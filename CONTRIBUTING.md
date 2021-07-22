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
4\. [Documentation](#4-documentation)  
5\. [Testing](#5-testing)  
6\. [Derived tables](#6-derived-tables)  
7\. [Formatting SQL](#7-formatting-sql)  
8\. [Naming things](#8-naming-things)


1\. New contributors
--------------------

Before working on a contribution, it is usually a good idea to ask the
community in advance about the work you propose to do.  They may have
feedback that would save you time.

For general questions, please use the
[Discussions](https://github.com/folio-org/folio-analytics/discussions)
area.

For bugs or specific technical proposals, please use
[Issues](https://github.com/folio-org/folio-analytics/issues).


2\. Branches
------------

All pull requests should be based on the `main` branch.  Some bug 
fixes will be backported to recent release branches.


3\. Code review
---------------

A pull request is reviewed by at least two people other than the
contributor before it can be merged.


4\. Documentation
-----------------

Additions or changes to queries should be accompanied by the
corresponding additions or changes to user documentation, together in
the same pull request.

The user documentation should contain three sections:

* Purpose of report
* Sample output
* Query instructions, e.g. how to set parameters


5\. Testing
-----------

All queries or changes to queries should be tested with an LDP
database before they are submitted in a pull request.  We do not
currently have a test data set to allow significant automated testing.


6\. Derived tables
------------------

Additions or changes to derived tables should be accompanied by any
required additions or changes to the `runlist.txt` and `deps.txt`
files, together in the same pull request.


7\. Formatting SQL
------------------

We use the `pg_format` tool from
[pgFormatter](https://github.com/darold/pgFormatter) to make SQL code
more readable.  For maximum consistency, a [configuration
file](https://github.com/folio-org/folio-analytics/blob/main/sql/pg_format.conf)
has been provided.  The configuration file should be copied as
`~/.pg_format`.

Please use this method to format submitted code if possible.

Note that `pg_format` has known issues such as with [formatting
CTEs](https://github.com/darold/pgFormatter/issues/213).  In these
cases, manual formatting is preferred.


8\. Naming things
-----------------

Names of tables and columns should be in lowercase and use underscores
( `_` ) to separate words.

In the rare case where a column name is both the same as a reserved
word and stands alone without a table or alias prefix, it must be
enclosed in quotation marks ( `"` ).  Apart from these cases, it is
better not to use quotation marks.

For derived tables, the table names do not follow a purely mechanical
pattern, which might result in some names being impractically long.
The schema/table name of the first table listed after `FROM` is
normally used as a prefix for the derived table name, for example,
`instance_` or `item_`.  Added to this is often a suffix that suggests
the most salient table join, or `ext` for general extensions of the
data.  Overall, it is helpful to think about how to describe the
derived table concisely.



