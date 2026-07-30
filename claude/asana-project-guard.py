#!/usr/bin/env python3
"""PreToolUse guard that keeps Asana MCP writes inside known projects.

Asana MCP apps have no scopes, so the OAuth token carries every permission the
authorizing user has. This hook narrows that down locally: read tools pass,
write tools only pass when every project reference in the payload is on the
allowed list. A write with no resolvable project reference (most tools take a
task gid, not a project gid) falls back to a permission prompt instead of being
allowed silently.
"""

import json
import os
import re
import sys
from pathlib import Path

# The gids live outside this repo: ASANA_ALLOWED_PROJECTS as a comma-separated
# list, or ~/.claude/asana-allowed-projects with one gid per line (blank lines
# and # comments ignored). Without either, every write is denied.
CONFIG = Path.home() / ".claude" / "asana-allowed-projects"


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


def project_refs(node, key="", found=None):
    """Collect gid-shaped values sitting under a project-ish key."""
    if found is None:
        found = set()
    if isinstance(node, dict):
        for k, v in node.items():
            project_refs(v, k, found)
    elif isinstance(node, list):
        for item in node:
            project_refs(item, key, found)
    elif isinstance(node, str) and "project" in key.lower() and GID.match(node):
        found.add(node)
    return found


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
    refs = project_refs(payload.get("tool_input") or {})
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
