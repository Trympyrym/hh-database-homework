INSERT INTO users SELECT 'employer' || id AS username, '123' AS password, now() AS regTime, 'employer' AS usertype FROM generate_series(1, 5) as t(id);
INSERT INTO users SELECT 'candidate' || id AS username, '123' AS password, now() AS regTime, 'candidate' AS usertype FROM generate_series(1, 6) as t(id);
INSERT INTO usersLastVisit SELECT users.username AS username, users.regTime AS lastVisit FROM users;
INSERT INTO emails SELECT users.username AS owner, users.username || series.id || 'mailmailmail.email' AS email FROM users AS users LEFT JOIN GENERATE_SERIES(1, 3) AS series(id) ON true;


insert into users(username, regtime, type) select 'employer' || series.id, now(), 'employer' from generate_se
ries(1, 10000) as series(id) limit 1000 + round(random()*9000); // - insert random(1000, 10000) employers into users;

insert into users(username, regtime, type) select 'candidate' || series.id, now(), 'candidate' from generate_series(1, 100000) as series(id) limit 10000 + round(random()*90000); // - insert random(10000, 100000) candidates into users;

insert into users_last_visit select users.username, users.regtime from users; // - fill users_last_visit table with regTime values;

insert into emails select upper_subtable.username, upper_subtable.email_prefix || '@' || (array['yandex.ru', 'gmail.com', 'gmail.com', 'gmail.com', 'gmail.com', 'yandex.ru', 'hotmail.com', 'yandex.ru', 'gmail.com', 'gmail.com', 'gmail.com', 'mail.ru', 'gmail.com', 'gmail.com'])[ceil(random()*14)] from (select users.username, users.username || '_1' as email_prefix from users union all select subtable.username, subtable.username || '_2' as email_prefix from (select users.username as username, random() > 0.2 as second_email_present from users) as subtable where second_email_present union all select subtable.username, subtable.username || '_3' as email_prefix from (select users.username as username, random() > 0.4 as third_email_present from users) as subtable where third_email_present union all select subtable.username, subtable.username || '_4' as email_prefix from (select users.username as username, random() > 0.6 as fourth_email_present from users) as subtable where fourth_email_present union all select subtable.username, subtable.username || '_5' as email_prefix from (select users.username as username, random() > 0.8 as fifth_email_present from users) as subtable where fifth_email_present) as upper_subtable;

insert into companies(username, name) select subtable.username, 'company_' || series.id || '_of_' || subtable.username from (select users.username, 1 + random()*15 as random_number from users where users.type = 'employer') as subtable left join generate_series(1, 20) as series(id) on series.id < subtable.random_number; // every employer has 1-16 companies

insert into cv(owner, position) select subtable.username, 'some position' from (select users.username, 1 + random()*19 as random_number from users where users.type = 'candidate') as subtable left join generate_series(1, 20) as series(id) on series.id < subtable.random_number; 

insert into vacancies(owner, position) select subtable.id, 'some position' from (select companies.id, 1 + random()*100 as random_number from companies) as subtable left join generate_series(1, 100) as series(id) on series.id < subtable.random_number;

insert into vacancies_timeline(vacancy, duration) select id, tsrange(begin_date, begin_date + random()*('1 mo
nth'::interval)) from (select id, '2016-12-01 20:00:00'::timestamp + random()*('5 month'::interval) as begin_date from (
select id from (select id, random() as random_number from vacancies) as subtable_1 where random_number < 0.9 ) as subtab
le_2) as subtable_3;

insert into messages(vacancy, cv, direction, text) select vac_id, cv_id, (array['toEmployer', 'toCandidate'])[ceil(random()*2)]::message_direction, md5(cast(random() as text)) from (select vacancies.id as vac_id, cv.id as cv_id,
random() as random_number from vacancies left join cv on true) as subtable_1 where random_number < 0.0000007;