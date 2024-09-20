USE WilliamPagerSA

--MIGRATE WORKPLANS

DELETE FROM [dbo].[sma_MST_WorkPlans]
GO

DELETE FROM [dbo].[sma_MST_WorkPlanItemTemplates]
GO

DELETE FROM [dbo].[sma_MST_WorkPlanItem]
GO

DELETE FROM [dbo].[sma_TRN_WorkPlans]
GO

DELETE FROM [dbo].[sma_TRN_WorkPlanItems]
GO

DELETE FROM [dbo].[sma_TRN_WorkPlanItemContacts]
GO



SET IDENTITY_INSERT [dbo].[sma_MST_WorkPlans] ON
GO

INSERT INTO [dbo].[sma_MST_WorkPlans]
	(
	[uId]
   ,[Name]
   ,[Description]
   ,[CreatorId]
   ,[CreationDate]
   ,[ModifierId]
   ,[ModifyDate]
   ,[SpecialNotes]
   ,[IsDeleted]
	)
	SELECT
		[PLANID]
	   ,--[uId]
		[CODE]
	   , --[Name]
		[DESCRIPTION]
	   , --,[Description]
		[CREATORID]
	   ,--,[CreatorId]
		GETDATE()
	   , --,[CreationDate]
		[REVISORID]
	   , --,[ModifierId]
		NULL
	   , --,[ModifyDate]
		[NOTES]
	   , --,[SpecialNotes]
		0--,[IsDeleted]
	FROM [WilliamPagerSaga].[dbo].[PMPLAN]

GO

SET IDENTITY_INSERT [dbo].[sma_MST_WorkPlans] OFF
GO

SET IDENTITY_INSERT [dbo].[sma_MST_WorkPlanItemTemplates] ON;
GO

INSERT INTO [dbo].[sma_MST_WorkPlanItemTemplates]
	(
	[uId]
   ,[Name]
   ,[Description]
   ,[ItemTypeId]
   ,[CategoryId]
   ,[CreatorUserId]
   ,[CreationDate]
   ,[ModifyUserId]
   ,[ModifyDate]
   ,[PriorityId]
   ,[SpecialInstructions]
   ,[Due]
   ,[Reminder]
   ,[SecReminder]
   ,[TetReminder]
   ,[IsAutomatic]
   ,[RepeatFrequency]
   ,[RepeatCount]
   ,[DateFrom]
   ,[DateTo]
   ,[IsDueAfterHolidays]
   ,[DueType]
   ,[DueDays]
   ,[DueMonths]
   ,[DueYears]
   ,[EquationType]
   ,[ToPromptUser]
	)
	SELECT
		[RULEID]
	   ,--   [uId]
		ISNULL([TITLE], ISNULL([DESCRIPTION], ''))
	   ,	--,[Name]
		[DESCRIPTION]
	   ,--   ,[Description]
		CASE [TYPE]
			WHEN 0
				THEN 1
			WHEN 1
				THEN 2
			WHEN 2
				THEN 3
			WHEN 3
				THEN 1
			WHEN 4
				THEN 2
		END
	   , --   ,[ItemTypeId]
		CASE [TYPE]
			WHEN 0
				THEN 5
			WHEN 1
				THEN 59
			WHEN 2
				THEN 22
			WHEN 3
				THEN 1
			WHEN 4
				THEN 43
		END
	   , --   ,[CategoryId]
		[CREATORID]
	   ,NULL--   ,[CreatorUserId]
		--[DATECREATED]							-- ds 2024-09-20
	   , --   ,[CreationDate]
		[REVISORID]
	   ,null--   ,[ModifyUserId]
		--[DATEREVISED]							-- ds 2024-092-0
	   ,--   ,[ModifyDate]
		CASE [PRIORITY]
			WHEN 'Critical'
				THEN 1
			WHEN 'Urgent'
				THEN 1
			WHEN 'High'
				THEN 2
			WHEN 'Normal'
				THEN 3
		END
	   , --   ,[PriorityId]
		[INSTRUCTIONS]
	   ,--   ,[SpecialInstructions]
		[DUE]
	   , --   ,[Due]
		NULL
	   , --   ,[Reminder]
		NULL
	   , --   ,[SecReminder]
		NULL
	   , --   ,[TetReminder]
		CASE [AUTOMATIC]
			WHEN 'T'
				THEN 1
			ELSE 0
		END
	   , --   ,[IsAutomatic]
		NULL
	   , --   ,[RepeatFrequency]
		NULL
	   , --   ,[RepeatCount]
		NULL
	   , --   ,[DateFrom]
		NULL
	   , --   ,[DateTo]
		CASE [AFTERHOLIDAY]
			WHEN 'T'
				THEN 1
			ELSE 0
		END
	   ,--   ,[IsDueAfterHolidays]
		[DUEMODE]
	   , --   ,[DueType] ---MOST LIKELY WILL HAVE TO CHANGE THIS 
		[DUE]
	   , --   ,[DueDays]
		[DUEMONTHS]
	   , --   ,[DueMonths]
		[DUEYEARS]
	   ,--   ,[DueYears]
		1
	   ,--   ,[EquationType]
		CASE [PROMPT]
			WHEN 'T'
				THEN 1
			ELSE 0
		END --   ,[ToPromptUser]
	FROM [WilliamPagerSaga].[dbo].[PLRULE]

