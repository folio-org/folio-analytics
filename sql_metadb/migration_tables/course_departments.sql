DROP TABLE IF EXISTS course_departments;

CREATE TABLE course_departments AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'description')::varchar(65535) AS description,
    jsonb_extract_path_text(jsonb, 'name')::varchar(65535) AS name,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_courses.coursereserves_departments;

ALTER TABLE course_departments ADD PRIMARY KEY (id);

CREATE INDEX ON course_departments (description);

CREATE INDEX ON course_departments (name);

VACUUM ANALYZE course_departments;
