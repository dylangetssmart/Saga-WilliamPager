USE WilliamPagerSA

--SAGA Disposition Information
INSERT INTO [sma_MST_UDFDefinition]
	(
	[udfsUDFCtg]
   ,[udfnRelatedPK]
   ,[udfsUDFName]
   ,[udfsScreenName]
   ,[udfsType]
   ,[udfsLength]
   ,[udfsFormat]
   ,[udfsTableName]
   ,[udfsNewValues]
   ,[udfsDefaultValue]
   ,[udfnSortOrder]
   ,[udfbIsActive]
   ,[udfnRecUserID]
   ,[udfnDtCreated]
   ,[udfnModifyUserID]
   ,[udfnDtModified]
   ,[udfnLevelNo]
   ,[udfbIsSystem]
	)
	SELECT
		'C'
	   ,cstnCaseTypeID
	   ,'Settlement/Award Date'
	   ,'Case'
	   ,'Date'
	   ,500
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,1
	   ,1
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,1
	   ,NULL
	FROM WilliamPagerSaga.dbo.LAWTYPE
	LEFT JOIN sma_MST_CaseType
		ON cstsType = DESCRIPTION
	UNION
	SELECT
		'C'
	   ,cstnCaseTypeID
	   ,'Settlement/Award Amount'
	   ,'Case'
	   ,'Text'
	   ,500
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,2
	   ,1
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,1
	   ,NULL
	FROM WilliamPagerSaga.dbo.LAWTYPE
	LEFT JOIN sma_MST_CaseType
		ON cstsType = DESCRIPTION
	UNION
	SELECT
		'C'
	   ,cstnCaseTypeID
	   ,'Final Payment Date'
	   ,'Case'
	   ,'Date'
	   ,500
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,3
	   ,1
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,1
	   ,NULL
	FROM WilliamPagerSaga.dbo.LAWTYPE
	LEFT JOIN sma_MST_CaseType
		ON cstsType = DESCRIPTION
	UNION
	SELECT
		'C'
	   ,cstnCaseTypeID
	   ,'Unsettled Case Disbursement'
	   ,'Case'
	   ,'Text'
	   ,500
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,4
	   ,1
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,1
	   ,NULL
	FROM WilliamPagerSaga.dbo.LAWTYPE
	LEFT JOIN sma_MST_CaseType
		ON cstsType = DESCRIPTION
	UNION
	SELECT
		'C'
	   ,cstnCaseTypeID
	   ,'Unsettled Liens'
	   ,'Case'
	   ,'Text'
	   ,500
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,5
	   ,1
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,1
	   ,NULL
	FROM WilliamPagerSaga.dbo.LAWTYPE
	LEFT JOIN sma_MST_CaseType
		ON cstsType = DESCRIPTION
	UNION
	SELECT
		'C'
	   ,cstnCaseTypeID
	   ,'Unsettled Plaintiff Disbursement'
	   ,'Case'
	   ,'Text'
	   ,500
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,6
	   ,1
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,1
	   ,NULL
	FROM WilliamPagerSaga.dbo.LAWTYPE
	LEFT JOIN sma_MST_CaseType
		ON cstsType = DESCRIPTION
	UNION
	SELECT
		'C'
	   ,cstnCaseTypeID
	   ,'Closed Date'
	   ,'Case'
	   ,'Date'
	   ,500
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,7
	   ,1
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,1
	   ,NULL
	FROM WilliamPagerSaga.dbo.LAWTYPE
	LEFT JOIN sma_MST_CaseType
		ON cstsType = DESCRIPTION
	UNION
	SELECT
		'C'
	   ,cstnCaseTypeID
	   ,'Closed File#'
	   ,'Case'
	   ,'Text'
	   ,500
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,8
	   ,1
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,1
	   ,NULL
	FROM WilliamPagerSaga.dbo.LAWTYPE
	LEFT JOIN sma_MST_CaseType
		ON cstsType = DESCRIPTION
	UNION
	SELECT
		'C'
	   ,cstnCaseTypeID
	   ,'Closed File Location'
	   ,'Case'
	   ,'Text'
	   ,1000
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,9
	   ,1
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,1
	   ,NULL
	FROM WilliamPagerSaga.dbo.LAWTYPE
	LEFT JOIN sma_MST_CaseType
		ON cstsType = DESCRIPTION
--------------------------------------------------------------------

