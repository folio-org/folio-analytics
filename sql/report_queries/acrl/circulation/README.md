# ACRL Circulation Report

## Report Details

This report is used for pulling data that are reported on an annual basis to organizations such as the Association of College & Research Libraries (ACRL), the Association of Research Libraries (ARL), and the National Center for Education Statistics (NCES). 

The manner in which these data are reported can vary greatly from one library to the next. Therefore, a host of filter-point data elements must be included here in support of the widest variety of need within the FOLIO community. 

The ACRL statistical survey asks for an accounting of initial circulation transactions. "Initial circulation" includes charges only (no renewals). Depending on the situation, libraries may need to filter these transactions by location or the item-based material type. This query provides columns to allow for such filtering.

A library may count all loan IDs within a specific period to derive their initial circulation count. However, there may be instances where some filter mechanism must be used in order to select a subset of total initial circulation. In such cases, one may wish to filter out certain non-collection materials (e.g., markers, calculators, keys, etc.). There may also be a need for additional filtering by item location. Therefore, the following elements are being included in this report prototype to support this type of query refinement. 

This report generates data with the following format:

| date\_range | loan\_date | patron\_group\_name | material\_type\_name | perm\_location\_name | temp\_location\_name | effective\_location\_name | institution\_name | campus\_name | library\_name |
|---|---|---|---|---|---|---|---|---|---|
|2000-01-01 to 2021-01-01 | 2020-12-10 09:00:20-05|staff|dvd|Main Library||Main Library|KÃ¸benhavns Universitet|City Campus|Datalogisk Institut|
|2000-01-01 to 2021-01-01|2020-12-10 06:37:52-05|graduate|dvd|Main Library||Main Library|KÃ¸benhavns Universitet|City Campus|Datalogisk Institut|
|2000-01-01 to 2021-01-01|2020-12-10 06:59:25-05|faculty|book|Main Library|Annex|Annex|KÃ¸benhavns Universitet|City Campus|Datalogisk Institut|
|2000-01-01 to 2021-01-01|2020-12-10 06:57:45-05|faculty|book|Main Library||Main Library|KÃ¸benhavns Universitet|City Campus|Datalogisk Institut|

## Parameters

Users of this query should edit the "parameters" statement at the top to limit the results to a particular loan date range, item material type, or item location.
