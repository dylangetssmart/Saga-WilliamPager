USE WilliamPagerSA

ALTER TABLE sma_mst_indvcontacts DISABLE TRIGGER ALL
GO


DECLARE @Name VARCHAR(1000)
DECLARE @SQL VARCHAR(2000)

-- Declare a cursor that will get staff contactid


--DECLARE trnasactiontable_Cursor CURSOR FAST_FORWARD FOR SELECT DISTINCT
--	name
--FROM sys.objects
--WHERE type = 'u'
--	AND name LIKE '%trn_%'
--	AND name NOT LIKE 'sma_trn_cases'
--	AND name NOT LIKE 'sma_TRN_CourtDocket'
--	AND name NOT LIKE 'sma_TRN_Plaintiff'
--	AND name NOT LIKE 'sma_TRN_CaseStagesStatus'
----Open a cursor
--OPEN trnasactiontable_Cursor

--FETCH NEXT FROM trnasactiontable_Cursor INTO @Name

--WHILE @@FETCH_STATUS = 0
--BEGIN

--SELECT
--	@SQL = 'truncate table ' + @Name + ''
--EXEC (@SQL)

--FETCH NEXT FROM trnasactiontable_Cursor INTO @Name
--END

--CLOSE trnasactiontable_Cursor
--DEALLOCATE trnasactiontable_Cursor


--DECLARE @Name1 VARCHAR(1000)
--DECLARE @SQL1 VARCHAR(2000)

---- Declare a cursor that will get staff contactid


--DECLARE Contacttable_Cursor CURSOR FAST_FORWARD FOR SELECT DISTINCT
--	name
--FROM sys.objects
--WHERE type = 'u'
--	AND name LIKE '%contact%'
--	AND name NOT LIKE '%contacttype%'
--	AND name NOT LIKE '%sma_mst_ContactDocumentType%'
--	AND name NOT LIKE '%sma_MST_IndvContacts%'
--	AND name NOT LIKE 'CategoryContactFilters'
--	AND name NOT LIKE '%sma_MST_orgContacts%'
--	AND name NOT LIKE '%sma_MST_ContactCtg%'
--	AND name NOT LIKE '%sma_MST_ContactNoType%'
----Open a cursor
--OPEN Contacttable_Cursor

--FETCH NEXT FROM Contacttable_Cursor INTO @Name1

--WHILE @@FETCH_STATUS = 0
--BEGIN

--SELECT
--	@SQL1 = 'truncate table ' + @Name1 + ''
--EXEC (@SQL1)

--FETCH NEXT FROM Contacttable_Cursor INTO @Name1
--END

--CLOSE Contacttable_Cursor
--DEALLOCATE Contacttable_Cursor

--TRUNCATE TABLE sma_mst_contactnumbers
--TRUNCATE TABLE sma_mst_address
--TRUNCATE TABLE sma_mst_emailwebsite


--select t.name as TableWithForeignKey, fk.constraint_column_id as FK_PartNo , c.name as ForeignKeyColumn 
--from sys.foreign_key_columns as fk
--inner join sys.tables as t on fk.parent_object_id = t.object_id
--inner join sys.columns as c on fk.parent_object_id = c.object_id and fk.parent_column_id = c.column_id
--where fk.referenced_object_id = (select object_id from sys.tables where name = 'sma_trn_cases')
--order by TableWithForeignKey, FK_PartNo

GO

IF EXISTS (
		SELECT
			*
		FROM sys.foreign_keys
		WHERE object_id = OBJECT_ID(N'[dbo].[FK_sma_MST_CaseTypeCoCounsel_sma_MST_IndvContacts]')
			AND parent_object_id = OBJECT_ID(N'[dbo].[sma_MST_CaseTypeCoCounsel]')
	)
	ALTER TABLE [dbo].[sma_MST_CaseTypeCoCounsel] DROP CONSTRAINT [FK_sma_MST_CaseTypeCoCounsel_sma_MST_IndvContacts]
