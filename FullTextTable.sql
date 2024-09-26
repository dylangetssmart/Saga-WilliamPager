DECLARE @tablename nvarchar(max), @columnlist nvarchar(max)

DECLARE @SQLString nvarchar(1000)
DECLARE @keyIndex nvarchar(100)

	    DECLARE cds_cursor CURSOR FOR 
		   SELECT tab, col FROM (
		   VALUES 
		   (N'sma_TRN_Documents',N'docsDescrptn'),
		   (N'sma_TRN_Emails',N'emlsContents,emlsSubject')
		   ) as tableau(tab,col)
	    OPEN cds_cursor  
	    FETCH NEXT FROM cds_cursor INTO @tablename, @columnlist
	    WHILE @@FETCH_STATUS = 0  
	    BEGIN  
	    

set @keyIndex = ISNULL((SELECT TOP 1 convert(nvarchar(100),name) FROM sys.objects
WHERE type = 'PK' 
AND  parent_object_id = OBJECT_ID (@tablename)),
(SELECT TOP 1 convert(nvarchar(100),name) FROM sys.indexes
WHERE is_unique = 1
AND  object_id = OBJECT_ID (@tablename)))

SET @SQLString =
     N'IF NOT EXISTS(SELECT *
		    FROM sys.fulltext_indexes
		    WHERE object_id = OBJECT_ID(N'''+@tablename+N'''))
BEGIN
CREATE FULLTEXT INDEX ON '+@tablename+N'('+@columnlist+N') KEY INDEX ' + @keyIndex +N' ON DocumentsFullTextCatalog
END'

EXEC (@SQLString)

		   FETCH NEXT FROM cds_cursor INTO @tablename, @columnlist
	    END  

	    CLOSE cds_cursor  
 	    DEALLOCATE cds_cursor  

	    DECLARE cds_cursor CURSOR FOR 
		   SELECT tab, col FROM (
		   VALUES 
		   (N'sma_MST_Injury',N'injsDscrptn'),
		   (N'sma_MST_QuickInjury',N'qinsDscrptn'),
		   (N'sma_TRN_CriticalComments',N'ctcsText'),
		   (N'sma_TRN_Defendants',N'defsComments'),
		   (N'sma_TRN_Incidents',N'IncidentFacts,MergedFacts'),
		   (N'sma_TRN_Injury',N'injnOtherInj,injsComments,injsDescription'),
		   (N'sma_TRN_LawFirms',N'lwfsComments,lwfsFileNumber'),
		   (N'sma_TRN_Negotiations',N'negsComments'),
		   (N'sma_TRN_Notes',N'notmPlainText'),
		   (N'sma_TRN_Plaintiff',N'plnsComments'),
		   (N'sma_TRN_PlaintiffInjury',N'plisComment,plisInjuriesSummary,plisPleadingsSummary'),
		   (N'sma_TRN_Settlements',N'stlsComments')
		   ) as tableau(tab,col)
	    OPEN cds_cursor  
	    FETCH NEXT FROM cds_cursor INTO @tablename, @columnlist
	    WHILE @@FETCH_STATUS = 0  
	    BEGIN  

set @keyIndex = ISNULL((SELECT TOP 1 convert(nvarchar(100),name) FROM sys.objects
WHERE type = 'PK' 
AND  parent_object_id = OBJECT_ID (@tablename)),
(SELECT TOP 1 convert(nvarchar(100),name) FROM sys.indexes
WHERE is_unique = 1
AND  object_id = OBJECT_ID (@tablename)))

SET @SQLString =
     N'IF NOT EXISTS(SELECT *
		    FROM sys.fulltext_indexes
		    WHERE object_id = OBJECT_ID(N'''+@tablename+N'''))
BEGIN
CREATE FULLTEXT INDEX ON '+@tablename+N'('+@columnlist+N') KEY INDEX ' + @keyIndex +N' ON FullText_Catalog
END'

EXEC (@SQLString)

		   FETCH NEXT FROM cds_cursor INTO @tablename, @columnlist
	    END  

	    CLOSE cds_cursor  
 	    DEALLOCATE cds_cursor  

	    SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('sma_sp_FullTextSearch_Check','P') IS NOT NULL
BEGIN
    DROP PROCEDURE sma_sp_FullTextSearch_Check
END
GO

-- =============================================
-- Author:		andre
-- Create date: 12/8/2015
-- Description:	Testing for Full Text Search
-- =============================================
CREATE PROCEDURE [dbo].[sma_sp_FullTextSearch_Check]
	@keySearch NVARCHAR(4000)
AS
BEGIN
	SET NOCOUNT ON;
  SELECT count(*) FROM  sma_TRN_Incidents WHERE CONTAINS(IncidentFacts,@keySearch)
END
GO

update sma_MST_AdminParameters set adpbKeyValue = 0 where adpsKeyGroup = 'DocumentSearch' and adpsKeyName = 'EnableSearchInsideDocuments'