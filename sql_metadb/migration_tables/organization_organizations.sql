DROP TABLE IF EXISTS organization_organizations;

CREATE TABLE organization_organizations AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'accessProvider')::boolean AS access_provider,
    jsonb_extract_path_text(jsonb, 'claimingInterval')::bigint AS claiming_interval,
    jsonb_extract_path_text(jsonb, 'code')::varchar(65535) AS code,
    jsonb_extract_path_text(jsonb, 'description')::varchar(65535) AS description,
    jsonb_extract_path_text(jsonb, 'discountPercent')::numeric(12,2) AS discount_percent,
    jsonb_extract_path_text(jsonb, 'erpCode')::varchar(65535) AS erp_code,
    jsonb_extract_path_text(jsonb, 'expectedActivationInterval')::bigint AS expected_activation_interval,
    jsonb_extract_path_text(jsonb, 'expectedInvoiceInterval')::bigint AS expected_invoice_interval,
    jsonb_extract_path_text(jsonb, 'expectedReceiptInterval')::bigint AS expected_receipt_interval,
    jsonb_extract_path_text(jsonb, 'exportToAccounting')::boolean AS export_to_accounting,
    jsonb_extract_path_text(jsonb, 'governmental')::boolean AS governmental,
    jsonb_extract_path_text(jsonb, 'isVendor')::boolean AS is_vendor,
    jsonb_extract_path_text(jsonb, 'language')::varchar(65535) AS language,
    jsonb_extract_path_text(jsonb, 'liableForVat')::boolean AS liable_for_vat,
    jsonb_extract_path_text(jsonb, 'licensor')::boolean AS licensor,
    jsonb_extract_path_text(jsonb, 'materialSupplier')::boolean AS material_supplier,
    jsonb_extract_path_text(jsonb, 'name')::varchar(65535) AS name,
    jsonb_extract_path_text(jsonb, 'paymentMethod')::varchar(65535) AS payment_method,
    jsonb_extract_path_text(jsonb, 'renewalActivationInterval')::bigint AS renewal_activation_interval,
    jsonb_extract_path_text(jsonb, 'sanCode')::varchar(65535) AS san_code,
    jsonb_extract_path_text(jsonb, 'status')::varchar(65535) AS status,
    jsonb_extract_path_text(jsonb, 'subscriptionInterval')::bigint AS subscription_interval,
    jsonb_extract_path_text(jsonb, 'taxId')::varchar(65535) AS tax_id,
    jsonb_extract_path_text(jsonb, 'taxPercentage')::numeric(12,2) AS tax_percentage,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_organizations.organizations;

ALTER TABLE organization_organizations ADD PRIMARY KEY (id);

CREATE INDEX ON organization_organizations (access_provider);

CREATE INDEX ON organization_organizations (claiming_interval);

CREATE INDEX ON organization_organizations (code);

CREATE INDEX ON organization_organizations (description);

CREATE INDEX ON organization_organizations (discount_percent);

CREATE INDEX ON organization_organizations (erp_code);

CREATE INDEX ON organization_organizations (expected_activation_interval);

CREATE INDEX ON organization_organizations (expected_invoice_interval);

CREATE INDEX ON organization_organizations (expected_receipt_interval);

CREATE INDEX ON organization_organizations (export_to_accounting);

CREATE INDEX ON organization_organizations (governmental);

CREATE INDEX ON organization_organizations (is_vendor);

CREATE INDEX ON organization_organizations (language);

CREATE INDEX ON organization_organizations (liable_for_vat);

CREATE INDEX ON organization_organizations (licensor);

CREATE INDEX ON organization_organizations (material_supplier);

CREATE INDEX ON organization_organizations (name);

CREATE INDEX ON organization_organizations (payment_method);

CREATE INDEX ON organization_organizations (renewal_activation_interval);

CREATE INDEX ON organization_organizations (san_code);

CREATE INDEX ON organization_organizations (status);

CREATE INDEX ON organization_organizations (subscription_interval);

CREATE INDEX ON organization_organizations (tax_id);

CREATE INDEX ON organization_organizations (tax_percentage);

