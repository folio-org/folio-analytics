Contributing
============

Thank you for your interest in contributing to FOLIO reporting.  We
appreciate submissions of SQL code for new report queries and derived
table queries, as well as bug fixes.  Please follow these guidelines
when preparing a pull request.


##### Contents  
1\. [New contributors](#1-new-contributors)  
2\. [Branches](#2-branches)  
3\. [Code review](#3-code-review)  
4\. [Formatting SQL](#4-formatting-sql)  


1\. New contributors
--------------------

Before working on a contribution, it is sometimes a good idea to ask
the community in advance about the work you propose to do.  They may
have feedback that would save you time.

For general questions, please use the
[Discussions](https://github.com/folio-org/folio-analytics/discussions)
area.

For bugs or specific technical proposals, please use
[Issues](https://github.com/folio-org/folio-analytics/issues).


2\. Branches
------------

There are three types of branches:

* `main` is the development branch, which all pull requests should be
  based on.

* `stable` is a development branch that is made from `main` and is
  thought to be somewhat more stable than `main`.

* `*-release` are specific release branches made from `stable`.

Again, please use the `main` branch for all pull requests.


3\. Code review
---------------

A pull request is reviewed by at least one person other than the
contributor before it can be merged.  Feel free to request a specific
reviewer, if you wish.


4\. Formatting SQL
------------------

We use the `pg_format` tool from
[pgFormatter](https://github.com/darold/pgFormatter) to make SQL code
more readable.  For maximum consistency, a [configuration
file](https://github.com/folio-org/folio-analytics/blob/main/sql/pg_format.conf)
has been provided.

Please use this method to format submitted code if possible.

Note that `pg_format` has [known
issues](https://github.com/darold/pgFormatter/issues/213) formatting
`WITH` clauses.  In these cases, manual formatting is preferred.


