DROP TABLE IF EXISTS course_copyrightstatuses;

CREATE TABLE course_copyrightstatuses AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'description')::varchar(65535) AS description,
    jsonb_extract_path_text(jsonb, 'name')::varchar(65535) AS name,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_courses.coursereserves_copyrightstates;

ALTER TABLE course_copyrightstatuses ADD PRIMARY KEY (id);

CREATE INDEX ON course_copyrightstatuses (description);

CREATE INDEX ON course_copyrightstatuses (name);

