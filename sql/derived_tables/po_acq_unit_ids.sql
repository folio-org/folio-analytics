DROP TABLE IF EXISTS po_acq_unit_ids;

-- These fields in adjustments can be locally defined
CREATE TABLE po_acq_unit_ids AS
WITH po_acq_unit AS (
    SELECT
        id AS po_id,
        po_purchase_orders.data->>'poNumber' AS po_number,
	acq_unit_ids.data #>> '{}' AS po_acq_unit_id
    FROM
        po_purchase_orders
        CROSS JOIN jsonb_array_elements((data->'acqUnitIds')::jsonb) AS acq_unit_ids (data)
)
SELECT
    po_acq_unit.po_id AS po_id,
    po_acq_unit.po_number,
    po_acq_unit.po_acq_unit_id AS po_acquisition_unit_id,
    acquisitions_units.data->>'name' AS po_acquisition_unit_name
FROM
    po_acq_unit
    LEFT JOIN acquisitions_units ON acquisitions_units.id = po_acq_unit.po_acq_unit_id;

