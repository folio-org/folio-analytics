-- public.po_order_invoice_relns
COMMENT ON COLUMN public.po_order_invoice_relns.id IS 'UUID of po and invoice relationship record';
COMMENT ON COLUMN public.po_order_invoice_relns.invoice_id IS 'Invoice UUID';  
COMMENT ON COLUMN public.po_order_invoice_relns.purchase_order_id IS 'Purchase order UUID';

-- public.circulation_loans
COMMENT ON COLUMN public.circulation_loans.id IS 'Unique ID (generated UUID) of the loan';
COMMENT ON COLUMN public.circulation_loans.action IS 'Last action performed on a loan (currently can be any value, values commonly used are checkedout and checkedin)';
COMMENT ON COLUMN public.circulation_loans.action_comment IS 'Comment to last action performed on a loan';
COMMENT ON COLUMN public.circulation_loans.checkin_service_point_id IS 'ID (generated UUID) of the Service Point where the last checkin occurred';
COMMENT ON COLUMN public.circulation_loans.checkout_service_point_id IS 'ID (generated UUID) of the Service Point where the last checkout occured';
COMMENT ON COLUMN public.circulation_loans.declared_lost_date IS 'Date and time the item was declared lost during this loan';
COMMENT ON COLUMN public.circulation_loans.due_date IS 'Date time when the item is due to be returned';
COMMENT ON COLUMN public.circulation_loans.item_effective_location_id_at_check_out IS 'The effective location (generated UUID), at the time of checkout, of the item loaned to the patron.';
COMMENT ON COLUMN public.circulation_loans.item_id IS 'ID (generated UUID) of the item lent to the patron';
COMMENT ON COLUMN public.circulation_loans.item_status IS 'Last item status used in relation to this loan (currently can be any value, values commonly used are Checked out and Available)';
COMMENT ON COLUMN public.circulation_loans.loan_date IS 'Date time when the loan began (typically represented according to rfc3339 section-5.6. Has not had the date-time format validation applied as was not supported at point of introduction and would now be a breaking change)';
COMMENT ON COLUMN public.circulation_loans.loan_policy_id IS 'ID (generated UUID) of last policy used in relation to this loan';
COMMENT ON COLUMN public.circulation_loans.lost_item_policy_id IS 'ID (generated UUID) of lost item policy which determines when the item ages to lost and the associated fees or the associated fees if the patron declares the item lost.';
COMMENT ON COLUMN public.circulation_loans.metadata__created_by_user_id IS 'ID (generated UUID) of the user who last updated the record (when available)';
COMMENT ON COLUMN public.circulation_loans.metdata__created_date IS 'Date and time when the record was created';
COMMENT ON COLUMN public.circulation_loans.metadata__updated_by_user_id IS 'ID (generated UUID) of the user who created the record (when available)';
COMMENT ON COLUMN public.circulation_loans.metadata__updated_date IS 'Date and time when the record was last updated';
COMMENT ON COLUMN public.circulation_loans.overdue_fine_policy_id IS 'ID (generated UUID) of overdue fines policy at the time the item is check-in or renewed';
COMMENT ON COLUMN public.circulation_loans.patron_group_id_at_checkout IS 'Patron Group (generated UUID) at checkout';
COMMENT ON COLUMN public.circulation_loans.proxy_user_id IS 'ID (generated UUID) of the user representing a proxy for the patron';
COMMENT ON COLUMN public.circulation_loans.renewal_count IS 'Count of how many times a loan has been renewed (incremented by the client)';
COMMENT ON COLUMN public.circulation_loans.return_date IS 'Date time when the item is returned and the loan ends (typically represented according to rfc3339 section-5.6. Has not had the date-time format validation applied as was not supported at point of introduction and would now be a breaking change)';
COMMENT ON COLUMN public.circulation_loans.status__name IS 'Name of the status (currently can be any value, values commonly used are Open and Closed)';
COMMENT ON COLUMN public.circulation_loans.system_return_date IS 'Date time when the returned item is actually processed';
COMMENT ON COLUMN public.circulation_loans.user_id IS 'ID (generated UUID) of the patron the item was lent to. Required for open loans, not required for closed loans (for anonymization).';
COMMENT ON COLUMN public.circulation_loans.data IS 'JSON representation of the record';
COMMENT ON COLUMN public.circulation_loans.claimed_returned_date IS 'Date and time the item was claimed returned for this loan';

