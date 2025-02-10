USE AP;

/*   5   */
/* Create SCALAR-value function */
DROP FUNCTION IF EXISTS fnUnpaidInvoiceID;
GO
CREATE FUNCTION fnUnpaidInvoiceID()
RETURNS int 
--     /* this RETURN must return a single value */ 
BEGIN
    RETURN -- return the InvoiceID of the earliest invoice w/ an unpaid balance
    (   /* get 1 single InvoiceID */
        SELECT MIN(InvoiceID)
        FROM Invoices
        WHERE InvoiceTotal - CreditTotal - PaymentTotal > 0 -- unpaid balance
        AND -- earliest invoice of unpaid balance
            InvoiceDueDate =
            (SELECT MIN(InvoiceDueDate)
            FROM Invoices
            WHERE InvoiceTotal - CreditTotal - PaymentTotal > 0)
    );
END;

/* Calling fnUnpaidInvoiceID */
GO
SELECT 
    VendorName, 
    InvoiceNumber, 
    InvoiceDueDate,
    InvoiceTotal - CreditTotal - PaymentTotal AS Balance
FROM Vendors 
JOIN Invoices
ON vendors.vendorID = Invoices.vendorID
WHERE InvoiceID = dbo.fnUnpaidinvoiceID();

-- select * from Invoices


/*   6   */
DROP FUNCTION IF EXISTS fnDateRange;
GO
/* Create TABLE-value function */
CREATE FUNCTION fnDateRange
    (@DateMin date,
    @DateMax date)
RETURNS table
/* Return a result set*/
RETURN 
(
    SELECT 
        InvoiceNumber, 
        InvoiceDate,
        InvoiceTotal,
        InvoiceTotal - CreditTotal - PaymentTotal AS Balance
    FROM Invoices
    WHERE InvoiceDate Between @DateMin and @DateMax 
);

/* Calling fnDateRange */
GO
SELECT *
FROM dbo.fnDateRange
('2015/12/10','2015/12/20');
-- ('2019/12/10','2019/12/20'); -- since the current AP db only contains data 2019-2020


/*   7   */
SELECT 
    VendorName,
    i.InvoiceNumber, 
    i.InvoiceDate,
    i.InvoiceTotal,
    Balance
FROM Invoices i 
JOIN Vendors v 
    ON v.VendorID = i.VendorID
JOIN dbo.fnDateRange
    ('2015/12/10','2015/12/20') 
    -- ('2019/12/10','2019/12/20') -- for testing
    AS dr 
    ON dr.InvoiceNumber = i.InvoiceNumber