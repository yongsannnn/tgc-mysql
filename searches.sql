-- Filtering
-- https://www.mysqltutorial.org/tryit/
select employeeNumber, email from table

-- Condition
select firstName,lastName,email from employees where officeCode = 1;

-- Show all employees from sales department
select firstName,lastName,email from employees where jobTitle = "Sales Rep";

-- Show all substrings
-- % is a wild card, front or back matters 
select * from employees where jobTitle like "%sales%";


-- How to search with two condition
-- use and, can go as many as you want
select * from employees where officeCode = 1 and jobTitle = "Sales Rep";

-- there is also an OR
select * from employees where officeCode = 1 or officeCode = 4;

-- Find all employees not from office code 1 or 4
select * from employees where officeCode != 1 and officeCode != 4;
--Can use the NOT IN to exclude or IN to include
select * from employees where officeCode not in (1,4);

-- Find all employees from office code 4 and all sales rep from office code 1
select * from employees where officeCode = 4 or officeCode = 1 and jobTitle = "Sales Rep"

-- find all customer from either france or usa
select * from customers where country = "France"  or country= "USA";



-- JOINING
-- Join will happen first, select will happen NEXT
-- join the employees office code with the offices address
SELECT firstName, lastName, state,city,addressLine1,addressLine2 
	FROM employees join offices on employees.officeCode = offices.officeCode

-- Want those that are Sales Rep
-- JOIN first, WHERE next, SELECT last
SELECT firstName, lastName, jobTitle,state,city,addressLine1,addressLine2 
	FROM employees join offices on employees.officeCode = offices.officeCode 
	where jobTitle = "Sales Rep"

-- Multiple JOIN
-- Becareful of ambiguous variable just use "office.city" like how we use object.
SELECT customerName, firstName, lastName, offices.city FROM customers join employees
on customers.salesRepEmployeeNumber = employees.employeeNumber
join offices
on employees.officeCode = offices.officeCode

-- Show cus name, sales rep name, city of sales rep, but only customer 
-- from usa or france sorted by the customer name in descending order 
-- and limit to 3 entry
select customers.customerName, employees.firstName, employees.lastName, offices.city
from customers join employees
on customers.salesRepEmployeeNumber = employees.employeeNumber
join offices
on employees.officeCode = offices.officeCode
where customers.country = "France" or customers.country = "USA"
order by customers.customerNumber desc 
limit 3;


-- Show all orders on the dates 
select * from orders where orderDate = "2003-01-06"

-- Show all the orders made before the date
select * from orders where orderDate < "2003-07-16"

-- Seperate the year month and day
select orderNumber, YEAR(orderDate), MONTH(orderDate), DAY(orderDate) from orders;

-- Show all transaction within the year 2003
select orderNumber, orderDate from orders where year(orderDate) = 2003

-- Show all transaction withiin the year 2003 and in month of feb
select orderNumber, orderDate from orders where year(orderDate) = 2003 and month(orderDate) = 2

-- See current time in sever
select now()

-- See current date in sever
select CURDATE()

-- Find all the orders that are required to ship in 3 days time
select * from orders where requiredDate - CURDATE() = 3;


-- Aggregating (Reducing)
-- Count all entries in orders
select count(*) from orders;

-- Adding up all entries from a specific column
SELECT sum(creditLimit) FROM customers;

-- Show average creditLimit for all customers
SELECT avg(creditLimit) FROM customers;

-- Show Max 
SELECT max(creditLimit) FROM customers where country="USA"

-- Show Min
SELECT min(creditLimit) FROM customers where country="USA"

-- Show country where have customers
SELECT distinct(country) FROM customers;

-- Show country and calculate average credit limit of each countries'
SELECT country, avg(creditLimit) FROM customers group by country;

-- Count how many employee are there in each of the office code
select offices.officeCode, city, count(*) AS "employee_count" from employees
join offices on employees.officeCode = offices.officeCode
group by officeCode,city

-- select offices.officeCode, city, count(*) AS "employee_count" from employees
join offices on employees.officeCode = offices.officeCode
group by officeCode,city

-- Count how many employee are there in each of the office code where their job title is "Sales Rep"
select offices.officeCode, city, count(*) AS "employee_count" from employees
join offices on employees.officeCode = offices.officeCode
where jobTitle = "Sales Rep"
group by officeCode,city

-- Count same as above but have more than two
select offices.officeCode, city, count(*) AS "employee_count" from employees
join offices on employees.officeCode = offices.officeCode
where jobTitle = "Sales Rep"
group by officeCode,city
having count(*) > 2

-- Count same as above, and make it ascending order
select offices.officeCode, city, count(*) AS "employee_count" from employees
join offices on employees.officeCode = offices.officeCode
where jobTitle = "Sales Rep"
group by officeCode,city
having count(*) > 2
order by count(*)


-- SUB QUERY
-- Using (), it will always go first and return a number or an array
-- You will need a sub query when you need a variable that needs to be derived. 

-- For each customer, get their average credit limit
-- but only show the customer whose average credit limit is higher than average credit limit of all the customers
SELECT customerNumber,
         creditLimit
FROM customers
HAVING AVG(creditLimit) > ????
-- ???? is the result of another table.

SELECT customerNumber,
         creditLimit
FROM customers
HAVING AVG(creditLimit) > (SELECT AVG(creditLimit) from customers)


-- Show the products that has not beed sold before
SELECT *
FROM products
WHERE productCode NOT IN 
    (SELECT productCode
    FROM orderdetails)
