-- select *
-- from 
    -- Vendors
    -- Invoices
    -- GLAccounts
    -- InvoiceLineItems
    
-- ;


/*  HAVING (for Aggregates) */
-- select 
--     VendorState, 
--     count(VendorID) as 'State with more than 5 vendors'
-- from Vendors
-- group by VendorState
-- having count(VendorID)>5;

/*  Return the vendors that have at least 10 invoices in 20219*/
-- select 
--     VendorID, 
--     count(InvoiceID) AS [Invoices in 2019]
-- from Invoices
-- where YEAR(InvoiceDate) = '2019'
-- group by VendorID
-- having count(InvoiceID) >= 10;

/*  Which one of the AccountDescription  is  generating the most sales? */
-- SELECT
--     TOP 1
--     -- *
--     AccountDescription,
--     sum(il.InvoiceLineItemAmount) as [Total sales]
-- from GLAccounts as gl 
-- JOIN InvoiceLineItems il on gl.AccountNo=il.AccountNo
-- group by AccountDescription
-- -- having sum(il.InvoiceLineItemAmount) > 1
-- ORDER BY [Total sales] DESC
-- ;