USE WilliamPagerSA

ALTER TABLE [sma_TRN_CaseStatus] DISABLE TRIGGER ALL

INSERT INTO sma_MST_CaseStatus
	(
	csssDescription
   ,cssnStatusTypeID
   ,cssnRecUserID
   ,cssdDtCreated
   ,SGsStatusType
	)
	SELECT
		LTRIM(RTRIM(description))
	   ,1
	   ,8
	   ,GETDATE()
	   ,'Status'
	FROM [WilliamPagerSaga].[dbo].[STATUS]
	WHERE DESCRIPTION NOT LIKE '%closed%'
	EXCEPT
	SELECT
		LTRIM(RTRIM(csssdescription))
	   ,1
	   ,8
	   ,GETDATE()
	   ,'Status'
	FROM sma_MST_CaseStatus
	WHERE csssDescription IN (
			SELECT
				description
			FROM [WilliamPagerSaga].[dbo].[STATUS]
		)
		AND cssnStatusTypeID = 1


INSERT INTO [sma_TRN_CaseStatus]
	(
	[cssnCaseID]
   ,[cssnStatusTypeID]
   ,[cssnStatusID]
   ,[cssnExpDays]
   ,[cssdFromDate]
   ,[cssdToDt]
   ,[csssComments]
   ,[cssnRecUserID]
   ,[cssdDtCreated]
   ,[cssnModifyUserID]
   ,[cssdDtModified]
   ,[cssnLevelNo]
   ,[cssnDelFlag]
	)
	SELECT
		casnCaseID
	   ,1
	   ,CASE
			WHEN b.DESCRIPTION LIKE '%closed%'
				THEN 9
			ELSE cssnStatusID
		END
	   ,cssnExpNoOfDays
	   ,a.STATUSDATE
	   ,NULL
	   ,CASE
			WHEN b.DESCRIPTION LIKE '%closed%'
				THEN b.DESCRIPTION
			ELSE ''
		END
	   ,u1.usrnUserID
	   ,a.STATUSDATE
	   ,u2.usrnUserID
	   ,a.DATEREVISED
	   ,NULL
	   ,NULL
	FROM [WilliamPagerSaga].[dbo].[Matter] a
	LEFT JOIN sma_trn_cases
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN [WilliamPagerSaga].[dbo].[STATUS] b
		ON a.STATUSID = b.STATUSID
	LEFT JOIN sma_MST_CaseStatus
		ON csssDescription = LTRIM(RTRIM(b.description))
	LEFT JOIN sma_MST_IndvContacts l
		ON l.cinsGrade = a.CREATORID
	LEFT JOIN sma_mst_users u1
		ON u1.usrnContactID = l.cinnContactID
	LEFT JOIN sma_MST_IndvContacts m
		ON m.cinsGrade = a.REVISORID
	LEFT JOIN sma_mst_users u2
		ON u2.usrnContactID = m.cinnContactID
	WHERE casnCaseID IS NOT NULL

INSERT INTO [sma_TRN_CaseStatus]
	(
	[cssnCaseID]
   ,[cssnStatusTypeID]
   ,[cssnStatusID]
   ,[cssnExpDays]
   ,[cssdFromDate]
   ,[cssdToDt]
   ,[csssComments]
   ,[cssnRecUserID]
   ,[cssdDtCreated]
   ,[cssnModifyUserID]
   ,[cssdDtModified]
   ,[cssnLevelNo]
   ,[cssnDelFlag]
	)
	SELECT DISTINCT
		casnCaseID
	   ,1
	   ,cssnStatusID
	   ,cssnExpNoOfDays
	   ,b.STATUSDATE
	   ,DATEPOSTED
	   ,''
	   ,u1.usrnUserID
	   ,b.STATUSDATE
	   ,u1.usrnUserID
	   ,b.DATEPOSTED
	   ,NULL
	   ,NULL
	FROM [WilliamPagerSaga].[dbo].[MATTER_STATUS_HISTORY] b
	LEFT JOIN [WilliamPagerSaga].[dbo].[Matter] a
		ON a.matterid = b.MATTERID
	LEFT JOIN sma_trn_cases
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_CaseStatus
		ON csssDescription = LTRIM(RTRIM(b.STATUS))
	LEFT JOIN sma_MST_IndvContacts l
		ON l.cinsGrade = b.POSTEDBY
	LEFT JOIN sma_mst_users u1
		ON u1.usrnContactID = l.cinnContactID
	WHERE casnCaseID IS NOT NULL
ALTER TABLE [sma_TRN_CaseStatus] ENABLE TRIGGER ALL


ALTER TABLE sma_trn_cases DISABLE TRIGGER ALL

UPDATE a
SET casdClosingDate = cssdfromdate
FROM sma_trn_cases a
LEFT JOIN sma_TRN_CaseStatus
	ON cssnCaseID = casnCaseID
WHERE cssnStatusID IN (
	SELECT
		StatusID
	FROM sma_TRN_CaseStagesStatus
	WHERE StageID = 5
)
AND cssdToDt IS NULL

ALTER TABLE sma_trn_cases ENABLE TRIGGER ALL

ALTER TABLE sma_TRN_CaseStatus DISABLE TRIGGER ALL
UPDATE cs
SET csssComments = ISNULL(CASE
	WHEN LASTREVIEW IS NOT NULL
		THEN ISNULL('Last Review: ' + CONVERT(VARCHAR(20), LASTREVIEW, 101), '')
	ELSE ''
END, '') +
ISNULL(CASE
	WHEN LASTREVIEWBYID IS NOT NULL
		THEN ISNULL(CHAR(13) + 'Last Reviewed By: ' + cinsLastName + ', ' + cinsFirstName, '')
	ELSE ''
END, '')
FROM WilliamPagerSaga.dbo.MATTER m
LEFT JOIN sma_trn_cases
	ON cassCaseNumber = MATTERNUMBER
LEFT JOIN sma_TRN_CaseStatus cs
	ON cssnCaseID = casnCaseID
	AND cssdToDt IS NULL
	AND cssnStatusTypeID = 1
LEFT JOIN sma_mst_indvcontacts
	ON cinsGrade = LASTREVIEWBYID
WHERE ISNULL(CASE
	WHEN LASTREVIEW IS NOT NULL
		THEN ISNULL('Last Review: ' + CONVERT(VARCHAR(20), LASTREVIEW, 101), '')
	ELSE ''
END, '') +
ISNULL(CASE
	WHEN LASTREVIEWBYID IS NOT NULL
		THEN ISNULL(CHAR(13) + 'Last Reviewed By: ' + cinsLastName + ', ' + cinsFirstName, '')
	ELSE ''
END, '') <> ''
ALTER TABLE sma_TRN_CaseStatus ENABLE TRIGGER ALL

GO
