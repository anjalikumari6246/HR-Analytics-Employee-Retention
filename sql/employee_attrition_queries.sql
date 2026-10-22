SELECT * FROM hr_data
--1. total empoyees
SELECT COUNT(*) AS total_employee
FROM hr_data;

--2. total employee who left
SELECT COUNT(*) AS employees_left FROM hr_data WHERE attrition = 'Yes';

--3. Attrition Rate(%)
SELECT 
ROUND(
100.0 * SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END)/COUNT(*),2
) AS attrition_rate 
FROM hr_data

--4. Department-wise employee count
SELECT department, COUNT(*) AS total_employee
FROM hr_data
GROUP BY department
ORDER BY total_employee DESC

--5. Job-role wise employee count
SELECT jobrole, COUNT(*) AS total_employee
FROM hr_data
GROUP BY jobrole
ORDER BY total_employee DESC

--6. Avg. salary by department
SELECT department, ROUND(AVG(monthlyincome),2) AS avg_salary
FROM hr_data
GROUP BY department 
ORDER BY avg_salary DESC

--7. Avg yrs at company by department
SELECT department, ROUND(AVG(yearsatcompany),2) AS avg_years
FROM hr_data
GROUP BY department 
ORDER BY avg_years DESC

--8. Attrition by gender
SELECT gender, attrition, COUNT(*) AS employee FROM hr_data
GROUP BY gender, attrition
ORDER BY gender

--9. Overtime vs attrition
SELECT overtime, attrition, COUNT(*) AS employee FROM hr_data
GROUP BY overtime, attrition
ORDER BY overtime

--10. attrition rate by age group (export)
SELECT age_group,
COUNT(*) FILTER (WHERE attrition='Yes') AS leavers,
COUNT(*) AS employees,
ROUND(
100.0 * COUNT(*) FILTER (WHERE attrition ='Yes')/COUNT(*),1
) AS attrition_rate FROM hr_data
GROUP BY age_group
ORDER BY attrition_rate DESC

--11.  Highest paying job roles
SELECT jobrole, ROUND(AVG(monthlyincome),2) AS avg_salary
FROM hr_data
GROUP BY jobrole
ORDER BY avg_salary DESC

--12. Avg. salary by Education Level
SELECT education_level, ROUND(AVG(monthlyincome),2) AS avg_salary
FROM hr_data
GROUP BY education_level
ORDER BY avg_salary DESC

--13. Rank departments by attrition rate (WINDOW FN)
SELECT department,
       ROUND(100.0 * AVG(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END), 1) AS attrition_rate,
       RANK() OVER (ORDER BY AVG(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) DESC) AS department_rank
FROM hr_data GROUP BY department;

--14. Employee earning above Department Avg (CTE)
WITH dept_avg AS(
SELECT department, ROUND(AVG(monthlyincome),2) AS avg_salary
FROM hr_data
GROUP BY department
)

SELECT h.employeenumber, h.department,
h.jobrole, h.monthlyincome FROM hr_data h
JOIN dept_avg d
ON h.department = d.department
WHERE h.monthlyincome > d.avg_salary
ORDER BY h.department

--15. Top 5 highest paid employee in each dept. (WINDOW FN)
WITH ranked_salary AS (
SELECT department, employeenumber, jobrole, monthlyincome,
RANK() OVER(
PARTITION BY  department
ORDER BY monthlyincome DESC
) AS salary_rank 
FROM hr_data
)
SELECT * FROM ranked_salary 
WHERE salary_rank <= 5

-- NEW. Attrition RATE by any driver (swap the column name): department, overtime, jobrole,
-- income_group, maritalstatus, businesstravel, joblevel, stockoptionlevel, experience_group ...
SELECT overtime,
       COUNT(*) AS employees,
       ROUND(100.0 * AVG(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END), 1) AS attrition_rate
FROM hr_data GROUP BY overtime ORDER BY attrition_rate DESC;      
 
-- NEW. Does the overtime effect hold inside every department? (checks for confounding)
SELECT department, overtime,
       ROUND(100.0 * AVG(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END), 1) AS attrition_rate
FROM hr_data GROUP BY department, overtime ORDER BY department, overtime;
 