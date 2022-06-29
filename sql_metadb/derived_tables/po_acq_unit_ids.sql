-- These derived table extracts aquisition unit ids from purchase order table.
DROP TABLE IF EXISTS po_acq_unit_ids;

CREATE TABLE po_acq_unit_ids AS
    SELECT
        po.id AS po_id,
        po.po_number AS po_number,
        CAST(acq_unit_ids.jsonb #>> '{}' AS uuid) AS po_acquisition_unit_id,
        au.name AS po_acquisition_unit_name
    FROM
        folio_orders.purchase_order__t AS po
        LEFT JOIN folio_orders.purchase_order AS pur ON po.id = pur.id
        CROSS JOIN jsonb_array_elements(jsonb_extract_path(pur.jsonb, 'acqUnitIds')) WITH ORDINALITY AS acq_unit_ids (jsonb)
        LEFT JOIN folio_orders.acquisitions_unit__t AS au ON (acq_unit_ids.jsonb #>> '{}')::uuid = au.id ;
    
CREATE INDEX ON po_acq_unit_ids (po_id);

CREATE INDEX ON po_acq_unit_ids (po_number);

CREATE INDEX ON po_acq_unit_ids (po_acquisition_unit_id);

CREATE INDEX ON po_acq_unit_ids (po_acquisition_unit_name);


VACUUM ANALYZE  po_acq_unit_ids;
