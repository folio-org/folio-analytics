DROP TABLE IF EXISTS circulation_loans;

CREATE TABLE circulation_loans AS
SELECT
    id::varchar(36),
    (jsonb->>'action')::varchar AS action,
    (jsonb->>'actionComment')::varchar AS action_comment,
    (jsonb->>'checkinServicePointId')::varchar(36) AS checkin_service_point_id,
    (jsonb->>'checkoutServicePointId')::varchar(36) AS checkout_service_point_id,
    (jsonb->>'claimedReturnedDate')::timestamptz AS claimed_returned_date,
    (jsonb->>'declaredLostDate')::timestamptz AS declared_lost_date,
    (jsonb->>'dueDate')::timestamptz AS due_date,
    (jsonb->>'dueDateChangedByRecall')::bool AS due_date_changed_by_recall,
    (jsonb->>'itemEffectiveLocationIdAtCheckOut')::varchar(36) AS item_effective_location_id_at_check_out,
    (jsonb->>'itemId')::varchar(36) AS item_id,
    (jsonb->>'itemStatus')::varchar(36) AS item_status,
    (jsonb->>'loanDate')::timestamptz AS loan_date,
    (jsonb->>'loanPolicyId')::varchar(36) AS loan_policy_id,
    (jsonb->>'lostItemPolicyId')::varchar(36) AS lost_item_policy_id,
    (jsonb->>'overdueFinePolicyId')::varchar(36) AS overdue_fine_policy_id,
    (jsonb->>'patronGroupIdAtCheckout')::varchar(36) AS patron_group_id_at_checkout,
    (jsonb->>'proxyUserId')::varchar(36) AS proxy_user_id,
    (jsonb->>'renewalCount')::varchar AS renewal_count,
    (jsonb->>'returnDate')::timestamptz AS return_date,
    (jsonb->>'systemReturnDate')::timestamptz AS system_return_date,
    (jsonb->>'userId')::varchar(36) AS user_id,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_circulation.loan;

ALTER TABLE circulation_loans ADD PRIMARY KEY (id);

CREATE INDEX ON circulation_loans (action);

CREATE INDEX ON circulation_loans (action_comment);

CREATE INDEX ON circulation_loans (checkin_service_point_id);

CREATE INDEX ON circulation_loans (checkout_service_point_id);

CREATE INDEX ON circulation_loans (claimed_returned_date);

CREATE INDEX ON circulation_loans (declared_lost_date);

CREATE INDEX ON circulation_loans (due_date);

CREATE INDEX ON circulation_loans (due_date_changed_by_recall);

CREATE INDEX ON circulation_loans (item_effective_location_id_at_check_out);

CREATE INDEX ON circulation_loans (item_id);

CREATE INDEX ON circulation_loans (item_status);

CREATE INDEX ON circulation_loans (loan_date);

CREATE INDEX ON circulation_loans (loan_policy_id);

CREATE INDEX ON circulation_loans (lost_item_policy_id);

CREATE INDEX ON circulation_loans (overdue_fine_policy_id);

CREATE INDEX ON circulation_loans (patron_group_id_at_checkout);

CREATE INDEX ON circulation_loans (proxy_user_id);

CREATE INDEX ON circulation_loans (renewal_count);

CREATE INDEX ON circulation_loans (return_date);

CREATE INDEX ON circulation_loans (system_return_date);

CREATE INDEX ON circulation_loans (user_id);

VACUUM ANALYZE circulation_loans;
