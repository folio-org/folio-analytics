# ERM Agreements Cost Report

## Purpose

This report is to provide a dataset of invoice lines to summarize costs by agreements. Filters were designed to customize this queries on local needs.

## Parameters

The parameters in the table below can be set in the WITH clause to filter the report output.

| parameter | description | examples |
| --- | --- | --- |
| agreement_status | date invoice was approved | 'Active', 'Closed' etc. |
| resource_type | type of resource | 'monograph', 'serial' etc. |
| resource_sub_type | subtype of resource | 'electronic', 'print' etc. |
| resource_publication_type | publication type of resource | 'journal', 'book'  etc. |
| po_line_order_format | given order format | 'Electronic Resource', 'Physical Resource', 'P/E Mix' etc. |
| invoice_line_status | status of invoice | 'Paid' or 'Approved' etc. |
| invoice_payment_date | date invoice was paid | Set start\_date and end\_date in YYYY-MM-DD format. |

## Sample Output

|subscription_agreement_name|subscription_agreement_status|entitlement_id|entitlement_active_from|entitlement_active_to|erm_resource_name|erm_resource_type|erm_resource_sub_type|erm_resource_publication_type|po_line_payment_status|po_line_is_package|po_line_order_format|invl_status|invoice_payment_date|invl_sub_total|invl_total|transactions_invl_total|
|----------|----------|----------|----------|----------|----------|----------|----------|----------|----------|----------|----------|----------|----------|----------|----------|----------|
|Agreement_Test_PCI |Active|934cd3cd-2a0f-476e-a740-51796bb1a480|||De Gruyter : Journal Package Mathematics, Physics, Engineering : 2019-07-08||||Fully Paid|true|Electronic Resource|Open||6300|6300||
|Agreement_Test_Package 2|Active|934cd3cd-2a0f-476e-a740-51796bb1a480|||BMJ Publishing Group : BMJ Journals Online Archive : NL||||Fully Paid|true|Electronic Resource|Paid||9000|9000|$9,000.00|
