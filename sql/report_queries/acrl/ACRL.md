# ACRL’s Academic Library Trends and Statistical Survey

The Association of College and Research Libraries (ACRL), http://www.ala.org/acrl/ , is the largest division of the American Library Association (ALA).  Its survey is the largest survey of academic libraries in the U.S.

The ACRL survey is annual (fiscal year), and is hosted by Counting Opinions through LibPAS.  The most recent survey form and definitions can be found at: https://acrl.countingopinions.com/ .  Earlier surveys can be found at https://acrl.countingopinions.com/index.php?page_id=5 .  The survey has a LibGuide: https://acrl.libguides.com/stats/surveyhelp .   There is no freely available access to the ACRL results; consult your local ACRL data provider for more info.

Note: The ACRL survey includes all measures included in the NCES survey (as well as additional measures), and it purposefully uses the same definitions to save libraries time.  Institutions with multiple IPEDS IDs report for those campuses separately.

There are three sets of data requested by the ACRL survey that are normally tracked through library management systems such as FOLIO:
*	Materials-related expenditures
* Library collections
*	Library circulation
  
FOLIO queries are available for this survey at GitHub Folio-Analytics at: https://github.com/folio-org/folio-analytics/tree/main/sql/report_queries/acrl .  See these GitHub folders to address these ACRL measures:
 
* https://github.com/folio-org/folio-analytics/tree/main/sql/report_queries/acrl/collections_expenditures :
  * Materials / Services Expenses:
    * 20: One-time purchase of books, serial backfiles, and other materials
      * 20a: > E-books (if available; subset)
    * 21: Ongoing commitments to subscriptions
      * 21a: > e-books (if available; subset)
      * 21b: > e-journals (if available; subset)
    * 22: All other materials/services costs
    * 23: Total materials/services expenses
   
* https://github.com/folio-org/folio-analytics/tree/main/sql/report_queries/acrl/library_collections :
  (note that this does not include all types of resources):
  
  * Library Collections:
    * 40: Books [title counts] – physical and digital/electronic
    * 40a: Volume count [item count] – physical
    * 41: Databases [title count] – digital/electronic
    * 42: Media [title counts] – physical and digital/electronic
    * 43: Serials [title counts] – physical and digital/electronic
    * 44: Total – physical and digital/electronic
      
* https://github.com/folio-org/folio-analytics/tree/main/sql/report_queries/acrl/circulation :
  
  * Library Circulation / Usage:
    * Total circulation – physical (general and reserve checkouts)
    * (Note that the survey also requests COUNTER download counts.  Those reports are still awaiting development.)
