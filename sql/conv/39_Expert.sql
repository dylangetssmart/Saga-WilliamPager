USE WilliamPagerSA

INSERT INTO [dbo].[sma_MST_ExpertType]
	(
	[extsCode]
   ,[extsDscrptn]
   ,[extnRecUserID]
   ,[extdDtCreated]
   ,[extnModifyUserID]
   ,[extdDtModified]
   ,[extnLevelNo]
	)
	SELECT
		UPPER(SUBSTRING(LTRIM(RTRIM(DESCRIPTION)), 0, 4))
	   ,LTRIM(RTRIM(DESCRIPTION))
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM [WilliamPagerSaga].dbo.LW_A_EXPERTTYPE
	WHERE LTRIM(RTRIM(DESCRIPTION)) NOT IN (
			SELECT
				LTRIM(RTRIM(extsDscrptn))
			FROM sma_MST_ExpertType
		)
GO
INSERT INTO [dbo].[sma_MST_Speciality]
	(
	[splsCode]
   ,[splnContactTypeID]
   ,[splsSpeciality]
   ,[splsSubspeciality]
   ,[splnRecUserID]
   ,[spldDtCreated]
   ,[splnModifyUserID]
   ,[spldDtModified]
   ,[splnLevelNo]
	)
	SELECT
		UPPER(SUBSTRING(LTRIM(RTRIM(DESCRIPTION)), 0, 4))
	   ,23
	   ,LTRIM(RTRIM(DESCRIPTION))
	   ,NULL
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM [WilliamPagerSaga].dbo.LW_A_SPECIALTY
	WHERE LTRIM(RTRIM(DESCRIPTION)) NOT IN (
			SELECT
				LTRIM(RTRIM([splsSpeciality]))
			FROM sma_MST_Speciality
		)
GO

