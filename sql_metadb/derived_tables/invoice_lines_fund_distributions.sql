--invoice_lines_fund_distributions

DROP TABLE IF EXISTS invoice_lines_fund_distributions;

CREATE TABLE invoice_lines_fund_distributions AS
WITH funds_distr AS (
    SELECT
        id AS invoice_line_id,
        jsonb_extract_path_text(dist.data, 'code') AS fund_distribution_code,
        jsonb_extract_path_text(dist.data, 'fundId')::uuid AS fund_distribution_id,
        jsonb_extract_path_text(dist.data, 'distributionType') AS fund_distribution_type,
        jsonb_extract_path_text(dist.data, 'value')::numeric AS fund_distribution_value,
        jsonb_extract_path_text(lines.jsonb, 'subTotal')::numeric(12,2) AS invoice_line_sub_total,
        jsonb_extract_path_text(lines.jsonb, 'total')::numeric(12,2) AS invoice_line_total
    FROM
        folio_invoice.invoice_lines AS lines
        CROSS JOIN jsonb_array_elements(jsonb_extract_path(lines.jsonb, 'fundDistributions')) AS dist(data)
)
SELECT
    invoice_line_id AS invoice_line_id,
    fund_distribution_id AS fund_distribution_id,
    ff.fund_status,
    ff.code AS fund_code,
    ff.name AS fund_name,
    ft.id AS fund_type_id,
    ft.name AS fund_type_name,
    fund_distribution_value,
    fund_distribution_type,
    invoice_line_sub_total,
    invoice_line_total 
FROM
    funds_distr
    LEFT JOIN folio_finance.fund__t AS ff ON ff.id = funds_distr.fund_distribution_id
    LEFT JOIN folio_finance.fund_type__t AS ft ON ft.id = ff.fund_type_id::uuid
   ;

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

VACUUM ANALYZE invoice_lines_fund_distributions;
