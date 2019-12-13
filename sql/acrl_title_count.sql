/* ACRL Title Count
 *  
 *  An aggregate count of instance records grouped by 
 *      Institution Location
 *      Campus Location
 *      Library Location
 *      Instance Type
 *      Instance Format
 */

WITH instance_format_extract AS (
    SELECT
        inst.id AS instance_id,
        JSON_ARRAY_ELEMENTS_TEXT(JSON_EXTRACT_PATH_TEXT
        (inst.data, 'instanceFormatIds') :: JSON) :: VARCHAR AS instance_format_id
    FROM
        instances AS inst
)
SELECT
    institutions.name AS "institution location name",
    campuses.name AS "campus location name",
    libraries.name AS "library location name",
    instance_types.name AS "instance type name",
    instance_formats.name AS "instance format name", 
    COUNT(instances.id) AS "title count"
FROM
    libraries
LEFT JOIN campuses
LEFT JOIN institutions
LEFT JOIN locations
LEFT JOIN holdings ON
    locations.id = holdings.permanent_location_id ON
    institutions.id = locations.institution_id ON
    campuses.id = locations.campus_id ON
    libraries.id = locations.library_id
LEFT JOIN instances ON
    holdings.instance_id = instances.id
LEFT JOIN instance_types ON
    instances.instance_type_id = instance_types.id
LEFT JOIN instance_format_extract ON 
    instances.id = instance_format_extract.instance_id
LEFT JOIN instance_formats ON 
    instance_format_extract.instance_format_id = instance_formats.id
GROUP BY
    institutions.name,
    campuses.name,
    libraries.name,
    instance_types.name,
    instance_formats.name