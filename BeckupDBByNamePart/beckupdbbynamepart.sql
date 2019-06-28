USE [master]
GO

IF OBJECT_ID('[dbo].sp_beckupdbbynamepart') IS NOT NULL
BEGIN
	DROP PROCEDURE [dbo].sp_beckupdbbynamepart 
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		poluhovichandrey@gmail.com
-- Create date: 06/14/2019
-- Description:	Will beckup all databases from the server by part of the name
-- =============================================
CREATE PROCEDURE [dbo].sp_beckupdbbynamepart 
	@PartName nvarchar(124),
	@Mode nvarchar(10) =  'RUN'
AS
BEGIN
	DECLARE @DBMark VARCHAR(8) = '<DBName>'
	DECLARE @BeckupFile NVARCHAR(max) 
	DECLARE @BeckupPath NVARCHAR(4000) 
	DECLARE @TimeMark NVARCHAR(60)
	
	SELECT @TimeMark = 
		REPLACE(
			REPLACE(
				CONVERT(NVARCHAR(60), GETDATE(), 120), 
				' ', '_'), 
			':', '-');
	EXEC master.dbo.xp_instance_regread 
			N'HKEY_LOCAL_MACHINE', 
			N'Software\Microsoft\MSSQLServer\MSSQLServer',N'BackupDirectory', 
			@BeckupPath OUTPUT,  
			'no_output' 
	SET @BeckupFile = @BeckupPath + N'\' + @DBMark + N'_' + @TimeMark

	DECLARE @DelteDBTemplate NVARCHAR(MAX) = 
		'BACKUP DATABASE [' + @DBMark + '] TO  
			DISK = ''' + @BeckupFile + '.bak''
			WITH NOFORMAT, NOINIT,  
			NAME = N''' + @DBMark + '-Full Database Backup'', 
			SKIP, NOREWIND, NOUNLOAD,  STATS = 10
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
