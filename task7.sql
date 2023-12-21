create schema if not exists views;

create view views.products as
    select *
    from products;

create view views.warehouses as
    select *
    from warehouses;

create view views.shops as
    select *
    from shops;

create view views.suppliers as
    select *
    from suppliers;

create view views.cards as
    select *
    from cards;

create view views.purchases as
    select *
    from purchases;

create view views.supplies_wareh as
    select *
    from supplies_wareh;

create view views.supplies_shop as
    select *
    from supplies_shop;

create view views.prods_wareh as
    select *
    from prods_wareh;

create view views.prods_supply_wareh as
    select *
    from prods_supply_wareh;

create view views.prods_supply_shop as
    select *
    from prods_supply_shop;

create view views.prods_shop as
    select *
    from prods_shop;

create view views.prods_purchase as
    select *
    from prods_purchase;

create view views.cards_versions as
    select *
    from cards_versions;
