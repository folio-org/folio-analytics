/** Documentation of ERM AGREEMENT COUNT QUERY

DERIVED TABLES
agreements_package_content_item
agreements_subscription_agreement_entitlement

TABLES
folio_agreements.refdata_value 

*/

WITH parameters AS (
    SELECT
		-- filters on agreement level
		''::VARCHAR AS agreement_status, -- Enter your subscription agreement status eg. 'Active', 'Closed' etc.
		-- subscription agreement time period will be added when available (IRIS)
		--NULL::DATE AS a_start_date,
        --NULL::DATE AS a_end_date,
        --'2021-01-01' :: DATE AS sa_start_date, -- start date day is included in interval
        --'2022-01-01' :: DATE AS sa_end_date, -- end date day is NOT included in interval -> enter next day		
		-- filters on erm_resource level
		''::VARCHAR AS resource_type, -- Enter your erm resource type eg. 'monograph', 'serial' etc.
		''::VARCHAR AS resource_sub_type, -- Enter your erm resource sub type eg. 'electronic', 'print' etc.
		''::VARCHAR AS resource_publication_type, -- Enter your erm resource publication type eg. 'journal', 'book' etc.
		-- filters on entitelment level
        NULL::DATE AS ent_start_date,
        NULL::DATE AS ent_end_date,
        --'2021-01-01' :: DATE AS ent_start_date, -- start date day is included in interval
        --'2022-01-01' :: DATE AS ent_end_date, -- end date day is NOT included in interval -> enter next day
		-- filters on package content item level
        NULL::DATE AS pci_start_date,
        NULL::DATE AS pci_end_date
        --'2021-01-01' :: DATE AS pci_start_date, -- start date day is included in interval
        --'2022-01-01' :: DATE AS pci_end_date -- end date day is NOT included in interval -> enter next day
)
SELECT
    sa_ent.subscription_agreement_name AS "Agreements",
    agrestat.rdv_label AS "Status",
    pci_list.res_type_value AS "Resource Type",
    pci_list.res_sub_type_value AS "Resource Subtype",
    pci_list.res_publication_type_value AS "Resource Publicationtype",  
    count(DISTINCT pci_list.pci_id) AS "Count"
FROM
    folio_derived.agreements_package_content_item AS pci_list
    LEFT JOIN folio_derived.agreements_subscription_agreement_entitlement AS sa_ent ON pci_list.entitlement_id = sa_ent.entitlement_id
    LEFT JOIN folio_agreements.refdata_value AS agrestat ON agrestat.rdv_id = sa_ent.subscription_agreement_status
WHERE
 -- Don't count removed titles from packages
    pci_list.pci_removed_ts IS NULL
 -- Start with parameter filters
    AND
	((agrestat.rdv_label = (SELECT agreement_status FROM parameters)) OR
		((SELECT agreement_status FROM parameters) = ''))
	AND
    ((pci_list.pci_access_start < (SELECT pci_end_date FROM parameters) AND
	    (pci_list.pci_access_end >= (SELECT pci_start_date FROM parameters) OR pci_list.pci_access_end IS NULL))
	    OR
		(((SELECT pci_start_date FROM parameters) IS NULL)
			OR ((SELECT pci_end_date FROM parameters) IS NULL)))
	AND
    ((sa_ent.entitlement_active_from < (SELECT ent_end_date FROM parameters) AND
	    (sa_ent.entitlement_active_to >= (SELECT ent_start_date FROM parameters) OR sa_ent.entitlement_active_to IS NULL))
	    OR
		(((SELECT ent_start_date FROM parameters) IS NULL)
			OR ((SELECT ent_end_date FROM parameters) IS NULL)))
    AND
	((pci_list.res_type_value = (SELECT resource_type FROM parameters)) OR
		((SELECT resource_type FROM parameters) = ''))	
	AND
	((pci_list.res_sub_type_value = (SELECT resource_sub_type FROM parameters)) OR
		((SELECT resource_sub_type FROM parameters) = ''))	
	AND
	((pci_list.res_publication_type_value = (SELECT resource_publication_type FROM parameters)) OR
		((SELECT resource_publication_type FROM parameters) = ''))	
	-- subscription agreement time period will be added when available (IRIS)
	/*
	AND 			
    ((sa_ent.sa_start_date < (SELECT a_end_date FROM parameters) AND
	    (sa_ent.sa_end_date >= (SELECT a_start_date FROM parameters) OR sa_ent.sa_end_date IS NULL))
	    OR 
		(((SELECT a_start_date FROM parameters) IS NULL) 
			OR ((SELECT a_end_date FROM parameters) IS NULL)))	
	*/
GROUP BY
    sa_ent.subscription_agreement_name,
    agrestat.rdv_label,
    pci_list.res_type_value,
    pci_list.res_sub_type_value,
    pci_list.res_publication_type_value 
    ;


