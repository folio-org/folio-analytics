--metadb:table openaccess_works

-- Derived table to show informations about the records in the table "folio_oa.works" 
-- and their linked tables and reference data.

DROP TABLE IF EXISTS openaccess_works;

CREATE TABLE openaccess_works AS
SELECT
    work.w_id::uuid AS oa_work_id,
    work.w_version AS oa_work_version,
    work.w_title AS oa_work_title,
    work.w_indexed_in_doaj_fk::uuid AS oa_work_indexed_in_doaj,
    journal_doaj_status.w_indexed_in_doaj_value AS oa_work_indexed_in_doaj_value,
    journal_doaj_status.w_indexed_in_doaj_label AS oa_work_indexed_in_doaj_label,
    work.w_oa_status_fk::uuid AS oa_work_status_fk,
    jounal_oa_status.w_oa_status_value AS oa_work_status_value,
    jounal_oa_status.w_oa_status_label AS oa_work_status_label,
    title_instance.ti_id::uuid AS oa_work_ti_id,
    title_instance.ti_version AS oa_work_ti_version,
    title_instance.ti_work_fk::uuid AS oa_work_ti_work,
    title_instance.ti_type_fk::uuid AS oa_work_ti_type,
    ti_type.ti_type_value AS oa_work_ti_type_value,
    ti_type.ti_type_label AS oa_work_ti_type_label,
    title_instance.ti_subtype_fk::uuid AS oa_work_ti_subtype,
    ti_subtype.ti_subtype_value AS oa_work_ti_subtype_value,
    ti_subtype.ti_subtype_label AS oa_work_ti_subtype_label,
    title_instance.ti_publication_type_fk::uuid AS oa_work_ti_publication_type,
    ti_publication_type.ti_publication_type_value AS oa_work_ti_publication_type_value,
    ti_publication_type.ti_publication_type_label AS oa_work_ti_publication_type_label,
    title_instance.ti_title AS oa_work_ti_title,
    identifier_occurrence.io_id::uuid AS oa_work_io_id,
    identifier_occurrence.io_version AS oa_work_io_version,
    identifier_occurrence.io_ti_fk::uuid AS oa_work_io_ti,
    identifier_occurrence.io_status_fk::uuid AS oa_work_io_status,
    io_status.io_status_value AS oa_work_io_status_value,
    io_status.io_status_label AS oa_work_io_status_label,
    identifier_occurrence.io_identifier_fk::uuid AS oa_work_io_identifier_fk,
    identifier_occurrence.io_selected AS oa_work_io_selected,
    identifier.id_id::uuid AS oa_work_id_id,
    identifier.id_version AS oa_work_id_version,
    identifier.id_ns_fk::uuid AS oa_work_id_ns_fk,
    identifier.id_value AS oa_work_id_value,
    identifier_namespace.idns_id::uuid AS oa_work_idns_id,
    identifier_namespace.idns_version AS oa_work_idns_version,
    identifier_namespace.idns_value AS oa_work_idns_value
FROM folio_oa.work
    LEFT JOIN folio_oa.title_instance ON title_instance.ti_work_fk::uuid = work.w_id::uuid
    LEFT JOIN folio_oa.identifier_occurrence ON identifier_occurrence.io_ti_fk::uuid = title_instance.ti_id::uuid
    LEFT JOIN folio_oa.identifier ON identifier.id_id::uuid = identifier_occurrence.io_identifier_fk::uuid
    LEFT JOIN folio_oa.identifier_namespace ON identifier_namespace.idns_id::uuid = identifier.id_ns_fk::uuid
    LEFT JOIN folio_oa.refdata_value AS journal_doaj_status ON journal_doaj_status.rdv_id = work.w_indexed_in_doaj_fk::uuid
    LEFT JOIN folio_oa.refdata_value AS jounal_oa_status ON jounal_oa_status.rdv_id = work.w_oa_status_fk::uuid
    LEFT JOIN folio_oa.refdata_value AS ti_type ON ti_type.rdv_id = title_instance.ti_type_fk::uuid
    LEFT JOIN folio_oa.refdata_value AS ti_subtype ON ti_subtype.rdv_id = title_instance.ti_subtype_fk::uuid
    LEFT JOIN folio_oa.refdata_value AS ti_publication_type ON ti_publication_type.rdv_id = title_instance.ti_publication_type_fk::uuid
    LEFT JOIN folio_oa.refdata_value AS io_status ON io_status.rdv_id = identifier_occurrence.io_status_fk::uuid   