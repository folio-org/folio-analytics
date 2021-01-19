/* Agreement - Resource Name - Status */
SELECT
    sa.sa_name AS "Agreement",
    res.res_name AS "Resource Name",
    rdv.rdv_value AS "Status"
    /* pci_list == all of items available in KB - x; pci_list == all of items we are entitled to - o */
FROM (
    /* select all PCIs that are linked directly from an agreement entitlement */
    SELECT
        pci.id AS pci_id,
        pci.pci_pti_fk AS pti_fk,
        pci_as_ent.ent_owner_fk AS ent_owner
    FROM
        erm_agreements_package_content_item AS pci
        INNER JOIN erm_agreements_entitlement AS pci_as_ent ON pci_as_ent.ent_resource_fk = pci.id
UNION
/* Union that list of PCIs with a list of PCIs that belong to packages that are linked from an agreement entitlement */
SELECT
    pci_in_pkg.id pci_id,
    pci_in_pkg.pci_pti_fk AS pti_fk,
    pkg_as_ent.ent_owner_fk AS ent_owner
FROM
    erm_agreements_package_content_item AS pci_in_pkg
    INNER JOIN erm_agreements_package AS pkg ON pkg.id = pci_in_pkg.pci_pkg_fk
    INNER JOIN erm_agreements_entitlement AS pkg_as_ent ON pkg_as_ent.ent_resource_fk = pkg.id) AS pci_list
    /* join PCI to PTI */
    JOIN erm_agreements_platform_title_instance AS pti ON pci_list.pti_fk = pti.id
    JOIN erm_agreements_erm_resource AS res ON pti.pti_ti_fk = res.id
    JOIN erm_agreements_subscription_agreement AS sa ON pci_list.ent_owner = sa.sa_id
    JOIN erm_agreements_refdata_value AS rdv ON sa.sa_agreement_status = rdv.rdv_id
ORDER BY
    sa.sa_name,
    res.res_name;

