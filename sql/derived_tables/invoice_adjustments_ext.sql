DROP TABLE IF EXISTS folio_reporting.invoice_adjustments_ext;

-- This table includes the percentage of the invoice lines amount in relation to the invoice_line total to calculate the invoice adjustment by row
CREATE TABLE folio_reporting.invoice_adjustments_ext AS
WITH invl_total AS (
    SELECT
        inv.id AS inv_id,
        sum(invl.total) ::numeric(12, 2) AS invl_total
    FROM
        invoice_invoices AS inv
        LEFT JOIN invoice_lines AS invl ON inv.id = invl.invoice_id
    GROUP BY
        inv_id
)
SELECT
    inv.id AS invoice_id,
    invl.id AS invl_id,
    COALESCE (invl.total, 0) AS invoice_line_value,
    COALESCE (invadj.adjustment_value, 0) AS inv_adjust_total_value, --This is the total of the invoice adjustment
    invltotal.invl_total AS "invls_total",
    invadj.adjustment_prorate AS inv_adj_prorate,
    invadj.adjustment_relationtototal AS inv_adj_relationToTotal,
    CASE WHEN invltotal.invl_total IS NULL
        OR invltotal.invl_total = 0 THEN
        0
    ELSE
        COALESCE (invl.total, 0) / invltotal.invl_total
    END AS perc_of_inv_adj_per_invoice_line,
    --Above: This is the percentage of the invoice adjustment per invoice line
    CASE WHEN invltotal.invl_total IS NULL
        OR invltotal.invl_total = 0 THEN
        0
    ELSE
        invadj.adjustment_value * (COALESCE(invl.total, 0) / invltotal.invl_total)
    END AS inv_adj_total
    --Above:  This is the adjustment at the invoice line level, taking into consideration the total percentage per invoice line.
FROM
    invoice_invoices AS inv
    LEFT JOIN invoice_lines AS invl ON json_extract_path_text(invl.data, 'invoiceId') = inv.id
    LEFT JOIN folio_reporting.invoice_adjustments_in_addition_to AS invadj ON invadj.invoice_id = inv.id
    LEFT JOIN invl_total AS invltotal ON inv.id = invltotal.inv_id
GROUP BY
    inv.id,
    invl_id,
    inv_adj_relationToTotal,
    invadj.adjustment_prorate,
    invadj.adjustment_value,
    invl.total,
    invltotal.invl_total;

CREATE INDEX ON folio_reporting.invoice_adjustments_ext (invoice_id);

CREATE INDEX ON folio_reporting.invoice_adjustments_ext (invl_id);

CREATE INDEX ON folio_reporting.invoice_adjustments_ext (invoice_line_value);

CREATE INDEX ON folio_reporting.invoice_adjustments_ext (inv_adjust_total_value);

CREATE INDEX ON folio_reporting.invoice_adjustments_ext (invls_total);

CREATE INDEX ON folio_reporting.invoice_adjustments_ext (inv_adj_prorate);

CREATE INDEX ON folio_reporting.invoice_adjustments_ext (inv_adj_relationToTotal);

CREATE INDEX ON folio_reporting.invoice_adjustments_ext (perc_of_inv_adj_per_invoice_line);

CREATE INDEX ON folio_reporting.invoice_adjustments_ext (inv_adj_total);

