-- Using employee relationship ER diagram
-- Removed self relationship/ reviews and supervisor


-- Create Database
create database company;

-- Switch database
use company;

-- Create Strong entity first
-- Departments
create table Departments(
    department_id tinyint unsigned auto_increment primary key,
    `name` varchar(100) not null
) engine=innodb;

insert into Departments(`name`)
    values("Management"),
        ("Operation"),
        ("Marketing"),
        ("Accounting");


-- Taskforces
create table Taskforces(
    taskforce_id tinyint unsigned auto_increment primary key,
    `name` varchar(100) not null
) engine = innodb;

insert into Taskforces(`name`)
    values("Fire Response Team"),
    ("Covid Response Team"), 
    ("Employee Welfare Team");

-- Create Employees Table
-- Reference department_id
create table Employees (
    employee_id smallint unsigned auto_increment primary key,
    surname varchar(30) not null,
    given_name varchar(100) not null,
    date_of_employment date not null,
    department_id tinyint unsigned,
    foreign key(department_id) references Departments(department_id) on delete cascade
) engine = innodb;

insert into Employees(surname, given_name, date_of_employment, department_id)
    values("Ang","Anthony","2000-01-31", 1),
    ("Beh", "Beth", "2001-12-31", 2),
    ("Chew", "Caroline", "2002-02-22",3),
    ("Davis", "Douglas", "2003-03-13", 4);

insert into Employees(surname, given_name, date_of_employment, department_id)
    values("Eng","Edward","2004-04-24", 1),
    ("Fang", "Fang Fang", "2005-05-25", 2),
    ("Goh", "Goodfrey", "2006-06-26",3),
    ("Ho", "Heng Hwee", "2007-07-17", 4);

-- Create Addresses Table
-- Reference employee_id
create table Addresses (
    address_id smallint unsigned auto_increment primary key,
    blk_number varchar(20) not null,
    street varchar(100) not null,
    unit_code varchar(20) not null,
    postal_code varchar(7) not null,
    employee_id smallint unsigned, 
    foreign key (employee_id) references Employees(employee_id) on delete cascade
) engine = innodb;

insert into Addresses(blk_number, street,unit_code,postal_code,employee_id)
    values("10","Ang Mo Kio St 4","#10-01","823010", 1),
    ("223","Bedok Ave 2","#12-2201","731223", 2),
    ("832","Clementi St 7","#03-301","182832", 3),
    ("441","Delta Road","#14-421","504441", 4);


-- Create Employee_Taskforce table
-- Reference employee_id and taskforce_id
create table Employee_Taskforces(
    employee_taskforce_id smallint unsigned auto_increment primary key, 
    taskforce_id tinyint unsigned,
    employee_id smallint unsigned,
    role varchar(100) not null,
    foreign key (employee_id) references Employees(employee_id) on delete cascade,
    foreign key (taskforce_id) references Taskforces(taskforce_id) on delete cascade
) engine=innodb;

insert into Employee_Taskforces(taskforce_id,employee_id,role)
    values(2,1,"Main IC"),
    (2,2,"Secondary IC"),
    (3,1,"Main IC"),
    (1,4,"Main IC"),
    (1,3, "Safety Officier"),
    (1,1, "Drill instructor");