--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.1
-- Dumped by pg_dump version 9.6.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: postgres; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE postgres IS 'default administrative connection database';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: message_direction; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE message_direction AS ENUM (
    'toEmployer',
    'toCandidate'
);


ALTER TYPE message_direction OWNER TO postgres;

--
-- Name: usertype; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE usertype AS ENUM (
    'employer',
    'candidate'
);


ALTER TYPE usertype OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: companies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE companies (
    id bigint NOT NULL,
    username character varying(20),
    name character varying(100) NOT NULL
);


ALTER TABLE companies OWNER TO postgres;

--
-- Name: emails; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE emails (
    owner character varying(20),
    email character varying(80) NOT NULL
);


ALTER TABLE emails OWNER TO postgres;

--
-- Name: any_email; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW any_email AS
 SELECT companies.id AS company,
    max((emails.email)::text) AS email
   FROM (companies
     LEFT JOIN emails ON (((companies.username)::text = (emails.owner)::text)))
  GROUP BY companies.id
  WITH NO DATA;


ALTER TABLE any_email OWNER TO postgres;

--
-- Name: companies_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE companies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE companies_id_seq OWNER TO postgres;

--
-- Name: companies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE companies_id_seq OWNED BY companies.id;


--
-- Name: cv; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE cv (
    id bigint NOT NULL,
    owner character varying(20),
    "position" character varying(80) NOT NULL,
    age integer,
    salary int4range,
    exp integer
);


ALTER TABLE cv OWNER TO postgres;

--
-- Name: cv_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE cv_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cv_id_seq OWNER TO postgres;

--
-- Name: cv_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE cv_id_seq OWNED BY cv.id;


--
-- Name: messages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE messages (
    vacancy bigint,
    cv bigint,
    direction message_direction,
    text text
);


ALTER TABLE messages OWNER TO postgres;

--
-- Name: skills_needed; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE skills_needed (
    target bigint NOT NULL,
    name character varying(80) NOT NULL
);


ALTER TABLE skills_needed OWNER TO postgres;

--
-- Name: skills_provided; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE skills_provided (
    target bigint NOT NULL,
    name character varying(80) NOT NULL
);


ALTER TABLE skills_provided OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE users (
    username character varying(20) NOT NULL,
    password character varying(20),
    regtime timestamp without time zone,
    type usertype
);


ALTER TABLE users OWNER TO postgres;

--
-- Name: users_last_visit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE users_last_visit (
    username character varying(20) NOT NULL,
    last_visit timestamp without time zone
);


ALTER TABLE users_last_visit OWNER TO postgres;

--
-- Name: vacancies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE vacancies (
    id bigint NOT NULL,
    owner bigint,
    "position" character varying(80) NOT NULL,
    description character varying(500),
    salary int4range,
    exp integer
);


ALTER TABLE vacancies OWNER TO postgres;

--
-- Name: vacancies_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE vacancies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE vacancies_id_seq OWNER TO postgres;

--
-- Name: vacancies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE vacancies_id_seq OWNED BY vacancies.id;


--
-- Name: vacancies_timeline; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE vacancies_timeline (
    vacancy bigint NOT NULL,
    duration tsrange
);


ALTER TABLE vacancies_timeline OWNER TO postgres;

--
-- Name: companies id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY companies ALTER COLUMN id SET DEFAULT nextval('companies_id_seq'::regclass);


--
-- Name: cv id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY cv ALTER COLUMN id SET DEFAULT nextval('cv_id_seq'::regclass);


--
-- Name: vacancies id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY vacancies ALTER COLUMN id SET DEFAULT nextval('vacancies_id_seq'::regclass);


--
-- Data for Name: companies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY companies (id, username, name) FROM stdin;
50	employer1	employer1company1
51	employer1	employer1company2
52	employer1	employer1company3
53	employer2	employer2company1
54	employer2	employer2company2
55	employer2	employer2company3
56	employer3	employer3company1
57	employer3	employer3company2
58	employer3	employer3company3
59	employer4	employer4company1
60	employer4	employer4company2
61	employer4	employer4company3
62	employer5	employer5company1
63	employer5	employer5company2
64	employer5	employer5company3
\.


--
-- Name: companies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('companies_id_seq', 64, true);


