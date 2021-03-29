DROP TABLE IF EXISTS folio_reporting.agreements_erm_resource;

-- Creates a derived table on agreements_erm_resource that has an entitlement linked and 
-- resolves values and labels from erm_agreements_refdata_value for:
--    res_sub_type_fk
--    res_type_fk
CREATE TABLE folio_reporting.agreements_erm_resource AS
SELECT
    id AS res_id,
    res_sub_type_fk,
    rst.rdv_value AS res_sub_type_fk_value,
    rst.rdv_label AS res_sub_type_fk_label,
    res_name,
    res_type_fk,
    rt.rdv_value AS res_type_fk_value,
    rt.rdv_label AS res_type_fk_label
FROM
    folio_agreements.erm_resource AS res
    INNER JOIN folio_agreements.entitlement AS ent ON res.id = ent.ent_resource_fk
    LEFT JOIN folio_agreements.refdata_value AS rst ON res.res_sub_type_fk = rst.rdv_id
    LEFT JOIN folio_agreements.refdata_value AS rt ON res.res_type_fk = rt.rdv_id;

CREATE INDEX ON folio_reporting.agreements_erm_resource (res_id);

CREATE INDEX ON folio_reporting.agreements_erm_resource (res_sub_type_fk);

CREATE INDEX ON folio_reporting.agreements_erm_resource (res_sub_type_fk_value);

CREATE INDEX ON folio_reporting.agreements_erm_resource (res_sub_type_fk_label);

CREATE INDEX ON folio_reporting.agreements_erm_resource (res_name);

CREATE INDEX ON folio_reporting.agreements_erm_resource (res_type_fk);

CREATE INDEX ON folio_reporting.agreements_erm_resource (res_type_fk_value);

CREATE INDEX ON folio_reporting.agreements_erm_resource (res_type_fk_label);

