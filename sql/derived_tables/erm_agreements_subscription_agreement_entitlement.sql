DROP TABLE IF EXISTS local.erm_agreements_subscription_agreement_entitlement;

-- Join to get all identifiers as a base for harvesting needed data out of local KB and/or eHoldings

CREATE TABLE local.erm_agreements_subscription_agreement_entitlement AS
SELECT
    sa_id AS subscription_agreement_id,
    sa_agreement_type AS subscription_agreement_type,
    sa_name AS subscription_agreement_name,
    sa_local_reference AS subscription_agreement_local_reference,
    sa_agreement_status AS subscription_agreement_agreement_status,
    ent.ent_id AS entitlement_id,
    ent.ent_active_to AS entitlement_active_to,
    ent.ent_active_from AS entitlement_active_from,
    ent.ent_owner_fk AS entitlement_subscription_agreement_id,
    ent.ent_resource_fk AS entitlement_resource_fk,
    ent.ent_authority AS entitlement_authority,
    ent.ent_reference AS entitlement_reference
FROM
    erm_agreements_subscription_agreement AS sa
    LEFT JOIN erm_agreements_entitlement AS ent ON sa.sa_id = ent.ent_owner_fk;

CREATE INDEX ON local.erm_agreements_subscription_agreement_entitlement (subscription_agreement_id);

CREATE INDEX ON local.erm_agreements_subscription_agreement_entitlement (subscription_agreement_type);

CREATE INDEX ON local.erm_agreements_subscription_agreement_entitlement (subscription_agreement_name);

CREATE INDEX ON local.erm_agreements_subscription_agreement_entitlement (subscription_agreement_local_reference);

CREATE INDEX ON local.erm_agreements_subscription_agreement_entitlement (subscription_agreement_agreement_status);

CREATE INDEX ON local.erm_agreements_subscription_agreement_entitlement (entitlement_id);

CREATE INDEX ON local.erm_agreements_subscription_agreement_entitlement (entitlement_active_to);

CREATE INDEX ON local.erm_agreements_subscription_agreement_entitlement (entitlement_active_from);

CREATE INDEX ON local.erm_agreements_subscription_agreement_entitlement (entitlement_subscription_agreement_id);

CREATE INDEX ON local.erm_agreements_subscription_agreement_entitlement (entitlement_resource_fk);

CREATE INDEX ON local.erm_agreements_subscription_agreement_entitlement (entitlement_authority);

CREATE INDEX ON local.erm_agreements_subscription_agreement_entitlement (entitlement_reference);

