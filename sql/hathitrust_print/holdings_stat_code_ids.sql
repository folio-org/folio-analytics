--create holdings_statcodeIDs
CREATE TABLE local.holdings_statcodeIDs AS
SELECT
    id AS holdings_id,
    json_array_elements(
          json_extract_path(data, 'statisticalCodeIds') ) :: VARCHAR
    AS holdings_statcode_id
FROM inventory_holdings;
-- PostgreSQL-specific
CREATE INDEX ON local.holdings_statcodeIDs (holdings_id);
CREATE INDEX ON local.holdings_statcodeIDs (holdings_statcode_id);
VACUUM local.holdings_statcodeIDs;
ANALYZE local.holdings_statcodeIDs;
