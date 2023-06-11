DROP TABLE IF EXISTS instance_ext;

-- Create a local table that includes the name for the mode of
-- issuance, resource type, and statuses.
CREATE TABLE instance_ext AS
SELECT
    instance.id AS instance_id,
    instance.hrid AS instance_hrid,
    instance.cataloged_date,
    instance.title,
    instance.index_title,
    instance.instance_type_id AS type_id,
    instance_type.name AS type_name,
    instance.mode_of_issuance_id,
    mode_of_issuance.name AS mode_of_issuance_name,
    instance.previously_held,
    instance.source AS instance_source,
    instance.discovery_suppress,
    instance.staff_suppress,
    instance.status_id,
    instance_status.name AS status_name,
    instance.status_updated_date,
    instance.source AS record_source,
    instance.data #>> '{metadata,createdDate}' AS record_created_date,
    instance.data #>> '{metadata,updatedByUserId}' AS updated_by_user_id,
    instance.data #>> '{metadata,updatedDate}' AS updated_date
FROM
    inventory_instances AS instance
    LEFT JOIN inventory_instance_types AS instance_type ON instance.instance_type_id = instance_type.id
    LEFT JOIN inventory_modes_of_issuance AS mode_of_issuance ON instance.mode_of_issuance_id = mode_of_issuance.id
    LEFT JOIN inventory_instance_statuses AS instance_status ON instance.status_id = instance_status.id;

