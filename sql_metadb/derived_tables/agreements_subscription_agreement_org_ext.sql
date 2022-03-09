DROP TABLE IF EXISTS agreements_subscription_agreement_org_ext;

-- Creates a derived table on subscription_agreement_org joins related values from org and
-- resolves values and labels from erm_agreements_refdata_value for sao_role
CREATE TABLE agreements_subscription_agreement_org_ext AS
SELECT
    sao.sao_id,
    sao.sao_owner_fk AS subscription_agreement_id,
    sao.sao_org_fk AS sao_org_id,
    org.org_name AS sao_org_name,
    sao.sao_role AS sao_role_id,
    saor.rdv_value AS sao_role_value,
    saor.rdv_label AS sao_role_label,
    sao.sao_note,
    org.org_orgs_uuid::uuid
FROM
    folio_agreements.subscription_agreement_org AS sao
    LEFT JOIN folio_agreements.refdata_value AS saor ON sao.sao_role = saor.rdv_id
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

VACUUM ANALYZE agreements_subscription_agreement_org_ext;
