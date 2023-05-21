--metadb:table po_lines_cost

-- These derived table extracts cost information on the purchase order line.

DROP TABLE IF EXISTS po_lines_cost;

CREATE TABLE po_lines_cost AS
SELECT
    pol.id AS pol_id,
    jsonb_extract_path_text(pol.jsonb, 'cost', 'listUnitPrice')::numeric(19,4) AS po_line_list_unit_price_phys,
    jsonb_extract_path_text(pol.jsonb, 'cost', 'quantityPhysical') AS po_line_quant_phys,
    jsonb_extract_path_text(pol.jsonb, 'cost', 'listUnitPriceElectronic')::numeric(19,4) AS po_line_list_unit_price_elec,
    jsonb_extract_path_text(pol.jsonb, 'cost', 'quantityElectronic') AS po_line_quant_elec,
    jsonb_extract_path_text(pol.jsonb, 'cost', 'additionalCost')::numeric(19,4) AS po_line_additional_cost,
    jsonb_extract_path_text(pol.jsonb, 'cost', 'currency') AS po_line_currency,
    jsonb_extract_path_text(pol.jsonb, 'cost', 'discount')::numeric(19,4) AS po_line_discount,
    jsonb_extract_path_text(pol.jsonb, 'cost', 'discountType') AS po_line_discount_type,
    jsonb_extract_path_text(pol.jsonb, 'cost', 'poLineEstimatedPrice')::numeric(19,4) AS po_line_estimated_price
FROM
    folio_orders.po_line AS pol;

CREATE INDEX ON po_lines_cost (pol_id);

CREATE INDEX ON po_lines_cost (po_line_list_unit_price_phys);

CREATE INDEX ON po_lines_cost (po_line_quant_phys);

CREATE INDEX ON po_lines_cost (po_line_list_unit_price_elec);

CREATE INDEX ON po_lines_cost (po_line_quant_elec);

CREATE INDEX ON po_lines_cost (po_line_additional_cost);

CREATE INDEX ON po_lines_cost (po_line_currency);

CREATE INDEX ON po_lines_cost (po_line_discount);

CREATE INDEX ON po_lines_cost (po_line_discount_type);

CREATE INDEX ON po_lines_cost (po_line_estimated_price);

COMMENT ON COLUMN po_lines_cost.pol_id IS 'purchaseOrders';

COMMENT ON COLUMN po_lines_cost.po_line_list_unit_price_phys IS 'The per-item list price for physical or resources of Other order format';

COMMENT ON COLUMN po_lines_cost.po_line_quant_phys IS 'Quantity of physical items or resources of Other order format in this purchase order line';

COMMENT ON COLUMN po_lines_cost.po_line_list_unit_price_elec IS 'The e-resource per-item list price';

COMMENT ON COLUMN po_lines_cost.po_line_quant_elec IS 'Quantity of electronic items in this purchase order line';

COMMENT ON COLUMN po_lines_cost.po_line_additional_cost IS 'Lump sum that is added to the total estimated price - not affected by discount';

COMMENT ON COLUMN po_lines_cost.po_line_currency IS 'An ISO currency code';

COMMENT ON COLUMN po_lines_cost.po_line_discount IS 'Percentage (0 to 100) or amount (positive number) that is subtracted from the list price time quantities calculation before additional cost';

COMMENT ON COLUMN po_lines_cost.po_line_discount_type IS 'Percentage or amount discount type';

COMMENT ON COLUMN po_lines_cost.po_line_estimated_price IS 'The calculated total estimated price for this purchase order line: list price time quantities minus discount amount plus additional cost';

