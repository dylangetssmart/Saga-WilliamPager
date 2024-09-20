USE WilliamPagerSA

UPDATE [sma_MST_UDFDefinition]
SET udfsUDFName = 'County'
WHERE udfsUDFCtg = 'I'
AND udfsUDFName = 'Country'

INSERT INTO [sma_MST_IncidentTypes]
	SELECT DISTINCT
		'frmIncident'
	   ,cgpsDscrptn
	FROM sma_trn_cases
	LEFT JOIN sma_MST_CaseType
		ON cstnCaseTypeID = casnOrgCaseTypeID
	LEFT JOIN sma_MST_CaseGroup CG
		ON cstnGroupID = cgpnCaseGroupID
	WHERE LTRIM(RTRIM('frmIncident')) NOT IN (
			SELECT
				LTRIM(RTRIM([IncidentType]))
			FROM [sma_MST_IncidentTypes]
		)

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
	SELECT DISTINCT
		[udfsUDFCtg]
	   ,IncidentTypeID
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
	FROM sma_MST_UDFDefinition
	CROSS JOIN [sma_MST_IncidentTypes]
	WHERE IncidentTypeID NOT IN (
			SELECT
				udfnRelatedPK
			FROM sma_MST_UDFDefinition
			WHERE udfsUDFCtg = 'I'
		)
		AND udfsUDFCtg = 'I'
		AND udfnRelatedPK = 2
	ORDER BY IncidentTypeID, udfnSortOrder



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
	SELECT DISTINCT
		[udfsUDFCtg]
	   ,udfnRelatedPK
	   ,'Zip'
	   ,'Incident'
	   ,'Text'
	   ,[udfsLength]
	   ,[udfsFormat]
	   ,[udfsTableName]
	   ,''
	   ,[udfsDefaultValue]
	   ,11
	   ,[udfbIsActive]
	   ,368
	   ,GETDATE()
	   ,[udfnModifyUserID]
	   ,[udfnDtModified]
	   ,[udfnLevelNo]
	   ,[udfbIsSystem]
	FROM sma_MST_UDFDefinition
	WHERE udfsUDFCtg = 'I'
		AND udfnRelatedPK IN (
			SELECT DISTINCT
				CG.IncidentTypeID
			FROM sma_trn_cases
			LEFT JOIN sma_MST_CaseType
				ON cstnCaseTypeID = casnOrgCaseTypeID
			LEFT JOIN sma_MST_CaseGroup CG
				ON cstnGroupID = cgpnCaseGroupID
			LEFT JOIN [sma_MST_IncidentTypes]
				ON LTRIM(RTRIM('frmIncident')) = LTRIM(RTRIM([IncidentType]))
		)
	UNION
	SELECT DISTINCT
		[udfsUDFCtg]
	   ,udfnRelatedPK
	   ,'Country'
	   ,'Incident'
	   ,'Text'
	   ,[udfsLength]
	   ,[udfsFormat]
	   ,[udfsTableName]
	   ,''
	   ,[udfsDefaultValue]
	   ,12
	   ,[udfbIsActive]
	   ,368
	   ,GETDATE()
	   ,[udfnModifyUserID]
	   ,[udfnDtModified]
	   ,[udfnLevelNo]
	   ,[udfbIsSystem]
	FROM sma_MST_UDFDefinition
	WHERE udfsUDFCtg = 'I'
		AND udfnRelatedPK IN (
			SELECT DISTINCT
				CG.IncidentTypeID
			FROM sma_trn_cases
			LEFT JOIN sma_MST_CaseType
				ON cstnCaseTypeID = casnOrgCaseTypeID
			LEFT JOIN sma_MST_CaseGroup CG
				ON cstnGroupID = cgpnCaseGroupID
			LEFT JOIN [sma_MST_IncidentTypes]
				ON LTRIM(RTRIM('frmIncident')) = LTRIM(RTRIM([IncidentType]))
		)
	UNION
	SELECT DISTINCT
		[udfsUDFCtg]
	   ,udfnRelatedPK
	   ,'Incident Description In Pleadings'
	   ,'Incident'
	   ,'MultiText'
	   ,[udfsLength]
	   ,[udfsFormat]
	   ,[udfsTableName]
	   ,''
	   ,[udfsDefaultValue]
	   ,13
	   ,[udfbIsActive]
	   ,368
	   ,GETDATE()
	   ,[udfnModifyUserID]
	   ,[udfnDtModified]
	   ,[udfnLevelNo]
	   ,[udfbIsSystem]
	FROM sma_MST_UDFDefinition
	WHERE udfsUDFCtg = 'I'
		AND udfnRelatedPK IN (
			SELECT DISTINCT
				CG.IncidentTypeID
			FROM sma_trn_cases
			LEFT JOIN sma_MST_CaseType
				ON cstnCaseTypeID = casnOrgCaseTypeID
			LEFT JOIN sma_MST_CaseGroup CG
				ON cstnGroupID = cgpnCaseGroupID
			LEFT JOIN [sma_MST_IncidentTypes]
				ON LTRIM(RTRIM('frmIncident')) = LTRIM(RTRIM([IncidentType]))
		)
	UNION
	SELECT DISTINCT
		[udfsUDFCtg]
	   ,udfnRelatedPK
	   ,'User Defined Date1'
	   ,'Incident'
	   ,'Date'
	   ,[udfsLength]
	   ,[udfsFormat]
	   ,[udfsTableName]
	   ,''
	   ,[udfsDefaultValue]
	   ,14
	   ,[udfbIsActive]
	   ,368
	   ,GETDATE()
	   ,[udfnModifyUserID]
	   ,[udfnDtModified]
	   ,[udfnLevelNo]
	   ,[udfbIsSystem]
	FROM sma_MST_UDFDefinition
	WHERE udfsUDFCtg = 'I'
		AND udfnRelatedPK IN (
			SELECT DISTINCT
				CG.IncidentTypeID
			FROM sma_trn_cases
			LEFT JOIN sma_MST_CaseType
				ON cstnCaseTypeID = casnOrgCaseTypeID
			LEFT JOIN sma_MST_CaseGroup CG
				ON cstnGroupID = cgpnCaseGroupID
			LEFT JOIN [sma_MST_IncidentTypes]
				ON LTRIM(RTRIM('frmIncident')) = LTRIM(RTRIM([IncidentType]))
		)
	UNION
	SELECT DISTINCT
		[udfsUDFCtg]
	   ,udfnRelatedPK
	   ,'User Defined Date2'
	   ,'Incident'
	   ,'Date'
	   ,[udfsLength]
	   ,[udfsFormat]
	   ,[udfsTableName]
	   ,''
	   ,[udfsDefaultValue]
	   ,15
	   ,[udfbIsActive]
	   ,368
	   ,GETDATE()
	   ,[udfnModifyUserID]
	   ,[udfnDtModified]
	   ,[udfnLevelNo]
	   ,[udfbIsSystem]
	FROM sma_MST_UDFDefinition
	WHERE udfsUDFCtg = 'I'
		AND udfnRelatedPK IN (
			SELECT DISTINCT
				CG.IncidentTypeID
			FROM sma_trn_cases
			LEFT JOIN sma_MST_CaseType
				ON cstnCaseTypeID = casnOrgCaseTypeID
			LEFT JOIN sma_MST_CaseGroup CG
				ON cstnGroupID = cgpnCaseGroupID
			LEFT JOIN [sma_MST_IncidentTypes]
				ON LTRIM(RTRIM('frmIncident')) = LTRIM(RTRIM([IncidentType]))
		)
	ORDER BY udfnRelatedPK



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
	   ,udfsScreenName
	   ,udfsUDFCtg
	   ,casnCaseID
	   ,''
	   ,CONVERT(VARCHAR(10), UDFDATE1, 101)
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
	LEFT JOIN sma_MST_CaseType
		ON cstnCaseTypeID = casnOrgCaseTypeID
	LEFT JOIN sma_MST_CaseGroup CG
		ON cstnGroupID = cgpnCaseGroupID
	LEFT JOIN [sma_MST_IncidentTypes]
		ON LTRIM(RTRIM('frmIncident')) = LTRIM(RTRIM([IncidentType]))
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = CG.IncidentTypeID
	WHERE udfsUDFName = 'User Defined Date1'
		AND ISNULL(UDFDATE1, '') <> ''
		AND udfsUDFCtg = 'I'
	UNION
	SELECT DISTINCT
		udfnUDFID
	   ,udfsScreenName
	   ,udfsUDFCtg
	   ,casnCaseID
	   ,''
	   ,CONVERT(VARCHAR(10), UDFDATE2, 101)
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
	LEFT JOIN sma_MST_CaseType
		ON cstnCaseTypeID = casnOrgCaseTypeID
	LEFT JOIN sma_MST_CaseGroup CG
		ON cstnGroupID = cgpnCaseGroupID
	LEFT JOIN [sma_MST_IncidentTypes]
		ON LTRIM(RTRIM('frmIncident')) = LTRIM(RTRIM([IncidentType]))
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = CG.IncidentTypeID
	WHERE udfsUDFName = 'User Defined Date2'
		AND ISNULL(UDFDATE2, '') <> ''
		AND udfsUDFCtg = 'I'

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
	   ,udfsScreenName
	   ,udfsUDFCtg
	   ,casnCaseID
	   ,''
	   ,CONVERT(VARCHAR(4000), LOCATIONSTREET)
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
	LEFT JOIN sma_MST_CaseType
		ON cstnCaseTypeID = casnOrgCaseTypeID
	LEFT JOIN sma_MST_CaseGroup CG
		ON cstnGroupID = cgpnCaseGroupID
	LEFT JOIN [sma_MST_IncidentTypes]
		ON LTRIM(RTRIM('frmIncident')) = LTRIM(RTRIM([IncidentType]))
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = CG.IncidentTypeID
	WHERE udfsUDFName = 'location'
		AND ISNULL(LOCATIONSTREET, '') <> ''
		AND udfsUDFCtg = 'I'
	UNION
	SELECT DISTINCT
		udfnUDFID
	   ,udfsScreenName
	   ,udfsUDFCtg
	   ,casnCaseID
	   ,''
	   ,LOCATIONCITY
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
	LEFT JOIN sma_MST_CaseType
		ON cstnCaseTypeID = casnOrgCaseTypeID
	LEFT JOIN sma_MST_CaseGroup CG
		ON cstnGroupID = cgpnCaseGroupID
	LEFT JOIN [sma_MST_IncidentTypes]
		ON LTRIM(RTRIM('frmIncident')) = LTRIM(RTRIM([IncidentType]))
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = CG.IncidentTypeID
	WHERE udfsUDFName = 'city'
		AND ISNULL(LOCATIONCITY, '') <> ''
		AND udfsUDFCtg = 'I'
	UNION
	SELECT DISTINCT
		udfnUDFID
	   ,udfsScreenName
	   ,udfsUDFCtg
	   ,casnCaseID
	   ,''
	   ,LOCATIONCOUNTY
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
	LEFT JOIN sma_MST_CaseType
		ON cstnCaseTypeID = casnOrgCaseTypeID
	LEFT JOIN sma_MST_CaseGroup CG
		ON cstnGroupID = cgpnCaseGroupID
	LEFT JOIN [sma_MST_IncidentTypes]
		ON LTRIM(RTRIM('frmIncident')) = LTRIM(RTRIM([IncidentType]))
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = CG.IncidentTypeID
	WHERE udfsUDFName = 'county'
		AND ISNULL(LOCATIONCOUNTY, '') <> ''
		AND udfsUDFCtg = 'I'
	UNION
	SELECT DISTINCT
		udfnUDFID
	   ,udfsScreenName
	   ,udfsUDFCtg
	   ,casnCaseID
	   ,''
	   ,LOCATIONCOUNTRY
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
	LEFT JOIN sma_MST_CaseType
		ON cstnCaseTypeID = casnOrgCaseTypeID
	LEFT JOIN sma_MST_CaseGroup CG
		ON cstnGroupID = cgpnCaseGroupID
	LEFT JOIN [sma_MST_IncidentTypes]
		ON LTRIM(RTRIM('frmIncident')) = LTRIM(RTRIM([IncidentType]))
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = CG.IncidentTypeID
	WHERE udfsUDFName = 'country'
		AND ISNULL(LOCATIONCOUNTRY, '') <> ''
		AND udfsUDFCtg = 'I'
	UNION
	SELECT DISTINCT
		udfnUDFID
	   ,udfsScreenName
	   ,udfsUDFCtg
	   ,casnCaseID
	   ,''
	   ,LOCATIONZIP
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
	LEFT JOIN sma_MST_CaseType
		ON cstnCaseTypeID = casnOrgCaseTypeID
	LEFT JOIN sma_MST_CaseGroup CG
		ON cstnGroupID = cgpnCaseGroupID
	LEFT JOIN [sma_MST_IncidentTypes]
		ON LTRIM(RTRIM('frmIncident')) = LTRIM(RTRIM([IncidentType]))
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = CG.IncidentTypeID
	WHERE udfsUDFName = 'zip'
		AND ISNULL(LOCATIONZIP, '') <> ''
		AND udfsUDFCtg = 'I'
	UNION
	SELECT DISTINCT
		udfnUDFID
	   ,udfsScreenName
	   ,udfsUDFCtg
	   ,casnCaseID
	   ,''
	   ,CONVERT(VARCHAR(4000), COMMENTS)
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
	LEFT JOIN sma_MST_CaseType
		ON cstnCaseTypeID = casnOrgCaseTypeID
	LEFT JOIN sma_MST_CaseGroup CG
		ON cstnGroupID = cgpnCaseGroupID
	LEFT JOIN [sma_MST_IncidentTypes]
		ON LTRIM(RTRIM('frmIncident')) = LTRIM(RTRIM([IncidentType]))
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = CG.IncidentTypeID
	WHERE udfsUDFName = 'Incident Description In Pleadings'
		AND ISNULL(CONVERT(VARCHAR(4000), COMMENTS), '') <> ''
		AND udfsUDFCtg = 'I'

