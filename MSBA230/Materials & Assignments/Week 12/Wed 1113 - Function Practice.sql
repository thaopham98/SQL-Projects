--The number of courses that each instructor taught
SELECT 
	Instructors.InstructorID, 
	FirstName, 
	LastName, 
	COUNT(*) AS 'Number of Courses Taught' 
FROM Instructors JOIN Courses ON Instructors.InstructorID=Courses.InstructorID
GROUP BY Instructors.InstructorID, FirstName, LastName
ORDER BY COUNT(*) DESC 

--Create a function that given a instructor ID returns the number of courses they taught
GO
CREATE FUNCTION fnCourseInstructor (@InstructorID int)
RETURNS int
BEGIN 
	RETURN (SELECT COUNT(*) FROM Courses WHERE InstructorID=@InstructorID)	
END 
----
GO
PRINT dbo.fnCourseInstructor(3)

SELECT InstructorID, FirstName, LastName, dbo.fnCourseInstructor(InstructorID) AS 'Number of Courses taught'
FROM Instructors
ORDER BY 'Number of Courses taught' DESC
-----------
--write a query that returns the courses that have more than 5 students enrolled in it
SELECT C.CourseID, CourseNumber, CourseDescription, COUNT(*) AS 'Enrollment'
FROM Courses C JOIN StudentCourses SC ON C.CourseID=SC.CourseID
GROUP BY C.CourseID, CourseNumber, CourseDescription
HAVING COUNT(*) > 5
ORDER BY COUNT(*) DESC 

--do the above but first create a function that returns the enrollment number given a course 
GO 
CREATE FUNCTION fnEnrollment (@courseID int)
RETURNS int
BEGIN
	RETURN (SELECT COUNT(*) FROM StudentCourses WHERE CourseID=@courseID)
END
GO
--use that function in a query
SELECT CourseID, CourseNumber, CourseDescription, dbo.fnEnrollment(CourseID) AS Enrollment
FROM Courses
WHERE dbo.fnEnrollment(CourseID) >5
ORDER BY Enrollment DESC 

------
--create a function that returns all the courses and their enrollment
GO
CREATE FUNCTION fnCourseEnrollment ()
RETURNS Table

RETURN (SELECT C.CourseID, CourseNumber, CourseDescription, COUNT(*) AS 'Enrollment'
		FROM Courses C JOIN StudentCourses SC ON C.CourseID=SC.CourseID
		GROUP BY C.CourseID, CourseNumber, CourseDescription)
--
GO

SELECT * 
FROM dbo.fnCourseEnrollment()
WHERE Enrollment >5