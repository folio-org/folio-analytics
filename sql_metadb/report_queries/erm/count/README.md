# ERM Agreements Count Report

## Purpose

This report is to counts of e-resources by agreement

## Known issue
As there is currently an issue on the field type for dates in MetaDB date filters are commented out and will be reimplemented when solved.

## Parameters

The parameters in the table below can be set in the WITH clause to filter the report output.

| parameter | description | examples |
| --- | --- | --- |
| agreement_status | date invoice was approved | 'Active', 'Closed' etc. |
| ent_start_date | start date of period with active entitlements | Set start\_date and end\_date in YYYY-MM-DD format. |
| ent_ended_date | end date of period with active entitlements | Set start\_date and end\_date in YYYY-MM-DD format. |
| pci_start_date | start date of period with accessible package content items | Set start\_date and end\_date in YYYY-MM-DD format. |
| pci_end_date |  end date of period with accessible package content items | Set start\_date and end\_date in YYYY-MM-DD format. |

## Future Updates
More data fields as resource type and subscription agreement date for display/filtering will be included in next updates  

## Sample Output

|Agreements|Status|Count|
|----------|----------|----------|
|Agreement_Test_PCI |Active|44|
|Agreement_Test_Package 2|Active|30|
