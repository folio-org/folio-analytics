--metadb:table instance_alternative_titles

--This derived table extracts data for the instance alternative titles.
--It includes the instance uuid, hrid, the alternative title, type, uuid, and the name associated with that type uuid.
--Ordinality has been included.

DROP TABLE IF EXISTS instance_alternative_titles;

CREATE TABLE instance_alternative_titles AS
SELECT
    i.id AS instance_id,
    jsonb_extract_path_text(i.jsonb, 'hrid') AS instance_hrid,
    jsonb_extract_path_text(titles.jsonb, 'alternativeTitle') AS alternative_title,
    jsonb_extract_path_text(titles.jsonb, 'alternativeTitleTypeId')::uuid AS alternative_title_type_id,
    titles.ordinality AS alternative_title_ordinality,
    jsonb_extract_path_text(att.jsonb, 'name') AS alternative_title_type_name
FROM
    folio_inventory.instance AS i
    CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(i.jsonb, 'alternativeTitles')) WITH ORDINALITY AS titles (jsonb)
    LEFT JOIN folio_inventory.alternative_title_type AS att ON jsonb_extract_path_text(titles.jsonb, 'alternativeTitleTypeId')::uuid = att.id;

CREATE INDEX ON instance_alternative_titles (instance_id);

CREATE INDEX ON instance_alternative_titles (instance_hrid);

CREATE INDEX ON instance_alternative_titles (alternative_title);

CREATE INDEX ON instance_alternative_titles (alternative_title_type_id);

CREATE INDEX ON instance_alternative_titles (alternative_title_ordinality);

CREATE INDEX ON instance_alternative_titles (alternative_title_type_name);

VACUUM ANALYZE instance_alternative_titles;

