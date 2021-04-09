--This query is for materials purchased, not other cost ACRL suggest may be included under "All other materials/services cost"
--This query provides a total amount of material expenditures, broken down by invoice lines and including any adjustment made at the invoice level.
--An export to Excel will provide the total amount paid by summing the 'total paid converted' column
/* FIELDS TO INCLUDE:
 Invoice table:
 Invoice ID
 Invoice approval date
 Invoice exchange rate
 Invoice currency
 *Payment Date* not developed yet, will need to add to this query   
 Invoice Line table:
 Invoice Line iD
 Invoice Line status
 Invoice Line adjustment value
 Invoice Line adjustment description
 Invoice line subtotal
 Invoice line value
 Invoice Lines total                 
 Purchase Order Table:
 Purchase order type
 Purchase order number
 Purchase Order Line Table:
 Purchase order line ID
 Purchase order line format 
 Finance Transactions table
 ID
 Source invoice ID
 Source invoice line ID
 Transaction amount
 Currency
 Transaction type
 Finance Fiscal Years table
 Fiscal year ID
 Fiscal year code      
 Derived tables folio_reporting:	
 Invoice_lines_adjustments
 invoice line adjustments description 
 Invoice line adjustmetn value	
 Instances_ext
 Instance ID
 Instance mode of issuance name
 Instance_formats
 Instance_format_name
 Invoices_ext	
 Invoice line value
 Invoice adjustment total value
 Invoice adjustment prorate
 Invoice adjustment relation to total
 Ratio of invoice adjustment per invoice line total
 Invoice adjustment total	
 Finance_transactions_invoices
 Transaction ID
 Transaction invoice ID
 Transaction invoice line ID
 Transaction amount
 Transaction Currency
 Transaction Type  
 Transaction Expense Class      		
 */
/* Change the lines below to filter or leave blank to return all results. Add details in '' for a specific filter.*/
WITH parameters AS (
    SELECT
        '2000-01-01'::date AS approval_date_start_date, --ex:2000-01-01
        '2021-12-31'::date AS approval_date_end_date, -- ex:2020-12-31
        '2000-01-01'::date AS payment_date_start_date, --ex:2000-01-01 'INVOICE PAYMENT DATE' IN DEVELOPMENT- USE WHEN BECOMES AVAILABLE
        '2021-12-31'::date AS payment_date_end_date, -- ex:2020-12-31 'INVOICE PAYMENT DATE' IN DEVELOPMENT- USE wHEN BECOMES AVAILABLE
        ''::varchar AS order_type, -- select 'One-Time' or 'Ongoing' or leave blank for both
        ''::varchar AS order_format, -- select 'Electronic Resource', 'Physical Resource', 'P/E Mix', 'Other' or leave blank for all
        ''::varchar AS instance_format_name, -- example: select e-resources vs physical (eg. "computer-online resource" for electronic resources or "Phycical Resource" for phycial resources)
        ''::varchar AS instance_mode_of_issuance, -- example: 'single unit', 'serial' etc.
        ''::varchar AS transaction_type -- example:'Payment', 'Pending payment'
        --		e-books: Example: select format name:computer-online resource and mode of isssuance: Multipart monograph or single unit
        --		e-journals: Example: select format name:computer-online resource and mode of isssuance: serial
        --		Could also use physical and electronic material type. To be dertermined when more data is available.
),
invl_transac_amount_total AS (
    --Provides sum of transactions per invoice_line
    SELECT
        invl.id AS invl_id,
        fti.transaction_fiscal_year_id AS fiscal_year_id,
        fy.code AS fiscal_year_code,
        sum(fti.transaction_amount)::numeric(12, 2) AS transaction_total_per_invl
    FROM
        invoice_lines AS invl
        LEFT JOIN folio_reporting.finance_transaction_invoices AS fti ON fti.invoice_line_id = invl.id
        LEFT JOIN finance_fiscal_years AS fy ON fy.id = fti.transaction_fiscal_year_id
    GROUP BY
        invl.id,
        fti.invoice_line_id,
        fti.transaction_fiscal_year_id,
        fy.code
),
inv_transac_amount_total AS (
    -- Provide invoice transaction not appearing in invoice_line, i.e. adjustment
    SELECT
        transaction_id AS transaction_id,
        transaction_expense_class_id AS transaction_expense_class_id,
        transaction_fiscal_year_id AS fiscal_year_id,
        invoice_id AS transaction_source_invoice_id,
        invoice_line_id AS transaction_source_invoice_line_id,
        transaction_amount AS transaction_amount,
        transaction_currency AS transaction_currency,
        fti.transaction_type
    FROM
        folio_reporting.finance_transaction_invocies AS fti
    WHERE
        invoice_line_id IS NULL
        AND invoice_id IS NOT NULL
        AND fti.transaction_type LIKE 'Payment'
),
invoice_adj_ratio AS (
    -- ratio per invoice_line to distribute transaction not associated with an invoice_line
    SELECT
        invoice_id AS invoice_id,
        invl_id AS invoice_line_id,
        ratio_of_inv_adj_per_invoice_line -- rounded to 2 decimals
    FROM
        folio_reporting.invoice_adjustments_ext)
    ---MAIN QUERY
 SELECT
   inv.id AS inv_id,
   pol.id AS pol_id,
   po.po_number AS po_number,
   po.order_type AS po_order_type,
   pol.order_format AS pol_order_format,
   ifo.format_name AS instance_format_name,
   pol_phys_type.pol_mat_type_name AS pol_mat_type_name,
   pol_er_type.pol_er_mat_type_name AS pol_er_mat_type_name,
   iext.mode_of_issuance_name AS instance_mode_of_isssuance,
   ita.transaction_expense_class_id,
   fec.name AS expense_classes_name,
   invl.invoice_line_status AS invl_status,
   inv.approval_date::date AS inv_approval_date,
   coalesce(invl.sub_total, 0) AS invl_sub_total,
   ila.adjustment_value AS invl_adjustment_value,
   ila.adjustment_description AS invl_adj_desc,
   coalesce(invl.total, 0)::numeric(12, 2) AS invl_value,
   coalesce(invadjext.invls_total, 0)::numeric(12, 2) AS invls_total, -- This is coming from the invoice_adjustments_ext table inv.exchange_rate::numeric(12, 3) AS inv_exchange_rate,
   inv.currency AS inv_currency,
   fti.transaction_type AS transaction_type,
   coalesce(invadjext.ratio_of_inv_adj_per_invoice_line, 0) * coalesce(ita.transaction_amount, 0)::numeric(12, 2) AS transaction_inv_adj_dist_converted,
   coalesce(ilta.transaction_total_per_invl, 0) AS transaction_amount_per_invl_converted,
   coalesce(ilta.transaction_total_per_invl, 0) + (coalesce(invadjext.ratio_of_inv_adj_per_invoice_line, 0) * coalesce(ita.transaction_amount, 0)) AS total_paid_converted
