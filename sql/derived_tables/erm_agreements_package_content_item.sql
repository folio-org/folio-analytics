DROP TABLE IF EXISTS local.erm_agreements_package_content_item;

-- Creates a derived table on all needed data of the local KB on package_conent_item level

CREATE TABLE local.erm_agreements_package_content_item AS
SELECT
    pci.id AS pci_id,
    pci.pci_access_start,
    pci.pci_access_end,
    pci.pci_pkg_fk AS pci_package_id,
    pack.pkg_source AS package_source,
    pack.pkg_vendor_fk AS package_vendor_id,
    org.org_name AS org_vendor_name,
    pack.pkg_remote_kb AS package_remote_kb_id,
    remotekb.rkb_name AS remotekb_remote_kb_name,
    pack.pkg_reference AS package_reference,
    pci.pci_pti_fk AS pci_platform_title_instance_id,
    pti.pti_pt_fk AS pti_platform_id,
    pt.pt_name AS pt_platform_name,
    pti.pti_ti_fk AS pti_title_instance_id,
    pti.pti_url,
    ti.id AS ti_id,
    ti.ti_work_fk AS ti_work_id,
    ti.ti_date_monograph_published,
    ti.ti_first_author,
    ti.ti_monograph_edition,
    ti.ti_monograph_volume,
    ti.ti_first_editor,
    id.id_id AS identifier_id,
    id.id_value AS identifier_value,
    id.id_ns_fk AS identifier_namespace_id,
    idns.idns_value AS identifiernamespace_name
FROM
    erm_agreements_package_content_item AS pci
    LEFT JOIN erm_agreements_package AS pack ON pci.pci_pkg_fk = pack.id
    LEFT JOIN erm_agreements_org AS org ON pack.pkg_vendor_fk = org.org_id
    LEFT JOIN erm_agreements_remotekb AS remotekb ON pack.pkg_remote_kb = remotekb.rkb_id
    LEFT JOIN erm_agreements_platform_title_instance AS pti ON pci.pci_pti_fk = pti.id
    LEFT JOIN erm_agreements_platform AS pt ON pti.pti_pt_fk = pt.pt_id
    LEFT JOIN erm_agreements_title_instance AS ti ON pti.pti_ti_fk = ti.id
    LEFT JOIN erm_agreements_identifier_occurrence AS oc ON ti.id = oc.io_ti_fk
    LEFT JOIN erm_agreements_identifier AS id ON oc.io_identifier_fk = id.id_id
    LEFT JOIN erm_agreements_identifier_namespace AS idns ON id.id_ns_fk = idns.idns_id;

CREATE INDEX ON local.erm_agreements_package_content_item (pci_id);

CREATE INDEX ON local.erm_agreements_package_content_item (pci_access_start);

CREATE INDEX ON local.erm_agreements_package_content_item (pci_access_end);

CREATE INDEX ON local.erm_agreements_package_content_item (pci_package_id);

CREATE INDEX ON local.erm_agreements_package_content_item (package_source);

CREATE INDEX ON local.erm_agreements_package_content_item (package_vendor_id);

CREATE INDEX ON local.erm_agreements_package_content_item (org_vendor_name);

CREATE INDEX ON local.erm_agreements_package_content_item (package_remote_kb_id);

CREATE INDEX ON local.erm_agreements_package_content_item (remotekb_remote_kb_name);

CREATE INDEX ON local.erm_agreements_package_content_item (package_reference);

CREATE INDEX ON local.erm_agreements_package_content_item (pci_platform_title_instance_id);

CREATE INDEX ON local.erm_agreements_package_content_item (pti_platform_id);

CREATE INDEX ON local.erm_agreements_package_content_item (pt_platform_name);

CREATE INDEX ON local.erm_agreements_package_content_item (pti_title_instance_id);

CREATE INDEX ON local.erm_agreements_package_content_item (pti_url);

CREATE INDEX ON local.erm_agreements_package_content_item (ti_id);

CREATE INDEX ON local.erm_agreements_package_content_item (ti_work_id);

CREATE INDEX ON local.erm_agreements_package_content_item (ti_date_monograph_published);

CREATE INDEX ON local.erm_agreements_package_content_item (ti_first_author);

CREATE INDEX ON local.erm_agreements_package_content_item (ti_monograph_edition);

CREATE INDEX ON local.erm_agreements_package_content_item (ti_monograph_volume);

CREATE INDEX ON local.erm_agreements_package_content_item (ti_first_editor);

CREATE INDEX ON local.erm_agreements_package_content_item (identifier_id);

CREATE INDEX ON local.erm_agreements_package_content_item (identifier_value);

CREATE INDEX ON local.erm_agreements_package_content_item (identifier_namespace_id);

CREATE INDEX ON local.erm_agreements_package_content_item (identifiernamespace_name);

