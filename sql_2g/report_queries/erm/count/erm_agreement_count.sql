/** Documentation of ERM AGREEMENT COUNT QUERY

DERIVED TABLES
agreements_package_content_item
agreements_subscription_agreement_entitlement

TABLES
folio_agreements.refdata_value 

*/
SELECT
    sa_ent.subscription_agreement_name AS "Agreements",
    agrestat.rdv_label AS "Status",
    count(DISTINCT pci_list.pci_id) AS "Count"
FROM
    folio_reporting.agreements_package_content_item AS pci_list
    LEFT JOIN folio_reporting.agreements_subscription_agreement_entitlement AS sa_ent ON pci_list.entitlement_id = sa_ent.entitlement_id
    LEFT JOIN folio_agreements.refdata_value AS agrestat ON agrestat.rdv_id = sa_ent.subscription_agreement_agreement_status
GROUP BY
    sa_ent.subscription_agreement_name,
    agrestat.rdv_label;


