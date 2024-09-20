USE WilliamPagerSA

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
	   ,4
	FROM WilliamPagerSaga.dbo.EROLE r
	JOIN WilliamPagerSaga.dbo.ASSIGN a
		ON a.ROLEID = r.ROLEID
	WHERE PARTYTYPE = 1
		AND LTRIM(RTRIM(r.DESCRIPTION)) NOT IN (
			SELECT
				LTRIM(RTRIM([srcsDscrptn]))
			FROM [sma_mst_SubRoleCode]
			WHERE [srcnRoleID] = 4
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
	   ,4
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
			WHERE PARTYTYPE = 1
		)


ALTER TABLE sma_trn_plaintiff DISABLE TRIGGER ALL


INSERT INTO [sma_TRN_Plaintiff]
	(
	[plnnCaseID]
   ,[plnnContactCtg]
   ,[plnnContactID]
   ,[plnnAddressID]
   ,[plnnRole]
   ,[plnbIsPrimary]
   ,[plnbWCOut]
   ,[plnnPartiallySettled]
   ,[plnbSettled]
   ,[plnbOut]
   ,[plnbSubOut]
   ,[plnnSeatBeltUsed]
   ,[plnnCaseValueID]
   ,[plnnCaseValueFrom]
   ,[plnnCaseValueTo]
   ,[plnnPriority]
   ,[plnnDisbursmentWt]
   ,[plnbDocAttached]
   ,[plndFromDt]
   ,[plndToDt]
   ,[plnnRecUserID]
   ,[plndDtCreated]
   ,[plnnModifyUserID]
   ,[plndDtModified]
   ,[plnnLevelNo]
   ,[plnsMarked]
   ,[saga]
   ,[plnnNoInj]
   ,[plnnMissing]
   ,[plnnLIPBatchNo]
   ,[plnnPlaintiffRole]
	)

	SELECT
		casnCaseID
	   ,CASE
			WHEN (ISNULL(cinncontactid, '')) <> ''
				THEN (cinnContactCtg)
			WHEN (ISNULL(conncontactid, '')) <> ''
				THEN (connContactCtg)
		END
	   ,CASE
			WHEN (ISNULL(cinncontactid, '')) <> ''
				THEN (cinnContactID)
			WHEN (ISNULL(conncontactid, '')) <> ''
				THEN (connContactID)
		END
	   ,CASE
			WHEN (ISNULL(cinncontactid, '')) <> ''
				THEN (IndvAddressID)
			WHEN (ISNULL(conncontactid, '')) <> ''
				THEN (orgAddressID)
		END
	   ,(sbrnSubRoleId)
	   ,0
	   ,0
	   ,0
	   ,0
	   ,0
	   ,0
	   ,0
	   ,0
	   ,0
	   ,0
	   ,0
	   ,0
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
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	FROM [WilliamPagerSaga].dbo.matter m
	LEFT JOIN sma_trn_cases
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN [WilliamPagerSaga].dbo.status s
		ON m.statusId = s.statusId
	LEFT JOIN [WilliamPagerSaga].dbo.lawtype LT
		ON LT.LAWTYPEID = m.LAWTYPEID
	LEFT JOIN [WilliamPagerSaga].dbo.ASSIGN a
		ON m.MATTERID = a.MATTERID
	LEFT JOIN [WilliamPagerSaga].dbo.EROLE r
		ON r.ROLEID = a.ROLEID
	LEFT JOIN [WilliamPagerSaga].dbo.entities e
		ON a.ENTITYID = e.ENTITYID
	LEFT JOIN sma_MST_IndvContacts i1
		ON i1.cinsGrade = e.ENTITYID
	LEFT JOIN sma_MST_OrgContacts o1
		ON o1.connLevelNo = e.ENTITYID
	LEFT JOIN [sma_mst_SubRoleCode]
		ON [srcsDscrptn] = r.DESCRIPTION
	OUTER APPLY (
		SELECT TOP 1
			addnaddressid AS IndvAddressID
		FROM sma_MST_Address
		WHERE addnContactID = cinncontactid
			AND addnContactCtgID = 1
		ORDER BY ISNULL(addbPrimary, 0) DESC
	) z
	OUTER APPLY (
		SELECT TOP 1
			addnaddressid AS orgAddressID
		FROM sma_MST_Address
		WHERE addnContactID = conncontactid
			AND addnContactCtgID = 2
		ORDER BY ISNULL(addbPrimary, 0) DESC
	) b
	OUTER APPLY (
		SELECT TOP 1
			sbrnSubRoleId
		FROM sma_MST_SubRole
		WHERE sbrnCaseTypeID = casnOrgCaseTypeID
			AND sbrnRoleId = 4
			AND sbrnTypeCode = srcncodeid
	) c
	WHERE casnCaseID IS NOT NULL
		AND a.PARTYTYPE = 1


