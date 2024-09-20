USE WilliamPagerSA

/*
alter table [dbo].[sma_TRN_Documents] disable trigger all
delete from [dbo].[sma_TRN_Documents] 
DBCC CHECKIDENT ('[dbo].[sma_TRN_Documents]', RESEED, 0);
alter table [dbo].[sma_TRN_Documents] enable trigger all
*/


INSERT INTO [sma_MST_ScannedDocCategories]
	(
	[sctgsCategoryCode]
   ,[sctgsCategoryName]
   ,[sctgnRecUserID]
   ,[sctgdDtCreated]
   ,[sctgnModifyUserID]
   ,[sctgdDtModified]
	)
	SELECT
		CODE
	   ,SUBSTRING(DESCRIPTION, 0, 50)
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	FROM [WilliamPagerSaga].dbo.DOCCAT
	WHERE NOT EXISTS (
			SELECT
				ctgsCategoryName
			FROM sma_MST_CategoriesNew
			WHERE ctgsCategoryName = DESCRIPTION
		)
GO
--INSERT INTO [sma_MST_ScannedSubCategories]
--([sctgnCategoryID],[scanSubCategoryCode],[scanSubCategoryName],[scanRecUserID],[scanDtCreated],[scanModifyUserID],[scanDtModified])     
--Select distinct sctgnCategoryID,CODE,DESCRIPTION,368,GETDATE(),null,null from [WilliamPagerSaga].dbo.DOCCAT
--join [sma_MST_ScannedDocCategories] on [sctgsCategoryName]=DESCRIPTION
--where not exists(select b.[sctgsCategoryName] from [sma_MST_ScannedSubCategories] a join [sma_MST_ScannedDocCategories] b on a.sctgnCategoryID=b.[sctgnCategoryID] where b.[sctgsCategoryName]=DESCRIPTION)

INSERT INTO [sma_MST_ScannedSubCategories]
	(
	[sctgnCategoryID]
   ,[scanSubCategoryCode]
   ,[scanSubCategoryName]
   ,[scanRecUserID]
   ,[scanDtCreated]
   ,[scanModifyUserID]
   ,[scanDtModified]
	)
	SELECT DISTINCT
		sctgnCategoryID
	   ,''
	   ,SUBSTRING(dType.DESCRIPTION, 0, 50)
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	FROM [WilliamPagerSaga].dbo.document d
	LEFT JOIN [WilliamPagerSaga].dbo.DOCCAT dcat
		ON d.CategoryID = dcat.CategoryID
	LEFT JOIN [WilliamPagerSaga].dbo.doctype dType
		ON d.TYPEID = dType.TypeID
	LEFT JOIN [sma_MST_ScannedDocCategories] s1
		ON dcat.DESCRIPTION = [sctgsCategoryName]
GO
ALTER TABLE sma_trn_documents DISABLE TRIGGER ALL

SET QUOTED_IDENTIFIER ON;
GO

