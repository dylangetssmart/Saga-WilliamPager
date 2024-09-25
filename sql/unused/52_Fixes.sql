USE WilliamPagerSA

GO
ALTER TABLE sma_TRN_Plaintiff DISABLE TRIGGER ALL
DELETE FROM sma_TRN_Plaintiff
WHERE plnnPlaintiffID NOT IN (
		SELECT
			MIN(plnnPlaintiffID)
		FROM sma_TRN_Plaintiff
		GROUP BY plnnCaseID
				,plnnContactID
				,plnnContactCtg
	)
ALTER TABLE sma_TRN_Plaintiff ENABLE TRIGGER ALL
GO

INSERT INTO [sma_MST_OriginalContactTypes]
	(
	[octsCode]
   ,[octnContactCtgID]
   ,[octsDscrptn]
   ,[octnRecUserID]
   ,[octdDtCreated]
   ,[octnModifyUserID]
   ,[octdDtModified]
   ,[octnLevelNo]
	)
	SELECT DISTINCT
		UPPER(SUBSTRING(et.DESCRIPTION, 0, 5))
	   ,1
	   ,DESCRIPTION
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM [WilliamPagerSaga].[dbo].[ENTITIES] e
	LEFT JOIN [WilliamPagerSaga].[dbo].enttype et
		ON e.ENTITYTYPEID = et.ENTITYTYPEID
	WHERE ISPERSON = 't'
		AND FIRST_DBA IS NOT NULL
		AND et.DESCRIPTION NOT IN (
			SELECT
				[octsDscrptn]
			FROM [sma_MST_OriginalContactTypes]
			WHERE [octnContactCtgID] = 1
		)
GO
ALTER TABLE [sma_TRN_Notes] DISABLE TRIGGER ALL
--Truncate table sma_trn_notes
INSERT INTO [sma_TRN_Notes]
	(
	[notnCaseID]
   ,[notnNoteTypeID]
   ,[notmDescription]
   ,[notmPlainText]
   ,[notnContactCtgID]
   ,[notnContactId]
   ,[notsPriority]
   ,[notnFormID]
   ,[notnRecUserID]
   ,[notdDtCreated]
   ,[notnModifyUserID]
   ,[notdDtModified]
   ,[notnLevelNo]
   ,[notdDtInserted]
   ,notnSubject
	)
	SELECT
		Caseid
	   ,nttnNoteTypeID
	   ,comments
	   ,ISNULL(comments, '')
	   ,NULL
	   ,NULL
	   ,'Normal'
	   ,NULL
	   ,RecUserID
	   ,DtCreated
	   ,NULL
	   ,NULL
	   ,0
	   ,DtCreated
	   ,NULL
	FROM sma_TRN_Incidents
	CROSS JOIN sma_MST_NoteTypes
	WHERE ISNULL(comments, '') <> ''
		AND nttsDscrptn = 'General & Miscellaneous Notes'
ALTER TABLE [sma_TRN_Notes] ENABLE TRIGGER ALL

GO

ALTER TABLE sma_TRN_Incidents DISABLE TRIGGER ALL
--Truncate table sma_trn_notes
UPDATE sma_TRN_Incidents
SET Comments = ''
ALTER TABLE sma_TRN_Incidents ENABLE TRIGGER ALL
GO
INSERT INTO sma_mst_SubRoleCode
	SELECT DISTINCT
		csssComments
	   ,10
	FROM sma_TRN_CaseStaff
	WHERE ISNULL(csssComments, '') <> ''
		AND NOT EXISTS (
			SELECT
				*
			FROM sma_mst_SubRoleCode
			WHERE srcnRoleID = 10
				AND srcsDscrptn = csssComments
		)
GO
INSERT INTO sma_MST_SubRole
	SELECT DISTINCT
		''
	   ,10
	   ,srcsDscrptn
	   ,0
	   ,0
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,0
	   ,NULL
	   ,NULL
	   ,srcnCodeId
	FROM sma_mst_SubRoleCode
	WHERE srcnRoleID = 10
		AND NOT EXISTS (
			SELECT
				*
			FROM sma_MST_SubRole
			WHERE sbrnRoleID = 10
				AND sbrnTypeCode = srcnCodeId
		)
GO
UPDATE sma_MST_SOLDetails
SET sldnSOLTypeID = 14
WHERE sldnSOLTypeID = 3
GO
UPDATE sma_MST_SOLDetails
SET sldnFromIncident = 0
WHERE sldnFromIncident IS NULL
GO
ALTER TABLE sma_TRN_Negotiations DISABLE TRIGGER ALL
UPDATE sma_TRN_Negotiations
SET negsComments = REPLACE(negsComments, 'Default Entity Note Description', '')

