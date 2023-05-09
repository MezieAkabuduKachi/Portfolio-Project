SELECT *
FROM coviddeaths
WHERE continent is not NULL
;

-- SELECT *
-- FROM covidvaccination 
-- WHERE continent is not NULL ;

-- Select Data to be used frequently

SELECT continent, location, date, total_cases, total_deaths, new_deaths,new_deaths_smoothed new_cases, new_cases_smoothed, population
FROM coviddeaths
WHERE continent is not NULL;

-- Looking at Total Cases vs Total Deaths
-- Looking at this the highest death per cases in Nigeria was on January 5th 2020
-- This also shows the chances of you dying if you contacted Covid 19 in Nigeria

SELECT continent, location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM coviddeaths
WHERE location like "%Nigeria%" and continent is not NULL
ORDER BY DeathPercentage ;

-- Looking at Total Cases vs Population
-- Shows what percentage of population got Covid-19

SELECT continent, location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
FROM coviddeaths
-- WHERE location like "%Nigeria%"
WHERE continent is not NULL;

-- Looking at Countries with highest infection rate per Populatin
-- shows the highest percentage of countries infected by population
-- The highest country infected is Andorra due to their minimal population and high infection count

SELECT continent, location, population, MAX(total_cases) AS HighestInfectionCount,  MAX((total_cases/population))*100 as PercentPopulationInfected
FROM coviddeaths
WHERE continent is not NULL
GROUP BY continent, location, population
-- WHERE location like "%Nigeria%"
ORDER BY PercentPopulationInfected  DESC;

CREATE VIEW PercentPopulationInfected AS 
SELECT continent, location, population, MAX(total_cases) AS HighestInfectionCount,  MAX((total_cases/population))*100 as PercentPopulationInfected
FROM coviddeaths
WHERE continent is not NULL
GROUP BY continent, location, population
-- WHERE location like "%Nigeria%"
ORDER BY PercentPopulationInfected  DESC;

SELECT continent, location, population, date,  MAX(total_cases) AS HighestInfectionCount,  MAX((total_cases/population))*100 as PercentPopulationInfected
FROM coviddeaths
WHERE continent is not NULL
GROUP BY continent, location, population, date
-- WHERE location like "%Nigeria%"
ORDER BY PercentPopulationInfected  DESC;

-- Looking at the new cases vs the new deaths
-- This shows us the deaths per cases as they were being reported and updated

SELECT continent, location, date, new_cases_smoothed, new_deaths_smoothed, (new_deaths_smoothed/new_cases_smoothed)*100 as NewDeathPercentage
FROM coviddeaths
WHERE location like "%Nigeria%" AND continent is not NULL
ORDER BY NewDeathPercentage ;

-- Looking at the countries with the Highest infection and deaths
-- Here we are taking a quick look at the countries with the highest cases and deaths 
-- Country with the highest CASES is United States
-- Country with the highest DEATHS is United States
-- Country with the highest max death percentage is Vanuatu a very small country with 4 cases and 1 death 

SELECT continent, location, MAX(total_cases) AS HighestInfectionCount, MAX(total_deaths) AS HighestDeathCount, MAX(total_deaths)/MAX(total_cases)*100 as MaxDeathPercentage
FROM coviddeaths
WHERE continent is not NULL
-- WHERE location like "%Nigeria%"
GROUP BY continent, location
ORDER BY MaxDeathPercentage  DESC;

-- Looking at the countries with the Highest infection and deaths per Population
-- Here we are taking a quick look at the countries with the highest cases and deaths  per population 
-- Country with the highest CASES is United States
-- Country with the highest DEATHS is United States
-- Country with the highest max infected percentage is Andorra 
-- Country with the highest max death percentage is Hungary 

SELECT continent, location, population, MAX(total_cases) AS HighestInfectionCount, MAX(total_deaths) AS HighestDeathCount,
 MAX(total_cases)/population*100 as MaxInfectedPercentage,
 MAX(total_deaths)/population*100 as MaxDeathPercentage
FROM coviddeaths
WHERE continent is not NULL
-- WHERE location like "%Nigeria%"
GROUP BY continent, location, population
ORDER BY MaxDeathPercentage  DESC;

-- Breaking things down by Continent
-- The Continent with the Highest Infection Count is Europe
-- The Continent with the Highest Death Count is also Europe

SELECT continent, location, MAX(total_cases) AS HighestInfectionCount, MAX(total_deaths) AS HighestDeathCount
FROM coviddeaths
WHERE continent is  NULL
-- WHERE location like "%Nigeria%"
GROUP BY continent, location
ORDER BY HighestInfectionCount  DESC;

-- CREATING VIEW TO STORE DATA FOR LATER VISUALIZATIONS

CREATE VIEW HIGHESTINFECTION_DEATHBY_CONTINENT AS
SELECT continent, location, MAX(total_cases) AS HighestInfectionCount, MAX(total_deaths) AS HighestDeathCount
FROM coviddeaths
WHERE continent is  NULL
-- WHERE location like "%Nigeria%"
GROUP BY continent, location
ORDER BY HighestInfectionCount  DESC;

SELECT*
FROM HIGHESTINFECTION_DEATHBY_CONTINENT
;

-- GLOBAL NUMBERS
-- Across the entire world there was a recorded Total Cases of 150,574,977
-- Across the entire world there was a recorded Total Deaths of 3,180,206
-- Across the entire world there was a recorded DeathPercentage of 2.11%

