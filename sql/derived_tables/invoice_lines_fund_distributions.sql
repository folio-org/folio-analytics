DROP TABLE IF EXISTS invoice_lines_fund_distributions;

-- Create a local table for Fund Distributions
CREATE TABLE invoice_lines_fund_distributions AS
WITH funds_distr AS (
    SELECT
        id AS invoice_line_id,
        dist.data #>> '{code}' AS fund_distribution_code,
        dist.data #>> '{fundId}' AS fund_distribution_id,
        dist.data #>> '{distributionType}' AS fund_distribution_type,
        (dist.data #>> '{value}')::numeric AS fund_distribution_value,
        (lines.data #>> '{subTotal}')::numeric(12,2) AS invoice_line_sub_total,
        (lines.data #>> '{total}')::numeric(12,2) AS invoice_line_total
    FROM
        invoice_lines AS lines
        CROSS JOIN jsonb_array_elements((data #> '{fundDistributions}')::jsonb) AS dist(data)
)
SELECT
    invoice_line_id AS invoice_line_id,
    fund_distribution_id AS fund_distribution_id,
    ff.data #>> '{fundStatus}' AS finance_fund_status,
    ff.data #>> '{code}' AS finance_fund_code,
    ff.data #>> '{name}' AS fund_name,
    ff.data #>> '{id}' AS fund_type_id,
    ft.data #>> '{name}' AS fund_type_name,
    fund_distribution_value AS fund_distribution_value,
    fund_distribution_type AS fund_distribution_type,
    invoice_line_sub_total AS invoice_line_sub_total,
    invoice_line_total AS invoice_line_total
FROM
    funds_distr
    LEFT JOIN finance_funds AS ff ON ff.id = funds_distr.fund_distribution_id
    LEFT JOIN finance_fund_types AS ft ON ft.id = ff.data #>> '{fundTypeId}';

