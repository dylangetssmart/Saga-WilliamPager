USE WilliamPagerSA

DELETE FROM [sma_MST_ActivityType]
WHERE attnActivityCtg <> 1

GO
INSERT INTO [dbo].[sma_MST_ActivityType]
	(
	[attsCode]
   ,[attsDscrptn]
   ,[attnActivityCtg]
   ,[attnmoduleID]
   ,[attsDefinition]
   ,[attnRecUserID]
   ,[attdDtCreated]
   ,[attnModifyUserID]
   ,[attdDtModified]
   ,[attnLevelNo]
	)
	SELECT DISTINCT
		''
	   ,pt.DESCRIPTION
	   ,1
	   ,NULL
	   ,NULL
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM [WilliamPagerSaga].dbo.MRULASS mr
	LEFT JOIN [WilliamPagerSaga].dbo.PLRULTYP pt
		ON mr.RULETYPEID = pt.RULETYPEID
	WHERE TYPE IN (1, 4)
	EXCEPT
	SELECT DISTINCT
		''
	   ,[attsDscrptn]
	   ,1
	   ,NULL
	   ,NULL
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM [sma_MST_ActivityType]
GO
INSERT INTO [sma_TRN_CalendarAppointments]
	(
	[FromDate]
   ,[ToDate]
   ,[AppointmentTypeID]
   ,[ActivityTypeID]
   ,[CaseID]
   ,[LocationContactID]
   ,[LocationContactGtgID]
   ,[JudgeID]
   ,[Comments]
   ,[StatusID]
   ,[Address]
   ,[Subject]
   ,[RecurranceParentID]
   ,[AdjournedID]
   ,[RecUserID]
   ,[DtCreated]
   ,[ModifyUserID]
   ,[DtModified]
   ,[DepositionType]
   ,[Deponants]
   ,[OriginalAppointmentID]
   ,[OriginalAdjournedID]
	)
	--Select distinct mr.date1+isnull(cast(TIMEFROM as TIME),''),mr.date1+isnull(cast(TIMETO as time),''),case when mr.type=4 then 0 else 3 end,attnActivityTypeID,casnCaseID,case when mr.TYPE=4 then  k.connContactID end,case when mr.TYPE=4 then k.connContactCtg end,z.crtJudgeorClerkContactID,isnull(convert(varchar(1800),notes),'')+char(13)+char(13),
	--CASE mr.STATUS WHEN 1 THEN 1 WHEN 2 THEN 3 WHEN 3 THEN 2 ELSE 1 END,convert(varchar(200),ISNULL(mr.LOCATION,'')),TITLE,null,null,u1.usrnUserID,mr.DATECREATED,u2.usrnUserID,mr.DATEREVISED,null,mr.THREADID,null,null
	SELECT DISTINCT
		CONVERT(DATETIME, mr.date1) + CONVERT(DATETIME, CONVERT(TIME, TIMEFROM))
	   ,CONVERT(DATETIME, mr.date1) + CONVERT(DATETIME, CONVERT(TIME, TIMETO))
	   ,CASE
			WHEN mr.type = 4
				THEN 0
			ELSE 3
		END
	   ,attnActivityTypeID
	   ,casnCaseID
	   ,CASE
			WHEN mr.TYPE = 4
				THEN k.connContactID
		END
	   ,CASE
			WHEN mr.TYPE = 4
				THEN k.connContactCtg
		END
	   ,z.crtJudgeorClerkContactID
	   ,ISNULL(CONVERT(VARCHAR(1800), notes), '') + CHAR(13) + CHAR(13)
	   ,CASE mr.STATUS
			WHEN 1
				THEN 1
			WHEN 2
				THEN 3
			WHEN 3
				THEN 2
			ELSE 1
		END
	   ,CONVERT(VARCHAR(200), ISNULL(mr.LOCATION, ''))
	   ,TITLE
	   ,NULL
	   ,NULL
	   ,u1.usrnUserID
	   ,mr.DATECREATED
	   ,u2.usrnUserID
	   ,mr.DATEREVISED
	   ,NULL
	   ,mr.THREADID
	   ,NULL
	   ,NULL
	FROM [WilliamPagerSaga].dbo.matter m
	LEFT JOIN [WilliamPagerSaga].dbo.MRULASS mr
		ON m.MATTERID = mr.MATTERID
	LEFT JOIN [WilliamPagerSaga].dbo.MRULENT mrl
		ON mr.THREADID = mrl.THREADID
	LEFT JOIN [WilliamPagerSaga].dbo.PLRULTYP pt
		ON mr.RULETYPEID = pt.RULETYPEID
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
		FROM [WilliamPagerSaga].dbo.PLRULTYP pt
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
	LEFT JOIN sma_MST_IndvContacts l
		ON l.cinsGrade = mr.CREATORID
	LEFT JOIN sma_mst_users u1
		ON u1.usrnContactID = l.cinnContactID
	LEFT JOIN sma_MST_IndvContacts g
		ON g.cinsGrade = mr.REVISORID
	LEFT JOIN sma_mst_users u2
		ON u2.usrnContactID = g.cinnContactID
	LEFT JOIN [sma_MST_ActivityType]
		ON LTRIM(RTRIM(pt.description)) = LTRIM(RTRIM(attsDscrptn))
	LEFT JOIN [WilliamPagerSaga].dbo.jurisdct jurisdct
		ON jurisdct.COURTID = mr.COURTID
	LEFT JOIN sma_TRN_Courts
		ON crtnCaseID = casnCaseID
	OUTER APPLY (
		SELECT
			crtJudgeorClerkContactID
		FROM sma_trn_caseJudgeorClerk
		LEFT JOIN sma_TRN_CourtDocket
			ON crdnCourtDocketID = crtDocketID
		LEFT JOIN sma_TRN_Courts
			ON crtnPKCourtsID = crdnCourtsID
		LEFT JOIN sma_MST_IndvContacts
			ON JUDGEID = cinsGrade
		WHERE crtnCaseID = casnCaseID
			AND cinnContactID = crtJudgeorClerkContactid
	) z
	OUTER APPLY (
		SELECT TOP 1
			connContactID
		   ,connContactCtg
		FROM sma_MST_OrgContacts k
		WHERE connContactID = crtnCourtID
			AND casnCaseID = crtnCaseID
	) k
	OUTER APPLY (
		SELECT TOP 1
			COALESCE(courtcasenumber, '') + COALESCE('/' + CourtCaseNumberExt, '') AS CoutDocketNo
		FROM [WilliamPagerSaga].dbo.lw_court lwc
		LEFT JOIN [WilliamPagerSaga].dbo.assign a
			ON lwc.assignid = a.assignid
		LEFT JOIN [WilliamPagerSaga].dbo.erole er
			ON er.roleid = a.roleid
		WHERE er.rolecategoryid = 6
			AND a.matterid = m.matterid
	) z1
	WHERE casncaseid IS NOT NULL
		AND mr.TYPE IN (1, 4)

