# ERM Agreements Count Report

## Purpose

This report counts of e-resources by agreement

## Parameters

The parameters in the table below can be set in the WITH clause to filter the report output.

| parameter | description | examples |
| --- | --- | --- |
| agreement_status | current status of the agreement | 'Active', 'Closed' etc. |
| resource_type | type of resource | 'monograph', 'serial' etc. |
| resource_sub_type | sub type of resource | 'electronic', 'print' etc. |
| resource_publication_type | publication type of resource | 'journal', 'book' etc. |
| ent_start_date | start date of period with active entitlements | Set start\_date and end\_date in YYYY-MM-DD format. |
| ent_ended_date | end date of period with active entitlements | Set start\_date and end\_date in YYYY-MM-DD format. |
| pci_start_date | start date of period with accessible package content items | Set start\_date and end\_date in YYYY-MM-DD format. |
| pci_end_date |  end date of period with accessible package content items | Set start\_date and end\_date in YYYY-MM-DD format. |

## Future Updates
Subscription agreement date for display/filtering will be included in next update  

## Sample Output

|Agreements|Status|Resource Type|Resource Subtype|Resource Publicationtype|Count|
|----------|----------|----------|----------|----------|----------|
|Agreement_Test_PCI |Active|serial|electronic|journal|44|
|Agreement_Test_Package 2|Active|monograph|electronic|book|30|