GO
IF EXISTS (
		SELECT
			*
		FROM sys.foreign_keys
		WHERE object_id = OBJECT_ID(N'[dbo].[FK_sma_MST_CaseTypeCoCounsel_sma_MST_OrgContacts]')
			AND parent_object_id = OBJECT_ID(N'[dbo].[sma_MST_CaseTypeCoCounsel]')
	)
	ALTER TABLE [dbo].[sma_MST_CaseTypeCoCounsel] DROP CONSTRAINT [FK_sma_MST_CaseTypeCoCounsel_sma_MST_OrgContacts]
GO
IF EXISTS (
		SELECT
			*
		FROM sys.foreign_keys
		WHERE object_id = OBJECT_ID(N'[dbo].[FK_sma_MST_OtherCasesContact_sma_TRN_Cases]')
			AND parent_object_id = OBJECT_ID(N'[dbo].[sma_MST_OtherCasesContact]')
	)
	ALTER TABLE [dbo].[sma_MST_OtherCasesContact] DROP CONSTRAINT [FK_sma_MST_OtherCasesContact_sma_TRN_Cases]
GO


GO

IF EXISTS (
		SELECT
			*
		FROM sys.foreign_keys
		WHERE object_id = OBJECT_ID(N'[dbo].[FK_sma_trn_AgeolCallersInfo_sma_TRN_Cases]')
			AND parent_object_id = OBJECT_ID(N'[dbo].[sma_trn_AgeolCallersInfo]')
	)
	ALTER TABLE [dbo].[sma_trn_AgeolCallersInfo] DROP CONSTRAINT [FK_sma_trn_AgeolCallersInfo_sma_TRN_Cases]
GO


IF EXISTS (
		SELECT
			*
		FROM sys.foreign_keys
		WHERE object_id = OBJECT_ID(N'[dbo].[FK_sma_TRN_CaseContactComment_sma_TRN_Cases]')
			AND parent_object_id = OBJECT_ID(N'[dbo].[sma_TRN_CaseContactComment]')
	)
	ALTER TABLE [dbo].[sma_TRN_CaseContactComment] DROP CONSTRAINT [FK_sma_TRN_CaseContactComment_sma_TRN_Cases]
GO

IF EXISTS (
		SELECT
			*
		FROM sys.foreign_keys
		WHERE object_id = OBJECT_ID(N'[dbo].[FK_sma_TRN_SearchEngine_sma_TRN_Cases]')
			AND parent_object_id = OBJECT_ID(N'[dbo].[sma_TRN_SearchEngine]')
	)
	ALTER TABLE [dbo].[sma_TRN_SearchEngine] DROP CONSTRAINT [FK_sma_TRN_SearchEngine_sma_TRN_Cases]
GO

GO

IF EXISTS (
		SELECT
			*
		FROM sys.foreign_keys
		WHERE object_id = OBJECT_ID(N'[dbo].[FK_sma_trn_SSDAppealCounselnSma_trn_plaintiff]')
			AND parent_object_id = OBJECT_ID(N'[dbo].[sma_trn_SSDAppealCounsel]')
	)
	ALTER TABLE [dbo].[sma_trn_SSDAppealCounsel] DROP CONSTRAINT [FK_sma_trn_SSDAppealCounselnSma_trn_plaintiff]
GO
GO

IF EXISTS (
		SELECT
			*
		FROM sys.foreign_keys
		WHERE object_id = OBJECT_ID(N'[dbo].[FK_sma_trn_plaintiff]')
			AND parent_object_id = OBJECT_ID(N'[dbo].[sma_trn_SSDInitialApplication]')
	)
	ALTER TABLE [dbo].[sma_trn_SSDInitialApplication] DROP CONSTRAINT [FK_sma_trn_plaintiff]
GO
GO

IF EXISTS (
		SELECT
			*
		FROM sys.foreign_keys
		WHERE object_id = OBJECT_ID(N'[dbo].[FK_sma_trn_caseJudgeorClerk_sma_TRN_CourtDocket]')
			AND parent_object_id = OBJECT_ID(N'[dbo].[sma_trn_caseJudgeorClerk]')
	)
	ALTER TABLE [dbo].[sma_trn_caseJudgeorClerk] DROP CONSTRAINT [FK_sma_trn_caseJudgeorClerk_sma_TRN_CourtDocket]
GO
GO

