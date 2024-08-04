/* NOTES: This is a homework assignment for the third course in my Database Design & SQL certificate, using MSSQL and SalesDB. My codes all ran properly and I recieved an A on the assignment. */

USE SalesDB
GO


PRINT '1. What is the dollar total for each of the salespeople?' + CHAR(10) 
PRINT 'Calculate totals for all salespeople (even if they have no sales). Columns to display: SALESPERSONS.EmpID, SALESPERSONS.Ename, SUM(ORDERITEMS.Qty*INVENTORY.Price)' + CHAR(10)


SELECT			SALESPERSONS.EmpID, SALESPERSONS.Ename AS 'Salesperson',
				CONCAT('$', ISNULL(SUM(ORDERITEMS.Qty*INVENTORY.Price),0)) AS 'Total Dollar Value'
FROM			SALESPERSONS
LEFT OUTER JOIN		ORDERS ON SALESPERSONS.EmpID = ORDERS.EmpID
LEFT OUTER JOIN		ORDERITEMS ON ORDERS.OrderID = ORDERITEMS.OrderID
LEFT OUTER JOIN		INVENTORY ON ORDERITEMS.PartID = INVENTORY.PartID
GROUP BY		SALESPERSONS.EmpID, SALESPERSONS.Ename
ORDER BY		SUM(ORDERITEMS.Qty*INVENTORY.Price) DESC;

GO


PRINT '================================================================================' + CHAR(10)
PRINT '2. What is the $$ value of each of the orders?' + CHAR(10) 

SELECT		ORDERS.OrderID, CONCAT('$',ISNULL(SUM(ORDERITEMS.Qty*INVENTORY.Price),0)) AS 'Dollar Value'
FROM		ORDERS
JOIN		ORDERITEMS ON ORDERS.OrderID = ORDERITEMS.OrderID
JOIN		INVENTORY ON ORDERITEMS.PartID = INVENTORY.PartID
GROUP BY	ORDERS.OrderID
ORDER BY	SUM(ORDERITEMS.Qty*INVENTORY.Price) DESC;

GO


PRINT '================================================================================' + CHAR(10)
PRINT '3. Which orders contain widgets?' + CHAR(10)
PRINT 'The word ''widget'' may not be the only word in the part''s description (use a wildcard).
Display the orders where a ''widget'' part appears in at least one ORDERITEMS rows for the order.
List in sales date sequence with the newest first. 
Do not use the EXISTS clause.' + CHAR(10)


SELECT		ORDERS.OrderID, ORDERS.SalesDate
FROM		ORDERS
JOIN		ORDERITEMS ON ORDERS.OrderID = ORDERITEMS.OrderID
JOIN		INVENTORY ON ORDERITEMS.PartID = INVENTORY.PartID
WHERE		INVENTORY.Description LIKE '%widget%'
ORDER BY	ORDERS.SalesDate DESC;

GO


PRINT '================================================================================' + CHAR(10)
PRINT '4. Which orders contain widgets?' + CHAR(10)
PRINT 'Same as above, but use the EXISTS clause.' + CHAR(10)

SELECT		ORDERS.OrderID, ORDERS.SalesDate
FROM		ORDERS
WHERE		EXISTS (
	SELECT		OrderID
	FROM		ORDERITEMS
	WHERE		ORDERS.OrderID = ORDERITEMS.OrderID
	AND			EXISTS (
		SELECT		PartID
		FROM		INVENTORY
		WHERE		ORDERITEMS.PartID = INVENTORY.PartID
		AND			INVENTORY.Description LIKE '%widget%'
		)
	)
ORDER BY	ORDERS.SalesDate DESC;
	

GO


PRINT '================================================================================' + CHAR(10)
PRINT '5. What are the gadget and gizmo only orders? i.e. which orders contain at least one gadget and at least one gizmo, but no other parts?' + CHAR(10)

SELECT		OrderID
FROM		ORDERS
WHERE		OrderID IN (
	SELECT		OrderID
	FROM		ORDERITEMS
	WHERE		PartID IN (
		SELECT		PartID
		FROM		INVENTORY
		WHERE		Description LIKE '%gadget%'
		)
	)
AND			OrderID IN (
	SELECT		OrderID
	FROM		ORDERITEMS
	WHERE		PartID IN (
		SELECT		PartID
		FROM		INVENTORY
		WHERE		Description LIKE '%gizmo%'
		)
	)
AND			OrderID NOT IN (
	SELECT		OrderID
	FROM		ORDERITEMS
	WHERE		PartID IN (
		SELECT		PartID
		FROM		INVENTORY
		WHERE		Description NOT LIKE '%gadget%'
		AND		Description NOT LIKE '%gizmo%'
		)
	)
ORDER BY	OrderID;

GO


PRINT '================================================================================' + CHAR(10)
PRINT '6. Who are our profit-less customers? (ie. customers who have placed no orders.) Use EXISTS.' + CHAR(10)

SELECT		CUSTOMERS.CustID, CUSTOMERS.Cname AS 'Name'
FROM		CUSTOMERS
WHERE		NOT EXISTS  (
	SELECT		CustID
	FROM		ORDERS
	WHERE		CUSTOMERS.CustID = ORDERS.CustID
	)
ORDER BY	Cname;
GO


PRINT '================================================================================' + CHAR(10)
PRINT '7. What is the average $$ value of an order?' + CHAR(10)
PRINT 'To get the answer, you need to add up all the order values (see #2, above) and divide this by the number of orders. 
There are two possible averages on this question, because not all of the order numbers in the ORDERS table are in the ORDERITEMS table...
You will calculate and display both averages.' + CHAR(10)

