-- 1.Customer Report of the customers from America as Customer ID, Customer Name, Contact Person, State...
SELECT CustomerID, CompanyName AS [Customer Name], ContactName AS [Contact Person], City
FROM Customers
WHERE Country = 'USA'


-- 2.Product List as Product ID, Product Name, Category ID, List Price for products with list price above 50
SELECT P.ProductID, P.ProductName, P.CategoryID, P.UnitPrice AS [List Price]
FROM Products AS P
WHERE UnitPrice > 50
ORDER BY [List Price] DESC


-- 3.List of Employees Living in London and Seattle as Employee ID, Employee name
SELECT e.EmployeeID AS [Employee ID], e.FirstName + '' + e.LastName AS [Employee name]
FROM Employees AS e
WHERE e.City = 'London' OR e.City ='Seattle'


-- List of customers as CustomerID, Customer Name, Contact Title
-- such that the contact title contains word sales int it
SELECT CustomerID, ContactName, ContactTitle
FROM Customers 
WHERE ContactTitle like 'Sales%'


-- list of current products with unit price between 10 and 50 as product ID, Product Name, unit price
SELECT P.ProductID, P.ProductName, P.UnitPrice
FROM Products P
WHERE Discontinued = 0 -- discontinued always takes only 2 values, true/false
AND P.UnitPrice BETWEEN 10 AND 50
ORDER BY P.UnitPrice


-- List of orders raised in the month of December 1997
SELECT *
FROM Orders AS O
WHERE YEAR(O.OrderDate) = 1997
AND MONTH(O.OrderDate) = 12

-- DATE FUNCTION
SELECT GETDATE()


-- List of orders raised in the third quarter of 1996
SELECT *
FROM ORDERS AS O
WHERE YEAR(O.OrderDate) = 1996
AND DATEPART(Q,OrderDate) = 3;


--list of orders as OrderID,Order Date for all orders raused in Novemenber
Select OrderId,OrderDate 
from Orders as O
where MONTH(O.OrderDate) = 11;

-- list of employees as EmployeedID, employeeName, employee Age in Year;
-- Employeee month in service

select E.EmployeeID, E.FirstName + ' ' + E.LastName as [Employee FullName], 
DATEDIFF(YY,E.BirthDate, GETDATE()) as [Employee Age In Years],
DATEDIFF(MM, E.HireDate, GETDATE()) as [Employee Months in Years]
FROM Employees as E;


-- list of employees as EmployeedID, employeeName, employee Age in Year;
-- Employeee month in service as of 31-dec-1997

select E.EmployeeID, E.FirstName + ' ' + E.LastName as [Employee FullName], 
DATEDIFF(YY,E.BirthDate, '1997-12-31') as [Employee Age In Years from '1997-12-31'],
DATEDIFF(MM, E.HireDate, '1997-12-31') as [Employee Months in Years from '1997-12-31']
FROM Employees as E;


-- JOINS IN SQL
--Product List as Product ID, Product Name, CategoryID, CategoryName
SELECT *
FROM 
Products AS P 
INNER JOIN Categories AS C ON P.CategoryID = C.CategoryID
-- INNER JOIN: It returns only the rows that have matching values in both tables.


-- Create Order Report for all orders raised for customers in the USA and not yet shipped as OrderID, Order Date, Required By Date, 
-- Customer Date, Employee Name
SELECT O.OrderID, O.OrderDate, O.RequiredDate AS [Required By Date], C.CompanyName AS [Customer Name],
E.FirstName + '' +E.LastName AS [Employee Name]
FROM 
Orders AS O 
				JOIN Customers AS C ON O.CustomerID = C.CustomerID 
				JOIN Employees AS E ON O.EmployeeID = E.EmployeeID
WHERE 
C.Country = 'USA' AND O.ShippedDate IS NULL 


-- Product Report as Porduct ID, Product Name, Category Name, Order ID, Order Date Shipper Name 
-- for all orders sent to France 
-- Sort the data in ascending order of Category Name, Product Name and Order ID

SELECT  C.CategoryName, OD.ProductID, P.ProductName, OD.OrderID, O.OrderDate
FROM
[Order Details] AS OD JOIN Orders AS O ON OD.OrderID = O.OrderID
                      JOIN Products AS P ON OD.ProductID = P.ProductID
					  JOIN Shippers AS S ON O.SHIPVia = S.ShipperID
					  JOIN Categories AS C ON P.CategoryID = C.CategoryID
WHERE
O.ShipCountry = 'France'
ORDER BY C.CategoryName, P.ProductName, O.OrderID


-- Assuming the report generation date as 31-May-1997, list all orders which are not shipped 
-- along with the classification of orders as 'On Time' or 'Delayed'
-- Which the order is delayed... should be 0 for 'On time'
Select *,
CASE
WHEN O.OrderDate <= '1998-05-31' THEN 'Delayed'
ELSE 'ON Time'
END As Classification,
CASE
When DATEDIFF(D,O.RequiredDate,'1998-05-31') < 0 Then 0
ELSE DATEDIFF(D, O.RequiredDate,'1998-05-31')
END AS DelayedByDays
FROM Orders as O
WHERE O.ShippedDate IS NULL;

