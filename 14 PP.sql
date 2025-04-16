--In SQL Challenges database, you will create the patients table first:

CREATE TABLE IF NOT EXISTS patients_new(
Patient_ID Numeric Primary Key, 
First_Name VARCHAR(255),
Last_Name VARCHAR(255),
DOB Date,
Weight Numeric,
Gender VARCHAR(255),
City VARCHAR(255),
State VARCHAR(255),
Hospital VARCHAR(255),
Department VARCHAR(255),
Admission_Date Date,
Diagnosis VARCHAR(255),
Diagnosis_ID VARCHAR(255),
Doctors_First_Name VARCHAR(255),
Doctors_Last_Name VARCHAR(255),
Doctor_ID Numeric
);

--Write a query to create a patients table with patient ID, name, dob, weight, 
--gender, city, state, hospital, department, admission date, diagnosis, diagnosis id, doctor's name, and doctor ID. 
--Make sure field names match the file structure and that the data types are correct

SELECT *
FROM patients_new

--Now, import patients.csv file to the populate the table

SELECT *
FROM patients_new

--Writes queries of at least 4-5 data quality checks of the table including the count of patients in the table

Select *
FROM patients_new 
WHERE Patient_ID = ''

DELETE FROM patients_new
WHERE Patient_ID = ''

--Found null patient and removed

Select COUNT(Patient_ID) as Count_of_Patients
FROM patients_new

SELECT *, COUNT(*) as Duplicates
FROM patients_new
GROUP BY Patient_ID, First_Name, Last_Name, DOB, Weight, Gender, City, State, Hospital, Department, Admission_Date
, Diagnosis, Diagnosis_ID, Doctors_First_Name, Doctors_Last_Name, Doctor_ID
HAVING COUNT(*) > 1;

SELECT *
FROM patients_new 
WHERE Patient_ID is null or First_Name is null or Last_Name is null or DOB is null or Weight is null or 
Gender is null or City is null or State is null or Hospital is null or Department is null or 
Admission_Date is null or Diagnosis is null or Diagnosis_ID is null or Doctors_First_Name is null or 
Doctors_Last_Name is null or Doctor_ID is null;

SELECT COUNT(*) as Row_Count
FROM patients_new


--Write separate queries for items below:
--Write a query to display the patient id and patient name with the current date

SELECT patient_id, First_Name, Last_Name, date('now') as Current_Date
FROM patients_new

--Write a query to display the old patient name and the new patient name in uppercase

Select First_Name as Old_Patient_First_Name , Last_Name as Old_Patient_Last_Name
, upper(First_Name) as New_Patient_First_Name, upper(Last_Name) as New_Patient_Last_Name
From Patients_new;

--Write a query to display the patients' combined names along with the total number of characters in their name

Select CONCAT(First_Name, ' ', Last_Name) as Patient_Name
, sum(length(CONCAT(First_Name, ' ', Last_Name))) as Number_of_Characters
FROM patients_new
GROUP BY Patient_Name

 --Write a query to combine the patient's combined name and the doctor's last name 
 --in a new column separated with a hyphen

Select CONCAT(First_Name, ' ', Last_Name, ' - ', Doctors_last_Name) as Patient_and_Doctor
FROM patients_new

--Write a query to extract the year for a given date and place it in a separate column

Select DOB, strftime('%Y',DOB) as DOB_Year
FROM patients_new

--Write a query to calculate the patient's age at the time of admission

Select First_Name, Last_Name, DOB, Admission_Date
, ((JULIANDAY(Admission_Date) - JULIANDAY(DOB)) / 365) as Patient_Current_Age
FROM patients_new 

--Write a query using a function to create an age group column for patients under 27 
--with a result value 'Gen-Z' and all other patients called 'Other'

Select First_Name, Last_Name, ((JULIANDAY(Admission_Date) - JULIANDAY(DOB)) / 365) as Patient_Current_Age,
	CASE
		WHEN ((JULIANDAY(Admission_Date) - JULIANDAY(DOB)) / 365) < 27 THEN 'Gen-Z'
		ELSE 'Other'
	END as Age_Group
FROM patients_new
	









































