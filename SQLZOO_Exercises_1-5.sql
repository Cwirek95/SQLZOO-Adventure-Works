/*
SQLZOO Exercises
https://sqlzoo.net/wiki/AdventureWorks
*/

-- Exercises 1-5

/*
Exercise 1
Show the first name and the email address of customer with CompanyName 'Bike World'.
*/
SELECT 
	customer.FirstName, 
	customer.EmailAddress
FROM Customer customer
WHERE customer.CompanyName = 'Bike World';


/*
Exercise 2
Show the CompanyName for all customers with an address in City 'Dallas'.
*/
SELECT 
	customer.CompanyName
FROM Customer customer
INNER JOIN CustomerAddress customerAddress ON customerAddress.CustomerID = customer.CustomerID
INNER JOIN Address address ON address.AddressID = customerAddress.AddressID
WHERE address.City = 'Dallas';


/*
Exercise 3
How many items with ListPrice more than $1000 have been sold?
*/
SELECT
	COUNT(*) AS 'Sold Items'
FROM Product product
INNER JOIN SalesOrderDetail orderDetail ON orderDetail.ProductID = product.ProductID
WHERE product.ListPrice > 1000;


/*
Exercise 4
Give the CompanyName of those customers with orders over $100000. Include the subtotal plus tax plus freight.
*/
SELECT DISTINCT
	customer.CompanyName
FROM Customer customer
INNER JOIN SalesOrderHeader orderHeader ON orderHeader.CustomerID = customer.CustomerID
WHERE (orderHeader.SubTotal + orderHeader.TaxAmt + orderHeader.Freight) > 100000


/*
Exercise 5
Find the number of left racing socks ('Racing Socks, L') ordered by CompanyName 'Riding Cycles'
*/
SELECT
	COUNT(*) AS 'Count'
FROM Product product
INNER JOIN SalesOrderDetail orderDetail ON orderDetail.ProductID = product.ProductID
INNER JOIN SalesOrderHeader orderHeader ON orderHeader.SalesOrderID = orderDetail.SalesOrderID
INNER JOIN Customer customer ON customer.CustomerID = orderHeader.CustomerID
WHERE customer.CompanyName = 'Riding Cycles' AND product.Name = 'Racing Socks, L';