-- list of customers who did not raise any order
SELECT DISTINCT C.ContactName
FROM Customers AS C
LEFT JOIN Orders AS O ON C.CustomerID = O.CustomerID
WHERE O.OrderID IS NULL;


-- Employee report as EmployeeId, Employee Name, Terriotory, Region sorted by region 
SELECT E.EmployeeID, E.FirstName + ' ' + E.LastName AS [Employee Name],T.TerritoryDescription AS Territory,R.RegionDescription AS Region
FROM Employees E
JOIN EmployeeTerritories ET ON E.EmployeeID = ET.EmployeeID
JOIN Territories T ON ET.TerritoryID = T.TerritoryID
JOIN Region R ON T.RegionID = R.RegionID
ORDER BY  R.RegionDescription ASC;


-- Order Count as per order year in decending order
SELECT YEAR(O.OrderDate) AS [Order Year], COUNT(O.OrderID) AS [Order COunt]
FROM Orders AS O
GROUP BY YEAR(O.OrderDate)
ORDER BY [Order Year] DESC;


-- Product reports as ProductID, Product Name and Order Count for Orders raised in year 1997
SELECT OD.ProductID, P.ProductName, COUNT(OD.OrderID) AS [Order Count]
FROM [Order Details] AS OD JOIN Orders AS O ON OD.OrderID = O.OrderID
                           JOIN Products AS P ON OD.ProductID = P.ProductID
WHERE YEAR(O.OrderDate) = 1997
GROUP BY OD.ProductID, P.ProductName
ORDER BY [Order Count] 

-- STEPS
-- 1. Identify column header
-- 2. Identify tables - columns - expression
-- 3. Identify Joins
-- 4. Identify filter condition
-- 5. Aggregation Requirements
-- 6. Grouping Requirements
-- 7. Sorting Requirements

-- FROM 
-- FKT JOIN PKT ON FKT.FK = PKT.PK


-- Report showing the Customer Count by Product from category 'Beverages' in year 1998
SELECT OD.ProductID, P.ProductName, C.CategoryName, COUNT(O.CustomerID) as [Customer Count]
FROM [Order Details] AS OD JOIN Products AS P ON OD.ProductID = P.ProductID
                           JOIN Orders AS O ON OD.OrderID = O.OrderID
						   JOIN Categories AS C ON P.CategoryID = C.CategoryID
						   -- JOIN Customers AS CT ON O.CustomerID = CT.CustomerID
WHERE 
YEAR(O.OrderDate) = 1998 AND C.CategoryName = 'Beverages'
GROUP BY OD.ProductID, P.ProductName, C.CategoryName 
ORDER BY [Customer Count] DESC


-- Order Report for the US based Customers as Customer Name, Order ID, Order Date, Total Order Value 
-- for all July and August Orders
SELECT C.CompanyName, OD.OrderID AS [Order ID], O.OrderDate AS [Order Date], SUM(OD.Quantity * OD.UnitPrice*(1-OD.Discount)) AS [Total Order Value]
FROM [Order Details] AS OD JOIN Orders AS O ON OD.OrderID = O.OrderID
						   JOIN Customers AS C ON O.CustomerID = C.CustomerID
WHERE C.Country = 'USA' AND O.OrderDate BETWEEN '1996-07-01' AND '1996-08-31'
GROUP BY C.CompanyName, OD.OrderID, O.OrderDate
ORDER BY O.OrderDate , [Total Order Value] DESC


-- nerver group by on Name because there can be two students or employees with same name. thus along with name use id or any other condition
-- Employee who generated the highest Order Value in year 1997...
SELECT O.EmployeeID, E.FirstName + ' ' + E.LastName as [Employee Name], MAX(OD.Quantity * OD.UnitPrice * (1- OD.Discount)) AS [Max Order Value]
FROM 
[Order Details] AS OD JOIN Orders AS O ON OD.OrderID = O.OrderID -- Highest FK is with Order Details thus we use FROM [Order Details]
                      JOIN Employees AS E ON O.EmployeeID = E.EmployeeID
WHERE 
YEAR(O.OrderDate) = 1997
GROUP BY O.EmployeeID, E.FirstName, E.LastName
ORDER BY [Max Order Value] DESC


-- Employee Report as EmployeeID, Employee Name Total Order Value for year 1997
-- here we are just getting the output of the highest order value out of total order values list. it is not giving the the max or sum of all employees.
SELECT TOP 1 O.EmployeeID, E.FirstName + ' ' + E.LastName as [Employee Name], SUM(OD.Quantity * OD.UnitPrice * (1- OD.Discount)) AS [Total Order Value]
FROM 
[Order Details] AS OD JOIN Orders AS O ON OD.OrderID = O.OrderID -- Highest FK is with Order Details thus we use FROM [Order Details]
                      JOIN Employees AS E ON O.EmployeeID = E.EmployeeID
WHERE 
YEAR(O.OrderDate) = 1997
GROUP BY O.EmployeeID, E.FirstName, E.LastName
ORDER BY [Total Order Value] DESC;


