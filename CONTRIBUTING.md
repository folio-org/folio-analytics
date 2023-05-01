Contributing
============

We appreciate submissions of SQL code for new report queries and
derived table queries, as well as bug fixes.  All submissions will be
considered as time allows.  We ask your patience; it may require
considerable time to decide whether a pull request will be accepted.

Please follow these guidelines when preparing a pull request.

##### Contents  
1\. [New contributors](#1-new-contributors)  
2\. [Commits and pull requests](#2-commits-and-pull-requests)  
3\. [Code review](#3-code-review)  
4\. [Documentation](#4-documentation)  
5\. [Testing](#5-testing)  
6\. [Derived tables](#6-derived-tables)  
7\. [Formatting SQL](#7-formatting-sql)  
8\. [Naming things](#8-naming-things)  
9\. [Checklist](#9-checklist)


1\. New contributors
--------------------

Before beginning work on a contribution, we recommend that you ask the
community in advance about the work you propose to do.  They may have
feedback that would save you time.

At present most contributors use the #reporting-lab channel in the
FOLIO Slack organization.

Alternatively, for general questions, feel free to use the
[Discussions](https://github.com/folio-org/folio-analytics/discussions)
area.  For bugs or specific technical proposals, use
[Issues](https://github.com/folio-org/folio-analytics/issues).


2\. Commits and pull requests
-----------------------------

### Making changes

All commits should be made in a "forked" repository, not in this
repository.

It is **strongly recommended** to create a new branch based on the
`main` branch, rather than committing directly to `main`.

**Pull requests will be "squash merged," and so the pull request
branch should be discarded or not reused after being merged, in order
to avoid confusion.**  If the `main` branch is used for a pull
request, it is a good idea to re-fork the repository after the merge.

Since the entire pull request will be squashed into a single commit,
it is recommended to keep the scope of the pull request relatively
narrow, preferrably addressing only a single issue.


### Commit description

Quoting roughly from the Git Reference Manual, Git commits are
documented with a short, one-line title which summarizes the changes,
followed by a more thorough, long description.  The title should be no
more than 75 characters.  It is important that at least the title be
filled in with a meaningful summary so that the Git history will be
readable.  Hyperlinks or other references such as "Fixes #" may be
included in the long description, but not in the title and not as a
substitute for a complete description of the changes.

### CHANGES.md

The CHANGES.md file should be updated with release notes describing
the changes made in the pull request.  This should be a
self-contained, textual summary of the changes, rather than a
hyperlink to an issue.


3\. Code review
---------------

A pull request is reviewed by at least two people other than the
contributor before it can be merged.

If a review suggests expanding the scope of the changes to include
additional functionality, those changes do not have to be addressed in
the current pull request but may be handled in a separate, new pull
request.

See below for a suggested checklist for code reviews.


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

Derived table queries for Metadb should also include any relevant
external SQL directives, in particular:

```
--metadb:table <table>
```


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
( `_` ) to separate words.  Double underscores ( `__` ) should be
avoided because they are used in Metadb databases as special
indicators.

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


9\. Checklist
-------------

The checklist below can be used to guide your review of a pull request
(PR).  A copy of the checklist may be added to a comment attached to a
review.  Check off the items that have been confirmed in your review
by adding an `x` between the square brackets `[]` on each line.

If any items remain unchecked or you have further questions, you can
indicate that in the comment as well and select "Request changes" as
the review response.

```
All queries:
- [ ] PR Title and Description are accurate and thorough
- [ ] PR is based on a new branch (not main)
- [ ] PR scope is not overly broad
- [ ] Query runs without errors
- [ ] Query output is correct
- [ ] Query logic is clear and well documented
- [ ] Query is readable and properly indented with spaces (not tabs)
- [ ] Table and column names are in all-lowercase
- [ ] Quotation marks are used only where necessary

Report queries:
- [ ] Query has complete user documentation
    - [ ] Purpose of report
    - [ ] Sample output
    - [ ] Query instructions

Derived tables:
- [ ] Query begins with user documentation in comment lines
- [ ] File name is listed in `runlist.txt` after dependencies
- [ ] All columns have indexes
- [ ] Table is vacuumed and analyzed
- [ ] First line is "--metadb:table" directive, followed by blank line
```

