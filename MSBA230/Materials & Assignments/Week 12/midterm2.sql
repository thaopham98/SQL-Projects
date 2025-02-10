USE BikeStores;

/* Q1
Create a stored procedure that when passed a customer ID returns the store details, number
of times they ordered from that store and the total amount ordered. If CustomerID doesn’t
exist throw an error.
*/
DROP PROCEDURE IF EXISTS mid2Q1;
GO
CREATE OR ALTER PROC mid2Q1
    @customerID INT 
AS 
    BEGIN
    /* If CustomerID does NOT EXISTS */
    IF @customerID NOT IN (select customer_id from [sales].[orders])
        THROW 50000, 'The customer ID does not exists', 1;
    
    /* Declaring local variables for a message of this SP's purpose */
    DECLARE @storename varchar(30), @countorders int, @totalamount money

    SELECT
        @storename = store_name, 
        @countorders = count(distinct o.order_id), -- needs DISTINCT b/c in an order can have multiple products.
        @totalamount = sum(list_price*(1-discount)*quantity)
    from sales.orders o 
    join sales.order_items oi 
        on o.order_id = oi.order_id
    join sales.stores s 
        on s.store_id = o.store_id
    WHERE @customerID = customer_id
    GROUP BY store_name;

    /* this will display the whole result table */
    -- select 
    --     customer_id,
    --     s.store_id, s.store_name, -- the store details
    --     count(distinct o.order_id) [Frequency of Order],-- number of times they ordered from that store 
    --     sum(list_price*(1-discount)*quantity) [Total Amount]-- the total amount ordered (money)
    -- from sales.orders o 
    -- join sales.order_items oi 
    --     on o.order_id = oi.order_id
    -- join sales.stores s 
    --     on s.store_id = o.store_id
    -- where customer_id=@customerID
    -- group by customer_id, s.store_id, s.store_name;

    /* display a message for the SP*/
    PRINT CONCAT('There have been ',@countorders, ' orders from ', @storename, 
			' store and the total amount is $', @totalamount)
    
    END
GO
EXEC mid2Q1 175;
EXEC mid2Q1 6;
EXEC mid2Q1 60;
EXEC mid2Q1 2000;

/* Q2
Create a stored procedure that when passed a state returns the store, list of employees and 
the name of the manager. Ino store in that state, print a message.
*/
DROP PROCEDURE IF EXISTS mid2Q2;
GO 
CREATE OR ALTER PROC mid2Q2
    @state VARCHAR(2)
AS 
    /* If CustomerID does NOT EXISTS */
    IF @state NOT IN (select state from [sales].[stores])
        THROW 50000, 'The state does not exists', 1;


    /* Declaring local variables for a message of this SP's purpose */
    -- DECLARE @storename varchar(30), @countStaff INT 
    
    -- SELECT 
    --     s.store_id, 
    --     s.store_name,
    --     s.[state], 
    --     e.first_name + ' ' + e.last_name [Employee Name]
    --     -- m.first_name + ' ' + m.last_name [Manager Name] 
    -- FROM sales.stores s
    -- JOIN sales.staffs e 
    --     ON s.store_id = e.store_id
    -- -- JOIN sales.staffs m 
    --     -- ON m.staff_id=e.manager_id
    -- WHERE [state] IN ('CA','TX','NY');

    SELECT 
        s.store_id, 
        s.store_name,
        s.[state], 
        e.first_name + ' ' + e.last_name [Employee Name],
        m.first_name + ' ' + m.last_name [Manager Name] 
    FROM sales.stores s
    JOIN sales.staffs e 
        ON s.store_id = e.store_id
    JOIN sales.staffs m 
        ON m.staff_id=e.manager_id
    WHERE [state] = @state;

GO 
EXEC mid2Q2 CA;
EXEC mid2Q2 TX;
EXEC mid2Q2 LA;


    SELECT * FROM
    SELECT * FROM
    SELECT * FROM
    SELECT * FROM [sales].[stores];
    SELECT * FROM [sales].[staffs];

/**/
/**/
/**/

GO
/* total amount per order_id*/
SELECT 
    *
    -- order_id, 
    -- sum(list_price*(1-discount)*quantity) 
from sales.order_items 
WHERE order_id=4
-- group by order_id;

/* display total amount per order_id of a customer*/
select 
    o.order_id,
    customer_id,
    count(distinct o.order_id) [Frequency of Order],-- number of times they ordered from that store 
    sum(list_price*(1-discount)*quantity) [Total Amount]-- the total amount ordered (money)
from sales.orders o 
join sales.order_items oi 
    on o.order_id = oi.order_id
where customer_id=175
    group by customer_id, o.order_id;