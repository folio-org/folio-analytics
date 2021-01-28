# Services Usage Report

## Status: Tested

This query has been reviewed for code syntax and style, approved by the community, and provided with machine test files.

## Report Details

This a report on number of circulation transactions by service-point and transaction type, with time aggregated to date, day of week, and hour of day. Can also be filtered to a particular date range (either a full year or a smaller date range, as needed). This report can be used to review hourly statistics for a short time period to review staffing needs or (by aggregating to week) to report weekly statistics over a full year.

Note: the only data we have about renewals is a total count, so renewals are not included in this service desk activities report.  If renewals are ever tracked with time and location information, those should be added.

This report generates data with the following format:

| service\_point\_name | action\_date | day\_of\_week | hour\_of\_day | material\_type\_name | action\_type | item\_effective\_location\_name\_at\_check\_out | item\_status | ct
|---|---|---|---|---|---|---|---|---|
|Online | 2020-12-03 | Thursday  | 1 | book | Checkin | Main Library | In transit | 1|
|Online | 2020-12-03 | Thursday  | 1 | book | Checkout | Main Library | In transit | 1|
|Online | 2020-12-03 | Thursday  | 2 | book | Checkin | Main Library | In transit | 1|
|Online | 2020-12-03 | Thursday  | 2 | book | Checkout | Main Library | In transit | 1|
|Online | 2020-12-03 | Thursday  | 12 | book | Checkin | Main Library | In transit | 1|
|Online | 2020-12-03 | Thursday  | 12 | book | Checkout | Main Library | In transit | 1|

## Parameters

Users of this query should edit the "parameters" statement at the top to limit the results to a particular check-in/check-out date range.
