--metadb:table finance_budgets

-- This derived table shows the budgets for each fund for all fiscal years
-- including calculated values.

SELECT 
    fb.id AS budget_id,
    fb.budget_status AS budget_status,
    ffy.code AS fiscal_yr_name,
    ff.code AS fund_code,
    ff.fund_status AS fund_status,
    ff.name AS fund_name,
    fb.allowable_expenditure AS allowable_expenditure,
    fb.allowable_encumbrance AS allowable_encumbrance,
    COALESCE(fb.initial_allocation, 0) AS initial_allocation,
    COALESCE(fb.allocation_to, 0) AS increase_in_allocation,
    COALESCE(fb.allocation_from, 0) AS decrease_in_allocation,
    COALESCE(fb.initial_allocation, 0) + COALESCE(fb.allocation_to, 0) - COALESCE(fb.allocation_from, 0) AS total_allocated,
    COALESCE(fb.net_transfers, 0) AS net_transfers,
    COALESCE(fb.initial_allocation, 0) + COALESCE(fb.allocation_to, 0) - COALESCE(fb.allocation_from, 0) + COALESCE(fb.net_transfers, 0) AS total_funding,
    COALESCE(fb.encumbered, 0) AS encumbered,
    COALESCE(fb.awaiting_payment, 0) AS awaiting_payment,
    COALESCE(fb.expenditures, 0) AS expended,
    COALESCE(fb.encumbered, 0) + COALESCE(fb.awaiting_payment, 0) + COALESCE(fb.expenditures, 0) AS unavailable,
    COALESCE(fb.initial_allocation, 0) + COALESCE(fb.allocation_to, 0) - COALESCE(fb.allocation_from, 0) + COALESCE(fb.net_transfers, 0) - COALESCE(fb.expenditures, 0) AS cash_balance,
    COALESCE(fb.initial_allocation, 0) + COALESCE(fb.allocation_to, 0) - COALESCE(fb.allocation_from, 0) + COALESCE(fb.net_transfers, 0) - COALESCE(fb.encumbered, 0) - COALESCE(fb.awaiting_payment, 0) - COALESCE(fb.expenditures, 0) AS available_balance,
    CASE 
        WHEN fb.expenditures - (COALESCE(fb.initial_allocation, 0) + COALESCE(fb.allocation_to, 0) - COALESCE(fb.allocation_from, 0) + COALESCE(fb.net_transfers, 0)) > 0 
        THEN fb.expenditures - (COALESCE(fb.initial_allocation, 0) + COALESCE(fb.allocation_to, 0) - COALESCE(fb.allocation_from, 0) + COALESCE(fb.net_transfers, 0))
        ELSE 0 
    END AS over_expended,
    CASE 
        WHEN fb.encumbered - (COALESCE(fb.initial_allocation, 0) + COALESCE(fb.allocation_to, 0) - COALESCE(fb.allocation_from, 0) + COALESCE(fb.net_transfers, 0)) > 0 
        THEN fb.encumbered - (COALESCE(fb.initial_allocation, 0) + COALESCE(fb.allocation_to, 0) - COALESCE(fb.allocation_from, 0) + COALESCE(fb.net_transfers, 0))
        ELSE 0 
    END AS over_encumbered
FROM folio_finance.fund__t AS ff
    LEFT JOIN folio_finance.budget__t AS fb ON fb.fund_id = ff.id  
    LEFT JOIN folio_finance.fiscal_year__t AS ffy ON fb.fiscal_year_id = ffy.id
    LEFT JOIN folio_finance.fund_type__t AS fft ON ff.fund_type_id = fft.id 
ORDER BY 
    ff.code;