--metadb:table loans_renewal_dates 

/*This derived table captures the renewal actions from the folio_circulation.audit_loan table and shows the dates of renewal. 
 The table also captures the current loan status from the folio_circulation.loan table. 
 This table may be used to count the number of renewals within a given renewal date range, or count the number of renewals 
 for specific loans. The folio_renewal_count is the number of times the loan has been renewed in FOLIO. */
 
DROP TABLE IF EXISTS loans_renewal_dates;

CREATE TABLE loans_renewal_dates AS

SELECT DISTINCT
        jsonb_extract_path_text(audit_loan.jsonb, 'loan','id') AS loan_id,
        jsonb_extract_path_text(audit_loan.jsonb, 'loan','loanDate')::TIMESTAMPTZ AS loan_date,
        jsonb_extract_path_text(audit_loan.jsonb, 'loan','itemId') AS item_id,
        item__t.hrid AS item_hrid,
        jsonb_extract_path_text(audit_loan.jsonb, 'loan','action') AS loan_action,
        DATE_TRUNC ('minute',jsonb_extract_path_text(audit_loan.jsonb, 'loan','metadata','updatedDate')::TIMESTAMPTZ) AS renewal_date, -- truncated to eliminate seconds
        COUNT (DISTINCT jsonb_extract_path_text(audit_loan.jsonb, 'loan','id')) AS folio_renewal_count,       
        jsonb_extract_path_text(loan.jsonb, 'status','name') AS loan_status

    FROM folio_circulation.audit_loan
    	LEFT JOIN folio_circulation.loan 
    	ON jsonb_extract_path_text(audit_loan.jsonb, 'loan','id')::UUID = loan.id::UUID
    	
    	LEFT JOIN folio_inventory.item__t 
    	ON jsonb_extract_path_text(audit_loan.jsonb, 'loan','itemId')::UUID = item__t.id::UUID
    	
    WHERE
        jsonb_extract_path_text(audit_loan.jsonb, 'loan','action') IN ('renewed', 'renewedThroughOverride')       

	GROUP BY 
		jsonb_extract_path_text(audit_loan.jsonb, 'loan','id'),
        jsonb_extract_path_text(audit_loan.jsonb, 'loan','loanDate')::TIMESTAMPTZ,
        jsonb_extract_path_text(audit_loan.jsonb, 'loan','itemId'),
        item__t.hrid,
        jsonb_extract_path_text(audit_loan.jsonb, 'loan','action'),
        DATE_TRUNC ('minute',jsonb_extract_path_text(audit_loan.jsonb, 'loan','metadata','updatedDate')::TIMESTAMPTZ), -- truncated to eliminate seconds
		jsonb_extract_path_text(loan.jsonb, 'status','name')
		
    ORDER by
    	jsonb_extract_path_text(audit_loan.jsonb, 'loan','id'),
    	date_trunc('minute',jsonb_extract_path_text(audit_loan.jsonb, 'loan','metadata','updatedDate')::TIMESTAMPTZ)
    	;
    	
    COMMENT ON COLUMN loans_renewal_dates.loan_id IS 'The ID of the loan';
    COMMENT ON COLUMN loans_renewal_dates.item_id IS 'The ID of the item';
    COMMENT ON COLUMN loans_renewal_dates.item_hrid IS 'The HRID of the loan';
    COMMENT ON COLUMN loans_renewal_dates.loan_action IS 'Last action performed on a loan (currently can be any value, values commonly used are checkedout and checkedin)';
    COMMENT ON COLUMN loans_renewal_dates.renewal_date IS 'Date of renewal of the loan';
    COMMENT ON COLUMN loans_renewal_dates.folio_renewal_count IS 'Number of times the loan was renewed in FOLIO';
    COMMENT ON COLUMN loans_renewal_dates.loan_status IS 'Name of the status of the loan (currently can be any value, values commonly used are Open and Closed)';
    
