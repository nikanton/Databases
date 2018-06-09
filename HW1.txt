--1
SET DATEFORMAT dmy
DECLARE @CID datetime = '27.03.2016'
SELECT distinct Data
FROM dbo.Docs
WHERE CustomerID = @CID
--2
SELECT GoodID, SUM(Qty), SUM(Qty * Price)
FROM dbo.Docs_data
GROUP BY GoodID
--3
SELECT Docs_data.StoreID, SUM(Goods.Mass * Qty) as "mass", SUM(Goods.Volume * Qty) as "volume"
FROM  Goods INNER JOIN Docs_data ON Goods.GoodID = Docs_data.GoodID
GROUP BY Docs_data.StoreID
--4
SELECT Customers.CustomerID, Customers.Customer, COUNT(*)
FROM  Customers INNER JOIN Docs ON Docs.CustomerID = Customers.CustomerID
GROUP BY Customers.CustomerID, Customers.Customer
HAVING COUNT(*) < 10