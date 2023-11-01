/*
 * COUNTER Database Master Report
 * 
 * Database Master Reports (DR) show activity across all metrics for entire databases 
 * or fixed collections of content which behave like a database.
 */

WITH parameters AS (
    SELECT
        --'2022-01-01' :: DATE AS reporting_start_period,
        --'2022-12-31' :: DATE AS reporting_end_period,
        '' :: VARCHAR AS data_type, -- e.g. Book, Journal, Database
        '' :: VARCHAR AS platform, -- The name of the platform
        '' :: VARCHAR AS publisher, -- The name of the publisher
        '' :: VARCHAR AS database -- The name of the DATABASE, e.g. African American Music Reference
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
        jsonb_extract_path_text(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Database') AS database,
        jsonb_extract_path_text(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Publisher') AS publisher,
        jsonb_extract_path_text(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Publisher_ID')->0, 'Type') AS publisher_id_type_1,
        jsonb_extract_path_text(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Publisher_ID')->0, 'Value') AS publisher_id_value_1,
        jsonb_extract_path_text(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Publisher_ID')->1, 'Type') AS publisher_id_type_2,
        jsonb_extract_path_text(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Publisher_ID')->1, 'Value') AS publisher_id_value_2,
        jsonb_extract_path_text(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Platform') AS platform,
        jsonb_extract_path_text(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Data_Type') AS data_type,
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
        jsonb_extract_path_text(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Performance')), 'Instance')->4, 'Count')::INTEGER AS reporting_period_total_5,
        jsonb_extract_path_text(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Performance')), 'Instance')->5, 'Metric_Type') AS metric_type_6, 
        jsonb_extract_path_text(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Performance')), 'Instance')->5, 'Count')::INTEGER AS reporting_period_total_6,
        jsonb_extract_path_text(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Performance')), 'Instance')->6, 'Metric_Type') AS metric_type_7, 
        jsonb_extract_path_text(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Performance')), 'Instance')->6, 'Count')::INTEGER AS reporting_period_total_7,
        jsonb_extract_path_text(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Performance')), 'Instance')->7, 'Metric_Type') AS metric_type_8, 
        jsonb_extract_path_text(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Performance')), 'Instance')->7, 'Count')::INTEGER AS reporting_period_total_8,
        jsonb_extract_path_text(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Performance')), 'Instance')->8, 'Metric_Type') AS metric_type_9, 
        jsonb_extract_path_text(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Performance')), 'Instance')->8, 'Count')::INTEGER AS reporting_period_total_9,
        jsonb_extract_path_text(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Performance')), 'Instance')->9, 'Metric_Type') AS metric_type_10, 
        jsonb_extract_path_text(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Performance')), 'Instance')->9, 'Count')::INTEGER AS reporting_period_total_10,
        jsonb_extract_path_text(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Performance')), 'Instance')->10, 'Metric_Type') AS metric_type_11, 
        jsonb_extract_path_text(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Performance')), 'Instance')->10, 'Count')::INTEGER AS reporting_period_total_11          
    FROM 
        folio_erm_usage.counter_reports
    WHERE 
        jsonb_extract_path_text(counter_reports.jsonb, 'reportName') = 'DR'
    ORDER BY
        jsonb_extract_path_text(jsonb_array_elements(jsonb_extract_path(counter_reports.jsonb, 'report', 'Report_Items')), 'Database') ASC, 
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
    counter_reports.database,
    counter_reports.publisher,
    CASE 
        WHEN counter_reports.publisher_id_type_1 = 'ISNI' THEN counter_reports.publisher_id_value_1
        WHEN counter_reports.publisher_id_type_2 = 'ISNI' THEN counter_reports.publisher_id_value_2
    END AS publisher_id,
    counter_reports.platform,
    CASE 
        WHEN counter_reports.publisher_id_type_1 = 'Proprietary' THEN counter_reports.publisher_id_value_1
        WHEN counter_reports.publisher_id_type_2 = 'Proprietary' THEN counter_reports.publisher_id_value_2
    END AS proprietary_id,
    counter_reports.data_type,
    counter_reports.access_type,
    counter_reports.access_method,           
    CASE
        WHEN counter_reports.metric_type_1 = 'Total_Item_Requests' THEN counter_reports.reporting_period_total_1 
        WHEN counter_reports.metric_type_2 = 'Total_Item_Requests' THEN counter_reports.reporting_period_total_2
        WHEN counter_reports.metric_type_3 = 'Total_Item_Requests' THEN counter_reports.reporting_period_total_3
        WHEN counter_reports.metric_type_4 = 'Total_Item_Requests' THEN counter_reports.reporting_period_total_4
        WHEN counter_reports.metric_type_5 = 'Total_Item_Requests' THEN counter_reports.reporting_period_total_5
        WHEN counter_reports.metric_type_6 = 'Total_Item_Requests' THEN counter_reports.reporting_period_total_6
        WHEN counter_reports.metric_type_7 = 'Total_Item_Requests' THEN counter_reports.reporting_period_total_7
        WHEN counter_reports.metric_type_8 = 'Total_Item_Requests' THEN counter_reports.reporting_period_total_8
        WHEN counter_reports.metric_type_9 = 'Total_Item_Requests' THEN counter_reports.reporting_period_total_9
        WHEN counter_reports.metric_type_10 = 'Total_Item_Requests' THEN counter_reports.reporting_period_total_10
        WHEN counter_reports.metric_type_11 = 'Total_Item_Requests' THEN counter_reports.reporting_period_total_11
    END AS total_item_requests,
    CASE
        WHEN counter_reports.metric_type_1 = 'Total_Item_Investigations' THEN counter_reports.reporting_period_total_1 
        WHEN counter_reports.metric_type_2 = 'Total_Item_Investigations' THEN counter_reports.reporting_period_total_2
        WHEN counter_reports.metric_type_3 = 'Total_Item_Investigations' THEN counter_reports.reporting_period_total_3
        WHEN counter_reports.metric_type_4 = 'Total_Item_Investigations' THEN counter_reports.reporting_period_total_4
        WHEN counter_reports.metric_type_5 = 'Total_Item_Investigations' THEN counter_reports.reporting_period_total_5
        WHEN counter_reports.metric_type_6 = 'Total_Item_Investigations' THEN counter_reports.reporting_period_total_6
        WHEN counter_reports.metric_type_7 = 'Total_Item_Investigations' THEN counter_reports.reporting_period_total_7
        WHEN counter_reports.metric_type_8 = 'Total_Item_Investigations' THEN counter_reports.reporting_period_total_8
        WHEN counter_reports.metric_type_9 = 'Total_Item_Investigations' THEN counter_reports.reporting_period_total_9
        WHEN counter_reports.metric_type_10 = 'Total_Item_Investigations' THEN counter_reports.reporting_period_total_10
        WHEN counter_reports.metric_type_11 = 'Total_Item_Investigations' THEN counter_reports.reporting_period_total_11
    END AS total_item_investigations,
    CASE
        WHEN counter_reports.metric_type_1 = 'Unique_Item_Requests' THEN counter_reports.reporting_period_total_1 
        WHEN counter_reports.metric_type_2 = 'Unique_Item_Requests' THEN counter_reports.reporting_period_total_2
        WHEN counter_reports.metric_type_3 = 'Unique_Item_Requests' THEN counter_reports.reporting_period_total_3
        WHEN counter_reports.metric_type_4 = 'Unique_Item_Requests' THEN counter_reports.reporting_period_total_4
        WHEN counter_reports.metric_type_5 = 'Unique_Item_Requests' THEN counter_reports.reporting_period_total_5
        WHEN counter_reports.metric_type_6 = 'Unique_Item_Requests' THEN counter_reports.reporting_period_total_6
        WHEN counter_reports.metric_type_7 = 'Unique_Item_Requests' THEN counter_reports.reporting_period_total_7
        WHEN counter_reports.metric_type_8 = 'Unique_Item_Requests' THEN counter_reports.reporting_period_total_8
        WHEN counter_reports.metric_type_9 = 'Unique_Item_Requests' THEN counter_reports.reporting_period_total_9
        WHEN counter_reports.metric_type_10 = 'Unique_Item_Requests' THEN counter_reports.reporting_period_total_10
        WHEN counter_reports.metric_type_11 = 'Unique_Item_Requests' THEN counter_reports.reporting_period_total_11
    END AS unique_item_requests,
    CASE
        WHEN counter_reports.metric_type_1 = 'Unique_Item_Investigations' THEN counter_reports.reporting_period_total_1 
        WHEN counter_reports.metric_type_2 = 'Unique_Item_Investigations' THEN counter_reports.reporting_period_total_2
        WHEN counter_reports.metric_type_3 = 'Unique_Item_Investigations' THEN counter_reports.reporting_period_total_3
        WHEN counter_reports.metric_type_4 = 'Unique_Item_Investigations' THEN counter_reports.reporting_period_total_4
        WHEN counter_reports.metric_type_5 = 'Unique_Item_Investigations' THEN counter_reports.reporting_period_total_5
        WHEN counter_reports.metric_type_6 = 'Unique_Item_Investigations' THEN counter_reports.reporting_period_total_6
        WHEN counter_reports.metric_type_7 = 'Unique_Item_Investigations' THEN counter_reports.reporting_period_total_7
        WHEN counter_reports.metric_type_8 = 'Unique_Item_Investigations' THEN counter_reports.reporting_period_total_8
        WHEN counter_reports.metric_type_9 = 'Unique_Item_Investigations' THEN counter_reports.reporting_period_total_9
        WHEN counter_reports.metric_type_10 = 'Unique_Item_Investigations' THEN counter_reports.reporting_period_total_10
        WHEN counter_reports.metric_type_11 = 'Unique_Item_Investigations' THEN counter_reports.reporting_period_total_11
    END AS unique_item_investigations, 
    CASE
        WHEN counter_reports.metric_type_1 = 'Unique_Title_Investigations' THEN counter_reports.reporting_period_total_1 
        WHEN counter_reports.metric_type_2 = 'Unique_Title_Investigations' THEN counter_reports.reporting_period_total_2
        WHEN counter_reports.metric_type_3 = 'Unique_Title_Investigations' THEN counter_reports.reporting_period_total_3
        WHEN counter_reports.metric_type_4 = 'Unique_Title_Investigations' THEN counter_reports.reporting_period_total_4
        WHEN counter_reports.metric_type_5 = 'Unique_Title_Investigations' THEN counter_reports.reporting_period_total_5
        WHEN counter_reports.metric_type_6 = 'Unique_Title_Investigations' THEN counter_reports.reporting_period_total_6
        WHEN counter_reports.metric_type_7 = 'Unique_Title_Investigations' THEN counter_reports.reporting_period_total_7
        WHEN counter_reports.metric_type_8 = 'Unique_Title_Investigations' THEN counter_reports.reporting_period_total_8
        WHEN counter_reports.metric_type_9 = 'Unique_Title_Investigations' THEN counter_reports.reporting_period_total_9
        WHEN counter_reports.metric_type_10 = 'Unique_Title_Investigations' THEN counter_reports.reporting_period_total_10
        WHEN counter_reports.metric_type_11 = 'Unique_Title_Investigations' THEN counter_reports.reporting_period_total_11
    END AS unique_title_investigations,
    CASE
        WHEN counter_reports.metric_type_1 = 'Unique_Title_Requests' THEN counter_reports.reporting_period_total_1 
        WHEN counter_reports.metric_type_2 = 'Unique_Title_Requests' THEN counter_reports.reporting_period_total_2
        WHEN counter_reports.metric_type_3 = 'Unique_Title_Requests' THEN counter_reports.reporting_period_total_3
        WHEN counter_reports.metric_type_4 = 'Unique_Title_Requests' THEN counter_reports.reporting_period_total_4
        WHEN counter_reports.metric_type_5 = 'Unique_Title_Requests' THEN counter_reports.reporting_period_total_5
        WHEN counter_reports.metric_type_6 = 'Unique_Title_Requests' THEN counter_reports.reporting_period_total_6
        WHEN counter_reports.metric_type_7 = 'Unique_Title_Requests' THEN counter_reports.reporting_period_total_7
        WHEN counter_reports.metric_type_8 = 'Unique_Title_Requests' THEN counter_reports.reporting_period_total_8
        WHEN counter_reports.metric_type_9 = 'Unique_Title_Requests' THEN counter_reports.reporting_period_total_9
        WHEN counter_reports.metric_type_10 = 'Unique_Title_Requests' THEN counter_reports.reporting_period_total_10
        WHEN counter_reports.metric_type_11 = 'Unique_Title_Requests' THEN counter_reports.reporting_period_total_11
    END AS unique_title_requests,
    CASE
        WHEN counter_reports.metric_type_1 = 'No_License' THEN counter_reports.reporting_period_total_1 
        WHEN counter_reports.metric_type_2 = 'No_License' THEN counter_reports.reporting_period_total_2
        WHEN counter_reports.metric_type_3 = 'No_License' THEN counter_reports.reporting_period_total_3
        WHEN counter_reports.metric_type_4 = 'No_License' THEN counter_reports.reporting_period_total_4
        WHEN counter_reports.metric_type_5 = 'No_License' THEN counter_reports.reporting_period_total_5
        WHEN counter_reports.metric_type_6 = 'No_License' THEN counter_reports.reporting_period_total_6
        WHEN counter_reports.metric_type_7 = 'No_License' THEN counter_reports.reporting_period_total_7
        WHEN counter_reports.metric_type_8 = 'No_License' THEN counter_reports.reporting_period_total_8
        WHEN counter_reports.metric_type_9 = 'No_License' THEN counter_reports.reporting_period_total_9
        WHEN counter_reports.metric_type_10 = 'No_License' THEN counter_reports.reporting_period_total_10
        WHEN counter_reports.metric_type_11 = 'No_License' THEN counter_reports.reporting_period_total_11
    END AS no_license,
    CASE
        WHEN counter_reports.metric_type_1 = 'Limit_Exceeded' THEN counter_reports.reporting_period_total_1 
        WHEN counter_reports.metric_type_2 = 'Limit_Exceeded' THEN counter_reports.reporting_period_total_2
        WHEN counter_reports.metric_type_3 = 'Limit_Exceeded' THEN counter_reports.reporting_period_total_3
        WHEN counter_reports.metric_type_4 = 'Limit_Exceeded' THEN counter_reports.reporting_period_total_4
        WHEN counter_reports.metric_type_5 = 'Limit_Exceeded' THEN counter_reports.reporting_period_total_5
        WHEN counter_reports.metric_type_6 = 'Limit_Exceeded' THEN counter_reports.reporting_period_total_6
        WHEN counter_reports.metric_type_7 = 'Limit_Exceeded' THEN counter_reports.reporting_period_total_7
        WHEN counter_reports.metric_type_8 = 'Limit_Exceeded' THEN counter_reports.reporting_period_total_8
        WHEN counter_reports.metric_type_9 = 'Limit_Exceeded' THEN counter_reports.reporting_period_total_9
        WHEN counter_reports.metric_type_10 = 'Limit_Exceeded' THEN counter_reports.reporting_period_total_10
        WHEN counter_reports.metric_type_11 = 'Limit_Exceeded' THEN counter_reports.reporting_period_total_11
    END AS limit_exceeded,
    CASE
        WHEN counter_reports.metric_type_1 = 'Searches_Regular' THEN counter_reports.reporting_period_total_1 
        WHEN counter_reports.metric_type_2 = 'Searches_Regular' THEN counter_reports.reporting_period_total_2
        WHEN counter_reports.metric_type_3 = 'Searches_Regular' THEN counter_reports.reporting_period_total_3
        WHEN counter_reports.metric_type_4 = 'Searches_Regular' THEN counter_reports.reporting_period_total_4
        WHEN counter_reports.metric_type_5 = 'Searches_Regular' THEN counter_reports.reporting_period_total_5
        WHEN counter_reports.metric_type_6 = 'Searches_Regular' THEN counter_reports.reporting_period_total_6
        WHEN counter_reports.metric_type_7 = 'Searches_Regular' THEN counter_reports.reporting_period_total_7
        WHEN counter_reports.metric_type_8 = 'Searches_Regular' THEN counter_reports.reporting_period_total_8
        WHEN counter_reports.metric_type_9 = 'Searches_Regular' THEN counter_reports.reporting_period_total_9
        WHEN counter_reports.metric_type_10 = 'Searches_Regular' THEN counter_reports.reporting_period_total_10
        WHEN counter_reports.metric_type_11 = 'Searches_Regular' THEN counter_reports.reporting_period_total_11
    END AS searches_regular,
    CASE
        WHEN counter_reports.metric_type_1 = 'Searches_Automated' THEN counter_reports.reporting_period_total_1 
        WHEN counter_reports.metric_type_2 = 'Searches_Automated' THEN counter_reports.reporting_period_total_2
        WHEN counter_reports.metric_type_3 = 'Searches_Automated' THEN counter_reports.reporting_period_total_3
        WHEN counter_reports.metric_type_4 = 'Searches_Automated' THEN counter_reports.reporting_period_total_4
        WHEN counter_reports.metric_type_5 = 'Searches_Automated' THEN counter_reports.reporting_period_total_5
        WHEN counter_reports.metric_type_6 = 'Searches_Automated' THEN counter_reports.reporting_period_total_6
        WHEN counter_reports.metric_type_7 = 'Searches_Automated' THEN counter_reports.reporting_period_total_7
        WHEN counter_reports.metric_type_8 = 'Searches_Automated' THEN counter_reports.reporting_period_total_8
        WHEN counter_reports.metric_type_9 = 'Searches_Automated' THEN counter_reports.reporting_period_total_9
        WHEN counter_reports.metric_type_10 = 'Searches_Automated' THEN counter_reports.reporting_period_total_10
        WHEN counter_reports.metric_type_11 = 'Searches_Automated' THEN counter_reports.reporting_period_total_11
    END AS searches_automated,
    CASE
        WHEN counter_reports.metric_type_1 = 'Searches_Federated' THEN counter_reports.reporting_period_total_1 
        WHEN counter_reports.metric_type_2 = 'Searches_Federated' THEN counter_reports.reporting_period_total_2
        WHEN counter_reports.metric_type_3 = 'Searches_Federated' THEN counter_reports.reporting_period_total_3
        WHEN counter_reports.metric_type_4 = 'Searches_Federated' THEN counter_reports.reporting_period_total_4
        WHEN counter_reports.metric_type_5 = 'Searches_Federated' THEN counter_reports.reporting_period_total_5
        WHEN counter_reports.metric_type_6 = 'Searches_Federated' THEN counter_reports.reporting_period_total_6
        WHEN counter_reports.metric_type_7 = 'Searches_Federated' THEN counter_reports.reporting_period_total_7
        WHEN counter_reports.metric_type_8 = 'Searches_Federated' THEN counter_reports.reporting_period_total_8
        WHEN counter_reports.metric_type_9 = 'Searches_Federated' THEN counter_reports.reporting_period_total_9
        WHEN counter_reports.metric_type_10 = 'Searches_Federated' THEN counter_reports.reporting_period_total_10
        WHEN counter_reports.metric_type_11 = 'Searches_Federated' THEN counter_reports.reporting_period_total_11
    END AS searches_federated
FROM 
    counter_reports
WHERE
    ((counter_reports.data_type = (SELECT data_type FROM parameters)) OR ((SELECT data_type FROM parameters) = ''))
    AND 
    ((counter_reports.platform = (SELECT platform FROM parameters)) OR ((SELECT platform FROM parameters) = ''))
    AND 
    ((counter_reports.publisher = (SELECT publisher FROM parameters)) OR ((SELECT publisher FROM parameters) = ''))
    AND 
    ((counter_reports.database = (SELECT database FROM parameters)) OR ((SELECT database FROM parameters) = ''))
    /* AND 
    counter_reports.reporting_period_start >= (SELECT reporting_start_period FROM parameters)
    AND 
    counter_reports.reporting_period_end <= (SELECT reporting_end_period FROM parameters) */
;
