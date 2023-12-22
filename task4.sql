insert into shops (shop_address, supervisor_email)
values ('Ул. Менделеева 30/2', '302msvisor@smarket.com'),
       ('Октябрьский проспект 104', '104opsvisor@smarket.com'),
       ('Ул. Комсомольская 15', '15ksvisor@smarket.com'),
       ('Ул. Грибова 22', '22gsvisor@smarket.com'),
       ('Ул. Лопина 13/1', '131lsvisor@smarket.com');

insert into cards (owner_phone, owner_name, owner_email)
values ('79173243420', 'Абелла', 'abella@y.ru'),
       ('79173245515', 'Марко', 'marjoh@zmail.com'),
       ('79593382919', 'Леви', 'levilevi@zmail.com'),
       ('79805406563', 'Cамари', 'samari222@y.com'),
       ('79805406569', 'Марина', 'occs@zmail.com');

insert into warehouses (warehouse_address, supervisor_email)
values ('Ул. Кароба 9', '9kvisor@smarket.com'),
       ('Ул. Лоббака 12', '12lsvisor@smarket.com'),
       ('Ул. Могилова 7', '7msvisor@smarket.com'),
       ('Ул. Дружбы народов 28/2', '282dnsvisor@smarket.com'),
       ('Ул. Дружболюбова 11', '11dsvisor@smarket.com');

insert into suppliers (supplier_name, supplier_email)
values ('Вкусочка', 'vkochkasupplies@zmail.com'),
       ('Хрючфудс', 'hrychcommers@zmail.com'),
       ('Сойфудс', 'supplies@soyfoods.com'),
       ('Texproducts', 'texdress@y.ru'),
       ('Калофудс', 'kalofoods@y.ru');

insert into products (product_name, product_price, product_manufacturer)
values ('Напиток Ватт 0.45 л жб', 80, 'АБ Инбев'),
       ('Продукт мясосодержащий "гойслоп мясной" 200 гр', 139, 'Эпикфудз'),
       ('Молоко пастеризованное 9% 1.5 л', 70, 'ООО Никтек'),
       ('Напиток Пепс 2л', 100, 'АБ Инбев'),
       ('Продукт сыросодержащий "Маспо" 99% 300 гр', 89, 'ООО Никтек');



insert into supplies_wareh(warehouse_id, supplier_id, supply_date)
values (3, 1, '2023-11-13'),
       (4, 2, '2023-12-20'),
       (4, 4, '2023-12-19'),
       (4, 5, '2023-11-10'),
       (1, 1, '2023-12-15');

insert into supplies_shop(warehouse_id, shop_id, supply_date)
values (4, 1, '2023-12-21'),
       (4, 2, '2023-12-20'),
       (1, 3, '2023-12-16'),
       (3, 5, '2023-11-15'),
       (1, 4, '2023-12-15');

insert into prods_supply_wareh (supply_wareh_id, product_id, product_quantity)
values (1, 1, 100),
       (1, 2, 50),
       (2, 4, 30),
       (2, 5, 70),
       (4, 3, 120),
       (4, 1, 100),
       (5, 3, 50),
       (5, 2, 50),
       (5, 1, 50),
       (3, 2, 50),
       (3, 1, 30);

insert into prods_supply_shop (supply_shop_id, product_id, product_quantity)
values (4, 1, 30),
       (4, 2, 30),
       (1, 1, 20),
       (1, 3, 20),
       (2, 3, 10),
       (2, 5, 50),
       (3, 3, 25),
       (3, 2, 25),
       (5, 3, 25),
       (5, 2, 25);

insert into purchases (card_phone, shop_id, purchase_date)
values ('79173243420', 1, '2023-12-23'),
       ('79173243420', 1, '2023-12-24'),
       ('79173245515', 2, '2023-12-24'),
       ('79593382919', 3, '2023-12-24'),
       ('79805406563', 2, '2023-12-23'),
       (NULL, 5, '2023-12-25');

insert into prods_purchase (purchase_id, product_id, product_quantity)
values (1, 1, 2),
       (2, 3, 1),
       (3, 3, 4),
       (4, 2, 4),
       (5, 5, 2),
       (6, 1, 2);

insert into cards_versions (owner_phone, owner_name, owner_email, change_date)
values ('79173243420', 'Абела', 'abella@y.ru', '2023-12-20'),
       ('79805406563', 'Cамари', 'samari148@y.com', '2023-12-17');


insert into prods_wareh
select INCOME.warehouse_id,
       INCOME.product_id,
       sum(INCOME.summ - coalesce(OUTCOME.summ, 0))
from ((select A.warehouse_id, B.product_id, sum(B.product_quantity) as summ
       from supplies_wareh as A
                join prods_supply_wareh as B
                     on A.supply_wareh_id = B.supply_wareh_id
       group by A.warehouse_id, B.product_id) as INCOME
    left join (select D.warehouse_id, E.product_id, sum(E.product_quantity) as summ
               from supplies_shop as D
                        join prods_supply_shop as E
                             on D.supply_shop_id = E.supply_shop_id
               group by D.warehouse_id, E.product_id) as OUTCOME
      on INCOME.warehouse_id = OUTCOME.warehouse_id and
         INCOME.product_id = OUTCOME.product_id)
group by INCOME.warehouse_id, INCOME.product_id
order by warehouse_id;

insert into prods_shop
select INCOME.shop_id, INCOME.product_id, sum(INCOME.summ - coalesce(OUTCOME.summ, 0))
from ((select A.shop_id, B.product_id, sum(B.product_quantity) as summ
       from supplies_shop as A
                join prods_supply_shop as B on A.supply_shop_id = B.supply_shop_id
       group by A.shop_id, B.product_id) as INCOME
    left join (select D.shop_id, E.product_id, sum(E.product_quantity) as summ
               from purchases as D
                        join prods_purchase E on D.purchase_id = E.purchase_id
               group by D.shop_id, E.product_id) as OUTCOME
      on INCOME.shop_id = OUTCOME.shop_id and INCOME.product_id = OUTCOME.product_id)
group by INCOME.shop_id, INCOME.product_id
order by shop_id;



