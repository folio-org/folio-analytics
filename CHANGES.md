* Added comments to public.sql for public_po_lines table

## 1.6.0

* Use `timestamptz` columns for data extracted from metadata
  `createdDate` fields.

* Updated LDP1 derived table `locations_service_points` to add
  documentation and remove unnecessary quotation marks and tabs.  Also
  ported to Metadb.
  
* A new derived table `finance_funds` for Metadb to show financial data.


## 1.5.0

* New derived table for LDP1, `instance_administrative_notes`,
  extracts administrative notes from instance records.

* Columns `finance_funds.fund_type_id` and
  `finance_transactions.description` added to `ldp_add_columns.conf`.

* LDP1 derived table `requests_items` updated to replace obsolete uses
  of `json_extract_path_text()`

* Added encumbrance status to LDP1 derived table
  `finance_transaction_purchase_order`.

* Added comments to derived tables: `agreements_custom_property`,
  `licenses_license_ext`, `finance_transaction_purchase_order`,
  `po_line_fund_distribution_transactions`,
  `agreements_subscription_agreement`,
  `agreements_subscription_agreement_entitlement`,
  `po_acq_unit_ids`, `invoice_voucher_lines_fund_distributions`,
  `po_lines_eresource`, `po_lines_details_subscription`, `po_ongoing`,
  `po_lines_er_mat_type`, `po_lines_phys_mat_type`,
  `agreements_subscription_agreement_org_ext`,
  `finance_transaction_invoices`, `invoice_adjustments_ext`,
  `invoice_adjustments_in_addition_to`, `po_lines_cost`,
  `agreements_package_content_item`, `holdings_administrative_notes`,
  `po_lines_physical`.

* Fixed error "Column reference `res_name` is ambiguous" in report
  `erm_agreement_package_content_item_list`.

* Ported derived table `invoice_lines_adjustments` from LDP1.

* Updated report query `erm_agreement_cancellation_dates` with
  improvements and to support schema changes in the source data.

* Deleted derived table `finance_po_inv_transactions`.

* Additional columns added to `ldp_add_columns.conf`:
  `finance_funds.fund_type_id` and `finance_transactions.description`.

* Fixed data type of column `created_date` in derived table
  `po_instance`.

* Added column `holding_id` and related locations at PO line level for
  derived table `po_lines_eresource`.

* Fixed timestamp data types in derived table `item_ext`.

* Removed field `pol_phys_volumes_description` from derived table
  `po_lines_physical`.

* Removed duplicate column `holdings_record_id` from derived table
  `items_holdings_instances`.

