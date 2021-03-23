with isbns as (
select
	ii.instance_id as instance_id,
	ii.instance_hrid as instance_hrid,
	ii.identifier_type_name as identifier_type_name,
	ii.identifier as identifier
from
	folio_reporting.instance_identifiers as ii
where
	ii.identifier_type_name in ('ISBN', 'Invalid ISBN')
)
select 
 	ie.instance_id as po_instance_id, 
	ie.instance_hrid as po_instance_hrid,
	isbns.instance_hrid as duplicate_instance_hrid,
	isbns.identifier_type_name as duplicate_identifier_type,
	isbns.identifier as duplicate_identifier
from
	folio_reporting.instance_ext as ie
join 
	folio_reporting.instance_identifiers as ii1 on ie.instance_id = ii1.instance_id 
left join 
	isbns on ii1.identifier = isbns.identifier
where 
	ii1.instance_id != isbns.instance_id	
	and ii1.identifier_type_name in ('ISBN', 'Invalid ISBN');
