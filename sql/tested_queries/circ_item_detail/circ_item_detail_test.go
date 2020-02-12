package circ_detail

import (
	"testing"

	"github.com/folio-org/ldp-analytics/gotest"
)

func TestQuery(t *testing.T) {

	gotest.RunTest(t, "circ_item_detail.sql", "circ_item_detail_result.csv")

}