-- Getting the top 1st employee who had made the max order value in the year 1997
SELECT TOP 1 O.EmployeeID, E.FirstName + ' ' + E.LastName as [Employee Name], SUM(OD.Quantity * OD.UnitPrice * (1- OD.Discount)) AS [Total Order Value]
FROM 
[Order Details] AS OD JOIN Orders AS O ON OD.OrderID = O.OrderID -- Highest FK is with Order Details thus we use FROM [Order Details]
                      JOIN Employees AS E ON O.EmployeeID = E.EmployeeID
WHERE 
YEAR(O.OrderDate) = 1997
GROUP BY O.EmployeeID, E.FirstName, E.LastName
ORDER BY [Total Order Value] DESC;


-- what if more than two employees are having exact same Order value then we have to display everyone's name
-- MAX(SUM..) can't be used together because two agg functions can't be used together
-- COMMON TABLE EXPRESSION(CTE) helps us to create a table(temp memory table) which can't be seen in the tables list of database in which it stores first query ouput of 
-- SUM(..) and then applying MAX(..)/(TOP..) on the previous table so that there will not be any AGG error

WITH Employee_Total_Order_Value AS
(
	SELECT O.EmployeeID, E.FirstName + ' ' + E.LastName as [Employee Name], SUM(OD.Quantity * OD.UnitPrice * (1- OD.Discount)) AS [Total Order Value]
	FROM 
	[Order Details] AS OD JOIN Orders AS O ON OD.OrderID = O.OrderID -- Highest FK is with Order Details thus we use FROM [Order Details]
						  JOIN Employees AS E ON O.EmployeeID = E.EmployeeID
	WHERE 
	YEAR(O.OrderDate) = 1997
	GROUP BY O.EmployeeID, E.FirstName, E.LastName

	
-- AS keyword automatically make a new memory table and creates columns as per the query and inserts rows when executed
), Max_Order_Value AS 
(
	SELECT MAX(ETOV.[Total Order Value]) AS [Max Order Value]
	FROM Employee_Total_Order_Value ETOV
)

-- there is no relation between the two tables since we want to join both the tables CROSS JOIN on both CTE's
SELECT *
FROM Employee_Total_Order_Value AS ETOV CROSS JOIN Max_Order_Value AS MOV

WHERE ETOV.[Total Order Value] = MOV.[Max Order Value]


-- SELECT ETOV.EmployeeID, ETOV.[Employee Name], MAX(ETOV.[Total Order Value]) AS [Max Order Value]
-- FROM Employee_Total_Order_Value AS ETOV
-- GROUP BY ETOV.EmployeeID, ETOV.[Employee Name]

-- WHERE ETOV.[MAX Order Value] = (SELECT(MAX(ETOV.[MAX Order Value])) FROM ETOV
-- NOT POSSIBLE because for query the table must exist in the database

-- Employee report as Employee ID, Employee Name, Total Order Value Avg Order Value...
-- Create a classification column with values 'Above Average' and 'Below Average'
WITH Employee_Total_Order_Value AS
(
	SELECT O.EmployeeID, E.FirstName + ' ' + E.LastName as [Employee Name], SUM(OD.Quantity * OD.UnitPrice * (1- OD.Discount)) AS [Total Order Value]
	FROM 
	[Order Details] AS OD JOIN Orders AS O ON OD.OrderID = O.OrderID -- Highest FK is with Order Details thus we use FROM [Order Details]
						  JOIN Employees AS E ON O.EmployeeID = E.EmployeeID
	WHERE 
	YEAR(O.OrderDate) = 1997
	GROUP BY O.EmployeeID, E.FirstName, E.LastName
	
), Average_Order_Value AS 
(
	SELECT AVG(ETOV.[Total Order Value]) AS [Avg Order Value]
	FROM Employee_Total_Order_Value ETOV
)
SELECT *,
CASE
	WHEN ETOV.[Total Order Value] > AOV.[Avg Order Value] THEN 'Above Average'
	ELSE 'Below Average'
END AS Classification
FROM Employee_Total_Order_Value AS ETOV CROSS JOIN Average_Order_Value AS AOV
ORDER BY ETOV.[Total Order Value] DESC

-- Write a query to display total order value, average order value fro year 1998
SELECT SUM(OD.Quantity * OD.UnitPrice * (1- OD.Discount)) AS [Total Order Value]
FROM 
[Order Details] AS OD JOIN Orders AS O ON OD.OrderID = O.OrderID
WHERE YEAR(O.OrderDate) = 1998


-- Top 3 highest selling products by TOV for year 1997
WITH Products_TOV AS (
	SELECT 
		p.ProductName, 
		od.ProductID, 
		SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)) AS TOV
	FROM [Order Details] od
	JOIN Orders o ON od.OrderID = o.OrderID
	JOIN Products p ON od.ProductID = p.ProductID
	WHERE YEAR(o.OrderDate) = 1997
	GROUP BY p.ProductName, od.ProductID
),
Ranked_Products AS (
	SELECT *,
		DENSE_RANK() OVER (ORDER BY TOV DESC) AS Product_Rank
	FROM Products_TOV
)
SELECT * 
FROM Ranked_Products
WHERE Product_Rank <= 3;


