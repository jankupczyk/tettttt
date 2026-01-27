CREATE LOGIN [DOMAIN\user1] FROM WINDOWS;
CREATE LOGIN [DOMAIN\user2] FROM WINDOWS;

USE TwojaBaza;
GO

CREATE USER [DOMAIN\user1] FOR LOGIN [DOMAIN\user1];
CREATE USER [DOMAIN\user2] FOR LOGIN [DOMAIN\user2];


ALTER ROLE db_datareader ADD MEMBER [DOMAIN\user1];
ALTER ROLE db_datareader ADD MEMBER [DOMAIN\user2];

USE TwojaBaza;
SELECT 
    u.name AS user_name,
    r.name AS role_name
FROM sys.database_role_members drm
JOIN sys.database_principals r ON drm.role_principal_id = r.principal_id
JOIN sys.database_principals u ON drm.member_principal_id = u.principal_id
WHERE u.name IN ('DOMAIN\user1', 'DOMAIN\user2');
