DROP TABLE if exists local.instances_contributors
--Create a derived table for contributors from instance records

CREATE TABLE local.instances_contributors AS

SELECT
	instance.id AS ins_id,
	instance.hrid AS ins_hrid,
	json_extract_path_text(contributors.data, 'contributorNameTypeId') AS ins_contributor_name_type_id,
	inventory_contributor_name_types.name AS ins_contributor_name_type,
	json_extract_path_text(contributors.data, 'contributorTypeId') AS ins_contributor_rdatype_id,
	inventory_contributor_types.name AS ins_contributor_rdatype_name,
	json_extract_path_text(contributors.data, 'contributorTypeText') AS ins_contributor_type_freetext,
	json_extract_path_text(contributors.data, 'name') AS ins_contributor_name,
	json_extract_path_text(contributors.data, 'primary') AS ins_contributor_primary
FROM 
	inventory_instances AS instance
	CROSS JOIN json_array_elements(json_extract_path(instance.data, 'contributors')) AS contributors(data)
	LEFT JOIN inventory_contributor_name_types ON json_extract_path_text(contributors.data, 'contributorNameTypeId') = inventory_contributor_name_types.id
	LEFT JOIN inventory_contributor_types ON json_extract_path_text(contributors.DATA, 'contributorTypeId') = inventory_contributor_types.id;

CREATE INDEX ON local.instances_contributors (ins_id);

CREATE INDEX ON local.instances_contributors (ins_hrid);

CREATE INDEX ON local.instances_contributors (ins_contributor_name_type_id);

CREATE INDEX ON local.instances_contributors (ins_contributor_name_type);

CREATE INDEX ON local.instances_contributors (ins_contributor_rdatype_id);

CREATE INDEX ON local.instances_contributors (ins_contributor_rdatype_name);

CREATE INDEX ON local.instances_contributors (ins_contributor_type_freetext);

CREATE INDEX ON LOCAL.instances_contributors (ins_contributor_name);

CREATE INDEX ON local.instances_contributors (ins_contributor_primary);