INSERT INTO [sma_TRN_Documents]
	(
	[docnCaseID]
   ,[docsDocumentName]
   ,[docsDocumentPath]
   ,[docsDocumentData]
   ,[docnCategoryID]
   ,[docnSubCategoryID]
   ,[docnFromContactCtgID]
   ,[docnFromContactID]
   ,[docsToContact]
   ,[docsDocType]
   ,[docnTemplateID]
   ,[docbAttachFlag]
   ,[docsDescrptn]
   ,[docnAuthor]
   ,[docsDocsrflag]
   ,[docnRecUserID]
   ,[docdDtCreated]
   ,[docnModifyUserID]
   ,[docdDtModified]
   ,[docnLevelNo]
   ,[ctgnCategoryID]
   ,[sctnSubCategoryID]
   ,[sctssSubSubCategoryID]
   ,[sctsssSubSubSubCategoryID]
   ,[docnMedProvContactctgID]
   ,[docnMedProvContactID]
   ,[docnComments]
   ,[docnReasonReject]
   ,[docsReviewerContactId]
   ,[docsReviewDate]
   ,[docsDocumentAnalysisResultId]
   ,[docsIsReviewed]
   ,[docsToContactID]
   ,[docsToContactCtgID]
   ,[docdLastUpdated]
   ,[docnPriority]
	)
	SELECT DISTINCT
		casnCaseID
	   ,SUBSTRING(FILENAME, 0, 200)
	   ,SUBSTRING(PATH, 0, 1000)
	   ,''
	   ,s1.sctgnCategoryID
	   ,s2.scanSubCategoryID
	   ,CASE
			WHEN froml.cinnContactID IS NOT NULL
				THEN 1
			WHEN fromo.connContactID IS NOT NULL
				THEN 2
		END
	   ,CASE
			WHEN froml.cinnContactID IS NOT NULL
				THEN froml.cinnContactID
			WHEN fromo.connContactID IS NOT NULL
				THEN fromo.connContactID
		END
	   ,''
	   ,'Doc'
	   ,NULL
	   ,NULL
	   ,SUBSTRING(d.DESCRIPTION, 0, 200)
	   ,0
	   ,''
	   ,u1.usrnUserID
	   ,CASE ISDATE(d.datecreated)
			WHEN 0
				THEN GETDATE()
			ELSE (d.datecreated)
		END
	   ,u2.usrnUserID
	   ,CASE
			WHEN DOCDATE BETWEEN '1/1/1900' AND '12/31/2079'
				THEN DOCDATE
		END
	   ,''
	   ,s1.sctgnCategoryID
	   ,s2.scanSubCategoryid
	   ,''
	   ,''
	   ,''
	   ,''
	   ,''
	   ,''
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,d.DATEREVISED
	   ,3
	FROM [WilliamPagerSaga].dbo.document d
	LEFT JOIN [WilliamPagerSaga].dbo.MATTER m
		ON m.MATTERID = d.MATTERID
	LEFT JOIN [WilliamPagerSaga].dbo.entities e
		ON d.AUTHORID = e.entityid
	LEFT JOIN [WilliamPagerSaga].dbo.DOCCAT dcat
		ON d.CategoryID = dcat.CategoryID
	LEFT JOIN [WilliamPagerSaga].dbo.Docent r
		ON d.documentid = r.documentid
	LEFT JOIN [WilliamPagerSaga].dbo.doctype dType
		ON d.TYPEID = dType.TypeID
	LEFT JOIN [WilliamPagerSaga].dbo.LW_A_MATTERTYPE LMT
		ON m.MATTERTYPEID = LMT.MATTERTYPEID
	LEFT JOIN sma_trn_cases
		ON cassCaseNumber = m.MATTERNUMBER
	LEFT JOIN sma_MST_IndvContacts l
		ON l.cinsGrade = d.CREATORID
	LEFT JOIN sma_mst_users u1
		ON u1.usrnContactID = l.cinnContactID
	LEFT JOIN sma_MST_IndvContacts g
		ON g.cinsGrade = d.REVISORID
	LEFT JOIN sma_mst_users u2
		ON u2.usrnContactID = g.cinnContactID
	LEFT JOIN sma_MST_IndvContacts froml
		ON froml.cinsGrade = d.AUTHORID
	LEFT JOIN sma_MST_OrgContacts fromo
		ON fromo.connLevelNo = d.AUTHORID
	LEFT JOIN [sma_MST_ScannedDocCategories] s1
		ON SUBSTRING(dcat.DESCRIPTION, 0, 50) = [sctgsCategoryName]
	LEFT JOIN [sma_MST_ScannedSubCategories] s2
		ON s2.sctgnCategoryID = s1.sctgnCategoryID
			AND SUBSTRING(dType.DESCRIPTION, 0, 50) = s2.scanSubCategoryName
	WHERE casnCaseID IS NOT NULL

GO

SET QUOTED_IDENTIFIER OFF;

