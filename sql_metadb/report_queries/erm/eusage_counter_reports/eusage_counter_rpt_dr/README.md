# COUNTER Database Master Report

## Purpose

This report shows activity across all metrics for entire databases or fixed collections of content which behave like a database. The reports contains also additonal informations to the COUNTER report file.

## Attributes

| attribute | description | sample output |
| --- | --- | --- |
| id | UUID of the report | e034f768-5a29-4751-9212-3702ebddf4c5 |
| report_name | Name of the report | Platform Master Report |
| report_id | Identifier of the report | IR |
| release | The version of COUNTER | 5 |
| institution_name | Name of the institution to which usage is attributed | WIB1234 - Library XY |
| institution_id | Identifier for the institution to which usage is attributed | 123456 |
| reporting_period_start | Date range start covered by the report | 2023-04-01 |
| reporting_period_end | Date range end covered by the report | 2023-04-30 |
| created | Date the report was run | 2023-05-22 |
| created_by | Name of organization or system that generated the report | Example LLC. |
| report_year_mounth | Month and its year covered in the report. It is kind of a date range | 2023-04 |
| database | A collection of electronically stored data or unit records (facts, bibliographic data, texts) with a common user interface and software for the retrieval and manipulation of data (NISO) | Academic Search Premier |
| publisher | An organization whose function is to commission, create, collect, validate, host, distribute and trade information online and\/or in printed form. | Annual Reviews |
| publisher_id | An ID for the publisher | ar:1015 |
| platform | The name of the platform | Annual Reviews |
| proprietary_id | A COUNTER report item identifier for a unique identifier given by publishers and other content providers to a product or collection of products | Ovid:1416 |
| data_type | The element identifying the type of content. | Database |
| access_type | A COUNTER report attribute used to report on the nature of access control restrictions, if any, placed on the content item at the time when the content item was accessed. <br> * Controlled <br> * OA_Gold <br> * OA_Delayed <br> * Other_Free_to_Read | OA_Gold |
| access_method | This tells how the content was used. Regular means the usage was by a person, while TDM means robotic use | Regular |
| total_item_requests | A COUNTER Metric_Type that represents the number of times users requested the full content (e.g. a full text) of an item. Requests may take the form of viewing, downloading, emailing, or printing content, provided such actions can be tracked by the content provider. | 1 |
| total_item_investigations | A COUNTER Metric_Type that represents the number of times users accessed the content (e.g. a full text) of an item, or information describing that item (e.g. an abstract). | 1 |
| unique_item_requests | A COUNTER Metric_Type that represents the number of unique content items requested in a user session. Examples of content items are articles, books, book chapters, and multimedia files. | 1 |
| unique_item_investigations | A COUNTER Metric_Type that represents the number of unique content items investigated in a user session. Examples of content items are articles, books, book chapters, and multimedia files. | 1 |
| unique_title_investigations | A COUNTER Metric_Type that represents the number of unique titles investigated in a user session. This Metric_Type is only applicable for Data_Type Book | 2 |
| unique_title_requests | A COUNTER Metric_Type that represents the number of unique titles requested in a user session. This Metric_Type is only applicable for Data_Type Book | 1 |
| no_license | A COUNTER Metric_Type. A user is denied access to a content item because the user or the user’s institution does not have access rights under an agreement with the vendor | 1 |
| limit_exceeded | A COUNTER Metric_Type. A user is denied access to a content item because the simultaneous-user limit for their institution’s license would be exceeded | 1 |
| searches_regular | A COUNTER Metric_Type used to report on searches conducted by a user on a host site where the user has the option of selecting the databases being searched | 1 |
| searches_automated | A COUNTER Metric_Type used to report on searches conducted on a host site or discovery service where multiple databases are searched simultaneously with a single query and the end user does not have the option of selecting the databases being searched | 1 |
| searches_federated | A COUNTER Metric_Type used to report on searches conducted by a federated search application | 1 |

## Parameters

The parameters in the table below can be set in the WITH clause to filter the report output.

| parameter | description | examples |
| --- | --- | --- |
| reporting_start_period | Start date of period of the COUNTER report | Set start date in YYYY-MM-DD format |
| reporting_end_period |  End date of period of the COUNTER report | Set end date in YYYY-MM-DD format |
| data_type | The element identifying the type of content | Database |
| platform | Filter out a specific platform | Annual Reviews |
| publisher | Filter out a specific publisher | Annual Reviews |
| database | Filter out a specific database | Academic Search Premier |
