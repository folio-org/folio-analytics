# Shelflist Report

## Report Details

Brief description: To extract records for all items that have a permanent location or temporary location that matches the location(s) selected from the location list. This can include item information such as barcode, enumeration, or chronology, instance information such as title and primary contributor, and loan history information. This report can be run ad hoc or on a regular basis.

Note: This report relies on FOLIO Instance records only. 

This report generates data with the following format:

| item\_id | item\_hrid | item\_barcode | chronology | enumeration | effective\_call_number | material\_type\_name | status | loan\_item\_status | permanent\_location\_name | temporary\_location\_name | item\_suppressed | loan\_due\_date | loan\_return\_date | item\_num\_loans | location\_name | campus\_name | library\_name | institution\_name | instance\_hrid | title | contributor\_type\_name | contributor\_primary | identifier\_type\_name |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 0b96a642-5e7f-452d-9cae-9cee66c9a892 | item000000000017 | 645398607547 | | | PN1987 .B84 1997 | book | Available | | | | | | | 0 | Main Library | City Campus | Datalogisk Institut | KÃ¸benhavns Universitet | inst000000000024 | Temeraire| Novik, Naomi | | ISBN |


## Parameters

Users of this query should edit the "parameters" statement at the top to limit the results to a particular location, campus/library/institution name, identifier type.