IF EXISTS (
		SELECT
			*
		FROM sys.foreign_keys
		WHERE object_id = OBJECT_ID(N'[dbo].[FK_sma_TRN_MySmartAdvocateLayout_sma_MST_Users]')
			AND parent_object_id = OBJECT_ID(N'[dbo].[sma_TRN_MySmartAdvocateLayout]')
	)
	ALTER TABLE [dbo].[sma_TRN_MySmartAdvocateLayout] DROP CONSTRAINT [FK_sma_TRN_MySmartAdvocateLayout_sma_MST_Users]
GO
IF EXISTS (
		SELECT
			*
		FROM sys.foreign_keys
		WHERE object_id = OBJECT_ID(N'[dbo].[FK_sma_trn_ChangeStaffByStatus_sma_MST_IndvContacts]')
			AND parent_object_id = OBJECT_ID(N'[dbo].[sma_trn_ChangeStaffByStatus]')
	)
	ALTER TABLE [dbo].[sma_trn_ChangeStaffByStatus] DROP CONSTRAINT [FK_sma_trn_ChangeStaffByStatus_sma_MST_IndvContacts]
GO

IF EXISTS (
		SELECT
			*
		FROM sys.foreign_keys
		WHERE object_id = OBJECT_ID(N'[dbo].[FK_sma_TRN_ContactDocuments_sma_mst_ContactDocumentType]')
			AND parent_object_id = OBJECT_ID(N'[dbo].[sma_TRN_ContactDocuments]')
	)
	ALTER TABLE [dbo].[sma_TRN_ContactDocuments] DROP CONSTRAINT [FK_sma_TRN_ContactDocuments_sma_mst_ContactDocumentType]
GO

IF EXISTS (
		SELECT
			*
		FROM sys.foreign_keys
		WHERE object_id = OBJECT_ID(N'[dbo].[FK_WorkFlows_sma_MST_Users]')
			AND parent_object_id = OBJECT_ID(N'[dbo].[WorkFlows]')
	)
	ALTER TABLE [dbo].[WorkFlows] DROP CONSTRAINT [FK_WorkFlows_sma_MST_Users]
GO
-->truncate table sma_mst_indvcontacts<--chinmong implementation
--TRUNCATE TABLE sma_mst_orgcontacts
---->truncate table sma_mst_users<--chinmong comment implementation
--TRUNCATE TABLE sma_trn_cases
--TRUNCATE TABLE sma_trn_plaintiff
--TRUNCATE TABLE sma_mst_ContactDocumentType
--TRUNCATE TABLE sma_TRN_CourtDocket
--TRUNCATE TABLE sma_mst_contacttypesforcontact
--TRUNCATE TABLE sma_MST_AdvertisementCampaign
--TRUNCATE TABLE sma_MST_ReferOutRules
--TRUNCATE TABLE saemailsignature
GO



--ALTER TABLE [dbo].[sma_TRN_ContactDocuments] WITH CHECK ADD CONSTRAINT [FK_sma_TRN_ContactDocuments_sma_mst_ContactDocumentType] FOREIGN KEY ([cntctDocumentTypeID])
--REFERENCES [dbo].[sma_mst_ContactDocumentType] ([cntctDocTypeID])
--GO

--ALTER TABLE [dbo].[sma_TRN_ContactDocuments] CHECK CONSTRAINT [FK_sma_TRN_ContactDocuments_sma_mst_ContactDocumentType]
--GO

--ALTER TABLE [dbo].[sma_MST_OtherCasesContact] WITH CHECK ADD CONSTRAINT [FK_sma_MST_OtherCasesContact_sma_TRN_Cases] FOREIGN KEY ([OtherCasesID])
--REFERENCES [dbo].[sma_TRN_Cases] ([casnCaseID])
--GO

--ALTER TABLE [dbo].[sma_MST_OtherCasesContact] CHECK CONSTRAINT [FK_sma_MST_OtherCasesContact_sma_TRN_Cases]
--GO

--ALTER TABLE [dbo].[sma_TRN_CaseContactComment] WITH CHECK ADD CONSTRAINT [FK_sma_TRN_CaseContactComment_sma_TRN_Cases] FOREIGN KEY ([CaseContactCaseID])
--REFERENCES [dbo].[sma_TRN_Cases] ([casnCaseID])
--GO

