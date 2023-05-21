--metadb:table invoice_lines_fund_distributions

-- Creates a derived table to extract fund_distributions from invoice_lines 
-- and join fund-related tables.

DROP TABLE IF EXISTS invoice_lines_fund_distributions;

CREATE TABLE invoice_lines_fund_distributions AS
WITH fdist AS (
    SELECT
        id AS invoice_line_id,
        jsonb_extract_path_text(dist.data, 'code') AS fund_distribution_code,
        jsonb_extract_path_text(dist.data, 'fundId')::uuid AS fund_distribution_id,
        jsonb_extract_path_text(dist.data, 'distributionType') AS fund_distribution_type,
        jsonb_extract_path_text(dist.data, 'value')::numeric(19,4) AS fund_distribution_value,
        jsonb_extract_path_text(lines.jsonb, 'subTotal')::numeric(19,4) AS invoice_line_sub_total,
        jsonb_extract_path_text(lines.jsonb, 'total')::numeric(19,4) AS invoice_line_total
    FROM
        folio_invoice.invoice_lines AS lines
        CROSS JOIN jsonb_array_elements(jsonb_extract_path(lines.jsonb, 'fundDistributions')) AS dist(data)
)
SELECT
    fdist.invoice_line_id AS invoice_line_id,
    fdist.fund_distribution_id AS fund_distribution_id,
    f.fund_status,
    f.code AS fund_code,
    f.name AS fund_name,
    t.id AS fund_type_id,
    t.name AS fund_type_name,
    fdist.fund_distribution_value,
    fdist.fund_distribution_type,
    fdist.invoice_line_sub_total,
    fdist.invoice_line_total
FROM
    fdist
    LEFT JOIN folio_finance.fund__t AS f ON f.id = fdist.fund_distribution_id
    LEFT JOIN folio_finance.fund_type__t AS t ON t.id = f.fund_type_id::uuid;

CREATE INDEX ON invoice_lines_fund_distributions (invoice_line_id);

CREATE INDEX ON invoice_lines_fund_distributions (fund_distribution_id);

CREATE INDEX ON invoice_lines_fund_distributions (fund_status);

CREATE INDEX ON invoice_lines_fund_distributions (fund_code);

CREATE INDEX ON invoice_lines_fund_distributions (fund_name);

CREATE INDEX ON invoice_lines_fund_distributions (fund_type_id);

CREATE INDEX ON invoice_lines_fund_distributions (fund_type_name);

CREATE INDEX ON invoice_lines_fund_distributions (fund_distribution_value);

CREATE INDEX ON invoice_lines_fund_distributions (fund_distribution_type);

CREATE INDEX ON invoice_lines_fund_distributions (invoice_line_sub_total);

CREATE INDEX ON invoice_lines_fund_distributions (invoice_line_total);

COMMENT ON COLUMN invoice_lines_fund_distributions.invoice_line_id IS 'UUID of the invoice line associated with this fund distribution';

COMMENT ON COLUMN invoice_lines_fund_distributions.fund_distribution_id IS 'UUID of the fund distribution';

COMMENT ON COLUMN invoice_lines_fund_distributions.fund_status IS 'The current status of this fund';

COMMENT ON COLUMN invoice_lines_fund_distributions.fund_code IS 'The code of the fund associated with this fund distribution';

COMMENT ON COLUMN invoice_lines_fund_distributions.fund_name IS 'The name of the fund associated with this fund distribution';

COMMENT ON COLUMN invoice_lines_fund_distributions.fund_type_id IS 'UUID of the fund type associated with this fund';

COMMENT ON COLUMN invoice_lines_fund_distributions.fund_type_name IS 'The name of this fund type';

COMMENT ON COLUMN invoice_lines_fund_distributions.fund_distribution_value IS 'The percentage of the cost to be applied to this fund';

COMMENT ON COLUMN invoice_lines_fund_distributions.fund_distribution_type IS 'Percentage or amount type of the value property';

COMMENT ON COLUMN invoice_lines_fund_distributions.invoice_line_sub_total IS 'Invoice line amount before adjustments are applied';

COMMENT ON COLUMN invoice_lines_fund_distributions.invoice_line_total IS 'Invoice line total amount which is sum of subTotal and adjustmentsTotal. This amount is always calculated by system.';

