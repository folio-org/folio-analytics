DROP TABLE IF EXISTS course_terms;

CREATE TABLE course_terms AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'endDate')::varchar(65535) AS end_date,
    jsonb_extract_path_text(jsonb, 'name')::varchar(65535) AS name,
    jsonb_extract_path_text(jsonb, 'startDate')::varchar(65535) AS start_date,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_courses.coursereserves_terms;

