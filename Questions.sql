-- Questions to answer :
USE human_resources;

SET sql_mode = '';

select * from hr;
-- 1 - Whats is the gender breakdown of employees in the company?
SELECT 
	gender,
	count(*) as `total`
FROM hr
WHERE age >= 18 AND fire_date = '0000-00-00'
GROUP BY gender;

-- 2 - Whats is the race/ethnicy breakdown of employees in the company?
SELECT 
	race,	
	count(*) as `total`
FROM hr
WHERE age >= 18 AND fire_date = '0000-00-00'
GROUP BY race
ORDER BY `total` DESC;

-- 3 - Whats is the age distribuition of employees in the company?
SELECT 
	CASE
		WHEN age >= 18 AND age <= 25 THEN '18-25' 
		WHEN age >= 26 AND age <= 33 THEN '26-33' 
		WHEN age >= 34 AND age <= 42 THEN '34-42' 
		WHEN age >= 43 AND age <= 50 THEN '43-50' 
		WHEN age >= 51 AND age <= 60 THEN '51-60'
        ELSE '61+'
	END as `group_age`, gender,
    count(*) FROM hr
	WHERE age >= 18 AND fire_date = '0000-00-00'
    GROUP BY `group_age`, gender
    ORDER BY `group_age`;

-- 4 - How many employees work at headquarters versus remote locations?
SELECT location, count(*) from hr
WHERE age >= 18 AND fire_date = '0000-00-00'
GROUP BY location;

-- 5 - What is the average length of employment for employees who have been terminated?
SELECT round(avg(datediff(fire_date, hire_date))/365, 2) AS avg_length_employment
FROM hr
WHERE fire_date <= CURDATE() AND fire_date <> '0000-00-00' AND age >= 18;

-- 6 - How does the gender distribution vary across departments jobs titles?
SELECT
	department,
    gender,
    count(*) as `total`
FROM hr
WHERE age >= 18 AND fire_date = '0000-00-00'
GROUP BY department, gender
ORDER BY department;

-- 7 - What is the distribution of jobs titles across the company?
SELECT
	jobtitle,
    count(*) as `total`
FROM hr
WHERE age >= 18 AND fire_date = '0000-00-00'
GROUP BY jobtitle
ORDER BY jobtitle;

-- 8 - Which department has the highest turnover rate?
SELECT
	department,
    total,
    terminated_count,
    (terminated_count/total) * 100 as `terminated_rate_(%)`   
FROM (
	SELECT department,
    count(*) as total,
    sum(CASE WHEN fire_date <> '0000-00-00' AND fire_date <= CURDATE() THEN 1 ELSE 0 END) AS terminated_count
    FROM hr
	WHERE age >= 18
	GROUP BY department
    ) AS subquery
ORDER BY `terminated_rate_(%)` DESC;

-- 9- What is the distribution of employees across locations by the city and state?
SELECT
	location_state,
    count(*) as total
FROM hr
WHERE age >= 18 AND fire_date = '0000-00-00'
GROUP BY location_state
ORDER BY total DESC;

-- 10 - How has the company's employees count changed over time based on hire and term dates?
SELECT
	`year`,
    hires,
    terminations,
    hires - terminations AS `net_change`,
    round((hires - terminations)/hires * 100, 2) AS `net_change_(%)`
FROM (
	SELECT YEAR(hire_date) AS `year`,
    count(*) as hires,
    sum(CASE WHEN fire_date <> '0000-00-00' AND fire_date <= CURDATE() THEN 1 ELSE 0 END) AS terminations
	FROM hr
	WHERE age >= 18
	GROUP BY YEAR(hire_date)
    ) AS subquery
ORDER BY `year` ASC;

-- 11 - What is the tenure distribution for each department?

SELECT
	department,
    round(avg(datediff(fire_date, hire_date))/365,2) AS avg_tenue
FROM hr
WHERE fire_date <> '0000-00-00' AND fire_date <= CURDATE() AND age >= 18
GROUP BY department
ORDER BY avg_tenue DESC;

