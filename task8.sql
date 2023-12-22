-- Статистика продаж: показывает какие товары когда и где было проданы,
-- такая статистика нужна например для того чтобы констатировать факт шоплифтинга
create or replace view views.sales_statistic as
select purchases.shop_id,
       purchases.purchase_date,
       products.product_id,
       sum(prods_purchase.product_quantity) as quantity
from purchases
         inner join prods_purchase
                    on purchases.purchase_id = prods_purchase.purchase_id
         inner join products
                    on prods_purchase.product_id = products.product_id
group by products.product_id, purchases.purchase_date, purchases.shop_id
order by purchases.shop_id, purchases.purchase_date;



-- Представление показывающее сумму покупок за текущий месяц в каждом магазине с картой и без, такое представление нужно
-- например для того чтобы было понимание, какая из точек нуждается в продвижении, а также на сотрудников какой
-- точки стоит наложить санкции за низкое количество покупок с картой лояльности
create or replace view views.shop_spending as
select s.shop_id,
       s.supervisor_email,
       coalesce(sum(pp.product_quantity * pr.product_price), 0) as total_spending_all,
       coalesce(sum(case when c.owner_phone is not null then pp.product_quantity * pr.product_price else 0 end),
                0)                                              as total_spending_with_card
from shops s
         left join purchases p
                   on s.shop_id = p.shop_id and extract(month from p.purchase_date) = extract(month from current_date)
         inner join prods_purchase pp
                    on p.purchase_id = pp.purchase_id
         inner join products pr
                    on pp.product_id = pr.product_id
         left join cards c
                   on p.card_phone = c.owner_phone
group by s.shop_id, s.supervisor_email
order by s.shop_id;



-- Сводка товаров с низким запасом на складе, нужна чтобы понимать что нужно заказывать у оптовиков
create or replace view views.low_stock as
select w.warehouse_id,
       pw.product_id,
       pw.product_quantity as stock,
       w.supervisor_email
from warehouses w
         inner join prods_wareh pw
                    on w.warehouse_id = pw.warehouse_id
         inner join products p
                    on pw.product_id = p.product_id
where pw.product_quantity < 50
order by w.warehouse_id
