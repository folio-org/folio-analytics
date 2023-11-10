--metadb:table openaccess_publication_request

/*
 * This derived table shows data about publication requests from the FOLIO app Open Access.
 */

DROP TABLE IF EXISTS openaccess_publication_request;

CREATE TABLE openaccess_publication_request AS
SELECT
    publication_request.pr_id :: UUID,
    publication_request.pr_request_date :: TIMESTAMPTZ,
    publication_request.pr_date_created :: TIMESTAMPTZ,        
    publication_request.pr_last_updated :: TIMESTAMPTZ,        
    publication_request.pr_request_number,        
    publication_request.pr_title,        
    publication_request.pr_request_status,        
    pr_status.rdv_value AS pr_request_status_value,
    pr_status.rdv_label AS pr_request_status_label,        
    publication_request.pr_pub_type_fk :: UUID,
    pr_pub_type.rdv_value AS pr_pub_type_value,
    pr_pub_type.rdv_label AS pr_pub_type_label,        
    publication_request.pr_authnames,                
    publication_request.pr_corresponding_author_fk :: UUID,
    rp_role_corresponding_author.rdv_value AS pr_corresponding_author_role_value,
    rp_role_corresponding_author.rdv_label AS pr_corresponding_author_role_label,
    party_corresponding_author.p_full_name AS pr_corresponding_author_name,
    pr_corresponding_author.rp_party_fk :: UUID AS pr_corresponding_author_rp_party_fk,
    publication_request.pr_local_ref,        
    publication_request.pr_pub_url,        
    publication_request.pr_subtype :: UUID,        
    pr_subtype.rdv_value AS pr_subtype_value,
    pr_subtype.rdv_label AS pr_subtype_label,        
    publication_request.pr_publisher :: UUID,
    pr_publisher.rdv_value AS pr_publisher_value,
    pr_publisher.rdv_label AS pr_publisher_label,        
    publication_request.pr_license :: UUID,
    pr_license.rdv_value AS pr_license_value,
    pr_license.rdv_label AS pr_license_label,        
    publication_request.pr_doi,        
    publication_request.pr_group_fk :: UUID,
    publication_request.pr_agreement_reference :: UUID,        
    COALESCE(publication_request.pr_without_agreement, 'false') :: BOOLEAN AS pr_without_agreement,        
    publication_request.pr_work_fk :: UUID,        
    publication_request.pr_book_date_of_publication,        
    publication_request.pr_book_place_of_publication,        
    publication_request.pr_work_indexed_in_doaj_fk :: UUID,        
    pr_doaj_status.rdv_value AS pr_work_indexed_in_doaj_value,
    pr_doaj_status.rdv_label AS pr_work_indexed_in_doaj_label,
    publication_request.pr_work_oa_status_fk :: UUID,
    pr_oa_status.rdv_value AS pr_work_oa_status_value,
    pr_oa_status.rdv_label AS pr_work_oa_status_label,        
    publication_request.pr_corresponding_institution_level_1_fk :: UUID,
    pr_corresponding_institution_level_1.rdv_value AS pr_corresponding_institution_level_1_value,
    pr_corresponding_institution_level_1.rdv_label AS pr_corresponding_institution_level_1_label,        
    publication_request.pr_corresponding_institution_level_2,        
    COALESCE(publication_request.pr_retrospective_oa, 'false') :: BOOLEAN AS pr_retrospective_oa,        
    publication_request.pr_closure_reason_fk :: UUID,        
    pr_closure_reason.rdv_value AS pr_closure_reason_value,
    pr_closure_reason.rdv_label AS pr_closure_reason_label,
    publication_request.pr_request_contact_fk :: UUID,
    rp_role_request_contact.rdv_value AS pr_request_contact_role_value,
    rp_role_request_contact.rdv_label AS  pr_request_contact_role_label,
    party_request_contact.p_full_name AS pr_request_contact_name,
    pr_request_contact.rp_party_fk :: UUID AS pr_request_contact_rp_party_fk
