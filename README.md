# folio-analytics

Copyright (C) 2018-2020 The Open Library Foundation

This software is distributed under the terms of the Apache License,
Version 2.0. See the file "[LICENSE](LICENSE)" for more information.


## Introduction

This repository contains reports and other analytics developed for
FOLIO and designed to run on the [Library Data
Platform](https://github.com/folio-org/ldp).  At present most of the
content here consists of SQL reports developed by the FOLIO reporting
community and based on the requirements of [FOLIO partner
libraries](https://www.folio.org/community/support/).  For more
information about FOLIO reporting, see the [FOLIO Reporting Special
Interest Group](https://wiki.folio.org/display/RPT/).


## How to use this repository

LDP-based queries are written in SQL and are designed to execute
correctly on either PostgreSQL or Redshift.  To use these queries, you
will need to connect to an LDP database instance using a reporting
tool that supports SQL scripts.  Examples of reporting tools that will
execute SQL scripts include:

* Microsoft Access
* DBeaver
* R
* Crystal Reports
* BIRT
* Tableau

If none of the queries provided match your needs, you can look for an
existing query to use as a starting point and edit the query to create
the desired output.  The [LDP User
Guide](https://github.com/folio-org/ldp/blob/master/doc/User_Guide.md)
includes guidelines for query writing.


## Queries

SQL queries are stored in the [sql directory](sql) of this repository. Queries are separated into two categories: [derived table queries](sql/derived_tables) and [report queries](sql/report_queries). 

Derived table queries are designed to combine tables that are commonly used together or to otherwise simply querying. Institutions may wish to set up a nightly CRON job to run these queries.

Report queries are created in response to specific report requests from FOLIO member institutions. Each query has a separate directory. A full report may contain separate individual queries. Consult the README file in the [report queries](sql/report_queries) folder for a query table of contents, and look for additional README files in the query folders to explain how to run the reports.


## Testing

This repository includes [a framework for testing queries](TESTING.md).


## How to learn more about SQL

* [Self-paced course on Relational
  Algebra](https://lagunita.stanford.edu/courses/DB/RA/SelfPaced/about)
* [Self-paced course on
  SQL](https://lagunita.stanford.edu/courses/DB/SQL/SelfPaced/about)

