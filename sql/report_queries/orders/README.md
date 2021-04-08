# Orders Report

## Purpose

The purpose of this report is to provide details about each purchase order. It includes options to filter results by date ordered, subscription date range, order type, tags, and workflow status. The data are aggregated by purchase order line number, purchase order type, purchase order description, acquisition unit name, acquisition method, and material type (physical or electronic). Acquisition unit name, subscription dates, and tags are optional, so data will be available for these fields only if the institution has elected to enter it. For subscription dates, the &quot;subscription\_to&quot; date parameter is not the last day of the interval; it is the day after (half open interval). This ensures including all times up to midnight in the date range.

## Parameters

The parameters in the table below can be set in the WITH clause to filter the report output.

| parameter | description | options |
| --- | --- | --- |
| date\_ordered | date purchase order was opened | Set start\_date in YYYY-MM-DD format. Set YYYY-MM-DD as end\_date. |
| order\_type | type of purchase order, which can be &quot;one-time&quot; or &quot;ongoing&quot;; renewal date is only present if order type is &quot;ongoing&quot; | Set to &quot;order\_type&quot; to &quot;one-time&quot; or &quot;ongoing.&quot; Leave blank to return all values. |
| subscription\_to and subscription\_from dates | can be set to filter output by &quot;subscription to&quot; and &quot;subscription from&quot; date range for &quot;one-time&quot; order types only | Comment out NULL statement and set &quot;subscription\_to&quot; and subscription\_from&quot; date range in YYYY-MM-DD format. Leave set to default of NULL if subscription dates are not available in your institution&#39;s data. |
| workflow status | shows current workflow status of purchase orders selected, which can be pending, open, or closed | Set &quot;workflow\_status&quot; to &quot;pending,&quot; &quot;open,&quot; or &quot;closed. Leave blank to return all values. |
| tags | local custom fields set by the institution | Enter up to 3 &quot;tags&quot; or leave blank to return all values. Use &quot;%%&quot; as wildcards. |


## Sample Output

| po_line_number | purchase_order_description | po_order_type | purchase_order_acquisition_method | po_acquisition_unit_name | purchase_order_elec_material_type_name | purchase_order_phys_material_type_name |
|----------------|----------------------------|---------------|-----------------------------------|--------------------------|----------------------------------------|----------------------------------------|
| 10000-1        |                            | One-Time      | Purchase   At Vendor System       | main                     |                                        | book                                   |
| 10001-1        |                            | One-Time      | Purchase   At Vendor System       | annex                    |                                        | book                                   |
| 10002-1        |                            | One-Time      | Purchase   At Vendor System       | main                     | book                                   |                                        |
| 10003-1        |                            | One-Time      | Purchase   At Vendor System       | annex                    | book                                   |                                        |
| 101101-1       |                            | Ongoing       | Purchase                          | main                     |                                        | book                                   |
| 101113-1       |                            | Ongoing       | Purchase                          | main                     |                                        | text                                   |
| 101125-1       |                            | One-Time      | Purchase                          | main                     |                                        | text                                   |
| 52590-1        |                            | One-Time      | Purchase                          | annex                    | dvd                                    |                                        |
| 81-1           |                            | Ongoing       | Purchase                          | annex                    | sound   recording                      |                                        |

## Future Updates

The &quot;paymentDate&quot; field, which captures the date an invoice was paid, is currently in development. This element should be added to the query as soon as it becomes available.