INSERT INTO sma_TRN_ExpertContacts
	(
	ectnCaseID
   ,ectnExpContactID
   ,ectnExpAddressID
   ,ectnExpertFor
   ,ectnExpertTypeID
   ,ectnWillTestifyYN
   ,ectnDisclosureReqd
   ,ectdDisclosureDt
   ,ectnSpeciality
   ,ectnSubspeciality
   ,ectdRetDte
   ,ectsRetainerDoc
   ,ectnRetainerPaid
   ,ectsComment
   ,ectbDocAttached
   ,ectnRecUserID
   ,ectdDtCreated
   ,ectnLevelNo
	)
	SELECT DISTINCT
		casnCaseID
	   ,CASE
			WHEN i1.cinnContactID IS NOT NULL
				THEN i1.cinnContactID
			WHEN o1.connContactID IS NOT NULL
				THEN o1.connContactID
		END
	   ,CASE
			WHEN i1.cinnContactID IS NOT NULL
				THEN ad2.addnAddressID
			WHEN o1.connContactID IS NOT NULL
				THEN ad1.addnAddressID
		END
	   ,CASE
			WHEN asg.PARTYTYPE = 2
				THEN 1
			WHEN asg.PARTYTYPE = 1
				THEN 0
		END
	   ,extnExpertTypeID
	   ,CASE
			WHEN ISTESTIFY = 'T'
				THEN 1
			ELSE 0
		END
	   ,NULL
	   ,NULL
	   ,splnSpecialityID
	   ,NULL
	   ,NULL
	   ,NULL
	   ,'0.00'
	   ,CASE
			WHEN REPORTDATE IS NOT NULL
				THEN 'Report Date: ' + CONVERT(VARCHAR, REPORTDATE) + CHAR(13)
		END +
		CASE
			WHEN DATEREVIEWED IS NOT NULL
				THEN 'Date Reviewed: ' + CONVERT(VARCHAR, DATEREVIEWED) + CHAR(13)
		END + ISNULL(CONVERT(VARCHAR(MAX), n.NOTES), '')
	   ,NULL
	   ,NULL
	   ,NULL
	   ,''
	FROM [WilliamPagerSaga].dbo.LW_EXPERT a
	LEFT JOIN [WilliamPagerSaga].dbo.LW_A_EXPERTTYPE b
		ON a.EXPERTTYPEID = b.EXPERTTYPEID
	LEFT JOIN [sma_MST_ExpertType]
		ON LTRIM(RTRIM(DESCRIPTION)) = LTRIM(RTRIM(extsDscrptn))
	LEFT JOIN [WilliamPagerSaga].dbo.MATRELT mat
		ON mat.MATRELTID = a.MATRELTID
	LEFT JOIN [WilliamPagerSaga].dbo.ASSIGN asg
		ON asg.ASSIGNID = mat.ASSIGNID
	LEFT JOIN [WilliamPagerSaga].dbo.ASSIGN expe
		ON mat.RELATEDASSIGNID = expe.ASSIGNID
	LEFT JOIN [WilliamPagerSaga].dbo.ENTITIES e1
		ON e1.ENTITYID = asg.ENTITYID
	LEFT JOIN [WilliamPagerSaga].dbo.ENTITIES e2
		ON e2.ENTITYID = expe.ENTITYID
	LEFT JOIN [WilliamPagerSaga].dbo.EROLE r1
		ON r1.ROLEID = asg.ROLEID
	LEFT JOIN [WilliamPagerSaga].dbo.EROLE r2
		ON r2.ROLEID = expe.ROLEID
	LEFT JOIN [WilliamPagerSaga].dbo.MATTER m
		ON m.MATTERID = expe.MATTERID
	LEFT JOIN sma_TRN_Cases
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_IndvContacts i1
		ON i1.cinsGrade = e2.ENTITYID
	LEFT JOIN sma_MST_OrgContacts o1
		ON o1.connLevelNo = e2.ENTITYID
	OUTER APPLY (
		SELECT TOP 1
			addnAddressID
		FROM sma_MST_Address
		WHERE addnContactID = o1.connContactID
			AND addbPrimary = 1
			AND addnContactCtgID = 2
	) ad1
	OUTER APPLY (
		SELECT TOP 1
			addnAddressID
		FROM sma_MST_Address
		WHERE addnContactID = i1.cinnContactID
			AND addbPrimary = 1
			AND addnContactCtgID = 1
	) ad2
	LEFT JOIN [WilliamPagerSaga].dbo.LW_A_SPECIALTY s1
		ON s1.SPECIALTYID = a.SPECIALTYID
	LEFT JOIN sma_MST_Speciality
		ON LTRIM(RTRIM([splsSpeciality])) = LTRIM(RTRIM(s1.DESCRIPTION))
	LEFT JOIN [WilliamPagerSaga].dbo.NOTE n
		ON n.NOTEID = mat.NOTEID
	WHERE casnCaseID IS NOT NULL
GO
UPDATE sma_TRN_ExpertContacts
SET ectsComment = CONVERT(VARCHAR(MAX), LTRIM(REPLACE(
dbo.RegExReplace(ectsComment, '({\\)(.+?)(})|(\\)(.+?)(\b)', '')
, '}', '')
))
GO

INSERT INTO [sma_mst_SubRoleCode]
	SELECT DISTINCT
		[DESCRIPTION]
	   ,5
	FROM [WilliamPagerSaga].[dbo].[LW_A_WITNESSTYPE]
	WHERE [DESCRIPTION] NOT IN (
			SELECT
				[srcsDscrptn]
			FROM [sma_mst_SubRoleCode]
			WHERE srcnRoleID = 5
		)
