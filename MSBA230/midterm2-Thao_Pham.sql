/* Question 1
Create a stored procedure called spM1 that accepts a VendorID as input and returns all invoices for that vendor. 
Additionally, include a message specifying the total number of invoices as well as the total amount of invoice for that vendor. 
If the vendor doesn’t have any invoices, display an appropriate message. If the vendor ID does not exist, raise an error.
    Exec for vendorID of 1, 95, 125
*/
USE AP;
GO

/* Dropping the SP spM1 if exists */
DROP proc IF EXISTS spM1;
GO

/* Creating the SP spM1 */
CREATE OR alter proc spM1
    @VendorID INT -- input VendorID 
AS 

    /* error messages if VendorID NOT exists */
    IF @VendorID NOT IN (select VendorID from Vendors) -- if the @VendorID does NOT exists in Vendors table 
        THROw 50002, 'The VendorID does NOT exist in the Vendors table.', 1
    IF @VendorID NOT IN (select VendorID from Invoices) -- if the @VendorID does NOT exists in Invoices table
        THROW 50001, 'The VendorID does NOT exist in the Invoices table.', 1

    /* Returning all invoices of that vendor */
    SELECT i.* 
    FROM Invoices i 
    JOIN Vendors v ON i.VendorID=v.VendorID
    WHERE v.VendorID = @VendorID;

    /* Declaring local variables for a message */
    DECLARE @totalInvoices INT, -- the total number of invoices for that vendor. count()
        @totalInvoiceAmount INT -- the total amount of invoice for that vendor, aka money . sum()
    ;

    /* SELECT clauses for Message */
    SELECT @totalInvoices = count(*)
    FROM Invoices 
    WHERE VendorID = @VendorID;
    
    SELECT @totalInvoiceAmount = SUM(InvoiceTotal) -- the total amount of money of all the invoices 
    FROM Invoices
    WHERE VendorID=@VendorID;

    /* Display Message */
    PRINT CONCAT('The total number of invoices: ', @totalInvoices, '. The total amount of invoice for that vendor: $', @totalInvoiceAmount)

GO

/* EXEC the SP */
EXEC spM1 1;
EXEC spM1 95;
EXEC spM1 125;

EXEC spM1 122;
GO

/* Question 2
Create a scalar-valued function named fnM2 that takes an AccountNo as input and returns the total unpaid balance for that account.
Use the function in a SELECT query to retrieve the Account Descriptions of the top 3 accounts with the highest unpaid balances.
*/

/* Dropping the function if exists */
DROP FUNCTION IF EXISTS fnM2;
GO

/* Creating the function fnM2 */
CREATE or ALTER function fnM2
    (@AccountNo INT) -- input parameter
RETURNS INT -- return type
BEGIN
    RETURN (

        SELECT 
            SUM(InvoiceTotal - PaymentTotal - CreditTotal) 'Unpaid Amount'
        FROM Invoices i 
        JOIN InvoiceLineItems li 
            ON i.InvoiceID = li.InvoiceID
        WHERE AccountNo = @AccountNo
        GROUP BY AccountNo
        HAVING SUM(InvoiceTotal - PaymentTotal - CreditTotal) > 0 -- still own money, aka UNPAID balance
    )
END

GO

/* Calling the func fnM2 in SELECT and displaying AccountNO and AccountDescription */
SELECT 
    DISTINCT TOP 3 -- the top 3 
    li.AccountNO, 
    AccountDescription,
    dbo.fnM2(li.AccountNo) 'Unpaid Amount' -- the returns amount will be around up
FROM InvoiceLineItems li 
JOIN [dbo].[GLAccounts] gl 
    ON li.AccountNo=gl.AccountNo
ORDER BY 'Unpaid Amount' DESC; -- highest to lowest unpaid balance

GO 
----------------------------------------------- TESTING QUERIES -----------------------------------------------

/* Calling the func fnM2 and displaying AccountNO */
-- select 
--     distinct top 3 
--     li.AccountNO, 
--     -- AccountDescription, 
--     dbo.fnM2(li.AccountNo) 'Unpaid Amount' -- the returns amount will be around up
-- from InvoiceLineItems li 
-- join [dbo].[GLAccounts] gl on li.AccountNo=gl.AccountNo
-- order by 'Unpaid Amount' DESC;


-- GO

/* Calling the func fnM2 and displaying AccountDescription */
-- select 
--     distinct top 3 
--     -- li.AccountNO, 
--     AccountDescription, 
--     dbo.fnM2(li.AccountNo) 'Unpaid Amount' -- the returns amount will be around up
-- from InvoiceLineItems li 
-- join [dbo].[GLAccounts] gl on li.AccountNo=gl.AccountNo
-- order by 'Unpaid Amount' DESC;

--
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
