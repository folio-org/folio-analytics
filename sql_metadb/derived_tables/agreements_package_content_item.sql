--metadb:table agreements_package_content_item
--metadb:require folio_agreements.package_content_item.id uuid
--metadb:require folio_agreements.package_content_item.pci_access_end date
--metadb:require folio_agreements.package_content_item.pci_access_start date
--metadb:require folio_agreements.package_content_item.pci_pkg_fk uuid
--metadb:require folio_agreements.package_content_item.pci_pti_fk uuid
--metadb:require folio_agreements.package_content_item.pci_removed_ts bigint

/* Creates a derived table on all needed data of package_content_items
 * that either are linked directly to an entitlement or have a package
 * linked that is linked to an entitlement.
 */

DROP TABLE IF EXISTS agreements_package_content_item;

CREATE TABLE agreements_package_content_item AS
SELECT
    pci.id AS pci_id,
    pci.pci_access_start,
    pci.pci_access_end,
    pci.pci_pkg_fk AS pci_package_id,
    pci.pci_removed_ts,
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
    idns.idns_value AS identifiernamespace_name,
    ent.ent_id AS entitlement_id,
    res.res_name,
    res.res_sub_type_fk,
    rst.rdv_value AS res_sub_type_value,
    rst.rdv_label AS res_sub_type_label,
    rstc.rdc_description AS res_sub_type_category,
    res.res_type_fk,
    rt.rdv_value AS res_type_value,
    rt.rdv_label AS res_type_label,
    rtc.rdc_description AS res_type_category,
    res.res_publication_type_fk,
    rpub.rdv_value AS res_publication_type_value,
    rpub.rdv_label AS res_publication_type_label,
    rpubc.rdc_description AS res_publication_type_category
FROM
    folio_agreements.package_content_item AS pci
    INNER JOIN folio_agreements.entitlement AS ent ON pci.id = ent.ent_resource_fk
    LEFT JOIN folio_agreements.package AS pack ON pci.pci_pkg_fk = pack.id
    LEFT JOIN folio_agreements.org AS org ON pack.pkg_vendor_fk::uuid = org.org_id
    LEFT JOIN folio_agreements.remotekb AS remotekb ON pack.pkg_remote_kb = remotekb.rkb_id
    LEFT JOIN folio_agreements.platform_title_instance AS pti ON pci.pci_pti_fk = pti.id
    LEFT JOIN folio_agreements.platform AS pt ON pti.pti_pt_fk = pt.pt_id
    LEFT JOIN folio_agreements.title_instance AS ti ON pti.pti_ti_fk = ti.id
    LEFT JOIN folio_agreements.identifier_occurrence AS oc ON ti.id = oc.io_ti_fk
    LEFT JOIN folio_agreements.identifier AS id ON oc.io_identifier_fk = id.id_id
    LEFT JOIN folio_agreements.identifier_namespace AS idns ON id.id_ns_fk = idns.idns_id
    LEFT JOIN folio_agreements.erm_resource AS res ON res.id = pti.pti_ti_fk
    LEFT JOIN folio_agreements.refdata_value AS rst ON res.res_sub_type_fk = rst.rdv_id
    LEFT JOIN folio_agreements.refdata_category AS rstc ON rst.rdv_owner = rstc.rdc_id
    LEFT JOIN folio_agreements.refdata_value AS rt ON res.res_type_fk = rt.rdv_id
    LEFT JOIN folio_agreements.refdata_category AS rtc ON rt.rdv_owner = rtc.rdc_id
    LEFT JOIN folio_agreements.refdata_value AS rpub ON res.res_publication_type_fk = rpub.rdv_id
    LEFT JOIN folio_agreements.refdata_category AS rpubc ON rpub.rdv_owner = rpubc.rdc_id
UNION
SELECT
    pci.id AS pci_id,
    pci.pci_access_start,
    pci.pci_access_end,
    pci.pci_pkg_fk AS pci_package_id,
    pci.pci_removed_ts,
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
    idns.idns_value AS identifiernamespace_name,
    ent.ent_id AS entitlement_id,
    res.res_name,
    res.res_sub_type_fk,
    rst.rdv_value AS res_sub_type_value,
    rst.rdv_label AS res_sub_type_label,
    rstc.rdc_description AS res_sub_type_category,
    res.res_type_fk,
    rt.rdv_value AS res_type_value,
    rt.rdv_label AS res_type_label,
    rtc.rdc_description AS res_type_category,
    res.res_publication_type_fk,
    rpub.rdv_value AS res_publication_type_value,
    rpub.rdv_label AS res_publication_type_label,
    rpubc.rdc_description AS res_publication_type_category
