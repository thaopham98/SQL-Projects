use BikeStores;

/* Q3
Create a function that when passed productid, return the total quantity that the product was
ordered.
a. Use the function in a SELECT to return the product names and the quantity they
were ordered
*/

DROP FUNCTION IF EXISTS m2Q3;
GO
CREATE or ALTER FUNCTION m2Q3(@productid INT)
    RETURNS INT
BEGIN 
    RETURN
    (
        SELECT sum(quantity) from sales.order_items where product_id=@productid
    )
END
GO

-- use the func to return the number of products that haven't been ordered yet
select 
    product_name, 
    dbo.m2Q3(product_id) AS 'Quantity Ordered' -- calling the function m2Q3
from production.products
where dbo.m2Q3(product_id) IS NULL -- products that haven't been ordered yet

SELECT * from sales.order_items where product_id=20



/* Q4
Create a function that when passed a storeid returns the name of the main manager (the
manager that doesn’t have a manager) OR the TOP manager of the store.
    a. Use the function in a SELECT query to return all the stores and the number of
mangers in each store.
*/

SELECT * FROM sales.staffs

SELECT 
    TOP 1
    m.first_name + ' ' + m.last_name 'Manager Name', 
    m.store_id 'Store' 
    --m.store_id MStore
    -- count(m.staff_id) CountStaffID,
    -- count(e.manager_id )'Total Employee Managed'
FROM sales.staffs e 
join sales.staffs m on e.manager_id=m.staff_id
where e.store_id=2 --*** very importance, e.store_id != m.store_id
group by m.first_name,m.last_name , 
    m.store_id --, m.staff_id
order by count(e.manager_id) desc 
;

GO
drop function if EXISTS m2Q4;
go;

CREATE OR ALTER FUNCTION m2Q4(@storeid INT)
RETURNS varchar(30) --table
BEGIN
    RETURN
    (
        -- SELECT 
        -- -- TOP 1 --  cannot have this here will raise expression error
        -- m.first_name + ' ' + m.last_name 'Manager Name'
        -- -- e.store_id 'Store'
        -- --m.store_id MStore
        -- -- count(m.staff_id) CountStaffID,
        -- -- count(e.manager_id )'Total Employee Managed' -- cannot have this here will raise expression error
        -- FROM sales.staffs e 
        -- join sales.staffs m on e.manager_id=m.staff_id
        -- where e.store_id=@storeid --*** very importance, e.store_id != m.store_id
        -- group by m.first_name,m.last_name--, e.store_id , m.staff_id

        -- /* to avoid expression error, we will using HAVING clause*/
        -- having count(*) =(
            -- select
            --     top 1 count(*)
            --     from sales.staffs
            --     where store_id=1
            --     group by manager_id, store_id
            --     order by count(*) DESC
        -- )    

        SELECT top 1
            m.first_name + ' ' + m.last_name 'Manager Name', 
            m.store_id 'Store' 
        FROM sales.staffs e 
        JOIN sales.staffs m 
            ON e.manager_id=m.staff_id
        WHERE e.store_id = @storeid --*** very importance, e.store_id != m.store_id
        GROUP BY  
            m.first_name,
            m.last_name , 
            m.store_id, 
            m.staff_id
        ORDER BY m.staff_id DESC -- highest - lowest 
    )
END
GO

SELECT * from dbo.m2Q4(2);
GO
select  * from dbo.FnQ5(2)
