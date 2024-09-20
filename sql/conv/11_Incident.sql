USE WilliamPagerSA

ALTER TABLE [sma_TRN_Incidents] DISABLE TRIGGER ALL

DECLARE @StateID INT
SELECT
	@StateID = sttnStateID
FROM WilliamPagerSaga.dbo.SETTINGS
JOIN sma_MST_States
	ON LTRIM(RTRIM(addrstate)) = LTRIM(RTRIM(sttsCode))
		OR LTRIM(RTRIM(addrstate)) = LTRIM(RTRIM(sttsDescription))

--INSERT INTO [sma_TRN_Incidents]
--([CaseId],[IncidentDate],[StateID],[LiabilityCodeId],[IncidentFacts],[MergedFacts],[Comments],[IncidentTime],[RecUserID],[DtCreated],[ModifyUserID],[DtModified])
--Select distinct casnCaseID,DATETIMEOFINCIDENT,case when isnull(sttnStateID,'')='' then @StateID else sttnStateID end,null,convert(varchar(8000),e.notes),convert(varchar(8000),d.notes),convert(varchar(8000),substring(c.notes,0,2000)),CONVERT(time,DATETIMEOFINCIDENT)
--,case isnull((u1.usrnuserid),'') when '' then 368 else (u1.usrnuserid) end,case (b.datecreated) when null then GETDATE() else (b.datecreated) end,(u2.usrnuserid),(b.daterevised)
-- FROM [WilliamPagerSaga].[dbo].[LW_MATTER] a
--Left Join [WilliamPagerSaga].[dbo].[Matter] b on b.MATTERID=a.MATTERID
--Left Join sma_trn_cases on b.MATTERNUMBER=cassCaseNumber
--left join sma_MST_States on ltrim(rtrim(sttsCode))=ltrim(rtrim(LOCATIONSTATE))
--left join [WilliamPagerSaga].[dbo].[NOTE] c on c.NOTEID=a.ALERTNOTEID
--left join [WilliamPagerSaga].[dbo].[NOTE] d on d.NOTEID=a.FACTDETAILNOTEID
--left join [WilliamPagerSaga].[dbo].[NOTE] e on e.NOTEID=a.FACTSUMMARYNOTEID
--left join sma_MST_IndvContacts l on l.cinsGrade=b.CREATORID
--left join sma_mst_users u1 on u1.usrnContactID=l.cinnContactID
--left join sma_MST_IndvContacts m on m.cinsGrade=b.REVISORID
--left join sma_mst_users u2 on u2.usrnContactID=m.cinnContactID
--where casnCaseID is not null

