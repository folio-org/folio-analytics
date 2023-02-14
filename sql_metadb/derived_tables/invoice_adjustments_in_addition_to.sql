--metadb:table invoice_adjustments_in_addition_to

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
        jsonb_extract_path_text(adjustments.data, 'value')::numeric(19,4) AS adjustment_value
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

COMMENT ON COLUMN invoice_adjustments_in_addition_to.invoice_id IS 'UUID of this invoice';

COMMENT ON COLUMN invoice_adjustments_in_addition_to.adjustment_description IS 'List of invoice level adjustments. The adjustments can be pro-rated which are defined at the invoice level, but are applied to the invoice lines. A generic example is a shipping fee which should be spread out across all of the invoice lines so that all funds involved pay some portion of the fee.';

COMMENT ON COLUMN invoice_adjustments_in_addition_to.adjustment_prorate IS 'Displayed in invoice line per adjustment in toggled on in settings';

COMMENT ON COLUMN invoice_adjustments_in_addition_to.adjustment_relationToTotal IS 'Relationship of this adjustment to the total;In addition to: added to subtotal;Included in: reported as subtotal portion;Separate from:calculated from subtotal';

COMMENT ON COLUMN invoice_adjustments_in_addition_to.adjustment_type IS 'Adjustment type';

COMMENT ON COLUMN invoice_adjustments_in_addition_to.adjustment_value IS 'Adjustment value';

VACUUM ANALYZE invoice_adjustments_in_addition_to;
