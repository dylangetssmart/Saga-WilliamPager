USE WilliamPagerSA

----SAGA Overview Screen Group Information
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
	   ,'Matter Group1 Date'
	   ,'Case'
	   ,'Date'
	   ,500
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,11
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
	   ,'Matter Group1'
	   ,'Case'
	   ,'Text'
	   ,500
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,10
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
	   ,'Matter Group2 Date'
	   ,'Case'
	   ,'Date'
	   ,500
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,13
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
	   ,'Matter Group2'
	   ,'Case'
	   ,'Text'
	   ,500
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,12
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
	   ,'Matter Group3 Date'
	   ,'Case'
	   ,'Date'
	   ,500
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,15
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
	   ,'Matter Group3'
	   ,'Case'
	   ,'Text'
	   ,500
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,14
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
	   ,CONVERT(VARCHAR(10), MATTERGROUP1DATE, 101)
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM WilliamPagerSaga.dbo.MATTER a
	LEFT JOIN WilliamPagerSaga.dbo.[LW_A_MATTERGROUP] b
		ON a.MATTERGROUP1ID = b.MATTERGROUPID
	LEFT JOIN sma_trn_cases
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = casnOrgCaseTypeID
	WHERE udfsUDFName = 'Matter Group1 Date'
		AND ISNULL(MATTERGROUP1DATE, '') <> ''
	UNION
	SELECT DISTINCT
		udfnUDFID
	   ,'Case'
	   ,'C'
	   ,casnCaseID
	   ,0
	   ,CONVERT(VARCHAR(10), MATTERGROUP2DATE, 101)
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM WilliamPagerSaga.dbo.MATTER a
	LEFT JOIN WilliamPagerSaga.dbo.[LW_A_MATTERGROUP] b
		ON a.MATTERGROUP2ID = b.MATTERGROUPID
	LEFT JOIN sma_trn_cases
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = casnOrgCaseTypeID
	WHERE udfsUDFName = 'Matter Group2 Date'
		AND ISNULL(MATTERGROUP2DATE, '') <> ''
	UNION
	SELECT DISTINCT
		udfnUDFID
	   ,'Case'
	   ,'C'
	   ,casnCaseID
	   ,0
	   ,CONVERT(VARCHAR(10), MATTERGROUP3DATE, 101)
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM WilliamPagerSaga.dbo.MATTER a
	LEFT JOIN WilliamPagerSaga.dbo.[LW_A_MATTERGROUP] b
		ON a.MATTERGROUP3ID = b.MATTERGROUPID
	LEFT JOIN sma_trn_cases
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = casnOrgCaseTypeID
	WHERE udfsUDFName = 'Matter Group3 Date'
		AND ISNULL(MATTERGROUP3DATE, '') <> ''


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
	   ,b.DESCRIPTION
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM WilliamPagerSaga.dbo.MATTER a
	LEFT JOIN WilliamPagerSaga.dbo.[LW_A_MATTERGROUP] b
		ON a.MATTERGROUP1ID = b.MATTERGROUPID
	LEFT JOIN sma_trn_cases
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = casnOrgCaseTypeID
	WHERE udfsUDFName = 'Matter Group1'
		AND ISNULL(b.DESCRIPTION, '') <> ''
	UNION
	SELECT DISTINCT
		udfnUDFID
	   ,'Case'
	   ,'C'
	   ,casnCaseID
	   ,0
	   ,b.DESCRIPTION
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM WilliamPagerSaga.dbo.MATTER a
	LEFT JOIN WilliamPagerSaga.dbo.[LW_A_MATTERGROUP] b
		ON a.MATTERGROUP2ID = b.MATTERGROUPID
	LEFT JOIN sma_trn_cases
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = casnOrgCaseTypeID
	WHERE udfsUDFName = 'Matter Group2'
		AND ISNULL(b.DESCRIPTION, '') <> ''
	UNION
	SELECT DISTINCT
		udfnUDFID
	   ,'Case'
	   ,'C'
	   ,casnCaseID
	   ,0
	   ,b.DESCRIPTION
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM WilliamPagerSaga.dbo.MATTER a
	LEFT JOIN WilliamPagerSaga.dbo.[LW_A_MATTERGROUP] b
		ON a.MATTERGROUP3ID = b.MATTERGROUPID
	LEFT JOIN sma_trn_cases
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = casnOrgCaseTypeID
	WHERE udfsUDFName = 'Matter Group3'
		AND ISNULL(b.DESCRIPTION, '') <> ''
