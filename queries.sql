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