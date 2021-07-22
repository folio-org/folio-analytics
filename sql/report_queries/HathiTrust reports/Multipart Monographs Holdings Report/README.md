# HathiTrust Multipart Monograph Report

## Report Details

Brief description: To extract records for all items that fit the requirements for HathiTrust. Use the parameters to back multipart monograph resources with OCLC numbers. There are a number of optional results such as item status, holdings type or statistical codes. If these results aren't needed, they can be removed from the query. This report doesn't account for the option government document information typically found in MARC fixed fields. This report relies on FOLIO metadata only. 

This report generates data with the following format:

| item_id | item_hrid | item_material_type | chronology | enumeration | item_status_name | instance_id | instance_hrid | instanace_status_name | instance_resource_type | instance_mode_of_issuance | instance_identifier_name | instance_identifier | instance_format | holdings_type_name | item_stat_code_type_name | item_stat_code_name | hol_stat_code_type_name | hol_stat_code_name | inst_stat_code_type_name | inst_stat_code_name | location_name | campus_name | library_name | institution_name |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 0b96a642-5e7f-452d-9cae-9cee66c9a892 | item000000000017 | text |  |  | Available | 69640328-788e-43fc-9c3c-af39e243f3b7 | inst000000000001 | Temporary | text | single unit | OCLC | 98837837 | unmediated -- volume | physical | ARL (Collection stats) | Serials, print (serials) | ARL (Collection stats) | Serials, print (serials) | ARL (Collection stats) | Serials, print (serials) |


# Parameters

Users can add parameters for the institution, campus name, library, name, location, mode of issuance, holdings type, status name, identifier, format, and 3 options for resource type. Only one entry is allowed for the parameters. The suggestions are based on FOLIO Snapshot options.

