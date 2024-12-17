-- Exploratory Data Analysis

-- I explored the data to find trends, patterns, or anything interesting like outliers


SELECT *
FROM layoffs_staging2;

-- I started just looking at how big the layoffs were
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

-- I looked to see what companies totally went under with 1.0 or 100% of employees laid off
-- Ordering by funds_raised_millions allowed me to see how big these companies were
-- Quibi had almost 2 billion dollars raised and still went under, very interesting
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- Here I looked at companies with the most layoffs
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- looked at the window in which all of these layoffs went down in
SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

-- Looked at total layoffs by country to see who had the most (not surprised it was the U.S.)
SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT *
FROM layoffs_staging2;

-- Looked at which stages companies with the most layoffs were in
SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;


SELECT company, AVG(percentage_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;


-- I looked at total layoffs per month
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;

-- I then wanted to make a rolling total for all of the layoffs per month
WITH Rolling_Total AS
(SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, total_off,
SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- I looked at companies by the year and how many people they laid off in that year
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

-- I then created a CTE because I wanted to see the top 5 companies with the most layoffs per year ranked
WITH Company_Year (company, years, total_laid_off) AS
(SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS -- Then I gave the CTE a rank and used it as another CTE that hits off the first CTE
(SELECT *, 
DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5; -- Then I queried off the final CTE
-- And finally, that allowed me to see the top 5 companies with the most layoffs per year ranked
































