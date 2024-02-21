Select *
From Portfolio..CovidDeaths
Where continent is not null
order by 3,4

--Select *
--From Portfolio..CovidVaccination
--order by 3,4

--Select the data we are going to be using 

Select location,date,total_cases,new_cases,total_deaths,population
From Portfolio..CovidDeaths
Where continent is not null
order by 1,2

-- Looking at Total Cases vs Total Deaths
-- Shows the likelihood of dying if you contract covid in your country

Select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From Portfolio..CovidDeaths
Where location like '%india%'
Where continent is not null
order by 1,2

-- Looking at Total Cases vs Population
-- Show what percentage of population got Covid

Select location, date, population,total_cases, (total_cases/population)*100 as PercentPopulationInfected
From Portfolio..CovidDeaths
--Where location like '%india%'
order by 1,2

--Looking at Countries with highest infection rate compared to population

Select location, population,MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From Portfolio..CovidDeaths
--Where location like '%india%'
Group by location,population
order by PercentPopulationInfected desc

--Showing the countries with highest death count per population

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From Portfolio..CovidDeaths
--Where location like '%india%'
Where continent is not null
Group by location
order by TotalDeathCount desc

-- LET'S BREAK THINGS DOWN BY CONTINENT

-- Showing the continent with the highest death count

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From Portfolio..CovidDeaths
--Where location like '%india%'
Where continent is not null
Group by continent
order by TotalDeathCount desc


--GLOBAL NUMBERS 

Select SUM(new_cases) as Total_cases ,SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases) *100 as DeathPercentage
From Portfolio..CovidDeaths
--Where location like '%india%'
Where continent is not null
--group by date
order by 1,2

--Looking at total population vs vaccination

-- JOIN 2 DATASET 
-- USE CTE 

WITH PopvsVac (continent, location , date , population,new_vaccinations,  RollingPeopleVaccinated)
as
(
select dea.continent , dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(int,vac.new_vaccinations )) OVER (partition by dea.location order by dea.location,dea.date) 
as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from Portfolio..CovidDeaths dea
Join Portfolio..CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3
)
select *, (RollingPeopleVaccinated/population)*100
from PopvsVac

-- TEMP TABLE 

drop table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
	continent nvarchar(255),
	location nvarchar(255),
	date datetime,
	population numeric,
	new_vaccinations numeric ,
	RollingPeopleVaccinated numeric
)
INSERT into #PercentPopulationVaccinated
Select dea.continent , dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(int,vac.new_vaccinations )) OVER (partition by dea.location order by dea.location,dea.date) 
as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from Portfolio..CovidDeaths dea
Join Portfolio..CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
--Where dea.continent is not null
--order by 2,3

select *, (RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated

--CREATING VIEW TO STORE DATA FOR LATER VISUALIZATION
create View PercentPopulationVaccinated as 
Select dea.continent , dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(int,vac.new_vaccinations )) OVER (partition by dea.location order by dea.location,dea.date) 
as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from Portfolio..CovidDeaths dea
Join Portfolio..CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3


select *
from PercentPopulationVaccinated