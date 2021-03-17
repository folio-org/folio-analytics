DROP TABLE IF EXISTS folio_reporting.licenses;

-- Create a derived table that contains information about licenses from the app license
--
-- Tables included:
--   folio_licenses.license
--   folio_licenses.license_org
--   folio_licenses.org
--   folio_licenses.refdata_value
CREATE TABLE folio_reporting.licenses AS
select 
	licenses_license.lic_id as "license_id",
	licenses_license.lic_name as "license_name",
	licenses_license.lic_description as "license_description",
	licenses_license.lic_start_date as "license_start",
	licenses_license.lic_end_date as "license_end",
	licenses_refdata_value2.rdv_value as "license_type",
	licenses_refdata_value3.rdv_value as "license_status",
	licenses_license_org2.org_name as "license_org",
	licenses_refdata_value.rdv_label as "license_org_role",
	licenses_license_org2.org_orgs_uuid as "license_org_uuid"
from 
	(
		folio_licenses.license as licenses_license
		left join
		folio_licenses.license_org as licenses_license_org on licenses_license.lic_id = licenses_license_org.sao_owner_fk
		left join 
		folio_licenses.org as licenses_license_org2 on licenses_license_org.sao_org_fk = licenses_license_org2.org_id
		left join 
		folio_licenses.refdata_value as licenses_refdata_value on licenses_refdata_value.rdv_id = licenses_license_org.sao_role
	)
	left JOIN
		folio_licenses.refdata_value as licenses_refdata_value2 on licenses_refdata_value2.rdv_id = licenses_license.lic_type_rdv_fk
	left join 
		folio_licenses.refdata_value as licenses_refdata_value3 on licenses_refdata_value3.rdv_id = licenses_license.lic_status_rdv_fk 
/* metadb specific attributes */
where 
	licenses_license."__current"
	and 
	licenses_license_org."__current" 
	and  
	licenses_license_org2."__current" 
	and 
	licenses_refdata_value."__current";

CREATE INDEX ON folio_reporting.licenses (license_id);

CREATE INDEX ON folio_reporting.licenses (license_name);

CREATE INDEX ON folio_reporting.licenses (license_description);

CREATE INDEX ON folio_reporting.licenses (license_start);

CREATE INDEX ON folio_reporting.licenses (license_end);

CREATE INDEX ON folio_reporting.licenses (license_type);

CREATE INDEX ON folio_reporting.licenses (license_status);

CREATE INDEX ON folio_reporting.licenses (license_org);

CREATE INDEX ON folio_reporting.licenses (license_org_role);

CREATE INDEX ON folio_reporting.licenses (license_org_uuid);