-- SQL Project - Data Cleaning - I am initially cleaning this data to later explore in the EDA Project

-- https://www.kaggle.com/datasets/swaptr/layoffs-2022


SELECT * 
FROM layoffs;

-- Table of Contents
-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null Values or Blank Values
-- 4. Remove any Columns

-- I want to first create a staging table where I can clean data and in case
-- something happens I don't lose the original raw data

CREATE TABLE layoffs_staging
LIKE layoffs;


SELECT *
FROM layoffs_staging;

INSERT layoffs_staging
SELECT *
FROM layoffs;

-- 1. Remove Duplicates
-- First, I'll check for duplicates

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num 
FROM layoffs_staging;

WITH duplicate_cte AS
(SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage
, country, funds_raised) AS row_num 
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

-- I'll check 'Oda' to confirm

SELECT *
FROM layoffs_staging
WHERE company = 'Oda';
-- All entries look good and shouldn't be deleted

-- These are the duplicates I want to delete: where row num > 1
WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage
, country, funds_raised) AS row_num 
FROM layoffs_staging
)
DELETE 
FROM duplicate_cte
WHERE row_num > 1;

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage
, country, funds_raised) AS row_num 
FROM layoffs_staging;

-- Now that I have this I can delete rows where row_num is greater than 1

DELETE
FROM layoffs_staging2
WHERE row_num > 1;

SELECT *
FROM layoffs_staging2;


-- 2. Standardizing Data - Finding issues and fixing them

-- Some companies were slightly offset from the left so I trimmed it
SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

-- I noticed Crypto has multiple variations so I standardize it by changing them all to say 'Crypto'

SELECT DISTINCT industry
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- Some 'United States' had a period at the end so I standardized that

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

-- The date column wasn't formatted correctly so I standardized that

SELECT `date`
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');


ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE; 

-- 3. Null Values or Blank Values

-- There are some null and empty rows in the industry column so I took a look at them

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL;

-- I made a plan to change every blank space to null so everything would be the same, and then fill those in

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';

-- I checked Bally, does not have another populated row to fill in null values
SELECT *
FROM layoffs_staging2
WHERE company LIKE 'Bally%';

-- I wrote a query to say that if there is another row with the same company name, it will update it to the
-- non-null industry values
-- I found that to be the easiest way so that if there were hundreds of them I wouldn't have to check them all

SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

SELECT *
FROM layoffs_staging2;

-- 4. Remove any Columns or Rows

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Since there is no data in the Columns for total laid off and percentage laid off, there's no way for 
-- me to tell whether they actually laid anyone off or not, so they are useless and were deleted

SELECT *
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

