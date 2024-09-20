USE WilliamPagerSA

SET ANSI_WARNINGS OFF
ALTER TABLE sma_trn_hospitals DISABLE TRIGGER ALL

INSERT INTO [sma_TRN_Hospitals]
	(
	[hosnCaseID]
   ,[hosnContactID]
   ,[hosnContactCtg]
   ,[hosnAddressID]
   ,[hossMedProType]
   ,[hosdStartDt]
   ,[hosdEndDt]
   ,[hosnNoVisits]
   ,[hosnImpair]
   ,[hosnTotalBill]
   ,[hosnExpert]
   ,[hosnWillTestify]
   ,[hosnIsMediConnect]
   ,[hosnPlaintiffID]
   ,[hosbDocAttached]
   ,[hosnParentHospitalId]
   ,[hosnRecUserID]
   ,[hosdDtCreated]
   ,[hosnModifyUserID]
   ,[hosdDtModified]
   ,[hosnLevelNo]
   ,[hosnMedRecordFee]
   ,[hosnMedReportFee]
   ,[hosnIsReferred]
   ,[hosnComments]
   ,[hosnAuthtoDefCouns]
   ,[hosnAuthtoDefCounsDt]
   ,[hosnAccountNo]
	)

	SELECT DISTINCT
		casnCaseID
	   ,CASE
			WHEN l.cinnContactID IS NOT NULL
				THEN l.cinnContactID
			WHEN k.connContactID IS NOT NULL
				THEN k.connContactID
		END
	   ,CASE
			WHEN l.cinnContactID IS NOT NULL
				THEN l.cinnContactCtg
			WHEN k.connContactID IS NOT NULL
				THEN k.connContactCtg
		END
	   ,CASE
			WHEN l.cinnContactID IS NOT NULL
				THEN IndvAddressID
			WHEN k.connContactID IS NOT NULL
				THEN orgAddressID
		END
	   ,'M'
	   ,CASE
			WHEN sps.StartDate BETWEEN '01/01/1900' AND '01/01/2050'
				THEN sps.STARTDATE
			ELSE NULL
		END
	   ,CASE
			WHEN sps.endDate BETWEEN '01/01/1900' AND '01/01/2050'
				THEN sps.ENDDATE
			ELSE NULL
		END
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,CASE
			WHEN q.cinnContactID IS NOT NULL
				THEN p1.plnnPlaintiffID
			ELSE p2.plnnPlaintiffID
		END
	   ,NULL
	   ,NULL
	   ,CASE
			WHEN u1.usrnuserid IS NULL
				THEN 368
			ELSE u1.usrnuserid
		END
	   ,CASE
			WHEN mt.DATECREATED IS NULL
				THEN GETDATE()
			WHEN mt.DATECREATED BETWEEN '01/01/1900' AND '01/01/2050'
				THEN GETDATE()
			ELSE mt.DATECREATED
		END
	   ,u2.usrnUserID
	   ,mt.DATEREVISED
	   ,med.MATRELTID
	   ,NULL
	   ,NULL
	   ,NULL
	   ,ISNULL(z.description, '') + CHAR(13) + ISNULL(CONVERT(VARCHAR(6000), LTRIM(REPLACE(
		dbo.RegExReplace(NOTES, '({\\)(.+?)(})|(\\)(.+?)(\b)', '')
		, '}', '')

		)), '')
	   ,NULL
	   ,NULL
	   ,NULL
	FROM [WilliamPagerSaga].dbo.LW_MEDICAL med
	LEFT JOIN [WilliamPagerSaga].dbo.MATRELT mt
		ON med.MATRELTID = mt.MATRELTID
	LEFT JOIN [WilliamPagerSaga].dbo.assign aprov
		ON mt.RelatedAssignID = aprov.assignid
	LEFT JOIN [WilliamPagerSaga].dbo.assign aplan
		ON mt.assignid = aplan.assignid
	LEFT JOIN WilliamPagerSaga.dbo.NOTE n
		ON n.NOTEID = mt.NOTEID
	LEFT JOIN [WilliamPagerSaga].dbo.entities eplan
		ON aplan.entityid = eplan.entityid
	LEFT JOIN [WilliamPagerSaga].dbo.entities eprov
		ON aprov.entityid = eprov.entityid
	LEFT JOIN [WilliamPagerSaga].dbo.LW_SPECIALS sps
		ON sps.matreltid = med.MATRELTID
	LEFT JOIN [WilliamPagerSaga].dbo.matter m
		ON aplan.matterid = m.matterid
	LEFT JOIN sma_TRN_CaseS
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_IndvContacts l
		ON l.cinsGrade = eprov.ENTITYID
	LEFT JOIN sma_MST_OrgContacts k
		ON k.connLevelNo = eprov.ENTITYID
	OUTER APPLY (
		SELECT TOP 1
			addnaddressid AS IndvAddressID
		FROM sma_MST_Address
		WHERE addnContactID = cinncontactid
			AND addnContactCtgID = 1
		ORDER BY ISNULL(addbPrimary, 0) DESC
	) a
	OUTER APPLY (
		SELECT TOP 1
			addnaddressid AS orgAddressID
		FROM sma_MST_Address
		WHERE addnContactID = conncontactid
			AND addnContactCtgID = 2
		ORDER BY ISNULL(addbPrimary, 0) DESC
	) b
	LEFT JOIN sma_MST_IndvContacts q
		ON q.cinsGrade = eplan.ENTITYID
	LEFT JOIN sma_MST_orgContacts u
		ON u.connLevelNo = eplan.ENTITYID
	LEFT JOIN sma_TRN_Plaintiff p1
		ON p1.plnnContactID = q.cinnContactID
			AND p1.plnnContactCtg = 1
			AND p1.plnnCaseID = casnCaseID
	LEFT JOIN sma_TRN_Plaintiff p2
		ON p2.plnnContactID = u.connContactID
			AND p2.plnnContactCtg = 2
			AND p2.plnnCaseID = casnCaseID
	LEFT JOIN sma_MST_IndvContacts v
		ON v.cinsGrade = mt.CREATORID
	LEFT JOIN sma_MST_IndvContacts w
		ON w.cinsGrade = mt.REVISORID
	LEFT JOIN sma_mst_users u1
		ON u1.usrnContactID = v.cinnContactID
	LEFT JOIN sma_mst_users u2
		ON u2.usrnContactID = w.cinnContactID
	OUTER APPLY (
		SELECT TOP 1
			spt.description
		FROM [WilliamPagerSaga].dbo.LW_A_SPECIALSSUB spt
		WHERE spt.SPECIALSSUBID = sps.SPECIALSSUBID
	) z
	WHERE casnCaseID IS NOT NULL

