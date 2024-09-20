USE WilliamPagerSA

INSERT INTO [sma_MST_LienType]
	(
	[lntsCode]
   ,[lntsDscrptn]
   ,[lntnRecUserID]
   ,[lntdDtCreated]
   ,[lntnModifyUserID]
   ,[lntdDtModified]
   ,[lntnLevelNo]
	)
	SELECT DISTINCT
		''
	   ,DESCRIPTION
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM [WilliamPagerSaga].[dbo].[LW_LIENS] a
	JOIN [WilliamPagerSaga].[dbo].[LW_A_LIENCATEGORY] b
		ON a.[LIENCATEGORYID] = b.[LIENCATEGORYID]
	EXCEPT
	SELECT DISTINCT
		''
	   ,[lntsDscrptn]
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM [sma_MST_LienType]

ALTER TABLE [sma_TRN_Lienors] DISABLE TRIGGER ALL

INSERT INTO [sma_TRN_Lienors]
	(
	[lnrnLienorContactCtgID]
   ,[lnrnLienorContactID]
   ,[lnrnLienorAddressID]
   ,[lnrnLienorRelaContactID]
   ,[lnrnPlaintiffID]
   ,[lnrnCaseID]
   ,[lnrnLienorTypeID]
   ,[lnrnAgentContactCtg]
   ,[lnrnAgentContactID]
   ,[lnrnAgentAddressID]
   ,[lnrnUnCnfrmdLienAmount]
   ,[lnrnCnfrmdLienAmount]
   ,[lnrnNegLienAmount]
   ,[lnrsFileNo]
   ,[lnrnPolicyReceipt]
   ,[lnrnERISA]
   ,[lnrdNoticeDate]
   ,[lnrsCertifiedMail]
   ,[lnrdRcptSignedDt]
   ,[lnrsComments]
   ,[lnrbDocAttached]
   ,[lnrnRecUserID]
   ,[lnrdDtCreated]
   ,[lnrnModifyUserID]
   ,[lnrdDtModified]
   ,[lnrnLevelNo]
   ,[lnrnAgentPersonCtg]
   ,[lnrnAgentPersonContactID]
   ,[lnrnAgentPersonAddID]
   ,[lnrnLienorRelaAddID]
   ,[lnrnFinal]
	)
	SELECT
		CASE
			WHEN o.connContactID IS NOT NULL
				THEN 2
			WHEN p.cinnContactID IS NOT NULL
				THEN 1
		END
	   ,CASE
			WHEN o.connContactID IS NOT NULL
				THEN o.connContactID
			WHEN p.cinnContactID IS NOT NULL
				THEN p.cinnContactID
		END
	   ,CASE
			WHEN o.connContactID IS NOT NULL
				THEN orgAddressID
			WHEN p.cinnContactID IS NOT NULL
				THEN IndvAddressID
		END
	   ,NULL
	   ,plnnPlaintiffID
	   ,casnCaseID
	   ,lntnLienTypeID
	   ,NULL
	   ,NULL
	   ,NULL
	   ,LIENDENIEDAMOUNT
	   ,LIENAMOUNT
	   ,LIENPAIDAMOUNT
	   ,CLAIMFILENUMBER
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,CASE
			WHEN ISDATE(LIENRECEIVEDDATE) = 1 AND
				YEAR(LIENRECEIVEDDATE) BETWEEN 1900 AND 2050
				THEN LIENRECEIVEDDATE
			ELSE NULL
		END
	   ,SUBSTRING(ll.COMMENTS, 0, 2000)
	   ,''
	   ,casnRecUserID
	   ,casdDtCreated
	   ,NULL
	   ,NULL
	   ,''
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	FROM [WilliamPagerSaga].[dbo].[LW_LIENS] ll
	LEFT JOIN [WilliamPagerSaga].[dbo].LW_A_LIENCATEGORY lc
		ON ll.LIENCATEGORYID = lc.LIENCATEGORYID
	LEFT JOIN [WilliamPagerSaga].[dbo].assign ahol
		ON ll.LIENHOLDERASSIGNID = ahol.assignid
	LEFT JOIN [WilliamPagerSaga].[dbo].assign apl
		ON ll.PLAINTIFFASSIGNID = apl.assignid
	LEFT JOIN [WilliamPagerSaga].[dbo].entities ehol
		ON ehol.entityid = ahol.entityid
	LEFT JOIN [WilliamPagerSaga].[dbo].entities epl
		ON epl.entityid = apl.entityid
	LEFT JOIN [WilliamPagerSaga].[dbo].matter m
		ON apl.matterid = m.matterid
	LEFT JOIN [WilliamPagerSaga].[dbo].LW_DENIALS ld
		ON ld.LW_LIENSID = ll.LW_LIENSID
	LEFT JOIN sma_MST_IndvContacts l
		ON l.cinsGrade = epl.ENTITYID
	LEFT JOIN sma_MST_OrgContacts k
		ON k.connLevelNo = epl.ENTITYID
	LEFT JOIN sma_trn_cases
		ON cassCaseNumber = m.MATTERNUMBER
	LEFT JOIN sma_TRN_Plaintiff
		ON ((plnnContactID = k.conncontactid
					AND plnnContactCtg = 2)
				OR (plnnContactID = l.cinncontactid
					AND plnnContactCtg = 1))
			AND plnnCaseID = casnCaseID
	LEFT JOIN sma_MST_OrgContacts o
		ON o.connLevelNo = ehol.ENTITYID
	LEFT JOIN sma_MST_IndvContacts p
		ON p.cinsGrade = ehol.ENTITYID
	OUTER APPLY (
		SELECT TOP 1
			addnaddressid AS IndvAddressID
		FROM sma_MST_Address
		WHERE addnContactID = p.cinncontactid
			AND addnContactCtgID = 1
		ORDER BY ISNULL(addbPrimary, 0) DESC
	) z
	OUTER APPLY (
		SELECT TOP 1
			addnaddressid AS orgAddressID
		FROM sma_MST_Address
		WHERE addnContactID = o.conncontactid
			AND addnContactCtgID = 2
		ORDER BY ISNULL(addbPrimary, 0) DESC
	) z1
	LEFT JOIN [sma_MST_LienType]
		ON lntsDscrptn = lc.DESCRIPTION
	WHERE apl.partytype = 1
