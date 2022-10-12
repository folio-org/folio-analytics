/* ACRL Title Count
 *  
 *  An aggregate count of instance records grouped by 
 *      Institution Location
 *      Campus Location
 *      Library Location
 *      Instance Type
 *      Instance Format
 */


/** Unnesting arrays in Redshift is a multi-step process:
 *  - isolate specific array with json_extract_path_text and find the lengths for each record with json_array_length
 *  - generate a table of integers at least as long as the longest array
 *  - cross join the integers with the arrays, filtering out rows where the number goes past the length of the array
 *  - use the integer to extract the specific element out of the array
 *  - use json_extract_path_text or other functions to deal with the isolated array elements
 *  (based on https://blog.getdbt.com/how-to-unnest-arrays-in-redshift/) **/
-- NUMBERS TABLE HAS TO BE LARGER THAN LENGTH OF LARGEST ARRAY
WITH numbers_table AS (
    SELECT 0 AS i
    UNION ALL SELECT 1
    UNION ALL SELECT 2
    UNION ALL SELECT 3
    UNION ALL SELECT 4
    UNION ALL SELECT 5
    UNION ALL SELECT 6
    UNION ALL SELECT 7
    UNION ALL SELECT 8
    UNION ALL SELECT 9
    UNION ALL SELECT 10
    UNION ALL SELECT 11
    UNION ALL SELECT 12
    UNION ALL SELECT 13
    UNION ALL SELECT 14
    UNION ALL SELECT 15
    UNION ALL SELECT 16
    UNION ALL SELECT 17
    UNION ALL SELECT 18
    UNION ALL SELECT 19
    UNION ALL SELECT 20
    UNION ALL SELECT 21
    UNION ALL SELECT 22
    UNION ALL SELECT 23
    UNION ALL SELECT 24
    UNION ALL SELECT 25
    UNION ALL SELECT 26
    UNION ALL SELECT 27
    UNION ALL SELECT 28
    UNION ALL SELECT 29
    UNION ALL SELECT 30
    UNION ALL SELECT 31
    UNION ALL SELECT 32
    UNION ALL SELECT 33
    UNION ALL SELECT 34
    UNION ALL SELECT 35
    UNION ALL SELECT 36
    UNION ALL SELECT 37
    UNION ALL SELECT 38
    UNION ALL SELECT 39
    UNION ALL SELECT 40
    UNION ALL SELECT 41
    UNION ALL SELECT 42
    UNION ALL SELECT 43
    UNION ALL SELECT 44
    UNION ALL SELECT 45
    UNION ALL SELECT 46
    UNION ALL SELECT 47
    UNION ALL SELECT 48
    UNION ALL SELECT 49
    UNION ALL SELECT 50
    UNION ALL SELECT 51
    UNION ALL SELECT 52
    UNION ALL SELECT 53
    UNION ALL SELECT 54
    UNION ALL SELECT 55
    UNION ALL SELECT 56
    UNION ALL SELECT 57
    UNION ALL SELECT 58
    UNION ALL SELECT 59
    UNION ALL SELECT 60
    UNION ALL SELECT 61
    UNION ALL SELECT 62
    UNION ALL SELECT 63
    UNION ALL SELECT 64
    UNION ALL SELECT 65
    UNION ALL SELECT 66
    UNION ALL SELECT 67
    UNION ALL SELECT 68
    UNION ALL SELECT 69
    UNION ALL SELECT 70
    UNION ALL SELECT 71
    UNION ALL SELECT 72
    UNION ALL SELECT 73
    UNION ALL SELECT 74
    UNION ALL SELECT 75
    UNION ALL SELECT 76
    UNION ALL SELECT 77
    UNION ALL SELECT 78
    UNION ALL SELECT 79
    UNION ALL SELECT 80
    UNION ALL SELECT 81
    UNION ALL SELECT 82
    UNION ALL SELECT 83
    UNION ALL SELECT 84
    UNION ALL SELECT 85
    UNION ALL SELECT 86
    UNION ALL SELECT 87
    UNION ALL SELECT 88
    UNION ALL SELECT 89
    UNION ALL SELECT 90
    UNION ALL SELECT 91
    UNION ALL SELECT 92
    UNION ALL SELECT 93
    UNION ALL SELECT 94
    UNION ALL SELECT 95
    UNION ALL SELECT 96
    UNION ALL SELECT 97
    UNION ALL SELECT 98
    UNION ALL SELECT 99
),
instance_formats_objects AS (
    SELECT
        id AS instance_id,
        json_extract_path_text(data, 'instanceFormatIds', true) AS objects
        -- Add array length to every objects table, so where clause can refer by name?
    FROM
        inventory_instances
),
instance_formats_expanded AS (
    SELECT
        instance_formats_objects.instance_id AS instance_id,
        --shouldn't need to select array length here; just needed for WHERE clause, not output
        json_array_length(instance_formats_objects.objects, true) as number_of_items,
        json_extract_array_element_text(
            instance_formats_objects.objects, 
            numbers_table.i::int, 
            true
        ) AS instance_format_id
    FROM instance_formats_objects
    CROSS JOIN numbers_table
    WHERE numbers_table.i <
        json_array_length(instance_formats_objects.objects, true)
),
instance_format_names AS (
    SELECT 
        instance_id,
        LISTAGG(DISTINCT inventory_instance_formats.name, '|' :: VARCHAR) AS instance_format_names
    FROM instance_formats_expanded
    LEFT JOIN inventory_instance_formats
        ON instance_formats_expanded.instance_format_id = inventory_instance_formats.id
    GROUP BY instance_formats_expanded.instance_id
)
SELECT
    inst.name AS "institution location name",
    cmp.name AS "campus location name",
    lib.name AS "library location name",
    insttyp.name AS "instance type name",
    instance_format_names.instance_format_names AS "instance format name", 
    COUNT(ins.id) AS title_count
FROM inventory_instances AS ins
LEFT JOIN inventory_instance_types AS insttyp
	ON ins.instance_type_id = insttyp.id
LEFT JOIN instance_format_names 
	ON ins.id = instance_format_names.instance_id
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
    instance_format_names.instance_format_names
