-- The report provides an overview of the login credentials used by the FOLIO app eUsage when harvesting.

SELECT 
    jsonb_extract_path_text(usage_data_providers.jsonb, 'label') AS source,
    jsonb_extract_path_text(usage_data_providers.jsonb, 'description') AS source_description,
    jsonb_extract_path_text(usage_data_providers.jsonb, 'sushiCredentials', 'customerId') AS customer_id,
    jsonb_extract_path_text(usage_data_providers.jsonb, 'sushiCredentials', 'requestorId') AS requestor_id,
    jsonb_extract_path_text(usage_data_providers.jsonb, 'sushiCredentials', 'apiKey') AS api_key,
    jsonb_extract_path_text(usage_data_providers.jsonb, 'harvestingConfig', 'harvestVia') AS protocol,
    jsonb_extract_path_text(usage_data_providers.jsonb, 'harvestingConfig', 'reportRelease') :: INTEGER AS report_release,
    jsonb_extract_path_text(usage_data_providers.jsonb, 'harvestingConfig', 'sushiConfig', 'serviceUrl') AS service_url,
    jsonb_extract_path_text(usage_data_providers.jsonb, 'metadata', 'createdDate') :: TIMESTAMPTZ AS metadata_created_date,
    jsonb_extract_path_text(usage_data_providers.jsonb, 'metadata', 'updatedDate') :: TIMESTAMPTZ AS metadata_updated_date,
    jsonb_extract_path_text(usage_data_providers.jsonb, 'metadata', 'createdByUserId') :: UUID AS metadata_created_by_user_id,
    jsonb_extract_path_text(usage_data_providers.jsonb, 'metadata', 'updatedByUserId') :: UUID AS metadata_updated_by_user_id 
FROM 
    folio_erm_usage.usage_data_providers
ORDER BY 
    jsonb_extract_path_text(usage_data_providers.jsonb, 'label')
;
