/* Question 1:
Create a stored procedure called spM1 that accepts a VendorID as input and returns all invoices for that vendor. 
Additionally, include a message specifying the total number of invoices as well as the total amount of invoice for that vendor. 
If the vendor doesn’t have any invoices, display an appropriate message. If the vendor ID does not exist, raise an error.
     Exec for vendorID of 1, 95, 125
*/
USE AP; -- Set the database
GO

DROP proc IF EXISTS spM1; -- Drop procedure spM1 if it exists
GO

CREATE OR ALTER proc spM1 -- Create or Alter procedure spM1
    @VendorID INT 
AS 

    /* error message if VendorID NOT exists on both Vendors and Invoices tables*/
    IF @VendorID NOT IN (select VendorID from Vendors ) -- check if VendorID exists on Vendors table
        THROw 50002, 'The VendorID does NOT exist in the Vendors table.', 1
    IF @VendorID NOT IN (select VendorID from Invoices) -- check if VendorID exists on Invoices table
        THROW 50001, 'The VendorID does NOT exist in the Invoices table.', 1

    /* returns all invoices for the VendorID */
    SELECT i.* 
    FROM Invoices i 
    JOIN Vendors v ON i.VendorID=v.VendorID
    WHERE v.VendorID = @VendorID;

    /* declare variables for a message */
    DECLARE @totalInvoices INT, -- the total number of invoices. count()
        @totalInvoiceAmount INT -- the total amount of invoice for that vendor. sum()
    ;

    /* SELECT for Message */
    SELECT @totalInvoices = COUNT(*) FROM Invoices WHERE VendorID=@VendorID ;
    SELECT @totalInvoiceAmount = SUM(InvoiceTotal) FROM Invoices WHERE VendorID=@VendorID;
    

    /* Display Message */
    PRINT CONCAT('The total number of invoices: ', @totalInvoices, '. The total amount of invoice for that vendor: $', @totalInvoiceAmount)

GO

/* EXECUTIONS */
EXEC spM1 1;
EXEC spM1 95;
EXEC spM1 125;

EXEC spM1 122;
GO

/* Question 2
Create a scalar-valued function named fnM2 that takes an AccountNo as input and returns the total unpaid balance for that account.
      Use the function in a SELECT query to retrieve the Account Descriptions of the top 3 accounts with the highest unpaid balances.
*/
     
DROP FUNCTION IF EXISTS fnM2; -- Drop function fnM2 if it exists
GO

CREATE or ALTER function fnM2(@AccountNo INT) -- Create or Alter function fnM2 with input
RETURNS INT -- returning an int
BEGIN
    RETURN (

        SELECT 
            SUM(InvoiceTotal - PaymentTotal - CreditTotal) 'Unpaid Amount'
        FROM Invoices i 
        JOIN InvoiceLineItems li 
            ON i.InvoiceID=li.InvoiceID
        WHERE AccountNo = @AccountNo
        GROUP BY AccountNo
        HAVING SUM(InvoiceTotal - PaymentTotal - CreditTotal)> 0
        
    )
END

GO

/* Calling the func fnM2 and display AccountNO */
SELECT 
    DISTINCT top 3 
    li.AccountNO, 
    -- AccountDescription, 
    dbo.fnM2(li.AccountNo) 'Unpaid Amount' -- the returns amount will be around up to the 
FROM InvoiceLineItems li 
JOIN [dbo].[GLAccounts] gl on li.AccountNo=gl.AccountNo
ORDER BY 'Unpaid Amount' DESC;


GO
/* Calling the func fnM2 and display AccountDescription */
SELECT 
    DISTINCT top 3 
    -- li.AccountNO, 
    AccountDescription, 
    dbo.fnM2(li.AccountNo) 'Unpaid Amount' -- the returns amount will be around up to the 
FROM InvoiceLineItems li 
JOIN [dbo].[GLAccounts] gl ON li.AccountNo=gl.AccountNo
ORDER BY 'Unpaid Amount' DESC;


---------------------------------------- TESTING QUERIES --------------------------------------------
-- select AccountNo,
--             sum(InvoiceTotal - PaymentTotal - CreditTotal) Unpaid
--         from Invoices i 
--         join InvoiceLineItems li 
--             on i.InvoiceID=li.InvoiceID
--         where AccountNo = 553
--         group by AccountNo
--         having sum(InvoiceTotal - PaymentTotal - CreditTotal)> 0;


-- select top 5 * 
-- from InvoiceLineItems;

-- select distinct AccountNo from InvoiceLineItems;

-- select AccountNo,
--     sum(InvoiceTotal - PaymentTotal - CreditTotal) Unpaid
-- from Invoices i 
-- join InvoiceLineItems li 
--     on i.InvoiceID=li.InvoiceID
-- where AccountNo = 553
-- group by AccountNo
-- having sum(InvoiceTotal - PaymentTotal - CreditTotal)> 0;

-- select * from Invoices where VendorID = 122

-- SELECT sum(InvoiceTotal)
-- FROM Invoices 
-- where VendorID=122;
-- select * FROM Invoices
