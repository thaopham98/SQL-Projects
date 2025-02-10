USE AP;
select * from VendorCopy;
SELECT * FROM Vendors;

select * from InvoiceCopy;
SELECT * from Invoices;

/*   1   */
-- DROP TABLE IF EXISTS VendorCopy, InvoiceCopy;

-- SELECT * 
-- INTO VendorCopy 
-- FROM Vendors;

-- SELECT * 
-- INTO InvoiceCopy 
-- FROM Invoices;


/*   2   */
-- INSERT INTO InvoiceCopy(VendorID, InvoiceTotal, TermsID, InvoiceNumber, PaymentTotal, InvoiceDueDate, InvoiceDate, CreditTotal, PaymentDate)
-- VALUES (32, 434.58, 2, 'AX-014-027', 0.00, '2016-07-08', '2016-06-21', 0.00, null);


/*   3   */
-- INSERT INTO VendorCopy
-- select 
--     VendorName,
--     VendorAddress1,
--     VendorAddress2,
--     VendorCity,
--     VendorState,
--     VendorZipCode,
--     VendorPhone,
--     VendorContactLName,
--     VendorContactFName,
--     DefaultTermsID,
--     DefaultAccountNo
-- FROM Vendors
-- where VendorState <> 'CA' -- NON-Californian Vendor
-- ;


/*   4   */
-- UPDATE VendorCopy
-- SET DefaultAccountNo=403 -- Updating to 403
-- where DefaultAccountNo=400 -- Vendors with Default Account Number - 400
-- ;


/*   5   */
UPDATE InvoiceCopy
SET 
    PaymentDate=CAST(GETDATE() AS date), 
    PaymentTotal = InvoiceTotal-CreditTotal
WHERE InvoiceTotal-CreditTotal-PaymentTotal>0;


/*   6   */
UPDATE InvoiceCopy
SET TermsID = 2
WHERE VendorID IN
    (
        SELECT VendorID
        FROM VendorCopy
        WHERE DefaultTermsID = 2
     );


/*   7   */
UPDATE InvoiceCopy  
SET TermsID = 2
FROM VendorCopy vc
JOIN Invoices i on vc.VendorID = i.VendorID
WHERE vc.DefaultTermsID = 2


/*   8   */
-- DELETE
-- -- SELECT * -- To check after running the DELETE. 
-- FROM VendorCopy
-- WHERE VendorState='MN';


/*   9   */
-- DELETE
-- -- select *
-- from VendorCopy 
-- WHERE VendorState NOT IN 
--     (
--         select distinct vc.VendorState
--         from VendorCopy vc
--         join InvoiceCopy ic on vc.VendorID=ic.VendorID
--     )
-- ;