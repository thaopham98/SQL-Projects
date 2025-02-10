-- SELECT * FROM Instructors;
-- SELECT * from Students
-- select * from Courses;
-- SELECT * FROM StudentCourses;

/* CHAPTER 5 */
/*  1   */
-- select 
--     COUNT(*) AS [Number of Instructors],
--     AVG(AnnualSalary) AS [The Average Annual Salary]
-- from Instructors
-- Where [Status] = 'F';

/*  2   */
-- SELECT
--     d.DepartmentName,
--     COUNT(i.InstructorID) AS [Number of Instructors],
--     MAX(i.AnnualSalary) AS [Highest Annual Salary]
-- FROM Instructors AS i
-- JOIN Departments AS d on i.DepartmentID=d.DepartmentID
-- GROUP BY 
--     DepartmentName
-- ORDER BY [Number of Instructors] DESC

/*  3   */
-- SELECT 
--     i.FirstName + ' ' + i.LastName AS [Full Name],
--     COUNT(c.CourseID) AS [Number of Courses],
--     SUM(c.CourseUnits) AS [Total Course Units]
-- from Instructors as i 
-- join Courses as c on c.InstructorID=i.InstructorID
-- GROUP by i.FirstName, i.LastName
-- ORDER BY [Course Units] DESC

/*  4   */
-- SELECT
--     d.DepartmentName,
--     c.CourseDescription,
--     COUNT(sc.StudentID) AS StudentCount
-- FROM
--     Departments d
-- INNER JOIN Courses c ON d.DepartmentID = c.DepartmentID
-- INNER JOIN StudentCourses sc ON c.CourseID = sc.CourseID
-- GROUP BY
--     d.DepartmentName,
--     c.CourseDescription
-- HAVING COUNT(sc.StudentID) > 0
-- ORDER BY
--     d.DepartmentName,
--     StudentCount ASC;

/*  5   */
-- SELECT 
--     s.StudentID,
--     SUM(CourseUnits) AS [Total Course Units]
-- FROM StudentCourses as sc 
-- JOIN Students as s on sc.StudentID = s.StudentID
-- JOIN Courses as c on c.CourseID = sc.CourseID
-- GROUP BY 
--     s.StudentID
-- ORDER BY [Total Course Units] DESC;

/*  6   */
-- SELECT 
--     s.StudentID,
--     SUM(CourseUnits) AS [CourseUnits]
-- FROM StudentCourses as sc 
-- JOIN Students as s on sc.StudentID = s.StudentID
-- JOIN Courses as c on c.CourseID = sc.CourseID
-- WHERE 
--     s.GraduationDate IS NULL 
-- GROUP BY 
--     s.StudentID
-- having
--     SUM(CourseUnits) > 9
-- ORDER BY [CourseUnits] DESC;

/*  ?7?   */
-- SELECT 
--     LastName +', '+FirstName AS [Full Name],
--     COUNT(c.CourseNumber) AS [Number of Courses]
-- from Instructors as i 
-- JOIN Courses as c on c.InstructorID = c.InstructorID
-- where STATUS='P'
-- group by 
--     i.LastName, 
--     i.FirstName;


/* CHAPTER 6 */

/*  1   */
-- select distinct LastName , FirstName
-- from Instructors i 
-- WHERE InstructorID IN 
--     (
--         select c.InstructorID
--         from Courses c
--     )
-- Order by LastName, FirstName;

/*  2   */
-- SELECT 
--     LastName,
--     FirstName, 
--     AnnualSalary
-- from Instructors
-- where AnnualSalary >
--     (select avg(AnnualSalary)
--     from Instructors)
-- Order by AnnualSalary DESC;


/*  3   */
-- select 
--     LastName,
--     FirstName
-- from Instructors i 
-- Where NOT EXISTS 
--     (select 
--         InstructorID
--     from Courses c 
--     where c.InstructorID=i.InstructorID
--     )
-- ORDER by LastName, FirstName;

/*  4   */
-- SELECT 
--     s.LastName, 
--     s.FirstName, 
--     COUNT(sc.CourseID) AS NumberOfCourses
-- FROM Students s
-- JOIN StudentCourses sc ON s.StudentID = sc.StudentID
-- WHERE 
--     s.StudentID IN (
--         SELECT 
--             StudentID 
--         FROM 
--             StudentCourses
--         GROUP BY 
--             StudentID
--         HAVING 
--             COUNT(CourseID) > 1
--     )
-- GROUP BY 
--     s.LastName, 
--     s.FirstName
-- ORDER BY 
--     s.LastName ASC, 
--     s.FirstName ASC;

/*  5  */
-- select 
--     LastName,
--     FirstName,
--     AnnualSalary
-- from Instructors i 
-- where AnnualSalary in 
--     (
--         select AnnualSalary 
--         from Instructors
--         GROUP by AnnualSalary
--         having count(*) = 1
--         )
-- order by LastName ASC, FirstName ASC;

/*  6   */
-- WITH recentEnrollment AS(
-- select 
--     c.CourseID,
--     Max(s.EnrollmentDate) [Recent Enrollment Date]
-- from Courses c
-- join StudentCourses sc on sc.CourseID=c.CourseID
-- join Students s on s.StudentID=sc.StudentID
-- group by c.CourseID
-- )

-- SELECT c.CourseDescription, s.LastName, s.FirstName, re.[Recent Enrollment Date]
-- FROM Courses c
-- JOIN StudentCourses sc ON c.CourseID = sc.CourseID
-- JOIN Students s ON sc.StudentID = s.StudentID
-- JOIN recentEnrollment re ON c.CourseID = re.CourseID
--     AND s.EnrollmentDate = re.[Recent Enrollment Date]
-- ORDER BY c.CourseID;

/*  7   */
WITH TotalCourseUnits AS (
        SELECT 
            sc.StudentID,
            SUM(c.CourseUnits) [TotalUnits]
        FROM Courses c
        join StudentCourses sc on c.CourseID=sc.CourseID
        group by sc.StudentID
        having SUM(c.CourseUnits)> 9
)

select 
    tc.StudentID, 
    tc.TotalUnits,
    (t.FullTimeCost+(t.PerUnitCost*tc.TotalUnits)) AS Tuition
from TotalCourseUnits tc
CROSS JOIN Tuition t;