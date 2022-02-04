DROP TABLE IF EXISTS circulation_cancellation_reasons;

CREATE TABLE circulation_cancellation_reasons AS
SELECT
    id::varchar(36),
    (jsonb->>'description')::varchar AS description,
    (jsonb->>'name')::varchar AS name,
    (jsonb->>'public_description')::varchar AS public_description,
    (jsonb->>'requiresAdditionalInformation')::bool AS requires_additional_information,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_circulation.cancellation_reason;

ALTER TABLE circulation_cancellation_reasons ADD PRIMARY KEY (id);

CREATE INDEX ON circulation_cancellation_reasons (description);

CREATE INDEX ON circulation_cancellation_reasons (name);

CREATE INDEX ON circulation_cancellation_reasons (public_description);

CREATE INDEX ON circulation_cancellation_reasons (requires_additional_information);

VACUUM ANALYZE circulation_cancellation_reasons;
