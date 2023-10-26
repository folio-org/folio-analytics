--metadb:table po_lines_vendor_reference_numbers

-- This derived table extracts reference numbers from po_lines vendor
-- details.

DROP TABLE IF EXISTS po_line_vendor_reference_number;

CREATE TABLE po_line_vendor_reference_number AS 
SELECT
    pl.id AS po_line_id,
    plt.po_line_number AS po_line_number,
    jsonb_extract_path_text(numbers.jsonb, 'refNumber') AS vendor_reference_number,
    jsonb_extract_path_text(numbers.jsonb, 'refNumberType') AS vendor_reference_number_type,
    jsonb_extract_path_text(pl.jsonb, 'vendorDetail', 'instructions') AS vendor_instructions
FROM folio_orders.po_line AS pl
    CROSS JOIN jsonb_array_elements(jsonb_extract_path(pl.jsonb, 'vendorDetail', 'referenceNumbers'))
        AS numbers (jsonb)
    LEFT JOIN folio_orders.po_line__t plt ON pl.id = plt.id;

COMMENT ON COLUMN po_line_vendor_reference_number.po_line_id IS 'UUID identifying this purchase order line';

COMMENT ON COLUMN po_line_vendor_reference_number.po_line_number IS 'A human readable number assigned to this PO line';

COMMENT ON COLUMN po_line_vendor_reference_number.vendor_reference_number IS 'A reference number for this purchase order line';

COMMENT ON COLUMN po_line_vendor_reference_number.vendor_reference_number_type IS 'The reference number type';

COMMENT ON COLUMN po_line_vendor_reference_number.vendor_instructions IS 'Special instructions for the vendor';

