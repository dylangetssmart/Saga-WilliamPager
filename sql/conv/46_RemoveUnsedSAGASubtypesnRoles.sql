USE WilliamPagerSA

SET ANSI_WARNINGS OFF
ALTER TABLE sma_mst_subrole DISABLE TRIGGER ALL

DELETE FROM sma_mst_subrole
WHERE sbrnroleid = 4
	AND sbrsdscrptn NOT LIKE '(p%'
	AND sbrnSubRoleId NOT IN (
		SELECT
			plnnrole
		FROM sma_TRN_Plaintiff
	)

DELETE FROM sma_mst_subrole
WHERE sbrnroleid = 5
	AND sbrsdscrptn NOT LIKE '(d%'
	AND sbrnSubRoleId NOT IN (
		SELECT
			defnSubRole
		FROM sma_TRN_Defendants
	)

ALTER TABLE sma_mst_subrole ENABLE TRIGGER ALL



DELETE FROM sma_MST_CaseSubType
WHERE cstnGroupID >= 1400
	AND NOT EXISTS (
		SELECT
			casncasetypeid
		FROM sma_trn_cases
		WHERE cstnCaseSubTypeID = casnCaseTypeID
			AND cstnGroupID = casnOrgCaseTypeID
	)

TRUNCATE TABLE sma_mst_casetypestatusstaff

INSERT INTO [dbo].[sma_MST_CaseTypeStatusStaff]
	(
	[csfnCaseTypeID]
   ,[csfnStatusTypeID]
   ,[csfnStatusID]
   ,[csfnStaffID]
   ,[csfnPriority]
   ,[csfnRoleID]
   ,[csfbSystemAssignYN]
   ,[csfnRecUserID]
   ,[csfdDtCreated]
   ,[csfnModifyUserID]
   ,[csfdDtModified]
   ,[csfnLevelNo]
	)
	SELECT
		cstncasetypeid
	   ,1
	   ,162
	   ,8
	   ,''
	   ,1
	   ,0
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM sma_mst_casetype

UPDATE sma_mst_casetype
SET cstnStatusID = 162
   ,cstnStatusTypeID = 1



ALTER TABLE sma_TRN_Plaintiff DISABLE TRIGGER ALL
UPDATE z
SET plnnRole = sbrnSubRoleId
FROM sma_TRN_Plaintiff z
LEFT JOIN sma_trn_cases
	ON casnCaseID = plnnCaseID
LEFT JOIN WilliamPagerSaga.dbo.MATTER m
	ON m.MATTERNUMBER = cassCaseNumber
LEFT JOIN sma_MST_IndvContacts
	ON cinnContactID = plnnContactID
	AND plnnContactCtg = 1
LEFT JOIN sma_mst_orgcontacts
	ON connContactID = plnnContactID
	AND plnnContactCtg = 2
LEFT JOIN [WilliamPagerSaga].dbo.ASSIGN a
	ON m.MATTERID = a.MATTERID
	AND CASE plnnContactCtg
		WHEN 1
			THEN cinsGrade
		WHEN 2
			THEN connLevelNo
	END = a.ENTITYID
LEFT JOIN [WilliamPagerSaga].dbo.EROLE r
	ON r.ROLEID = a.ROLEID
LEFT JOIN sma_MST_SubRole
	ON sbrnCaseTypeID = casnOrgCaseTypeID
	AND CASE
		WHEN DESCRIPTION LIKE '%Guardian%'
			THEN 'Guardian'
		ELSE REPLACE(LTRIM(RTRIM(DESCRIPTION)), 'Plaintiff - ', '')
	END = REPLACE(LTRIM(RTRIM(sbrsDscrptn)), '(p)-', '')
WHERE casnCaseID IS NOT NULL
AND a.partytype = 1
AND sbrnSubRoleId IS NOT NULL
ALTER TABLE sma_TRN_Plaintiff ENABLE TRIGGER ALL



ALTER TABLE sma_trn_cases DISABLE TRIGGER ALL
UPDATE b
SET casdClosingDate = cssdFromDate
   ,casnStatusValueID = 9
FROM sma_TRN_CaseStatus c
LEFT JOIN sma_MST_CaseStatus cs
	ON cs.cssnStatusID = c.cssnStatusID
LEFT JOIN sma_trn_cases b
	ON casnCaseID = cssnCaseID
WHERE cs.csssDescription = 'archived'
AND cs.cssnStatusTypeID = 1
ALTER TABLE sma_trn_cases ENABLE TRIGGER ALL


ALTER TABLE sma_TRN_CaseStatus DISABLE TRIGGER ALL
UPDATE c
SET cssnStatusID = 9
FROM sma_TRN_CaseStatus c
LEFT JOIN sma_MST_CaseStatus cs
	ON cs.cssnStatusID = c.cssnStatusID
LEFT JOIN sma_trn_cases b
	ON casnCaseID = cssnCaseID
WHERE cs.csssDescription = 'archived'
AND cs.cssnStatusTypeID = 1
ALTER TABLE sma_TRN_CaseStatus ENABLE TRIGGER ALL

DELETE FROM sma_MST_CaseStatus
WHERE csssDescription = 'archived'

