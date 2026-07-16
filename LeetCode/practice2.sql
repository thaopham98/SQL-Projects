-- USE EmployeeDB;

-- ======================== 1. Managers with at Least 5 Direct Reports
--  Approach A — Subquery
-- select
--     name
-- from Employee
-- WHERE id IN -- Step 2 — Filter for managers with 5 or more, then get their name
-- (   -- Step 1: how many employess report to each manager?
--     select 
--     manager_id
--     -- ,COUNT(*) AS [Number of Staff]
--     from Employee
--     group by manager_id
--     having count(*) >=5
-- )

-- -- Approach B — Self-join + GROUP BY + HAVING
-- SELECT 
--     m.name
-- FROM Employee e
-- JOIN Employee m ON e.manager_id = m.id
-- GROUP BY 
--     m.id 
--     ,m.name
-- HAVING count(e.manager_id) >=5; -- the number of direct reports per manager


-- ======================== 2. Employees Earning More Than Their Managers
-- SELECT 
--     e.name AS "Employee"
-- FROM Employee e
-- JOIN Employee m ON e.manager_id = m.id
-- WHERE e.salary > m.salary
-- GROUP BY 
--     e.id 
--     ,e.name
-- ;


-- ========================= 3. Return Duplicated Records
-- -- A: names where the same email appear more than once
-- SELECT
--     name, email
-- FROM Employee
-- GROUP BY name, email 
-- HAVING COUNT(*) > 1;

-- -- B: names that have multiple different emails
-- SELECT name 
-- FROM Employee
-- GROUP BY name
-- HAVING COUNT(DISTINCT email) > 1;

-- ======================== 4. Customers Who Never Order ========================================
-- select
--     name as Customers
-- from Customers c 
-- LEFT JOIN Orders o on c.id = o.customerId
-- where c.id not in (select customerId from Orders);

-- SELECT
--     name AS Customers
-- FROM Customers c
-- LEFT JOIN Orders o ON c.id = o.customerId
-- WHERE o.customerId IS NULL;

-- SELECT 
--     c.name AS Customers
-- FROM Customers c
-- WHERE NOT EXISTS (
--     SELECT 1 
--     FROM Orders o 
--     WHERE o.customerId = c.id
-- );

-- SELECT name AS Customers
-- FROM Customers
-- WHERE id NOT IN (
--     SELECT customerId
--     FROM Orders
-- );


-- ======================== 5. Second Highest Salary ============================================
-- select 
--     MAX(salary) AS SecondHighestSalary
-- from Employee
-- WHERE salary < (SELECT MAX(salary) FROM Employee); -- will also handle to return NULL if there's no second highest 

-- 3. wraps the entire subquery inside a standalone SELECT 
-- SELECT (
--     -- 2. filters the ranked list to only look at rows where the rank is exactly 2
--     SELECT DISTINCT salary 
--     FROM (
--         -- 1. grabs all salaries and ranks them in DESC order
--         SELECT salary, DENSE_RANK() OVER(ORDER BY salary DESC) AS rankt
--         FROM Employee
--     ) t
--     WHERE rankt = 2
-- ) AS SecondHighestSalary;

-- SELECT
--     (
--         SELECT MAX(salary)
--         FROM
--             (-- grabs all salaries and ranks them in DESC order
--                 SELECT salary, DENSE_RANK() OVER(ORDER BY salary DESC) AS rank
--                 FROM Employee) t
--         WHERE rank = 2
--     ) AS SecondHighestSalary;


-- ======================== 6. Nth Highest Salary ==================================================
-- DROP FUNCTION IF EXISTS getNthHighestSalary;
-- GO

-- CREATE OR ALTER FUNCTION getNthHighestSalary(@N INT)
-- RETURNS INT
-- BEGIN
--     RETURN (
--         SELECT DISTINCT salary
--         FROM
--             (SELECT 
--                 DISTINCT salary, RANK() OVER(ORDER BY salary DESC) AS rankt
--             FROM Employee)t
--         WHERE rankt = @N
--     )
-- END;
-- GO

-- SELECT DISTINCT dbo.getNthHighestSalary(2) FROM Employee;


-- ======================== 7. Department Highest Salary ===========================================
-- -- Find employees who have the highest salary in each of the departments
-- USE MurachCollege; 
-- GO