FROM 
    folio_oa.publication_request
    LEFT JOIN folio_oa.refdata_value AS pr_status ON pr_status.rdv_id :: UUID = publication_request.pr_request_status :: UUID
    LEFT JOIN folio_oa.refdata_value AS pr_pub_type ON pr_pub_type.rdv_id :: UUID = publication_request.pr_pub_type_fk :: UUID
    LEFT JOIN folio_oa.refdata_value AS pr_subtype ON pr_subtype.rdv_id :: UUID = publication_request.pr_subtype :: UUID
    LEFT JOIN folio_oa.refdata_value AS pr_publisher ON pr_publisher.rdv_id :: UUID = publication_request.pr_publisher :: UUID
    LEFT JOIN folio_oa.refdata_value AS pr_license ON pr_license.rdv_id :: UUID = publication_request.pr_license :: UUID
    LEFT JOIN folio_oa.refdata_value AS pr_doaj_status ON pr_doaj_status.rdv_id :: UUID  = publication_request.pr_work_indexed_in_doaj_fk :: UUID
    LEFT JOIN folio_oa.refdata_value AS pr_oa_status ON pr_oa_status.rdv_id :: UUID  = publication_request.pr_work_oa_status_fk :: UUID
    LEFT JOIN folio_oa.refdata_value AS pr_corresponding_institution_level_1 ON pr_corresponding_institution_level_1.rdv_id :: UUID = publication_request.pr_corresponding_institution_level_1_fk :: UUID
    LEFT JOIN folio_oa.refdata_value AS pr_closure_reason ON pr_closure_reason.rdv_id :: UUID = publication_request.pr_closure_reason_fk :: UUID
    LEFT JOIN folio_oa.request_party AS pr_corresponding_author ON pr_corresponding_author.rp_id :: UUID = publication_request.pr_corresponding_author_fk :: UUID
    LEFT JOIN folio_oa.refdata_value AS rp_role_corresponding_author ON rp_role_corresponding_author.rdv_id :: UUID = pr_corresponding_author.rp_role :: UUID        
    LEFT JOIN folio_oa.request_party AS pr_request_contact ON pr_request_contact.rp_id :: UUID = publication_request.pr_request_contact_fk :: UUID
    LEFT JOIN folio_oa.refdata_value AS rp_role_request_contact ON rp_role_request_contact.rdv_id :: UUID = pr_request_contact.rp_role :: UUID
    LEFT JOIN folio_oa.party AS party_corresponding_author ON party_corresponding_author.p_id :: UUID = pr_corresponding_author.rp_party_fk :: UUID
    LEFT JOIN folio_oa.party AS party_request_contact ON party_request_contact.p_id :: UUID = pr_request_contact.rp_party_fk :: UUID 
ORDER BY 
    publication_request.pr_request_number        
;

COMMENT ON COLUMN openaccess_publication_request.pr_id IS 'UUID of the publication request';

COMMENT ON COLUMN openaccess_publication_request.pr_request_date IS 'Timestamp when the request was made (manually)';

COMMENT ON COLUMN openaccess_publication_request.pr_date_created IS 'Timestamp when the record was created (comes from the system)';

COMMENT ON COLUMN openaccess_publication_request.pr_last_updated IS 'Timestamp when the record is last updated (comes from the system)';

COMMENT ON COLUMN openaccess_publication_request.pr_request_number IS 'Human readable number for a publication request';

COMMENT ON COLUMN openaccess_publication_request.pr_title IS 'Title of the publication';

COMMENT ON COLUMN openaccess_publication_request.pr_request_status IS 'UUID reference to a refdata value';

COMMENT ON COLUMN openaccess_publication_request.pr_request_status_value IS 'Refdata value for publication request status';

COMMENT ON COLUMN openaccess_publication_request.pr_request_status_label IS 'Refdata label for publication request status';

COMMENT ON COLUMN openaccess_publication_request.pr_pub_type_fk IS 'UUID reference to a refdata value';

COMMENT ON COLUMN openaccess_publication_request.pr_pub_type_value IS 'Refdata value for publication request publication type';

COMMENT ON COLUMN openaccess_publication_request.pr_pub_type_label IS 'Refdata label for publication request publication type';

COMMENT ON COLUMN openaccess_publication_request.pr_authnames IS 'List of names of the authors of the publication';

COMMENT ON COLUMN openaccess_publication_request.pr_corresponding_author_fk IS 'FK for a record in table request_party';

COMMENT ON COLUMN openaccess_publication_request.pr_corresponding_author_role_value IS 'Refdata value for the role of the corresponding author';

COMMENT ON COLUMN openaccess_publication_request.pr_corresponding_author_role_label IS 'Refdata label for role of the corresponding author';

COMMENT ON COLUMN openaccess_publication_request.pr_corresponding_author_name IS 'Name of the linked corresponding author';

COMMENT ON COLUMN openaccess_publication_request.pr_corresponding_author_rp_party_fk IS 'FK to the table party';

COMMENT ON COLUMN openaccess_publication_request.pr_local_ref IS 'ID to use for a local repository or storage';

