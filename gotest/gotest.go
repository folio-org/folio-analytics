package gotest

import (
	"database/sql"
	"fmt"
	"io/ioutil"
	"os"
	"path/filepath"
	"sort"
	"strings"
	"testing"
)

func RunTest(t *testing.T, queryFile string, resultFile string) {
	dir, _ := os.Getwd()
	queryPath := filepath.Join(dir, queryFile)
	resultPath := filepath.Join(dir, resultFile)
	err := run(queryPath, resultPath)
	if err != nil {
		t.Errorf("%v", err)
	}
}

func run(queryPath string, resultPath string) error {
	config, err := readConfig()
	if err != nil {
		return err
	}
	databases := strings.Split(config.Get("", "databases"), ",")
	for _, d := range databases {
		// TODO Move inside loop to function to allow proper db.Close()
		section := strings.TrimSpace(d)
		db, err := openDatabase(
			config.Get(section, "host"),
			config.Get(section, "port"),
			config.Get(section, "user"),
			config.Get(section, "password"),
			config.Get(section, "dbname"),
			"require")
		if err != nil {
			return err
		}
		defer db.Close()
		err = runDB(queryPath, resultPath, section, db)
		if err != nil {
			return err
		}
	}
	return nil
}

func runDB(queryPath string, resultPath string, section string,
	db *sql.DB) error {

	buf, err := ioutil.ReadFile(queryPath)
	if err != nil {
		return fmt.Errorf("Unable to read query file: %v", err)
	}
	query := string(buf)

	buf, err = ioutil.ReadFile(resultPath)
	if err != nil {
		return fmt.Errorf("Unable to read result file: %v", err)
	}
	expectedResult := string(buf)

	rows, err := db.Query(query)
	if err != nil {
		return fmt.Errorf("Error running query: %v", err)
	}
	defer rows.Close()

	var rb strings.Builder
	columns, err := rows.Columns()
	if err != nil {
		return fmt.Errorf("Error running query: %v", err)
	}
	for x, c := range columns {
		if x > 0 {
			rb.WriteRune(',')
		}
		rb.WriteString(c)
	}
	rb.WriteRune('\n')
	data := make([]interface{}, len(columns))
	rdata := make([][]byte, len(columns))
	for x := range rdata {
		data[x] = &rdata[x]
	}
	for rows.Next() {
		err = rows.Scan(data...)
		if err != nil {
			return fmt.Errorf("Error running query (scan): %v",
				err)
		}
		for x, r := range rdata {
			if x > 0 {
				rb.WriteRune(',')
			}
			if r != nil {
				rb.WriteString(string(r))
			}
		}
		rb.WriteRune('\n')
	}
	result := rb.String()

	err = rows.Err()
	if err != nil {
		return fmt.Errorf("Error running query: %v", err)
	}

	result = normalizeResult(result)
	expectedResult = normalizeResult(expectedResult)
	match := (result == expectedResult)

	if !match {

		fn, err := writeResult(filepath.Dir(queryPath), result)
		if err != nil {
			fn = "(Unable to write file)"
		}

		return fmt.Errorf(
			"\n\nQuery:\n"+
				"%s\n\n"+
				"Expected result:\n"+
				"%s\n\n"+
				"Testing in database:  %s\n\n"+
				"Got:\n"+
				"%s\n\n"+
				"Want:\n"+
				"%s\n\n"+
				"Unexpected result written to:\n"+
				"%s\n\n",
			queryPath,
			resultPath,
			section,
			strings.TrimSpace(result),
			strings.TrimSpace(expectedResult),
			fn)

	}

	return nil
}

// normalizeResult converts a query result into a normalized form, including
// sorting the rows, so that it can be compared with another result.
func normalizeResult(result string) string {
	sp := strings.Split(result, "\n")
	cols := sp[0]
	rows := sp[1:]
	sp = nil
	sort.Slice(rows, func(i, j int) bool {
		return rows[i] < rows[j]
	})
	var newresult []string
	newresult = append(newresult, cols)
	for _, r := range rows {
		if strings.TrimSpace(r) != "" {
			newresult = append(newresult, r)
		}
	}
	return strings.TrimSpace(strings.Join(newresult, "\n"))
}

// writeResult writes the unexpected result to a file and returns the file
// name.
func writeResult(dir string, result string) (string, error) {
	f, err := ioutil.TempFile(dir, "test-result-*.csv")
	if err != nil {
		return "", err
	}
	_, err = f.Write([]byte(result))
	if err != nil {
		f.Close()
		return "", err
	}
	err = f.Close()
	if err != nil {
		return "", err
	}
	return f.Name(), nil
}
