# ldp-analytics

Copyright (C) 2018-2019 The Open Library Foundation

This software is distributed under the terms of the Apache License,
Version 2.0. See the file "[LICENSE](LICENSE)" for more information.


## Introduction

This repository contains reports, queries and other data analysis code for the Library Data Platform ([LDP](https://github.com/folio-org/ldp)). The queries contained herein have been developed by the [FOLIO Reporting Special Interest Group](https://wiki.folio.org/display/RPT/) according to specifications submitted by [FOLIO partner libraries](https://www.folio.org/community/support/).


## How to use this repository

LDP queries are written in SQL and are designed to execute correctly on either the PostgreSQL or Redshift installation of the LDP. To use these queries, you will need to connect to an instance of the LDP using a reporting tool that supports SQL scripts. Examples of reporting tools that will execute SQL scripts include:

* Microsoft Access
* DBeaver
* R
* Crystal Reports
* BIRT
* Tableau

If none of the queries provided match your needs, you can look for an existing
query to use as a starting point and edit the query to create the desired
output.  The [LDP User
Guide](https://github.com/folio-org/ldp/blob/master/USER_GUIDE.md) includes
LDP-specific guidelines for query writing.


## Queries

SQL queries are stored in the [sql directory](sql) of this repository. Each query has a separate directory. A full report may contain separate individual queries, so the queries are grouped into reports using the list below.

### Circulation

* Circulation Detail Report: [Circulation Detail Query](sql/circ_detail)
* Circulation Item Detail Report: [Circulation Item Detail Query](sql/circ_item_detail)
* Services Usage Report: [Services Usage Report](sql/services_usage)

### Inventory

### Finance and Orders

### Resource Management

### Users


## Testing

This repository includes [a framework for testing queries](TESTING.md).


## How to learn more about SQL

* [Self-paced course on Relational Algebra](https://lagunita.stanford.edu/courses/DB/RA/SelfPaced/about)
* [Self-paced course on SQL](https://lagunita.stanford.edu/courses/DB/SQL/SelfPaced/about)