-- Bottom 5 ranked products for year 1997 based on Order count
WITH Product_Order_Count AS (
	SELECT 
		p.ProductName, 
		od.ProductID, 
		COUNT( Distinct o.OrderID) AS [Order Count]
	FROM [Order Details] od
	JOIN Orders o ON od.OrderID = o.OrderID
	JOIN Products p ON od.ProductID = p.ProductID
	WHERE YEAR(o.OrderDate) = 1997
	GROUP BY p.ProductName, od.ProductID
),
Ranked_Products AS (
	SELECT *,
		DENSE_RANK() OVER (ORDER BY POC.[Order Count] ASC) AS Product_Rank
	FROM Product_Order_Count POC
)
SELECT TOP  5 * 
FROM Ranked_Products RP
WHERE Product_Rank <= 5;


-- Top 5 ranked customers based on their product count for year 1998
WITH Customer_Product_Count AS (
    SELECT 
        c.CustomerID,
        c.CompanyName,
        SUM(od.Quantity) AS TotalProductsBought
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    JOIN [Order Details] od ON o.OrderID = od.OrderID
    WHERE YEAR(o.OrderDate) = 1998
    GROUP BY c.CustomerID, c.CompanyName
),
Ranked_Customers AS (
    SELECT *, 
           DENSE_RANK() OVER (ORDER BY TotalProductsBought DESC) AS CustomerRank
    FROM Customer_Product_Count
)
SELECT *
FROM Ranked_Customers
WHERE CustomerRank <= 5;


-- Top 3 customers based on TOV in each year
WITH Customer_TOV_By_Year AS (
    SELECT 
        c.CustomerID,
        c.CompanyName,
        YEAR(o.OrderDate) AS OrderYear,
        SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)) AS TotalOrderValue
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    JOIN [Order Details] od ON o.OrderID = od.OrderID
    GROUP BY c.CustomerID, c.CompanyName, YEAR(o.OrderDate)
),
Ranked_Customers AS (
    SELECT *,
           DENSE_RANK() OVER (
               PARTITION BY OrderYear 
               ORDER BY TotalOrderValue DESC
           ) AS CustomerRank
    FROM Customer_TOV_By_Year
)
SELECT *
FROM Ranked_Customers
WHERE CustomerRank <= 3
ORDER BY OrderYear, CustomerRank;


-- List of customers contributing to 70% of TOV for year 1998
WITH Customers_TOV AS (
    SELECT 
        o.CustomerID,
        c.CompanyName AS [Customer Name],
        SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)) AS TOV
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    JOIN [Order Details] od ON o.OrderID = od.OrderID
	WHERE YEAR(o.OrderDate) = 1998
    GROUP BY o.CustomerID, c.CompanyName
),
Seventy_Percent_of_TOV AS 
(
    SELECT 0.7 * SUM(CT.TOV) AS [70% Of TOV]
	FROM Customers_TOV AS CT
),
Cumulative_TOV AS
(
	SELECT *,
	SUM(CT.TOV) OVER(ORDER BY CT.TOV DESC) AS [Cumulative TOV]
	FROM Customers_TOV AS CT
)
SELECT * FROM
Cumulative_TOV AS CT
CROSS JOIN Seventy_Percent_of_TOV SPOT
WHERE CT.[Cumulative TOV] <= SPOT.[70% Of TOV]


-- Category-wise List of Products contributing to 50% of Category TOV for year 1997
WITH [Category Product TOV] AS (
    SELECT 
		p.CategoryID,
        c.CategoryName,
		od.ProductId,
		p.ProductName,
        SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)) AS [Product TOV]
    FROM [Order Details] od
    JOIN Orders o ON od.OrderID = o.OrderID
    JOIN Products p ON od.ProductID= p.ProductID
	JOIN Categories AS c ON p.CategoryID = c.categoryID 
	WHERE YEAR(o.OrderDate) = 1997
	GROUP BY p.CategoryID,
        c.CategoryName,
		od.ProductId,
		p.ProductName
),
Fifty_Percent_Of_Category_TOV AS
(	
	SELECT	CPT.CategoryID, CPT.CategoryName, SUM(CPT.[Product TOV])* 0.5 AS [50% Of Category TOV]
	FROM [Category Product TOV] AS CPT
	GROUP BY CPT.CategoryID, CPT.CategoryName
),
Category_Cumulative_TOV AS
(
	SELECT *,
	SUM(CPT.[Product TOV]) OVER(PARTITION BY CPT.CategoryID ORDER BY CPT.[Product TOV]) AS [Category Cumulative]
	FROM [Category Product TOV] AS CPT
)
SELECT * FROM [Category_Cumulative_TOV] AS CC
JOIN [Fifty_Percent_Of_Category_TOV] AS T50 ON CC.[CategoryID] = T50.[CategoryID]
-- CROSS JOIN Fifty_Percent_Of_Category_TOV AS T50 
WHERE CC.[Category Cumulative] <= T50.[50% Of Category TOV]




