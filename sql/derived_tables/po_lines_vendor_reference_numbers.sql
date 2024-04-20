-- This derived table extracts reference numbers from po_lines vendor details.

DROP TABLE IF EXISTS po_lines_vendor_reference_numbers;

CREATE TABLE po_lines_vendor_reference_numbers AS
SELECT
    po_lines.id AS po_line_id,
    po_lines.po_line_number AS po_line_number,
    numbers.data #>> '{refNumber}' AS vendor_reference_number,
    numbers.data #>> '{refNumberType}' AS vendor_reference_number_type,
    po_lines.data #>> '{vendorDetail,instructions}' AS vendor_instructions
FROM po_lines
    CROSS JOIN LATERAL jsonb_array_elements((po_lines.data #> '{vendorDetail,referenceNumbers}')::jsonb) AS numbers (data);

COMMENT ON COLUMN po_lines_vendor_reference_numbers.po_line_id IS 'UUID identifying this purchase order line';

COMMENT ON COLUMN po_lines_vendor_reference_numbers.po_line_number IS 'A human readable number assigned to this PO line';

COMMENT ON COLUMN po_lines_vendor_reference_numbers.vendor_reference_number IS 'A reference number for this purchase order line';

COMMENT ON COLUMN po_lines_vendor_reference_numbers.vendor_reference_number_type IS 'The reference number type';

COMMENT ON COLUMN po_lines_vendor_reference_numbers.vendor_instructions IS 'Special instructions for the vendor';