GO
DELETE FROM sma_TRN_Hospitals
WHERE hosnHospitalID NOT IN (
		SELECT
			MAX(hosnHospitalID)
		FROM sma_TRN_Hospitals
		GROUP BY hosnCaseID
				,hosnContactCtg
				,hosnContactID
				,hosnPlaintiffID
	)
GO
ALTER TABLE sma_trn_hospitals ENABLE TRIGGER ALL
GO
INSERT INTO [sma_MST_AdmissionType]
	(
	[amtsCode]
   ,[amtsDscrptn]
   ,[amtnRecUserID]
   ,[amtdDtCreated]
   ,[amtnModifyUserID]
   ,[amtdDtModified]
   ,[amtnLevelNo]
	)
	SELECT
		UPPER(SUBSTRING(ls.DESCRIPTION, 0, 4))
	   ,ls.DESCRIPTION
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM WilliamPagerSaga.dbo.[LW_A_SPECIALSSUB] ls
	WHERE ls.DESCRIPTION NOT IN (
			SELECT
				[amtsDscrptn]
			FROM [sma_MST_AdmissionType]
		)
GO

ALTER TABLE sma_TRN_Visits
ALTER COLUMN vissComments VARCHAR(4000)

ALTER TABLE [sma_TRN_Visits] DISABLE TRIGGER ALL

