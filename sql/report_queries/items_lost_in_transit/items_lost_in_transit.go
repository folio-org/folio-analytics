package items_lost_in_transit

import (
	"testing"

	"github.com/folio-org/folio-analytics/gotest"
)

func TestQuery(t *testing.T) {

	gotest.RunTest(t, "items_lost_in_transit.sql", "items_lost_in_transit_result.csv")

}
