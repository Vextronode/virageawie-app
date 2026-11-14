# Database

## Engine
- PostgreSQL 18 everywhere (local, CI, staging, production). Do not write MySQL- or SQLite-only SQL.
- Timezone Asia/Jakarta in the app; store timestamps as `timestampTz`.

## Migrations
- Every schema change is a new migration (`php artisan make:migration`). Never edit a migration that already exists on `dev`.
- Migrations must be backward compatible with the currently deployed code (expand, then contract):
  1. add new nullable columns or new tables;
  2. deploy code that writes both or reads the new shape;
  3. backfill in a separate migration or command;
  4. only then drop or tighten old columns in a later PR.
- No destructive changes (drop column/table, rename) in the same PR that introduces the replacement.
- Every migration has a working `down()` unless it is data-destructive by nature; then say so in the PR.
- CI runs `php artisan migrate --force` on an empty database for PRs to `main`.
- Never run `migrate:fresh` or `db:wipe` outside a disposable local or test database.

## Types and precision
| Value | Type |
| --- | --- |
| Money amount | `$table->decimal('amount', 18, 2)` (NUMERIC) |
| Moving average cost per unit | `$table->decimal('average_cost', 18, 4)` |
| Quantity | `$table->decimal('quantity', 18, 3)` unless the FR says otherwise |
| Status / type | `string` column + PHP backed enum (no DB enum type) |
| Reference number | `string`, unique index |
| Idempotency key | `uuid`, unique per actor or per table |

- Never use `float`, `double`, or `real` columns.
- Add `CHECK` constraints for invariants where cheap (for example `quantity >= 0` on stock balances).

## Append-only transactions
- Transaction tables (cash, purchase, sale, settlement, stock ledger, audit log) have no update or delete paths in the app. Corrections are reversal rows that reference the original.
- Use foreign keys with `restrictOnDelete()` for transaction references.

## Locking and performance
- Row locks via `lockForUpdate()` inside the Action's transaction; always lock in a stable order (by id) to avoid deadlocks.
- Index every foreign key and the columns used for period and date filtering.

## Seeders
- Seeders are for local and test data only; use faker locale `id_ID`. Production data comes from the opening balance feature, not seeders.
