Query Writing
=============

This document describes techniques for creating, understanding, and revising LDP queries.

SQL Style
---------
* spacing/indentation
	* four spaces for indents
	* when listing more than 3 elements, put each on a new line (including first)
* keywords
	* capitalize keywords (use upper case)
	* always use AS for aliasing (columns, subqueries, tables, etc.)
* blank lines
	* no blank lines
* punctuation
	* commas at end of line
	* ( at end of line
	* ) at beginning of line, lined up with keyword from line with (
* type conversion
	* always use ' :: ' followed by data type in lower case (e.g., 'varchar', 'date')
* comments
	* /* ... */ for multi-line comments
	* -- for single line comments
* file name
	* (underscores)
* selecting fields
	* no "select *", list all fields explicitly
	* (for joins, can join on whole table, don't need a subquery to limit the right table in the join)

Structuring a Query
-------------------
1. header comment section
	* last edited date? current as of?
	* fields requested in output, in requested order 
	* any filters?
	* aggregated or not? (how?)
	* any other context necessary to understand query
	* warning if query might result in more than 1 million rows (Excel)?
	* have this header as a template in the documentation
2. parameters (using WITH statement)
	* place parameters at beginning of file to make it easier for people to modify
	* always use name "parameters"
	* avoid using parameter field names that duplicate LDP field names, if possible
	* set default parameter values in a way that should guarantee the query will return some results, both for testing and for reassuring query users
		* if filtering by a date range, use a default date range that is very large (10+ years), even if this query will typically be used for a single year
		* if filtering by value in a particular field (e.g., a particular service point), consider using the most common value
3. additional WITH statements to label subqueries (e.g., services-usage) - optional
4. primary query


Details on Specific Strategies
------------------------------
* WITH statements
	* can use WITH to create temporary tables at the beginning of the query that then get used later
	* last WITH statement goes straight into primary SELECT statement for query, do not need a comma after last WITH statement
* Catching empty string & null values
	* if you are just selecting a column that may have a null value, you don't need to do anything special
	* if you are transforming the column in some way, like using it in a mathematical calculation or extracting some part of the value you need to test for a null value or empty string
	* one way might be COALESCE, which allows you to specify a default value if the result is null
* Picking which table to select from first
	* when writing a query, it's important to think through which table you list first in the SELECT statement because of the joins that will build on it
	* start with the table that best represents what you want on each line of the results table
		* for example, if you ultimately want a list of loans, start with loans table
* LEFT JOIN vs. INNER JOIN
	* in general, using LEFT makes sure you don't accidentally lose the items you're most interested
		* for example, if you're interested in loans and also want to see the demographics of the users making the loan, you can use LEFT JOIN to keep all loans even if you don't know the user's demographics
	* if you are filtering a table based on a field in a secondary table, you may instead want to use INNER JOIN to make sure to exclude records that don't have the required value
* BETWEEN
	* note that using BETWEEN for dates is risky because it only includes records up to midnight of the end date (essentially, the end of the day before)
	* if you do use BETWEEN, try to educate people about its behavior in comments and set default values that make sense for the behavior
	* if you do not use BETWEEN, you can use >= and <= instead
* DRY - Don't Repeat Yourself
	* as with any programming, the more repetition you have in your query, the more likely you are to forget to update something or make a mistake the second time around
	* try to find a way to reuse parts of your query creatively, either with parameters or WITH statements


Accommodating Redshift
----------------------
* Why accommodate Redshift
	* PostgreSQL is great and free, but requires local hosting
	* Amazon Redshift requires Amazon hosting, but is often faster than locally-hosted PostgreSQL
	* LDP is designed to run on either PostgreSQL or Redshift, so LDP queries also need to run on both
	* Redshift SQL is based on (an older version of) PostgreSQL, but there are differences that mean that not everything that runs on PG can run on Redshift (and vice versa)
* JSON functions
	* PostgreSQL has much better JSON support than Redshift. Redshift can pretty much only use json\_extract\_path\_text()
	* [Redshift JSON functions](https://docs.aws.amazon.com/redshift/latest/dg/json-functions.html)
* explicit casting
	* for anything in a query that doesn't come from a database table, you will need to explicitly state (or "cast") the value to a data type
		* example: anything in the parameters temporary table will need explicit casting
		* example: if you are adding an ad hoc field with a static value into your table (see services-usage), the static value will need explicit casting
* other issues
	* had some trouble with the date_part functions and Redshift documentation was not helpful; took a fair amount of trial-and-error to figure out the right pattern (see services-usage)


