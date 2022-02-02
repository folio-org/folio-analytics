DROP TABLE IF EXISTS po_lines_details_subscription;

-- Create a local table for subscription details in po_lines.
CREATE TABLE po_lines_details_subscription AS
SELECT
    pol.id AS pol_id,
    json_extract_path_text(data, 'details', 'subscriptionFrom')::date AS pol_subscription_from,
    json_extract_path_text(data, 'details', 'subscriptionTo')::date AS pol_subscription_to,
    json_extract_path_text(data, 'details', 'subscriptionInterval') AS pol_subscription_interval
FROM
    po_lines AS pol;

CREATE INDEX ON po_lines_details_subscription (pol_id);

CREATE INDEX ON po_lines_details_subscription (pol_subscription_from);

CREATE INDEX ON po_lines_details_subscription (pol_subscription_to);

CREATE INDEX ON po_lines_details_subscription (pol_subscription_interval);

