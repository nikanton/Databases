--1
SELECT Пользователи.Сотрудник_ID, Фамилия, Имя, Отчество, count(login_ID) as 'Kоличество'
FROM  dbo.Пользователи LEFT JOIN dbo.Пользователи_login ON dbo.Пользователи.Сотрудник_ID = dbo.Пользователи_login.Сотрудник_ID
GROUP BY dbo.Пользователи.Сотрудник_ID, dbo.Пользователи.Фамилия, dbo.Пользователи.Имя, dbo.Пользователи.Отчество
--2
SELECT Компьютеры.Комп_ID, Компьютеры.Название
FROM  Компьютеры LEFT JOIN Компьютеры_сессии ON Компьютеры.Комп_ID = Компьютеры_сессии.Комп_ID
GROUP BY Компьютеры.Комп_ID, Компьютеры.Название
HAVING COUNT(Компьютеры_сессии.Сессия_ID) = 0
--3
USE test
SELECT Компьютеры.Комп_ID, Название
FROM  Компьютеры LEFT JOIN Компьютеры_сессии ON Компьютеры.Комп_ID = Компьютеры_сессии.Комп_ID INNER JOIN Пользователи_login ON Компьютеры_сессии.login_ID = Пользователи_login.login_ID AND Пользователи_login.login NOT LIKE '%admin%'
GROUP BY Компьютеры.Комп_ID, Название
--4
SELECT DISTINCT Пользователи_login.Сотрудник_ID, Комп_ID
FROM Компьютеры_сессии INNER JOIN Пользователи_login ON Компьютеры_сессии.login_ID != Пользователи_login.login_ID
--5
SET DATEFORMAT dmy
SELECT DISTINCT Пользователи_login.Сотрудник_ID, Комп_ID
FROM Компьютеры_сессии INNER JOIN Пользователи_login ON Компьютеры_сессии.login_ID != Пользователи_login.login_ID
WHERE Компьютеры_сессии.ДатаПо <= '01.02.17'
--6
SELECT Компьютеры.Комп_ID
FROM Компьютеры INNER JOIN Компьютеры_сессии ON Компьютеры.Комп_ID = Компьютеры_сессии.Комп_ID
WHERE Компьютеры_сессии.ДатаПо IS NULL
UNION
SELECT Комп_ID
FROM Компьютеры
WHERE YEAR(ДатаСборки) = 2016
--7
SELECT Пользователи_login.login_ID, Пользователи_login.login, COUNT(Пользователи_login.login_ID) as 'Количество компов'
FROM Пользователи_login LEFT JOIN Компьютеры_сессии ON Пользователи_login.login_ID = Компьютеры_сессии.login_ID
GROUP BY Пользователи_login.login_ID, login
HAVING COUNT(Пользователи_login.login_ID) < 3
--8
DECLARE @Комп_ID int = 1, @Сессия_ID int = 1
UPDATE Компьютеры_сессии
SET ДатаПо = GETDATE()
WHERE (Комп_ID = @Комп_ID) AND (Сессия_ID = @Сессия_ID) AND (ДатаПо IS NULL)
--9
ALTER TABLE Компьютеры
ADD СумvДлтнсть int NULL
UPDATE Компьютеры
SET СумvДлтнсть = DATEDIFF(MINUTE, Компьютеры_сессии.ДатаС, Компьютеры_сессии.ДатаПо)
FROM Компьютеры INNER JOIN Компьютеры_сессии ON Компьютеры.Комп_ID = Компьютеры_сессии.Комп_ID
--10
DELETE FROM Пользователи_login 
WHERE login_ID NOT IN(SELECT DISTINCT login_ID FROM Компьютеры_сессии)
--11
ALTER TABLE Компьютеры DROP COLUMN ДатаСборки
ALTER TABLE Компьютеры ALTER COLUMN HDD int