--metadb:table po_ongoing

-- Create a derived table for ongoing details in purchase orders.

DROP TABLE IF EXISTS po_ongoing;

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

COMMENT ON COLUMN po_ongoing.po_id IS 'UUID of this purchase order';

COMMENT ON COLUMN po_ongoing.po_ongoing_interval IS 'The subscription interval in days';

COMMENT ON COLUMN po_ongoing.po_ongoing_is_subscription IS 'Whether or not this is a subscription';

COMMENT ON COLUMN po_ongoing.po_ongoing_manual_renewal IS 'Whether or not this is a manual renewal';

COMMENT ON COLUMN po_ongoing.po_ongoing_renewal_date IS 'The date this Ongoing PO''s order lines were renewed';

COMMENT ON COLUMN po_ongoing.po_ongoing_review_period IS 'Time prior to renewal where changes can be made to subscription';

VACUUM ANALYZE po_ongoing;
