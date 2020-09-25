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
        ins.id AS instance_id,
        JSON_ARRAY_ELEMENTS_TEXT(
            JSON_EXTRACT_PATH(ins.data, 'instanceFormatIds')) :: VARCHAR AS instance_format_id
    FROM
        inventory_instances AS ins
)
SELECT
    inst.name AS "institution location name",
    cmp.name AS "campus location name",
    lib.name AS "library location name",
    insttyp.name AS "instance type name",
    instfmt.name AS "instance format name", 
    COUNT(ins.id) AS "title count"
FROM inventory_instances AS ins
LEFT JOIN inventory_instance_types AS insttyp
	ON ins.instance_type_id = insttyp.id
LEFT JOIN instance_format_extract 
	ON ins.id = instance_format_extract.instance_id
LEFT JOIN inventory_instance_formats AS instfmt
	ON instance_format_extract.instance_format_id = instfmt.id
LEFT JOIN inventory_holdings AS h
	ON ins.id = h.instance_id
LEFT JOIN inventory_locations AS hpl
	ON h.permanent_location_id = hpl.id  
LEFT JOIN inventory_libraries AS lib
	ON hpl.library_id = lib.id
LEFT JOIN inventory_campuses AS cmp
	ON lib.campus_id = cmp.id
LEFT JOIN inventory_institutions AS inst
	ON cmp.institution_id = inst.id
GROUP BY
    inst.name,
    cmp.name,
    lib.name,
    insttyp.name,
    instfmt.name