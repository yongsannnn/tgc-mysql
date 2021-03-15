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

-- MySQL Select hands-on
-- 1 - Find all the offices and display only their city, phone and country
SELECT city,phone,country FROM offices;

-- 2 - Find all rows in the orders table that mentions FedEx in the comments.
select * from orders where comments like "%FedEx%"

-- 3 - Display all the orders bought by the customer with the customer number 124, along with the customer name, the contact's first name and contact's last name.
SELECT orders.*, customers.customerName, customers.contactLastName, customers.contactFirstName
FROM orders
JOIN customers
on orders.customerNumber = customers.customerNumber
WHERE orders.customerNumber = 124;

-- 4 - Show the contact first name and contact last name of all customers in descending order by the customer's name
SELECT contactFirstName,
         contactLastName
FROM customers
ORDER BY  customerName desc;

-- 5 - Find all sales rep who are in office code 1, 2 or 3 and their first name or last name contains the substring 'son'
SELECT *
FROM employees
WHERE jobTitle = "Sales Rep"
        AND (officeCode = 1
        OR officeCode = 2
        OR officeCode = 3)
        AND (firstName LIKE "%son%"
        OR lastName LIKE "%son%");

-- alternate
SELECT *
FROM employees
WHERE jobTitle = "Sales Rep"
        AND (officeCode in(1,2,3))
        AND (firstName LIKE "%son%"
        OR lastName LIKE "%son%");

-- 6 - Show the name of the product, together with the order details,  
-- for each order line from the orderdetails table
SELECT products.productName,
         orderdetails.*
FROM orderdetails
JOIN products
    ON orderdetails.productCode = products.productCode;

-- 7 - Show how many employees are there for each state in the USA	
SELECT state,
         count(*)
FROM employees
JOIN offices
    ON employees.officeCode = offices.officeCode
GROUP BY  state


-- 8 - From the payments table, display the average amount spent by each customer. 
-- Display the name of the customer as well.
SELECT customerNumber,
         avg(amount)
FROM payments
GROUP BY  amount;

-- 9 - From the payments table, display the average amount spent by each customer 
-- but only if the customer has spent a minimum of 10,000 dollars.
SELECT customerNumber,
         avg(amount)
FROM payments
GROUP BY  amount
HAVING avg(amount)>10000;

-- 10  - For each product, display how many times it was ordered, 
-- and display the results with the most orders first and only show the top ten.
SELECT *,
        count(*)
FROM orderdetails
JOIN products
    ON orderdetails.productCode = products.productCode
GROUP BY  productName desc
limit 10;

-- 11 - Display all orders made between Jan 2003 and Dec 2003
SELECT * FROM orders where year(orderDate) = 2003;

-- 12 - Display all the number of orders made, per month, between Jan 2003 and 
-- Dec 2003
SELECT month(orderDate),
        count(*)
FROM orders
WHERE year(orderDate) = 2003
GROUP BY  month(orderDate);