/*DROP DATABASE IF EXISTS LA3;
CREATE DATABASE LA3;
USE LA3;
DROP TABLE IF EXISTS Term;
CREATE TABLE Term
(
	terms_id INT PRIMARY KEY AUTO_INCREMENT,
    terms_description VARCHAR(50) NOT NULL,
    terms_due_days INT NOT NULL
);

-- INSERT statement
INSERT INTO Term
VALUES 
(6, 'Net due 120 days', 120)
*/

-- DESCRIBE Term;

-- UPDATE statement
/*UPDATE Term
SET terms_description = 'Net due 125 days',
	terms_due_days = 125
WHERE terms_id = 6*/

-- DELETE statement
/*DELETE FROM Term
WHERE terms_id = 6*/