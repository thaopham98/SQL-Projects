USE MyGuitarShop;

/*
Create a stored procedure called spFinal that given a ProductID does the following:

If the Product doesn’t exist, display a mesage. e.g. "Product doesn't exist"
If the Product hasn’t been ordered display a message e.g. “There are no orders for ibanez.”
Otherwise, return all the orders for that product and display a message saying 
how many units of that product have been sold. 

Bonus: Return the  number of units sold for that product as an output parameter.
*/
select * from Orders
select * from Products
select * from OrderItems

/* Create a procedure spFinal given a ProductID */
GO
-- DROP PROCEDURE spFinal; -- Dropping the procedure 
CREATE PROC spFinal
    @ProductID int
AS
    IF @ProductID NOT IN (SELECT ProductID FROM Products) -- If the Product doesn’t exist
        PRINT 'Product does not exist.'
    
    IF NOT EXISTS (SELECT * FROM Products 
                    JOIN OrderItems 
                    ON Products.ProductID=OrderItems.ProductID 
                    WHERE @ProductID=OrderItems.ProductID)-- If the Product hasn’t been ordered display a message
        PRINT 'There are no orders for ' + CONVERT(varchar,@ProductID)

        --  Otherwise, return all the orders for that product and display a message saying 
            SELECT * 
            FROM OrderItems oi 
            JOIN Products p 
            ON oi.ProductID=p.ProductID
            WHERE p.ProductID=@ProductID

        -- how many units of that product have been sold. 
            DECLARE @total int 
            SELECT  @total=sum(Quantity)
            FROM OrderItems
            WHERE @ProductID=ProductID 
            
            PRINT 'Number of product sold: ' + CONVERT(varchar,@total)


EXEC spFinal 100;



