DROP TABLE IF EXISTS email_email;

CREATE TABLE email_email AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'body')::varchar(65535) AS body,
    jsonb_extract_path_text(jsonb, 'date')::timestamptz AS date,
    jsonb_extract_path_text(jsonb, 'deliveryChannel')::varchar(65535) AS delivery_channel,
    jsonb_extract_path_text(jsonb, 'from')::varchar(65535) AS from,
    jsonb_extract_path_text(jsonb, 'header')::varchar(65535) AS header,
    jsonb_extract_path_text(jsonb, 'message')::varchar(65535) AS message,
    jsonb_extract_path_text(jsonb, 'notificationId')::varchar(36) AS notification_id,
    jsonb_extract_path_text(jsonb, 'outputFormat')::varchar(65535) AS output_format,
    jsonb_extract_path_text(jsonb, 'status')::varchar(65535) AS status,
    jsonb_extract_path_text(jsonb, 'to')::varchar(65535) AS to,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_email.email_statistics;

ALTER TABLE email_email ADD PRIMARY KEY (id);

CREATE INDEX ON email_email (body);

CREATE INDEX ON email_email (date);

CREATE INDEX ON email_email (delivery_channel);

CREATE INDEX ON email_email ("from");

CREATE INDEX ON email_email (header);

CREATE INDEX ON email_email (message);

CREATE INDEX ON email_email (notification_id);

CREATE INDEX ON email_email (output_format);

CREATE INDEX ON email_email (status);

CREATE INDEX ON email_email ("to");