ALTER TABLE sma_TRN_Negotiations ENABLE TRIGGER ALL
GO
UPDATE sma_MST_AdminParameters
SET adpsKeyValue = '1000'
WHERE adpsKeyGroup = 'CaseDisbursement'
AND adpsKeyName = 'DefaultDisbursementLimit'
AND ISNULL(adpsKeyValue, '') = ''
GO

ALTER TABLE sma_TRN_Incidents DISABLE TRIGGER ALL

UPDATE i
SET IncidentFacts = LTRIM(REPLACE(
dbo.RegExReplace(notes, '({\\)(.+?)(})|(\\)(.+?)(\b)', '')
, '}', '')
)
FROM sma_TRN_Incidents i
JOIN sma_trn_cases
	ON casnCaseID = CaseId
JOIN [WilliamPagerSaga].[dbo].[Matter] b
	ON b.MATTERNUMBER = cassCaseNumber
JOIN [WilliamPagerSaga].[dbo].[LW_MATTER] a
	ON a.MATTERID = b.MATTERID
JOIN [WilliamPagerSaga].[dbo].[NOTE] e
	ON e.NOTEID = a.FACTSUMMARYNOTEID
WHERE ISNULL(IncidentFacts, '') = ''

ALTER TABLE sma_TRN_Incidents ENABLE TRIGGER ALL
GO
INSERT INTO sma_TRN_PlaintiffInjury
	SELECT
		injnPlaintiffId
	   ,injnCaseId
	   ,injnOtherInj
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,injnRecUserID
	   ,ISNULL(injdDtCreated, GETDATE())
	   ,NULL
	   ,NULL
	FROM sma_TRN_Injury
	WHERE NOT EXISTS (
			SELECT
				*
			FROM sma_TRN_PlaintiffInjury
			WHERE plinPlaintiffID = injnPlaintiffId
				AND injnCaseId = plinCaseID
		)
GO
UPDATE p
SET plisInjuriesSummary = injnOtherInj
FROM sma_TRN_Injury
JOIN sma_TRN_PlaintiffInjury p
	ON injnCaseId = plinCaseID
	AND injnPlaintiffId = plinPlaintiffID
WHERE ISNULL(CAST(plisInjuriesSummary AS NVARCHAR(MAX)), '') = ''
AND ISNULL(injnOtherInj, '') <> ''
GO
UPDATE sma_TRN_Injury
SET injnOtherInj = injsDescription
   ,injsDescription = ''
GO
UPDATE sma_TRN_PlaintiffInjury
SET plisPleadingsSummary = plisInjuriesSummary
GO
UPDATE p
SET plisInjuriesSummary = injnOtherInj
FROM sma_TRN_Injury
JOIN sma_TRN_PlaintiffInjury p
	ON injnCaseId = plinCaseID
	AND injnPlaintiffId = plinPlaintiffID
GO

INSERT INTO sma_MST_MedicalProvideSpeciality
	SELECT DISTINCT
		DESCRIPTION
	   ,GETDATE()
	   ,368
	   ,NULL
	   ,NULL
	FROM [WilliamPagerSaga].[dbo].[LW_A_SPECIALTY]
	WHERE NOT EXISTS (
			SELECT
				*
			FROM sma_MST_MedicalProvideSpeciality
			WHERE spDescription = DESCRIPTION
		)
		AND ISNULL(DESCRIPTION, '') <> ''
GO
INSERT INTO sma_MST_MedicalProvideSubSpeciality
	SELECT DISTINCT
		sub.DESCRIPTION
	   ,GETDATE()
	   ,368
	   ,NULL
	   ,NULL
	   ,splid
	FROM [WilliamPagerSaga].dbo.LW_MEDICAL med
	JOIN [WilliamPagerSaga].[dbo].[LW_A_SUBSPECIALTY] sub
		ON med.SUBSPECIALTYID = sub.SUBSPECIALTYID
	LEFT JOIN [WilliamPagerSaga].[dbo].[LW_A_SPECIALTY] spe
		ON spe.SPECIALTYID = med.SPECIALTYID
	OUTER APPLY (
		SELECT TOP 1
			*
		FROM sma_MST_MedicalProvideSpeciality
		WHERE spDescription = spe.DESCRIPTION
	) z
	WHERE ISNULL(sub.DESCRIPTION, '') <> ''
		AND NOT EXISTS (
			SELECT
				*
			FROM sma_MST_MedicalProvideSubSpeciality
			WHERE sub.DESCRIPTION = subspDescription
				AND spid = splID
		)
GO

