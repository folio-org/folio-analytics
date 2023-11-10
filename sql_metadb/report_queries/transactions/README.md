# Transaction Report

## Purpose

The report offers the possibility to filter within the transactions according to certain parameters. Therefore the report contains several attributes from the FOLIO finance app.

## Parameters

The parameters in the table below can be set in the WITH clause to filter the report output.

| parameter | description | examples |
| --- | --- | --- |
| start\_date\_transaction\_created | date transaction was created | Start date for a interval. Set start\_date in YYYY-MM-DD format |
| end\_date\_transaction\_created | date transaction was created | End date for a interval. Set end\_ date in YYYY-MM-DD format |
| start\_date\_transaction_updated | date transaction was updated | Start date for a interval. Set start\_date in YYYY-MM-DD format |
| end\_date\_transaction_updated | date transaction was updated | End date for a interval. Set end\_date in YYYY-MM-DD format |
| start\_date\_fiscal\_year\_start | date fiscal year started | Start date for a interval. Set start\_date in YYYY-MM-DD format |
| end\_date\_fiscal\_year\_start | date fiscal year started | End date for a interval. Set end\_date in YYYY-MM-DD format |
| start\_date\_fiscal\_year\_end | date fiscal year ended | Start date for a interval. Set start\_date in YYYY-MM-DD format |
| end\_date\_fiscal\_year\_end | date fiscal year ended | End date for a interval. Set end\_date in YYYY-MM-DD format |
| expense\_class\_code | The code of the expense class | Enter your expense class code |
| expense\_class\_name | The name of the expense class | Enter your expense class name |
| encumbrance\_order\_status | Taken from the purchase order | Enter the status of the order, e.g. Open, Pending, Closed |
| encumbrance\_order\_type | Taken from the purchase order | Enter the order type, e.g. One-Time, Ongoing |
| encumbrance\_re\_encumber | Taken from the purchase Order,for fiscal year rollover | Set true or false |
| encumbrance\_status | The status of this encumbrance | Enter the status of the encumbrance, e.g. Released, Unreleased, Pending |
| encumbrance\_subscription | Taken from the purchase Order,for fiscal year rollover | Set true or false |
| budget\_name | The name of the budget | Enter your budget name |
| budget\_status | The status of the budget | Enter your budget status |
| fund\_code | A unique code associated with the fund | Enter your fund code |
| fund\_name | The name of this fund | Enter your fund name |
| fund\_status | The current status of this fund | Enter your fund status |
| ledger\_code | The code for the ledger | Enter your ledger code |
| ledger\_name | The name of the ledger | Enter your ledger name |
| ledger\_status | The status of the ledger | Enter your ledger status |
| fiscal\_year\_code | The code of the fiscal year | Enter your fiscal year code |
| fiscal\_year\_name | The name of the fiscal year | Enter your fiscal year name |
| transaction\_source | The readable identifier of the record that resulted in the creation of this transaction | Enter the source of the transaction, e.g. User, PoLine, Invoice |
| transaction\_type | This describes the type of transaction | Enter the type of the transaction, e.g. Credit, Encumbrance, Payment, Pending payment



## Sample Output

transaction_id | transaction_created_date | transaction_updated_date | source | transaction_type | expense_class_code | expense_class_name | currency | amount | encumbrance__amount_awaiting_payment | encumbrance__amount_expended | encumbrance__initial_amount_encumbered | encumbrance__order_status | encumbrance__order_type | encumbrance__re_encumber | encumbrance__status | encumbrance__subscription | fiscal_year_code | fiscal_year_name | fiscal_year_period_start | fiscal_year_period_end | budget_name | budget_status | fund_code | fund_name | fund_status | fund_type_name | ledger_code | ledger_name | ledger_status
|----------|----------|----------|----------|----------|----------|----------|----------|----------|----------|----------|----------|----------|----------|----------|----------|----------|----------|----------|----------|----------|----------|----------|----------|----------|----------|----------|----------|----------|----------|
7af24e7a-ab66-4df5-84c9-28110df26c6e | 2023-05-17 10:02:11.785 +0200 | 2023-05-17 11:16:48.449 +0200 | PoLine | Encumbrance | | | USD | 20 | 0 | 0 | 20 | Open | One-Time | \[v\] | Unreleased | \[ \] | FY2023 | Fiscal Year 2023 | 2023-01-01 01:00:00.000 +0100 | 2024-01-01 00:59:59.000 +0100 | MFund-FY2023 | Active | MFund | MFund | Active |  | MLedger | MLedger | Active |
546add06-23a6-4e08-90fa-67d50a96b365 | 2023-05-10 08:11:47.971 +0200 | 2023-05-10 08:11:47.971 +0200 | Invoice | Pending payment | Prn | Print | USD | 55,07 | | | | | | \[ \] | | \[ \] | FY2023 | Fiscal Year 2023 | 2023-01-01 01:00:00.000 +0100 | 2023-12-31 01:00:00.000 +0100 | med_textbook-FY2023 | Active | med_textbook | Medicin_textbooks | Active | | MAIN-LIB | Main Library | Active |
12e5f6bd-8120-4e05-841f-8a31fff1868e | 2023-05-10 08:11:47.913 +0200 | 2023-05-10 08:11:47.913 +0200 | Invoice | Pending payment | Elec | Electronic | USD | 55,07 | | | | | | \[ \] | | \[ \] | FY2023 | Fiscal Year 2023 | 2023-01-01 01:00:00.000 +0100 | 2023-12-31 01:00:00.000 +0100 | med_textbook-FY2023 | Active | med_textbook | Medicin_textbooks | Active | | MAIN-LIB | Main Library | Active |

### Note on expense classes
If the same fund is selected in a fund distribution (e.g. po lines or invoice lines), but with different expense classes, then each of these distribtions gets its own transaction in FOLIO.
