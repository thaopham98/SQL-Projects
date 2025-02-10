USE MyGuitarShop;

--Returning EmailAddress, OrderID, OrderDate
SELECT 
    c.EmailAddress, 
    o.OrderID, 
    o.OrderDate
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID -- Joining with Orders table with CustomerID
-- Correlation subquery  
WHERE o.OrderDate = -- Condition: filtering the row where o.OrderDate matches the minimum o2.OrderDate.
(
    SELECT MIN(o2.OrderDate) -- returing the minimum/oldest date of each customer.
    FROM Orders o2 -- joining with the Orders table and set as o2
    WHERE o2.CustomerID = c.CustomerID -- it references the `c.CustomerID` from the main query & we're find the MIN(OrderDate) of EACH CUSTOMER.
);