--1 Вывод матрицы
DECLARE @ID int = 1

SELECT ID as 'Идентификатор матрицы', X as 'Номер столбца', Y as 'Номер строки', val as 'Значение'
FROM Matrix
WHERE ID = @ID

--2 Вывод транспонированной матрицы
DECLARE @ID int = 1

SELECT ID as 'Идентификатор матрицы', Y as 'Номер столбца', X as 'Номер строки', val as 'Значение'
FROM Matrix
WHERE ID = @ID

--3 Проверка на симметричность
CREATE PROCEDURE 
IsSymmetric
	@ID AS int,
	@ans AS int OUTPUT
AS
	SET @ans =
	(
		SELECT (CASE WHEN COUNT(*) = 0 THEN 1 ELSE 0 END)
		FROM Matrix as orgn JOIN Matrix as transp ON (orgn.ID = transp.ID AND orgn.X = transp.Y AND orgn.Y = transp.X AND orgn.ID = @ID)
		WHERE orgn.val <> transp.val
	)

--4 Вывод матрицы, умноженной на число
CREATE FUNCTION
MultiplyFloat (@ID int, @number float)
RETURNS @Multiplied TABLE (X int, Y int, val float)
AS
BEGIN
	INSERT INTO @Multiplied
	SELECT X, Y, val * @number
	FROM Matrix
	WHERE ID = @ID
RETURN
END

--5 Проверяем является ли матрица вектором
CREATE FUNCTION
IsVector (@ID int)
RETURNS int
AS
BEGIN
	RETURN
	(
		SELECT (CASE WHEN MAX(X) = 1 AND MAX(Y) > 1 THEN 1 ELSE 0 END)
		FROM Matrix
		WHERE ID = @ID
	)
END

--6 Выводит является ли квадратной (да/нет)
CREATE FUNCTION
SizeX (@ID int)
RETURNS int
AS
BEGIN
	RETURN
	(
		SELECT MAX(X)
		FROM Matrix
		WHERE ID = @ID
	)
END

GO

CREATE FUNCTION
SizeY (@ID int)
RETURNS int
AS
BEGIN
	RETURN
	(
		SELECT MAX(Y)
		FROM Matrix
		WHERE ID = @ID
	)
END

GO

DECLARE @ID int = 1

SELECT CASE WHEN dbo.SizeX(@ID) = dbo.SizeY(@ID) THEN 'да' ELSE 'нет' END as 'Результат'

--7 Выводит можно ли сложить две матрицы (да/нет)
CREATE FUNCTION
SizeX (@ID int)
RETURNS int
AS
BEGIN
	RETURN
	(
		SELECT MAX(X)
		FROM Matrix
		WHERE ID = @ID
	)
END
GO
CREATE FUNCTION
SizeY (@ID int)
RETURNS int
AS
BEGIN
	RETURN
	(
		SELECT MAX(Y)
		FROM Matrix
		WHERE ID = @ID
	)
END
GO
DECLARE @ID1 int = 1
DECLARE @ID2 int = 2

SELECT CASE WHEN dbo.SizeX(@ID1) = dbo.SizeX(@ID2) AND dbo.SizeY(@ID1) = dbo.SizeY(@ID2) THEN 'да' ELSE 'нет' END  as 'Результат'

--8 Вывод суммы матриц
CREATE FUNCTION
SizeX (@ID int)
RETURNS int
AS
BEGIN
	RETURN
	(
		SELECT MAX(X)
		FROM Matrix
		WHERE ID = @ID
	)
END
GO
CREATE FUNCTION
SizeY (@ID int)
RETURNS int
AS
BEGIN
	RETURN
	(
		SELECT MAX(Y)
		FROM Matrix
		WHERE ID = @ID
	)
END
GO
DECLARE @ID1 int = 1
DECLARE @ID2 int = 2

