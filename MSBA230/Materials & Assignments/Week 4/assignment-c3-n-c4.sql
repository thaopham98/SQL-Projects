/*  CHAPTER 3   */
/*   1   */
-- SELECT *
-- FROM Courses;

/*   2   */
-- SELECT CourseNumber, CourseDescription, CourseUnits
-- FROM Courses 
-- ORDER BY CourseNumber;

/*   3   */
-- SELECT LastName + ', ' + FirstName AS 'FullName'
-- FROM Students
-- WHERE LastName LIKE '[a-m]%'
-- ORDER BY LastName;

/*   4   */ 
-- SELECT LastName, FirstName, AnnualSalary
-- FROM Instructors
-- WHERE (AnnualSalary > 60000) OR (AnnualSalary = 60000)
-- ORDER BY AnnualSalary DESC;

/*   5   */
-- SELECT LastName, FirstName, HireDate
-- FROM Instructors
-- WHERE HireDate LIKE '2022%'
-- ORDER BY HireDate;

/*   6   */
-- SELECT 
--     FirstName, 
--     LastName, 
--     EnrollmentDate, 
--     -- /*CONVERT (date, GETDATE())*/ GETDATE() AS CurrentDate,
--     DATEDIFF(MONTH, EnrollmentDate, GETDATE()) AS MonthsAttended
-- FROM Students
-- ORDER BY MonthsAttended;

/*   7   */
-- SELECT TOP 20 PERCENT FirstName, LastName, AnnualSalary
-- FROM Instructors
-- ORDER BY AnnualSalary DESC;

/*   8   */
-- SELECT 
--     LastName,
--     FirstName
-- FROM Students
-- WHERE LastName LIKE 'G%';

/*   9   */
-- SELECT 
--     LastName,
--     FirstName,
--     EnrollmentDate, 
--     GraduationDate
-- FROM Students
-- WHERE EnrollmentDate > '12-01-2022' AND GraduationDate is NULL

/*   10   */
-- SELECT
--     FullTimeCost,
--     PerUnitCost,
--     12 AS Units,
--     PerUnitCost * 12 AS TotalPerUnitCost,
--     FullTimeCost + (PerUnitCost * 12) AS TotalTuition
-- FROM
--     Tuition;


/*  CHAPTER 4   */
/*   1   */
-- SELECT DepartmentName, CourseNumber, CourseDescription
-- FROM Courses
-- JOIN Departments
-- ON Courses.DepartmentID = Departments.DepartmentID
-- ORDER by DepartmentName, CourseNumber;

/*   2   */
-- SELECT LastName, FirstName, CourseNumber, CourseDescription
-- FROM Instructors
-- JOIN Courses 
-- ON Courses.InstructorID = Instructors.InstructorID
-- WHERE Instructors.[Status]='P'
-- ORDER BY LastName, FirstName;

/*   3   */
-- SELECT 
--     DepartmentName,
--     CourseDescription,
--     FirstName,
--     LastName
-- FROM Departments
-- JOIN Courses
-- ON Courses.DepartmentID = Departments.DepartmentID

-- JOIN Instructors
-- ON Courses.InstructorID = Instructors.InstructorID
-- WHERE CourseUnits=3
-- ORDER BY DepartmentName ASC, CourseDescription ASC;

/*   4   */
-- SELECT 
--     DepartmentName,
--     CourseDescription, 
--     LastName,
--     FirstName
-- FROM Departments AS d
-- JOIN Courses AS c ON d.DepartmentID = c.DepartmentID
-- JOIN StudentCourses AS sc ON sc.CourseID = c.CourseID
-- JOIN Students AS s ON s.StudentID = sc.StudentID
-- WHERE d.DepartmentName = 'English'
-- ORDER BY CourseDescription ASC;

/*   5   */
-- SELECT
--     LastName,
--     FirstName, 
--     CourseDescription
-- FROM Instructors AS i
-- LEFT JOIN Courses AS c ON i.InstructorID = c.InstructorID # some instructors don't teach any courses.
-- ORDER BY LastName ASC, FirstName ASC;

/*   6   */
-- SELECT 
--     -- COUNT(*) -- counting # of Undergrads
--     'UNDERGRAD' AS Status, 
--     FirstName, 
--     LastName, 
--     EnrollmentDate,
--     GraduationDate
-- FROM Students
-- WHERE GraduationDate IS NULL

-- UNION 

-- SELECT 
--     COUNT(*) -- counting # of Grads
--     'GRADUATED' AS Status,
--     FirstName, 
--     LastName, 
--     EnrollmentDate,
--     GraduationDate
-- FROM Students
-- WHERE GraduationDate IS NOT NULL
-- ORDER BY EnrollmentDate;

/*   7   */
-- SELECT 
--     DepartmentName,
--     CourseID
-- FROM Departments AS d 
-- LEFT JOIN Courses AS c ON d.DepartmentID = c.DepartmentID
-- WHERE c.CourseID is NULL;

/*   8   */
-- SELECT
--     d1.DepartmentName AS InstructorDept,
--     i.LastName,
--     i.FirstName,
--     c.CourseDescription,
--     d2.DepartmentName AS CourseDept
-- FROM Instructors i
-- JOIN Departments d1 ON i.DepartmentID = d1.DepartmentID
-- JOIN Courses c ON i.InstructorID = c.InstructorID
-- JOIN Departments d2 ON c.DepartmentID = d2.DepartmentID
-- WHERE d1.DepartmentID <> d2.DepartmentID;