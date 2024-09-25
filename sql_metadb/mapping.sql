CREATE DATA MAPPING FOR json
    FROM TABLE folio_audit.acquisition_order_line_log__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_audit.acquisition_order_log__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_audit.circulation_logs__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_calendar.actual_opening_hours__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_calendar.audit_actual_opening_hours__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_calendar.audit_openings__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_calendar.audit_regular_hours__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_calendar.openings__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_calendar.regular_hours__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_circulation.audit_loan__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_circulation.cancellation_reason__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_circulation.check_in__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_circulation.circulation_rules__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_circulation.fixed_due_date_schedule__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_circulation.loan__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_circulation.loan_policy__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_circulation.patron_action_session__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_circulation.patron_notice_policy__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_circulation.request__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_circulation.request_policy__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_circulation.scheduled_notice__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_circulation.staff_slips__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_circulation.user_request_preference__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_copycat.profile__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_email.email_statistics__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_feesfines.accounts__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_feesfines.comments__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_feesfines.feefineactions__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_feesfines.feefines__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_feesfines.lost_item_fee_policy__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_feesfines.manualblocks__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_feesfines.overdue_fine_policy__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_feesfines.owners__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_feesfines.payments__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_feesfines.refunds__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_feesfines.waives__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_finance.budget__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_finance.budget_expense_class__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_finance.expense_class__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_finance.fiscal_year__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_finance.fund__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_finance.fund_type__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_finance.group_fund_fiscal_year__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_finance.groups__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_finance.invoice_transaction_summaries__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_finance.ledger__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_finance.ledger_fiscal_year_rollover__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_finance.ledger_fiscal_year_rollover_budget__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_finance.ledger_fiscal_year_rollover_error__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_finance.ledger_fiscal_year_rollover_progress__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_finance.order_transaction_summaries__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_finance.temporary_invoice_transactions__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_finance.temporary_order_transactions__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_finance.transaction__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_inventory.alternative_title_type__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_inventory.audit_holdings_record__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_inventory.audit_instance__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_inventory.audit_item__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_inventory.authority_source_file__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_inventory.call_number_type__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_inventory.classification_type__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_inventory.contributor_name_type__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_inventory.contributor_type__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_inventory.electronic_access_relationship__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_inventory.holdings_note_type__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_inventory.holdings_record__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_inventory.holdings_records_source__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_inventory.holdings_type__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_inventory.hrid_settings__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_inventory.identifier_type__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_inventory.instance__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_inventory.instance_format__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_inventory.instance_note_type__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_inventory.instance_relationship_type__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_inventory.instance_status__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_inventory.instance_type__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_inventory.item__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_inventory.item_damaged_status__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_inventory.item_note_type__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_inventory.loan_type__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_inventory.location__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_inventory.loccampus__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_inventory.locinstitution__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_inventory.loclibrary__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_inventory.material_type__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_inventory.mode_of_issuance__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_inventory.nature_of_content_term__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_inventory.preceding_succeeding_title__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_inventory.service_point__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_inventory.service_point_user__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_inventory.statistical_code__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_inventory.statistical_code_type__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_invoice.batch_groups__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_invoice.batch_voucher_export_configs__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_invoice.documents__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_invoice.invoice_lines__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_invoice.invoices__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_invoice.voucher_lines__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_invoice.vouchers__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_notes.note_data__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_notes.note_type__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_notify.notify_data__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_orders.acquisition_method__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_orders.order_invoice_relationship__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_orders.order_templates__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_orders.pieces__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_orders.po_line__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_orders.purchase_order__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_orders.reasons_for_closure__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_orders.titles__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_organizations.categories__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_organizations.contacts__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_organizations.interface_credentials__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_organizations.interfaces__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_organizations.organizations__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_organizations.organization_types__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_permissions.permissions__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_permissions.permissions_users__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_users.addresstype__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_users.custom_fields__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_users.groups__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_users.proxyfor__ COLUMN jsonb PATH '$'
    TO 't';

CREATE DATA MAPPING FOR json
    FROM TABLE folio_users.users__ COLUMN jsonb PATH '$'
    TO 't';

