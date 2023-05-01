-- The report shows loans and renewals for items by year.

WITH loans_current_year_minus_2 AS (
    SELECT    
        jsonb_extract_path_text(loan.jsonb, 'itemId') :: UUID AS item_id,
        COUNT(*) AS loans,
        COALESCE(SUM(jsonb_extract_path_text(loan.jsonb, 'renewalCount') :: INTEGER), 0) AS renewal_count
    FROM
        folio_circulation.loan
    WHERE 
        EXTRACT(YEAR FROM DATE(jsonb_extract_path_text(loan.jsonb, 'loanDate'))) = EXTRACT(YEAR FROM CURRENT_DATE - INTERVAL '2 years')
    GROUP BY 
        item_id
),
loans_current_year_minus_1 AS (
    SELECT    
        jsonb_extract_path_text(loan.jsonb, 'itemId') :: UUID AS item_id,
        COUNT(*) AS loans,
        COALESCE(SUM(jsonb_extract_path_text(loan.jsonb, 'renewalCount') :: INTEGER), 0) AS renewal_count
    FROM
        folio_circulation.loan
    WHERE 
        EXTRACT(YEAR FROM DATE(jsonb_extract_path_text(loan.jsonb, 'loanDate'))) = EXTRACT(YEAR FROM CURRENT_DATE - INTERVAL '1 years')
    GROUP BY 
        item_id
),
loans_current_year AS (
    SELECT    
        jsonb_extract_path_text(loan.jsonb, 'itemId') :: UUID AS item_id,
        COUNT(*) AS loans,
        COALESCE(SUM(jsonb_extract_path_text(loan.jsonb, 'renewalCount') :: INTEGER), 0) AS renewal_count
    FROM
        folio_circulation.loan
    WHERE 
        EXTRACT(YEAR FROM DATE(jsonb_extract_path_text(loan.jsonb, 'loanDate'))) = EXTRACT(YEAR FROM CURRENT_DATE)
    GROUP BY 
        item_id
),
loans_all AS (
    SELECT 
        jsonb_extract_path_text(loan.jsonb, 'itemId') :: UUID AS item_id,
        COALESCE(COUNT(id), 0) AS loans,
        COALESCE(SUM(jsonb_extract_path_text(loan.jsonb, 'renewalCount') :: INTEGER), 0) AS renewal_count
    FROM 
        folio_circulation.loan
    GROUP BY 
        item_id
),
loans_all_sum AS (
    SELECT 
        item_id,
        SUM(loans + renewal_count) AS summary
    FROM
        loans_all
    GROUP BY
        item_id
)
SELECT DISTINCT   
    item.id AS item,
    jsonb_extract_path_text(item.jsonb, 'barcode') AS item_barcode,
    jsonb_extract_path_text(instance.jsonb, 'title') AS instance_title,
    jsonb_extract_path_text(item.jsonb, 'metadata', 'createdDate') :: TIMESTAMPTZ AS item_created_date,
    AGE(DATE(jsonb_extract_path_text(item.jsonb, 'metadata', 'createdDate'))) AS item_age,
    jsonb_extract_path_text(material_type.jsonb, 'name') AS item_material_type,
    jsonb_extract_path_text(item_permanent_location.jsonb, 'code') AS item_permanent_location,
    jsonb_extract_path_text(item_temporary_location.jsonb, 'code') AS item_temporary_location,
    jsonb_extract_path_text(item_effective_location.jsonb, 'code') AS item_effective_location,
    jsonb_extract_path_text(loclibrary.jsonb, 'code') AS item_effective_location_code,
    jsonb_extract_path_text(item.jsonb, 'itemLevelCallNumber') AS item_call_number,
    jsonb_extract_path_text(item.jsonb, 'effectiveShelvingOrder') AS item_effective_shelving_order,
    jsonb_extract_path_text(item.jsonb, 'effectiveCallNumberComponents', 'callNumber') AS item_effective_call_number,
    jsonb_extract_path_text(item.jsonb, 'effectiveCallNumberComponents', 'prefix') AS item_effective_call_number_prefix,
    jsonb_extract_path_text(item.jsonb, 'effectiveCallNumberComponents', 'suffix') AS item_effective_call_number_suffix,
    COALESCE(loans_current_year_minus_2.loans, 0) AS loans_current_year_minus_2,
    COALESCE(loans_current_year_minus_2.renewal_count, 0) AS renewals_current_year_minus_2,
    COALESCE(loans_current_year_minus_1.loans, 0) AS loans_current_year_minus_1,
    COALESCE(loans_current_year_minus_1.renewal_count, 0) AS renewals_current_year_minus_1,
    COALESCE(loans_current_year.loans, 0) AS loans_current_year,
    COALESCE(loans_current_year.renewal_count, 0) AS renewals_current_year,
    COALESCE(loans_all.loans, 0) AS all_loans,
    COALESCE(loans_all.renewal_count, 0) AS all_renewals,
    COALESCE(loans_all_sum.summary, 0) AS sum_of_loans_renewals
FROM
    folio_circulation.loan
    LEFT JOIN folio_inventory.item ON item.id = jsonb_extract_path_text(loan.jsonb, 'itemId') :: UUID
    LEFT JOIN folio_inventory.material_type ON material_type.id = item.materialtypeid
    LEFT JOIN folio_inventory.holdings_record ON holdings_record.id = item.holdingsrecordid
    LEFT JOIN folio_inventory.instance ON instance.id = holdings_record.instanceid
    LEFT JOIN folio_inventory.location AS item_permanent_location ON item.permanentlocationid = item_permanent_location.id
    LEFT JOIN folio_inventory.location AS item_temporary_location ON item.temporarylocationid = item_temporary_location.id
    LEFT JOIN folio_inventory.location AS item_effective_location ON item.effectivelocationid = item_effective_location.id
    LEFT JOIN folio_inventory.loclibrary ON loclibrary.id = item_effective_location.libraryid 
    LEFT JOIN loans_current_year_minus_2 ON loans_current_year_minus_2.item_id = item.id
    LEFT JOIN loans_current_year_minus_1 ON loans_current_year_minus_1.item_id = item.id
    LEFT JOIN loans_current_year ON loans_current_year.item_id = item.id
    LEFT JOIN loans_all ON loans_all.item_id = item.id
    LEFT JOIN loans_all_sum ON loans_all_sum.item_id = item.id
ORDER BY 
    item,
    item_barcode
