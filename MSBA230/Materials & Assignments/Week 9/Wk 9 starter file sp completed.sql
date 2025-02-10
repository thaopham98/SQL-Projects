/*
1- Create a PROC to return all the unpaid invoices

2- Create a PROC that given a state returns all the vendors in that state

3- Change #2 so that state is optional and if not provided returns all the vendors.

4- Change #3 to display a message if no vendors are found in that state. 

5- Create a PROC that given a vendorid will return all the unpaid invoices for that vendor. (Check for 37)
  
6- Alter #4 to display a message such as : There are 1 unpaid invoice for vendor id 37

7- Create a PROC that given 2 dates returns all in invoices during that time.

8- Create a PROC that given a vendor ID, returns the number of unpaid invoices along with the total balance for that vendor

*/
--Q1
CREATE PROC spUnpaidInvoices
AS
	SELECT *
	FROM Invoices
	WHERE InvoiceTotal-PaymentTotal-CreditTotal > 0
RETURN
---
EXEC spUnpaidInvoices
-------------------------------
GO
--Q2
CREATE PROC spStateVendors
	@State char(2)
AS
	SELECT *
	FROM Vendors
	WHERE VendorState=@State
RETURN
--
EXEC spStateVendors 'CA'
----------------------------
GO
--Q3
--In order to make a parameter optional you have to give it a default value
ALTER PROC spStateVendors
	@State varchar(2) = '%'
AS
	SELECT *
	FROM Vendors
	WHERE VendorState LIKE @State
RETURN
--
EXEC spStateVendors 'LA'
---

DECLARE @x char(20)
SELECT @x ='a'
PRINT TRIM(@x)

--

GO
ALTER PROC spStateVendors
	@State char(2) = NULL --optional since it has a default value 
AS

IF @State IS NULL
	SELECT * FROM Vendors
ELSE
	SELECT * FROM Vendors WHERE VendorState = @State
RETURN
----
GO
--Q4
ALTER PROC spStateVendors
	@State varchar(2) = '%'
AS
--count the number of vendors for the state, if the count is 0, print a message

IF (SELECT COUNT(*) FROM Vendors WHERE VendorState LIKE @State) =0
	PRINT 'No vendor found for ' + @State	
ELSE
	BEGIN
		SELECT *
		FROM Vendors
		WHERE VendorState LIKE @State
	END
RETURN
--
EXEC spStateVendors 'CA'
------------------------------------------
GO

--Q5
IF OBJECT_ID('spUnpaidforvendor', 'P') IS NOT NULL
    DROP PROCEDURE spUnpaidforvendor
GO
CREATE PROC spUnpaidforvendor
	@vendorID int
AS
	BEGIN
		-- Check if the vendor exists
		IF (SELECT COUNT(*) FROM Vendors WHERE VendorID = @vendorID) = 0
		BEGIN
			PRINT 'VendorID ' + CAST(@vendorID AS varchar) + ' not found. Please add a correct VendorID'
			RETURN
		END

		-- Check if there are unpaid invoices for the vendor
		IF (SELECT COUNT(*) FROM Invoices WHERE VendorID = @vendorID AND InvoiceTotal - PaymentTotal - CreditTotal > 0) = 0
		BEGIN
			PRINT 'No unpaid invoices for VendorID ' + CAST(@vendorID AS varchar)
			RETURN
		END

		-- If there are unpaid invoices, return them
		SELECT *
		FROM Invoices
		WHERE InvoiceTotal - PaymentTotal - CreditTotal > 0 AND VendorID = @vendorID
	END
EXEC spUnpaidforvendor 37
----------------------------------------
/*
HOMEWORK DUE FRIDAY 10/25/2024:
Update Q5:
- if the vendor doesn't exist it displays a message such as 
VendorID @vendorID not found. Please add a correct VendorID

-if there no unpaid invoices for a vendorID display a messge:
No unpaid invoices for VendorID 1

*/

-- Q5

/*
complete Q6 and Q8 as well

*/

---------------------------------------
GO
--Q7
ALTER PROC spInvoiceDate
	@Date1 date,
	@Date2 date = NULL
	--I can't do @Date2 date =GETDATE() becuase getdate() is function and procedures don't let you assign a fucntion to a parameter
AS 

IF @Date2 IS NULL
	SELECT @Date2=GETDATE()

SELECT *
FROM Invoices
WHERE InvoiceDate BETWEEN @Date1 AND @Date2

RETURN 
--
EXEC spInvoiceDate '1/1/2008', '1/1/2020'