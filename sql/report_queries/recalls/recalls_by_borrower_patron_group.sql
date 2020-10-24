-- This report produces a count of Recall requests by
-- borrower_patron_group_type for a particular time period, grouped by
-- quarters.  One concern with this report is that we have to guess
-- what loan was active when the recall request was placed.
-- Currently, we look for a loan with the same item as the recall
-- request and where the loan date preceeds the recall and the return
-- date is either null or is preceeded by the recall.  It would be
-- nicer to have the request data model include the id of the active
-- loan when the recall request is placed.  We could explore
-- alternatives to this approach.  Would notices provide data on what
-- patron groups received a notice of recall?
WITH parameters AS (
    SELECT
        -- Choose a start and end date for the requests
        '2020-01-01'::date AS start_date,
        '2022-01-01'::date AS end_date
)
SELECT
    (
        SELECT
            start_date::varchar
        FROM
            parameters) || ' to '::varchar || (
        SELECT
            end_date::varchar
        FROM
            parameters) AS date_range,
    li.patron_group_name AS borrower_patron_group_name,
    extract(year FROM ri.request_date) || '-Q'::varchar || extract(quarter FROM ri.request_date) AS recall_quarter,
    count(DISTINCT ri.request_id) AS count_recalled
FROM
    local.requests_items AS ri
    LEFT JOIN local.loans_items AS li ON ri.item_id = li.item_id
WHERE
    request_date >= (
        SELECT
            start_date
        FROM
            parameters)
    AND request_date < (
        SELECT
            end_date
        FROM
            parameters)
    AND ((request_date < loan_return_date)
        OR (loan_return_date IS NULL))
    AND request_date >= loan_date
    -- AND request_type = 'Recall'  -- Uncomment when there is test data for Recall
GROUP BY
    borrower_patron_group_name,
    recall_quarter;

