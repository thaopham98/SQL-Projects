USE MyGuitarShop;

/* Ex 1:
    Write a stored procedure that when passed a category ID returns all the customers who
have bought that category more than once. The SP should as well return a message that
display the number of products in that category. Demonstrate using the SP for category ID
=1
*/
DROP PROC IF EXISTS q1;
GO

CREATE OR ALTER PROC q1
    @categoryID INT
AS 

    IF @categoryID NOT IN (SELECT CategoryID FROM Categories)
        BEGIN
            PRINT 'Category does not exist!' -- display the message
            RETURN -- Ends the execution of the stored procedure 
        END  

    /* SELECT query: Info of customers who bought @categoryID more than 1*/
    SELECT 
        c.CustomerID,
        FirstName, 
        LastName
        -- ,count(*) [Category Frequency], count(p.ProductID) [Number of Product]
    FROM Customers c 
    JOIN Orders o ON c.CustomerID = o.CustomerID
    JOIN OrderItems oi ON o.OrderID = oi.OrderID
    JOIN Products p ON oi.ProductID = p.ProductID
    WHERE CategoryID=@categoryID
    GROUP BY 
        c.CustomerID,
        FirstName, 
        LastName
    HAVING COUNT(*)>1 -- bought the category more than 1
    ;

    /* Display message: There are 5 products in this category*/
    /* Declare variable for the message */
    DECLARE @countProduct INT;

    /* SELECT query for the message*/
    SELECT 
        @countProduct = COUNT(*)
    FROM Products
    WHERE CategoryID=@categoryID;

    /* Display the message */
    PRINT CONCAT('There are', @countProduct, ' product(s) in category ',@categoryID)

GO

/* Executing q1 */
EXEC q1 11;
EXEC q1 1;
EXEC q1 2;
EXEC q1 3;
EXEC q1 4;

/*
2- Write a stored procedure that given the productid returns a message with the total
quantity of sales for that product. Demonstrate using the SP for product ID =3
*/
GO

DROP PROC IF EXISTS q2;
GO

CREATE OR ALTER PROC q2
    @productID INT 
AS 
    /*Check if the @productID exists or not */
    IF @productID NOT IN (SELECT productID FROM Products)
        BEGIN
            PRINT CONCAT('The productID ', @productID, ' doesn not exist!');
            -- THROW 50001, 'The productID does not exist', 1;
            RETURN
        END
        -- THROW 50001, 'The productID does not exist', 1; 

    /* Return a message with the total quantity of sales for the @productID */
    /* Declare variable(s) for the message */
    DECLARE @totalSalesQuantity INT;

    /* SELECT query for the message */
    SELECT 
        -- *
        -- ProductID,
        -- ProductName,
        @totalSalesQuantity = SUM(Quantity) -- [Total Quantity of Sales]
    FROM OrderItems oi
    WHERE ProductID = @productID
    -- GROUP BY ProductID,
        -- ProductName
    ;
    /* Display the message: a total of 20 quantity was sold for this product */

    PRINT CONCAT('A total of ',@totalSalesQuantity, ' quantity was sold for this productID ',@productID)

/* Executing q2*/
GO 
EXEC q2 3;
EXEC q2 12; -- not exist
EXEC q2 1;
EXEC q2 4;

/*
3- Write a store procedure that given a state returns all the customers that live there. If no
customers in that state, raise an error.
*/
GO 

DROP PROC IF EXISTS q3;
GO

CREATE OR ALTER PROC q3
    @state CHAR(2)
AS
    /* Check if the @state exists or not */
    IF @state NOT IN (SELECT [State] FROM Addresses)
        THROW 50002, 'The state does not exist', 1

    /* Raise an error if NO customers in the @state*/
    IF NOT EXISTS (SELECT * FROM Addresses WHERE State = @state)
        THROW 50003, 'No one living in that state', 1

    /* Return all the customers that live in the @state */
    SELECT 
        DISTINCT c.*
    FROM Customers c 
    JOIN Addresses a ON c.CustomerID=a.CustomerID
    WHERE [State]= @state
                    --'CA'
    ;


/* Executing q3 */
EXEC q3 'LL'
EXEC q3 'CA'

---- from a different ERD in the Final Review Solution file ----
/* 4
Write a SELECT query that returns the name of employees that have sold more than $3,000
in August and September of 2024
*/