INSERT INTO [sma_TRN_Visits]
	(
	[vissRefTable]
   ,[visnRecordID]
   ,[visdAdmissionDt]
   ,[visnAdmissionTypeID]
   ,[visdDischargeDt]
   ,[vissAccountNo]
   ,[visdReq4RecSent]
   ,[visdRecExpDt]
   ,[visdRecRcvdDate]
   ,[visnRecAllVisits]
   ,[visdReq4RepSent]
   ,[visdRepExpDt]
   ,[visdRepRcvdDate]
   ,[visnRepAllVisits]
   ,[vissComplaint]
   ,[vissTesting]
   ,[vissDiagnosis]
   ,[vissTreatmentPlan]
   ,[visnAmount]
   ,[vissChkNo]
   ,[visdChkDt]
   ,[vissRequestId1]
   ,[vissRequestId2]
   ,[vissRecordType]
   ,[visbTreatmentEnded]
   ,[visnParentVisitID]
   ,[visnRecUserID]
   ,[visdDtCreated]
   ,[visnModifyUserID]
   ,[visdDtModified]
   ,[visnLevelNo]
   ,[visnRepAmount]
   ,[visnRecAmount]
   ,[visnRepID]
   ,[visnRecID]
   ,[vissComments]
   ,[visdReq4RecSent2]
   ,[visdReq4RepSent2]
   ,[visitResultTypeID]
	)
	SELECT
		'Hospitals'
	   ,hosnHospitalID
	   ,CASE
			WHEN ls.STARTDATE BETWEEN '01/01/1900' AND '12/31/2079'
				THEN ls.STARTDATE
			ELSE NULL
		END
	   ,amtnAdmsnTypeID
	   ,CASE
			WHEN ls.ENDDATE BETWEEN '01/01/1900' AND '12/31/2079'
				THEN ls.ENDDATE
			ELSE NULL
		END
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,0
	   ,NULL
	   ,NULL
	   ,NULL
	   ,0
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,'0.00'
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,0
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
	   ,ISNULL('Category: ' + lsp.DESCRIPTION, '') + CHAR(13)
		+ ISNULL(CASE
			WHEN RECORDSRECEIVED = 'F'
				THEN 'RECORDSRECEIVED: ' + 'No' + CHAR(13)
			WHEN RECORDSRECEIVED = 'T'
				THEN 'RECORDSRECEIVED: ' + 'Yes' + CHAR(13)
		END, '')
		+ ISNULL(CASE
			WHEN REPORTRECEIVED = 'F'
				THEN 'REPORTRECEIVED: ' + 'No' + CHAR(13)
			WHEN REPORTRECEIVED = 'T'
				THEN 'REPORTRECEIVED: ' + 'Yes' + CHAR(13)
		END, '')
		+ ISNULL(CASE
			WHEN REPORTDATE IS NOT NULL
				THEN 'REPORTDATE: ' + CONVERT(VARCHAR(10), REPORTDATE, 101) + CHAR(13)
		END, '')
		+ ISNULL(CASE
			WHEN RECORDS_REQUESTED IS NOT NULL
				THEN 'Records Requested: ' + CONVERT(VARCHAR(10), RECORDS_REQUESTED, 101) + CHAR(13)
		END, '')
		+ ISNULL(CASE
			WHEN REVIEWDATE IS NOT NULL
				THEN 'REVIEWDATE: ' + CONVERT(VARCHAR(10), REVIEWDATE, 101) + CHAR(13)
		END, '')
		+ ISNULL(CASE
			WHEN VISITS IS NOT NULL
				THEN 'VISITS: ' + CONVERT(VARCHAR, VISITS) + CHAR(13)
		END, '')
		+ ISNULL('Comments: ' + CONVERT(VARCHAR(4000), comments), '')
	   ,NULL
	   ,NULL
	   ,NULL
	FROM WilliamPagerSaga.dbo.[LW_SPECIALS] ls
	LEFT JOIN WilliamPagerSaga.dbo.[LW_A_SPECIALSSUB] lss
		ON lss.SPECIALSSUBID = ls.SPECIALSSUBID
	LEFT JOIN [sma_MST_AdmissionType]
		ON amtsDscrptn = lss.DESCRIPTION
	LEFT JOIN [WilliamPagerSaga].[dbo].[LW_MEDICAL] lm
		ON lm.MATRELTID = ls.MATRELTID
	LEFT JOIN WilliamPagerSaga.dbo.[LW_A_SPECIALS] lsp
		ON lsp.SPECIALSID = ls.SPECIALSID
	LEFT JOIN sma_TRN_Hospitals
		ON hosnLevelNo = lm.MATRELTID
