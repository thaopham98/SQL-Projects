USE MurachCollege;

SELECT * FROM Departments;
SELECT * FROM Instructors;
SELECT * FROM Courses;


/*   1   */
-- INSERT INTO Departments
-- VALUES ('History'); -- The ID is 14 since i was testing by inserting and deleting the row many times.

-- DELETE FROM Departments WHERE DepartmentName='History';
-- select * from Departments WHERE DepartmentID=9;
-- DELETE FROM Departments WHERE DepartmentID=13;

/*   2   */
-- INSERT INTO Instructors
-- VALUES 
--     ('Benedict', 'Susan', 'P', 0, CAST(GETDATE() AS DATE), 34000.00, 14),
    -- ('Adams', NULL, 'F', 1, CAST(GETDATE() AS DATE), 66000.00, 14); -- the DepartmentID is 14 because mine only have 14 and not 9


/*   3   */
-- UPDATE Instructors 
-- SET AnnualSalary=35000.00
-- WHERE InstructorID = 24; -- Susan Benedict's ID is 24


/*   4   */
-- DELETE FROM Instructors WHERE InstructorID=25; --Adam's ID was 25


/*   5   */ 
    /*SINCE I DON'T HAVE THE DEPARTMENTID = 9, I USE 14*/
-- DELETE FROM Departments WHERE DepartmentID = 14;
-- DELETE FROM Instructors WHERE DepartmentID = 14; 


/*   6   */
-- UPDATE Instructors
-- SET AnnualSalary = AnnualSalary * 1.05
-- -- select * -- This statement is used to check after the update.
-- from Departments d 
-- join Instructors i on d.DepartmentID = i.DepartmentID
-- where d.DepartmentName='Education';


/*   7   */
-- DELETE
-- -- select * --   This statement is used to check after runing DELETE
-- from Instructors
-- WHERE InstructorID NOT IN
-- (   /* InstructorsID that in Courses table */
--     select InstructorID
--     from Courses
-- );


/*   8   */
-- CREATE TABLE GradStudents
-- (StudentID      INT         PRIMARY KEY,
--  LastName       VARCHAR(25) NOT NULL,
--  FirstName      VARCHAR(25) NOT NULL,
--  EnrollmentDate DATE        NOT NULL,
--  GraduationDate Date        NULL);

-- SELECT * FROM GradStudents; -- Checking the table.

/*   9   */
-- INSERT INTO GradStudents
-- SELECT * 
-- FROM Students
-- WHERE GraduationDate IS NOT NULL;


/*   10   */
-- RAN the CreateMurachCollege.sql successfully 