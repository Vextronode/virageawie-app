# Testing

## Runner and layout
- Pest 4. Run from `src/`.
- `tests/Unit/Domain/<Module>/`: pure domain logic (Money, cost calculation). No HTTP.
- `tests/Feature/<Module>/`: Actions with the database, and HTTP tests for pages and forms. Uses `RefreshDatabase` (bound in `tests/Pest.php`).
- `tests/Arch/`: architecture rules. Do not weaken them.
- `tests/Fixtures/golden/`: hand-verified datasets. Read-only unless explicitly asked.
- Tests run on PostgreSQL (`virageawie_test` locally, a PostgreSQL 18 service in CI). Do not switch to SQLite.

## Naming
- Every test for an acceptance criterion includes the KP id: `it('KP-03.2 rejects cash out above balance', ...)`.
- One `describe()` per FR when a file covers several criteria: `describe('FR-03 cash out', ...)`.

## What to test for each FR
- Every acceptance criterion: at least one passing case and one rejection case.
- For cash and stock Actions additionally:
  - the transaction is atomic (a failure leaves no partial rows);
  - the audit log row exists with actor, action, and before/after values;
  - repeating the same idempotency key creates nothing new;
  - authorization: a user without permission gets 403.
- Money: assert with strings or `Money` equality, never floats (`toBe('1250000.00')`).

## Workflow
1. Write or update the test for the criterion first.
2. Run only that test: `vendor/bin/pest --filter='KP-03.2'`.
3. Make it pass with the smallest change.
4. When the task is done, run `composer test` once.

## Never
- Change an expected value, skip (`->skip()`, `markTestSkipped`), or delete a test to make it pass. If an expectation looks wrong, stop and ask.
- Mock the database or the Action under test.
- Depend on test order or on the current time without `Carbon::setTestNow()` / `$this->travelTo()` (timezone Asia/Jakarta).

## Factories
- Factories use faker locale `id_ID`.
- Money fields in factories use string amounts with two decimals.
