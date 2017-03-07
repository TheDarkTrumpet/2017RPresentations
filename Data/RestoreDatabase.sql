RESTORE DATABASE WorldWideImporters FROM DISK='e:\data\Data\WideWorldImporters-Full.bak'
WITH
   MOVE 'WWI_Primary' TO 'C:\var\opt\mssql\data\WorldWideImporters.mdf',
   MOVE 'WWI_Log' TO 'C:\var\opt\mssql\data\WorldWideImporters_log.ldf',
   MOVE 'WWI_UserData' TO 'C:\var\opt\mssql\data\WorldWideImporters_UserData.ndf',
   MOVE 'WWI_InMemory_Data_1' TO 'C:\var\opt\mssql\data\WideWorldImporters_InMemory_Data_1',
REPLACE