-- Create a report providing mmonthlyh TOV and Order Count...
-- Provide the month on month change in TOV and order count, in absolute value and percentage
WITH Monthly_Data AS
{
	SELECT MONTH(o.Orderdate) AS [Month Number], DATENAME(MM, o.OrderDate) AS [Month Name],
	SUM(od.Quantity * od.unitPrice * (1 - od.Discount)) As [Month TOV],
	COUNT(DISTINCT o.OrderID) AS [Current Month Order Count]
	FROM [Order Details] AS od
	JOIN Orders AS o ON od.OrderID = o.OrderID
	WHERE YEAR(o.OrderDate) = 1997
	GROUP BY MONTH(o.OrderDate), DATENAME(MM, o.OrderDate)
),
Monthly_Data_With_Previous_Month_Values AS
(
	SELECT *
	LAG(MD.[Current Month TOV], 1, 0) OVER
	(
		ORDER BY MD.[Month Number]
	) AS [Previous Month TOV],
	LAG(MD.[Current Month Order Count], 1, 0) OVER
	(
		ORDER BY MD.[Month Number]
	) AS [Previous Month Order Count],
	FROM Monthly_Data AS MD
)
SELECT *
CASE
	WHEN MDWPMV.[Previous Month TOV] = 0
	THEN 0
	ELSE
	MDWPMV.[Current Month TOV] - MDWPMV.[Previous Month TOV]
END AS [M-O-M Change In TOV (ABS)],
CASE 
	WHEN MDWPMV.[Previous Month TOV]=0
	THEN '0.0%'
	ELSE
	CAST((MDWPMV.[Current Month TOV] - MDWPMV.[Previous Month TOV]) / MDWPMV.[Previous Month TOV] * 100 AS numeric(4,2)) AS nvarhcar) + '%'
