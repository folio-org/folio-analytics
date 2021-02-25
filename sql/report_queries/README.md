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

In the folder for each query, you should see an .sql file and a README
file, or perhaps multiple .sql files. 

The README file summarizes the purpose, output, and special instructions
of the query.  

The .sql file contains the SQL code for the query. You can copy and
paste the content of this file into the reporting tool of your choice
(or download the file and open it in the tool).

While some queries may be designed to use only tables in the public schema
of the LDP (that is, the tables populated directly with FOLIO data), other
queries rely on our [derived tables](../derived_tables/README.md). The derived tables 
simply the data architecture of the public schema, making FOLIO data much
easier and more efficient to query. To make sure the report queries are
using current FOLIO data, all derived table queries should be scheduled
to run automatically and regularly, perhaps using a nightly Cron job.

## Query Table of Contents

### Circulation

* [ACRL Circulation Report](acrl/circulation)
* [Claimed Returned Report](claimed_returned)
* [Items Lost in Transit Report](items_lost_in_transit)
* [Loans and Renewals Counts
  Report](loans_and_renewals_counts)
* [Services Usage Report](services_usage)

### Course Reserves

### External Statistics
* [Association of College and Research Libraries (ACRL) Report](acrl)

### Finance and Orders

* [ACRL Collections Expenditures Report](acrl/collections_expenditures)

### Inventory

* [ACRL Title Count Report](acrl/title_count)
* [ACRL Volume Count Report](acrl/volume_count)
* [Pick List Report](pick_list)
* [Shelf List Report](shelf_list)

### Notifications

### Resource Management

* [RM Title Count Report](title_count)
* [RM Item Count Report](item_count)
* [Invoices Report](invoices)
* [Orders Report](orders)

### E-Resource Management

* [ERM Costs Reports](erm/costs)
* [ERM Inventory Count Report](erm/count)

### Users
