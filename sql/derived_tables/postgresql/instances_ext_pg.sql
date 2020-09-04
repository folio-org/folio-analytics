CREATE INDEX ON local.instances_ext (instance_id);
CREATE INDEX ON local.instances_ext (cataloged_date);
CREATE INDEX ON local.instances_ext (discovery_suppress);
CREATE INDEX ON local.instances_ext (hrid);
CREATE INDEX ON local.instances_ext (index_title);
CREATE INDEX ON local.instances_ext (instance_type_id);
CREATE INDEX ON local.instances_ext (instance_type_name);
CREATE INDEX ON local.instances_ext (mode_of_issuance_id);
CREATE INDEX ON local.instances_ext (mode_of_issuance_name);
CREATE INDEX ON local.instances_ext (previously_held);
CREATE INDEX ON local.instances_ext (instance_source);
CREATE INDEX ON local.instances_ext (staff_suppress);
CREATE INDEX ON local.instances_ext (status_id);
CREATE INDEX ON local.instances_ext (instance_status_name);
CREATE INDEX ON local.instances_ext (title);

VACUUM local.instances_ext;
ANALYZE local.instances_ext;
