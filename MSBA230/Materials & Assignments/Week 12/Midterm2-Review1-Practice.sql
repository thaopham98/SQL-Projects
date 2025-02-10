USE BikeStores;

/* Q1
Create a stored procedure that when passed a customer ID returns the store details, number
of times they ordered from that store and the total amount ordered. If CustomerID doesn’t
exist throw an error.
a. Exec for 6, 60, 2000
*/
DROP PROCEDURE IF EXISTS M2Q1;
GO

CREATE OR ALTER PROC M2Q1 
    @customerID INT
AS 
    /* Check the query first before apply it with SP*/
    IF @customerID NOT IN (SELECT customer_id FROM sales.customers)
    	THROW 50000, 'Customer does not exist', 1 

    /* SELECT statement returns a RECORD/TABLE */
    SELECT 
        store_name, -- return the store details
        COUNT(DISTINCT oi.order_id) 'Order Frequency', -- number of times they ordered from the store
            -- Hint: there can be many product in an order
        SUM(list_price*(1-discount)*quantity) 'Total Amount of Ordered' -- The total amount of order
            -- Hint: when testing for customerID=1 and get 17, then the query is not correct 
    FROM sales.orders so
    JOIN sales.stores ss
        on ss.store_id=so.store_id
    JOIN sales.order_items oi 
        on oi.order_id=so.order_id
    WHERE customer_id = @customerID
    GROUP BY store_name
    ;

    /* Defining local variables */
    DECLARE @storename varchar(30), @countorders int, @totalamount money

    /* SELECT statement returns a MESSAGE */
    SELECT @totalamount=SUM(list_price*(1-discount)*quantity ), 
        @storename=store_name, 
        @countorders=COUNT(DISTINCT OI.order_id)
    FROM sales.orders sales JOIN sales.stores stores ON sales.store_id=stores.store_id
                            JOIN sales.order_items OI ON OI.order_id=sales.order_id
    WHERE customer_id=@customerID
    GROUP BY store_name;

    /* Displaying the message */
    PRINT CONCAT('There have been ',@countorders,' orders from ', @storename, 
                ' store and the total amount is $',@totalamount)

EXEC M2Q1 6
EXEC M2Q1 60
EXEC M2Q1 2000


/* Q2
Create a stored procedure that when passed a state returns the store, list of employees and
the name of the manager. If no store in that state, print a message.
*/

DROP PROCEDURE IF EXISTS M2Q2;
GO
CREATE OR ALTER PROC M2Q2(@state VARCHAR(2))
AS      
    IF @state NOT IN (SELECT [state] FROM sales.stores)
        THROW 50001, 'There is no store in this state', 1;

    SELECT 
        TOP 1 
        m.first_name + ' ' + m.last_name AS ManagerName,  -- Full name of the manager
        s.store_name  -- Store name
        -- COUNT(e.staff_id) AS 'Number of Staff'  -- Count of staff under this manager
    FROM sales.stores s
    JOIN sales.staffs e ON s.store_id = e.store_id  -- Join stores with employees
    JOIN sales.staffs m ON e.manager_id = m.staff_id  -- Join to find the manager for each employee
    WHERE s.[state] = @state  -- Replace with the desired store_id or parameterize it
    GROUP BY m.first_name, m.last_name, s.store_name  -- Group by manager and store name
    ORDER BY COUNT(e.staff_id) DESC  -- Order by number of staff under each manager in descending order

    /* Defining local variables */
    DECLARE @storeName varchar(30), @countEmployees int, @managerName varchar(50);

    /* SELECT statements return a MESSAGE */
    SELECT @countEmployees = COUNT(e.active)
    FROM sales.stores s
    JOIN sales.staffs e ON s.store_id = e.store_id
    WHERE s.[state] = @state;

    SELECT 
        @storeName = s.store_name,
        @managerName = m.first_name+' '+ m.last_name
    FROM sales.stores s
    JOIN sales.staffs e ON s.store_id = e.store_id -- Join staffs with stores
    JOIN sales.staffs m ON e.manager_id = m.staff_id -- Get the manager's details
    WHERE s.[state] = @state
    GROUP BY s.store_name, m.first_name, m.last_name

    /* Displaying the message */
    PRINT CONCAT('The store, ', @storeName, ', in ', @state, ' state has ', 
        @countEmployees, ' employees and the manager is ', @managerName, '.'
    ); 

