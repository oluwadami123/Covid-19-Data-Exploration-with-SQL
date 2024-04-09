Select * 
From [My SQL PortfolioProject]..CovidDeaths
Where Continent is not Null /* Removing Continent With Null Values and Selecting Columns/Rows without Null Values*/
Order By 3,4
---Selection of Necessary Columns 
Select Location, date, total_cases, new_cases, total_deaths, population
From [My SQL PortfolioProject]..CovidDeaths
Order By 1,2

-- Looking at the DeathPercentage in Nigeria 
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From [My SQL PortfolioProject]..CovidDeaths
Where Location like 'Nigeria'
Order By 1,2

--- Looking at the Total_cases per Population for the whole Countries
Select Location, date, total_cases, Population,(total_cases/population)*100 as TotalCasesperPopulation
From [My SQL PortfolioProject]..CovidDeaths
Where location like 'China'
Order By 1,2

--- Countries With highest Infection Rate Vs Population across all Country
Select Location, Max(total_cases)as HighestInfectionCount, Population, Max((total_cases/population))*100 as TotalCasesPerPopulation
From [My SQL PortfolioProject]..CovidDeaths
Group By location, population
Order By TotalCasesPerPopulation Desc

--- Total Deaths Cases across all Locations
Select Location, Max(Cast(total_deaths as int))as HighestDeathCount
From [My SQL PortfolioProject]..CovidDeaths
Where continent is not Null 
Group By Location
Order By HighestDeathCount Desc

--- Total Deaths across all Continents
Select Location, Max(Cast(total_deaths as int)) as HighestDeathCount
From [My SQL PortfolioProject]..CovidDeaths
Where Continent is null
Group By Location
Order By HighestDeathCount Desc

--- Viewing Numbers of New_deaths amd new_Cases across the Globe grouped by Date
Select Date, Sum(new_cases) as Total_cases, Sum(Cast(new_deaths as int)) as Total_deaths, Sum(cast(new_deaths as Int))/ Sum(new_cases)*100 as DeathPercentage
From [My SQL PortfolioProject]..CovidDeaths
Where continent is not Null
Group By Date
Order By 1,2
 
 ---Viewing the Total_Number of the Infected and Deaths
 Select Sum(new_cases) as Total_Cases, Sum(Cast(new_deaths as Int)) as Total_deaths, Sum(cast(new_deaths as Int))/Sum(new_cases)*100 as DeathPercentage
  From [My SQL PortfolioProject]..CovidDeaths
  Where Continent is not Null
  Order By 1,2

  --- Total Number of Population Vs Vaccination
----Joining the two Tables together on Location and Date 
Select Deaths.continent, Deaths.location, Deaths.population, Deaths.date, Vaccinated.new_vaccinations,
Sum(Cast(vaccinated.new_vaccinations as Int)) Over (Partition By Deaths.location Order By deaths.location,deaths.date) as CountofVaccinatedPeople /* Counting the no of vaccinated people by their location and date*/
From [My SQL PortfolioProject]..CovidDeaths as Deaths
Join [My SQL PortfolioProject]..CovidVaccinations as Vaccinated
       ON Deaths.location = Vaccinated.location
	   and Deaths.date = Vaccinated.date
Where Deaths.continent is Not Null
Order By 2,4

--- Countof VaccinatedPeople/Population
--Create a table(CTE)
With PopulationVsVaccination (Continent, location, population, date, new_vaccinations, CountofVaccinatedPeople)
as
(
Select Deaths.continent, Deaths.location, Deaths.population, Deaths.date, Vaccinated.new_vaccinations,
Sum(Cast(vaccinated.new_vaccinations as Int)) Over (Partition By Deaths.location Order By deaths.location,deaths.date) as CountofVaccinatedPeople /* Counting the no of vaccinated people by their location and date*/
From [My SQL PortfolioProject]..CovidDeaths as Deaths
Join [My SQL PortfolioProject]..CovidVaccinations as Vaccinated
       ON Deaths.location = Vaccinated.location
	   and Deaths.date = Vaccinated.date
Where Deaths.continent is Not Null
)
Select *, (CountofVaccinatedPeople/population*100) as VaccinatedPerPopulation
From PopulationVsVaccination 