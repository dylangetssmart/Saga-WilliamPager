alter table [sma_MST_OrgContacts] disable trigger all
Update sma_MST_OrgContacts
set connContactTypeID=12
where connContactID in (
Select distinct lwfnLawFirmContactID from sma_TRN_LawFirms)

Alter table sma_mst_address disable trigger all
Update sma_mst_address set addbPrimary=0 where addnAddressID
not in(
select min(addnAddressID) from sma_mst_address 
where addbPrimary=1
group by addnContactID,addnContactCtgID) and addbPrimary=1

update sma_mst_address set addbIsMailing=0 where addnAddressID
not in(
select min(addnAddressID) from sma_mst_address 
where addbIsMailing=1
group by addnContactID,addnContactCtgID) and addbIsMailing=1
Alter table sma_mst_address enable trigger all

Alter table sma_mst_contactnumbers disable trigger all
update sma_mst_contactnumbers
set cnnbPrimary=0
where cnnnContactNumberID not in (
select min(cnnnContactNumberID) from sma_MST_ContactNumbers where cnnbPrimary=1
group by cnnnContactID,cnnnContactCtgID) and cnnbPrimary=1
Alter table sma_mst_contactnumbers enable trigger all

alter table sma_MST_EmailWebsite disable trigger all

Update sma_MST_EmailWebsite
set cewbDefault=0
where cewnEmlWSID not in (
select min(cewnEmlWSID) from sma_MST_EmailWebsite
where cewbDefault=1 and cewsEmailWebsiteFlag='E'
group by cewnContactID,cewnContactCtgID) and cewbDefault=1 and cewsEmailWebsiteFlag='E'

alter table sma_MST_EmailWebsite enable trigger all

Alter table sma_trn_casestaff disable trigger all
Delete from sma_trn_casestaff
where cssnPKID not in (
select min(cssnpkid) from sma_TRN_CaseStaff
where cssdToDate is null
group by cssnStaffID,cssnCaseID)
Alter table sma_trn_casestaff enable trigger all

Alter table sma_trn_cases disable trigger all
Update a 
set casdClosingDate=cssdFromDate
from sma_TRN_CaseStatus
left join sma_trn_cases a on cssnCaseID=casnCaseID
where cssnStatusID in (select statusid from sma_TRN_CaseStagesStatus where StageID=5) and cssdToDt is null and casdClosingDate is null
Alter table sma_trn_cases enable trigger all

  INSERT INTO [sma_MST_OrgContacts]
([conbPrimary]
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
,[saga])
Select 1,12,'',FIRMNAME,1,'','',2,'','','','',null,368,GETDATE(),null,null,null,null,null
From WilliamPagerSaga.dbo.SETTINGS 

alter table [sma_MST_Address] disable trigger all
INSERT INTO [sma_MST_Address]
([addnContactCtgID],[addnContactID],[addnAddressTypeID],[addsAddressType],[addsAddTypeCode],[addsAddress1],[addsAddress2],[addsAddress3],
[addsStateCode],[addsCity],[addnZipID]
,[addsZip],[addsCounty],[addsCountry],[addbIsResidence],[addbPrimary],[adddFromDate],[adddToDate],[addnCompanyID],
[addsDepartment],[addsTitle],[addnContactPersonID],[addsComments]
,[addbIsCurrent],[addbIsMailing],[addnRecUserID],[adddDtCreated],[addnModifyUserID],[adddDtModified],[addnLevelNo],[caseno],[addbDeleted],[addsZipExtn],[saga])
Select 2,connContactID, 10 ,'Other',
 'OTH' ,ADDRLINE1,ADDRLINE2,'',ADDRCITY,ADDRSTATE,'',ADDRZIPCODE,'','USA',
1,1, GETDATE() ,null,null,null,null,null,'',1,
1,
368,GETDATE() ,null,null,'','','','',''
From WilliamPagerSaga.dbo.SETTINGS  outer apply (select top 1 conncontactid from  sma_mst_orgcontacts where consname=FIRMNAME order by connContactID desc) o1 
alter table [sma_MST_Address] enable trigger all

