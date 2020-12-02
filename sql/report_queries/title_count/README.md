# Documentation for the RM title query

## Contents
* [Status](https://github.com/LM-15/falltest/blob/main/README.md#status)
* [Purpose](https://github.com/LM-15/falltest/blob/main/README.md#purpose)
* [Filters](https://github.com/LM-15/falltest/blob/main/README.md#filters)
* [Output](https://github.com/LM-15/falltest/blob/main/README.md#output)
* [Requests not yet addressed](https://github.com/LM-15/falltest/blob/main/README.md#requests-not-yet-addressed) 


## Status
As of 11/18/20, this query has been reviewed, but it is being updated to use the relevant derived tables.

## Purpose
To provide **title** counts for **non-electronic** resources cataloged in the Inventory, by various filters.  

<details>
  <summary>Click to read more!</summary>
  
  * Provides unique title counts (i.e., only one count if more than one copy/subscription).  
  * Modify this query to suit your local needs. This query was built to include many of the measures commonly used to get overall title counts, such as those that record bibliographic format and library location information. Some parameter filters are available.  We also try to spell out which assumptions are made (some of which individual institutions may need to adjust), and requests not yet addressed. 
  * Queries to count e-resources (whether tracked through the ERM or the Inventory) are available separately. Each reporter must know where their institution’s various resources are tracked and should find the needed reports as appropriate, adding together counts if needed, and avoiding any duplication if possible.
  * Note that it is generally assumed that if you need a holdings count as of a certain date, you take it on that date; while you may be able to use processing dates to exclude resources newly added after a certain date, you cannot get back titles that were withdrawn or transferred.
  * Local and national definitions can be updated from year to year; be sure to review for needed changes.
  </details>
  
  ## Filters
  
  #### Hardcoded filters (assumptions; in the where clause):
* Excludes: e-resources; suppressed instance records, and instance records with only suppressed holdings records.  

<details>
  <summary>Click to read more!</summary>
  
  * Each instance has a holdings record.  Each holdings record has a permanent location.
  * Excludes suppressed instance records (instance discovery suppress value is “true”)
  * [When this field becomes available:] Excludes instance records that do not have at least one unsuppressed holdings record (all holdings discovery suppress values are “true”)
  * This query is intended to exclude e-resources. It excludes instance records with instance format names of “computer – online resource” or “ISNULL,”  and excludes instance records with holdings library names of “Online” or “ISNULL.” These values many need to be updated for your local needs.
  </details>
  
#### Parameter filters (at the top of the query):

* Through parameter filters, this SQL allows you to easily type in text to filter by: instance status, resource format, receipt status, language, date, location, call number and holdings acquisition method.  

<details>
  <summary>Click to read more!</summary>
  
  * Instance statuses:
    * Instance statuses name (you can use this parameter to include only those titles cataloged and made ready for use; for many institutions, this would be "cataloged" and "batchloaded"; note that if your institution sets an instance status of, e.g., "pda unpurchased" you can exclude unpurchased patron driven acquisitions items if needed) (query allows up to two selected simultaneously)
  * Resource format: (Reporters need to know how their institution's records format information locally; it may use one of more of these commonly used fields, but not all of them.)
    * Instance types name (e.g., text, video, computer dataset, etc.)  (query allows up to three selected simultaneously)
    * Instance formats name (e.g., video – videocassette, unmediated – sheet, microform – microfilm roll, etc.)  (query allows up to three selected simultaneously)
    * Instance nature of content terms (e.g., autobiography, journal, newspaper, research report, etc.)
    * Instance statistical code types name (e.g., ARL (Collection stats), DISC (Discovery); SERM (Serial management), etc.)
    * Instance statistical code name
    * Holdings statistical code name
    * Inventory modes of issuance name (e.g., serial, integrating resource, single unit, unspecified, etc.)
    * Holdings types name (e.g., physical, electronic, serial, multi-part monograph, etc.)
* Receipt status:
  * Holdings receipt status (e.g., not currently received)
* Language:
  * Languages (will include a value for each language used; if more than one language, the first is the primary language if there is one; use %% as wildcards; use, e.g., "%%eng%%" to get all titles that are fully or partially in english.)
* Date:
  * Cataloged date (allows you to specify start and end date)
* Location: (where housed) (institutions with a shared consortial database may need to filter with their institutional location information to verify ownership (i.e., presence of instance record alone not enough))
  * Holdings permanent location id (typically the lowest level in the location hierarchy -- the specific location within a library)
  * Holdings location name
  * Holdings campus name
  * Holdings institution name
* Call number:
  * Holdings call number types name (e.g., LC, NLM, Dewey Decimal, etc.)
  * Holdings call number (note that the call number field is a text string only (no breakouts); you may want to use truncation symbols as suggested in the filter to get at call number ranges)
  * Holdings acquisition method (e.g., gift, deposit, membership, etc.)
  </details>
  
  #### Other fields you might want to filter on in results:
    * Instance previously held  (indicates the item was "previously held" in terms of, for example, HathiTrust digital access)
    * Super relation type name  (content within titles is sometimes analyzed (cataloged) as part of the larger, parent title; if you need to avoid including one level in your count in such cases, this and the following measure will allow you to exclude one or the other) (This query assumes that a relationship type is always included.)
    * Sub relation type name (see immediately above)

## Output
Aggregation: This query provides counts grouped by:
* Instance type id
* Instance type name
* Mode of issuance id
* Mode of issuance name
* Instance format id
* Instance format code
* Instance format name
* Instance language (first)
* Instance statistical code id
* Instance statistical code
* Instance statistical code name
* Instance nature of content id
* Instance nature of content code
* Instance nature of content name
* Holdings type id
* Holdings type name
* Holdings call number type id
* Holdings call number type name
* Holdings statistical code id
* Holdings statistical code
* Holdings statistical code name
* Holdings receipt status
* Inventory locations name
* Instance previously held
* Instance super relationship type id
* Instance super relationship type name
* Instance sub relationship type id
* Instance sub relationship type name

## Requests not yet addressed
<details>
  <summary>Click to read more!</summary>
  
  See this page for additional information recorded by the Resource Management reporters: https://wiki.folio.org/x/OA8uAg 
  * Counting separately multiple formats cataloged on the same instance record (maybe by unique instances and unique holdings formats?)
  * Information tracked possibly through holdings records notes?: precious bindings, copy notes, dedications, inscriptions, left by decedents? Use a filter with truncation. Which measures each institution uses to track this information could differ.
  * When fields available?:
    * When the holdings discover suppress field becomes available, add it to the WHERE hardcoded filters and update comment.
    * country of publication (source record)
    * date of publication (At this point in time, we are not bringing in the instance dataofpublication because it is not in standardized form; institutions may want to consider bringing it in if they set up parsing options to suit their needs. Will likely add date one and date two data from the source record when available (MARC  008 (places 7-10 for date 1, and 11-14 for date 2)).
    * geographic area code (source record)
    * is open access (source record?)
    * withdrawn in timeframe (instance suppressed with status update date in timeframe?)
    * transferred within the institution in a time period
    * has retention requirements / is an obligatory copy (have retention policy field on holdings?)
    * is government document (how this will be addressed by institutions can vary greatly; statistical code, location, source record (not yet available; e.g., MARC 008, 086 for federal US/Canadian docs))
    * acquired as part of a project
    * identifying records for collections like CRL if in catalog, so can be excluded for national reporting
  </details>
