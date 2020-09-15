# The FOLIO Query Repository

This repository stores shared queries designed to produce reports of
FOLIO data in a local LDP instance.  These queries have been developed
by the FOLIO reporting community.  For more information about FOLIO
reporting, see the [FOLIO Reporting
SIG](https://wiki.folio.org/display/RPT/).


## How to find a query

You can find queries by browsing the subfolders in this folder or by
reviewing the [main README file for this
repository](https://github.com/folio-org/folio-analytics).

## Understanding query files

In the folder for each query, you should see an .sql file, a README
file, and for most queries, a set of test files (\*\_test.go,
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

## Submitting new queries

When working on a new query, please contact Angela Zoss with the URL
of your prototype. Angela will create a subdirectory and README file
for your work, at which point you can fork the folio-analytics
repository and begin using version control to save progress on your
query.

When you are done with your initial query development, you may submit
a pull request to have the query merged back into the master
repository. Then the query will go through the review workflow on
JIRA.