Declare @addressid int
select @addressid=addnaddressid from sma_MST_Address join sma_mst_orgcontacts on connContactID=addnContactID and addnContactCtgID=2 where consName='Leslie Elliot Krause Law Office'
Update sma_MST_FirmInfo 
set frinAddsID=@addressid


  INSERT INTO [sma_MST_OrgContacts]
([conbPrimary]
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
,[saga])
Select 1,11,'',casscasename,1,'','',2,'','','','',null,368,GETDATE(),null,null,null,null,null
from sma_trn_cases where casnCaseID in (select plnnCaseID from sma_TRN_Plaintiff where plnnContactCtg=1 and plnnContactID=9)

alter table [sma_MST_Address] disable trigger all
INSERT INTO [sma_MST_Address]
([addnContactCtgID],[addnContactID],[addnAddressTypeID],[addsAddressType],[addsAddTypeCode],[addsAddress1],[addsAddress2],[addsAddress3],
[addsStateCode],[addsCity],[addnZipID]
,[addsZip],[addsCounty],[addsCountry],[addbIsResidence],[addbPrimary],[adddFromDate],[adddToDate],[addnCompanyID],
[addsDepartment],[addsTitle],[addnContactPersonID],[addsComments]
,[addbIsCurrent],[addbIsMailing],[addnRecUserID],[adddDtCreated],[addnModifyUserID],[adddDtModified],[addnLevelNo],[caseno],[addbDeleted],[addsZipExtn],[saga])
Select distinct 2,connContactID, 11 ,'Other',
 'OTH' ,'','','','','','','','','',
1,1, GETDATE() ,null,null,null,null,null,'',1,
1,
368,GETDATE() ,null,null,'','','','',''
From sma_mst_orgcontacts join sma_trn_cases on cassCaseName=consName where casnCaseID in (select plnnCaseID from sma_TRN_Plaintiff where plnnContactCtg=1 and plnnContactID=9)
alter table [sma_MST_Address] enable trigger all


Alter table sma_trn_plaintiff disable trigger all
Update a
set plnnContactCtg=2,plnnContactID=connContactID,plnnAddressID=addnAddressID
from sma_TRN_Plaintiff a
left join sma_trn_cases on plnnCaseID=casnCaseID
left join sma_mst_orgcontacts on consName=cassCaseName
left join sma_mst_address on addncontactid=connContactID and addnContactCtgID=2
where plnnContactCtg=1 and plnnContactID=9
Alter table sma_trn_plaintiff enable trigger all

Alter table sma_trn_cases disable trigger all
Update a 
set casdClosingDate=cssdFromDate
from sma_TRN_CaseStatus 
left join sma_trn_cases a on casnCaseID=cssnCaseID 
where cssdToDt is null and cssnStatusID in (select statusid from sma_TRN_CaseStagesStatus where StageID=5) and casdClosingDate is null
Alter table sma_trn_cases enable trigger all


Delete FROM [WorkFlowStepTemplates] where WorkFlowTemplateId=2
Delete FROM [WorkFlowValueTemplates] where WorkFlowTemplateId=2

--Alter table sma_TRN_Hospitals disable trigger all
--Update a
--set hosnPlaintiffID=p2.plnnPlaintiffID
--from sma_TRN_Hospitals a
--left join sma_TRN_Plaintiff p1 on p1.plnnCaseID=hosnCaseID
--left join sma_TRN_Plaintiff p2 on p2.plnnCaseID=hosnCaseID and p2.plnbIsPrimary=1
--where hosnCaseID =p1.plnnCaseID and hosnPlaintiffID<>p1.plnnPlaintiffID and hosnPlaintiffID is not null
--Alter table sma_TRN_Hospitals enable trigger all

alter table sma_TRN_Defendants disable trigger all
delete from sma_TRN_Defendants
where defnDefendentID not in (
select MIN(defnDefendentID) from sma_TRN_Defendants
group by defnContactID,defnContactCtgID,defnCaseID)
alter table sma_TRN_Defendants enable trigger all



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
alter table [sma_MST_OrgContacts] enable trigger all
