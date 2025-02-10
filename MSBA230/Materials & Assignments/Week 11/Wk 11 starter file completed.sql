/*
CREATE FUNCTION function_name
[(pameter declaration)]
RETURNS data_type
WITH ENCRYPTION

BEGIN

RETURN scalar_expression
END
1- Create a fucntion that given a month will return total invoices in that month
	Call the function by printing the result

2- Create a function that passed a vendorid returns the total invoices for that vendor
	Call the function by printing the result
	Write a query that return all the vendors and the total invoices for each (use the function you just created)

3- Create a function that return all the vendors and their outstanding balance
	Call the function in a SELECT query

*/

--create a function that given a year returns the number of invoices 

CREATE FUNCTION fnNumInvoices
	(@year int)
RETURNS int
BEGIN 

DECLARE @countinvoice int
SELECT @countinvoice=COUNT(*)
		FROM Invoices
		WHERE YEAR(InvoiceDate)=@year

RETURN @countinvoice

END 
-------
PRINT dbo.fnNumInvoices(2020)
---------------------------------------------------
GO
CREATE FUNCTION fnTotalInvoicesYear
	(@year int)
RETURNS Table

RETURN (SELECT * FROM Invoices WHERE YEAR(InvoiceDate)=@year)

----
SELECT * FROM dbo.fnTotalInvoicesYear(2020)
--------
--create a function that given a vendorid and year returns the number of invoices
GO
CREATE FUNCTION fnInvoiceCountVY
	(@vendorid int, @year int)
RETURNS int
BEGIN

RETURN(SELECT COUNT(*)
FROM Invoices
WHERE VendorID=@vendorid AND YEAR(InvoiceDate)=@year)


END

--------

SELECT VendorName, dbo.fnInvoiceCountVY(VendorID, 2020)
FROM Vendors
ORDER BY dbo.fnInvoiceCountVY(VendorID, 2020) DESC