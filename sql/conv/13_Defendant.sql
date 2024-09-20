USE WilliamPagerSA

SET ANSI_WARNINGS OFF
DECLARE @RoleID INT

SELECT
	@RoleID = MAX(sbrnsubroleid)
FROM sma_MST_SubRole

INSERT INTO [sma_mst_SubRoleCode]
	(
	[srcsDscrptn]
   ,[srcnRoleID]
	)
	SELECT DISTINCT
		LTRIM(RTRIM(r.DESCRIPTION))
	   ,5
	FROM WilliamPagerSaga.dbo.EROLE r
	JOIN WilliamPagerSaga.dbo.ASSIGN a
		ON a.ROLEID = r.ROLEID
	WHERE PARTYTYPE = 2
		AND LTRIM(RTRIM(r.DESCRIPTION)) NOT IN (
			SELECT
				LTRIM(RTRIM([srcsDscrptn]))
			FROM [sma_mst_SubRoleCode]
			WHERE [srcnRoleID] = 5
		)

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
   ,sbrnTypeCode
	)
	SELECT DISTINCT
		''
	   ,5
	   ,SUBSTRING(srcsDscrptn, 0, 50)
	   ,cstnCaseTypeID
	   ,''
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	   ,NULL
	   ,''
	   ,srcnCodeId
	FROM [WilliamPagerSaga].[dbo].[LAWTYPE] c
	LEFT JOIN sma_MST_CaseType
		ON cstsType = c.DESCRIPTION
	CROSS JOIN [sma_mst_SubRoleCode]
	WHERE srcsDscrptn IN (
			SELECT DISTINCT
				LTRIM(RTRIM(r.DESCRIPTION))
			FROM WilliamPagerSaga.dbo.EROLE r
			JOIN WilliamPagerSaga.dbo.ASSIGN a
				ON a.ROLEID = r.ROLEID
			WHERE PARTYTYPE = 2
		)

ALTER TABLE sma_trn_defendants DISABLE TRIGGER ALL

