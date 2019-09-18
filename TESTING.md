Query Testing
=============


A lightweight testing framework is provided in this repository for testing
queries.


System requirements
-------------------

* Linux or macOS
* [Go](https://golang.org) 1.13 or later
* Database systems supported:
  * PostgreSQL 12 or later
    ([Debian](https://wiki.postgresql.org/wiki/Apt),
    [CentOS/RHEL](https://yum.postgresql.org/))
  * Redshift 1.0.8995 or later


Configuration
-------------

The `GOPATH` environment variable should be set to specify a path that can
serve as the build workspace for Go, e.g.:

```shell
$ export GOPATH=$HOME/go
```

Also set `GO111MODULE` to `on` to enable Go dependency management:

```shell
$ export GO111MODULE=on
```

Next create a configuration file called `.ldptestsql` in your home directory.
This file provides connection details for the database to be used for testing:

```ini
databases = <section_name>,[...]

[<section_name>]
dbtype = <database_type>
host = <host_name>
port = <port_number>
user = <user_name>
password = <password>
dbname = <database_name>
```

For example:

```ini
databases = ldpqdev,rs-ldpqdev

[ldpqdev]
dbtype = postgresql
host = localhost
port = 5432
user = ldp
password = YS4p4EkJGWJqbO9w
dbname = ldpqdev

[rs-ldpqdev]
dbtype = redshift
host = ldpqdev.hfwgaxcbvs5t.us-east-2.redshift.amazonaws.com
port = 5439
user = ldp
password = z3HjUZhkSaQPdt43
dbname = ldpqqev
```


Running tests
-------------

To run tests that have been created for a specific query or queries in a
directory, `cd` to that directory and then run `go test`, e.g.:

```shell
$ cd ldp-analytics/sql/circ_detail
$ go test
```

To run all tests, change to the top level directory:

```shell
$ cd ldp-analytics
$ go test -count=1 ./...
```


Creating a new test
-------------------

To create a new test for a queries or queries in a directory, create a file in
the same directory with a file name ending in `_test.go`.  For example, to
test `circ_detail.sql`, create a file called `circ_detail_test.go`.  Its
contents should look roughly like, e.g.:

```go
package circ_detail

import (
	"testing"

	"github.com/folio-org/ldp-analytics/gotest"
)

func TestQuery(t *testing.T) {

	gotest.RunTest(t, "circ_detail.sql", "circ_detail_result.csv")

}
```

Note the first line: `package circ_detail`.  The package name should match the
name of the directory where this file (and the query) are located.

The test is run by the line:

```go
	gotest.RunTest(t, "circ_detail.sql", "circ_detail_result.csv")
```

The first file, in this example `"circ_detail.sql"`, should contain the query
to be tested.  The second file, in this case `"circ_detail_result.csv"`,
should contain the expected result in CSV.

The expected result can be generated using `psql`, e.g.:

```shell
$ psql ldpqdev -U ldp --csv -f circ_detail.sql -o circ_detail_result.csv
```

The testing code called by `gotest.RunTest()` runs the query and confirms that
the result matches the expected result.


