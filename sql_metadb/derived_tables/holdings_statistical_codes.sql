DROP TABLE IF EXISTS holdings_statistical_codes;
CREATE TABLE holding_statistical_codes AS 
WITH stcodes AS (
    SELECT 
    h.instanceid AS instance_id, 
    jsonb_extract_path_text(i.jsonb, 'hrid') AS instance_hrid,
    h.id AS holdings_id, 
    jsonb_extract_path_text(h.jsonb, 'hrid') AS holdings_hrid,
    (statcodes.jsonb #>> '{}')::uuid AS statistical_code_id,
    statcodes.ordinality AS stat_code_ordinality
    FROM 
    folio_inventory.holdings_record h
    LEFT JOIN folio_inventory.INSTANCE i ON h.instanceid = i.id
    CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(h.jsonb, 'statisticalCodeIds'))
    WITH ordinality AS statcodes (jsonb))
SELECT
    stc.instance_id,
    stc.instance_hrid,
    stc.holdings_id,
    stc.holdings_hrid,
    stc.statistical_code_id,
    sct.statistical_code_type_id::uuid,
    sctt.name AS statistical_code_type_name,
    sct.code AS statistical_code,
    sct.name AS statistical_code_name,
    stc.stat_code_ordinality 
FROM 
    stcodes AS stc
    LEFT JOIN folio_inventory.statistical_code__t AS sct ON stc.statistical_code_id::uuid = sct.id::uuid 
    LEFT JOIN folio_inventory.statistical_code_type__t AS sctt ON sct.statistical_code_type_id::uuid = sctt.id::uuid;
    
CREATE INDEX ON holdings_statistical_codes (instance_id);
CREATE INDEX ON holdings_statistical_codes (instance_hrid);
CREATE INDEX ON holdings_statistical_codes (holdings_id);
CREATE INDEX ON holdings_statistical_codes (holdings_hrid);
CREATE INDEX ON holdings_statistical_codes (statistical_code_id);
CREATE INDEX ON holdings_statistical_codes (statistical_code_type_id);
CREATE INDEX ON holdings_statistical_codes (statistical_code_type_name);
CREATE INDEX ON holdings_statistical_codes (statistical_code);
CREATE INDEX ON hldings_statistical_codes (statistical_code_name);
CREATE INDEX ON holdings_statistical_codes (stat_code_ordinality);
VACUUM ANALYZE holdings_statistical_codes;