--public.circulation_requests
COMMENT ON COLUMN public.circulation_requests.id IS 'ID (generated UUID) of the request';
COMMENT ON COLUMN public.circulation_requests.awaiting_pickup_request_closed_date IS 'The date when the request with awaiting pickup status was closed';
COMMENT ON COLUMN public.circulation_requests.cancellation_additional_information IS 'Potential relevant information regarding a cancellation';
COMMENT ON COLUMN public.circulation_requests.cancellation_reason_id IS 'ID (generated UUID) of the request cancellation reason';
COMMENT ON COLUMN public.circulation_requests.cancelled_by_user_id IS 'ID (generated UUID) of the user that cancelled the request';
COMMENT ON COLUMN public.circulation_requests.cancelled_date IS 'Date the request was cancelled';
COMMENT ON COLUMN public.circulation_requests.fulfilment_preference IS 'How should the request be fulfilled (whether the item should be kept on the hold shelf for collection or delivered to the requester)';
COMMENT ON COLUMN public.circulation_requests.hold_shelf_expiration_date IS 'Date when an item on the hold shelf expires';
COMMENT ON COLUMN public.circulation_requests.holdings_record_id IS 'ID (generated UUID) of the holdings record being requested';
COMMENT ON COLUMN public.circulation_requests.instance__title IS 'Title of the item being requested';
COMMENT ON COLUMN public.circulation_requests.instance_id IS 'ID (generated UUID) of the instance being requested';
COMMENT ON COLUMN public.circulation_requests.item__barcode IS 'Barcode of the item being requested';
COMMENT ON COLUMN public.circulation_requests.item_id IS 'ID (generated UUID) of the item being requested';
COMMENT ON COLUMN public.circulation_requests.metadata__created_by_user_id IS 'ID (generated UUID) of the user who created the record (when available)';
COMMENT ON COLUMN public.circulation_requests.metadata__created_date IS 'Date and time when the record was created';
COMMENT ON COLUMN public.circulation_requests.metadata__updated_by_user_id IS 'ID (generated UUID) of the user who last updated the record (when available)';
COMMENT ON COLUMN public.circulation_requests.metadata__updated_date IS 'Date and time when the record was last updated';
COMMENT ON COLUMN public.circulation_requests.patron_comments IS 'Comments made by the patron';
COMMENT ON COLUMN public.circulation_requests.pickup_service_point_id IS 'ID (generated UUID) of the Service Point where this request can be picked up';
COMMENT ON COLUMN public.circulation_requests.position IS 'Position of the request in the unified request queue';
COMMENT ON COLUMN public.circulation_requests.request_date IS 'Date the request was made';
COMMENT ON COLUMN public.circulation_requests.request_expiration_date IS 'Date when the request expires';
COMMENT ON COLUMN public.circulation_requests.request_level IS 'Level of the request - Item or Title';
COMMENT ON COLUMN public.circulation_requests.request_type IS 'Whether the item should be held upon return, recalled or paged for';
COMMENT ON COLUMN public.circulation_requests.requester__barcode IS 'Barcode of the requesting patron';
COMMENT ON COLUMN public.circulation_requests.requester__first_name IS 'First name of the requesting patron';
COMMENT ON COLUMN public.circulation_requests.requester__last_name IS 'Last name of the requesting patron';
COMMENT ON COLUMN public.circulation_requests.requester_id IS 'ID (generated UUID) of the requesting patron (user)';
COMMENT ON COLUMN public.circulation_requests.status IS 'Status of the request';
COMMENT ON COLUMN public.circulation_requests.data IS 'JSON representation of the record';

