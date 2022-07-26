# folio-analytics

Copyright (C) 2018-2022 The Open Library Foundation

This software is distributed under the terms of the Apache License,
Version 2.0. See the file "[LICENSE](LICENSE)" for more information.


## Introduction

This repository contains reports and other analytics developed for
FOLIO and designed to run on the [Library Data
Platform](https://github.com/library-data-platform/ldp).  At present
most of the content here consists of SQL reports developed by the
FOLIO reporting community and based on the requirements of [FOLIO
partner libraries](https://www.folio.org/community/support/).  In
addition to report development, FOLIO has a [Reporting Special
Interest Group](https://wiki.folio.org/display/RPT/) that discusses
reporting requirements and other related topics.


## How to use this repository

LDP-based queries are written in SQL and are currently tested on
PostgreSQL, with plans to test on Redshift in the future.  To use
these queries, you will need to connect to an LDP database instance
using a reporting tool that supports SQL scripts.  Examples of
reporting tools that will execute SQL scripts include DBeaver, Aqua
Data Studio, Tableau, and Microsoft Access.

If none of the queries provided match your needs, you can look for an
existing query to use as a starting point and edit the query to create
the desired output.  The [LDP User
Guide](https://github.com/library-data-platform/ldp/blob/main/doc/User_Guide.md)
includes guidelines for writing queries.


## Queries

SQL queries are stored in the [sql directory](sql) of this repository.
Queries are separated into two categories: [derived table
queries](sql/derived_tables) and [report queries](sql/report_queries). 

Derived table queries are designed to combine tables that are commonly
used together or to otherwise simply querying.  Institutions may wish
to set up a nightly Cron job to run these queries.

Report queries are created in response to specific report requests
from FOLIO member institutions.  Each query is located in a separate
directory.  A full report may contain several individual queries.
Consult the README.md file in the [report queries](sql/report_queries)
folder for a query table of contents, and look for additional
README.md files in the query folders to explain how to run the
reports.


## Releases and branches

Each release of folio-analytics is intended to be used with a specific
FOLIO release:

| FOLIO         | folio-analytics  |
| ------------- | :--------------: |
| Morning Glory |        1.4       |
| Lotus         |        1.3       |
| Kiwi          |        1.2       |
| Juniper       |        1.2       |

There are two primary types of branches:

* The main branch (`main`).  This is a development branch where new
  features are first merged.  This branch is relatively unstable.  It
  is also the default view when browsing the repository on GitHub.

* Release branches (`release-*`).  These are releases made from
  `main`.  They are managed as stable branches; i.e. they may receive
  bug fixes but generally no new features.  Production deployments
  should install release tags, not branches.