GO

SET IDENTITY_INSERT [dbo].[sma_MST_WorkPlanItemTemplates] OFF;
GO

SET IDENTITY_INSERT [dbo].[sma_MST_WorkPlanItem] ON;
GO

INSERT INTO [dbo].[sma_MST_WorkPlanItem]
	(
	[uId]
   ,[Name]
   ,[WorkPlanID]
   ,[Description]
   ,[SpecialInstructions]
   ,[ParentID]
   ,[TypeID]
   ,[CategoryID]
   ,[Reminder]
   ,[SecReminder]
   ,[TetReminder]
   ,[IsAutomatic]
   ,[CreatorUserID]
   ,[CreateDate]
   ,[ModifyUserID]
   ,[ModifyDate]
   ,[PriorityID]
   ,[RepeatFrequency]
   ,[RepeatCount]
   ,[DateFrom]
   ,[DateTo]
   ,[IsDueAfterHolidays]
   ,[DueType]
   ,[DueTargetId]
   ,[DueTargetEventId]
   ,[DueDays]
   ,[DueMonths]
   ,[DueYears]
   ,[EquationType]
   ,[ToPromptUser]
   ,[VisualIndex]
	)
	SELECT
		[THREADID]
	   , --[uId]
		[TITLE]
	   , --,[Name]
		[PLANID]
	   , --,[WorkPlanID]
		[COMPDESCRIPTION]
	   , --,[Description]
		[INSTRUCTIONS]
	   ,--,[SpecialInstructions]
		CASE [PARENTID]
			WHEN [THREADID]
				THEN 1
			ELSE [PARENTID]
		END
	   ,--,[ParentID]
		CASE [LOGICTYPE]
			WHEN 0
				THEN 4
			WHEN 1
				THEN 0
			ELSE [dbo].[sma_MST_WorkPlanItemTemplates].ItemTypeId
		END
	   , --,[TypeID]
		[dbo].[sma_MST_WorkPlanItemTemplates].CategoryId
	   , --,[CategoryID]
		NULL
	   ,--,[Reminder]
		NULL
	   , --,[SecReminder]
		NULL
	   , --,[TetReminder]
		CASE [AUTOMATIC]
			WHEN 'T'
				THEN 1
			ELSE 0
		END
	   , --,[IsAutomatic]
		[CREATORID]
	   , --,[CreatorUserID]
		GETDATE()
	   , --,[CreateDate]
		NULL
	   , --,[ModifyUserID]
		NULL
	   , --,[ModifyDate]
		CASE [PRIORITY]
			WHEN 'Critical'
				THEN 1
			WHEN 'Urgent'
				THEN 1
			WHEN 'High'
				THEN 2
			ELSE 3
		END
	   ,--,[PriorityID]
		NULL
	   , --,[RepeatFrequency]
		NULL
	   , --,[RepeatCount]
		[TIMEFROM]
	   ,--,[DateFrom]
		[TIMETO]
	   , --,[DateTo]
		CASE [AFTERHOLIDAY]
			WHEN 'T'
				THEN 1
			ELSE 0
		END
	   , --,[IsDueAfterHolidays]
		[DUEMODE]
	   ,--,[DueType]
		NULL
	   , --,[DueTargetId]
		NULL
	   , --,[DueTargetEventId]
		[WilliamPagerSaga].[dbo].[RULASS].[DUE]
	   , --,[DueDays]
		[WilliamPagerSaga].[dbo].[RULASS].[DUEMONTHS]
	   ,--,[DueMonths]
		[WilliamPagerSaga].[dbo].[RULASS].[DUEYEARS]
	   ,--,[DueYears]
		[dbo].[sma_MST_WorkPlanItemTemplates].EquationType
	   , --,[EquationType]
		CASE [PROMPT]
			WHEN 'T'
				THEN 1
			ELSE 0
		END
	   , --,[ToPromptUser]
		0 --,[VisualIndex]
	FROM [WilliamPagerSaga].[dbo].[RULASS]
	LEFT JOIN [dbo].[sma_MST_WorkPlanItemTemplates]
		ON [dbo].[sma_MST_WorkPlanItemTemplates].uId = RULEID