INSERT INTO [sma_MST_CaseSubTypeCode]
	(
	[stcsDscrptn]
	)

	SELECT DISTINCT
		cstsDscrptn
	FROM sma_MST_CaseSubType
	EXCEPT
	SELECT DISTINCT
		[stcsDscrptn]
	FROM [sma_MST_CaseSubTypeCode]

UPDATE a
SET cstnTypeCode = stcncodeid
FROM sma_MST_CaseSubType a
LEFT JOIN [sma_MST_CaseSubTypeCode]
	ON cstsDscrptn = [stcsDscrptn]
WHERE cstnTypeCode IS NULL

UPDATE a
SET sbrnTypeCode = srcnCodeId
FROM sma_mst_subrole a
LEFT JOIN [sma_mst_SubRoleCode]
	ON sbrsDscrptn = srcsDscrptn
WHERE sbrnTypeCode IS NULL

ALTER TABLE sma_trn_cases DISABLE TRIGGER ALL
UPDATE a
SET casdIncidentDate = IncidentDate
FROM sma_trn_cases a
LEFT JOIN sma_TRN_Incidents
	ON CaseId = casnCaseID
ALTER TABLE sma_trn_cases DISABLE TRIGGER ALL


DELETE FROM [sma_MST_ContactTypesForContact]
WHERE ctcnContTypeContID NOT IN (
		SELECT
			MIN(ctcnContTypeContID)
		FROM [dbo].[sma_MST_ContactTypesForContact]
		GROUP BY ctcnContactCtgID
				,ctcnContactID
				,ctcnContactTypeID
	)


DECLARE @CaseTypID INT
SELECT
	@CaseTypID = MAX(cstnGroupID)
FROM sma_MST_CaseSubType
INSERT INTO sma_MST_CaseSubType
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
   ,[cstnTypeCode]
	)
	SELECT DISTINCT
		''
	   ,casnOrgCaseTypeID
	   ,cstsDscrptn
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	   ,0
	   ,''
	   ,cstnTypeCode
	FROM sma_trn_cases
	LEFT JOIN sma_MST_CaseSubType
		ON cstnCaseSubTypeID = casnCaseTypeID
	WHERE casnOrgCaseTypeID > @CaseTypID

ALTER TABLE sma_trn_cases DISABLE TRIGGER ALL
UPDATE a
SET casnCaseTypeID = cs2.cstnCaseSubTypeID
FROM sma_trn_cases a
LEFT JOIN sma_MST_CaseSubType cs1
	ON cs1.cstnCaseSubTypeID = casnCaseTypeID
LEFT JOIN sma_MST_CaseSubType cs2
	ON cs2.cstnGroupID = casnOrgCaseTypeID
	AND cs1.cstsDscrptn = cs2.cstsDscrptn
WHERE casnOrgCaseTypeID >= (
	SELECT
		MIN(cstncasetypeid)
	FROM sma_MST_CaseType
	WHERE cstdDtCreated > GETDATE() - 1
)

DELETE FROM sma_MST_CaseSubType
WHERE cstnCaseSubTypeID NOT IN (
		SELECT
			casncasetypeid
		FROM sma_trn_cases
	)
	AND cstnGroupID >= 1406
ALTER TABLE sma_trn_cases ENABLE TRIGGER ALL


DELETE FROM sma_mst_casegroup
WHERE cgpncasegroupid NOT IN (
		SELECT DISTINCT
			cstngroupid
		FROM sma_mst_casetype
	)

DELETE FROM sma_MST_CaseTypeCoCounsel
DELETE FROM sma_mst_casetype
WHERE cstncasetypeid < (
		SELECT
			MIN(cstncasetypeid)
		FROM sma_MST_CaseType
		WHERE cstdDtCreated > GETDATE() - 1
	)
	AND cstncasetypeid NOT IN (
		SELECT
			casnorgcasetypeid
		FROM sma_trn_cases
	)

DELETE FROM sma_mst_casestatustype
WHERE stpnStatusTypeid NOT IN (1, 2)

DELETE FROM sma_mst_casestatus
WHERE cssnstatustypeid <> 1

DELETE FROM sma_mst_casestatus
WHERE (cssnstatusid NOT IN (
		SELECT
			cssnstatusid
		FROM sma_trn_casestatus
	)
	OR cssnstatusid NOT IN (162, 39, 9))
	AND cssnstatusid <= 799

DELETE FROM [sma_MST_CaseSubType]
WHERE cstnTypeCode IS NULL
INSERT INTO [dbo].[sma_MST_CaseSubType]
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
   ,[cstnTypeCode]
	)
	SELECT
		''
	   ,cstnCaseTypeID
	   ,stcsDscrptn
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	   ,1
	   ,''
	   ,stcnCodeId
	FROM sma_mst_casetype
	OUTER APPLY (
		SELECT TOP 1
			*
		FROM sma_MST_CaseSubTypeCode
		WHERE stcsDscrptn LIKE '%default%'
	) a
	WHERE cstnCaseTypeID NOT IN (
			SELECT
				cstnGroupID
			FROM sma_MST_CaseSubType
		)

ALTER TABLE sma_trn_cases DISABLE TRIGGER ALL
UPDATE a
SET casnCaseTypeID = cstnCaseSubTypeID
FROM sma_trn_cases a
OUTER APPLY (
	SELECT TOP 1
		cstnCaseSubTypeID
	FROM sma_mst_casesubtype
	WHERE cstnGroupID = casnOrgCaseTypeID
) z
WHERE casnCaseTypeID IS NULL
ALTER TABLE sma_trn_cases ENABLE TRIGGER ALL

