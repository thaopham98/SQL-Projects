USE AP;
/*  Chapter 3   */
/*  1   */
-- SELECT
--     VendorContactFName,
--     VendorContactLName,
--     VendorName
-- FROM Vendors
-- ORDER BY VendorContactLName, VendorContactFName;

/*  2   */
-- SELECT
--     InvoiceNumber AS 'Number',
--     InvoiceTotal AS 'Total',
--     PaymentTotal + CreditTotal AS 'Credits',
--     InvoiceTotal - (PaymentTotal + CreditTotal) AS 'Balance'
-- FROM Invoices;

/*  3   */
-- SELECT
--     VendorContactLName +', '+ VendorContactFName  AS 'Full Name'
-- FROM Vendors
-- ORDER BY VendorContactLName, VendorContactFName;

/*  4   */
-- SELECT 
--     InvoiceTotal, 
--     InvoiceTotal / 10 AS '10%',
--     InvoiceTotal * 1.1 AS 'Plus 10%'
-- FROM Invoices
-- WHERE InvoiceTotal - PaymentTotal - CreditTotal > 100
-- ORDER BY InvoiceTotal DESC;

/*  5   */
-- SELECT
--     InvoiceNumber AS 'Number',
--     InvoiceTotal AS 'Total',
--     PaymentTotal + CreditTotal AS 'Credits',
--     InvoiceTotal - (PaymentTotal + CreditTotal) AS 'Balance'
-- FROM Invoices
-- WHERE 
--     InvoiceTotal BETWEEN 500 AND 10000;

/*  6   */
-- SELECT
--     VendorContactLName +', '+ VendorContactFName  AS 'Full Name'
-- FROM Vendors
-- WHERE VendorContactLName LIKE '[A,B,C,E]%'
-- ORDER BY VendorContactLName, VendorContactFName;

/*  7   */
-- SELECT *
-- FROM Invoices
-- WHERE ((InvoiceTotal - PaymentTotal - CreditTotal <= 0) 
--         AND
--         PaymentDate IS NULL) 
--       OR
--       ((InvoiceTotal - PaymentTotal - CreditTotal > 0) 
--         AND
--         PaymentDate IS NOT NULL);

/*  Chapter 4   */
/*  1   */
-- SELECT *
-- FROM Vendors
-- INNER JOIN Invoices ON Vendors.VendorID = Invoices.VendorID;

/*  2   */
-- SELECT 
--     VendorName, 
--     InvoiceNumber,
--     InvoiceDate, 
--     InvoiceTotal - PaymentTotal - CreditTotal AS 'Balance'
-- FROM Vendors v
-- JOIN Invoices i ON v.VendorID = i.VendorID
-- WHERE InvoiceTotal - PaymentTotal - CreditTotal > 0 
-- ORDER BY VendorName;

/*  3   */
-- SELECT
--     VendorName, 
--     DefaultAccountNo, 
--     AccountDescription
-- FROM Vendors v 
-- JOIN GLAccounts g ON v.DefaultAccountNo = g.AccountNo 
-- ORDER BY AccountDescription, VendorName;

/*  4   */
-- SELECT 
--     VendorName, 
--     InvoiceNumber,
--     InvoiceDate, 
--     InvoiceTotal - PaymentTotal - CreditTotal AS 'Balance'
-- FROM Vendors, Invoices
-- WHERE
--     Vendors.VendorID = Invoices.VendorID
--     AND 
--     InvoiceTotal - PaymentTotal - CreditTotal > 0 
-- ORDER BY VendorName;

/*  5   */
-- SELECT
--     VendorName AS 'Vendor',
--     InvoiceDate AS 'Date',
--     InvoiceNumber AS 'Number',
--     InvoiceSequence AS '#',
--     InvoiceLineItemAmount AS 'LineItem'
-- FROM Vendors v 
-- JOIN Invoices i on v.VendorID = i.VendorID
-- JOIN InvoiceLineItems Ii on i.InvoiceID = Ii.InvoiceID
-- ORDER BY Vendor,Date,Number,#,LineItem;

/*  6   */
-- SELECT
--     v1.VendorID,
--     v1.VendorName,
--     v1.VendorContactFName +' ' + v1.VendorContactLName AS 'Name' 
-- FROM Vendors v1
-- JOIN Vendors v2 ON (v1.VendorID <> v2.VendorID) 
--       AND
--       (v1.VendorContactFName = v2.VendorContactFName)
-- ORDER BY Name;

/*  7   */
-- SELECT
--     g.AccountNo,
--     g.AccountDescription
-- FROM GLAccounts g
-- LEFT JOIN InvoiceLineItems i ON g.AccountNo=i.AccountNo
-- WHERE i.InvoiceID is null
-- ORDER BY g.AccountNo; 

/*  8   */
--     SELECT 
--         VendorName,
--         VendorState
--     FROM Vendors 
--     WHERE VendorState = 'CA'
-- UNION 
--     SELECT 
--         VendorName,
--         'Outside CA' AS VendorState 
--     FROM Vendors 
--     WHERE VendorState <> 'CA'
-- ORDER BY VendorName;