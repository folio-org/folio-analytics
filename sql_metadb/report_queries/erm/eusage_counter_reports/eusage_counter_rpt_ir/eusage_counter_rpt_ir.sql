/*
 * COUNTER Item Master Report
 * 
 * This report is a A Standard View of COUNTER Item Master Reports and 
 * shows activity across all metrics for single items, such as articles or videos. 
 * The reports contains also additonal informations to the report file.
 */

WITH parameters AS (
    SELECT
        --'2022-01-01' :: DATE AS reporting_start_period,
        --'2022-12-31' :: DATE AS reporting_end_period,
        '' :: VARCHAR AS item_title, -- The title of an item, e.g. 'AI in Measurement Science' (Article level)
        '' :: VARCHAR AS parent_title, -- The parent title of the item, e.g. 'Annual Review of Biochemistry' (Journal level)
        '' :: VARCHAR AS platform, -- The name of the platform, e.g. 'Annual Reviews' (Provider level)
        '' :: VARCHAR AS access_type -- The access type, e.g. Controlled, OA_Gold
),
counter_reports AS (
    SELECT 
        counter_reports.id,
        jsonb_extract_path_text(counter_reports.jsonb, 'report', 'Report_Header', 'Report_Name') AS report_name,
        jsonb_extract_path_text(counter_reports.jsonb, 'reportName') AS report_id,
        jsonb_extract_path_text(counter_reports.jsonb, 'report', 'Report_Header', 'Release') AS release,
        jsonb_extract_path_text(counter_reports.jsonb, 'report', 'Report_Header', 'Institution_Name') AS institution_name,
        jsonb_extract_path_text(counter_reports.jsonb, 'report', 'Report_Header', 'Customer_ID') AS institution_id,
        jsonb_extract_path_text(jsonb_array_elements(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Performance')), 'Period', 'Begin_Date') :: DATE AS reporting_period_start,
        jsonb_extract_path_text(jsonb_array_elements(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Performance')), 'Period', 'End_Date') :: DATE AS reporting_period_end,
        jsonb_extract_path_text(counter_reports.jsonb, 'report', 'Report_Header', 'Created')::DATE AS created,
        jsonb_extract_path_text(counter_reports.jsonb, 'report', 'Report_Header', 'Created_By') AS created_by,
        jsonb_extract_path_text(counter_reports.jsonb, 'yearMonth') AS report_year_mounth,              
        jsonb_extract_path_text(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Item') AS item,
        jsonb_extract_path_text(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Publisher') AS publisher,
        jsonb_extract_path_text(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Publisher_ID')->0, 'Type') AS publisher_id_type_1,
        jsonb_extract_path_text(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Publisher_ID')->0, 'Value') AS publisher_id_value_1,
        jsonb_extract_path_text(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Platform') AS platform,
        jsonb_extract_path_text(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Item_Contributors')->0, 'Type') AS item_contributors_type_1,
        jsonb_extract_path_text(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Item_Contributors')->0, 'Name') AS item_contributors_value_1,
        jsonb_extract_path_text(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Item_Dates')->0, 'Type') AS item_dates_type_1,
        jsonb_extract_path_text(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Item_Dates')->0, 'Value') AS item_dates_value_1,
        jsonb_extract_path_text(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Item_Attributes')->0, 'Type') AS item_attributes_type_1,
        jsonb_extract_path_text(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Item_Attributes')->0, 'Value') AS item_attributes_value_1,
        jsonb_extract_path_text(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Item_ID')->0, 'Type') AS item_type_1,
        jsonb_extract_path_text(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Item_ID')->0, 'Value') AS item_value_1,
        jsonb_extract_path_text(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Item_ID')->1, 'Type') AS item_type_2,
        jsonb_extract_path_text(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Item_ID')->1, 'Value') AS item_value_2,
        jsonb_extract_path_text(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Item_ID')->2, 'Type') AS item_type_3,
        jsonb_extract_path_text(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Item_ID')->2, 'Value') AS item_value_3,
        jsonb_extract_path_text(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Item_ID')->3, 'Type') AS item_type_4,
        jsonb_extract_path_text(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Item_ID')->3, 'Value') AS item_value_4,
        jsonb_extract_path_text(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Item_ID')->4, 'Type') AS item_type_5,
        jsonb_extract_path_text(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Item_ID')->4, 'Value') AS item_value_5,
        jsonb_extract_path_text(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Item_ID')->5, 'Type') AS item_type_6,
        jsonb_extract_path_text(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Item_ID')->5, 'Value') AS item_value_6,
        jsonb_extract_path_text(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Item_Parent', 'Item_Name') AS parent_title,
        NULL AS parent_authors,
        NULL AS parent_publication_date,
        NULL AS parent_article_version,
        jsonb_extract_path_text(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Item_Parent', 'Data_Type') AS parent_data_type,
        jsonb_extract_path_text(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Item_Parent', 'Item_ID')->0, 'Type') AS parent_type_1,
        jsonb_extract_path_text(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Item_Parent', 'Item_ID')->0, 'Value') AS parent_value_1,
        jsonb_extract_path_text(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Item_Parent', 'Item_ID')->1, 'Type') AS parent_type_2,
        jsonb_extract_path_text(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Item_Parent', 'Item_ID')->1, 'Value') AS parent_value_2,
        jsonb_extract_path_text(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Item_Parent', 'Item_ID')->2, 'Type') AS parent_type_3,
        jsonb_extract_path_text(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Item_Parent', 'Item_ID')->2, 'Value') AS parent_value_3,
        jsonb_extract_path_text(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Item_Parent', 'Item_ID')->3, 'Type') AS parent_type_4,
        jsonb_extract_path_text(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Item_Parent', 'Item_ID')->3, 'Value') AS parent_value_4,
        jsonb_extract_path_text(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Item_Parent', 'Item_ID')->4, 'Type') AS parent_type_5,
        jsonb_extract_path_text(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Item_Parent', 'Item_ID')->4, 'Value') AS parent_value_5,
        jsonb_extract_path_text(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Item_Parent', 'Item_ID')->5, 'Type') AS parent_type_6,
        jsonb_extract_path_text(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Item_Parent', 'Item_ID')->5, 'Value') AS parent_value_6,
        jsonb_extract_path_text(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Data_Type') AS data_type,
        jsonb_extract_path_text(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'YOP') AS yop,
        jsonb_extract_path_text(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Access_Type') AS access_type,
        jsonb_extract_path_text(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Access_Method') AS access_method,           
        jsonb_extract_path_text(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Performance')), 'Instance')->0, 'Metric_Type') AS metric_type_1, 
        jsonb_extract_path_text(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Performance')), 'Instance')->0, 'Count')::INTEGER AS reporting_period_total_1,
        jsonb_extract_path_text(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Performance')), 'Instance')->1, 'Metric_Type') AS metric_type_2, 
        jsonb_extract_path_text(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Performance')), 'Instance')->1, 'Count')::INTEGER AS reporting_period_total_2,
        jsonb_extract_path_text(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Performance')), 'Instance')->2, 'Metric_Type') AS metric_type_3, 
        jsonb_extract_path_text(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Performance')), 'Instance')->2, 'Count')::INTEGER AS reporting_period_total_3,
        jsonb_extract_path_text(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Performance')), 'Instance')->3, 'Metric_Type') AS metric_type_4, 
        jsonb_extract_path_text(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Performance')), 'Instance')->3, 'Count')::INTEGER AS reporting_period_total_4
    FROM 
        folio_erm_usage.counter_reports
    WHERE 
        jsonb_extract_path_text(counter_reports.jsonb, 'reportName') = 'IR'
    ORDER BY
        jsonb_extract_path_text(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Item'),
        jsonb_extract_path_text(counter_reports.jsonb, 'yearMonth') DESC
)
SELECT 
    counter_reports.id,
    counter_reports.report_name,
    counter_reports.report_id,
    counter_reports.release,
    counter_reports.institution_name,
    counter_reports.institution_id,
    counter_reports.reporting_period_start,
    counter_reports.reporting_period_end,
    counter_reports.created,
    counter_reports.created_by,
    counter_reports.report_year_mounth,
    counter_reports.item,
    counter_reports.publisher,
    CASE 
        WHEN counter_reports.publisher_id_type_1 = 'Proprietary' THEN counter_reports.publisher_id_value_1
    END AS publisher_id,        
    counter_reports.platform,
    CASE 
        WHEN counter_reports.item_contributors_type_1 = 'Author' THEN counter_reports.item_contributors_value_1
    END AS authors,        
    CASE 
        WHEN counter_reports.item_dates_type_1 = 'Publication_Date' THEN counter_reports.item_dates_value_1 
    END AS publication_date,        
    CASE 
        WHEN counter_reports.item_attributes_type_1 = 'Article_Version' THEN counter_reports.item_attributes_value_1
    END AS article_version,
    CASE 
        WHEN counter_reports.item_type_1 = 'DOI' THEN counter_reports.item_value_1
        WHEN counter_reports.item_type_2 = 'DOI' THEN counter_reports.item_value_2
        WHEN counter_reports.item_type_3 = 'DOI' THEN counter_reports.item_value_3
        WHEN counter_reports.item_type_4 = 'DOI' THEN counter_reports.item_value_4
        WHEN counter_reports.item_type_5 = 'DOI' THEN counter_reports.item_value_5
        WHEN counter_reports.item_type_6 = 'DOI' THEN counter_reports.item_value_6
    END AS doi,
    CASE 
        WHEN counter_reports.item_type_1 = 'Proprietary' THEN counter_reports.item_value_1
        WHEN counter_reports.item_type_2 = 'Proprietary' THEN counter_reports.item_value_2
        WHEN counter_reports.item_type_3 = 'Proprietary' THEN counter_reports.item_value_3
        WHEN counter_reports.item_type_4 = 'Proprietary' THEN counter_reports.item_value_4
        WHEN counter_reports.item_type_5 = 'Proprietary' THEN counter_reports.item_value_5
        WHEN counter_reports.item_type_6 = 'Proprietary' THEN counter_reports.item_value_6
    END AS proprietary,
    CASE 
        WHEN counter_reports.item_type_1 = 'Online_ISSN' THEN counter_reports.item_value_1
        WHEN counter_reports.item_type_2 = 'Online_ISSN' THEN counter_reports.item_value_2
        WHEN counter_reports.item_type_3 = 'Online_ISSN' THEN counter_reports.item_value_3
        WHEN counter_reports.item_type_4 = 'Online_ISSN' THEN counter_reports.item_value_4
        WHEN counter_reports.item_type_5 = 'Online_ISSN' THEN counter_reports.item_value_5
        WHEN counter_reports.item_type_6 = 'Online_ISSN' THEN counter_reports.item_value_6
    END AS online_issn,
    CASE 
        WHEN counter_reports.item_type_1 = 'Print_ISSN' THEN counter_reports.item_value_1
        WHEN counter_reports.item_type_2 = 'Print_ISSN' THEN counter_reports.item_value_2
        WHEN counter_reports.item_type_3 = 'Print_ISSN' THEN counter_reports.item_value_3
        WHEN counter_reports.item_type_4 = 'Print_ISSN' THEN counter_reports.item_value_4
        WHEN counter_reports.item_type_5 = 'Print_ISSN' THEN counter_reports.item_value_5
        WHEN counter_reports.item_type_6 = 'Print_ISSN' THEN counter_reports.item_value_6
    END AS print_issn,
    CASE 
        WHEN counter_reports.item_type_1 = 'ISBN' THEN counter_reports.item_value_1
        WHEN counter_reports.item_type_2 = 'ISBN' THEN counter_reports.item_value_2
        WHEN counter_reports.item_type_3 = 'ISBN' THEN counter_reports.item_value_3
        WHEN counter_reports.item_type_4 = 'ISBN' THEN counter_reports.item_value_4
        WHEN counter_reports.item_type_5 = 'ISBN' THEN counter_reports.item_value_5
        WHEN counter_reports.item_type_6 = 'ISBN' THEN counter_reports.item_value_6
    END AS isbn,
    CASE 
        WHEN counter_reports.item_type_1 = 'URI' THEN counter_reports.item_value_1
        WHEN counter_reports.item_type_2 = 'URI' THEN counter_reports.item_value_2
        WHEN counter_reports.item_type_3 = 'URI' THEN counter_reports.item_value_3
        WHEN counter_reports.item_type_4 = 'URI' THEN counter_reports.item_value_4
        WHEN counter_reports.item_type_5 = 'URI' THEN counter_reports.item_value_5
        WHEN counter_reports.item_type_6 = 'URI' THEN counter_reports.item_value_6
    END AS uri,
    counter_reports.parent_title,
    counter_reports.parent_authors,
    counter_reports.parent_publication_date,
    counter_reports.parent_article_version,
    counter_reports.parent_data_type,    
    counter_reports.data_type,
    counter_reports.yop,
    counter_reports.access_type,
    counter_reports.access_method,
    CASE
        WHEN counter_reports.metric_type_1 = 'Total_Item_Requests' THEN counter_reports.reporting_period_total_1 
        WHEN counter_reports.metric_type_2 = 'Total_Item_Requests' THEN counter_reports.reporting_period_total_2
        WHEN counter_reports.metric_type_3 = 'Total_Item_Requests' THEN counter_reports.reporting_period_total_3
        WHEN counter_reports.metric_type_4 = 'Total_Item_Requests' THEN counter_reports.reporting_period_total_4
    END AS total_item_requests,
    CASE
        WHEN counter_reports.metric_type_1 = 'Total_Item_Investigations' THEN counter_reports.reporting_period_total_1 
        WHEN counter_reports.metric_type_2 = 'Total_Item_Investigations' THEN counter_reports.reporting_period_total_2
        WHEN counter_reports.metric_type_3 = 'Total_Item_Investigations' THEN counter_reports.reporting_period_total_3
        WHEN counter_reports.metric_type_4 = 'Total_Item_Investigations' THEN counter_reports.reporting_period_total_4
    END AS total_item_investigations,
    CASE
        WHEN counter_reports.metric_type_1 = 'Unique_Item_Requests' THEN counter_reports.reporting_period_total_1 
        WHEN counter_reports.metric_type_2 = 'Unique_Item_Requests' THEN counter_reports.reporting_period_total_2
        WHEN counter_reports.metric_type_3 = 'Unique_Item_Requests' THEN counter_reports.reporting_period_total_3
        WHEN counter_reports.metric_type_4 = 'Unique_Item_Requests' THEN counter_reports.reporting_period_total_4
    END AS unique_item_requests,
    CASE
        WHEN counter_reports.metric_type_1 = 'Unique_Item_Investigations' THEN counter_reports.reporting_period_total_1 
        WHEN counter_reports.metric_type_2 = 'Unique_Item_Investigations' THEN counter_reports.reporting_period_total_2
        WHEN counter_reports.metric_type_3 = 'Unique_Item_Investigations' THEN counter_reports.reporting_period_total_3
        WHEN counter_reports.metric_type_4 = 'Unique_Item_Investigations' THEN counter_reports.reporting_period_total_4
    END AS unique_item_investigations,
    CASE 
        WHEN counter_reports.parent_type_1 = 'DOI' THEN counter_reports.parent_value_1
        WHEN counter_reports.parent_type_2 = 'DOI' THEN counter_reports.parent_value_2
        WHEN counter_reports.parent_type_3 = 'DOI' THEN counter_reports.parent_value_3
        WHEN counter_reports.parent_type_4 = 'DOI' THEN counter_reports.parent_value_4
        WHEN counter_reports.parent_type_5 = 'DOI' THEN counter_reports.parent_value_5
        WHEN counter_reports.parent_type_6 = 'DOI' THEN counter_reports.parent_value_6
    END AS parent_doi,
    CASE 
        WHEN counter_reports.parent_type_1 = 'Proprietary' THEN counter_reports.parent_value_1
        WHEN counter_reports.parent_type_2 = 'Proprietary' THEN counter_reports.parent_value_2
        WHEN counter_reports.parent_type_3 = 'Proprietary' THEN counter_reports.parent_value_3
        WHEN counter_reports.parent_type_4 = 'Proprietary' THEN counter_reports.parent_value_4
        WHEN counter_reports.parent_type_5 = 'Proprietary' THEN counter_reports.parent_value_5
        WHEN counter_reports.parent_type_6 = 'Proprietary' THEN counter_reports.parent_value_6
    END AS parent_proprietary,
    CASE 
        WHEN counter_reports.parent_type_1 = 'Online_ISSN' THEN counter_reports.parent_value_1
        WHEN counter_reports.parent_type_2 = 'Online_ISSN' THEN counter_reports.parent_value_2
        WHEN counter_reports.parent_type_3 = 'Online_ISSN' THEN counter_reports.parent_value_3
        WHEN counter_reports.parent_type_4 = 'Online_ISSN' THEN counter_reports.parent_value_4
        WHEN counter_reports.parent_type_5 = 'Online_ISSN' THEN counter_reports.parent_value_5
        WHEN counter_reports.parent_type_6 = 'Online_ISSN' THEN counter_reports.parent_value_6
    END AS parent_online_issn,
    CASE 
        WHEN counter_reports.parent_type_1 = 'Print_ISSN' THEN counter_reports.parent_value_1
        WHEN counter_reports.parent_type_2 = 'Print_ISSN' THEN counter_reports.parent_value_2
        WHEN counter_reports.parent_type_3 = 'Print_ISSN' THEN counter_reports.parent_value_3
        WHEN counter_reports.parent_type_4 = 'Print_ISSN' THEN counter_reports.parent_value_4
        WHEN counter_reports.parent_type_5 = 'Print_ISSN' THEN counter_reports.parent_value_5
        WHEN counter_reports.parent_type_6 = 'Print_ISSN' THEN counter_reports.parent_value_6
    END AS parent_print_issn,
    CASE 
        WHEN counter_reports.parent_type_1 = 'ISBN' THEN counter_reports.parent_value_1
        WHEN counter_reports.parent_type_2 = 'ISBN' THEN counter_reports.parent_value_2
        WHEN counter_reports.parent_type_3 = 'ISBN' THEN counter_reports.parent_value_3
        WHEN counter_reports.parent_type_4 = 'ISBN' THEN counter_reports.parent_value_4
        WHEN counter_reports.parent_type_5 = 'ISBN' THEN counter_reports.parent_value_5
        WHEN counter_reports.parent_type_6 = 'ISBN' THEN counter_reports.parent_value_6
    END AS parent_isbn,
    CASE 
        WHEN counter_reports.parent_type_1 = 'URI' THEN counter_reports.parent_value_1
        WHEN counter_reports.parent_type_2 = 'URI' THEN counter_reports.parent_value_2
        WHEN counter_reports.parent_type_3 = 'URI' THEN counter_reports.parent_value_3
        WHEN counter_reports.parent_type_4 = 'URI' THEN counter_reports.parent_value_4
        WHEN counter_reports.parent_type_5 = 'URI' THEN counter_reports.parent_value_5
        WHEN counter_reports.parent_type_6 = 'URI' THEN counter_reports.parent_value_6
    END AS parent_uri
FROM 
    counter_reports
WHERE 
    ((counter_reports.item = (SELECT item_title FROM parameters)) OR ((SELECT item_title FROM parameters) = ''))
    AND 
    ((counter_reports.parent_title = (SELECT parent_title FROM parameters)) OR ((SELECT parent_title FROM parameters) = ''))
    AND 
    ((counter_reports.platform = (SELECT platform FROM parameters)) OR ((SELECT platform FROM parameters) = ''))
    AND 
    ((counter_reports.access_type = (SELECT access_type FROM parameters)) OR ((SELECT access_type FROM parameters) = ''))
    /*AND 
    counter_reports.reporting_period_start >= (SELECT reporting_start_period FROM parameters)
    AND 
    counter_reports.reporting_period_end <= (SELECT reporting_end_period FROM parameters) */
;
