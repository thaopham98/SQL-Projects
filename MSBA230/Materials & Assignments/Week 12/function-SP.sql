-- USE MurachCollege;

-- Function vs. SP
-- writing SP be shorter when writing, but cannot return a recordset like function.
-- main function of sp is NOT return something, it's best to use func. 
-- SP can call function, function CANNOT call SP.

-- write a query that returns the courses that have more than 5 students enrolled in it. 
select * from Courses 
select * from Students
select * from StudentCourses

SELECT c.*, count(sc.CourseID) 'Number of Courses' FROM StudentCourses sc JOIN Courses c ON c.CourseID=sc.CourseID
GROUP by c.CourseID, c.CourseNumber, c.CourseDescription, c.CourseUnits, c.DepartmentID, c.InstructorID
having count(sc.CourseID)>5

-- do the above but first create a function that return the enrollment number given a course
DROP FUNCTION iF EXISTS fnEnrollment;

GO
CREATE FUNCTION fnEnrollment(@courseID int)
    RETURNS int
BEGIN
    RETURN 
        (SELECT count(*) FROM StudentCourses where @courseID=CourseID)
END ;

GO
select CourseID, CourseNumber, CourseDescription, dbo.fnEnrollment(CourseID) AS enrollment
from Courses where dbo.fnEnrollment=@
