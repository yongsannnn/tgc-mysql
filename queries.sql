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

