# Items Lost in Transit Report

## Report Details

Brief description: Reports items that were discharged at a circulation desk other than their "home" circulation desk and haven't yet been discharged at home. Therefore the items might have been lost or misplaced on their way back to their home location.

Note: We are using item status "In transit" and a date range to indicate that an item is missing. You can set the date range to specify that it is older, closed loans with "In transit" status that constitute missing items. 

This report generates data with the following format:

| date\_range | item\_id | title | shelving\_title | item\_status | loan\_return\_date | checkout\_service\_point\_name | checkin\_service\_point\_name | in\_transit\_destination\_service\_point\_name | barcode | call\_number | enumeration | chronology | copy\_number | volume | holdings\_permanent\_location\_name | holdings\_temporary\_location\_name | current\_item\_permanent\_location\_name | current\_item\_temporary\_location\_name | current\_item\_effective\_location\_name | cataloged\_date | publication\_dates\_list | notes\_list | material\_type\_name | num\_loans | num\_renewals |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 2000-01-01 to 2022-01-01 | 0e71be20-da9a-4b7f-8538-1a0d47eecef9 | L’Apprenti sorcier / Paul Dukas |  | In transit | 2021-01-07 11:39:07.472+00 | Online | Online | Circulation Desk -- Hallway | 1609984352676639732 |  |  |  |  |  | Main Library |  |  |  | Main Library |  |  |  | book | 1 | 0 |

## Parameters

Users of this query should edit the "parameters" statement at the top to limit the results to a particular date range, item status, and location or service point.
