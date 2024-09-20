USE WilliamPagerSA

DECLARE @CaseTypeID INT
SELECT
	@CaseTypeID = MAX(cstncasetypeid)
FROM sma_MST_CaseType

INSERT INTO [sma_MST_CaseStatus]
	(
	[csssCode]
   ,[csssDescription]
   ,[cssnStatusTypeID]
   ,[cssnClientStatusID]
   ,[cssnExpNoOfDays]
   ,[cssnRecUserID]
   ,[cssdDtCreated]
   ,[cssnModifyUserID]
   ,[cssdDtModified]
   ,[cssnLevelNo]
   ,[cssbBlockRetComment]
   ,[SGsStatusType]
	)
	SELECT
		''
	   ,DESCRIPTION
	   ,1
	   ,NULL
	   ,''
	   ,CASE ISNULL(u1.usrnuserid, '')
			WHEN ''
				THEN 368
			ELSE u1.usrnuserid
		END
	   ,GETDATE()
	   ,u2.usrnuserid
	   ,GETDATE()
	   ,''
	   ,SHOWMODE
	   ,STATUSID
	FROM [WilliamPagerSaga].[dbo].[STATUS]
	LEFT JOIN sma_MST_IndvContacts a
		ON a.cinsGrade = CREATORID
	LEFT JOIN sma_mst_users u1
		ON u1.usrnContactID = a.cinnContactID
	LEFT JOIN sma_MST_IndvContacts b
		ON b.cinsGrade = REVISORID
	LEFT JOIN sma_mst_users u2
		ON u2.usrnContactID = b.cinnContactID
	WHERE LTRIM(RTRIM(DESCRIPTION)) NOT IN (
			SELECT
				LTRIM(RTRIM(csssDescription))
			FROM sma_MST_CaseStatus
			WHERE cssnStatusTypeID = 1
		)
		AND LTRIM(RTRIM(DESCRIPTION)) NOT LIKE '%closed%'


INSERT INTO sma_TRN_CaseStagesStatus
	(
	StageID
   ,StatusID
   ,CreatedDt
   ,CreatedBy
	)
	SELECT
		5
	   ,cssnStatusID
	   ,GETDATE()
	   ,368
	FROM sma_MST_CaseStatus
	WHERE csssDescription IN ('Rejected', 'Settled', 'Rejected and scanned', 'SET7 - Settled and Scanned', 'Withdrew', 'Discontinued')
		AND cssnStatusTypeID = 1

--alter table sma_mst_casegroup 
--alter column [incident_type] varchar(500)

INSERT INTO [sma_MST_CaseGroup]
	(
	[cgpsCode]
   ,[cgpsDscrptn]
   ,[cgpnRecUserId]
   ,[cgpdDtCreated]
   ,[cgpnModifyUserID]
   ,[cgpdDtModified]
   ,[cgpnLevelNo]
	)--,[cgpsIncidentScreen],[incident_type])
	SELECT
		[CODE]
	   ,[description]
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''--,'frmIncident'+code,[description]
	FROM [WilliamPagerSaga].[dbo].[LAWCAT] a
	WHERE [description] NOT IN (
			SELECT
				[cgpsDscrptn]
			FROM [sma_MST_CaseGroup]
		)


INSERT INTO [sma_MST_CaseType]
	(
	[cstsCode]
   ,[cstsType]
   ,[cstsSubType]
   ,[cstnWorkflowTemplateID]
   ,[cstnExpectedResolutionDays]
   ,[cstnRecUserID]
   ,[cstdDtCreated]
   ,[cstnModifyUserID]
   ,[cstdDtModified]
   ,[cstnLevelNo]
   ,[cstbTimeTracking]
   ,[cstnGroupID]
   ,[cstnGovtMunType]
   ,[cstnIsMassTort]
   ,cstbActive
	)

	SELECT DISTINCT
		''
	   ,c.DESCRIPTION
	   ,''
	   ,NULL
	   ,720
	   ,1
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	   ,0
	   ,cgpncasegroupid
	   ,NULL
	   ,NULL
	   ,1
	FROM [WilliamPagerSaga].[dbo].[LAWTYPE] c
	LEFT JOIN sma_MST_CaseType
		ON cstsType = c.DESCRIPTION
	LEFT JOIN [WilliamPagerSaga].[dbo].[LAWCAT] a
		ON a.[LAWCATEGORYID] = c.[LAWCATEGORYID]
	LEFT JOIN sma_mst_casegroup
		ON cgpsdscrptn = a.description
	WHERE c.DESCRIPTION NOT IN (
			SELECT
				cststype
			FROM sma_mst_casetype
		)

