USE MyGuitarShop;
/* PART 1 */
/* a) return the store with the most staffs */
-- select TOP 1 store_id, store_name, count(*) as [Most Staffs]
-- from Stores s 
-- join Staffs on s.store_id=Staffs.store_id 
-- group by store_id, store_name
-- order by count(*) DESC;

/* b) Return the customers that have bought products 
with a list price of $2000 in the last month.*/
-- select c.*
-- from Orders o 
-- join Customers c on c.CustomerID=o.CustomerID
-- join OrderItems oi on o.OrderID=oi.OrderID
-- where DATEDIFF(Month, OrderDate,getdate())<= 1
-- and list_price=2000

/* c) Return the number of times that products with model
year of 2017 and price of $1000 or more, have been ordered*/
-- select p.ProductName, count(*) [Ordered Times]
-- from Products p 
-- join OrderItems oi on oi.ProductID=p.ProductID
-- where p.model_year=2017 
-- and ListPrice>=1000
-- group by p.ProductName

/* d) Return the CA customers that have purchased 
from an out of state store */
-- select c.*
-- from Customers c 
-- join Orders o on o.CustomerID=c.CustomerID
-- join Stores s on s.store_id=o.store_id
-- where c.state='CA' and s.state<>'CA';

/* e) List the out of stock products for Store ID 1. */
-- select Products.*
-- from Stocks 
-- join Products on Stocks.ProductID=Products.ProductID
-- where store_id=1 and quantity=0

/* f) return the customers that their 
number of orders is above average*/
-- WITH NumberOfOrders AS (
-- select 
--     CustomerID, 
--     count(*) [Number of Order]
-- from Orders
-- group by CustomerID
-- )

-- SELECT CustomerID, COUNT(*) [Number of Order]
-- FROM Orders
-- GROUP BY CustomerID
-- HAVING COUNT(*) >  
-- (
--     SELECT AVG([Number of Order]) 
--     FROM #NumberOfOrders
-- )

/* g) Return the name of all the managers */

/* Subquery */
-- select FirstName, LastName
-- from Staffs s  
-- where s.StaffID in 
-- (-- get the mangers' id
-- select Distinct m.managerID 
-- from Staff m)

/* Self Join*/
-- select distinct m.firstname, m.LastName
-- from Staff s 
-- join Staff m on s.StaffID=m.ManagerID

/* h) For 2016, return the store that has the 
most orders in Spring season (March, April, May). */
-- select s.StoreName, COUNT(*)
-- from Stores s 
-- join Orders o on o.store_id=s.store_id 
-- where YEAR(OrderDate)=2016
-- and month(OrderDate) IN (3,4,5)
-- group by s.StoreName
-- ORDER by count(* ) DESC
-- ;

    /* This is to checking out the query's CLAUSES above */
-- select top 1 CardNumber, COUNT(*)
-- from OrderItems oi 
-- join  Orders o on o.OrderID=oi.OrderID 
-- group by CardNumber
-- order by count(*) desc ;


/* PART 2 */
/*  a)
Return the products and total quantity that 
was ordered in the last month. 
Sort the result with the most popular product at the top.*/

-- select 
--     p.productName,
--     SUM(quantity) TotalQuantity
-- from Products p 
-- join OrderItems oi on p.ProductID = oi.ProductID
-- join Orders o on o.OrderID = oi.OrderID
-- where DATEDIFF(MONTH, OrderDate, GetDate())<=1 -- includes orders from the previous calendar month and the current calendar month.
-- group by productName
-- order by TotalQuantity DESC

/* d) 
Return the customers with the count of their 
orders and the total amount for those orders. 
Order by the customer with the highest orders. */

-- select 
--     c.FirstName, 
--     c.LastName, 
--     count(OrderID), 
--     sum(ShipAmount)
-- from Customers c 
-- join Orders o on c.CustomerID=o.CustomerID
-- group by c.FirstName, c.LastName, OrderID
-- order by count(o.OrderID) DESC

/* 
Return all the customers that have put
at least 5 orders in the last 6 months. 
Sort the result with the customer with 
the most order at the top. 
 */

-- select 
--     c.FirstName, 
--     c.LastName, 
--     count(*)
-- from Customers c 
-- join Orders o on c.CustomerID=o.CustomerID
-- where DATEDIFF(MONTH, OrderDate, GetDATE())<=6
-- group by 
--     c.FirstName, 
--     c.LastName
-- having count(*)>=5
-- order by count(*) desc

