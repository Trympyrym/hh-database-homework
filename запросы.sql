﻿1) Работодатели без вакансий

SELECT
	companies.name AS name,
	any_email.email AS email,
	users.regtime AS regtime,
	users_last_visit.last_visit AS last_visit
FROM
	companies 
	LEFT JOIN vacancies 
		ON companies.id = vacancies.owner 
	LEFT JOIN any_email
		ON companies.id = any_email.company
	LEFT JOIN users_last_visit
		ON companies.username = users_last_visit.username
	LEFT JOIN users
		ON companies.username = users.username
WHERE
	vacancies.owner IS NULL;

2) Вакансии, срок размещения которых истекает менее чем через сутки

SELECT 
	vacancies.position AS position,
	upper(vacancies_timeline.duration) - now() AS timeleft,
	companies.name AS companyName,
	any_email.email AS email
FROM
	vacancies_timeline
	LEFT JOIN vacancies 
		ON vacancies.id = vacancies_timeline.vacancy 
	LEFT JOIN companies 
		ON vacancies.owner = companies.id 
	LEFT JOIN any_email
		ON companies.id = any_email.company
WHERE
	vacancies_timeline.duration @> now()::timestamp 
	AND upper(vacancies_timeline.duration) - '24 hours'::interval < now()::timestamp

3) Активные вакансии, размещенные более чем неделю, но без сообщений от соискателей

SELECT 
	vacancies.position AS position,
	companies.name AS companyName,
	any_email.email AS email
FROM
	vacancies_timeline 
	LEFT JOIN messages 
		ON vacancies_timeline.vacancy = messages.vacancy
		AND messages.direction = 'toEmployer'
	LEFT JOIN vacancies
		ON vacancies_timeline.vacancy = vacancies.id 
	LEFT JOIN companies 
		ON vacancies.owner = companies.id
	LEFT JOIN any_email
		ON companies.id = any_email.company
WHERE
	vacancies_timeline.duration @> now()::timestamp
	AND lower(vacancies_timeline.duration) + '1 week'::interval < now()::timestamp
	AND messages.vacancy IS NULL;

4) Список вакансий + количество откликнувшихся

SELECT 
	vacancies.position AS position,
	companies.name AS companyname,
	COUNT(DISTINCT cv.owner) AS number_of_unique_responses
FROM
	vacancies
	LEFT JOIN companies 
		ON vacancies.owner = companies.id
	LEFT JOIN messages
		ON vacancies.id = messages.vacancy
		AND messages.direction = 'toEmployer'
	LEFT JOIN cv
		ON messages.cv = cv.id 
GROUP BY
	vacancies.position,
	ccompanies.name;


5) Среднее количество сообщений на вакансию у компании
SELECT
	COUNT(messages.vacancy) / COUNT(DISTINCT messages.vacancy) AS responses_per_vacancy,
	companies.name AS companyname
FROM
	messages
	LEFT JOIN vacancies
		ON messages.vacancy = vacancies.id
	LEFT JOIN companies
		ON vacancies.owner = companies.id
GROUP BY companies.name;