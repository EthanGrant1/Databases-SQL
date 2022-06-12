-- File: companyDML-a2.sql
-- SQL/DML (on the COMPANY database)
/*
--
IMPORTANT SPECIFICATIONS
--
(A)
-- Use the COMPANY database that you created in the previous DML assignment.
--
(B)
--Implement the queries below by ***editing this file*** to include
your name and your SQL code in the indicated places.   
--
(C)
After you have written the SQL code in the appropriate places:
-- Run this file (from the command line in sqlplus). It will produce the spooled file companyDML-a2.txt.
-- Upload the spooled file (companyDML-a2.txt) to BB.*/
--
*/
SPOOL companyDML-a2.txt
SET ECHO ON
-- ---------------------------------------------------------------
-- 
-- Name: Ethan Grant
--
-- ------------------------------------------------------------
--
/*(16A) Hint: A NULL in the hours column should be considered as zero hours.
Find the ssn, lname, and the total number of hours worked on projects for every employee whose total is less than 40 hours. Sort the result by lname
*/ 
SELECT E.ssn, E.Lname, sum(W.Hours)
FROM Employee E, Works_On W
WHERE E.ssn = W.Essn
GROUP BY E.Ssn, E.Lname
HAVING sum(W.Hours) < 40
ORDER BY E.Lname ASC;
--
------------------------------------
-- 
/*(17A)
For every project that has more than 2 employees working on it: Find the project number, project name, number of employees working on it, and the total number of hours worked by all employees on that project. Sort the results by project number.
*/ 
SELECT P.Pnumber, P.Pname, COUNT(W.Essn), sum(W.Hours)
FROM Project P, Works_On W
WHERE   W.Pno = P.Pnumber
GROUP BY P.Pnumber, P.Pname
HAVING COUNT(W.Essn) > 2
ORDER BY P.Pnumber;
-- 
-- CORRELATED SUBQUERY --------------------------------
--
/*(18A)
For every employee who has the highest salary in their department: Find the dno, ssn, lname, and salary. Sort the results by department number.
*/
SELECT E.Dno, E.Ssn, E.Lname, E.Salary
FROM Employee E
WHERE E.Salary = 
      (SELECT MAX(E1.Salary)
       FROM Employee E1
       WHERE E1.Dno = E.Dno)
ORDER BY E.Dno;
--
-- NON-CORRELATED SUBQUERY -------------------------------
--
/*(19A)
For every employee who does not work on any project that is located in Houston: Find the ssn and lname. Sort the results by lname
*/
SELECT E.Ssn, E.Lname
FROM Employee E, Dept_Locations D
WHERE E.Dno = D.Dnumber AND
      D.Dlocation NOT IN (SELECT D.Dlocation
                          FROM Dept_Locations D
                          WHERE D.Dlocation = 'Houston')
ORDER BY E.Lname ASC;
--
-- DIVISION ---------------------------------------------
--
/*(20A) Hint: This is a DIVISION query
For every employee who works on every project that is located in Stafford: Find the ssn and lname. Sort the results by lname
*/
SELECT E.Ssn, E.Lname
FROM Employee E
WHERE NOT EXISTS ((SELECT P.Plocation
                   FROM Project P
                   WHERE P.Plocation = 'Stafford')
                   MINUS
                   (SELECT P.Plocation
                    FROM Project P, Works_On W
                    WHERE  P.Plocation = 'Stafford' AND
                           W.Essn = E.Ssn           AND
                           W.Pno = P.Pnumber))
ORDER BY E.Lname ASC;
--
SET ECHO OFF
SPOOL OFF