INSERT INTO [sma_TRN_Incidents]
	(
	[CaseId]
   ,[IncidentDate]
   ,[StateID]
   ,[LiabilityCodeId]
   ,[IncidentFacts]
   ,[MergedFacts]
   ,[Comments]
   ,[IncidentTime]
   ,[RecUserID]
   ,[DtCreated]
   ,[ModifyUserID]
   ,[DtModified]
	)
	SELECT
		A.c1
	   ,A.c2
	   ,A.c3
	   ,A.c4
	   ,A.c5
	   ,A.c6
	   ,A.c7
	   ,A.c8
	   ,A.c9
	   ,A.c10
	   ,A.c11
	   ,A.c12
	FROM (
		SELECT DISTINCT
			casnCaseID AS c1
		   ,DATETIMEOFINCIDENT AS c2
		   ,CASE
				WHEN ISNULL(sttnStateID, '') = ''
					THEN @StateID
				ELSE sttnStateID
			END AS c3
		   ,NULL AS c4
		   ,CONVERT(VARCHAR(8000), e.notes) AS c5
		   ,CONVERT(VARCHAR(8000), d.notes) AS c6
		   ,CONVERT(VARCHAR(8000), SUBSTRING(c.notes, 0, 2000)) AS c7
		   ,CONVERT(TIME, DATETIMEOFINCIDENT) AS c8
		   ,CASE ISNULL((u1.usrnuserid), '')
				WHEN ''
					THEN 368
				ELSE (u1.usrnuserid)
			END AS c9
		   ,CASE (b.datecreated)
				WHEN NULL
					THEN GETDATE()
				ELSE (b.datecreated)
			END AS c10
		   ,(u2.usrnuserid) AS c11
		   ,(b.daterevised) AS c12
		   ,ROW_NUMBER() OVER (PARTITION BY casnCaseID ORDER BY casnCaseID) row_index
		FROM [WilliamPagerSaga].[dbo].[LW_MATTER] a
		LEFT JOIN [WilliamPagerSaga].[dbo].[Matter] b
			ON b.MATTERID = a.MATTERID
		LEFT JOIN sma_trn_cases
			ON b.MATTERNUMBER = cassCaseNumber
		LEFT JOIN sma_MST_States
			ON LTRIM(RTRIM(sttsCode)) = LTRIM(RTRIM(LOCATIONSTATE))
		LEFT JOIN [WilliamPagerSaga].[dbo].[NOTE] c
			ON c.NOTEID = a.ALERTNOTEID
		LEFT JOIN [WilliamPagerSaga].[dbo].[NOTE] d
			ON d.NOTEID = a.FACTDETAILNOTEID
		LEFT JOIN [WilliamPagerSaga].[dbo].[NOTE] e
			ON e.NOTEID = a.FACTSUMMARYNOTEID
		LEFT JOIN sma_MST_IndvContacts l
			ON l.cinsGrade = b.CREATORID
		LEFT JOIN sma_mst_users u1
			ON u1.usrnContactID = l.cinnContactID
		LEFT JOIN sma_MST_IndvContacts m
			ON m.cinsGrade = b.REVISORID
		LEFT JOIN sma_mst_users u2
			ON u2.usrnContactID = m.cinnContactID
		WHERE casnCaseID IS NOT NULL
	) A
	WHERE A.row_index = 1







UPDATE sma_TRN_Incidents
SET StateID = 67
WHERE StateID IS NULL

UPDATE sma_TRN_Incidents
SET IncidentFacts = LTRIM(REPLACE(
	dbo.RegExReplace(IncidentFacts, '({\\)(.+?)(})|(\\)(.+?)(\b)', '')
	, '}', '')
	)
   ,Comments = LTRIM(REPLACE(
	dbo.RegExReplace(Comments, '({\\)(.+?)(})|(\\)(.+?)(\b)', '')
	, '}', '')
	)
   ,MergedFacts = LTRIM(REPLACE(
	dbo.RegExReplace(MergedFacts, '({\\)(.+?)(})|(\\)(.+?)(\b)', '')
	, '}', '')
	)

ALTER TABLE [sma_TRN_Incidents] ENABLE TRIGGER ALL


ALTER TABLE sma_trn_cases DISABLE TRIGGER ALL

UPDATE a
SET casnState = StateID
FROM sma_trn_cases a
LEFT JOIN sma_trn_incidents
	ON caseid = casnCaseID

ALTER TABLE sma_trn_cases ENABLE TRIGGER ALL
GO

INSERT INTO sma_MST_CaseValue
	SELECT DISTINCT
		'Range'
	   ,valuelow
	   ,valuehigh
	   ,''
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	FROM [WilliamPagerSaga].[dbo].[LW_EVAL] ev
	WHERE CAST(valuelow AS VARCHAR(50)) + '-' + CAST(valuehigh AS VARCHAR(50)) NOT IN (
			SELECT
				CAST(csvnFromValue AS VARCHAR(50)) + '-' + CAST(csvnToValue AS VARCHAR(50))
			FROM sma_MST_CaseValue
		)
GO

