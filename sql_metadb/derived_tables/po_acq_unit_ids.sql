--metadb:table po_acq_unit_ids
--metadb:require folio_orders.acquisitions_unit__t.id uuid
--metadb:require folio_orders.acquisitions_unit__t.name text

-- These derived table extracts aquisition unit ids from purchase
-- order table.

DROP TABLE IF EXISTS po_acq_unit_ids;

CREATE TABLE po_acq_unit_ids AS
    SELECT
        po.id AS po_id,
        po.po_number AS po_number,
        CAST(acq_unit_ids.jsonb #>> '{}' AS uuid) AS po_acquisition_unit_id,
        au.name AS po_acquisition_unit_name
    FROM
        folio_orders.purchase_order__t AS po
        LEFT JOIN folio_orders.purchase_order ON po.id = purchase_order.id
        CROSS JOIN jsonb_array_elements(jsonb_extract_path(purchase_order.jsonb, 'acqUnitIds')) WITH ORDINALITY AS acq_unit_ids (jsonb)
        LEFT JOIN folio_orders.acquisitions_unit__t AS au ON (acq_unit_ids.jsonb #>> '{}')::uuid = au.id;
    
CREATE INDEX ON po_acq_unit_ids (po_id);

CREATE INDEX ON po_acq_unit_ids (po_number);

CREATE INDEX ON po_acq_unit_ids (po_acquisition_unit_id);

CREATE INDEX ON po_acq_unit_ids (po_acquisition_unit_name);

COMMENT ON COLUMN po_acq_unit_ids.po_id IS 'UUID of this purchase order';

COMMENT ON COLUMN po_acq_unit_ids.po_number IS 'human readable ID assigned to this purchase order';

COMMENT ON COLUMN po_acq_unit_ids.po_acquisition_unit_id IS 'UUID of this acquisitions unit record';

COMMENT ON COLUMN po_acq_unit_ids.po_acquisition_unit_name IS 'Name for this acquisitions unit';

