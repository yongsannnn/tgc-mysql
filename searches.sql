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