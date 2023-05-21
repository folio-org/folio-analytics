--metadb:table invoice_lines_adjustments

-- This table includes the extracted adjustments data on the invoice
-- line level.  The field description can be locally defined by
-- institutions.  Examples are "shipping", "VAT" (MwSt), "Service
-- Charge".  The adjustment fund distribution data array will be
-- extracted from the invoice_lines table in a separate derived table
-- called invoice_lines_adjustments_fund_distributions in a future
-- release.

DROP TABLE IF EXISTS invoice_lines_adjustments;

CREATE TABLE invoice_lines_adjustments AS
WITH adjustments AS (
    SELECT
        id AS invoice_line_id,
        jsonb_extract_path_text(adjustments.data, 'description') AS adjustment_description,
        jsonb_extract_path_text(adjustments.data, 'prorate') AS adjustment_prorate,
        jsonb_extract_path_text(adjustments.data, 'relationToTotal') AS adjustment_relation_to_total,
        jsonb_extract_path_text(adjustments.data, 'type') AS adjustment_type,
        jsonb_extract_path_text(adjustments.data, 'value')::numeric(19,4) AS adjustment_value,
        jsonb_extract_path_text(invl.jsonb, 'adjustmentsTotal')::numeric(12,2) AS adjustment_adjustments_total
    FROM
        folio_invoice.invoice_lines AS invl
        CROSS JOIN jsonb_array_elements(jsonb_extract_path(invl.jsonb, 'adjustments'))
            AS adjustments(data)
)
SELECT
    invoice_line_id,
    adjustment_description,
    adjustment_prorate,
    adjustment_relation_to_total,
    adjustment_type,
    adjustment_value,
    adjustment_adjustments_total
FROM
    adjustments
WHERE
    adjustment_relation_to_total IN ('In addition to', 'Included', 'Separate from');

CREATE INDEX ON invoice_lines_adjustments (invoice_line_id);

CREATE INDEX ON invoice_lines_adjustments (adjustment_description);

CREATE INDEX ON invoice_lines_adjustments (adjustment_prorate);

CREATE INDEX ON invoice_lines_adjustments (adjustment_relation_to_total);

CREATE INDEX ON invoice_lines_adjustments (adjustment_type);

CREATE INDEX ON invoice_lines_adjustments (adjustment_value);

CREATE INDEX ON invoice_lines_adjustments (adjustment_adjustments_total);

COMMENT ON COLUMN invoice_lines_adjustments.invoice_line_id IS 'UUID of this invoice line id';

COMMENT ON COLUMN invoice_lines_adjustments.adjustment_description IS 'List of invoice level adjustments. The adjustments can be pro-rated which are defined at the invoice level, but are applied to the invoice lines. A generic example is a shipping fee which should be spread out across all of the invoice lines so that all funds involved pay some portion of the fee.';

COMMENT ON COLUMN invoice_lines_adjustments.adjustment_prorate IS 'Displayed in invoice line per adjustment in toggled on in settings';

COMMENT ON COLUMN invoice_lines_adjustments.adjustment_relation_to_total IS 'Relationship of this adjustment to the total';

COMMENT ON COLUMN invoice_lines_adjustments.adjustment_type IS 'Adjustment type';

COMMENT ON COLUMN invoice_lines_adjustments.adjustment_value IS 'Adjustment value';

COMMENT ON COLUMN invoice_lines_adjustments.adjustment_adjustments_total IS 'Total amount which is sum of all invoice line adjustments and all non-prorated invoice level adjustments. This amount is always calculated by system.';


