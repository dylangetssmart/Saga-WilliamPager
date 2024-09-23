USE WilliamPagerSA

ALTER TABLE [sma_TRN_PoliceReports] DISABLE TRIGGER ALL
INSERT INTO [sma_TRN_PoliceReports]
	(
	[pornCaseID]
   ,[porsDepartment]
   ,[porsDivision]
   ,[pornPoliceID]
   ,[pornPOContactID]
   ,[pornPOAddressID]
   ,[pornPoliceAdID]
   ,[pornPOCtgID]
   ,[porsPrecinct]
   ,[pornReportTypeID]
   ,[porsReportNo]
   ,[pordRepRequestDate]
   ,[pordRepReceivedDate]
   ,[pornRepProvidedByADID]
   ,[pornRepProvidedBy]
   ,[pornReportProvidedCtgID]
   ,[pornRepFavourable]
   ,[porsComments]
   ,[pornRecUserID]
   ,[pordDtCreated]
   ,[pornModifyUserID]
   ,[pordDtModified]
   ,[pornLevelNo]
	)
	SELECT
		casnCaseID
	   ,''
	   ,''
	   ,''
	   ,CASE
			WHEN o.cinnContactID IS NOT NULL
				THEN o.cinnContactID
			WHEN n.connContactID IS NOT NULL
				THEN n.connContactID
		END
	   ,CASE
			WHEN o.cinnContactID IS NOT NULL
				THEN IndvAddressID
			WHEN n.connContactID IS NOT NULL
				THEN orgAddressID
		END
	   ,''
	   ,CASE
			WHEN o.cinnContactID IS NOT NULL
				THEN 1
			WHEN n.connContactID IS NOT NULL
				THEN 2
		END
	   ,SUBSTRING(ep.FIRST_DBA, 0, 30)
	   ,CASE
			WHEN REPORTTYPE LIKE '%accident%'
				THEN 8
			ELSE NULL
		END
	   ,a.FILENUMBER
		--  ,CASE
		--	WHEN [REPORT_REQUESTED] BETWEEN '1/1/1900' AND '12/31/2079'
		--		THEN [REPORT_REQUESTED]
		--END
	   ,NULL				 -- ds 2024-09-23
	   ,CASE
			WHEN [REPORTDATE] IS NULL AND
				REPORTRECEIVED = 'T'
				THEN '1/1/2000'
			WHEN REPORTDATE BETWEEN '1/1/1900' AND '12/31/2079'
				THEN REPORTDATE
		END
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,SUBSTRING(REPORTTYPE, 0, 199)
	   ,casnRecUserID
	   ,CASE
			WHEN casdDtCreated BETWEEN '1/1/1900' AND '12/31/2079'
				THEN casdDtCreated
			ELSE GETDATE()
		END
	   ,NULL
	   ,NULL
	   ,''
	FROM [WilliamPagerSaga].[dbo].[LW_POLICEAGENCY] a
	LEFT JOIN [WilliamPagerSaga].[dbo].[ENTITIES] e
		ON ENTITYID = CONTACTID
	LEFT JOIN [WilliamPagerSaga].[dbo].[ASSIGN] b
		ON a.ASSIGNID = b.ASSIGNID
	LEFT JOIN [WilliamPagerSaga].dbo.MATTER m
		ON b.MATTERID = m.MATTERID
	LEFT JOIN sma_TRN_Cases
		ON cassCaseNumber = m.MATTERNUMBER
	LEFT JOIN sma_MST_IndvContacts l
		ON l.cinsGrade = e.ENTITYID
	LEFT JOIN sma_MST_OrgContacts k
		ON k.connLevelNo = e.ENTITYID
	LEFT JOIN [WilliamPagerSaga].[dbo].[ENTITIES] ep
		ON ep.ENTITYID = b.ENTITYID
	LEFT JOIN sma_MST_IndvContacts o
		ON o.cinsGrade = ep.ENTITYID
	LEFT JOIN sma_MST_OrgContacts n
		ON n.connLevelNo = ep.ENTITYID
	OUTER APPLY (
		SELECT TOP 1
			addnAddressID AS IndvAddressID
		FROM sma_MST_Address
		WHERE addnContactID = o.cinnContactID
			AND addnContactCtgID = 1
		ORDER BY ISNULL(addbPrimary, 0) DESC
	) z
	OUTER APPLY (
		SELECT TOP 1
			addnAddressID AS orgAddressID
		FROM sma_MST_Address
		WHERE addnContactID = n.connContactID
			AND addnContactCtgID = 2
		ORDER BY ISNULL(addbPrimary, 0) DESC
	) z1
ALTER TABLE [sma_TRN_PoliceReports] ENABLE TRIGGER ALL     


