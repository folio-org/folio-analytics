--metadb:table agreements_subscription_agreement_org_ext

-- Creates a derived table on subscription_agreement_org joins related
-- values from org and resolves values and labels from
-- erm_agreements_refdata_value for sao_role

DROP TABLE IF EXISTS agreements_subscription_agreement_org_ext;

CREATE TABLE agreements_subscription_agreement_org_ext AS
SELECT
    sao.sao_id,
    sao.sao_owner_fk AS subscription_agreement_id,
    sao.sao_org_fk AS sao_org_id,
    org.org_name AS sao_org_name,
	saor.saor_role_fk AS sao_role_id,
    saorv.rdv_value AS sao_role_value,
    saorv.rdv_label AS sao_role_label,
    sao.sao_note,
    org.org_orgs_uuid::uuid
FROM
    folio_agreements.subscription_agreement_org AS sao
    LEFT JOIN folio_agreements.subscription_agreement_org_role AS saor ON sao.sao_id = saor.saor_owner_fk    
    LEFT JOIN folio_agreements.refdata_value AS saorv ON saorv.rdv_id = saor.saor_role_fk
    LEFT JOIN folio_agreements.org AS org ON org.org_id = sao.sao_org_fk;

CREATE INDEX ON agreements_subscription_agreement_org_ext (sao_id);

CREATE INDEX ON agreements_subscription_agreement_org_ext (subscription_agreement_id);

CREATE INDEX ON agreements_subscription_agreement_org_ext (sao_org_id);

CREATE INDEX ON agreements_subscription_agreement_org_ext (sao_org_name);

CREATE INDEX ON agreements_subscription_agreement_org_ext (sao_role_id);

CREATE INDEX ON agreements_subscription_agreement_org_ext (sao_role_value);

CREATE INDEX ON agreements_subscription_agreement_org_ext (sao_role_label);

CREATE INDEX ON agreements_subscription_agreement_org_ext (sao_note);

CREATE INDEX ON agreements_subscription_agreement_org_ext (org_orgs_uuid);

COMMENT ON COLUMN agreements_subscription_agreement_org_ext.sao_id IS 'UUID for subscription and organization pairing';

COMMENT ON COLUMN agreements_subscription_agreement_org_ext.subscription_agreement_id IS 'UUId for the subscritpion and agreement pairing';

COMMENT ON COLUMN agreements_subscription_agreement_org_ext.sao_org_id IS 'The unique UUID for an organization';

COMMENT ON COLUMN agreements_subscription_agreement_org_ext.sao_org_name IS 'The name of an organization';

COMMENT ON COLUMN agreements_subscription_agreement_org_ext.sao_role_id IS 'ID of the type of provider role';

COMMENT ON COLUMN agreements_subscription_agreement_org_ext.sao_role_value IS 'Name of the type of provider role';

COMMENT ON COLUMN agreements_subscription_agreement_org_ext.sao_role_label IS 'Public name of the type of provider role';

COMMENT ON COLUMN agreements_subscription_agreement_org_ext.sao_note IS 'Notes attached';

COMMENT ON COLUMN agreements_subscription_agreement_org_ext.org_orgs_uuid IS 'UUID of organization attached to the agreement';

