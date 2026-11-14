# Architecture

## Layers
Request flow: Route -> Controller -> FormRequest (validate) -> Policy (authorize) -> Action -> Inertia response.

| Layer | Location | Does | Does not |
| --- | --- | --- | --- |
| Controller | `app/Http/Controllers/<Module>/` | validate via FormRequest, `$this->authorize()` / Gate, call one Action, return `Inertia::render()` or redirect | query the DB, compute values, use `DB` facade |
| FormRequest | `app/Http/Requests/<Module>/` | input rules, Indonesian messages, `toData()` returning a Data object | business rules that need other records |
| Policy | `app/Policies/` | who may do what | business validation |
| Action | `app/Domain/<Module>/Actions/` | one use case, one public `handle()` method, owns the transaction | use `Illuminate\Http`, read `request()` |
| Service | `app/Domain/<Module>/Services/` | reusable domain logic used by several Actions (cost calculation, numbering) | talk to HTTP or the session |
| Data | `app/Domain/<Module>/Data/` | immutable typed input/output objects (`readonly` classes) | contain behaviour beyond simple derivation |
| Enums | `app/Domain/<Module>/Enums/` | backed enums for statuses and types | |
| Exceptions | `app/Domain/<Module>/Exceptions/` | domain errors with Indonesian user messages | |
| Model | `app/Models/` | relations, casts, scopes | business rules, side effects in events |

`App\Domain` must not use `Illuminate\Http`; controllers must not use the `DB` facade. Both are enforced by `tests/Arch/ArchitectureTest.php`.

## Naming
- Actions are verbs: `RecordCashIn`, `PostPurchase`, `ReverseTransaction`, `LockPeriod`.
- Data objects end in `Data`: `CashInData`, `PurchaseLineData`.
- Names follow `docs/glossary.md`; do not invent synonyms.
- Shared building blocks (Money, Quantity, ReferenceNumber, idempotency) live in `app/Domain/Shared/`.

## Action skeleton
```php
final class RecordCashIn
{
    public function __construct(private AuditLogger $audit) {}

    public function handle(CashInData $data, User $actor): CashTransaction
    {
        return DB::transaction(function () use ($data, $actor) {
            // 1. idempotency check
            // 2. lock affected rows (lockForUpdate)
            // 3. domain checks (period open, balance, stock)
            // 4. write records
            // 5. audit log
        });
    }
}
```

## Cross-module calls
- A module may call another module's Actions or Services, never its models' internals directly for writes.
- Reporting reads only; it never writes.
- Audit is written by the Action that makes the change, inside the same transaction.

## Errors
- Throw a domain exception; the controller or exception handler turns it into a validation error or flash message in Indonesian.
- Never swallow exceptions inside an Action.

## Queues
- Queue connection is `database`. Jobs must be idempotent and must not change cash or stock outside an Action.
