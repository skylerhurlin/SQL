/* NOTES: This is a homework assignment for the third course in my Database Design & SQL certificate, using MSSQL and SalesDB. My codes all ran properly and I recieved an A on the assignment. */

PRINT '================================================================================' + CHAR(10)
    + 'CIS276 Lab1' + CHAR(10)
    + '================================================================================' + CHAR(10)
GO


USE SalesDB;
GO


PRINT '1. Who earns less than or equal to $2,500?' + CHAR(10)

SELECT		Ename AS 'Salesperson', Salary AS 'Salary'
FROM		SALESPERSONS
WHERE		Salary <= 2500
ORDER BY	Salary DESC;

GO


PRINT '================================================================================' + CHAR(10)
PRINT '2. Which parts cost between one and fifteen dollars (inclusive)?' + CHAR(10)


SELECT		PartID, Description, Price
FROM		INVENTORY
WHERE		Price BETWEEN 1 AND 15
ORDER BY	Price DESC;

GO


PRINT '================================================================================' + CHAR(10)
PRINT '3. What is the highest Priced part? What is the lowest Priced part?' + CHAR(10)


SELECT		PartID, Description, Price
FROM		INVENTORY
WHERE		Price IN (
	(SELECT		MAX(Price)
	FROM		INVENTORY),
	(SELECT		MIN(Price)
	FROM		INVENTORY)
	);
GO


PRINT '================================================================================' + CHAR(10)
PRINT '4. Which part Descriptions begin with the letter T?' + CHAR(10)

SELECT		PartID, Description
FROM		INVENTORY
WHERE		Description LIKE 't%'
OR			Description LIKE 'T%'
ORDER BY	Price DESC;
GO


PRINT '================================================================================' + CHAR(10)
PRINT '5. Which parts need to be ordered from our supplier?' + CHAR(10)

SELECT		PartID, Description, (ReorderPnt - StockQty) AS 'Inv. Needed'
FROM		INVENTORY
WHERE		StockQty < ReorderPnt
ORDER BY	'Inv. Needed' DESC;

GO


PRINT '================================================================================' + CHAR(10)
PRINT '6. Which sales people have NOT sold anything? Subquery version.' + CHAR(10)

SELECT		Ename AS 'Salesperson'
FROM		SALESPERSONS
WHERE		EmpID NOT IN (
	SELECT		EmpID
	FROM		ORDERS
	)
ORDER BY	Ename;

SELECT		Ename AS 'Salesperson'
FROM		SALESPERSONS
WHERE		NOT EXISTS  (
	SELECT		EmpID
	FROM		ORDERS
	WHERE		SALESPERSONS.EmpID = ORDERS.EmpID
	)
ORDER BY	Ename;

GO


PRINT '================================================================================' + CHAR(10)
PRINT '7. Which sales people have NOT sold anything? JOIN version (explicit or named JOIN).' + CHAR(10)

SELECT		Ename AS 'Salesperson'
FROM		SALESPERSONS
LEFT JOIN	ORDERS ON SALESPERSONS.EmpID = ORDERS.EmpID
WHERE		ORDERS.EmpID IS NULL
ORDER BY	Ename;

GO


PRINT '================================================================================' + CHAR(10)
PRINT '8. Who placed the most orders?' + CHAR(10)

SELECT		TOP 1 CUSTOMERS.CustID, CUSTOMERS.Cname AS 'Name', COUNT(DISTINCT ORDERS.OrderID) AS '# of Orders'
FROM		CUSTOMERS
JOIN		ORDERS ON ORDERS.CustID = CUSTOMERS.CustID
GROUP BY	CUSTOMERS.CustID, CUSTOMERS.Cname
ORDER BY	'# of Orders' DESC;

GO


PRINT '================================================================================' + CHAR(10)
PRINT '9. Who ordered the most quantity?' + CHAR(10)

SELECT		TOP 1 CUSTOMERS.CustID, CUSTOMERS.Cname AS 'Name', SUM(ORDERITEMS.Qty) as 'Total Qty'
FROM		CUSTOMERS
JOIN		ORDERS ON ORDERS.CustID = CUSTOMERS.CustID
JOIN		ORDERITEMS ON ORDERITEMS.OrderID = ORDERS.OrderID
GROUP BY	CUSTOMERS.CustID, CUSTOMERS.Cname
ORDER BY	'Total Qty' DESC;

GO


PRINT '================================================================================' + CHAR(10)
PRINT '10. Who ordered the highest total value?' + CHAR(10)

SELECT		TOP 1 CUSTOMERS.CustID, CUSTOMERS.Cname AS 'Name', SUM(INVENTORY.Price * ORDERITEMS.Qty) as 'Total Value'
FROM		CUSTOMERS
JOIN		ORDERS ON ORDERS.CustID = CUSTOMERS.CustID
JOIN		ORDERITEMS ON ORDERITEMS.OrderID = ORDERS.OrderID
JOIN		INVENTORY ON INVENTORY.PartID = ORDERITEMS.PartID
GROUP BY	CUSTOMERS.CustID, CUSTOMERS.Cname
ORDER BY	'Total Value' DESC;

GO


--------------------------------------------------------------------------------
-- Program block
--------------------------------------------------------------------------------
DECLARE @v_now DATETIME;
BEGIN
    SET @v_now = GETDATE();
    PRINT '================================================================================'
    PRINT 'End of CIS276 Lab1';
    PRINT @v_now;
    PRINT '================================================================================';
END;
