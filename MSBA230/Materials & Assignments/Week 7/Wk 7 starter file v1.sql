USE MyGuitarShop;
select * from Categories
select * from Products;
select * from Orders;
select * from OrderItems;
select * from Customers;

-- Return all the categories and the number of products in each.
select 
    CategoryName, 
    count(*) [Number of Products]
from Products p 
join Categories c on p.CategoryID=c.CategoryID
group by CategoryName
order by [Number of Products];

-- Return the products and the number of times they were ordered
select 
    p.ProductName, 
    oi.ProductID, 
    count(*) [Frequency]
    -- count(Distinct OrderID) [Distinct] -- Sometimes it is different from just COUNT()
from Products p 
join OrderItems oi on p.ProductID=oi.ProductID
group by p.ProductName, oi.ProductID;

-- What is the best selling product?
select 
    TOP 1 
    p.ProductName,
    oi.ProductID, 
    count(*) [Frequency],
    sum(Quantity) [Total Quantity Ordered]
from Products p 
join OrderItems oi on p.ProductID=oi.ProductID
group by p.ProductName, oi.ProductID
ORDER BY [Total Quantity Ordered] DESC;

--List the customers who have ordered more than one time.
select 
    c.FirstName + ' ' +c.LastName FullName,
    Count(o.CustomerID) [Count]
from Customers c
join Orders o on c.CustomerID=o.CustomerID
group by c.FirstName + ' ' +c.LastName
;

-- CTE to create a temporary table 
with countOfOrders AS(
    select 
        ProductName,
        count(*) [Number of Times Ordered],
        sum(Quantity) [Totatl Quantity]
    from Products
    join OrderItems on Products.ProductID=OrderItems.ProductID
    group by ProductName
)
select 
    * INTO #countOfOrders -- the # sign makes it a temporary table & not added to the database
    -- sum([Number of Times Ordered])  
from countOfOrders;

-- Return the products that they final price is less than $500.
select 
    ProductName,
    ListPrice*(ListPrice*DiscountPercent)/100 [Final Price]
from Products p 
Where ListPrice-(ListPrice*DiscountPercent)/100 < 500

select 
    ProductName,
    ListPrice*(100-DiscountPercent)/100 [Final Price]
from Products p 
Where ListPrice*(100-DiscountPercent)/100 < 500

-- Return the months and the number of products shippped in each month. 
select 
    MONTH(ShipDate) Month,
    SUM(Quantity) [Total Quantity]
from Orders o 
join OrderItems oi on o.OrderID=oi.OrderID
WHERE MONTH(ShipDate) is not NULL
group by MONTH(ShipDate)

-- Cross Join
select * 
from products CROSS JOIN Customers;