GO

SET IDENTITY_INSERT [dbo].[sma_MST_WorkPlanItem] OFF;
GO


SET IDENTITY_INSERT [dbo].[sma_TRN_WorkPlans] ON;
GO

INSERT INTO [dbo].[sma_TRN_WorkPlans]
	(
	[uId]
   ,[PlanId]
   ,[CaseId]
   ,[IsCompleted]
   ,[CompletionDate]
   ,[IsStarted]
   ,[StartDate]
   ,[Description]
   ,[Notes]
   ,[Name]
	)
	SELECT
		[MATPLANID]
	   , --[uId]
		[PLANID]
	   , --,[PlanId]
		[sma_TRN_Cases].casnCaseID
	   , --,[CaseId]
		CASE [ISCOMPLETED]
			WHEN 'T'
				THEN 1
			ELSE 0
		END
	   , --,[IsCompleted]
		CASE [ISCOMPLETED]
			WHEN 'F'
				THEN NULL
			WHEN 'T'
				THEN GETDATE()
		END
	   , --,[CompletionDate]
		CASE [ISSTARTED]
			WHEN 'T'
				THEN 1
			ELSE 0
		END
	   ,--,[IsStarted]
		CASE [ISSTARTED]
			WHEN 'F'
				THEN NULL
			WHEN 'T'
				THEN GETDATE()
		END
	   ,--,[StartDate]
		[DESCRIPTION]
	   , --,[Description]
		[NOTES]
	   , --,[Notes]
		[DESCRIPTION]--,[Name]
	FROM [WilliamPagerSaga].[dbo].[MATPLAN]
	INNER JOIN [WilliamPagerSaga].[dbo].[MATTER]
		ON [WilliamPagerSaga].[dbo].[MATTER].MATTERID = [WilliamPagerSaga].[dbo].[MATPLAN].MATTERID
	INNER JOIN [sma_TRN_Cases]
		ON [sma_TRN_Cases].cassCaseNumber = [WilliamPagerSaga].[dbo].[MATTER].MATTERNUMBER
GO

SET IDENTITY_INSERT [dbo].[sma_TRN_WorkPlans] OFF;
GO



SET IDENTITY_INSERT [dbo].[sma_TRN_WorkPlanItems] ON;
GO

