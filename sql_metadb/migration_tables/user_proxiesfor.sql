DROP TABLE IF EXISTS user_proxiesfor;

CREATE TABLE user_proxiesfor AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'accrueTo')::varchar(65535) AS accrue_to,
    jsonb_extract_path_text(jsonb, 'expirationDate')::timestamptz AS expiration_date,
    jsonb_extract_path_text(jsonb, 'notificationsTo')::varchar(65535) AS notifications_to,
    jsonb_extract_path_text(jsonb, 'proxyUserId')::varchar(36) AS proxy_user_id,
    jsonb_extract_path_text(jsonb, 'requestForSponsor')::varchar(65535) AS request_for_sponsor,
    jsonb_extract_path_text(jsonb, 'status')::varchar(65535) AS status,
    jsonb_extract_path_text(jsonb, 'userId')::varchar(36) AS user_id,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_users.proxyfor;

