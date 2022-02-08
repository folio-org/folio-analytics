DROP TABLE IF EXISTS course_courselistings;

CREATE TABLE course_courselistings AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'courseTypeId')::varchar(36) AS course_type_id,
    jsonb_extract_path_text(jsonb, 'externalId')::varchar(36) AS external_id,
    jsonb_extract_path_text(jsonb, 'locationId')::varchar(36) AS location_id,
    jsonb_extract_path_text(jsonb, 'registrarId')::varchar(36) AS registrar_id,
    jsonb_extract_path_text(jsonb, 'servicepointId')::varchar(36) AS servicepoint_id,
    jsonb_extract_path_text(jsonb, 'termId')::varchar(36) AS term_id,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_courses.coursereserves_courselistings;

ALTER TABLE course_courselistings ADD PRIMARY KEY (id);

CREATE INDEX ON course_courselistings (course_type_id);

CREATE INDEX ON course_courselistings (external_id);

CREATE INDEX ON course_courselistings (location_id);

CREATE INDEX ON course_courselistings (registrar_id);

CREATE INDEX ON course_courselistings (servicepoint_id);

CREATE INDEX ON course_courselistings (term_id);

VACUUM ANALYZE course_courselistings;
