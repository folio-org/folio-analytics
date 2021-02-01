/**
 
PURPOSE
The purpose of this report is to provide details about each purchase order. 
It allows filtering by date, order type, tags, and workflow status. 
The data are aggregated by purchase order, acquisition method, and material type.

MAIN TABLES AND COLUMNS INCLUDED
-po_lines
 -purchase order line number
 -purchase_order_number from po_lines_id
 -tags (data array)
 -purchase order description
 -acquisition method
 -subscription from
 -subscription to 
 -material type (data array)
 -instanceid
 
-po_purchase_orders
 -order type
 -workflow status
 -acquisition unit (data array)
 -acquisition method

AGGREGATION
This query aggregates the data by po line number, po order type, po acquisition method, po acquisition unit name, and material type.	
 
FILTERS FOR USERS TO SELECT
date: filters data using the date_ordered field on purchase orders
order type: can be set to One-Time or Ongoing; renewal date is only present if order type is Ongoing
subscription: can be set for "subscription to," subscription from" dates; subscription data only shows for One-Time order type
workflow status: can be set to pending, open, or closed
tags: local field with custom settings; can set up to 3 tag filters	

OPTIONAL FIELDS
Acquistion unit id and acquisition unit name: these fields will only show data if the institution has elected to use them.
Subscription data entry is optional for institutions.

STILL IN PROGRESS
-need to add paymentDate field from invoices data array when this field is available

*/
 
-- updated to use date
WITH parameters AS (
    SELECT
        '2000-01-01'::date AS start_date,
        '2021-01-01'::date AS end_date,
        ''::varchar AS workflow_status,
        ''::varchar AS order_type,
        -- Please comment/uncomment one pair the these NULL parameters if you want to define the range of active subscriptions
        NULL::date AS subscription_from_date,
        NULL::date AS subscription_to_date,
        --'2000-01-01'::date AS subscription_from_date,
        --'2021-01-01'::date AS subscription_to_date,
        ''::varchar AS tags_filter1, -- select 'your first local tag' or leave blank for all. You can use %% as wildcards.
        ''::varchar AS tags_filter2, -- select 'your second local tag' or leave blank for all. You can use %% as wildcards.
        ''::varchar AS tags_filter3 --select 'your third local tag' or leave blank for all. You can use %% as wildcards.
),
-- po_lines_detail
po_lines_detail AS (
    SELECT
        pol.id AS po_line_id,
        pol.po_line_number AS po_line_number,
        poltags.pol_tag AS purchase_order_tag,
        pol.description AS purchase_order_description,
        pol.acquisition_method AS purchase_order_acquisition_method,
        polsubdtl.pol_subscription_from AS pol_subscription_from,
        polsubdtl.pol_subscription_to AS pol_subscription_to,
        polsubdtl.pol_subscription_interval AS pol_subscription_interval,
        polermat.pol_er_mat_type_name AS purchase_order_elec_material_type_name,
        polphysmat.pol_mat_type_name AS purchase_order_phys_material_type_name,
        json_extract_path_text(pol.data, 'instanceId')::varchar AS instance_id,
        pol.purchase_order_id AS purchase_order_id
    FROM
        po_lines AS pol
        LEFT JOIN folio_reporting.po_lines_er_mat_type AS polermat ON pol.id = polermat.pol_id
        LEFT JOIN folio_reporting.po_lines_phys_mat_type AS polphysmat ON pol.id = polphysmat.pol_id
        LEFT JOIN folio_reporting.po_lines_tags AS poltags ON pol.id = poltags.pol_id
        LEFT JOIN folio_reporting.po_lines_details_subscription AS polsubdtl ON pol.id = polsubdtl.pol_id
),
-- po_purchase_order_detail
po_purchase_order_detail AS (
    SELECT
        podtl.id AS po_detail_id,
        podtl.order_type AS po_order_type,
        podtl.po_number AS po_number,
        json_extract_path_text(podtl.data, 'dateOrdered')::varchar AS po_date_ordered,
        podtl.workflow_status AS po_workflow_status,
        poacqunitids.po_acquisition_unit_id AS po_acquisition_unit_id,
        poacqunitids.po_acquisition_unit_name AS po_acquisition_unit_name,
        poonging.po_ongoing_interval AS po_ongoing_interval,
        poonging.po_ongoing_is_subscription AS po_is_subscription,
        poonging.po_ongoing_renewal_date AS po_renewal_date,
        poonging.po_ongoing_review_period AS po_review_period
    FROM
        po_purchase_orders AS podtl
        LEFT JOIN folio_reporting.po_acq_unit_ids AS poacqunitids ON podtl.id = poacqunitids.po_id
        LEFT JOIN folio_reporting.po_ongoing AS poonging ON podtl.id = poonging.po_id
)
-- MAIN QUERY: provide details about each purchase order with filtering by date and/or order type
-- starts from po_lines_detail
SELECT
    po_line_number,
    purchase_order_description,
    po_order_type,
    purchase_order_acquisition_method,
    po_acquisition_unit_name,
    purchase_order_elec_material_type_name,
    purchase_order_phys_material_type_name 
FROM
    po_lines_detail AS pol
    LEFT JOIN po_purchase_order_detail AS podtl ON podtl.po_detail_id = pol.purchase_order_id
-- filters for date ordered, workflow status, order type, subscription start and end dates, and tags
WHERE
--	 (podtl.po_date_ordered > (SELECT start_date FROM parameters) AND
--		podtl.po_date_ordered < (SELECT end_date FROM parameters))
--	AND
    ((podtl.po_workflow_status = (
                SELECT
                    workflow_status
                FROM
                    parameters))
            OR ((
                    SELECT
                        workflow_status
                    FROM
                        parameters) = ''))
    AND ((po_order_type = (
                SELECT
                    order_type
                FROM
                    parameters))
            OR ((
                    SELECT
                        order_type
                    FROM
                        parameters) = ''))
    AND ((pol.pol_subscription_to >= (
                SELECT
                    subscription_from_date
                FROM
                    parameters)
                OR pol.pol_subscription_from <= (
                    SELECT
                        subscription_to_date
                    FROM
                        parameters))
                OR (((
                            SELECT
                                subscription_to_date
                            FROM
                                parameters) IS NULL)
                        OR ((
                                SELECT
                                    subscription_from_date
                                FROM
                                    parameters) IS NULL)))
    AND ((pol.purchase_order_tag LIKE (
                SELECT
                    tags_filter1
                FROM
                    parameters)
                OR pol.purchase_order_tag LIKE (
                    SELECT
                        tags_filter2
                    FROM
                        parameters)
                    OR pol.purchase_order_tag LIKE (
                        SELECT
                            tags_filter3
                        FROM
                            parameters))
                    OR ((
                            SELECT
                                tags_filter1
                            FROM
                                parameters) = ''
                            AND (
                                SELECT
                                    tags_filter2
                                FROM
                                    parameters) = ''
                                AND (
                                    SELECT
                                        tags_filter3
                                    FROM
                                        parameters) = ''))
-- aggregation by data elements below
GROUP BY
    po_line_number,
    po_order_type,
    purchase_order_description,
    po_acquisition_unit_name,
    purchase_order_acquisition_method,
    purchase_order_elec_material_type_name,
    purchase_order_phys_material_type_name
;

