CREATE TYPE usertype AS ENUM ('employer', 'candidate');
CREATE TABLE users ( username VARCHAR(20) PRIMARY KEY, password VARCHAR(20), regTime TIMESTAMP, type usertype);
CREATE INDEX users_username_index ON users (username);


CREATE TABLE usersLastVisit(username VARCHAR(20) PRIMARY KEY REFERENCES users (username) ON UPDATE CASCADE ON DELETE CASCADE, lastVisit TIMESTAMP);
CREATE INDEX usersLastVisitUsernameIndex ON usersLastVisit (username);


CREATE TABLE emails (owner VARCHAR(20) REFERENCES users (username) ON UPDATE CASCADE ON DELETE CASCADE, email VARCHAR(80) PRIMARY KEY);
CREATE INDEX emailsOwnerIndex ON emails (owner);


CREATE TABLE companies (id BIGSERIAL PRIMARY KEY, username VARCHAR(20) REFERENCES users (username) ON UPDATE CASCADE ON DELETE SET NULL, name VARCHAR(100) NOT NULL);
CREATE INDEX companiesIdIndex ON companies(id);
CREATE INDEX companiesUsernameIndex ON companies(username);

CREATE TABLE VACANCIES(id BIGSERIAL PRIMARY KEY, owner BIGINT REFERENCES COMPANIES (id) ON UPDATE CASCADE ON DELETE CASCADE, position VARCHAR(80) NOT NULL, description VARCHAR(500), salary int4range, exp integer);
CREATE INDEX vacanciesIdIndex ON vacancies(id);
CREATE INDEX vacanciesOwnerIndex ON vacancies(owner);

CREATE TABLE vacancies_timeline(vacancy BIGINT PRIMARY KEY REFERENCES vacancies (id) ON UPDATE CASCADE ON DELETE CASCADE, duration tsrange);
CREATE INDEX vacanciesTimelineVacancyIndex ON vacancies_timeline(vacancy);
create index vacancies_timeline_active_vacancy_index on vacancies_timeline using gist (duration);
create index vacancies_timeline_lower_bound_index on vacancies_timeline ((lower(duration)));
create index vacancies_timeline_upper_bound_index on vacancies_timeline ((upper(duration)));

CREATE TABLE skills_needed(target bigint REFERENCES vacancies(id) ON DELETE CASCADE ON UPDATE CASCADE, name varchar(80), PRIMARY KEY (target, name));

CREATE TABLE cv(id BIGSERIAL PRIMARY KEY, owner varchar(20) REFERENCES users(username) ON UPDATE CASCADE ON DELETE CASCADE, position varchar(80) NOT NULL, age integer, salary int4range, exp integer);
CREATE INDEX cvIdIndex ON cv (id);

CREATE TABLE skills_provided(target BIGINT REFERENCES cv(id) ON DELETE CASCADE ON UPDATE CASCADE, name varchar(80), PRIMARY KEY(target, name));

CREATE TYPE message_direction AS ENUM('toEmployer', 'toCandidate');
CREATE TABLE messages(vacancy bigint REFERENCES vacancies(id) ON DELETE SET NULL ON UPDATE CASCADE, cv bigint REFERENCES cv(id) ON DELETE SET NULL ON UPDATE CASCADE,  direction message_direction, text text);
CREATE INDEX messagesVacancyIndex ON messages(vacancy);

CREATE MATERIALIZED VIEW any_email AS SELECT companies.id AS company, max(emails.email) AS email FROM companies LEFT JOIN emails ON companies.username=emails.owner GROUP BY company; 
CREATE INDEX anyEmailscompanyIndex ON any_email (company);