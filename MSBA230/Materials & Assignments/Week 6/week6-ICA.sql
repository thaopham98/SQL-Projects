-- select count(*), SUM(InvoiceTotal)
-- from Invoices

/* Return the vendor city and number of vendor in each city*/
-- SELECT
--     VendorCity, 
--     COUNT(VendorCity) AS [Number of vendors in each city]
-- FROM Vendors
-- GROUP BY VendorCity

/* Return the year and total amount of invoices*/
-- select
--     -- *
--     YEAR(InvoiceDate) AS 'Year of Invoice',
--     SUM(InvoiceTotal) AS 'Total Amount of Invoices'
-- FROM Invoices
-- group by YEAR(InvoiceDate);

/* Return the vendor with the highest amount of invoice */
SELECT 
    TOP 1 VendorID,
    SUM(InvoiceTotal) AS 'Vendor with the Highest Invoices'
FROM Invoices
GROUP BY VendorID
ORDER by VendorID Desc;