select 
    e.EmpID,
    e.Firstname +' '+ e.Lastname 'Full Name',
    SUM(DollarSales) 'Total Sales in Dollar'
from Employee e
join Sales s on s.EmpID = e.EmpID
WHERE -- either one of the queries below 
    -- SaleDate BETWEEN '1/8/2024' AND '30/09/2024'
    Year(SaleDate)=2024 AND MONTH(SalesDate) IN (8,9)
GROUP BY e.EmpID, e.Firstname, e.Lastname
HAVING SUM(DollarSales)>3000;

-------------------- TESTING QUERY ---------------------
-- select 
--     *
-- From orders 
-- where YEAR(OrderDate)=2020 AND MONTH(OrderDate) IN (1,3)
--------------------------- END -------------------------

/* 5
Write a SELECT query to return the employee with the most bonus
*/
select 
    TOP 1
    e.EmpID, 
    e.Firstname +' '+ e.Lastname 'Full Name',
    SUM(BonousAmount) 'Total Bonus'
from Employee e
join Bonuses b on b.EmpID = e.EmpID
group by 
    e.EmpID, 
    e.Firstname,
    e.Lastname 
ORDER BY 'Total Bonus' DESC ;


/* 6 
Create a stored procedure that given the EmpID and month returns all following:
• A table (EmpID, Name, Total sales amount, Number of sales) for the specified employee
during that month of current year.
• A message similar to: “There were a total of 5 transactions adding up to $40,000 in sales.”
*/
GO 
CREATE OR ALTER PROC q6
    @EmpID INT, @month int 
AS 
    /* Return a table */
    select 
        e.EmpID,
        e.Firstname +' '+ e.Lastname 'Full Name',
        SUM(DollarSales) [Total sales amount],
        COUNT(*) [Number of sales]
    FROM Employee e 
    JOIN Sales s on s.EmpID = e.EmpID
    WHERE 
        e.EmpID=@EmpID
        AND 
        YEAR(SaleDate) = YEAR(GETDATE())
        AND 
        MONTH(SaleDate) = @month
    GROUp by 
        e.EmpID,
        e.Firstname,
        e.Lastname ;

    /* Message: there were a total of 5 transactions adding up to $40,000 in sales */
    DECLARE @trans int, @totalSales int 

    select 
        @trans = COUNT(*),
        @totalSales = SUM(DollarSales)
    FROM Employee e 
    WHERE
        e.EmpID=@EmpID
        AND 
        YEAR(SaleDate) = YEAR(GETDATE())
        AND 
        MONTH(SaleDate) = @month
    
    PRINT CONCAT('There were a total of ', @trans, 'transactions adding up to $', @totalSales, ' in sales.')
-------------------- TESTING QUERY ---------------------
SELECT YEAR(GETDATE())
SELECT MONTH(GETDATE())
--------------------------- END -------------------------



---- from a different ERD in the Final Review Solution file ----

/*
Which customers have more than one water meter installed?
*/
SELECT
    -- w.CustomerID,
    Firstname, 
    Lastname,
    count(InstallationDate) 'Number of water meter installed' -- or using count(*)
from WaterMeters w
JOIN Customer c on w.CustomerID = c.CustomerID
group by
    -- w.CustomerID, 
    Firstname, 
    Lastname
having count(InstallationDate)>1 -- or using count(*)

/*
Which brands have an average usage greater than 500 cubic feet? (Hint: Usage=
CurrentReadingin100CubicFt - LastReadingIn100CubicFt )
*/

select 
    MeterBrand, 
    AVG(CurrentReadingin100CubicFt - LastReadingIn100CubicFt) 'Average Usage'
From WaterMeters w 
JOIN MeterReading m on w.MeterSerialNumber = m.MeterSerialNumber
group by MeterBrand
having AVG(CurrentReadingin100CubicFt - LastReadingIn100CubicFt)>500

/*
Which customers have water meters installed after January 1, 2020, and belong to the
'Residential' usage type?
*/
select 
    c.*,
    InstallationDate
from WaterMeters w
JOIN Customer c on w.CustomerID = c.CustomerID
where 
        InstallationDate>'01/01/2020' -- AFTER '01/01/2020'
    and 
        UsageType='Residential'

-------------------- TESTING QUERY ---------------------
SELECT * FROM Customers
SELECT * FROM Orders