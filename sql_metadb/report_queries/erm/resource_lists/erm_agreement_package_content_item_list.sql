/*
 * description:
 * -------------
 * The report shows e-resources that are covered by an agreement.
 * All identifiers for a title are aggregated and output in the identificator attribute.
 * 
 * tables: 
 * -------------
 * folio_derived.agreements_package_content_item
 * folio_derived.agreements_subscription_agreement_entitlement
 * folio_agreements.work
 * folio_agreements.erm_resource
 */
SELECT
    erm_pci_titles.w_title AS title,
    erm_agreements.subscription_agreement_name AS agreement,
    erm_erm_resource.res_name AS res_name,
    erm_pci_list.package_source,
    erm_pci_list.org_vendor_name,
    erm_pci_list.remotekb_remote_kb_name,
    erm_pci_list.package_reference,
    erm_pci_list.pt_platform_name,
    erm_pci_list.ti_date_monograph_published,
    erm_pci_list.ti_first_author,
    erm_pci_list.ti_monograph_edition,
    erm_pci_list.ti_monograph_volume,
    erm_pci_list.ti_first_editor,
    string_agg(erm_pci_list.identifiernamespace_name || ': ' || erm_pci_list.identifier_value, ', ' ORDER BY erm_pci_list.identifiernamespace_name, erm_pci_list.identifier_value) identificator
FROM
    folio_derived.agreements_package_content_item AS erm_pci_list
    JOIN folio_agreements."work" AS erm_pci_titles ON erm_pci_titles.w_id = erm_pci_list.ti_work_id
    JOIN folio_derived.agreements_subscription_agreement_entitlement AS erm_agreements ON erm_agreements.entitlement_id = erm_pci_list.entitlement_id
    JOIN folio_agreements.erm_resource AS erm_erm_resource ON erm_erm_resource.id = erm_agreements.entitlement_resource_fk
GROUP BY
    title,
    agreement,
    res_name,
    erm_pci_list.package_source,
    erm_pci_list.org_vendor_name,
    erm_pci_list.remotekb_remote_kb_name,
    erm_pci_list.package_reference,
    erm_pci_list.pt_platform_name,
    erm_pci_list.ti_date_monograph_published,
    erm_pci_list.ti_first_author,
    erm_pci_list.ti_monograph_edition,
    erm_pci_list.ti_monograph_volume,
    erm_pci_list.ti_first_editor
ORDER BY
    title,
    agreement,
    res_name;