-- SELECT *  
-- FROM Orders
-- WHERE ShipDate IS NULL;

-- SELECT 
--     c.CustomerID, 
--     c.FirstName +' '+c.LastName AS FullName, 
--     CONCAT(Line1, Line2,', ', City,', ', State,', ', ZipCode) AS Address
--     -- a.*
-- FROM Customers AS c
-- JOIN Addresses AS a ON c.CustomerID=a.CustomerID
-- WHERE c.ShippingAddressID=c.BillingAddressID;


-- SELECT *
-- FROM Customers AS c 
-- WHERE c.EmailAddress LIKE FirstName+'%'
-- ;

-- SELECT *
-- FROM Customers
-- LEFT JOIN Orders on Customers.CustomerID=Orders.CustomerID
-- WHERE OrderID is NULL

/* Subquery -- 1 query inside another query*/
-- SELECT *
-- FROM Customers
-- WHERE CustomerID NOT IN (
--     SElect DISTINCT CustomerID
--     from Orders)


-- select * from Products
-- WHERE DiscountPercent>25;

-- SELECT *
-- FROM Products AS p 
-- LEFT JOIN Categories AS c ON p.CategoryID=c.CategoryID
-- WHERE CategoryName = 'Guitars';

SELECT *
FROM Products AS p 
-- LEFT JOIN Categories AS c ON p.CategoryID=c.CategoryID
WHERE p.[Description] LIKE '%electric guitar%' 
    -- OR c.CategoryName='Guitars'
    ;
