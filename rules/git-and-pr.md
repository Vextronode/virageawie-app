# Git and pull requests

## Hard rule
- Never run `git commit` or `git push` in any form (also not via `git -C <dir>`). Humans commit and push manually.
- Allowed: `status`, `diff`, `log`, `fetch`, `pull`, `checkout`, `switch`, `branch`, `add`, `stash`, `worktree add`.
- Ask first before anything that discards work: `reset --hard`, `clean`, `restore` / `checkout --` on changed files, `branch -D`, `worktree remove`, `stash drop`.

## Branches
- `main` <- `dev` <- work branches.
- Work branches start from an up-to-date `dev`: `feat/*`, `fix/*`, `refactor/*`, `chore/*`, `docs/*`.
- `hotfix/*` starts from `main` and is merged back to both `main` and `dev`.
- Name: `<type>/<short-kebab-description>`, optionally with the FR id: `feat/fr-03-cash-out`.
- PRs are merged with a merge commit only (squash and rebase are disabled), so every commit on a work branch ends up in `dev`.
- Bring a work branch up to date by merging `dev` into it; never rebase a branch that is already pushed.

## Commit messages (Conventional Commits)
- Every commit (not only the PR title) uses the format `<type>(<optional scope>)<optional !>: <description>`, because commits are kept as-is in `dev`.
- One logical change per commit; no "wip" or "fix typo" commits left in a PR. When proposing commits, group the changes accordingly.
- Types: `feat`, `fix`, `refactor`, `chore`, `docs`, `test`, `ci`, `build`, `perf`.
- Scope is the module in lowercase: `cash`, `inventory`, `purchasing`, ...
- Examples:
  - `feat(cash): record cash out with balance check`
  - `fix(inventory): round HPP to the nearest rupiah`
  - `refactor(sales)!: split sale posting into two actions`
- When asked to propose a commit message, output it as text only; do not run the commit.

## Pull requests
- One PR per FR or per fix. Keep it under about 400 changed lines (lock files excluded); CI warns above that.
- PR title uses the same Conventional Commits format (checked by CI).
- Fill in `.github/pull_request_template.md`:
  - summary and related FR or issue;
  - type of change;
  - sensitive zones touched;
  - new dependencies (or "None");
  - test changes explained, with KP ids covered;
  - the checkbox "I have read and understand every line in this PR" is for the human author.
- Before handing over, run: `composer test`, `composer lint`, `composer analyse`, `npm run lint`, `npm run format:check`, `npm run types`, `npm run build`, and report the results.

## Staging
- You may `git add` files when asked, grouped per logical change. Otherwise leave staging to the human.
- Never stage `.env` files, `.AI/`, `AGENTS.md`, `CLAUDE.md`, `.claude/`, `.codex/`, or `.github/copilot-instructions.md`.
