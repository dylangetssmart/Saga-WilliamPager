USE WilliamPagerSA

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
	   ,text
	   ,'Case'
	   ,CASE
			WHEN CTRLNUM BETWEEN 8 AND 11
				THEN 'Date'
			WHEN CTRLTYPE = 202
				THEN 'Dropdown'
			ELSE 'Text'
		END
	   ,500
	   ,NULL
	   ,NULL
	   ,CASE
			WHEN CTRLTYPE = 202
				THEN 'Yes~No'
		END
	   ,NULL
	   ,1000 + CTRLNUM
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
	CROSS JOIN WilliamPagerSaga.dbo.DESCTRL a
	LEFT JOIN WilliamPagerSaga.dbo.DESFORM b
		ON a.FORMID = b.FORMID
	WHERE b.DESCRIPTION LIKE 'matter%'
		AND CTRLTYPE IN (101, 202)
	UNION
	SELECT
		'C'
	   ,cstnCaseTypeID
	   ,text
	   ,'Plaintiff'
	   ,CASE
			WHEN CTRLNUM BETWEEN 8 AND 11
				THEN 'Date'
			WHEN CTRLTYPE = 202
				THEN 'Dropdown'
			ELSE 'Text'
		END
	   ,500
	   ,NULL
	   ,NULL
	   ,CASE
			WHEN CTRLTYPE = 202
				THEN 'Yes~No'
		END
	   ,NULL
	   ,1000 + CTRLNUM
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
	CROSS JOIN WilliamPagerSaga.dbo.DESCTRL a
	LEFT JOIN WilliamPagerSaga.dbo.DESFORM b
		ON a.FORMID = b.FORMID
	WHERE b.DESCRIPTION LIKE 'plaint%'
		AND CTRLTYPE IN (101, 202)
	UNION
	SELECT
		'C'
	   ,cstnCaseTypeID
	   ,text
	   ,'Defendant'
	   ,CASE
			WHEN CTRLNUM BETWEEN 8 AND 11
				THEN 'Date'
			WHEN CTRLTYPE = 202
				THEN 'Dropdown'
			ELSE 'Text'
		END
	   ,500
	   ,NULL
	   ,NULL
	   ,CASE
			WHEN CTRLTYPE = 202
				THEN 'Yes~No'
		END
	   ,NULL
	   ,1000 + CTRLNUM
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
	CROSS JOIN WilliamPagerSaga.dbo.DESCTRL a
	LEFT JOIN WilliamPagerSaga.dbo.DESFORM b
		ON a.FORMID = b.FORMID
	WHERE b.DESCRIPTION LIKE 'defen%'
		AND CTRLTYPE IN (101, 202)


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
	SELECT
		udfnUDFID
	   ,'Case'
	   ,'C'
	   ,casnCaseID
	   ,0
	   ,FIELD1
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM WilliamPagerSaga.dbo.AUXUDFMA
	LEFT JOIN WilliamPagerSaga.dbo.MATTER
		ON MATTERID = REFERID
	LEFT JOIN sma_TRN_CaseS
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = casnOrgCaseTypeID
	WHERE udfsUDFName = (
			SELECT
				text
			FROM WilliamPagerSaga.dbo.DESCTRL a
			LEFT JOIN WilliamPagerSaga.dbo.DESFORM b
				ON a.FORMID = b.FORMID
			WHERE b.DESCRIPTION LIKE 'matter%'
				AND CTRLTYPE IN (101, 202)
				AND CTRLNUM = 2
		)
		AND ISNULL(FIELD1, '') <> ''
	UNION
	SELECT
		udfnUDFID
	   ,'Case'
	   ,'C'
	   ,casnCaseID
	   ,0
	   ,FIELD2
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM WilliamPagerSaga.dbo.AUXUDFMA
	LEFT JOIN WilliamPagerSaga.dbo.MATTER
		ON MATTERID = REFERID
	LEFT JOIN sma_TRN_CaseS
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = casnOrgCaseTypeID
	WHERE udfsUDFName = (
			SELECT
				text
			FROM WilliamPagerSaga.dbo.DESCTRL a
			LEFT JOIN WilliamPagerSaga.dbo.DESFORM b
				ON a.FORMID = b.FORMID
			WHERE b.DESCRIPTION LIKE 'matter%'
				AND CTRLTYPE IN (101, 202)
				AND CTRLNUM = 3
		)
		AND ISNULL(FIELD2, '') <> ''
	UNION
	SELECT
		udfnUDFID
	   ,'Case'
	   ,'C'
	   ,casnCaseID
	   ,0
	   ,FIELD3
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM WilliamPagerSaga.dbo.AUXUDFMA
	LEFT JOIN WilliamPagerSaga.dbo.MATTER
		ON MATTERID = REFERID
	LEFT JOIN sma_TRN_CaseS
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = casnOrgCaseTypeID
	WHERE udfsUDFName = (
			SELECT
				text
			FROM WilliamPagerSaga.dbo.DESCTRL a
			LEFT JOIN WilliamPagerSaga.dbo.DESFORM b
				ON a.FORMID = b.FORMID
			WHERE b.DESCRIPTION LIKE 'matter%'
				AND CTRLTYPE IN (101, 202)
				AND CTRLNUM = 4
		)
		AND ISNULL(FIELD3, '') <> ''
	UNION
	SELECT
		udfnUDFID
	   ,'Case'
	   ,'C'
	   ,casnCaseID
	   ,0
	   ,FIELD4
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM WilliamPagerSaga.dbo.AUXUDFMA
	LEFT JOIN WilliamPagerSaga.dbo.MATTER
		ON MATTERID = REFERID
	LEFT JOIN sma_TRN_CaseS
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = casnOrgCaseTypeID
	WHERE udfsUDFName = (
			SELECT
				text
			FROM WilliamPagerSaga.dbo.DESCTRL a
			LEFT JOIN WilliamPagerSaga.dbo.DESFORM b
				ON a.FORMID = b.FORMID
			WHERE b.DESCRIPTION LIKE 'matter%'
				AND CTRLTYPE IN (101, 202)
				AND CTRLNUM = 5
		)
		AND ISNULL(FIELD4, '') <> ''
	UNION
	SELECT
		udfnUDFID
	   ,'Case'
	   ,'C'
	   ,casnCaseID
	   ,0
	   ,FIELD5
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM WilliamPagerSaga.dbo.AUXUDFMA
	LEFT JOIN WilliamPagerSaga.dbo.MATTER
		ON MATTERID = REFERID
	LEFT JOIN sma_TRN_CaseS
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = casnOrgCaseTypeID
	WHERE udfsUDFName = (
			SELECT
				text
			FROM WilliamPagerSaga.dbo.DESCTRL a
			LEFT JOIN WilliamPagerSaga.dbo.DESFORM b
				ON a.FORMID = b.FORMID
			WHERE b.DESCRIPTION LIKE 'matter%'
				AND CTRLTYPE IN (101, 202)
				AND CTRLNUM = 6
		)
		AND ISNULL(FIELD5, '') <> ''


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
	SELECT
		udfnUDFID
	   ,'Case'
	   ,'C'
	   ,casnCaseID
	   ,0
	   ,FIELD6
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM WilliamPagerSaga.dbo.AUXUDFMA
	LEFT JOIN WilliamPagerSaga.dbo.MATTER
		ON MATTERID = REFERID
	LEFT JOIN sma_TRN_CaseS
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = casnOrgCaseTypeID
	WHERE udfsUDFName = (
			SELECT
				text
			FROM WilliamPagerSaga.dbo.DESCTRL a
			LEFT JOIN WilliamPagerSaga.dbo.DESFORM b
				ON a.FORMID = b.FORMID
			WHERE b.DESCRIPTION LIKE 'matter%'
				AND CTRLTYPE IN (101, 202)
				AND CTRLNUM = 12
		)
		AND ISNULL(FIELD6, '') <> ''
	UNION
	SELECT
		udfnUDFID
	   ,'Case'
	   ,'C'
	   ,casnCaseID
	   ,0
	   ,FIELD7
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM WilliamPagerSaga.dbo.AUXUDFMA
	LEFT JOIN WilliamPagerSaga.dbo.MATTER
		ON MATTERID = REFERID
	LEFT JOIN sma_TRN_CaseS
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = casnOrgCaseTypeID
	WHERE udfsUDFName = (
			SELECT
				text
			FROM WilliamPagerSaga.dbo.DESCTRL a
			LEFT JOIN WilliamPagerSaga.dbo.DESFORM b
				ON a.FORMID = b.FORMID
			WHERE b.DESCRIPTION LIKE 'matter%'
				AND CTRLTYPE IN (101, 202)
				AND CTRLNUM = 13
		)
		AND FIELD7 IS NOT NULL
	UNION
	SELECT
		udfnUDFID
	   ,'Case'
	   ,'C'
	   ,casnCaseID
	   ,0
	   ,FIELD8
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM WilliamPagerSaga.dbo.AUXUDFMA
	LEFT JOIN WilliamPagerSaga.dbo.MATTER
		ON MATTERID = REFERID
	LEFT JOIN sma_TRN_CaseS
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = casnOrgCaseTypeID
	WHERE udfsUDFName = (
			SELECT
				text
			FROM WilliamPagerSaga.dbo.DESCTRL a
			LEFT JOIN WilliamPagerSaga.dbo.DESFORM b
				ON a.FORMID = b.FORMID
			WHERE b.DESCRIPTION LIKE 'matter%'
				AND CTRLTYPE IN (101, 202)
				AND CTRLNUM = 14
		)
		AND FIELD8 IS NOT NULL

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
	SELECT
		udfnUDFID
	   ,'Case'
	   ,'C'
	   ,casnCaseID
	   ,0
	   ,CASE
			WHEN FIELD9 = 'T'
				THEN 'Yes'
			ELSE FIELD9
		END
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM WilliamPagerSaga.dbo.AUXUDFMA
	LEFT JOIN WilliamPagerSaga.dbo.MATTER
		ON MATTERID = REFERID
	LEFT JOIN sma_TRN_CaseS
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = casnOrgCaseTypeID
	WHERE udfsUDFName = (
			SELECT
				text
			FROM WilliamPagerSaga.dbo.DESCTRL a
			LEFT JOIN WilliamPagerSaga.dbo.DESFORM b
				ON a.FORMID = b.FORMID
			WHERE b.DESCRIPTION LIKE 'matter%'
				AND CTRLTYPE IN (101, 202)
				AND CTRLNUM = 28
		)
		AND ISNULL(FIELD9, '') <> ''
		AND FIELD9 <> 'F'
	UNION
	SELECT
		udfnUDFID
	   ,'Case'
	   ,'C'
	   ,casnCaseID
	   ,0
	   ,CASE
			WHEN FIELD10 = 'T'
				THEN 'Yes'
			ELSE FIELD10
		END
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM WilliamPagerSaga.dbo.AUXUDFMA
	LEFT JOIN WilliamPagerSaga.dbo.MATTER
		ON MATTERID = REFERID
	LEFT JOIN sma_TRN_CaseS
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = casnOrgCaseTypeID
	WHERE udfsUDFName = (
			SELECT
				text
			FROM WilliamPagerSaga.dbo.DESCTRL a
			LEFT JOIN WilliamPagerSaga.dbo.DESFORM b
				ON a.FORMID = b.FORMID
			WHERE b.DESCRIPTION LIKE 'matter%'
				AND CTRLTYPE IN (101, 202)
				AND CTRLNUM = 29
		)
		AND ISNULL(FIELD10, '') <> ''
		AND FIELD10 <> 'F'


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
	SELECT
		udfnUDFID
	   ,'Case'
	   ,'C'
	   ,casnCaseID
	   ,0
	   ,CASE
			WHEN ISDATE(FIELD11) = 1
				THEN FIELD11
			ELSE NULL
		END
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM WilliamPagerSaga.dbo.AUXUDFMA
	LEFT JOIN WilliamPagerSaga.dbo.MATTER
		ON MATTERID = REFERID
	LEFT JOIN sma_TRN_CaseS
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = casnOrgCaseTypeID
	WHERE udfsUDFName = (
			SELECT
				text
			FROM WilliamPagerSaga.dbo.DESCTRL a
			LEFT JOIN WilliamPagerSaga.dbo.DESFORM b
				ON a.FORMID = b.FORMID
			WHERE b.DESCRIPTION LIKE 'matter%'
				AND CTRLTYPE IN (101, 202)
				AND CTRLNUM = 8
		)
		AND ISNULL(FIELD11, '') <> ''
	UNION
	SELECT
		udfnUDFID
	   ,'Case'
	   ,'C'
	   ,casnCaseID
	   ,0
	   ,CASE
			WHEN ISDATE(FIELD12) = 1
				THEN FIELD12
			ELSE NULL
		END
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM WilliamPagerSaga.dbo.AUXUDFMA
	LEFT JOIN WilliamPagerSaga.dbo.MATTER
		ON MATTERID = REFERID
	LEFT JOIN sma_TRN_CaseS
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = casnOrgCaseTypeID
	WHERE udfsUDFName = (
			SELECT
				text
			FROM WilliamPagerSaga.dbo.DESCTRL a
			LEFT JOIN WilliamPagerSaga.dbo.DESFORM b
				ON a.FORMID = b.FORMID
			WHERE b.DESCRIPTION LIKE 'matter%'
				AND CTRLTYPE IN (101, 202)
				AND CTRLNUM = 9
		)
		AND ISNULL(FIELD12, '') <> ''
	UNION
	SELECT
		udfnUDFID
	   ,'Case'
	   ,'C'
	   ,casnCaseID
	   ,0
	   ,CASE
			WHEN ISDATE(FIELD13) = 1
				THEN FIELD13
			ELSE NULL
		END
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM WilliamPagerSaga.dbo.AUXUDFMA
	LEFT JOIN WilliamPagerSaga.dbo.MATTER
		ON MATTERID = REFERID
	LEFT JOIN sma_TRN_CaseS
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = casnOrgCaseTypeID
	WHERE udfsUDFName = (
			SELECT
				text
			FROM WilliamPagerSaga.dbo.DESCTRL a
			LEFT JOIN WilliamPagerSaga.dbo.DESFORM b
				ON a.FORMID = b.FORMID
			WHERE b.DESCRIPTION LIKE 'matter%'
				AND CTRLTYPE IN (101, 202)
				AND CTRLNUM = 10
		)
		AND ISNULL(FIELD13, '') <> ''
	UNION
	SELECT
		udfnUDFID
	   ,'Case'
	   ,'C'
	   ,casnCaseID
	   ,0
	   ,CASE
			WHEN ISDATE(FIELD14) = 1
				THEN FIELD14
			ELSE NULL
		END
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM WilliamPagerSaga.dbo.AUXUDFMA
	LEFT JOIN WilliamPagerSaga.dbo.MATTER
		ON MATTERID = REFERID
	LEFT JOIN sma_TRN_CaseS
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = casnOrgCaseTypeID
	WHERE udfsUDFName = (
			SELECT
				text
			FROM WilliamPagerSaga.dbo.DESCTRL a
			LEFT JOIN WilliamPagerSaga.dbo.DESFORM b
				ON a.FORMID = b.FORMID
			WHERE b.DESCRIPTION LIKE 'matter%'
				AND CTRLTYPE IN (101, 202)
				AND CTRLNUM = 11
		)
		AND ISNULL(FIELD14, '') <> ''

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
	SELECT
		udfnUDFID
	   ,'Defendant'
	   ,'C'
	   ,casnCaseID
	   ,defnDefendentID
	   ,FIELD1
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM WilliamPagerSaga.dbo.AUXUDFDF
	LEFT JOIN WilliamPagerSaga.dbo.MATTER
		ON MATTERID = REFERID
	LEFT JOIN sma_TRN_CaseS
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = casnOrgCaseTypeID
	LEFT JOIN sma_TRN_Defendants
		ON defnCaseID = casnCaseID
			AND defbIsPrimary = 1
	WHERE udfsUDFName = (
			SELECT
				text
			FROM WilliamPagerSaga.dbo.DESCTRL a
			LEFT JOIN WilliamPagerSaga.dbo.DESFORM b
				ON a.FORMID = b.FORMID
			WHERE b.DESCRIPTION LIKE 'Defendant%'
				AND CTRLTYPE IN (101, 202)
				AND CTRLNUM = 2
		)
		AND ISNULL(FIELD1, '') <> ''
	UNION
	SELECT
		udfnUDFID
	   ,'Defendant'
	   ,'C'
	   ,casnCaseID
	   ,defnDefendentID
	   ,FIELD2
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM WilliamPagerSaga.dbo.AUXUDFDF
	LEFT JOIN WilliamPagerSaga.dbo.MATTER
		ON MATTERID = REFERID
	LEFT JOIN sma_TRN_CaseS
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = casnOrgCaseTypeID
	LEFT JOIN sma_TRN_Defendants
		ON defnCaseID = casnCaseID
			AND defbIsPrimary = 1
	WHERE udfsUDFName = (
			SELECT
				text
			FROM WilliamPagerSaga.dbo.DESCTRL a
			LEFT JOIN WilliamPagerSaga.dbo.DESFORM b
				ON a.FORMID = b.FORMID
			WHERE b.DESCRIPTION LIKE 'Defendant%'
				AND CTRLTYPE IN (101, 202)
				AND CTRLNUM = 3
		)
		AND ISNULL(FIELD2, '') <> ''
	UNION
	SELECT
		udfnUDFID
	   ,'Defendant'
	   ,'C'
	   ,casnCaseID
	   ,defnDefendentID
	   ,FIELD3
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM WilliamPagerSaga.dbo.AUXUDFDF
	LEFT JOIN WilliamPagerSaga.dbo.MATTER
		ON MATTERID = REFERID
	LEFT JOIN sma_TRN_CaseS
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = casnOrgCaseTypeID
	LEFT JOIN sma_TRN_Defendants
		ON defnCaseID = casnCaseID
			AND defbIsPrimary = 1
	WHERE udfsUDFName = (
			SELECT
				text
			FROM WilliamPagerSaga.dbo.DESCTRL a
			LEFT JOIN WilliamPagerSaga.dbo.DESFORM b
				ON a.FORMID = b.FORMID
			WHERE b.DESCRIPTION LIKE 'Defendant%'
				AND CTRLTYPE IN (101, 202)
				AND CTRLNUM = 4
		)
		AND ISNULL(FIELD3, '') <> ''
	UNION
	SELECT
		udfnUDFID
	   ,'Defendant'
	   ,'C'
	   ,casnCaseID
	   ,defnDefendentID
	   ,FIELD4
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM WilliamPagerSaga.dbo.AUXUDFDF
	LEFT JOIN WilliamPagerSaga.dbo.MATTER
		ON MATTERID = REFERID
	LEFT JOIN sma_TRN_CaseS
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = casnOrgCaseTypeID
	LEFT JOIN sma_TRN_Defendants
		ON defnCaseID = casnCaseID
			AND defbIsPrimary = 1
	WHERE udfsUDFName = (
			SELECT
				text
			FROM WilliamPagerSaga.dbo.DESCTRL a
			LEFT JOIN WilliamPagerSaga.dbo.DESFORM b
				ON a.FORMID = b.FORMID
			WHERE b.DESCRIPTION LIKE 'Defendant%'
				AND CTRLTYPE IN (101, 202)
				AND CTRLNUM = 5
		)
		AND ISNULL(FIELD4, '') <> ''
	UNION
	SELECT
		udfnUDFID
	   ,'Defendant'
	   ,'C'
	   ,casnCaseID
	   ,defnDefendentID
	   ,FIELD5
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM WilliamPagerSaga.dbo.AUXUDFDF
	LEFT JOIN WilliamPagerSaga.dbo.MATTER
		ON MATTERID = REFERID
	LEFT JOIN sma_TRN_CaseS
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = casnOrgCaseTypeID
	LEFT JOIN sma_TRN_Defendants
		ON defnCaseID = casnCaseID
			AND defbIsPrimary = 1
	WHERE udfsUDFName = (
			SELECT
				text
			FROM WilliamPagerSaga.dbo.DESCTRL a
			LEFT JOIN WilliamPagerSaga.dbo.DESFORM b
				ON a.FORMID = b.FORMID
			WHERE b.DESCRIPTION LIKE 'Defendant%'
				AND CTRLTYPE IN (101, 202)
				AND CTRLNUM = 6
		)
		AND ISNULL(FIELD5, '') <> ''

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
	SELECT
		udfnUDFID
	   ,'Defendant'
	   ,'C'
	   ,casnCaseID
	   ,defnDefendentID
	   ,FIELD6
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM WilliamPagerSaga.dbo.AUXUDFDF
	LEFT JOIN WilliamPagerSaga.dbo.MATTER
		ON MATTERID = REFERID
	LEFT JOIN sma_TRN_CaseS
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = casnOrgCaseTypeID
	LEFT JOIN sma_TRN_Defendants
		ON defnCaseID = casnCaseID
			AND defbIsPrimary = 1
	WHERE udfsUDFName = (
			SELECT
				text
			FROM WilliamPagerSaga.dbo.DESCTRL a
			LEFT JOIN WilliamPagerSaga.dbo.DESFORM b
				ON a.FORMID = b.FORMID
			WHERE b.DESCRIPTION LIKE 'Defendant%'
				AND CTRLTYPE IN (101, 202)
				AND CTRLNUM = 12
		)
		AND ISNULL(FIELD6, '') <> ''
		AND FIELD6 <> 0
	UNION
	SELECT
		udfnUDFID
	   ,'Defendant'
	   ,'C'
	   ,casnCaseID
	   ,defnDefendentID
	   ,FIELD7
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM WilliamPagerSaga.dbo.AUXUDFDF
	LEFT JOIN WilliamPagerSaga.dbo.MATTER
		ON MATTERID = REFERID
	LEFT JOIN sma_TRN_CaseS
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = casnOrgCaseTypeID
	LEFT JOIN sma_TRN_Defendants
		ON defnCaseID = casnCaseID
			AND defbIsPrimary = 1
	WHERE udfsUDFName = (
			SELECT
				text
			FROM WilliamPagerSaga.dbo.DESCTRL a
			LEFT JOIN WilliamPagerSaga.dbo.DESFORM b
				ON a.FORMID = b.FORMID
			WHERE b.DESCRIPTION LIKE 'Defendant%'
				AND CTRLTYPE IN (101, 202)
				AND CTRLNUM = 13
		)
		AND FIELD7 IS NOT NULL
		AND FIELD7 <> '0.00'
	UNION
	SELECT
		udfnUDFID
	   ,'Defendant'
	   ,'C'
	   ,casnCaseID
	   ,defnDefendentID
	   ,FIELD8
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM WilliamPagerSaga.dbo.AUXUDFDF
	LEFT JOIN WilliamPagerSaga.dbo.MATTER
		ON MATTERID = REFERID
	LEFT JOIN sma_TRN_CaseS
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = casnOrgCaseTypeID
	LEFT JOIN sma_TRN_Defendants
		ON defnCaseID = casnCaseID
			AND defbIsPrimary = 1
	WHERE udfsUDFName = (
			SELECT
				text
			FROM WilliamPagerSaga.dbo.DESCTRL a
			LEFT JOIN WilliamPagerSaga.dbo.DESFORM b
				ON a.FORMID = b.FORMID
			WHERE b.DESCRIPTION LIKE 'Defendant%'
				AND CTRLTYPE IN (101, 202)
				AND CTRLNUM = 14
		)
		AND FIELD8 IS NOT NULL
		AND FIELD8 <> '0.00'

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
	SELECT
		udfnUDFID
	   ,'Defendant'
	   ,'C'
	   ,casnCaseID
	   ,defnDefendentID
	   ,CASE
			WHEN FIELD9 = 'T'
				THEN 'Yes'
			ELSE FIELD9
		END
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM WilliamPagerSaga.dbo.AUXUDFDF
	LEFT JOIN WilliamPagerSaga.dbo.MATTER
		ON MATTERID = REFERID
	LEFT JOIN sma_TRN_CaseS
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = casnOrgCaseTypeID
	LEFT JOIN sma_TRN_Defendants
		ON defnCaseID = casnCaseID
			AND defbIsPrimary = 1
	WHERE udfsUDFName = (
			SELECT
				text
			FROM WilliamPagerSaga.dbo.DESCTRL a
			LEFT JOIN WilliamPagerSaga.dbo.DESFORM b
				ON a.FORMID = b.FORMID
			WHERE b.DESCRIPTION LIKE 'Defendant%'
				AND CTRLTYPE IN (101, 202)
				AND CTRLNUM = 28
		)
		AND ISNULL(FIELD9, '') <> ''
		AND FIELD9 <> 'F'
	UNION
	SELECT
		udfnUDFID
	   ,'Defendant'
	   ,'C'
	   ,casnCaseID
	   ,defnDefendentID
	   ,CASE
			WHEN FIELD10 = 'T'
				THEN 'Yes'
			ELSE FIELD10
		END
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM WilliamPagerSaga.dbo.AUXUDFDF
	LEFT JOIN WilliamPagerSaga.dbo.MATTER
		ON MATTERID = REFERID
	LEFT JOIN sma_TRN_CaseS
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = casnOrgCaseTypeID
	LEFT JOIN sma_TRN_Defendants
		ON defnCaseID = casnCaseID
			AND defbIsPrimary = 1
	WHERE udfsUDFName = (
			SELECT
				text
			FROM WilliamPagerSaga.dbo.DESCTRL a
			LEFT JOIN WilliamPagerSaga.dbo.DESFORM b
				ON a.FORMID = b.FORMID
			WHERE b.DESCRIPTION LIKE 'Defendant%'
				AND CTRLTYPE IN (101, 202)
				AND CTRLNUM = 29
		)
		AND ISNULL(FIELD10, '') <> ''
		AND FIELD10 <> 'F'

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
	SELECT
		udfnUDFID
	   ,'Defendant'
	   ,'C'
	   ,casnCaseID
	   ,defnDefendentID
	   ,CASE
			WHEN ISDATE(FIELD11) = 1
				THEN FIELD11
			ELSE NULL
		END
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM WilliamPagerSaga.dbo.AUXUDFDF
	LEFT JOIN WilliamPagerSaga.dbo.MATTER
		ON MATTERID = REFERID
	LEFT JOIN sma_TRN_CaseS
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = casnOrgCaseTypeID
	LEFT JOIN sma_TRN_Defendants
		ON defnCaseID = casnCaseID
			AND defbIsPrimary = 1
	WHERE udfsUDFName = (
			SELECT
				text
			FROM WilliamPagerSaga.dbo.DESCTRL a
			LEFT JOIN WilliamPagerSaga.dbo.DESFORM b
				ON a.FORMID = b.FORMID
			WHERE b.DESCRIPTION LIKE 'Defendant%'
				AND CTRLTYPE IN (101, 202)
				AND CTRLNUM = 8
		)
		AND ISNULL(FIELD11, '') <> ''
	UNION
	SELECT
		udfnUDFID
	   ,'Defendant'
	   ,'C'
	   ,casnCaseID
	   ,defnDefendentID
	   ,CASE
			WHEN ISDATE(FIELD12) = 1
				THEN FIELD12
			ELSE NULL
		END
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM WilliamPagerSaga.dbo.AUXUDFDF
	LEFT JOIN WilliamPagerSaga.dbo.MATTER
		ON MATTERID = REFERID
	LEFT JOIN sma_TRN_CaseS
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = casnOrgCaseTypeID
	LEFT JOIN sma_TRN_Defendants
		ON defnCaseID = casnCaseID
			AND defbIsPrimary = 1
	WHERE udfsUDFName = (
			SELECT
				text
			FROM WilliamPagerSaga.dbo.DESCTRL a
			LEFT JOIN WilliamPagerSaga.dbo.DESFORM b
				ON a.FORMID = b.FORMID
			WHERE b.DESCRIPTION LIKE 'Defendant%'
				AND CTRLTYPE IN (101, 202)
				AND CTRLNUM = 9
		)
		AND ISNULL(FIELD12, '') <> ''
	UNION
	SELECT
		udfnUDFID
	   ,'Defendant'
	   ,'C'
	   ,casnCaseID
	   ,defnDefendentID
	   ,CASE
			WHEN ISDATE(FIELD13) = 1
				THEN FIELD13
			ELSE NULL
		END
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM WilliamPagerSaga.dbo.AUXUDFDF
	LEFT JOIN WilliamPagerSaga.dbo.MATTER
		ON MATTERID = REFERID
	LEFT JOIN sma_TRN_CaseS
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = casnOrgCaseTypeID
	LEFT JOIN sma_TRN_Defendants
		ON defnCaseID = casnCaseID
			AND defbIsPrimary = 1
	WHERE udfsUDFName = (
			SELECT
				text
			FROM WilliamPagerSaga.dbo.DESCTRL a
			LEFT JOIN WilliamPagerSaga.dbo.DESFORM b
				ON a.FORMID = b.FORMID
			WHERE b.DESCRIPTION LIKE 'Defendant%'
				AND CTRLTYPE IN (101, 202)
				AND CTRLNUM = 10
		)
		AND ISNULL(FIELD13, '') <> ''
	UNION
	SELECT
		udfnUDFID
	   ,'Defendant'
	   ,'C'
	   ,casnCaseID
	   ,defnDefendentID
	   ,CASE
			WHEN ISDATE(FIELD14) = 1
				THEN FIELD14
			ELSE NULL
		END
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM WilliamPagerSaga.dbo.AUXUDFDF
	LEFT JOIN WilliamPagerSaga.dbo.MATTER
		ON MATTERID = REFERID
	LEFT JOIN sma_TRN_CaseS
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = casnOrgCaseTypeID
	LEFT JOIN sma_TRN_Defendants
		ON defnCaseID = casnCaseID
			AND defbIsPrimary = 1
	WHERE udfsUDFName = (
			SELECT
				text
			FROM WilliamPagerSaga.dbo.DESCTRL a
			LEFT JOIN WilliamPagerSaga.dbo.DESFORM b
				ON a.FORMID = b.FORMID
			WHERE b.DESCRIPTION LIKE 'Defendant%'
				AND CTRLTYPE IN (101, 202)
				AND CTRLNUM = 11
		)
		AND ISNULL(FIELD14, '') <> ''

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
	SELECT
		udfnUDFID
	   ,'Plaintiff'
	   ,'C'
	   ,casnCaseID
	   ,plnnplaintiffid
	   ,FIELD1
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM WilliamPagerSaga.dbo.AUXUDFPL
	LEFT JOIN WilliamPagerSaga.dbo.MATTER
		ON MATTERID = REFERID
	LEFT JOIN sma_TRN_CaseS
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = casnOrgCaseTypeID
	LEFT JOIN sma_TRN_Plaintiff
		ON plnnCaseID = casnCaseID
			AND plnbIsPrimary = 1
	WHERE udfsUDFName = (
			SELECT
				text
			FROM WilliamPagerSaga.dbo.DESCTRL a
			LEFT JOIN WilliamPagerSaga.dbo.DESFORM b
				ON a.FORMID = b.FORMID
			WHERE b.DESCRIPTION LIKE 'Plaintiff%'
				AND CTRLTYPE IN (101, 202)
				AND CTRLNUM = 2
		)
		AND ISNULL(FIELD1, '') <> ''
	UNION
	SELECT
		udfnUDFID
	   ,'Plaintiff'
	   ,'C'
	   ,casnCaseID
	   ,plnnPlaintiffID
	   ,FIELD2
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM WilliamPagerSaga.dbo.AUXUDFPL
	LEFT JOIN WilliamPagerSaga.dbo.MATTER
		ON MATTERID = REFERID
	LEFT JOIN sma_TRN_CaseS
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = casnOrgCaseTypeID
	LEFT JOIN sma_TRN_Plaintiff
		ON plnnCaseID = casnCaseID
			AND plnbIsPrimary = 1
	WHERE udfsUDFName = (
			SELECT
				text
			FROM WilliamPagerSaga.dbo.DESCTRL a
			LEFT JOIN WilliamPagerSaga.dbo.DESFORM b
				ON a.FORMID = b.FORMID
			WHERE b.DESCRIPTION LIKE 'Plaintiff%'
				AND CTRLTYPE IN (101, 202)
				AND CTRLNUM = 3
		)
		AND ISNULL(FIELD2, '') <> ''
	UNION
	SELECT
		udfnUDFID
	   ,'Plaintiff'
	   ,'C'
	   ,casnCaseID
	   ,plnnPlaintiffID
	   ,FIELD3
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM WilliamPagerSaga.dbo.AUXUDFPL
	LEFT JOIN WilliamPagerSaga.dbo.MATTER
		ON MATTERID = REFERID
	LEFT JOIN sma_TRN_CaseS
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = casnOrgCaseTypeID
	LEFT JOIN sma_TRN_Plaintiff
		ON plnnCaseID = casnCaseID
			AND plnbIsPrimary = 1
	WHERE udfsUDFName = (
			SELECT
				text
			FROM WilliamPagerSaga.dbo.DESCTRL a
			LEFT JOIN WilliamPagerSaga.dbo.DESFORM b
				ON a.FORMID = b.FORMID
			WHERE b.DESCRIPTION LIKE 'Plaintiff%'
				AND CTRLTYPE IN (101, 202)
				AND CTRLNUM = 4
		)
		AND ISNULL(FIELD3, '') <> ''
	UNION
	SELECT
		udfnUDFID
	   ,'Plaintiff'
	   ,'C'
	   ,casnCaseID
	   ,plnnPlaintiffID
	   ,FIELD4
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM WilliamPagerSaga.dbo.AUXUDFPL
	LEFT JOIN WilliamPagerSaga.dbo.MATTER
		ON MATTERID = REFERID
	LEFT JOIN sma_TRN_CaseS
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = casnOrgCaseTypeID
	LEFT JOIN sma_TRN_Plaintiff
		ON plnnCaseID = casnCaseID
			AND plnbIsPrimary = 1
	WHERE udfsUDFName = (
			SELECT
				text
			FROM WilliamPagerSaga.dbo.DESCTRL a
			LEFT JOIN WilliamPagerSaga.dbo.DESFORM b
				ON a.FORMID = b.FORMID
			WHERE b.DESCRIPTION LIKE 'Plaintiff%'
				AND CTRLTYPE IN (101, 202)
				AND CTRLNUM = 5
		)
		AND ISNULL(FIELD4, '') <> ''
	UNION
	SELECT
		udfnUDFID
	   ,'Plaintiff'
	   ,'C'
	   ,casnCaseID
	   ,plnnPlaintiffID
	   ,FIELD5
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM WilliamPagerSaga.dbo.AUXUDFPL
	LEFT JOIN WilliamPagerSaga.dbo.MATTER
		ON MATTERID = REFERID
	LEFT JOIN sma_TRN_CaseS
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = casnOrgCaseTypeID
	LEFT JOIN sma_TRN_Plaintiff
		ON plnnCaseID = casnCaseID
			AND plnbIsPrimary = 1
	WHERE udfsUDFName = (
			SELECT
				text
			FROM WilliamPagerSaga.dbo.DESCTRL a
			LEFT JOIN WilliamPagerSaga.dbo.DESFORM b
				ON a.FORMID = b.FORMID
			WHERE b.DESCRIPTION LIKE 'Plaintiff%'
				AND CTRLTYPE IN (101, 202)
				AND CTRLNUM = 6
		)
		AND ISNULL(FIELD5, '') <> ''

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
	SELECT
		udfnUDFID
	   ,'Plaintiff'
	   ,'C'
	   ,casnCaseID
	   ,plnnPlaintiffID
	   ,FIELD6
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM WilliamPagerSaga.dbo.AUXUDFPL
	LEFT JOIN WilliamPagerSaga.dbo.MATTER
		ON MATTERID = REFERID
	LEFT JOIN sma_TRN_CaseS
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = casnOrgCaseTypeID
	LEFT JOIN sma_TRN_Plaintiff
		ON plnnCaseID = casnCaseID
			AND plnbIsPrimary = 1
	WHERE udfsUDFName = (
			SELECT
				text
			FROM WilliamPagerSaga.dbo.DESCTRL a
			LEFT JOIN WilliamPagerSaga.dbo.DESFORM b
				ON a.FORMID = b.FORMID
			WHERE b.DESCRIPTION LIKE 'Plaintiff%'
				AND CTRLTYPE IN (101, 202)
				AND CTRLNUM = 12
		)
		AND FIELD6 IS NOT NULL
		AND FIELD6 <> 0
	UNION
	SELECT
		udfnUDFID
	   ,'Plaintiff'
	   ,'C'
	   ,casnCaseID
	   ,plnnPlaintiffID
	   ,FIELD7
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM WilliamPagerSaga.dbo.AUXUDFPL
	LEFT JOIN WilliamPagerSaga.dbo.MATTER
		ON MATTERID = REFERID
	LEFT JOIN sma_TRN_CaseS
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = casnOrgCaseTypeID
	LEFT JOIN sma_TRN_Plaintiff
		ON plnnCaseID = casnCaseID
			AND plnbIsPrimary = 1
	WHERE udfsUDFName = (
			SELECT
				text
			FROM WilliamPagerSaga.dbo.DESCTRL a
			LEFT JOIN WilliamPagerSaga.dbo.DESFORM b
				ON a.FORMID = b.FORMID
			WHERE b.DESCRIPTION LIKE 'Plaintiff%'
				AND CTRLTYPE IN (101, 202)
				AND CTRLNUM = 13
		)
		AND FIELD7 IS NOT NULL
		AND FIELD7 <> '0.00'
	UNION
	SELECT
		udfnUDFID
	   ,'Plaintiff'
	   ,'C'
	   ,casnCaseID
	   ,plnnPlaintiffID
	   ,FIELD8
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM WilliamPagerSaga.dbo.AUXUDFPL
	LEFT JOIN WilliamPagerSaga.dbo.MATTER
		ON MATTERID = REFERID
	LEFT JOIN sma_TRN_CaseS
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = casnOrgCaseTypeID
	LEFT JOIN sma_TRN_Plaintiff
		ON plnnCaseID = casnCaseID
			AND plnbIsPrimary = 1
	WHERE udfsUDFName = (
			SELECT
				text
			FROM WilliamPagerSaga.dbo.DESCTRL a
			LEFT JOIN WilliamPagerSaga.dbo.DESFORM b
				ON a.FORMID = b.FORMID
			WHERE b.DESCRIPTION LIKE 'Plaintiff%'
				AND CTRLTYPE IN (101, 202)
				AND CTRLNUM = 14
		)
		AND FIELD8 IS NOT NULL
		AND FIELD8 <> '0.00'

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

	SELECT
		udfnUDFID
	   ,'Plaintiff'
	   ,'C'
	   ,casnCaseID
	   ,plnnPlaintiffID
	   ,CASE
			WHEN FIELD9 = 'T'
				THEN 'Yes'
			ELSE FIELD9
		END
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM WilliamPagerSaga.dbo.AUXUDFPL
	LEFT JOIN WilliamPagerSaga.dbo.MATTER
		ON MATTERID = REFERID
	LEFT JOIN sma_TRN_CaseS
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = casnOrgCaseTypeID
	LEFT JOIN sma_TRN_Plaintiff
		ON plnnCaseID = casnCaseID
			AND plnbIsPrimary = 1
	WHERE udfsUDFName = (
			SELECT
				text
			FROM WilliamPagerSaga.dbo.DESCTRL a
			LEFT JOIN WilliamPagerSaga.dbo.DESFORM b
				ON a.FORMID = b.FORMID
			WHERE b.DESCRIPTION LIKE 'Plaintiff%'
				AND CTRLTYPE IN (101, 202)
				AND CTRLNUM = 28
		)
		AND ISNULL(FIELD9, '') <> ''
		AND FIELD9 <> 'F'
	UNION
	SELECT
		udfnUDFID
	   ,'Plaintiff'
	   ,'C'
	   ,casnCaseID
	   ,plnnPlaintiffID
	   ,CASE
			WHEN FIELD10 = 'T'
				THEN 'Yes'
			ELSE FIELD10
		END
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM WilliamPagerSaga.dbo.AUXUDFPL
	LEFT JOIN WilliamPagerSaga.dbo.MATTER
		ON MATTERID = REFERID
	LEFT JOIN sma_TRN_CaseS
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = casnOrgCaseTypeID
	LEFT JOIN sma_TRN_Plaintiff
		ON plnnCaseID = casnCaseID
			AND plnbIsPrimary = 1
	WHERE udfsUDFName = (
			SELECT
				text
			FROM WilliamPagerSaga.dbo.DESCTRL a
			LEFT JOIN WilliamPagerSaga.dbo.DESFORM b
				ON a.FORMID = b.FORMID
			WHERE b.DESCRIPTION LIKE 'Plaintiff%'
				AND CTRLTYPE IN (101, 202)
				AND CTRLNUM = 29
		)
		AND FIELD10 IS NOT NULL
		AND FIELD10 <> 'F'

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
	SELECT
		udfnUDFID
	   ,'Plaintiff'
	   ,'C'
	   ,casnCaseID
	   ,plnnPlaintiffID
	   ,CASE
			WHEN ISDATE(FIELD11) = 1
				THEN FIELD11
			ELSE NULL
		END
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM WilliamPagerSaga.dbo.AUXUDFPL
	LEFT JOIN WilliamPagerSaga.dbo.MATTER
		ON MATTERID = REFERID
	LEFT JOIN sma_TRN_CaseS
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = casnOrgCaseTypeID
	LEFT JOIN sma_TRN_Plaintiff
		ON plnnCaseID = casnCaseID
			AND plnbIsPrimary = 1
	WHERE udfsUDFName = (
			SELECT
				text
			FROM WilliamPagerSaga.dbo.DESCTRL a
			LEFT JOIN WilliamPagerSaga.dbo.DESFORM b
				ON a.FORMID = b.FORMID
			WHERE b.DESCRIPTION LIKE 'Plaintiff%'
				AND CTRLTYPE IN (101, 202)
				AND CTRLNUM = 8
		)
		AND ISNULL(FIELD11, '') <> ''
	UNION
	SELECT
		udfnUDFID
	   ,'Plaintiff'
	   ,'C'
	   ,casnCaseID
	   ,plnnPlaintiffID
	   ,CASE
			WHEN ISDATE(FIELD12) = 1
				THEN FIELD12
			ELSE NULL
		END
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM WilliamPagerSaga.dbo.AUXUDFPL
	LEFT JOIN WilliamPagerSaga.dbo.MATTER
		ON MATTERID = REFERID
	LEFT JOIN sma_TRN_CaseS
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = casnOrgCaseTypeID
	LEFT JOIN sma_TRN_Plaintiff
		ON plnnCaseID = casnCaseID
			AND plnbIsPrimary = 1
	WHERE udfsUDFName = (
			SELECT
				text
			FROM WilliamPagerSaga.dbo.DESCTRL a
			LEFT JOIN WilliamPagerSaga.dbo.DESFORM b
				ON a.FORMID = b.FORMID
			WHERE b.DESCRIPTION LIKE 'Plaintiff%'
				AND CTRLTYPE IN (101, 202)
				AND CTRLNUM = 9
		)
		AND ISNULL(FIELD12, '') <> ''
	UNION
	SELECT
		udfnUDFID
	   ,'Plaintiff'
	   ,'C'
	   ,casnCaseID
	   ,plnnPlaintiffID
	   ,CASE
			WHEN ISDATE(FIELD13) = 1
				THEN FIELD13
			ELSE NULL
		END
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM WilliamPagerSaga.dbo.AUXUDFPL
	LEFT JOIN WilliamPagerSaga.dbo.MATTER
		ON MATTERID = REFERID
	LEFT JOIN sma_TRN_CaseS
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = casnOrgCaseTypeID
	LEFT JOIN sma_TRN_Plaintiff
		ON plnnCaseID = casnCaseID
			AND plnbIsPrimary = 1
	WHERE udfsUDFName = (
			SELECT
				text
			FROM WilliamPagerSaga.dbo.DESCTRL a
			LEFT JOIN WilliamPagerSaga.dbo.DESFORM b
				ON a.FORMID = b.FORMID
			WHERE b.DESCRIPTION LIKE 'Plaintiff%'
				AND CTRLTYPE IN (101, 202)
				AND CTRLNUM = 10
		)
		AND ISNULL(FIELD13, '') <> ''
	UNION
	SELECT
		udfnUDFID
	   ,'Plaintiff'
	   ,'C'
	   ,casnCaseID
	   ,plnnPlaintiffID
	   ,CASE
			WHEN ISDATE(FIELD14) = 1
				THEN FIELD14
			ELSE NULL
		END
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM WilliamPagerSaga.dbo.AUXUDFPL
	LEFT JOIN WilliamPagerSaga.dbo.MATTER
		ON MATTERID = REFERID
	LEFT JOIN sma_TRN_CaseS
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = casnOrgCaseTypeID
	LEFT JOIN sma_TRN_Plaintiff
		ON plnnCaseID = casnCaseID
			AND plnbIsPrimary = 1
	WHERE udfsUDFName = (
			SELECT
				text
			FROM WilliamPagerSaga.dbo.DESCTRL a
			LEFT JOIN WilliamPagerSaga.dbo.DESFORM b
				ON a.FORMID = b.FORMID
			WHERE b.DESCRIPTION LIKE 'Plaintiff%'
				AND CTRLTYPE IN (101, 202)
				AND CTRLNUM = 11
		)
		AND ISNULL(FIELD14, '') <> ''

