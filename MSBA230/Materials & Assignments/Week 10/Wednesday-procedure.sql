USE MurachCollege ;

select * from Instructors

/* Create a new table, RaiseStatus */
create table RaiseStatus(
    ID int PRIMARY KEY IDENTITY(1,1), 
    InstructorID int, 
    FirstName varchar(50), 
    LastName varchar(50), 
    [Amount of Raise] money, 
    [Date of Raise] Date)

/* Create a procedure, Raise */
GO
CREATE PROC Raise
    @InstructorID int 

AS 
    IF @InstructorID IN (select InstructorID FROM RaiseStatus WHERE DATEDIFF(YEAR,[Date of Raise],GETDATE())<=365 )-- if a raise was given in the last year
        BEGIN 
            PRINT 'NOT Eligible for A Raise'-- print a message that not eligible for raise  
            RETURN -- exit out of the store procedure
        END 

    ELSE
        BEGIN 
            /* Update Salary */
            UPDATE Instructors
                SET AnnualSalary = AnnualSalary * 5% + AnnualSalary
                WHERE InstructorID=@InstructorID AND DATEDIFF(YEAR, HireDate, GETDATE())<=5

            /*  Insert a row in RaiseStatus table*/
            /* Cách 1 */
            -- INSERT INTO RaiseStatus([Amount of Raise], [Date of Raise])
            --     SELECT 
            --         InstructorID, 
            --         FirstName, -- get the firstname and last name and then insert into the table
            --         LastName, 
            --         AnnualSalary*0.05, -- in order to do the INSERT INTO I need to calcualte amount of raise,
            --         GETDATE()
            --     FROM Instructors
            --     WHERE InstructorID=@InstructorID AND DATEDIFF(YEAR, HireDate,GETDATE())<=5

            /* Cách 2 */
            INSERT INTO RaiseStatus([Amount of Raise], [Date of Raise])
            VALUES(@InstructorID, @firstName, @lastName, @raiseAmount, GETDATE())
            DECLARE @firstName=FirstName
        END 