--ALTER TABLE [dbo].[sma_TRN_CaseContactComment] CHECK CONSTRAINT [FK_sma_TRN_CaseContactComment_sma_TRN_Cases]
--GO


GO

--ALTER TABLE [dbo].[sma_trn_AgeolCallersInfo] WITH CHECK ADD CONSTRAINT [FK_sma_trn_AgeolCallersInfo_sma_TRN_Cases] FOREIGN KEY ([CaseID])
--REFERENCES [dbo].[sma_TRN_Cases] ([casnCaseID])
--GO

--ALTER TABLE [dbo].[sma_trn_AgeolCallersInfo] CHECK CONSTRAINT [FK_sma_trn_AgeolCallersInfo_sma_TRN_Cases]
--GO
--ALTER TABLE [dbo].[sma_TRN_SearchEngine] WITH CHECK ADD CONSTRAINT [FK_sma_TRN_SearchEngine_sma_TRN_Cases] FOREIGN KEY ([CaseID])
--REFERENCES [dbo].[sma_TRN_Cases] ([casnCaseID])
--GO

--ALTER TABLE [dbo].[sma_TRN_SearchEngine] CHECK CONSTRAINT [FK_sma_TRN_SearchEngine_sma_TRN_Cases]
--GO

--GO

--ALTER TABLE [dbo].[sma_trn_SSDAppealCounsel] WITH CHECK ADD CONSTRAINT [FK_sma_trn_SSDAppealCounselnSma_trn_plaintiff] FOREIGN KEY ([SSDAppealCounselPlaintiffID])
--REFERENCES [dbo].[sma_TRN_Plaintiff] ([plnnPlaintiffID])
--GO

--ALTER TABLE [dbo].[sma_trn_SSDAppealCounsel] CHECK CONSTRAINT [FK_sma_trn_SSDAppealCounselnSma_trn_plaintiff]
--GO


--GO

--ALTER TABLE [dbo].[sma_trn_SSDInitialApplication] WITH CHECK ADD CONSTRAINT [FK_sma_trn_plaintiff] FOREIGN KEY ([SSDPlaintifID])
--REFERENCES [dbo].[sma_TRN_Plaintiff] ([plnnPlaintiffID])
--GO

--ALTER TABLE [dbo].[sma_trn_SSDInitialApplication] CHECK CONSTRAINT [FK_sma_trn_plaintiff]
--GO

--GO

--ALTER TABLE [dbo].[sma_trn_caseJudgeorClerk] WITH CHECK ADD CONSTRAINT [FK_sma_trn_caseJudgeorClerk_sma_TRN_CourtDocket] FOREIGN KEY ([crtDocketID])
--REFERENCES [dbo].[sma_TRN_CourtDocket] ([crdnCourtDocketID])
--GO

--ALTER TABLE [dbo].[sma_trn_caseJudgeorClerk] CHECK CONSTRAINT [FK_sma_trn_caseJudgeorClerk_sma_TRN_CourtDocket]
--GO

--ALTER TABLE [dbo].[sma_MST_CaseTypeCoCounsel] WITH CHECK ADD CONSTRAINT [FK_sma_MST_CaseTypeCoCounsel_sma_MST_IndvContacts] FOREIGN KEY ([CoCounselAttorneyID])
--REFERENCES [dbo].[sma_MST_IndvContacts] ([cinnContactID])
--GO

--ALTER TABLE [dbo].[sma_MST_CaseTypeCoCounsel] CHECK CONSTRAINT [FK_sma_MST_CaseTypeCoCounsel_sma_MST_IndvContacts]
--GO

--ALTER TABLE [dbo].[WorkFlows]  WITH CHECK ADD  CONSTRAINT [FK_WorkFlows_sma_MST_Users] FOREIGN KEY([CreatorUserId])
--REFERENCES [dbo].[sma_MST_Users] ([usrnUserID])
--GO

--ALTER TABLE [dbo].[WorkFlows] CHECK CONSTRAINT [FK_WorkFlows_sma_MST_Users]
--GO
--ALTER TABLE [dbo].[sma_MST_CaseTypeCoCounsel]  WITH CHECK ADD  CONSTRAINT [FK_sma_MST_CaseTypeCoCounsel_sma_MST_OrgContacts] FOREIGN KEY([CoCounselLawfirmID])
--REFERENCES [dbo].[sma_MST_OrgContacts] ([connContactID])
--GO

