-- This derived table extracts tags from the instance record.
DROP TABLE IF EXISTS instance_tags;

CREATE TABLE instance_tags AS 
SELECT 
	it.id AS instance_id,
	it.hrid AS instance_hrid,
	insttags.jsonb #>> '{}' AS instance_tag,
	insttags.ordinality AS instance_tag_ordinality
FROM 
	folio_inventory.instance__t AS it
	LEFT JOIN folio_inventory.instance AS inst ON inst.id = it.id
	CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(inst.jsonb, 'tags', 'tagList')) WITH ORDINALITY AS insttags (jsonb);
	
CREATE INDEX ON instance_tags (instance_id);

CREATE INDEX ON instance_tags (instance_hrid);

CREATE INDEX ON instance_tags (instance_tag);

CREATE INDEX ON instance_tags (instance_tag_ordinality);

VACUUM ANALYZE instance_tags;