END AS [M-O-M Change In TOV (PER)]
CASE
	WHEN MDWPMV.[Previous Month Order Count] = 0
	TEHN 'O.O%'
	ELSE
	CAST(
	CAST(
	(MDWPMV.[Previous Month Order Count] - MDWPMV.[Current Month Order Count])/MDWPMV.[Previous Month Order Count] * 100 
	AS numeric(4,2))
	AS varchar

FROM Monthly_Data_With_Previous_Month_Values A MDWPMV
GO

-- Daily TOV for Year 1997 along with 5 day and 10 simple moving average
WITH Daily_TOV AS
(
	SE;ECT O.OrderDate AS [Order Date],
	SUM OD.Quantity * OD.UnitPrice * (1- OD.Discount)) AS TOV
	FROM [Order Detail] AS OD
	JOIN Order AS O ON OD.OrderID = O.OrderID
	WHERE YEAR (O.OrderDate) = 1997
	GROUP BY O.OrderDate
),
[5 Day SMA] AS 
(
	SELECT *,
	AVG(DT.TOV) OVER()
	(
		OVER BY DT.[Order Date]
		ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
	) 
	AS [5 DMA] AS
	(
	FROM Daily_TOV AS DT


-- Q1. Average Sale per Product for each Category in 1997 and Deviation %

WITH Sales1997 AS (
    SELECT 
        P.ProductID,
        P.ProductName,
        C.CategoryID,
        C.CategoryName,
        OD.UnitPrice * OD.Quantity * (1 - OD.Discount) AS SaleAmount
    FROM Orders O
    JOIN [Order Details] OD ON O.OrderID = OD.OrderID
    JOIN Products P ON OD.ProductID = P.ProductID
    JOIN Categories C ON P.CategoryID = C.CategoryID
    WHERE YEAR(O.OrderDate) = 1997
),
CategoryAvg AS (
    SELECT 
        CategoryID,
        CategoryName,
        AVG(SaleAmount) AS AvgSalePerProduct
    FROM Sales1997
    GROUP BY CategoryID, CategoryName
),
OverallAvg AS (
    SELECT AVG(SaleAmount) AS OverallAvgSale
    FROM Sales1997
)
SELECT 
    CA.CategoryName,
    CA.AvgSalePerProduct,
    O.OverallAvgSale,
    ROUND(((CA.AvgSalePerProduct - O.OverallAvgSale) / O.OverallAvgSale) * 100, 2) AS DeviationPercent
FROM CategoryAvg CA
CROSS JOIN OverallAvg O
ORDER BY DeviationPercent DESC;


-- 2. Employee-wise Order Count for year 1997... Create new column called 'Assessment' with the values as based on following criteria -
-- a. Employee with count within top 30% of Sale as 'High Performer'
-- b. Employee with count within bottom 20% of Sale as 'Low Performer'
-- c. All others as 'Average Performers'
WITH EmpOrders AS (
    SELECT 
        E.EmployeeID,
        E.FirstName + ' ' + E.LastName AS EmployeeName,
        COUNT(O.OrderID) AS OrderCount
    FROM Orders O
    JOIN Employees E ON O.EmployeeID = E.EmployeeID
    WHERE YEAR(O.OrderDate) = 1997
    GROUP BY E.EmployeeID, E.FirstName, E.LastName
),
Ranked AS (
    SELECT *,
        NTILE(10) OVER (ORDER BY OrderCount DESC) AS Decile
    FROM EmpOrders
)
SELECT 
    EmployeeID,
    EmployeeName,
    OrderCount,
    CASE 
        WHEN Decile <= 3 THEN 'High Performer'
        WHEN Decile >= 9 THEN 'Low Performer'
        ELSE 'Average Performer'
    END AS Assessment
FROM Ranked
ORDER BY OrderCount DESC;


--3. Ship Country-wise Top 3 Products by Order Count
WITH ProductCountry AS (
    SELECT 
        O.ShipCountry,
        P.ProductName,
        COUNT(OD.OrderID) AS OrderCount
    FROM Orders O
    JOIN [Order Details] OD ON O.OrderID = OD.OrderID
    JOIN Products P ON OD.ProductID = P.ProductID
    GROUP BY O.ShipCountry, P.ProductName
),
Ranked AS (
    SELECT *,
        RANK() OVER (PARTITION BY ShipCountry ORDER BY OrderCount DESC) AS ProductRank
    FROM ProductCountry
)
SELECT *
FROM Ranked
WHERE ProductRank <= 3
ORDER BY ShipCountry, ProductRank;


-- 4:Year-wise Count of Orders and % of Orders Booked to Orders Shipped...
SELECT 
    YEAR(OrderDate) AS OrderYear,
    COUNT(OrderID) AS TotalOrders,
    SUM(CASE WHEN MONTH(OrderDate) = MONTH(ShippedDate) AND YEAR(OrderDate) = YEAR(ShippedDate) THEN 1 ELSE 0 END) AS SameMonthShipped,
    ROUND(
        CAST(SUM(CASE WHEN MONTH(OrderDate) = MONTH(ShippedDate) AND YEAR(OrderDate) = YEAR(ShippedDate) THEN 1 ELSE 0 END) AS FLOAT) 
        / COUNT(OrderID) * 100, 2) AS BookingVsShippingPercent
FROM Orders
GROUP BY YEAR(OrderDate)
ORDER BY OrderYear;


-- 5: Category-wise Sale and Contribution % for 1998
WITH Sales1998 AS (
    SELECT 
        C.CategoryName,
        OD.UnitPrice * OD.Quantity * (1 - OD.Discount) AS SaleAmount
    FROM Orders O
    JOIN [Order Details] OD ON O.OrderID = OD.OrderID
    JOIN Products P ON OD.ProductID = P.ProductID
    JOIN Categories C ON P.CategoryID = C.CategoryID
    WHERE YEAR(O.OrderDate) = 1998
),
CategorySale AS (
    SELECT 
        CategoryName,
        SUM(SaleAmount) AS TotalCategorySale
    FROM Sales1998
    GROUP BY CategoryName
),
TotalSale AS (
    SELECT SUM(SaleAmount) AS OverallSale
    FROM Sales1998
)
SELECT 
    CS.CategoryName,
    CS.TotalCategorySale,
	TS.OverallSale,
    ROUND(CS.TotalCategorySale / TS.OverallSale * 100, 2) AS ContributionPercent
FROM CategorySale CS
CROSS JOIN TotalSale TS
ORDER BY ContributionPercent DESC;



-- 6. Customer-wise Sale for year 1996 with Average Sale per Customer, Total Sale for each Country, Total Sale of Year, 
-- Customer Contribution % to Country Sale, Country Sale Contribution to Year Sale...
WITH Sales1996 AS (
    SELECT 
        C.CustomerID,
        C.CompanyName,
        C.Country,
        OD.UnitPrice * OD.Quantity * (1 - OD.Discount) AS SaleAmount
    FROM Orders O
    JOIN [Order Details] OD ON O.OrderID = OD.OrderID
    JOIN Customers C ON O.CustomerID = C.CustomerID
    WHERE YEAR(O.OrderDate) = 1996
),
CustomerSale AS (
    SELECT 
        CustomerID,
        CompanyName,
        Country,
        SUM(SaleAmount) AS TotalCustomerSale
    FROM Sales1996
    GROUP BY CustomerID, CompanyName, Country
),
CountrySale AS (
    SELECT 
        Country,
        SUM(TotalCustomerSale) AS TotalCountrySale
    FROM CustomerSale
    GROUP BY Country
),
YearSale AS (
    SELECT SUM(TotalCustomerSale) AS TotalYearSale
    FROM CustomerSale
),
AvgCustomerSale AS (
    SELECT AVG(TotalCustomerSale) AS AvgSalePerCustomer
    FROM CustomerSale
)
SELECT 
    CS.CustomerID,
    CS.CompanyName,
    CS.Country,
    CS.TotalCustomerSale,
    AC.AvgSalePerCustomer,
    CO.TotalCountrySale,
    YS.TotalYearSale,
    ROUND(CS.TotalCustomerSale * 100.0 / CO.TotalCountrySale, 2) AS CustomerToCountryPercent,
    ROUND(CO.TotalCountrySale * 100.0 / YS.TotalYearSale, 2) AS CountryToYearPercent
FROM CustomerSale CS
JOIN CountrySale CO ON CS.Country = CO.Country
CROSS JOIN YearSale YS
CROSS JOIN AvgCustomerSale AC
ORDER BY CS.TotalCustomerSale DESC;


-- 7: Countries Contributing to 60% Freight Per Shipper Per Yea
WITH FreightData AS (
    SELECT 
        YEAR(O.OrderDate) AS OrderYear,
        S.CompanyName AS Shipper,
        O.ShipCountry AS Country,
        SUM(O.Freight) AS TotalFreight
    FROM Orders O
    JOIN Shippers S ON O.ShipVia = S.ShipperID
    GROUP BY YEAR(O.OrderDate), S.CompanyName, O.ShipCountry
),
TotalFreightPerShipperYear AS (
    SELECT 
        OrderYear,
        Shipper,
        SUM(TotalFreight) AS ShipperYearFreight
    FROM FreightData
    GROUP BY OrderYear, Shipper
),
RankedFreight AS (
    SELECT 
        FD.*,
        TS.ShipperYearFreight,
        ROUND(FD.TotalFreight * 100.0 / TS.ShipperYearFreight, 2) AS FreightContribution,
        SUM(FD.TotalFreight) OVER (PARTITION BY FD.OrderYear, FD.Shipper ORDER BY FD.TotalFreight DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS CumulativeFreight
    FROM FreightData FD
    JOIN TotalFreightPerShipperYear TS 
      ON FD.OrderYear = TS.OrderYear AND FD.Shipper = TS.Shipper
),
Final AS (
    SELECT *,
           ROUND(CumulativeFreight * 100.0 / ShipperYearFreight, 2) AS CumulativeFreightPercent
    FROM RankedFreight
)
SELECT OrderYear, Shipper, Country, TotalFreight, FreightContribution, CumulativeFreightPercent
FROM Final
WHERE CumulativeFreightPercent <= 60
ORDER BY OrderYear, Shipper, CumulativeFreightPercent;


-- 8. Quarter-wise Sale (All Years) + QoQ Change and Avg Change %

WITH SalesQuarter AS (
    SELECT 
        YEAR(O.OrderDate) AS OrderYear,
        DATEPART(QUARTER, O.OrderDate) AS Quarter,
        SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) AS TotalSale
    FROM Orders O
    JOIN [Order Details] OD ON O.OrderID = OD.OrderID
    GROUP BY YEAR(O.OrderDate), DATEPART(QUARTER, O.OrderDate)
),
WithLag AS (
    SELECT *,
        LAG(TotalSale) OVER (PARTITION BY OrderYear ORDER BY Quarter) AS PrevQuarterSale
    FROM SalesQuarter
),
WithChange AS (
    SELECT *,
        ROUND((TotalSale - PrevQuarterSale) * 100.0 / PrevQuarterSale, 2) AS QoQChangePercent
    FROM WithLag
)
SELECT *,
       ROUND(AVG(QoQChangePercent) OVER (PARTITION BY Quarter), 2) AS AvgQoQChangePerQuarter
FROM WithChange
ORDER BY OrderYear, Quarter;


-- 9: Category-wise Monthly Sale for 1997 with Color Code
WITH MonthlySale AS (
    SELECT 
        C.CategoryName,
        MONTH(O.OrderDate) AS SaleMonth,
        SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) AS TotalSale
    FROM Orders O
    JOIN [Order Details] OD ON O.OrderID = OD.OrderID
    JOIN Products P ON OD.ProductID = P.ProductID
    JOIN Categories C ON P.CategoryID = C.CategoryID
    WHERE YEAR(O.OrderDate) = 1997
    GROUP BY C.CategoryName, MONTH(O.OrderDate)
),
AvgSale AS (
    SELECT CategoryName, AVG(TotalSale) AS AvgCategoryMonthlySale
    FROM MonthlySale
    GROUP BY CategoryName
)
SELECT 
    M.CategoryName,
    M.SaleMonth,
    M.TotalSale,
    A.AvgCategoryMonthlySale,
    CASE
        WHEN M.TotalSale >= 1.25 * A.AvgCategoryMonthlySale THEN 'Green'
        WHEN M.TotalSale <= 0.80 * A.AvgCategoryMonthlySale THEN 'Red'
        ELSE 'Yellow'
    END AS ColorCode
FROM MonthlySale M
JOIN AvgSale A ON M.CategoryName = A.CategoryName
ORDER BY M.CategoryName, M.SaleMonth;


-- INTERNAL TEST
--1. Write the query that generates the following output - ProductID, ProductName, CategoryName
SELECT 
    P.ProductID,
    P.ProductName,
    C.CategoryName
FROM Products P
JOIN Categories C 
    ON P.CategoryID = C.CategoryID
ORDER BY P.ProductID;
-- FROM FKT
-- JOIN PKT ON FKT.FK = PKT.PK


--2. Write a query to generate the list of customers as - CustomerID, CompnayName, Country where the contact person is owner
SELECT 
    CustomerID,
    CompanyName,
    Country
FROM Customers
WHERE ContactTitle LIKE '%Owner%'
ORDER BY Country, CompanyName;


-- 3. Write a query that gives the total sale for each month of year 1998
SELECT 
    MONTH(O.OrderDate) AS SaleMonth,
    SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) AS TotalSale
