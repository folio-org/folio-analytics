DROP TABLE IF EXISTS po_lines_details_subscription;

-- Create a local table for subscription details in po_lines.
CREATE TABLE po_lines_details_subscription AS
SELECT
    pol.id AS pol_id,
    (data #>> '{details,subscriptionFrom}')::date AS pol_subscription_from,
    (data #>> '{details,subscriptionTo}')::date AS pol_subscription_to,
    data #>> '{details,subscriptionInterval}' AS pol_subscription_interval
FROM
    po_lines AS pol;

