/*
Create a stored procedure that when passed a customer ID returns the store details, number
of times they ordered from that store and the total amount ordered. If CustomerID doesn�t
exist throw an error.
a. Exec for 6, 60, 2000 */
DROP PROCEDURE IF EXISTS Q1;
GO
CREATE OR ALTER PROC Q1
	@customerID int
AS

IF @customerID NOT IN (SELECT customer_id FROM sales.customers)
	THROW 50000, 'Customer does not exist',1


--returns the store details, 
--number of times they ordered from that store and 
--the total amount ordered
DECLARE @storename varchar(30), @countorders int, @totalamount money

SELECT @totalamount=SUM(list_price*(1-discount)*quantity ), 
	   @storename=store_name, 
	   @countorders=COUNT(DISTINCT OI.order_id)
FROM sales.orders sales JOIN sales.stores stores ON sales.store_id=stores.store_id
						JOIN sales.order_items OI ON OI.order_id=sales.order_id
WHERE customer_id=@customerID
GROUP BY store_name

PRINT CONCAT('There have been ',@countorders, ' orders from ', @storename, 
			' store and the total amount is $ ',@totalamount)

----------------------------------------------------------------------------------------
EXEC Q1 6
EXEC Q1 60
EXEC Q1 2000
----------------------------------------------------------------------------------------
/*Create a function that when passed productid, return the total quantity that the product was
ordered. 
a. Use the function in a SELECT to return the number of products bought .*/
DROP PROCEDURE IF EXISTS Q4;
GO

ALTER FUNCTION Q4 (@productID int)
RETURNS int
BEGIN

RETURN (SELECT SUM(quantity)
		FROM sales.order_items
		WHERE product_id=@productID)

END 
GO
----------------------------------------------------------------------------------------
SELECT product_name AS 'Product Name', dbo.Q4(product_id) AS 'Total quantity ordered'
FROM [production].[products]

