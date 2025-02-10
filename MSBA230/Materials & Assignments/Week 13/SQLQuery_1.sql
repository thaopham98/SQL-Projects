USE BikeStores;
SELECT * FROM [sales].[staffs];
SELECT * FROM [sales].[stores];
/* 
Q5:
Create a function that when passed a store_id returns the name of all managers. a. Use the
function in a SELECT query to return all the stores and the number of mangers in each store.
 */
GO
DROP FUNCTION IF EXISTS q5;

GO
CREATE OR ALTER FUNCTION q5(@storeID int)
RETURNS TABLE 
AS
    RETURN 
    (
        SELECT 
            -- * 
            m.staff_id,
            m.manager_id,
            m.first_name + ' ' + m.last_name [Full Name], 
            m.store_id
        FROM sales.staffs m 
        JOIN sales.staffs s 
        ON s.manager_id  = m.staff_id -- ???? why NOT s.staff_id=m.manager_id https://www.geeksforgeeks.org/sql-self-join/#:~:text=Step%203%3A%20Explanation%20and%20implementation%20of%20Self%20Join
        -- WHERE m.store_id=@storeID
    )
GO

SELECT DISTINCT * from dbo.q5(1); -- !!! NOT COMPLETE, finish later

/* 
Q2:
Create a stored procedure that when passed a state returns the store, list of employees and
the name of the manager. Ino store in that state, print a message. 
*/

GO;
-- CREATE OR ALTER PROC q2
--     @state VARCHAR
-- AS 
    
SELECT * FROM [sales].[stores];

select 
    s.[store_id], 
    [store_name], 
    e.first_name + ' ' + e.last_name StaffName, 
    m.first_name +' '+m.last_name Manager

from [sales].[stores] s
JOIN [sales].[staffs] e
    ON s.store_id = e.store_id
JOIN sales.staffs m 
    ON e.manager_id  = m.staff_id
WHERE [state]='CA'

/*
Q3:

First write a query to list the years that we have orders for. Then create a stored procedure
that when passed a year and returns the following information:
a. The store that sold the most (orders). And the following information for that store:
b. The total sales, the most popular product and the manager name

*/
select top 5 * from [sales].[orders];
select top 5 * from [sales].[order_items];
select * from sales.staffs;
select distinct year(order_date) from sales.orders;

-- /* Cost per Item in an order */
-- select 
--     order_id, 
--     item_id,
--     list_price*(1-discount)*quantity [Cost per Item]
-- from sales.order_items 
-- where order_id=1;

-- /* Total Cost per Order */
-- select 
--     order_id, 
--     sum(list_price*(1-discount)*quantity) [Total Cost per Order]
-- from sales.order_items 
-- where order_id=1
-- group by order_id;

-- select distinct YEAR(order_date) YEAR from sales.orders; 

-- The store that sold the MOST (orders), AKA 1 store that sales the most (money)
select 
    -- TOP 1 
    o.store_id, -- getting the top 1 store
    sum(list_price*(1-discount)*quantity) 'Total Amount of Orders' -- sum/total amount (money)
from [sales].[order_items] oi
join sales.orders o on o.order_id=oi.order_id
WHERE YEAR(o.order_date)='2016'
group by o.store_id 
order by sum(list_price*(1-discount)*quantity) desc -- highest to lowest

-- following information for that store: 

-- the manager name -- self join 
SELECT 
    -- *
    e.staff_id 'e.staff_id', -- the id of the staff themself
    e.first_name + ' ' + e.last_name 'Employee Names',
    m.staff_id 'm.staff_id',  -- the id of the managers
    m.manager_id 'm.manager_id', -- the id of the manager's managers (if applicable)
    m.first_name + ' ' + m.last_name 'Manager Names'
FROM sales.staffs e 
JOIN sales.staffs m 
    ON e.manager_id = m.staff_id


select 
    top 1
    product_id,-- the most popular product
    count(quantity) [Total Quantity],
    sum(list_price*(1-discount)*quantity)[Total Sales] -- total sales
from [sales].[order_items]
group by product_id
order by 
    [Total Quantity] 
    -- [Total Sales]
    desc;

/* combining the 2 queries */
select 
    top 1
    product_id, -- the product id
    count(quantity) [Total Quantity], -- the most popular product
    sum(list_price*(1-discount)*quantity)[Total Sales] -- total sales
from [sales].[order_items]

group by product_id
order by 
    [Total Quantity] 
    -- [Total Sales]
    desc;
;

select 

/*   CREATE SP   */
go;

drop procedure if exists q3;

GO

-- CREATE OR ALTER PROC q3
--     @ year INT 
-- AS 
--     (
--         select 
--             -- TOP 1 
--             o.store_id, -- getting the top 1 store
--             -- the most popular product
--             sum(list_price*(1-discount)*quantity) 'Total Amount of Orders', -- sum/total amount (money)
--             m.first_name + ' ' + m.last_name 'Manager Names'
--         from [sales].[order_items] oi
--         join sales.orders o on o.order_id=oi.order_id
--         join sales.staffs e
--             on o.staff_id = e.staff_id
--         join sales.staffs m 
--             on m.staff_id = e.manager_id
--         WHERE YEAR(o.order_date)='2016'
--         group by o.store_id , m.first_name, m.last_name
--         order by sum(list_price*(1-discount)*quantity) desc -- highest to lowest
--     )
GO

CREATE OR ALTER PROCEDURE q3
    @Year INT
AS
BEGIN
    -- Find the store with the highest total sales for the given year
    DECLARE @TopStoreID INT;
    SELECT TOP 1 @TopStoreID = o.store_id
    FROM sales.orders o
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    WHERE YEAR(o.order_date) = @Year
    GROUP BY o.store_id
    ORDER BY SUM(oi.list_price * (1 - oi.discount) * oi.quantity) DESC;

    -- Get the total sales, most popular product, and manager name for the top store
    SELECT 
        TOP 1 oi.product_id AS MostPopularProduct,
        s.store_name,
        SUM(oi.list_price * (1 - oi.discount) * oi.quantity) AS TotalSales,
        m.first_name + ' ' + m.last_name AS ManagerName
    FROM sales.orders o
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    JOIN sales.stores s ON o.store_id = s.store_id
    JOIN sales.staffs e ON s.store_id = e.store_id
    JOIN sales.staffs m ON e.manager_id = m.staff_id
    WHERE o.store_id = @TopStoreID AND YEAR(o.order_date) = @Year
    GROUP BY s.store_name, m.first_name, m.last_name, oi.product_id
    ORDER BY TotalSales DESC;
END;
GO

exec q3 '2016'
exec q3 '2017'
exec q3 '2018'


