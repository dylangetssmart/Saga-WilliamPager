USE WilliamPagerSA

INSERT INTO [sma_MST_TaskTemplateGroup]
	(
	[tskgrpName]
   ,[tskgrpRecUserID]
   ,[tskgrpDtCreated]
   ,[tskgrpModifyUserID]
   ,[tskgrpDtModified]
	)
	SELECT
		'SAGA'
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
GO
INSERT INTO [sma_mst_Task_Template]
	(
	[tskMasterDetails]
   ,[tskCategoryID]
   ,[tskDoneNoteTypeID]
   ,[tskPriority]
   ,[tskSubject]
   ,[tskDueDateShift]
   ,[tskDefAssigneeRole]
   ,[tskDocTemplateId]
   ,[tskDocTemplateKeyword]
   ,[tskNewStatusId]
   ,[tskChangeStatusId]
   ,[tskCreatedBy]
   ,[tskCreatedDt]
   ,[tskModifiedBy]
   ,[tskModifiedDt]
   ,[tskDefAssignee]
   ,[tskDefSecondaryRole]
	)
	SELECT DISTINCT
		description
	   ,CASE
			WHEN AType.description = 'review'
				THEN 3
			ELSE 4
		END
	   ,NULL
	   ,1
	   ,NULL
	   ,10
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	FROM [WilliamPagerSaga].dbo.PLRULE AType
	WHERE type IN (0, 3)
		AND LTRIM(RTRIM(description)) NOT IN (
			SELECT
				LTRIM(RTRIM([tskMasterDetails]))
			FROM [sma_mst_Task_Template]
		)
GO
ALTER TABLE sma_mst_TaskCaseStatus NOCHECK CONSTRAINT ALL
INSERT INTO sma_mst_taskcasestatus
	SELECT
		tskMasterID
	   ,0
	   ,GETDATE()
	   ,368
	   ,NULL
	   ,NULL
	FROM [sma_mst_Task_Template]
	WHERE tskMasterID >= (
			SELECT
				MIN(tskMasterID)
			FROM [sma_mst_Task_Template]
			WHERE [tskCreatedDt] > GETDATE() - 1
		)
GO
DECLARE @TemplateGroupID INT
SELECT
	@TemplateGroupID = MAX(tskgrpid)
FROM [sma_MST_TaskTemplateGroup]
WHERE tskgrpName = 'SAGA'

INSERT INTO [sma_TRN_TaskTemplateGroup]
	SELECT
		@TemplateGroupID
	   ,tskMasterID
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	FROM [sma_mst_Task_Template]
	WHERE tskMasterID >= (
			SELECT
				MIN(tskMasterID)
			FROM [sma_mst_Task_Template]
			WHERE [tskCreatedDt] > GETDATE() - 1
		)
GO
SELECT DISTINCT
	MATTERID
   ,t.Data
   ,THREADID INTO #tmpTask
FROM [WilliamPagerSaga].dbo.MRULASS muu
CROSS APPLY dbo.Split(RESPONSIBLELIST, ',') AS t
WHERE t.Data IS NOT NULL
	AND MATTERID IS NOT NULL
	AND RESPONSIBLELIST LIKE '%,%'
ORDER BY MATTERID
GO
INSERT INTO #tmpTask
	SELECT DISTINCT
		MATTERID
	   ,RESPONSIBLELIST
	   ,THREADID
	FROM [WilliamPagerSaga].dbo.MRULASS muu
	WHERE RESPONSIBLELIST IS NOT NULL
		AND MATTERID IS NOT NULL
		AND RESPONSIBLELIST NOT LIKE '%,%'
	ORDER BY MATTERID
