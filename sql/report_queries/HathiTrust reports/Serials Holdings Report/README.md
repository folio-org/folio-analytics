# HathiTrust Serials Report

## Report Details

Brief description: To extract records for all items that fit the requirements for HathiTrust. Use the parameters to bring back serial resources with OCLC numbers. There are a number of optional results such as item status, holdings type or statistical codes. If these results aren't needed, they can be removed from the query. This report doesn't account for the option government document information typically found in MARC fixed fields. This report relies on FOLIO metadata only. 

This report generates data with the following format:

| title | instance\_id | instance\_hrid | oclc\_number | instance\_mode\_of\_issuance | item\_stat\_code\_type\_name | item\_stat\_code\_name | hol\_stat\_code\_type\_name | hol\_stat\_code\_name | inst\_stat\_code\_type\_name | inst\_stat\_code\_name | location\_name | campus\_name | library\_name | institution\_name |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| The year FOLIO went live | 0b96a642-5e7f-452d-9cae-9cee66c9a892 | item000000000017 | 098766 | serial | ARL (Collection stats) | Serials, print (serials) | ARL (Collection stats) | Serials, print (serials) | ARL (Collection stats) | Serials, print (serials) | Main Library | City Campus | FOLIO Libraries | |


# Parameters

Users can add parameters for the institution, campus name, library, name, location, mode of issuance, status name, and identifier. Only one entry is allowed for the parameters. The suggestions are based on FOLIO Snapshot options.
