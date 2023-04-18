-- This derived table shows data of the fund distribution of the purchase order lines

DROP TABLE IF EXISTS po_lines_fund_distribution;

CREATE TABLE po_lines_fund_distribution AS
SELECT
    po_lines.id AS pol_id,
    json_extract_path_text(json_array_elements(po_lines.data->'fundDistribution'), 'fundId') AS pol_distr_fund_id,
    json_extract_path_text(json_array_elements(po_lines.data->'fundDistribution'), 'value') AS pol_distr_value,
    json_extract_path_text(json_array_elements(po_lines.data->'fundDistribution'), 'distributionType') AS pol_distr_type,
    json_extract_path_text(json_array_elements(po_lines.data->'fundDistribution'), 'code') AS pol_distr_code,
    json_extract_path_text(json_array_elements(po_lines.data->'fundDistribution'), 'encumbrance') AS pol_distr_encumbrance_id,
    json_extract_path_text(json_array_elements(po_lines.data->'fundDistribution'), 'expenseClassId') AS pol_distr_expense_class_id
FROM
    public.po_lines;

CREATE INDEX ON po_lines_fund_distribution (pol_id);

CREATE INDEX ON po_lines_fund_distribution (pol_distr_fund_id);

CREATE INDEX ON po_lines_fund_distribution (pol_distr_value);

CREATE INDEX ON po_lines_fund_distribution (pol_distr_type);

CREATE INDEX ON po_lines_fund_distribution (pol_distr_code);

CREATE INDEX ON po_lines_fund_distribution (pol_distr_encumbrance_id);

CREATE INDEX ON po_lines_fund_distribution (pol_distr_expense_class_id);

COMMENT ON COLUMN po_lines_fund_distribution.pol_id IS 'UUID identifying this purchase order line';

COMMENT ON COLUMN po_lines_fund_distribution.pol_distr_fund_id IS 'UUID of the fund associated with this fund distribution';

COMMENT ON COLUMN po_lines_fund_distribution.pol_distr_value IS 'The value of the cost to be applied to this fund';

COMMENT ON COLUMN po_lines_fund_distribution.pol_distr_type IS 'Percentage or amount type of the value property';

COMMENT ON COLUMN po_lines_fund_distribution.pol_distr_code IS 'The fund code';

COMMENT ON COLUMN po_lines_fund_distribution.pol_distr_encumbrance_id IS 'UUID of encumbrance record associated with this fund distribution';

COMMENT ON COLUMN po_lines_fund_distribution.pol_distr_expense_class_id IS 'UUID of the expense class associated with this fund distribution';

VACUUM ANALYZE po_lines_fund_distribution;
