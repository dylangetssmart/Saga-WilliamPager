USE WilliamPagerSA

INSERT INTO [sma_MST_DisbursmentType]
	(
	[disnTypeCode]
   ,[dissTypeName]
   ,[disnRecUserID]
   ,[disnDtCreated]
   ,[disnModifyUserID]
   ,[disnDtModified]
   ,[disnLevelNo]
	)
	SELECT
		CODE
	   ,LTRIM(RTRIM(CONVERT(VARCHAR(100), (DESCRIPTION))))
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM WilliamPagerSaga.dbo.TRANSACT
	WHERE LTRIM(RTRIM(CONVERT(VARCHAR(100), (DESCRIPTION)))) NOT IN (
			SELECT
				LTRIM(RTRIM(disstypename))
			FROM sma_MST_DisbursmentType
		)


ALTER TABLE [sma_TRN_Disbursement]
ALTER COLUMN [dissDescription] VARCHAR(8000)
INSERT INTO [sma_TRN_Disbursement]
	(
	[disnCaseID]
   ,[disdCheckDt]
   ,[dissCheckNo__]
   ,[disnAmount__]
   ,[disbIsLinior]
   ,[disnPayeeContactCtgID]
   ,[disnPayeeContactID]
   ,[dissDescription__]
   ,[disnPlaintiffID]
   ,[disnShareAcrossPlaintiffs]
   ,[disnEqualWeighted]
   ,[disnRecoverable]
   ,[disnWaived]
   ,[dissComments__]
   ,[disbDocAttachedFlag]
   ,[disnRecUserID]
   ,[disdDtCreated]
   ,[disnModifyUserID]
   ,[disdDtModified]
   ,[disnLevelNo]
   ,[dissGeneralLedger__]
   ,[dissDisbursementType]
   ,[dissQukBkName]
   ,[dissCheckNo]
   ,[disnAmount]
   ,[dissDescription]
   ,[dissComments]
   ,[dissGeneralLedger]
   ,[dissInvoiceNumber]
   ,[disdCheckMailedD]
   ,[UniquePayeeID]
	)
	SELECT
		casnCaseID
	   ,CASE
			WHEN t.tdate BETWEEN '1/1/1900' AND '12/31/2079'
				THEN t.tdate
		END
	   ,t.CHECKNUMBER
	   ,NULL
	   ,''
	   ,CASE
			WHEN cinnContactID IS NOT NULL
				THEN 1
			WHEN connContactID IS NOT NULL
				THEN 2
		END
	   ,CASE
			WHEN cinnContactID IS NOT NULL
				THEN cinnContactID
			WHEN connContactID IS NOT NULL
				THEN connContactID
		END
	   ,NULL
	   ,NULL
	   ,NULL
	   ,0
	   ,CASE BSTATUS
			WHEN 'b'
				THEN 1
			WHEN 'h'
				THEN 1
			WHEN 'c'
				THEN 1
			ELSE 0
		END
	   ,CASE BSTATUS
			WHEN 'N'
				THEN 1
			ELSE 0
		END
	   ,''
	   ,''
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	   ,''
	   ,disnTypeID
	   ,''
	   ,CHECKNUMBER
	   ,CAST(AMOUNTCHARGED AS FLOAT)
	   ,ISNULL(CONVERT(VARCHAR(4000), t.DESCRIPTION), '') + CHAR(13) + ISNULL(CONVERT(VARCHAR(4000), ts.DESCRIPTION), '')
	   ,''
	   ,''
	   ,''
	   ,NULL
	   ,CAST(CASE
			WHEN cinnContactID IS NOT NULL
				THEN 1
			WHEN connContactID IS NOT NULL
				THEN 2
		END AS VARCHAR) + CAST(CASE
			WHEN cinnContactID IS NOT NULL
				THEN cinnContactID
			WHEN connContactID IS NOT NULL
				THEN connContactID
		END AS VARCHAR)
	FROM WilliamPagerSaga.dbo.TRANSACT ts
	LEFT JOIN WilliamPagerSaga.dbo.timeslip t
		ON t.TRANSACTIONID = ts.TRANSACTIONID
	LEFT JOIN WilliamPagerSaga.dbo.matter m
		ON m.MATTERID = t.MATTERID
	LEFT JOIN sma_trn_cases
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_DisbursmentType
		ON LTRIM(RTRIM(disstypename)) = LTRIM(RTRIM(CONVERT(VARCHAR(100), (ts.[description]))))
	LEFT JOIN sma_MST_IndvContacts i1
		ON LTRIM(RTRIM(i1.cinsGrade)) = t.PAIDID
	LEFT JOIN sma_MST_OrgContacts o1
		ON LTRIM(RTRIM(o1.connLevelNo)) = t.PAIDID
	WHERE ISNULL(t.AMODE, 'e') <> 'T'

GO

INSERT INTO [dbo].[sma_TRN_CaseUserTime]
	(
	[cutnCaseID]
   ,[cutnStaffID]
   ,[cutnActivityID]
   ,[cutdFromDtTime]
   ,[cutdToDtTime]
   ,[cutsDuration]
   ,[cutnBillingRate]
   ,[cutnBillingAmt]
   ,[cutsComments]
   ,[cutnRecUserID]
   ,[cutdDtCreated]
   ,[cutnModifyUserID]
   ,[cutdDtModified]
   ,[cutnLevelNo]
   ,[cutnAddTime]
   ,[cutnPlaintiffID]
   ,[cutbSharedExpenses]
	)
	SELECT
		casnCaseID
	   ,u1.usrnContactID
	   ,0
	   ,timein
	   ,timeout
	   ,hours
	   ,ratecharged
	   ,CAST(AMOUNTCHARGED AS FLOAT)
	   ,ISNULL(CONVERT(VARCHAR(4000), t.DESCRIPTION), '') + CHAR(13) + ISNULL(CONVERT(VARCHAR(4000), ts.DESCRIPTION), '')
	   ,u3.usrnUserID
	   ,t.DATECREATED
	   ,u4.usrnContactID
	   ,t.DATEREVISED
	   ,NULL
	   ,1
	   ,plnnPlaintiffID
	   ,0
	FROM WilliamPagerSaga.dbo.TRANSACT ts
	LEFT JOIN WilliamPagerSaga.dbo.timeslip t
		ON t.TRANSACTIONID = ts.TRANSACTIONID
	LEFT JOIN WilliamPagerSaga.dbo.matter m
		ON m.MATTERID = t.MATTERID
	LEFT JOIN sma_MST_IndvContacts i2
		ON i2.cinsGrade = t.ENTITYID
	LEFT JOIN sma_MST_Users u1
		ON u1.usrnContactID = i2.cinnContactID
	LEFT JOIN sma_MST_IndvContacts i3
		ON i3.cinsGrade = t.CREATORID
	LEFT JOIN sma_MST_Users u3
		ON u3.usrnContactID = i3.cinnContactID
	LEFT JOIN sma_MST_IndvContacts i4
		ON i4.cinsGrade = t.REVISORID
	LEFT JOIN sma_MST_Users u4
		ON u4.usrnContactID = i4.cinnContactID
	LEFT JOIN sma_trn_cases
		ON cassCaseNumber = LTRIM(RTRIM(MATTERNUMBER))
	LEFT JOIN sma_trn_plaintiff
		ON plnncaseid = casncaseid
			AND plnbisprimary = 1
	WHERE t.AMODE = 'T'
		AND timein BETWEEN '1/1/1900' AND '12/31/2079'