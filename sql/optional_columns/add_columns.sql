ALTER TABLE public.inventory_instance_relationship_types ADD COLUMN name varchar(1);
ALTER TABLE public.po_purchase_orders ADD COLUMN po_number varchar(1);
ALTER TABLE public.po_purchase_orders ADD COLUMN vendor varchar(1);

