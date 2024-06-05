--metadb:table finance_funds

-- This derived table shows the budgets for each fund for all fiscal years
-- including calculated values.

DROP TABLE IF EXISTS finance_budgets;

CREATE TABLE finance_budgets AS
SELECT 
	fb.id AS budget_id,
	fb.budget_status AS budget_status,
	ffy.code AS fiscal_yr_name,
	ff.code AS fund_code,
	ff.fund_status AS fund_status,
	ff.name AS fund_name,
	fb.allowable_expenditure AS allowable_expenditure,
	fb.allowable_encumbrance AS allowable_encumbrance,
	COALESCE (fb.initial_allocation,0) AS initial_allocation,
	COALESCE (fb.allocation_to,0) AS increase_in_allocation,
	COALESCE (fb.allocation_from,0) AS decrease_in_allocation,
	COALESCE (fb.initial_allocation,0) + COALESCE (fb.allocation_to,0)- COALESCE (fb.allocation_from,0) AS total_allocated,
	COALESCE (fb.net_transfers,0) AS net_transfers,
	COALESCE (fb.initial_allocation,0)+COALESCE (fb.allocation_to,0)-COALESCE (fb.allocation_from,0)+COALESCE (fb.net_transfers,0) AS total_funding,
	COALESCE (fb.encumbered,0) AS encumbered,
	COALESCE (fb.awaiting_payment,0) AS awaiting_payment,
	COALESCE (fb.expenditures,0) AS expended,
	COALESCE (fb.encumbered,0)+COALESCE (fb.awaiting_payment,0)+COALESCE (fb.expenditures,0) AS unavailable,
	COALESCE (fb.initial_allocation,0)+COALESCE (fb.allocation_to,0)-COALESCE (fb.allocation_from,0)+COALESCE (fb.net_transfers,0) - COALESCE (fb.expenditures,0) AS cash_balance,
	COALESCE (fb.initial_allocation,0)+COALESCE (fb.allocation_to,0)-COALESCE (fb.allocation_from,0)+COALESCE (fb.net_transfers,0) - COALESCE (fb.encumbered,0) - COALESCE (fb.awaiting_payment,0) - COALESCE (fb.expenditures,0) AS available_balance,
	CASE 
		WHEN fb.expenditures - (COALESCE (fb.initial_allocation,0)+COALESCE (fb.allocation_to,0)-COALESCE (fb.allocation_from,0)+COALESCE (fb.net_transfers,0))> 0 THEN fb.expenditures - (COALESCE (fb.initial_allocation,0)+COALESCE (fb.allocation_to,0)-COALESCE (fb.allocation_from,0)+COALESCE (fb.net_transfers,0))
		ELSE '0' 
	END AS over_expended,
	CASE 
		WHEN fb.encumbered - (COALESCE (fb.initial_allocation,0)+COALESCE (fb.allocation_to,0)-COALESCE (fb.allocation_from,0)+COALESCE (fb.net_transfers,0))> 0 THEN fb.encumbered - (COALESCE (fb.initial_allocation,0)+COALESCE (fb.allocation_to,0)-COALESCE (fb.allocation_from,0)+COALESCE (fb.net_transfers,0))
		ELSE '0' 
	END AS over_encumbered
FROM folio_finance.fund__t AS ff
	LEFT JOIN folio_finance.budget__t AS fb ON fb.fund_id = ff.id  
	LEFT JOIN folio_finance.fiscal_year__t AS ffy ON fb.fiscal_year_id = ffy.id
	LEFT JOIN folio_finance.fund_type__t AS fft ON ff.fund_type_id = fft.id 
ORDER BY 
	ff.code;

COMMENT ON COLUMN finance_budgets.budget_id IS 'UUID of the budget record';

COMMENT ON COLUMN finance_budgets.budget_status IS 'The status of the budget';

COMMENT ON COLUMN finance_budgets.fiscal_yr_name IS 'The name for the fiscal year';

COMMENT ON COLUMN finance_budgets.fund_code IS 'The code for the fund';

COMMENT ON COLUMN finance_budgets.fund_status IS 'The current status of the fund';

COMMENT ON COLUMN finance_budgets.fund_name IS 'The name for the fund';

COMMENT ON COLUMN finance_budgets.allowable_expenditure IS 'The percentage of allowable expenditures in relation to total funding';

COMMENT ON COLUMN finance_budgets.allowable_encumbrance IS 'The percentage of allowable encumbrances in relation to total funding';

COMMENT ON COLUMN finance_budgets.initial_allocation IS 'The initial allocation to the fund';

COMMENT ON COLUMN finance_budgets.increase_in_allocation IS 'The total increases in allocation to the fund';

COMMENT ON COLUMN finance_budgets.decrease_in_allocation IS 'The total decreases in allocation to the fund';

COMMENT ON COLUMN finance_budgets.total_allocated IS 'The total funding allocated to a fund';
	
COMMENT ON COLUMN finance_budgets.net_transfers IS 'The net total of all transfers to and from a fund';
	
COMMENT ON COLUMN finance_budgets.total_funding IS 'The total funding allocated and transfered to a fund';
	
COMMENT ON COLUMN finance_budgets.encumbered IS 'The total of open encumbrances on a fund';
	
COMMENT ON COLUMN finance_budgets.awaiting_payment IS 'The total of funding awaiting payment on a fund';
	
COMMENT ON COLUMN finance_budgets.expended IS 'The total expenditures of a fund';
	
COMMENT ON COLUMN finance_budgets.unavailable IS 'The total amount of open encumbrances, awaiting payments, and expenditures on a fund';
	
COMMENT ON COLUMN finance_budgets.cash_balance IS 'The total funding minus expenditures of a fund';
	
COMMENT ON COLUMN finance_budgets.available IS 'The total funding minus unavailable funding of a fund';
	
COMMENT ON COLUMN finance_budgets.over_expended IS 'The total funding minus expenditures of a fund';
	
COMMENT ON COLUMN finance_budgets.over_encumbered IS 'The total funding minus open encumbrances of a fund';