ALTER TABLE [sma_TRN_Lienors] ENABLE TRIGGER ALL

ALTER TABLE sma_TRN_Lienors DISABLE TRIGGER ALL
UPDATE sma_TRN_Lienors
SET lnrnFinal = 0
   ,lnrnLienorRelaAddID = 0
   ,lnrnAgentPersonAddID = 0
   ,lnrnAgentPersonContactID = 0
   ,lnrnAgentPersonCtg = 0
   ,lnrnNegLienAmount = '0.00'
   ,lnrnUnCnfrmdLienAmount = '0.00'
   ,lnrnAgentContactCtg = 0
   ,lnrnAgentContactID = 0
   ,lnrnAgentAddressID = 0
   ,lnrnLienorRelaContactID = 0
WHERE lnrnFinal IS NULL
AND lnrnLienorRelaAddID IS NULL
AND lnrnAgentPersonAddID IS NULL
AND lnrnAgentPersonContactID IS NULL
AND lnrnAgentPersonCtg IS NULL
AND lnrnNegLienAmount IS NULL
AND lnrnUnCnfrmdLienAmount IS NULL
AND lnrnAgentContactCtg IS NULL
AND lnrnAgentContactID IS NULL
AND lnrnAgentAddressID IS NULL
AND lnrnLienorRelaContactID IS NULL
ALTER TABLE sma_TRN_Lienors ENABLE TRIGGER ALL

ALTER TABLE sma_TRN_Lienors DISABLE TRIGGER ALL
UPDATE sma_TRN_Lienors
SET lnrnFinal = 0
   ,lnrnLienorRelaAddID = 0
   ,lnrnAgentPersonAddID = 0
   ,lnrnAgentPersonContactID = 0
   ,lnrnAgentPersonCtg = 0
   ,lnrnAgentContactCtg = 0
   ,lnrnAgentContactID = 0
   ,lnrnAgentAddressID = 0
   ,lnrnLienorRelaContactID = 0
WHERE lnrnFinal IS NULL
AND lnrnLienorRelaAddID IS NULL
AND lnrnAgentPersonAddID IS NULL
AND lnrnAgentPersonContactID IS NULL
AND lnrnAgentPersonCtg IS NULL
AND lnrnAgentContactCtg IS NULL
AND lnrnAgentContactID IS NULL
AND lnrnAgentAddressID IS NULL
AND lnrnLienorRelaContactID IS NULL
ALTER TABLE sma_TRN_Lienors ENABLE TRIGGER ALL

ALTER TABLE sma_TRN_LienDetails DISABLE TRIGGER ALL
INSERT INTO sma_TRN_LienDetails
	(
	lndnLienorID
   ,lnddLienDt
   ,lndnLienAmt
   ,lndnCommTypeID
   ,lndnUnCnfrmdLienAmount
   ,lndnCnfrmdLienAmount
   ,lnddConfrmtnReceivedDt
   ,lndnLienTypeID
   ,lndbIsConffirmed
   ,lnddItemizReqDate
   ,lnddItemizRcvdDate
   ,lnddClientNotifiedDate
   ,lnddClientRespDate
   ,lndsComments
   ,lndbWaived
   ,lndsRefTable
   ,lndnRecordID
   ,lndnRecUserID
   ,lnddDtCreated
   ,lndnLevelNo
	)
	SELECT
		lnrnLienorID
	   ,lnrdRcptSignedDt
	   ,NULL
	   ,NULL
	   ,NULL
	   ,lnrnCnfrmdLienAmount
	   ,NULL
	   ,lnrnLienorTypeID
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,''
	   ,NULL
	   ,'sma_TRN_Lienors'
	   ,lnrnLienorID
	   ,lnrnRecUserID
	   ,lnrdDtCreated
	   ,0
	FROM sma_TRN_Lienors
ALTER TABLE sma_TRN_LienDetails ENABLE TRIGGER ALL