INSERT INTO [dbo].[sma_TRN_CaseValue]
	(
	[csvnCaseID]
   ,[csvnValueID]
   ,[csvnValue]
   ,[csvsComments]
   ,[csvdFromDate]
   ,[csvdToDate]
   ,[csvnRecUserID]
   ,[csvdDtCreated]
   ,[csvnModifyUserID]
   ,[csvdDtModified]
   ,[csvnLevelNo]
   ,[csvnMinSettlementValue]
	)
	SELECT DISTINCT
		casnCaseID
	   ,csvnValueID
	   ,csvnFromValue
	   ,CONVERT(VARCHAR(2000), LTRIM(REPLACE(dbo.RegExReplace(n.NOTES, '({\\)(.+?)(})|(\\)(.+?)(\b)', ''), '}', '')))
	   ,GETDATE()
	   ,NULL
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,1
	   ,NULL
	FROM [WilliamPagerSaga].[dbo].[LW_EVAL] ev
	LEFT JOIN [WilliamPagerSaga].[dbo].[Assign] a
		ON a.assignid = ev.assignid
	LEFT JOIN [WilliamPagerSaga].[dbo].[Matter] m
		ON m.matterid = a.matterid
	LEFT JOIN [WilliamPagerSaga].[dbo].[note] n
		ON n.noteid = ev.noteid
	LEFT JOIN sma_MST_CaseValue
		ON CAST(csvnFromValue AS VARCHAR(50)) + '-' + CAST(csvnToValue AS VARCHAR(50)) = CAST(valuelow AS VARCHAR(50)) + '-' + CAST(valuehigh AS VARCHAR(50))
	LEFT JOIN sma_trn_cases z
		ON z.casscasenumber = m.matternumber
GO
UPDATE z
SET casnCaseValueFrom = valuelow
   ,casnCaseValueTo = valuehigh
   ,casncasevalueid = csvnValueID
FROM [WilliamPagerSaga].[dbo].[LW_EVAL] ev
LEFT JOIN [WilliamPagerSaga].[dbo].[Assign] a
	ON a.assignid = ev.assignid
LEFT JOIN [WilliamPagerSaga].[dbo].[Matter] m
	ON m.matterid = a.matterid
LEFT JOIN sma_MST_CaseValue n
	ON CAST(csvnFromValue AS VARCHAR(50)) + '-' + CAST(csvnToValue AS VARCHAR(50)) = CAST(valuelow AS VARCHAR(50)) + '-' + CAST(valuehigh AS VARCHAR(50))
LEFT JOIN sma_trn_cases z
	ON z.casscasenumber = m.matternumber
GO
DELETE FROM [sma_MST_LiabilityCode]
INSERT INTO [dbo].[sma_MST_LiabilityCode]
	(
	[lbcsCode]
   ,[lbcsDscrptn]
   ,[lbcnRecUserID]
   ,[lbcdDtCreated]
   ,[lbcnModifyUserID]
   ,[lbcdDtModified]
   ,[lbcnLevelNo]
	)
	SELECT DISTINCT
		''
	   ,liability
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM [WilliamPagerSaga].[dbo].[LW_EVAL]
	WHERE liability IS NOT NULL
GO
UPDATE x
SET x.LiabilityCodeId = lbcnLiabilityID
FROM [WilliamPagerSaga].[dbo].[LW_EVAL] ev
LEFT JOIN [WilliamPagerSaga].[dbo].[Assign] a
	ON a.assignid = ev.assignid
LEFT JOIN [WilliamPagerSaga].[dbo].[Matter] m
	ON m.matterid = a.matterid
LEFT JOIN sma_MST_CaseValue n
	ON CAST(csvnFromValue AS VARCHAR(50)) + '-' + CAST(csvnToValue AS VARCHAR(50)) = CAST(valuelow AS VARCHAR(50)) + '-' + CAST(valuehigh AS VARCHAR(50))
LEFT JOIN sma_trn_cases z
	ON z.casscasenumber = m.matternumber
LEFT JOIN sma_trn_incidents x
	ON x.caseid = casncaseid
LEFT JOIN [sma_MST_LiabilityCode]
	ON [lbcsDscrptn] = liability
WHERE liability IS NOT NULL
GO