ALTER TABLE sma_TRN_InsuranceCoverage DISABLE TRIGGER ALL
UPDATE sma_TRN_InsuranceCoverage
SET incnInsured = (
	SELECT
		MIN(a.UniqueContactId)
	FROM sma_MST_AllContactInfo a
	WHERE a.AddressId = incnInsured
)



ALTER TABLE sma_TRN_InsuranceCoverage ENABLE TRIGGER ALL

ALTER TABLE sma_TRN_InsuranceCoverage DISABLE TRIGGER ALL
DELETE FROM sma_TRN_InsuranceCoverage
WHERE incsPlaintiffOrDef = 'd'
	AND incnPlaintiffIDOrDefendantID NOT IN (
		SELECT
			defnDefendentID
		FROM sma_TRN_Defendants
	)
ALTER TABLE sma_TRN_InsuranceCoverage ENABLE TRIGGER ALL
GO
GO
SELECT DISTINCT
	CASE
		WHEN (connLevelNo) IS NOT NULL
			THEN (connLevelNo)
		ELSE (cinsgrade)
	END AS Entity
   ,caseid INTO #tmpAllCaseContact
FROM sma_VU_AllCaseContact
LEFT JOIN sma_MST_IndvContacts
	ON cinnContactID = casecontactid
		AND CaseContactCategoryID = 1
LEFT JOIN sma_MST_OrgContacts
	ON connContactID = casecontactid
		AND CaseContactCategoryID = 2
WHERE ISNULL(CASE
		WHEN (connLevelNo) IS NOT NULL
			THEN (connLevelNo)
		ELSE (cinsgrade)
	END, 1) <> 1
	AND caseid IS NOT NULL
GO
INSERT INTO [dbo].[sma_TRN_CaseContactComment]
	(
	[CaseContactCaseID]
   ,[CaseRelContactID]
   ,[CaseRelContactCtgID]
   ,[CaseContactComment]
   ,[CaseContactCreaatedBy]
   ,[CaseContactCreateddt]
   ,[caseContactModifyBy]
   ,[CaseContactModifiedDt]
	)
	SELECT DISTINCT
		casncaseid
	   ,CASE
			WHEN connLevelNo IS NOT NULL
				THEN connContactID
			ELSE cinnContactID
		END
	   ,CASE
			WHEN connLevelNo IS NOT NULL
				THEN 2
			ELSE 1
		END
	   ,''
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	FROM [WilliamPagerSaga].dbo.ASSIGN a
	LEFT JOIN [WilliamPagerSaga].dbo.EROLE r
		ON r.ROLEID = a.roleid
	LEFT JOIN [WilliamPagerSaga].dbo.matter m
		ON m.MATTERID = a.MATTERID
	LEFT JOIN sma_trn_cases
		ON cassCaseNumber = matternumber
	LEFT JOIN sma_mst_indvcontacts
		ON a.ENTITYID = cinsGrade
	LEFT JOIN sma_mst_orgcontacts
		ON a.ENTITYID = connLevelNo
	WHERE a.ENTITYID NOT IN (
			SELECT
				Entity
			FROM #tmpAllCaseContact
			WHERE caseid = casnCaseID
		)
		AND (CASE
			WHEN connLevelNo IS NOT NULL
				THEN connContactID
			ELSE cinsGrade
		END IS NOT NULL)
		AND casnCaseID IS NOT NULL
GO
INSERT INTO [dbo].[sma_MST_OtherCasesContact]
	(
	[OtherCasesID]
   ,[OtherCasesContactID]
   ,[OtherCasesContactCtgID]
   ,[OtherCaseContactAddressID]
   ,[OtherCasesContactRole]
   ,[OtherCasesCreatedUserID]
   ,[OtherCasesContactCreatedDt]
   ,[OtherCasesModifyUserID]
   ,[OtherCasesContactModifieddt]
	)
	SELECT DISTINCT
		casncaseid
	   ,CASE
			WHEN connLevelNo IS NOT NULL
				THEN connContactID
			ELSE cinnContactID
		END
	   ,CASE
			WHEN connLevelNo IS NOT NULL
				THEN 2
			ELSE 1
		END
	   ,NULL
	   ,r.DESCRIPTION
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	FROM [WilliamPagerSaga].dbo.ASSIGN a
	LEFT JOIN [WilliamPagerSaga].dbo.EROLE r
		ON r.ROLEID = a.roleid
	LEFT JOIN [WilliamPagerSaga].dbo.matter m
		ON m.MATTERID = a.MATTERID
	LEFT JOIN sma_trn_cases
		ON cassCaseNumber = matternumber
	LEFT JOIN sma_mst_indvcontacts
		ON a.ENTITYID = cinsGrade
	LEFT JOIN sma_mst_orgcontacts
		ON a.ENTITYID = connLevelNo
	WHERE a.ENTITYID NOT IN (
			SELECT
				Entity
			FROM #tmpAllCaseContact
			WHERE caseid = casnCaseID
		)
		AND (CASE
			WHEN connLevelNo IS NOT NULL
				THEN connContactID
			ELSE cinsGrade
		END IS NOT NULL)
