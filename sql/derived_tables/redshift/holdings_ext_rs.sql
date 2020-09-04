ALTER TABLE local.holdings_ext
    ALTER DISTKEY holdings_id;

ALTER TABLE local.holdings_ext
    ALTER COMPOUND SORTKEY (holdings_id);

VACUUM local.holdings_ext;
ANALYZE local.holdings_ext;
