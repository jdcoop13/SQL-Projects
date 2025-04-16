--Input Dataset

 --emp_record_table: It contains the information of all the employees.

/*EMP_ID – ID of the employee
FIRST_NAME – First name of the employee
LAST_NAME – Last name of the employee
GENDER – Gender of the employee
ROLE – Post of the employee
DEPT – Field of the employee
EXP – The employee’s years of experience
COUNTRY – The employee’s current country of residence
CONTINENT – The employee’s continent of residence
SALARY – Salary of the employee
EMP_RATING – Performance rating of the employee
MANAGER_ID – The manager mapped to the employee
PROJ_ID – The project on which the employee is working or has worked on
*/
/*
 -- Proj_table: It contains information about the projects.
PROJECT_ID – ID for the project
PROJ_Name – Name of the project
DOMAIN – Field of the project
START_DATE – Day the project began
CLOSURE_DATE – Day the project was or will be completed
DEV_QTR – Quarter in which the project was scheduled
STATUS – Status of the project currently
*/

/*
Data_science_team: It contains information about all the employees in the Data Science team.
EMP_ID – ID of the employee
FIRST_NAME – First name of the employee
LAST_NAME – Last name of the employee
GENDER – Gender of the employee
ROLE – Post of the employee
DEPT – Field of the employee
EXP – Years of experience the employee has
COUNTRY – Country in which the employee is presently living
CONTINENT – Continent in which the country is
*/

--Action   

--Create a SQLite database called SQT_HR.
--Create tables then import data_science_team.csv proj_table.csv and emp_record_table.csv 
--into the employee database from the given resources.
--Create an ER diagram for the given employee database.

CREATE TABLE IF NOT EXISTS emp_record_table (
EMP_ID VARCHAR(255) PRIMARY KEY,
FIRST_NAME VARCHAR (255),
LAST_NAME VARCHAR (255),
GENDER VARCHAR (255),
ROLE VARCHAR (255),
DEPT VARCHAR (255),
EXP NUMERIC,
COUNTRY VARCHAR (255),
CONTINENT VARCHAR (255),
SALARY NUMERIC,
EMP_RATING NUMERIC,
MANAGER_ID VARCHAR (255),
PROJ_ID VARCHAR (255)
)

SELECT *
FROM emp_record_table

CREATE TABLE IF NOT EXISTS proj_table (
PROJECT_ID VARCHAR(255) PRIMARY KEY,
PROJ_Name VARCHAR(255),
DOMAIN VARCHAR(255),
START_DATE DATE,
CLOSURE_DATE DATE,
DEV_QTR VARCHAR(255),
STATUS VARCHAR(255)
)

SELECT *
FROM proj_table

CREATE TABLE IF NOT EXISTS Data_science_team (
EMP_ID VARCHAR(255),
FIRST_NAME VARCHAR(255),
LAST_NAME VARCHAR(255),
GENDER VARCHAR(255),
ROLE VARCHAR(255),
DEPT VARCHAR(255),
EXP NUMERIC,
COUNTRY VARCHAR(255),
CONTINENT VARCHAR(255)
)

SELECT *
FROM Data_science_team



--Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, and DEPARTMENT from the employee record table,
--and make a list of employees and details of their department.

SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT
FROM emp_record_table

--Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT, and EMP_RATING if the EMP_RATING is: 
	--less than two return "Below Average", greater than four return "Above Average", 
	--and between two and four return "Average".

SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING,
	CASE
		WHEN EMP_RATING < 2 THEN 'Below Average'
		WHEN EMP_RATING > 4 THEN 'Above Average'
		ELSE 'Average'
	END AS EMP_RATING_CATEGORY
FROM emp_record_table	

--Write a query to concatenate the FIRST_NAME and the LAST_NAME of employees 
--in the Finance department from the employee table and then give the resultant column alias as NAME.

SELECT CONCAT(FIRST_NAME, ' ', LAST_NAME) AS NAME
FROM emp_record_table
WHERE DEPT = 'FINANCE'

--Write a query to list only those employees who have someone reporting to them. 
--Also, show the number of reporters (including the President).

SELECT *
FROM emp_record_table

SELECT ert1.EMP_ID, ert1.FIRST_NAME, ert1.LAST_NAME, COUNT(ert2.EMP_ID) AS NUMBER_OF_REPORTERS
FROM emp_record_table ert1
INNER JOIN emp_record_table ert2 ON ert1.EMP_ID = ert2.MANAGER_ID
GROUP BY ert1.EMP_ID, ert1.FIRST_NAME, ert1.LAST_NAME

--Write a query to list all the employees from the healthcare and finance departments using union. 
--Take data from the employee record table.

SELECT EMP_ID, FIRST_NAME, LAST_NAME, DEPT
FROM emp_record_table
WHERE DEPT = 'HEALTHCARE'
UNION ALL
SELECT EMP_ID, FIRST_NAME, LAST_NAME, DEPT
FROM emp_record_table
WHERE DEPT = 'FINANCE'

