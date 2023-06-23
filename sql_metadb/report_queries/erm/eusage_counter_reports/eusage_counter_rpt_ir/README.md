# COUNTER Item Master Report

## Purpose

This report is a A Standard View of COUNTER Item Master Reports and shows activity across all metrics for single items, such as articles or videos. The reports contains also additonal informations to the COUNTER report file.

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
| Item | The title of the item | 3D Printed Microfluidics |
| Publisher | An organization whose function is to commission, create, collect, validate, host, distribute and trade information online and\/or in printed form. | Annual Reviews |
| Publisher_ID | An ID for the publisher | ar:1015 |
| Platform | The name of the platform | Annual Reviews | 
| Authors | The authors of the item | Alan Poland, Joyce C. Knutson |
| Publication_Date | The publication date of the item | 2015-03-20 |
| Article_Version | Defined by ALPSP and NISO as a classification of the version of an Article as it goes through its publication life-cycle. <br> * Accepted Manuscript (AM) <br> * Version of Record (VoR) <br> * Corrected Version of Record (CVoR) <br> * Enhanced Version of Record (EVoR) | VoR |
| DOI | The digital object identifier for the item  | 10.1729/jhik.345 |
| Proprietary | A COUNTER report item identifier for a unique identifier given by publishers and other content providers to a product or collection of products. | SampleIR:100026 |
| Online_ISSN | The E-ISSN of the item | 1234-5678 |
| Print_ISSN | The P-ISSN of the item | 1234-5678 |
| ISBN | The ISBN of the item | 978-3-16-448410-7 |
| URI | The URI of the item | http:\/\/www.example.com\/questions\/3456\/my-document |
| Parent_Title | The parent title of the publication an item is part of. For a journal article, the parent is the journal, and for a book chapter it is the book. | Annual Review of Pharmacology and Toxicology |
| Parent_Authors | The contributers \/ authors of the parent title an item is part of. For a journal article, the parent is the journal, and for a book chapter it is the book. | Alan Poland, Joyce C. Knutson |
| Parent_Publication_Date | The publication date of the parent title | 2014-03-03 |
| Parent_Article_Version | Defined by ALPSP and NISO as a classification of the version of an Article as it goes through its publication life-cycle. <br> * Accepted Manuscript (AM) <br> * Version of Record (VoR) <br> * Corrected Version of Record (CVoR) <br> * Enhanced Version of Record (EVoR) | VoR |
| Parent_Data_Type | The element identifying the type of content. | Journal |
| Data_Type | The element identifying the type of content. | Article |
| YOP | Year of publication. Calendar year in which an article, item, issue, or volume is published. | 2015 |
| Access_Type | A COUNTER report attribute used to report on the nature of access control restrictions, if any, placed on the content item at the time when the content item was accessed. <br> * Controlled <br> * OA_Gold <br> * OA_Delayed <br> * Other_Free_to_Read | OA_Gold |
| Access_Method | This tells how the content was used. Regular means the usage was by a person, while TDM means robotic use | Regular |
| Total_Item_Requests | A COUNTER Metric_Type that represents the number of times users requested the full content (e.g. a full text) of an item. Requests may take the form of viewing, downloading, emailing, or printing content, provided such actions can be tracked by the content provider. | 1|
| Total_Item_Investigations | A COUNTER Metric_Type that represents the number of times users accessed the content (e.g. a full text) of an item, or information describing that item (e.g. an abstract). | 1 |
| Unique_Item_Requests | A COUNTER Metric_Type that represents the number of unique content items requested in a user session. Examples of content items are articles, books, book chapters, and multimedia files. | 1 |
| Unique_Item_Investigations | A COUNTER Metric_Type that represents the number of unique content items investigated in a user session. Examples of content items are articles, books, book chapters, and multimedia files. | 1 |
| Parent_DOI | The digital object identifier for the parent title | 10.1729/jhik | 
| Parent_Proprietary | A COUNTER report item identifier for a unique identifier given by publishers and other content providers to a product or collection of products. | SampleIR:45 | 
| Parent_Online_ISSN | The E-ISSN of the parent title | 1234-5678 |
| Parent_Print_ISSN | The P-ISSN of the parent title | 1234-5678 |
| Parent_ISBN | The ISBN of the parent title | 978-3-16-458401-2 |
| Parent_URI | The URI of the parent title | http:\/\/www.example.com\/questions\/3456\/my-document |

## Parameters

The parameters in the table below can be set in the WITH clause to filter the report output.

| parameter | description | examples |
| --- | --- | --- |
| reporting_start_period | Start date of period of the COUNTER report | Set start date in YYYY-MM-DD format |
| reporting_end_period |  End date of period of the COUNTER report | Set end date in YYYY-MM-DD format |
| item_title | Filter out a specific item title | 3D Printed Microfluidics |
| parent_title | Filter out a specific parent title | Annual Review of Pharmacology and Toxicology |
| platform | Filter out a specific platform | Annual Reviews |
| access_type | Filter out the nature of access control restrictions | * Controlled <br> * OA_Gold <br> * OA_Delayed <br> * Other_Free_to_Read | 
