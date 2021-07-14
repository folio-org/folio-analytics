# ERM Order Status Report

## Purpose

This query covers reports on the status of purchase orders. Check for currently open orders, as well as Pending "Not Yet Published" titles and were updated in the last 30 days.

## Parameters

The parameters in the table below can be set in the WITH clause to filter the report output.

| parameter | description | examples |
| --- | --- | --- |
| days_from_current_date | filter updated orders from given days to current day | Set days_from_current_date as an integer |

## Sample Output
| po_id | po_number | po_created_date | vendor_code | po_status | po_approved | po_order_type | po_line_number | pol_instance_id | title | ISBNs | authors | discovery_suppress | pub_publisher | pol_receipt_status | pol_requester | no_physical | no_electronical | pol_estimated_price | approved_by_id | invoice_id | field | series |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
2df96080-4b68-447e-8991-9d3055ecd223|10034|2021-02-10|HARRA|Open|false|Ongoing|10034-1|0393577e-7657-4a7b-8a52-d805dbf699e4|Meteorology and atmospheric physics.| | |false|Springer-Verlag|Partially Received| |1| |200.0|7a16958e-af23-5002-8191-d7a96f5f8070|9263c096-c3b4-4672-a805-b8bf28e2603a|890|$aMeteorology and atmospheric physics.$i97-646656$aMeteorology and atmospheric physics.
9d07ac5f-6197-48e2-bc30-5c54cc81fbfc|10040|2021-02-12|HARRA|Open|false|Ongoing|10040-1|92a760cf-bbd1-4315-b131-b097bf812127|Aerobiologia.| |Italian Association of Aerobiology, Consiglio nazionale delle ricerche (Italy)|false|Pitagora Editrice|Partially Received| |1| |200.0|7a16958e-af23-5002-8191-d7a96f5f8070|fe2a9fb0-bda3-475e-9ad9-7a6ad2143af3|890|$aAerobiologia.$i95-647188
e8fe1322-b103-49d7-9f6d-82160bd9141d|10036|2021-02-11|HARRA|Open|false|Ongoing|10036-1|997ef9db-824a-3dc5-ae2c-094dc528868b|Acta informatica.| | |false|Springer-Verlag|Partially Received| |1| |200.0|7a16958e-af23-5002-8191-d7a96f5f8070|bc38aebb-7489-4f19-8584-40c0d11856ee|890|$aActa informatica.  (Springer-Verlag)  Berlin.$isv85-2113