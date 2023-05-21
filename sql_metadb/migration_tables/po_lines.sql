DROP TABLE IF EXISTS po_lines;

CREATE TABLE po_lines AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'acquisitionMethod')::varchar(36) AS acquisition_method,
    jsonb_extract_path_text(jsonb, 'agreementId')::varchar(36) AS agreement_id,
    jsonb_extract_path_text(jsonb, 'automaticExport')::boolean AS automatic_export,
    jsonb_extract_path_text(jsonb, 'cancellationRestriction')::boolean AS cancellation_restriction,
    jsonb_extract_path_text(jsonb, 'cancellationRestrictionNote')::varchar(65535) AS cancellation_restriction_note,
    jsonb_extract_path_text(jsonb, 'checkinItems')::boolean AS checkin_items,
    jsonb_extract_path_text(jsonb, 'collection')::boolean AS collection,
    jsonb_extract_path_text(jsonb, 'description')::varchar(65535) AS description,
    jsonb_extract_path_text(jsonb, 'donor')::varchar(65535) AS donor,
    jsonb_extract_path_text(jsonb, 'edition')::varchar(65535) AS edition,
    jsonb_extract_path_text(jsonb, 'instanceId')::varchar(36) AS instance_id,
    jsonb_extract_path_text(jsonb, 'isPackage')::boolean AS is_package,
    jsonb_extract_path_text(jsonb, 'orderFormat')::varchar(65535) AS order_format,
    jsonb_extract_path_text(jsonb, 'paymentStatus')::varchar(65535) AS payment_status,
    jsonb_extract_path_text(jsonb, 'poLineDescription')::varchar(65535) AS po_line_description,
    jsonb_extract_path_text(jsonb, 'poLineNumber')::varchar(65535) AS po_line_number,
    jsonb_extract_path_text(jsonb, 'publicationDate')::varchar(65535) AS publication_date,
    jsonb_extract_path_text(jsonb, 'publisher')::varchar(65535) AS publisher,
    jsonb_extract_path_text(jsonb, 'purchaseOrderId')::varchar(36) AS purchase_order_id,
    jsonb_extract_path_text(jsonb, 'receiptDate')::timestamptz AS receipt_date,
    jsonb_extract_path_text(jsonb, 'receiptStatus')::varchar(65535) AS receipt_status,
    jsonb_extract_path_text(jsonb, 'requester')::varchar(65535) AS requester,
    jsonb_extract_path_text(jsonb, 'rush')::boolean AS rush,
    jsonb_extract_path_text(jsonb, 'selector')::varchar(65535) AS selector,
    jsonb_extract_path_text(jsonb, 'source')::varchar(65535) AS source,
    jsonb_extract_path_text(jsonb, 'titleOrPackage')::varchar(65535) AS title_or_package,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_orders.po_line;

ALTER TABLE po_lines ADD PRIMARY KEY (id);

CREATE INDEX ON po_lines (acquisition_method);

CREATE INDEX ON po_lines (agreement_id);

CREATE INDEX ON po_lines (automatic_export);

CREATE INDEX ON po_lines (cancellation_restriction);

CREATE INDEX ON po_lines (cancellation_restriction_note);

CREATE INDEX ON po_lines (checkin_items);

CREATE INDEX ON po_lines (collection);

CREATE INDEX ON po_lines (description);

CREATE INDEX ON po_lines (donor);

CREATE INDEX ON po_lines (edition);

CREATE INDEX ON po_lines (instance_id);

CREATE INDEX ON po_lines (is_package);

CREATE INDEX ON po_lines (order_format);

CREATE INDEX ON po_lines (payment_status);

CREATE INDEX ON po_lines (po_line_description);

CREATE INDEX ON po_lines (po_line_number);

CREATE INDEX ON po_lines (publication_date);

CREATE INDEX ON po_lines (publisher);

CREATE INDEX ON po_lines (purchase_order_id);

CREATE INDEX ON po_lines (receipt_date);

CREATE INDEX ON po_lines (receipt_status);

CREATE INDEX ON po_lines (requester);

CREATE INDEX ON po_lines (rush);

CREATE INDEX ON po_lines (selector);

CREATE INDEX ON po_lines (source);

CREATE INDEX ON po_lines (title_or_package);

