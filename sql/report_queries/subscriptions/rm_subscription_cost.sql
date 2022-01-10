
/*This query provides the cost of Active Subscriptions. In order to get Active subscriptions, the order needs to be 'Ongoing' and the Workflow status 'Open'.
Please note that workflow status as "Pending" should also be considered, since it may be the status carried over from the data migration.

TABLES used:
Po_Lines
Po_purchase_orders
Invoice_invoices
Invoice_lines
invl_transac_amount_total
inv_transac_amount_total
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
 folio_reporting.po_lines_tags
 folio_reporting.invoice_adjustments_ext AS invadjext ON invadjext.invl_id = invl.id
*/

WITH parameters AS (
    SELECT
        -- POSSIBLE FILTERS-- USE EXACT TERM, CASE SENSITIVE.
        '2019-01-01'::DATE AS invoice_payment_date_start_date,--ex:2000-01-01
        '2022-12-31'::DATE AS invoice_payment_date_end_date,-- ex:2020-01-01
        ''::VARCHAR AS po_workflow_status,-- select 'Closed', 'Open', 'Pending' or leave blank for all.
        ''::VARCHAR AS pol_receipt_status,-- select 'Pending', 'Ongoing', 'Partially Received', 'Fully Received', 'Cancelled', 'Awaiting Receipt', 'Receipt Not Required' etc. or leave blank for all.
        ''::VARCHAR AS inst_nature_of_content,-- select 'journal', 'newspaper' etc. or leave blank for all.
        ''::VARCHAR AS pol_order_format-- select 'Electronic Resource', 'Physical Resource', 'P/E Mix', 'Other' or leave blank for all
),
     invl_transac_amount_total AS( --Provides sum of transactions per invoice_line
         SELECT
             invl.id AS invoice_line_id,
             sum(ft.amount) ::numeric(12, 2) AS transaction_total_per_invl
         FROM
             finance_transactions AS ft
                 LEFT JOIN invoice_lines AS invl ON invl.id = ft.source_invoice_line_id
                 LEFT JOIN invoice_invoices AS inv ON inv.id = invl.invoice_id
         WHERE transaction_type = 'Payment'
         GROUP BY
             invl.id
     ),
     inv_transac_amount_total AS ( -- Provide invoice transaction not appearing in invoice_line, i.e. adjustment
         SELECT
             id AS transaction_id,
             json_extract_path_text(ft.data, 'expenseClassId') AS transaction_expense_class_id,
             fiscal_year_id AS fiscal_year_id,
             source_invoice_id AS transaction_source_invoice_id,
             source_invoice_line_id AS transaction_source_invoice_line_id,
             amount AS transaction_amount,
             currency AS transaction_currency,
             ft.transaction_type AS transaction_type

         FROM finance_transactions AS ft
         WHERE
             source_invoice_line_id IS NULL
           AND source_invoice_id IS NOT NULL
           AND ft.transaction_type LIKE 'Payment'
     ),
     invoice_adj_ratio AS ( -- ratio per invoice_line to distribute transaction not associated with an invoice_line
         SELECT
             invoice_id AS invoice_id,
             invl_id AS invoice_line_id,
             ratio_of_inv_adj_per_invoice_line AS ratio_of_inv_adj_per_invoice_line -- rounded to 2 decimals
         FROM folio_reporting.invoice_adjustments_ext
     )
SELECT
    poorg.org_name AS vendor_name,
    pol.title_or_package AS pol_title_or_package,
    pol.is_package AS pol_is_package,
    polt.pol_tag AS po_line_tags,
    acquisition_method AS pol_acq_method,
    poi.title AS instance_title,
    ppo.po_number AS po_number,
    pol.po_line_number AS po_line_number,
    fti.invoice_line_id AS inv_line_id,
    inv.vendor_invoice_no AS vendor_inv_no,
    poacq.po_acquisition_unit_name AS po_acq_unit_name,
    inc.nature_of_content_term_name AS nature_of_content_name,
    pol.receipt_status AS pol_receipt_status,-- could be use to provide journal and newspaper breakdown
    ppo.workflow_status AS po_workflow_status,
    polp.pol_mat_type_name AS pol_phys_mat_type_name,
    pole.pol_er_mat_type_name AS pol_er_mat_type_name,
    pol.order_format AS pol_order_format,
    ppo.approval_date::date AS po_approval_date,
    pol.payment_status AS pol_payment_status,
    fti.invoice_payment_date::date AS invoice_payment_date,
    ppo.approved_by_id AS po_approved_by_id,
    ppo.bill_to AS po_bill_to,
    poong.po_ongoing_interval AS po_ongoing_interval,
    poong.po_ongoing_renewal_date AS po_ongoing_renewal_date,
    poong.po_ongoing_review_period AS po_ongoing_review_period,
    pols.pol_subscription_from AS pol_subscription_from,
    pols.pol_subscription_to AS pol_subscription_to,
    COALESCE(invadjext.ratio_of_inv_adj_per_invoice_line,0) * coalesce(ita.transaction_amount,0)::numeric(12,2) AS transaction_inv_adj_dist_converted,
    COALESCE(ilta.transaction_total_per_invl,0) AS transaction_amount_per_invl_converted,
    COALESCE(ilta.transaction_total_per_invl,0) + (COALESCE(invadjext.ratio_of_inv_adj_per_invoice_line,0) * COALESCE(ita.transaction_amount,0)) AS total_paid_converted
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
        LEFT JOIN invoice_invoices AS inv ON inv.id = fti.invoice_id
        LEFT JOIN invoice_lines AS invl ON invl.invoice_id = inv.id
        LEFT JOIN folio_reporting.invoice_adjustments_ext AS invadjext ON invadjext.invl_id = invl.id
        LEFT JOIN invl_transac_amount_total AS ilta ON ilta.invoice_line_id = invl.id
        LEFT JOIN inv_transac_amount_total AS ita ON ita.transaction_source_invoice_id = inv.id
WHERE
    (fti.invoice_payment_date::date >= (SELECT invoice_payment_date_start_date FROM parameters))
  AND (fti.invoice_payment_date ::date < (SELECT invoice_payment_date_end_date FROM parameters))
  AND po_ongoing_is_subscription = 'true'
  AND ppo.order_type = 'Ongoing'
  AND ppo.workflow_status = 'Open'
  AND (ppo.workflow_status = (SELECT po_workflow_status FROM parameters) OR (SELECT po_workflow_status FROM parameters) = '')
  AND (pol.receipt_status = (SELECT pol_receipt_status FROM parameters) OR (SELECT pol_receipt_status FROM parameters) = '')
  AND (inc.nature_of_content_term_name = (SELECT inst_nature_of_content FROM parameters) OR (SELECT inst_nature_of_content FROM parameters) = '')
  AND (pol.order_format = (SELECT pol_order_format FROM parameters) OR (SELECT pol_order_format FROM parameters) = '')
GROUP BY
    pol.title_or_package,
    poorg.org_name,
    pol.po_line_number,
    ppo.po_number,
    ppo.approval_date,
    ppo.bill_to,
    pol.acquisition_method,
    inc.nature_of_content_term_name,-- could be use to provide journal and newspaper breakdown
    pol.payment_status,
    pol.receipt_status,
    ppo.workflow_status,
    ppo.approved_by_id,
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
    polt.pol_tag,
    poorg.po_number,
    fti.invoice_id,
    inv.vendor_invoice_no,
    fti.invoice_line_id,
    invl.total,
    ilta.transaction_total_per_invl,
    invadjext.ratio_of_inv_adj_per_invoice_line,
    ita.transaction_amount
ORDER BY pol.po_line_number;