COMMENT ON COLUMN openaccess_publication_request.pr_pub_url IS 'URL for the publication';

COMMENT ON COLUMN openaccess_publication_request.pr_subtype IS 'UUID reference to a refdata value';

COMMENT ON COLUMN openaccess_publication_request.pr_subtype_value IS 'Refdata value for publication request subtype';

COMMENT ON COLUMN openaccess_publication_request.pr_subtype_label IS 'Refdata label for publication request subtype';

COMMENT ON COLUMN openaccess_publication_request.pr_publisher IS 'UUID reference to a refdata value';

COMMENT ON COLUMN openaccess_publication_request.pr_publisher_value IS 'Refdata value for publication request publisher';

COMMENT ON COLUMN openaccess_publication_request.pr_publisher_label IS 'Refdata label for publication request publisher';

COMMENT ON COLUMN openaccess_publication_request.pr_license IS 'UUID reference to a refdata value';

COMMENT ON COLUMN openaccess_publication_request.pr_license_value IS 'Refdata value for publication request license';

COMMENT ON COLUMN openaccess_publication_request.pr_license_label IS 'Refdata label for publication request license';

COMMENT ON COLUMN openaccess_publication_request.pr_doi IS 'DOI for the publication';

COMMENT ON COLUMN openaccess_publication_request.pr_group_fk IS '';

COMMENT ON COLUMN openaccess_publication_request.pr_agreement_reference IS 'FK for publication request agreement';

COMMENT ON COLUMN openaccess_publication_request.pr_without_agreement IS 'Is there a agreement to the publication request';

COMMENT ON COLUMN openaccess_publication_request.pr_work_fk IS 'FK for a record in the table work';

COMMENT ON COLUMN openaccess_publication_request.pr_book_date_of_publication IS 'Year of publication. For books only';

COMMENT ON COLUMN openaccess_publication_request.pr_book_place_of_publication IS 'Place of publication. For books only';

COMMENT ON COLUMN openaccess_publication_request.pr_work_indexed_in_doaj_fk IS 'UUID reference to a refdata value';

COMMENT ON COLUMN openaccess_publication_request.pr_work_indexed_in_doaj_value IS 'Refdata value for publication request doaj status';

COMMENT ON COLUMN openaccess_publication_request.pr_work_indexed_in_doaj_label IS 'Refdata label for publication request doaj status';

COMMENT ON COLUMN openaccess_publication_request.pr_work_oa_status_fk IS 'UUID reference to a refdata value';

COMMENT ON COLUMN openaccess_publication_request.pr_work_oa_status_value IS 'Refdata value for publication request open access status';

COMMENT ON COLUMN openaccess_publication_request.pr_work_oa_status_label IS 'Refdata label for publication request open access status';

COMMENT ON COLUMN openaccess_publication_request.pr_corresponding_institution_level_1_fk IS 'UUID reference to a refdata value';

COMMENT ON COLUMN openaccess_publication_request.pr_corresponding_institution_level_1_value IS 'Refdata value for publication request "institution level 1"';

COMMENT ON COLUMN openaccess_publication_request.pr_corresponding_institution_level_1_label IS 'Refdata label for publication request "institution level 1"';

COMMENT ON COLUMN openaccess_publication_request.pr_corresponding_institution_level_2 IS 'Second level for free naming the institution';

COMMENT ON COLUMN openaccess_publication_request.pr_retrospective_oa IS 'Indicates if the request is for "retrospective OA". Where a publication previously published as closed access is converted to open access through a payment or other mechanism';

COMMENT ON COLUMN openaccess_publication_request.pr_closure_reason_fk IS 'UUID reference to a refdata value';

COMMENT ON COLUMN openaccess_publication_request.pr_closure_reason_value IS 'Refdata value for publication request closure reason';

COMMENT ON COLUMN openaccess_publication_request.pr_closure_reason_label IS 'Refdata label for publication request closure reason';

COMMENT ON COLUMN openaccess_publication_request.pr_request_contact_fk IS 'FK for a record in the table request_party';

COMMENT ON COLUMN openaccess_publication_request.pr_request_contact_role_value IS 'Refdata value for role of the request contact';

COMMENT ON COLUMN openaccess_publication_request.pr_request_contact_role_label IS 'Refdata label for role of the request contact';

COMMENT ON COLUMN openaccess_publication_request.pr_request_contact_name IS 'Name of the linked request contact';

COMMENT ON COLUMN openaccess_publication_request.pr_request_contact_rp_party_fk IS 'FK to the table party';