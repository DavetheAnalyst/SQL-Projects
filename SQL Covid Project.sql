Select *
from [PortoflioProject ]..CovidDeaths
where continent is not null
ORDER BY 3,4


--Select *
--from [PortoflioProject ]..Covidvaccantation
--ORDER BY 3,4

Select location, date, total_cases, new_cases, total_deaths, population 
from [PortoflioProject ]..CovidDeaths
Order by 1,2



--Looking at total cases vs total deaths 

Select location, date, total_cases, new_cases, total_deaths, population 
from [PortoflioProject ]..CovidDeaths
Order by 1,2

--shows the likehood od you dying if you contract covid in your country
Select location, date, total_cases, total_deaths deaths,  (total_deaths/total_cases)*100 as PercentagePopulationInfected
from [PortoflioProject ]..CovidDeaths
where location like '%states%'
Order by 1,2

--Shows what percentage of population got covid
Select location, date,population, total_cases, (total_cases/population)*100 as PercentagePopulationInfected
from [PortoflioProject ]..CovidDeaths
--where location like '%states%'
Order by 1,2

--looking at Countries with Highest Infection Rate compared to Population 

Select location, population, max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentagePopulationInfected
from [PortoflioProject ]..CovidDeaths
--where location like '%states%'
Group by location, population
order by PercentagePopulationInfected desc

--Showing Countries with Highest Death Count per Population
Select location, max(cast(total_deaths as int)) as TotalDeathCount
from [PortoflioProject ]..CovidDeaths
--where location like '%states%'
where continent is not null
Group by location
order by TotalDeathCount desc

--Let Break This Down By Continent 
Select continent, max(cast(total_deaths as int)) as TotalDeathCount
from [PortoflioProject ]..CovidDeaths
--where location like '%states%'
where continent is not null
Group by continent   
order by TotalDeathCount desc

--Showing the continent with the Higest Dealth Count per Popoulation

 Select continent, max(cast(total_deaths as int)) as TotalDeathCount
from [PortoflioProject ]..CovidDeaths
--where location like '%states%'
where continent is not null
Group by continent   
order by TotalDeathCount desc

--Global Numbers 
Select Sum(new_cases) as total_cases, Sum(cast(new_deaths as int)) as total_deaths, Sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage 
from [PortoflioProject ]..CovidDeaths
--where location like '%states%'
where continent is not null
--Group by date 
Order by 1,2 


--Looking at total Population Vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations
, Sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From [PortoflioProject ]..CovidDeaths dea
join [PortoflioProject ]..Covidvaccantation vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3 


---USE CTE

With PopvsVac (continent,location, date, population, new_vaccinations, RollingPeoplevaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations
, Sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
from [PortoflioProject ]..CovidDeaths dea
join [PortoflioProject ]..Covidvaccantation vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3 
)
Select *, (RollingPeoplevaccinated/population)*100
from PopvsVac






--Temp Table
Drop table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent Nvarchar(255),
location nvarchar(255),
Date datetime,
Population Numeric,
New_vaccinations Numeric, 
RollingPeopleVaccinated numeric
)


Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations
, Sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
from [PortoflioProject ]..CovidDeaths dea
join [PortoflioProject ]..Covidvaccantation vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3 



Select *, (RollingPeoplevaccinated/population)*100
from #PercentPopulationVaccinated



--Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations
, Sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
from [PortoflioProject ]..CovidDeaths dea
join [PortoflioProject ]..Covidvaccantation vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3 

Select *
from PercentPopulationVaccinated