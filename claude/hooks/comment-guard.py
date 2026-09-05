#!/usr/bin/env python3
"""PostToolUse guard: warn when a NEW code comment carries incident/ticket/date/amount noise
or grows into an essay. Comments must describe the code and stand on their own; history and
long rationale belong in commit messages and docs/, never in source comments.

Reads the Edit/Write payload on stdin, scans only the text being written (Edit.new_string or
Write.content), and on a hit exits 2 with the findings on stderr so the model sees them and
self-corrects. Never blocks the edit (it already ran); it is a nudge, not a gate. Fails open."""

import json
import re
import sys

CODE_EXT = (".ts", ".tsx", ".js", ".jsx", ".mjs", ".cjs")

# Each: (label, compiled regex). Matched against COMMENT text only.
PATTERNS = [
    (
        "a date (history belongs in the commit message / docs)",
        re.compile(r"\b20\d\d-\d\d-\d\d\b"),
    ),
    (
        "a PR/ticket/issue number",
        re.compile(r"(?:#\d{3,}\b|\bPR\s*#?\d|\bissue\s*#?\d)", re.IGNORECASE),
    ),
    (
        "a slice/ticket/approach/incident reference",
        re.compile(
            r"\b(?:slice\s*\d|ticket|incident|observed live|approach\s+[A-D]\b)",
            re.IGNORECASE,
        ),
    ),
    ("a money amount", re.compile(r"(?:EUR|USD|GBP|€|\$)\s?\d")),
    (
        "an em/en dash (use a comma, colon, parentheses, or a separate sentence)",
        re.compile(r"[—–]"),
    ),
]

MAX_COMMENT_BLOCK_LINES = (
    10  # a longer run of comment lines belongs in docs/ with a pointer
)


def comment_text(line: str):
    """Return the comment portion of a line, or None if the line is not (or has no) comment.
    Handles // line comments, /* */ and * block-comment continuation lines. Skips :// (URLs)."""
    s = line.lstrip()
    if s.startswith("*") or s.startswith("/*") or s.startswith("*/"):
        return s.lstrip("*/ ")
    m = re.search(r"(^|[^:])//(.*)$", line)
    if m:
        return m.group(2)
    return None


def main():
    try:
        payload = json.load(sys.stdin)
    except Exception:
        return 0
    ti = payload.get("tool_input") or {}
    path = ti.get("file_path") or ""
    if not path.endswith(CODE_EXT):
        return 0
    text = ti.get("new_string")
    if text is None:
        text = ti.get("content")
    if not text:
        return 0

    findings = []
    run = 0  # consecutive comment-line counter for the essay check
    for i, line in enumerate(text.splitlines(), 1):
        c = comment_text(line)
        if c is None:
            run = 0
            continue
        run += 1
        if run == MAX_COMMENT_BLOCK_LINES + 1:
            findings.append(
                f"  L~{i}: comment block over {MAX_COMMENT_BLOCK_LINES} lines — move the body to docs/ and leave a short pointer"
            )
        for label, rx in PATTERNS:
            if rx.search(c):
                findings.append(f"  L{i}: {label} — {c.strip()[:80]}")
                break

    if findings:
        sys.stderr.write(
            "Comment guard: new comments in %s look non-self-standing.\n"
            "Code comments must describe the code and stand alone: no dates, ticket/PR/incident\n"
            "references, money amounts, or em/en dashes; long rationale goes in docs/ with a pointer.\n"
            "Fix these before finishing:\n%s\n" % (path, "\n".join(findings))
        )
        return 2
    return 0


if __name__ == "__main__":
    sys.exit(main())
