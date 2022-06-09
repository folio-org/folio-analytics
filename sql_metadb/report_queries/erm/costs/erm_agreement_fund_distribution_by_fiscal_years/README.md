# ERM Agreement fund distribution by fiscal years

## Purpose

The report shows the fund distribution by fiscal years. Amounts are calculated from invoice lines in system currency and are paid. At the same time, the invoice lines must be connected to an agreement line.

## Parameters

The parameters in the table below can be set in the WITH clause to filter the report output.

| parameter | description | examples |
| --- | --- | --- |
| start_date | Date to specify the start of interval for the fiscal years | Set start_date in YYYY-MM-DD format. |
| end_date | Date to specify the end of interval for the fiscal years  | Set end_date in YYYY-MM-DD format. |

## Sample Output

|fy_id|fy_start|fy_end|fy_code|fund_code|amount_paid
|----------|----------|----------|----------|----------|----------|
| 684b5dc5-92f6-4db7-b996-b549d88f5e4e | 2020-01-01 01:00:00.000 +0100 | 2021-01-01 00:59:59.000 +0100 | FY2020 | ASIAHIST | 11.115 |
