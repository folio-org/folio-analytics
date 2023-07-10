--metadb:table licenses_license_ext

-- Create a derived table that contains information about licenses from the app license

DROP TABLE IF EXISTS licenses_license_ext;

CREATE TABLE licenses_license_ext AS
SELECT
    license.lic_id AS license_id,
    license.lic_name AS license_name,
    license.lic_description AS license_description,
    license.lic_start_date AS license_start,
    license.lic_end_date AS license_end,
    licenses_type.rdv_value AS license_type,
    license_status.rdv_value AS license_status,
    org.org_name AS license_org,
    license_org_role_value.rdv_label AS license_org_role,
    org.org_orgs_uuid::uuid AS license_org_uuid
FROM
    folio_licenses.license
    LEFT JOIN folio_licenses.license_org ON license_org.sao_owner_fk = license.lic_id
    LEFT JOIN folio_licenses.org ON org.org_id = license_org.sao_org_fk
    LEFT JOIN folio_licenses.refdata_value AS licenses_type ON licenses_type.rdv_id = license.lic_type_rdv_fk
    LEFT JOIN folio_licenses.refdata_value AS license_status ON license_status.rdv_id = license.lic_status_rdv_fk
    LEFT JOIN folio_licenses.license_org_role ON license_org_role.lior_owner_fk = license_org.sao_id
    LEFT JOIN folio_licenses.refdata_value AS license_org_role_value ON license_org_role_value.rdv_id = license_org_role.lior_role_fk;

COMMENT ON COLUMN licenses_license_ext.license_id IS 'The UUID of the license';

COMMENT ON COLUMN licenses_license_ext.license_name IS 'Name of license';

COMMENT ON COLUMN licenses_license_ext.license_description IS 'Description of license';

COMMENT ON COLUMN licenses_license_ext.license_start IS 'Start date of this license';

COMMENT ON COLUMN licenses_license_ext.license_end IS 'End date of this license';

COMMENT ON COLUMN licenses_license_ext.license_type IS 'Reference data value for license type';

COMMENT ON COLUMN licenses_license_ext.license_status IS 'Reference data value for license status';

COMMENT ON COLUMN licenses_license_ext.license_org IS 'Name of the organization';

COMMENT ON COLUMN licenses_license_ext.license_org_role IS 'Reference data value for the role of the organization';

COMMENT ON COLUMN licenses_license_ext.license_org_uuid IS 'UUID of organization';

