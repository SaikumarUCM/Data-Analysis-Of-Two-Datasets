select * 
from PortfolioProject..CovidDeaths
order by 3,4

--select * 
--from PortfolioProject..CovidVaccinations
--order by 3,4


--selecting data that we are going to be using

select Location,date,total_cases,new_cases,total_deaths,population
from PortfolioProject..CovidDeaths
order by 1,2


--looking at total cases vs total Deaths
-- Shows likelihood of Dying if you contract covid in your country

select Location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location like '%india%'
order by 1,2

-- Lookinig at Total Cases vs Population
-- Shows what percentage of population got covid

select Location,date,population,total_cases,(total_cases/population)*100 as CovidPercentage
from PortfolioProject..CovidDeaths
where location like '%india%'
order by 1,2


-- Looking at countries with Highest Infection rate compared to Population

select Location,population,MAX(total_cases) as HighestInfectionCount ,MAX((total_cases/population))*100 as CovidPercentage
from PortfolioProject..CovidDeaths
--where location like '%india%'
Group by Location,population
order by CovidPercentage desc

-- Showing Countries with Highest Death Count per Population

select Location,MAX(cast(total_Deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
Group by Location
order by TotalDeathCount desc 



-- Lets Break Things Down by Continent

select continent,MAX(cast(total_Deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
Group by continent
order by TotalDeathCount desc 


-- Showing the continents with the highest death rate

select continent,MAX(cast(total_Deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
Group by continent
order by TotalDeathCount desc 

--GLOBAL NUMBERS

select date,SUM(new_cases) as total_cases,SUM(cast(new_deaths as int)) as total_deaths,SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
Group by date
order by 1,2



--Looking at Total population vs Vaccinations 

-- USE CTE

with PopvsVac (Continent,Location,Date,Population,New_vaccinations,RollingPeopleVaccinated)
as
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations  vac
    on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
--order by 2,3
)
select * ,(RollingPeopleVaccinated/Population)*100
from PopvsVac




-- TEMP TABLE

Create table #PersonPopulationVaccinated
(
Continent  nvarchar(255),
Location nvarchar(255),
Date datetime,
population numeric
New_vaccinations numeric,
)


Insert into #PersonPopulationVaccinated

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations  vac
    on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
--order by 2,3

select * ,(RollingPeopleVaccinated/Population)*100
from #PersonPopulationVaccinated





