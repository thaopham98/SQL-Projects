USE master;
GO

DROP DATABASE IF EXISTS TransactionDB;
GO

CREATE DATABASE TransactionDB;
GO

USE TransactionDB
GO
------------------------------------
CREATE TABLE Accounts(
	AccountNumber int PRIMARY KEY IDENTITY(1,1),
	CurrentBalance money
)

CREATE TABLE Transactions(
	TransactionID int PRIMARY KEY IDENTITY (1,1),
	AccountNumber int FOREIGN KEY REFERENCES Accounts(AccountNumber),
	TranType varchar(10) CHECK(TranType IN ('Withdrawal','Deposit')),
	TranLoc varchar(7) CHECK(TranLoc IN ('ATM','Counter')),
	TranAmount money CHECK (TranAmount >0),
	TranDateTime datetime NOT NULL 
)
-----------------------
INSERT INTO Accounts 
VALUES(1000),
	  (500),
	  (2500)

SELECT * FROM Accounts
-----------------

INSERT INTO Transactions
VALUES (1, 'Withdrawal','ATM', 100,GETDATE())

GO 

SELECT * FROM Transactions

----------------------------------------------
GO
ALTER PROC AddTransaction
	@AccountNumber int,
	@TranactionType varchar(40),
	@TransactionLocation varchar(40),
	@Amount money
AS

--check if account number exists
IF @AccountNumber NOT IN (SELECT AccountNumber FROM Accounts)
	THROW 50001, 'Account Number not found',1
 
--Check if type is either withdrawal or deposit
IF @TranactionType NOT IN ('Withdrawal','Deposit')
	THROW 50002, 'Trasaction type not accepted', 2

--Check if location is ATM or Counter
IF @TransactionLocation NOT IN ('ATM', 'Counter')
	THROW 50003, 'Transaction Location not accepted' , 2

--Check if amount >0
IF @Amount <=0
	THROW 50004, 'Amount needs to be greater than 0' , 2


INSERT INTO Transactions
VALUES (@AccountNumber,@TranactionType,@TransactionLocation,@Amount, GETDATE())

--
EXEC AddTransaction 1, 'Deposit','ATM', 200

-----
--Alter the procedure to update the accounts table as well depending if the transaction is 
--withdrawal or deposit
--In withdrawal cases you need to make sure that there are enough funds available 

--exec for different scenarios to make sure it works 