# CLAUDE.md

The shared rules live in `agents/AGENTS.md`, linked to `~/.codex/AGENTS.md` so Claude Code and Codex read the same file.

## Machine-Local Instructions

Two files stay out of this repo and are imported below, after the shared rules. Codex cannot import, so they reach Claude only. An absent file resolves to nothing, and
Claude Code says nothing about it, so a missing import fails silently.

- `~/.claude/work.md`: anything tied to an employer or a client. Only exists on the machine that needs it.
- `~/.claude/private.md`: personal rules that do not belong in a public repo. Nothing syncs it, copy it by hand when setting up a new machine.

@~/.codex/AGENTS.md
@~/.claude/work.md
@~/.claude/private.md