--where lsp.DESCRIPTION like '%medical%'
ALTER TABLE [sma_TRN_Visits] ENABLE TRIGGER ALL
GO
ALTER TABLE sma_TRN_SpDamages DISABLE TRIGGER ALL
INSERT INTO sma_TRN_SpDamages
	(
	spdsRefTable
   ,spdnRecordID
   ,spdsBillNo
   ,spdnBillAmt
   ,spddSubmittedDt
   ,spdnPayerInsCoID
   ,spdnRole
   ,spdsAccntNo
   ,spdnAmtPaid
   ,spdnAdjustment
   ,spdnBalance
   ,spdnLienAmt
   ,spdbLienConfirmed
   ,spdnStaffID
   ,spddCommunicateDt
   ,spddWrittenDt
   ,spddFinalConfirmed
   ,spddFirmAckSignOff
   ,spdnLienorContact
   ,spdsComments
   ,spdbDocAttached
   ,spdnRecUserID
   ,spddDtCreated
   ,spdnLevelNo
   ,spdnVisitId
	)
	SELECT DISTINCT
		'Hospitals'
	   ,hosnHospitalID
	   ,NULL
	   ,SERVICEAMOUNT
	   ,SUBMITTEDDATE
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,0
	   ,0
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,368
	   ,GETDATE()
	   ,''
	   ,NULL
	FROM WilliamPagerSaga.dbo.[LW_SPECIALS] ls
	LEFT JOIN WilliamPagerSaga.dbo.[LW_A_SPECIALSSUB] lss
		ON lss.SPECIALSSUBID = ls.SPECIALSSUBID
	LEFT JOIN [sma_MST_AdmissionType]
		ON amtsDscrptn = lss.DESCRIPTION
	LEFT JOIN [WilliamPagerSaga].[dbo].[LW_MEDICAL] lm
		ON lm.MATRELTID = ls.MATRELTID
	LEFT JOIN WilliamPagerSaga.dbo.[LW_A_SPECIALS] lsp
		ON lsp.SPECIALSID = ls.SPECIALSID
	LEFT JOIN sma_TRN_Hospitals
		ON hosnLevelNo = lm.MATRELTID
	WHERE hosnHospitalID IS NOT NULL
		AND ISNULL(SERVICEAMOUNT, 0) > 0
