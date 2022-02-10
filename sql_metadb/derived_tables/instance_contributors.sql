--This derived table extracts data for the instance contributors. 
--It includes the instance uuid, hrid, the contributor's name, if it is primary, type id, type name, type text, name type id and name type.
--Ordinality has been included.
DROP TABLE IF EXISTS instance_contributors;

CREATE TABLE instance_contributors AS 
WITH contribs AS (
	SELECT 
		i.id AS instance_id,
		jsonb_extract_path_text(i.jsonb, 'hrid') AS instance_hrid,
		jsonb_extract_path_text(ctb.jsonb, 'name') AS contributor_name,
		jsonb_extract_path_text(ctb.jsonb, 'primary')::boolean AS contributor_is_primary,
		jsonb_extract_path_text(ctb.jsonb, 'contributorTypeId')::uuid AS contributor_type_id,
		jsonb_extract_path_text(ctb.jsonb, 'contributorTypeText') AS contributor_type_text,
		jsonb_extract_path_text(ctb.jsonb, 'contributorNameTypeId')::uuid AS contributor_name_type_id,
    	ctb.ordinality AS contributor_ordinality
	FROM 
		folio_inventory.instance i
		CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(i.jsonb, 'contributors')) WITH ORDINALITY AS ctb (jsonb)
)
SELECT 
	ctbs.instance_id,
	ctbs.instance_hrid,
	ctbs.contributor_name,
	ctbs.contributor_is_primary,
	ctbs.contributor_type_id,
	ctt.name AS contributor_type_name,
	ctbs.contributor_type_text,
	ctbs.contributor_name_type_id,
	cntt.name AS contributor_name_type_name,
	ctbs.contributor_ordinality 
FROM 
	contribs AS ctbs
	LEFT JOIN folio_inventory.contributor_type__t AS ctt ON ctbs.contributor_type_id = ctt.id
	LEFT JOIN folio_inventory.contributor_name_type__t AS cntt ON ctbs.contributor_name_type_id = cntt.id ; 
	
CREATE INDEX ON instance_contributors (instance_id);

CREATE INDEX ON instance_contributors (instance_hrid);

CREATE INDEX ON instance_contributors (contributor_name);

CREATE INDEX ON instance_contributors (contributor_is_primary);

CREATE INDEX ON instance_contributors (contributor_type_id);

CREATE INDEX ON instance_contributors (contributor_type_name);

CREATE INDEX ON instance_contributors (contributor_type_text);

CREATE INDEX ON instance_contributors (contributor_name_type_id);

CREATE INDEX ON instance_contributors (contributor_name_type_name);

CREATE INDEX ON instance_contributors (contributor_ordinality);

VACUUM ANALYZE instance_contributors; 