UPDATE sma_TRN_Plaintiff
SET plnbIsPrimary = 1
FROM sma_trn_plaintiff
WHERE (plnnContactID IN (
	SELECT
		cinncontactid
	FROM sma_MST_IndvContacts
	JOIN [WilliamPagerSaga].dbo.MATTER e
		ON cinsGrade = e.CLIENTID
)
AND plnnContactCtg = 1)
OR (plnnContactID IN (
	SELECT
		conncontactid
	FROM sma_MST_orgContacts
	JOIN [WilliamPagerSaga].dbo.MATTER e
		ON connLevelNo = e.CLIENTID
)
AND plnnContactCtg = 2)


INSERT INTO [sma_TRN_Plaintiff]
	(
	[plnnCaseID]
   ,[plnnContactCtg]
   ,[plnnContactID]
   ,[plnnAddressID]
   ,[plnnRole]
   ,[plnbIsPrimary]
   ,[plnbWCOut]
   ,[plnnPartiallySettled]
   ,[plnbSettled]
   ,[plnbOut]
   ,[plnbSubOut]
   ,[plnnSeatBeltUsed]
   ,[plnnCaseValueID]
   ,[plnnCaseValueFrom]
   ,[plnnCaseValueTo]
   ,[plnnPriority]
   ,[plnnDisbursmentWt]
   ,[plnbDocAttached]
   ,[plndFromDt]
   ,[plndToDt]
   ,[plnnRecUserID]
   ,[plndDtCreated]
   ,[plnnModifyUserID]
   ,[plndDtModified]
   ,[plnnLevelNo]
   ,[plnsMarked]
   ,[saga]
   ,[plnnNoInj]
   ,[plnnMissing]
   ,[plnnLIPBatchNo]
   ,[plnnPlaintiffRole]
	)
	SELECT
		casncaseid
	   ,1
	   ,9
	   ,2
	   ,sbrnSubRoleId
	   ,1
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,GETDATE()
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
	FROM sma_trn_cases
	OUTER APPLY (
		SELECT TOP 1
			sbrnSubRoleId
		FROM sma_MST_SubRole
		WHERE sbrnCaseTypeID = casnOrgCaseTypeID
			AND sbrnRoleId = 4
		ORDER BY REPLACE(sbrsDscrptn, '(P)-Plaintiff', ' (P)-Plaintiff') ASC
	) c
	WHERE cassCaseNumber IS NOT NULL
		AND casncaseid NOT IN (
			SELECT DISTINCT
				plnncaseid
			FROM sma_TRN_Plaintiff
		)

UPDATE sma_TRN_Plaintiff
SET plnbIsPrimary = 1
WHERE plnnPlaintiffID IN (
	SELECT
		MIN(plnnplaintiffid)
	FROM sma_TRN_Plaintiff
	WHERE plnnCaseID IN (
			SELECT
				plnnCaseID
			FROM sma_TRN_Plaintiff
			EXCEPT
			SELECT
				plnncaseid
			FROM sma_TRN_Plaintiff
			WHERE plnbIsPrimary = 1
		)
	GROUP BY plnnCaseID
)
ALTER TABLE sma_trn_plaintiff ENABLE TRIGGER ALL

ALTER TABLE sma_MST_SubRole DISABLE TRIGGER ALL
DELETE FROM sma_MST_SubRole
WHERE sbrnSubRoleId NOT IN (
		SELECT
			plnnRole
		FROM sma_TRN_Plaintiff
		LEFT JOIN sma_TRN_CaseS
			ON casnCaseID = plnnCaseID
		LEFT JOIN sma_MST_CaseType
			ON cstnCaseTypeID = casnOrgCaseTypeID
		WHERE cstnCaseTypeID = casnOrgCaseTypeID
			AND cstnCaseTypeID = sbrnCaseTypeID
	)
	AND sbrnRoleID = 4
	AND sbrnSubRoleId > @RoleID
ALTER TABLE sma_MST_SubRole ENABLE TRIGGER ALL




