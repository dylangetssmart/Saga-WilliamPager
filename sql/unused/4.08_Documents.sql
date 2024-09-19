
use SANeedlesSLF
go

/*
alter table [sma_TRN_Documents] disable trigger all
delete from [sma_TRN_Documents] 
DBCC CHECKIDENT ('[sma_TRN_Documents]', RESEED, 0);
alter table [sma_TRN_Documents] enable trigger all
*/

---(0)----

IF OBJECT_ID (N'dbo.FileNamePart', N'FN') IS NOT NULL
    DROP FUNCTION FileNamePart;
GO
CREATE FUNCTION dbo.FileNamePart(@parameter varchar(MAX) )
RETURNS varchar(MAX) 
AS 

BEGIN
	declare @trimParameter varchar(MAX)=ltrim(rtrim(@parameter));
    DECLARE @return varchar(MAX);
	declare @position int =convert(int,(SELECT CHARINDEX('\', REVERSE (@trimParameter), 0)))
	set @return=substring (right(@trimParameter,@position),2,1000)
    RETURN @return;
END;
GO

---(0)---

IF OBJECT_ID (N'dbo.PathPart', N'FN') IS NOT NULL
    DROP FUNCTION PathPart;
GO
CREATE FUNCTION dbo.PathPart(@parameter varchar(MAX) )
RETURNS varchar(MAX) 
AS 

BEGIN
	declare @trimParameter varchar(MAX)=ltrim(rtrim(@parameter));
    DECLARE @return varchar(MAX);
	if ((len(@trimParameter) + 2 - convert(int,(SELECT CHARINDEX('\', REVERSE (@trimParameter), 0)))) < 0 )
	begin
		set @return=@trimParameter
	end
	else
	begin
		set @return=substring(@trimParameter,0,len(@trimParameter) + 2 - convert(int,(SELECT CHARINDEX('\', REVERSE (@trimParameter), 0))))
	end
		RETURN @return;
END;
GO

---(0)---
INSERT INTO [sma_MST_ScannedDocCategories] ( sctgsCategoryName )
(
SELECT DISTINCT
    Category as sctgsCategoryName 
FROM [NeedlesSLF].[dbo].[documents] where isnull(Category,'')<>''
    UNION
SELECT 'Other'
)
    EXCEPT 
SELECT sctgsCategoryName FROM [sma_MST_ScannedDocCategories]
GO

ALTER TABLE [dbo].[sma_TRN_Documents]
ALTER column [docsToContact] [varchar](120) NULL
GO

----

if not exists (SELECT * FROM sys.columns WHERE Name = N'saga' AND Object_ID = Object_ID(N'sma_TRN_Documents'))
begin
    ALTER TABLE [sma_TRN_Documents] ADD [saga] [varchar](500) NULL; 
end 

GO
----

ALTER TABLE [sma_TRN_Documents] DISABLE TRIGGER ALL
GO
SET QUOTED_IDENTIFIER  ON 

---(1)---


/*
alter table [sma_TRN_Documents] disable trigger all
delete from [sma_TRN_Documents] 
DBCC CHECKIDENT ('[sma_TRN_Documents]', RESEED, 0);
alter table [sma_TRN_Documents] enable trigger all
*/

INSERT INTO [sma_TRN_Documents]
([docnCaseID],[docsDocumentName],[docsDocumentPath],[docsDocumentData],[docnCategoryID],[docnSubCategoryID],[docnFromContactCtgID]
,[docnFromContactID],[docsToContact],[docsDocType],[docnTemplateID],[docbAttachFlag],[docsDescrptn],[docnAuthor],[docsDocsrflag]
,[docnRecUserID],[docdDtCreated],[docnModifyUserID],[docdDtModified],[docnLevelNo],[ctgnCategoryID],[sctnSubCategoryID],[sctssSubSubCategoryID]
,[sctsssSubSubSubCategoryID],[docnMedProvContactctgID],[docnMedProvContactID],[docnComments],[docnReasonReject],[docsReviewerContactId]
,[docsReviewDate],[docsDocumentAnalysisResultId],[docsIsReviewed],[docsToContactID],[docsToContactCtgID],[docdLastUpdated],[docnPriority],[saga])

select 
    CAS.casnCaseID						as [docnCaseID], 
    dbo.FileNamePart(DOC.[file_path])	as [docsDocumentName],
    dbo.PathPart(DOC.[file_path])		as [docsDocumentPath],
    ''									as [docsDocumentData],
    null								as [docnCategoryID],
    null								as [docnSubCategoryID],
    1									as [docnFromContactCtgID],
    null								as docnFromContactID,
    null								as [docsToContact],
    'Doc'								as [docsDocType],
    null								as [docnTemplateID],
    null								as [docbAttachFlag],
    left(DOC.[notes],4000)				as [docsDescrptn],
    0									as [docnAuthor],
    ''									as [docsDocsrflag],
    --(select usrnUserID from sma_MST_Users where saga=DOC.Staff_Created)	as [docnRecUserID],
    --case
	   --when DOC.Date_Added between '1900-01-01' and '2079-06-06' then DOC.Date_Added
	   --else null
    --end						 as [docdDtCreated],

    NULL								as [docnRecUserID],
    null								as [docdDtCreated],
    null								as [docnModifyUserID],
    null								as [docdDtModified],
    ''									as [docnLevelNo],
    case
	   when exists (select * FROM sma_MST_ScannedDocCategories where sctgsCategoryName=DOC.Category) 
		  then (select sctgnCategoryID FROM sma_MST_ScannedDocCategories where sctgsCategoryName=DOC.Category)
	   else (select sctgnCategoryID FROM sma_MST_ScannedDocCategories where sctgsCategoryName='Other/Misc')
    end									as [ctgnCategoryID],
    null								as [sctnSubCategoryID],
    '','','','','','',null,null,null,null,null,null,GETDATE(),
    3									as [docnPriority],  -- normal priority
    null								as [saga]
FROM [NeedlesSLF].[dbo].[documents] DOC
JOIN [sma_TRN_Cases] CAS on CAS.cassCaseNumber=DOC.case_id
GO

ALTER TABLE [sma_TRN_Documents] enable trigger all
GO


/*

select
    DOC.[case_id],
    DOC.[file_path],
    dbo.FileNamePart(DOC.[file_path])	as [docsDocumentName],
    dbo.PathPart(DOC.[file_path])	 as [docsDocumentPath]
FROM [NeedlesSLF].[dbo].[documents] DOC
where case_id=200133

*/

/*
select 
    DOC.Category,
    (select sctgnCategoryID FROM sma_MST_ScannedDocCategories where sctgsCategoryName=DOC.Category),
    case
	   when exists (select * FROM sma_MST_ScannedDocCategories where sctgsCategoryName=DOC.Category) 
		  then (select sctgnCategoryID FROM sma_MST_ScannedDocCategories where sctgsCategoryName=DOC.Category)
	   else (select sctgnCategoryID FROM sma_MST_ScannedDocCategories where sctgsCategoryName='Other')
    end						 as [ctgnCategoryID]
FROM [NeedlesSLF].[dbo].[documents] DOC
*/