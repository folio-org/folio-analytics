--metadb:table openaccess_works
--metadb:require folio_oa.work.w_id uuid
--metadb:require folio_oa.work.w_version integer
--metadb:require folio_oa.work.w_title text
--metadb:require folio_oa.work.w_indexed_in_doaj_fk uuid
--metadb:require folio_oa.work.w_oa_status_fk uuid
--metadb:require folio_oa.refdata_value.rdv_id uuid
--metadb:require folio_oa.refdata_value.rdv_value text
--metadb:require folio_oa.refdata_value.rdv_label text
--metadb:require folio_oa.title_instance.ti_id uuid
--metadb:require folio_oa.title_instance.ti_version integer
--metadb:require folio_oa.title_instance.ti_work_fk uuid
--metadb:require folio_oa.title_instance.ti_type_fk uuid
--metadb:require folio_oa.title_instance.ti_subtype_fk uuid
--metadb:require folio_oa.title_instance.ti_publication_type_fk uuid
--metadb:require folio_oa.title_instance.ti_title text
--metadb:require folio_oa.identifier_occurrence.io_id uuid
--metadb:require folio_oa.identifier_occurrence.io_version integer
--metadb:require folio_oa.identifier_occurrence.io_ti_fk uuid
--metadb:require folio_oa.identifier_occurrence.io_status_fk uuid
--metadb:require folio_oa.identifier_occurrence.io_identifier_fk uuid
--metadb:require folio_oa.identifier_occurrence.io_selected boolean
--metadb:require folio_oa.identifier.id_id uuid
--metadb:require folio_oa.identifier.id_version integer
--metadb:require folio_oa.identifier.id_ns_fk uuid
--metadb:require folio_oa.identifier.id_value text
--metadb:require folio_oa.identifier_namespace.idns_id uuid
--metadb:require folio_oa.identifier_namespace.idns_version integer
--metadb:require folio_oa.identifier_namespace.idns_value text

/*
 * Derived table to show informations about the records in the table "folio_oa.works" 
 * and their linked tables and reference data.
 */ 

DROP TABLE IF EXISTS openaccess_works;

CREATE TABLE openaccess_works AS
SELECT
    work.w_id :: UUID,
    work.w_version,
    work.w_title,
    work.w_indexed_in_doaj_fk :: UUID,
    journal_doaj_status.rdv_value AS w_indexed_in_doaj_value,
    journal_doaj_status.rdv_label AS w_indexed_in_doaj_label,
    work.w_oa_status_fk :: UUID,
    jounal_oa_status.rdv_value AS w_oa_status_value,
    jounal_oa_status.rdv_label AS w_oa_status_label,
    title_instance.ti_id :: UUID,
    title_instance.ti_version,
    title_instance.ti_work_fk :: UUID,
    title_instance.ti_type_fk :: UUID,
    ti_type.rdv_value AS ti_type_value,
    ti_type.rdv_label AS ti_type_label,
    title_instance.ti_subtype_fk :: UUID,
    ti_subtype.rdv_value AS ti_subtype_value,
    ti_subtype.rdv_label AS ti_subtype_label,
    title_instance.ti_publication_type_fk :: UUID,
    ti_publication_type.rdv_value AS ti_publication_type_value,
    ti_publication_type.rdv_label AS ti_publication_type_label,
    title_instance.ti_title,
    identifier_occurrence.io_id :: UUID,
    identifier_occurrence.io_version,
    identifier_occurrence.io_ti_fk :: UUID,
    identifier_occurrence.io_status_fk :: UUID,
    io_status.rdv_value AS io_status_value,
    io_status.rdv_label AS io_status_label,
    identifier_occurrence.io_identifier_fk :: UUID,
    identifier_occurrence.io_selected,
    identifier.id_id :: UUID,
    identifier.id_version,
    identifier.id_ns_fk :: UUID,
    identifier.id_value,
    identifier_namespace.idns_id :: UUID,
    identifier_namespace.idns_version,
    identifier_namespace.idns_value
FROM 
    folio_oa.work
    LEFT JOIN folio_oa.title_instance ON title_instance.ti_work_fk :: UUID = work.w_id :: UUID
    LEFT JOIN folio_oa.identifier_occurrence ON identifier_occurrence.io_ti_fk :: UUID = title_instance.ti_id :: UUID
    LEFT JOIN folio_oa.identifier ON identifier.id_id :: UUID = identifier_occurrence.io_identifier_fk :: UUID
    LEFT JOIN folio_oa.identifier_namespace ON identifier_namespace.idns_id :: UUID = identifier.id_ns_fk :: UUID
    LEFT JOIN folio_oa.refdata_value AS journal_doaj_status ON journal_doaj_status.rdv_id :: UUID = work.w_indexed_in_doaj_fk :: UUID
    LEFT JOIN folio_oa.refdata_value AS jounal_oa_status ON jounal_oa_status.rdv_id :: UUID = work.w_oa_status_fk :: UUID
    LEFT JOIN folio_oa.refdata_value AS ti_type ON ti_type.rdv_id :: UUID = title_instance.ti_type_fk :: UUID
    LEFT JOIN folio_oa.refdata_value AS ti_subtype ON ti_subtype.rdv_id :: UUID = title_instance.ti_subtype_fk :: UUID
    LEFT JOIN folio_oa.refdata_value AS ti_publication_type ON ti_publication_type.rdv_id :: UUID = title_instance.ti_publication_type_fk :: UUID
    LEFT JOIN folio_oa.refdata_value AS io_status ON io_status.rdv_id :: UUID = identifier_occurrence.io_status_fk :: UUID
