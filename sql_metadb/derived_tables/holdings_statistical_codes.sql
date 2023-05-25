--metadb:table holdings_statistical_codes

-- Create a local holdings table with the id and name for the code and type.

DROP TABLE IF EXISTS holdings_statistical_codes;

CREATE TABLE holdings_statistical_codes AS
WITH stcodes AS (
    SELECT
        h.instanceid AS instance_id,
        jsonb_extract_path_text(i.jsonb, 'hrid') AS instance_hrid,
        h.id AS holdings_id,
        jsonb_extract_path_text(h.jsonb, 'hrid') AS holdings_hrid,
        (sc.jsonb #>> '{}') ::uuid AS statistical_code_id,
        sc.ordinality AS statistical_code_ordinality
    FROM
        folio_inventory.holdings_record AS h
    LEFT JOIN folio_inventory.instance AS i ON h.instanceid = i.id
    CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(h.jsonb, 'statisticalCodeIds')) WITH ORDINALITY AS sc (jsonb)
)
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
    stc.statistical_code_ordinality
FROM
    stcodes AS stc
    LEFT JOIN folio_inventory.statistical_code__t AS sct ON stc.statistical_code_id::uuid = sct.id::uuid
    LEFT JOIN folio_inventory.statistical_code_type__t AS sctt ON sct.statistical_code_type_id::uuid = sctt.id::uuid;


