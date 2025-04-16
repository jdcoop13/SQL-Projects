--Employee Table and Sales Table
	--Write a query to create a table using the employee_data.csv and sales_data.csv in the SQL Challenges database
	
CREATE TABLE IF NOT EXISTS employee_data(
emp_id Numeric Primary Key, 
f_name VARCHAR(255),
l_name VARCHAR(255),
job_id VARCHAR(255),
salary numeric,
manager_id numeric,
dept_id numeric
);

CREATE TABLE IF NOT EXISTS sales_data(
Order_ID Numeric, 
Order_Date Date,
Ship_Date Date,
DOB Date,
Region VARCHAR(255),
Product_ID VARCHAR(255),
Category VARCHAR(255),
Sub_Category VARCHAR(255),
Product_Name VARCHAR(255),
Sales Numeric,
Quantity Numeric,
Discount Numeric,
Profit Numeric,
Salesrep Numeric
);
	
	--Import the employee_data.csvLinks to an external site. and sales_data.csvLinks to an external site. 
	--file into the tables
	
Select *	
FROM employee_data 

Select *
FROM sales_data
	
	--Perform data quality checks to confirm proper import
	--Utilize any necessary joins or set operations during the creation if applicable
	--Create an ER Diagram (Upload a screenshot/image)

SELECT *, COUNT(*) as Duplicates
FROM employee_data
GROUP BY emp_id, f_name, l_name, job_id, salary, 
manager_id, dept_id
HAVING COUNT(*) > 1;

SELECT *, COUNT(*) as Duplicates
FROM sales_data
GROUP BY Order_ID, Order_Date, Ship_Date, Region, Product_ID, Category, Sub_Category, Product_Name, Sales, Quantity, 
Discount, Profit, Salesrep
HAVING COUNT(*) > 1;

SELECT *
FROM employee_data 
WHERE emp_id is null or f_name is null or l_name is null or job_id is null or salary is null or 
manager_id is null or dept_id is null;

SELECT *
FROM sales_data 
WHERE Order_ID is null or Order_Date is null or Ship_Date is null or Region is null or Product_ID is null or 
Category is null or Sub_Category is null or Product_Name is null or Sales is null or Quantity is null or 
Discount is null or Profit is null or Salesrep is null;

--Retrieve Names and Products Sold
	--Execute SQL code to show total products sold by employees. Make sure to show results for all employees.

Select emp_id, f_name, l_name, IFNULL(sum(quantity),0) as Total_Products
FROM employee_data ed
LEFT JOIN sales_data sd on ed.emp_id = sd.Salesrep
GROUP BY emp_id, f_name, l_name

--Regions, Sales Rep, Sales
	--Execute SQL to show Final Sales (Quantity, Sales with Discount ) by region and Sales Rep

Select Salesrep, Region, SUM(sales * quantity * (1 - Discount)) as Final_Sales
FROM employee_data ed
INNER JOIN sales_data sd on ed.emp_id = sd.Salesrep
GROUP BY Salesrep, Region

--Classify Profits by Type and Amount (Using Joins and Set Operations)
	--Execute SQL code to flag profit losses vs gains with terms 'Loss' or 'Gain' . 
	--Column name should be called 'Profit Status'. Final columns Sales Rep Name, 
	--Category, Profit amount, Profit Status

Select f_name || ' ' || l_name as Salesrep_Name, Category, Profit as Profit_Amount,
	CASE
		WHEN Profit LIKE '-%' THEN 'Loss'
		ELSE 'Gain'
	END as Profit_Status
FROM employee_data ed
INNER JOIN sales_data sd on ed.emp_id = sd.Salesrep
GROUP BY Salesrep_Name, Category, Profit

--Display Top and Bottom Earners (Using Joins and Set Operations)
	--Write a query to get the average salary

Select avg(salary)
FROM employee_data ed
INNER JOIN sales_data sd on ed.emp_id = sd.Salesrep


	--Execute SQL code to display top earners and the bottom earners based on average salary.  
	--Include the first and last name , employee ID, salary, total sales and region. 
	--Create a column with the values of 'Top Earner' or 'Bottom Earner'

Select f_name, l_name, emp_id, salary, Region, SUM(sales * quantity * (1 - Discount)) as Total_Sales,
	CASE
		WHEN salary > 81800 THEN 'Top Earner'
		ELSE 'Bottom Earner'
	END as Top_and_Bottom_Earners
FROM employee_data ed
INNER JOIN sales_data sd on ed.emp_id = sd.Salesrep
GROUP BY f_name, l_name, emp_id, salary, Region






