INSERT INTO sma_TRN_MedicalProviderSpecialitySubSpeciality
	SELECT DISTINCT
		splid
	   ,subsplID
	   ,cinnContactID
	   ,1
	   ,GETDATE()
	   ,368
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
	JOIN sma_MST_IndvContacts l
		ON l.cinsGrade = eprov.ENTITYID
	LEFT JOIN [WilliamPagerSaga].[dbo].[LW_A_SPECIALTY] m1
		ON m1.SPECIALTYID = med.SPECIALTYID
	OUTER APPLY (
		SELECT TOP 1
			*
		FROM sma_MST_MedicalProvideSpeciality
		WHERE spDescription = m1.DESCRIPTION
	) z
	LEFT JOIN [WilliamPagerSaga].[dbo].[LW_A_SUBSPECIALTY] sub
		ON med.SUBSPECIALTYID = sub.SUBSPECIALTYID
	LEFT JOIN sma_MST_MedicalProvideSubSpeciality
		ON sub.DESCRIPTION = subspDescription
			AND spid = splID
	--LEFT JOIN sma_MST_OrgContacts k on k.connLevelNo=eprov.ENTITYID
	WHERE med.SPECIALTYID IS NOT NULL
		AND NOT EXISTS (
			SELECT
				*
			FROM sma_TRN_MedicalProviderSpecialitySubSpeciality
			WHERE mdprvContactctgID = 1
				AND mdprvContactID = cinnContactID
		)
GO

INSERT INTO sma_TRN_MedicalProviderSpecialitySubSpeciality
	SELECT DISTINCT
		splid
	   ,subsplID
	   ,connContactID
	   ,2
	   ,GETDATE()
	   ,368
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
	JOIN sma_MST_OrgContacts k
		ON k.connLevelNo = eprov.ENTITYID
	LEFT JOIN [WilliamPagerSaga].[dbo].[LW_A_SPECIALTY] m1
		ON m1.SPECIALTYID = med.SPECIALTYID
	OUTER APPLY (
		SELECT TOP 1
			*
		FROM sma_MST_MedicalProvideSpeciality
		WHERE spDescription = m1.DESCRIPTION
	) z
	LEFT JOIN [WilliamPagerSaga].[dbo].[LW_A_SUBSPECIALTY] sub
		ON med.SUBSPECIALTYID = sub.SUBSPECIALTYID
	LEFT JOIN sma_MST_MedicalProvideSubSpeciality
		ON sub.DESCRIPTION = subspDescription
			AND spid = splID

	WHERE med.SPECIALTYID IS NOT NULL
		AND NOT EXISTS (
			SELECT
				*
			FROM sma_TRN_MedicalProviderSpecialitySubSpeciality
			WHERE mdprvContactctgID = 2
				AND mdprvContactID = connContactID
		)
GO
UPDATE sma_MST_CaseGroup
SET IncidentTypeID = 1
WHERE IncidentTypeID IS NULL
GO
UPDATE sma_TRN_LostWages
SET ltwsType = 11
WHERE ltwsType = 'Lost Wages'
GO
UPDATE sma_TRN_LostWages
SET ltwsType = 12
WHERE ltwsType = 'General'
GO
INSERT INTO [sma_TRN_UDFValues]
	(
	[udvnUDFID]
   ,[udvsScreenName]
   ,[udvsUDFCtg]
   ,[udvnRelatedID]
   ,[udvnSubRelatedID]
   ,[udvsUDFValue]
   ,[udvnRecUserID]
   ,[udvdDtCreated]
   ,[udvnModifyUserID]
   ,[udvdDtModified]
   ,[udvnLevelNo]
	)
	SELECT DISTINCT
		udfnUDFID
	   ,udfsScreenName
	   ,udfsUDFCtg
	   ,casnCaseID
	   ,''
	   ,CONVERT(VARCHAR(4000), LOCATIONSTREET)
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM WilliamPagerSaga.dbo.MATTER a
	LEFT JOIN WilliamPagerSaga.dbo.LW_MATTER b
		ON a.MATTERID = b.MATTERID
	LEFT JOIN sma_trn_cases
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_MST_CaseType
		ON cstnCaseTypeID = casnOrgCaseTypeID
	LEFT JOIN sma_MST_CaseGroup CG
		ON cstnGroupID = cgpnCaseGroupID
	LEFT JOIN [sma_MST_IncidentTypes]
		ON LTRIM(RTRIM('frmIncident')) = LTRIM(RTRIM([IncidentType]))
	LEFT JOIN sma_MST_UDFDefinition
		ON udfnRelatedPK = CG.IncidentTypeID
	WHERE udfsUDFName = 'location'
		AND ISNULL(LOCATIONSTREET, '') <> ''
		AND udfsUDFCtg = 'I'
		AND NOT EXISTS (
			SELECT
				*
			FROM sma_TRN_UDFValues
			WHERE udvnRelatedID = casnCaseID
				AND udvnUDFID = udfnUDFID
		)

