alter session set "_ORACLE_SCRIPT"=true;

-- Brallan Garcia Aguirre

CREATE TABLE ATTACKS(
id INTEGER,
url VARCHAR2(2048),
ip_address VARCHAR2(255),
number_of_attacks INTEGER,
time_of_last_attack TIMESTAMP
);

-- PART I

-- 1. Create a tablespace with name 'quiz' and three datafiles. Each datafile of 15Mb.
CREATE TABLESPACE quiz
    DATAFILE 'quiz01.DBF' SIZE 15M,
             'quiz02.DBF' SIZE 15M,
             'quiz03.DBF' SIZE 15M
    EXTENT MANAGEMENT LOCAL AUTOALLOCATE;

-- 2. Create a profile with idle time of 20 minutes, the name of the profile should be 'student'

CREATE PROFILE student LIMIT IDLE_TIME 20; 

-- 3. Create an user named "usuario_1" with password "usuario_1". 
--	- The user should be able to connect
--	- The user should has the profile "student"
--	- The user should be associated to the tablespace "quiz"
--	- The user should be able to create tables WITHOUT USING THE DBA ROLE.
CREATE USER usuario_1
IDENTIFIED BY "usuario_1" 
DEFAULT TABLESPACE quiz
QUOTA UNLIMITED ON quiz;

GRANT CONNECT TO usuario_1;

ALTER USER usuario_1 PROFILE student;

GRANT CREATE ON DBA TO usuario_1;

-- 4. Create an user named "usuario_2" with password "usuario_2"
--	- The user should be able to connect
--	- The user should has the profile "student"
--	- The user should be associated to the tablespace "quiz"
--	- The user shouldn't be able to create tables.
CREATE USER usuario_2 
IDENTIFIED BY "usuario_2" 
DEFAULT TABLESPACE quiz
QUOTA UNLIMITED ON quiz;

GRANT CONNECT TO usuario_2;

ALTER USER usuario_2 PROFILE student;


-- PART II

-- 1. With the usuario_1 create the next table (DON'T CHANGE THE NAME OF THE TABLE NOR COLUMNS: 
create table attacks (
	id INT,
	url VARCHAR(2048),
	ip_address VARCHAR(20),
	number_of_attacks INT,
	time_of_last_attack TIMESTAMP
);

-- 2. Import this data (The format of the date is "YYYY-MM-DD HH24:MI:SS"): https://gist.github.com/amartinezg/6c2c27ae630102dbfb499ed22b338dd8
-- 3. Give permission to view table "attacks" of the usuario_2 (Do selects)

-- PART III

-- Queries: 

-- 1. Count the urls which have been attacked and have the protocol 'https'
SELECT COUNT(1) FROM ATTACKS WHERE URL LIKE 'https%';
-- 2. List the records where the URL attacked matches with google (it does not matter if it is google.co.jp, google.es, google.pt, etc) order by number of attacks ascendent
SELECT * FROM ATTACKS WHERE URL LIKE '%google%' ORDER BY number_of_attacks ASC;
-- 3. List the ip addresses and the time of the last attack if the attack has been produced the last year (2017) (Hint: https://stackoverflow.com/a/30071091)
SELECT ip_address,time_of_last_attack FROM ATTACKS WHERE EXTRACT(year FROM time_of_last_attack) = 2017;
-- 4. Show the first IP Adress which has been registered with the minimum number of attacks 
SELECT * FROM (SELECT ip_address FROM ATTACKS ORDER BY number_of_attacks ASC) WHERE ROWNUM = 1;
-- 5. Show the ip address and the number of attacks if instagram has been attack using https protocol
SELECT ip_address,COUNT(1) FROM ATTACKS WHERE URL LIKE 'https%' AND URL LIKE '%instagram%' GROUP BY ip_address;