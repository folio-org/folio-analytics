--metadb:table loans_renewal_dates

/* This derived table pulls renewals from the folio_circulation.loan table by 
 * filtering on the loan's "action" column. Additional columns allow users to 
 * join renewals with dates to other tables, to filter down to specific renewals, 
 * or to validate the results. */
DROP TABLE IF EXISTS loans_renewal_dates;

--check for rows that are duplicated except for __id
CREATE TABLE loans_renewal_dates AS
    WITH distinct_records AS (
        SELECT
            DISTINCT __start, id, jsonb
        FROM
            folio_circulation.loan
    )
    SELECT
        --__id AS loan_history_id, -- can add back in if we stop de-duplicating rows
        __start AS loan_action_date,
        id AS loan_id,
        jsonb_extract_path_text(jsonb, 'itemId') AS item_id,
        jsonb_extract_path_text(jsonb, 'action') AS loan_action,
        jsonb_extract_path_text(jsonb, 'renewalCount') AS loan_renewal_count,
        jsonb_extract_path_text(jsonb, 'status', 'name') AS loan_status
    FROM distinct_records
    WHERE
        jsonb_extract_path_text(jsonb, 'action') IN ('renewed', 'renewedThroughOverride')
    ORDER BY
        loan_id,
        loan_action_date
;

--CREATE INDEX ON loans_renewal_dates (loan_history_id);

CREATE INDEX ON loans_renewal_dates (loan_action_date);

CREATE INDEX ON loans_renewal_dates (loan_id);

CREATE INDEX ON loans_renewal_dates (item_id);

CREATE INDEX ON loans_renewal_dates (loan_action);

CREATE INDEX ON loans_renewal_dates (loan_renewal_count);

CREATE INDEX ON loans_renewal_dates (loan_status);

