DROP TABLE IF EXISTS po_ongoing;

-- Create a derived table for ongoing details in purchase orders.

CREATE TABLE po_ongoing AS
SELECT
    po.id AS po_id,
    jsonb_extract_path_text(jsonb, 'ongoing', 'interval')::int AS po_ongoing_interval,
    jsonb_extract_path_text(jsonb, 'ongoing', 'isSubscription')::boolean AS po_ongoing_is_subscription,
    jsonb_extract_path_text(jsonb, 'ongoing', 'manualRenewal')::boolean AS po_ongoing_manual_renewal,
    jsonb_extract_path_text(jsonb, 'ongoing', 'renewalDate')::timestamptz AS po_ongoing_renewal_date,
    jsonb_extract_path_text(jsonb, 'ongoing', 'reviewPeriod')::int AS po_ongoing_review_period
FROM
    folio_orders.purchase_order AS po;

CREATE INDEX ON po_ongoing (po_id);

CREATE INDEX ON po_ongoing (po_ongoing_interval);

CREATE INDEX ON po_ongoing (po_ongoing_is_subscription);

CREATE INDEX ON po_ongoing (po_ongoing_manual_renewal);

CREATE INDEX ON po_ongoing (po_ongoing_renewal_date);

CREATE INDEX ON po_ongoing (po_ongoing_review_period);

VACUUM ANALYZE po_ongoing;

