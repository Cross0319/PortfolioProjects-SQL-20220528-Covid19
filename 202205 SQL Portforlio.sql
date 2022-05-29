--依照要匯入的CSV欄位建立一個Table
CREATE TABLE CoviDeath(
	iso_code varchar(10),
	continent varchar(10),
	location varchar(200),
	date date,
	total_cases int,
	population bigint,
	new_cases double precision,
	new_cases_smoothed double precision,	
	total_deaths double precision,
	new_deaths double precision,
	new_deaths_smoothed double precision,	
	total_cases_per_million	double precision,
	new_cases_per_million	double precision,
	new_cases_smoothed_per_million	double precision,
	total_deaths_per_million	double precision,
	new_deaths_per_million	double precision,
	new_deaths_smoothed_per_million	double precision,
	reproduction_rate double precision,
	icu_patients double precision,
	icu_patients_per_million double precision,	
	hosp_patients int,
	hosp_patients_per_million double precision,
	weekly_icu_admissions int,
	weekly_icu_admissions_per_million double precision,
	weekly_hosp_admissions	int,
	weekly_hosp_admissions_per_million	double precision,
	total_tests int
)



--遇到預設的欄位長度太短 變更char長度
ALTER TABLE covideaths
ALTER COLUMN continent TYPE character varying(30)
--遇到預設的時間欄位資料類別不對 變更為Date
ALTER TABLE covideaths
ALTER COLUMN date TYPE date



--找出近期在台灣的致死率(總死亡/總確診)
SELECT 
	location, 
	date, 
	total_cases, 
	total_deaths,
	total_deaths/ total_cases *100 AS death_percentage
FROM covideaths
WHERE location LIKE 'Taiwan'
ORDER BY date DESC
LIMIT 10


--找出台灣地區總死亡率(總死亡數/總人口)
--並利用AND篩選條件過濾掉NULL值
--可得知最高的總人口死亡率大約在4.19%左右
SELECT 
	location,
	date, 
	population, 
	total_deaths,
	total_deaths/ population *100 AS death_percentage
FROM covideaths
WHERE location LIKE 'Taiwan'
AND total_deaths/ population *100 IS NOT NULL
ORDER BY total_deaths/ population *100 ASC

		
--觀察各個國家的致死率(確診死亡/確診數)
--得知確診後死亡率最高的為葉門
SELECT location,
	AVG(total_deaths/total_cases)*100 AS death_average
	FROM covideaths
GROUP BY location
HAVING AVG(total_deaths/total_cases) IS NOT NULL
ORDER BY death_average DESC

--觀察各個國家的致死率(確診死亡/人口數)
--得知以人口比例推算致死率最高的是祕魯 大約為0.38%
SELECT location,
	AVG(total_deaths/population)*100 AS death_average
	FROM covideaths
GROUP BY location
HAVING AVG(total_deaths/population) IS NOT NULL
ORDER BY death_average DESC



--利用大陸來做分類計算
SELECT continent, SUM(new_cases) AS new_cases_sum
FROM covideaths
GROUP BY continent
HAVING continent IS NOT NULL
ORDER BY SUM(new_cases) DESC;

