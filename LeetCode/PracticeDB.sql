-- Create a new database
-- CREATE DATABASE EmployeeDB;
-- GO

-- Use the new database
USE EmployeeDB;
GO

-- DROP TABLE IF EXISTS Employee;
-- -- -- Create the Employee table
-- CREATE TABLE Employee (
--     id INT PRIMARY KEY,
--     name VARCHAR(50) NOT NULL,
--     department CHAR(1) NOT NULL,
--     manager_id INT NULL,
--     FOREIGN KEY (manager_id) REFERENCES Employee(id),
--     salary INT NULL, 
-- );
-- GO

-- -- -- Insert the data
-- INSERT INTO Employee (id, name, department, manager_id, salary) VALUES
-- (101, 'John', 'A', NULL, 500),
-- (102, 'Dan', 'A', 101, 50),
-- (103, 'James', 'A', 101, 40),
-- (104, 'Amy', 'A', 101, 40),
-- (105, 'Anne', 'A', 101, 40),
-- (106, 'Ron', 'B', 101, 60),
-- (107, 'Jon', 'C', NULL, 300),
-- (108, 'Don', 'A', 107, NULL),
-- (109, 'Hames', 'C', 107, 200),
-- (110, 'Manny', 'C', 107, 75),
-- (111, 'Marie', 'B', 107, 80),
-- (112, 'Jenny', 'B', 107, 240),
-- (113, 'Danny', 'A', NULL, 280),
-- (114, 'Jess', 'A', 113, NULL),
-- (115, 'Tom', 'A', 113, 60),
-- (116, 'Tim', 'A', 107, 50),
-- (117, 'Brit', 'A', 113, NULL),
-- (118, 'Jack', 'B', 107, 100);
-- GO

-- -- Verify the data was inserted correctly
-- SELECT * FROM Employee;
-- GO

-- CREATE TABLE Customers (
--     id INT PRIMARY KEY,
--     name VARCHAR(20) NOT NULL
-- );

-- GO

-- CREATE TABLE Orders (
--     id INT PRIMARY KEY,
--     customerId INT FOREIGN KEY REFERENCES Customers(id)
-- );

-- GO

-- INSERT INTO Customers(id, name) VALUES
-- (1, 'Joe'), 
-- (2, 'Henry'), 
-- (3, 'Sam'), 
-- (4, 'Max');

-- INSERT INTO Orders (id, customerId) VALUES
-- (1, 3),
-- (2, 1);

GO


-- IF (OBJECT_ID('Weather') IS NOT NULL)
--     BEGIN
--         PRINT 'Table with the same name available'
--     END
-- ELSE
--     BEGIN
--         PRINT 'Table NOT exist, creating a new table'

--         CREATE TABLE Weather (id int, recordDate date, temperature int)
--         Truncate table Weather
--         insert into Weather (id, recordDate, temperature) values ('1', '2015-01-01', '10')
--         insert into Weather (id, recordDate, temperature) values ('2', '2015-01-02', '25')
--         insert into Weather (id, recordDate, temperature) values ('3', '2015-01-03', '20')
--         insert into Weather (id, recordDate, temperature) values ('4', '2015-01-04', '30')
--     END


--  IF (OBJECT_ID('Scores') IS NOT NULL)
--     BEGIN
--         PRINT 'Table with the same name, Scores, available'
--     END
-- ELSE
--     BEGIN
--         PRINT 'Table Scores NOT exist, creating a new table'

--         Create table Scores(id int, score DECIMAL(3,2))
--         Truncate table Scores
--         insert into Scores (id, score) values ('1', '3.5')
--         insert into Scores (id, score) values ('2', '3.65')
--         insert into Scores (id, score) values ('3', '4.0')
--         insert into Scores (id, score) values ('4', '3.85')
--         insert into Scores (id, score) values ('5', '4.0')
--         insert into Scores (id, score) values ('6', '3.65')
--     END


-- IF (OBJECT_ID('Orders') IS NOT NULL)
--     BEGIN
--         PRINT 'Table with the same name, Orders, available'
--     END
-- ELSE
--     BEGIN
--         PRINT 'Table Orders NOT exist, creating a new table'

--         CREATE TABLE Orders (order_number int, customer_number int)
--         Truncate table Orders
--         insert into Orders (order_number, customer_number) values (1, 1)
--         insert into Orders (order_number, customer_number) values (2, 2)
--         insert into Orders (order_number, customer_number) values (3, 3)
--         insert into Orders (order_number, customer_number) values (4, 3)
--     END