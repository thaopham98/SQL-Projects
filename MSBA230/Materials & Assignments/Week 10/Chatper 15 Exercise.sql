USE MurachCollege;

select * FROM Students;
select * FROM StudentCourses;
select * FROM Courses;
select * FROM Instructors;
SELECT * FROM Departments;

/* 1 */
DROP PROC IF EXISTS spStudentUnit;
GO
CREATE PROC spStudentUnit 
    @studentID INT 
AS 
    BEGIN
        select 
            sc.StudentID, 
            SUM(c.CourseUnits) TotalCourseUnits
        FROM StudentCourses sc 
        JOIN Courses c
        ON c.CourseID=sc.CourseID
        WHERE @studentID=sc.StudentID
        GROUP BY sc.StudentID
    END

EXEC spStudentUnit 5;

/* 2 */
DROP PROC IF EXISTS spCoursetaught;
GO 
CREATE PROCEDURE spCoursetaught 
    @InstructorID INT = NULL
AS
    BEGIN
        SELECT 
            i.InstructorID,
            c.*
        FROM Instructors i
        INNER JOIN 
            Courses c ON i.InstructorID = c.InstructorID
        WHERE 
            (@InstructorID IS NULL OR i.InstructorID = @InstructorID)
    END;
EXEC spCoursetaught ;
EXEC spCoursetaught 5;

/* 3 */
DROP PROC IF EXISTS spInsertDepartment;
GO
CREATE PROC spInsertDepartment
    @deptName VARCHAR(50)
AS 
    BEGIN
        INSERT INTO Departments (DepartmentName)
        VALUES (@deptName);
    END;

EXEC spInsertDepartment 'Art';
EXEC spInsertDepartment 'Business';
EXEC spInsertDepartment 'Sport';

/* 4 */
DROP PROC IF EXISTS spInsertInstructor;
    /*the Instructors table doesn't have DateAdd only have HireDate*/
ALTER TABLE Instructors
ADD DateAdded DATE DEFAULT GETDATE(); 
GO
CREATE PROCEDURE spInsertInstructor
    @LastName VARCHAR(50),
    @FirstName VARCHAR(50),
    @Status VARCHAR(1),
    @DepartmentChairman INT,
    @AnnualSalary DECIMAL(10,2),
    @DepartmentID INT
AS
BEGIN
    IF @AnnualSalary < 0
        THROW 50002 ,'AnnualSalary cannot be negative.',1

    INSERT INTO Instructors (LastName, FirstName, Status, DepartmentChairman, AnnualSalary,HireDate, DepartmentID, DateAdded)
    VALUES (@LastName, @FirstName, @Status, @DepartmentChairman, @AnnualSalary, GETDATE(), @DepartmentID, GETDATE());
END;

EXEC spInsertInstructor 'Test4', 'Test2', 'P', 0, 50000.00, 1;
EXEC spInsertInstructor 'Test5', 'Test4', 'F', 1, -10000.00, 2;

/* 5 */
DROP PROC IF EXISTS spUpdateInstructor
GO
CREATE PROCEDURE spUpdateInstructor
    @InstructorID INT,
    @AnnualSalary DECIMAL(10,2)
AS
BEGIN
    -- Check if AnnualSalary is negative and raise an error if so
    IF @AnnualSalary < 0
        -- Use THROW to raise an error with a custom message
        THROW 50001, 'The AnnualSalary must be a positive number.', 1;

    -- Update the instructor's annual salary
    UPDATE Instructors
    SET AnnualSalary = @AnnualSalary
    WHERE InstructorID = @InstructorID;
END


EXEC spUpdateInstructor 15, 80000.00;
EXEC spUpdateInstructor 12, -10000.00;