INSERT INTO [sma_TRN_UDFValues]
	(
	[udvnUDFID]
   ,[udvsScreenName]
   ,[udvsUDFCtg]
   ,[udvnRelatedID]
   ,[udvnSubRelatedID]
   ,[udvsUDFValue]
   ,[udvnRecUserID]
   ,[udvdDtCreated]
   ,[udvnModifyUserID]
   ,[udvdDtModified]
   ,[udvnLevelNo]
	)
	SELECT DISTINCT
		udfnUDFID
	   ,'Case'
	   ,'C'
	   ,casnCaseID
	   ,0
	   ,CLOSEDMATTERNUMBER
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM WilliamPagerSaga.dbo.MATTER a
	LEFT JOIN WilliamPagerSaga.dbo.LW_MATTER b
		ON a.MATTERID = b.MATTERID
	LEFT JOIN sma_trn_cases
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = casnOrgCaseTypeID
	WHERE udfsUDFName = 'Closed File#'
		AND ISNULL(CLOSEDMATTERNUMBER, '') <> ''
	UNION
	SELECT DISTINCT
		udfnUDFID
	   ,'Case'
	   ,'C'
	   ,casnCaseID
	   ,0
	   ,CLOSEDFILELOCATION
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM WilliamPagerSaga.dbo.MATTER a
	LEFT JOIN WilliamPagerSaga.dbo.LW_MATTER b
		ON a.MATTERID = b.MATTERID
	LEFT JOIN sma_trn_cases
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = casnOrgCaseTypeID
	WHERE udfsUDFName = 'Closed File Location'
		AND ISNULL(CLOSEDFILELOCATION, '') <> ''


INSERT INTO [sma_TRN_UDFValues]
	(
	[udvnUDFID]
   ,[udvsScreenName]
   ,[udvsUDFCtg]
   ,[udvnRelatedID]
   ,[udvnSubRelatedID]
   ,[udvsUDFValue]
   ,[udvnRecUserID]
   ,[udvdDtCreated]
   ,[udvnModifyUserID]
   ,[udvdDtModified]
   ,[udvnLevelNo]
	)
	SELECT DISTINCT
		udfnUDFID
	   ,'Case'
	   ,'C'
	   ,casnCaseID
	   ,0
	   ,'$' + CONVERT(VARCHAR, CAST(TotalSettleAward AS MONEY), 1)
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM WilliamPagerSaga.dbo.MATTER a
	LEFT JOIN WilliamPagerSaga.dbo.LW_MATTER b
		ON a.MATTERID = b.MATTERID
	LEFT JOIN sma_trn_cases
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = casnOrgCaseTypeID
	WHERE udfsUDFName = 'Settlement/Award Amount'
		AND ISNULL(TotalSettleAward, '') <> ''
	UNION
	SELECT DISTINCT
		udfnUDFID
	   ,'Case'
	   ,'C'
	   ,casnCaseID
	   ,0
	   ,'$' + CONVERT(VARCHAR, CAST(UNSETTLEDPLAINTIFFEXPENSES AS MONEY), 1)
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM WilliamPagerSaga.dbo.MATTER a
	LEFT JOIN WilliamPagerSaga.dbo.LW_MATTER b
		ON a.MATTERID = b.MATTERID
	LEFT JOIN sma_trn_cases
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = casnOrgCaseTypeID
	WHERE udfsUDFName = 'Unsettled Plaintiff Disbursement'
		AND ISNULL(UNSETTLEDPLAINTIFFEXPENSES, '') <> ''
	UNION
	SELECT DISTINCT
		udfnUDFID
	   ,'Case'
	   ,'C'
	   ,casnCaseID
	   ,0
	   ,'$' + CONVERT(VARCHAR, CAST(UnsettledLiens AS MONEY), 1)
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM WilliamPagerSaga.dbo.MATTER a
	LEFT JOIN WilliamPagerSaga.dbo.LW_MATTER b
		ON a.MATTERID = b.MATTERID
	LEFT JOIN sma_trn_cases
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = casnOrgCaseTypeID
	WHERE udfsUDFName = 'Unsettled Liens'
		AND ISNULL(UnsettledLiens, '') <> ''
	UNION
	SELECT DISTINCT
		udfnUDFID
	   ,'Case'
	   ,'C'
	   ,casnCaseID
	   ,0
	   ,'$' + CONVERT(VARCHAR, CAST(UNSETTLEDDISBURSEMENTS AS MONEY), 1)
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM WilliamPagerSaga.dbo.MATTER a
	LEFT JOIN WilliamPagerSaga.dbo.LW_MATTER b
		ON a.MATTERID = b.MATTERID
	LEFT JOIN sma_trn_cases
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = casnOrgCaseTypeID
	WHERE udfsUDFName = 'Unsettled Case Disbursement'
		AND ISNULL(UNSETTLEDDISBURSEMENTS, '') <> ''



