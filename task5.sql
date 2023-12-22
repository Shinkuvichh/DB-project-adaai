set search_path = supermarket, public;

insert into cards
values ('79313402511', 'Оливия', 'ysee@y.ru');

select owner_name, owner_email
from cards
where owner_phone = '79313402511';

update cards
set owner_email = 'olivia@y.com'
where owner_phone = '79313402511';

delete
from cards
where owner_phone = '79313402511';


insert into products(product_name, product_price, product_manufacturer)
values ('Хлеб "Белый" 150 гр', 30, 'Хлебзавод 1');

select product_price
from products
where product_name = 'Хлеб "Белый" 150 гр';

update products
set product_price = 40
where product_name = 'Хлеб "Белый" 150 гр';

delete
from products
where product_name = 'Хлеб "Белый" 150 гр';
