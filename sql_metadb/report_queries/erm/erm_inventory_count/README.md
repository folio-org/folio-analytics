# Documentation for the ERM inventory count query 

## Table of Contents

- [1\. Purpose](#1-purpose)
- [2\. Filters](#2-filters)
    - [2.1\. Hardcoded filters](#21-hardcoded-filters)
    - [2.2\. Parameter filters](#22-parameter-filters)
- [3\. Sample Output](#3-sample-output)
	
1\. Purpose
--------------------
The aim is to provide title counts for `electronic` resources cataloged in the Inventory, by various filters. This query relies on the `title count query` but is only addressing virtual instances.

2\. Filters
--------------------
2.1\. Hardcoded filters
--------------------
Hardcoded filters in the where clause:
* Show 
    * only e-resources. This query is intended to only include e-resources. It includes instance records with instance format names of `computer – online resource` or instance records with holdings library names of `Online`. These values many need to be updated for your local needs.
* Do not show 
    * suppressed instance records
	* suppressed holdings records

2.2\. Parameter filters
--------------------
Through parameter filters, this query allows you to easily type in text to filter various statuses. 

* DATE RANGE:
    * You can filter when the instance record was cataloged. It allows you to specify start and end date.
* POSSIBLE FORMAT MEASURES:
    * Instance types, e.g. `text`, `Performed Music`, `Other` etc. The query allows up to three selected simultaneously.
    * Instance statuses. You can use this parameter to include only those titles cataloged and made ready for use; for many institutions, this would be `cataloged` and `batchloaded`; note that if your institution sets an instance status of, e.g., `pda unpurchased` you can exclude unpurchased patron driven acquisitions items if needed. The query allows up to two selected simultaneously.
    * Instance formats, e.g. `audio -- audio disc', 'computer -- other' etc. The query allows up to three selected simultaneously.
    * Instance languages: will include a value for each language used; if more than one language, the first is the primary language if there is one; use `%%` as wildcards; use, e.g. `%%eng%%` to get all titles that are fully or partially in english.
    * Inventory modes of issuance name, e.g. `integrating resource`, `serial`, `multipart monograph` etc.
    * Instance nature of content terms, e.g. `textbook`, `journal`
    * Holdings receipt status, e.g. `partially received`, `fully received`
    * Holdings types, e.g. `Electronic`, `Monograph` etc.
    * Call number:
        * Holdings call number types, e.g. `LC`, `NLM`, `Dewey Decimal` etc.
        * Holdings call number. Note that the call number field is a text string only (no breakouts). You may want to use truncation symbols as suggested in the filter to get at call number ranges.
    * Holdings acquisition method, e.g. `Purchase`, `Approval`, `Gifts` etc.
* STATISTICAL CODES:
    * Instance statistical code, e.g. `Active Serial`, `Book, print (books)`, `Book`, `electronic (ebooks)`, `Microfiche` etc.
    * Holdings statistical code, e.g. `Active Serial`, `Book, print (books)`, `Book`, `electronic (ebooks)`, `Microfiche` etc.
	* Instance statistical code type, e.g. `ARL (Collection stats)`, `DISC (Discovery)`
* LOCATION:
<br> Institutions with a shared consortial database may need to filter with their institutional location information to verify ownership, i.e. presence of instance record alone not enough. Or institutions may want to exclude particular locations.
  * Holdings permanent location name, e.g. `Online`, `Annex`, `Main Library`
  * Holdings campus name, e.g. `Main Campus`, `City Campus`, `Online`
  * Holdings library name, e.g. `Datalogisk Institut`, `Adelaide Library`
  * Holdings institution name, e.g. `Kobenhavns Universitet`, `Montoya College`
 
3\. Sample Output
--------------------

| attribute | sample output |
|-----------|---------------|
| type_id | 6312d172-f0cf-40f6-b27d-9fa8feaf332f |
| type_name | text |
| mode_of_issuance_id | 9d18a02f-5897-4c31-9106-c9abb5c7ae8b |
| mode_of_issuance_name | single unit |
| instance_format_id | f5e8210f-7640-459b-a71f-552567f92369 |
| instance_format_code | cr |
| instance_format_name | computer -- online resource |
| first_language | eng |
| instance_statistical_code_id |  |
| instance_statistical_code |  |
| instance_statistical_code_name | |
| nature_of_content_id | |
| nature_of_content_code | |
| nature_of_content_name | |
| holdings_type_id | |
| holdings_type_name | |
| holdings_callnumber_type_id | |
| holdings_callnumber_type_name | |
| holdings_statistical_code_id | |
| holdings_statistical_code | |
| holdings_statistical_code_name | |
| holdings_receipt_status | |
| location_name | |
| previously_held | |
| instance_super_relation_relationship_type_id | |
| instance_super_relation_relationship_type_name | |
| instance_sub_relation_relationship_type_id | |
| instance_sub_relation_relationship_type_name | |
| title_count | 1 |
