-- Create a local table that includes the name for the mode of
-- issuance, resource type, and statuses.

CREATE TABLE local.instances_ext AS
SELECT instance.id AS instance_id,
       json_extract_path_text(instance.data, 'catalogedDate')
               AS cataloged_date,
       instance.discovery_suppress,
       instance.hrid,
       instance.index_title,
       instance.instance_type_id,
       instance_type.name AS instance_type_name,
       instance.mode_of_issuance_id,
       mode_of_issuance.name AS mode_of_issuance_name,
       instance.previously_held,
       instance.source AS instance_source,
       instance.staff_suppress,
       instance.status_id,
       instance_status.name AS instance_status_name,
       instance.title
FROM inventory_instances AS instance
    LEFT JOIN inventory_instance_types AS instance_type
        ON instance.instance_type_id = instance_type.id
    LEFT JOIN inventory_modes_of_issuance AS mode_of_issuance
        ON instance.mode_of_issuance_id = mode_of_issuance.id
    LEFT JOIN inventory_instance_statuses AS instance_status
        ON instance.status_id = instance_status.id;
