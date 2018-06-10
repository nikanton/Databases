--1 Свойства, которые есть у всех групп
DECLARE @groupsCount int = (
	SELECT COUNT(*)
	FROM Users
	WHERE Grp = 1
)

SELECT PropID
FROM Users as U RIGHT JOIN User_properties as P ON U.UserID = P.UserID
WHERE U.Grp = 1
GROUP BY PropID
HAVING COUNT(*) = @groupsCount

--2 Статистика новостей и комментариев по датам
SELECT CONVERT(date, Дата), SUM(Новости) 'Количество новостей', SUM(Комментарии) 'Количество комментариев'
FROM (
SELECT Date_of_comments Дата, 0 Новости, COUNT(*) Комментарии
FROM News_comments
GROUP BY Date_of_comments
UNION
SELECT Date_of_news Дата, COUNT(*) Новости, 0 Комментарии
FROM News
GROUP BY Date_of_news
) AS Tab
GROUP BY CONVERT(date, Дата)

--3 Гистаграмма для числа пользовотелей по числу новостей
DECLARE @step int = 5

SELECT (Колво_новостей / @step) * @step Новостей_от, (Колво_новостей / @step + 1) * @step Новостей_до, COUNT(*) Колво
FROM (
SELECT U.UserID, COUNT(NewsID) Колво_новостей
FROM Users AS U LEFT JOIN News AS N ON U.UserID = N.UserID
GROUP BY U.UserID
) AS T
GROUP BY Колво_новостей / @step

--4 Level_ID, под которыми UserID никогда не публиковал
SELECT DISTINCT N.UserID, V.Level_ID
FROM News AS N CROSS JOIN Visibility_levels AS V
EXCEPT
SELECT DISTINCT UserID, Level_ID
FROM News

--5 Без комментариев после 01-05-2017
SELECT DISTINCT N.UserID, V.Level_ID
FROM News AS N CROSS JOIN Visibility_levels AS V
EXCEPT
SELECT DISTINCT C.Comment_UserID, N.Level_ID
FROM News_comment AS C JOIN News AS N ON (C.NewsID = N.NewsID AND C.Date_of_comments > 2017-05-01)

--6 Уровни видимости с числом публикаций менее 5
SELECT V.Level_ID, V.Level, COUNT(N.NewsID) 'Колво новостей', COUNT(DISTINCT N.UserID) 'Колво уникальных пользователей'
FROM News N JOIN Visibility_levels V ON N.Level_ID = V.Level_ID
GROUP BY V.Level_ID, V.Level
HAVING COUNT(N.NewsID) < 5

--7 Промежутки без новостей
DECLARE @dates TABLE(Дата date)

DECLARE @date date = '2017-04-01'
WHILE @date <= '2017-05-01'
	BEGIN
		INSERT INTO @dates VALUES (@date)
		SET @date = DATEADD(day, 1, @date)
	END

SELECT MIN(Дата), MAX(Дата)
FROM (
SELECT Дата, DATEADD(day, -1*ROW_NUMBER() OVER(ORDER BY Дата), Дата) grp
FROM(
SELECT Дата
FROM
@dates
EXCEPT
SELECT CONVERT(date, Date_of_news)
FROM News
) AS Tab ) AS Tab
GROUP BY grp

--8 Подписчики второго уровня
DECLARE @user int = 1

SELECT DISTINCT @user, S2.UserID
FROM Subscriptions AS S1 INNER JOIN Subscriptions AS S2 ON S1.UserID = S2.SubsID
WHERE S1.SubsID = @user