ALTER TABLE sma_TRN_SpDamages ENABLE TRIGGER ALL
GO
INSERT INTO [sma_TRN_MedicalProviderRequest]
	(
	[MedPrvCaseID]
   ,[MedPrvPlaintiffID]
   ,[MedPrvRequestdate]
   ,[MedPrvCompleteDate]
   ,[MedPrvFromDate]
   ,[MedPrvToDate]
   ,[MedPrvComments]
   ,[MedPrvAssignee]
   ,[MedPrvHighPriority]
   ,[MedPrvAssignedBy]
   ,[MedPrvRecUserID]
   ,[MedPrvRecCreatedDt]
   ,[MedPrvModifiedUserId]
   ,[MedPrvModifiedDt]
   ,[MedPrvSendRecordsTo]
   ,[MedPrvRecordType]
   ,[MedPrvhosnHospitalID]
   ,[MedPrvCancel]
   ,[MedPrvIsAllRecords]
   ,[MedPrvStatusId]
   ,[MedPrvStatusDate]
   ,[MedPrvFollowUpDate]
   ,[MedPrvUntilToday]
   ,[MedPrvAuthorisationReceived]
	)
	SELECT DISTINCT
		hosnCaseID
	   ,hosnPlaintiffID
	   ,CASE
			WHEN RECORDS_REQUESTED BETWEEN '1/1/1900' AND '12/31/2079'
				THEN RECORDS_REQUESTED
		END
	   ,CASE
			WHEN RECORDS_REQUESTED BETWEEN '1/1/1900' AND '12/31/2079'
				THEN RECORDS_REQUESTED
		END
	   ,CASE
			WHEN RECORDS_REQUESTED BETWEEN '1/1/1900' AND '12/31/2079'
				THEN RECORDS_REQUESTED
		END
	   ,NULL
	   ,ISNULL(CONVERT(VARCHAR(MAX), comments), '')
	   ,usrnUserID
	   ,0
	   ,usrnUserID
	   ,usrnUserID
	   ,CASE
			WHEN RECORDS_REQUESTED BETWEEN '1/1/1900' AND '12/31/2079'
				THEN RECORDS_REQUESTED
		END
	   ,NULL
	   ,NULL
	   ,0
	   ,0
	   ,hosnHospitalID
	   ,NULL
	   ,0
	   ,CASE
			WHEN RECORDSRECEIVED = 'T'
				THEN 3
			ELSE 2
		END
	   ,CASE
			WHEN RECORDS_REQUESTED BETWEEN '1/1/1900' AND '12/31/2079'
				THEN RECORDS_REQUESTED
		END
	   ,CASE
			WHEN RECORDS_REQUESTED BETWEEN '1/1/1900' AND '12/31/2079'
				THEN RECORDS_REQUESTED
		END
	   ,1
	   ,NULL
	FROM WilliamPagerSaga.dbo.[LW_SPECIALS] ls
	LEFT JOIN WilliamPagerSaga.dbo.[LW_A_SPECIALSSUB] lss
		ON lss.SPECIALSSUBID = ls.SPECIALSSUBID
	LEFT JOIN [sma_MST_AdmissionType]
		ON amtsDscrptn = lss.DESCRIPTION
	LEFT JOIN [WilliamPagerSaga].[dbo].[LW_MEDICAL] lm
		ON lm.MATRELTID = ls.MATRELTID
	LEFT JOIN WilliamPagerSaga.dbo.[LW_A_SPECIALS] lsp
		ON lsp.SPECIALSID = ls.SPECIALSID
	LEFT JOIN sma_TRN_Hospitals
		ON hosnLevelNo = lm.MATRELTID
	OUTER APPLY (
		SELECT TOP 1
			usrnuserid
		FROM sma_TRN_CaseStaff
		LEFT JOIN sma_MST_SubRole
			ON sbrnSubRoleId = cssnRoleID
		JOIN sma_MST_Users
			ON usrnContactID = cssnStaffID
		WHERE cssdToDate IS NULL
			AND cssnCaseID = hosnCaseID
		ORDER BY CASE
			WHEN sbrsDscrptn LIKE '%primary paralegal%'
				THEN 2
			WHEN sbrsDscrptn LIKE '%paralegal%'
				THEN 1
			ELSE 0
		END DESC
	) z
--where RECORDS_REQUESTED is not null and REPORTRECEIVED='F' and RECORDSRECEIVED='F'
GO

SELECT
	spdnRecordID
   ,SUM(spdnBillAmt) AS TotBillAmt INTO #tmpspbilamt
FROM sma_TRN_SpDamages
WHERE spdsRefTable = 'Hospitals'
GROUP BY spdnRecordID


ALTER TABLE sma_TRN_Hospitals DISABLE TRIGGER ALL
UPDATE a
SET hosnTotalBill = TotBillAmt
FROM sma_TRN_Hospitals a
JOIN #tmpspbilamt
	ON hosnHospitalID = spdnRecordID
