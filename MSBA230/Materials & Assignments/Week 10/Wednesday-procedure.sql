USE MurachCollege ;

select * from Instructors;

/* Create a new table, RaiseStatus */
drop table IF EXISTS RaiseStatus;
GO 
create table RaiseStatus(
    ID int PRIMARY KEY IDENTITY(1,1), 
    InstructorID int, 
    FirstName varchar(50), 
    LastName varchar(50), 
    [Amount of Raise] money, 
    [Date of Raise] Date);

/* Create a procedure, Raise */
GO
CREATE OR ALTER PROC Raise
    @InstructorID INT
AS
    IF @InstructorID IN (select InstructorID FROM RaiseStatus WHERE DATEDIFF(YEAR,[Date of Raise],GETDATE())<=1 )-- if a raise was given in the last year
            BEGIN 
                PRINT 'NOT Eligible for A Raise'-- print a message that not eligible for raise  
                RETURN -- exit out of the store procedure
            END
    ELSE 
        BEGIN
            -- ================ METHOD 1 ================
            /* Update Salary in the Instructors table*/
            -- UPDATE Instructors
            --     SET AnnualSalary = AnnualSalary * 1.05
            --     WHERE InstructorID=@InstructorID AND DATEDIFF(YEAR, HireDate, GETDATE())<=5

            -- INSERT INTO RaiseStatus(InstructorID, FirstName, LastName, [Amount of Raise], [Date of Raise])
            --     SELECT 
            --         InstructorID, 
            --         FirstName, 
            --         LastName, 
            --         AnnualSalary * 0.05,
            --         GETDATE()
            --     FROM Instructors
            --     WHERE InstructorID=@InstructorID AND DATEDIFF(YEAR, HireDate,GETDATE())<=5
            -- PRINT 'Salary has been raised'


            -- ================ METHOD 2 ================
            /* Declare variables to store instructor info */
            DECLARE @FirstName varchar(50),
                    @LastName varchar(50), 
                    @RaiseAmount money,
                    @AnnualSalary money
            
            /* Retrieve instructor data into variables */
            SELECT 
                @firstName = FirstName,
                @lastName = LastName,
                @AnnualSalary = AnnualSalary
            FROM Instructors
            WHERE InstructorID=@InstructorID AND DATEDIFF(YEAR, HireDate, GETDATE())<=5

            /* Calculate the raise amount (5% of current salary) */
            SET @RaiseAmount = @AnnualSalary * 1.05

            /* UPDATE the salary in Instructors table */
            -- UPDATE Instructors
            --     SET AnnualSalary = AnnualSalary * 1.05
            --     WHERE InstructorID=@InstructorID AND DATEDIFF(YEAR, HireDate, GETDATE())<=5

            /* Insert the raise record into RaiseStatus */
            INSERT INTO RaiseStatus(InstructorID, FirstName, LastName, [Amount of Raise], [Date of Raise])
            VALUES (@InstructorID, @firstName, @lastName, @raiseAmount, GETDATE())


        SELECT * FROM RaiseStatus -- display the table RaiseStatus
        END
GO
-- EXEC Raise 14;
-- EXEC Raise 15;
-- EXEC Raise 16;

-- delete from RaiseStatus where InstructorID = 15;
-- SELECT * FROM RaiseStatus

-- -- ================ METHOD 1 ================
-- GO
-- CREATE OR ALTER PROC Raise_V1
--     @InstructorID int 
-- AS 
--     IF @InstructorID IN (SELECT InstructorID FROM RaiseStatus WHERE DATEDIFF(YEAR,[Date of Raise],GETDATE())<=1)
--         BEGIN 
--             PRINT 'NOT Eligible for A Raise'
--             RETURN 
--         END 

--     ELSE
--         BEGIN 
--             /* Update Salary */
--             UPDATE Instructors
--                 SET AnnualSalary = AnnualSalary * 1.05
--                 WHERE InstructorID=@InstructorID AND DATEDIFF(YEAR, HireDate, GETDATE())<=5

