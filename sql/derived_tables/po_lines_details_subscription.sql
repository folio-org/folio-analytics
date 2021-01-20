DROP TABLE IF EXISTS folio_reporting.po_lines_details_subscription;

CREATE TABLE folio_reporting.po_lines_details_subscription AS
/* Subquery to extract nested JSON data */
WITH temp_pol_detail_subs AS (
    SELECT
        pol.id AS pol_id,
        json_extract_path_text(data, 'details', 'subscriptionFrom') ::DATE AS pol_subscription_from,
        json_extract_path_text(data, 'details', 'subscriptionTo') ::DATE AS pol_subscription_to,
        json_extract_path_text(data, 'details', 'subscriptionInterval') AS pol_subscription_interval
    FROM
        po_lines AS pol
)
/* Main query */
SELECT
    pol_subs.pol_id,
    pol_subs.pol_subscription_from AS pol_subscription_from,
    pol_subs.pol_subscription_to AS pol_subscription_to,
    pol_subs.pol_subscription_interval AS pol_subscription_interval
FROM
    temp_pol_detail_subs AS pol_subs;

CREATE INDEX ON folio_reporting.po_lines_details_subscription (pol_id);

CREATE INDEX ON folio_reporting.po_lines_details_subscription (pol_subscription_from);

CREATE INDEX ON folio_reporting.po_lines_details_subscription (pol_subscription_to);

CREATE INDEX ON folio_reporting.po_lines_details_subscription (pol_subscription_interval);

