DROP TABLE IF EXISTS course_courses;

CREATE TABLE course_courses AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'courseListingId')::varchar(36) AS course_listing_id,
    jsonb_extract_path_text(jsonb, 'courseNumber')::varchar(65535) AS course_number,
    jsonb_extract_path_text(jsonb, 'departmentId')::varchar(36) AS department_id,
    jsonb_extract_path_text(jsonb, 'description')::varchar(65535) AS description,
    jsonb_extract_path_text(jsonb, 'name')::varchar(65535) AS name,
    jsonb_extract_path_text(jsonb, 'numberOfStudents')::bigint AS number_of_students,
    jsonb_extract_path_text(jsonb, 'sectionName')::varchar(65535) AS section_name,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_courses.coursereserves_courses;

ALTER TABLE course_courses ADD PRIMARY KEY (id);

CREATE INDEX ON course_courses (course_listing_id);

CREATE INDEX ON course_courses (course_number);

CREATE INDEX ON course_courses (department_id);

CREATE INDEX ON course_courses (description);

CREATE INDEX ON course_courses (name);

CREATE INDEX ON course_courses (number_of_students);

CREATE INDEX ON course_courses (section_name);

VACUUM ANALYZE course_courses;
