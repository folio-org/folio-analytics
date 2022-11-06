## 1.5.0

* New derived table for LDP1, `instance_administrative_notes`,
  extracts administrative notes from instance records.

* Columns `finance_funds.fund_type_id` and
  `finance_transactions.description` added to `ldp_add_columns.conf`.

* LDP1 derived table `requests_items` updated to replace obsolete uses
  of `json_extract_path_text()`

* Added comments to derived tables `agreements_custom_property` and
  `licenses_license_ext.`.

* Fixed error "Column reference `res_name` is ambiguous" in report
  `erm_agreement_package_content_item_list`.

* Updated report query `erm_agreement_cancellation_dates` with
  improvements and to support schema changes in the source data.

* Deleted derived table `finance_po_inv_transactions`.

* Additional columns added to `ldp_add_columns.conf`:
  `finance_funds.fund_type_id` and `finance_transactions.description`.