FROM Orders O
JOIN [Order Details] OD 
    ON O.OrderID = OD.OrderID
WHERE YEAR(O.OrderDate) = 1998
GROUP BY MONTH(O.OrderDate)
ORDER BY SaleMonth;


-- 4. Write the query that gives the list of customers who placed more than 5 orders in year 1997 as - CustomerID, CompanyName, OrderCount
SELECT 
    C.CustomerID,
    C.CompanyName,
    COUNT(O.OrderID) AS OrderCount
FROM Customers C
JOIN Orders O 
    ON C.CustomerID = O.CustomerID
WHERE YEAR(O.OrderDate) = 1997
GROUP BY C.CustomerID, C.CompanyName
HAVING COUNT(O.OrderID) > 5
ORDER BY OrderCount DESC;


-- 5. Write a query that provides the Name of the shipper company with the lowest freight for each country in ship year 1998
SELECT 
    O.ShipCountry,
    S.CompanyName AS ShipperCompanyName,
    O.Freight
FROM Orders O
JOIN Shippers S 
    ON O.ShipVia = S.ShipperID
WHERE YEAR(O.ShippedDate) = 1998
  AND O.Freight = (
        SELECT MIN(Freight)
        FROM Orders
        WHERE ShipCountry = O.ShipCountry
          AND YEAR(ShippedDate) = 1998
    )
