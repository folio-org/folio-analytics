DROP TABLE IF EXISTS srs_records;

CREATE TABLE srs_records AS
SELECT
    id::varchar(36),
    created_by_user_id::varchar(36),
    created_date::timestamptz,
    -------------------------------------------------------------
    -- Folio before Kiwi uses "instance_hrid" and "instance_id"
    -- instance_hrid::varchar(65535) AS external_hrid,
    -- instance_id::varchar(36) AS external_id,
    -------------------------------------------------------------
    -- Folio Kiwi and later use "external_hrid" and "external_id"
    external_hrid::varchar(65535),
    external_id::varchar(36),
    -------------------------------------------------------------
    generation::bigint,
    leader_record_status::varchar(65535),
    matched_id::varchar(36),
    "order"::bigint,
    record_type::varchar(65535),
    snapshot_id::varchar(36),
    state::varchar(65535),
    suppress_discovery::boolean,
    updated_by_user_id::varchar(36),
    updated_date::timestamptz
FROM
    folio_source_record.records_lb;

