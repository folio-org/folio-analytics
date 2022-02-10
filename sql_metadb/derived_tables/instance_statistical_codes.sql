--This derived table extracts data for the instance statistical codes. 
--It includes the instance uuid, hrid, the statistical code uuid, name, associated code, type id and name.
--Ordinality has been included.
DROP TABLE IF EXISTS instance_statistical_codes;

CREATE TABLE instance_statistical_codes AS 
WITH stcodes AS (
	SELECT 
		i.id::uuid AS instance_id,
		jsonb_extract_path_text(i.jsonb, 'hrid') AS instance_hrid,
		statcodes.jsonb #>> '{}' AS statistical_code_id,
		statcodes.ordinality AS stat_code_ordinality
	FROM 
		folio_inventory.instance AS i 
		CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(i.jsonb, 'statisticalCodeIds')) WITH ORDINALITY AS statcodes (jsonb)
)
SELECT
	stc.instance_id,
	stc.instance_hrid,
	stc.statistical_code_id,
	stc.stat_code_ordinality,
	sct.statistical_code_type_id,
	sctt.name AS statistical_code_type_name,
	sct.code AS statistical_code,
	sct.name AS statistical_code_name,
	stc.stat_code_ordinality 
FROM 
	stcodes AS stc
	LEFT JOIN folio_inventory.statistical_code__t AS sct ON stc.statistical_code_id::uuid = sct.id::uuid 
	LEFT JOIN folio_inventory.statistical_code_type__t AS sctt ON sct.statistical_code_type_id::uuid = sctt.id::uuid;
	
CREATE INDEX ON instance_statistical_codes (instance_id);

CREATE INDEX ON instance_statistical_codes (instance_hrid);

CREATE INDEX ON instance_statistical_codes (statistical_code_id);

CREATE INDEX ON instance_statistical_codes (statistical_code_type_id);

CREATE INDEX ON instance_statistical_codes (statistical_code_type_name);

CREATE INDEX ON instance_statistical_codes (statistical_code);

CREATE INDEX ON instance_statistical_codes (statistical_code_name);

CREATE INDEX ON instance_statistical_codes (stat_code_ordinality);

VACUUM ANALYZE instance_statistical_codes; 