ORDER BY O.ShipCountry;


-- 6.Write a query to provide the list of products as - ProductID, ProductName,
-- ProductSale with +/- 20% deviation from the average sale per product for year 1997

WITH ProductSales AS (
    SELECT 
        P.ProductID,
        P.ProductName,
        SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) AS ProductSale
    FROM [Order Details] OD
    JOIN Orders O 
        ON OD.OrderID = O.OrderID
    JOIN Products P 
        ON OD.ProductID = P.ProductID
    WHERE YEAR(O.OrderDate) = 1997
    GROUP BY P.ProductID, P.ProductName
),

AvgSale AS (
    SELECT AVG(ProductSale) AS AvgProductSale
    FROM ProductSales
)

SELECT 
    PS.ProductID,
    PS.ProductName,
    PS.ProductSale
FROM ProductSales PS
CROSS JOIN AvgSale A
WHERE PS.ProductSale BETWEEN A.AvgProductSale * 0.8 
                          AND A.AvgProductSale * 1.2
ORDER BY PS.ProductSale DESC;


-- 7. Write a query to provide the bottom 3 ranked products in each category for year 1998
WITH Product_Order_Count AS (
    SELECT 
        p.CategoryID,
        c.CategoryName,
        p.ProductID,
        p.ProductName,
        COUNT(DISTINCT o.OrderID) AS [Order Count]
    FROM [Order Details] od
    JOIN Orders o ON od.OrderID = o.OrderID
    JOIN Products p ON od.ProductID = p.ProductID
    JOIN Categories c ON p.CategoryID = c.CategoryID
    WHERE YEAR(o.OrderDate) = 1998
    GROUP BY p.CategoryID, c.CategoryName, p.ProductID, p.ProductName
),
Ranked_Products AS (
    SELECT *,
           DENSE_RANK() OVER (PARTITION BY CategoryID ORDER BY [Order Count] ASC) AS Product_Rank
    FROM Product_Order_Count
)
SELECT *
FROM Ranked_Products
WHERE Product_Rank <= 3;


-- 8. Write a query that provides the Employee with highest freight for each ship year
WITH Freight_Per_Employee AS (
    SELECT 
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName AS EmployeeName,
        YEAR(o.ShippedDate) AS ShipYear,
        SUM(o.Freight) AS TotalFreight
    FROM Orders o
    JOIN Employees e ON o.EmployeeID = e.EmployeeID
    GROUP BY e.EmployeeID, e.FirstName, e.LastName, YEAR(o.ShippedDate)
),
Ranked_Employees AS (
    SELECT *,
        RANK() OVER (PARTITION BY ShipYear ORDER BY TotalFreight DESC) AS RankNo
    FROM Freight_Per_Employee
)
SELECT ShipYear, EmployeeID, EmployeeName, TotalFreight
FROM Ranked_Employees
WHERE RankNo = 1;


-- 9. Customer-wise products contributing to 60% of sales in 1997
WITH CustomerSales AS (
    SELECT 
        c.CustomerID,
        p.ProductName,
		c.CompanyName,
        SUM(od.UnitPrice * od.Quantity) AS ProductSales
    FROM Orders o
    JOIN [Order Details] od ON o.OrderID = od.OrderID
    JOIN Products p ON od.ProductID = p.ProductID
    JOIN Customers c ON o.CustomerID = c.CustomerID
    WHERE YEAR(o.OrderDate) = 1997
    GROUP BY c.CustomerID,c.CompanyName, p.ProductName
),
SalesWithPercent AS (
    SELECT *,
        SUM(ProductSales) OVER (PARTITION BY CustomerID) AS TotalSales
    FROM CustomerSales
),
CumulativeSales AS (
    SELECT *,
        SUM(ProductSales) OVER (PARTITION BY CustomerID ORDER BY ProductSales DESC) AS RunningSales
    FROM SalesWithPercent
)
SELECT CustomerID, ProductName, ProductSales
FROM CumulativeSales
WHERE RunningSales <= 0.6 * TotalSales;


























