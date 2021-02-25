SELECT
    count(oclc.instances_id)
FROM
    inventory_instances AS ins
LEFT JOIN
    inventory_holdings AS hol ON ins.id = hol.instance_id
LEFT JOIN
    inventory_items AS itm ON hol.id = itm.holdings_record_id
left JOIN
    inventory_instance_types AS instyp ON ins.instance_type_id = instyp.id
LEFT JOIN
    inventory_instance_statuses AS insstat ON ins.status_id = insstat.id
LEFT JOIN
    inventory_modes_of_issuance AS modi ON ins.mode_Of_Issuance_ID = modi.id
LEFT JOIN
    local.instances_formatids ON ins.id = local.instances_formatids.instances_id
LEFT JOIN
    inventory_instance_formats AS form ON local.instances_formatids.instance_format_id = '"'||form.id||'"'
LEFT JOIN
    local.holdings_statcodeids ON local.holdings_statcodeids.holdings_id = hol.id
LEFT JOIN
    local.items_statcodeids ON local.items_statcodeids.items_id = itm.id
LEFT JOIN
    local.instances_statcodeids ON local.instances_statcodeids.instances_id = ins.id
LEFT JOIN
    inventory_statistical_codes AS inssc ON local.instances_statcodeids.instance_statcode_id = inssc.id
LEFT JOIN
    inventory_statistical_codes AS holsc ON local.holdings_statcodeids.holdings_statcode_id = holsc.id
LEFT JOIN
    inventory_statistical_codes AS itmsc ON local.items_statcodeids.items_statcode_id = itmsc.id
JOIN
    local.instances_identifiers AS oclc ON ins.id = oclc.instances_id
JOIN
    inventory_identifier_types AS idty ON idty.id = oclc.type_id
WHERE
    idty.name = 'OCLC'
    AND
    (instyp.name IN ('text', 'notated music', 'cartographic image') OR
    instyp.code IN ('txt', 'ntm', 'cri'))
    AND
    insstat.name IN ('Cataloging complete', 'East Asia Cataloging complete', 'East Asia recon records', 'OCLC Retrocon records', 'TALX DLL recon', 'Short cataloged', 'Temporary category', 'Batch record load no export permited', 'Table of Contents from BNA')
    AND
   	(modi.name IN ('Monograph', 'Integrating resource') OR modi.name is null)
   	AND
    form.name = 'unmediated -- volume';
