--metadb:table agreements_subscription_agreement

-- Creates a derived table on agreements_subscription_agreement and
-- resolves values and labels from erm_agreements_refdata_value for:
--    sa_renewal_priority
--    sa_is_perpetual
--    sa_agreement_status
--    sa_reason_for_closure

DROP TABLE IF EXISTS agreements_subscription_agreement;

CREATE TABLE agreements_subscription_agreement AS
SELECT
    sa_id,
    sa_renewal_priority,
    sarp.rdv_value AS sa_renewal_priority_value,
    sarp.rdv_label AS sa_renewal_priority_label,
    sa_is_perpetual,
    saip.rdv_value AS sa_is_perpetual_value,
    saip.rdv_label AS sa_is_perpetual_label,
    sa_name,
    sa_local_reference,
    sa_agreement_status,
    saas.rdv_value AS sa_agreement_status_value,
    saas.rdv_label AS sa_agreement_status_label,
    sa_description,
    sa_license_note,
    sa_reason_for_closure,
    sarfc.rdv_value AS sa_reason_for_closure_value,
    sarfc.rdv_label AS sa_reason_for_closure_label,
    custom_properties_id AS sa_custom_properties_id
FROM
    folio_agreements.subscription_agreement AS sa
    LEFT JOIN folio_agreements.refdata_value AS sarp ON sa.sa_renewal_priority = sarp.rdv_id
    LEFT JOIN folio_agreements.refdata_value AS saip ON sa.sa_is_perpetual = saip.rdv_id
    LEFT JOIN folio_agreements.refdata_value AS saas ON sa.sa_agreement_status = saas.rdv_id
    LEFT JOIN folio_agreements.refdata_value AS sarfc ON sa.sa_reason_for_closure = sarfc.rdv_id;

CREATE INDEX ON agreements_subscription_agreement (sa_id);

CREATE INDEX ON agreements_subscription_agreement (sa_renewal_priority);

CREATE INDEX ON agreements_subscription_agreement (sa_renewal_priority_value);

CREATE INDEX ON agreements_subscription_agreement (sa_renewal_priority_label);

CREATE INDEX ON agreements_subscription_agreement (sa_is_perpetual);

CREATE INDEX ON agreements_subscription_agreement (sa_is_perpetual_value);

CREATE INDEX ON agreements_subscription_agreement (sa_is_perpetual_label);

CREATE INDEX ON agreements_subscription_agreement (sa_name);

CREATE INDEX ON agreements_subscription_agreement (sa_local_reference);

CREATE INDEX ON agreements_subscription_agreement (sa_agreement_status);

CREATE INDEX ON agreements_subscription_agreement (sa_agreement_status_value);

CREATE INDEX ON agreements_subscription_agreement (sa_agreement_status_label);

CREATE INDEX ON agreements_subscription_agreement (sa_description);

CREATE INDEX ON agreements_subscription_agreement (sa_license_note);

CREATE INDEX ON agreements_subscription_agreement (sa_reason_for_closure);

CREATE INDEX ON agreements_subscription_agreement (sa_reason_for_closure_value);

CREATE INDEX ON agreements_subscription_agreement (sa_reason_for_closure_label);

CREATE INDEX ON agreements_subscription_agreement (sa_custom_properties_id);

COMMENT ON COLUMN agreements_subscription_agreement.sa_id IS 'UUID of Agreement';

COMMENT ON COLUMN agreements_subscription_agreement.sa_renewal_priority IS 'ID of reference data value for renewal priority';

COMMENT ON COLUMN agreements_subscription_agreement.sa_renewal_priority_value IS 'Describes whether an agreement should be renewed, reviewed or cancelled';

COMMENT ON COLUMN agreements_subscription_agreement.sa_renewal_priority_label IS 'Displayed name of renewal priority';

COMMENT ON COLUMN agreements_subscription_agreement.sa_is_perpetual IS 'ID of reference data value for is perpetual';

COMMENT ON COLUMN agreements_subscription_agreement.sa_is_perpetual_value IS 'Describes whether the agreement is a perpetual agreement or not';

COMMENT ON COLUMN agreements_subscription_agreement.sa_is_perpetual_label IS 'Displayed name of is perpetual';

COMMENT ON COLUMN agreements_subscription_agreement.sa_name IS 'A name for the agreement assigned by the institution';

COMMENT ON COLUMN agreements_subscription_agreement.sa_local_reference IS 'Where an agreement has been created through an integration / data import from an external system the sa_local_reference is used to store a reference/identifier for the agreement in the external system to support ongoing data synchronisation/updates';

COMMENT ON COLUMN agreements_subscription_agreement.sa_agreement_status IS 'ID of reference data value for agreement status';

COMMENT ON COLUMN agreements_subscription_agreement.sa_agreement_status_value IS 'Describes the current status of the agreement (e.g. Active, Closed)';

COMMENT ON COLUMN agreements_subscription_agreement.sa_agreement_status_label IS 'Displayed name of agreement status';

COMMENT ON COLUMN agreements_subscription_agreement.sa_description IS 'A description for the agreement assigned by the institution';

COMMENT ON COLUMN agreements_subscription_agreement.sa_license_note IS 'To record any general information about the license for the Agreement';

COMMENT ON COLUMN agreements_subscription_agreement.sa_reason_for_closure IS 'ID of reference data value for reason for closure';

COMMENT ON COLUMN agreements_subscription_agreement.sa_reason_for_closure_value IS 'Describes for a closed agreement, the reason the agreement has been closed ';

COMMENT ON COLUMN agreements_subscription_agreement.sa_reason_for_closure_label IS 'Displayed name of reason for closure';

COMMENT ON COLUMN agreements_subscription_agreement.sa_custom_properties_id IS 'ID used to link custom_properties';

VACUUM ANALYZE agreements_subscription_agreement;