INSERT INTO [dbo].[sma_TRN_WorkPlanItems]
	(
	[uId]
   ,[TemplateId]
   ,[CaseId]
   ,[Name]
   ,[WorkPlanId]
   ,[Description]
   ,[SpecialInstructions]
   ,[ParentID]
   ,[TypeID]
   ,[CategoryID]
   ,[Reminder]
   ,[SecReminder]
   ,[TetReminder]
   ,[IsAutomatic]
   ,[CreatorUserID]
   ,[CreateDate]
   ,[ModifyUserID]
   ,[ModifyDate]
   ,[PriorityID]
   ,[RepeatFrequency]
   ,[RepeatCount]
   ,[DateFrom]
   ,[DateTo]
   ,[IsDueAfterHolidays]
   ,[DueType]
   ,[DueTargetId]
   ,[DueTargetEventId]
   ,[DueDays]
   ,[DueMonths]
   ,[DueYears]
   ,[EquationType]
   ,[ToPromptUser]
   ,[StartDate]
   ,[CompletedDate]
   ,[DueDate]
   ,[VisualIndex]
	)
	SELECT
		[THREADID]
	   , --[uId]
		[RULEID]
	   , --,[TemplateId]
		ISNULL([sma_TRN_Cases].casnCaseID, 0)
	   , --,[CaseId]
		[TITLE]
	   , --,[Name]
		ISNULL([MATPLANID], 0)
	   , --,[WorkPlanId]
		[COMPDESCRIPTION]
	   , --,[Description]
		[INSTRUCTIONS]
	   , --,[SpecialInstructions]
		CASE [WilliamPagerSaga].[dbo].[MRULASS].[PARENTID]
			WHEN [THREADID]
				THEN 1
			ELSE [WilliamPagerSaga].[dbo].[MRULASS].[PARENTID]
		END
	   , --,[ParentID]
		CASE [LOGICTYPE]
			WHEN 0
				THEN 4
			WHEN 1
				THEN 0
			ELSE ISNULL([sma_MST_WorkPlanItem].TypeID, 1)
		END
	   , --,[TypeID]
		[sma_MST_WorkPlanItem].CategoryID
	   , --,[CategoryID]
		NULL
	   , --,[Reminder]
		NULL
	   , --,[SecReminder]
		NULL
	   , --,[TetReminder]
		CASE [AUTOMATIC]
			WHEN 'T'
				THEN 1
			ELSE 0
		END
	   , --,[IsAutomatic]
		[WilliamPagerSaga].[dbo].[MRULASS].[CREATORID]
	   , --,[CreatorUserID]
		[WilliamPagerSaga].[dbo].[MRULASS].[DATECREATED]
	   , --,[CreateDate]
		[WilliamPagerSaga].[dbo].[MRULASS].[REVISORID]
	   , --,[ModifyUserID]
		[WilliamPagerSaga].[dbo].[MRULASS].[DATEREVISED]
	   , --,[ModifyDate]
		CASE [PRIORITY]
			WHEN 'Critical'
				THEN 1
			WHEN 'Urgent'
				THEN 1
			WHEN 'High'
				THEN 2
			ELSE 3
		END
	   ,--,[PriorityID]
		NULL
	   , --,[RepeatFrequency]
		NULL
	   , --,[RepeatCount]
		[TIMEFROM]
	   , --,[DateFrom]
		[TIMETO]
	   , --,[DateTo]
		CASE [AFTERHOLIDAY]
			WHEN 'T'
				THEN 1
			ELSE 0
		END
	   , --,[IsDueAfterHolidays]
		[DUEMODE]
	   , --,[DueType]
		NULL
	   , --,[DueTargetId]
		NULL
	   , --,[DueTargetEventId]
		[WilliamPagerSaga].[dbo].[MRULASS].[DUE]
	   ,--,[DueDays]
		[WilliamPagerSaga].[dbo].[MRULASS].[DUEMONTHS]
	   , --,[DueMonths]
		[WilliamPagerSaga].[dbo].[MRULASS].[DUEYEARS]
	   , --,[DueYears]
		[sma_MST_WorkPlanItem].EquationType
	   , --,[EquationType]
		CASE [PROMPT]
			WHEN 'T'
				THEN 1
			ELSE 0
		END
	   , --,[ToPromptUser]
		CASE [STATUS]
			WHEN 0
				THEN NULL
			ELSE [WilliamPagerSaga].[dbo].[MRULASS].[DATECREATED]
		END
	   , --,[StartDate]
		CASE [STATUS]
			WHEN 2
				THEN GETDATE()
			ELSE NULL
		END
	   , --,[CompletedDate]
		NULL
	   , --,[DueDate]
		0--,[VisualIndex]
	FROM [WilliamPagerSaga].[dbo].[MRULASS]
	LEFT JOIN [dbo].[sma_MST_WorkPlanItem]
		ON [dbo].[sma_MST_WorkPlanItem].uId = [ADMINID]
	INNER JOIN [WilliamPagerSaga].[dbo].[MATTER]
		ON [WilliamPagerSaga].[dbo].[MATTER].MATTERID = [WilliamPagerSaga].[dbo].[MRULASS].MATTERID
	INNER JOIN [sma_TRN_Cases]
		ON [sma_TRN_Cases].cassCaseNumber = [WilliamPagerSaga].[dbo].[MATTER].MATTERNUMBER

