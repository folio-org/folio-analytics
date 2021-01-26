DROP TABLE IF EXISTS local.nancybolduc_invoice__adjustments_ext;

-- This table includes the percentage of the invoice lines amount in relation to the invoice_line total to calculate the invoice adjutment by row
CREATE TABLE local.nancybolduc_invoice_adjustments_ext AS
WITH invl_total AS (

SELECT 
inv.id AS inv_id,
sum(invl.total) AS invl_total

FROM INVOICE_INVOICES AS inv
	LEFT JOIN invoice_lines AS invl ON inv.id = invl.invoice_id
GROUP BY 
 inv_id
 

)
SELECT 
	inv.id AS invoice_id,
	invl.id AS invl_id,
	CASE WHEN invl.total IS NULL THEN 0
		ELSE invl.total END AS invoice_line_value,
	CASE WHEN invadj.adjustment_value::decimal IS NULL THEN 0 
		ELSE invadj.adjustment_value::decimal END AS inv_adjust_total_value,--This is the total of the invoice adjustment
	invltotal.invl_total,
	invadj.adjustment_prorate AS inv_adj_prorate,
	invadj.adjustment_relationtototal AS inv_adj_relationToTotal,
	invl.total::decimal / sum(invl.total::decimal) AS perc_of_inv_adj_per_invoice_line,--This is the percentage of the invoice adjustment per invoice line
	CASE WHEN invl.total IS NULL THEN invadj.adjustment_value::decimal ELSE invadj.adjustment_value::decimal * (invl.total::decimal / sum(invl.total::decimal)) END AS inv_adj_total
	--Above:  This is the adjustment at the invoice line level, taking into consideration the total percentage per invoice line.
FROM 
	invoice_invoices AS inv
	LEFT JOIN invoice_lines AS invl ON invl.invoice_id = inv.id 
	LEFT JOIN LOCAL.NANCYBOLDUC_INVOICE_ADJUSTMENT_IN_ADDITION_TO AS invadj ON invadj.invoice_id = inv.id
	LEFT JOIN invl_total AS invltotal ON inv.id = invltotal.inv_id
GROUP BY 
inv.id,
invl_id,
inv_adj_relationToTotal,
invadj.adjustment_prorate,
invadj.adjustment_value,
invltotal.invl_total;

CREATE INDEX ON local.nancybolduc_invoice_adjustments_ext (invoice_id);

CREATE INDEX ON local.nancybolduc_invoice_adjustments_ext (invl_id);

CREATE INDEX ON local.nancybolduc_invoice_adjustments_ext (invoice_line_value);

CREATE INDEX ON local.nancybolduc_invoice_adjustments_ext (inv_adjust_total_value);

CREATE INDEX ON local.nancybolduc_invoice_adjustments_ext (invl_total);

CREATE INDEX ON local.nancybolduc_invoice_adjustments_ext (inv_adj_prorate);

CREATE INDEX ON local.nancybolduc_invoice_adjustments_ext (inv_adj_relationToTotal);

CREATE INDEX ON local.nancybolduc_invoice_adjustments_ext (perc_of_inv_adj_per_invoice_line);

CREATE INDEX ON local.nancybolduc_invoice_adjustments_ext (inv_adj_total);