SELECT			CONCAT('$',SUM(ORDERITEMS.Qty*INVENTORY.Price) / COUNT(DISTINCT ORDERS.OrderID)) AS 'Orders Average',
				CONCAT('$',SUM(ORDERITEMS.Qty*INVENTORY.Price) / COUNT(DISTINCT ORDERITEMS.OrderID)) AS 'OrderItems Average'
FROM			ORDERS
LEFT OUTER JOIN		ORDERITEMS ON ORDERS.OrderID = ORDERITEMS.OrderID
LEFT OUTER JOIN		INVENTORY ON ORDERITEMS.PartID = INVENTORY.PartID;

GO


PRINT '================================================================================' + CHAR(10)
PRINT '8. Who is our most profitable salesperson?' + CHAR(10)
PRINT 'A salesperson''s profit (or loss) is the difference between what the person sold and what the person earns.' + CHAR(10)

SELECT			TOP 1 WITH TIES SALESPERSONS.EmpID, SALESPERSONS.Ename AS 'Name',
				CONCAT('$', ISNULL((SUM(ORDERITEMS.Qty*INVENTORY.Price) - SALESPERSONS.Salary),0)) AS 'Profit/Loss'
FROM			SALESPERSONS
LEFT OUTER JOIN		ORDERS ON SALESPERSONS.EmpID = ORDERS.EmpID
LEFT OUTER JOIN		ORDERITEMS ON ORDERS.OrderID = ORDERITEMS.OrderID
LEFT OUTER JOIN		INVENTORY ON ORDERITEMS.PartID = INVENTORY.PartID
GROUP BY		SALESPERSONS.Salary, SALESPERSONS.EmpID, SALESPERSONS.Ename
ORDER BY		ISNULL((SUM(ORDERITEMS.Qty*INVENTORY.Price) - SALESPERSONS.Salary),0) DESC;


GO


PRINT '================================================================================' + CHAR(10)
PRINT '9. Who is our second-most profitable salesperson?' + CHAR(10)
PRINT 'Do not hard-code the results of #2 above into this query - that simply creates a data-dependent query.
See if you can do this without using the SQL Server keyword TOP or TOP WITH TIES.' + CHAR(10)


SELECT			PR_1.EmpID, PR_1.Ename AS Name, 
				CONCAT('$', ISNULL((SUM(ORDERITEMS.Qty*INVENTORY.Price) - PR_1.Salary),0)) AS 'Profit/Loss'
FROM				
	(SELECT			SP_2.Salary, SP_2.EmpID, SP_2.Ename,
					DENSE_RANK() OVER(ORDER BY (ISNULL((SUM(OI_2.Qty*I_2.Price) - SP_2.Salary),0)) DESC) AS PR
	FROM			SALESPERSONS AS SP_2
	LEFT OUTER JOIN		ORDERS AS O_2 ON SP_2.EmpID = O_2.EmpID
	LEFT OUTER JOIN		ORDERITEMS AS OI_2 ON O_2.OrderID = OI_2.OrderID
	LEFT OUTER JOIN		INVENTORY AS I_2 ON OI_2.PartID = I_2.PartID
	GROUP BY		SP_2.Salary, SP_2.EmpID, SP_2.Ename
	) AS PR_1
LEFT OUTER JOIN		ORDERS ON PR_1.EmpID = ORDERS.EmpID
LEFT OUTER JOIN		ORDERITEMS ON ORDERS.OrderID = ORDERITEMS.OrderID
LEFT OUTER JOIN		INVENTORY ON ORDERITEMS.PartID = INVENTORY.PartID
WHERE			PR_1.PR = '2'
GROUP BY		PR_1.Salary, PR_1.EmpID, PR_1.Ename
ORDER BY		ISNULL((SUM(ORDERITEMS.Qty*INVENTORY.Price) - PR_1.Salary),0) DESC;


GO


PRINT '================================================================================' + CHAR(10)
PRINT'10. We have decided to give quantity discounts to encourage more sales.  If an order contains five or more units of a given 
 product we will give a 5% discount for that line item.  If an order contains ten or more units we will give a 10% discount 
 on that line item. Produce an output that prints the OrderID, partid, description, Qty ordered, unit list Price, the total
 original Price(Qty ordered * list Price),  the total discount value (shown as money or percent), and the total final Price 
 of the product after the discount. Use the CASE statement.' + CHAR(10)

SELECT		OrderID, ORDERITEMS.PartID, Description, Qty, CONCAT('$', Price) AS UnitPrice, 
			CONCAT('$',(Qty * Price)) AS OriginalCost,
			CONCAT('$', (CONVERT(DEC(10,2), 
				CASE
					WHEN Qty >= 5 AND Qty < 10 THEN (.95 * Price)
					WHEN Qty >= 10 THEN .9 * Price
				END))) AS QuantityDeduction,
			CONCAT('$', (CONVERT(DEC(10,2),
				CASE
					WHEN Qty >= 5 AND Qty < 10 THEN (.95 * Price) * Qty 
					WHEN Qty >= 10 THEN (.9 * Price) * Qty
				END))) AS FinalCost
FROM		ORDERITEMS
JOIN		INVENTORY ON ORDERITEMS.PartID = INVENTORY.PartID
WHERE		Qty >= 5
ORDER BY	OrderID, PartID;


GO


--------------------------------------------------------------------------------
-- Program block
--------------------------------------------------------------------------------
DECLARE @v_now DATETIME;
BEGIN
    SET @v_now = GETDATE();
    PRINT '================================================================================'
    PRINT 'End of CIS276 Lab2';
    PRINT @v_now;
    PRINT '================================================================================';
END;


