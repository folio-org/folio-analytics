# ACRL Collections Expenditures Reports  (UXPROD-2529)

Table of Contents
=================

  * [Status](#status)
  * [Purpose](#purpose)
  * [ACRL Collection Expenditures survey info](#survey)
  * [Filters](#filters)
  * [Output](#output)
  * [Requests not yet adressed](#requests)


## Status <a name="status"></a>
The ACRL Collection Expenditures comprises three different queries -- ACRL Collection Expenditures A, B & C. The different use for each query is described in this document under ‘Purpose’. As of 03/19/2021, these queries are in testing status. 
<p>
 
## Purpose <a name="purpose"></a>
These queries are designed to help ACRL member libraries report on expenditures paid through the FOLIO Inventory for ACRL’s annual Academic Library Trends and Statistics Survey. 
<p>
  It is important to keep in mind that the way library materials expenditures are reported in FOLIO may be different from how they were reported in your previous system. Understanding the new data model will be key in getting the desired results. 
 <p>
These queries are intended to include the most common FOLIO fields used; reporters will likely need to add and remove fields to suit their local needs, and may need to write additional queries.  Where possible, they allow you to type text into “parameter filters” to help get the needed breakouts. Each institution’s reporters need to know how their institution tracks the metadata need to get the requested breakouts.  
<p>
<details>
  <summary markdown="span">Click here to read more!</summary>  
  <br>
<p>
 Most expenditures tracked in library management systems are for materials or materials-related services.  However, some institutions might report some expenditures that are tracked in the FOLIO Inventory, in ACRL’s “Operations and Maintenance Expenses.”  Likewise, what institutions choose to include in ACRL’s “all other materials/services” may also vary.  So, each reporter will need to know how expenditures are handled at their institution. 
 <p>
  In FOLIO, only payments made at the Invoice Line level can be assigned a bibliographic format and order type through their corresponding purchase order lines.  However, FOLIO allows institutions to also make payments/adjustments at the Invoice level. For example, some may pay for shipping costs only at the Invoice level.  This report is broken into three parts to help address these differences.  Part C provides data for Invoice transactions/adjustments made directly at the Invoice level that are ‘Not prorated’, and therefore not distributed to the Invoice Lines total.  Part B provides payments made at the Invoice Line level, excluding any transactions/adjustments made directly at the Invoice level that are not prorated.  Part A provides a total of both, prorating any ‘un-prorated’ Invoice transactions/adjustments amount and distributing it to each Invoice Line based on the ratio of each Invoice Line amount in relation to the Invoice Lines total amount, per invoice. If an institution wants to break out service costs to be reported in “all other materials/services” or in “operations and maintenance expenses” (e.g., ill costs, shipping, or binding), and it tracks those expenses by fund (either at the invoice or the PO line level), the institution will need to build and run a separate query to isolate those costs, and remove them from the appropriate totals.
  <p>
  Please note that these queries make use of the Finance Transactions table to get the exact amounts spent.  This is because, in FOLIO, an invoice can be approved in a foreign currency, but the Finance Transactions table is the only place where the exchange rate calculations are presented (calculated without causing rounding problems). Exchange rate information can also be found in the Invoice Invoices table, but at this time, it should not be used to get exact totals since it carries only two digits. 
 <p> 
<ins>ACRL Collection Expenditures A:</ins>
<p>
This query reports on all FOLIO inventory expenditures, including un-prorated transactions/adjustments made at the Invoice level.  Expenditures are broken down by Invoice Lines.   The needed totals can be calculated by exporting your results to Excel or by using any other reporting tools of your choice, like Tableau. Transactions at the Invoice level that are "Prorated" are applied automatically to the Invoice Lines by the system. The prorate field specifies how the adjustment should be distributed.
The Invoice transactions/adjustments that are "Not prorated" and “in addition to” are not distributed to the Invoice Lines. In this case, the query adds the Invoice transactions/adjustments to each Invoice Line based on its ratio in relation to the Invoice Lines total amount. (See above)
 <P>
  For example, in this query, if an invoice adjustment is for shipping, is “Not Prorated”, and is “In addition to”, the cost will be distributed to each Invoice Line according to the ratio  calculated by the query. Therefore, the amount included in the report will include the amount for shipping. If your institution is recording shipping separately as an invoice adjustment and you do not want to include this invoice adjustment to your PO costs, then the option would be to record the adjustment as ‘Not prorated’ and use the ACRL Collection Expenditures B and the ACRL Collection Expenditures C jointly to get the total needed. 
<br>
<p>
<ins>ACRL Collection Expenditures B:</ins>
This query provides the total of materials expenditures made at the invoice line level. The overall total will be calculated by adding all Invoice Lines together. The needed totals will be calculated by exporting your results to Excel or by using any other reporting tools of your choice, like Tableau.  Please note that it does not include any transactions made at the Invoice level that have not been distributed to the Invoice Lines by the system. If one wants to get the total of Invoice Lines plus the total of all invoice transactions/adjustments made only at the invoice level, then the ACRL Collection Expenditures B should be run jointly with ACRL Collection Expenditures C.  
<br>
<p>
 <ins>ACRL Collection Expenditures C:</ins>
This query will return all transactions made at the Invoice Level that have not been distributed to any Invoice Line.   The needed totals will be calculated by exporting your results to excel or by using any other reporting tools of your choice, like Tableau.  As mentioned earlier, the ACRL Collection Expenditure B can be used in conjunction with the ACRL Collection Expenditures C to provide total material expenditures; 
 <br>
 <h4>Relevant LDP/FOLIO documentation:</h4> 
 
 * API reference documentation for all modules located at:  https://dev.folio.org/reference/api/
 * Schema Spy has visual representation of tables at https://glintcore.net:8443/ldp/schemaspy/public/relationships.html
 * FOLIO raml parser: https://docs.google.com/spreadsheets/d/1m_Cq_GmZX37gJPEjVWt9eOLXskUjSLUb-8KapWj0SIw/edit#gid=24879874
 * Inventory Beta - Metadata Elements (being kept up to date by Charlotte): https://docs.google.com/spreadsheets/d/1RCZyXUA5rK47wZqfFPbiRM0xnw8WnMCcmlttT7B3VlI/edit#gid=952741439
 * LDP table relationships: https://glintcore.net:8443/ldp/schemaspy/public/relationships.html
 <p>
 The most current U.S. Association of College & Research Libraries (ACRL) survey documentation is available here: https://acrl.countingopinions.com/  Earlier documentation is available here: https://acrl.countingopinions.com/index.php?page_id=5

 <p> 
 </details>

 ## ACRL Collection Expenditures survey info<a name="survey"></a>
<p>
 The annual ACRL Academic Library Trends and Statistics survey asks members to report their total materials expenditures broken into one-time, ongoing, and all other materials/services expenditures.  It also asks, if possible, that members break out: e-book expenditures from within one-time expenditures; and e-book and e-journal expenditures from within ongoing expenditures.
 <p>
  As noted above, some “Operations and Maintenance” expenditures may also be included in FOLIO (see https://acrl.countingopinions.com for more info).  A basic assumption is that institutions should report expenditures where they think most appropriate, avoiding any duplication.
  <p>
 The current (FY20) ACRL survey requests are described briefly below, and fully at https://acrl.countingopinions.com/. ACRL requests that expenditures be reported for the most recent 12-month period that corresponds to the institution's fiscal year. All expenses should be reported in whole dollars in the most appropriate category to provide an unduplicated count of expenses. 
   
<details>
  <summary markdown="span">Click here to read more!</summary>  
  <br>
   <p>   
   
 
| Material/Services expenses  | Additional information |
| ------------- | ------------- |
| One-time purchase of books, serial backfiles, and other materials  | Include: onetime purchases of books, serials, and all other materials (electronic or 	physical, including locally held e-resources), purchased on a one-time basis.<br>Exclude: expenses for computer software used to support library operations or to link to external networks, and anything purchased on a subscription basis.
| E-books (20a)<br> (if available)<br> (subset of above): | Include:  expenditures for any e-books purchased on a one-time basis, including e-books purchases triggered through a PDA or DDA program. <br>Exclude: ongoing subscriptions to e-book packages; and deposit account money that hasn’t been expended yet.<br>Note: some vendor packages mix formats. If your library has such packages, you may want to indicate this measure is unavailable, or note that the count only includes those sold separately. |
| Ongoing commitments to subscriptions:  | Include: expenses for ongoing commitments for all formats, including serials and any other items committed to annually, including annual electronic platform or access 	fees. Expenditures for standing orders if possible.  |
| E-books (21a)<br> (if available)<br>(subset of above):| Include: ongoing subscriptions to ebook packages; include annual fees for e-book 	platforms. <br> Note: some vendor packages mix formats. If your library has such packages, you may want to indicate this measure is unavailable, or note that the count only includes those sold separately.|
| E-journals 21b <br> (if available)<br>(subset of above)::  | Include: expenses for e-journals purchased in an ongoing basis. See note above.  | 
| All other material/services cost  | ACRL is not fully prescriptive about what should be included in the category “all other materials/services expenditures”; it only indicates what these expenditures “may” include.  This is possibly because it may not be easy for members to break out these costs.  It may also be because some institutions do not consider the expenditures ACRL recommends as materials expenditures, but as other operating expenditures; and following local procedures, institutions may need or want to include them as other operating expenditures.  ACRL suggests that “all other materials/services” might include, e.g.: document delivery/interlibrary loan services; pay-per-view journal articles costs unless added to your collection; fees expended for short-term loans as part of a DDA or PDA programs; copyright fees and fees for database searches; and costs for bibliographic management systems (e.g., RefWorks).  See the ACRL documentation for more info.  Each institution will need to decide what is correct for them.  It is suggested data notes are provided if local practices differ. 

Note that the ACRL survey is aligned with the NCES Academic Library survey, so these measures can also be used for that survey.
<p>
ACRL requests that expenditures be reported for the most recent 12-month period that corresponds to the institution's fiscal year. All expenses should be reported in whole dollars in the most appropriate category to provide an unduplicated count of expenses. 
 <p>
   </details>
     <p>
 
  


## Filters <a name="filters"></a>
<p>
Each institution’s reporters will need to know how to best get the needed breakouts for their institution.  The code in this query includes hardcoded filters and parameters filters.
<details>
  <summary markdown="span">Click here to read more!</summary>  
   <h4>Hardcoded filters:</h4> 
 These are assumptions, located in the 'Where" clause.
 For this query, there is only one harcoded filter: Invoice lines with a status of ‘paid’
 <p>
  <h4>Parameter filters:</h4> 
 
 * Approval date: Select approval_date_start_date and approval_date_end_date (e.g., 2019-	01-01)
 * Payment Date (currently in development, should be added to these queries)
 * Order Type: Select “one-time” or “ongoing,” or leave blank for both
 * Order Format: Select “Electronic Resource,” “Physical Resource,” “P/E Mix” or leave 	blank for all)
 * Instance Format: Select e_resources vs physical. (eg. "computer-online resource" for electronic resources or "Physical Resource" for physical resources) 
 * Instance Mode of Issuance: Select “single unit”, “serial” etc.
 * Location: Location should be added later when a link will be created between Holdings and PO Lines.
 <p>
 
   </details>
 <p> 

## Output <a name="output"></a>
<ins>ACRL Collection Expenditures A:</ins>
<br>
 Aggregation:
 
* Invoice ID
* Purchase Order Line ID
* Purchase order number
* Purchase order type
* Purchase order line format
* Instance format name
* Purchase order line material type physical
* Purchase order line material type electronic
* Instance mode of issuance name
* Invoice Line status
* Invoice Line ID
* Invoice approval date
* Invoice payment date
* Invoice Line adjustments description
* Invoice adjustments total
* Invoice Line value
* Invoice exchange rate
* Invoice currency
* Transaction type
* Transaction invoice adjustment converted
* Transaction amount per Invoice Line converted
* Total paid converted

<p> 
 <details>
  <summary markdown="span">Click here to read more!</summary>  
  <br>
  
 <p> 
<ins>ACRL Collection Expenditures B:</ins>
 <br>
 Aggregation:
 
* Invoice ID
* Purchase Order Line ID
* Purchase order number
* Purchase order type
* Purchase order line format
* Instance format name
* Purchase order line material type physical
* Purchase order line material type electronic
* Instance mode of issuance name
* Invoice Line status
* Invoice Line ID
* Invoice approval date
* Invoice payment date 
* Invoice Line sub-total
* Invoice Line adjustments value
* Invoice Line adjustments description
* Invoice Line value
* Invoice exchange rate
* Invoice currency
* Transaction type
* Transaction amount per Invoice Line converted

 
 <ins>ACRL Collection Expenditures C:</ins>
<br>
Aggregation:
 
* Transaction ID
* Invoice approval date
* Invoice payment date
* Transaction source invoice ID
* Fiscal year code
* Transaction source Invoice Line ID
* Transaction amount
* Transaction currency
* Transaction type

 </details>

## Requests not yet adressed <a name="requests"></a>
<p>
 <ins>ACRL Collection expenditures report by location:</ins>
 <br>
At this time, the location data is only available through the PO lines at the time of its creation and the total amount of the PO lines may very well be $0; therefore using this location data would not return accurate results. <p>
 <ins>Future Custom Fields:</ins>
 <br>
There is JIRA issue created to be able to add custom fields to Purchase Orders and Purchase Order Lines. This could be useful for ACRL reporting in the future.
https://issues.folio.org/plugins/servlet/mobile#issue/UXPROD-2865



