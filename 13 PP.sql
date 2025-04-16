-- Write a query to create a students table with the student ID, first name, last name, 
-- class, and age fields. Ensure that the last name, first name, 
-- and student ID fields have the NOT NULL constraint, and that the student ID field is a primary key

CREATE TABLE IF NOT EXISTS students(
Student_ID Numeric Primary Key Not Null, 
First_Name VARCHAR(255) not null,
Last_Name VARCHAR(255) not null,
Class VARCHAR(255),
Age Numeric
);

-- Write a query to create a marksheet table with score, year, ranking, class, and student ID fields 

CREATE TABLE IF NOT EXISTS marksheet(
Score Numeric, 
Year Numeric,
Class Numeric,
Ranking Numeric,
Student_ID Numeric
);

-- Write a query to insert values into the students and marksheet tables (refer to the csv files for data) 

Insert into students (Student_ID, First_Name, Last_Name, Class, Age)
Values
	(1, 'krishna', 'gee',10,18),
	(2, 'Stephen', 'Christ',10,17),
	(3, 'Kailash', 'kumar',10,18),
	(4, 'ashish', 'jain',10,16),
	(5, 'khusbu', 'jain',10,17),
	(6, 'madhan', 'lal',10,16),
	(7, 'saurab', 'kothari',10,15),
	(8, 'vinesh', 'roy',10,14),
	(9, 'rishika', 'r',10,15),
	(10, 'sara', 'rayan',10,16),
	(11, 'rosy', 'kumar',10,16);

Select *
FROM students
	
Insert into marksheet (Score, Year, Class, Ranking, Student_ID)
Values
	(989, 2014, 10,1,1),
	(454, 2014, 10,10,2),
	(880, 2014, 10,4,3),
	(870, 2014, 10,5,4),
	(720, 2014, 10,7,5),
	(670, 2014, 10,8,6),
	(900, 2014, 10,3,7),
	(540, 2014, 10,9,8),
	(801, 2014, 10,6,9),
	(420, 2014, 10,11,10),
	(970, 2014, 10,2,11),
	(720, 2014, 10,12,12);

Select *
FROM marksheet

-- Write a query to display the student ID and first name of every student in the students table 
-- whose age is greater than or equal to 16 and whose last name is Kumar 

SELECT Student_ID, First_name
FROM students 
WHERE Age >= 16 or Last_Name = 'Kumar'

-- Write a query to display the details of every student from the marksheet table whose score is 
-- between 800 and 1000 

SELECT Year, Ranking, Class, Student_ID
FROM marksheet 
WHERE Score between 800 and 1000

-- Write a query to increase the score in the marksheet table by five and create a new score column 
-- to display this new score 

SELECT *, Score + 5 as New_Score
FROM marksheet

-- Write a query to display the marksheet table in descending order of the score 

SELECT *
FROM marksheet
ORDER BY Score DESC

-- Write a query to display the details of every student whose first name starts with an ‘s’ 

SELECT Student_ID, Last_Name, Class, Age
FROM students
WHERE First_Name LIKE 'S%'






























