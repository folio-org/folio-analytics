-- Creates a derived table that extracts the service points array from 
-- locations and creates a direct connection between the locations and
-- all of their service points.
 
DROP TABLE IF EXISTS locations_service_points;

CREATE TABLE locations_service_points AS
    SELECT 
        service_points.data #>> '{}' AS service_point_id,  
        isp.discovery_display_name AS service_point_discovery_display_name,
        isp.name AS service_point_name,
        ll.location_id,
        ll.discovery_display_name AS location_discovery_display_name,
        ll.location_name,
        ll.library_id,
        ll.library_name,
        ll.campus_id, 
        ll.campus_name,
        ll.institution_id,
        ll.institution_name 
    FROM public.inventory_locations AS il
        CROSS JOIN json_array_elements(json_extract_path(il.data, 'servicePointIds')) AS service_points (data)
        LEFT JOIN public.inventory_service_points AS isp ON service_points.data #>> '{}' = isp.id 
        LEFT JOIN locations_libraries AS ll ON il.id=ll.location_id 
;

CREATE INDEX ON locations_service_points (service_point_id);

CREATE INDEX ON locations_service_points (service_point_discovery_display_name);

CREATE INDEX ON locations_service_points (service_point_name);

CREATE INDEX ON locations_service_points (location_id);

CREATE INDEX ON locations_service_points (location_discovery_display_name);

CREATE INDEX ON locations_service_points (location_name);  

CREATE INDEX ON locations_service_points (library_id);

CREATE INDEX ON locations_service_points (library_name);

CREATE INDEX ON locations_service_points (campus_id);  

CREATE INDEX ON locations_service_points (campus_name);

CREATE INDEX ON locations_service_points (institution_id);  

CREATE INDEX ON locations_service_points (institution_name);

VACUUM ANALYZE  locations_service_points;

