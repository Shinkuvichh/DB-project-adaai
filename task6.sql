set search_path = supermarket, public;

/* По номеру телефона 79173243420 найдем сумму, потраченную обладателем карты (Абелла) в нашем супермаркете. */
select sum(D.priceXquantity)
from (select sum(product_price * product_quantity) as priceXquantity
      from (select purchase_id from supermarket.purchases where card_phone = '79173243420') as A
               join supermarket.prods_purchase as B on A.purchase_id = B.purchase_id
               join supermarket.products as C on B.product_id = C.product_id
      group by B.product_id) as D;


/* Найдем выручку за последний месяц всех наших супермаркетов. */
select total.shop_id, sum(total.summ)
from (select A.shop_id, sum(C.product_quantity * D.product_price) as summ
      from supermarket.shops as A
               left join supermarket.purchases as B on A.shop_id = B.shop_id
               join supermarket.prods_purchase as C
                    on B.purchase_id = C.purchase_id and B.purchase_date >= date_trunc('month', current_date)::date
               join supermarket.products as D on C.product_id = D.product_id
      group by A.shop_id, C.product_id) as total
group by total.shop_id;


/* Найдем любимые магазины всех пользователей наших супермаркетов, найдем кол-во покупок в любимом и кол-во покупок всего. */
select rates.owner_phone,
       rates.shop_id        as favourite_shop,
       rates.shop_purchases as favorite_shop_purchases,
       rates.total_purchases
from (select A.owner_phone,
             B.shop_id,
             count(*)                                                         as shop_purchases,
             sum(count(*)) over (partition by A.owner_phone)                  as total_purchases,
             rank() over ( partition by A.owner_phone order by count(*) desc) as shop_rank
      from supermarket.cards as A
               join supermarket.purchases as B on A.owner_phone = B.card_phone
      group by A.owner_phone, B.shop_id) as rates
where shop_rank = 1;


/* Найдем в магазинах средний чек за 2023-12-24 */
select supermarket.shops.shop_id,
       avg(supermarket.products.product_price * supermarket.prods_purchase.product_quantity) as average_receipt
from supermarket.shops
         join supermarket.purchases
              on shops.shop_id = purchases.shop_id
         join supermarket.prods_purchase
              on purchases.purchase_id = prods_purchase.purchase_id
         join supermarket.products
              on supermarket.prods_purchase.product_id = products.product_id
where purchases.purchase_date = '2023-12-24'
group by shops.shop_id;


/* Найдем для каждого товара магазин, где его больше всего покупают */
select D.product_id, D.shop_id as best_shop, D.purchsum as sold
from (select A.product_id,
             C.shop_id,
             sum(product_quantity)                                                        as purchsum,
             rank() over ( partition by A.product_id order by sum(product_quantity) desc) as rank
      from supermarket.products as A
               join supermarket.prods_purchase as B on A.product_id = B.product_id
               join supermarket.purchases as C on B.purchase_id = C.purchase_id
      group by A.product_id, C.shop_id) as D
where rank = 1;
