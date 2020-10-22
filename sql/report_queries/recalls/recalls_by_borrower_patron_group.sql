--All we need for this report is a count of Recall requests by borrower_patron_group_type
--We don't need item_id or loan_id for this report, I just included it here to see what we get
--We don't need locations
WITH parameters AS (
    SELECT
        /* Choose a start and end date for the requests */
        '2020-01-01'::DATE AS start_date,
        '2021-01-01'::DATE AS end_date
)
SELECT
    ri.request_type,
    ri.request_date,
    ri.request_id,
    ri.item_id,
    li.user_id AS borrower_id,
    li.patron_group_name AS borrower_patron_group_name,
    li.loan_id
FROM
    LOCAL.requests_items AS ri
    LEFT JOIN LOCAL.loans_items AS li ON ri.item_id = li.item_id
WHERE
    request_type = 'Hold' --change this to Recall; there is no currently no test data for Recall
    AND request_date >= (
        SELECT
            start_date
        FROM
            parameters)
    AND request_date < (
        SELECT
            end_date
        FROM
            parameters);