# COUNTER Platform Master Report

## Purpose

This report is a standard view of COUNTER Platform Master Reports and showing total and unique item requests, as well as platform searches. The report contains also additonal informations to the COUNTER report file.

## Attributes

| attribute | description | sample output |
| --- | --- | --- |
| id | UUID of the report | e034f768-5a29-4751-9212-3702ebddf4c5 |
| report_name | Name of the report | Platform Master Report |
| report_id | Identifier of the report | PR |
| release | The version of COUNTER | 5 |
| institution_name | Name of the institution to which usage is attributed | WIB1234 - Library XY |
| institution_id | Identifier for the institution to which usage is attributed | 123456 |
| reporting_period_start | Date range start covered by the report | 2023-04-01 |
| reporting_period_end | Date range end covered by the report | 2023-04-30 |
| created | Date the report was run | 2023-05-22 |
| created_by | Name of organization or system that generated the report | Example LLC. |
| report_year_mounth | Month and its year covered in the report. It is kind of a date range | 2023-04 |
| platform | The name of the platform | Annual Reviews |
| data_type | The type of content item used | Journal |
| access_method | This tells how the content was used. Regular means the usage was by a person, while TDM means robotic use | Regular |
| searches_platform | A COUNTER Metric_Type used to report on searches conducted at the platform level | 13 |
| total_item_requests | A COUNTER Metric_Type that represents the number of times users requested the full content (e.g. a full text) of an item. Requests may take the form of viewing, downloading, emailing, or printing content, provided such actions can be tracked by the content provider. | 1|
| total_item_investigations | A COUNTER Metric_Type that represents the number of times users accessed the content (e.g. a full text) of an item, or information describing that item (e.g. an abstract). | 1 |
| unique_item_investigations | A COUNTER Metric_Type that represents the number of unique content items investigated in a user session. Examples of content items are articles, books, book chapters, and multimedia files. | 1 |
| unique_item_requests | A COUNTER Metric_Type that represents the number of unique content items requested in a user session. Examples of content items are articles, books, book chapters, and multimedia files. | 1 |

## Parameters

The parameters in the table below can be set in the WITH clause to filter the report output.

| parameter | description | examples |
| --- | --- | --- |
| reporting_start_period | Start date of period of the COUNTER report | Set start date in YYYY-MM-DD format |
| reporting_end_period |  End date of period of the COUNTER report | Set end date in YYYY-MM-DD format |
| platform | The name of the platform | Annual Reviews |
