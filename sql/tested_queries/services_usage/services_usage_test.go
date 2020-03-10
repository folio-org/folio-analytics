package circ_detail

import (
	"testing"

	"github.com/folio-org/ldp-analytics/gotest"
)

func TestQuery(t *testing.T) {

	gotest.RunTest(t, "services_usage.sql", "services_usage_result.csv")

}
