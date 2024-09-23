USE WilliamPagerSA

ALTER TABLE sma_TRN_CaseStaff DISABLE TRIGGER ALL


INSERT INTO [sma_TRN_CaseStaff]
	(
	[cssnCaseID]
   ,[cssnStaffID]
   ,[cssnRoleID]
   ,[csssComments]
   ,[cssdFromDate]
   ,[cssdToDate]
   ,[cssnRecUserID]
   ,[cssdDtCreated]
   ,[cssnModifyUserID]
   ,[cssdDtModified]
   ,[cssnLevelNo]
	)
	SELECT DISTINCT
		casnCaseID
	   ,i1.cinnContactID
	   ,CASE
			WHEN z.DESCRIPTION = 'Secretary'
				THEN 19000
			WHEN z.DESCRIPTION = 'Attorney - Primary'
				THEN 5
			WHEN z.DESCRIPTION = 'Paralegal - Primary'
				THEN 6
			WHEN z.DESCRIPTION = 'Attorney  - Primary (our office)'
				THEN 5
			WHEN z.DESCRIPTION = 'Attorney - Subsequent'
				THEN 1
			WHEN z.DESCRIPTION = 'Paralegal'
				THEN 3
			WHEN z.DESCRIPTION = 'Paralegal - Primary'
				THEN 6
			WHEN z.DESCRIPTION = 'Attorney'
				THEN 1
			WHEN z.DESCRIPTION = 'Primary Attorney'
				THEN 5
			WHEN z.DESCRIPTION = 'Managing Attorney'
				THEN 8
			WHEN z.DESCRIPTION = 'Attorney - Primary (our Staff)'
				THEN 5
			WHEN z.DESCRIPTION LIKE '%attorney%'
				THEN 1
			WHEN z.DESCRIPTION LIKE '%paralegal%'
				THEN 3
			ELSE 19000
		END
	   ,z.DESCRIPTION
	   ,CASE
			WHEN (a.DATECREATED NOT BETWEEN '1900-01-01' AND '2079-12-31')
				THEN GETDATE()
			ELSE (a.DATECREATED)
		END
	   ,NULL
	   ,u1.usrnUserID
	   ,CASE
			WHEN (a.DATECREATED NOT BETWEEN '1900-01-01' AND '2079-12-31')
				THEN GETDATE()
			ELSE (a.DATECREATED)
		END
	   ,u2.usrnUserID
	   ,CASE
			WHEN (a.DATEREVISED NOT BETWEEN '1900-01-01' AND '2079-12-31')
				THEN GETDATE()
			ELSE (a.DATEREVISED)
		END
	   ,NULL
	FROM [WilliamPagerSaga].[dbo].ASSIGN a
	LEFT JOIN [WilliamPagerSaga].[dbo].[MATTER] b
		ON b.MATTERID = a.MATTERID
	LEFT JOIN [WilliamPagerSaga].[dbo].[EROLE] z
		ON z.ROLEID = a.ROLEID
	LEFT JOIN sma_TRN_Cases
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_IndvContacts i1
		ON LTRIM(RTRIM(i1.cinsGrade)) = a.ENTITYID
	--left join sma_MST_SubRole on sbrsDscrptn=case when z.ROLEID in (101,102,105,103,104) then z.DESCRIPTION else 'Attorney' end
	LEFT JOIN sma_MST_IndvContacts l
		ON l.cinsGrade = a.CREATORID
	LEFT JOIN sma_MST_Users u1
		ON u1.usrnContactID = l.cinnContactID
	LEFT JOIN sma_MST_IndvContacts m
		ON m.cinsGrade = a.REVISORID
	LEFT JOIN sma_MST_Users u2
		ON u2.usrnContactID = m.cinnContactID
	WHERE z.ROLECATEGORYID IN (0, 1, 2, 3, 4, 5)
		AND a.ENTITYID IN (
			SELECT
				cinsGrade
			FROM sma_MST_Users
			JOIN sma_MST_IndvContacts
				ON cinnContactID = usrnContactID
			WHERE cinsGrade IS NOT NULL
		)


INSERT INTO [sma_TRN_CaseStaff]
	(
	[cssnCaseID]
   ,[cssnStaffID]
   ,[cssnRoleID]
   ,[csssComments]
   ,[cssdFromDate]
   ,[cssdToDate]
   ,[cssnRecUserID]
   ,[cssdDtCreated]
   ,[cssnModifyUserID]
   ,[cssdDtModified]
   ,[cssnLevelNo]
	)
	SELECT
		casnCaseID
	   ,8
	   ,1
	   ,'UnAssigned Staff'
	   ,GETDATE()
	   ,NULL
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM sma_TRN_Cases
	WHERE casnCaseID NOT IN (
			SELECT
				cssnCaseID
			FROM sma_TRN_CaseStaff
		)

DELETE FROM sma_TRN_CaseStaff
WHERE cssnPKID NOT IN (
		SELECT
			MIN(cssnPKID)
		FROM sma_TRN_CaseStaff
		GROUP BY cssnCaseID
				,cssnStaffID
	)


ALTER TABLE sma_TRN_CaseStaff ENABLE TRIGGER ALL