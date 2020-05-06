package missing_items

import (
	"testing"

	"github.com/folio-org/ldp-analytics/gotest"
)

func TestQuery(t *testing.T) {

	gotest.RunTest(t, "missing_items.sql", "missing_items_result.csv")

}
