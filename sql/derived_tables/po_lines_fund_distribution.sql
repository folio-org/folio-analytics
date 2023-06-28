-- po_lines_fund_distribution extracts arrays of fund distributions
-- from the public.po_lines table.

DROP TABLE IF EXISTS po_lines_fund_distribution;

CREATE TABLE po_lines_fund_distribution AS
SELECT p.id AS po_lines_id,
       f.data #>> '{code}' AS code,
       f.data #>> '{distributionType}' AS distribution_type,
       (f.data #>> '{encumbrance}')::uuid AS encumbrance,
       (f.data #>> '{expenseClassId}')::uuid AS expense_class_id,
       (f.data #>> '{fundId}')::uuid AS fund_id,
       (f.data #>> '{value}')::numeric AS value,
       f.ordinality
    FROM public.po_lines AS p
        CROSS JOIN LATERAL jsonb_array_elements((data #> '{fundDistribution}')::jsonb) WITH ORDINALITY
            AS f (data);
