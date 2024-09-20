USE WilliamPagerSA

SET ANSI_WARNINGS OFF
--Insert Negotiation
INSERT INTO [sma_TRN_Negotiations]
	(
	[negnCaseID]
   ,[negsUniquePartyID]
   ,[negdDate]
   ,[negnStaffID]
   ,[negnPlaintiffID]
   ,[negbPartiallySettled]
   ,[negnClientAuthAmt]
   ,[negbOralConsent]
   ,[negdOralDtSent]
   ,[negdOralDtRcvd]
   ,[negnDemand]
   ,[negnOffer]
   ,[negbConsentType]
   ,[negnRecUserID]
   ,[negdDtCreated]
   ,[negnModifyUserID]
   ,[negdDtModified]
   ,[negnLevelNo]
   ,[negsComments]
	)
	SELECT DISTINCT
		casncaseid
	   ,CASE
			WHEN oo1.incnCaseID IS NOT NULL AND
				oo2.incnCaseID IS NOT NULL
				THEN 'I' + CONVERT(VARCHAR, oo2.incnInsCovgID)
			WHEN oo1.incnCaseID IS NOT NULL
				THEN 'I' + CONVERT(VARCHAR, oo1.incnInsCovgID)
			WHEN oo2.incnCaseID IS NOT NULL
				THEN 'I' + CONVERT(VARCHAR, oo2.incnInsCovgID)
			WHEN ISNULL(l1.lwfnLawFirmID, '') <> ''
				THEN 'L' + CONVERT(VARCHAR, l1.lwfnLawFirmID)
			WHEN
				ISNULL(l2.lwfnLawFirmID, '') <> ''
				THEN 'l' + CONVERT(VARCHAR, l2.lwfnLawFirmID)
		END
	   ,CASE
			WHEN ISDATE(l.ADATE) = 1 AND
				YEAR(l.ADATE) BETWEEN 1900 AND 2079
				THEN l.ADATE
			ELSE GETDATE()
		END
	   ,i1.cinnContactID
	   ,plnnPlaintiffID
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,l.DEMAND
	   ,l.OFFER
	   ,NULL
	   ,CASE ISNULL((u2.usrnuserid), '')
			WHEN ''
				THEN 368
			ELSE (u2.usrnuserid)
		END
	   ,CASE
			WHEN (m.datecreated) IS NULL
				THEN GETDATE()
			WHEN m.datecreated < '1900-01-01'
				THEN GETDATE()
			ELSE (m.datecreated)
		END
	   ,NULL
	   ,NULL
	   ,LW_LOGID
	   ,n.DESCRIPTION + CHAR(13) + CONVERT(VARCHAR(6000), LTRIM(REPLACE(REPLACE(REPLACE(dbo.RegExReplace(n.NOTES, '({\\)(.+?)(})|(\\)(.+?)(\b)', ''), '}', ''), CHAR(13), ''), CHAR(10), '')))
	FROM [WilliamPagerSaga].dbo.LW_log l
	LEFT JOIN [WilliamPagerSaga].dbo.matter m
		ON m.matterid = l.matterid
	LEFT JOIN [WilliamPagerSaga].dbo.note n
		ON n.NOTEID = l.NOTEID
	LEFT JOIN sma_trn_cases
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_TRN_Plaintiff
		ON plnnCaseID = casnCaseID
			AND plnbIsPrimary = 1
	LEFT JOIN sma_MST_IndvContacts i2
		ON i2.cinsGrade = l.ADJUSTER_ATTORNEYID
			AND ISNULL(i2.cinsGrade, '') <> ''
	LEFT JOIN sma_Mst_OrgContacts o1
		ON o1.connLevelNo = l.ADJUSTER_ATTORNEYID
			AND ISNULL(o1.connLevelNo, '') <> ''
	LEFT JOIN sma_TRN_InsuranceCoverage oo1
		ON oo1.incnAdjContactId = i2.cinnContactID
			AND oo1.incnCaseID = casnCaseID
	LEFT JOIN sma_TRN_InsuranceCoverage oo2
		ON oo2.incnInsContactID = o1.connContactID
			AND oo2.incnCaseID = casnCaseID
	LEFT JOIN sma_TRN_Defendants
		ON defnCaseID = casnCaseID
	LEFT JOIN sma_TRN_LawFirms l1
		ON l1.lwfnContactID = defnDefendentID
			AND l1.lwfnLawFirmContactID = o1.connContactID
			AND ISNULL(defnDefendentID, '') <> ''
			AND ISNULL(l.ADJUSTER_ATTORNEYID, '') <> ''
			AND l1.lwfnRoleType = 2
	LEFT JOIN sma_TRN_LawFirms l2
		ON l1.lwfnContactID = defnDefendentID
			AND l2.lwfnAttorneyContactID = i2.cinnContactID
			AND ISNULL(defnDefendentID, '') <> ''
			AND ISNULL(l.ADJUSTER_ATTORNEYID, '') <> ''
			AND l2.lwfnRoleType = 2
	LEFT JOIN sma_MST_IndvContacts cl
		ON cl.cinsGrade = m.CREATORID
	LEFT JOIN sma_mst_users u2
		ON u2.usrnContactID = cl.cinnContactID
	LEFT JOIN sma_MST_IndvContacts i1
		ON i1.cinsGrade = l.USERID
	WHERE casnCaseID IS NOT NULL
