set search_path = supermarket, public;

create or replace function after_purchase_edit_stock() returns trigger as
$$
begin

    update supermarket.prods_shop
    set product_quantity = product_quantity - new.product_quantity
    where product_id = new.product_id
      and shop_id = (select shop_id from supermarket.purchases where supermarket.purchases.purchase_id = new.purchase_id);
    return new;
end;
$$ language plpgsql;

create trigger after_purchase_stock_editor
    after insert
    on supermarket.prods_purchase
    for each row
execute procedure after_purchase_edit_stock();


create or replace function after_edit_stock_check_wareh() returns trigger as
$$
declare
    wh record;
begin
    if new.product_quantity = 0 then
        raise notice 'Товар с product_id % закончился.', new.product_id;
        for wh in select supermarket.warehouses.warehouse_id, supermarket.warehouses.supervisor_email
                  from supermarket.prods_wareh
                           join supermarket.warehouses
                                on supermarket.warehouses.warehouse_id = supermarket.prods_wareh.warehouse_id
                  where new.product_id = supermarket.prods_wareh.product_id
                    and coalesce(supermarket.prods_wareh.product_quantity, 0) > 0
            loop
                raise notice 'Товар есть на складе с id %, почта супервайзера: %', wh.warehouse_id, wh.supervisor_email;
            end loop;
    end if;
    return new;
end;
$$ language plpgsql;

create or replace trigger after_purchase_stock_editor
    after update
    on supermarket.prods_shop
    for each row
execute procedure after_edit_stock_check_wareh();
