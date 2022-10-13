# ERM Agreements cancellation dates

## Purpose

The report contains an overview of agreements and their cancellation deadlines.

## Parameters

The parameters in the table below can be set in the WITH clause to filter the report output.

| parameter | description | examples |
| --- | --- | --- |
| sao_role | required to restrict the table column "agreement_vendor" to vendor | 'vendor' |
| agreement_cancellation_interval_start | required, start date for cancellation interval | '2022-01-01' |
| agreement_cancellation_interval_end | required, end date for cancellation interval | '2023-12-31' |
| agreement_status | Enter your agreement_status | 'active', 'closed', 'draft', 'requested' |
| agreement_is_perpetual | Enter your selection for agreement perpetual | 'yes' |


## Sample Output

|agreement_id|agreement_name|agreement_res_name|agreement_cancellation_deadline|agreement_is_perpetual|agreement_status|agreement_vendor|agreement_internal_contact|pol_uuid|
|----------|----------|----------|----------|----------|----------|----------|----------|----------|
|f910739b-40f4-4b35-a11c-d5b720d1964f|Springer_agreement|Java Design Patterns|2022-11-29 00:00:00.000|yes|active|NULL|Doe, Jane|ce188b6f-3fc2-407e-9d0c-7a3b02081bb4|
|e615bb5f-b19d-4bed-b2ac-e348072f0d94|Thieme_agreement|Surgery|2023-10-31 00:00:00.000|NULL|active|Bookworm Ltd.|Doe, John|ce188b6f-3fc2-407e-9d0c-7a3b02081bb4|