FROM
    invoice_invoices AS inv
    LEFT JOIN invoice_lines AS invl ON invl.invoice_id = inv.id
    LEFT JOIN po_lines AS pol ON pol.id = invl.po_line_id
    LEFT JOIN po_purchase_orders AS po ON pol.purchase_order_id = po.id
    LEFT JOIN folio_reporting.invoice_lines_adjustments AS ila ON ila.invoice_line_id = invl.id
    LEFT JOIN folio_reporting.instance_ext AS iext ON iext.instance_id = pol.instance_id
    LEFT JOIN folio_reporting.instance_formats AS ifo ON ifo.instance_id = iext.instance_id
    LEFT JOIN folio_reporting.invoice_adjustments_ext AS invadjext ON invadjext.invl_id = invl.id
    LEFT JOIN folio_reporting.po_lines_phys_mat_type AS pol_phys_type ON pol.id = pol_phys_type.pol_id
    LEFT JOIN folio_reporting.po_lines_er_mat_type AS pol_er_type ON pol.id = pol_er_type.pol_id
    LEFT JOIN folio_reporting.finance_transaction_invoices AS fti ON fti.invoice_line_id = invl.id
    LEFT JOIN invl_transac_amount_total AS ilta ON ilta.invl_id = invl.id
    LEFT JOIN inv_transac_amount_total AS ita ON ita.transaction_source_invoice_id = inv.id
    LEFT JOIN finance_expense_classes AS fec ON fec.id = ita.transaction_expense_class_id 
WHERE
    invl.invoice_line_status LIKE 'Paid'
    AND (inv.payment_date::date >= (SELECT payment_date_start_date FROM parameters))
    AND (inv.payment_date::date < (SELECT payment_date_end_date FROM parameters))
    AND (inv.payment_date >= (SELECT payment_date_start_date FROM parameters))
    AND (inv.payment_date < (SELECT payment_date_end_date FROM parameters))
    AND (po.order_type = (SELECT order_type FROM parameters) OR (SELECT order_type FROM parameters) = '')
    AND (pol.order_format = (SELECT order_format FROM parameters) OR (SELECT order_format FROM parameters) = '')
    AND (ifo.format_name = (SELECT instance_format_name FROM parameters) OR (SELECT instance_format_name FROM parameters) = '')
    AND (iext.mode_of_issuance_name = (SELECT instance_mode_of_issuance FROM parameters) OR (SELECT instance_mode_of_issuance FROM parameters) = '')
    AND (fti.transaction_type = (SELECT transaction_type FROM parameters) OR (SELECT transaction_type FROM parameters) = '')
GROUP BY
    po.order_type,
    pol.id,
    ifo.format_name,
    iext.mode_of_issuance_name,
    inv.id,
    invl.invoice_line_status,
    invl.sub_total,
    invl.total,
    ila.adjustment_value,
    ila.adjustment_description,
    po.po_number,
    invadjext.invls_total,
    pol_phys_type.pol_mat_type_name,
    pol_er_type.pol_er_mat_type_name,
    fti.transaction_type,
    ilta.transaction_total_per_invl,
    ita.transaction_amount,
    ita.transaction_expense_class_id,
    invadjext.ratio_of_inv_adj_per_invoice_line;