INSERT INTO [sma_TRN_Defendants]
	(
	[defnCaseID]
   ,[defnContactCtgID]
   ,[defnContactID]
   ,[defnAddressID]
   ,[defnSubRole]
   ,[defbIsPrimary]
   ,[defbCounterClaim]
   ,[defbThirdParty]
   ,[defsThirdPartyRole]
   ,[defnPriority]
   ,[defdFrmDt]
   ,[defdToDt]
   ,[defnRecUserID]
   ,[defdDtCreated]
   ,[defnModifyUserID]
   ,[defdDtModified]
   ,[defnLevelNo]
   ,[defsMarked]
   ,[saga]
   ,defsComments
	)
	SELECT
		casnCaseID
	   ,CASE
			WHEN (ISNULL(cinncontactid, '')) <> ''
				THEN (cinnContactCtg)
			WHEN (ISNULL(conncontactid, '')) <> ''
				THEN (connContactCtg)
			ELSE 1
		END
	   ,CASE
			WHEN (ISNULL(cinncontactid, '')) <> ''
				THEN (cinnContactID)
			WHEN (ISNULL(conncontactid, '')) <> ''
				THEN (connContactID)
			ELSE 11
		END
	   ,CASE
			WHEN (ISNULL(cinncontactid, '')) <> ''
				THEN (d.addnaddressid)
			WHEN (ISNULL(conncontactid, '')) <> ''
				THEN (e.addnaddressid)
			ELSE 3
		END
	   ,(sbrnSubRoleId)
	   ,0
	   ,0
	   ,0
	   ,SUBSTRING((z.DESCRIPTION), 0, 30)
	   ,0
	   ,(casdDtCreated)
	   ,NULL
	   ,(casnRecUserID)
	   ,(casdDtCreated)
	   ,(casnModifyUserID)
	   ,(casdDtModified)
	   ,NULL
	   ,NULL
	   ,NULL
	   ,CONVERT(VARCHAR(MAX), LTRIM(REPLACE(
		dbo.RegExReplace(n.NOTES, '({\\)(.+?)(})|(\\)(.+?)(\b)', '')
		, '}', '')

		))
	FROM [WilliamPagerSaga].[dbo].ASSIGN a
	LEFT JOIN [WilliamPagerSaga].[dbo].[Matter] b
		ON b.MATTERID = a.MATTERID
	LEFT JOIN [WilliamPagerSaga].[dbo].[erole] z
		ON z.roleid = a.ROLEID
	LEFT JOIN [WilliamPagerSaga].[dbo].note n
		ON n.noteid = a.NOTEID
	LEFT JOIN sma_trn_cases
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_IndvContacts i1
		ON LTRIM(RTRIM(i1.cinsGrade)) = a.ENTITYID
	LEFT JOIN sma_MST_OrgContacts o1
		ON LTRIM(RTRIM(o1.connLevelNo)) = a.ENTITYID
	LEFT JOIN sma_MST_Address d
		ON d.addnContactID = cinncontactid
			AND d.addnContactCtgID = 1
			AND d.addbPrimary = 1
	LEFT JOIN sma_MST_Address e
		ON e.addnContactID = cinncontactid
			AND e.addnContactCtgID = 1
			AND e.addbPrimary = 1
	--outer apply(select top 1 addnaddressid as orgAddressID from  sma_MST_Address where addnContactID=conncontactid and addnContactCtgID=2 order by isnull(addbPrimary,0) desc) e
	--outer apply(select top 1 sbrnSubRoleId from  sma_MST_SubRole where sbrnCaseTypeID=casnOrgCaseTypeID and sbrnRoleId=5  order by isnull(sbrbDefualt,0) desc) c
	--left join sma_MST_SubRole on sbrnCaseTypeID=casnOrgCaseTypeID and sbrnRoleId=5 and sbrsdscrptn like '%(D)-Owner/Operator%'
	LEFT JOIN [sma_mst_SubRoleCode]
		ON [srcsDscrptn] = z.DESCRIPTION
	OUTER APPLY (
		SELECT TOP 1
			sbrnSubRoleId
		FROM sma_MST_SubRole
		WHERE sbrnCaseTypeID = casnOrgCaseTypeID
			AND sbrnRoleId = 5
			AND sbrsDscrptn = z.DESCRIPTION
	) c
	WHERE casnCaseID IS NOT NULL
		AND a.PARTYTYPE = 2
--and z.DESCRIPTION like '%defenda%' and z.DESCRIPTION not like '%carrier%' and z.DESCRIPTION not like '%insured%' and z.DESCRIPTION not like '%adjuster%' and z.DESCRIPTION not like '%attorney%'

INSERT INTO [sma_TRN_Defendants]
	(
	[defnCaseID]
   ,[defnContactCtgID]
   ,[defnContactID]
   ,[defnAddressID]
   ,[defnSubRole]
   ,[defbIsPrimary]
   ,[defbCounterClaim]
   ,[defbThirdParty]
   ,[defsThirdPartyRole]
   ,[defnPriority]
   ,[defdFrmDt]
   ,[defdToDt]
   ,[defnRecUserID]
   ,[defdDtCreated]
   ,[defnModifyUserID]
   ,[defdDtModified]
   ,[defnLevelNo]
   ,[defsMarked]
   ,[saga]
	)
	SELECT
		casnCaseID
	   ,1
	   ,9
	   ,2
	   ,(sbrnSubRoleId)
	   ,1
	   ,0
	   ,0
	   ,NULL
	   ,0
	   ,GETDATE()
	   ,NULL
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	FROM sma_trn_cases
	OUTER APPLY (
		SELECT TOP 1
			sbrnSubRoleId
		FROM sma_MST_SubRole
		WHERE sbrnCaseTypeID = casnOrgCaseTypeID
			AND sbrnRoleId = 5
		ORDER BY ISNULL(sbrbDefualt, 0) DESC
	) c
	WHERE casncaseid NOT IN (
			SELECT
				defncaseid
			FROM sma_trn_defendants
		)

