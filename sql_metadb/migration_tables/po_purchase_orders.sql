DROP TABLE IF EXISTS po_purchase_orders;

CREATE TABLE po_purchase_orders AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'approvalDate')::timestamptz AS approval_date,
    jsonb_extract_path_text(jsonb, 'approved')::boolean AS approved,
    jsonb_extract_path_text(jsonb, 'approvedById')::varchar(36) AS approved_by_id,
    jsonb_extract_path_text(jsonb, 'billTo')::varchar(36) AS bill_to,
    jsonb_extract_path_text(jsonb, 'dateOrdered')::timestamptz AS date_ordered,
    jsonb_extract_path_text(jsonb, 'manualPo')::boolean AS manual_po,
    jsonb_extract_path_text(jsonb, 'orderType')::varchar(65535) AS order_type,
    jsonb_extract_path_text(jsonb, 'poNumber')::varchar(65535) AS po_number,
    jsonb_extract_path_text(jsonb, 'reEncumber')::boolean AS re_encumber,
    jsonb_extract_path_text(jsonb, 'shipTo')::varchar(36) AS ship_to,
    jsonb_extract_path_text(jsonb, 'vendor')::varchar(36) AS vendor,
    jsonb_extract_path_text(jsonb, 'workflowStatus')::varchar(65535) AS workflow_status,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_orders.purchase_order;

