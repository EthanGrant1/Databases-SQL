SPOOL db.txt 
SET ECHO ON 
/* 
Homework: create DB 
Author: <enter your first and last name here> 
*/ 
SELECT * FROM Sailors; 
SELECT * FROM Boats; 
SELECT * FROM Reservations; 
SELECT * FROM LazySailors; 
SET AUTOCOMMIT ON; 
INSERT INTO Sailors VALUES (22, 'Dave', 6, 45.0, 95); 
INSERT INTO Sailors VALUES (21, 'Jay', 6, 45.0, 99); 
INSERT INTO Sailors VALUES (92, 'Popeye', 17, 45.0, 95); 
SET ECHO OFF 
SPOOL OFF