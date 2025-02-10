Use AP;
--int, money, date, datetime, varchar, char
DECLARE @x int, @y money
SELECT @x=2
PRINT @x
------
SELECT SUM(InvoiceTotal), COUNT(*)
FROM Invoices

--There are 114 invoices and the total amount is $214,290.51

DECLARE @TotalInvoice money, @NumofInvoice int
SELECT @TotalInvoice=SUM(InvoiceTotal), @NumofInvoice=COUNT(*)
FROM Invoices
--CONVERT (varchar ,@NumofInvoice )
--CAST(@NumofInvoice AS varchar)
PRINT 'There are '+CONVERT (varchar ,@NumofInvoice ) +' invoices and the total amount is $'+CONVERT(varchar,@TotalInvoice,1)
PRINT CONCAT('There are ',@NumofInvoice,' invoices and the total amount is $',@TotalInvoice)
-------------
/*
Create a script that given a vendorID will check to see if there are any invoices
for that vendor
if there are no invoices, return a message that says no invoice found
if there are invoices, return a message that shows the number of invoices
as well as the total amount of invoice
*/
GO
--Declare a variable to store the vendorID
DECLARE @VendorID int
SELECT @VendorID=34 -- I can change this value if I want a different vendorID
--SELECT query to check and see if there are any invoices for that vendor
--SELECT COUNT(*)
--FROM Invoices
--WHERE VendorID=@VendorID
--IF there are no invoices
IF (SELECT COUNT(*) FROM Invoices WHERE VendorID=@VendorID)=0
	--PRINT no invoice found
	PRINT 'No Invoice Found'
--ELSE
ELSE
	--Print a message showing the count and total invoice amount
	BEGIN
		DECLARE @TotalInvoice money, @NumofInvoice int
		SELECT @TotalInvoice=SUM(InvoiceTotal), @NumofInvoice=COUNT(*)
		FROM Invoices
		WHERE VendorID=@VendorID
		PRINT 'There are '+CONVERT (varchar ,@NumofInvoice ) +' invoices and the total amount is $'+CONVERT(varchar,@TotalInvoice,1)
	END

---------------------------------------
GO
ALTER PROC spUnpaidInvoices
--add parameters
AS
	SELECT InvoiceID, VendorID, InvoiceTotal-PaymentTotal-CreditTotal AS Balance
	FROM Invoices
	WHERE InvoiceTotal-PaymentTotal-CreditTotal <> 0 
	---
	DECLARE @countunpaid int
	SELECT @countunpaid=COUNT(*)
	FROM Invoices
	WHERE InvoiceTotal-PaymentTotal-CreditTotal <> 0 
	PRINT CONCAT(@countunpaid, ' unpaid invoices')

RETURN
EXEC spUnpaidInvoices 
---------------
GO
CREATE PROC InvoiceStatus
	@vendorID int
AS

IF (SELECT COUNT(*) FROM Invoices WHERE VendorID=@VendorID)=0
	--PRINT no invoice found
	PRINT 'No Invoice Found'
--ELSE
ELSE
	--Print a message showing the count and total invoice amount
	BEGIN
		DECLARE @TotalInvoice money, @NumofInvoice int
		SELECT @TotalInvoice=SUM(InvoiceTotal), @NumofInvoice=COUNT(*)
		FROM Invoices
		WHERE VendorID=@VendorID
		PRINT 'There are '+CONVERT (varchar ,@NumofInvoice ) +' invoices and the total amount is $'+CONVERT(varchar,@TotalInvoice,1)
	END
RETURN 
EXEC InvoiceStatus 1