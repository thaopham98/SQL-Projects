USE AP;
SELECT * FROM Vendors;
SELECT * FROM Invoices;

/*   1   */
DROP PROCEDURE IF EXISTS spBalanceRange;
GO

CREATE PROC spBalanceRange
       @VendorVar varchar(50) = '%',
       @BalanceMin money = 0,
       @BalanceMax money = 0
AS
    IF @BalanceMax = 0
        BEGIN
            SELECT 
                VendorName, 
                InvoiceNumber,
                InvoiceTotal - CreditTotal - PaymentTotal AS Balance
            FROM Vendors v 
            JOIN Invoices i
                ON v.VendorID = i.VendorID
            WHERE VendorName LIKE @VendorVar AND
                (InvoiceTotal - CreditTotal - PaymentTotal) > 0 AND
                (InvoiceTotal - CreditTotal - PaymentTotal) >= @BalanceMin
            ORDER BY Balance DESC -- largest Balance due
        END
    
    ELSE
    BEGIN
        SELECT 
            VendorName, 
            InvoiceNumber,
            InvoiceTotal - CreditTotal - PaymentTotal AS Balance
        FROM Vendors v
        JOIN Invoices i
            ON v.VendorID = i.VendorID
        WHERE VendorName LIKE @VendorVar 
            AND (InvoiceTotal - CreditTotal - PaymentTotal) > 0 
            AND (InvoiceTotal - CreditTotal - PaymentTotal)
            BETWEEN @BalanceMin AND @BalanceMax
        ORDER BY Balance DESC -- largest Balance due
    END

EXEC spBalanceRange 'C%';
EXEC spBalanceRange 'F%',0,70;
/*   2   */
GO;
/* a */
EXEC spBalanceRange 'M%';

/* b */
EXEC spBalanceRange @BalanceMin = 200, @BalanceMax = 1000;

/* c */
EXEC spBalanceRange '[C,F]%', 0, 200; -- @VendorVar, @BalanaceMin, @BalanceMax

/*   3   */
DROP PROCEDURE IF EXISTS spDateRange;
GO

CREATE PROC spDateRange
       @DateMin varchar(50) = NULL,
       @DateMax varchar(50) = NULL
AS
    /* Conditions */
    IF @DateMin IS NULL OR @DateMax IS NULL
        THROW 50001, 'The DateMin and DateMax parameters are required.', 1;
    IF NOT (ISDATE(@DateMin) = 1 AND ISDATE(@DateMax) = 1)
        THROW 50001, 'Invalid format. Please try this format mm/dd/yyyy.', 1;
    IF CAST(@DateMin AS date) > CAST(@DateMax AS date)
        THROW 50001, 'DateMin must be earlier than DateMax', 1;

    SELECT 
        InvoiceNumber, 
        InvoiceDate, 
        InvoiceTotal,
        InvoiceTotal - CreditTotal - PaymentTotal AS Balance
    FROM Invoices
    WHERE InvoiceDate 
        BETWEEN 
        @DateMin 
        AND 
        @DateMax
    ORDER BY InvoiceDate;
    
EXEC spDateRange ; -- The DateMin and DateMax parameters are required
EXEC spDateRange '11/04/2018', '11/04/2019'; -- correct input
EXEC spDateRange '2021/1/4', '2024/1/0' -- Invalid format. Please use mm/dd/yy
EXEC spDateRange '11/04/2024', '11/04/2021'; -- DateMin must be earlier than DateMax

/*   4   */
BEGIN TRY
	EXEC spDateRange '2019-10-10', '2020-10-20'; -- since my db only has from 2019 - 2020
    -- EXEC spDateRange ; -- The DateMin and DateMax parameters are required
    -- EXEC spDateRange '2021/1/4', '2024/1/0' -- Invalid format. Please use mm/dd/yy
    -- EXEC spDateRange '11/04/2024', '11/04/2021'; -- DateMin must be earlier than DateMax
END TRY
    BEGIN CATCH
        PRINT 'Error Number:  ' + CONVERT(varchar(100), ERROR_NUMBER());
        PRINT 'Error Message: ' + CONVERT(varchar(100), ERROR_MESSAGE());
    END CATCH;