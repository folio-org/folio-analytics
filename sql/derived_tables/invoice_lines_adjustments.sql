DROP TABLE IF EXISTS invoice_lines_adjustments;

-- This table includes the extracted adjustments data on the invoice
-- line level.  The field description can be locally defined by the
-- institutions.  Examples are "shipping", "VAT" (MwSt), "Service
-- Charge".
CREATE TABLE invoice_lines_adjustments AS
WITH adjustments AS (
    SELECT
        id AS invoice_line_id,
        adjustments.data #>> '{description}' AS adjustment_description,
        adjustments.data #>> '{fundDistributions}' AS adjustment_fund_distributions,
        adjustments.data #>> '{prorate}' AS adjustment_prorate,
        adjustments.data #>> '{relationToTotal}' AS adjustment_relationToTotal,
        adjustments.data #>> '{type}' AS adjustment_type,
        adjustments.data #>> '{value}' AS adjustment_value,
        (invoice_lines.data #>> '{adjustmentsTotal}')::numeric(12,2) AS adjustment_adjustments_total
    FROM
        invoice_lines
        CROSS JOIN LATERAL jsonb_array_elements((data #> '{adjustments}')::jsonb)
            AS adjustments(data)
)
SELECT
    invoice_line_id,
    adjustment_description,
    adjustment_fund_distributions,
    adjustment_prorate,
    adjustment_relationToTotal,
    adjustment_type,
    adjustment_value,
    adjustment_adjustments_total
FROM
    adjustments
WHERE
    adjustment_relationToTotal = 'In addition to'
    OR adjustment_relationToTotal = 'Included'
    OR adjustment_relationToTotal = 'Separate from';

