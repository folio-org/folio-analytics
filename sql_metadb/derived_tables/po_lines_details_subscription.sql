DROP TABLE IF EXISTS po_lines_details_subscription;

-- Create a local table for subscription details in po_lines.
CREATE TABLE po_lines_details_subscription AS
SELECT
    pol.id AS pol_id,
    jsonb_extract_path_text(jsonb, 'details', 'subscriptionFrom')::timestamptz AS pol_subscription_from,
    jsonb_extract_path_text(jsonb, 'details', 'subscriptionTo')::timestamptz AS pol_subscription_to,
    jsonb_extract_path_text(jsonb, 'details', 'subscriptionInterval')::int AS pol_subscription_interval
FROM
    folio_orders.po_line AS pol;

CREATE INDEX ON po_lines_details_subscription (pol_id);

CREATE INDEX ON po_lines_details_subscription (pol_subscription_from);

CREATE INDEX ON po_lines_details_subscription (pol_subscription_to);

CREATE INDEX ON po_lines_details_subscription (pol_subscription_interval);


VACUUM ANALYZE  po_lines_details_subscription;
