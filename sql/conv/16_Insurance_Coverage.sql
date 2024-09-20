USE WilliamPagerSA

INSERT INTO [sma_MST_InsuranceType]
	(
	[intsCode]
   ,[intsDscrptn]
   ,[intnRecUserID]
   ,[intdDtCreated]
   ,[intnModifyUserID]
   ,[intdDtModified]
   ,[intnLevelNo]
	)
	SELECT DISTINCT
		''
	   ,DESCRIPTION
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM [WilliamPagerSaga].dbo.lw_a_coveragetype icoverage
	WHERE DESCRIPTION NOT IN (
			SELECT
				intsDscrptn
			FROM [sma_MST_InsuranceType]
		)

GO
ALTER TABLE [sma_TRN_InsuranceCoverage] DISABLE TRIGGER ALL
INSERT INTO [sma_TRN_InsuranceCoverage]
	(
	[incnCaseID]
   ,[incnInsContactID]
   ,[incnInsAddressID]
   ,[incbCarrierHasLienYN]
   ,[incnInsType]
   ,[incnAdjContactId]
   ,[incnAdjAddressID]
   ,[incsPolicyNo]
   ,[incsClaimNo]
   ,[incnStackedTimes]
   ,[incsComments]
   ,[incnInsured]
   ,[incnCovgAmt]
   ,[incnDeductible]
   ,[incnUnInsPolicyLimit]
   ,[incnUnderPolicyLimit]
   ,[incbPolicyTerm]
   ,[incbTotCovg]
   ,[incsPlaintiffOrDef]
   ,[incnPlaintiffIDOrDefendantID]
   ,[incnTPAdminOrgID]
   ,[incnTPAdminAddID]
   ,[incnTPAdjContactID]
   ,[incnTPAdjAddID]
   ,[incsTPAClaimNo]
   ,[incnRecUserID]
   ,[incdDtCreated]
   ,[incnModifyUserID]
   ,[incdDtModified]
   ,[incnLevelNo]
   ,[incnUnInsPolicyLimitAcc]
   ,[incnUnderPolicyLimitAcc]
   ,[incb100Per]
   ,[incnMVLeased]
   ,[incnPriority]
   ,[incbDelete]
   ,[incnauthtodefcoun]
   ,[incnauthtodefcounDt]
   ,incbPrimary
	)

	SELECT DISTINCT
		casnCaseID
	   ,insco.connContactID
	   ,ad1.addnAddressID
	   ,''
	   ,intnInsuranceTypeID
	   ,CASE
			WHEN i1.cinnContactID IS NULL
				THEN o1.connContactID
			ELSE i1.cinnContactID
		END
	   ,CASE
			WHEN ad2.addnAddressID IS NULL
				THEN ad3.addnAddressID
			ELSE ad2.addnAddressID
		END
	   ,i.POLICYNUMBER
	   ,i.CLAIMNUMBER
	   ,''
	   ,ISNULL('POLICYSTARTED: ' + CONVERT(VARCHAR(20), POLICYSTARTED, 101) + CHAR(13), '') + ISNULL('Expires: ' + CONVERT(VARCHAR(20), EXPIRES, 101) + CHAR(13), '') + CONVERT(VARCHAR(4000), LTRIM(REPLACE(
		dbo.RegExReplace(notes, '({\\)(.+?)(})|(\\)(.+?)(\b)', '')
		, '}', '')

		))
	   ,CASE
			WHEN ad4.addnAddressID IS NOT NULL
				THEN ad4.addnAddressID
			WHEN ad5.addnAddressID IS NOT NULL
				THEN ad5.addnAddressID
		END
	   ,'0.00'
	   ,'0.00'
	   ,ISNULL(i.LIMITLOW, '0.00')
	   ,'0.00'
	   ,1
	   ,0
	   ,CASE
			WHEN p1.plnnPlaintiffID IS NOT NULL
				THEN 'P'
			WHEN p2.plnnPlaintiffID IS NOT NULL
				THEN 'P'
			WHEN d1.defnDefendentID IS NOT NULL
				THEN 'D'
			WHEN d2.defnDefendentID IS NOT NULL
				THEN 'D'
		END
	   ,CASE
			WHEN p1.plnnPlaintiffID IS NOT NULL
				THEN p1.plnnPlaintiffID
			WHEN p2.plnnPlaintiffID IS NOT NULL
				THEN p2.plnnPlaintiffID
			WHEN d1.defnDefendentID IS NOT NULL
				THEN d1.defnDefendentID
			WHEN d2.defnDefendentID IS NOT NULL
				THEN d2.defnDefendentID
		END
	   ,0
	   ,0
	   ,0
	   ,0
	   ,''
	   ,368
	   ,GETDATE()
	   ,''
	   ,''
	   ,''
	   ,ISNULL(i.LIMITHIGH, '0.00')
	   ,'0.00'
	   ,0
	   ,0
	   ,1
	   ,0
	   ,''
	   ,NULL
	   ,0
	FROM [WilliamPagerSaga].dbo.lw_ins i
	LEFT JOIN WilliamPagerSaga.dbo.ASSIGN a
		ON a.ASSIGNID = i.ADJUSTERASSIGNID
	LEFT JOIN [WilliamPagerSaga].dbo.matrelt mat
		ON mat.matreltid = i.matreltid
	LEFT JOIN [WilliamPagerSaga].dbo.ASSIGN asg
		ON asg.ASSIGNID = mat.ASSIGNID
	LEFT JOIN [WilliamPagerSaga].dbo.ASSIGN ainscomp
		ON mat.RELATEDASSIGNID = ainscomp.assignID
	LEFT JOIN [WilliamPagerSaga].dbo.assign aparty
		ON i.INSUREDASSIGNID = aparty.assignid
	LEFT JOIN [WilliamPagerSaga].dbo.assign adjuster
		ON i.ADJUSTERASSIGNID = adjuster.assignid
	LEFT JOIN [WilliamPagerSaga].dbo.lw_a_coveragetype icoverage
		ON icoverage.coveragetypeid = i.coveragetypeid
	LEFT JOIN [WilliamPagerSaga].dbo.ASSIGN ains
		ON i.insuredassignid = ains.assignid
	LEFT JOIN [WilliamPagerSaga].dbo.matter matter
		ON matter.MATTERID = asg.MATTERID
	LEFT JOIN [WilliamPagerSaga].dbo.entities einscompany
		ON ainscomp.entityid = einscompany.entityid
	LEFT JOIN [WilliamPagerSaga].dbo.entities einsadjuster
		ON adjuster.ASSIGNID = einsadjuster.entityid
	LEFT JOIN [WilliamPagerSaga].dbo.entities eparty
		ON asg.ENTITYID = eparty.entityid
	LEFT JOIN sma_TRN_CaseS
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_OrgContacts insco
		ON insco.connLevelNo = einscompany.ENTITYID
	LEFT JOIN WilliamPagerSaga.dbo.ENTITIES e
		ON e.ENTITYID = a.ENTITYID
	LEFT JOIN sma_MST_IndvContacts i1
		ON i1.cinsGrade = a.ENTITYID
	LEFT JOIN sma_MST_OrgContacts o1
		ON o1.connLevelNo = a.ENTITYID
	LEFT JOIN sma_MST_IndvContacts i5
		ON i5.cinsGrade = aparty.ENTITYID
	LEFT JOIN sma_MST_OrgContacts o5
		ON o5.connLevelNo = aparty.ENTITYID
	OUTER APPLY (
		SELECT TOP 1
			addnAddressID
		FROM sma_MST_Address
		WHERE addnContactID = o1.connContactID
			AND addbPrimary = 1
			AND addnContactCtgID = 2
	) ad3
	LEFT JOIN sma_mst_orgcontacts o2
		ON o2.connLevelNo = eparty.ENTITYID
	LEFT JOIN sma_MST_IndvContacts i2
		ON i2.cinsGrade = eparty.ENTITYID
	LEFT JOIN sma_TRN_Defendants d1
		ON d1.defnContactID = o2.connContactID
			AND d1.defnContactCtgID = 2
			AND d1.defnCaseID = casncaseid
	LEFT JOIN sma_TRN_Defendants d2
		ON d2.defnContactID = i2.cinnContactID
			AND d2.defnContactCtgID = 1
			AND d2.defnCaseID = casncaseid
	LEFT JOIN sma_TRN_Plaintiff p1
		ON p1.plnnContactID = o2.connContactID
			AND p1.plnnContactCtg = 2
			AND p1.plnnCaseID = casncaseid
	LEFT JOIN sma_TRN_Plaintiff p2
		ON p2.plnnContactID = i2.cinnContactID
			AND p2.plnnContactCtg = 1
			AND p2.plnnCaseID = casncaseid
	OUTER APPLY (
		SELECT TOP 1
			addnAddressID
		FROM sma_MST_Address
		WHERE addnContactID = insco.connContactID
			AND addbPrimary = 1
			AND addnContactCtgID = 2
	) ad1
	OUTER APPLY (
		SELECT TOP 1
			addnAddressID
		FROM sma_MST_Address
		WHERE addnContactID = i1.cinnContactID
			AND addbPrimary = 1
			AND addnContactCtgID = 1
	) ad2
	OUTER APPLY (
		SELECT TOP 1
			addnAddressID
		FROM sma_MST_Address
		WHERE addnContactID = i5.cinnContactID
			AND addbPrimary = 1
			AND addnContactCtgID = 1
	) ad4
	OUTER APPLY (
		SELECT TOP 1
			addnAddressID
		FROM sma_MST_Address
		WHERE addnContactID = o5.connContactID
			AND addbPrimary = 1
			AND addnContactCtgID = 2
	) ad5
	LEFT JOIN [sma_MST_InsuranceType]
		ON intsDscrptn = icoverage.DESCRIPTION
	LEFT JOIN WilliamPagerSaga.dbo.NOTE n
		ON n.NOTEID = mat.NOTEID
	WHERE casnCaseID IS NOT NULL
