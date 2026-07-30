#!/usr/bin/env python3
"""PreToolUse guard that keeps Asana MCP writes inside known projects.

Asana MCP apps have no scopes, so the OAuth token carries every permission the
authorizing user has. This hook narrows that down locally: read tools pass,
write tools only pass when every project reference in the payload is on the
allowed list. Most write tools take a task gid, not a project gid, so the guard
asks Asana which projects those tasks live in and checks those too. Anything it
cannot resolve falls back to a permission prompt instead of being allowed
silently.
"""

import json
import os
import re
import sys
import urllib.error
import urllib.request
from pathlib import Path

# The gids live outside this repo: ASANA_ALLOWED_PROJECTS as a comma-separated
# list, or ~/.claude/asana-allowed-projects with one gid per line (blank lines
# and # comments ignored). Without either, every write is denied.
CONFIG = Path.home() / ".claude" / "asana-allowed-projects"

# Personal access token for the task -> project lookup: ASANA_TOKEN, or the
# first non-comment line of ~/.claude/asana-token. Without it the guard falls
# back to asking on every task-level write.
TOKEN_FILE = Path.home() / ".claude" / "asana-token"


def allowed_projects():
    raw = os.environ.get("ASANA_ALLOWED_PROJECTS", "")
    if not raw.strip() and CONFIG.is_file():
        raw = CONFIG.read_text()
    gids = set()
    for line in raw.replace(",", "\n").splitlines():
        gid = line.split("#", 1)[0].strip()
        if gid:
            gids.add(gid)
    return gids


ALLOWED = allowed_projects()


def token():
    raw = os.environ.get("ASANA_TOKEN", "")
    if not raw.strip() and TOKEN_FILE.is_file():
        raw = TOKEN_FILE.read_text()
    for line in raw.splitlines():
        value = line.split("#", 1)[0].strip()
        if value:
            return value
    return ""


TOKEN = token()

# Tool name fragments that only read. Everything else counts as a write.
READ_ONLY = re.compile(
    r"(^|_)(get|list|search|find|read|typeahead|about|export|download)(_|$)",
    re.IGNORECASE,
)

GID = re.compile(r"^\d{9,}$")


def emit(decision, reason):
    json.dump(
        {
            "hookSpecificOutput": {
                "hookEventName": "PreToolUse",
                "permissionDecision": decision,
                "permissionDecisionReason": reason,
            }
        },
        sys.stdout,
    )
    sys.exit(0)


# Keys that only wrap a value and say nothing about what it is, so the enclosing
# key stays in force: {"dependencies": {"add": ["123"]}} is still a task ref.
WRAPPER_KEYS = {"add", "remove", "data", "gid", "value"}

# Task-shaped keys. "parent" and the dependency edges also write to the other
# task, so they get resolved too.
TASK_KEYS = {"parent", "dependencies", "dependents"}


def gid_refs(node, key="", found=None):
    """Collect gid-shaped values, bucketed by the kind of key they sit under."""
    if found is None:
        found = {"project": set(), "task": set()}
    if isinstance(node, dict):
        for k, v in node.items():
            gid_refs(v, key if k.lower() in WRAPPER_KEYS else k, found)
    elif isinstance(node, list):
        for item in node:
            gid_refs(item, key, found)
    elif isinstance(node, str) and GID.match(node):
        key = key.lower()
        if "project" in key:
            found["project"].add(node)
        elif "task" in key or key in TASK_KEYS:
            found["task"].add(node)
    return found


def fetch_task(gid):
    request = urllib.request.Request(
        f"https://app.asana.com/api/1.0/tasks/{gid}?opt_fields=projects.gid,parent.gid",
        headers={"Authorization": f"Bearer {TOKEN}"},
    )
    with urllib.request.urlopen(request, timeout=10) as response:
        return json.load(response)["data"]


def task_projects(gid):
    """Projects a task belongs to, walking up to the parent for subtasks."""
    seen = set()
    while gid and gid not in seen:
        seen.add(gid)
        task = fetch_task(gid)
        projects = {p["gid"] for p in task.get("projects") or []}
        if projects:
            return projects
        gid = (task.get("parent") or {}).get("gid")
    return set()


def main():
    payload = json.load(sys.stdin)
    tool = payload.get("tool_name", "")
    if not tool.startswith("mcp__asana__"):
        return

    short = tool[len("mcp__asana__") :]
    if READ_ONLY.search(short):
        emit("allow", "Asana read tool")

    if not ALLOWED:
        emit(
            "deny",
            "No allowed Asana projects configured. Set ASANA_ALLOWED_PROJECTS or "
            f"list the gids in {CONFIG}.",
        )

    allowed = ", ".join(sorted(ALLOWED))
    found = gid_refs(payload.get("tool_input") or {})
    refs = set(found["project"])

    if found["task"] and not TOKEN:
        emit(
            "ask",
            f"{short} names task(s) but no project, and no Asana token is "
            f"configured to look them up. Set ASANA_TOKEN or write a personal "
            f"access token to {TOKEN_FILE}.",
        )
    for gid in sorted(found["task"]):
        try:
            projects = task_projects(gid)
        except (urllib.error.URLError, OSError, KeyError, ValueError) as err:
            emit("ask", f"{short}: task {gid} lookup failed ({err}).")
        if not projects:
            emit("ask", f"{short}: task {gid} belongs to no project the guard can see.")
        refs |= projects

    if not refs:
        emit(
            "ask",
            f"{short} writes to Asana but names no project. The guard cannot tell "
            f"whether this stays inside {allowed}.",
        )
    stray = sorted(refs - ALLOWED)
    if stray:
        emit(
            "deny",
            f"{short} targets project(s) {', '.join(stray)}. Allowed: {allowed}.",
        )
    emit("allow", f"Write stays inside {', '.join(sorted(refs))}")


if __name__ == "__main__":
    try:
        main()
    except Exception as err:  # never fail open on a malformed payload
        emit("ask", f"asana-project-guard failed: {err}")
