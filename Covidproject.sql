/*
Covid-19 Data Analysis Project

Skills used: Joins, CTEs, Temp Tables, Window Functions, Aggregate Functions, Creating Views, Converting Data Types

Database: covidproject
Tables: CovidDeaths, CovidVaccinations

Ensure the correct database is selected before running these queries.
USE covidproject;
*/

-- 1. Demographic Analysis: Age and GDP Impact on Covid-19 Deaths
SELECT dea.location, dea.date, dea.total_deaths, vac.median_age, vac.gdp_per_capita
FROM CovidDeaths dea
JOIN CovidVaccinations vac
  ON dea.location = vac.location
 AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY dea.location, dea.date;

-- 2. Analyzing Infection Rates by Population Density
SELECT location, date, population_density, new_cases,  
       (new_cases / NULLIF(population_density, 0)) * 100 AS PercentPopulationInfected
FROM CovidDeaths
ORDER BY location, date;

-- 3. Vaccination Impact on New Cases: Correlation Analysis
SELECT dea.location, dea.date, vac.new_vaccinations, dea.new_cases
FROM CovidDeaths dea
JOIN CovidVaccinations vac
  ON dea.location = vac.location
 AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY dea.location, dea.date;

-- 4. Highest Daily New Cases by Country
SELECT location, date, new_cases
FROM CovidDeaths
WHERE new_cases = (SELECT MAX(new_cases) FROM CovidDeaths sub WHERE sub.location = CovidDeaths.location)
ORDER BY new_cases DESC;

-- 5. Countries with the Highest Vaccination Rates
SELECT location, MAX(total_vaccinations) AS TotalVaccinations
FROM CovidVaccinations
GROUP BY location
ORDER BY TotalVaccinations DESC;

-- 6. Impact of Health Infrastructure on Covid-19 Outcomes
SELECT dea.location, dea.date, dea.total_deaths, vac.hospital_beds_per_thousand, vac.life_expectancy
FROM CovidDeaths dea
JOIN CovidVaccinations vac
  ON dea.location = vac.location
 AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY dea.location, dea.date;

-- 7. Stringency Index Impact on Covid-19 Spread
SELECT dea.location, dea.date, dea.new_cases, vac.stringency_index
FROM CovidDeaths dea
JOIN CovidVaccinations vac
  ON dea.location = vac.location
 AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY dea.location, dea.date;

-- 8. Weekly Trends in New Cases and Deaths
WITH WeeklyTrends AS (
    SELECT location, 
           DATEPART(week, date) AS Week, 
           SUM(new_cases) AS WeeklyNewCases, 
           SUM(new_deaths) AS WeeklyNewDeaths
    FROM CovidDeaths
    WHERE continent IS NOT NULL
    GROUP BY location, DATEPART(week, date)
)
SELECT *
FROM WeeklyTrends
ORDER BY location, Week;

-- 9. Monthly Trends in Vaccinations
WITH MonthlyVaccinations AS (
    SELECT location, 
           DATEPART(month, date) AS Month, 
           SUM(new_vaccinations) AS MonthlyNewVaccinations
    FROM CovidVaccinations
    WHERE continent IS NOT NULL
    GROUP BY location, DATEPART(month, date)
)
SELECT *
FROM MonthlyVaccinations
ORDER BY location, Month;

-- 10. Excess Mortality Analysis by Country
SELECT location, date, total_deaths, excess_mortality_cumulative
FROM CovidDeaths
WHERE continent IS NOT NULL
ORDER BY location, date;

-- 11. Gender and Smoking Impact on Covid-19 Deaths
SELECT dea.location, dea.date, dea.total_deaths, vac.female_smokers, vac.male_smokers
FROM CovidDeaths dea
JOIN CovidVaccinations vac
  ON dea.location = vac.location
 AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY dea.location, dea.date;

-- 12. Percentage of Population Fully Vaccinated
SELECT location, date, population, people_fully_vaccinated, 
       (people_fully_vaccinated / NULLIF(population, 0)) * 100 AS PercentFullyVaccinated
FROM CovidVaccinations
WHERE continent IS NOT NULL
ORDER BY location, date;

-- 13. Countries with the Most Boosters Administered
SELECT location, MAX(total_boosters) AS TotalBoosters
FROM CovidVaccinations
GROUP BY location
ORDER BY TotalBoosters DESC;

-- 14. Analysis of Covid-19 Spread by Population Density and Urbanization
SELECT dea.location, dea.date, dea.new_cases, vac.population_density, vac.population
FROM CovidDeaths dea
JOIN CovidVaccinations vac
  ON dea.location = vac.location
 AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY dea.location, dea.date;

-- 15. Covid-19 Cases and Deaths by Income Group
-- Assuming an additional 'income_group' column is present in CovidVaccinations table
SELECT dea.location, dea.date, dea.new_cases, dea.total_deaths, vac.gdp_per_capita
FROM CovidDeaths dea
JOIN CovidVaccinations vac
  ON dea.location = vac.location
 AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY dea.location, dea.date;


--View for Stringency Index Impact on Covid-19 Spread

CREATE VIEW StringencyImpact AS
SELECT dea.location, 
       dea.date, 
       dea.new_cases, 
       vac.stringency_index
FROM CovidDeaths dea
JOIN CovidVaccinations vac
  ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;


--View for Infection Rates by Population Density

CREATE VIEW InfectionRates AS
SELECT location, 
       date, 
       population_density, 
       new_cases, 
       (new_cases / NULLIF(population_density, 0)) * 100 AS PercentPopulationInfected
FROM CovidDeaths
WHERE continent IS NOT NULL;
