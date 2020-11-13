# Title Count Report

# Documentation of the RM title query

## Contents
* [Status](https://github.com/LM-15/falltest/blob/main/README.md#status)
* [Purpose](https://github.com/LM-15/falltest/blob/main/README.md#purpose)
* [Filters](https://github.com/LM-15/falltest/blob/main/README.md#filters)
* [Output](https://github.com/LM-15/falltest/blob/main/README.md#output)
* [In Progress](https://github.com/LM-15/falltest/blob/main/README.md#in-progress) 


## Status
This query has been reviewed for code syntax and style, approved by the community, and provided with machine test files.

## Purpose
To provide title counts for non-electronic resources cataloged in the Inventory.  

<details>
  <summary>Click to read more!</summary>
  
  * Provides unique title counts (i.e., only one count if more than one copy/subscription).  See assumptions and filters available below. Note that it is It is generally assumed that if you need a holdings count as of a certain date, you take it on that date; while you can use processing dates to exclude items newly added after a certain date, you cannot get back titles that were withdrawn or transferred through this query. Local and national definitions can be updated from year to year; be sure to review for needed changes.
  </details>
  
  ## Filters
  
  #### Harcoded filters (assumptions):
* Includes only titles cataloged and made ready for use.
* Excludes: e-resources; suppressed instance record counts, and counts of instance records with only suppressed holdings records.  
