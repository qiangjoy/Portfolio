-- Data Cleaning and Analysis in SQL

-- This project demonstrates a comprehensive approach to data cleaning and exploratory data analysis using SQL.
-- The dataset used in this project contains details about world layoffs from 2020 - 2022, including company, industry, location, and other related attributes.



-- 1. DATA CLEANING
	-- Step 1. Create a Staging Table to avoid working with the raw data
CREATE TABLE layoffs_staging
LIKE layoffs;

INSERT INTO layoffs_staging
SELECT *
FROM layoffs;

	-- Step 2. Check for and remove duplicates. 
WITH duplicate_cte AS (
  SELECT *,
         ROW_NUMBER() OVER (
           PARTITION BY company, location, industry, total_laid_off, 
                        percentage_laid_off, `date`, stage, country, funds_raised_millions
         ) AS row_num
  FROM layoffs_staging
)
DELETE FROM layoffs_staging
WHERE row_num > 1;

	-- Step 3. Standardize data
		-- trim whitespace
UPDATE layoffs_staging
SET company = TRIM(company);

UPDATE layoffs_staging
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

		-- format dates
UPDATE layoffs_staging
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging
MODIFY COLUMN `date` DATE;

	-- Step 4. Handle missing / null values
SELECT t1.industry, t2.industry
FROM layoffs_staging t1
JOIN layoffs_staging t2
	ON t1.company = t2.company
    AND t1.location = t2.location
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging
SET industry = NULL
WHERE industry = '';

DELETE FROM layoffs_staging
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

UPDATE layoffs_staging t1
JOIN layoffs_staging t2
  ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL;




-- 2. EXPLORATORY DATA ANALYSIS
	-- Dataset overview
SELECT *
FROM layoffs_staging2;

	-- Total layoffs by company
SELECT company, SUM(total_laid_off)
FROM layoffs_staging
GROUP BY company
ORDER BY total_laid_off DESC;

	-- Total layoffs by industry
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging
GROUP BY industry
ORDER BY total_laid_off DESC;

	-- Total layoffs by country
SELECT country, SUM(total_laid_off)
FROM layoffs_staging
GROUP BY country
ORDER BY total_laid_off DESC;

	-- Layoffs over time
SELECT YEAR(`date`) AS year, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging
GROUP BY year
ORDER BY year ASC;

	-- Rolling total of layoffs
WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`, 1, 7) AS month, SUM(total_laid_off) AS total_off
FROM layoffs_staging
GROUP BY month
ORDER BY month
)
SELECT `MONTH`, total_off, 
	SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;

	-- Top 5 companies by layoffs each year
WITH Company_Year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`) AS year, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging
GROUP BY company, year
), Ranked_Companies AS
(
SELECT *, 
DENSE_RANK() OVER (PARTITION BY year ORDER BY total_laid_off DESC) AS ranking
FROM Company_Year
)
SELECT *
FROM Ranked_Companies
WHERE Ranking <= 5;