--
-- Data for Name: cv; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY cv (id, owner, "position", age, salary, exp) FROM stdin;
1	candidate1	qweqwe	\N	\N	\N
2	candidate2	qweqe	\N	\N	\N
3	candidate3	qwqwqw	\N	\N	\N
\.


--
-- Name: cv_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('cv_id_seq', 3, true);


--
-- Data for Name: emails; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY emails (owner, email) FROM stdin;
employer1	employer11mailmailmail.email
employer1	employer12mailmailmail.email
employer1	employer13mailmailmail.email
employer2	employer21mailmailmail.email
employer2	employer22mailmailmail.email
employer2	employer23mailmailmail.email
employer3	employer31mailmailmail.email
employer3	employer32mailmailmail.email
employer3	employer33mailmailmail.email
employer4	employer41mailmailmail.email
employer4	employer42mailmailmail.email
employer4	employer43mailmailmail.email
employer5	employer51mailmailmail.email
employer5	employer52mailmailmail.email
employer5	employer53mailmailmail.email
candidate1	candidate11mailmailmail.email
candidate1	candidate12mailmailmail.email
candidate1	candidate13mailmailmail.email
candidate2	candidate21mailmailmail.email
candidate2	candidate22mailmailmail.email
candidate2	candidate23mailmailmail.email
candidate3	candidate31mailmailmail.email
candidate3	candidate32mailmailmail.email
candidate3	candidate33mailmailmail.email
candidate4	candidate41mailmailmail.email
candidate4	candidate42mailmailmail.email
candidate4	candidate43mailmailmail.email
candidate5	candidate51mailmailmail.email
candidate5	candidate52mailmailmail.email
candidate5	candidate53mailmailmail.email
candidate6	candidate61mailmailmail.email
candidate6	candidate62mailmailmail.email
candidate6	candidate63mailmailmail.email
\.


--
-- Data for Name: messages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY messages (vacancy, cv, direction, text) FROM stdin;
1	2	toEmployer	\N
1	3	toEmployer	\N
2	1	toEmployer	\N
3	2	toCandidate	\N
\.


--
-- Data for Name: skills_needed; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY skills_needed (target, name) FROM stdin;
\.


--
-- Data for Name: skills_provided; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY skills_provided (target, name) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY users (username, password, regtime, type) FROM stdin;
employer1	123	2017-02-06 17:41:07.895963	employer
employer2	123	2017-02-06 17:41:07.895963	employer
employer3	123	2017-02-06 17:41:07.895963	employer
employer4	123	2017-02-06 17:41:07.895963	employer
employer5	123	2017-02-06 17:41:07.895963	employer
candidate1	123	2017-02-06 17:42:11.400517	candidate
candidate2	123	2017-02-06 17:42:11.400517	candidate
candidate3	123	2017-02-06 17:42:11.400517	candidate
candidate4	123	2017-02-06 17:42:11.400517	candidate
candidate5	123	2017-02-06 17:42:11.400517	candidate
candidate6	123	2017-02-06 17:42:11.400517	candidate
\.


--
-- Data for Name: users_last_visit; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY users_last_visit (username, last_visit) FROM stdin;
employer1	2017-02-06 17:41:07.895963
employer2	2017-02-06 17:41:07.895963
employer3	2017-02-06 17:41:07.895963
employer4	2017-02-06 17:41:07.895963
employer5	2017-02-06 17:41:07.895963
candidate1	2017-02-06 17:42:11.400517
candidate2	2017-02-06 17:42:11.400517
candidate3	2017-02-06 17:42:11.400517
candidate4	2017-02-06 17:42:11.400517
candidate5	2017-02-06 17:42:11.400517
candidate6	2017-02-06 17:42:11.400517
\.


--
-- Data for Name: vacancies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY vacancies (id, owner, "position", description, salary, exp) FROM stdin;
1	50	position1_1	\N	\N	\N
2	50	position1_2	\N	\N	\N
3	52	position3_1	\N	\N	\N
\.


--
-- Name: vacancies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('vacancies_id_seq', 3, true);


--
-- Data for Name: vacancies_timeline; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY vacancies_timeline (vacancy, duration) FROM stdin;
1	["2010-01-01 14:30:00","2010-01-01 15:30:00")
2	["2017-02-05 15:58:05.165411","2017-02-13 14:58:05.165411")
3	["2017-01-29 16:22:03.191505","2017-02-13 21:22:03.191505")
\.


--
-- Name: companies companies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY companies
    ADD CONSTRAINT companies_pkey PRIMARY KEY (id);


