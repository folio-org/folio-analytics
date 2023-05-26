DROP TABLE IF EXISTS feesfines_overdue_fines_policies;

CREATE TABLE feesfines_overdue_fines_policies AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'countClosed')::boolean AS count_closed,
    jsonb_extract_path_text(jsonb, 'description')::varchar(65535) AS description,
    jsonb_extract_path_text(jsonb, 'forgiveOverdueFine')::boolean AS forgive_overdue_fine,
    jsonb_extract_path_text(jsonb, 'gracePeriodRecall')::boolean AS grace_period_recall,
    jsonb_extract_path_text(jsonb, 'maxOverdueFine')::numeric(12,2) AS max_overdue_fine,
    jsonb_extract_path_text(jsonb, 'maxOverdueRecallFine')::numeric(12,2) AS max_overdue_recall_fine,
    jsonb_extract_path_text(jsonb, 'name')::varchar(65535) AS name,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_feesfines.overdue_fine_policy;

