-- Step 1: always start from master
USE master;
GO

-- Step 2: drop database if exists
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'LA2')
BEGIN
    ALTER DATABASE LA2 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE LA2;
END;
GO

-- Step 3: create database
CREATE DATABASE LA2;
GO

-- Step 4: switch to it (must be in new batch)
USE LA2;
GO

-- Step 5: drop tables in correct order
DROP TABLE IF EXISTS members_committees;
DROP TABLE IF EXISTS members;
DROP TABLE IF EXISTS committees;
GO

-- Step 6: create tables
CREATE TABLE members
(
	member_id INT PRIMARY KEY IDENTITY(1,1),
	first_name VARCHAR(50) NOT NULL, 
	last_name VARCHAR(50) NOT NULL, 
	address VARCHAR(50) NOT NULL, 
	city VARCHAR(25) NOT NULL, 
	state CHAR(2),
	phone VARCHAR(20)
);

CREATE TABLE committees 
(
	committee_id INT PRIMARY KEY, 
	committee_name VARCHAR(50) NOT NULL
);

CREATE TABLE members_committees
(
	member_id INT NOT NULL,
    committee_id INT NOT NULL, 
	CONSTRAINT members_committees_fk_members
		FOREIGN KEY (member_id)
		REFERENCES members (member_id),
	CONSTRAINT member_committees_fk_committees
		FOREIGN KEY (committee_id)
		REFERENCES committees (committee_id)
);
GO