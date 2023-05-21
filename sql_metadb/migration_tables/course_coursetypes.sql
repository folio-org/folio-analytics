DROP TABLE IF EXISTS course_coursetypes;

CREATE TABLE course_coursetypes AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'description')::varchar(65535) AS description,
    jsonb_extract_path_text(jsonb, 'name')::varchar(65535) AS name,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_courses.coursereserves_coursetypes;

ALTER TABLE course_coursetypes ADD PRIMARY KEY (id);

CREATE INDEX ON course_coursetypes (description);

CREATE INDEX ON course_coursetypes (name);

