# How to install 
Copy the file [fn_splitstringtorows.sql by this link](fn_splitstringtorows.sql) and run it on your environment. It will install stored function in \[master\] DB.
This function will split the string to rows with selected delimeter 
Manually Tested for SQL Server 2017 (14.0)

# How to use
**Split string. Default separator is ','.**
```sql
USE [master]
GO 

SELECT *
FROM [dbo].[fn_splitstringtorows] ('1,22,333,4444', ',')
GO
```
**Result**
| Id|  StartFromIndex | Data  |   
|---|-----------------|-------|
| 1 |0                |1      |   
| 2 |3                |22     |   
| 3 |6                |333    |   
| 3 |10               |4444   |   

