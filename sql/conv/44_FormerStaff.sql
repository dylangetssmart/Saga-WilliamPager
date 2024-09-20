USE WilliamPagerSA

ALTER TABLE [sma_MST_OrgContacts] DISABLE TRIGGER ALL
UPDATE sma_MST_OrgContacts
SET connContactTypeID = 12
WHERE connContactID IN (
	SELECT DISTINCT
		lwfnLawFirmContactID
	FROM sma_TRN_LawFirms
)

ALTER TABLE sma_mst_address DISABLE TRIGGER ALL
UPDATE sma_mst_address
SET addbPrimary = 0
WHERE addnAddressID
NOT IN (
	SELECT
		MIN(addnAddressID)
	FROM sma_mst_address
	WHERE addbPrimary = 1
	GROUP BY addnContactID
			,addnContactCtgID
)
AND addbPrimary = 1

UPDATE sma_mst_address
SET addbIsMailing = 0
WHERE addnAddressID
NOT IN (
	SELECT
		MIN(addnAddressID)
	FROM sma_mst_address
	WHERE addbIsMailing = 1
	GROUP BY addnContactID
			,addnContactCtgID
)
AND addbIsMailing = 1
ALTER TABLE sma_mst_address ENABLE TRIGGER ALL

ALTER TABLE sma_mst_contactnumbers DISABLE TRIGGER ALL
UPDATE sma_mst_contactnumbers
SET cnnbPrimary = 0
WHERE cnnnContactNumberID NOT IN (
	SELECT
		MIN(cnnnContactNumberID)
	FROM sma_MST_ContactNumbers
	WHERE cnnbPrimary = 1
	GROUP BY cnnnContactID
			,cnnnContactCtgID
)
AND cnnbPrimary = 1
ALTER TABLE sma_mst_contactnumbers ENABLE TRIGGER ALL

ALTER TABLE sma_MST_EmailWebsite DISABLE TRIGGER ALL

UPDATE sma_MST_EmailWebsite
SET cewbDefault = 0
WHERE cewnEmlWSID NOT IN (
	SELECT
		MIN(cewnEmlWSID)
	FROM sma_MST_EmailWebsite
	WHERE cewbDefault = 1
		AND cewsEmailWebsiteFlag = 'E'
	GROUP BY cewnContactID
			,cewnContactCtgID
)
AND cewbDefault = 1
AND cewsEmailWebsiteFlag = 'E'

ALTER TABLE sma_MST_EmailWebsite ENABLE TRIGGER ALL

ALTER TABLE sma_trn_casestaff DISABLE TRIGGER ALL
DELETE FROM sma_trn_casestaff
WHERE cssnPKID NOT IN (
		SELECT
			MIN(cssnpkid)
		FROM sma_TRN_CaseStaff
		WHERE cssdToDate IS NULL
		GROUP BY cssnStaffID
				,cssnCaseID
	)
ALTER TABLE sma_trn_casestaff ENABLE TRIGGER ALL

ALTER TABLE sma_trn_cases DISABLE TRIGGER ALL
UPDATE a
SET casdClosingDate = cssdFromDate
FROM sma_TRN_CaseStatus
LEFT JOIN sma_trn_cases a
	ON cssnCaseID = casnCaseID
WHERE cssnStatusID IN (
	SELECT
		statusid
	FROM sma_TRN_CaseStagesStatus
	WHERE StageID = 5
)
AND cssdToDt IS NULL
AND casdClosingDate IS NULL
ALTER TABLE sma_trn_cases ENABLE TRIGGER ALL

INSERT INTO [sma_MST_OrgContacts]
	(
	[conbPrimary]
   ,[connContactTypeID]
   ,[connContactSubCtgID]
   ,[consName]
   ,[conbStatus]
   ,[consEINNO]
   ,[consComments]
   ,[connContactCtg]
   ,[connRefByCtgID]
   ,[connReferredBy]
   ,[connContactPerson]
   ,[consWorkPhone]
   ,[conbPreventMailing]
   ,[connRecUserID]
   ,[condDtCreated]
   ,[connModifyUserID]
   ,[condDtModified]
   ,[connLevelNo]
   ,[consOtherName]
   ,[saga]
	)
	SELECT
		1
	   ,12
	   ,''
	   ,FIRMNAME
	   ,1
	   ,''
	   ,''
	   ,2
	   ,''
	   ,''
	   ,''
	   ,''
	   ,NULL
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	FROM WilliamPagerSaga.dbo.SETTINGS

