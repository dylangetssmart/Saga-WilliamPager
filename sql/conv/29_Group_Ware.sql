USE WilliamPagerSA

ALTER TABLE [sma_TRN_Emails]
ALTER COLUMN [emlsSubject] VARCHAR(2000)
ALTER TABLE [sma_TRN_Emails]
ALTER COLUMN [emlsFromEmailID] VARCHAR(1000)
ALTER TABLE [sma_TRN_Emails]
ALTER COLUMN [emlsOutLookUserEmailID] VARCHAR(1000)
GO
SET ANSI_WARNINGS OFF
INSERT INTO [sma_TRN_Emails]
	(
	[emlnCaseID]
   ,[emlnFrom]
   ,[emlsTableName]
   ,[emlsColumnName]
   ,[emlnRecordID]
   ,[emlsSubject]
   ,[emlsSentReceived]
   ,[emlsContents]
   ,[emlbAcknowledged]
   ,[emldDate]
   ,[emlsFromEmailID]
   ,[emlsOutLookUserEmailID]
   ,[emlnTemplateID]
   ,[emlnPriority]
   ,[emlnRecUserID]
   ,[emldDtCreated]
   ,[emlnModifyUserID]
   ,[emldDtModified]
   ,[emlnLevelNo]
   ,[emlnReviewerContactId]
   ,[emlnReviewDate]
   ,[emlnDocumentAnalysisResultId]
   ,[emlnIsReviewed]
   ,[emlnToContactID]
   ,[emlnToContactCtgID]
   ,[emlnDocPriority]
	)
	SELECT DISTINCT
		casnCaseID
	   ,NULL
	   ,''
	   ,''
	   ,0
	   ,MR.SUBJECT
	   ,CASE MR.INCOMING
			WHEN 'T'
				THEN 'D'
			ELSE 'S'
		END
	   ,
		--CONVERT(nVARCHAR(MAX),cast(WMESSAGE as nvarchar(max))),null,BEGINTIME,WFROM,WTO,0,0,u1.usrnUserID,mr.DATECREATED,u2.usrnUserID,mr.DATEREVISED,'' <-- chinmong comment
		''
	   ,NULL
	   ,BEGINTIME
	   ,WFROM
	   ,WTO
	   ,0
	   ,0
	   ,u1.usrnUserID
		--	   ,MR.DATECREATED
	   ,NULL								-- ds 2024-09-23
	   ,u2.usrnUserID
		--	   ,MR.DATEREVISED
	   ,NULL								-- ds 2024-09-23
	   ,''
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,3
	FROM WilliamPagerSaga.dbo.MATRULE MR
	LEFT JOIN WilliamPagerSaga.dbo.MATTER M
		ON M.MATTERID = MR.MATTERID
	LEFT JOIN sma_TRN_Cases
		ON cassCaseNumber = M.MATTERNUMBER
	LEFT JOIN sma_MST_IndvContacts i1
		ON i1.cinsGrade = MR.CREATORID
	LEFT JOIN sma_MST_Users u1
		ON u1.usrnContactID = i1.cinnContactID
	LEFT JOIN sma_MST_IndvContacts i2
		ON i2.cinsGrade = MR.REVISORID
	LEFT JOIN sma_MST_Users u2
		ON u2.usrnContactID = i2.cinnContactID
	WHERE casnCaseID IS NOT NULL
GO
  