UPDATE sma_TRN_Defendants
SET defbIsPrimary = 1
WHERE defnDefendentID IN (
	SELECT
		MIN(defnDefendentID)
	FROM sma_TRN_Defendants
	WHERE defnCaseID IN (
			SELECT
				defnCaseID
			FROM sma_TRN_Defendants
			EXCEPT
			SELECT
				defnCaseID
			FROM sma_TRN_Defendants
			WHERE defbIsPrimary = 1
		)
	GROUP BY defnCaseID
)
ALTER TABLE sma_trn_defendants ENABLE TRIGGER ALL

ALTER TABLE sma_MST_SubRole DISABLE TRIGGER ALL
DELETE FROM sma_MST_SubRole
WHERE sbrnSubRoleId NOT IN (
		SELECT
			defnSubRole
		FROM sma_TRN_Defendants
		LEFT JOIN sma_TRN_CaseS
			ON casnCaseID = defnCaseID
		LEFT JOIN sma_MST_CaseType
			ON cstnCaseTypeID = casnOrgCaseTypeID
		WHERE cstnCaseTypeID = casnOrgCaseTypeID
			AND cstnCaseTypeID = sbrnCaseTypeID
	)
	AND sbrnRoleID = 5
	AND sbrnSubRoleId > @RoleID
ALTER TABLE sma_MST_SubRole ENABLE TRIGGER ALL

GO
INSERT INTO [sma_MST_SOLDetails]
	(
	[sldnSOLTypeID]
   ,[sldnCaseTypeID]
   ,[sldnDefRole]
   ,[sldnStateID]
   ,[sldnYears]
   ,[sldnMonths]
   ,[sldnDays]
   ,[sldnSOLDays]
   ,[sldnRecUserID]
   ,[slddDtCreated]
   ,[sldnModifyUserID]
   ,[slddDtModified]
   ,[sldnLevelNo]
   ,[sldsDorP]
   ,[sldsSOLName]
   ,[sldbIsIncidDtEffect]
   ,[sldbDefualt]
	)
	SELECT
		16
	   ,cstnCaseTypeID
	   ,sbrnSubRoleId
	   ,stcnStateID
	   ,1
	   ,0
	   ,0
	   ,0
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,0
	   ,'D'
	   ,'SOL'
	   ,NULL
	   ,0
	FROM sma_MST_CaseType
	LEFT JOIN sma_MST_SubRole
		ON sbrnCaseTypeID = cstnCaseTypeID
			AND sbrnRoleID = 5
	LEFT JOIN [sma_MST_StateCaseTypes]
		ON stcnCaseTypeID = cstnCaseTypeID
	WHERE cstnCaseTypeID >= (
			SELECT
				MIN(cstncasetypeid)
			FROM sma_MST_CaseType
			WHERE cstdDtCreated > GETDATE() - 1
		)

