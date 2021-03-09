/* This derived table will pull renewals from the circulation_loan_history by 
 * filtering on the loan's "action" column. Additional columns allow users to 
 * join renewals with dates to other tables, to filter down to specific renewals, 
 * or to validate the results. When we move to metadb, will probably want to use
 * metadb's native history functionality instead. */
  
-- loan with renewal history in folio_snapshot: 2927e07a-322b-459b-a35e-b6aa231e24e2
-- can't find loans with renewal history in reports_dev, so will need to add data

-- write first version against folio_snapshot, since this is
-- scheduled for milestone 1.1

-- Questions:
-- Do we want to count "renewedThroughOverride" as a renewal for circulation reports?
-- like, for annual statistics, would that count as a renewal? It does
-- increment renewal count.

SELECT
    id AS loan_history_id,
    created_date AS loan_action_date,
    json_extract_path_text(data, 'loan', 'id') AS loan_id,
    json_extract_path_text(data, 'loan', 'itemId') AS item_id,
    json_extract_path_text(data, 'loan', 'action') AS loan_action,
    json_extract_path_text(data, 'loan', 'renewalCount') AS loan_renewal_count,
    json_extract_path_text(data, 'loan', 'status', 'name') AS loan_status
FROM public.circulation_loan_history
WHERE
    json_extract_path_text(data, 'loan', 'action') IN ('renewed', 'renewedThroughOverride')
ORDER BY
    loan_id,
    action_date
;