GO
INSERT INTO [dbo].[sma_TRN_TaskNew]
	(
	[tskCaseID]
   ,[tskDueDate]
   ,[tskStartDate]
   ,[tskRequestorID]
   ,[tskAssigneeId]
   ,[tskReminderDays]
   ,[tskDescription]
   ,[tskCreatedDt]
   ,[tskCreatedUserID]
   ,[tskCompleted]
   ,[tskMasterID]
   ,[tskCtgID]
   ,[tskSummary]
   ,[tskModifiedDt]
   ,[tskModifyUserID]
   ,[tskPriority]
	)
	SELECT
		casnCaseID
	   ,CASE
			WHEN mr.DATE1 BETWEEN '1/1/1900' AND '12/31/2079'
				THEN mr.date1
			ELSE NULL
		END
	   ,CASE
			WHEN mr.DATECREATED BETWEEN '1/1/1900' AND '12/31/2079'
				THEN mr.DATECREATED
			ELSE NULL
		END
	   ,u1.usrnUserID
	   ,u3.usrnUserID
	   ,NULL
	   ,ISNULL(mr.TITLE, '') + CHAR(13) + CONVERT(VARCHAR(4000), ISNULL(mr.notes, ''))
	   ,CASE
			WHEN mr.DATECREATED BETWEEN '1/1/1900' AND '12/31/2079'
				THEN mr.DATECREATED
			ELSE GETDATE()
		END
	   ,u1.usrnUserID
	   ,CASE
			WHEN mr.Date2 IS NOT NULL
				THEN 1
			ELSE 0
		END
	   ,tskMasterID
	   ,tskCategoryID
	   ,ISNULL(mr.TITLE, '')
	   ,CASE
			WHEN mr.DATEREVISED BETWEEN '1/1/1900' AND '12/31/2079'
				THEN mr.DATEREVISED
			ELSE NULL
		END
	   ,u2.usrnUserID
	   ,tskPriority
	FROM [WilliamPagerSaga].dbo.matter m
	LEFT JOIN [WilliamPagerSaga].dbo.MRULASS mr
		ON m.MATTERID = mr.MATTERID
	LEFT JOIN #tmpTask z
		ON z.MATTERID = mr.MATTERID
			AND z.THREADID = mr.THREADID
	LEFT JOIN [WilliamPagerSaga].dbo.MRULENT mrl
		ON mr.THREADID = mrl.THREADID
	LEFT JOIN [WilliamPagerSaga].dbo.lw_matter lm
		ON m.matterid = lm.matterid
	LEFT JOIN [WilliamPagerSaga].dbo.LW_A_MATTERGROUP mg1
		ON m.MATTERGROUP1ID = mg1.MATTERGROUPID
	LEFT JOIN [WilliamPagerSaga].dbo.LW_A_MATTERGROUP mg2
		ON m.MATTERGROUP2ID = mg2.MATTERGROUPID
	LEFT JOIN [WilliamPagerSaga].dbo.LW_A_MATTERGROUP mg3
		ON m.MATTERGROUP3ID = mg3.MATTERGROUPID
	OUTER APPLY (
		SELECT TOP 1
			pt.description
		FROM [WilliamPagerSaga].dbo.PLRULE pt
		WHERE mr.RULETYPEID = pt.RULETYPEID
	) AType
	OUTER APPLY (
		SELECT TOP 1
			aa.partytype
		FROM [WilliamPagerSaga].dbo.assign aa
		WHERE m.MATTERID = aa.MATTERID
	) CrOurSide
	LEFT JOIN sma_trn_cases
		ON cassCaseNumber = m.MATTERNUMBER
	LEFT JOIN sma_trn_plaintiff
		ON plnncaseid = casncaseid
			AND plnbisprimary = 1
	LEFT JOIN sma_MST_SOLDetails
		ON sldnCaseTypeID = casnOrgCaseTypeID
			AND casnState = sldnStateID
			AND plnnrole = sldndefrole
			AND sldnsoltypeid = 14
	LEFT JOIN sma_MST_IndvContacts l
		ON l.cinsGrade = mrl.CREATORID
	LEFT JOIN sma_mst_users u1
		ON u1.usrnContactID = l.cinnContactID
	LEFT JOIN sma_MST_IndvContacts g
		ON g.cinsGrade = mrl.REVISORID
	LEFT JOIN sma_mst_users u2
		ON u2.usrnContactID = g.cinnContactID
	LEFT JOIN WilliamPagerSaga.dbo.ENTITIES et
		ON et.WPINITIALS = LTRIM(RTRIM(data))
	LEFT JOIN sma_MST_IndvContacts inew
		ON inew.cinsGrade = et.ENTITYID
	LEFT JOIN sma_mst_users u3
		ON u3.usrnContactID = inew.cinnContactID
	LEFT JOIN [sma_mst_Task_Template]
		ON AType.DESCRIPTION = tskMasterDetails
	WHERE casncaseid IS NOT NULL
		AND mr.type IN (0, 3)

GO
DROP TABLE #tmpTask
GO
DELETE FROM sma_TRN_TaskNew
WHERE NOT EXISTS (
		SELECT
			MIN(tskid) AS tskid
		FROM [sma_TRN_TaskNew]
		WHERE tskid = tskid
		GROUP BY tskCaseID
				,tskDueDate
				,tskStartDate
				,tskRequestorID
				,tskAssigneeId
				,tskDescription
				,tskCreatedDt
				,tskCreatedUserID
				,tskCompleted
				,tskMasterID
				,tskCtgID
				,tskSummary
	)
GO
UPDATE a
SET a.tskCompleted = 2
   ,a.tskModifiedDt = GETDATE()
   ,a.tskModifyUserID = 368
FROM sma_TRN_TaskNew a
WHERE tskAssigneeId IS NULL
AND ISNULL(tskCompleted, 0) = 0
AND EXISTS (
	SELECT
		*
	FROM sma_trn_tasknew b
	WHERE a.tskCaseID = b.tskCaseID
		AND a.tskDescription = b.tskDescription
		AND a.tskDueDate = b.tskDueDate
		AND ISNULL(b.tskCompleted, 0) = 0
		AND b.tskAssigneeId IS NOT NULL
)
GO
--Update a 
--set tskDueDate=getdate(),tskAssigneeId=case when tskassigneeid is null then usrnuserid end
--from sma_trn_tasknew a
--outer apply(select top 1 usrnUserID from sma_trn_casestaff left join sma_mst_users on usrnContactID=cssnStaffID where cssdToDate is null and cssnCaseID=tskCaseID order by replace(replace((cssnRoleID),8,0),5,1) desc)z
--where tskDueDate is null
--go
--Update a 
--set tskAssigneeId=case when tskassigneeid is null then usrnuserid end
--from sma_trn_tasknew a
--outer apply(select top 1 usrnUserID from sma_trn_casestaff left join sma_mst_users on usrnContactID=cssnStaffID where cssdToDate is null and cssnCaseID=tskCaseID order by replace(replace((cssnRoleID),8,0),5,1) desc)z
--where tskAssigneeId is null
