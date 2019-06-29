# How to install 
Copy the file [restoredbbynamepart.sql by this link](restoredbbynamepart.sql) and run it on your environment. It will install stored procedure in \[master\] DB.
The latest backup will be taken from the DB Properties. You can find it in "Restore" window for specific DB.
Manually Tested for SQL Server 2017 (14.0)

# How to use
**Get list with DBs to beckup**
```sql
[dbo].sp_restoredbbynamepart '%db_part_name%', 'dbs'
GO
```
**Generate scripts that will beckup the DBs**
```sql
[dbo].sp_restoredbbynamepart '%db_part_name%', 'scripts'
GO
```
**beckup DBs by part of the name**
```sql
[dbo].sp_restoredbbynamepart '%db_part_name%'
GO
```
