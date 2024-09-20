USE WilliamPagerSA

ALTER TABLE [sma_MST_AttorneyTypes]
ALTER COLUMN atnsAtorneyDscrptn VARCHAR(500) NULL

ALTER TABLE sma_trn_lawfirms DISABLE TRIGGER ALL

INSERT INTO [sma_MST_AttorneyTypes]
	(
	[atnsAtorneyCode]
   ,[atnsAtorneyDscrptn]
   ,[atnnRecUserID]
   ,[atndDtCreated]
   ,[atnnModifyUserID]
   ,[atndDtModified]
   ,[atnnLevelNo]
	)
	SELECT
		''
	   ,DESCRIPTION
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,NULL
	FROM [WilliamPagerSaga].dbo.EROLE
	WHERE DESCRIPTION LIKE '%attorney%'
		AND DESCRIPTION NOT LIKE 'primary%'
		AND DESCRIPTION NOT LIKE 'secondary%'
		AND DESCRIPTION NOT LIKE 'managing%'

GO
INSERT INTO [sma_TRN_LawFirms]
	(
	[lwfnLawFirmContactID]
   ,[lwfnLawFirmAddressID]
   ,[lwfnAttorneyContactID]
   ,[lwfnAttorneyAddressID]
   ,[lwfnAttorneyTypeID]
   ,[lwfsFileNumber]
   ,[lwfnRoleType]
   ,[lwfnContactID]
   ,[lwfnRecUserID]
   ,[lwfdDtCreated]
   ,[lwfnModifyUserID]
   ,[lwfdDtModified]
   ,[lwfnLevelNo]
   ,[lwfnAdjusterID]
	)
	SELECT DISTINCT
		o1.connContactID
	   ,ad1.addnAddressID
	   ,attorney.cinnContactID
	   ,ad2.addnAddressID
	   ,atnnAtorneyTypeID
	   ,SUBSTRING(f.FILENUMBER, 0, 30)
	   ,2
	   ,CASE
			WHEN d1.defnDefendentID IS NOT NULL
				THEN d1.defnDefendentID
			WHEN d2.defnDefendentID IS NOT NULL
				THEN d2.defnDefendentID
		END
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	FROM WilliamPagerSaga.dbo.LW_FIRM f
	LEFT JOIN WilliamPagerSaga.dbo.matrelt mat
		ON f.MATRELTID = mat.MATRELTID
	LEFT JOIN WilliamPagerSaga.dbo.assign aatty
		ON f.ATTORNEYASSIGNID = aatty.ASSIGNID
	LEFT JOIN WilliamPagerSaga.dbo.entities eatty
		ON aatty.entityid = eatty.entityid
	LEFT JOIN sma_MST_IndvContacts attorney
		ON attorney.cinsGrade = eatty.ENTITYID
	LEFT JOIN WilliamPagerSaga.dbo.assign acomp
		ON acomp.assignid = mat.RELATEDASSIGNID
	LEFT JOIN WilliamPagerSaga.dbo.matter m
		ON acomp.matterid = m.matterid
	LEFT JOIN WilliamPagerSaga.dbo.entities ecomp
		ON acomp.entityid = ecomp.entityid
	LEFT JOIN WilliamPagerSaga.dbo.erole r
		ON r.roleid = aatty.roleid
	LEFT JOIN WilliamPagerSaga.dbo.assign aparty
		ON aparty.assignid = mat.ASSIGNID
			AND aparty.partytype = 2
	LEFT JOIN WilliamPagerSaga.dbo.entities eparty
		ON eparty.entityid = aparty.entityid
	LEFT JOIN WilliamPagerSaga.dbo.ADDRESS ad
		ON ad.ADDRESSID = ecomp.PRIMARYADDR
	LEFT JOIN sma_MST_AttorneyTypes
		ON r.DESCRIPTION = atnsAtorneyDscrptn
	LEFT JOIN sma_TRN_CaseS
		ON cassCaseNumber = m.MATTERNUMBER
	LEFT JOIN sma_MST_IndvContacts i1
		ON i1.cinsGrade = acomp.ENTITYID
	LEFT JOIN sma_mst_orgcontacts o1
		ON o1.connLevelNo = acomp.ENTITYID
	LEFT JOIN sma_MST_IndvContacts i2
		ON i2.cinsGrade = aparty.ENTITYID
	LEFT JOIN sma_mst_orgcontacts o2
		ON o2.connLevelNo = aparty.ENTITYID
	LEFT JOIN sma_TRN_Defendants d1
		ON d1.defnContactCtgID = 1
			AND d1.defnContactID = i2.cinnContactID
			AND d1.defnCaseID = casnCaseID
	LEFT JOIN sma_TRN_Defendants d2
		ON d2.defnContactCtgID = 2
			AND d2.defnContactID = o2.connContactID
			AND d2.defnCaseID = casnCaseID
	LEFT JOIN sma_MST_Address ad1
		ON ad1.addnContactID = o1.connContactID
			AND ad1.addbPrimary = 1
			AND ad1.addsCity = ad.ADDRCITY
			AND ad1.addsAddress1 = ad.ADDRLINE1
			AND ad1.addnContactCtgID = 2
	LEFT JOIN sma_MST_Address ad2
		ON ad2.addnContactID = attorney.cinnContactID
			AND ad2.addbPrimary = 1
			AND ad2.addnContactCtgID = 1
	--Outer apply(Select top 1 addnAddressID from sma_MST_Address where addnContactID=connContactID and addnContactCtgID=2 and addbPrimary=1 ) ad1
	--Outer apply(Select top 1 addnAddressID from sma_MST_Address where addnContactID=connContactID and addnContactCtgID=2 and addbPrimary=1) ad2
	WHERE casnCaseID IS NOT NULL --and connContactID is not null--and aparty.ROLEID in (Select ROLEID from   [WilliamPagerSaga].dbo.EROLE where DESCRIPTION like '%defe%') and LawFrimContactID is not null
		AND (attorney.cinnContactID IS NOT NULL
		OR o1.connContactID IS NOT NULL)
