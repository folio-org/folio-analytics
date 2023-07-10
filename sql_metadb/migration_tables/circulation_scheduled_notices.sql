DROP TABLE IF EXISTS circulation_scheduled_notices;

CREATE TABLE circulation_scheduled_notices AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'loanId')::varchar(36) AS loan_id,
    jsonb_extract_path_text(jsonb, 'nextRunTime')::timestamptz AS next_run_time,
    jsonb_extract_path_text(jsonb, 'recipientUserId')::varchar(36) AS recipient_user_id,
    jsonb_extract_path_text(jsonb, 'requestId')::varchar(36) AS request_id,
    jsonb_extract_path_text(jsonb, 'triggeringEvent')::varchar(65535) AS triggering_event,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_circulation.scheduled_notice;

