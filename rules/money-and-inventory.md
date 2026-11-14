# Money and inventory

## Money
- Storage: PostgreSQL `NUMERIC(18,2)` for amounts; `NUMERIC(18,4)` for moving average cost per unit.
- In PHP, money is always the `Money` value object in `app/Domain/Shared/` (backed by `bcmath` strings). Never `float`, never `round()`, never `number_format()` for calculation.
- Eloquent casts return `Money` (custom cast); raw strings only at the persistence boundary.
- Rounding happens only inside `Money` methods, with an explicit mode. Default: half up to the nearest Rupiah where a whole Rupiah is required.
- Formatting for display (`Rp 1.250.000`) happens on the server or in one shared formatter; React never does arithmetic on amounts.
- Currency is always IDR. No multi-currency.

## Moving average cost
- On every stock-in (purchase, opening balance, positive adjustment, customer return):
  `new_avg = (old_qty * old_avg + in_qty * in_unit_cost) / (old_qty + in_qty)`, kept at 4 decimals.
- Stock-out (sale, negative adjustment, return to supplier) does not change the average; it consumes at the current average.
- When quantity reaches zero, keep the last average for reference; the next stock-in restarts from it as described above.

## HPP (cost_of_goods_sold)
- `HPP = out_qty * average_cost`, rounded to the nearest Rupiah (half up) at the moment of the sale line, then stored.
- Store HPP per sale line; reports sum stored values, they do not recompute.

## Stock rules
- No negative stock. The Action locks the item stock row (`lockForUpdate`) and rejects an out movement larger than the available quantity with an Indonesian message.
- Every movement is a row in the stock ledger with: item, date, direction, quantity, unit cost, resulting quantity, resulting average, source document, reference number.
- Quantities use `NUMERIC` with the precision defined per item unit; never float.

## Back-dated and reversed transactions
- A movement dated before later movements, or a reversal of an older movement, triggers a recalculation chain:
  1. Lock the item's ledger rows from the affected date onward, in date then id order.
  2. Replay movements from the last row before the affected date, recomputing resulting quantity, average cost, and HPP for each later row.
  3. If any replayed row would make stock negative, abort the whole transaction.
  4. Write changed HPP values and an audit log entry for each corrected document, in the same transaction.
- No recalculation across a locked period: back-dating into a locked period is rejected.

## Golden dataset tests
- `tests/Fixtures/golden/` holds hand-verified scenarios (inputs and expected ledger, averages, HPP, balances).
- Every change to money or stock logic must keep all golden tests green.
- Golden fixtures are changed only on explicit request, with the reason in the PR.
- Add a new golden scenario for each new rule (back-dating, reversal, zero stock, rounding edge such as x.5 Rupiah).
