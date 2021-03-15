-- To log in 
-- Root user is always created by default, root user does not have any password
-- If have password should be mysql -u username -p password
mysql -u root

-- See all databases
show databases;

-- Create database
create database swimming;

-- Switch database
use swimming;

-- Show all tables
show tables;

-- Create tables

-- engine=innodb -> To enable foreign key

-- unsigned -> Is to ensure no negative numbers

-- auto_increment -> Will always give next available number, number deleted will not be reused.

-- primary key -> Numbers can jump 

-- not null -> Cannot be empty

-- Make sure last line have no comma
create table Parents (
    parents_id int unsigned auto_increment primary key,
    surname varchar(50) not null,
    given_name varchar(50) not null,
    email varchar(350) not null
) engine=innodb; 

-- Insert one row to the table
insert into Parents(surname, given_name, email)
    values("Tan", "Choon Seng","choonsengtan@geemail.com");

-- See all the row in a table
select * from Parents;

-- Add many in one row
insert into Parents(surname, given_name, email)
    values("Leow", "Ming Ming","mingmingleow@geemail.com"),
          ("Jonas", "Valentino", "valentinojonas@geemail.com"); 



-- Create the strong entity first
-- Venues 
create table Venues (
    venue_id int unsigned auto_increment primary key,
    address varchar(500) not null
) engine=innodb;

-- Insert ONE address
insert into Venues (address)
    values("351 Yishun Ave 3, S769057");

-- Insert MULTIPLE address
insert into Venues (address)
    values("95 Hougang Ave 4, S538830"),
    ("900 Tiong Bahru Road, S158790");


-- Certificates
create table Certificates(
    certificate_id int unsigned auto_increment primary key,
    title varchar(200) not null
) engine=innodb;

-- Insert ONE Certificate
insert into Certificates(title)
    values("Singapore Swimming Proficiency Awards Level 1");

-- Insert MULTIPLE Certificates
insert into Certificates(title)
    values("Singapore Swimming Proficiency Awards Level 2"),
    ("Singapore Swimming Proficiency Awards Level 3");



-- See the output of the table
describe Venues;

-- Foreign keys
-- Must match the parents_id definition, in this case must include "int unsigned"
-- syntax
-- foreign key (declared_key) reference table_name(declared_key)
 
create table Students (
    student_id int unsigned auto_increment primary key,
    surname varchar(100) not null,
    given_name varchar(100) not null,
    date_of_birth date not null,
    parents_id int unsigned not null, 
    foreign key(parents_id) references Parents(parents_id)
) engine=innodb;

-- Insert a student
insert into Students (surname, given_name, date_of_birth, parents_id)
values ("Tan", "James", "1990-06-29", 1);

insert into Students (surname, given_name, date_of_birth, parents_id)
    values ("Leow", "Da Ming", "1997-01-13", 2),
             ("Leow", "Xiao Ming", "1998-06-22", 2);

-- If parent key inserted does not exist, it will give you an error. 
insert into Students (surname, given_name, date_of_birth, parents_id)
    values ("Sue", "Mary", "1990-06-29", 999);

-- ERROR 1452 (23000): Cannot add or update a child row: a foreign key constraint fails (`swimming`.`Students`, CONSTRAINT `Students_ibfk_1` FOREIGN KEY (`parents_id`) REFERENCES `Parents` (`parents_id`))
-- Mongo will not have such error message. (Document Base Vs Relational Base)

-- Delete syntax
delete Parents where parents_id = 1;
-- This will not work too because system will cause a contradiction. One of the student have parents_id = 1.
-- In order for this to work we need to delete the student first.

-- Create Sessions table
create table Sessions (
    session_id int unsigned auto_increment primary key,
    session_date datetime not null,
    venue_id int unsigned not null,
    foreign key(venue_id) references Venues(venue_id)
) engine=innodb;

insert into Sessions (session_date, venue_id)
    values("2020-02-14 12:00:00", 1);

insert into Sessions (session_date, venue_id)
    values("2020-02-21 22:00:00", 2),
          ("2020-02-21 21:00:00", 2);

delete Venues where venue_id = 1;


-- Create Pivot table
-- Certificate_Student table
create table Certificate_Student(
    certificate_student_id int unsigned auto_increment primary key,
    student_id int unsigned,
    certificate_id int unsigned,
    awarded_date date not null,
    foreign key (student_id) references Students(student_id),
    foreign key (certificate_id) references Certificates(certificate_id)
) engine = innodb;

insert into Certificate_Student(student_id,certificate_id,awarded_date)
    values(2,1, "2021-02-14");


-- To alter a table
-- syntax
-- alter table (tableName) (operator) (columnName) (criteria)
alter table Students add gender varchar(1) not null;

-- To rename a column
alter table Students rename column surname to last_name;
alter table Students rename column given_name to first_name;

-- Modify the definition of a column
alter table Students modify gender varchar(1);

-- Deleting the entire table
-- Assuming there is a table called "Fake" 
drop table Fake;


-- To create, use `insert`
-- To delete, use `delete from` and `where` 
delete from Parents where parents_id = 3;

-- To modify a row, we use `update`
-- update `Table` set `THINGS YOU WANT TO CHANGE` where `condition`
update Students set gender = "M" where student_id = 3;


-- Add in a foreign key after a table has been created. 
-- Example, I want to have coach id under the Sessions table
-- 1. Create Table first
create table Coaches(
    coach_id tinyint unsigned auto_increment primary key,
    `name` varchar(100) not null
) engine=innodb;
insert into Coaches(`name`)
    values ("Steven");

-- 2. Add in new column to the Sessions table
alter table Sessions add coach_id tinyint unsigned not null;

-- 3. Add in foreign key definition
alter table Sessions add foreign key(coach_id) references Coaches(coach_id); 