--Write a query to list employee details such as EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPARTMENT, and EMP_RATING.
--Include the respective employee rating along with the max emp rating for each department.

SELECT EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPT, EMP_RATING
, MAX(EMP_RATING) OVER (PARTITION BY DEPT) AS MAX_DEPT_EMP_RATING
FROM emp_record_table
GROUP BY EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPT, EMP_RATING

--Write a query to calculate the minimum and the maximum salary of the employees in each role. 
--Take data from the employee record table.

SELECT EMP_ID, FIRST_NAME, LAST_NAME, ROLE, SALARY
, MIN(SALARY) OVER (PARTITION BY ROLE) AS ROLE_MIN_SALARY
, MAX(SALARY) OVER (PARTITION BY ROLE) AS ROLE_MAX_SALARY
FROM emp_record_table
GROUP BY EMP_ID, FIRST_NAME, LAST_NAME, ROLE, SALARY

--Write a query to assign ranks to each employee based on their experience. 
--Take data from the employee record table.

SELECT EMP_ID, FIRST_NAME, LAST_NAME, EXP
, ROW_NUMBER() OVER (ORDER BY EXP DESC) AS EXP_RANK
FROM emp_record_table
ORDER BY EXP DESC

--Write a query to create a view that displays employees in various countries whose salary is more than six thousand. 
--Take data from the employee record table.

CREATE VIEW EMP_SALARY_OVER_6K AS 
SELECT EMP_ID, FIRST_NAME, LAST_NAME, COUNTRY, SALARY
FROM emp_record_table
WHERE SALARY > 6000

--Write a nested query to find employees with experience of more than ten years. 
--Take data from the employee record table.

SELECT EMP_ID, FIRST_NAME, LAST_NAME, EXP
FROM (
	SELECT EMP_ID, FIRST_NAME, LAST_NAME, EXP
	FROM emp_record_table
	WHERE EXP > 10
) 

--Write a query to check whether the job profile assigned to each employee in the data science team 
--matches the organization’s set standard.The standard being:
	--For an employee with experience less than or equal to 2 years assign 'JUNIOR DATA SCIENTIST',
	--For an employee with the experience of 2 to 5 years assign 'ASSOCIATE DATA SCIENTIST',
	--For an employee with the experience of 5 to 10 years assign 'SENIOR DATA SCIENTIST',
	--For an employee with the experience of 10 to 12 years assign 'LEAD DATA SCIENTIST',
	--For an employee with the experience of 12 to 16 years assign 'MANAGER'.

SELECT EMP_ID, FIRST_NAME, LAST_NAME, ROLE, EXP, 
	CASE
		WHEN EXP <= 2 THEN 'JUNIOR DATA SCIENTIST'
		WHEN EXP > 2 AND EXP <= 5 THEN 'ASSOCIATE DATA SCIENTIST'
		WHEN EXP > 5 AND EXP <= 10 THEN 'SENIOR DATA SCIENTIST'
		WHEN EXP > 10 AND EXP <= 12 THEN 'LEAD DATA SCIENTIST'
		WHEN EXP > 12 AND EXP <= 16 THEN 'MANAGER'
	END AS ORG_STANDARD_EXP_ROLE,
	CASE
		WHEN ROLE = 
			CASE
				WHEN EXP <= 2 THEN 'JUNIOR DATA SCIENTIST'
				WHEN EXP > 2 AND EXP <= 5 THEN 'ASSOCIATE DATA SCIENTIST'
				WHEN EXP > 5 AND EXP <= 10 THEN 'SENIOR DATA SCIENTIST'
				WHEN EXP > 10 AND EXP <= 12 THEN 'LEAD DATA SCIENTIST'
				WHEN EXP > 12 AND EXP <= 16 THEN 'MANAGER'
			END
		THEN 'ORG STANDARD'
		ELSE 'NOT ORG STANDARD'
	END AS ORG_STANDARD_ROLE_CHECK
FROM Data_science_team	

--Write a query to calculate the bonus for all the employees, based on their ratings and salaries
--(Use the formula: 5% of salary * employee rating).

SELECT EMP_ID, FIRST_NAME, LAST_NAME, SALARY, EMP_RATING
, ((SALARY * .05) * EMP_RATING) AS EMP_BONUS
FROM emp_record_table

--Write a query to calculate the average salary distribution based on the continent and country. 
--Take data from the employee record table.

SELECT CONTINENT, COUNTRY
, AVG(SALARY) OVER (PARTITION BY CONTINENT) as AVG_CONTINENT_SALARY
, AVG(SALARY) OVER (PARTITION BY COUNTRY) as AVG_COUNTRY_SALARY
FROM emp_record_table
GROUP BY CONTINENT, COUNTRY










































