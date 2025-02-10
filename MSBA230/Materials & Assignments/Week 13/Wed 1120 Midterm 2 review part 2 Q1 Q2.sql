/*1. Create a stored procedure that when passed a letter, does the following:
a. Return all the brands that start with that letter, the number of products in that brand
and the number of stores that carry that brand.
b. If there are no brands starting with that letter display a message.*/

CREATE OR ALTER PROC P2Q1
	@startletter char(1)
	--@startletter char(3)
AS

	IF (SELECT COUNT(*) FROM [production].[brands] WHERE brand_name LIKE @startletter+'%') =0
	--IF NOT EXISTS (SELECT * FROM [production].[brands] WHERE brand_name LIKE @startletter+'%')
	--NOT EXISTS means if your SELECT returns an empty table
		BEGIN
			PRINT 'No brands starting with '+ @startletter + ' letter'
			RETURN
		END

	SELECT  brand_name, 
			COUNT(DISTINCT P.product_id) AS 'Number of products', 
			COUNT(DISTINCT store_id) AS 'Number of stores carrying the brand'
	FROM [production].[brands] B JOIN [production].[products] P ON B.brand_id=P.brand_id
								JOIN [production].[stocks] S ON S.product_id=P.product_id
	WHERE brand_name LIKE @startletter+'%'
	--WHERE brand_name LIKE '['+@startletter+']%'
	GROUP BY brand_name

-------------------------
EXEC P2Q1 s
--EXEC P2Q1 eso
--------------------------------------------------------------------------------------------------
/*2. Create a stored procedure that a when passed a store ID returns all the products that have
an inventory of 10 or lower. Display a message as well that specifies the number of products
with low inventory in that specific store.*/

GO
CREATE OR ALTER PROC P2Q2 
	@storeID int
AS

--check if store exists
IF @storeID NOT IN (SELECT store_id FROM [sales].[stores])
	THROW 50000, 'Store ID not valid',1
	--BEGIN 
	--	PRINT 'Store ID not valid'
	--	RETURN
	--END

/* returning the tables where store_id inventory is <= 10 */
SELECT P.*, quantity AS Inventory
FROM [production].[stocks] S JOIN [production].[products] P ON S.product_id=P.product_id
WHERE store_ID=@storeID AND quantity <=10

--Message: name of the store, count of low inventory products
DECLARE @storename varchar(50), @countlowinventory int

SELECT @storename = store_name
FROM [sales].[stores]
WHERE store_id=@storeID

SELECT @countlowinventory=COUNT(*)
FROM [production].[stocks] S JOIN [production].[products] P ON S.product_id=P.product_id
WHERE store_ID=@storeID AND quantity <=10

PRINT CONCAT('There are ', @countlowinventory, ' low inventory products in ',@storename, ' store.')
---------------------------------
EXEC P2Q2 20
EXEC P2Q2 3
--------------------------------------------------------------------------------------------------
/*
3. Create a function that when passed productid, return the total quantity that the product was
ordered.
a. Use the function in a SELECT to return the product names and the quantity they
were ordered.*/


/*
4. Create a function that when passed a storied returns the name of the main manager (the
manager that doesn�t have a manager).
a. Use the function in a SELECT query to return all the stores and the number of
mangers in each store.*/