-- Setting up
-- mysql -u root < chinook.sql

-- 1 - Display all Sales Support Agents with their first name and last name
SELECT FirstName, LastName, Title FROM Employee
WHERE Title = "Sales Support Agent";

-- 2 - Display all employees hired between 2002 and 2003, 
-- and display their first name and last name

SELECT FirstName, LastName, HireDate FROM Employee
WHERE HireDate >= "2002-01-01" AND HireDate <= "2003-12-31";

-- 3 - Display all artists that have the word 'Metal' in their name
SELECT * FROM Artist
WHERE Name like "%Metal%";  

-- 4 - Display all employees which are in sales (sales manager, sales rep etc.)
SELECT FirstName, LastName, Title FROM Employee
WHERE Title like "%Sales%";

-- 5 - Display the titles of all tracks which has the genre "easy listening"
SELECT Track.Name, Genre.Name 
FROM Track 
JOIN Genre 
on Track.GenreId = Genre.GenreId
WHERE Genre.Name = "Easy Listening";


-- 6 - Display all the tracks from all albums along with the genre of each track
SELECT Album.Title, Track.Name, Track.GenreId FROM Album
JOIN Track
on Album.AlbumId = Track.AlbumId;



-- 7 - Using the Invoice table, show the average payment made for each country
SELECT BillingCountry, AVG(Total) FROM Invoice
GROUP BY BillingCountry;


-- 8 - Using the Invoice table, show the average payment made for each country, but only for countries that paid more than 1,000 in total
SELECT BillingCountry, SUM(Total), AVG(Total) FROM Invoice
GROUP BY BillingCountry
HAVING SUM(Total) >= "100";

-- 9 - Using the Invoice table, show the average payment made for each customer, but only for customer reside in Germany and only if that customer has paid more than 100 in total
SELECT Invoice.CustomerId, AVG(Invoice.Total), SUM(Invoice.Total), Customer.Country FROM Invoice
JOIN Customer
on Invoice.CustomerId = Customer.CustomerId
WHERE Customer.Country = "Germany"
GROUP BY Invoice.CustomerId, Customer.Country
HAVING SUM(Invoice.Total) > "10"

-- 10 - Display the average length of Jazz song (that is, the genre of the song is Jazz) for each album
SELECT Album.AlbumId, Album.Title, AVG(Track.Milliseconds) from Album
JOIN Track 
on Album.AlbumId = Track.AlbumId
WHERE Track.GenreId = "2"
GROUP BY Album.AlbumId

SELECT Album.AlbumId, Album.Title, AVG(Track.Milliseconds) from Album
JOIN Track on Album.AlbumId = Track.AlbumId
JOIN Genre on Track.GenreId = Genre.GenreId
WHERE Genre.Name = "Jazz"
GROUP BY Album.AlbumId, Album.Title;