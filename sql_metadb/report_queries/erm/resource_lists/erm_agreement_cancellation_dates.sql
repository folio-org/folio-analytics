-- Creates a report that contains an overview of agreements and their cancellation deadlines.
--
-- The filters can be used, for example, to display agreements whose cancellation deadline is within a certain period of time.
WITH parameters AS (
    SELECT
        'vendor' AS sao_role, -- required to restrict the table column "agreement_vendor" to vendor.
        '2022-01-01'::date AS agreement_cancellation_interval_start, -- required, start date for cancellation interval, e.g. 2022-01-01
        '2022-12-31'::date AS agreement_cancellation_interval_end, -- required, end date for cancellation interval, e.g. 2022-12-31
        'active' AS agreement_status, -- Enter your agreement_status eg. 'active', 'closed', 'draft', 'requested' etc.
        'yes' AS agreement_is_perpetual -- Enter your selection for agreement perpetual
),
organizations AS (
    SELECT
        *
    FROM
        folio_agreements.subscription_agreement_org AS subscription_agreement_org
        LEFT JOIN folio_agreements.org AS agreement_org ON agreement_org.org_id = subscription_agreement_org.sao_org_fk
        LEFT JOIN folio_agreements.refdata_value AS sao_role ON sao_role.rdv_id = subscription_agreement_org.sao_role
    WHERE
        sao_role.rdv_value = (SELECT sao_role FROM parameters)
),
internal_contacts AS (
    SELECT
        internal_contact.ic_owner_fk,
        jsonb_extract_path_text(users_users."jsonb", 'personal', 'lastName') || ', ' || jsonb_extract_path_text(users_users."jsonb", 'personal', 'firstName') AS names
    FROM
        folio_agreements.internal_contact AS internal_contact
        LEFT JOIN folio_agreements.refdata_value AS internal_contact_refdata_value ON internal_contact_refdata_value.rdv_id = internal_contact.ic_role
        LEFT JOIN folio_users.users AS users_users ON jsonb_extract_path_text(users_users."jsonb", 'id') = internal_contact.ic_user_fk
)
SELECT
    subscription_agreement.sa_id AS agreement_id,
    subscription_agreement.sa_name AS agreement_name,
    agreements_erm_resource.res_name AS agreement_res_name,
    subscription_agreement.sa_cancellation_deadline AS agreement_cancellation_deadline,
    agreement_is_perpetual.rdv_value AS agreement_is_perpetual,
    agreement_status.rdv_value AS agreement_status,
    organizations.org_name AS agreement_vendor,
    internal_contacts.names AS agreement_internal_contact,
    agreements_order_line.pol_orders_fk AS pol_uuid
FROM
    folio_agreements.subscription_agreement AS subscription_agreement
    LEFT JOIN folio_agreements.refdata_value AS agreement_is_perpetual ON agreement_is_perpetual.rdv_id = subscription_agreement.sa_is_perpetual
    LEFT JOIN folio_agreements.refdata_value AS agreement_status ON agreement_status.rdv_id = subscription_agreement.sa_agreement_status
    LEFT JOIN organizations ON organizations.sao_owner_fk = subscription_agreement.sa_id
    LEFT JOIN internal_contacts ON internal_contacts.ic_owner_fk = subscription_agreement.sa_id
    LEFT JOIN folio_agreements.entitlement AS agreements_entitlement ON agreements_entitlement.ent_owner_fk = subscription_agreement.sa_id
    LEFT JOIN folio_agreements.erm_resource AS agreements_erm_resource ON agreements_erm_resource.id = agreements_entitlement.ent_resource_fk
    LEFT JOIN folio_agreements.order_line AS agreements_order_line ON agreements_order_line.pol_owner_fk = agreements_entitlement.ent_id
WHERE
    subscription_agreement.sa_cancellation_deadline BETWEEN (SELECT agreement_cancellation_interval_start FROM parameters) AND (SELECT agreement_cancellation_interval_end FROM parameters)
    AND
    (agreement_status.rdv_value = (SELECT agreement_status FROM parameters)) OR ((SELECT agreement_status FROM parameters) = '')
    AND
    (agreement_is_perpetual.rdv_value = (SELECT agreement_is_perpetual FROM parameters)) OR ((SELECT agreement_is_perpetual FROM parameters) = '')
ORDER BY
    subscription_agreement.sa_name;
