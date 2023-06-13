--metadb:table instance_ext

-- Create an extended version of the instance table where the names for identifiers are included
-- This derived table doesn't include all the properties extracted from the json objects
-- For example, electronic access, notes, publication, series, or edition statements have their own
-- derived tables.

DROP TABLE IF EXISTS instance_ext;

CREATE TABLE instance_ext AS
SELECT
    instance__t.id AS instance_id,
    instance__t.hrid AS instance_hrid,
    instance__t.cataloged_date :: DATE,
    instance__t.title,
    instance__t.index_title,
    instance__t.instance_type_id AS type_id,
    instance_type__t.name AS type_name,
    instance__t.mode_of_issuance_id,
    mode_of_issuance__t.name AS mode_of_issuance_name,
    COALESCE(instance__t.previously_held, 'false') :: BOOLEAN AS previously_held,
    instance__t.source AS instance_source,
    COALESCE(instance__t.discovery_suppress, 'false') :: BOOLEAN AS discovery_suppress,
    COALESCE(instance__t.staff_suppress, 'false') :: BOOLEAN AS staff_suppress,
    instance__t.status_id,
    instance_status__t.name AS status_name,
    instance__t.status_updated_date,
    instance__t.source AS record_source,
    jsonb_extract_path_text(instance.jsonb, 'metadata', 'createdDate') :: TIMESTAMPTZ AS record_created_date,
    jsonb_extract_path_text(instance.jsonb, 'metadata', 'updatedByUserId') :: UUID AS updated_by_user_id,
    jsonb_extract_path_text(instance.jsonb, 'metadata', 'updatedDate')::timestamptz AS updated_date,
    jsonb_extract_path_text(instance.jsonb, 'matchKey') :: UUID AS match_key,
    COALESCE(jsonb_extract_path_text(instance.jsonb, 'isBoundWith'), 'false') :: BOOLEAN AS is_bound_with
FROM
    folio_inventory.instance__t
    LEFT JOIN folio_inventory.instance ON instance.id = instance__t.id
    LEFT JOIN folio_inventory.instance_type__t ON instance_type__t.id = instance__t.instance_type_id
    LEFT JOIN folio_inventory.mode_of_issuance__t ON mode_of_issuance__t.id = instance__t.mode_of_issuance_id
    LEFT JOIN folio_inventory.instance_status__t ON instance_status__t.id = instance__t.status_id;
    
COMMENT ON COLUMN instance_ext.instance_id IS 'The unique ID of the instance record, a UUID.';

COMMENT ON COLUMN instance_ext.instance_hrid IS 'The human readable ID, also called eye readable ID. A system-assigned sequential ID which maps to the Instance ID.';

COMMENT ON COLUMN instance_ext.cataloged_date IS 'Date or timestamp on an instance for when is was considered cataloged.';

COMMENT ON COLUMN instance_ext.title IS 'The primary title (or label) associated with the resource.';

COMMENT ON COLUMN instance_ext.index_title IS 'Title normalized for browsing and searching; based on the title with articles removed';

COMMENT ON COLUMN instance_ext.type_id IS 'UUID of the unique term for the resource type whether it is from the RDA content term list of locally defined.';

COMMENT ON COLUMN instance_ext.type_name IS 'Label for the resource type.';

COMMENT ON COLUMN instance_ext.mode_of_issuance_id IS 'UUID of the RDA mode of issuance, a categorization reflecting whether a resource is issued in one or more parts, the way it is updated, and whether its termination is predetermined or not (e.g. monograph,  sequential monograph, serial; integrating Resource, other).';

COMMENT ON COLUMN instance_ext.mode_of_issuance_name IS 'Label for the mode of issuance.';

COMMENT ON COLUMN instance_ext.previously_held IS 'Records the fact that the resource was previously held by the library for things like Hathi access, etc.';

COMMENT ON COLUMN instance_ext.instance_source IS 'The metadata source and its format of the underlying record to the instance record. (e.g. FOLIO if it is a record created in Inventory;  MARC if it is a MARC record created in MARCcat or EPKB if it is a record coming from eHoldings).';

COMMENT ON COLUMN instance_ext.discovery_suppress IS 'Records the fact that the record should not be displayed in a discovery system.';

COMMENT ON COLUMN instance_ext.staff_suppress IS 'Records the fact that the record should not be displayed for others than catalogers.';

COMMENT ON COLUMN instance_ext.status_id IS 'UUID for the Instance status term (e.g. cataloged, uncatalogued, batch loaded, temporary, other, not yet assigned).';

COMMENT ON COLUMN instance_ext.status_name IS 'Label for the instance status.';

COMMENT ON COLUMN instance_ext.status_updated_date IS 'Date [or timestamp] for when the instance status was updated.';

COMMENT ON COLUMN instance_ext.record_source IS 'The metadata source and its format of the underlying record to the instance record. (e.g. FOLIO if it is a record created in Inventory;  MARC if it is a MARC record created in MARCcat or EPKB if it is a record coming from eHoldings).';

COMMENT ON COLUMN instance_ext.record_created_date IS 'Date and time when the record was created.';

COMMENT ON COLUMN instance_ext.updated_by_user_id IS 'ID of the user who last updated the record (when available).';

COMMENT ON COLUMN instance_ext.updated_date IS 'Date and time when the record was last updated.';

COMMENT ON COLUMN instance_ext.match_key IS 'A unique instance identifier matching a client-side bibliographic record identification scheme, in particular for a scenario where multiple separate catalogs with no shared record identifiers contribute to the same Instance in Inventory. A match key is typically generated from select, normalized pieces of metadata in bibliographic records.';

COMMENT ON COLUMN instance_ext.is_bound_with IS 'Relationships to other entities if it is bounded with them.';
