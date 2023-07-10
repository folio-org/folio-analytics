DROP TABLE IF EXISTS po_ongoing;

-- Create a local table for ongoing details in purchase orders.
CREATE TABLE po_ongoing AS
SELECT
    po.id AS po_id,
    (data #>> '{ongoing,interval}')::integer AS po_ongoing_interval,
    (data #>> '{ongoing,isSubscription}')::boolean AS po_ongoing_is_subscription,
    (data #>> '{ongoing,manualRenewal}')::boolean AS po_ongoing_manual_renewal,
    (data #>> '{ongoing,renewalDate}')::timestamptz AS po_ongoing_renewal_date,
    (data #>> '{ongoing,reviewPeriod}')::integer AS po_ongoing_review_period
FROM
    po_purchase_orders AS po;