--
-- Name: cv cv_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY cv
    ADD CONSTRAINT cv_pkey PRIMARY KEY (id);


--
-- Name: emails emails_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY emails
    ADD CONSTRAINT emails_pkey PRIMARY KEY (email);


--
-- Name: skills_needed skills_needed_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY skills_needed
    ADD CONSTRAINT skills_needed_pkey PRIMARY KEY (target, name);


--
-- Name: skills_provided skills_provided_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY skills_provided
    ADD CONSTRAINT skills_provided_pkey PRIMARY KEY (target, name);


--
-- Name: users_last_visit users_last_visit_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users_last_visit
    ADD CONSTRAINT users_last_visit_pkey PRIMARY KEY (username);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (username);


--
-- Name: vacancies vacancies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY vacancies
    ADD CONSTRAINT vacancies_pkey PRIMARY KEY (id);


--
-- Name: vacancies_timeline vacancies_timeline_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY vacancies_timeline
    ADD CONSTRAINT vacancies_timeline_pkey PRIMARY KEY (vacancy);


--
-- Name: anyemailscompanyindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX anyemailscompanyindex ON any_email USING btree (company);


--
-- Name: companies_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX companies_id_index ON companies USING btree (id);


--
-- Name: companies_username_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX companies_username_index ON companies USING btree (username);


--
-- Name: cvidindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX cvidindex ON cv USING btree (id);


--
-- Name: messagesvacancyindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX messagesvacancyindex ON messages USING btree (vacancy);


--
-- Name: users_last_visit_username_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX users_last_visit_username_index ON users_last_visit USING btree (username);


--
-- Name: users_username_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX users_username_index ON users USING btree (username);


--
-- Name: vacancies_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX vacancies_id_index ON vacancies USING btree (id);


--
-- Name: vacancies_owner_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX vacancies_owner_index ON vacancies USING btree (owner);


--
-- Name: vacancies_timeline_active_vacancy_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX vacancies_timeline_active_vacancy_index ON vacancies_timeline USING gist (duration);


--
-- Name: vacancies_timeline_lower_bound_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX vacancies_timeline_lower_bound_index ON vacancies_timeline USING btree (lower(duration));


--
-- Name: vacancies_timeline_upper_bound_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX vacancies_timeline_upper_bound_index ON vacancies_timeline USING btree (upper(duration));


--
-- Name: vacanciestimelinevacancyindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX vacanciestimelinevacancyindex ON vacancies_timeline USING btree (vacancy);


--
-- Name: companies companies_username_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY companies
    ADD CONSTRAINT companies_username_fkey FOREIGN KEY (username) REFERENCES users(username) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: cv cv_owner_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY cv
    ADD CONSTRAINT cv_owner_fkey FOREIGN KEY (owner) REFERENCES users(username) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: emails emails_owner_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY emails
    ADD CONSTRAINT emails_owner_fkey FOREIGN KEY (owner) REFERENCES users(username) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: messages messages_cv_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY messages
    ADD CONSTRAINT messages_cv_fkey FOREIGN KEY (cv) REFERENCES cv(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: messages messages_vacancy_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY messages
    ADD CONSTRAINT messages_vacancy_fkey FOREIGN KEY (vacancy) REFERENCES vacancies(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: skills_needed skills_needed_target_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY skills_needed
    ADD CONSTRAINT skills_needed_target_fkey FOREIGN KEY (target) REFERENCES vacancies(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: skills_provided skills_provided_target_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY skills_provided
    ADD CONSTRAINT skills_provided_target_fkey FOREIGN KEY (target) REFERENCES cv(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: users_last_visit users_last_visit_username_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users_last_visit
    ADD CONSTRAINT users_last_visit_username_fkey FOREIGN KEY (username) REFERENCES users(username) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: vacancies vacancies_owner_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY vacancies
    ADD CONSTRAINT vacancies_owner_fkey FOREIGN KEY (owner) REFERENCES companies(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: vacancies_timeline vacancies_timeline_vacancy_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY vacancies_timeline
    ADD CONSTRAINT vacancies_timeline_vacancy_fkey FOREIGN KEY (vacancy) REFERENCES vacancies(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: any_email; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: postgres
--

REFRESH MATERIALIZED VIEW any_email;


--
-- PostgreSQL database dump complete
--

