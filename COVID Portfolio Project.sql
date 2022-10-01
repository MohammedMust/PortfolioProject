

  --Headers we will use 

  Select Location ,date,total_cases,new_cases,total_deaths,population From ..CovidDeaths
  order by 1,2
 
 --Total cases vs totalDeath
 --Likelihood 
 Select Location ,date,(total_cases),(total_deaths ),Cast(total_deaths as float)/Cast(total_cases as float )  DeathPercentage From [Portofolioproject]..CovidDeaths
 Where location LIKE 'SUDAN%'
 order by 1,2

 --Totala cases vs Population

  Select Location ,date,(total_cases),([population] ),Cast(total_cases as float)/Cast([population] as float )  DeathPercentage From [Portofolioproject]..CovidDeaths
 Where location LIKE 'SUDAN%'
 order by 1,2

 --Looking at country with hifhtest infiction rate VS population

   Select Location ,max(total_cases) Highest_Cases,Max(population)Highest_Population,max(total_cases)/Max(population) *100 Infiction_Rate From [Portofolioproject]..CovidDeaths
  Group by Location,population
 order by 4 desc

 --Country with highest death per Population

 Select Location ,max (Cast(total_deaths as int) )Highest_Death,Max(population)Highest_Population,
 max(Cast(total_deaths as float))/Max(CAST(population as float) ) *100 DeathPercentage From [Portofolioproject]..CovidDeaths
 Group by Location
 order by 2 desc

 --Look by Continent

 
 Select continent ,max (Cast(total_deaths as int) )Highest_Death From [Portofolioproject]..CovidDeaths
 Where continent IS NOT NULL
 Group by continent
 order by 2 desc

  --Look by Continent PER POPULATION 
   
 Select continent ,max (Cast(total_deaths as int) )Highest_Death,max (Cast(population as int) )Highest_Population
 ,max (Try_Cast(total_deaths as float) )/max (Try_Cast(population as float) ) 
 From [Portofolioproject]..CovidDeaths
 Where continent IS Not NULL
 Group by continent
 order by 2 desc

 --Global number
    
 Select CONVERT(date,date)_Date,SUM(Cast(new_deaths as int) )Highest_Death,SUM (Cast(new_cases as int) )Highest_New_Cases
 ,SUM (Try_Cast(new_deaths as float) )/SUM (Try_Cast(new_cases as float) ) *100 Glopal_Death_Percentage
 From [Portofolioproject]..CovidDeaths
 Where continent IS Not NULL
 Group by date 
 order by 1,2 

  Select SUM(Cast(new_deaths as int) )Highest_Death,SUM (Cast(new_cases as int) )Highest_New_Cases
 ,SUM (Try_Cast(new_deaths as float) )/SUM (Try_Cast(new_cases as float) ) *100 Glopal_Death_Percentage
 From [Portofolioproject]..CovidDeaths
 Where continent IS Not NULL

 order by 1,2 

 --Total Vaccination vs population GLOBAL

 SELECT  SUM(Try_CAST(v.total_vaccinations as float)) Total_vaccinated,SUM(Try_CAST(d.population as float))_Populatio 
 ,SUM(Try_CAST(v.total_vaccinations as float))/SUM(Try_CAST(d.population as float))*100 Vaccinated_Percentage
 From Portofolioproject..CovidDeaths as D
 
 Join Portofolioproject..CovidVaccinations as V
 on D.location=V.location
 and D.date=V.date 

  --Total Vaccination vs population GLOBAL per location
  
   SELECT D.continent,D.location,D.date,D.population,V.new_vaccinations,
 SUM(Try_CAST(V.new_vaccinations as float)) over( Partition by D.location order by D.location,D.date) Roling_People_Vaccinated
 --,(Roling_People_Vaccinated/D.population)
 From Portofolioproject..CovidDeaths as D
 
 Join Portofolioproject..CovidVaccinations as V
 on D.location=V.location
 and D.date=V.date 
 Where d.continent IS NOT NULL 
order by 1,3 

--USE_CET
with PopvsVac(continent,location,date,population,new_vaccinations,Roling_People_Vaccinated)
as
(SELECT D.continent,D.location,D.date,D.population,V.new_vaccinations,
 SUM(Try_CAST(V.new_vaccinations as float)) over( Partition by D.location order by D.location,D.date) Roling_People_Vaccinated
 --,(Roling_People_Vaccinated/D.population)
 From Portofolioproject..CovidDeaths as D
 Join Portofolioproject..CovidVaccinations as V
 on D.location=V.location
 and D.date=V.date 
 Where d.continent IS NOT NULL ) select *,(Roling_People_Vaccinated/ population)*100 Rolling_Percentage from PopvsVac

 order by 1,7

 --USE TEMP TABLE


 create Table #Roling_People_Vaccinated_VS_Population
 (continent nvarchar(255),
 Location nvarchar(255),
 date datetime ,
 Population numeric,
 new_vaccinations numeric,
 Roling_People_Vaccinated numeric
)
 insert into #Roling_People_Vaccinated_VS_Population

 SELECT D.continent,D.location,D.date,D.population,V.new_vaccinations,
 SUM(Try_CAST(V.new_vaccinations as float)) over( Partition by D.location order by D.location,D.date) Roling_People_Vaccinated
 --,(Roling_People_Vaccinated/D.population)
 From Portofolioproject..CovidDeaths as D
 Join Portofolioproject..CovidVaccinations as V
 on D.location=V.location
 and D.date=V.date 
 Where d.continent IS NOT NULL 
 
 select *  from #Roling_People_Vaccinated_VS_Population

  --USE TEMP TABLE (DROP TABLE IF EXEST)

  Drop table if exists #Roling_People_Vaccinated_VS_Population
 create Table #Roling_People_Vaccinated_VS_Population
 (continent nvarchar(255),
 Location nvarchar(255),
 date datetime ,
 Population numeric,
 new_vaccinations numeric,
 Roling_People_Vaccinated numeric
)
 insert into #Roling_People_Vaccinated_VS_Population

 SELECT D.continent,D.location,D.date,D.population,V.new_vaccinations,
 SUM(Try_CAST(V.new_vaccinations as float)) over( Partition by D.location order by D.location,D.date) Roling_People_Vaccinated
 --,(Roling_People_Vaccinated/D.population)
 From Portofolioproject..CovidDeaths as D
 Join Portofolioproject..CovidVaccinations as V
 on D.location=V.location
 and D.date=V.date 
 Where d.continent IS NOT NULL 
 
 select *  from #Roling_People_Vaccinated_VS_Population

 --Creatinig View for Tablue 

 Create view Roling_People_Vaccinated_VS_Population as 
  (SELECT D.continent,D.location,D.date,D.population,V.new_vaccinations,
 SUM(Try_CAST(V.new_vaccinations as float)) over( Partition by D.location order by D.location,D.date) Roling_People_Vaccinated
 From Portofolioproject..CovidDeaths as D
 Join Portofolioproject..CovidVaccinations as V
 on D.location=V.location
 and D.date=V.date 
 Where d.continent IS NOT NULL) 

 --View #2
 Create view Total_Death_ByContenint as 
  Select continent ,max (Cast(total_deaths as int) )Highest_Death From [Portofolioproject]..CovidDeaths
 Where continent IS NOT NULL
 Group by continent

