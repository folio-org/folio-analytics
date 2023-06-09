DROP TABLE IF EXISTS po_lines_cost;

-- Create table for cost information on the purchase order line
CREATE TABLE po_lines_cost AS
SELECT
    pol.id AS pol_id,
    pol.data->'cost'->>'listUnitPrice' AS po_lines_list_unit_price_phys,
    pol.data->'cost'->>'quantityPhysical' AS po_lines_quant_phys,
    pol.data->'cost'->>'listUnitPriceElectronic' AS po_lines_list_unit_price_elec,
    pol.data->'cost'->>'quantityElectronic' AS po_lines_quant_elec,
    pol.data->'cost'->>'additionalCost' AS po_lines_additional_cost,
    pol.data->'cost'->>'currency' AS po_lines_currency,
    pol.data->'cost'->>'discount' AS po_lines_discount,
    pol.data->'cost'->>'discountType' AS po_lines_discount_type,
    pol.data->'cost'->>'poLineEstimatedPrice' AS po_lines_estimated_price
FROM
    po_lines AS pol;

