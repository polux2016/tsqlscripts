# Here is a scripts that I am use to simplify my work 


**[Script to remove all databases from the server by part of the name](RemoveDBByNamePart/README.md)**

**[Script to backing up all databases from the server by part of the name](BeckupDBByNamePart/README.md)**

**[Script to restore to the latest backup all databases from the server by part of the name](RestoreDBByNamePart/README.md)**

# Plans for improving
- Improving the backup and restore stored procedures
  - Restoring DB with creation from beckups 
  - Work on azure
  - Work with other folder with access checking
  - Work with ftp and shared folders
  - Work with specific bd by prefix or/and creating the backup with specific format
  - Add stored procedure that removes all Beckups accept the assigned ones
- Utils
  - Script to generate a copy of data with/without all dependency tree (with "n" levels)
  - Script that will find value in eny column by text part in table/column/value with generating scripts for search 
  - Scripts to generate CREATE/UPDATE/DELETE for special tables with filtration (WHERE part) 
  - Generating Classes with relations for EF Core 