GO
DROP TABLE #tmpAllCaseContact

GO

ALTER TABLE [sma_MST_RelContacts] DISABLE TRIGGER ALL
INSERT INTO [dbo].[sma_MST_RelContacts]
	(
	[rlcnPrimaryCtgID]
   ,[rlcnPrimaryContactID]
   ,[rlcnPrimaryAddressID]
   ,[rlcnRelCtgID]
   ,[rlcnRelContactID]
   ,[rlcnRelAddressID]
   ,[rlcnRelTypeID]
   ,[rlcnRecUserID]
   ,[rlcdDtCreated]
   ,[rlcnModifyUserID]
   ,[rlcdDtModified]
   ,[rlcnLevelNo]
   ,[rlcsBizFam]
   ,[rlcnOrgTypeID]
	)
	SELECT DISTINCT
		CASE
			WHEN i1.cinnContactID IS NOT NULL
				THEN 1
			WHEN o1.connContactID IS NOT NULL
				THEN 2
		END
	   ,CASE
			WHEN i1.cinnContactID IS NOT NULL
				THEN i1.cinnContactID
			WHEN o1.connContactID IS NOT NULL
				THEN o1.connContactID
		END
	   ,CASE
			WHEN i1.cinnContactID IS NOT NULL
				THEN z.IndvAddressID
			WHEN o1.connContactID IS NOT NULL
				THEN z1.orgAddressID
		END
	   ,CASE
			WHEN i2.cinnContactID IS NOT NULL
				THEN 1
			WHEN o2.connContactID IS NOT NULL
				THEN 2
		END
	   ,CASE
			WHEN i2.cinnContactID IS NOT NULL
				THEN i2.cinnContactID
			WHEN o2.connContactID IS NOT NULL
				THEN o2.connContactID
		END
	   ,CASE
			WHEN i2.cinnContactID IS NOT NULL
				THEN z2.IndvAddressID
			WHEN o2.connContactID IS NOT NULL
				THEN z3.orgAddressID
		END
	   ,26
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	   ,NULL
	   ,NULL
	FROM WilliamPagerSaga.dbo.ENTITIES e --ll
	LEFT JOIN sma_MST_IndvContacts i1
		ON i1.cinsGrade = e.ENTITYID
	LEFT JOIN sma_MST_orgContacts o1
		ON o1.connLevelNo = e.ENTITYID
	OUTER APPLY (
		SELECT TOP 1
			addnaddressid AS IndvAddressID
		FROM sma_MST_Address
		WHERE addnContactID = i1.cinncontactid
			AND addnContactCtgID = 1
		ORDER BY ISNULL(addbPrimary, 0) DESC
	) z
	OUTER APPLY (
		SELECT TOP 1
			addnaddressid AS orgAddressID
		FROM sma_MST_Address
		WHERE addnContactID = o1.conncontactid
			AND addnContactCtgID = 2
		ORDER BY ISNULL(addbPrimary, 0) DESC
	) z1
	LEFT JOIN sma_MST_IndvContacts i2
		ON i2.cinsGrade = e.SUPERIORID
	LEFT JOIN sma_MST_orgContacts o2
		ON o2.connLevelNo = e.SUPERIORID
	OUTER APPLY (
		SELECT TOP 1
			addnaddressid AS IndvAddressID
		FROM sma_MST_Address
		WHERE addnContactID = i2.cinncontactid
			AND addnContactCtgID = 1
		ORDER BY ISNULL(addbPrimary, 0) DESC
	) z2
	OUTER APPLY (
		SELECT TOP 1
			addnaddressid AS orgAddressID
		FROM sma_MST_Address
		WHERE addnContactID = o2.conncontactid
			AND addnContactCtgID = 2
		ORDER BY ISNULL(addbPrimary, 0) DESC
	) z3
	WHERE SUPERIORID IS NOT NULL
		AND CASE
			WHEN i2.cinnContactID IS NOT NULL
				THEN 1
			WHEN o2.connContactID IS NOT NULL
				THEN 2
		END IS NOT NULL
GO
INSERT INTO [dbo].[sma_MST_RelContacts]
	(
	[rlcnPrimaryCtgID]
   ,[rlcnPrimaryContactID]
   ,[rlcnPrimaryAddressID]
   ,[rlcnRelCtgID]
   ,[rlcnRelContactID]
   ,[rlcnRelAddressID]
   ,[rlcnRelTypeID]
   ,[rlcnRecUserID]
   ,[rlcdDtCreated]
   ,[rlcnModifyUserID]
   ,[rlcdDtModified]
   ,[rlcnLevelNo]
   ,[rlcsBizFam]
   ,[rlcnOrgTypeID]
	)
	SELECT
		[rlcnRelCtgID]
	   ,[rlcnRelContactID]
	   ,[rlcnRelAddressID]
	   ,[rlcnPrimaryCtgID]
	   ,[rlcnPrimaryContactID]
	   ,[rlcnPrimaryAddressID]
	   ,[rlcnRelTypeID]
	   ,[rlcnRecUserID]
	   ,[rlcdDtCreated]
	   ,[rlcnModifyUserID]
	   ,[rlcdDtModified]
	   ,[rlcnLevelNo]
	   ,[rlcsBizFam]
	   ,[rlcnOrgTypeID]
	FROM [sma_MST_RelContacts]
