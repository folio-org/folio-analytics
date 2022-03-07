-- public.circulation_loans
COMMENT ON COLUMN public.circulation_loans.id IS 'Unique ID (generated UUID) of the loan';
COMMENT ON COLUMN public.circulation_loans."action" IS 'Last action performed on a loan (currently can be any value, values commonly used are checkedout and checkedin)';
COMMENT ON COLUMN public.circulation_loans.action_comment IS 'Comment to last action performed on a loan';
COMMENT ON COLUMN public.circulation_loans.checkin_service_point_id IS 'ID of the Service Point where the last checkin occurred';
COMMENT ON COLUMN public.circulation_loans.checkout_service_point_id IS 'ID of the Service Point where the last checkout occured';
COMMENT ON COLUMN public.circulation_loans.declared_lost_date IS 'Date and time the item was declared lost during this loan';
COMMENT ON COLUMN public.circulation_loans.due_date IS 'Date time when the item is due to be returned';
COMMENT ON COLUMN public.circulation_loans.item_effective_location_id_at_check_out IS 'The effective location, at the time of checkout, of the item loaned to the patron.';
COMMENT ON COLUMN public.circulation_loans.item_id IS 'ID of the item lent to the patron';
COMMENT ON COLUMN public.circulation_loans.item_status IS 'Last item status used in relation to this loan (currently can be any value, values commonly used are Checked out and Available)';
COMMENT ON COLUMN public.circulation_loans.loan_date IS 'Date time when the loan began (typically represented according to rfc3339 section-5.6. Has not had the date-time format validation applied as was not supported at point of introduction and would now be a breaking change)';
COMMENT ON COLUMN public.circulation_loans.loan_policy_id IS 'ID of last policy used in relation to this loan';
COMMENT ON COLUMN public.circulation_loans.lost_item_policy_id IS 'ID of lost item policy which determines when the item ages to lost and the associated fees or the associated fees if the patron declares the item lost.';
COMMENT ON COLUMN public.circulation_loans.overdue_fine_policy_id IS 'ID of overdue fines policy at the time the item is check-in or renewed';
COMMENT ON COLUMN public.circulation_loans.patron_group_id_at_checkout IS 'Patron Group Id at checkout';
COMMENT ON COLUMN public.circulation_loans.proxy_user_id IS 'ID of the user representing a proxy for the patron';
COMMENT ON COLUMN public.circulation_loans.renewal_count IS 'Count of how many times a loan has been renewed (incremented by the client)';
COMMENT ON COLUMN public.circulation_loans.return_date IS 'Date time when the item is returned and the loan ends (typically represented according to rfc3339 section-5.6. Has not had the date-time format validation applied as was not supported at point of introduction and would now be a breaking change)';
COMMENT ON COLUMN public.circulation_loans.system_return_date IS 'Date time when the returned item is actually processed';
COMMENT ON COLUMN public.circulation_loans.user_id IS 'ID of the patron the item was lent to. Required for open loans, not required for closed loans (for anonymization).';
COMMENT ON COLUMN public.circulation_loans."data" IS 'JSON representation of the record';
COMMENT ON COLUMN public.circulation_loans.claimed_returned_date IS 'Date and time the item was claimed returned for this loan';

--public.circulation_requests
COMMENT ON COLUMN public.circulation_requests.id IS 'UUID of the request';
COMMENT ON COLUMN public.circulation_requests.cancellation_additional_information IS 'Potential relevant information regarding a cancellation';
COMMENT ON COLUMN public.circulation_requests.cancellation_reason_id IS 'The ID of the request cancellation reason';
COMMENT ON COLUMN public.circulation_requests.cancelled_by_user_id IS 'The ID of the user that cancelled the request';
COMMENT ON COLUMN public.circulation_requests.cancelled_date IS 'Date the request was cancelled';
COMMENT ON COLUMN public.circulation_requests.fulfilment_preference IS 'How should the request be fulfilled (whether the item should be kept on the hold shelf for collection or delivered to the requester)';
COMMENT ON COLUMN public.circulation_requests.hold_shelf_expiration_date IS 'Date when an item on the hold shelf expires';
COMMENT ON COLUMN public.circulation_requests.holdings_record_id IS 'ID of the holdings record being requested';
COMMENT ON COLUMN public.circulation_requests.instance_id IS 'ID of the instance being requested';
COMMENT ON COLUMN public.circulation_requests.item_id IS 'ID of the item being requested';
COMMENT ON COLUMN public.circulation_requests.patron_comments IS 'Comments made by the patron';
COMMENT ON COLUMN public.circulation_requests.pickup_service_point_id IS 'The ID of the Service Point where this request can be picked up';
COMMENT ON COLUMN public.circulation_requests."position" IS 'Position of the request in the unified request queue';
COMMENT ON COLUMN public.circulation_requests.request_date IS 'Date the request was made';
COMMENT ON COLUMN public.circulation_requests.request_expiration_date IS 'Date when the request expires';
COMMENT ON COLUMN public.circulation_requests.request_level IS 'Level of the request - Item or Title';
COMMENT ON COLUMN public.circulation_requests.request_type IS 'Whether the item should be held upon return, recalled or paged for';
COMMENT ON COLUMN public.circulation_requests.status IS 'Status of the request';
COMMENT ON COLUMN public.circulation_requests."data" IS 'JSON representation of the record';



