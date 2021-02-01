# Claimed Returned Report

## Status: Tested

This report shows a list of items that patrons claim they have returned, but are not showing as checked in by the system (where the item status is 'claimed returned').  The filters also include date range and borrowing location.

The report includes past circulation information to inform replacement decisions.

NOTE: This report includes patron personal information, which is not GDPR-compliant. This is needed to identify whether the same patron has an excessive number of 'claimed returned' on items, in which case the patron may be flagged.

## Report Details

Brief description: 

This report generates data with the following format:

| date\_range | loan\_id | item\_id | loan\_date | loan\_due\_date | loan\_return\_date | claimed\_returned\_date | item\_status | item\_notes | item\_effective\_location\_name\_at\_check\_out | loan\_policy\_name | permanent\_loan\_type\_name | current\_item\_temporary\_location\_name | current\_item\_effective\_location\_name | current\_item\_permanent\_location\_name | current\_item\_permanent\_location\_library\_name | current\_item\_permanent\_location\_campus\_name | current\_item\_permanent\_location\_institution\_name | barcode | material\_type\_name | chronology | copy\_number | enumeration | item\_level\_call\_number | number\_of\_pieces | volume | call\_number | permanent\_location\_name | temporary\_location\_name | shelving\_title | cataloged\_date | dates\_of\_publication | num\_loans | num\_renewals | patron\_group\_name | first\_name | middle\_name | last\_name | email |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
|2000-01-01 to 2022-01-01 | e3d9c195-ecc6-4852-8dce-a9d8e60b5522 | 15e8e286-8727-4feb-b3fd-3d4d92ce5f27 | 2021-01-28 13:09:23+00 | 2021-01-28 14:09:23+00 |  |  | Checked out |  | Main Library | One Hour |  |  | Main Library |  |  |  |  | 1611838737372137603 | book |  |  |  |  | 1 |  |  | Main Library |  |  |  |  | 1 | 0 | undergrad | Pietro | Brigitte | Brown | pascale@lindgren-hammes-and-toy.nm.us|
|2000-01-01 to 2022-01-01 | 40f5e9d9-38ac-458e-ade7-7795bd821652 | 1b6d3338-186e-4e35-9e75-1b886b0da53e | 2017-03-05 18:32:31+00 | 2017-03-19 18:32:31+00 |  |  | Checked out | Signed by the author |  |  | Course reserves |  | Main Library |  |  |  |  | 453987605438 | book |  | Copy 1 |  |  | 1 |  |  | Main Library |  |  |  | 2016 | 1 | 0 |  | Justen | Else | Hilll | pete@schulist-raynor-and-beer.ar.us|
|2000-01-01 to 2022-01-01 | 77441157-33ba-403f-9f7b-131686e274ee | 1d583119-77bb-42a7-9af8-cf5e79ae44e2 | 2021-01-28 13:09:28+00 | 2021-01-28 14:09:28+00 |  |  | Checked out |  | Main Library | One Hour |  |  | Main Library |  |  |  |  | 1611838737372418575 | book |  |  |  |  | 1 |  |  | Main Library |  |  |  |  | 1 | 0 | undergrad | Pietro | Brigitte | Brown | pascale@lindgren-hammes-and-toy.nm.us|


## Parameters

Users of this query should edit the "parameters" statement at the top to limit the results to a particular date range, location, library, campus, or institution. 

The item status filter uses "Checked out" for its value because of the minimal test data avialable for claimed returned items. When running this query on real data, this needs to be changed to "Claimed returned."