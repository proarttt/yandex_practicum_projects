--1)Определите диапазон заработных плат в общем, а именно средние значения, минимумы и максимумы нижних и верхних порогов зарплаты.
--2)Выявите регионы и компании, в которых сосредоточено наибольшее количество вакансий.
--3)Проанализируйте, какие преобладают типы занятости, а также графики работы.
--4)Изучите распределение грейдов (Junior, Middle, Senior) среди аналитиков данных и системных аналитиков.
--5)Выявите основных работодателей, предлагаемые зарплаты и условия труда для аналитиков.
--6)Определите наиболее востребованные навыки (как жёсткие, так и мягкие) для  позиции junior-разработчика.


SELECT *
FROM public.parcing_table;



--Определите диапазон заработных плат в общем, а именно средние значения, минимумы и максимумы нижних и верхних порогов зарплаты.
SELECT min(salary_from) AS min_salary_from, min(salary_to) AS min_salary_to,  max(salary_from) AS max_salary_from, max(salary_to) 
AS max_salary_to, avg(salary_from) AS avg_salary_from, avg(salary_to)  AS avg_salary_to
FROM public.parcing_table
WHERE salary_from IS NOT NULL;
-- Средняя зарплата в категории «от» составляет около 109525 рублей, а  
-- в категории «до» — около 153969 рублей. Это указывает на то, что работодатели готовы платить
-- аналитикам данных и системным аналитикам в среднем около 130000 рублей. 
-- Минимальная предлагаемая зарплата начинается с 50 рублей, что, скорее всего, 
-- является ошибкой данных, а максимальная достигает 497500 рублей.



--Выявите регионы и компании, в которых сосредоточено наибольшее количество вакансий. ТОП 10
SELECT area, count(id) AS count_id
FROM public.parcing_table
GROUP BY area 
ORDER BY count_id DESC
LIMIT 10;
-- Москва и Санкт-Петербург — лидеры по количеству вакансий. 
-- Это неудивительно, учитывая, что это крупнейшие города 
-- с развитой инфраструктурой и большим количеством компаний.

SELECT employer, count(id) AS count_id
FROM public.parcing_table
GROUP BY employer 
ORDER BY count_id desc
LIMIT 10
-- СБЕР предлагает 243 вакансии и является крупнейшим работодателем для аналитиков данных и 
-- системных аналитиков. Это может говорить о значительных инвестициях в аналитику и технологические решения
-- в компании. К тому же в банковской среде всегда нужны аналитики. WILDBERRIES, Ozon 
-- и другие крупные компании также активно ищут специалистов в области данных, 
-- что говорит о высоком спросе на аналитиков в крупных корпорациях.

--Проанализируйте, какие преобладают типы занятости, а также графики работы.

SELECT schedule, count(id) AS count_schedule
FROM public.parcing_table
GROUP BY schedule 
ORDER BY count_schedule DESC;
-- Большинство вакансий (1441) предлагают работу с полным днём. 
-- Однако значительное количество вакансий (310) также позволяет 
-- удалённую работу. Это указывает на то, что работодатели готовы быть
-- гибкими в современных условиях.

SELECT employment, count(id) AS count_employment
FROM public.parcing_table
GROUP BY employment
ORDER BY count_employment DESC;
-- Подавляющее большинство вакансий (1764) предлагают полную занятость.
-- Это указывает на то, что работодатели предпочитают нанимать 
-- аналитиков данных и системных аналитиков на постоянные позиции.


--Изучите распределение грейдов (Junior, Middle, Senior) среди аналитиков данных и системных аналитиков.

SELECT experience, count(id) AS count_id
FROM public.parcing_table
GROUP BY experience
ORDER BY count_id desc;
-- Наибольшее количество вакансий предназначено для специалистов с опытом от 1 до 3 лет (Junior+), 
-- что свидетельствует о высоком спросе на специалистов начального и среднего уровней. 

