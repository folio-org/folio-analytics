package gotest

import (
	"database/sql"
	"fmt"

	_ "github.com/lib/pq"
)

// openDatabase creates and returns a client connection to a specified
// database.
func openDatabase(host, port, user, password, dbname, sslmode string) (*sql.DB,
	error) {

	connStr := fmt.Sprintf(
		"host=%s port=%s user=%s password=%s dbname=%s sslmode=%s",
		host, port, user, password, dbname, sslmode)
	db, err := sql.Open("postgres", connStr)
	if err != nil {
		return nil, err
	}

	// Ping the database to test for connection errors.
	err = db.Ping()
	if err != nil {
		return nil, err
	}

	return db, nil
}