;

COMMENT ON COLUMN openaccess_works.w_id IS 'ID of the record in the table work';

COMMENT ON COLUMN openaccess_works.w_version IS 'Version of the record in the table work';

COMMENT ON COLUMN openaccess_works.w_title IS 'Title of the publication';

COMMENT ON COLUMN openaccess_works.w_indexed_in_doaj_fk IS 'ID of reference data value for the status in the directory DOAJ';

COMMENT ON COLUMN openaccess_works.w_indexed_in_doaj_value IS 'Reference data value for the status in the directory DOAJ';

COMMENT ON COLUMN openaccess_works.w_indexed_in_doaj_label IS 'Label of the reference data value for the status in the directory DOAJ';

COMMENT ON COLUMN openaccess_works.w_oa_status_fk IS 'ID of reference data value for the kind of Open Access';

COMMENT ON COLUMN openaccess_works.w_oa_status_value IS 'Reference data value for the kind of Open Access';

COMMENT ON COLUMN openaccess_works.w_oa_status_label IS 'Label of the reference data value for the kind of Open Access';

COMMENT ON COLUMN openaccess_works.ti_id IS 'ID of the record in the table title_instance';

COMMENT ON COLUMN openaccess_works.ti_version IS 'Version of the record in the table title_instance';

COMMENT ON COLUMN openaccess_works.ti_work_fk IS 'ID to the related record in the table work';

COMMENT ON COLUMN openaccess_works.ti_type_fk IS 'ID of reference data value for type of the title instance';

COMMENT ON COLUMN openaccess_works.ti_type_value IS 'Reference data value for the type of the title instance';

COMMENT ON COLUMN openaccess_works.ti_type_label IS 'Label of the reference data value for the type of the title instance';

COMMENT ON COLUMN openaccess_works.ti_subtype_fk IS 'ID of reference data value for subtype of the title instance';

COMMENT ON COLUMN openaccess_works.ti_subtype_value IS 'Reference data value for the subtype of the title instance';

COMMENT ON COLUMN openaccess_works.ti_subtype_label IS 'Label of the reference data value for the subtype of the title instance';

COMMENT ON COLUMN openaccess_works.ti_publication_type_fk IS 'ID of reference data value for publication type of the title instance';

COMMENT ON COLUMN openaccess_works.ti_publication_type_value IS 'Reference data value for the publication type of the title instance';

COMMENT ON COLUMN openaccess_works.ti_publication_type_label IS 'Label of the reference data value for the publication type of the title instance';

COMMENT ON COLUMN openaccess_works.ti_title IS 'Title of the title instance';

COMMENT ON COLUMN openaccess_works.io_id IS 'ID of the identifier occurrence that is related to the title instance';

COMMENT ON COLUMN openaccess_works.io_version IS 'Version of the record for identifier occurrence';

COMMENT ON COLUMN openaccess_works.io_ti_fk IS 'ID of the record in the table title_instance';

COMMENT ON COLUMN openaccess_works.io_status_fk IS 'Status of the record for identifier occurrence';

COMMENT ON COLUMN openaccess_works.io_status_value IS 'Reference data value for the status of the record for identifier occurrence';

COMMENT ON COLUMN openaccess_works.io_status_label IS 'Label of the reference data value for the status of the record for identifier occurrence';

COMMENT ON COLUMN openaccess_works.io_identifier_fk IS 'ID to the record for the identifier that is related to the title instance';

COMMENT ON COLUMN openaccess_works.io_selected IS '';

COMMENT ON COLUMN openaccess_works.id_id IS 'ID for the record for the identifier';

COMMENT ON COLUMN openaccess_works.id_version IS 'Version of the record for the identifier';

COMMENT ON COLUMN openaccess_works.id_ns_fk IS 'ID to the record for the type of identifier';

COMMENT ON COLUMN openaccess_works.id_value IS 'Value of the identifier';

COMMENT ON COLUMN openaccess_works.idns_id IS 'ID of the record for the type of identifier';

COMMENT ON COLUMN openaccess_works.idns_version IS 'Version of the record for the type of identifier';

COMMENT ON COLUMN openaccess_works.idns_value IS 'Value of the type of identifier';