GO
IF OBJECT_ID('tmpNegotiation') IS NOT NULL
	DROP TABLE tmpNegotiation
GO
SELECT DISTINCT
	ROW_NUMBER() OVER (ORDER BY [negsUniquePartyID] DESC) AS RowNum
   ,(negnid)											  AS negid
   ,[negsUniquePartyID]
   ,negnCaseID
   ,negdDate
   ,negnStaffID
   ,negnDemand
   ,negnOffer INTO tmpNegotiation
FROM sma_TRN_Negotiations
ORDER BY ([negsUniquePartyID]) DESC
GO
DELETE FROM sma_TRN_Negotiations
WHERE negnID NOT IN (
		SELECT
			MIN(negid)
		FROM tmpNegotiation
		GROUP BY negnCaseID
				,negdDate
				,negnStaffID
				,negnDemand
				,negnOffer
		UNION
		SELECT
			MIN(negid)
		FROM tmpNegotiation
		WHERE [negsUniquePartyID] IS NOT NULL
		GROUP BY negnCaseID
				,negdDate
				,negnStaffID
				,negnDemand
				,negnOffer
	)
GO
DROP TABLE tmpNegotiation
GO
DELETE FROM sma_TRN_Negotiations
WHERE negnID NOT IN (
		SELECT
			MIN(negnid)
		FROM sma_TRN_Negotiations
		WHERE [negsUniquePartyID] IS NOT NULL
		GROUP BY negnCaseID
				,negdDate
				,negnStaffID
				,negnDemand
				,negnOffer
		UNION
		SELECT
			MAX(negnid)
		FROM sma_TRN_Negotiations
		GROUP BY negnCaseID
				,negdDate
				,negnStaffID
				,negnDemand
				,negnOffer
	)
GO
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
	SELECT
		negnID
	   ,negnCaseID
	   ,NULL
	   ,plnnPlaintiffID
	   ,NULL
	   ,SETTLEMENT
	   ,NULL
	   ,NULL
	   ,NULL
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
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,negdDate
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	FROM [WilliamPagerSaga].dbo.LW_log l
	JOIN sma_TRN_Negotiations
		ON negnLevelNo = LW_LOGID
	LEFT JOIN sma_TRN_Plaintiff
		ON plnnCaseID = negnCaseID
			AND plnbIsPrimary = 1
	WHERE ISNULL(SETTLEMENT, '0.00') <> '0.00'

