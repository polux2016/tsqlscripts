USE [master]
GO

IF OBJECT_ID('[dbo].sp_removedbbynamepart') IS NOT NULL
BEGIN
	DROP PROCEDURE [dbo].sp_removedbbynamepart 
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		poluhovichandrey@gmail.com
-- Create date: 06/14/2019
-- Description:	Will remove all databases from the server by part of the name
-- =============================================
CREATE PROCEDURE [dbo].sp_removedbbynamepart 
	@PartName nvarchar(124),
	@Mode nvarchar(10) =  'RUN'
AS
BEGIN
	DECLARE @DBMark VARCHAR(8) = '<DBName>'
	DECLARE @DelteDBTemplate NVARCHAR(MAX) = 
		'
		EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N''' + @DBMark + '''
		DROP DATABASE [' + @DBMark + ']
		'
	DECLARE @SQL NVARCHAR(MAX) = ''
	DECLARE @DBName NVARCHAR(124)

	DECLARE db_cursor CURSOR FOR 
	SELECT db.[name]
	FROM sys.databases as db
	WHERE db.[name] like @PartName

	OPEN db_cursor

	FETCH NEXT FROM db_cursor 
		INTO @DBName

	WHILE @@FETCH_STATUS = 0
	BEGIN
		
		SET @SQL = REPLACE(@DelteDBTemplate, @DBMark, @DBName)
		IF @Mode = 'dbs' PRINT @DBName
		IF @Mode = 'scripts' PRINT @SQL
		IF @Mode = 'run' EXEC sp_executesql @SQL
		FETCH NEXT FROM db_cursor 
			INTO @DBName
	END

	CLOSE db_cursor  
	DEALLOCATE db_cursor  

END
GO