GO
GO
UPDATE [sma_MST_RelContacts]
SET [rlcnRelTypeID] =
CASE
	WHEN [rlcnPrimaryCtgID] = 1 AND
		[rlcnRelCtgID] = 2
		THEN 2
	WHEN [rlcnPrimaryCtgID] = 2 AND
		[rlcnRelCtgID] = 1
		THEN 1
	ELSE 26
END
GO
ALTER TABLE [sma_MST_RelContacts] ENABLE TRIGGER ALL


GO
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

ALTER TABLE sma_TRN_SOLs DISABLE TRIGGER ALL
UPDATE a
SET solnSOLTypeID = sldnSOLDetID
FROM sma_TRN_SOLs a
LEFT JOIN sma_TRN_CaseS
	ON casnCaseID = solnCaseID
OUTER APPLY (
	SELECT TOP 1
		sldnSOLDetID
	FROM sma_MST_SOLDetails
	WHERE sldnCaseTypeID = casnOrgCaseTypeID
		AND sldsSOLName = 'No Fault'
) z
WHERE solnSOLTypeID IS NULL
AND solsComments LIKE '%no fault%'
ALTER TABLE sma_TRN_SOLs ENABLE TRIGGER ALL
GO
ALTER TABLE sma_TRN_CaseS DISABLE TRIGGER ALL
UPDATE sma_TRN_CaseS
SET casdClosingDate = NULL
WHERE casnCaseID IN (
	SELECT
		cssnCaseID
	FROM sma_TRN_CaseStatus
	WHERE cssdToDt IS NULL
		AND cssnStatusID <> 9
		AND cssnCaseID IN (
			SELECT
				casnCaseID
			FROM sma_TRN_CaseS
			WHERE casdClosingDate IS NOT NULL
		)
)
ALTER TABLE sma_TRN_CaseS ENABLE TRIGGER ALL

GO
SET IDENTITY_INSERT sma_mst_casestatustype ON
INSERT INTO sma_mst_casestatustype
	(
	[stpnStatusTypeID]
   ,[stpsCode]
   ,[stpsStatusType]
   ,[stpnRecUserID]
   ,[stpdDtCreated]
   ,[stpnModifyUserID]
   ,[stpdDtModified]
   ,[stpnLevelNo]
	)

	SELECT
		21
	   ,'M1'
	   ,'M1'
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,1
	UNION
	SELECT
		22
	   ,'M2'
	   ,'M2'
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,1
	UNION
	SELECT
		23
	   ,'M3'
	   ,'M3'
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,1

GO

ALTER TABLE sma_TRN_CaseS DISABLE TRIGGER ALL
UPDATE a
SET casdClosingDate = cssdFromDate
FROM sma_TRN_CaseS a
LEFT JOIN sma_TRN_CaseStatus
	ON cssnCaseID = casnCaseID
WHERE casnStatusValueID = 9
AND casdClosingDate IS NULL
AND cssdToDt IS NULL
AND cssnStatusTypeID = 1
ALTER TABLE sma_TRN_CaseS ENABLE TRIGGER ALL
GO

INSERT INTO sma_MST_CaseStatus
	SELECT DISTINCT
		''
	   ,description
	   ,21
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
	FROM WilliamPagerSaga.dbo.MATTER a
	LEFT JOIN WilliamPagerSaga.dbo.[LW_A_MATTERGROUP] b
		ON a.MATTERGROUP1ID = b.MATTERGROUPID
	WHERE a.MATTERGROUP1ID IS NOT NULL
		AND NOT EXISTS (
			SELECT
				*
			FROM sma_MST_CaseStatus
			WHERE csssDescription = DESCRIPTION
				AND cssnStatusTypeID = 21
		)

INSERT INTO sma_MST_CaseStatus
	SELECT DISTINCT
		''
	   ,description
	   ,22
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
	FROM WilliamPagerSaga.dbo.MATTER a
	LEFT JOIN WilliamPagerSaga.dbo.[LW_A_MATTERGROUP] b
		ON a.MATTERGROUP2ID = b.MATTERGROUPID
	WHERE a.MATTERGROUP2ID IS NOT NULL
		AND NOT EXISTS (
			SELECT
				*
			FROM sma_MST_CaseStatus
			WHERE csssDescription = DESCRIPTION
				AND cssnStatusTypeID = 22
		)

INSERT INTO sma_MST_CaseStatus
	SELECT DISTINCT
		''
	   ,description
	   ,23
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
	FROM WilliamPagerSaga.dbo.MATTER a
	LEFT JOIN WilliamPagerSaga.dbo.[LW_A_MATTERGROUP] b
		ON a.MATTERGROUP3ID = b.MATTERGROUPID
	WHERE a.MATTERGROUP3ID IS NOT NULL
		AND NOT EXISTS (
			SELECT
				*
			FROM sma_MST_CaseStatus
			WHERE csssDescription = DESCRIPTION
				AND cssnStatusTypeID = 23
		)

