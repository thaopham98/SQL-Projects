USE BikeStores;

SELECT * FROM sales.customers;
SELECT * FROM sales.order_items;
/* Q1 v1
Create a stored procedure that when passed a customer ID returns the store details, number
of times they ordered from that store and the total amount ordered. If CustomerID doesn’t
exist throw an error.
a. Exec for 6, 60, 2000
*/
GO
CREATE OR ALTER PROC Q1 
    @customerID INT
AS 
    /* Check the query first before apply it with SP*/
    SELECT 
    -- *
    store_name,
    COUNT(*) 'Order Frequency',
    SUM(list_price*(1-discount)*quantity) 'Total Amount of Ordered' -- Hint: when testing for customerID=1 and get 17, then the query is not correct 
    FROM sales.orders so
    JOIN sales.stores ss
        on ss.store_id=so.store_id
    JOIN sales.order_items oi 
        on oi.order_id=so.order_id
    where customer_id = 1
    group by store_name
    ;

-- when using BEGIN & END? When using IF & ELSE and inside them there're more than 1 line of code.

/* Q2 v1
Create a stored procedure that when passed a state returns the store, list of employees and
the name of the manager. Ino store in that state, print a message.
*/

drop PROCEDURE if exists Q2;
GO
create or alter procedure Q2(@state VARCHAR(2))
AS      
    if @state NOT IN (SELECT [state] from sales.stores)
        throw 50001, 'There is no store in this state', 1;
GO
exec Q2 MN


    


/* Q4 v1
Create a function that when passed productid, return the total quantity that the product was
ordered. a. Use the function in a SELECT to return the number of products bought by each
customer
*/