ALTER TABLE sma_trn_documents ENABLE TRIGGER ALL



GO

IF EXISTS (
		SELECT
			*
		FROM sys.foreign_keys
		WHERE object_id = OBJECT_ID(N'[dbo].[FK_sma_TRN_MassMailing_sma_MST_Templates]')
			AND parent_object_id = OBJECT_ID(N'[dbo].[sma_TRN_MassMailing]')
	)
	ALTER TABLE [dbo].[sma_TRN_MassMailing] DROP CONSTRAINT [FK_sma_TRN_MassMailing_sma_MST_Templates]
GO

TRUNCATE TABLE sma_MST_Templates
GO

ALTER TABLE [dbo].[sma_TRN_MassMailing] WITH CHECK ADD CONSTRAINT [FK_sma_TRN_MassMailing_sma_MST_Templates] FOREIGN KEY ([masmailTemplateID])
REFERENCES [dbo].[sma_MST_Templates] ([tmlnTemplateId])
GO

ALTER TABLE [dbo].[sma_TRN_MassMailing] CHECK CONSTRAINT [FK_sma_TRN_MassMailing_sma_MST_Templates]
GO


INSERT INTO [dbo].[sma_MST_ScannedSubCategories]
	(
	[sctgnCategoryID]
   ,[scanSubCategoryCode]
   ,[scanSubCategoryName]
   ,[scanRecUserID]
   ,[scanDtCreated]
   ,[scanModifyUserID]
   ,[scanDtModified]
	)
	SELECT
		d.sctgnCategoryID
	   ,UPPER(SUBSTRING(c.DESCRIPTION, 0, 5))
	   ,SUBSTRING(c.DESCRIPTION, 0, 50)
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	FROM [WilliamPagerSaga].dbo.DOCTEMPL a
	LEFT JOIN [WilliamPagerSaga].[dbo].[DOCTYPE] c
		ON c.TYPEID = a.TYPEID
	LEFT JOIN [WilliamPagerSaga].dbo.DOCCAT b
		ON a.CATEGORYID = b.CATEGORYID
	LEFT JOIN sma_MST_ScannedDocCategories d
		ON sctgsCategoryName = SUBSTRING(b.DESCRIPTION, 0, 50)
	LEFT JOIN [sma_MST_ScannedSubCategories] e
		ON d.sctgnCategoryID = e.sctgnCategoryID
			AND [scanSubCategoryName] = SUBSTRING(c.DESCRIPTION, 0, 50)
	WHERE NOT EXISTS (
			SELECT
				*
			FROM [sma_MST_ScannedSubCategories] f
			WHERE e.scanSubCategoryID = f.scanSubCategoryID
		)
		AND d.sctgnCategoryID IS NOT NULL
		AND ISNULL(SUBSTRING(c.DESCRIPTION, 0, 50), '') <> ''

