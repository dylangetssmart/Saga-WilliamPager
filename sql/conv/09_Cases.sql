USE WilliamPagerSA

INSERT INTO [sma_TRN_Cases]
	(
	[cassCaseNumber]
   ,[casbAppName]
   ,[cassCaseName]
   ,[casnCaseTypeID]
   ,[casnState]
   ,[casdStatusFromDt]
   ,[casnStatusValueID]
   ,[casdsubstatusfromdt]
   ,[casnSubStatusValueID]
   ,[casdOpeningDate]
   ,[casdClosingDate]
   ,[casnCaseValueID]
   ,[casnCaseValueFrom]
   ,[casnCaseValueTo]
   ,[casnCurrentCourt]
   ,[casnCurrentJudge]
   ,[casnCurrentMagistrate]
   ,[casnCaptionID]
   ,[cassCaptionText]
   ,[casbMainCase]
   ,[casbCaseOut]
   ,[casbSubOut]
   ,[casbWCOut]
   ,[casbPartialOut]
   ,[casbPartialSubOut]
   ,[casbPartiallySettled]
   ,[casbInHouse]
   ,[casbAutoTimer]
   ,[casdExpResolutionDate]
   ,[casdIncidentDate]
   ,[casnTotalLiability]
   ,[cassSharingCodeID]
   ,[casnStateID]
   ,[casnLastModifiedBy]
   ,[casdLastModifiedDate]
   ,[casnRecUserID]
   ,[casdDtCreated]
   ,[casnModifyUserID]
   ,[casdDtModified]
   ,[casnLevelNo]
   ,[cassCaseValueComments]
   ,[casbRefIn]
   ,[casbDelete]
   ,[casbIntaken]
   ,[casnOrgCaseTypeID]
   ,[CassCaption]
   ,[cassMdl]
   ,[office_id]
   ,[saga]
   ,[LIP]
   ,[casnSeriousInj]
   ,[casnCorpDefn]
   ,[casnWebImporter]
   ,[casnRecoveryClient]
   ,[cas]
   ,[ngage]
   ,[casnClientRecoveredDt]
   ,[CloseReason]
	)
	SELECT DISTINCT
		(MATTERNUMBER)
	   ,NULL
	   ,MIN(SHORTMATTERNAME)
	   ,MIN(cstnCaseSubTypeID)
	   ,CASE
			WHEN MIN(sttnStateID) IS NULL
				THEN 67
			WHEN MIN(sttnStateID) = ''
				THEN 67
			ELSE MIN(sttnStateID)
		END
	   ,MIN(a.STATUSDATE)   AS [casdStatusFromDt]
	   ,MIN(i.cssnStatusID) AS [casnStatusValueID]
	   ,NULL				AS [casdsubstatusfromdt]
	   ,''					AS [casnSubStatusValueID]
	   ,CASE
			WHEN YEAR(MIN(a.DATEOPENED)) < 1900
				THEN '2000-01-01 00:00:00.000'
			WHEN MIN(DATEOPENED) IS NULL
				THEN '2000-01-01 00:00:00.000'
			ELSE CONVERT(DATETIME, MIN(DATEOPENED))
		END
	   ,CASE
			WHEN YEAR(MIN(DATECLOSED)) < 1900 AND
				YEAR(MIN(DATEOPENED)) > 1900
				THEN CONVERT(DATETIME, MIN(DATEOPENED)) + 1
			WHEN YEAR(MIN(DATECLOSED)) < 1900 AND
				(YEAR(MIN(DATEOPENED)) < 1900 OR
				MIN(DATEOPENED) IS NULL)
				THEN NULL
			WHEN MIN(DATECLOSED) IS NULL
				THEN NULL
			ELSE CONVERT(DATETIME, MIN(DATECLOSED))
		END
	   ,NULL
	   ,0
	   ,0
	   ,MIN(connContactID)
	   ,NULL
	   ,NULL
	   ,NULL
	   ,MIN(CONVERT(VARCHAR(4000), CAPTION))
	   ,1
	   ,0					AS [casbCaseOut]
	   ,0					AS [casbSubOut]
	   ,0					AS [casbWCOut]
	   ,0					AS [casbPartialOut]
	   ,0					AS [casbPartialSubOut]
	   ,0					AS [casbPartiallySettled]
	   ,1					AS [casbInHouse]
	   ,0					AS [casbAutoTimer]
	   ,NULL				AS [casdExpResolutionDate]
	   ,NULL
	   ,0					AS [casnTotalLiability]
	   ,MIN(MATTERID)		AS [cassSharingCodeID]
	   ,''					AS [casnStateID]
	   ,MIN(u2.usrnuserid)
	   ,MIN(a.daterevised)
	   ,CASE ISNULL(MIN(u1.usrnuserid), '')
			WHEN ''
				THEN 368
			ELSE MIN(u1.usrnuserid)
		END
	   ,CASE MIN(a.datecreated)
			WHEN NULL
				THEN GETDATE()
			ELSE MIN(a.datecreated)
		END
	   ,MIN(u2.usrnuserid)
	   ,MIN(a.daterevised)
	   ,''					AS [casnLevelNo]
	   ,''					AS [cassCaseValueComments]
	   ,0					AS [casbRefIn]
	   ,0					AS [casbDelete]
	   ,1					AS [casbIntaken]
	   ,MIN(cstnCaseTypeID) AS [casnOrgCaseTypeID]
	   ,''					AS [CassCaption]
	   ,''					AS [cassMdl]
	   ,2					AS [office_id]
	   ,''					AS [saga]
	   ,''					AS [LIP]
	   ,''					AS [casnSeriousInj]
	   ,''					AS [casnCorpDefn]
	   ,''					AS [casnWebImporter]
	   ,''					AS [casnRecoveryClient]
	   ,''					AS [cas]
	   ,''					AS [ngage]
	   ,NULL				AS [casnClientRecoveredDt]
	   ,''					AS [CloseReason]
	FROM [WilliamPagerSaga].[dbo].[Matter] a
	LEFT JOIN [WilliamPagerSaga].[dbo].[ENTITIES] b
		ON CLIENTID = ENTITYID
	LEFT JOIN [WilliamPagerSaga].[dbo].[LAWTYPE] c
		ON a.LawTypeid = c.LawTypeid
	LEFT JOIN [WilliamPagerSaga].dbo.LW_A_MATTERTYPE t
		ON t.mattertypeid = a.mattertypeid
	LEFT JOIN sma_MST_CaseType z
		ON cstsType = c.DESCRIPTION
	LEFT JOIN sma_mst_casesubtype z1
		ON cstsdscrptn = t.DESCRIPTION
			AND z1.cstnGroupID = z.cstnCaseTypeID
	LEFT JOIN sma_MST_IndvContacts d
		ON d.cinsGrade = a.CLIENTID
	--OUTER APPLY (
	--	SELECT TOP 1
	--		STATUSDATE
	--	FROM [WilliamPagerSaga].[dbo].[MATTER_STATUS_HISTORY] e
	--	WHERE e.MATTERID = a.MATTERID
	--	ORDER BY e.STATUSDATE DESC
	--) e
	OUTER APPLY (
		SELECT TOP 1
			sttnStateID
		   ,sttsCode
		FROM sma_MST_Address
		LEFT JOIN sma_MST_States
			ON LTRIM(RTRIM(addsStateCode)) = sttsCode
		WHERE addnContactID = d.cinnContactID
			AND addnContactCtgID = 1
		ORDER BY ISNULL(addbPrimary, 0) DESC
	) g
	LEFT JOIN [WilliamPagerSaga].[dbo].[STATUS] h
		ON h.STATUSID = a.STATUSID
	LEFT JOIN sma_MST_CaseStatus i
		ON i.csssDescription = h.DESCRIPTION
			AND i.cssnStatusTypeID = 1
	LEFT JOIN [WilliamPagerSaga].[dbo].[JURISDCT] j
		ON j.JURISDICTIONID = a.JURISDICTIONID
	LEFT JOIN sma_MST_OrgContacts k
		ON k.connLevelNo = j.COURTID
	LEFT JOIN sma_MST_IndvContacts l
		ON l.cinsGrade = a.CREATORID
	LEFT JOIN sma_mst_users u1
		ON u1.usrnContactID = l.cinnContactID
	LEFT JOIN sma_MST_IndvContacts m
		ON m.cinsGrade = a.REVISORID
	LEFT JOIN sma_mst_users u2
		ON u2.usrnContactID = m.cinnContactID
	WHERE ISNULL(matternumber, '') <> ''
	GROUP BY a.MATTERNUMBER 