WHERE hosnTotalBill IS NULL
ALTER TABLE sma_TRN_Hospitals ENABLE TRIGGER ALL

DROP TABLE #tmpspbilamt
GO
IF NOT EXISTS (
		SELECT
			*
		FROM sma_MST_ProviderTypes
		WHERE prvsDscrptn = 'Property Damage'
	)
BEGIN
	INSERT INTO sma_MST_ProviderTypes
		SELECT
			'PROPDAM'
		   ,'Property Damage'
		   ,368
		   ,GETDATE()
		   ,NULL
		   ,NULL
		   ,''
END
INSERT INTO [dbo].[sma_TRN_OthrProviders]
	(
	[otpnCaseID]
   ,[otpnAddressID]
   ,[otpnContactID]
   ,[otpnContactCtg]
   ,[otpnType]
   ,[otpdStartDt]
   ,[otpdEndDt]
   ,[otpnNoVisits]
   ,[otpnTotalBill]
   ,[otpnPlaintiffID]
   ,[otpbDocAttached]
   ,[otpnRecUserID]
   ,[otpdDtCreated]
   ,[otpnModifyUserID]
   ,[otpdDtModified]
   ,[otpnLevelNo]
	)
	SELECT DISTINCT
		casnCaseID
	   ,CASE
			WHEN l.cinnContactID IS NOT NULL
				THEN IndvAddressID
			WHEN k.connContactID IS NOT NULL
				THEN orgAddressID
		END
	   ,CASE
			WHEN l.cinnContactID IS NOT NULL
				THEN l.cinnContactID
			WHEN k.connContactID IS NOT NULL
				THEN k.connContactID
		END
	   ,CASE
			WHEN l.cinnContactID IS NOT NULL
				THEN l.cinnContactCtg
			WHEN k.connContactID IS NOT NULL
				THEN k.connContactCtg
		END
	   ,prvnProvTypeID
	   ,CASE
			WHEN ls.StartDate BETWEEN '01/01/1900' AND '01/01/2050'
				THEN ls.STARTDATE
			ELSE NULL
		END
	   ,CASE
			WHEN ls.endDate BETWEEN '01/01/1900' AND '01/01/2050'
				THEN ls.ENDDATE
			ELSE NULL
		END
	   ,NULL
	   ,NULL
	   ,CASE
			WHEN q.cinnContactID IS NOT NULL
				THEN p1.plnnPlaintiffID
			ELSE p2.plnnPlaintiffID
		END
	   ,NULL
	   ,CASE
			WHEN u1.usrnuserid IS NULL
				THEN 368
			ELSE u1.usrnuserid
		END
	   ,CASE
			WHEN mt.DATECREATED IS NULL
				THEN GETDATE()
			WHEN mt.DATECREATED BETWEEN '01/01/1900' AND '01/01/2050'
				THEN GETDATE()
			ELSE mt.DATECREATED
		END
	   ,u2.usrnUserID
	   ,mt.DATEREVISED
	   ,ls.LW_SPECIALSID
	FROM WilliamPagerSaga.dbo.[LW_SPECIALS] ls
	LEFT JOIN [WilliamPagerSaga].dbo.MATRELT mt
		ON ls.MATRELTID = mt.MATRELTID
	LEFT JOIN [WilliamPagerSaga].dbo.assign aprov
		ON mt.RelatedAssignID = aprov.assignid
	LEFT JOIN [WilliamPagerSaga].dbo.assign aplan
		ON mt.assignid = aplan.assignid
	LEFT JOIN WilliamPagerSaga.dbo.NOTE n
		ON n.NOTEID = mt.NOTEID
	LEFT JOIN [WilliamPagerSaga].dbo.matter m
		ON aplan.matterid = m.matterid
	LEFT JOIN sma_TRN_CaseS
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_IndvContacts l
		ON l.cinsGrade = aprov.ENTITYID
	LEFT JOIN sma_MST_OrgContacts k
		ON k.connLevelNo = aprov.ENTITYID
	OUTER APPLY (
		SELECT TOP 1
			addnaddressid AS IndvAddressID
		FROM sma_MST_Address
		WHERE addnContactID = cinncontactid
			AND addnContactCtgID = 1
		ORDER BY ISNULL(addbPrimary, 0) DESC
	) a
	OUTER APPLY (
		SELECT TOP 1
			addnaddressid AS orgAddressID
		FROM sma_MST_Address
		WHERE addnContactID = conncontactid
			AND addnContactCtgID = 2
		ORDER BY ISNULL(addbPrimary, 0) DESC
	) b
	LEFT JOIN sma_MST_IndvContacts q
		ON q.cinsGrade = aplan.ENTITYID
	LEFT JOIN sma_MST_orgContacts u
		ON u.connLevelNo = aplan.ENTITYID
	LEFT JOIN sma_TRN_Plaintiff p1
		ON p1.plnnContactID = q.cinnContactID
			AND p1.plnnContactCtg = 1
			AND p1.plnnCaseID = casnCaseID
	LEFT JOIN sma_TRN_Plaintiff p2
		ON p2.plnnContactID = u.connContactID
			AND p2.plnnContactCtg = 2
			AND p2.plnnCaseID = casnCaseID
	LEFT JOIN sma_MST_IndvContacts v
		ON v.cinsGrade = mt.CREATORID
	LEFT JOIN sma_MST_IndvContacts w
		ON w.cinsGrade = mt.REVISORID
	LEFT JOIN sma_mst_users u1
		ON u1.usrnContactID = v.cinnContactID
	LEFT JOIN sma_mst_users u2
		ON u2.usrnContactID = w.cinnContactID
	LEFT JOIN WilliamPagerSaga.dbo.[LW_A_SPECIALSSUB] lss
		ON lss.SPECIALSSUBID = ls.SPECIALSSUBID
	CROSS JOIN sma_MST_ProviderTypes
	WHERE lss.DESCRIPTION LIKE '%damage%'
		AND prvsDscrptn = 'Property Damage'

