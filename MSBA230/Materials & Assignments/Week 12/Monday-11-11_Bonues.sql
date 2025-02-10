USE master;
GO 

/* CREATE DB and TABLES */
DROP DATABASE IF EXISTS ICA;

CREATE DATABASE ICA;
GO

USE ICA;
GO

CREATE TABLE Students(
    StudentID INT PRIMARY KEY IDENTITY(1,1),
    LastName VARCHAR(50),
    FirstName VARCHAR(50),
    CurrentGrade INT
);

DROP TABLE IF EXISTS StudentAttendances;
CREATE TABLE StudentAttendances(
    AbsenceID int PRIMARY KEY IDENTITY(1,1),
    StudentID INT FOREIGN Key REFERENCES Students(StudentID),
    AttendanceDate DATE, 
    AttendancePeriod INT, 
    AttendanceStatus VARCHAR(7)
);

INSERT INTO Students
VALUES 
    ('Smith', 'John', 10),
    ('Johnson', 'Emma', 11),
    ('Williams', 'Olivia', 12);

INSERT INTO StudentAttendances
VALUES 
    (1, '10/1/2024', 1, 'Absent'),
    (1, '10/2/2024', 2, 'Present'),
    (2, '10/3/2024', 1, 'Absent'),
    (3, '10/4/2024', 1, 'Absent'),
    (3, '10/5/2024', 2, 'Present');

/* CREATE SCARLAR-VALUE FUNCTION */
DROP Function if EXISTS DaysAbsent;
GO
CREATE FUNCTION DaysAbsent (@StudetnID int, @startDate date, @endDate date)
RETURNS INT
BEGIN
    DECLARE @countAbsents int;
    SELECT @countAbsents=COUNT(*)
    FROM StudentAttendances
    WHERE AttendanceStatus = 'Absent' 
    AND StudentID=@StudetnID 
    AND (AttendanceDate BETWEEN @startDate and @endDate )
RETURN @countAbsents
END;

GO


/* CALLING */
select dbo.DaysAbsent(1, '2024-9-29', '2024-10-5') 'Days Absent';



/* TESTING */
-- SELECT @AbsentDays AS AbsentDays;
-- SELECT * FROM dbo.DaysAbsent(1, '2024-9-29', '2024-10-5');
-- select *  dbo.DaysAbsent 

-- SELECT * FROM StudentAttendances;

-- SELECT count(*) AS 'Absence Days'
-- from StudentAttendances
-- WHERE AttendanceStatus = 'Absent' AND StudentID=1 AND (AttendanceDate BETWEEN '2024-9-29' and '2024-10-5'  ) --DATEDIFF(DAY,'2024-9-29', '2024-10-5' );