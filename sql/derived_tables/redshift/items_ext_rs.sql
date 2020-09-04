ALTER TABLE local.items_ext
    ALTER DISTKEY items_id;

ALTER TABLE local.items_ext
    ALTER COMPOUND SORTKEY (items_id);

VACUUM local.items_ext;
ANALYZE local.items_ext;
