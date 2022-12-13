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
    inst.name AS "institution location name",
    cmp.name AS "campus location name",
    lib.name AS "library location name",
    itpl.name AS "item location name",
    mt.name AS "material type name",
    COUNT(i.id) AS item_count
FROM
    inventory_instances AS ins 
    LEFT JOIN inventory_holdings AS h 
    	ON ins.id = h.instance_id
    LEFT JOIN inventory_items AS i
    	ON h.id = i.holdings_record_id
    LEFT JOIN inventory_locations AS itpl
    	ON i.permanent_location_id = itpl.id
    LEFT JOIN inventory_institutions AS inst
    	ON itpl.institution_id = inst.id
    LEFT JOIN inventory_campuses AS cmp
    	ON itpl.campus_id = cmp.id
    LEFT JOIN inventory_libraries AS lib
    	ON itpl.library_id = lib.id
    LEFT JOIN inventory_material_types AS mt 
    	ON i.material_type_id = mt.id
GROUP BY
    inst.name,
    cmp.name,
    lib.name,
    itpl.name,
    mt.name
