create schema if not exists supermarket;
set search_path = supermarket, public;

drop table if exists products cascade;
create table products
(
    product_id           serial primary key,
    product_name         varchar(50) not null,
    product_price        integer     not null check (product_price > 0),
    product_manufacturer varchar(50) not null
);
drop table if exists warehouses cascade;
create table warehouses
(
    warehouse_id      serial primary key,
    warehouse_address varchar(50) not null,
    supervisor_email  varchar(50) not null
);
drop table if exists shops cascade;
create table shops
(
    shop_id          serial primary key,
    shop_address     varchar(50) not null,
    supervisor_email varchar(50) not null
);

drop table if exists suppliers cascade;
create table suppliers
(
    supplier_id    serial primary key,
    supplier_name  varchar(50) not null,
    supplier_email varchar(50) not null
);
drop table if exists cards cascade;
create table cards
(
    owner_phone varchar(11) primary key,
    owner_name  varchar(50) not null,
    owner_email varchar(50) not null

);

drop table if exists purchases cascade;
create table purchases
(
    purchase_id   serial primary key,
    card_phone    varchar(11),
    shop_id       integer not null,
    purchase_date date    not null,
    foreign key (card_phone) references cards (owner_phone),
    foreign key (shop_id) references shops (shop_id)
);

drop table if exists supplies_wareh cascade;
create table supplies_wareh
(
    supply_wareh_id serial primary key,
    warehouse_id    integer not null,
    supplier_id     integer not null,
    supply_date     date    not null,
    foreign key (warehouse_id) references warehouses (warehouse_id),
    foreign key (supplier_id) references suppliers (supplier_id)
);

drop table if exists supplies_shop cascade;
create table supplies_shop
(
    supply_shop_id serial primary key,
    warehouse_id   integer not null,
    shop_id        integer not null,
    supply_date    date    not null,
    foreign key (warehouse_id) references warehouses (warehouse_id),
    foreign key (shop_id) references shops (shop_id)
);



drop table if exists prods_wareh cascade;
create table prods_wareh
(
    warehouse_id     integer,
    product_id       integer not null,
    product_quantity integer not null check (product_quantity > -1),
    foreign key (product_id) references products (product_id),
    foreign key (warehouse_id) references warehouses (warehouse_id),
    primary key (warehouse_id, product_id)
);

drop table if exists prods_supply_wareh cascade;
create table prods_supply_wareh
(
    supply_wareh_id  integer,
    product_id       integer not null,
    product_quantity integer not null check (product_quantity > 0),
    foreign key (product_id) references products (product_id),
    foreign key (supply_wareh_id) references supplies_wareh (supply_wareh_id),
    primary key (supply_wareh_id, product_id)
);

drop table if exists prods_supply_shop cascade;
create table prods_supply_shop
(
    supply_shop_id   integer,
    product_id       integer not null,
    product_quantity integer not null check (product_quantity > 0),
    foreign key (product_id) references products (product_id),
    foreign key (supply_shop_id) references supplies_shop (supply_shop_id),
    primary key (supply_shop_id, product_id)
);


drop table if exists prods_shop cascade;
create table prods_shop
(
    shop_id          integer ,
    product_id       integer not null,
    product_quantity integer not null check (product_quantity > -1),
    foreign key (product_id) references products (product_id),
    foreign key (shop_id) references shops (shop_id),
    primary key (shop_id, product_id)
);
drop table if exists prods_purchase cascade;
create table prods_purchase
(
    purchase_id      integer,
    product_id       integer not null,
    product_quantity integer not null check (product_quantity > 0),
    foreign key (purchase_id) references purchases (purchase_id),
    foreign key (product_id) references products (product_id),
    primary key (purchase_id, product_id)

);

drop table if exists cards_versions cascade;
create table cards_versions
(
    owner_phone varchar(11) not null,
    owner_name  varchar(50) not null,
    owner_email varchar(50) not null,
    change_date timestamp(0),
    foreign key (owner_phone) references cards (owner_phone),
    primary key (owner_phone, change_date)
);
