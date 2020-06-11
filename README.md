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

LDP queries are written in SQL and are designed to execute correctly
on either the PostgreSQL or Redshift installation of the LDP. To use
these queries, you will need to connect to an instance of the LDP
using a reporting tool that supports SQL scripts. Examples of
reporting tools that will execute SQL scripts include:

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
includes LDP-specific guidelines for query writing.


## Queries

SQL queries are stored in the [sql directory](sql) of this repository.
Each query has a separate directory. A full report may contain
separate individual queries, so the queries are grouped into reports
using the list below.

### Circulation

* Circulation Detail Report: [Circulation Detail
  Query](sql/circ_detail)
* Circulation Item Detail Report: [Circulation Item Detail
  Query](sql/circ_item_detail)
* Loans and Renewals Report: [Loans and Renewals Counts
  Query](sql/loans_and_renewals_counts)
* Services Usage Report: [Services Usage Report](sql/services_usage)

### Inventory

* ACRL Title Count Report: [ACRL Title Count Query](sql/acrl)
* ACRL Volume Count Report: [ACRL Volume Count Query](sql/acrl)
* Missing Items Report: [Missing Items Query](sql/missing_items)
* Pick List Report: [Pick List Query](sql/pick_list)

### Finance and Orders

### Resource Management

### Users


## Testing

This repository includes [a framework for testing queries](TESTING.md).


## How to learn more about SQL

* [Self-paced course on Relational
  Algebra](https://lagunita.stanford.edu/courses/DB/RA/SelfPaced/about)
* [Self-paced course on
  SQL](https://lagunita.stanford.edu/courses/DB/SQL/SelfPaced/about)

