-- Microsoft SQL Server on Docker
DROP DATABASE IF EXISTS LA2; -- check if LA2 Database exists or not. if exists, then drop it
CREATE DATABASE LA2; -- create a new LA2 database
USE LA2;
GO -- send everything above this line to SQL SERVER as 1 batch, then start fresh

DROP TABLE IF EXISTS members;
CREATE TABLE members
(
	member_id INT PRIMARY KEY IDENTITY(1,1), -- IDENTITY(1,1) auto increment 
	first_name VARCHAR(50) NOT NULL, 
	last_name VARCHAR(50) NOT NULL, 
	address VARCHAR(50) NOT NULL, 
	city VARCHAR(25) NOT NULL, 
	state CHAR(2),
	phone VARCHAR(20)
);
DROP TABLE IF EXISTS committees;
CREATE TABLE committees 
(
	committee_id INT PRIMARY KEY, 
	committee_name VARCHAR(50) NOT NULL
);
DROP TABLE IF EXISTS members_committees;
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