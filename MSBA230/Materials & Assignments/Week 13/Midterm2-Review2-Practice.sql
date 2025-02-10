USE BikeStores;

/* Q1
Create a stored procedure that when passed a letter, does the following:
a. Return all the brands that start with that letter, the number of products in that brand
and the number of stores that carry that brand.
b. If there are no brands starting with that letter display a message.
*/
drop PROCEDURE if EXISTS M2P2Q1;
GO
CREATE or alter proc M2P2Q1
    @letter char(1) -- passing a letter
AS
    /* a */
    select 
        b.brand_id,
        b.brand_name,
        count(distinct p.product_id) 'Number of Products', -- a product_id can be in multiple stores
        count(distinct store_id) 'Number of Stores'
    from production.products p
    JOIN production.brands b on b.brand_id = p.brand_id
    join production.stocks s on s.product_id = p.product_id
    where brand_name LIKE @letter+'%' -- '['+@startletter+']%'
    group by b.brand_id,
        b.brand_name
 
EXEC M2P2Q1 s

    -- select 
    --     b.brand_name,
    --     count(distinct p.product_id) 'Number of Products', 
    --     count(distinct store_id) 'Number of Stores'

    -- from production.products p
    -- JOIN production.brands b on b.brand_id = p.brand_id
    -- join production.stocks s on s.product_id = p.product_id
    -- where brand_name LIKE 's%'
    -- group by 
    --     b.brand_name


/* Q2
Create a stored procedure that a when passed a store ID returns all the products that have
an inventory of 10 or lower. Display a message as well that specifies the number of products
with low inventory in that specific store.
*/
go
CREATe or alter proc M2P2Q2
    @storeid INT 
AS 
    --check if store exists
    IF @storeID NOT IN (SELECT store_id FROM [sales].[stores])
        THROW 50000, 'Store ID not valid',1

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

    PRINT CONCAT('There are ',@countlowinventory, ' low inventory products in ',@storename, ' store.')