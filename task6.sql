set search_path = supermarket, public;

/* По номеру телефона 79173243420 найдем сумму, потраченную обладателем карты (Абелла) в нашем супермаркете. */
select sum(D.priceXquantity)
from (select sum(product_price * product_quantity) as priceXquantity
      from (select purchase_id from supermarket.purchases where card_phone = '79173243420') as A
               join supermarket.prods_purchase as B on A.purchase_id = B.purchase_id
               join supermarket.products as C on B.product_id = C.product_id
      group by B.product_id) as D;

/* Найдем выручку за последний месяц всех наших супермаркетов. */

select total.shop_id, sum(total.summ) from (select A.shop_id, sum(C.product_quantity* D.product_price) as summ from
                   supermarket.shops as A left join supermarket.purchases as B on A.shop_id = B.shop_id
                   join supermarket.prods_purchase as C on B.purchase_id = C.purchase_id and B.purchase_date >= date_trunc('month', current_date)::date
                   join supermarket.products as D on C.product_id = D.product_id group by A.shop_id, C.product_id) as total group by total.shop_id;


/* Пересчитаем количество товаров в магазинах, учтя новые (сегодняшние) поставки и продажи. */

/* Пересчитаем количество товаров на складах, учтя новые (сегодняшние) поставки и отгрузки в супермаркеты. */

/* Найдем общее количество товаров на всех складах */






