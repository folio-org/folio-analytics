-- This derived table extracts reference numbers from po_lines vendor details.

DROP TABLE IF EXISTS po_lines_vendor_reference_numbers;

CREATE TABLE po_lines_vendor_reference_numbers AS 
SELECT
        po_lines.id AS po_line_id,
        po_lines.po_line_number AS po_line_number,
        json_extract_path_text(numbers.data, 'refNumber') AS vendor_reference_number,
        json_extract_path_text(numbers.data, 'refNumberType') AS vendor_reference_number_type,
        json_extract_path_text(po_lines.data, 'vendorDetail', 'instructions') AS vendor_instructions
FROM po_lines
     CROSS JOIN json_array_elements(json_extract_path(po_lines.data, 'vendorDetail', 'referenceNumbers'))
                AS numbers (data);

CREATE INDEX ON po_lines_vendor_reference_numbers (po_line_id);

CREATE INDEX ON po_lines_vendor_reference_numbers (po_line_number);

CREATE INDEX ON po_lines_vendor_reference_numbers (vendor_reference_number);

CREATE INDEX ON po_lines_vendor_reference_numbers (vendor_reference_number_type);

CREATE INDEX ON po_lines_vendor_reference_numbers (vendor_instructions);



VACUUM ANALYZE  po_lines_vendor_reference_numbers;