GO
--drop table #lwfrmEntity

INSERT INTO [sma_TRN_PlaintiffAttorney]
	(
	[planPlaintffID]
   ,[planCaseID]
   ,[planPlCtgID]
   ,[planPlContactID]
   ,[planLawfrmAddID]
   ,[planLawfrmContactID]
   ,[planAtorneyAddID]
   ,[planAtorneyContactID]
   ,[planAtnTypeID]
   ,[plasFileNo]
   ,[planRecUserID]
   ,[pladDtCreated]
   ,[planModifyUserID]
   ,[pladDtModified]
   ,[planLevelNo]
   ,[planRefOutID]
	)
	SELECT
		plnnPlaintiffID
	   ,plnnCaseID
	   ,plnnContactCtg
	   ,plnnContactID
	   ,ad1.addnAddressID
	   ,LawFrimContactID
	   ,NULL
	   ,NULL
	   ,atnnAtorneyTypeID
	   ,lw.FILENUMBER
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	FROM [WilliamPagerSaga].dbo.lw_firm lw
	LEFT JOIN [WilliamPagerSaga].dbo.matrelt ml
		ON ml.MATRELTID = lw.MATRELTID
	LEFT JOIN [WilliamPagerSaga].dbo.ASSIGN afirm
		ON ml.relatedASSIGNID = afirm.ASSIGNID
	LEFT JOIN [WilliamPagerSaga].dbo.MATTER m
		ON afirm.matterid = m.matterid
	LEFT JOIN [WilliamPagerSaga].dbo.EROLE r
		ON r.ROLEID = afirm.ROLEID
	LEFT JOIN [WilliamPagerSaga].dbo.assign aparty
		ON ml.assignid = aparty.assignid
	LEFT JOIN sma_MST_AttorneyTypes
		ON r.DESCRIPTION = atnsAtorneyDscrptn
	LEFT JOIN sma_TRN_CaseS
		ON cassCaseNumber = m.FILENUMBER
	OUTER APPLY (
		SELECT TOP 1
			CASE
				WHEN cinnContactCtg IS NOT NULL
					THEN 1
				WHEN connContactCtg IS NOT NULL
					THEN 2
			END AS ContactCtg
		   ,CASE
				WHEN cinnContactID IS NOT NULL
					THEN cinnContactID
				WHEN connContactID IS NOT NULL
					THEN connContactID
			END AS ContactID
		FROM [WilliamPagerSaga].dbo.entities en
		LEFT JOIN sma_MST_IndvContacts l
			ON l.cinsGrade = en.ENTITYID
		LEFT JOIN sma_MST_OrgContacts k
			ON k.connLevelNo = en.ENTITYID
		WHERE en.entityid = aparty.entityid
	) Party
	LEFT JOIN sma_TRN_Plaintiff
		ON plnnCaseID = casnCaseID
			AND plnnContactID = ContactID
			AND plnnContactCtg = ContactCtg
	OUTER APPLY (
		SELECT TOP 1
			CASE
				WHEN connContactID IS NOT NULL
					THEN connContactID
			END AS LawFrimContactID
		FROM [WilliamPagerSaga].dbo.entities efirm
		LEFT JOIN sma_MST_OrgContacts k
			ON k.connLevelNo = efirm.ENTITYID
		WHERE afirm.ENTITYID = efirm.ENTITYID
	) efrim
	OUTER APPLY (
		SELECT TOP 1
			addnAddressID
		FROM sma_MST_Address
		WHERE addnContactID = LawFrimContactID
			AND addbPrimary = 1
			AND addnContactCtgID = 2
	) ad1
	WHERE plnnCaseID IS NOT NULL
		AND aparty.ROLEID IN (
			SELECT
				ROLEID
			FROM [WilliamPagerSaga].dbo.EROLE
			WHERE DESCRIPTION LIKE '%plain%'
		)

ALTER TABLE sma_trn_lawfirms ENABLE TRIGGER ALL
GO