DROP TABLE IF EXISTS invoice_adjustments_in_addition_to;

-- This query will return the invoice adjustments when they are "Not Prorated" and "In addition To"
CREATE TABLE invoice_adjustments_in_addition_to AS
WITH adjustments AS (
    SELECT
        id AS invoice_id,
        jsonb_extract_path_text(adjustments.data, 'description') AS adjustment_description,
        jsonb_extract_path_text(adjustments.data, 'prorate') AS adjustment_prorate,
        jsonb_extract_path_text(adjustments.data, 'relationToTotal') AS adjustment_relationToTotal,
        jsonb_extract_path_text(adjustments.data, 'type') AS adjustment_type,
        jsonb_extract_path_text(adjustments.data, 'value') ::numeric(19,4) AS adjustment_value
    FROM
        folio_invoice.invoices AS inv
        CROSS JOIN jsonb_array_elements(jsonb_extract_path(inv.jsonb, 'adjustments')) AS adjustments (data)
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

CREATE INDEX ON invoice_adjustments_in_addition_to (invoice_id);

CREATE INDEX ON invoice_adjustments_in_addition_to (adjustment_description);

CREATE INDEX ON invoice_adjustments_in_addition_to (adjustment_prorate);

CREATE INDEX ON invoice_adjustments_in_addition_to (adjustment_relationToTotal);

CREATE INDEX ON invoice_adjustments_in_addition_to (adjustment_type);

CREATE INDEX ON invoice_adjustments_in_addition_to (adjustment_value);

VACUUM ANALYZE invoice_adjustments_in_addition_to;
