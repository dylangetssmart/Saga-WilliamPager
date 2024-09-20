USE WilliamPagerSA

/*
(1) Copy Rtf2Text.dll to J:\Rtf2Text.dll
(2) Register the dll by executing the script below
(3) Convert to the result
*/

--(2)--

EXEC sp_configure 'clr strict security', 0;
RECONFIGURE;
GO

sp_configure 'clr enabled', 1
RECONFIGURE WITH OVERRIDE
go

If not exists (select * from sys.assemblies where name='TextFunctions')
Begin
                CREATE ASSEMBLY TextFunctions FROM 'D:\Saga-WilliamPager\Rtf2Text\Rtf2Text\Rtf2Text.dll'
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


----(3)--
/*
select 
    convert(varchar(max),ltrim(replace(
       dbo.RegExReplace(e.notes,'({\\)(.+?)(})|(\\)(.+?)(\b)','')
      ,'}','')
    
      )),e.notes,

    convert(varchar(max),ltrim(replace( dbo.RegExReplace(e.notes,'({\\)(.+?)(})|(\\)(.+?)(\b)','') ,'}','') ))

from [WilliamPagerSaga].[dbo].[NOTE] e 
*/

