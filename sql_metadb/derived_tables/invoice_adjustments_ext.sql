DROP TABLE IF EXISTS invoice_adjustments_ext;

-- This table includes the ratio of the invoice lines amount in relation to the invoice_line total to calculate the invoice adjustment by row
CREATE TABLE invoice_adjustments_ext AS
WITH invl_total AS (
    SELECT
        inv.id AS inv_id,
        sum(jsonb_extract_path_text(invl.jsonb, 'total')::numeric(19,4)) AS invl_total
    FROM
        folio_invoice.invoices AS inv
        LEFT JOIN folio_invoice.invoice_lines AS invl ON inv.id = jsonb_extract_path_text(invl.jsonb, 'invoiceId')::uuid
    GROUP BY
        inv_id
)
SELECT
    inv.id AS invoice_id,
    invl.id AS invl_id,
    coalesce(jsonb_extract_path_text(invl.jsonb, 'total')::numeric(19,4), 0) AS invoice_line_value,
    fintrainvl.transaction_amount::numeric(19,4) AS transaction_invoice_line_value, --This is invoice_line_value in system currency
    coalesce(invadj.adjustment_value, 0::numeric(19,4)) AS inv_adjust_total_value, 
    fintrainv.transaction_amount::numeric(19,4) AS transaction_invoice_adj_value, --This is inv_adjust_total_value in system currency
    invltotal.invl_total::numeric(19,4) AS invls_total,
    invadj.adjustment_prorate AS inv_adj_prorate,
    invadj.adjustment_relationtototal AS inv_adj_relationToTotal,
    CASE WHEN invltotal.invl_total IS NULL
        OR invltotal.invl_total = 0 THEN
        0.0000
    ELSE
        round(coalesce(jsonb_extract_path_text(invl.jsonb, 'total')::numeric(19,4), 0) / invltotal.invl_total, 4)
    END AS ratio_of_inv_adj_per_invoice_line,
    --Above: This is the ratio of the invoice adjustment per invoice line
    CASE WHEN invadj.adjustment_value IS NULL
        OR invltotal.invl_total IS NULL
        OR invltotal.invl_total = 0 THEN
        0.0000
    ELSE
        round(invadj.adjustment_value * (coalesce(jsonb_extract_path_text(invl.jsonb, 'total')::numeric(19,4), 0) / invltotal.invl_total), 4)
    END AS inv_adj_total,
    --Above:  This is the adjustment at the invoice line level, taking into consideration the total ratio per invoice line.
    CASE WHEN fintrainv.transaction_amount IS NULL
        OR invltotal.invl_total IS NULL
        OR invltotal.invl_total = 0 THEN
        0.0000
    ELSE
        round(fintrainv.transaction_amount::numeric(19,4) * (coalesce(jsonb_extract_path_text(invl.jsonb, 'total')::numeric(19,4), 0) / invltotal.invl_total), 4)
    END AS transactions_inv_adj_total
    --Above:  This is the adjustment at the invoice line level, taking into consideration the total ratio per invoice line. IN SYSTEM CURRENCY.
FROM
    folio_invoice.invoices AS inv
    LEFT JOIN folio_invoice.invoice_lines AS invl ON jsonb_extract_path_text(invl.jsonb, 'invoiceId')::uuid = inv.id
    LEFT JOIN invoice_adjustments_in_addition_to AS invadj ON invadj.invoice_id = inv.id
    LEFT JOIN invl_total AS invltotal ON inv.id = invltotal.inv_id
    LEFT JOIN finance_transaction_invoices AS fintrainv ON fintrainv.invoice_id = inv.id AND fintrainv.invoice_line_id IS NULL
    LEFT JOIN finance_transaction_invoices AS fintrainvl ON fintrainvl.invoice_line_id = invl.id
GROUP BY
    inv.id,
    invl_id,
    inv_adj_relationToTotal,
    invadj.adjustment_prorate,
    invadj.adjustment_value,
    jsonb_extract_path_text(invl.jsonb, 'total')::numeric(19,4),
    invltotal.invl_total,
    transaction_invoice_line_value,
    transaction_invoice_adj_value;

CREATE INDEX ON invoice_adjustments_ext (invoice_id);

CREATE INDEX ON invoice_adjustments_ext (invl_id);

CREATE INDEX ON invoice_adjustments_ext (invoice_line_value);

CREATE INDEX ON invoice_adjustments_ext (inv_adjust_total_value);

CREATE INDEX ON invoice_adjustments_ext (invls_total);

CREATE INDEX ON invoice_adjustments_ext (inv_adj_prorate);

CREATE INDEX ON invoice_adjustments_ext (inv_adj_relationToTotal);

CREATE INDEX ON invoice_adjustments_ext (ratio_of_inv_adj_per_invoice_line);

CREATE INDEX ON invoice_adjustments_ext (inv_adj_total); 

COMMENT ON COLUMN invoice_adjustments_ext.invoice_id IS 'UUID of this invoice';

COMMENT ON COLUMN invoice_adjustments_ext.invl_id IS 'UUID of the invoice line associated with this fund distribution';

COMMENT ON COLUMN invoice_adjustments_ext.invoice_line_value IS 'The percentage of the cost to be applied to this fund';

COMMENT ON COLUMN invoice_adjustments_ext.inv_adjust_total_value IS 'Total adjustment amount';

COMMENT ON COLUMN invoice_adjustments_ext.invls_total IS 'Invoice line total amount which is sum of subTotal and adjustmentsTotal. This amount is always calculated by system.';

COMMENT ON COLUMN invoice_adjustments_ext.inv_adj_prorate IS 'Displayed in invoice line per adjustment in toggled on in settings';

COMMENT ON COLUMN invoice_adjustments_ext.inv_adj_relationToTotal IS 'Relationship of this adjustment to the total;In addition to: added to subtotal;Included in: reported as subtotal portion;Separate from:calculated from subtotal';

COMMENT ON COLUMN invoice_adjustments_ext.ratio_of_inv_adj_per_invoice_line IS 'This is the ratio of the invoice adjustment per invoice line';

COMMENT ON COLUMN invoice_adjustments_ext.inv_adj_total IS 'This is the adjustment at the invoice line level, taking into consideration the total ratio per invoice line.';

COMMENT ON COLUMN invoice_adjustments_ext.transaction_invoice_line_value IS 'This is invoice_line_value in system currency';

COMMENT ON COLUMN invoice_adjustments_ext.transaction_invoice_adj_value IS 'This is inv_adjust_total_value in system currency';

COMMENT ON COLUMN invoice_adjustments_ext.transactions_inv_adj_total IS 'This is the adjustment at the invoice line level, taking into consideration the total ratio per invoice line. IN SYSTEM CURRENCY';

VACUUM ANALYZE invoice_adjustments_ext;