--public.circulation_loan_history
COMMENT ON COLUMN public.circulation_loan_history.id IS 'ID (generated UUID) of the snapshot of the loan record';
COMMENT ON COLUMN public.circulation_loan_history.created_date IS 'When this snapshot was created';
COMMENT ON COLUMN public.circulation_loan_history.loan__action IS 'Last action performed on a loan (currently can be any value, values commonly used are checkedout and checkedin)';
COMMENT ON COLUMN public.circulation_loan_history.loan__action_comment IS 'Comment to last action performed on a loan';
COMMENT ON COLUMN public.circulation_loan_history.loan__checkin_service_point_id IS 'ID (generated UUID) of the service point where the last checkin occured';
COMMENT ON COLUMN public.circulation_loan_history.loan__checkout_service_point_id IS 'ID (generated UUID) of the service point where the last checkout occured';
COMMENT ON COLUMN public.circulation_loan_history.loan__declared_lost_date IS 'Date and time the item was declared lost during this loan';
COMMENT ON COLUMN public.circulation_loan_history.loan__due_date IS 'Date and time when the item is due to be returned';
COMMENT ON COLUMN public.circulation_loan_history.loan__id IS 'ID (generated UUID) of the loan';
COMMENT ON COLUMN public.circulation_loan_history.loan__item_effective_location_id_at_check_out IS 'The effective location, at the time of checkout, of the item loaned to the patron';
COMMENT ON COLUMN public.circulation_loan_history.loan__item_id IS 'ID (generated UUID) of the item lent to the patron';
COMMENT ON COLUMN public.circulation_loan_history.loan__item_status IS 'Last item status used in relation to this loan (currently can be any value, values commonly used are Checked out and Available)';
COMMENT ON COLUMN public.circulation_loan_history.loan__loan_date IS 'Date and time when the loan began';
COMMENT ON COLUMN public.circulation_loan_history.loan__loan_policy_id IS 'ID (generated UUID) of last policy used in relation to this loan';
COMMENT ON COLUMN public.circulation_loan_history.loan__lost_item_policy_id IS 'ID (generated UUID) of lost item policy which determines when the item ages to lost and the associated fees or the associated fees if the patron declares the item lost';
COMMENT ON COLUMN public.circulation_loan_history.loan__overdue_fine_policy_id IS 'ID (generated UUID) of overdue fines policy at the time the item is check-in or renewed';
COMMENT ON COLUMN public.circulation_loan_history.loan__patron_group_id_at_checkout IS 'Patron group ID (generated UUID) at checkout';
COMMENT ON COLUMN public.circulation_loan_history.loan__proxy_user_id IS 'ID (generated UUID) of the user representing a proxy for the patron';
COMMENT ON COLUMN public.circulation_loan_history.loan__renewal_count IS 'Count of how many times a loan has been renewed (incremented by the client)';
COMMENT ON COLUMN public.circulation_loan_history.loan__return_date IS 'Date and time when the item is returned and the loan ends';
COMMENT ON COLUMN public.circulation_loan_history.loan__system_return_date IS 'Date and time when the returned item is actually processed';
COMMENT ON COLUMN public.circulation_loan_history.loan__user_id IS 'ID (generated UUID) of the patron the item was lent to. Required for open loans, not required for closed loans (for anonymization)';
COMMENT ON COLUMN public.circulation_loan_history.operation IS 'Type of change that triggered this loan record snapshot: I for insert, U for update, D for delete';
COMMENT ON COLUMN public.circulation_loan_history.data IS 'JSON representation of the record';