GO
INSERT INTO sma_TRN_CaseStatus
	SELECT DISTINCT
		casncaseid
	   ,21
	   ,cssnstatusid
	   ,NULL
	   ,GETDATE()
	   ,NULL
	   ,CASE
			WHEN a.MATTERGROUP1DATE IS NOT NULL
				THEN 'MatterGroup1Date: ' + CONVERT(VARCHAR(10), MATTERGROUP1DATE, 101)
			ELSE ''
		END
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	FROM WilliamPagerSaga.dbo.MATTER a
	LEFT JOIN WilliamPagerSaga.dbo.[LW_A_MATTERGROUP] b
		ON a.MATTERGROUP1ID = b.MATTERGROUPID
	LEFT JOIN sma_trn_cases
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_CaseStatus
		ON csssDescription = DESCRIPTION
			AND cssnStatusTypeID = 21
	WHERE a.MATTERGROUP1ID IS NOT NULL

INSERT INTO sma_TRN_CaseStatus
	SELECT DISTINCT
		casncaseid
	   ,22
	   ,cssnstatusid
	   ,NULL
	   ,GETDATE()
	   ,NULL
	   ,CASE
			WHEN a.MATTERGROUP2DATE IS NOT NULL
				THEN 'MatterGroup2Date: ' + CONVERT(VARCHAR(10), MATTERGROUP2DATE, 101)
			ELSE ''
		END
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	FROM WilliamPagerSaga.dbo.MATTER a
	LEFT JOIN WilliamPagerSaga.dbo.[LW_A_MATTERGROUP] b
		ON a.MATTERGROUP2ID = b.MATTERGROUPID
	LEFT JOIN sma_trn_cases
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_CaseStatus
		ON csssDescription = DESCRIPTION
			AND cssnStatusTypeID = 22
	WHERE a.MATTERGROUP2ID IS NOT NULL

INSERT INTO sma_TRN_CaseStatus
	SELECT DISTINCT
		casncaseid
	   ,23
	   ,cssnstatusid
	   ,NULL
	   ,GETDATE()
	   ,NULL
	   ,CASE
			WHEN a.MATTERGROUP3DATE IS NOT NULL
				THEN 'MatterGroup3Date: ' + CONVERT(VARCHAR(10), MATTERGROUP3DATE, 101)
			ELSE ''
		END
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	FROM WilliamPagerSaga.dbo.MATTER a
	LEFT JOIN WilliamPagerSaga.dbo.[LW_A_MATTERGROUP] b
		ON a.MATTERGROUP3ID = b.MATTERGROUPID
	LEFT JOIN sma_trn_cases
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_CaseStatus
		ON csssDescription = DESCRIPTION
			AND cssnStatusTypeID = 23
	WHERE a.MATTERGROUP3ID IS NOT NULL

GO
UPDATE sma_mst_users
SET usrnFirmRoleID = 21862
   ,usrnFirmTitleID = 21866
WHERE usrnUserID = 368

INSERT INTO Account_UsersInRoles

	SELECT
		usrnUserID
	   ,2
	FROM sma_mst_users
	WHERE usrnUserID NOT IN (
			SELECT
				user_id
			FROM Account_UsersInRoles
		)
GO
DELETE FROM sma_MST_AllContactInfo
GO
--insert org contacts

INSERT INTO [dbo].[sma_MST_AllContactInfo]
	(
	[UniqueContactId]
   ,[ContactId]
   ,[ContactCtg]
   ,[Name]
   ,[NameForLetters]
   ,[FirstName]
   ,[LastName]
   ,[AddressId]
   ,[Address1]
   ,[Address2]
   ,[Address3]
   ,[City]
   ,[State]
   ,[Zip]
   ,[ContactNumber]
   ,[ContactEmail]
   ,[ContactTypeId]
   ,[ContactType]
   ,[Comments]
   ,[DateModified]
   ,[ModifyUserId]
   ,[IsDeleted]
	)

	SELECT
		CONVERT(BIGINT, ('2' + CONVERT(VARCHAR(30), sma_MST_OrgContacts.connContactID))) AS UniqueContactId
	   ,CONVERT(BIGINT, sma_MST_OrgContacts.connContactID)								 AS ContactId
	   ,2																				 AS ContactCtg
	   ,sma_MST_OrgContacts.consName													 AS Name
	   ,sma_MST_OrgContacts.consName
	   ,NULL																			 AS FirstName
	   ,NULL																			 AS LastName
	   ,NULL																			 AS AddressId
	   ,NULL																			 AS Address1
	   ,NULL																			 AS Address2
	   ,NULL																			 AS Address3
	   ,NULL																			 AS City
	   ,NULL																			 AS State
	   ,NULL																			 AS Zip
	   ,NULL																			 AS ContactNumber
	   ,NULL																			 AS ContactEmail
	   ,sma_MST_OrgContacts.connContactTypeID											 AS ContactTypeId
	   ,sma_MST_OriginalContactTypes.octsDscrptn										 AS ContactType
	   ,sma_MST_OrgContacts.consComments												 AS Comments
	   ,GETDATE()																		 AS DateModified
	   ,347																				 AS ModifyUserId
	   ,0																				 AS IsDeleted
	FROM sma_MST_OrgContacts
	LEFT JOIN sma_MST_OriginalContactTypes
		ON sma_MST_OriginalContactTypes.octnOrigContactTypeID = sma_MST_OrgContacts.connContactTypeID
GO
--insert individual contacts

