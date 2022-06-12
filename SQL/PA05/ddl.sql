SPOOL ddl.txt 
SET ECHO ON  
--  
-- Author: Ethan Grant
-- 
-- IMPORTANT: use the names IC-1, IC-2, etc. as given below. 
-- -------------------------------------------------------------------- 
/*The following DROP command is inserted for convenience so that if you need 
to recompile your code, it will drop the table (if it already exists). 
*/ 
DROP TABLE Orders CASCADE CONSTRAINTS; 
DROP TABLE OrderLine CASCADE CONSTRAINTS; 
-- 
CREATE TABLE Orders 
( 
orderNum   INTEGER PRIMARY KEY,  
priority   CHAR(10) NOT NULL, 
cost       INTEGER NOT NULL, 
/* 
IC1: The priority is one of: high, medium, or low 
*/ 
CONSTRAINT IC1 CHECK (priority IN ('high', 'medium', 'low')),
/* 
IC2: The cost of a high priority order is above 2000. 
*/ 
CONSTRAINT IC2 CHECK (NOT(cost <= 2000 AND priority = 'high')),
/* 
IC3: The cost of a medium priority order is between 800 and 2200 (inclusive). 
*/ 
CONSTRAINT IC3 CHECK (NOT((cost < 800 OR cost > 2200) AND priority = 'medium')),
/* 
IC4: The cost of a low priority order is less than 1000. 
*/ 
CONSTRAINT IC4 CHECK (NOT(cost >= 1000 AND priority = 'low'))
);
-- 
-- 
CREATE TABLE  OrderLine 
( 
orderNum       INTEGER, 
lineNum        INTEGER, 
item           CHAR (10)  NOT NULL, 
quantity       INTEGER, 
PRIMARY KEY (orderNum, lineNum), 
/* 
IC5: Every order line must belong to an order in the Order table.  
Also: if an order is deleted then all its order lines must be deleted. 
IMPORTANT: DO NOT declare this IC as DEFERRABLE. 
*/ 
CONSTRAINT IC5 FOREIGN KEY (orderNum)
		REFERENCES Orders (orderNum)
		ON DELETE CASCADE
); 
-- 
-- ---------------------------------------------------------------- 
-- TESTING THE SCHEMA 
-- ----------------------------------------------------------------
-- Accepted
INSERT INTO Orders VALUES (10, 'high', 2400);
-- Rejected
INSERT INTO Orders VALUES (20, 'high', 1900);
-- Accepted
INSERT INTO Orders VALUES (30, 'high', 2100);
-- Rejected
INSERT INTO Orders VALUES (40, 'medium', 700);
-- Rejected
INSERT INTO Orders VALUES (50, 'low', 1100);
-- Accepted
INSERT INTO Orders VALUES (60, 'low', 900);
SELECT * from Orders; 
-- ---------------------------------------------------------------- 
INSERT INTO OrderLine VALUES (10, 1, 'AAA', 200);	
INSERT INTO OrderLine VALUES (10, 2, 'BBB', 300);
INSERT INTO OrderLine VALUES (60, 1, 'CCC', 5);
INSERT INTO OrderLine VALUES (15, 1, 'AAA', 7);
SELECT * FROM OrderLine; 
-- 
-- All accepted except for OrderLine 15

DELETE FROM Orders WHERE orderNum = 10;
SELECT * From Orders;
SELECT * FROM OrderLine;
-- Only Order 30 and 60
-- Only OrderLine (60, 1, 'CCC', 5)

SET ECHO OFF 
SPOOL OFF 