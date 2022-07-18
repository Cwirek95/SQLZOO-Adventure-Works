/*
SQLZOO Exercises
https://sqlzoo.net/wiki/AdventureWorks
*/

-- Exercises 11-15

/*
Exercise 11
For every customer with a 'Main Office' in Dallas show AddressLine1 of the 'Main Office' and AddressLine1 of the 'Shipping' address - if there is no shipping address leave it blank.
Use one row per customer.
*/
SELECT 
	mainOffice.CustomerID, 
	mainOffice.MainOffice, 
	shipping.Shipping
FROM
(SELECT 
	customer.CustomerID, 
	address.AddressLine1 AS 'MainOffice'
FROM Customer customer 
INNER JOIN CustomerAddress customerAddress ON customer.CustomerID = customerAddress.CustomerID
INNER JOIN Address address ON customerAddress.AddressID = address.AddressID
WHERE customerAddress.AddressType = 'Main Office' AND address.City = 'Dallas') AS mainOffice
LEFT JOIN
(SELECT
	customer.CustomerID,
	address.AddressLine1 AS 'Shipping'
FROM Customer customer 
INNER JOIN CustomerAddress customerAddress ON customer.CustomerID = customerAddress.CustomerID
INNER JOIN Address address ON customerAddress.AddressID = address.AddressID
WHERE customerAddress.AddressType = 'Shipping') AS shipping
ON mainOffice.CustomerID = shipping.CustomerID;


/*
Exercise 12
For each order show the SalesOrderID and SubTotal calculated three ways:
A) From the SalesOrderHeader
B) Sum of OrderQty*UnitPrice
C) Sum of OrderQty*ListPrice
*/
-- A)
SELECT
	orderHeader.SalesOrderID,
	orderHeader.SubTotal
FROM SalesOrderHeader orderHeader;

-- B)
SELECT
	orderDetail.SalesOrderID,
	SUM(orderDetail.OrderQty * orderDetail.UnitPrice) AS 'SubTotal'
FROM SalesOrderDetail orderDetail
GROUP BY orderDetail.SalesOrderID;

-- C)
SELECT
	orderDetail.SalesOrderID,
	SUM(orderDetail.OrderQty * product.ListPrice) AS 'SubTotal'
FROM SalesOrderDetail orderDetail
INNER JOIN Product product ON product.ProductID = orderDetail.ProductID
GROUP BY orderDetail.SalesOrderID;

/*
Exercise 13
Show the best selling item by value.
*/
SELECT TOP 1
	product.ProductID,
	product.Name,
	SUM((orderDetail.UnitPrice - orderDetail.UnitPriceDiscount) * OrderQty) AS 'Value'
FROM Product product
INNER JOIN SalesOrderDetail orderDetail ON orderDetail.ProductID = product.ProductID
GROUP BY product.ProductID, product.Name
ORDER BY 'Value' DESC;


/*
Exercise 14
Show how many orders are in the following ranges (in $):

    RANGE      Num Orders      Total Value
    0-  99
  100- 999
 1000-9999
10000-
*/
WITH orderTemp AS (
  SELECT 
	orderDetail.SalesOrderID, 
	SUM(orderDetail.OrderQty * orderDetail.UnitPrice) AS orderTotal
  FROM SalesOrderDetail orderDetail
  GROUP BY orderDetail.SalesOrderID
), 
rangeTemp AS (
  SELECT 
  orderTemp.SalesOrderID, 
  orderTemp.orderTotal, 
  CASE
    WHEN orderTotal BETWEEN 0 AND 99 THEN '0-99'
    WHEN orderTotal BETWEEN 100 AND 999 THEN '100-999'
    WHEN orderTotal BETWEEN 1000 AND 9999 THEN '1000-9999'
    WHEN orderTotal >= 10000 THEN '10000-'
  END AS rng
  FROM orderTemp
)
SELECT 
	rng AS 'RANGE', 
	COUNT(rng) AS 'Num Orders', 
	SUM(orderTotal) AS 'Total Value'
FROM rangeTemp
GROUP BY rng;



/*
Exercise 15
Identify the three most important cities. Show the break down of top level product category against city.
*/
SELECT TOP 3 
	address.City,
	SUM(orderDetail.OrderQty * (orderDetail.UnitPrice - orderDetail.UnitPriceDiscount)) AS 'Total Value'
FROM ProductCategory category 
INNER JOIN Product product ON product.ProductCategoryID = category.ProductCategoryID
INNER JOIN SalesOrderDetail orderDetail ON orderDetail.ProductID = product.ProductID
INNER JOIN SalesOrderHeader orderHeader ON orderHeader.SalesOrderID = orderDetail.SalesOrderID
INNER JOIN Address address ON address.AddressID = orderHeader.ShipToAddressID
GROUP BY address.City
ORDER BY 'Total Value' DESC;