GO
INSERT INTO sma_TRN_SpDamages
	(
	spdsRefTable
   ,spdnRecordID
   ,spdsBillNo
   ,spdnBillAmt
   ,spddSubmittedDt
   ,spdnPayerInsCoID
   ,spdnRole
   ,spdsAccntNo
   ,spdnAmtPaid
   ,spdnAdjustment
   ,spdnBalance
   ,spdnLienAmt
   ,spdbLienConfirmed
   ,spdnStaffID
   ,spddCommunicateDt
   ,spddWrittenDt
   ,spddFinalConfirmed
   ,spddFirmAckSignOff
   ,spdnLienorContact
   ,spdsComments
   ,spdbDocAttached
   ,spdnRecUserID
   ,spddDtCreated
   ,spdnLevelNo
   ,spdnVisitId
	)
	SELECT DISTINCT
		'OthrProviders'
	   ,otpnProviderID
	   ,NULL
	   ,SERVICEAMOUNT
	   ,SUBMITTEDDATE
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,0
	   ,0
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,368
	   ,GETDATE()
	   ,''
	   ,NULL
	FROM WilliamPagerSaga.dbo.[LW_SPECIALS] ls
	LEFT JOIN WilliamPagerSaga.dbo.[LW_A_SPECIALSSUB] lss
		ON lss.SPECIALSSUBID = ls.SPECIALSSUBID
	LEFT JOIN [sma_MST_AdmissionType]
		ON amtsDscrptn = lss.DESCRIPTION
	LEFT JOIN WilliamPagerSaga.dbo.[LW_A_SPECIALS] lsp
		ON lsp.SPECIALSID = ls.SPECIALSID
	LEFT JOIN sma_TRN_OthrProviders
		ON otpnLevelNo = ls.LW_SPECIALSID
	WHERE otpnProviderID IS NOT NULL
		AND ISNULL(SERVICEAMOUNT, 0) > 0
		AND lss.DESCRIPTION LIKE '%damage%'