INSERT INTO sma_MST_CaseValue
	SELECT DISTINCT
		'Range'
	   ,ISNULL(valuelow, '0.00')
	   ,ISNULL(valuehigh, '0.00')
	   ,''
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	FROM [WilliamPagerSaga].[dbo].[LW_EVAL] ev
	WHERE CAST(ISNULL(valuelow, '0.00') AS VARCHAR(50)) + '-' + CAST(ISNULL(VALUEHIGH, '0.00') AS VARCHAR(50)) NOT IN (
			SELECT
				CAST(ISNULL(csvnFromValue, '0.00') AS VARCHAR(50)) + '-' + CAST(ISNULL(csvnToValue, '0.00') AS VARCHAR(50))
			FROM sma_MST_CaseValue
		)
		AND (VALUELOW IS NULL
		AND VALUEHIGH IS NOT NULL)
		OR (VALUELOW IS NOT NULL
		AND VALUEHIGH IS NULL)
GO

INSERT INTO [dbo].[sma_TRN_CaseValue]
	(
	[csvnCaseID]
   ,[csvnValueID]
   ,[csvnValue]
   ,[csvsComments]
   ,[csvdFromDate]
   ,[csvdToDate]
   ,[csvnRecUserID]
   ,[csvdDtCreated]
   ,[csvnModifyUserID]
   ,[csvdDtModified]
   ,[csvnLevelNo]
   ,[csvnMinSettlementValue]
	)
	SELECT DISTINCT
		casnCaseID
	   ,csvnValueID
	   ,csvnFromValue
	   ,CONVERT(VARCHAR(2000), LTRIM(REPLACE(dbo.RegExReplace(n.NOTES, '({\\)(.+?)(})|(\\)(.+?)(\b)', ''), '}', '')))
	   ,GETDATE()
	   ,NULL
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,1
	   ,NULL
	FROM [WilliamPagerSaga].[dbo].[LW_EVAL] ev
	LEFT JOIN [WilliamPagerSaga].[dbo].[Assign] a
		ON a.assignid = ev.assignid
	LEFT JOIN [WilliamPagerSaga].[dbo].[Matter] m
		ON m.matterid = a.matterid
	LEFT JOIN [WilliamPagerSaga].[dbo].[note] n
		ON n.noteid = ev.noteid
	LEFT JOIN sma_MST_CaseValue
		ON CAST(ISNULL(csvnFromValue, '0.00') AS VARCHAR(50)) + '-' + CAST(ISNULL(csvnToValue, '0.00') AS VARCHAR(50)) = CAST(ISNULL(valuelow, '0.00') AS VARCHAR(50)) + '-' + CAST(ISNULL(valuehigh, '0.00') AS VARCHAR(50))
	LEFT JOIN sma_trn_cases z
		ON z.casscasenumber = m.matternumber
	WHERE (VALUELOW IS NULL
		AND VALUEHIGH IS NOT NULL)
		OR (VALUELOW IS NOT NULL
		AND VALUEHIGH IS NULL)
		AND casnCaseID NOT IN (
			SELECT
				csvncaseid
			FROM [sma_TRN_CaseValue]
		)
GO

UPDATE z
SET casnCaseValueFrom = ISNULL(valuelow, '0.00')
   ,casnCaseValueTo = ISNULL(valuehigh, '0.00')
   ,casncasevalueid = csvnValueID
FROM [WilliamPagerSaga].[dbo].[LW_EVAL] ev
LEFT JOIN [WilliamPagerSaga].[dbo].[Assign] a
	ON a.assignid = ev.assignid
LEFT JOIN [WilliamPagerSaga].[dbo].[Matter] m
	ON m.matterid = a.matterid
LEFT JOIN sma_MST_CaseValue n
	ON CAST(ISNULL(csvnFromValue, '0.00') AS VARCHAR(50)) + '-' + CAST(ISNULL(csvnToValue, '0.00') AS VARCHAR(50)) = CAST(ISNULL(valuelow, '0.00') AS VARCHAR(50)) + '-' + CAST(ISNULL(valuehigh, '0.00') AS VARCHAR(50))
LEFT JOIN sma_trn_cases z
	ON z.casscasenumber = m.matternumber
WHERE (VALUELOW IS NULL
AND VALUEHIGH IS NOT NULL)
OR (VALUELOW IS NOT NULL
AND VALUEHIGH IS NULL)