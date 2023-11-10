/*
 * COUNTER Title Master Report
 * 
 * This report is a standard view of COUNTER Title Master Reports and 
 * shows activity across all metrics for entire titles, which may be 
 * ebooks or journal titles. The reports contains also additonal 
 * informations to the COUNTER report file.
 */

WITH parameters AS (
    SELECT
        --'2022-01-01' :: DATE AS reporting_start_period,
        --'2022-12-31' :: DATE AS reporting_end_period,
        '' :: VARCHAR AS title, -- The name of the title, e.g. Annual Review of Cell and Developmental Biology
        '' :: VARCHAR AS yop, -- The year of publication, e.g. 2021
        '' :: VARCHAR AS publisher, -- The name of the publisher, e.g. Annual Reviews
        '' :: VARCHAR AS platform -- The name of the platform, e.g. Annual Reviews
),
counter_reports AS (
    SELECT 
        counter_reports.id,
        jsonb_extract_path_text(counter_reports.jsonb, 'report', 'Report_Header', 'Report_Name') AS report_name,
        jsonb_extract_path_text(counter_reports.jsonb, 'reportName') AS report_id,
        jsonb_extract_path_text(counter_reports.jsonb, 'report', 'Report_Header', 'Release') AS release,
        jsonb_extract_path_text(counter_reports.jsonb, 'report', 'Report_Header', 'Institution_Name') AS institution_name,
        jsonb_extract_path_text(counter_reports.jsonb, 'report', 'Report_Header', 'Customer_ID') AS institution_id,
        jsonb_extract_path_text(jsonb_array_elements(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Performance')), 'Period', 'Begin_Date')::DATE AS reporting_period_start,
        jsonb_extract_path_text(jsonb_array_elements(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Performance')), 'Period', 'End_Date')::DATE AS reporting_period_end,
        jsonb_extract_path_text(counter_reports.jsonb, 'report', 'Report_Header', 'Created')::DATE AS created,
        jsonb_extract_path_text(counter_reports.jsonb, 'report', 'Report_Header', 'Created_By') AS created_by,
        jsonb_extract_path_text(counter_reports.jsonb, 'yearMonth') AS report_year_mounth,
        jsonb_extract_path_text(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Title') AS title,
        jsonb_extract_path_text(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Publisher') AS publisher,
        jsonb_extract_path_text(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Publisher_ID')->0, 'Type') AS publisher_id_type_1,
        jsonb_extract_path_text(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Publisher_ID')->0, 'Value') AS publisher_id_value_1,
        jsonb_extract_path_text(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Platform') AS platform,
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
        jsonb_extract_path_text(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Data_Type') AS data_type,
        jsonb_extract_path_text(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Section_Type') AS section_type,
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
        jsonb_extract_path_text(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Performance')), 'Instance')->3, 'Count')::INTEGER AS reporting_period_total_4,
        jsonb_extract_path_text(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Performance')), 'Instance')->4, 'Metric_Type') AS metric_type_5, 
        jsonb_extract_path_text(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Performance')), 'Instance')->4, 'Count')::INTEGER AS reporting_period_total_5
    FROM 
        folio_erm_usage.counter_reports
    WHERE 
        jsonb_extract_path_text(counter_reports.jsonb, 'reportName') = 'TR'
    ORDER BY 
        jsonb_extract_path_text(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Title'),
        jsonb_extract_path_text(counter_reports.jsonb, 'yearMonth') DESC,
        jsonb_extract_path_text(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'YOP') DESC
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
    counter_reports.title,
    counter_reports.publisher,
    CASE 
        WHEN counter_reports.publisher_id_type_1 = 'Proprietary' THEN publisher_id_value_1
    END AS publisher_id,
    counter_reports.platform,
    CASE 
        WHEN item_type_1 = 'Proprietary' THEN item_value_1
        WHEN item_type_2 = 'Proprietary' THEN item_value_2
        WHEN item_type_3 = 'Proprietary' THEN item_value_3
        WHEN item_type_4 = 'Proprietary' THEN item_value_4
        WHEN item_type_5 = 'Proprietary' THEN item_value_5
        WHEN item_type_6 = 'Proprietary' THEN item_value_6
    END AS proprietary_id,
    CASE 
        WHEN item_type_1 = 'Online_ISSN' THEN item_value_1
        WHEN item_type_2 = 'Online_ISSN' THEN item_value_2
        WHEN item_type_3 = 'Online_ISSN' THEN item_value_3
        WHEN item_type_4 = 'Online_ISSN' THEN item_value_4
        WHEN item_type_5 = 'Online_ISSN' THEN item_value_5
        WHEN item_type_6 = 'Online_ISSN' THEN item_value_6
    END AS eissn,
    counter_reports.data_type,
    counter_reports.section_type,
    counter_reports.yop,
    counter_reports.access_type,
    counter_reports.access_method,
    CASE 
        WHEN metric_type_1 = 'Unique_Item_Requests' THEN reporting_period_total_1
        WHEN metric_type_2 = 'Unique_Item_Requests' THEN reporting_period_total_2
        WHEN metric_type_3 = 'Unique_Item_Requests' THEN reporting_period_total_3
        WHEN metric_type_4 = 'Unique_Item_Requests' THEN reporting_period_total_4
        WHEN metric_type_5 = 'Unique_Item_Requests' THEN reporting_period_total_5
    END AS unique_item_requests,
    CASE 
        WHEN metric_type_1 = 'Unique_Item_Investigations' THEN reporting_period_total_1
        WHEN metric_type_2 = 'Unique_Item_Investigations' THEN reporting_period_total_2
        WHEN metric_type_3 = 'Unique_Item_Investigations' THEN reporting_period_total_3
        WHEN metric_type_4 = 'Unique_Item_Investigations' THEN reporting_period_total_4
        WHEN metric_type_5 = 'Unique_Item_Investigations' THEN reporting_period_total_5
    END AS unique_item_investigations,
    CASE 
        WHEN metric_type_1 = 'Total_Item_Requests' THEN reporting_period_total_1
        WHEN metric_type_2 = 'Total_Item_Requests' THEN reporting_period_total_2
        WHEN metric_type_3 = 'Total_Item_Requests' THEN reporting_period_total_3
        WHEN metric_type_4 = 'Total_Item_Requests' THEN reporting_period_total_4
        WHEN metric_type_5 = 'Total_Item_Requests' THEN reporting_period_total_5
    END AS total_item_requests,
    CASE 
        WHEN metric_type_1 = 'Total_Item_Investigations' THEN reporting_period_total_1
        WHEN metric_type_2 = 'Total_Item_Investigations' THEN reporting_period_total_2
        WHEN metric_type_3 = 'Total_Item_Investigations' THEN reporting_period_total_3
        WHEN metric_type_4 = 'Total_Item_Investigations' THEN reporting_period_total_4
        WHEN metric_type_5 = 'Total_Item_Investigations' THEN reporting_period_total_5
    END AS total_item_investigations,
    CASE 
        WHEN metric_type_1 = 'No_License' THEN reporting_period_total_1
        WHEN metric_type_2 = 'No_License' THEN reporting_period_total_2
        WHEN metric_type_3 = 'No_License' THEN reporting_period_total_3
        WHEN metric_type_4 = 'No_License' THEN reporting_period_total_4
        WHEN metric_type_5 = 'No_License' THEN reporting_period_total_5
    END AS no_license
FROM 
    counter_reports
WHERE 
    ((counter_reports.title = (SELECT title FROM parameters)) OR ((SELECT title FROM parameters) = ''))
    AND 
    ((counter_reports.yop = (SELECT yop FROM parameters)) OR ((SELECT yop FROM parameters) = ''))
    AND 
    ((counter_reports.publisher = (SELECT publisher FROM parameters)) OR ((SELECT publisher FROM parameters) = ''))
    AND 
    ((counter_reports.platform = (SELECT platform FROM parameters)) OR ((SELECT platform FROM parameters) = ''))
    /*AND 
    counter_reports.reporting_period_start >= (SELECT reporting_start_period FROM parameters)
    AND 
    counter_reports.reporting_period_end <= (SELECT reporting_end_period FROM parameters)*/
;
