/* ACRL Volume Count
 * 
 *  An aggregate count of item records grouped by
 *      Institution Location
 *      Campus Location
 *      Library Location
 *      Item Location
 *      Material Type
 */

SELECT
    institutions.name AS "institution location name",
    campuses.name AS "campus location name",
    libraries.name AS "library location name",
    locations.name AS "item location name",
    material_type.name AS "material type name",
    COUNT(items.id) AS "item count"
FROM
    instances  
    LEFT JOIN holdings ON 
        instances.id = holdings.instance_id
    LEFT JOIN items ON 
        holdings.id = items.holdings_record_id
    LEFT JOIN locations ON
        items.permanent_location_id = locations.id
    LEFT JOIN institutions ON
        locations.institution_id = institutions.id
    LEFT JOIN campuses ON
        locations.campus_id = campuses.id
    LEFT JOIN libraries ON
        locations.library_id = libraries.id
    LEFT JOIN material_types material_type ON
        items.material_type_id = material_type.id
GROUP BY
    institutions.name,
    campuses.name,
    libraries.name,
    locations.name,
    material_type.name