--ALTER TABLE [dbo].[sma_MST_CaseTypeCoCounsel] CHECK CONSTRAINT [FK_sma_MST_CaseTypeCoCounsel_sma_MST_OrgContacts]
GO


ALTER TABLE [dbo].[sma_trn_ChangeStaffByStatus] WITH CHECK ADD CONSTRAINT [FK_sma_trn_ChangeStaffByStatus_sma_MST_IndvContacts] FOREIGN KEY ([chngStaffID])
REFERENCES [dbo].[sma_MST_IndvContacts] ([cinnContactID])
GO

ALTER TABLE [dbo].[sma_trn_ChangeStaffByStatus] CHECK CONSTRAINT [FK_sma_trn_ChangeStaffByStatus_sma_MST_IndvContacts]
GO
ALTER TABLE [dbo].[sma_TRN_MySmartAdvocateLayout] WITH CHECK ADD CONSTRAINT [FK_sma_TRN_MySmartAdvocateLayout_sma_MST_Users] FOREIGN KEY ([UserID])
REFERENCES [dbo].[sma_MST_Users] ([usrnUserID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[sma_TRN_MySmartAdvocateLayout] CHECK CONSTRAINT [FK_sma_TRN_MySmartAdvocateLayout_sma_MST_Users]
GO

DECLARE @LoginName VARCHAR(1000)
DECLARE @EntityID BIGINT

-- Declare a cursor that will get staff contactid


DECLARE indvCaseID_Cursor CURSOR FAST_FORWARD FOR SELECT DISTINCT
	CASE
		WHEN (LoginName) IS NOT NULL
			THEN (LoginName)
		WHEN (code) IS NULL
			THEN SUBSTRING(ISNULL((FIRST_DBA), ''), 0, 1) + (SUBSTRING(LAST_COMPANY, 0, 19))
		ELSE (CODE)
	END AS LoginName
   ,ENTITYID
FROM WilliamPagerSaga.dbo.ENTITIES e
WHERE CASE
		WHEN (LoginName) IS NOT NULL
			THEN (LoginName)
		WHEN (code) IS NULL
			THEN SUBSTRING(ISNULL((FIRST_DBA), ''), 0, 1) + (SUBSTRING(LAST_COMPANY, 0, 19))
		ELSE (CODE)
	END IN (
		SELECT
			LoginName
		FROM (
			SELECT DISTINCT
				CASE
					WHEN (LOGINNAME) IS NOT NULL
						THEN (LOGINNAME)
					WHEN (code) IS NULL
						THEN SUBSTRING(ISNULL((FIRST_DBA), ''), 0, 1) + (SUBSTRING(LAST_COMPANY, 0, 19))
					ELSE (CODE)
				END AS loginname
			   ,ENTITYID
			FROM [WilliamPagerSaga].[dbo].[ENTITIES] e
			LEFT JOIN [WilliamPagerSaga].[dbo].enttype et
				ON e.ENTITYTYPEID = et.ENTITYTYPEID
			WHERE e.ENTITYCATEGORY = 1
				OR et.DESCRIPTION LIKE '%staff%'
		--AND usertype = 1
		) a
		GROUP BY loginname
		HAVING COUNT(loginname) > 1
	)
	--and e.ENTITYCATEGORY=1 or et.DESCRIPTION like '%staff%' and usertype=1
	AND ENTITYID NOT IN (
		SELECT
			MIN(ENTITYID)
		FROM (
			SELECT DISTINCT
				CASE
					WHEN (LOGINNAME) IS NOT NULL
						THEN (LOGINNAME)
					WHEN (code) IS NULL
						THEN SUBSTRING(ISNULL((FIRST_DBA), ''), 0, 1) + (SUBSTRING(LAST_COMPANY, 0, 19))
					ELSE (CODE)
				END AS loginname
			   ,ENTITYID
			FROM [WilliamPagerSaga].[dbo].[ENTITIES] e
			LEFT JOIN [WilliamPagerSaga].[dbo].enttype et
				ON e.ENTITYTYPEID = et.ENTITYTYPEID
			WHERE e.ENTITYCATEGORY = 1
				OR et.DESCRIPTION LIKE '%staff%'
		--AND usertype = 1
		) a
		GROUP BY loginname
		HAVING COUNT(loginname) > 1
	)
--Open a cursor
OPEN indvCaseID_Cursor

FETCH NEXT FROM indvCaseID_Cursor INTO @LoginName, @EntityID

WHILE @@FETCH_STATUS = 0
BEGIN

UPDATE WilliamPagerSaga.dbo.ENTITIES
SET LOGINNAME = ISNULL(LOGINNAME, '') + CONVERT(VARCHAR(10), (
	SELECT
		10 + CONVERT(INT, (30 - 10 + 1) * RAND())
)
)
WHERE ENTITYID = @EntityID


FETCH NEXT FROM indvCaseID_Cursor INTO @LoginName, @EntityID
END

CLOSE indvCaseID_Cursor
DEALLOCATE indvCaseID_Cursor
GO
--SET IDENTITY_INSERT sma_mst_indvcontacts ON

--INSERT INTO [sma_MST_IndvContacts]
--(cinncontactid,[cinbPrimary],[cinnContactTypeID],[cinnContactSubCtgID],[cinsPrefix],[cinsFirstName],[cinsMiddleName],[cinsLastName],[cinsSuffix],[cinsNickName],[cinbStatus],[cinsSSNNo],[cindBirthDate],
--[cinsComments],[cinnContactCtg],[cinnRefByCtgID],[cinnReferredBy],[cindDateOfDeath],[cinsCVLink],[cinnMaritalStatusID],[cinnGender],[cinsBirthPlace],[cinnCountyID],[cinsCountyOfResidence],
--[cinbFlagForPhoto],[cinsPrimaryContactNo],[cinsHomePhone],[cinsWorkPhone],[cinsMobile],[cinbPreventMailing],[cinnRecUserID],[cindDtCreated],[cinnModifyUserID],[cindDtModified],[cinnLevelNo],
--[cinsPrimaryLanguage],[cinsOtherLanguage],[cinbDeathFlag],[cinsCitizenship],[cinsHeight],[cinnWeight],[cinsReligion],[cindMarriageDate],[cinsMarriageLoc],[cinsDeathPlace],[cinsMaidenName],
--[cinsOccupation],[saga],[cinsSpouse],[cinsGrade]) 

--SELECT distinct 8,1,10,null,'Mr.','Staff','','Unassigned',null,null,1,null,
--null,null,1,'','',null,'','',1,'',1,1,null,null,'','',null,0,368,GETDATE(),'',null,0,'','','','',null+null,null,'',Null,'','','','','','',null
--union
--SELECT distinct 9,1,10,null,'Mr.','John','','Doe',null,null,1,null,
--null,null,1,'','',null,'','',1,'',1,1,null,null,'','',null,0,368,GETDATE(),'',null,0,'','','','',null+null,null,'',Null,'','','','','','',null
--go
--set ansi_warnings off
--go
--alter table [sma_MST_Address] disable trigger all
--INSERT INTO [sma_MST_Address]
--([addnContactCtgID],[addnContactID],[addnAddressTypeID],[addsAddressType],[addsAddTypeCode],[addsAddress1],[addsAddress2],[addsAddress3],
--[addsStateCode],[addsCity],[addnZipID]
--,[addsZip],[addsCounty],[addsCountry],[addbIsResidence],[addbPrimary],[adddFromDate],[adddToDate],[addnCompanyID],
--[addsDepartment],[addsTitle],[addnContactPersonID],[addsComments]
--,[addbIsCurrent],[addbIsMailing],[addnRecUserID],[adddDtCreated],[addnModifyUserID],[adddDtModified],[addnLevelNo],[caseno],[addbDeleted],[addsZipExtn],[saga])
--Select 1,8, 10 ,'Other',
-- 'OTH' ,'','','','','','','','','',
--1,1, GETDATE() ,null,null,null,null,null,'',1,
--1,
--368,GETDATE() ,null,null,'','','','',''
--union
--Select 1,9, 10 ,'Other',
-- 'OTH' ,'','','','','','','','','',
--1,1, GETDATE() ,null,null,null,null,null,'',1,
--1,
--368,GETDATE() ,null,null,'','','','',''
--alter table [sma_MST_Address] enable trigger all

--SET IDENTITY_INSERT sma_mst_indvcontacts off


INSERT INTO [sma_MST_IndvContacts]
	(
	[cinbPrimary]
   ,[cinnContactTypeID]
   ,[cinnContactSubCtgID]
   ,[cinsPrefix]
   ,[cinsFirstName]
   ,[cinsMiddleName]
   ,[cinsLastName]
   ,[cinsSuffix]
   ,[cinsNickName]
   ,[cinbStatus]
   ,[cinsSSNNo]
   ,[cindBirthDate]
   ,[cinsComments]
   ,[cinnContactCtg]
   ,[cinnRefByCtgID]
   ,[cinnReferredBy]
   ,[cindDateOfDeath]
   ,[cinsCVLink]
   ,[cinnMaritalStatusID]
   ,[cinnGender]
   ,[cinsBirthPlace]
   ,[cinnCountyID]
   ,[cinsCountyOfResidence]
   ,[cinbFlagForPhoto]
   ,[cinsPrimaryContactNo]
   ,[cinsHomePhone]
   ,[cinsWorkPhone]
   ,[cinsMobile]
   ,[cinbPreventMailing]
   ,[cinnRecUserID]
   ,[cindDtCreated]
   ,[cinnModifyUserID]
   ,[cindDtModified]
   ,[cinnLevelNo]
   ,[cinsPrimaryLanguage]
   ,[cinsOtherLanguage]
   ,[cinbDeathFlag]
   ,[cinsCitizenship]
   ,[cinsHeight]
   ,[cinnWeight]
   ,[cinsReligion]
   ,[cindMarriageDate]
   ,[cinsMarriageLoc]
   ,[cinsDeathPlace]
   ,[cinsMaidenName]
   ,[cinsOccupation]
   ,[saga]
   ,[cinsSpouse]
   ,[cinsGrade]
	)

	SELECT DISTINCT
		1
	   ,10
	   ,NULL
	   ,TITLE
	   ,FIRST_DBA
	   ,MIDDLE_CONTACT
	   ,LAST_COMPANY
	   ,NULL
		--	   ,ALIASNAMES
	   ,NULL			-- ds 2024-09-20
		--  ,CASE USERTYPE
		--	WHEN 1
		--		THEN 1
		--	ELSE 0
		--END
	   ,1				-- ds 2024-09-20
	   ,ssn
	   ,DATEOFB
	   ,ENTITYNAME
	   ,1
	   ,''
	   ,''
	   ,DOD
	   ,''
	   ,''
	   ,CASE gender
			WHEN 'M'
				THEN 1
			WHEN 'F'
				THEN 2
		END
	   ,''
	   ,1
	   ,1
	   ,NULL
	   ,left(phone,20)
	   ,''
	   ,''
	   ,MOBILEPHONE
	   ,0
	   ,368
	   ,GETDATE()
	   ,''
	   ,NULL
	   ,0
	   ,''
	   ,''
	   ,''
	   ,''
		--,HEIGHTFEET + HEIGHTINCH
		--,WEIGHT
	   ,NULL			-- ds 2024-09-20
	   ,NULL			-- ds 2024-09-20
	   ,''
	   ,NULL
	   ,''
	   ,''
	   ,''
	   ,''
	   ,''
	   ,''
	   ,ENTITYID
	FROM [WilliamPagerSaga].[dbo].[ENTITIES] e
	LEFT JOIN [WilliamPagerSaga].[dbo].enttype et
		ON e.ENTITYTYPEID = et.ENTITYTYPEID
	WHERE e.ENTITYCATEGORY = 1
		OR et.DESCRIPTION LIKE '%staff%'
		--AND usertype = 1
		AND LOGINNAME NOT IN -->chinmong
		(
		'DJO',
		'NAM'
		)

INSERT INTO [sma_MST_Users]
	(
	[usrnContactID]
   ,[usrsLoginID]
   ,[usrsPassword]
   ,[usrsBackColor]
   ,[usrsReadBackColor]
   ,[usrsEvenBackColor]
   ,[usrsOddBackColor]
   ,[usrnRoleID]
   ,[usrdLoginDate]
   ,[usrdLogOffDate]
   ,[usrnUserLevel]
   ,[usrsWorkstation]
   ,[usrnPortno]
   ,[usrbLoggedIn]
   ,[usrbCaseLevelRights]
   ,[usrbCaseLevelFilters]
   ,[usrnUnsuccesfulLoginCount]
   ,[usrnRecUserID]
   ,[usrdDtCreated]
   ,[usrnModifyUserID]
   ,[usrdDtModified]
   ,[usrnLevelNo]
   ,[usrsCaseCloseColor]
   ,[usrnDocAssembly]
   ,[usrnAdmin]
   ,[usrnIsLocked]
   ,usrbActiveState
	)
	SELECT DISTINCT
		(cinncontactid)
	   ,CASE
			WHEN MIN(LOGINNAME) IS NOT NULL
				THEN MIN(LOGINNAME)
			WHEN MIN(code) IS NULL
				THEN SUBSTRING(ISNULL(MIN(cinsFirstName), ''), 0, 1) + MIN(SUBSTRING(cinsLastName, 0, 19))
			ELSE MIN(CODE)
		END
	   ,'#'
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,33
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,1
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,1
	   ,NULL
	 --  ,CASE
		--	WHEN MIN(USERTYPE) = 1
		--		THEN 1
		--	ELSE 0
		--END
		,0			AS usrbActiveState			-- ds 2024-09-20
	FROM sma_MST_IndvContacts
	LEFT JOIN [WilliamPagerSaga].[dbo].[ENTITIES]
		ON cinsGrade = ENTITYID
	WHERE cinnContactID NOT IN (8, 9)
		AND LOGINNAME NOT IN -->chinmong
		(
		'DJO',
		'NAM'
		)
	GROUP BY cinncontactid

--SET IDENTITY_INSERT sma_mst_users ON -->Chinmong


--INSERT INTO [sma_MST_Users]
--(usrnuserid,[usrnContactID],[usrsLoginID],[usrsPassword],[usrsBackColor],[usrsReadBackColor],[usrsEvenBackColor],[usrsOddBackColor],[usrnRoleID],[usrdLoginDate],[usrdLogOffDate],[usrnUserLevel],[usrsWorkstation],[usrnPortno],[usrbLoggedIn],
--[usrbCaseLevelRights],[usrbCaseLevelFilters],[usrnUnsuccesfulLoginCount],[usrnRecUserID],[usrdDtCreated],[usrnModifyUserID],[usrdDtModified],[usrnLevelNo],[usrsCaseCloseColor],[usrnDocAssembly],[usrnAdmin],[usrnIsLocked],usrbactivestate)     
--Select distinct 368,8,'aadmin','2/',null,null,null,null,33,null,null,null,null,null,null,null,null,null,1,GETDATE(),null,null,null,null,null,1,null,1

--SET IDENTITY_INSERT sma_mst_users OFF


DECLARE @UserID INT

-- Insert statements for trigger here


-- Insert statements for procedure here

DECLARE staff_cursor CURSOR FAST_FORWARD FOR SELECT
	usrnuserid
FROM sma_mst_users

OPEN staff_cursor

FETCH NEXT FROM staff_cursor INTO @UserID

WHILE @@FETCH_STATUS = 0
BEGIN

INSERT INTO sma_TRN_CaseBrowseSettings
	(
	cbsnColumnID
   ,cbsnUserID
   ,cbssCaption
   ,cbsbVisible
   ,cbsnWidth
   ,cbsnOrder
   ,cbsnRecUserID
   ,cbsdDtCreated
   ,cbsn_StyleName
	)
	SELECT DISTINCT
		cbcnColumnID
	   ,@UserID
	   ,cbcscolumnname
	   ,'True'
	   ,200
	   ,cbcnDefaultOrder
	   ,@UserID
	   ,GETDATE()
	   ,'Office2007Blue'
	FROM [sma_MST_CaseBrowseColumns]
	WHERE cbcnColumnID NOT IN (1, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 33)





FETCH NEXT FROM staff_cursor INTO @UserID
END

CLOSE staff_cursor
DEALLOCATE staff_cursor




ALTER TABLE sma_mst_indvcontacts ENABLE TRIGGER ALL