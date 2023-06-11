/* This derived table pulls renewals from the circulation_loan_history by 
 * filtering on the loan's "action" column. Additional columns allow users to 
 * join renewals with dates to other tables, to filter down to specific renewals, 
 * or to validate the results. */
DROP TABLE IF EXISTS loans_renewal_dates;

CREATE TABLE loans_renewal_dates AS
    SELECT
        id AS loan_history_id,
        created_date AS loan_action_date,
        data #>> '{loan,id}' AS loan_id,
        data #>> '{loan,itemId}' AS item_id,
        data #>> '{loan,action}' AS loan_action,
        data #>> '{loan,renewalCount}' AS loan_renewal_count,
        data #>> '{loan,status,name}' AS loan_status
    FROM public.circulation_loan_history
    WHERE
        data #>> '{loan,action}' IN ('renewed', 'renewedThroughOverride')
    ORDER BY
        loan_id,
        loan_action_date
;

