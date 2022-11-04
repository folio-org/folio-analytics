## 1.5.0

* Deleted pol_phys_volumes_description field from select, indexes and comments.
* Added comments to all columns for derived table po_lines_physical.sql.
* A new derived table for LDP 1.x, `instance_administrative_notes`,
  extracts administrative notes from instance records.
* Additional columns added to `ldp_add_columns.conf`:
  `finance_funds.fund_type_id` and `finance_transactions.description`.
