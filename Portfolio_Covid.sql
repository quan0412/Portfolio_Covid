select *
From Portfolio..CovidDeaths
where continent <>''
And continent is not null
order by 3,4

--select *
--from CovidVaccinations
--order by 3,4

select location, date, population, total_cases, total_deaths, convert(bigint,total_deaths)/nullif(cast(total_cases as float),0)*100 as DeathPercentage
From Portfolio..CovidDeaths
Where location like 'malaysia'
order by 1,2

select location, date, population, total_cases, convert(bigint,total_cases)/nullif(cast(population as float),0)*100 as PercentPopulationInfected
From Portfolio..CovidDeaths
Where location like 'malaysia'
order by 1,2

select location, population, MAX(cast(total_cases as float)) as HighestInfectionCount, max(cast(total_cases as int)/nullif(cast(population as float),0))*100 as PercentPopulationInfected
From Portfolio..CovidDeaths
--Where location like 'malaysia'
group by location, population
order by PercentPopulationInfected desc

select location, max(cast(total_deaths as int)) as TotalDeathCount
From Portfolio..CovidDeaths
--Where location like 'malaysia'
where continent <>''
and continent is not null
group by location
order by TotalDeathCount desc


select continent, max(cast(total_deaths as int)) as TotalDeathCount
From Portfolio..CovidDeaths
where continent <>''
and continent is not null
group by continent
order by TotalDeathCount desc

select sum(cast(new_cases as float)) as total_cases, sum(cast(new_deaths as float)) as total_deaths, sum(cast(new_deaths as int))/nullif(sum(cast(new_cases as float)),0)*100 as DeathPercentage
From Portfolio..CovidDeaths
--Where location like 'malaysia'
--group by date
order by DeathPercentage desc

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as float)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From Portfolio.dbo.CovidDeaths dea
Join Portfolio.dbo.CovidVaccinations vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent <>''
and dea.continent is not null
order by 1,2,3


With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as float)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From Portfolio.dbo.CovidDeaths dea
Join Portfolio.dbo.CovidVaccinations vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent <>''
and dea.continent is not null
--order by 1,2,3
)
Select *, (RollingPeopleVaccinated/nullif(population,0))*100 as VaccinatedPercentage
From PopvsVac


Drop Table if exists #PercentPopulationVaccinated
Create table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date date,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, try_cast(dea.date as date), try_cast(dea.population as numeric), try_cast(vac.new_vaccinations as numeric)
, sum(try_cast(vac.new_vaccinations as numeric)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From Portfolio.dbo.CovidDeaths dea
Join Portfolio.dbo.CovidVaccinations vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent <>''
and dea.continent is not null
--order by 1,2,3
Select *, (RollingPeopleVaccinated/population)*100 as VaccinatedPercentage
From #PercentPopulationVaccinated

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(try_cast(vac.new_vaccinations as numeric)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From Portfolio.dbo.CovidDeaths dea
Join Portfolio.dbo.CovidVaccinations vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent <>''
and dea.continent is not null
--order by 1,2,3

Select *
From PercentPopulationVaccinated