/*
OUTPUT parameter
Create a sp that given a VendorID returns the number of orders and the total 
invoice.

Create a new table called InvoiceReport with the following columns:
VendorID, NumberOfOrders, TotalInvoice, DateOfInquery

I want to store the result of the sp in this table. How can I do that?

---------------------------------------------------------------------
*/
--Creating a table

CREATE TABLE InvoiceReport (
	ID int PRIMARY KEY IDENTITY (1,1),
	VendorID int,
	NumberOfOrders int, 
	TotalInvoice money,
	DateOfInquery date
)

SELECT * FROM InvoiceReport
----------------------------------------------------------------------
GO
--SP that given a vendorID returns the count and total invoices
ALTER PROC spInvoiceStatus
	@VendorID int,
	@numinvoice int OUTPUT,
	@totalinvoice money OUTPUT
AS

SELECT @numinvoice=COUNT(*), @totalinvoice=SUM(InvoiceTotal)
FROM Invoices
WHERE VendorID=@VendorID

RETURN 
------------------------------------------------
--In order to exec a stored procedure that needs OUTPUT parameters you need to declare
--variables first

DECLARE @countI int, @TotalI money
EXEC spInvoiceStatus 37, @countI OUTPUT, @TotalI OUTPUT
--PRINT @countI
--PRINT @TotalI
-----------------------------------------------
--we can use those variables in an INSERT INTO clasue
INSERT INTO InvoiceReport
VALUES(37,@countI,@TotalI,GETDATE())

------------------------------------------------
--We can now create a stored procedure to do the insert into
GO
CREATE PROC spInsertInvoiceReport
	@VendorID int,
	@CountofInvoice int,
	@TotalInvoice money
AS

INSERT INTO InvoiceReport
VALUES(@VendorID,@CountofInvoice,@TotalInvoice,GETDATE())

PRINT 'Invoice report added successfully'
RETURN 
-----------------------------------------------------------

--OPTION 2
--Executing the two stored procedures

DECLARE @vendorID int, @countI int, @TotalI money
--Change this number to the vendor you want to get an invoice report
SELECT @VendorID =1
EXEC spInvoiceStatus @vendorID, @countI OUTPUT, @TotalI OUTPUT
EXEC spInsertInvoiceReport @vendorID, @countI, @TotalI
--------------
--OPTION 3
--Create a stored procedure that would call the two stored procedure
GO
ALTER PROC  InvoiceReportV2
	@vendorID int
AS 

DECLARE @countI int, @TotalI money
--Change this number to the vendor you want to get an invoice report
EXEC spInvoiceStatus @vendorID, @countI OUTPUT, @TotalI OUTPUT
EXEC spInsertInvoiceReport @vendorID, @countI, @TotalI
RETURN 
-----------------------------------------------------
EXEC InvoiceReportV2 27

SELECT * FROM InvoiceReport

-------------------------------------------------
--OPTION 3
--create one stored procedure that does all of that 
GO
ALTER PROC CalcualteANDInsert
	@VendorID int
AS 

DECLARE @numinvoice int, @totalinvoice MONEY
SELECT @numinvoice=COUNT(*), @totalinvoice=SUM(InvoiceTotal)
FROM Invoices
WHERE VendorID=@VendorID

INSERT INTO InvoiceReport
VALUES(@VendorID,@numinvoice,@totalinvoice,GETDATE())

PRINT 'Report added successfully'
SELECT * FROM InvoiceReport

RETURN

--
EXEC CalcualteANDInsert 4100
---------------------------------------------------------
/*
Murach College

1- Create a stored procedure that when passed a course number returns the number of
students enrolled. If the course number doesn�t exist display a message. Write the
code to execute the stored procedure for course number: 82754
2- Create a stored procedure that returns the list of departments and the name of the
chairs. Execute the stored procedure.
3- Create a stored procedure that when passed an optional year returns all the
instructors that have been hired since then. The result should have 4 columns: ID,
Name, Department name, Years hired. If no new instructors have been hired display
a message rather than an empty table. Execute the stored procedure once with no
parameter and once for 2018.
4- Create a stored procedure that will be used to add a new record to the students
table. Use the current date for Enrollment Date.
*/