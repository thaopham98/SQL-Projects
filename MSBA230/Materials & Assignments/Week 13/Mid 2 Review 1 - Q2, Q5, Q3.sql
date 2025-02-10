--5. Create a function that when passed a store id returns the name of all managers. a. Use the
--function in a SELECT query to return all the stores and the number of mangers in each store.

CREATE OR ALTER FUNCTION FnQ5
(@storeid int)

RETURNS TABLE

AS
    RETURN
    (
    SELECT DISTINCT Manager.first_name + ' '+ Manager.last_name AS 'Manager Name'
    FROM [sales].[staffs] AS Staff JOIN [sales].[staffs] AS Manager ON Staff.manager_id=Manager.[staff_id]
    WHERE Manager.store_id=@storeid
    )

GO

SELECT *--[store_id], COUNT([Manager Name])
FROM [sales].[stores] S CROSS APPLY dbo.FnQ5(Store_id)
--GROUP BY  [store_id]

----2. Create a stored procedure that when passed a state returns the 
--store, 
--list of employees and
----the name of the manager. 
--Ino store in that state, print a message.
----a. Exec for CA, NY, LA

GO
CREATE OR ALTER PROC Q2
   @state char(2)
AS
   IF @state NOT IN (SELECT state FROM [sales].[stores])
      PRINT 'No Store in this State'

   ELSE
      DECLARE @storeName varchar(30), @countEmployees varchar(50), @managerName varchar(50);
      BEGIN 
      --store
   
      --    SELECT @storeName=store_name
      --    FROM [sales].[stores]
      --    WHERE [state]=@state;

      -- --list of employees
      --    SELECT *
      --    FROM [sales].[staffs] AS S JOIN [sales].[stores] AS St ON St.store_id=S.store_id
      --    WHERE [state]='CA'--@state;

      -- --the name of the manager. 
      --    SELECT DISTINCT Manager.first_name + ' '+ Manager.last_name AS 'Manager Name'
      --    FROM [sales].[staffs] AS Staff JOIN [sales].[staffs] AS Manager ON Staff.manager_id=Manager.[staff_id] 
      --    JOIN [sales].[stores] St ON St.store_id=Manager.store_id
      --    WHERE [state]=@state; 

         SELECT 
            @storeName = s.store_name,
            @countEmployees = COUNT(e.staff_id),
            @managerName = 
            (
               SELECT CONCAT(m.first_name, ' ', m.last_name)
               FROM sales.staffs m 
               WHERE m.manager_id IS NULL AND m.store_id = s.store_id
            )
         FROM sales.stores s
         JOIN sales.staffs e ON s.store_id = e.store_id -- Join staffs with stores
         WHERE s.[state] = @state
         GROUP BY s.store_name, s.store_id;

      END
   
   PRINT CONCAT(
        'The store, ', @storeName, 
        ', in ', @state, ' state has ', 
        @countEmployees, ' employees and the manager is ', @managerName, '.'
    ); 
     SELECT 
        s.store_name AS StoreName,
        CONCAT(e.first_name, ' ', e.last_name) AS EmployeeName,
        @managerName AS ManagerName
    FROM sales.stores s
    JOIN sales.staffs e ON s.store_id = e.store_id -- Join staffs with stores
    WHERE s.[state] = @state
    ORDER BY s.store_name, EmployeeName;
EXEC Q2 CA

--3) First write a query to list the years that we have orders for. Then create a stored procedure
--that when passed a year ret b urns the following information:
--a. The store that sold the most. And the following information for that store:
--b. The total sales, the most popular product and the manager name

SELECT DISTINCT YEAR([order_date]) as 'Year'
FROM [sales].[orders]

GO

CREATE OR ALTER PROC Q3
 @year int

 AS
 DECLARE @storeid int, @totalsales Money

 --Store with Most orders

 SELECT 
    TOP 1 @storeid=[store_id], 
    @totalsales = SUM(Quantity*list_price*(1-[discount]))
 FROM [sales].[orders] SO 
 JOIN [sales].[order_items] OI 
    ON SO.order_id=OI.order_id
 WHERE YEAR([order_date]) =@year
 GROUP BY [store_id]
 ORDER BY SUM(Quantity*[list_price]*(1-[discount])) DESC

 -- Most popular product