INSERT INTO [dbo].[sma_MST_AllContactInfo]
	(
	[UniqueContactId]
   ,[ContactId]
   ,[ContactCtg]
   ,[Name]
   ,[NameForLetters]
   ,[FirstName]
   ,[LastName]
   ,[AddressId]
   ,[Address1]
   ,[Address2]
   ,[Address3]
   ,[City]
   ,[State]
   ,[Zip]
   ,[ContactNumber]
   ,[ContactEmail]
   ,[ContactTypeId]
   ,[ContactType]
   ,[Comments]
   ,[DateModified]
   ,[ModifyUserId]
   ,[IsDeleted]
   ,[DateOfBirth]
   ,[SSNNo]
	)

	SELECT
		CONVERT(BIGINT, ('1' + CONVERT(VARCHAR(30), sma_MST_IndvContacts.cinnContactID))) AS UniqueContactId
	   ,CONVERT(BIGINT, sma_MST_IndvContacts.cinnContactID)								  AS ContactId
	   ,1																				  AS ContactCtg
	   ,CASE ISNULL(cinsLastName, '')
			WHEN ''
				THEN ''
			ELSE cinsLastName + ', '
		END +
		CASE ISNULL([cinsFirstName], '')
			WHEN ''
				THEN ''
			ELSE [cinsFirstName]
		END
		+
		CASE ISNULL(cinsMiddleName, '')
			WHEN ''
				THEN ''
			ELSE ' ' + SUBSTRING(cinsMiddleName, 1, 1) + '.'
		END
		+
		CASE ISNULL(cinsSuffix, '')
			WHEN ''
				THEN ''
			ELSE ', ' + cinsSuffix
		END																				  AS Name
	   ,CASE ISNULL([cinsFirstName], '')
			WHEN ''
				THEN ''
			ELSE [cinsFirstName]
		END
		+
		CASE ISNULL(cinsMiddleName, '')
			WHEN ''
				THEN ''
			ELSE ' ' + SUBSTRING(cinsMiddleName, 1, 1) + '.'
		END
		+
		CASE ISNULL(cinsLastName, '')
			WHEN ''
				THEN ''
			ELSE ' ' + cinsLastName
		END
		+
		CASE ISNULL(cinsSuffix, '')
			WHEN ''
				THEN ''
			ELSE ', ' + cinsSuffix
		END																				  AS [NameForLetters]
	   ,ISNULL(sma_MST_IndvContacts.cinsFirstName, '')									  AS FirstName
	   ,ISNULL(sma_MST_IndvContacts.cinsLastName, '')									  AS LastName
	   ,NULL																			  AS AddressId
	   ,NULL																			  AS Address1
	   ,NULL																			  AS Address2
	   ,NULL																			  AS Address3
	   ,NULL																			  AS City
	   ,NULL																			  AS State
	   ,NULL																			  AS Zip
	   ,NULL																			  AS ContactNumber
	   ,NULL																			  AS ContactEmail
	   ,sma_MST_IndvContacts.cinnContactTypeID											  AS ContactTypeId
	   ,sma_MST_OriginalContactTypes.octsDscrptn										  AS ContactType
	   ,sma_MST_IndvContacts.cinsComments												  AS Comments
	   ,GETDATE()																		  AS DateModified
	   ,347																				  AS ModifyUserId
	   ,0																				  AS IsDeleted
	   ,[cindBirthDate]
	   ,[cinsSSNNo]
	FROM sma_MST_IndvContacts
	LEFT JOIN sma_MST_OriginalContactTypes
		ON sma_MST_OriginalContactTypes.octnOrigContactTypeID = sma_MST_IndvContacts.cinnContactTypeID

GO
--fill out address information for all contact types
UPDATE [dbo].[sma_MST_AllContactInfo]
SET [AddressId] = Addrr.addnAddressID
   ,[Address1] = Addrr.addsAddress1
   ,[Address2] = Addrr.addsAddress2
   ,[Address3] = Addrr.addsAddress3
   ,[City] = Addrr.addsCity
   ,[State] = Addrr.addsStateCode
   ,[Zip] = Addrr.addsZip
FROM sma_MST_AllContactInfo AllInfo
INNER JOIN sma_MST_Address Addrr
	ON (AllInfo.ContactId = Addrr.addnContactID)
	AND (AllInfo.ContactCtg = Addrr.addnContactCtgID)
GO

--fill out address information for all contact types, overwriting with primary addresses
UPDATE [dbo].[sma_MST_AllContactInfo]
SET [AddressId] = Addrr.addnAddressID
   ,[Address1] = Addrr.addsAddress1
   ,[Address2] = Addrr.addsAddress2
   ,[Address3] = Addrr.addsAddress3
   ,[City] = Addrr.addsCity
   ,[State] = Addrr.addsStateCode
   ,[Zip] = Addrr.addsZip
FROM sma_MST_AllContactInfo AllInfo
INNER JOIN sma_MST_Address Addrr
	ON (AllInfo.ContactId = Addrr.addnContactID)
	AND (AllInfo.ContactCtg = Addrr.addnContactCtgID)
	AND Addrr.addbPrimary = 1
GO
--fill out email information
UPDATE [dbo].[sma_MST_AllContactInfo]
SET [ContactEmail] = Email.cewsEmailWebSite
FROM sma_MST_AllContactInfo AllInfo
INNER JOIN sma_MST_EmailWebsite Email
	ON (AllInfo.ContactId = Email.cewnContactID)
	AND (AllInfo.ContactCtg = Email.cewnContactCtgID)
	AND Email.cewsEmailWebsiteFlag = 'E'