GO

SET IDENTITY_INSERT [dbo].[sma_TRN_WorkPlanItems] OFF;
GO


--UPDATE [dbo].[sma_TRN_WorkPlanItems]
--   SET [StartDate] = [WilliamPagerSaga].[dbo].[MRULASS].[DATECREATED]
--FROM [WilliamPagerSaga].[dbo].[MRULASS]
--WHERE [WilliamPagerSaga].[dbo].[MRULASS].[THREADID] = [dbo].[sma_TRN_WorkPlanItems].uId
--AND [dbo].[sma_TRN_WorkPlanItems].StartDate IS NULL




--ADD entity / responsible parties
INSERT INTO [dbo].[sma_TRN_WorkPlanItemContacts]
	(
	[WorkPlanItemId]
   ,[RoleId]
   ,[ContactId]
   ,[IsCaseRole]
   ,[IsGeneralRole]
   ,[IsSpecificContact]
   ,[IsResponsible]
   ,[IsAssigner]
   ,[ToNotify]
   ,[CreatorId]
   ,[CreationDate]
   ,[ModifyerId]
   ,[ModifyDate]
	)
	SELECT
		[THREADID]
	   , --[WorkPlanItemId]
		NULL
	   , --,[RoleId]
		Indv.cinnContactID
	   , --,[ContactId]
		0
	   , --,[IsCaseRole]
		0
	   , --,[IsGeneralRole]
		1
	   , --,[IsSpecificContact]
		CASE [WilliamPagerSaga].[dbo].[MRULENT].[RESPONSIBLE]
			WHEN 'F'
				THEN 0
			ELSE 1
		END
	   , --,[IsResponsible]
		CASE [WilliamPagerSaga].[dbo].[MRULENT].[ASSIGNEDBY]
			WHEN 'F'
				THEN 0
			ELSE 1
		END
	   ,--,[IsAssigner]
		CASE [WilliamPagerSaga].[dbo].[MRULENT].[NOTIFY]
			WHEN 'F'
				THEN 0
			ELSE 1
		END
	   ,--,[ToNotify]
		sma_MST_Users.usrnUserID
	   , --,[CreatorId]
		[WilliamPagerSaga].[dbo].[MRULENT].[DATECREATED]
	   , --,[CreationDate]
		NULL
	   , --,[ModifyerId]
		NULL--,[ModifyDate] 
	FROM [WilliamPagerSaga].[dbo].[MRULENT]
	LEFT OUTER JOIN [WilliamPagerSaga].[dbo].[ENTITIES]
		ON [WilliamPagerSaga].[dbo].[ENTITIES].ENTITYID = [WilliamPagerSaga].[dbo].[MRULENT].ENTITYID
	LEFT OUTER JOIN [sma_MST_IndvContacts] Indv
		ON Indv.cinsGrade = [WilliamPagerSaga].[dbo].[MRULENT].ENTITYID
	LEFT OUTER JOIN [sma_MST_IndvContacts] IndvCreator
		ON [WilliamPagerSaga].[dbo].[MRULENT].[CREATORID] = IndvCreator.cinsGrade
	LEFT OUTER JOIN sma_MST_Users
		ON sma_MST_Users.usrnContactID = IndvCreator.cinnContactID



