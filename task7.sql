create or replace view views.products as
select products.product_name,
       products.product_price,
       products.product_manufacturer
from products;

create or replace view views.warehouses as
select '******' as masked_warehouse_address,
       warehouses.supervisor_email
from warehouses;

create or replace view views.shops as
select shops.shop_address,
       shops.supervisor_email
from shops;

create or replace view views.suppliers as
select suppliers.supplier_name,
       overlay(overlay(suppliers.supplier_email placing
                       repeat('*', length(suppliers.supplier_email) - position('@' in suppliers.supplier_email)) from
                       position('@' in suppliers.supplier_email) + 1 for
                       position('.' in suppliers.supplier_email) - position('@' in suppliers.supplier_email) - 1)
               placing
               repeat('*', position('@' in suppliers.supplier_email) - 1) from 1 for
               position('@' in suppliers.supplier_email) - 1) as masked_supplier_email
from suppliers;

create or replace view views.cards as
select overlay(owner_phone placing
               repeat('*', length(cards.owner_phone) - 3) from 2) as masked_owner_phone,
       cards.owner_name,
       overlay(overlay(cards.owner_email placing
                       repeat('*', length(cards.owner_email) - position('@' in cards.owner_email)) from
                       position('@' in cards.owner_email) + 1 for
                       position('.' in cards.owner_email) - position('@' in cards.owner_email) - 1) placing
               repeat('*', position('@' in cards.owner_email) - 1) from 1 for
               position('@' in cards.owner_email) - 1)            as masked_owner_email
from cards;

create or replace view views.purchases as
select case
           when purchases.card_phone is not null then overlay(card_phone placing
                                                              repeat('*', length(purchases.card_phone) - 3) from 2)
           else purchases.card_phone end as masked_card_phone,
       purchases.shop_id,
       purchases.purchase_date
from purchases;

create or replace view views.supplies_wareh as
select supplies_wareh.warehouse_id,
       supplies_wareh.supplier_id,
       supplies_wareh.supply_date
from supplies_wareh;

create or replace view views.supplies_shop as
select supplies_shop.warehouse_id,
       supplies_shop.shop_id,
       supplies_shop.supply_date
from supplies_shop;

create or replace view views.prods_wareh as
select prods_wareh.product_quantity
from prods_wareh;

create or replace view views.prods_supply_wareh as
select prods_supply_wareh.product_quantity
from prods_supply_wareh;

create or replace view views.prods_supply_shop as
select prods_supply_shop.product_quantity
from prods_supply_shop;

create or replace view views.prods_shop as
select prods_shop.product_quantity
from prods_shop;

create or replace view views.prods_purchase as
select prods_purchase.product_quantity
from prods_purchase;

create or replace view views.cards_versions as
select cards_versions.owner_name,
       overlay(overlay(cards_versions.owner_email placing
                       repeat('*', length(cards_versions.owner_email) - position('@' in cards_versions.owner_email))
                       from
                       position('@' in cards_versions.owner_email) + 1 for
                       position('.' in cards_versions.owner_email) - position('@' in cards_versions.owner_email) - 1)
               placing
               repeat('*', position('@' in cards_versions.owner_email) - 1) from 1 for
               position('@' in cards_versions.owner_email) - 1) as masked_owner_email
from cards_versions;
