-- This table includes the ratio of the invoice lines amount in
-- relation to the invoice_line total to calculate the invoice
-- adjustment by row

DROP TABLE IF EXISTS invoice_adjustments_ext;

CREATE TABLE invoice_adjustments_ext AS
WITH invl_total AS (
    SELECT
        inv.id AS inv_id,
        sum((invl.data #>> '{total}')::numeric(12,2)) AS invl_total
    FROM
        invoice_invoices AS inv
        LEFT JOIN invoice_lines AS invl ON inv.id::uuid = (invl.data #>> '{invoiceId}')::uuid
    GROUP BY
        inv_id
)
SELECT
    inv.id AS invoice_id,
    invl.id AS invl_id,
    coalesce((invl.data #>> '{total}')::numeric(12,2), 0) AS invoice_line_value,
    fintrainvl.transaction_amount AS transaction_invoice_line_value, --This is invoice_line_value in system currency
    coalesce(invadj.adjustment_value, 0) AS inv_adjust_total_value, 
    fintrainv.transaction_amount AS transaction_invoice_adj_value, --This is inv_adjust_total_value in system currency
    invltotal.invl_total AS "invls_total",
    invadj.adjustment_prorate AS inv_adj_prorate,
    invadj.adjustment_relationtototal AS inv_adj_relationToTotal,
    CASE WHEN invltotal.invl_total IS NULL
        OR invltotal.invl_total = 0 THEN
        0.0000
    ELSE
        round(coalesce((invl.data #>> '{total}')::numeric(12,2), 0) / invltotal.invl_total, 4)
    END AS ratio_of_inv_adj_per_invoice_line,
    --Above: This is the ratio of the invoice adjustment per invoice line
    CASE WHEN invadj.adjustment_value IS NULL
        OR invltotal.invl_total IS NULL
        OR invltotal.invl_total = 0 THEN
        0.0000
    ELSE
        round(invadj.adjustment_value * (coalesce((invl.data #>> '{total}')::numeric(12,2), 0) / invltotal.invl_total), 4)
    END AS inv_adj_total,
    --Above: This is the adjustment at the invoice line level, taking
    --into consideration the total ratio per invoice line.
    CASE WHEN fintrainv.transaction_amount IS NULL
        OR invltotal.invl_total IS NULL
        OR invltotal.invl_total = 0 THEN
        0.0000
    ELSE
        round(fintrainv.transaction_amount * (coalesce((invl.data #>> '{total}')::numeric(12,2), 0) / invltotal.invl_total), 4)
    END AS transactions_inv_adj_total
    --Above: This is the adjustment at the invoice line level, taking
    --into consideration the total ratio per invoice line. IN SYSTEM
    --CURRENCY.
FROM
    invoice_invoices AS inv
    LEFT JOIN invoice_lines AS invl ON (invl.data #>> '{invoiceId}')::uuid = inv.id::uuid
    LEFT JOIN invoice_adjustments_in_addition_to AS invadj ON invadj.invoice_id = inv.id
    LEFT JOIN invl_total AS invltotal ON inv.id = invltotal.inv_id
    LEFT JOIN finance_transaction_invoices AS fintrainv ON fintrainv.invoice_id = inv.id AND fintrainv.invoice_line_id IS NULL
    LEFT JOIN finance_transaction_invoices AS fintrainvl ON fintrainvl.invoice_line_id::text = invl.id::text
GROUP BY
    inv.id,
    invl_id,
    inv_adj_relationToTotal,
    invadj.adjustment_prorate,
    invadj.adjustment_value,
    (invl.data #>> '{total}')::numeric(12,2),
    invltotal.invl_total,
    transaction_invoice_line_value,
    transaction_invoice_adj_value;

