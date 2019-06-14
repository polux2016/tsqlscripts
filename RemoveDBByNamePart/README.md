# How to install 
Copy the file [removedbbynamepart.sql by this link](removedbbynamepart.sql) and run it on your environment. It will install stored procedure in \[master\] DB.

# How to use
**Get list with DBs to remove**
```sql
[dbo].sp_removedbbynamepart '%db_part_name%', 'dbs'
GO
```
**Generate scripts that will remove the DBs**
```sql
[dbo].sp_removedbbynamepart '%db_part_name%', 'scripts'
GO
```
**Remove DBs by part of the name**
```sql
[dbo].sp_removedbbynamepart '%db_part_name%',
GO
```