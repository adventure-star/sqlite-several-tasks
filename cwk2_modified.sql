/*
This is the template SQL file for the queries for cousework2 (SQL). 
Please write all your SQL codes in this file and submit this file to Minerva
*/

/* ==============================================
   WARNNIG: DO NOT REMOVE THE CODES BELOW 
   Dropping existing tables and views if exists
   ==============================================
*/
DROP TABLE IF EXISTS TopImport;
DROP VIEW IF EXISTS vSales;
DROP VIEW IF EXISTS vLoyalCustomer;
DROP VIEW IF EXISTS vCustomerMissingDetails;
DROP VIEW IF EXISTS vTopRegionCustomer;
DROP VIEW IF EXISTS vTop10Products;

/*
======================
Question 1
======================
Question 1(a)
*/
CREATE TABLE TopImport (Id INTEGER PRIMARY KEY, Country VARCHAR (100), TotalImport REAL, ProductCategory INTEGER, CategoryName VARCHAR (100));

/*
Question 1(b)
*/
INSERT INTO TopImport VALUES (1, 'Germany', 18224.6, 1, 'Beverages');
INSERT INTO TopImport VALUES (2, 'Germany', 1082.885, 2, 'Condiments');
INSERT INTO TopImport VALUES (3, 'Germany', 19596.3825, 3, 'Condiments');
/*
Question 1(c)
*/
UPDATE TopImport SET CategoryName ='Confections' WHERE Id = 3;

/*
Question 1(d)
*/
DELETE FROM TopImport WHERE Id= 2;


/*
======================
Question 2
======================
Question 2(a)
*/

/*
Question 2(b)
*/



/*
======================
Question 3
======================
Question 3(a)
*/
CREATE VIEW vSales AS SELECT
	OrderDetailModified.ProductId,
	ProductName,
	CompanyName,
	TotalSales,
	UnitPrice
FROM
	(
		SELECT
			Product.Id AS ProductId,
			ProductName,
			CompanyName,
			UnitPrice
		FROM
			Product
		INNER JOIN Supplier ON Product.SupplierId = Supplier.Id
	) AS ProductSupplier
INNER JOIN (
	SELECT
		ProductId,
		sum(Quantity) AS TotalSales
	FROM
		OrderDetail
	GROUP BY
		ProductId
) AS OrderDetailModified
WHERE
	ProductSupplier.ProductId = OrderDetailModified.ProductId;
/*
Question 3(b)
*/
CREATE VIEW vTop10Products AS SELECT
	*
FROM
	vSales
ORDER BY
	TotalSales DESC
LIMIT 10;
/*
======================
Question 4
======================
Question 4(a)
*/
CREATE VIEW vLoyalCustomer AS SELECT
	TotalOrder,
	Customer.Id AS CustomerId,
	CompanyName,
	Region
FROM
	Customer
INNER JOIN (
	SELECT
		CustomerId,
		count(CustomerId) AS TotalOrder
	FROM
		'Order'
	GROUP BY
		CustomerId
) AS OrderModified ON Customer.Id = OrderModified.CustomerId;
/*
Question 4(b)
*/
CREATE VIEW vCustomerMissingDetails AS SELECT DISTINCT
	"Order".CustomerId
FROM
	"Order"
LEFT JOIN Customer ON "Order".CustomerId = Customer.Id
WHERE
	Customer.Id IS NULL;
/*
Question 4(c)
*/
CREATE VIEW vTopRegionCustomer AS SELECT
	max(TotalOrder),
	CustomerId,
	CompanyName,
	Region
FROM
	vLoyalCustomer
GROUP BY
	Region;