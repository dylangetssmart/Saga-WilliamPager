USE WilliamPagerSA

INSERT INTO [sma_TRN_Settlements]
	(
	[stlnNegotID]
   ,[stlnCaseID]
   ,[stlsUniquePartyID]
   ,[stlnPlaintiffID]
   ,[stlnStaffID]
   ,[stlnSetAmt]
   ,[stlbConsentReqd]
   ,[stlbCourtConsent]
   ,[stldCourtDtSent]
   ,[stldCourtDtRcvd]
   ,[stldDocSendToClientOn]
   ,[stldDocReceivedFromClient]
   ,[stldDocSendToInsuranceCo]
   ,[stldDocExpectedDate]
   ,[stlnRecUserID]
   ,[stldDtCreated]
   ,[stlnModifyUserID]
   ,[stldDtModified]
   ,[stlnLevelNo]
   ,[stlnLessDisbursement]
   ,[stlnNet]
   ,[stlnForwarder]
   ,[stlnPrior]
   ,[stlnOther]
   ,[stlnGrossAttorneyFee]
   ,[stldSettlementDate]
   ,[stldDateOfDisbursement]
   ,[stlnAttFeeType]
   ,[stlnAttFeeValue]
   ,[stlnNetToClientAmt]
   ,[stlsComments]
	)
	SELECT DISTINCT
		negnID
	   ,casnCaseID
	   ,NULL
	   ,plnnPlaintiffID
	   ,i1.cinnContactID
	   ,b.AMOUNTDUE
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,CASE ISNULL((u2.usrnuserid), '')
			WHEN ''
				THEN 368
			ELSE (u2.usrnuserid)
		END
	   ,CASE (m.datecreated)
			WHEN NULL
				THEN GETDATE()
			ELSE (m.datecreated)
		END
	   ,NULL
	   ,NULL
	   ,b.LW_SETTLEID
	   ,NULL
	   ,b.AMOUNTDUE
	   ,NULL
	   ,NULL
	   ,NULL
	   ,l.SETTLEMENT / 3
	   ,CASE
			WHEN ISDATE(l.ADATE) = 1 AND
				YEAR(l.ADATE) < 2100
				THEN l.ADATE
			ELSE GETDATE()
		END
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,n.DESCRIPTION + CHAR(13) + CONVERT(VARCHAR(6000), LTRIM(REPLACE(REPLACE(REPLACE(dbo.RegExReplace(n.NOTES, '({\\)(.+?)(})|(\\)(.+?)(\b)', ''), '}', ''), CHAR(13), ''), CHAR(10), '')))
	FROM WilliamPagerSaga.dbo.LW_SETTLE b
	LEFT JOIN WilliamPagerSaga.dbo.ASSIGN a
		ON a.ASSIGNID = b.ASSIGNID
	LEFT JOIN WilliamPagerSaga.dbo.MATTER m
		ON m.MATTERID = a.MATTERID
	LEFT JOIN sma_TRN_CaseS
		ON cassCaseNumber = MATTERNUMBER
	OUTER APPLY (
		SELECT TOP 1
			negnid
		FROM sma_TRN_Negotiations
		WHERE negnCaseID = casnCaseID
	) z
	LEFT JOIN WilliamPagerSaga.dbo.LW_PAY p
		ON p.LW_SETTLEID = b.LW_SETTLEID
	LEFT JOIN [WilliamPagerSaga].dbo.LW_log l
		ON m.matterid = l.matterid
	LEFT JOIN WilliamPagerSaga.dbo.ASSIGN carr
		ON carr.ASSIGNID = b.CARRIERASSIGNID
	LEFT JOIN WilliamPagerSaga.dbo.ASSIGN def
		ON def.ASSIGNID = b.DEFENDANTASSIGNID
	LEFT JOIN WilliamPagerSaga.dbo.ASSIGN firm
		ON firm.ASSIGNID = b.FIRMASSIGNID
	LEFT JOIN [WilliamPagerSaga].dbo.entities estaff
		ON l.userid = estaff.entityid
	LEFT JOIN [WilliamPagerSaga].dbo.entities espoke
		ON l.ADJUSTER_ATTORNEYID = espoke.entityid
	LEFT JOIN [WilliamPagerSaga].dbo.LW_matter lm
		ON l.matterid = lm.matterid
	LEFT JOIN sma_TRN_Plaintiff
		ON plnnCaseID = casnCaseID
			AND plnbIsPrimary = 1
	LEFT JOIN sma_MST_IndvContacts i1
		ON i1.cinsGrade = estaff.ENTITYID
	LEFT JOIN sma_MST_IndvContacts i2
		ON i2.cinsGrade = espoke.ENTITYID
	LEFT JOIN sma_MST_IndvContacts cl
		ON cl.cinsGrade = m.CREATORID
	LEFT JOIN sma_mst_users u2
		ON u2.usrnContactID = cl.cinnContactID
	LEFT JOIN [WilliamPagerSaga].dbo.note n
		ON n.NOTEID = l.NOTEID
	WHERE casnCaseID IS NOT NULL --and  l.Settlement is not null  and CONVERT(varchar,negdDate,101)=CONVERT(varchar,l.ADATE,101)
GO
INSERT INTO [sma_TRN_CheckReceivedFeeRecorded]
	(
	[crfnSettlementID]
   ,[crfnAmount]
   ,[crfdReceivedDate]
   ,[crfsTypeOfAmount]
	)
	SELECT
		stlnID
	   ,PAID
	   ,PAIDDATE
	   ,'s'
	FROM sma_TRN_Settlements
	LEFT JOIN WilliamPagerSaga.dbo.LW_PAY
		ON LW_SETTLEID = stlnLevelNo
	WHERE stlnID IS NOT NULL
GO
ALTER TABLE sma_trn_settlements
ALTER COLUMN stlsComments VARCHAR(MAX)
GO
UPDATE a
SET stlsComments = ISNULL('Due: ' + ISNULL(CONVERT(VARCHAR, due, 101), '') + CHAR(13) + 'Amount: ' + ISNULL(CONVERT(VARCHAR, amount), '') + CHAR(13), '') + ISNULL('Paid Date: ' + CONVERT(VARCHAR(10), PAIDDATE, 101) + CHAR(13), '') + ISNULL('Paid: ' + CAST(paid AS VARCHAR(200)) + CHAR(13), '') + ISNULL(CONVERT(VARCHAR(MAX), comments), '') + ISNULL(stlsComments, '')
FROM sma_TRN_Settlements a
LEFT JOIN WilliamPagerSaga.dbo.LW_PAY
	ON LW_SETTLEID = stlnLevelNo
WHERE stlnID IS NOT NULL
GO
DELETE FROM sma_TRN_Settlements
WHERE stlnID NOT IN (
		SELECT
			MIN(stlnID)
		FROM sma_TRN_Settlements
		WHERE stlsUniquePartyID IS NOT NULL
		GROUP BY stlnNegotID
				,stlnCaseID
				,stlnSetAmt
		UNION
		SELECT
			MAX(stlnID)
		FROM sma_TRN_Settlements
		WHERE stlsUniquePartyID IS NULL
		GROUP BY stlnNegotID
				,stlnCaseID
				,stlnSetAmt
	)
GO

