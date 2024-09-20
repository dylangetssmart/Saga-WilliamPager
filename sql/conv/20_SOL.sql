USE WilliamPagerSA

ALTER TABLE [sma_TRN_SOLs] DISABLE TRIGGER ALL

INSERT INTO [sma_TRN_SOLs]
	(
	[solnCaseID]
   ,[solnSOLTypeID]
   ,[soldSOLDate]
   ,[soldToProcessServerDt]
   ,[soldSnCFilingDate]
   ,[soldServiceDate]
   ,[soldLastDtToServe]
   ,[solnServiceMethodID]
   ,[solnMailingReqd]
   ,[soldLastDateToMail]
   ,[soldMailedDate]
   ,[solnFileAffidavitReqd]
   ,[soldLastDateToFile]
   ,[soldFiledDate]
   ,[soldProcessServerDt]
   ,[solnDefendentID]
   ,[soldDefAnsDueDt]
   ,[soldRcvdDate]
   ,[solsComments]
   ,[solnRecUserID]
   ,[soldDtCreated]
   ,[solnModifyUserID]
   ,[soldDtModified]
   ,[solnLevelNo]
   ,[soldLastDtFileSc]
   ,[soldDateComplied]
   ,[solsType]
   ,[solbIsOld]
   ,[intCriticalDeadline]
   ,[soldComments]
	)
	SELECT DISTINCT
		casnCaseID
	   ,sldnSOLdetID
	   ,CASE
			WHEN date1 BETWEEN '1/1/1900' AND '12/31/2079'
				THEN DATE1
		END
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,''
	   ,NULL
	   ,NULL
	   ,NULL
	   ,defndefendentid
	   ,NULL
	   ,NULL
	   ,title
	   ,CASE ISNULL((u1.usrnuserid), '')
			WHEN ''
				THEN 368
			ELSE (u1.usrnuserid)
		END
	   ,CASE (a.datecreated)
			WHEN NULL
				THEN GETDATE()
			ELSE (a.datecreated)
		END
	   ,CASE ISNULL((u2.usrnuserid), '')
			WHEN ''
				THEN 368
			ELSE (u2.usrnuserid)
		END
	   ,CASE (a.daterevised)
			WHEN NULL
				THEN GETDATE()
			ELSE (a.daterevised)
		END
	   ,NULL
	   ,CASE
			WHEN date1 BETWEEN '1/1/1900' AND '12/31/2079'
				THEN DATE1
		END
	   ,CASE
			WHEN date2 BETWEEN '1/1/1900' AND '12/31/2079'
				THEN date2
			ELSE NULL
		END date2
	   ,'D'
	   ,''
	   ,''
	   ,ISNULL(CONVERT(VARCHAR(4000), a.NOTES), '')
	FROM [WilliamPagerSaga].dbo.MRULASS a
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
		AND a.title LIKE '%statute%'
	ORDER BY date2 DESC
INSERT INTO [sma_TRN_SOLs]
	(
	[solnCaseID]
   ,[solnSOLTypeID]
   ,[soldSOLDate]
   ,[soldToProcessServerDt]
   ,[soldSnCFilingDate]
   ,[soldServiceDate]
   ,[soldLastDtToServe]
   ,[solnServiceMethodID]
   ,[solnMailingReqd]
   ,[soldLastDateToMail]
   ,[soldMailedDate]
   ,[solnFileAffidavitReqd]
   ,[soldLastDateToFile]
   ,[soldFiledDate]
   ,[soldProcessServerDt]
   ,[solnDefendentID]
   ,[soldDefAnsDueDt]
   ,[soldRcvdDate]
   ,[solsComments]
   ,[solnRecUserID]
   ,[soldDtCreated]
   ,[solnModifyUserID]
   ,[soldDtModified]
   ,[solnLevelNo]
   ,[soldLastDtFileSc]
   ,[soldDateComplied]
   ,[solsType]
   ,[solbIsOld]
   ,[intCriticalDeadline]
   ,[soldComments]
	)
	SELECT DISTINCT
		casnCaseID
	   ,sldnSOLdetID
	   ,CASE
			WHEN ISDATE(DATE1) = 1 AND
				YEAR(DATE1) BETWEEN 1900 AND 2050
				THEN DATE1
			ELSE NULL
		END
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,''
	   ,NULL
	   ,NULL
	   ,NULL
	   ,plnnPlaintiffID
	   ,NULL
	   ,NULL
	   ,title
	   ,CASE ISNULL((u1.usrnuserid), '')
			WHEN ''
				THEN 368
			ELSE (u1.usrnuserid)
		END
	   ,CASE (a.datecreated)
			WHEN NULL
				THEN GETDATE()
			ELSE (a.datecreated)
		END
	   ,CASE ISNULL((u2.usrnuserid), '')
			WHEN ''
				THEN 368
			ELSE (u2.usrnuserid)
		END
	   ,CASE (a.daterevised)
			WHEN NULL
				THEN GETDATE()
			ELSE (a.daterevised)
		END
	   ,NULL
	   ,CASE
			WHEN ISDATE(DATE1) = 1 AND
				YEAR(DATE1) BETWEEN 1900 AND 2050
				THEN DATE1
			ELSE NULL
		END
	   ,CASE
			WHEN ISDATE(DATE2) = 1 AND
				YEAR(DATE2) BETWEEN 1900 AND 2050
				THEN DATE2
			ELSE NULL
		END
	   ,'P'
	   ,''
	   ,''
	   ,ISNULL(CONVERT(VARCHAR(4000), a.NOTES), '')
	FROM [WilliamPagerSaga].dbo.MRULASS a
	LEFT JOIN [WilliamPagerSaga].dbo.MATTER b
		ON a.MATTERID = b.MATTERID
	LEFT JOIN sma_trn_cases
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_trn_plaintiff
		ON plnncaseid = casncaseid
			AND plnbisprimary = 1
	LEFT JOIN sma_MST_SOLDetails
		ON sldnCaseTypeID = casnOrgCaseTypeID
			AND casnState = sldnStateID
			AND plnnrole = sldndefrole
			AND sldnsoltypeid = 14
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
		AND a.title LIKE 'no fault%'

UPDATE a
SET [solnSOLTypeID] = sldnSOLdetID
FROM sma_trn_sols a
LEFT JOIN sma_trn_cases
	ON casncaseid = solncaseid
OUTER APPLY (
	SELECT TOP 1
		sldnSOLdetID
	FROM sma_mst_soldetails
	WHERE sldncasetypeid = casnorgcasetypeid
		AND sldnsoltypeid <> 37
		AND sldnstateid = 26
) z
WHERE [solnSOLTypeID] IS NULL
AND solstype = 'd'

UPDATE a
SET [solnSOLTypeID] = sldnSOLdetID
FROM sma_trn_sols a
LEFT JOIN sma_trn_cases
	ON casncaseid = solncaseid
OUTER APPLY (
	SELECT TOP 1
		sldnSOLdetID
	FROM sma_mst_soldetails
	WHERE sldncasetypeid = casnorgcasetypeid
		AND sldnsoltypeid = 14
		AND sldnstateid = 26
) z
WHERE [solnSOLTypeID] IS NULL
AND solstype = 'p'

DELETE FROM sma_TRN_SOLs
WHERE solnSOLID NOT IN (
		SELECT
			MIN(solnSOLID)
		FROM sma_trn_sols
		GROUP BY soldSOLDate
				,solnCaseID
	)
ALTER TABLE [sma_TRN_SOLs] ENABLE TRIGGER ALL

