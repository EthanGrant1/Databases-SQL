-- File: companyDML-a1.sql
-- SQL/DML (on the COMPANY database)
/*
--
IMPORTANT SPECIFICATIONS
--
(A)
-- Download the script file PA-06-companyDB.sql and use it to create your COMPANY database in sqlplus.
-- Dowlnoad the file companyDBinstance.pdf; it is provided for your convenience when checking the results of your queries.
--
(B)
--Implement the queries below by ***editing this file*** to include
your name and your SQL code in the indicated places.   
--
(C)
After you have written the SQL code in the appropriate places:
-- Run this file (from the command line in sqlplus). It will produce the spooled file companyDML-a1.txt.
-- Upload the spooled file (companyDML-a1.txt) to BB.*/
--
*/
SPOOL companyDML-a1.txt
SET ECHO ON
-- ---------------------------------------------------------------
-- 
-- Name: < Ethan Grant >
--
-- ------------------------------------------------------------
-- NULL AND SUBSTRINGS -------------------------------
--
/*(10A)
Find the ssn and last name of every employee who doesn't have a  supervisor, or his/her last name contains at least two occurences of the letter 'a'. Sort the results by ssn.
*/
SELECT E.Ssn, E.Lname
FROM Employee E
WHERE 	E.Super_ssn IS NULL OR 
	E.Lname LIKE '%a%a%'
ORDER BY E.Ssn ASC;
--
-- JOINING 3 TABLES ------------------------------
-- 
/*(11A)
For every employee who works more than 30 hours on any project: Find the ssn, lname, project number, project name, and number of hours. Sort the results by ssn.
*/
SELECT E.ssn, E.Lname, P.Pnumber, P.Pname, W.Hours
FROM Employee E, Project P, Works_On W
WHERE 	W.Essn = E.Ssn 		AND
	W.Pno = P.Pnumber	AND
	W.Hours > 30
ORDER BY E.Ssn ASC;
--
-- JOINING 3 TABLES ---------------------------
--
/*(12A)
Write a query that consists of one block only.
For every employee who works on a project that is not controlled by the department he works for: Find the employee's lname, the department he works for, the project number that he works on, and the number of the department that controls that project. Sort the results by lname.
*/
SELECT E.Lname, E.Dno, W.Pno, P.Dnum
FROM Employee E, Works_On W, Project P
WHERE	E.Ssn = W.Essn		AND
	W.Pno = P.Pnumber	AND
	E.Dno != P.Dnum
ORDER BY E.Lname ASC;
--
-- JOINING 4 TABLES -------------------------
--
/*(13A)
For every employee who works for more than 20 hours on any project that is located in the same location as his department: Find the ssn, lname, project number, project location, department number, and department location.Sort the results by lname
*/
SELECT E.Ssn, E.Lname, P.Pnumber, P.Plocation, P.Dnum, D.Dlocation
FROM Employee E, Project P, Dept_Locations D, Works_On W
WHERE	E.Ssn = W.Essn			AND
	W.Pno = P.Pnumber		AND
	P.Plocation = D.Dlocation	AND
	W.Hours > 20
ORDER BY E.Lname ASC;
--
-- SELF JOIN -------------------------------------------
-- 
/*(14A)
Write a query that consists of one block only.
For every employee whose salary is less than 70% of his/her immediate supervisor's salary: Find that employee's ssn, lname, salary; and their supervisor's ssn, lname, and salary. Sort the results by ssn.  
*/
SELECT E.Ssn, E.Lname, E.Salary, Sup.Ssn, Sup.Lname, Sup.Salary
FROM Employee E, Employee Sup
WHERE 	E.Super_ssn = Sup.Ssn	AND
	NOT (E.Salary >= 0.7*(Sup.Salary))
ORDER BY E.Ssn ASC;
--
-- USING MORE THAN ONE RANGE VARIABLE ON ONE TABLE -------------------
--
/*(15A)
For projects located in Houston: Find pairs of last names such that the two employees in the pair work on the same project. Remove duplicates. Sort the result by the lname in the left column in the result. 
*/
SELECT DISTINCT E1.Lname, E2.Lname
FROM Employee E1, Employee E2, Works_On W1, Works_On W2, Project P
WHERE 	E1.Lname != E2.Lname	AND
	E1.Ssn = W1.Essn	AND
	E2.Ssn = W2.Essn	AND
	W1.Essn != W2.Essn	AND
	W1.Pno = W2.Pno		AND
	P.Plocation = 'Houston'
ORDER BY E1.Lname;
--
------------------------------------
--
SET ECHO OFF
SPOOL OFF


