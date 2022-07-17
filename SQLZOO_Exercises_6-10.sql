/*
SQLZOO Exercises
https://sqlzoo.net/wiki/AdventureWorks
*/

-- Exercises 6-10

/*
Exercise 6
A "Single Item Order" is a customer order where only one item is ordered. Show the SalesOrderID and the UnitPrice for every Single Item Order.
*/
SELECT
	orderDetail.SalesOrderID,
	orderDetail.UnitPrice
FROM SalesOrderDetail orderDetail
GROUP BY orderDetail.SalesOrderID, orderDetail.UnitPrice
HAVING SUM(orderDetail.OrderQty) = 1


/*
Exercise 7
Where did the racing socks go? List the product name and the CompanyName for all Customers who ordered ProductModel 'Racing Socks'.
*/
SELECT 
	product.Name AS 'Product Name',
	customer.CompanyName
FROM Product product
INNER JOIN ProductModel productModel ON productModel.ProductModelID = product.ProductModelID
INNER JOIN SalesOrderDetail orderDetail ON orderDetail.ProductID = product.ProductID
INNER JOIN SalesOrderHeader orderHeader ON orderHeader.SalesOrderID = orderDetail.SalesOrderID
INNER JOIN Customer customer ON customer.CustomerID = orderHeader.CustomerID
WHERE productModel.name = 'Racing Socks'


/*
Exercise 8
Show the product description for culture 'fr' for product with ProductID 736.
*/
SELECT
	productDesc.Description AS 'Product Description'
FROM ProductDescription productDesc
INNER JOIN ProductModelProductDescription modelProductDesc ON modelProductDesc.ProductDescriptionID = productDesc.ProductDescriptionID
INNER JOIN ProductModel productModel ON productModel.ProductModelID = modelProductDesc.ProductModelID
INNER JOIN Product product ON product.ProductModelID = productModel.ProductModelID
WHERE product.ProductID = 736 AND modelProductDesc.Culture = 'fr';


/*
Exercise 9
Use the SubTotal value in SaleOrderHeader to list orders from the largest to the smallest.
For each order show the CompanyName and the SubTotal and the total weight of the order.
*/
SELECT 
	orderHeader.SubTotal,
	customer.CompanyName,
	SUM(COALESCE(product.Weight, 0)) AS 'Total weight'
FROM SalesOrderHeader orderHeader
INNER JOIN Customer customer ON customer.CustomerID = orderHeader.CustomerID
INNER JOIN SalesOrderDetail orderDetail ON orderDetail.SalesOrderID = orderHeader.SalesOrderID
INNER JOIN Product product ON product.ProductID = orderDetail.ProductID
GROUP BY orderHeader.SubTotal, customer.CompanyName
ORDER BY orderHeader.SubTotal DESC;


/*
Exercise 10
How many products in ProductCategory 'Cranksets' have been sold to an address in 'London'?
*/
SELECT
	SUM(orderDetail.OrderQty) AS 'Count'
FROM Product product
INNER JOIN ProductCategory productCategory ON productCategory.ProductCategoryID = product.ProductCategoryID
INNER JOIN SalesOrderDetail orderDetail ON orderDetail.ProductID = product.ProductID
INNER JOIN SalesOrderHeader orderHeader ON orderHeader.SalesOrderID = orderDetail.SalesOrderID
INNER JOIN Address address ON address.AddressID = orderHeader.ShipToAddressID
WHERE productCategory.Name = 'Cranksets' AND address.City = 'London';