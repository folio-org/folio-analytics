/*In order to get active subscriptions, the purchase order type needs to be 'Ongoing', the order workflow status 'Open', and the order IsSubscription 'true'.
Please note that a different workflow status should also be considered if your active subscriptions migrated to a different status.
Since an electronic subscriptions may have multiple PO lines, the count will be per PO lines.
Note that in this report, the count value will be 1 per row, since each row corresponds to a PO line/Title.

TABLES used:
Po_Lines
Po_purchase_orders
DERIVED TABLES:
 folio_reporting.finance_transaction_invoices
 folio_reporting.po_ongoing poong
 folio_reporting.po_organization poorg
 folio_reporting.po_lines_phys_mat_type
 folio_reporting.po_lines_er_mat_type
 folio_reporting.po_lines_details_subscription
 folio_reporting.po_instance
 folio_reporting.instance_ext
 folio_reporting.instance_nature_content
 folio_reporting.po_acq_unit_ids
 folio_reporting.po_lines_tags polt
*/

WITH parameters AS (
    SELECT
        -- POSSIBLE FILTERS-- USE EXACT TERM, CASE SENSITIVE.
        '2019-01-01'::DATE AS invoice_payment_date_start_date,--ex:2000-01-01
        '2022-12-31'::DATE AS invoice_payment_date_end_date,-- ex:2020-01-01
        ''::VARCHAR AS po_workflow_status,-- Should be 'Open'  If there is a need to filter by other order status, comment out hard coded filter first.
        ''::VARCHAR AS pol_receipt_status,-- select 'Pending', 'Ongoing', 'Partially Received', 'Fully Received', 'Cancelled', 'Awaiting Receipt', 'Receipt Not Required' etc. or leave blank for all.
        ''::VARCHAR AS inst_nature_of_content,-- select 'journal', 'newspaper' etc. or leave blank for all.
        ''::VARCHAR AS pol_order_format-- select 'Electronic Resource', 'Physical Resource', 'P/E Mix', 'Other' or leave blank for all
)
SELECT
    poorg.org_name AS vendor_name,
    pol.title_or_package AS pol_title_or_package,
    pol.is_package AS pol_is_package,
    polt.pol_tag AS po_line_tags,
    acquisition_method AS pol_acq_method,
    poi.title AS instance_title,
    ppo.po_number AS po_number,
    pol.po_line_number AS pol_number,
    pol.receipt_status AS pol_receipt_status,
    ppo.workflow_status AS po_workflow_status,
    poacq.po_acquisition_unit_name AS po_acq_unit_name,
    inc.nature_of_content_term_name AS nature_of_content,-- should provide journal and newspaper
    polp.pol_mat_type_name AS pol_phys_mat_type_name,
    pole.pol_er_mat_type_name AS pol_er_mat_type_name,
    pol.order_format AS pol_order_format,
    ppo.approval_date::date AS po_approval_date,
    pol.payment_status AS pol_payment_status,
    fti.invoice_payment_date::date AS invoice_payment_date,
    poong.po_ongoing_interval AS po_ongoing_interval,
    poong.po_ongoing_renewal_date AS po_ongoing_renewal_date,
    poong.po_ongoing_review_period AS po_ongoing_review_period,
    pols.pol_subscription_from AS pol_subscription_from,
    pols.pol_subscription_to AS pol_subscription_to,
    COUNT(DISTINCT pol.po_line_number) AS "Subscription count"
FROM
    po_lines AS pol
        LEFT JOIN po_purchase_orders AS ppo ON pol.purchase_order_id = ppo.id
        LEFT JOIN folio_reporting.finance_transaction_invoices AS fti ON fti.po_line_id = pol.id
        LEFT JOIN folio_reporting.po_ongoing poong ON ppo.id = poong.po_id
        LEFT JOIN folio_reporting.po_organization poorg ON ppo.po_number = poorg.po_number
        LEFT JOIN folio_reporting.po_lines_phys_mat_type AS polp ON polp.pol_id = pol.id
        LEFT JOIN folio_reporting.po_lines_er_mat_type AS pole ON pole.pol_id = pol.id
        LEFT JOIN folio_reporting.po_lines_details_subscription AS pols ON pols.pol_id = pol.id
        LEFT JOIN folio_reporting.po_instance AS poi ON poi.po_line_number = pol.po_line_number
        LEFT JOIN folio_reporting.instance_ext AS iext ON iext.instance_id = pol.instance_id
        LEFT JOIN folio_reporting.instance_nature_content AS inc ON inc.instance_id = iext.instance_id
        LEFT JOIN folio_reporting.po_acq_unit_ids AS poacq ON poacq.po_number = ppo.po_number
        LEFT JOIN folio_reporting.po_lines_tags polt ON polt.pol_id = pol.id
WHERE
    (fti.invoice_payment_date::date >= (SELECT invoice_payment_date_start_date FROM parameters))
  AND (fti.invoice_payment_date ::date < (SELECT invoice_payment_date_end_date FROM parameters))
  AND po_ongoing_is_subscription = 'true'
  AND ppo.order_type = 'Ongoing'
  AND ppo.workflow_status = 'Open'-- comment out if using filter parameter
  AND (ppo.workflow_status = (SELECT po_workflow_status FROM parameters) OR (SELECT po_workflow_status FROM parameters) = '')
  AND (pol.receipt_status = (SELECT pol_receipt_status FROM parameters) OR (SELECT pol_receipt_status FROM parameters) = '')
  AND (inc.nature_of_content_term_name = (SELECT inst_nature_of_content FROM parameters) OR (SELECT inst_nature_of_content FROM parameters) = '')
  AND (pol.order_format = (SELECT pol_order_format FROM parameters) OR (SELECT pol_order_format FROM parameters) = '')
GROUP BY
    poorg.org_name,
    pol.title_or_package,
    pol.po_line_number,
    pol.receipt_status,
    ppo.po_number,
    ppo.approval_date,
    pol.acquisition_method,
    inc.nature_of_content_term_name,
    pol.payment_status,
    ppo.workflow_status,
    fti.invoice_payment_date,
    poong.po_ongoing_interval,
    poong.po_ongoing_renewal_date,
    poong.po_ongoing_review_period,
    pols.pol_subscription_from,
    pols.pol_subscription_to,
    poi.title,
    poacq.po_acquisition_unit_name,
    pol.is_package,
    polp.pol_mat_type_name,
    pole.pol_er_mat_type_name,
    pol.order_format,
    polt.pol_tag;