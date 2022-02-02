DROP TABLE IF EXISTS licenses_license_ext;

-- Create a derived table that contains information about licenses from the app license
--
-- Tables included:
--   folio_licenses.license
--   folio_licenses.license_org
--   folio_licenses.org
--   folio_licenses.refdata_value
CREATE TABLE licenses_license_ext AS
SELECT
    licenses_license.lic_id AS "license_id",
    licenses_license.lic_name AS "license_name",
    licenses_license.lic_description AS "license_description",
    licenses_license.lic_start_date AS "license_start",
    licenses_license.lic_end_date AS "license_end",
    licenses_refdata_value2.rdv_value AS "license_type",
    licenses_refdata_value3.rdv_value AS "license_status",
    licenses_license_org2.org_name AS "license_org",
    licenses_refdata_value.rdv_label AS "license_org_role",
    licenses_license_org2.org_orgs_uuid AS "license_org_uuid"
FROM (folio_licenses.license AS licenses_license
    LEFT JOIN folio_licenses.license_org AS licenses_license_org ON licenses_license.lic_id = licenses_license_org.sao_owner_fk
    LEFT JOIN folio_licenses.org AS licenses_license_org2 ON licenses_license_org.sao_org_fk = licenses_license_org2.org_id
    LEFT JOIN folio_licenses.refdata_value AS licenses_refdata_value ON licenses_refdata_value.rdv_id = licenses_license_org.sao_role)
    LEFT JOIN folio_licenses.refdata_value AS licenses_refdata_value2 ON licenses_refdata_value2.rdv_id = licenses_license.lic_type_rdv_fk
    LEFT JOIN folio_licenses.refdata_value AS licenses_refdata_value3 ON licenses_refdata_value3.rdv_id = licenses_license.lic_status_rdv_fk;

CREATE INDEX ON licenses_license_ext (license_id);

CREATE INDEX ON licenses_license_ext (license_name);

CREATE INDEX ON licenses_license_ext (license_description);

CREATE INDEX ON licenses_license_ext (license_start);

CREATE INDEX ON licenses_license_ext (license_end);

CREATE INDEX ON licenses_license_ext (license_type);

CREATE INDEX ON licenses_license_ext (license_status);

CREATE INDEX ON licenses_license_ext (license_org);

CREATE INDEX ON licenses_license_ext (license_org_role);

CREATE INDEX ON licenses_license_ext (license_org_uuid);

