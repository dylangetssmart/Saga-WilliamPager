
sp_configure 'clr enabled', 1
RECONFIGURE WITH OVERRIDE
go
alter table WilliamPagerSaga.dbo.WORK_HISTORY_MATTER disable trigger all
GO

/****** Object:  Index [MATTER_MATTERNUMBER]    Script Date: 7/31/2014 10:33:22 PM ******/
DROP INDEX [MATTER_MATTERNUMBER] ON [WilliamPagerSaga].[dbo].[MATTER]
GO

alter table WilliamPagerSaga.dbo.MATTER 
alter column matternumber varchar(20) null
go

/****** Object:  Index [MATTER_MATTERNUMBER]    Script Date: 7/31/2014 10:33:22 PM ******/
CREATE NONCLUSTERED INDEX [MATTER_MATTERNUMBER] ON [WilliamPagerSaga].[dbo].[MATTER]
(
	[MATTERNUMBER] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


If not exists (select * from sys.assemblies where name='TextFunctions')
Begin
--	CREATE ASSEMBLY TextFunctions FROM '\\rahul\shared\Rtf2Text.dll'
	CREATE ASSEMBLY TextFunctions FROM 'E:\$My_Project_Notes\$WorkTools\Rtf2Text\Rtf2Text.dll'
End
If OBJECT_ID('dbo.RegExMatch') IS NOT NULL
  DROP FUNCTION RegExMatch
If OBJECT_ID('dbo.RegExReplace') IS NOT NULL
  DROP FUNCTION RegExReplace  
GO
CREATE FUNCTION RegExMatch( @Input NVARCHAR(max)
,@Pattern NVARCHAR(127)
)
RETURNS BIT

EXTERNAL NAME TextFunctions.RegularExpressions.RegExMatch
GO

CREATE FUNCTION RegExReplace( @Input NVARCHAR(max)
,@Pattern NVARCHAR(127)
,@Replacement NVARCHAR(max)
)
RETURNS NVARCHAR(max)

EXTERNAL NAME TextFunctions.RegularExpressions.RegExReplace
GO

/*
 Declare @CaseID int
 DECLARE @CaseNumber varchar(500)
 DECLARE @SequenceNumber varchar(500)
   
    -- Declare a cursor that will get staff contactid

	
DECLARE samecasenumber_cursor CURSOR FAST_FORWARD FOR 
select distinct MATTERID,FILENUMBER,ROW_NUMBER() OVER (Partition BY FILENUMBER order by FILENUMBER) as SequenceNumber  from WilliamPagerSaga.dbo.MATTER
where FILENUMBER in
(select FILENUMBER from WilliamPagerSaga.dbo.MATTER group by FILENUMBER having count(FILENUMBER)>1) or (matternumber is null and FILENUMBER is null)
order by FILENUMBER,MATTERID asc


--Open a cursor
OPEN samecasenumber_cursor 

FETCH NEXT FROM samecasenumber_cursor INTO @CaseID,@CaseNumber,@SequenceNumber

WHILE @@FETCH_STATUS = 0
BEGIN
 
    
Update WilliamPagerSaga.dbo.MATTER 
set FILENUMBER =isnull(FILENUMBER,'')+' D-'+@SequenceNumber
where MATTERID =@CaseID

FETCH NEXT FROM samecasenumber_cursor INTO @CaseID,@CaseNumber,@SequenceNumber
END

CLOSE samecasenumber_cursor
DEALLOCATE samecasenumber_cursor

 Update WilliamPagerSaga.dbo.MATTER 
 set MATTERNUMBER=filenumber
*/
 alter table WilliamPagerSaga.dbo.WORK_HISTORY_MATTER enable trigger all