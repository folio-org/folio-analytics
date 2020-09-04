CREATE INDEX ON local.instance_formats (instance_id);
CREATE INDEX ON local.instance_formats (instance_hrid);
CREATE INDEX ON local.instance_formats (instance_format_id);
CREATE INDEX ON local.instance_formats (format_code);
CREATE INDEX ON local.instance_formats (format_name);
CREATE INDEX ON local.instance_formats (format_source);

VACUUM local.instance_formats;
ANALYZE local.instance_formats;
