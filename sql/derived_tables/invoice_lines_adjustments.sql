DROP TABLE IF EXISTS local.invoice_lines_adjustments;

-- These fields in adjustments can be locally defined
--
CREATE TABLE local.invoice_lines_adjustments AS
WITH adjustments AS (
    SELECT
        id AS invoice_line_id,
        json_extract_path_text(json_array_elements(json_extract_path(data, 'adjustments')), 'description') AS adjustment_description,
        json_extract_path_text(json_array_elements(json_extract_path(data, 'adjustments')), 'fundDistributions') AS adjustment_fund_distributions,
        json_extract_path_text(json_array_elements(json_extract_path(data, 'adjustments')), 'prorate') AS adjustment_prorate,
        json_extract_path_text(json_array_elements(json_extract_path(data, 'adjustments')), 'relationToTotal') AS adjustment_relationToTotal,
        json_extract_path_text(json_array_elements(json_extract_path(data, 'adjustments')), 'type') AS adjustment_type,
        json_extract_path_text(json_array_elements(json_extract_path(data, 'adjustments')), 'value') AS adjustment_value,
        json_extract_path_text(data, 'adjustmentsTotal') AS adjustment_adjustments_total
    FROM
        invoice_lines
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
    OR adjustment_relationToTotal = 'included'
    OR adjustment_relationToTotal = 'separate from';

CREATE INDEX ON local.invoice_lines_adjustments (invoice_line_id);

CREATE INDEX ON local.invoice_lines_adjustments (adjustment_description);

CREATE INDEX ON local.invoice_lines_adjustments (adjustment_fund_distributions);

CREATE INDEX ON local.invoice_lines_adjustments (adjustment_prorate);

CREATE INDEX ON local.invoice_lines_adjustments (adjustment_relationToTotal);

CREATE INDEX ON local.invoice_lines_adjustments (adjustment_type);

CREATE INDEX ON local.invoice_lines_adjustments (adjustment_value);

CREATE INDEX ON local.invoice_lines_adjustments (adjustment_adjustments_total);

VACUUM local.invoice_lines_adjustments;

ANALYZE local.invoice_lines_adjustments;

