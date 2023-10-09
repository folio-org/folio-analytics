--metadb:table openaccess_checklists

/*
 * This derived table shows data from the checklists from the FOLIO app Open Access.
 */

DROP TABLE IF EXISTS openaccess_checklists;

CREATE TABLE openaccess_checklists AS
SELECT
    checklist_item.cli_id :: UUID,
    checklist_item.version :: INTEGER AS cli_version,
    checklist_item.cli_date_created :: TIMESTAMPTZ,
    checklist_item.cli_last_updated :: TIMESTAMPTZ,
    checklist_item.cli_definition_fk :: UUID,
    checklist_item_definition.clid_name AS cli_definition_value,
    checklist_item_definition.clid_label AS cli_definition_label,
    checklist_item_definition.clid_description AS cli_definition_description,
    checklist_item.cli_parent_fk :: UUID,
    checklist_item.cli_outcome_fk :: UUID,
    cli_outcome.rdv_value AS cli_outcome_value,
    cli_outcome.rdv_label AS cli_outcome_label,
    checklist_item.cli_status_fk :: UUID,
    cli_status.rdv_value AS cli_status_value,
    cli_status.rdv_label AS cli_status_label,
    publication_request.pr_id :: UUID AS publication_request_id
FROM 
    folio_oa.checklist_item
    LEFT JOIN folio_oa.checklist_item_definition ON checklist_item_definition.clid_id :: UUID = checklist_item.cli_definition_fk :: UUID
    LEFT JOIN folio_oa.refdata_value AS cli_outcome ON cli_outcome.rdv_id :: UUID = checklist_item.cli_outcome_fk :: UUID
    LEFT JOIN folio_oa.refdata_value AS cli_status ON cli_status.rdv_id :: UUID = checklist_item.cli_status_fk :: UUID
    LEFT JOIN folio_oa.publication_request ON publication_request.pr_id :: UUID = checklist_item.cli_parent_fk :: UUID
;

COMMENT ON COLUMN openaccess_checklists.cli_id IS 'UUID of the checklist item';

COMMENT ON COLUMN openaccess_checklists.cli_version IS 'Version of the record';

COMMENT ON COLUMN openaccess_checklists.cli_date_created IS 'Timestamp when the checklist item was created';

COMMENT ON COLUMN openaccess_checklists.cli_last_updated IS 'Timestamp when the checklist item was updated';

COMMENT ON COLUMN openaccess_checklists.cli_definition_fk IS 'UUID reference to folio_oa.checklist_item_definition';

COMMENT ON COLUMN openaccess_checklists.cli_definition_value IS 'Value of the definition for a checklist item';

COMMENT ON COLUMN openaccess_checklists.cli_definition_label IS 'Label for the definition for a checklist item';

COMMENT ON COLUMN openaccess_checklists.cli_definition_description IS 'Description for the checklist item definition';

COMMENT ON COLUMN openaccess_checklists.cli_parent_fk IS 'UUID reference to associated data where the checklists are used';

COMMENT ON COLUMN openaccess_checklists.cli_outcome_fk IS 'UUID reference to a refdata value';

COMMENT ON COLUMN openaccess_checklists.cli_outcome_value IS 'Refdata value for checklist item outcome';

COMMENT ON COLUMN openaccess_checklists.cli_outcome_label IS 'Refdata label for checklist item outcome';

COMMENT ON COLUMN openaccess_checklists.cli_status_fk IS 'UUID reference to a refdata value';

COMMENT ON COLUMN openaccess_checklists.cli_status_value IS 'Refdata value for checklist item status';

COMMENT ON COLUMN openaccess_checklists.cli_status_label IS 'Refdata label for checklist item status';

COMMENT ON COLUMN openaccess_checklists.publication_request_id IS 'UUID reference to a record of the publication request'