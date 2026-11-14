# .AI: local rules for coding tools

This folder holds the rules that every coding tool follows in this repository. There is one set of rules for all tools; nothing here is written for a particular brand. It is a separate git worktree on the orphan branch `ai-rules`; nothing here is part of the application branches (`main`, `dev`, work branches), and the main working tree ignores it through `.git/info/exclude`.

## Contents

| Path | Purpose |
| --- | --- |
| `RULES.md` | The rules: context, working style, commands, code map, mandatory rules, prohibitions, and a routing table to the topic files. Always loaded. |
| `rules/*.md` | Detail per topic, read only when the task matches the routing table in `RULES.md`. |
| `tools/claude-settings.json` | Permission rules (deny reading `.env`, deny commit/push, ask before installs). The only tool-specific file, because permissions cannot be expressed as plain text rules. |
| `scripts/sync.sh` | Copies the rules to where each tool looks for them and maintains `.git/info/exclude`. |

`sync.sh` writes the same `RULES.md` to every location tools read, so there is never a second version to maintain:

| Generated file | Read by |
| --- | --- |
| `AGENTS.md` | Codex, Copilot, and most other tools |
| `CLAUDE.md` (contains only `@AGENTS.md`) | Claude Code |
| `.github/copilot-instructions.md` | Copilot, when its `AGENTS.md` support is off |
| `.claude/settings.json` | Claude Code permissions |

## Setup after cloning

```bash
git clone <repo-url> virageawie-app
cd virageawie-app
git fetch origin ai-rules
git worktree add .AI ai-rules
bash .AI/scripts/sync.sh
git status --short   # AGENTS.md, CLAUDE.md, .claude/ and .github/copilot-instructions.md must not appear
```

## Using any coding tool safely

- Run it locally (CLI or IDE) from the repository root, with approval required for commands and file writes outside the workspace. Never use modes that skip approvals or the sandbox.
- One small task per session (one FR or one fix); name the module or files, and point it to the matching `rules/<file>.md`.
- Never let it read `.env` files or paste secrets into a chat.
- It may use git, but never `commit` or `push`; you review the diff, commit, and push. Ask before anything that discards work.
- Cloud agents that run on GitHub only see the pushed application branches, not `.AI/` or the generated files, so they do not know these rules. Do not use them for this project.
- On free or low-quota tiers, avoid "explain the whole repository" prompts and ask for diffs instead of whole files.

## Updating rules

1. Edit files in `.AI/` (keep `RULES.md` at 120 lines or less, each `rules/*.md` at 80 lines or less).
2. Run `bash .AI/scripts/sync.sh` so the generated copies are refreshed.
3. Commit and push inside `.AI/` (`git -C .AI ...`).
4. Other team members run `bash .AI/scripts/sync.sh --pull`.

## Handover

This folder and its generated copies are removed before the project is handed over: delete the generated files (`AGENTS.md`, `CLAUDE.md`, `.claude/`, `.codex/`, `.github/copilot-instructions.md`), remove the worktree, and delete the `ai-rules` branch locally and on the remote. The repository variable `LOCAL_ONLY_PATHS` in CI makes sure none of these files were ever committed to the application branches.
