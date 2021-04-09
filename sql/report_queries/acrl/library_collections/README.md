
# Documentation for the ACRL Library Collections Reports  

## Contents
* [Status](https://github.com/folio-org/folio-analytics/tree/main/sql/report_queries/acrl/libary_collections#status) 
* [Purpose](https://github.com/folio-org/folio-analytics/tree/main/sql/report_queries/acrl/libary_collections#purpose) 
* [Filters](https://github.com/folio-org/folio-analytics/tree/main/sql/report_queries/acrl/libary_collections#filters) 
* [Output](https://github.com/folio-org/folio-analytics/tree/main/sql/report_queries/acrl/libary_collections#output) 
* [Requests not yet addressed](https://github.com/folio-org/folio-analytics/tree/main/sql/report_queries/acrl/libary_collections#requests-not-yet-addressed) 

## Status
This READMe refers ACRL reporters to the following four queries which were created earlier. These queries can be adapted for this particular need, and for local reporting situations.
* Title Count (for physical titles cataloged in Inventory)
* Item Count  (for physical volumes cataloged in Inventory)
* ERM Title count (If using ERM - for electronic items tracked in the ERM, which is still in development)
* ERM Inventory Title Count  (for electronic items cataloged in Inventory)

## Purpose
These queries can be used by ACRL member libraries to report on library collections cataloged or tracked through the FOLIO Inventory and/or Folio ERM (currently in development) for ACRL’s annual Academic Library Trends and Statistics Survey. 

<details>
  <summary>Click to expand!</summary>
	
ACRL requires seven collection title counts, and one collection item count:
* Title counts:
  * Physical book titles
  * Physical serial titles (doesn’t matter if current/ceased or currently received or not; in all formats)
  * Physical media titles
  * Electronic book titles
  * Electronic serial titles (doesn’t matter if current/ceased or currently received or not; in all formats)
  * Electronic media titles
  * Electronic database titles
* Item count:
  * Physical volumes (text-based volumes)

The four queries noted above provide title or item counts by format. Among other elements, they include the most common FOLIO elements used to describe formats; reporters will likely need to add and/or remove elements to suit their local needs, and may need to write additional queries.  Where possible, they allow you to type text into “parameter filters” to help get the needed format breakouts. See the format filter section below.  Each institution’s reporters need to know how their institution tracks the metadata need to get the requested breakouts. 

You can run the queries multiple times to get individual counts.  Alternatively, you may be able to run a query one time, splitting up the title counts with all relevant format measures.

**Please also note for the title counts:** 
Generally, the goal is to count unique instance records by format. Needed format information will be either on the instance and/or the holdings records.  We have not tested this fully, but it is advised that if you want unique title counts, that if you are using data on the holdings record, you filter on that data only, and not include it in the grouping display. Otherwise, if you include holdings fields that may not be unique to the instance record, (e.g., there are multiple locations at the institution, there are multiple copies within a specific library or across a campus, there are different holdings types, etc.) the title count will be increased to reflect the counts that are unique across the instance and holdings records. 
</details>

## FILTERS
As mentioned earlier, four main queries can be used to help institution answering the Library Collections data and many filters can be selected.
1. Title Count
2. Volume Count
3. ERM Title Count (If using ERM; targeted for Release 1.1 but relies on the next version of LDP (MetaDB)) 
4. ERM Inventory Title Count

<details>
  <summary>Click for information on Hardcoded and Parameter filters!</summary>

### Hardcoded filters:
Note that the first two queries exclude online resources via their hardcoded filters (i.e., not instance.format_name (computer – online resource) and not holdings.library_name (online)). The fourth limits items in the Inventory to online resources via its hard filters (i.e., in instance.format_name (computer – online resource) and in holdings.library_name (online)).  All queries exclude records that are suppressed.

### Paramter filters:
(Note that the FOLIO App “Settings” for Inventory may allow you to see what possible values many of these fields may contain at your institution.)

#### Non-format filters:
* ACRL requests that unpurchased PDA/DDA items be excluded.  How they are tracked may differ by library.  We know one library is considering excluding them through the instance status element.
* Libraries may need to include/exclude titles by location.

#### Format filters:
The table below help reporters by indicating which query to use and which format filters to select to get the desired count. In the left-hand column of the table below, is a list of the counts needed for the survey. The second column provides guidance on how you could use filters to get to the desired format counts using the existing queries. Please know that the filters chosen may be different from one institution to another and the lists provided are suggestions based on the data currently available to report writers. It may well change as new developments are rolled out. 

|**Measure Name**|**Filters of Possible Interest**|
|---|---|
|**Physical: Books (title count)**|**Main query: Title Count**|
|   |Format filters options: Instance Type: text; tactile text; notated music; tactile notated music; tactile notated movement. (Also, look at titles coded as "Unspecified". Do other elements help you decide if counts should be included here?|
|   |Holdings Type:  monograph, multi-part monograph, physical.|
|   |Instance Mode of Issuance: single unit; multipart monograph; integrating resource.|
|   |Instance format: unmediated --volume.  (also look at unspecified with other fields)|
|   |Instance Statistical Code: books, print (books); printed music; music scores, (print).|
|   |*(Exclude: microforms; serials; maps;  videos; audios; mixed material, etc.)*|
|   |   |
|**Digital/Electronic: Books (title count)**|**Main query:  ERM Title Count (not available yet)**|
|   |Format filter options:|
|   |Resource Type : books|
|   |*If possible, exclude any unpurchased PDA/DDA items (possibly through instance status).*|
|   |   |
|   |**AND/OR (depending on where e-resources are tracked/cataloged)**|
|   |   |
|   |Main query: ERM Inventory Title Count|
|   |Filters options:|
|   |Instance Type: text; notated music; notated movement. (Also look at titles coded as "Unspecified". Do other elements help you decide if counts should be included here?)|
|   |Instance Statistical Code: Books, electronic (ebooks).|
|   |Instance Format: computer online resource|
|   |Holdings Type: electronic|
|   |Instance Mode of issuance: single unit; multipart monograph. (Also look at what is recorded in "Unspecified". Do other elements help you decide if counts should be included here?)|
|   |*If possible, exclude any unpurchased PDA/DDA items (possibly through instance status).*|
|   |   |
|**Physical: Volume count**|**Main query: Item Count**|
|(the ACRL measure name “Books (volume count)” name is a misnomer. The definition indicates it includes serials as well as other print-based volumes.|Format filter options:|
|   |Instance Type: text; tactile text; notated music; tactile notated music; notated movement. (Also look at what is recorded in "Unspecified".  Do other elements help you decide if counts should be included here?).|
|   |Holdings Type: physical|
|   |(Instance mode of issuance: all values.)|
|   |Instance format: unmediated --volume.  (also look at unspecified with other fields)|
|   |Holdings Statistical Code: book, print (books) printed music; music scores, (print); serials.|
|   |   |
|**Digital/Electronic: Databases**|**Main query: ERM Inventory Title Count**|
|   |Format filter options:|
|   |Instance mode of issuance: integrating resource|
|   |Instance format: computer-online resource|
|   |Holdings Type: electronic|
|   |Material Type: database|
|   |Statistical Code: database?|
|   |   |
|**Physical: Media**|**Main query: Title Count**|
|   |Format filter options:|
|   |*Instance format: When trying to identify media items for ACRL, start with Instance Format.  It includes many types of Media.  Include all formats that contain the text of:*<br>\*audio\*<br>\*video\*<br>\*image\*<br>\*micro\* (including microforms and microscopic)<br>\*object\*<br>\*graphic\* (including stereographic)|
|   |*For those items with Instance Formats that include  “\*unmediated\*” and “\*unspecified\*” then try the Instance Type to see if that gives clues.  Media would include titles with Instance types of:*<br>Cartographic material<br>Projected medium<br>Nonmusical sound recording<br>Musical sound recording<br>Two-dimensional nonprojectable graphic<br>Three-dimensional artifact or naturally occurring object|
|   |*Exclude all serials. Your institution might identify serials through Inventory mode of issuance, Instance statistics codes, holdings type).*|
|   |   |
|**Digital/Electronic: Media**|**Main query: ERM Title Count (not available yet)**|
|   |   |
|   |**AND/OR (depending on where e-resources are tracked/cataloged)**|
|   |   |
|   |**Main query: ERM Inventory Count**|
|   |Format filter options:|
|   |*Instance format: When trying to identify media items for ACRL, start with Instance Format.  It includes many types of Media.  Include all formats that contain the text of:*|
|   |\*audio\*|
|   |\*video\*|
|   |\*image\*|
|   |\*micro\* (including microforms and microscopic)|
|   |\*object\*|
|   |\*graphic\* (including stereographic)|
|   |*For those items with Instance Formats that include  “*unmediated*” and “*unspecified*” then try the Instance Type to see if that gives clues.  Media would include titles with Instance types of:*|
|   |Cartographic material|
|   |Projected medium|
|   |Nonmusical sound recording|
|   |Musical sound recording|
|   |Two-dimensional nonprojectable graphic|
|   |Three-dimensional artifact or naturally occurring object|
|   |*Exclude all serials. Your institution might identify serials through Inventory mode of issuance, Instance statistics codes, holdings type).*|
|   |*Note that you may also want to include in your count some items you cataloged outside of FOLIO.  For example, you might want to include those images you cataloged in Artstor, or that you pay for separately and host through Artstor.*|
|   |*If possible, exclude any unpurchased PDA/DDA items (possibly through instance status).*|
|   |   |
|**Physical: Serials (publication (such as a newspaper or journal) issued as one of a consecutively numbered and indefinitely continued series) Any type of serial.**|**Main query: Title Count**|
|   |Format filter options:|
|   |Instance Mode of Issuance: serial|
|   |Instance Statistical Code: For example, serials, print (serials)|
|   |Holdings Type: serial|
|   |Holdings location : not serv,remo (online)|
|   |   |
|**Digital/Electronic: Serials**|**Main query: ERM Title Count (Not available yet)**|
|   |Resource Type : serial|
|   |   |
|   |**AND/OR (depending on where e-resources are tracked/cataloged)**|
|   |   |
|   |**Main query: ERM Inventory Title Count**|
|   |Format filter options:|
|   |Instance Mode of Issuance: serials|
|   |Instance Statistical Code: serials, electronic  (eserials)|
|   |Holdings Type: serial|
|   |Holdings location: serv,remo (online)|                                  
</details>
	 	 
## Output
Not provided since it will be coming from each individual query.

## Requests not yet addressed 
None at this time