INSERT INTO [sma_MST_CaseSubType]
	(
	[cstsCode]
   ,[cstnGroupID]
   ,[cstsDscrptn]
   ,[cstnRecUserId]
   ,[cstdDtCreated]
   ,[cstnModifyUserID]
   ,[cstdDtModified]
   ,[cstnLevelNo]
   ,[cstbDefualt]
   ,[saga]
	)
	SELECT DISTINCT
		''
	   ,cstncasetypeid
	   ,d.description
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,NULL
	   ,1
	   ,''
	FROM [WilliamPagerSaga].[dbo].[LAWTYPE] c
	LEFT JOIN sma_MST_CaseType
		ON cstsType = c.DESCRIPTION
	CROSS JOIN WilliamPagerSaga.dbo.LW_A_MATTERTYPE d
	WHERE cstncasetypeid >= @CaseTypeID

INSERT INTO [sma_MST_SubRole]
	(
	[sbrsCode]
   ,[sbrnRoleID]
   ,[sbrsDscrptn]
   ,[sbrnCaseTypeID]
   ,[sbrnPriority]
   ,[sbrnRecUserID]
   ,[sbrdDtCreated]
   ,[sbrnModifyUserID]
   ,[sbrdDtModified]
   ,[sbrnLevelNo]
   ,[sbrbDefualt]
   ,[saga]
	)
	SELECT
		[sbrsCode]
	   ,[sbrnRoleID]
	   ,[sbrsDscrptn]
	   ,cstncasetypeid
	   ,[sbrnPriority]
	   ,[sbrnRecUserID]
	   ,[sbrdDtCreated]
	   ,[sbrnModifyUserID]
	   ,[sbrdDtModified]
	   ,[sbrnLevelNo]
	   ,[sbrbDefualt]
	   ,[saga]
	FROM [WilliamPagerSaga].[dbo].[LAWTYPE] c
	LEFT JOIN sma_MST_CaseType
		ON cstsType = c.DESCRIPTION
	LEFT JOIN sma_mst_subrole
		ON cstncasetypeid = [sbrnCaseTypeID]
			OR [sbrnCaseTypeID] = 1
	WHERE cstncasetypeid >= @CaseTypeID

INSERT INTO [sma_MST_StateCaseTypes]
	(
	[stcnCaseTypeID]
   ,[stcnStateID]
	)
	SELECT DISTINCT
		cstnCaseTypeID
	   ,sttnStateID
	FROM [WilliamPagerSaga].[dbo].[LAWTYPE] c
	LEFT JOIN sma_MST_CaseType
		ON cstsType = c.DESCRIPTION
	CROSS JOIN sma_mst_states
	WHERE cstnCaseTypeID NOT IN (
			SELECT
				stcncasetypeid
			FROM sma_MST_StateCaseTypes
		)



INSERT INTO [sma_MST_CaseTypeDefualtDefs]
	(
	[cddnCaseTypeID]
   ,[cddnDefContatID]
   ,[cddnDefContactCtgID]
   ,[cddnRoleID]
   ,[cddnDefAddressID]
	)
	SELECT
		cstncasetypeid
	   ,9
	   ,1
	   ,sbrnSubRoleId
	   ,2
	FROM sma_MST_CaseType
	LEFT JOIN sma_MST_SubRole
		ON sbrnCaseTypeID = cstnCaseTypeID
			AND sbrnRoleID = 5
			AND sbrbDefualt = 1
	WHERE cstnCaseTypeID >= @CaseTypeID
