DROP TABLE IF EXISTS circulation_patron_action_sessions;

CREATE TABLE circulation_patron_action_sessions AS
SELECT
    id::varchar(36),
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_circulation.patron_action_session;

ALTER TABLE circulation_patron_action_sessions ADD PRIMARY KEY (id);

VACUUM ANALYZE circulation_patron_action_sessions;
