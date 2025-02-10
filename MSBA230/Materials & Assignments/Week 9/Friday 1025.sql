/*
Create a proc that given a vendorID checks to see if it exists and if so 
returns the vendor information

for the above proc store the exec in a variable and print -- what do you see

Create a proc to return the total number of invoices, return the value so 
it can be used outside of the procedure

Create the same proc but with OUTPUT parameter

*/

ALTER PROC CheckVendor
	@VendorID int
AS

--check if exist then return the vendor information

--IF NOT EXISTS (SELECT * FROM Vendors WHERE VendorID=@VendorID)

--IF (SELECT COUNT(*) FROM Vendors WHERE VendorID=@VendorID) = 0
/*
IF @VendorID NOT IN (SELECT VendorID FROM Vendors)
	PRINT 'VendorID not found'
ELSE
	SELECT * FROM Vendors WHERE VendorID=@VendorID
*/

IF @VendorID NOT IN (SELECT VendorID FROM Vendors)
	BEGIN
		PRINT 'VendorID not found'
		RETURN @vendorID --Exits out of the procedure
	END

PRINT 'yes'
SELECT * FROM Vendors WHERE VendorID=@VendorID
RETURN --return only returns an int and by default returns 0

----
DECLARE @x int
EXEC @x=CheckVendor 10000
PRINT @x

----------------------------------------
GO
ALTER PROC sp2020AvgInvoices
AS


DECLARE @avginvoice int
SELECT @avginvoice=AVG(InvoiceTotal) FROM Invoices WHERE YEAR(InvoiceDate)=2020
PRINT @avginvoice

RETURN @avginvoice


--
DECLARE @Avg2020 int
EXEC @Avg2020=sp2020AvgInvoices
PRINT @Avg2020 

--are they any vendors that they total incvoice in 2020 is greater than the avg 
SELECT VendorID, SUM(InvoiceTotal)
FROM Invoices 
WHERE YEAR(InvoiceDate)=2020 
GROUP BY VendorID 
HAVING SUM(InvoiceTotal) > @Avg2020


--
GO
CREATE PROC welcome
AS
PRINT 'Good Morning'
RETURN 


EXEC welcome