-- WITH RankedInstructors AS (
--     SELECT 
--         d.DepartmentName,
--         CONCAT(i.FirstName, ' ', i.LastName) AS Employee,
--         i.AnnualSalary,
--         -- PARTITION BY groups the ranking within each department
--         DENSE_RANK() OVER(PARTITION BY d.DepartmentID ORDER BY i.AnnualSalary DESC) AS rankt
--     FROM Instructors i
--     JOIN Departments d ON d.DepartmentID = i.DepartmentID
-- )
-- SELECT 
--     DepartmentName,
--     Employee,
--     AnnualSalary
-- FROM RankedInstructors
-- WHERE rankt = 1; -- Grabs only the highest earner(s) per department!


-- SELECT
--     DepartmentName
--     ,FirstName AS Employee
--     ,AnnualSalary
-- FROM Instructors i
-- JOIN Departments d ON d.DepartmentID = i.DepartmentID
-- WHERE AnnualSalary IN
--     (
--         SELECT MAX(AnnualSalary) 
--         FROM Instructors 
--         Where d.DepartmentID = DepartmentID -- IMPORTANCE
--     )


-- ======================== 8. Game Play Analysis I ================================================
-- USE BikeStores;
-- select 
--     customer_id
--     ,MIN(order_date) AS "First Order Date"
-- from sales.orders
-- GROUP by customer_id


-- ======================== 9. Rising Temperature ==================================================
-- -- Write a solution to find all dates' `id` with higher temp compared to its previous dates
-- USE EmployeeDB;

-- select 
--     today.id AS Id
-- from Weather today
-- join Weather yesterday on DATEDIFF(DAY, yesterday.recordDate, today.recordDate) = 1
-- where today.temperature > yesterday.temperature


-- ======================== 10. Rank Scores =========================================================
-- Write a solution to find the rank of the scores. The ranking should be calculated according to the following rules:
    -- The scores should be ranked from the highest to the lowest.
    -- If there is a tie between two scores, both should have the same ranking.
    -- After a tie, the next ranking number should be the next consecutive integer value. In other words, there should be no holes between ranks.
-- Return the result table ordered by score in descending order.
-- The result format is in the following `score`, `rank`

-- select 
--     score
--     , DENSE_RANK() OVER (ORDER BY score DESC) AS rank
-- from Scores


-- ======================== 11. Customer Placing the Largest Number of Orders =======================
-- Write a solution to find the `customer_number` for the customer who has placed more orders than any other customers.
-- USE MyGuitarShop;
-- GO
-- select * from dbo.Orders;

-- select 
--     top 1 CustomerID
--     --, count(*) AS "Number of Orders"
-- from dbo.Orders 
-- group by CustomerID
-- order by count(*) DESC


-- ======================== 12. Project Employees I =================================================
-- USE MurachCollege;
-- GO 
-- -- CREATE VIEW v_InstructorTenure AS
-- -- SELECT 
-- --     InstructorID
-- --     , LastName
-- --     , HireDate
-- --     , DATEDIFF(YEAR, HireDate, GETDATE()) AS [Years of Working]
-- -- FROM Instructors;
-- -- GO
-- -- SELECT * FROM v_InstructorTenure;

-- -- select * from dbo.Departments;

-- select 
--     DepartmentID
--     -- , ROUND(AVG(CAST([Years of Working] AS DECIMAL(10,2))), 2) average_year
--     ,ROUND(SUM([Years of Working])*1.0/COUNT(v.InstructorID),2)  average_year -- convert to float by multiply by 1.0
-- from dbo.Courses c
-- JOIN v_InstructorTenure v on c.InstructorID = v.InstructorID
-- GROUP BY DepartmentID
-- -- having sum([Years of Working])/count(InstructorID)

-- DROP VIEW v_InstructorTenure; -- drop view table after 



-- ======================== 13. Swap Sex of Employees ===============================================
-- go
-- CREATE VIEW table1 AS select * from Instructors;
-- go
-- select * from table1;
-- UPDATE table1
-- SET Status = CASE 
--     When Status = 'F' then 'P'
--     ELSE 'F'
-- END
-- select * from table1;
-- drop view table1;


-- ======================== 14. 