SELECT SUM(new_cases) AS Total_Cases, SUM(new_deaths) AS Total_Deaths, SUM(new_deaths)/SUM(new_cases) *100 as DeathPercentage
FROM coviddeaths
-- WHERE location like "%Nigeria%" 
WHERE continent is not NULL ;
-- GROUP BY date  ;

-- CREATING VIEW TO STORE DATA FOR LATER VISUALIZATIONS

CREATE VIEW GLOBAL_NUMBERS AS
SELECT SUM(new_cases) AS Total_Cases, SUM(new_deaths) AS Total_Deaths, SUM(new_deaths)/SUM(new_cases) *100 as DeathPercentage
FROM coviddeaths
-- WHERE location like "%Nigeria%" 
WHERE continent is not NULL ;

SELECT*
FROM GLOBAL_NUMBERS 
;

-- LOOKING AT TOTAL GLOBAL POPULATION OF PEOPLE VACCINATED USING SUB-QUERIES

SELECT continent, location, date, population, new_vaccinations, (PeopleConstantlyVaccinated/population)*100 FROM   
 (SELECT DEA.continent, DEA.location, DEA.date, DEA.population, VAC.new_vaccinations
, SUM(new_vaccinations) OVER (PARTITION BY DEA.location ORDER BY DEA.location, DEA.date) AS PeopleConstantlyVaccinated
FROM coviddeaths DEA
JOIN covidvaccination VAC
    ON DEA.location = VAC.location
    AND DEA.date = VAC.date
WHERE DEA.continent is not NULL 
ORDER BY 2,3 ) DL ;

-- USING CTE TO LOOK AT TOTAL GLOBAL POPULATION OF PEOPLE VACCINATED

with PopvsVac (continent, location, date, population, new_vaccinations, PeopleConstantlyVaccinated)
as 
(
SELECT DEA.continent, DEA.location, DEA.date, DEA.population, VAC.new_vaccinations
, SUM(new_vaccinations) OVER (PARTITION BY DEA.location ORDER BY DEA.location, DEA.date) AS PeopleConstantlyVaccinated
FROM coviddeaths DEA
JOIN covidvaccination VAC
    ON DEA.location = VAC.location
    AND DEA.date = VAC.date
WHERE DEA.continent is not NULL 
)
SELECT *, (PeopleConstantlyVaccinated/population)*100
FROM PopvsVac
;

-- STILL USING CTE, WE CAN NOW SEE THE MAX PEOPLE CONSTANTLY VACCINATED PER POPULATION

with PopvsVac (continent, location, population, new_vaccinations, PeopleConstantlyVaccinated)
as 
(
SELECT DEA.continent, DEA.location, DEA.population, VAC.new_vaccinations
, SUM(new_vaccinations) OVER (PARTITION BY DEA.location ORDER BY DEA.location, DEA.date) AS PeopleConstantlyVaccinated
FROM coviddeaths DEA
JOIN covidvaccination VAC
    ON DEA.location = VAC.location
    AND DEA.date = VAC.date
WHERE DEA.continent is not NULL 
)
SELECT *, MAX(PeopleConstantlyVaccinated/population)*100
FROM PopvsVac
GROUP BY continent, location, population, new_vaccinations, PeopleConstantlyVaccinated
;

-- USING TEMP TABLE

DROP TABLE IF EXISTS PercentPopulationVaccinated ;
CREATE Table PercentPopulationVaccinated
(Continent varchar(200),
Location varchar(200),
Population numeric,
New_Vaccinations numeric,
PeopleConstantlyVaccinated numeric
)
;

INSERT INTO PercentPopulationVaccinated
SELECT DEA.continent, DEA.location, DEA.population, VAC.new_vaccinations
, SUM(new_vaccinations) OVER (PARTITION BY DEA.location ORDER BY DEA.location, DEA.date) AS PeopleConstantlyVaccinated
FROM coviddeaths DEA
JOIN covidvaccination VAC
    ON DEA.location = VAC.location
    AND DEA.date = VAC.date
-- WHERE DEA.continent is not NULL 
;

SELECT *, (PeopleConstantlyVaccinated/population)*100
FROM PercentPopulationVaccinated ;


-- CREATING VIEW TO STORE DATA FOR LATER VISUALIZATIONS

CREATE VIEW PercentPopulationVaccinated_ AS 
SELECT DEA.continent, DEA.location, DEA.population, VAC.new_vaccinations
, SUM(new_vaccinations) OVER (PARTITION BY DEA.location ORDER BY DEA.location, DEA.date) AS PeopleConstantlyVaccinated
FROM coviddeaths DEA
JOIN covidvaccination VAC
    ON DEA.location = VAC.location
    AND DEA.date = VAC.date
WHERE DEA.continent is not NULL ;

SELECT* 
FROM PercentPopulationVaccinated_;

SELECT Location, SUM(New_deaths) AS TotalDeathCount
FROM coviddeaths
WHERE continent is NULL
AND location not in ("World", "European Union", "International")
Group by location
Order by TotalDeathCount DESC ;

CREATE VIEW TotalDeathCount AS
SELECT Location, SUM(New_deaths) AS TotalDeathCount
FROM coviddeaths
WHERE continent is NULL
AND location not in ("World", "European Union", "International")
Group by location
Order by TotalDeathCount DESC ;


