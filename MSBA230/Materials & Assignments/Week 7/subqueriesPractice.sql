USE MyGuitarShop;

/*  1   */
-- select CategoryName
-- from Categories
-- where CategoryID IN 
--     (
--         select CategoryID
--         from Products
    -- );

/*  3   */
/* 
    Return the category names that don't have any products associated with them
*/
/* Method 1 - Using LEFT JOIN*/
-- SELECT *
-- FROM Categories c
-- LEFT Join Products p on p.CategoryID=c.CategoryID
-- where ProductID is NULL

/* Method 2 - Using a subquery*/
-- SELECT CategoryName
-- from Categories
-- where CategoryID NOT IN 
-- (SELECT Distinct CategoryID
-- from Products)

/* Method 3 - Using a correlated subquery*/
-- SELECT CategoryName
-- from Categories
-- where NOT EXISTS -- the sub query is not returning anything
-- ( 
--     select *
--     from Products where CategoryID=Categories.CategoryID
-- )


/*  4   */


/*  5   */
-- give me the products in the subquery.
SELECT ProductName, DiscountPercent
FROM Products
where DiscountPercent IN
    ( -- list of unique DiscountPercent
        select DiscountPercent
        from Products
        GROUP by DiscountPercent
        having count(*)=1
    )

/*  6   */
select 
    c.EmailAddress,
    MIN(o.OrderID) AS OldestOrderID,
    MIN(o.OrderDate) [Oldest Order Date]
from customers c 
join Orders o on o.CustomerID=c.CustomerID
group by 
    c.EmailAddress;


SELECT c.EmailAddress, o.OrderID, o.OrderDate
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderDate = (
    SELECT MIN(OrderDate)
    FROM Orders o2
    WHERE o2.CustomerID = c.CustomerID
);