--public.circulation_request_preference
COMMENT ON COLUMN public.circulation_request_preference.id IS 'ID (generated UUID) of request preference';
COMMENT ON COLUMN public.circulation_request_preference.delivery IS 'Whether Delivery option is available to the user.';
COMMENT ON COLUMN public.circulation_request_preference.fulfillment IS 'Preferred fulfillment type. Possible values are Delivery or Hold Shelf';
COMMENT ON COLUMN public.circulation_request_preference.hold_shelf IS 'Whether Hold Shelf option is available to the user.';
COMMENT ON COLUMN public.circulation_request_preference.metadata__created_by_user_id IS 'ID (generated UUID) of the user who created the record (when available)';
COMMENT ON COLUMN public.circulation_request_preference.metadata__created_date IS 'Date and time when the record was created';
COMMENT ON COLUMN public.circulation_request_preference.metadata__updated_by_user_id IS 'ID (generated UUID) of the user who last updated the record (when available)';
COMMENT ON COLUMN public.circulation_request_preference.metadata__updated_date IS 'Date and time when the record was last updated';
COMMENT ON COLUMN public.circulation_request_preference.user_id IS 'ID (generated UUID) of user associated with this request preference';
COMMENT ON COLUMN public.circulation_request_preference.data IS 'JSON representation of the record';

--public.circulation_request_policies
COMMENT ON COLUMN public.circulation_request_policies.id IS 'ID (generated UUID) of the request policy';
COMMENT ON COLUMN public.circulation_request_policies.description IS 'Description of request policy';
COMMENT ON COLUMN public.circulation_request_policies.metadata__created_date IS 'Date and time when the record was created';
COMMENT ON COLUMN public.circulation_request_policies.metadata__updated_date IS 'Date and time when the record was last updated';
COMMENT ON COLUMN public.circulation_request_policies.name IS 'Unique request policy name, required';
COMMENT ON COLUMN public.circulation_request_policies.data IS 'JSON representation of the record';

--public.circulation_patron_notice_policies 
COMMENT ON COLUMN public.circulation_patron_notice_policies.id IS 'ID (generated UUID) of the patron notice policy';
COMMENT ON COLUMN public.circulation_patron_notice_policies.active IS 'A flag to determine if a patron notice policy is active';
COMMENT ON COLUMN public.circulation_patron_notice_policies.description IS 'Patron notice policy description';
COMMENT ON COLUMN public.circulation_patron_notice_policies.metadata__created_date IS 'Date and time when the record was created';
COMMENT ON COLUMN public.circulation_patron_notice_policies.metadata__updated_date IS 'Date and time when the record was last updated';
COMMENT ON COLUMN public.circulation_patron_notice_policies.name IS 'Patron notice policy name';
COMMENT ON COLUMN public.circulation_patron_notice_policies.data IS 'JSON representation of the record';

--public.circulation_check_ins
COMMENT ON COLUMN public.circulation_check_ins.id IS 'ID (generated UUID) of the check-in operation';
COMMENT ON COLUMN public.circulation_check_ins.item_id IS 'ID (generated UUID) of the item that has been checked in';
COMMENT ON COLUMN public.circulation_check_ins.item_location_id IS 'Location (generated UUID) of the item at check-in time';
COMMENT ON COLUMN public.circulation_check_ins.item_status_prior_to_check_in IS 'Item status prior to check-in';
COMMENT ON COLUMN public.circulation_check_ins.occurred_date_time IS 'Date and time when the check-in occurred';
COMMENT ON COLUMN public.circulation_check_ins.performed_by_user_id IS 'ID (generated UUID) of the user that performed check-in operation';
COMMENT ON COLUMN public.circulation_check_ins.request_queue_size IS 'Request queue size for the item';
COMMENT ON COLUMN public.circulation_check_ins.service_point_id IS 'ID (generated UUID) of the service point where the item was checked in';
COMMENT ON COLUMN public.circulation_check_ins.data IS 'JSON representation of the record';

