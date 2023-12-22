create schema if not exists views;

create or replace view views.products as
select *
from products;

create or replace view views.warehouses as
select warehouses.warehouse_id,
       '******' as masked_warehouse_address,
       warehouses.supervisor_email
from warehouses;

create or replace view views.shops as
select *
from shops;

create or replace view views.suppliers as
select suppliers.supplier_id,
       suppliers.supplier_name,
       overlay(overlay(suppliers.supplier_email placing
                       repeat('*', length(suppliers.supplier_email) - position('@' in suppliers.supplier_email)) from
                       position('@' in suppliers.supplier_email) + 1 for
                       position('.' in suppliers.supplier_email) - position('@' in suppliers.supplier_email) - 1)
               placing
               repeat('*', position('@' in suppliers.supplier_email) - 1) from 1 for
               position('@' in suppliers.supplier_email) - 1) as masked_supplier_email
from suppliers;

create or replace view views.cards as
select cards.owner_phone,
       cards.owner_name,
       overlay(overlay(cards.owner_email placing
                       repeat('*', length(cards.owner_email) - position('@' in cards.owner_email)) from
                       position('@' in cards.owner_email) + 1 for
                       position('.' in cards.owner_email) - position('@' in cards.owner_email) - 1) placing
               repeat('*', position('@' in cards.owner_email) - 1) from 1 for
               position('@' in cards.owner_email) - 1) as masked_owner_email
from cards;

create or replace view views.purchases as
select purchases.purchase_id,
       case
           when purchases.card_phone is not null then overlay(card_phone placing
                                                              repeat('*', length(purchases.card_phone)) from 1)
           else purchases.card_phone end as masked_card_phone,
       purchases.shop_id,
       purchases.purchase_date
from purchases;

create or replace view views.supplies_wareh as
select *
from supplies_wareh;

create or replace view views.supplies_shop as
select *
from supplies_shop;

create or replace view views.prods_wareh as
select *
from prods_wareh;

create or replace view views.prods_supply_wareh as
select *
from prods_supply_wareh;

create or replace view views.prods_supply_shop as
select *
from prods_supply_shop;

create or replace view views.prods_shop as
select *
from prods_shop;

create or replace view views.prods_purchase as
select *
from prods_purchase;

create or replace view views.cards_versions as
select *
from cards_versions;
