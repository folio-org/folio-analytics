--metadb:table po_notes
--Creates a derived table to show all notes attached to purchase orders, including general notes, renewal notes, and notes when purchase order is closed. 

DROP TABLE IF EXISTS po_notes;
CREATE TABLE po_notes AS
SELECT
po.id AS po_id,
(po.jsonb -> 'metadata' ->> 'createdDate')::timestamptz AS created_date,
po.jsonb ->> 'poNumber' AS po_number,
po.jsonb ->> 'workflowStatus' AS po_workflow_status,
po_notes.jsonb #>> '{}' AS po_note,
po_notes.ORDINALITY AS po_note_ordinality,
po.jsonb -> 'closeReason' ->> 'note' AS po_close_reason_note,
po.jsonb -> 'ongoing' ->> 'renewalNote' AS po_renewal_note
FROM folio_orders.purchase_order AS po
CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(po.jsonb, 'notes')) WITH ORDINALITY AS po_notes (jsonb)
;

COMMENT ON COLUMN po_notes.po_id IS 'UUID of purchase order';

COMMENT ON COLUMN po_notes.created_date IS 'Purchase Order creation date and time';

COMMENT ON COLUMN po_notes.po_number IS 'Purchase order number';

COMMENT ON COLUMN po_notes.po_workflow_status IS 'workflow status of the purchase order';

COMMENT ON COLUMN po_notes.po_note IS 'Purchase order note';

COMMENT ON COLUMN po_notes.po_note_ordinality IS 'The ordinality of the note';

COMMENT ON COLUMN po_notes.po_close_reason_note IS 'Notes entered when a purchase order is closed';

COMMENT ON COLUMN po_notes.po_renewal_note IS 'Notes entered in the ongoing order information';