-- Определение доли грейдов среди вакансий аналитиков

-- 1) общее количество вакансий 

SELECT COUNT(*) 
FROM public.parcing_table 
WHERE name LIKE '%Аналитик данных%' 
   OR name LIKE '%аналитик данных%'
   OR name LIKE '%Системный аналитик%'
   OR name LIKE '%системный аналитик%';

-- Результат - 1326. 
-- 2)  доли:

SELECT experience,
       COUNT(*) AS count_vacancies,
       ROUND(COUNT(*) * 100.0 / 1326, 2) AS percent_vacancies
FROM public.parcing_table
WHERE name LIKE '%Аналитик данных%' 
   OR name LIKE '%аналитик данных%'
   OR name LIKE '%Системный аналитик%'
   OR name LIKE '%системный аналитик%'
GROUP BY experience
ORDER BY percent_vacancies DESC;

-- Большинство вакансий для аналитиков данных и системных аналитиков предназначены
-- для специалистов уровня Junior+ (64.40%) и Middle (26.02%). Это подтверждает высокую 
-- потребность в специалистах начального и среднего уровней. 

--Выявите основных работодателей, предлагаемые зарплаты и условия труда для аналитиков.
SELECT employer, schedule,  avg(salary_from) AS avg_salary_from, avg(salary_to)  AS avg_salary_to
FROM public.parcing_table
WHERE (employer = 'СБЕР' OR employer = 'WILDBERRIES' OR employer = 'Ozon') AND salary_from IS NOT NULL AND salary_to IS NOT null
GROUP BY employer, schedule
LIMIT 10;

--Определите наиболее востребованные навыки (как жёсткие, так и мягкие) для различных грейдов и позиций.
SELECT key_skills_1, count(id) AS count_id
FROM public.parcing_table
WHERE key_skills_1 IS NOT NULL AND experience = 'Junior+ (1-3 years)' AND key_skills_1 != ''
GROUP BY key_skills_1
ORDER BY count_id DESC
LIMIT 10;

SELECT key_skills_2, count(id) AS count_id
FROM public.parcing_table
WHERE key_skills_2 IS NOT NULL AND experience = 'Junior+ (1-3 years)' AND key_skills_1 != ''
GROUP BY key_skills_2
ORDER BY count_id DESC
LIMIT 10;

SELECT key_skills_3, count(id) AS count_id
FROM public.parcing_table
WHERE key_skills_3 IS NOT NULL AND experience = 'Junior+ (1-3 years)' AND key_skills_1 != ''
GROUP BY key_skills_3
ORDER BY count_id DESC
LIMIT 10;

SELECT soft_skills_1, count(id) AS count_id
FROM public.parcing_table
WHERE soft_skills_1 IS NOT NULL AND experience = 'Junior+ (1-3 years)' AND key_skills_1 != ''
GROUP BY soft_skills_1
ORDER BY count_id DESC
LIMIT 10;

SELECT soft_skills_2, count(id) AS count_id
FROM public.parcing_table
WHERE soft_skills_2 IS NOT NULL AND experience = 'Junior+ (1-3 years)' AND key_skills_1 != ''
GROUP BY soft_skills_2
ORDER BY count_id DESC
LIMIT 5;

SELECT soft_skills_3, count(id) AS count_id
FROM public.parcing_table
WHERE soft_skills_3 IS NOT NULL AND experience = 'Junior+ (1-3 years)' AND key_skills_1 != ''
GROUP BY soft_skills_3
ORDER BY count_id DESC
LIMIT 2;

--Итоговый вывод:
--Для позиции junior-разработчика наиболее критичными являются два ключевых навыка:
--1) SQL - фундаментальный инструмент для работы с данными, без которого невозможна эффективная аналитика и взаимодействие с базами данных
--2) Работа с документацией - умение самостоятельно находить информацию, разбираться в требованиях и осваивать новые технологии





