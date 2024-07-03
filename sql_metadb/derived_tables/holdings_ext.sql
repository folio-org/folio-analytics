--Metadb: holdings_ext
-- Create an extended holdings table which includes the name for call number type, holdings type, interlibrary loan policy,
-- permanent location, and temporary location.
-- Holdings notes are in a separate derived table.


DROP TABLE IF EXISTS holdings_ext;

CREATE TABLE holdings_ext AS

    SELECT
        h__t.id,
        h__t.hrid as holdings_hrid,
        h__t.acquisition_method,
        h__t.call_number,
        h__t.call_number_prefix,
        h__t.call_number_suffix,
        h__t.call_number_type_id,
        holdings_call_number_type.name as call_number_type_name,
        h__t.copy_number,
        h__t.holdings_type_id as type_id,
        holdings_type.name as type_name,
        h__t.ill_policy_id,
        holdings_ill_policy.name as ill_policy_name,
        h__t.instance_id,
        h__t.permanent_location_id,
        holdings_permanent_location.name as permanent_location_name,
        h__t.temporary_location_id,
        holdings_temporary_location.name as temporary_location_name,
        h__t.receipt_status,
        h__t.retention_policy,
        h__t.shelving_title,
        h__t.discovery_suppress,
        jsonb_extract_path_text(h.jsonb, 'metadata', 'createdDate')::timestamptz AS created_date,
        jsonb_extract_path_text(h.jsonb, 'metadata', 'updatedByUserId')::UUID AS updated_by_user_id,
        jsonb_extract_path_text(h.jsonb, 'metadata', 'updatedDate')::timestamptz AS updated_date

    FROM
        folio_inventory.holdings_record__t AS h__t 
        left join folio_inventory.holdings_record as h 
        ON h.id = h__t.id
        
        LEFT JOIN folio_inventory.call_number_type__t AS holdings_call_number_type 
        ON h__t.call_number_type_id::uuid = holdings_call_number_type.id
        
        LEFT JOIN folio_inventory.holdings_type__t AS holdings_type 
        ON h__t.holdings_type_id::uuid = holdings_type.id
        
        LEFT JOIN folio_inventory.ill_policy__t AS holdings_ill_policy 
        ON h__t.ill_policy_id::uuid = holdings_ill_policy.id
        
        LEFT JOIN folio_inventory.location__t AS holdings_permanent_location 
        ON h__t.permanent_location_id::uuid = holdings_permanent_location.id
        
        LEFT JOIN folio_inventory.location__t AS holdings_temporary_location 
        ON h__t.temporary_location_id::uuid = holdings_temporary_location.id
;    

COMMENT ON COLUMN holdings_ext.id IS 'The holdings ID';
COMMENT ON COLUMN holdings_ext.holdings_hrid IS 'The holdings HRID';
COMMENT ON COLUMN holdings_ext.acquisition_method IS 'Method of holdings record acquisition';
COMMENT ON COLUMN holdings_ext.call_number IS 'Call Number is an identifier assigned to an item, usually printed on a label attached to the item';
COMMENT ON COLUMN holdings_ext.call_number_prefix IS 'Prefix of the call number on the holding level';
COMMENT ON COLUMN holdings_ext.call_number_suffix IS 'Suffix of the call number on the holding level';
COMMENT ON COLUMN holdings_ext.call_number_type_id IS 'unique ID for the type of call number on a holdings record, a UUID';
COMMENT ON COLUMN holdings_ext.call_number_type_name IS 'call number type, such as Library of Congress Classification';
COMMENT ON COLUMN holdings_ext.copy_number IS 'Item/Piece ID (usually barcode) for systems that do not use item records. Ability to designate the copy number if institution chooses to use copy numbers.';
COMMENT ON COLUMN holdings_ext.type_id IS 'unique ID for the type of this holdings record, a UUID';
COMMENT ON COLUMN holdings_ext.type_name IS 'Name of the type of holdings record, such as monograph, serial, etc.';
COMMENT ON COLUMN holdings_ext.ill_policy_id IS 'Unique ID for an ILL policy, a UUID';
COMMENT ON COLUMN holdings_ext.ill_policy_name IS 'Name of the ILL policy such as limited lending policy, will lend hard copy only, etc.';
COMMENT ON COLUMN holdings_ext.instance_id IS 'Unique ID for the instance record, a UUID';
COMMENT ON COLUMN holdings_ext.permanent_location_id IS 'ID of the permanent shelving location in which an item resides';
COMMENT ON COLUMN holdings_ext.permanent_location_name IS 'Name of the permanent shelving location in which an item resides';
COMMENT ON COLUMN holdings_ext.temporary_location_id IS 'ID of the temporary location: Temporary location is the temporary location, shelving location, or holding which is a physical place where items are stored, or an Online location.';
COMMENT ON COLUMN holdings_ext.temporary_location_name IS 'Name of the temporary location: Temporary location is the temporary location, shelving location, or holding which is a physical place where items are stored, or an Online location.';
COMMENT ON COLUMN holdings_ext.receipt_status IS 'Receipt status (e.g. pending, awaiting receipt, partially received, fully received, receipt not required, and cancelled)';
COMMENT ON COLUMN holdings_ext.retention_policy IS 'Records information regarding how long we have agreed to keep something';
COMMENT ON COLUMN holdings_ext.shelving_title IS 'Indicates the shelving form of title';
COMMENT ON COLUMN holdings_ext.discovery_supress IS 'Records the fact that the record should not be displayed in a discovery system';
COMMENT ON COLUMN holdings_ext.created_date IS 'Date and time when the record was created';
COMMENT ON COLUMN holdings_ext.updated_by_user_id IS 'ID of the user who last updated the record (when available)';
COMMENT ON COLUMN holdings_ext.updated_date IS 'Date and time when the record was last updated';



