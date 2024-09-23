# William Pager Saga Conversion
Conversion project template.

# Restoring the data

- Install [SQL Server 2008 R2 SP2 Express](https://www.microsoft.com/en-us/download/details.aspx?id=30438)
- Restore .bak file to 2008 server

At some point either 2008 or 2022 was complaining that the .mdf/.ldf was in use. The command below was used to restore the db to the 2022 server.

```sql
RESTORE DATABASE WilliamPagerSaga 
FROM DISK = 'D:\Saga-WilliamPager\backups\WilliamPagerSaga_fromSQL2008.bak'
WITH REPLACE;
```


`select * from sma_mst_Tenants where hostname like '%WilliamPager%'`

`data source=72.52.250.51;Initial Catalog=SAWilliamPagerLawConversion;User Id = sa; Password=SAsuper11050; Connection Timeout=10000;Encrypt=False;`