--select notes,* from ASSIGN a left join note n on n.NOTEID=a.NOTEID where  ROLEDETAILS like '145-%'

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
	   ,'Role  Details'
	   ,'Plaintiff'
	   ,'Text'
	   ,5000
	   ,NULL
	   ,NULL
	   ,''
	   ,NULL
	   ,2001
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
	   ,'Plaintiff Comments'
	   ,'Plaintiff'
	   ,'Text'
	   ,50000
	   ,NULL
	   ,NULL
	   ,''
	   ,NULL
	   ,2002
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
	SELECT
		udfnUDFID
	   ,'Plaintiff'
	   ,'C'
	   ,casnCaseID
	   ,CASE
			WHEN p1.plnnPlaintiffID IS NOT NULL
				THEN p1.plnnPlaintiffID
			WHEN p2.plnnPlaintiffID IS NOT NULL
				THEN p2.plnnPlaintiffID
		END
	   ,ROLEDETAILS
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM WilliamPagerSaga.dbo.ASSIGN a
	LEFT JOIN WilliamPagerSaga.dbo.matter m
		ON a.MATTERID = m.MATTERID
	LEFT JOIN sma_trn_cases
		ON cassCaseNumber = MATTERNUMBER
	OUTER APPLY (
		SELECT TOP 1
			plnnplaintiffid
		FROM sma_TRN_Plaintiff
		LEFT JOIN sma_MST_IndvContacts
			ON plnnContactID = cinnContactID
			AND plnnContactCtg = 1
		WHERE plnnCaseid = casnCaseID
			AND cinsGrade = a.ENTITYID
			AND plnnContactCtg = 1
	) p1
	OUTER APPLY (
		SELECT TOP 1
			plnnplaintiffid
		FROM sma_TRN_Plaintiff
		LEFT JOIN sma_MST_orgContacts
			ON plnnContactID = connContactID
			AND plnnContactCtg = 2
		WHERE plnnCaseid = casnCaseID
			AND connLevelNo = a.ENTITYID
			AND plnnContactCtg = 1
	) p2
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = casnOrgCaseTypeID
			AND udfsUDFName = 'Role  Details'
	WHERE a.partytype = 1
		AND ISNULL(ROLEDETAILS, '') <> ''


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
	SELECT
		udfnUDFID
	   ,'Plaintiff'
	   ,'C'
	   ,casnCaseID
	   ,CASE
			WHEN p1.plnnPlaintiffID IS NOT NULL
				THEN p1.plnnPlaintiffID
			WHEN p2.plnnPlaintiffID IS NOT NULL
				THEN p2.plnnPlaintiffID
		END
	   ,CONVERT(VARCHAR(MAX), LTRIM(REPLACE(
		dbo.RegExReplace(notes, '({\\)(.+?)(})|(\\)(.+?)(\b)', '')
		, '}', '')
		))
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM WilliamPagerSaga.dbo.ASSIGN a
	LEFT JOIN WilliamPagerSaga.dbo.matter m
		ON a.MATTERID = m.MATTERID
	LEFT JOIN WilliamPagerSaga.dbo.note n
		ON n.NOTEID = a.NOTEID
	LEFT JOIN sma_trn_cases
		ON cassCaseNumber = MATTERNUMBER
	OUTER APPLY (
		SELECT TOP 1
			plnnplaintiffid
		FROM sma_TRN_Plaintiff
		LEFT JOIN sma_MST_IndvContacts
			ON plnnContactID = cinnContactID
			AND plnnContactCtg = 1
		WHERE plnnCaseid = casnCaseID
			AND cinsGrade = a.ENTITYID
			AND plnnContactCtg = 1
	) p1
	OUTER APPLY (
		SELECT TOP 1
			plnnplaintiffid
		FROM sma_TRN_Plaintiff
		LEFT JOIN sma_MST_orgContacts
			ON plnnContactID = connContactID
			AND plnnContactCtg = 2
		WHERE plnnCaseid = casnCaseID
			AND connLevelNo = a.ENTITYID
			AND plnnContactCtg = 1
	) p2
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = casnOrgCaseTypeID
			AND udfsUDFName = 'Plaintiff Comments'
	WHERE a.partytype = 1
		AND ISNULL(CONVERT(VARCHAR(MAX), LTRIM(REPLACE(
		dbo.RegExReplace(notes, '({\\)(.+?)(})|(\\)(.+?)(\b)', '')
		, '}', '')

		)), '') <> ''

