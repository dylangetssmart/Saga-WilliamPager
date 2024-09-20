USE WilliamPagerSA

SET ANSI_WARNINGS OFF
INSERT INTO [sma_MST_CriticalDeadlineTypes]
	(
	[cdtsCode]
   ,[cdtsDscrptn]
   ,[cdtnRecUserID]
   ,[cdtdDtCreated]
   ,[cdtnModifyUserID]
   ,[cdtdDtModified]
   ,[cdtnLevelNo]
   ,[ctdnCheckin]
   ,[ctdnCheckinn]
   ,[ctdnCriteria]
   ,cdtbActive
	)
	SELECT DISTINCT
		UPPER(SUBSTRING(DESCRIPTION, 0, 4))
	   ,DESCRIPTION
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,0
	   ,NULL
	   ,NULL
	   ,NULL
	   ,1
	FROM [WilliamPagerSaga].[dbo].PLRULTYP AType
	LEFT JOIN WilliamPagerSaga.dbo.MRULASS m
		ON m.RULETYPEID = AType.RULETYPEID
	WHERE m.type = 2
		AND LTRIM(RTRIM(description)) NOT IN (
			SELECT
				[cdtsDscrptn]
			FROM [sma_MST_CriticalDeadlineTypes]
		)

ALTER TABLE [sma_TRN_CriticalDeadlines] DISABLE TRIGGER ALL

INSERT INTO [sma_TRN_CriticalDeadlines]
	(
	[crdnCaseID]
   ,[crdnCriticalDeadlineTypeID]
   ,[crdsPartyFlag]
   ,[crdsPlntDefFlag]
   ,[crdnPlntDefID]
   ,[crddDueDate]
   ,[crddCompliedDate]
   ,[crdsComments]
   ,[crdnRecUserID]
   ,[crddDtCreated]
   ,[crdnModifyUserID]
   ,[crddDtModified]
   ,[crdnLevelNo]
   ,[crdnContactCtgId]
   ,[crdnContactId]
   ,[id_discovery]
   ,[crdnDiscoveryTypeId]
   ,[crdsWaivedFlag]
   ,[crdsSupercededFlag]
   ,[crdsCriteria]
	)
	SELECT DISTINCT
		casnCaseID
	   ,cdtnCriticalTypeID
	   ,'D'
	   ,'D'
	   ,defnDefendentID
	   ,CASE
			WHEN date1 BETWEEN '1/1/1900' AND '12/31/2079'
				THEN DATE1
		END
	   ,CASE
			WHEN date2 BETWEEN '1/1/1900' AND '12/31/2079'
				THEN date2
			ELSE NULL
		END date2
	   ,ISNULL(CONVERT(VARCHAR(3800), a.NOTES), '') + CHAR(13) + ISNULL(title, '') + CHAR(13) + ISNULL(COMPDESCRIPTION, '')
	   ,CASE ISNULL((u1.usrnuserid), '')
			WHEN ''
				THEN 368
			ELSE (u1.usrnuserid)
		END
	   ,CASE
			WHEN (a.datecreated) IS NULL
				THEN GETDATE()
			WHEN (a.datecreated) BETWEEN '1/1/1900' AND '12/31/2079'
				THEN a.DATECREATED
			ELSE GETDATE()
		END
	   ,CASE ISNULL((u2.usrnuserid), '')
			WHEN ''
				THEN 368
			ELSE (u2.usrnuserid)
		END
	   ,CASE
			WHEN (a.daterevised) IS NULL
				THEN GETDATE()
			WHEN a.DATEREVISED BETWEEN '1/1/1900' AND '12/31/2079'
				THEN a.DATEREVISED
			ELSE GETDATE()
		END
	   ,0
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	FROM [WilliamPagerSaga].dbo.MRULASS a
	LEFT JOIN [WilliamPagerSaga].[dbo].PLRULTYP AType
		ON a.RULETYPEID = AType.RULETYPEID
	LEFT JOIN [sma_MST_CriticalDeadlineTypes]
		ON LTRIM(RTRIM(description)) = cdtsDscrptn
	LEFT JOIN [WilliamPagerSaga].dbo.MATTER b
		ON a.MATTERID = b.MATTERID
	LEFT JOIN sma_trn_cases
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_trn_defendants
		ON defncaseid = casncaseid
			AND defbisprimary = 1
	LEFT JOIN sma_MST_SOLDetails
		ON sldnCaseTypeID = casnOrgCaseTypeID
			AND casnState = sldnStateID
			AND defnsubrole = sldndefrole
			AND sldnsoltypeid <> 37
	LEFT JOIN sma_MST_IndvContacts l
		ON l.cinsGrade = a.CREATORID
	LEFT JOIN sma_mst_users u1
		ON u1.usrnContactID = l.cinnContactID
	LEFT JOIN sma_MST_IndvContacts m
		ON m.cinsGrade = a.REVISORID
	LEFT JOIN sma_mst_users u2
		ON u2.usrnContactID = m.cinnContactID
	WHERE casncaseid IS NOT NULL
		AND a.type = 2
		AND a.title NOT LIKE 'no fault%'
		AND a.TITLE NOT LIKE '%statute%'
	ORDER BY date2 DESC

ALTER TABLE [sma_TRN_CriticalDeadlines] ENABLE TRIGGER ALL

