/*
Create a proc that given a instructor ID
--checks to see if there has been a raise in the last year
-- if not increase their salary 5% if they have been hired in the last 5 years
and add a row to in RaiseStatus table to keep track

Create a new table called RaiseStatus 
(ID, InstructorID, FirstName, LastName, Amount of Raise, Date of raise)
*/

SELECT * FROM Instructors
-------------------------------------------------------------
CREATE TABLE RaiseStatus(
	ID int PRIMARY KEY IDENTITY(1,1),
	InstructorID int,
	Firstname varchar(50),
	Lastname varchar(50),
	AmountofRaise money,
	DateofRaise date
)
SELECT * FROM RaiseStatus
---------------------------------------------------------------
GO -- why GO is here? it divide the sql into different part
Alter PROC Raise
	@InstructorID int -- parameter
AS -- to the stored procedure
--check if there has been a raise in the past year
IF @InstructorID IN (SELECT InstructorID FROM RaiseStatus WHERE DATEDIFF(DAY, DateofRaise,GETDATE())<=365)
-- if yes, print a message that says raise already applied and exit
	BEGIN
		PRINT 'Raise already applied. Not eligible for a raise.'
		RETURN
	END
--if not,
ELSE
	BEGIN
	-- Insert a row in RaiseStatus table
	--either use VALUES for insert into but you need to first declare and assign those values
	DECLARE @firsname varchar, @lastname varchar, @raiseamount money -- local variables 
	SELECT @firsname=FirstName, @lastname=LastName, @raiseamount=AnnualSalary*0.05
	FROM Instructors
	WHERE InstructorID=@InstructorID AND DATEDIFF(YEAR,HireDate, GETDATE()) <=5

	INSERT INTO RaiseStatus
	VALUES (@InstructorID,@firsname,@lastname,@raiseamount,GETDATE())
	-----------------------------------------------
	--or simply use SELECT with insert into
	INSERT INTO RaiseStatus
	SELECT InstructorID, FirstName, LastName, AnnualSalary *0.05, GETDATE()
	FROM Instructors
	WHERE InstructorID=@InstructorID AND DATEDIFF(YEAR,HireDate, GETDATE()) <=5
		-- in order to do the INSERT INTO I need to calcualte amount of raise,
		-- get the firstname and last name and then insert into the table 
	-- Update the salary 
	UPDATE Instructors 
	SET AnnualSalary = AnnualSalary *1.05
	WHERE InstructorID=@InstructorID AND DATEDIFF(YEAR,HireDate, GETDATE()) <=5
	END

select * from RaiseStatus
RETURN

EXEC Raise 3

