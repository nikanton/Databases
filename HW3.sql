--1
SELECT ������������.���������_ID, �������, ���, ��������, count(login_ID) as 'K���������'
FROM  dbo.������������ LEFT JOIN dbo.������������_login ON dbo.������������.���������_ID = dbo.������������_login.���������_ID
GROUP BY dbo.������������.���������_ID, dbo.������������.�������, dbo.������������.���, dbo.������������.��������
--2
SELECT ����������.����_ID, ����������.��������
FROM  ���������� LEFT JOIN ����������_������ ON ����������.����_ID = ����������_������.����_ID
GROUP BY ����������.����_ID, ����������.��������
HAVING COUNT(����������_������.������_ID) = 0
--3
USE test
SELECT ����������.����_ID, ��������
FROM  ���������� LEFT JOIN ����������_������ ON ����������.����_ID = ����������_������.����_ID INNER JOIN ������������_login ON ����������_������.login_ID = ������������_login.login_ID AND ������������_login.login NOT LIKE '%admin%'
GROUP BY ����������.����_ID, ��������
--4
SELECT DISTINCT ������������_login.���������_ID, ����_ID
FROM ����������_������ INNER JOIN ������������_login ON ����������_������.login_ID != ������������_login.login_ID
--5
SET DATEFORMAT dmy
SELECT DISTINCT ������������_login.���������_ID, ����_ID
FROM ����������_������ INNER JOIN ������������_login ON ����������_������.login_ID != ������������_login.login_ID
WHERE ����������_������.������ <= '01.02.17'
--6
SELECT ����������.����_ID
FROM ���������� INNER JOIN ����������_������ ON ����������.����_ID = ����������_������.����_ID
WHERE ����������_������.������ IS NULL
UNION
SELECT ����_ID
FROM ����������
WHERE YEAR(����������) = 2016
--7
SELECT ������������_login.login_ID, ������������_login.login, COUNT(������������_login.login_ID) as '���������� ������'
FROM ������������_login LEFT JOIN ����������_������ ON ������������_login.login_ID = ����������_������.login_ID
GROUP BY ������������_login.login_ID, login
HAVING COUNT(������������_login.login_ID) < 3
--8
DECLARE @����_ID int = 1, @������_ID int = 1
UPDATE ����������_������
SET ������ = GETDATE()
WHERE (����_ID = @����_ID) AND (������_ID = @������_ID) AND (������ IS NULL)
--9
ALTER TABLE ����������
ADD ���v������� int NULL
UPDATE ����������
SET ���v������� = DATEDIFF(MINUTE, ����������_������.�����, ����������_������.������)
FROM ���������� INNER JOIN ����������_������ ON ����������.����_ID = ����������_������.����_ID
--10
DELETE FROM ������������_login 
WHERE login_ID NOT IN(SELECT DISTINCT login_ID FROM ����������_������)
--11
ALTER TABLE ���������� DROP COLUMN ����������
ALTER TABLE ���������� ALTER COLUMN HDD int