--             /* Insert using SELECT - retrieves data directly from Instructors table */
--             INSERT INTO RaiseStatus(InstructorID, FirstName, LastName, [Amount of Raise], [Date of Raise])
--                 SELECT 
--                     InstructorID, 
--                     FirstName, 
--                     LastName, 
--                     AnnualSalary * 0.05,
--                     GETDATE()
--                 FROM Instructors
--                 WHERE InstructorID=@InstructorID AND DATEDIFF(YEAR, HireDate,GETDATE())<=5
            
--         END 
-- GO

-- -- ================ METHOD 2 ================
-- GO
-- CREATE PROC Raise_V2
--     @InstructorID int 
-- AS 
--     DECLARE @firstName varchar(50)
--     DECLARE @lastName varchar(50)
--     DECLARE @raiseAmount money
--     DECLARE @currentSalary money

--     IF @InstructorID IN (SELECT InstructorID FROM RaiseStatus WHERE DATEDIFF(YEAR,[Date of Raise],GETDATE())<=1)
--         BEGIN 
--             PRINT 'NOT Eligible for A Raise'
--             RETURN 
--         END 

--     ELSE
--         BEGIN 
--             /* Retrieve instructor data into variables */
--             SELECT 
--                 @firstName = FirstName,
--                 @lastName = LastName,
--                 @currentSalary = AnnualSalary
--             FROM Instructors
--             WHERE InstructorID=@InstructorID AND DATEDIFF(YEAR, HireDate, GETDATE())<=5

--             /* Calculate raise amount */
--             SET @raiseAmount = @currentSalary * 0.05

--             /* Update Salary */
--             UPDATE Instructors
--                 SET AnnualSalary = @currentSalary * 1.05
--                 WHERE InstructorID=@InstructorID

--             /* Insert using VALUES with variables */
--             INSERT INTO RaiseStatus(InstructorID, FirstName, LastName, [Amount of Raise], [Date of Raise])
--             VALUES(@InstructorID, @firstName, @lastName, @raiseAmount, GETDATE())
--         END 
-- GO

-- -- ================ METHOD 3 ================

-- GO
-- CREATE OR ALTER PROC Raise_v3
--     @InstructorID int 

-- AS
--     -- Check if instructor exists and received a raise within the last year (365 days)
--     IF @InstructorID IN (SELECT InstructorID FROM RaiseStatus WHERE DATEDIFF(YEAR,[Date of Raise],GETDATE())<=1 )-- if a raise was given in the last year
--         BEGIN 
--             PRINT 'NOT Eligible for A Raise'-- print a message that not eligible for raise  
--             RETURN -- exit out of the store procedure
--         END 

--     ELSE
--         BEGIN 
--             -- Declear variables to store instructor info
--             DECLARE @FirstName varchar(50),
--                     @LastName varchar(50), 
--                     @RaiseAmount money,
--                     @AnnualSalary money

--             -- Get instructor details first
--             SELECT @FirstName = FirstName,
--                    @LastName = LastName,
--                    @AnnualSalary = AnnualSalary
--             FROM Instructors
--             WHERE InstructorID = @InstructorID AND DATEDIFF(YEAR, HireDate, GETDATE()) <= 5
            
--             -- Only proceed if instructor was found (within 5 years of hire)
--             IF @FirstName IS NOT NULL
--                 BEGIN
--                     -- calculate raise amount ( 5% of current salary)
--                     SET @RaiseAmount = @AnnualSalary *0.05
                    
--                     /* Update Salary */
--                     UPDATE Instructors
--                         SET AnnualSalary = AnnualSalary * 5% + AnnualSalary
--                         WHERE InstructorID = @InstructorID AND DATEDIFF(YEAR, HireDate, GETDATE()) <= 5

--                     /*  Insert a row in RaiseStatus table*/
--                     /* === Method 3 === */
--                     INSERT INTO RaiseStatus (InstructorID, FirstName, LastName, [Amount of Raise], [Date of Raise]) 
--                     VALUES (@InstructorID, @FirstName, @LastName, @RaiseAmount, GETDATE())
--                     PRINT 'Raise of $' + CAST(@RaiseAmount AS varchar(20)) + ' applied for ' + @FirstName + ' ' + @LastName
--                 END

--             ELSE
--                 BEGIN
--                     PRINT 'Instructor with ID ' + CAST(@InstructorID AS varchar(10)) + ' is not eligible - either not found or hired more than 5 years ago'
--                 END
--         END
-- GO