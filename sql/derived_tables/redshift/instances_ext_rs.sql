ALTER TABLE local.instances_ext
    ALTER DISTKEY instance_id;

ALTER TABLE local.instances_ext
    ALTER COMPOUND SORTKEY (instance_id);

VACUUM local.instances_ext;
ANALYZE local.instances_ext;
