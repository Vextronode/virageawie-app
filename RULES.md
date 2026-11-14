# VIRAGEAWIE: rules for coding tools

## Context
VIRAGEAWIE is a cash and inventory recording PWA for a small business, built with Laravel 13, Inertia, React, TypeScript, Tailwind CSS, and PostgreSQL 18.
Money and stock values must be exact and auditable: transactions are append-only, corrections are reversals, and every change is logged.
Code identifiers are English, UI text is Indonesian, timezone is Asia/Jakarta, currency is Rupiah.

## Working style
These favour caution over speed; for trivial tasks, use judgement.
1. Think before coding.
   - State your assumptions. If a request can be read in more than one way, list the readings and ask; do not pick one silently.
   - If something is unclear, stop and name what is unclear.
   - If a simpler approach exists, say so and push back when warranted.
2. Simplicity first.
   - Write the minimum code that solves the request.
   - No speculative features, single-use abstractions, unrequested configurability, or handling for impossible cases.
   - If a senior engineer would call it overcomplicated, simplify (200 lines that could be 50 get rewritten).
3. Surgical changes.
   - Every changed line traces to the request. Do not reformat, refactor, or "improve" neighbouring code; match the existing style.
   - Remove only imports, variables, and functions that your change made unused. Mention unrelated dead code; do not delete it.
4. Goal-driven execution.
   - Turn the task into checks before coding: bug -> failing test first; validation -> tests for invalid input; refactor -> tests pass before and after.
   - For multi-step work, state a short plan with one check per step (`1. step -> verify: check`) and loop until every check passes.

## Commands (run from `src/`)
- Setup: `cp .env.example .env && composer install && npm ci && php artisan key:generate && php artisan migrate`
  (services: `docker compose -f infra/compose.local.yaml up -d` from the repo root)
- Run: `composer dev`
- Test: targeted first, `vendor/bin/pest --filter=<name>`; the full suite (`composer test`) once at the end.
- Lint: `composer lint` (Pint), `npm run lint` (Oxlint via Vite+), `npm run format:check` (Oxfmt via Vite+), `npm run types` (tsc)
- Analyse: `composer analyse` (Larastan level 6)

## Code map
| What | Where |
| --- | --- |
| Laravel app | `src/` |
| Business logic | `src/app/Domain/<Module>/{Actions,Services,Data,Enums,Exceptions}` |
| Modules | Access, MasterData, OpeningBalance, Cash, Purchasing, Sales, Settlement, Inventory, Period, Reversal, Audit, Reporting, Production, Shared |
| Eloquent models | `src/app/Models` |
| Controllers | `src/app/Http/Controllers`: FormRequest validates, Policy authorizes, call one Action, return Inertia |
| Pages / components | `src/resources/js/pages`, `components`, `layouts` (keep existing lowercase folders) |
| Tests | `src/tests/{Unit/Domain,Feature,Arch,Fixtures/golden}` (Pest) |
| Infra / CI / docs | `infra/`, `.github/`, `docs/` (glossary: `docs/glossary.md`) |

## Mandatory rules
1. Business logic only in `app/Domain/<Module>/Actions` or `Services`; thin controllers.
2. React components never compute business values such as balances or cost; they display server results.
3. Money is NUMERIC and handled through one Money value object; no float, no rounding outside it.
4. Every Action that changes cash or stock runs in one DB transaction, locks the affected rows, writes the audit log in the same transaction, and checks the idempotency key.
5. Transactions are never updated or deleted; corrections go through a reversal.
6. Each FR comes with tests for every acceptance criterion; test names include the KP id.
7. English identifiers per `docs/glossary.md`; Indonesian UI text.
8. UI uses shared components; custom CSS only in `app.css`.
9. One PR per FR or per fix.

## Prohibitions
1. Changing expectations, skipping, or deleting tests to make them pass.
2. Editing a migration that already exists on `dev`.
3. Adding Composer or npm dependencies without saying so.
4. Reading or writing `.env` files or secrets; hard-coding credentials.
5. Changing `.github/workflows/`, `infra/`, or `tests/Fixtures/golden/` unless explicitly asked.
6. Running `git commit` or `git push` in any form; humans commit and push manually. Other git commands (`checkout`, `switch`, `branch`, `add`, `fetch`, `pull`, `stash`) are allowed.
7. Running git commands that discard work (`reset --hard`, `clean`, `restore` or `checkout --` on changed files, `branch -D`, `worktree remove`) without asking.
8. Deploying or using SSH.
9. Disabling lint or static analysis rules without a written reason in code.

## Sensitive zones: stop and ask before changing
- `src/app/Domain/Inventory/`, `src/app/Domain/Cash/`
- `src/database/migrations/`
- `src/app/Policies/`, `src/app/Http/Middleware/`, `src/config/auth.php`
- `infra/`, `.github/workflows/`
- `src/tests/Fixtures/golden/`

## Routing: read only the one rule file that matches the task
| If the task touches | Read first |
| --- | --- |
| Domain modules, Actions, Services, controllers, policies | `.AI/rules/architecture.md` |
| Money, prices, cost, HPP, stock quantities, valuation | `.AI/rules/money-and-inventory.md` |
| Writing or fixing tests | `.AI/rules/testing.md` |
| Inertia pages, React components, Tailwind, forms | `.AI/rules/frontend.md` |
| Migrations, schema, indexes, seeders | `.AI/rules/database.md` |
| Branches, commit messages, PR description | `.AI/rules/git-and-pr.md` |

Do not read the other rule files unless the task clearly needs them.

## Quota hygiene
- Ask for small, single-FR tasks; split anything larger before starting.
- Do not read `vendor/`, `node_modules/`, `public/build/`, or lock files.
- Read only the files you need; search before opening large files.
- Do not paste whole files back; show only changed parts.
- Run targeted tests while working; the full suite once at the end.
- Finish with a short list: files changed, tests run and their result, open questions.
