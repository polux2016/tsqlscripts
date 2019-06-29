USE [master]
GO

IF OBJECT_ID('[dbo].sp_restoredbbynamepart') IS NOT NULL
BEGIN
	DROP PROCEDURE [dbo].sp_restoredbbynamepart 
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		poluhovichandrey@gmail.com
-- Create date: 06/28/2019
-- Description:	Will restore to the latest beckup all databases from the server by part of the name.
-- It works well together with sp_beckupdbbynamepart 
-- (https://github.com/polux2016/tsqlscripts/blob/a64f3c8e1a961ce67c9f15966da7b66c0eacee42/BeckupDBByNamePart/beckupdbbynamepart.sql)
-- =============================================
CREATE PROCEDURE [dbo].sp_restoredbbynamepart 
	@PartName nvarchar(124),
	@Mode nvarchar(10) =  'RUN'
AS
BEGIN
	DECLARE @DBMark VARCHAR(8) = '<DBName>'
	DECLARE @PathMark VARCHAR(14) = '<PathToBeckup>'
	DECLARE @BeckupFile NVARCHAR(max) 
	DECLARE @BeckupPath NVARCHAR(4000) 
	
	DECLARE @RestoreDBTemplate NVARCHAR(MAX) = 
		'
			USE [master]
			ALTER DATABASE [' + @DBMark + '] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
			RESTORE DATABASE [' + @DBMark + '] FROM 
				DISK = N''' + @PathMark + ''' 
				WITH  FILE = 1,  NOUNLOAD,  REPLACE,  STATS = 5
			ALTER DATABASE [' + @DBMark + '] SET MULTI_USER
		'
	DECLARE @SQL NVARCHAR(MAX) = ''
	DECLARE @DBName NVARCHAR(124)
	DECLARE @FilePath NVARCHAR(260)--Max NTFC Path length

	DECLARE db_cursor CURSOR FOR 
	SELECT dat.database_name, 
		dat.physical_device_name
	FROM (
		SELECT   
			(ROW_NUMBER() OVER (
				PARTITION BY database_name 
				ORDER BY msdb.dbo.backupset.backup_start_date DESC)) as RN,
			msdb.dbo.backupset.database_name,   
			msdb.dbo.backupmediafamily.physical_device_name,   
			msdb.dbo.backupset.name AS backupset_name
		FROM   msdb.dbo.backupmediafamily  
			INNER JOIN msdb.dbo.backupset ON msdb.dbo.backupmediafamily.media_set_id = msdb.dbo.backupset.media_set_id  
	) as dat
	WHERE RN = 1  
		AND dat.database_name like @PartName

	OPEN db_cursor

	FETCH NEXT FROM db_cursor 
		INTO @DBName, @FilePath

	WHILE @@FETCH_STATUS = 0
	BEGIN
		
		SET @SQL = 
			REPLACE(
				REPLACE(@RestoreDBTemplate, @DBMark, @DBName),
				@PathMark, @FilePath
			);
		IF @Mode = 'dbs' PRINT @DBName
		IF @Mode = 'scripts' PRINT @SQL
		IF @Mode = 'run' EXEC sp_executesql @SQL
		FETCH NEXT FROM db_cursor 
			INTO @DBName, @FilePath
	END

	CLOSE db_cursor  
	DEALLOCATE db_cursor  

END
GO
