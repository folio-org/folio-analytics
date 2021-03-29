/* This derived table will pull renewals from the folio_circulation.loan table by 
 * filtering on the loan's "action" column. Additional columns allow users to 
 * join renewals with dates to other tables, to filter down to specific renewals, 
 * or to validate the results. */
  
-- Questions:
-- Do we want to count "renewedThroughOverride" as a renewal for circulation reports?
-- like, for annual statistics, would that count as a renewal? It does
-- increment renewal count.

DROP TABLE IF EXISTS folio_reporting.loans_renewal_dates;

--check for rows that are duplicated except for __id
CREATE TABLE folio_reporting.loans_renewal_dates AS
    WITH distinct_records AS (
        SELECT
            DISTINCT __start, id, jsonb::VARCHAR
        FROM
            folio_circulation.loan
    )
    SELECT
        --__id AS loan_history_id, -- can add back in if we stop de-duplicating rows
        __start AS loan_action_date,
        id AS loan_id,
        json_extract_path_text(jsonb::JSON, 'itemId') AS item_id,
        json_extract_path_text(jsonb::JSON, 'action') AS loan_action,
        json_extract_path_text(jsonb::JSON, 'renewalCount') AS loan_renewal_count,
        json_extract_path_text(jsonb::JSON, 'status', 'name') AS loan_status
    FROM distinct_records
    WHERE
        json_extract_path_text(jsonb::JSON, 'action') IN ('renewed', 'renewedThroughOverride')
    ORDER BY
        loan_id,
        loan_action_date
;

--CREATE INDEX ON folio_reporting.loans_renewal_dates (loan_history_id);

CREATE INDEX ON folio_reporting.loans_renewal_dates (loan_action_date);

CREATE INDEX ON folio_reporting.loans_renewal_dates (loan_id);

CREATE INDEX ON folio_reporting.loans_renewal_dates (item_id);

CREATE INDEX ON folio_reporting.loans_renewal_dates (loan_action);

CREATE INDEX ON folio_reporting.loans_renewal_dates (loan_renewal_count);

CREATE INDEX ON folio_reporting.loans_renewal_dates (loan_status);