ALTER TABLE sma_mst_templates
ALTER COLUMN [tmlsTemplateName] VARCHAR(250)
INSERT INTO [sma_MST_Templates]
	(
	[tmlsTemplateName]
   ,[tmlsTemplateData]
   ,[tmlnCategoryID]
   ,[tmlnSubCategoryID]
   ,[tmldDtCreated]
   ,[tmlnRecUserId]
   ,[tmldDtModified]
   ,[tmlnModifyUserId]
   ,[tmlnLevelNo]
   ,[tmpsmrgCodeID]
   ,[tmlnnCategoryID]
   ,[tmlnnSubCategoryID]
   ,[tmlnSubSubCategoryID]
   ,[tmlnSubSubSubCategoryID]
   ,[tmlnIsMassMailing]
   ,[tmlnTemplateCaseGroup]
   ,[tmlnEnvelopeTemplateID]
   ,[tmlnIsArchived]
	)

	SELECT
		a.DESCRIPTION
	   ,CASE
			WHEN FRMFILE LIKE '%.%'
				THEN REPLACE(REPLACE(FRMFILE, '.frm', '.Doc'), '.wpd', '.Doc')
			ELSE CASE
					WHEN filename LIKE '%.%'
						THEN LEFT(FILENAME, CHARINDEX('.', FILENAME) - 1) + '.doc'
					ELSE filename + '.doc'
				END
		END
	   ,NULL
	   ,NULL
	   ,GETDATE()
	   ,368
	   ,NULL
	   ,NULL
	   ,''
	   ,''
	   ,CASE
			WHEN d.sctgnCategoryID IS NOT NULL
				THEN d.sctgnCategoryID
			ELSE 52
		END
	   ,CASE
			WHEN e.scanSubCategoryID IS NOT NULL
				THEN e.scanSubCategoryID
			ELSE 371
		END
	   ,''
	   ,''
	   ,''
	   ,''
	   ,NULL
	   ,''
	FROM [WilliamPagerSaga].dbo.DOCTEMPL a
	LEFT JOIN [WilliamPagerSaga].dbo.CMPNNTS z
		ON z.DESCRIPTION = a.DESCRIPTION
	LEFT JOIN [WilliamPagerSaga].[dbo].[DOCTYPE] c
		ON c.TYPEID = a.TYPEID
	LEFT JOIN [WilliamPagerSaga].dbo.DOCCAT b
		ON a.CATEGORYID = b.CATEGORYID
	LEFT JOIN sma_MST_ScannedDocCategories d
		ON sctgsCategoryName = SUBSTRING(b.DESCRIPTION, 0, 50)
	LEFT JOIN [sma_MST_ScannedSubCategories] e
		ON d.sctgnCategoryID = e.sctgnCategoryID
			AND [scanSubCategoryName] = SUBSTRING(c.DESCRIPTION, 0, 50)
	WHERE CASE
			WHEN FRMFILE IS NOT NULL
				THEN REPLACE(REPLACE(FRMFILE, '.frm', '.Doc'), '.wpd', '.Doc')
			ELSE REPLACE(REPLACE(REPLACE(FILENAME, '.frm', '.Doc'), '.wpd', '.Doc'), '.do', '.doc')
		END IS NOT NULL
GO
INSERT INTO [sma_MST_Templates]
	(
	[tmlsTemplateName]
   ,[tmlsTemplateData]
   ,[tmlnCategoryID]
   ,[tmlnSubCategoryID]
   ,[tmldDtCreated]
   ,[tmlnRecUserId]
   ,[tmldDtModified]
   ,[tmlnModifyUserId]
   ,[tmlnLevelNo]
   ,[tmpsmrgCodeID]
   ,[tmlnnCategoryID]
   ,[tmlnnSubCategoryID]
   ,[tmlnSubSubCategoryID]
   ,[tmlnSubSubSubCategoryID]
   ,[tmlnIsMassMailing]
   ,[tmlnTemplateCaseGroup]
   ,[tmlnEnvelopeTemplateID]
   ,[tmlnIsArchived]
	)

	SELECT
		DESCRIPTION
	   ,REPLACE(REPLACE(FRMFILE, '.frm', '.Doc'), '.wpd', '.Doc')
	   ,NULL
	   ,NULL
	   ,GETDATE()
	   ,368
	   ,NULL
	   ,NULL
	   ,''
	   ,''
	   ,52
	   ,371
	   ,''
	   ,''
	   ,''
	   ,''
	   ,''
	   ,''
	FROM [WilliamPagerSaga].dbo.CMPNNTS
	WHERE COMPONENTTYPEID = 14
		AND NOT EXISTS (
			SELECT
				*
			FROM sma_mst_templates
			WHERE tmlsTemplateName = DESCRIPTION
		)
		AND NOT EXISTS (
			SELECT
				*
			FROM sma_mst_templates
			WHERE CONVERT(VARCHAR(MAX), tmlsTemplateData) = REPLACE(REPLACE(FRMFILE, '.frm', '.Doc'), '.wpd', '.Doc')
		)


GO