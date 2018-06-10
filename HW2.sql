--1
DECLARE @pn nvarchar(50) = 'someName'

SELECT DISTINCT P.ParkingNo, P.ParkingName, CONVERT(date, PD.date_start)
FROM Parking P LEFT JOIN ParkingData PD ON P.ParkingNo = PD.ParkingNo
WHERE P.ParkingName = @pn

--2
SELECT PD.CarID, C.RegNo, COUNT(*), COUNT(DISTINCT PD.p_ID), SUM(DATEDIFF(s , PD.date_start, CASE WHEN PD.date_end IS NOT NULL THEN PD.date_end ELSE GETDATE() END))
FROM ParkingData PD LEFT JOIN Cars C ON PD.CarID = C.CarID
GROUP BY PD.CarID

--3
DECLARE @date date = '2017-01-01'

SELECT DISTINCT ParkingNo
FROM ParkingData
EXEPT
SELECT DISTINCT PD.ParkingNo
FROM ParkingData PD LEFT JOIN Cars C ON PD.CarID = C.CarID
WHERE C.RegNo like '%777' AND PD.date_start > @date

--4
DECLARE @Date date = '2017-01-01'

SELECT DISTINCT C.CarID, C.RegNo, COUNT(PD.ParkingNo)
FROM Cars C LEFT JOIN ParkingData PD ON PD.CarID = C.CarID
WHERE PD.date_start > @date
GROUP BY C.CarID, C.RegNo
HAVING COUNT(PD.ParkingNo) < 3

--5
ALTER TABLE Ñars ADD COLUMN Total_ent int
INSERT INTO Ñars(Total_ent) (
SELECT count(*)
FROM Cars INNER JOIN ParkingData USING Cars.CarID = ParkingData.CarID 
GROUP BY CarID
) as T