GO
INSERT INTO sma_TRN_CaseWitness
	(
	witnCaseID
   ,witnWitnesContactID
   ,witnWitnesAdID
   ,witnRoleID
   ,witnFavorable
   ,witnTestify
   ,witdStmtReqDate
   ,witdStmtDate
   ,witbHasRec
   ,witsDoc
   ,witsComment
   ,witnRecUserID
   ,witdDtCreated
   ,witnLevelNo
	)
	SELECT
		casnCaseID
	   ,CASE
			WHEN i1.cinnContactID IS NOT NULL
				THEN '1' + CAST(i1.cinnContactID AS VARCHAR(20))
			WHEN o1.connContactID IS NOT NULL
				THEN '2' + CAST(o1.connContactID AS VARCHAR(20))
		END
	   ,CASE
			WHEN i1.cinnContactID IS NOT NULL
				THEN ad1.addnAddressID
			WHEN o1.connContactID IS NOT NULL
				THEN ad2.addnAddressID
		END
	   ,[srcnCodeId]
	   ,NULL
	   ,CASE
			WHEN [ISTESTIFY] = 'T'
				THEN 2
			WHEN [ISTESTIFY] = 'F'
				THEN 3
			ELSE NULL
		END
		--  ,CASE
		--	WHEN report_requested BETWEEN '1/1/1900' AND '12/31/2079'
		--		THEN report_requested
		--	ELSE NULL
		--END
	   ,NULL				-- ds 2024-09-23
	   ,NULL
	   ,NULL
	   ,NULL
	   ,ISNULL('REPORT DATE: ' + CONVERT(VARCHAR(100), REPORTDATE), '')
		+ ISNULL(CHAR(13) + 'DATE REVIEWED: ' + CONVERT(VARCHAR(100), [DATEREVIEWED]), '')
		+ ISNULL(CHAR(13) + 'REPORT RECEIVED: ' + [REPORTRECEIVED], '')
	   ,368
	   ,GETDATE()
	   ,''
	FROM [WilliamPagerSaga].[dbo].[LW_WITNESS] w
	LEFT JOIN [WilliamPagerSaga].[dbo].[ASSIGN] a
		ON w.ASSIGNID = a.ASSIGNID
	LEFT JOIN [WilliamPagerSaga].[dbo].[MATTER] m
		ON m.MATTERID = a.MATTERID
	LEFT JOIN sma_TRN_Cases
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_IndvContacts i1
		ON i1.cinsGrade = a.ENTITYID
	LEFT JOIN sma_MST_OrgContacts o1
		ON o1.connLevelNo = a.ENTITYID
	OUTER APPLY (
		SELECT TOP 1
			addnAddressID
		FROM sma_MST_Address
		WHERE addnContactID = i1.cinnContactID
			AND addbPrimary = 1
			AND addnContactCtgID = 1
	) ad1
	OUTER APPLY (
		SELECT TOP 1
			addnAddressID
		FROM sma_MST_Address
		WHERE addnContactID = o1.connContactID
			AND addbPrimary = 1
			AND addnContactCtgID = 2
	) ad2
	LEFT JOIN [WilliamPagerSaga].[dbo].[LW_A_WITNESSTYPE] wt
		ON wt.[WITNESSTYPEID] = w.[WITNESSTYPEID]
	OUTER APPLY (
		SELECT TOP 1
			[srcnCodeId]
		FROM [sma_mst_SubRoleCode]
		WHERE [srcsDscrptn] = wt.[DESCRIPTION]
			AND srcnRoleID = 5
	) typ
GO
ALTER TABLE sma_TRN_CriticalComments DISABLE TRIGGER ALL
INSERT INTO sma_TRN_CriticalComments
	SELECT DISTINCT
		CaseId
	   ,0
	   ,Comments
	   ,1
	   ,RecUserID
	   ,DtCreated
	   ,NULL
	   ,NULL
	   ,1
	   ,'RET'
	FROM sma_TRN_Incidents
	WHERE ISNULL(Comments, '') <> ''
ALTER TABLE sma_TRN_CriticalComments ENABLE TRIGGER ALL
GO
UPDATE [sma_MST_CaseType]
SET [cstbUseIncident1] = 1
   ,[cstsIncidentLabel1] = 'Incident'
GO