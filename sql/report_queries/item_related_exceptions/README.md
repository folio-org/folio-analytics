# Item-Related Exceptions Report

## Purpose of report

This report shows a list of exceptions, which are actions taken by an operator (staff member) and are recorded in the circulation log. 
An example is when an item has been manually discharged or discharged by an operator. 

Data fields included are: Date range, location of action, description of action, the loan id on which the action was performed, item details (item id, barcode, and title),
patron name and email, patron group type, and operator id.

## Sample output

This report generates data with the following format:

|date\_range|action\_date|action|action\_description|action\_result|action\_source|service\_point\_id|user\_id|fee\_fine\_id|item\_id|loan\_id|item\_barcode|patron\_group\_name|patron\_last\_name|patron\_first\_name|patron\_middle\_name|patron\_email|location\_name|service\_point\_display\_name|
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
|2000-01-01 to 2022-01-01|2021-04-14 09:37:16.693-04|Paid fully|Fee/Fine type: Misc Fee. Amount: 2.00. Balance: 0.00. Payment method: cash. Additional information to staff: . Additional information to patron: .|Fee/Fine|ADMINISTRATOR, DIKU|7c5abc9f-f3d7-4856-b8d7-6712462ca007|67a248eb-b259-4e7f-98d0-9b57abd1ef59|2eb2fb7c-74d2-4166-8d97-7a19379a13e1||||Graduate Student|Melnyk|Anna||anna_melnyk@epam.com|||
|2000-01-01 to 2022-01-01|2021-04-14 12:01:23.681-04|Billed|Fee/Fine type: Lost item fee. Fee/Fine owner: Anna. Amount: 5.00. automated|Fee/Fine|System||9f8c6765-db3f-4a7a-92f6-4c976b51bfdb|4279f19d-4c05-4585-bbed-0c4d14019dab|7212ba6a-8dcf-45a1-be9a-ffaa847c4423|abc46827-c595-4be3-a06e-52928bb6b447|10101|Faculty Member|Barannyk|Roman||roman_barannyk@epam.com|||
|2000-01-01 to 2022-01-01|2021-04-14 08:53:29.462-04|Created|Type: Page.|Request|Barannyk, Roman|3a40852d-49fd-4df2-a1f9-6e2641a6e91f|9f8c6765-db3f-4a7a-92f6-4c976b51bfdb||7212ba6a-8dcf-45a1-be9a-ffaa847c4423||10101|Faculty Member|Barannyk|Roman||roman_barannyk@epam.com|Annex|Circulation Desk -- Hallway|


## Query instructions

The report can be filtered on a date range, type of actions, and location where the action took place.
(There is a long list of actions: see [documentation for circulation logs interface](https://s3.amazonaws.com/foliodocs/api/mod-audit/p/circulation-logs.html)).

NOTE: This report includes patron personal information and operator identifying ID information, which is not GDPR-compliant. This is needed to identify whether the same 
patron has received an excessive number of fee or other waivers on items, and which operator is responsible for the actions.
