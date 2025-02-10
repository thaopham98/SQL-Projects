USE AP;

/* 1 */
/* CREATE TABLE */
DROP TABLE IF EXISTS DatesOfBirth;
CREATE TABLE DatesOfBirth(
    PersonID INT PRIMARY KEY IDENTITY(1,1),
    DateOfBirth DATETIME,
    FirstName VARCHAR(30),
    LastName VARCHAR(30)
)

INSERT INTO DatesOfBirth
VALUES 
    ('1967/10/18 00:00:00', 'Ross', 'Geller'),
    ('1969/03/28 00:00:00', 'Monica', 'Geller'),
    ('1969/05/05 00:00:00', 'Rachel', 'Green'),
    ('1967/04/15 00:00:00', 'Chandler', 'Bing'),
    ('1965/02/16 00:00:00', 'Phoebe', 'Buffay'),
    ('1967/01/10 00:00:00', 'Joey', 'Tribbiani')

-- SELECT * FROM DatesOfBirth;
-- SELECT DAY(DateOfBirth) Date, DateOfBirth FROM DatesOfBirth WHERE DAY(DateOfBirth) BETWEEN 5 AND 10;

/* CREATE STORED PROCEDURE */
DROP PROCEDURE IF EXISTS peopleBirthday;

GO
CREATE PROC peopleBirthday
    @Birthday DATE,
    @SearchRange INT -- Days unit
AS
    BEGIN
        SELECT 
            DateOfBirth,  
            FirstName +' '+ LastName AS FullName
        FROM DatesOfBirth 

        WHERE  DATEDIFF(DAY, @Birthday, DateOfBirth) BETWEEN -@SearchRange AND @SearchRange -- Using DATEDIFF()

            -- ABS(DATEDIFF(day, @Birthday, DateOfBirth)) <= @SearchRange -- Using ABS() considers both positive and negative differences

            -- DateOfBirth BETWEEN DATEADD(day, -@SearchRange, @Birthday) -- Using DATEADD() calculates the date @SearchRange days before @Birthday
            -- AND DATEADD(day, @SearchRange, @Birthday)
        
    END;

EXEC peopleBirthday @Birthday='1967/01/5', @SearchRange=5; -- calling

/* 2 */

/* Creat table MeterReadings */
DROP TABLE IF EXISTS MeterReadings; -- drop if exists
CREATE TABLE MeterReadings(
    MeterReadingID INT PRIMARY KEY IDENTITY(1,1),
    MeterSerialNumber VARCHAR(7), -- 7 char starts with 2 letter and the rest is numbers
    DateTimeRead DATETIME, 
    MeterReaderID VARCHAR(3), -- 3 char starts with A,D, or L
    LastReadingIn100CubicFt INT, -- Larger than 0 
    CurrentReadingIn100CubicFt INT -- Larger than 0 
);

INSERT INTO MeterReadings
VALUES 
    ('MA12345', GETDATE(), 'A12', 9, 7),
    ('MA23456', GETDATE(), 'D23', 1, 4),
    ('MA34567', GETDATE(), 'L34', 6, 1);

/* Creat table Invoices1 since the Invoices table've already exists in this db AP*/
DROP TABLE IF EXISTS Invoices1; -- drop if exists
CREATE TABLE Invoices1(
    InvoiceNumber INT PRIMARY KEY IDENTITY(1,1),
    InvoiceDate DATE, 
    MeterReadingID INT FOREIGN KEY REFERENCES MeterReadings(MeterReadingID), 
    UsageIn100CubicFt INT, 
    InvoiceAmount INT, 
    Paid BIT -- FOR BOOLEAN data type with 0 is paid & 1 is unpaid
);

INSERT INTO Invoices1
VALUES 
    (GETDATE(), 1, 2, 40, 0),
    (GETDATE(), 2, 3, 30, 1), 
    ('2024-05-01', 3, 5, 20, 0)
;

SELECT * FROM MeterReadings;
SELECT * FROM Invoices1;

/* CREATE STORED PROCEDURE */
DROP PROCEDURE IF EXISTS reading;
GO
CREATE PROC reading
    @date DATE, 
    @range INT -- Assumming range in DAY
AS 
    BEGIN
        SELECT
            COUNT(m.MeterReadingID) 'Number of Reading',    --  number of readings
            SUM(i1.InvoiceNumber) 'Total Paid'   -- total amount of paid invoice
        FROM MeterReadings m
        JOIN Invoices1 i1
        ON m.MeterReadingID = i1.MeterReadingID
        WHERE 
            i1.Paid = 1 -- 1 means UNPAID 
            AND
            (DATEDIFF(day, @date, i1.InvoiceDate) BETWEEN -@range AND @range) -- if @range=5 (days), means 5 days before and 5 days after
            -- (DATEDIFF(day, @date, i1.InvoiceDate) BETWEEN -@range/2 AND @range/2) -- if @range=5 (days), means 2.5 days before and 2.5 days after
    END
;

EXEC reading '2024-11-08', 5;  