IF dbo.SizeX(@ID1) = dbo.SizeX(@ID2) AND dbo.SizeY(@ID1) = dbo.SizeY(@ID2) (
SELECT fir.X  as 'Номер строки', fir.Y as 'Номер столбца', fir.val + sec.val as 'Значение'
FROM Matrix as fir JOIN Matrix as sec ON (fir.ID = @ID1 AND sec.ID = @ID2 AND fir.X = sec.X AND fir.Y = sec.Y)
)

--9 Проверка на возможность перемножения (да/нет)
CREATE FUNCTION
SizeX (@ID int)
RETURNS int
AS
BEGIN
	RETURN
	(
		SELECT MAX(X)
		FROM Matrix
		WHERE ID = @ID
	)
END
GO
CREATE FUNCTION
SizeY (@ID int)
RETURNS int
AS
BEGIN
	RETURN
	(
		SELECT MAX(Y)
		FROM Matrix
		WHERE ID = @ID
	)
END
GO
DECLARE @ID1 int = 1
DECLARE @ID2 int = 2

SELECT CASE WHEN dbo.SizeX(@ID1) = dbo.SizeY(@ID2) THEN 'да' ELSE 'нет' END  as 'Результат'

--10 Перемножение матриц
CREATE FUNCTION
SizeX (@ID int)
RETURNS int
AS
BEGIN
	RETURN
	(
		SELECT MAX(X)
		FROM Matrix
		WHERE ID = @ID
	)
END
GO
CREATE FUNCTION
SizeY (@ID int)
RETURNS int
AS
BEGIN
	RETURN
	(
		SELECT MAX(Y)
		FROM Matrix
		WHERE ID = @ID
	)
END
GO
DECLARE @ID1 int = 1
DECLARE @ID2 int = 2

IF dbo.SizeX(@ID1) = dbo.SizeY(@ID2)(
	SELECT sec.X as X, fir.Y as Y, SUM(fir.val * sec.val) as val
	FROM Matrix as fir JOIN Matrix as sec ON (fir.ID = @ID1 AND sec.ID = @ID2 AND fir.X = sec.Y)
	GROUP BY sec.X, fir.Y
)

--11 Нечётные строки и чётные столбцы
DECLARE @ID int = 1

SELECT X / 2 as X, (Y + 1) / 2 as Y, val
FROM Matrix
WHERE ID = @ID AND X % 2 = 0 AND Y % 2 = 1

--12 Уравнение с ортоганальной матрицей
CREATE FUNCTION
SizeX (@ID int)
RETURNS int
AS
BEGIN
	RETURN
	(
		SELECT MAX(X)
		FROM Matrix
		WHERE ID = @ID
	)
END
GO
CREATE FUNCTION
SizeY (@ID int)
RETURNS int
AS
BEGIN
	RETURN
	(
		SELECT MAX(Y)
		FROM Matrix
		WHERE ID = @ID
	)
END
GO
DECLARE @A int = 1
DECLARE @B int = 2

IF dbo.SizeY(@A) = dbo.SizeY(@B)(
	SELECT sec.X as X, fir.X as Y, SUM(fir.val * sec.val) as val
	FROM Matrix as fir JOIN Matrix as sec ON (fir.ID = @A AND sec.ID = @B AND fir.Y = sec.Y)
	GROUP BY sec.X, fir.X
)

--13 Значения в выбранных ячейках
DECLARE @D int = 3 --ID матрицы с координатами в таблице

DECLARE @T TABLE (X int, Y int)
INSERT INTO @T
SELECT A.val, B.val
FROM Matrix as A JOIN Matrix as B ON (A.ID = @D AND B.ID = @D AND A.X = B.X AND A.Y = 1 AND B.Y = 2)

DECLARE @Matr int = 1

SELECT Matrix.val
FROM @T as A JOIN Matrix ON (A.X = Matrix.X AND A.Y = Matrix.Y AND Matrix.ID = @Matr)