GO
UPDATE a
SET incsPlaintiffOrDef = 'P'
   ,incnPlaintiffIDOrDefendantID = plnnPlaintiffID
FROM sma_TRN_InsuranceCoverage a
LEFT JOIN sma_TRN_Plaintiff
	ON plnnCaseID = incnCaseID
	AND plnbIsPrimary = 1
WHERE incsPlaintiffOrDef IS NULL
ALTER TABLE [sma_TRN_InsuranceCoverage] ENABLE TRIGGER ALL
GO

ALTER TABLE sma_TRN_InsuranceCoverage DISABLE TRIGGER ALL
DELETE FROM sma_TRN_InsuranceCoverage
WHERE incnInsCovgID NOT IN (
		SELECT
			MIN(incnInsCovgID)
		FROM sma_TRN_InsuranceCoverage
		WHERE incnAdjContactId IS NULL
			AND incnAdjAddressID IS NULL
			AND incsPolicyNo IS NULL
		GROUP BY incnCaseID
				,incnInsContactID
				,incnInsType
				,incnInsAddressID
				,incsPlaintiffOrDef
				,incnPlaintiffIDOrDefendantID
				,incnInsured
	)
	AND incnAdjContactId IS NULL
	AND incnAdjAddressID IS NULL
	AND incsPolicyNo IS NULL