GO

--fill out default email information
UPDATE [dbo].[sma_MST_AllContactInfo]
SET [ContactEmail] = Email.cewsEmailWebSite
FROM sma_MST_AllContactInfo AllInfo
INNER JOIN sma_MST_EmailWebsite Email
	ON (AllInfo.ContactId = Email.cewnContactID)
	AND (AllInfo.ContactCtg = Email.cewnContactCtgID)
	AND Email.cewsEmailWebsiteFlag = 'E'
	AND Email.cewbDefault = 1
GO
--fill out phone information
UPDATE [dbo].[sma_MST_AllContactInfo]
SET ContactNumber = Phones.cnnsContactNumber + (CASE
	WHEN Phones.[cnnsExtension] IS NULL
		THEN ''
	WHEN Phones.[cnnsExtension] = ''
		THEN ''
	ELSE ' x' + Phones.[cnnsExtension] + ''
END)
FROM sma_MST_AllContactInfo AllInfo
INNER JOIN sma_MST_ContactNumbers Phones
	ON (AllInfo.ContactId = Phones.cnnnContactID)
	AND (AllInfo.ContactCtg = Phones.cnnnContactCtgID)
GO

--fill out default phone information
UPDATE [dbo].[sma_MST_AllContactInfo]
SET ContactNumber = Phones.cnnsContactNumber + (CASE
	WHEN Phones.[cnnsExtension] IS NULL
		THEN ''
	WHEN Phones.[cnnsExtension] = ''
		THEN ''
	ELSE ' x' + Phones.[cnnsExtension] + ''
END)
FROM sma_MST_AllContactInfo AllInfo
INNER JOIN sma_MST_ContactNumbers Phones
	ON (AllInfo.ContactId = Phones.cnnnContactID)
	AND (AllInfo.ContactCtg = Phones.cnnnContactCtgID)
	AND Phones.cnnbPrimary = 1
GO
DELETE FROM Account_UsersInRoles
WHERE user_id <> 368

INSERT INTO Account_UsersInRoles
	SELECT
		usrnuserid
	   ,2
	FROM sma_MST_Users
	WHERE usrnUserID <> 368

UPDATE sma_MST_Users
SET usrnFirmRoleID = (
		SELECT
			usrnFirmRoleID
		FROM sma_MST_Users
		WHERE usrnUserID = 368
	)
   ,usrnFirmTitleID = (
		SELECT
			usrnFirmTitleID
		FROM sma_MST_Users
		WHERE usrnUserID = 368
	)
WHERE usrnUserID <> 368
GO
DELETE FROM sma_MST_CaseGroup
WHERE NOT EXISTS (
		SELECT
			*
		FROM sma_MST_CaseType
		WHERE cstnGroupID = cgpnCaseGroupID
	)
GO
GO
IF OBJECT_ID('RemoveInvalidXMLCharacters', 'FN') IS NOT NULL
	DROP FUNCTION [RemoveInvalidXMLCharacters]
GO
/****** Object:  UserDefinedFunction [dbo].[RemoveInvalidXMLCharacters]    Script Date: 12/23/2015 11:15:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[RemoveInvalidXMLCharacters] (@InputString VARCHAR(MAX))
RETURNS VARCHAR(MAX)
AS
BEGIN
	IF @InputString IS NOT NULL
	BEGIN
		DECLARE @Counter INT
			   ,@TestString NVARCHAR(40)

		SET @TestString = '%[' + NCHAR(0) + NCHAR(1) + NCHAR(2) + NCHAR(3) + NCHAR(4) + NCHAR(5) + NCHAR(6) + NCHAR(7) + NCHAR(8) + NCHAR(11) + NCHAR(12) + NCHAR(14) + NCHAR(15) + NCHAR(16) + NCHAR(17) + NCHAR(18) + NCHAR(19) + NCHAR(20) + NCHAR(21) + NCHAR(22) + NCHAR(23) + NCHAR(24) + NCHAR(25) + NCHAR(26) + NCHAR(27) + NCHAR(28) + NCHAR(29) + NCHAR(30) + NCHAR(31) + ']%'

		SELECT
			@Counter = PATINDEX(@TestString, @InputString COLLATE Latin1_General_BIN)

		WHILE @Counter <> 0
		BEGIN
		SELECT
			@InputString = STUFF(@InputString, @Counter, 1, ' ')
		SELECT
			@Counter = PATINDEX(@TestString, @InputString COLLATE Latin1_General_BIN)
		END
	END
	RETURN (@InputString)
END
GO
ALTER TABLE sma_trn_incidents DISABLE TRIGGER ALL
UPDATE sma_trn_incidents
SET IncidentFacts = dbo.[RemoveInvalidXMLCharacters](ISNULL(IncidentFacts, ''))
   ,MergedFacts = dbo.[RemoveInvalidXMLCharacters](ISNULL(MergedFacts, ''))
   ,Comments = dbo.[RemoveInvalidXMLCharacters](ISNULL(Comments, ''))
ALTER TABLE sma_trn_incidents ENABLE TRIGGER ALL
GO