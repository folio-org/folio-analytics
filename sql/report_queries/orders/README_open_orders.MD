# CR123 Open Orders

This query provides a list of open purchase orders and their encumbrance and/or amount paid, broken down by purchase order lines. 
Users can use multiple filters to narrow down their search by using parameters filters, located at the top of the query.

This is important to note that the transaction amount will differ from the invoice line sub-total amount when an adjustment is made at the invoice level. The invoice line amount is capturing the payments made on deposit accounts where the transaction amount would be $0. 

This report does not provide any invoice line data not attached to a purchase order line and adjustments made at the invoice level.

The fiscal year in the subquery called ‘fund_group_extract’ will need to be adjusted as needed to get the accurate group based on its fiscal year, since it may change over time.

Hardcoded filter:  
Workflow status is “Open”

Parameter filters:
Order type
Order format
Instance format name
Instance mode of issuance
Transaction type
Fund group name
