set search_path = supermarket, public;

create function edit_stock_wareh()
    returns void as
$$
declare
    deltas        record;
    declare delta record;
begin
    insert into deltas
    select INCOME.warehouse_id,
           INCOME.product_id,
           sum(INCOME.summ - coalesce(OUTCOME.summ, 0)) as delta
    from ((select A.warehouse_id, B.product_id, sum(B.product_quantity) as summ
           from supermarket.supplies_wareh as A
                    join supermarket.prods_supply_wareh as B
                         on A.supply_wareh_id = B.supply_wareh_id
           where supply_date = current_date
           group by A.warehouse_id, B.product_id) as INCOME
        left join (select D.warehouse_id, E.product_id, sum(E.product_quantity) as summ
                   from supermarket.supplies_shop as D
                            join supermarket.prods_supply_shop as E
                                 on D.supply_shop_id = E.supply_shop_id
                   where supply_date = current_date
                   group by D.warehouse_id, E.product_id) as OUTCOME
          on INCOME.warehouse_id = OUTCOME.warehouse_id and
             INCOME.product_id = OUTCOME.product_id)
    group by INCOME.warehouse_id, INCOME.product_id
    order by warehouse_id;

    update supermarket.prods_wareh as A
    set product_quantity = product_quantity + (select delta
                                               from deltas
                                               where deltas.warehouse_id = A.warehouse_id
                                                 and deltas.product_id = A.product_id);

end;
$$ language plpgsql;