FROM
    folio_agreements.package_content_item AS pci
    LEFT JOIN folio_agreements.package AS pack ON pci.pci_pkg_fk = pack.id
    INNER JOIN folio_agreements.entitlement AS ent ON ent.ent_resource_fk = pack.id
    LEFT JOIN folio_agreements.org AS org ON pack.pkg_vendor_fk::uuid = org.org_id
    LEFT JOIN folio_agreements.remotekb AS remotekb ON pack.pkg_remote_kb = remotekb.rkb_id
    LEFT JOIN folio_agreements.platform_title_instance AS pti ON pci.pci_pti_fk = pti.id
    LEFT JOIN folio_agreements.platform AS pt ON pti.pti_pt_fk = pt.pt_id
    LEFT JOIN folio_agreements.title_instance AS ti ON pti.pti_ti_fk = ti.id
    LEFT JOIN folio_agreements.identifier_occurrence AS oc ON ti.id = oc.io_ti_fk
    LEFT JOIN folio_agreements.identifier AS id ON oc.io_identifier_fk = id.id_id
    LEFT JOIN folio_agreements.identifier_namespace AS idns ON id.id_ns_fk = idns.idns_id
    LEFT JOIN folio_agreements.erm_resource AS res ON res.id = pti.pti_ti_fk
    LEFT JOIN folio_agreements.refdata_value AS rst ON res.res_sub_type_fk = rst.rdv_id
    LEFT JOIN folio_agreements.refdata_category AS rstc ON rst.rdv_owner = rstc.rdc_id
    LEFT JOIN folio_agreements.refdata_value AS rt ON res.res_type_fk = rt.rdv_id
    LEFT JOIN folio_agreements.refdata_category AS rtc ON rt.rdv_owner = rtc.rdc_id
    LEFT JOIN folio_agreements.refdata_value AS rpub ON res.res_publication_type_fk = rpub.rdv_id
    LEFT JOIN folio_agreements.refdata_category AS rpubc ON rpub.rdv_owner = rpubc.rdc_id;

CREATE INDEX ON agreements_package_content_item (pci_id);

CREATE INDEX ON agreements_package_content_item (pci_access_start);

CREATE INDEX ON agreements_package_content_item (pci_access_end);

CREATE INDEX ON agreements_package_content_item (pci_package_id);

CREATE INDEX ON agreements_package_content_item (pci_removed_ts);

CREATE INDEX ON agreements_package_content_item (package_source);

CREATE INDEX ON agreements_package_content_item (package_vendor_id);

CREATE INDEX ON agreements_package_content_item (org_vendor_name);

CREATE INDEX ON agreements_package_content_item (package_remote_kb_id);

CREATE INDEX ON agreements_package_content_item (remotekb_remote_kb_name);

CREATE INDEX ON agreements_package_content_item (package_reference);

CREATE INDEX ON agreements_package_content_item (pci_platform_title_instance_id);

CREATE INDEX ON agreements_package_content_item (pti_platform_id);

CREATE INDEX ON agreements_package_content_item (pt_platform_name);

CREATE INDEX ON agreements_package_content_item (pti_title_instance_id);

CREATE INDEX ON agreements_package_content_item (pti_url);

CREATE INDEX ON agreements_package_content_item (ti_id);

CREATE INDEX ON agreements_package_content_item (ti_work_id);

CREATE INDEX ON agreements_package_content_item (ti_date_monograph_published);

CREATE INDEX ON agreements_package_content_item (ti_first_author);

CREATE INDEX ON agreements_package_content_item (ti_monograph_edition);

CREATE INDEX ON agreements_package_content_item (ti_monograph_volume);

CREATE INDEX ON agreements_package_content_item (ti_first_editor);

CREATE INDEX ON agreements_package_content_item (identifier_id);

CREATE INDEX ON agreements_package_content_item (identifier_value);

CREATE INDEX ON agreements_package_content_item (identifier_namespace_id);

CREATE INDEX ON agreements_package_content_item (identifiernamespace_name);

CREATE INDEX ON agreements_package_content_item (entitlement_id);

CREATE INDEX ON agreements_package_content_item (res_name);

CREATE INDEX ON agreements_package_content_item (res_sub_type_fk);

CREATE INDEX ON agreements_package_content_item (res_sub_type_value);

CREATE INDEX ON agreements_package_content_item (res_sub_type_label);

CREATE INDEX ON agreements_package_content_item (res_sub_type_category);

CREATE INDEX ON agreements_package_content_item (res_type_fk);

CREATE INDEX ON agreements_package_content_item (res_type_value);

CREATE INDEX ON agreements_package_content_item (res_type_label);

CREATE INDEX ON agreements_package_content_item (res_type_category);

CREATE INDEX ON agreements_package_content_item (res_publication_type_fk);

CREATE INDEX ON agreements_package_content_item (res_publication_type_value);

CREATE INDEX ON agreements_package_content_item (res_publication_type_label);

CREATE INDEX ON agreements_package_content_item (res_publication_type_category);

COMMENT ON COLUMN agreements_package_content_item.pci_id IS 'ID of the package content item';

COMMENT ON COLUMN agreements_package_content_item.pci_access_start IS 'The date on which a package content item was first accessible in a package';