ALTER TABLE [sma_MST_Address] DISABLE TRIGGER ALL
INSERT INTO [sma_MST_Address]
	(
	[addnContactCtgID]
   ,[addnContactID]
   ,[addnAddressTypeID]
   ,[addsAddressType]
   ,[addsAddTypeCode]
   ,[addsAddress1]
   ,[addsAddress2]
   ,[addsAddress3]
   ,[addsStateCode]
   ,[addsCity]
   ,[addnZipID]
   ,[addsZip]
   ,[addsCounty]
   ,[addsCountry]
   ,[addbIsResidence]
   ,[addbPrimary]
   ,[adddFromDate]
   ,[adddToDate]
   ,[addnCompanyID]
   ,[addsDepartment]
   ,[addsTitle]
   ,[addnContactPersonID]
   ,[addsComments]
   ,[addbIsCurrent]
   ,[addbIsMailing]
   ,[addnRecUserID]
   ,[adddDtCreated]
   ,[addnModifyUserID]
   ,[adddDtModified]
   ,[addnLevelNo]
   ,[caseno]
   ,[addbDeleted]
   ,[addsZipExtn]
   ,[saga]
	)
	SELECT
		2
	   ,connContactID
	   ,10
	   ,'Other'
	   ,'OTH'
	   ,ADDRLINE1
	   ,ADDRLINE2
	   ,''
	   ,ADDRCITY
	   ,ADDRSTATE
	   ,''
	   ,ADDRZIPCODE
	   ,''
	   ,'USA'
	   ,1
	   ,1
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,''
	   ,1
	   ,1
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	   ,''
	   ,''
	   ,''
	   ,''
	FROM WilliamPagerSaga.dbo.SETTINGS
	OUTER APPLY (
		SELECT TOP 1
			conncontactid
		FROM sma_mst_orgcontacts
		WHERE consname = FIRMNAME
		ORDER BY connContactID DESC
	) o1
ALTER TABLE [sma_MST_Address] ENABLE TRIGGER ALL

DECLARE @addressid INT
SELECT
	@addressid = addnaddressid
FROM sma_MST_Address
JOIN sma_mst_orgcontacts
	ON connContactID = addnContactID
		AND addnContactCtgID = 2
WHERE consName = 'Leslie Elliot Krause Law Office'
UPDATE sma_MST_FirmInfo
SET frinAddsID = @addressid


INSERT INTO [sma_MST_OrgContacts]
	(
	[conbPrimary]
   ,[connContactTypeID]
   ,[connContactSubCtgID]
   ,[consName]
   ,[conbStatus]
   ,[consEINNO]
   ,[consComments]
   ,[connContactCtg]
   ,[connRefByCtgID]
   ,[connReferredBy]
   ,[connContactPerson]
   ,[consWorkPhone]
   ,[conbPreventMailing]
   ,[connRecUserID]
   ,[condDtCreated]
   ,[connModifyUserID]
   ,[condDtModified]
   ,[connLevelNo]
   ,[consOtherName]
   ,[saga]
	)
	SELECT
		1
	   ,11
	   ,''
	   ,casscasename
	   ,1
	   ,''
	   ,''
	   ,2
	   ,''
	   ,''
	   ,''
	   ,''
	   ,NULL
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	FROM sma_trn_cases
	WHERE casnCaseID IN (
			SELECT
				plnnCaseID
			FROM sma_TRN_Plaintiff
			WHERE plnnContactCtg = 1
				AND plnnContactID = 9
		)

ALTER TABLE [sma_MST_Address] DISABLE TRIGGER ALL
INSERT INTO [sma_MST_Address]
	(
	[addnContactCtgID]
   ,[addnContactID]
   ,[addnAddressTypeID]
   ,[addsAddressType]
   ,[addsAddTypeCode]
   ,[addsAddress1]
   ,[addsAddress2]
   ,[addsAddress3]
   ,[addsStateCode]
   ,[addsCity]
   ,[addnZipID]
   ,[addsZip]
   ,[addsCounty]
   ,[addsCountry]
   ,[addbIsResidence]
   ,[addbPrimary]
   ,[adddFromDate]
   ,[adddToDate]
   ,[addnCompanyID]
   ,[addsDepartment]
   ,[addsTitle]
   ,[addnContactPersonID]
   ,[addsComments]
   ,[addbIsCurrent]
   ,[addbIsMailing]
   ,[addnRecUserID]
   ,[adddDtCreated]
   ,[addnModifyUserID]
   ,[adddDtModified]
   ,[addnLevelNo]
   ,[caseno]
   ,[addbDeleted]
   ,[addsZipExtn]
   ,[saga]
	)
	SELECT DISTINCT
		2
	   ,connContactID
	   ,11
	   ,'Other'
	   ,'OTH'
	   ,''
	   ,''
	   ,''
	   ,''
	   ,''
	   ,''
	   ,''
	   ,''
	   ,''
	   ,1
	   ,1
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,''
	   ,1
	   ,1
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	   ,''
	   ,''
	   ,''
	   ,''
	FROM sma_mst_orgcontacts
	JOIN sma_trn_cases
		ON cassCaseName = consName
	WHERE casnCaseID IN (
			SELECT
				plnnCaseID
			FROM sma_TRN_Plaintiff
			WHERE plnnContactCtg = 1
				AND plnnContactID = 9
		)
ALTER TABLE [sma_MST_Address] ENABLE TRIGGER ALL


ALTER TABLE sma_trn_plaintiff DISABLE TRIGGER ALL
UPDATE a
SET plnnContactCtg = 2
   ,plnnContactID = connContactID
   ,plnnAddressID = addnAddressID
FROM sma_TRN_Plaintiff a
LEFT JOIN sma_trn_cases
	ON plnnCaseID = casnCaseID
