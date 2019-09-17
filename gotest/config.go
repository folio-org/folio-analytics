package gotest

import (
	"fmt"
	"os"
	"path/filepath"

	"github.com/nassibnassar/goconfig/ini"
)

// readConfig reads and returns the configuration file ".ldptestsql", which it
// expects to find in the user's home directory.
func readConfig() (*ini.Config, error) {
	homedir, err := os.UserHomeDir()
	if err != nil {
		return nil,
			fmt.Errorf("Error reading configuration file: " +
				"Unable to determine home directory")
	}
	filename := filepath.Join(homedir, ".ldptestsql")
	config, err := ini.NewConfigFile(filename)
	if err != nil {
		return nil,
			fmt.Errorf("Error reading configuration file: %v", err)
	}
	return config, nil
}