COMMENT ON COLUMN agreements_package_content_item.pci_access_end IS 'The date on which a package content item was last accessible in a package';

COMMENT ON COLUMN agreements_package_content_item.pci_package_id IS 'ID of package';

COMMENT ON COLUMN agreements_package_content_item.pci_removed_ts IS 'Timestamp when a package content item was removed';

COMMENT ON COLUMN agreements_package_content_item.package_source IS 'String describing the source of the package data';

COMMENT ON COLUMN agreements_package_content_item.package_vendor_id IS 'ID of the package provider organisation (in mod_agreements.orgs)';

COMMENT ON COLUMN agreements_package_content_item.org_vendor_name IS 'Name of the organization';

COMMENT ON COLUMN agreements_package_content_item.package_remote_kb_id IS 'ID of the remote knowledgebase from which the package data was obtained (in mod_agreements.remotekb)';

COMMENT ON COLUMN agreements_package_content_item.remotekb_remote_kb_name IS 'Name of the remote knowledgebase from which the package data was obtained (in mod_agreements.remotekb)';

COMMENT ON COLUMN agreements_package_content_item.package_reference IS 'ID or reference for the package in an external system';

COMMENT ON COLUMN agreements_package_content_item.pci_platform_title_instance_id IS 'ID of the platform title instance';

COMMENT ON COLUMN agreements_package_content_item.pti_platform_id IS 'UUID of Platform';

COMMENT ON COLUMN agreements_package_content_item.pt_platform_name IS 'Name/label of the platform';

COMMENT ON COLUMN agreements_package_content_item.pti_title_instance_id IS 'ID of the platform title instance';

COMMENT ON COLUMN agreements_package_content_item.pti_url IS 'The URL of the platform title instance';

COMMENT ON COLUMN agreements_package_content_item.ti_id IS 'ID of the title_instance';

COMMENT ON COLUMN agreements_package_content_item.ti_work_id IS 'The ID of the work to which the title instance is linked';

COMMENT ON COLUMN agreements_package_content_item.ti_date_monograph_published IS 'For monographs (books), the date the monograph was first published in the media specified by the linked erm resource subtype (typically “print” or “electronic”)';

COMMENT ON COLUMN agreements_package_content_item.ti_first_author IS 'For monographs (books), the last name of the book’s first author';

COMMENT ON COLUMN agreements_package_content_item.ti_monograph_edition IS 'For monographs (books), edition of the book';

COMMENT ON COLUMN agreements_package_content_item.ti_monograph_volume IS 'For monographs (books), the volume number of the book';

COMMENT ON COLUMN agreements_package_content_item.ti_first_editor IS 'For monographs (books), the last name of the book’s first editor';

COMMENT ON COLUMN agreements_package_content_item.identifier_id IS 'UUID of identifier';

COMMENT ON COLUMN agreements_package_content_item.identifier_value IS 'Value of the identifier (i.e. the identifier string)';

COMMENT ON COLUMN agreements_package_content_item.identifier_namespace_id IS 'UUID of identifier_namespace';

COMMENT ON COLUMN agreements_package_content_item.identifiernamespace_name IS 'Value of the namespace (i.e. the namespace name as a string)';

COMMENT ON COLUMN agreements_package_content_item.entitlement_id IS 'UUID of Entitlement (aka Agreement Line)';

COMMENT ON COLUMN agreements_package_content_item.res_name IS 'Name of the resource (can be name of a package or other resource type or the title of a published work such as a book or journal)';

COMMENT ON COLUMN agreements_package_content_item.res_sub_type_fk IS 'ID of reference data value for the subtype of resource';

COMMENT ON COLUMN agreements_package_content_item.res_sub_type_value IS 'A string value which is used to identify the reference data value';

COMMENT ON COLUMN agreements_package_content_item.res_sub_type_label IS 'A string label for the reference data value';

COMMENT ON COLUMN agreements_package_content_item.res_sub_type_category IS 'Text string identifying the reference data category';

COMMENT ON COLUMN agreements_package_content_item.res_type_fk IS 'ID of reference data value for the type of resource';

COMMENT ON COLUMN agreements_package_content_item.res_type_value IS 'A string value which is used to identify the reference data value';

COMMENT ON COLUMN agreements_package_content_item.res_type_label IS 'A string label for the reference data value';

COMMENT ON COLUMN agreements_package_content_item.res_type_category IS 'Text string identifying the reference data category';

COMMENT ON COLUMN agreements_package_content_item.res_publication_type_fk IS 'ID of the publication type';

COMMENT ON COLUMN agreements_package_content_item.res_publication_type_value IS 'A string value which is used to identify the reference data value';

COMMENT ON COLUMN agreements_package_content_item.res_publication_type_label IS 'A string label for the reference data value';

COMMENT ON COLUMN agreements_package_content_item.res_publication_type_category IS 'Text string identifying the reference data category';

VACUUM ANALYZE agreements_package_content_item;
