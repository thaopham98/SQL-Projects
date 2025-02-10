-- USE AP ;

/*   Chapter 5   */
/*  Ex 1  */
-- select 
--     VendorID,
--     sum(PaymentTotal) AS PaymentSum
-- from Invoices
-- group by VendorID;

/*  Ex 2  */
-- select 
--     TOP 10 VendorName,
--     sum(PaymentTotal) AS PaymentSum
-- from Vendors v
-- join Invoices i on i.VendorID=v.VendorID
-- GROUP by VendorName
-- order by PaymentSum DESC;

/*  Ex 3  */
-- select
--     VendorName,
--     COUNT(InvoiceID) AS InvoiceCount,
--     SUM(InvoiceTotal) AS InvoiceSum
-- from Invoices
-- join Vendors on Invoices.VendorID = Vendors.VendorID
-- group by VendorName
-- order by InvoiceCount Desc
-- ;

/*  Ex 4  */
-- select 
--     AccountDescription, 
--     count(ilt.InvoiceID) [LineItemCount],
--     SUM(ilt.InvoiceLineItemAmount) [LineItemSum]
-- from GLAccounts gl 
-- join InvoiceLineItems ilt on gl.AccountNo=ilt.AccountNo
-- group by 
--     AccountDescription
-- having count(ilt.InvoiceID) > 1
-- order by LineItemCount DESC;

/*  Ex 5  */
-- select 
--     -- i.InvoiceDate,
--     AccountDescription, 
--     count(ilt.InvoiceID) [LineItemCount],
--     SUM(ilt.InvoiceLineItemAmount) [LineItemSum]
-- from GLAccounts gl 
--     join InvoiceLineItems ilt on gl.AccountNo=ilt.AccountNo
--     join Invoices i on i.InvoiceID=ilt.InvoiceID
-- where i.InvoiceDate BETWEEN '2015-12-01' AND '2016-02-26'
-- group by 
--     -- i.InvoiceDate,
--     AccountDescription
-- having count(ilt.InvoiceID) > 1
-- order by LineItemCount DESC;

/*  Ex 6  */
-- select 
--     AccountNo,
--     sum(InvoiceLineItemAmount) [Total Amount]
-- FROM InvoiceLineItems
-- GROUP by AccountNo
--     WITH ROLLUP;

/*  Ex 7  */
-- select 
--     VendorName,
--     AccountDescription ,
--     COUNT(*) LineItemCount,
--     SUM(InvoiceLineItemAmount) LineItemSum
-- from InvoiceLineItems li 
-- join GLAccounts gl on li.AccountNo=gl.AccountNo
-- join Invoices i on i.InvoiceID=li.InvoiceID
-- join Vendors v on v.VendorID=i.InvoiceID
-- group by 
--     VendorName,
--     AccountDescription
-- ORDER by VendorName, AccountDescription;

/*  Ex 8  */
-- select 
--     VendorName, 
--     COUNT(Distinct li.AccountNo) [Total Number of Accounts]
-- from Invoices i
-- join InvoiceLineItems li on i.InvoiceID=li.InvoiceID
-- join Vendors v on i.VendorID=v.VendorID
-- group by VendorName
-- having COUNT(Distinct li.AccountNo)>1;

/*  ? Ex 9 ?  */
-- select 
--     i.VendorID,
--     i.InvoiceDate, 
--     i.InvoiceTotal, 
--     sum(i.InvoiceTotal) OVER (PARTITION BY VendorID) VendorTotal,
--     count(i.InvoiceTotal) OVER (PARTITION BY VendorID) VendorCount,
--     avg(i.InvoiceTotal) OVER (PARTITION BY VendorID) VendorAvg
-- from Invoices i 
-- join Vendors v on i.VendorID=v.VendorID
-- group by 
--     i.VendorID,
--     i.InvoiceDate, 
--     i.InvoiceTotal

-- SELECT
--     i.VendorID,
--     i.InvoiceDate,
--     i.InvoiceTotal,
--     v.VendorTotal,
--     v.VendorCount,
--     v.VendorAvg
-- FROM
--     Invoices i
-- JOIN (
--     SELECT
--         v.VendorID,
--         SUM(i.InvoiceTotal) AS VendorTotal,
--         COUNT(i.InvoiceID) AS VendorCount,
--         AVG(i.InvoiceTotal) AS VendorAvg
--     FROM
--         Vendors v
--     JOIN
--         Invoices i ON v.VendorID = i.VendorID
--     GROUP BY
--         v.VendorID
-- ) v ON i.VendorID = v.VendorID;

-- select *
-- from GLAccounts;

-- select *
-- from InvoiceLineItems;

-- select * 
-- from Invoices;

-- select * 
-- from Vendors