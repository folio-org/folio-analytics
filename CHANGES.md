## 1.5.0
* A new derived table for LDP 1.x, `instance_administrative_notes`,
  extracts administrative notes from instance records.
* Additional columns added to `ldp_add_columns.conf`:
  `finance_funds.fund_type_id` and `finance_transactions.description`.
* Changed cast in po_instance.sql for created_date to ::timestamp:
  `json_extract_path_text(po_purchase_orders.data, 'metadata', 'createdDate')::timestamp AS created_date`