GO
DELETE FROM sma_TRN_CalendarAppointments
WHERE AppointmentID NOT IN (
		SELECT
			MIN(AppointmentID)
		FROM sma_TRN_CalendarAppointments
		GROUP BY FromDate
				,ActivityTypeID
				,caseid
				,[subject]
	)


GO
SELECT DISTINCT
	MATTERID
   ,t.Data
   ,THREADID INTO #tmpapptss
FROM [WilliamPagerSaga].dbo.MRULASS muu
CROSS APPLY dbo.Split(RESPONSIBLELIST, ',') AS t
WHERE t.Data IS NOT NULL
	AND MATTERID IS NOT NULL
	AND RESPONSIBLELIST LIKE '%,%'
	AND muu.TYPE IN (1, 4)
ORDER BY MATTERID
GO
INSERT INTO sma_trn_AppointmentStaff
	SELECT
		appointmentid
	   ,CASE
			WHEN usrnContactID IS NOT NULL
				THEN usrnContactID
			ELSE cssnStaffID
		END
	FROM #tmpapptss
	LEFT JOIN sma_TRN_CalendarAppointments
		ON THREADID = Deponants
	--left join   [WilliamPagerSaga].dbo.MRULASS mu on mu.THREADID=Deponants 
	LEFT JOIN WilliamPagerSaga.dbo.ENTITIES et
		ON et.WPINITIALS = LTRIM(RTRIM(data))
	LEFT JOIN sma_MST_IndvContacts
		ON cinsGrade = et.ENTITYID
	LEFT JOIN sma_mst_users
		ON usrnContactID = cinnContactID
	LEFT JOIN sma_TRN_CaseStaff
		ON cssnCaseID = CaseID
			AND cssdToDate IS NULL
			AND cssnStaffID IS NOT NULL
	WHERE cssnStaffID IS NOT NULL
		AND appointmentid IS NOT NULL
GO
INSERT INTO sma_trn_AppointmentStaff
	SELECT
		appointmentid
	   ,CASE
			WHEN usrnContactID IS NOT NULL
				THEN usrnContactID
			ELSE cssnStaffID
		END
	FROM sma_TRN_CalendarAppointments
	LEFT JOIN [WilliamPagerSaga].dbo.MRULASS
		ON THREADID = Deponants
	LEFT JOIN WilliamPagerSaga.dbo.ENTITIES et
		ON et.WPINITIALS = LTRIM(RTRIM(RESPONSIBLELIST))
	LEFT JOIN sma_MST_IndvContacts
		ON cinsGrade = et.ENTITYID
	LEFT JOIN sma_mst_users
		ON usrnContactID = cinnContactID
	LEFT JOIN sma_TRN_CaseStaff
		ON cssnCaseID = CaseID
			AND cssdToDate IS NULL
			AND cssnStaffID IS NOT NULL
	WHERE cssnStaffID IS NOT NULL
		AND RESPONSIBLELIST NOT LIKE '%,%'
		AND [TYPE] IN (1, 4)
GO
DROP TABLE #tmpapptss
GO
GO
UPDATE sma_TRN_CalendarAppointments
SET Deponants = NULL
GO
--go
--Insert into sma_trn_AppointmentStaff
--Select appointmentid,cssnStaffID  from sma_TRN_CalendarAppointments
--left join sma_TRN_CaseStaff on cssnCaseID=CaseID and cssdToDate is null and cssnStaffID is not null               
--where cssnStaffID is not null   