INSERT INTO [sma_TRN_UDFValues]
	(
	[udvnUDFID]
   ,[udvsScreenName]
   ,[udvsUDFCtg]
   ,[udvnRelatedID]
   ,[udvnSubRelatedID]
   ,[udvsUDFValue]
   ,[udvnRecUserID]
   ,[udvdDtCreated]
   ,[udvnModifyUserID]
   ,[udvdDtModified]
   ,[udvnLevelNo]
	)

	SELECT DISTINCT
		udfnUDFID
	   ,'Case'
	   ,'C'
	   ,casnCaseID
	   ,0
	   ,CONVERT(VARCHAR(10), DATECLOSED, 101)
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM WilliamPagerSaga.dbo.MATTER a
	LEFT JOIN WilliamPagerSaga.dbo.LW_MATTER b
		ON a.MATTERID = b.MATTERID
	LEFT JOIN sma_trn_cases
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = casnOrgCaseTypeID
	WHERE udfsUDFName = 'Closed Date'
		AND ISNULL(DATECLOSED, '') <> ''
	UNION
	SELECT DISTINCT
		udfnUDFID
	   ,'Case'
	   ,'C'
	   ,casnCaseID
	   ,0
	   ,CONVERT(VARCHAR(10), FinalPaymentDate, 101)
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM WilliamPagerSaga.dbo.MATTER a
	LEFT JOIN WilliamPagerSaga.dbo.LW_MATTER b
		ON a.MATTERID = b.MATTERID
	LEFT JOIN sma_trn_cases
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = casnOrgCaseTypeID
	WHERE udfsUDFName = 'Final Payment Date'
		AND ISNULL(FinalPaymentDate, '') <> ''
	UNION
	SELECT DISTINCT
		udfnUDFID
	   ,'Case'
	   ,'C'
	   ,casnCaseID
	   ,0
	   ,CONVERT(VARCHAR(10), Settlement_AwardDate, 101)
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM WilliamPagerSaga.dbo.MATTER a
	LEFT JOIN WilliamPagerSaga.dbo.LW_MATTER b
		ON a.MATTERID = b.MATTERID
	LEFT JOIN sma_trn_cases
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = casnOrgCaseTypeID
	WHERE udfsUDFName = 'Settlement/Award Date'
		AND ISNULL(Settlement_AwardDate, '') <> ''
--,CLOSEDFILELOCATION,DATECLOSED,UNSETTLEDPLAINTIFFEXPENSES,UnsettledLiens,UNSETTLEDDISBURSEMENTS,FinalPaymentDate,TotalSettleAward,Settlement_AwardDate 
--select * from [sma_TRN_UDFValues]

INSERT INTO [sma_TRN_Settlements]
	(
	[stlnNegotID]
   ,[stlnCaseID]
   ,[stlsUniquePartyID]
   ,[stlnPlaintiffID]
   ,[stlnStaffID]
   ,[stlnSetAmt]
   ,[stlbConsentReqd]
   ,[stlbCourtConsent]
   ,[stldCourtDtSent]
   ,[stldCourtDtRcvd]
   ,[stldDocSendToClientOn]
   ,[stldDocReceivedFromClient]
   ,[stldDocSendToInsuranceCo]
   ,[stldDocExpectedDate]
   ,[stlnRecUserID]
   ,[stldDtCreated]
   ,[stlnModifyUserID]
   ,[stldDtModified]
   ,[stlnLevelNo]
   ,[stlnLessDisbursement]
   ,[stlnNet]
   ,[stlnForwarder]
   ,[stlnPrior]
   ,[stlnOther]
   ,[stlnGrossAttorneyFee]
   ,[stldSettlementDate]
   ,[stldDateOfDisbursement]
   ,[stlnAttFeeType]
   ,[stlnAttFeeValue]
   ,[stlnNetToClientAmt]
   ,[stlsComments]
	)
	SELECT
		NULL
	   ,casncaseid
	   ,NULL
	   ,-1
	   ,NULL
	   ,TotalSettleAward
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,Settlement_AwardDate
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,COMMENTSDISPOSITION
	FROM WilliamPagerSaga.dbo.LW_MATTER a
	LEFT JOIN WilliamPagerSaga.dbo.matter b
		ON a.MATTERID = b.MATTERID
	LEFT JOIN sma_trn_cases
		ON cassCaseNumber = b.MATTERNUMBER
	--left join sma_TRN_Plaintiff on plnnCaseID=casnCaseID and plnbIsPrimary=1
	WHERE ISNULL(TotalSettleAward, '0.00') <> '0.00'

