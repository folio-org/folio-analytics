# HathiTrust Monographic Report

## Report Details

Brief description: To extract records for all items that fit the requirements for HathiTrust. Use the parameters to back monographs or monograph like resources with OCLC numbers. There are a number of optional results such as item status, holdings type or statistical codes. If these results aren't needed, they can be removed from the query. This report doesn't account for the option government document information typically found in MARC fixed fields. This report relies on FOLIO metadata only. 

This report generates data with the following format:

| item\_id | item\_hrid | item\_material\_type | chronology | enumeration | item\_status\_name | instance\_id | instance\_hrid | instanace\_status\_name | instance\_resource\_type | instance\_mode\_of\_issuance | instance\_identifier\_name | instance\_identifier | instance\_format | holdings\_type\_name | item\_stat\_code\_type\_name | item\_stat\_code\_name | hol\_stat\_code\_type\_name | hol\_stat\_code\_name | inst\_stat\_code\_type\_name | inst\_stat\_code\_name | location\_name | campus\_name | library\_name | institution\_name |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 0b96a642-5e7f-452d-9cae-9cee66c9a892 | item000000000017 | text | | | Available | 69640328-788e-43fc-9c3c-af39e243f3b7 | inst000000000001 | Temporary | text | single unit | OCLC | 98837837 | unmediated -- volume | physical | ARL (Collection stats) | Serials, print (serials) | ARL (Collection stats) | Serials, print (serials) | ARL (Collection stats) | Serials, print (serials) |


# Parameters

Users can add parameters for the institution, campus name, library, name, location, mode of issuance, holdings type, status name, identifier, format, and 3 options for resource type. Only one entry is allowed for the parameters. The suggestions are based on FOLIO Snapshot options.