--public.circulation_scheduled_notices
COMMENT ON COLUMN public.circulation_scheduled_notices.id IS 'ID (generated UUID) of the scheduled task';
COMMENT ON COLUMN public.circulation_scheduled_notices.loan_id IS 'ID (generated UUID) of the related loan';
COMMENT ON COLUMN public.circulation_scheduled_notices.metadata__created_by_user_id IS 'ID (generated UUID) of the user who created the record (when available)';
COMMENT ON COLUMN public.circulation_scheduled_notices.metadata__created_date IS 'Date and time when the record was created';
COMMENT ON COLUMN public.circulation_scheduled_notices.metadata__updated_by_user_id IS 'ID (generated UUID) of the user who last updated the record (when available)';
COMMENT ON COLUMN public.circulation_scheduled_notices.metadata__updated_date IS 'Date and time when the record was last updated';
COMMENT ON COLUMN public.circulation_scheduled_notices.next_run_time IS 'Next run time';
COMMENT ON COLUMN public.circulation_scheduled_notices.notice_config__format IS 'Notice format (email, SMS, print)';
COMMENT ON COLUMN public.circulation_scheduled_notices.notice_config__send_in_real_time IS 'Real time notice flag';
COMMENT ON COLUMN public.circulation_scheduled_notices.notice_config__template_id IS 'ID (Generated UUID) of related template';
COMMENT ON COLUMN public.circulation_scheduled_notices.notice_config__timing IS 'Timing represents when we need to send notice, before, at or after loan due date';
COMMENT ON COLUMN public.circulation_scheduled_notices.recipient_user_id IS 'ID (generated UUID) of the user to whom this notice should be sent to';
COMMENT ON COLUMN public.circulation_scheduled_notices.request_id IS 'ID (generated UUID) of related request for request notices';
COMMENT ON COLUMN public.circulation_scheduled_notices.triggering_event IS 'Scheduled notice triggering event';
COMMENT ON COLUMN public.circulation_scheduled_notices.data IS 'JSON representation of the record';

--public.user_users
COMMENT ON COLUMN public.user_users.id IS 'ID (generated UUID) for the user';
COMMENT ON COLUMN public.user_users.active IS 'A flag to determine if a user can log in, take out loans, etc.';
COMMENT ON COLUMN public.user_users.barcode IS 'The unique library barcode for this user';
COMMENT ON COLUMN public.user_users.created_date IS 'Deprecated';
COMMENT ON COLUMN public.user_users.enrollment_date IS 'The date when the user joined the organization';
COMMENT ON COLUMN public.user_users.expiration_date IS 'The date when the user becomes inactive';
COMMENT ON COLUMN public.user_users.metadata__created_by_user_id IS 'ID (generated UUID) of the user who created the record (when available)';
COMMENT ON COLUMN public.user_users.metadata__created_date IS 'Date and time when the record was created';
COMMENT ON COLUMN public.user_users.metadata__updated_by_user_ID IS 'ID (generated UUID) of the user who last updated the record (when available)';
COMMENT ON COLUMN public.user_users.metadata__updated_date IS 'Date and time when the record was last updated';
COMMENT ON COLUMN public.user_users.patron_group IS 'ID (generated UUID) corresponding to the group the user belongs to';
COMMENT ON COLUMN public.user_users.personal__date_of_birth IS 'The user''s birth date';
COMMENT ON COLUMN public.user_users.personal__email IS 'The user''s email address';
COMMENT ON COLUMN public.user_users.personal__first_name IS 'The user''s given name';
COMMENT ON COLUMN public.user_users.personal__last_name IS 'The user''s surname';
COMMENT ON COLUMN public.user_users.personal__middle_name IS 'The user''s middle name (if any)';
COMMENT ON COLUMN public.user_users.personal__mobile_phone IS 'The user''s mobile phone number';
COMMENT ON COLUMN public.user_users.personal__phone IS 'The user''s primary phone number';
COMMENT ON COLUMN public.user_users.personal__preferred_contact_type_id IS 'ID of user''s preferred contact type like Email, Mail or Text Message';
COMMENT ON COLUMN public.user_users.personal__preferred_first_name IS 'The user''s preferred name';
COMMENT ON COLUMN public.user_users.type IS 'The class of user like staff or patron, this is different from patronGroup';
COMMENT ON COLUMN public.user_users.updated_date IS 'Deprecated'; 
COMMENT ON COLUMN public.user_users.username IS 'A unique name belonging to a user. Typically used for login';
COMMENT ON COLUMN public.user_users.data IS 'JSON representation of the record';