--select * from  WilliamPagerSaga.dbo.DESCTRL a
--left join WilliamPagerSaga.dbo.DESFORM b on a.FORMID=b.FORMID
--where b.DESCRIPTION like 'plain%' and CTRLTYPE in (101,202)
GO

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
		'C'
	   ,cstnCaseTypeID
	   ,'In hospital'
	   ,'Plaintiff'
	   ,'Text'
	   ,1000
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,2001
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
	SELECT DISTINCT
		'C'
	   ,cstnCaseTypeID
	   ,'Confined to home'
	   ,'Plaintiff'
	   ,'Text'
	   ,1000
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,2002
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
	SELECT DISTINCT
		'C'
	   ,cstnCaseTypeID
	   ,'Confined to bed'
	   ,'Plaintiff'
	   ,'Text'
	   ,1000
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,2003
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
	SELECT DISTINCT
		'C'
	   ,cstnCaseTypeID
	   ,'Incapacitated'
	   ,'Plaintiff'
	   ,'Text'
	   ,1000
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,2004
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

GO
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
	   ,'Plaintiff'
	   ,'C'
	   ,casnCaseID
	   ,plnnPlaintiffID
	   ,INHOSPITAL
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM [WilliamPagerSaga].dbo.LW_injury li
	LEFT JOIN [WilliamPagerSaga].dbo.assign a
		ON li.assignid = a.assignid
	LEFT JOIN [WilliamPagerSaga].dbo.matter m
		ON a.matterid = m.matterid
	LEFT JOIN [WilliamPagerSaga].dbo.entities e
		ON a.entityid = e.entityid
	LEFT JOIN sma_MST_IndvContacts l
		ON l.cinsGrade = e.ENTITYID
	LEFT JOIN sma_MST_OrgContacts k
		ON k.connLevelNo = e.ENTITYID
	LEFT JOIN sma_trn_cases
		ON cassCaseNumber = m.MATTERNUMBER
	LEFT JOIN sma_TRN_Plaintiff
		ON ((plnnContactID = k.conncontactid
					AND plnnContactCtg = 2)
				OR (plnnContactID = l.cinncontactid
					AND plnnContactCtg = 1))
			AND plnnCaseID = casnCaseID
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = casnOrgCaseTypeID
	WHERE casnCaseID IS NOT NULL
		AND plnnPlaintiffID IS NOT NULL
		AND udfsUDFName = 'In hospital'
		AND ISNULL(INHOSPITAL, '') <> ''
	UNION
	SELECT DISTINCT
		udfnUDFID
	   ,'Plaintiff'
	   ,'C'
	   ,casnCaseID
	   ,plnnPlaintiffID
	   ,CONFINEDHOME
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM [WilliamPagerSaga].dbo.LW_injury li
	LEFT JOIN [WilliamPagerSaga].dbo.assign a
		ON li.assignid = a.assignid
	LEFT JOIN [WilliamPagerSaga].dbo.matter m
		ON a.matterid = m.matterid
	LEFT JOIN [WilliamPagerSaga].dbo.entities e
		ON a.entityid = e.entityid
	LEFT JOIN sma_MST_IndvContacts l
		ON l.cinsGrade = e.ENTITYID
	LEFT JOIN sma_MST_OrgContacts k
		ON k.connLevelNo = e.ENTITYID
	LEFT JOIN sma_trn_cases
		ON cassCaseNumber = m.MATTERNUMBER
	LEFT JOIN sma_TRN_Plaintiff
		ON ((plnnContactID = k.conncontactid
					AND plnnContactCtg = 2)
				OR (plnnContactID = l.cinncontactid
					AND plnnContactCtg = 1))
			AND plnnCaseID = casnCaseID
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = casnOrgCaseTypeID
	WHERE casnCaseID IS NOT NULL
		AND plnnPlaintiffID IS NOT NULL
		AND udfsUDFName = 'Confined to home'
		AND ISNULL(CONFINEDHOME, '') <> ''
	UNION
	SELECT DISTINCT
		udfnUDFID
	   ,'Plaintiff'
	   ,'C'
	   ,casnCaseID
	   ,plnnPlaintiffID
	   ,CONFINEDBED
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM [WilliamPagerSaga].dbo.LW_injury li
	LEFT JOIN [WilliamPagerSaga].dbo.assign a
		ON li.assignid = a.assignid
	LEFT JOIN [WilliamPagerSaga].dbo.matter m
		ON a.matterid = m.matterid
	LEFT JOIN [WilliamPagerSaga].dbo.entities e
		ON a.entityid = e.entityid
	LEFT JOIN sma_MST_IndvContacts l
		ON l.cinsGrade = e.ENTITYID
	LEFT JOIN sma_MST_OrgContacts k
		ON k.connLevelNo = e.ENTITYID
	LEFT JOIN sma_trn_cases
		ON cassCaseNumber = m.MATTERNUMBER
	LEFT JOIN sma_TRN_Plaintiff
		ON ((plnnContactID = k.conncontactid
					AND plnnContactCtg = 2)
				OR (plnnContactID = l.cinncontactid
					AND plnnContactCtg = 1))
			AND plnnCaseID = casnCaseID
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = casnOrgCaseTypeID
	WHERE casnCaseID IS NOT NULL
		AND plnnPlaintiffID IS NOT NULL
		AND udfsUDFName = 'Confined to bed'
		AND ISNULL(CONFINEDBED, '') <> ''
	UNION
	SELECT DISTINCT
		udfnUDFID
	   ,'Plaintiff'
	   ,'C'
	   ,casnCaseID
	   ,plnnPlaintiffID
	   ,INCAPACITATED
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM [WilliamPagerSaga].dbo.LW_injury li
	LEFT JOIN [WilliamPagerSaga].dbo.assign a
		ON li.assignid = a.assignid
	LEFT JOIN [WilliamPagerSaga].dbo.matter m
		ON a.matterid = m.matterid
	LEFT JOIN [WilliamPagerSaga].dbo.entities e
		ON a.entityid = e.entityid
	LEFT JOIN sma_MST_IndvContacts l
		ON l.cinsGrade = e.ENTITYID
	LEFT JOIN sma_MST_OrgContacts k
		ON k.connLevelNo = e.ENTITYID
	LEFT JOIN sma_trn_cases
		ON cassCaseNumber = m.MATTERNUMBER
	LEFT JOIN sma_TRN_Plaintiff
		ON ((plnnContactID = k.conncontactid
					AND plnnContactCtg = 2)
				OR (plnnContactID = l.cinncontactid
					AND plnnContactCtg = 1))
			AND plnnCaseID = casnCaseID
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = casnOrgCaseTypeID
	WHERE casnCaseID IS NOT NULL
		AND plnnPlaintiffID IS NOT NULL
		AND udfsUDFName = 'Incapacitated'
		AND ISNULL(INCAPACITATED, '') <> '' 
