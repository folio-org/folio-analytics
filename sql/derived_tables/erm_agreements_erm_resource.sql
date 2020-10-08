DROP TABLE IF EXISTS local.erm_agreements_erm_resource;

-- Resolving values and labels from erm_agreements_refdata_value for:
--    res_sub_type_fk
--    res_type_fk

CREATE TABLE local.erm_agreements_erm_resource AS
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
    erm_agreements_erm_resource AS res
    LEFT JOIN erm_agreements_refdata_value AS rst ON res.res_sub_type_fk = rst.rdv_id
    LEFT JOIN erm_agreements_refdata_value AS rt ON res.res_type_fk = rt.rdv_id;

CREATE INDEX ON local.erm_agreements_erm_resource (res_id);

CREATE INDEX ON local.erm_agreements_erm_resource (res_sub_type_fk);

CREATE INDEX ON local.erm_agreements_erm_resource (res_sub_type_fk_value);

CREATE INDEX ON local.erm_agreements_erm_resource (res_sub_type_fk_label);

CREATE INDEX ON local.erm_agreements_erm_resource (res_name);

CREATE INDEX ON local.erm_agreements_erm_resource (res_type_fk);

CREATE INDEX ON local.erm_agreements_erm_resource (res_type_fk_value);

CREATE INDEX ON local.erm_agreements_erm_resource (res_type_fk_label);

