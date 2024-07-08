-- This derived table captures the renewal actions from the
-- public.circulation_loan_history table and shows the dates of
-- renewal.  The table also captures the current loan status from the
-- public.circulation_loans table.  This table may be used to count
-- the number of renewals within a given renewal date range, or count
-- the number of renewals for specific loans.

DROP TABLE IF EXISTS loans_renewal_dates;

CREATE TABLE loans_renewal_dates AS
SELECT     
        clh.loan__id AS loan_id,
        clh.loan__loan_date AS loan_date,
        clh.loan__item_id AS item_id,
        invitems.hrid AS item_hrid,
        clh.loan__action AS loan_action,
        date_trunc('minute', clh.created_date::timestamptz) AS renewal_date,
        count(DISTINCT clh.loan__id) AS folio_renewal_count,
        cl.status__name AS loan_status
    FROM public.circulation_loan_history AS clh
            LEFT JOIN public.circulation_loans AS cl ON clh.loan__id::uuid = cl.id::uuid
            LEFT JOIN inventory_items AS invitems ON clh.loan__item_id::uuid = invitems.id::uuid
    WHERE
        clh.loan__action IN ('renewed', 'renewedThroughOverride')
    GROUP BY         
        clh.loan__id,
        clh.loan__loan_date,
        clh.loan__item_id,
        invitems.hrid,
        clh.loan__action,
        date_trunc('minute', clh.created_date::timestamptz),
        cl.status__name
    ORDER BY
        clh.loan__id,
        date_trunc('minute', clh.created_date::timestamptz);
