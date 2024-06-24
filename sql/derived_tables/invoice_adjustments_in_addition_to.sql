DROP TABLE IF EXISTS invoice_adjustments_in_addition_to;

-- This query will return the invoice adjustments when they are "Not Prorated" and "In addition To"
CREATE TABLE invoice_adjustments_in_addition_to AS
WITH adjustments AS (
    SELECT
        id AS invoice_id,
        adjustments.data #>> '{description}' AS adjustment_description,
        adjustments.data #>> '{prorate}' AS adjustment_prorate,
        adjustments.data #>> '{relationToTotal}' AS adjustment_relationToTotal,
        adjustments.data #>> '{type}' AS adjustment_type,
        (adjustments.data #>> '{value}')::numeric(12,2) AS adjustment_value
    FROM
        invoice_invoices AS inv
        CROSS JOIN LATERAL jsonb_array_elements((data #> '{adjustments}')::jsonb) AS adjustments (data)
)
SELECT
    invoice_id,
    adjustment_description,
    adjustment_prorate,
    adjustment_relationToTotal,
    adjustment_type,
    adjustment_value
FROM
    adjustments
WHERE
    adjustment_relationToTotal = 'In addition to'
    AND adjustment_prorate = 'Not prorated';

