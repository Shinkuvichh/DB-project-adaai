set search_path = supermarket, public;

create or replace function after_purchase_edit_stock() returns trigger as
$$
begin

    update supermarket.prods_shop
    set product_quantity = product_quantity - new.product_quantity
    where product_id = new.product_id
      and shop_id = (select shop_id from supermarket.purchases where purchases.purchase_id = new.purchase_id);
    return new;
end;
$$ language plpgsql;

create trigger after_purchase_stock_editor
    after insert
    on supermarket.prods_purchase
    for each row
execute procedure after_purchase_edit_stock();