ALTER TABLE sma_TRN_InsuranceCoverage ENABLE TRIGGER ALL

ALTER TABLE sma_TRN_InsuranceCoverage DISABLE TRIGGER ALL
DELETE FROM sma_TRN_InsuranceCoverage
WHERE incnInsCovgID NOT IN (
		SELECT
			MIN(incnInsCovgID)
		FROM sma_TRN_InsuranceCoverage
		WHERE incnAdjContactId IS NOT NULL
			AND incnAdjAddressID IS NOT NULL
			AND incsPolicyNo IS NULL
		GROUP BY incnCaseID
				,incnInsContactID
				,incnInsType
				,incnInsAddressID
				,incsPlaintiffOrDef
				,incnPlaintiffIDOrDefendantID
				,incnInsured
				,incnAdjContactId
				,incnAdjAddressID
	)
	AND incnAdjContactId IS NOT NULL
	AND incnAdjAddressID IS NOT NULL
	AND incsPolicyNo IS NULL
ALTER TABLE sma_TRN_InsuranceCoverage ENABLE TRIGGER ALL


ALTER TABLE sma_TRN_InsuranceCoverage DISABLE TRIGGER ALL
DELETE FROM sma_TRN_InsuranceCoverage
WHERE incnInsCovgID NOT IN (
		SELECT
			MIN(incnInsCovgID)
		FROM sma_TRN_InsuranceCoverage
		WHERE incnAdjContactId IS NULL
			AND incnAdjAddressID IS NULL
			AND incsPolicyNo IS NOT NULL
		GROUP BY incnCaseID
				,incnInsContactID
				,incnInsType
				,incnInsAddressID
				,incsPlaintiffOrDef
				,incnPlaintiffIDOrDefendantID
				,incnInsured
				,incsPolicyNo
	)
	AND incnAdjContactId IS NULL
	AND incnAdjAddressID IS NULL
	AND incsPolicyNo IS NOT NULL
ALTER TABLE sma_TRN_InsuranceCoverage ENABLE TRIGGER ALL