LEFT JOIN sma_mst_orgcontacts
	ON consName = cassCaseName
LEFT JOIN sma_mst_address
	ON addncontactid = connContactID
	AND addnContactCtgID = 2
WHERE plnnContactCtg = 1
AND plnnContactID = 9
ALTER TABLE sma_trn_plaintiff ENABLE TRIGGER ALL

ALTER TABLE sma_trn_cases DISABLE TRIGGER ALL
UPDATE a
SET casdClosingDate = cssdFromDate
FROM sma_TRN_CaseStatus
LEFT JOIN sma_trn_cases a
	ON casnCaseID = cssnCaseID
WHERE cssdToDt IS NULL
AND cssnStatusID IN (
	SELECT
		statusid
	FROM sma_TRN_CaseStagesStatus
	WHERE StageID = 5
)
AND casdClosingDate IS NULL
ALTER TABLE sma_trn_cases ENABLE TRIGGER ALL


DELETE FROM [WorkFlowStepTemplates]
WHERE WorkFlowTemplateId = 2
DELETE FROM [WorkFlowValueTemplates]
WHERE WorkFlowTemplateId = 2

--Alter table sma_TRN_Hospitals disable trigger all
--Update a
--set hosnPlaintiffID=p2.plnnPlaintiffID
--from sma_TRN_Hospitals a
--left join sma_TRN_Plaintiff p1 on p1.plnnCaseID=hosnCaseID
--left join sma_TRN_Plaintiff p2 on p2.plnnCaseID=hosnCaseID and p2.plnbIsPrimary=1
--where hosnCaseID =p1.plnnCaseID and hosnPlaintiffID<>p1.plnnPlaintiffID and hosnPlaintiffID is not null
--Alter table sma_TRN_Hospitals enable trigger all

ALTER TABLE sma_TRN_Defendants DISABLE TRIGGER ALL
DELETE FROM sma_TRN_Defendants
WHERE defnDefendentID NOT IN (
		SELECT
			MIN(defnDefendentID)
		FROM sma_TRN_Defendants
		GROUP BY defnContactID
				,defnContactCtgID
				,defnCaseID
	)
ALTER TABLE sma_TRN_Defendants ENABLE TRIGGER ALL



--Alter table sma_MST_IndvContacts disable trigger all
--Update  sma_MST_IndvContacts
--set cinbStatus=1
--where cinsGrade in (
--select distinct CREATORID from WilliamPagerSaga.dbo.note)
--and cinnContactID not in (select usrncontactid from sma_mst_users)
--Alter table sma_MST_IndvContacts enable trigger all

--INSERT INTO [sma_MST_Users]
--([usrnContactID],[usrsLoginID],[usrsPassword],[usrsBackColor],[usrsReadBackColor],[usrsEvenBackColor],[usrsOddBackColor],[usrnRoleID],[usrdLoginDate],[usrdLogOffDate],[usrnUserLevel],[usrsWorkstation],[usrnPortno],[usrbLoggedIn],
--[usrbCaseLevelRights],[usrbCaseLevelFilters],[usrnUnsuccesfulLoginCount],[usrnRecUserID],[usrdDtCreated],[usrnModifyUserID],[usrdDtModified],[usrnLevelNo],[usrsCaseCloseColor],[usrnDocAssembly],[usrnAdmin],[usrnIsLocked])     
--Select distinct cinncontactid,SUBSTRING(cinsFirstName,1,1)+SUBSTRING(cinsLastName,1,1),'#',null,null,null,null,33,null,null,null,null,null,null,null,null,null,1,GETDATE(),null,null,null,null,null,null,1
--from sma_MST_IndvContacts
--where cinsGrade in (
--select distinct CREATORID from WilliamPagerSaga.dbo.note)
--and cinnContactID not in (select usrncontactid from sma_mst_users)

--Declare @UserID int

--    -- Insert statements for trigger here


--    -- Insert statements for procedure here

--DECLARE staff_cursor CURSOR FAST_FORWARD FOR SELECT usrnuserid from sma_mst_users where usrnUserID>368

--OPEN staff_cursor 

--FETCH NEXT FROM staff_cursor INTO @UserID

--WHILE @@FETCH_STATUS = 0
--BEGIN

--insert into sma_TRN_CaseBrowseSettings (cbsnColumnID,cbsnUserID,cbssCaption,cbsbVisible,cbsnWidth,cbsnOrder,cbsnRecUserID,cbsdDtCreated,cbsn_StyleName)
-- SELECT distinct cbcnColumnID,@UserID,cbcscolumnname,'True',200,cbcnDefaultOrder,@UserID,GETDATE(),'Office2007Blue' FROM [sma_MST_CaseBrowseColumns]
-- where cbcnColumnID not in (1,18,19,20,21,22,23,24,25,26,27,28,29,30,33)





--FETCH NEXT FROM staff_cursor INTO  @UserID
--END

--CLOSE staff_cursor 
--DEALLOCATE staff_cursor
ALTER TABLE [sma_MST_OrgContacts] ENABLE TRIGGER ALL
