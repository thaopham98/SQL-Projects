USE BikeStores;
select *
-- sum(quantity), 
-- count(quantity) 
from sales.order_items where product_id=6;
select * from sales.stores; -- only 3 stores
SELECT * from sales.orders;

-- a. The store that sold the most (orders), aka money
select 
    top 1
    store_id,
    sum(list_price*(1-discount)*quantity) [Total Amount of Order]
from sales.orders o 
join sales.order_items oi 
    on o.order_id=oi.order_id
group by store_id
order by [Total Amount of Order] DESC;
-- the results in this case is store_id = 2

-- b. The total sales, the most popular product and the manager name

-- the most popular product
select 
    top 1
    product_id, 
    sum(quantity) 'quantity' -- using sum() because it adding the value of quantity
from sales.stores s
join sales.orders o 
    on o.store_id=s.store_id
join sales.order_items oi 
    on o.order_id=oi.order_id
where s.store_id=2
group by o.store_id,product_id
order by 'quantity' DESC

-- the manager name by self join 
SELECT DISTINCT Manager.first_name + ' '+ Manager.last_name 'Manager Name'
FROM [sales].[staffs] AS Staff 
JOIN [sales].[staffs] AS Manager 
    ON Staff.manager_id=Manager.[staff_id]


/* combining */
select 
    top 1
    o.store_id,
    product_id, 
    sum(list_price*(1-discount)*quantity) [Total Amount of Order],
    sum(quantity) 'quantity', -- using sum() because it adding the value of quantity
    m.first_name + ' '+ m.last_name 'Manager Name'
from sales.stores s
join sales.orders o 
    on o.store_id=s.store_id
join sales.order_items oi 
    on o.order_id=oi.order_id
JOIN [sales].[staffs] AS e 
    on e.store_id = s.store_id
JOIN [sales].[staffs] AS m 
    ON e.manager_id=m.[staff_id]
where YEAR(o.order_date)='2016'
group by o.store_id,product_id, m.first_name + ' '+ m.last_name
order by [Total Amount of Order] DESC


/* final */
GO
CREATE OR ALTER PROC q3
    @year INT
AS
    Begin
        select 
            top 1
            o.store_id,
            product_id, 
            sum(list_price*(1-discount)*quantity) [Total Amount of Order], -- total sales of all products
            sum(quantity) 'quantity', -- using sum() because it adding the value of quantity
            m.first_name + ' '+ m.last_name 'Manager Name',
            Year(order_date)
        from sales.stores s
        join sales.orders o 
            on o.store_id=s.store_id
        join sales.order_items oi 
            on o.order_id=oi.order_id
        JOIN [sales].[staffs] AS e 
            on e.store_id = s.store_id
        JOIN [sales].[staffs] AS m 
            ON e.manager_id=m.[staff_id]
        where YEAR(o.order_date)=@year
        group by o.store_id,product_id, m.first_name + ' '+ m.last_name, Year(order_date)
        order by [Total Amount of Order] DESC;
    END

EXEC q3 2016;
EXEC q3 2017;
EXEC q3 2018;