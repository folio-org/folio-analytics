# ERM Costs Reports

## Purpose

This report is to provide a dataset of invoice lines to summarize certain costs on the predefined filter for electronic resorces in the inventory. Filters were designed to customize this queries on local needs. Furthermore costs on invoice line level are exemplary divided by instance subjects and formats. Take in account that this might duplicate invoice lines and needed to be adjusted if summing up totals. 

The costs relies on the amounts out of the transactions table in system currency. This data will only appear if an invoice status is 'Approved' or 'Paid'. 
The preset on the invoice status filter therefore is 'Paid'.

## Parameters

The parameters in the table below can be set in the WITH clause to filter the report output.

| parameter | description | examples |
| --- | --- | --- |
| invoice\_approval\_date | date invoice was approved | Set start\_date and end\_date in YYYY-MM-DD format. |
| invoice_line_status | status of the invoices to show, which can be open, reviewed, approved, paid, or cancelled | 'Paid', 'Approved', 'Open' etc. |
| po_line_order_format | the purchase order line format| 'Electronic Resource', 'Physical Resource', 'P/E Mix' etc. |
| instance_subject | name of the instance subject | |
| mode_of_issuance_name | mode of issuance, a categorization reflecting whether a resource is issued in one or more parts, the way it is updated, and whether its termination is predetermined or not | 'serial', 'integrating resource', 'single unit' etc. |
| format_name | instance format whether it's from the RDA carrier term list of locally defined | 'computer -- online resource'  for electronic resources |
| library_name | library name of the permanent location | |

## Sample Output

|po_line_id|invl_id|invl_status|po_line_payment_status|po_line_is_package|invoice_payment_date|po_line_order_format|po_line_phys_mat_type|po_line_er_mat_type|instance_mode_of_issuance_name|invl_adjustment_description|invl_adjustment_prorate|invl_adjustment_relationtototal|invl_adjustment_value|invl_sub_total|invl_total|inv_adj_prorate|inv_adj_relationtototal|transactions_inv_adj_total|transactions_invl_total|invl_total_incl_adj|instance_format_name|total_by_format|instance_subject|total_by_subject|
|----------|-------|-----------|----------------------|------------------|---------------------|--------------------|---------------------|-------------------|-------------------|------------------------------|---------------------------|-----------------------|-------------------------------|---------------------|--------------|----------|---------------|-----------------------|-------------|----------|--------------------|---------------|----------------|----------------|
|2f3a877a-5a2d-4a8d-a226-d7691d43f4f5|a89bae81-889d-429d-853a-e0cff4780f66|Paid|Pending|false|2021-01-14 13:45:04|Electronic Resource| | | |Fees|Not prorated|In addition to|5|15|20|Not prorated|In addition to|$1.75|$15.76|$17.51| | |Medicine|$17.51|
|e0f063e8-36c2-4cc8-9086-cdaf1c05d161|c5426cea-e6b9-430a-af8d-0612e21f1565|Paid|Pending|false|2021-01-12 11:42:24|Electronic Resource| | | | | | | |15|15| | | |$15.00|$15.00| | | |

