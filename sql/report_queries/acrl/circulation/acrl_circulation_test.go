package acrl_circulation

import (
	"testing"

	"github.com/folio-org/folio-analytics/gotest"
)

func TestQuery(t *testing.T) {

	gotest.RunTest(t, "acrl_circulation.sql", "acrl_circulation_result.csv")

}
