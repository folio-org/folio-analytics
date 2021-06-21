# Missing Items Report

## Report Details

Brief description: Reports items where the item status is 'Missing'. 

The report includes all item details including number of loans and renewals, so as to help with replacement decisions. The filters for this report are item status, date range, and item and holdings locations (if specified in parameters).

This report generates data with the following format:

|date_range|item_id|title|shelving_title|item_status|item_status_date|last_loan_return_date|checkout_service_point_name|checkin_service_point_name|barcode|call_number|enumeration|chronology|copy_number|volume|holdings_permanent_location_name|holdings_temporary_location_name|current_item_permanent_location_name|current_item_temporary_location_name|current_item_effective_location_name|cataloged_date|publication_dates_list|notes_list|material_type_name|num_loans|num_renewals|
|----------|-------|-----|--------------|-----------|----------------|---------------------|---------------------------|--------------------------|-------|-----------|-----------|----------|-----------|------|--------------------------------|--------------------------------|------------------------------------|------------------------------------|------------------------------------|--------------|----------------------|----------|------------------|---------|------------|
|2000-01-01 to 2022-01-01|0b96a642-5e7f-452d-9cae-9cee66c9a892|Temeraire||Missing|2021-05-25 14:10:12.852||||645398607547||||||Main Library||||Main Library||||book|||
|2000-01-01 to 2022-01-01|22654d6d-e1e6-4f41-bf99-0c215a41c399|Web Engineering / Reiner Dumke, Mathias Lother, Cornelius Wille, Fritz Zbrog||Missing|2021-05-25 14:09:45.023||||||||||Annex||||Annex||||book|||
|2000-01-01 to 2022-01-01|4428a37c-8bae-4f0d-865d-970d83d5ad55|Bridget Jones's Baby: the diaries||Missing|2021-05-25 14:09:19.731||||4539876054382||||Copy 2||Main Library||||Main Library||2016|Missing pages; p 10-13&#124;My action note&#124;My copy note&#124;My provenance&#124;My reproduction|book|||


## Parameters

The 'Missing' status is included as a parameter in this report. Other parameters include date range and item and holdings locations.
