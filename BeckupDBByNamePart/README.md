# How to install 
Copy the file [beckupdbbynamepart.sql by this link](beckupdbbynamepart.sql) and run it on your environment. It will install stored procedure in \[master\] DB.
Folder for becking up you can change in Server Properties.
Manually Tested for SQL Server 2017 (14.0)

# How to use
**Get list with DBs to beckup**
```sql
[dbo].sp_beckupdbbynamepart '%db_part_name%', 'dbs'
GO
```
**Generate scripts that will beckup the DBs**
```sql
[dbo].sp_beckupdbbynamepart '%db_part_name%', 'scripts'
GO
```
**beckup DBs by part of the name**
```sql
[dbo].sp_beckupdbbynamepart '%db_part_name%'
GO
```
