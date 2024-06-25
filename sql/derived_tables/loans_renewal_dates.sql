/*This derived table captures the renewal actions from the public.circulation_loan_history table and shows the dates of renewal. 
 The table also captures the current loan status from the public.circulation_loans table. 
 This table may be used to count the number of renewals within a given renewal date range, or count the number of renewals 
 for specific loans. */

	
DROP TABLE IF EXISTS loans_renewal_dates;

CREATE TABLE loans_renewal_dates AS

SELECT     
        clh.loan__id AS loan_id,
        clh.loan__loan_date AS loan_date,
        clh.loan__item_id AS item_id,
        invitems.hrid AS item_hrid,
        clh.loan__actiON AS loan_action,
        DATE_TRUNC ('minute', clh.created_date::TIMESTAMPTZ) AS renewal_date,
        COUNT (DISTINCT clh.loan__id) AS folio_renewal_count,   
        cl.status__name AS loan_status
        
    FROM public.circulation_loan_history AS clh
	    LEFT JOIN public.circulation_loans AS cl 
	    ON clh.loan__id::UUID = cl.id::UUID	   
	    
	    LEFT JOIN inventory_items AS invitems 
	    ON clh.loan__item_id::UUID = invitems.id::UUID
    
    WHERE
        clh.loan__action IN ('renewed', 'renewedThroughOverride')
        
    GROUP BY         
        clh.loan__id,
        clh.loan__loan_date,
        clh.loan__item_id,
        invitems.hrid,
        clh.loan__action,
        DATE_TRUNC ('minute', clh.created_date::TIMESTAMPTZ),
        cl.status__name
        
    ORDER BY
        clh.loan__id,
        DATE_TRUNC ('minute', clh.created_date::TIMESTAMPTZ) asc
        ;