GO
/* Calling the SP */
select * from sales.staffs where store_id=2
EXEC M2Q2 NY;
EXEC M2Q2 CA;
EXEC M2Q2 MN;
EXEC M2Q2 LA;


/* Q3
First write a query to list the years that we have orders for. Then create a stored procedure
that when passed a year ret b urns the following information:
a. The store that sold the most. And the following information for that store:
b. The total sales, the most popular product and the manager name
*/

SELECT DISTINCT YEAR(order_date) AS Year
FROM sales.orders
ORDER BY Year;

GO

DROP PROC IF EXISTS M2P1Q3;
GO

CREATE OR ALTER PROC M2P1Q3
    @year INT 
AS
BEGIN
    -- Declare variables to store the results
    DECLARE 
        @store_id INT,
        @total_sales DECIMAL(18, 2),
        @manager_name VARCHAR(100);

    -- Step 1: Find the store that sold the most in the specified year
    SELECT TOP 1 
        @store_id = s.store_id,
        @total_sales = SUM(oi.list_price * (1 - oi.discount) * oi.quantity)
    FROM sales.orders o 
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    JOIN sales.stores s ON o.store_id = s.store_id
    WHERE YEAR(o.order_date) = @year
    GROUP BY s.store_id
    ORDER BY SUM(oi.list_price * (1 - oi.discount) * oi.quantity) DESC; -- Sort by total sales directly

    -- Step 2: Find the most popular product for the top store
    DECLARE @most_popular_product VARCHAR(100);
    SELECT TOP 1
        @most_popular_product = p.product_name
    FROM sales.order_items oi
    JOIN production.products p ON oi.product_id = p.product_id
    JOIN sales.orders o ON oi.order_id = o.order_id
    WHERE o.store_id = @store_id
    GROUP BY p.product_name
    ORDER BY COUNT(oi.product_id) DESC; -- Most ordered product

    -- Step 3: Find the manager for the store
    SELECT 
        @manager_name = CONCAT(m.first_name, ' ', m.last_name)
    FROM sales.staffs e
    JOIN sales.staffs m ON e.manager_id = m.staff_id
    WHERE e.store_id = @store_id;

    -- Step 4: Return the results
    SELECT 
        @store_id AS StoreID,
        @total_sales AS TotalSales,
        @most_popular_product AS MostPopularProduct,
        @manager_name AS ManagerName;

    PRINT CONCAT('The store_id: ', @store_id,' managed by ',@manager_name ,' has the total sales of $',
            @total_sales,'. The most popular product is ', @most_popular_product,' in ',@year,'.')

END;
GO
EXEC M2P1Q3 2016

/* Q4
Create a function that when passed productid, return the total quantity that the product was
ordered. 
a. Use the function in a SELECT to return the number of products bought.
*/

DROP FUNCTION IF EXISTS M2Q4;
GO

CREATE OR ALTER FUNCTION M2Q4 (@productid INT)
    RETURNS INT
BEGIN
    RETURN (SELECT SUM(list_price) FROM production.products WHERE product_id = @productid)
END 

GO

SELECT 
    product_name, 
    dbo.M2Q4(p.product_id) 'Total Number of Product'
FROM [production].[products] p 


/* Q5
Create a function that when passed a store id returns the name of all managers. 
a. Use the function in a SELECT query to return all the stores and the number of mangers in each store.
*/

DROP FUNCTION IF EXISTS M2Q5;
GO
CREATE OR ALTER FUNCTION M2Q5 (@storeid INT)
    RETURNS VARCHAR(50)
BEGIN
    RETURN
    (
        SELECT 
            DISTINCT m.first_name + ' ' + m.last_name [Manager Name]
        FROM sales.staffs e
        JOIN sales.staffs m ON e.manager_id = m.staff_id
        WHERE m.store_id = @storeid
    );
END

GO
SELECT *
FROM sales.stores CROSS APPLY dbo.FnQ5(store_id)

SELECT [store_id], COUNT([Manager Name]) 'Number of Manager'
FROM [sales].[stores] CROSS APPLY dbo.FnQ5(Store_id)
GROUP BY store_id