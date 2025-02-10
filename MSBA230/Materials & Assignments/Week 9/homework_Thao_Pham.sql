/* Q5 Create a PROC that given a vendorid will return all the unpaid invoices for that vendor. 
(Check for 37)
- if the vendor doesn't exist it displays a message such as: 
"VendorID @vendorID not found. Please add a correct VendorID"

-if there no unpaid invoices for a vendorID display a messge:
"No unpaid invoices for VendorID 1"

*/
-- Check if EXIST or NOT
IF OBJECT_ID('spUnpaidforvendor', 'P') IS NOT NULL
    DROP PROCEDURE spUnpaidforvendor
GO

CREATE PROC spUnpaidforvendor
	@vendorID int
AS
	BEGIN
		-- Check if the vendor exists
		IF 
            (SELECT COUNT(*) 
            FROM Vendors 
            WHERE VendorID = @vendorID) = 0
		BEGIN
			PRINT 'VendorID ' + CAST(@vendorID AS varchar) + ' not found. Please add a correct VendorID'
			RETURN
		END

		-- Check if there are unpaid invoices for the vendor
		IF 
            (SELECT COUNT(*) 'Unpaid Invoices'
            FROM Invoices 
            WHERE
                VendorID = @vendorID 
                AND 
                InvoiceTotal - PaymentTotal - CreditTotal > 0
            ) = 0
		BEGIN
			PRINT 'No unpaid invoices for VendorID ' + CAST(@vendorID AS varchar)
			RETURN
		END

		-- If there are unpaid invoices, return them
		SELECT *
		FROM Invoices
		WHERE InvoiceTotal - PaymentTotal - CreditTotal > 0 AND VendorID = @vendorID
	END
--
EXEC spUnpaidforvendor 3

--
GO

/* Q6 Alter #4 to display a message such as : There are 1 unpaid invoice for vendor id 37 */
ALTER PROC spStateVendors
    @State VARCHAR(2) = '%'
AS
    BEGIN
        -- Check if any vendors exist for the specified state
        IF 
            (SELECT COUNT(*) 
            FROM Vendors 
            WHERE VendorState LIKE @State) = 0
        BEGIN
            PRINT 'No vendor found for ' + @State
            RETURN
        END

        -- Retrieve vendors for the specified state and check unpaid invoices
        DECLARE @vendorID INT, @unpaidCount INT
        DECLARE vendorCursor CURSOR FOR 
            SELECT VendorID
            FROM Vendors
            WHERE VendorState LIKE @State

        OPEN vendorCursor
        FETCH NEXT FROM vendorCursor INTO @vendorID

        -- While loop
        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Count unpaid invoices for the current vendor
            SET @unpaidCount = (SELECT COUNT(*) 
                                FROM Invoices 
                                WHERE VendorID = @vendorID 
                                AND InvoiceTotal - PaymentTotal - CreditTotal > 0)
            
            IF @unpaidCount > 0
                PRINT 'There are ' + CAST(@unpaidCount AS VARCHAR) + ' unpaid invoice(s) for VendorID ' + CAST(@vendorID AS VARCHAR)
            
            FETCH NEXT FROM vendorCursor INTO @vendorID
        END

        CLOSE vendorCursor
        DEALLOCATE vendorCursor
    END
--
EXEC spStateVendors 'CA';
--
GO 

/* Q8 Create a PROC that given a vendor ID, 
returns the number of unpaid invoices along with the total balance for that vendor*/

-- Check if EXIST or NOT
IF OBJECT_ID('spUnpaidInvoiceSummary', 'P') IS NOT NULL
    DROP PROCEDURE spUnpaidInvoiceSummary
GO

CREATE PROC spUnpaidInvoiceSummary
    @vendorID int 
AS 
    BEGIN
        /* Check EXIST */
        IF (SELECT COUNT(*) FROM Vendors WHERE VendorID = @vendorID) = 0
        BEGIN
            PRINT 'VendorID ' + CAST(@vendorID AS VARCHAR(10)) + ' not found. Please add a correct VendorID.'
            RETURN
        END 


        SELECT 
            COUNT(*) AS UnpaidInvoiceCount,
            SUM(InvoiceTotal - PaymentTotal - CreditTotal) AS TotalBalance
        FROM Invoices
        WHERE 
            VendorID = @vendorID
            AND 
            (InvoiceTotal - PaymentTotal - CreditTotal) > 0
    END
--
EXEC spUnpaidInvoiceSummary 37