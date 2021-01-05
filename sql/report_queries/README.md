# The FOLIO Query Repository

This repository stores shared queries designed to produce reports of
FOLIO data in a local LDP instance.  These queries have been developed
by the FOLIO reporting community.  For more information about FOLIO
reporting, see the [FOLIO Reporting
SIG](https://wiki.folio.org/display/RPT/).


## How to find a query

You can find queries by browsing the subfolders in this folder or by
reviewing the [Query Table of Contents](#query-table-of-contents) below.

## Understanding query files

In the folder for each query, you should see an .sql file, a README
file, and for some queries, a set of test files (\*\_test.go,
\*\_result.csv). 

The README file summarizes the status, purpose, output, and parameters
of the query. The status of a query can either be Reviewed (it has
undergone review for code logic, syntax, and style by the Reporting
SIG) or Unreviewed. Unreviewed queries will not have complete code or
documentation. 

The .sql file contains the SQL code for the query. You can copy and
paste the content of this file into the reporting tool of your choice
(or download the file and open it in the tool). Unreviewed queries,
however, may not yet be functional.

The test files are described in detail on our [testing documentation
page](https://github.com/folio-org/folio-analytics/blob/master/TESTING.md).

## Query Table of Contents

### Circulation

* Claimed Returned Report: [Claimed Returned Query](claimed_returned)
* Loans and Renewals Report: [Loans and Renewals Counts
  Query](loans_and_renewals_counts)
* Recalls Report: [Recalls Report](recalls)
* Requests Report: [Requests Report](requests)
* Services Usage Report: [Services Usage Report](services_usage)

### Course Reserves

### External Statistics
* [Association of College and Research Libraries (ACRL) Report](acrl)

### Finance and Orders

* ACRL Collection Expenditures Report: [ACRL Collection Expenditures Query](acrl/collection_expenditures)

### Inventory

* ACRL Title Count Report: [ACRL Title Count Query](acrl/title_count)
* ACRL Volume Count Report: [ACRL Volume Count Query](acrl/volume_count)
* HathiTrust Print Report: [Hathi Trust Print Queries](hathitrust_print)
* Missing Items Report: [Missing Items Query](missing_items)
* Pick List Report: [Pick List Query](pick_list)

### Notifications

### Resource Management
* RM Title Count Report: [RM Title Count Query](title_count)


### Users
