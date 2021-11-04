# Documentation for the RM title query (UXPROD-2395)

## Contents
* [Purpose](https://github.com/folio-org/folio-analytics/blob/main/sql/report_queries/title_count/README.md#purpose)
* [Filters](https://github.com/folio-org/folio-analytics/blob/main/sql/report_queries/title_count/README.md#filters)
* [Output](https://github.com/folio-org/folio-analytics/blob/main/sql/report_queries/title_count/README.md#output)
* [Requests not yet addressed](https://github.com/folio-org/folio-analytics/blob/main/sql/report_queries/title_count/README.md#requests-not-yet-addressed)


## Purpose
These two queries can be used to get counts of subscriptions with purchase orders in the Inventory, and their associated costs, if any. 

<details>
  <summary>Click to read more!</summary>



You can use the parameter filters to specify:
* Whether or not there must have been a costs associated with the subscriptions within a specific time period
* And whether or not the subscription was open during the period in question, or closed out in the period in question
* See notes above for additional information about specific queries. This documentation is specifically about cost and count of current subscriptions.


The Subscription Cost query uses the same parameters and hardcoded filters as the Subscriptions Count query, but adds the needed costs information (total amount spent per invoice Line).

### Assumptions:
* The count query is intended to be used for physical titles, electronic packages, and electronic titles cataloged individually in the Inventory. Note that electronic packages will contain multiple subscriptions that need to be counted in some other way, as appropriate for your institution.
* These queries do not report for subscriptions where there are not purchase orders; future queries may be written.
* To be a current subscription, the PO_TYPE needs to be “ongoing,” and the ORDER ISSUBSCRIPTION value “true.” And the WORKFLOW STATUS ‘Open’.
* To be available to users, the WORKFLOW_STATUS should not be pending
* If used to tell if the subscription is still in force, the POL SUBSCRIPTION TO date should be  greater than the last date in question
* If used to tell if the subscription was cancelled within the year in question, the POL SUBSCRIPTION TO date should be greater than the first date in question.
* For most institutions, POs for physical subscriptions will only have one PO line.  But since some institutions’ POs may have multiple lines (e.g., for electronic subscriptions), the resulting count will be per PO line (one count per row).   If this is different at your institution, please make appropriate changes to your query.
* We are assuming that each subscription may have more than one payment in a year, so there may be more than one row per purchase order line in the output even with the COUNT(DISTINCT ppo.id) command (export results to remove duplicates and to get summary counts).
* The stipulation that there was a payment is only needed for the year in question.  Some institutions make multiple year payments for subscriptions; this query does not account for that.


**Please note as always:** \
These queries are intended to include the most common FOLIO elements that would normally be used for this purpose; reporters may need to add and remove fields to suit their local needs, and may need to write additional queries. Where possible, the query allows you to type text into “parameter filters” to help get the needed breakouts. Each institution’s reporters need to know how their institution tracks the metadata need to get requested breakouts.
</details>

## Filters

#### Hardcoded filters (assumptions; in the where clause):
To select only Purchase Orders that are subscriptions:
* the Order Type need to be “ongoing”
* the isSubscription status is “true” 
* Workflow status is “Open”

#### Parameter filters (at the top of the queries):

* Through parameter filters, this SQL allows you to easily type in text to filter by: po_line receipt status, invoice payment date, po_line order format, instance nature of content
<details>
  <summary>Click to read more!</summary>

    • PO_Line_Receipt Status: (e.g. 'Pending', ‘Awaiting Receipt,’ 'Partially Received', 'Fully Received', 'Cancelled', ‘Receipt Not Required,’ or leave blank for all) Note: if you are counting current subscriptions available to users, you should request ‘Partially Received’ only).
    • Invoice payment date: lets you limit by timeframe. Note, however, that some payments may be made for multiple years. An institution may use ‘subscription_from’ and ‘and subscription_to’, to get the subscriptions dates. 
    • PO_lines.order_format  (e.g.,'Electronic Resource', 'Physical Resource', 'P/E Mix', 'Other')
    • Instance_nature_of_content (to meet particular DBS – Deutsche Bibliotheksstatistik requests)

  </details>

## Output
You can use this information to breakout counts or exclude counts for summary counts.

Info identifying the order:
* PO Id (ppo.id)
* PO number
* PO line number
* Acquisition method
* PO line title or package title (pol.title_or_package)
* Instance title (poi.title)
* Vendor name (poorg.org_name)
* PO acquisition unit (poacq.po_acquisition_unit_name)
* PO bill to (ppo.bill_to)

Info about the format of the item:
* Is this a package or not (pol.is_package)
* POL tags (if used)
* Instance nature of content for DBS reporters (inc.nature_of_content_term_name,-- should provide journal and newspaper)
* Purchase order line format (pol.order_format)
* Purchase order line physical material type (polp.pol_mat_type_name)
* Purchase order line electronic material type (pole.pol_er_mat_type_name)

Info about the status/nature of the order:
* PO workflow status (ppo.workflow_status)
* POL receipt status (may not currently be functioning properly?) Current info as of May 2021: Relying on receipt looks messy.  A number of issues have been encountered with receiving and how it works during migration trials. It is possible we might initially just receive in inventory, but hope not to.
* PO approval date (ppo.approval_date)
* PO approved by id (ppo.approved_by_id)
* PO ongoing interval (poong.po_ongoing_interval)
* PO ongoing renewal date (poong.po_ongoing_renewal_date)
* PO ongoing review period (poong.po_ongoing_review_period)
* PO line subscription from date (pols.pol_subscription_from)
*  PO line subscription to date (pols.pol_subscription_to)
* PO line payment status (pol.payment_status)

Additional Info about payment/cost for the subscription cost query:

* Invoice payment date (it.invoice_payment_date) 
* Transaction amount per invoice line converted. (Transaction_amount_per_invl_converted). This is the transaction amount for each invoice line in the system currency.
* Transaction invoice adjustment distributed (transaction_inv_adj_dist_converted). This is the amount of the adjustment made at the invoice level (if any) converted to the system currency. This needs to be calculated separately when an adjustment at the invoice level was made, not prorated and in addition to the invoice lines.
* Total paid converted (total_paid_converted). This is the addition of the invoice line total amount and the adjustment not prorated if any. 

**Note:**  We are using the transaction table since some institutions may approve invoices in a foreign currency. The amount presented at the transaction level is always in the system currency.
