-- This derived table shows data of the fund distribution of the
-- purchase order lines.

DROP TABLE IF EXISTS po_lines_fund_distribution;

CREATE TABLE po_lines_fund_distribution AS
SELECT p.id AS po_lines_id,
       f.data #>> '{code}' AS code,
       f.data #>> '{distributionType}' AS distribution_type,
       (f.data #>> '{encumbrance}')::uuid AS encumbrance,
       (f.data #>> '{expenseClassId}')::uuid AS expense_class_id,
       (f.data #>> '{fundId}')::uuid AS fund_id,
       (f.data #>> '{value}')::numeric(19, 4) AS value,
       f.ordinality
    FROM public.po_lines AS p
        CROSS JOIN LATERAL jsonb_array_elements((data #> '{fundDistribution}')::jsonb) WITH ORDINALITY
            AS f (data);

CREATE INDEX ON po_lines_fund_distribution (po_lines_id);

CREATE INDEX ON po_lines_fund_distribution (encumbrance);

CREATE INDEX ON po_lines_fund_distribution (expense_class_id);

CREATE INDEX ON po_lines_fund_distribution (fund_id);

COMMENT ON COLUMN po_lines_fund_distribution.po_lines_id IS 'UUID identifying this purchase order line';

COMMENT ON COLUMN po_lines_fund_distribution.code IS 'The fund code';

COMMENT ON COLUMN po_lines_fund_distribution.distribution_type IS 'Percentage or amount type of the value property';

COMMENT ON COLUMN po_lines_fund_distribution.encumbrance IS 'UUID of encumbrance record associated with this fund distribution';

COMMENT ON COLUMN po_lines_fund_distribution.expense_class_id IS 'UUID of the expense class associated with this fund distribution';

COMMENT ON COLUMN po_lines_fund_distribution.fund_id IS 'UUID of the fund associated with this fund distribution';

COMMENT ON COLUMN po_lines_fund_distribution.value IS 'The value of the cost to be applied to this fund';