INSERT INTO [sma_MST_SOLDetails]
	(
	[sldnSOLTypeID]
   ,[sldnCaseTypeID]
   ,[sldnDefRole]
   ,[sldnStateID]
   ,[sldnYears]
   ,[sldnMonths]
   ,[sldnDays]
   ,[sldnSOLDays]
   ,[sldnRecUserID]
   ,[slddDtCreated]
   ,[sldnModifyUserID]
   ,[slddDtModified]
   ,[sldnLevelNo]
   ,[sldsDorP]
   ,[sldsSOLName]
   ,[sldbIsIncidDtEffect]
   ,[sldbDefualt]
	)
	SELECT
		3
	   ,cstnCaseTypeID
	   ,sbrnSubRoleId
	   ,stcnStateID
	   ,0
	   ,0
	   ,30
	   ,0
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,0
	   ,'P'
	   ,'No Fault'
	   ,NULL
	   ,0
	FROM sma_MST_CaseType
	LEFT JOIN sma_MST_SubRole
		ON sbrnCaseTypeID = cstnCaseTypeID
			AND sbrnRoleID = 4
			AND sbrsDscrptn = '(P)-Plaintiff'
	LEFT JOIN [sma_MST_StateCaseTypes]
		ON stcnCaseTypeID = cstnCaseTypeID
	WHERE cstnCaseTypeID >= (
			SELECT
				MIN(cstncasetypeid)
			FROM sma_MST_CaseType
			WHERE cstdDtCreated > GETDATE() - 1
		)

GO
SELECT DISTINCT
	plnnPlaintiffID
   ,sb1.sbrnSubRoleId AS bb1
   ,sb2.sbrnSubRoleId AS sb2
   ,plnnRole
   ,sb1.sbrsDscrptn	  AS sb1ds
   ,sb2.sbrsDscrptn	  AS sb2ds INTO #tmpplntf
FROM sma_TRN_Plaintiff
LEFT JOIN sma_trn_cases
	ON casnCaseID = plnnCaseID
LEFT JOIN sma_MST_CaseType
	ON cstnCaseTypeID = casnOrgCaseTypeID
LEFT JOIN sma_mst_subrole sb1
	ON sb1.sbrnSubRoleId = plnnRole
LEFT JOIN sma_mst_subrole sb2
	ON sb2.sbrnCaseTypeID = cstnCaseTypeID
		AND sb2.sbrsDscrptn = sb1.sbrsDscrptn
		AND sb2.sbrnRoleID = 4
WHERE sb1.sbrnSubRoleId <> sb2.sbrnSubRoleId

ALTER TABLE sma_trn_plaintiff DISABLE TRIGGER ALL
UPDATE a
SET plnnRole = sb2
   ,plnnPlaintiffRole = sb2
FROM sma_TRN_Plaintiff a
JOIN #tmpplntf p
	ON p.plnnPlaintiffID = a.plnnPlaintiffID
WHERE p.plnnPlaintiffID = a.plnnPlaintiffID
ALTER TABLE sma_trn_plaintiff ENABLE TRIGGER ALL

DROP TABLE #tmpplntf

GO
SELECT DISTINCT
	defnDefendentID
   ,sb1.sbrnSubRoleId AS bb1
   ,sb2.sbrnSubRoleId AS sb2
   ,defnSubRole
   ,sb1.sbrsDscrptn	  AS sb1ds
   ,sb2.sbrsDscrptn	  AS sb2ds INTO #tmpdef
FROM sma_TRN_Defendants
LEFT JOIN sma_trn_cases
	ON casnCaseID = defnCaseID
LEFT JOIN sma_MST_CaseType
	ON cstnCaseTypeID = casnOrgCaseTypeID
LEFT JOIN sma_mst_subrole sb1
	ON sb1.sbrnSubRoleId = defnSubRole
LEFT JOIN sma_mst_subrole sb2
	ON sb2.sbrnCaseTypeID = cstnCaseTypeID
		AND sb2.sbrsDscrptn = sb1.sbrsDscrptn
		AND sb2.sbrnRoleID = 5
WHERE sb1.sbrnSubRoleId <> sb2.sbrnSubRoleId

ALTER TABLE sma_TRN_Defendants DISABLE TRIGGER ALL
UPDATE a
SET defnSubRole = sb2
FROM sma_TRN_Defendants a
JOIN #tmpdef p
	ON p.defnDefendentID = a.defnDefendentID
WHERE p.defnDefendentID = a.defnDefendentID
ALTER TABLE sma_TRN_Defendants ENABLE TRIGGER ALL

DROP TABLE #tmpdef
GO

