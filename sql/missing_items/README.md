# Missing Items Report

## Status: Reviewed

## Report Details

Brief description: Reports items that were discharged at a circulation desk other than their "home" circulation desk and haven't yet been discharged at home. Therefore the items might have been lost or misplaced on their way back to their home location.

This report generates data with the following format:

| date\_range | holdings\_permanent\_location\_name | holdings\_temporary\_location\_name | shelving\_title | items\_permanent\_location\_name | items\_temporary\_location\_name | items\_effective\_location\_name | barcode | item\_level\_call\_number | volume | enumeration | chronology | item\_notes | copy\_numbers | item\_status | checkout\_service\_point\_name | checkin\_service\_point\_name | cataloged\_date | instance\_publication\_date | material\_type\_name | in\_transit\_destination\_service\_point\_name | num\_loans\_and\_renewals |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
|2000-01-01 to 2021-01-01|Main Library||||||1574739805051615239||||||"{ ""copyNumbers"": []}"|In transit|Online|Online|||book|Circ Desk 1|

## Parameters

Users of this query should edit the "parameters" statement at the top to limit the results to a particular date range, item status, and location or service point.