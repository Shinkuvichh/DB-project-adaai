create view views.sales_statistic as  -- статистика продаж: показывает какие товары когда и где были проданы,
select products.product_id,           -- такая статистика нужна например для того чтобы констатировать факт шоплифтинга
       purchases.shop_id,
       purchases.purchase_date,
       prods_purchase.product_quantity
from purchases
inner join prods_purchase
    on purchases.purchase_id = prods_purchase.purchase_id
inner join products
    on prods_purchase.product_id = products.product_id;
