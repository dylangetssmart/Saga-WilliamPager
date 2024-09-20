alter table sma_mst_indvcontacts disable trigger all
set ansi_warnings off
go
--INSERT INTO [sma_MST_OriginalContactTypes]
--([octsCode],[octnContactCtgID],[octsDscrptn],[octnRecUserID],[octdDtCreated],[octnModifyUserID],[octdDtModified],[octnLevelNo])
-- Select distinct UPPER(SUBSTRING(et.DESCRIPTION,0,5)),1,DESCRIPTION,368,GETDATE(),null,null,''
-- FROM [WilliamPagerSaga].[dbo].[ENTITIES] e
--left join [WilliamPagerSaga].[dbo].enttype et on e.ENTITYTYPEID=et.ENTITYTYPEID
--where   FIRST_DBA is not null
--and et.DESCRIPTION not in (select [octsDscrptn] from [sma_MST_OriginalContactTypes] where [octnContactCtgID]=1)
--and et.DESCRIPTION not like '%judge%' and et.DESCRIPTION not like '%clerk%' and et.DESCRIPTION not like '%doctor%' and et.DESCRIPTION not like '%police%' and et.DESCRIPTION not like '%expert%' and et.DESCRIPTION not like '%adjuster%' and et.DESCRIPTION not like '%attorney%'  and et.DESCRIPTION not like '%investigator%'
------------------------------Insert Individual Contact Started-------------------------------------------------------------------------    
declare @ContactID int

select @ContactID= MAX(cinnContactID) from sma_MST_IndvContacts
INSERT INTO [sma_MST_IndvContacts]
([cinbPrimary]
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
,[cinsGrade])
SELECT distinct 1,case when et.DESCRIPTION like '%judge%' then 2 when et.DESCRIPTION like '%clerk%' then 32 when  et.DESCRIPTION like '%doctor%' then 1 when et.DESCRIPTION like '%police%' then 18 when  et.DESCRIPTION like '%expert%' then 23 when et.DESCRIPTION like '%adjuster%' then 20 when  et.DESCRIPTION like '%attorney%'  then 13 when  et.DESCRIPTION like '%investigator%' then 17 else 2 end,null,
substring(e.Title,0,19),substring(FIRST_DBA,0,29),substring(MIDDLE_CONTACT,0,29),substring(LAST_COMPANY,0,39),null,substring(ALIASNAMES,0,15), 1,substring(ssn,0,19),
DATEOFB,substring(ENTITYNAME,0,499),1,'','',DOD,'','',case gender when 'M' then 1 when 'F' then 2 end,'',1,1,null,substring(phone,0,19),'','',substring(MOBILEPHONE,0,19),0,
case isnull(u1.usrnuserid,'') when '' then 368 else u1.usrnuserid end,case e.datecreated when null then GETDATE() else e.datecreated end,u2.usrnuserid,e.daterevised,0,'','','','',HEIGHTFEET+HEIGHTINCH,WEIGHT,'',Null,'','','','','','',
j.JUDGEID
FROM [WilliamPagerSaga].dbo.MRULASS j
join [WilliamPagerSaga].[dbo].[ENTITIES]  e on j.JUDGEID=e.ENTITYID
left join [WilliamPagerSaga].[dbo].enttype et on e.ENTITYTYPEID=et.ENTITYTYPEID
--left join [sma_MST_OriginalContactTypes] on octsDscrptn=et.DESCRIPTION
left join sma_MST_IndvContacts a on a.cinsGrade=e.CREATORID
left join sma_mst_users u1 on u1.usrnContactID=a.cinnContactID
left join sma_MST_IndvContacts b on b.cinsGrade=e.REVISORID
left join sma_mst_users u2 on u2.usrnContactID=b.cinnContactID
where j.JUDGEID not in (select isnull(cinsgrade,0) from sma_mst_indvcontacts) --and  FIRST_DBA is not null
   
------------------------------Insert Individual Contact Finished-------------------------------------------------------------------------    

alter table [sma_MST_Address] disable trigger all
INSERT INTO [sma_MST_Address]
([addnContactCtgID],[addnContactID],[addnAddressTypeID],[addsAddressType],[addsAddTypeCode],[addsAddress1],[addsAddress2],[addsAddress3],[addsStateCode],[addsCity],[addnZipID]
,[addsZip],[addsCounty],[addsCountry],[addbIsResidence],[addbPrimary],[adddFromDate],[adddToDate],[addnCompanyID],[addsDepartment],[addsTitle],[addnContactPersonID],[addsComments]
,[addbIsCurrent],[addbIsMailing],[addnRecUserID],[adddDtCreated],[addnModifyUserID],[adddDtModified],[addnLevelNo],[caseno],[addbDeleted],[addsZipExtn],[saga])
Select 1,c.cinnContactID,case ADDRDESCRIPTION when 1001 then 7 when 4056 then 1 else 10 end,case ADDRDESCRIPTION when 1001 then 'Work' when 4056 then 'Home - Primary' else 'Other' end,
case ADDRDESCRIPTION when 1001 then 'WORK' when 4056 then 'HM' else 'OTH' end,substring(ADDRLINE1,0,75),substring(ADDRLINE2,0,75),substring(ADDRLINE3,0,75),substring(ADDRSTATE,0,20),substring(ADDRCITY,0,50),'',substring(ADDRZIPCODE,0,6),substring(ADDRCOUNTY,0,30),substring(ADDRCOUNTRY,0,30),
case when PRIMARYADDR  is NOT null then 1 else 0 end,case when PRIMARYADDR  is NOT null then 1 else 0 end,case ad.datecreated when null then GETDATE() else ad.datecreated end,null,null,null,null,null,EXTERNAL_REFERENCE_ID,
case when PRIMARYADDR  is NOT null then 1 else 0 end,case when PRIMARYADDR  is NOT null then 1 else 0 end,
case isnull(u1.usrnuserid,'') when '' then 368 else u1.usrnuserid end,case ad.datecreated when null then GETDATE() else ad.datecreated end,u2.usrnuserid,ad.daterevised,'','','',case when ADDRZIPCODE like '%-%' then SUBSTRING(ADDRZIPCODE, CHARINDEX('-', ADDRZIPCODE) + 1, LEN(ADDRZIPCODE)) else '' end,''
FROM [WilliamPagerSaga].[dbo].[Address]  ad
left join [WilliamPagerSaga].[dbo].[ENTITIES] en on ad.ENTITYID=en.ENTITYID
left join sma_MST_IndvContacts c on c.cinsGrade=ad.ENTITYID
left join sma_MST_IndvContacts a on a.cinsGrade=ad.CREATORID
left join sma_mst_users u1 on u1.usrnContactID=a.cinnContactID
left join sma_MST_IndvContacts b on b.cinsGrade=ad.REVISORID
left join sma_mst_users u2 on u2.usrnContactID=b.cinnContactID
where   c.cinncontactid is not null and c.cinnContactID>@ContactID
alter table [sma_MST_Address] enable trigger all


alter table [sma_MST_ContactNumbers] disable trigger all
INSERT INTO [sma_MST_ContactNumbers]
([cnnnContactCtgID],[cnnnContactID],[cnnnPhoneTypeID],[cnnsContactNumber],[cnnsExtension],[cnnbPrimary],[cnnbVisible],[cnnnAddressID],[cnnsLabelCaption],[cnnnRecUserID],[cnndDtCreated],
[cnnnModifyUserID],[cnndDtModified],[cnnnLevelNo],[caseNo],[saga])	
Select 1, c.cinnContactID,1,case when len(PHONE)>2 then isnull('(' + LEFT(Replace(ltrim(substring(dbo.[RemoveAlphaCharactersN](phone),0,11)),'-',''),3)+') '+SUBSTRING(Replace(Replace(substring(dbo.[RemoveAlphaCharactersN](phone),0,11),'-',''),' ',''),4,3)+'-'+RIGHT(Replace(Replace(substring(dbo.[RemoveAlphaCharactersN](phone),0,11),'-',''),' ',''),4),'') else null end,
PHONEEXT,1,1,addnaddressid,'Home 1',case isnull(u1.usrnuserid,'') when '' then 368 else u1.usrnuserid end,case datecreated when null then GETDATE() else datecreated end,u2.usrnuserid,daterevised,
null,null,null
FROM sma_MST_IndvContacts  c
Left Join [WilliamPagerSaga].[dbo].[ENTITIES]  on LTRIM(rtrim(c.cinsGrade))=ENTITYID 
outer apply(select top 1 addnaddressid,addsAddress1,addsAddress2,addsAddress3,addsCity,addsStateCode,addsZip from  sma_MST_Address where addnContactID=cinnContactID and addnContactCtgID=1 order by isnull(addbPrimary,0) desc) e
left join sma_MST_IndvContacts a on a.cinsGrade=CREATORID
left join sma_mst_users u1 on u1.usrnContactID=a.cinnContactID
left join sma_MST_IndvContacts b on b.cinsGrade=REVISORID
left join sma_mst_users u2 on u2.usrnContactID=b.cinnContactID
Where  len(PHONE)>2 and c.cinncontactid is not null and c.cinnContactID>@ContactID

INSERT INTO [sma_MST_ContactNumbers]
([cnnnContactCtgID],[cnnnContactID],[cnnnPhoneTypeID],[cnnsContactNumber],[cnnsExtension],[cnnbPrimary],[cnnbVisible],[cnnnAddressID],[cnnsLabelCaption],[cnnnRecUserID],[cnndDtCreated],
[cnnnModifyUserID],[cnndDtModified],[cnnnLevelNo],[caseNo],[saga])	
Select 1, c.cinnContactID,29,case when len(MOBILEPHONE)>2 then isnull('(' + LEFT(Replace(ltrim(substring(dbo.[RemoveAlphaCharactersN](MOBILEPHONE),0,11)),'-',''),3)+') '+SUBSTRING(Replace(Replace(substring(dbo.[RemoveAlphaCharactersN](MOBILEPHONE),0,11),'-',''),' ',''),4,3)+'-'+RIGHT(Replace(Replace(substring(dbo.[RemoveAlphaCharactersN](MOBILEPHONE),0,11),'-',''),' ',''),4),'') else null end,
MOBILEEXT,Case when len(PHONE)>2 then 0 else 1 end ,1,addnaddressid,'Cell Phone',case isnull(u1.usrnuserid,'') when '' then 368 else u1.usrnuserid end,case datecreated when null then GETDATE() else datecreated end,u2.usrnuserid,daterevised,
null,null,null
FROM sma_MST_IndvContacts  c
Left Join [WilliamPagerSaga].[dbo].[ENTITIES]  on LTRIM(rtrim(c.cinsGrade))=ENTITYID 
outer apply(select top 1 addnaddressid,addsAddress1,addsAddress2,addsAddress3,addsCity,addsStateCode,addsZip from  sma_MST_Address where addnContactID=cinnContactID and addnContactCtgID=1 order by isnull(addbPrimary,0) desc) e
left join sma_MST_IndvContacts a on a.cinsGrade=CREATORID
left join sma_mst_users u1 on u1.usrnContactID=a.cinnContactID
left join sma_MST_IndvContacts b on b.cinsGrade=REVISORID
left join sma_mst_users u2 on u2.usrnContactID=b.cinnContactID
Where  len(MOBILEPHONE)>2 and c.cinncontactid is not null and c.cinnContactID>@ContactID

INSERT INTO [sma_MST_ContactNumbers]
([cnnnContactCtgID],[cnnnContactID],[cnnnPhoneTypeID],[cnnsContactNumber],[cnnsExtension],[cnnbPrimary],[cnnbVisible],[cnnnAddressID],[cnnsLabelCaption],[cnnnRecUserID],[cnndDtCreated],
[cnnnModifyUserID],[cnndDtModified],[cnnnLevelNo],[caseNo],[saga])	
Select 1, c.cinnContactID,1,case when len(ADDRPHONE)>2 then isnull('(' + LEFT(Replace(ltrim(substring(dbo.[RemoveAlphaCharactersN](ADDRPHONE),0,11)),'-',''),3)+') '+SUBSTRING(Replace(Replace(substring(dbo.[RemoveAlphaCharactersN](ADDRPHONE),0,11),'-',''),' ',''),4,3)+'-'+RIGHT(Replace(Replace(substring(dbo.[RemoveAlphaCharactersN](ADDRPHONE),0,11),'-',''),' ',''),4),'') else null end,
ADDRPHONEEXT,Case when len(PHONE)>2 then 0 when LEN(MOBILEPHONE)>0 then 0 else 1 end ,1,addnaddressid,'Home 1',case isnull(u1.usrnuserid,'') when '' then 368 else u1.usrnuserid end,case f.datecreated when null then GETDATE() else f.datecreated end,u2.usrnuserid,f.daterevised,
null,null,null
FROM sma_MST_IndvContacts  c
Left Join [WilliamPagerSaga].[dbo].[address] f on LTRIM(rtrim(c.cinsGrade))=f.ENTITYID 
Left Join [WilliamPagerSaga].[dbo].[ENTITIES] g on f.ENTITYID =g.ENTITYID 
outer apply(select top 1 addnaddressid,addsAddress1,addsAddress2,addsAddress3,addsCity,addsStateCode,addsZip from  sma_MST_Address where addnContactID=cinnContactID and addnContactCtgID=1 order by isnull(addbPrimary,0) desc) e
left join sma_MST_IndvContacts a on a.cinsGrade=f.CREATORID
left join sma_mst_users u1 on u1.usrnContactID=a.cinnContactID
left join sma_MST_IndvContacts b on b.cinsGrade=f.REVISORID
left join sma_mst_users u2 on u2.usrnContactID=b.cinnContactID
Where  len(ADDRPHONE)>2 and c.cinncontactid is not null and c.cinnContactID>@ContactID

INSERT INTO [sma_MST_ContactNumbers]
([cnnnContactCtgID],[cnnnContactID],[cnnnPhoneTypeID],[cnnsContactNumber],[cnnsExtension],[cnnbPrimary],[cnnbVisible],[cnnnAddressID],[cnnsLabelCaption],[cnnnRecUserID],[cnndDtCreated],
[cnnnModifyUserID],[cnndDtModified],[cnnnLevelNo],[caseNo],[saga])	
Select 1, c.cinnContactID,16,case when len(ADDRDATA)>2 then isnull('(' + LEFT(Replace(ltrim(substring(dbo.[RemoveAlphaCharactersN](ADDRDATA),0,11)),'-',''),3)+') '+SUBSTRING(Replace(Replace(substring(dbo.[RemoveAlphaCharactersN](ADDRDATA),0,11),'-',''),' ',''),4,3)+'-'+RIGHT(Replace(Replace(substring(dbo.[RemoveAlphaCharactersN](ADDRDATA),0,11),'-',''),' ',''),4),'') else null end,
'',Case when len(PHONE)>2 then 0 when LEN(MOBILEPHONE)>0 then 0 when LEN(ADDRPHONE)>2 then 0 else 1 end ,1,addnaddressid,'Work 2',case isnull(u1.usrnuserid,'') when '' then 368 else u1.usrnuserid end,case f.datecreated when null then GETDATE() else f.datecreated end,u2.usrnuserid,f.daterevised,
null,null,null
FROM sma_MST_IndvContacts  c
Left Join [WilliamPagerSaga].[dbo].[address] f on LTRIM(rtrim(c.cinsGrade))=f.ENTITYID 
Left Join [WilliamPagerSaga].[dbo].[ENTITIES] g on f.ENTITYID =g.ENTITYID 
outer apply(select top 1 addnaddressid,addsAddress1,addsAddress2,addsAddress3,addsCity,addsStateCode,addsZip from  sma_MST_Address where addnContactID=cinnContactID and addnContactCtgID=1 order by isnull(addbPrimary,0) desc) e
left join sma_MST_IndvContacts a on a.cinsGrade=f.CREATORID
left join sma_mst_users u1 on u1.usrnContactID=a.cinnContactID
left join sma_MST_IndvContacts b on b.cinsGrade=f.REVISORID
left join sma_mst_users u2 on u2.usrnContactID=b.cinnContactID
Where  len(ADDRDATA)>2 and c.cinncontactid is not null and c.cinnContactID>@ContactID

INSERT INTO [sma_MST_ContactNumbers]
([cnnnContactCtgID],[cnnnContactID],[cnnnPhoneTypeID],[cnnsContactNumber],[cnnsExtension],[cnnbPrimary],[cnnbVisible],[cnnnAddressID],[cnnsLabelCaption],[cnnnRecUserID],[cnndDtCreated],[cnnnModifyUserID],[cnndDtModified],[cnnnLevelNo],[caseNo],[saga])	
Select 1, c.cinnContactID,25,case when len(ADDRFAX)>2 then isnull('(' + LEFT(Replace(ltrim(substring(dbo.[RemoveAlphaCharactersN](ADDRFAX),0,11)),'-',''),3)+') '+SUBSTRING(Replace(Replace(substring(dbo.[RemoveAlphaCharactersN](ADDRFAX),0,11),'-',''),' ',''),4,3)+'-'+RIGHT(Replace(Replace(substring(dbo.[RemoveAlphaCharactersN](ADDRFAX),0,11),'-',''),' ',''),4),'') else null end,
'',0,1,addnaddressid,'Home Fax',case isnull(u1.usrnuserid,'') when '' then 368 else u1.usrnuserid end,case f.datecreated when null then GETDATE() else f.datecreated end,u2.usrnuserid,f.daterevised,
null,null,null
FROM sma_MST_IndvContacts  c
Left Join [WilliamPagerSaga].[dbo].[address] f on LTRIM(rtrim(c.cinsGrade))=f.ENTITYID 
Left Join [WilliamPagerSaga].[dbo].[ENTITIES] g on f.ENTITYID =g.ENTITYID 
outer apply(select top 1 addnaddressid,addsAddress1,addsAddress2,addsAddress3,addsCity,addsStateCode,addsZip from  sma_MST_Address where addnContactID=cinnContactID and addnContactCtgID=1 order by isnull(addbPrimary,0) desc) e
left join sma_MST_IndvContacts a on a.cinsGrade=f.CREATORID
left join sma_mst_users u1 on u1.usrnContactID=a.cinnContactID
left join sma_MST_IndvContacts b on b.cinsGrade=f.REVISORID
left join sma_mst_users u2 on u2.usrnContactID=b.cinnContactID
Where  len(ADDRFAX)>2 and c.cinncontactid is not null and c.cinnContactID>@ContactID
alter table [sma_MST_ContactNumbers] enable trigger all

alter table [sma_MST_EmailWebsite] Disable trigger all

INSERT INTO [sma_MST_EmailWebsite]
([cewnContactCtgID],[cewnContactID],[cewsEmailWebsiteFlag],[cewsEmailWebSite],[cewbDefault],[cewnRecUserID],[cewdDtCreated],[cewnModifyUserID],[cewdDtModified],[cewnLevelNo],[saga])
Select 1,c.cinnContactID,'E',EMAILADDRESS,1,
case isnull(u1.usrnuserid,'') when '' then 368 else u1.usrnuserid end,case datecreated when null then GETDATE() else datecreated end,u2.usrnuserid,daterevised,
null,null
FROM sma_MST_IndvContacts c
Left Join [WilliamPagerSaga].dbo.ENTITIES on LTRIM(rtrim(c.cinsGrade))=ENTITYID 
left join sma_MST_IndvContacts a on a.cinsGrade=CREATORID
left join sma_mst_users u1 on u1.usrnContactID=a.cinnContactID
left join sma_MST_IndvContacts b on b.cinsGrade=REVISORID
left join sma_mst_users u2 on u2.usrnContactID=b.cinnContactID
Where  EMAILADDRESS<>'' and EMAILADDRESS  like '%@%' and c.cinncontactid is not null and c.cinnContactID>@ContactID
alter table [sma_MST_EmailWebsite] enable trigger all

Alter table sma_trn_courts disable trigger all
INSERT INTO [sma_TRN_Courts]
([crtnCaseID],[crtnCourtID],[crtnCourtAddId],[crtnIsJudge],[crtnJudgeID],[crtnJudgeAddId],[crtsComment],[crtbDocAttached],[crtdFromDt],[crtdToDt],[crtnRecUserID],[crtdDtCreated],[crtnModifyUserID],[crtdDtModified],[crtnLevelNo],[crtnDelete],[crtnIsActive]) 
select distinct casnCaseID,connContactID,addnAddressID,null,null,null,convert(varchar(max),ltrim(replace(
       dbo.RegExReplace(notes,'({\\)(.+?)(})|(\\)(.+?)(\b)','')
      ,'}','')
    
      )) ,'',ISNULL(casdDtModified,casdOpeningDate),null,ISNULL(casnModifyUserID,casnRecUserID),ISNULL(casdDtModified,casdOpeningDate),null,null,null,0,1
FROM [WilliamPagerSaga].[dbo].[LW_COURT] b
left join [WilliamPagerSaga].[dbo].ASSIGN c on b.ASSIGNID=c.ASSIGNID
left join [WilliamPagerSaga].[dbo].ASSIGN d on b.PARTYASSIGNID=d.ASSIGNID
left join [WilliamPagerSaga].[dbo].MATTER a on a.MATTERID=c.MATTERID
left join sma_trn_cases on cassCaseNumber=MATTERNUMBER
--left join [WilliamPagerSaga].[dbo].[JURISDCT] j on j.JURISDICTIONID=a.JURISDICTIONID
left join sma_MST_OrgContacts k on k.connLevelNo=c.ENTITYID
left join WilliamPagerSaga.dbo.ENTITIES en on en.ENTITYID=c.ENTITYID
left join WilliamPagerSaga.dbo.NOTE n on c.NOTEID=n.noteid
left join WilliamPagerSaga.dbo.ADDRESS ad on ad.ADDRESSID=en.PRIMARYADDR
left join sma_MST_Address on addnContactID=connContactID and addbPrimary=1 and addsCity=ad.ADDRCITY and addsAddress1=ad.ADDRLINE1 and addnContactCtgID=2
where casnCaseID is not null and isnull(connContactID,'') <>''

INSERT INTO [sma_TRN_Courts]
([crtnCaseID],[crtnCourtID],[crtnCourtAddId],[crtnIsJudge],[crtnJudgeID],[crtnJudgeAddId],[crtsComment],[crtbDocAttached],[crtdFromDt],[crtdToDt],[crtnRecUserID],[crtdDtCreated],[crtnModifyUserID],[crtdDtModified],[crtnLevelNo],[crtnDelete],[crtnIsActive]) 

select distinct casnCaseID,connContactID,addnAddressID,null,null,null,'' ,'',ISNULL(casdDtModified,casdOpeningDate),null,ISNULL(casnModifyUserID,casnRecUserID),ISNULL(casdDtModified,casdOpeningDate),null,null,null,0,1
FROM [WilliamPagerSaga].[dbo].[JURISDCT] j
left join [WilliamPagerSaga].[dbo].MATTER a on a.JURISDICTIONID=j.JURISDICTIONID
left join sma_trn_cases on cassCaseNumber=MATTERNUMBER
outer apply(select top 1 conncontactid,addnAddressID from  sma_MST_OrgContacts k left join sma_MST_Address on addnContactID=connContactID and addnContactCtgID=2 and addbPrimary=1 where k.consName=j.DESCRIPTION)k
where casnCaseID is not null and isnull(connContactID,'') <>'' and not exists(select * from sma_TRN_Courts where casnCaseID=crtnCaseID)

Alter table sma_trn_courts enable trigger all

Alter table [sma_TRN_CourtDocket] disable trigger all

Alter table [sma_TRN_CourtDocket]
Alter Column [crdnDocketNo] varchar(100)
INSERT INTO [sma_TRN_CourtDocket]
([crdnCourtsID],[crdnIndexTypeID],[crdnDocketNo],[crddDate],[crdnPrice],[crdsPayee],[crdsCheckNo],[crddCheckDt],[crdbActiveInActive],[crdsComments],[crdnRecUserID],[crddDtCreated],[crdnModifyUserID],[crddDtModified],[crdnLevelNo],[crdnDisbID],[crdnPayeeAddID],[crdnElcID],[crdsPayeeCtgID],[crdsEfile])
Select distinct crtnPKCourtsID,3,isnull(b.COURTCASENUMBER,'')+case when isnull(b.COURTCASENUMBEREXT,'') <>'' then '/'+b.COURTCASENUMBEREXT else '' end,case when DATEFILED between '1/1/1900' and '12/31/2079' then DATEFILED end ,null,null,null,case when DOCKETPURCHASEDATE between '1/1/1900' and '12/31/2079' then DOCKETPURCHASEDATE end,1,'',ISNULL(casnModifyUserID,casnRecUserID),ISNULL(casdDtModified,casdOpeningDate),null,null,null,null,null,null,null,0
FROM [WilliamPagerSaga].[dbo].[LW_COURT] b
left join [WilliamPagerSaga].[dbo].ASSIGN c on b.ASSIGNID=c.ASSIGNID
left join [WilliamPagerSaga].[dbo].ASSIGN d on b.PARTYASSIGNID=d.ASSIGNID
left join [WilliamPagerSaga].[dbo].MATTER a on a.MATTERID=c.MATTERID
left join sma_trn_cases on cassCaseNumber=MATTERNUMBER
left join sma_mst_orgcontacts on connlevelno=c.ENTITYID
left join sma_trn_courts on crtncaseid=casncaseid and connContactID=crtnCourtID
where b.COURTCASENUMBER <>'' and casnCaseID is not null and crtnPKCourtsID is not null 



INSERT INTO [sma_TRN_CourtDocket]
([crdnCourtsID],[crdnIndexTypeID],[crdnDocketNo],[crddDate],[crdnPrice],[crdsPayee],[crdsCheckNo],[crddCheckDt],[crdbActiveInActive],[crdsComments],[crdnRecUserID],[crddDtCreated],[crdnModifyUserID],[crddDtModified],[crdnLevelNo],[crdnDisbID],[crdnPayeeAddID],[crdnElcID],[crdsPayeeCtgID],[crdsEfile])
Select distinct crtnPKCourtsID,10,b.CALENDARNUMBER,case when DATEFILED between '1/1/1900' and '12/31/2079' then DATEFILED end,null,null,null,case when DOCKETPURCHASEDATE between '1/1/1900' and '12/31/2079' then DOCKETPURCHASEDATE end,1,'',ISNULL(casnModifyUserID,casnRecUserID),ISNULL(casdDtModified,casdOpeningDate),null,null,null,null,null,null,null,0
FROM [WilliamPagerSaga].[dbo].[LW_COURT] b
left join [WilliamPagerSaga].[dbo].ASSIGN c on b.ASSIGNID=c.ASSIGNID
left join [WilliamPagerSaga].[dbo].ASSIGN d on b.PARTYASSIGNID=d.ASSIGNID
left join [WilliamPagerSaga].[dbo].MATTER a on a.MATTERID=c.MATTERID
left join sma_trn_cases on cassCaseNumber=MATTERNUMBER
left join sma_mst_orgcontacts on connlevelno=c.ENTITYID
left join sma_trn_courts on crtncaseid=casncaseid and connContactID=crtnCourtID
where b.CALENDARNUMBER <>'' and casnCaseID is not null and crtnPKCourtsID is not null

Alter table [sma_TRN_CourtDocket] Enable trigger all





INSERT INTO [sma_trn_caseJudgeorClerk]
([crtDocketID],[crtJudgeorClerkContactID],[crtJudgeorClerkContactCtgID],[crtJudgeorClerkRoleID],[crtJudgeorClerkCreatedBy],[crtJudgeorClerkCreatedDt],[crtJudgeorClerkModifiedBy],
[crtJudgeorClerkModifiedDt])
 
  Select distinct crdnCourtDocketID,cinnContactID,1,2,368,GETDATE(),null,null
  FROM [WilliamPagerSaga].[dbo].LW_COURT c
  left join WilliamPagerSaga.dbo.assign z on z.assignid=c.ASSIGNID
  left join WilliamPagerSaga.dbo.matrelt mat on mat.assignid=c.assignid 
  left join WilliamPagerSaga.dbo.assign a on a.assignid=mat.relatedassignid
  left join WilliamPagerSaga.dbo.matter m on m.MATTERID=a.MATTERID
  left join WilliamPagerSaga.dbo.entities e on e.ENTITYID=a.entityid
  left join sma_MST_IndvContacts on cinsGrade=e.ENTITYID
  left join sma_TRN_CaseS on cassCaseNumber=MATTERNUMBER
  left join sma_mst_orgcontacts on connLevelNo=z.ENTITYID
  left join sma_TRN_Courts on crtnCaseID=casnCaseID and crtnCourtID=connContactID
  left join sma_TRN_CourtDocket on crdnCourtsID=crtnPKCourtsID
  where  crdnCourtDocketID is not null and cinnContactID is not null --and crtnCaseID=6340
  
set ansi_warnings on

  INSERT INTO [sma_TRN_UDFValues]
  ([udvnUDFID],[udvsScreenName],[udvsUDFCtg],[udvnRelatedID],[udvnSubRelatedID],[udvsUDFValue],[udvnRecUserID],[udvdDtCreated],[udvnModifyUserID],[udvdDtModified],[udvnLevelNo])
  Select distinct 377,'','R',cinnContactID,1,PARTNUMBER,368,GETDATE(),null,null,''
  FROM [WilliamPagerSaga].[dbo].[LW_JUDGE] j
  left join [WilliamPagerSaga].[dbo].[ASSIGN] a on a.ENTITYID=j.ENTITYID
  left join [WilliamPagerSaga].[dbo].[erole] r on r.ROLEID=a.ROLEID
  left join [WilliamPagerSaga].[dbo].[ENTITIES] et on et.ENTITYID=j.ENTITYID
  left join [WilliamPagerSaga].[dbo].[matter] m on m.MATTERID=a.MATTERID
  left join sma_trn_cases on cassCaseNumber=m.MATTERNUMBER
  left join sma_TRN_Courts on crtnCaseID=casnCaseID
  left join sma_TRN_CourtDocket on crdnCourtsID=crtnPKCourtsID
  left join sma_MST_IndvContacts on cinsGrade=j.ENTITYID
  where DESCRIPTION like 'judge%' and crdnCourtDocketID is not null and ISNULL(PARTNUMBER,'')<>'' and cinnContactID is not null
  Union
  Select distinct 378,'','R',cinnContactID,1,ROOMNUMBER,368,GETDATE(),null,null,''
  FROM [WilliamPagerSaga].[dbo].[LW_JUDGE] j
  left join [WilliamPagerSaga].[dbo].[ASSIGN] a on a.ENTITYID=j.ENTITYID
  left join [WilliamPagerSaga].[dbo].[erole] r on r.ROLEID=a.ROLEID
  left join [WilliamPagerSaga].[dbo].[ENTITIES] et on et.ENTITYID=j.ENTITYID
  left join [WilliamPagerSaga].[dbo].[matter] m on m.MATTERID=a.MATTERID
  left join sma_trn_cases on cassCaseNumber=m.MATTERNUMBER
  left join sma_TRN_Courts on crtnCaseID=casnCaseID
  left join sma_TRN_CourtDocket on crdnCourtsID=crtnPKCourtsID
  left join sma_MST_IndvContacts on cinsGrade=j.ENTITYID
  where DESCRIPTION like 'judge%' and crdnCourtDocketID is not null and ISNULL(ROOMNUMBER,'')<>'' and cinnContactID is not null
  
  Alter table [sma_TRN_Notes] disable trigger all
  INSERT INTO [sma_TRN_Notes]
([notnCaseID],[notnNoteTypeID],[notmDescription],[notmPlainText],[notnContactCtgID],[notnContactId],[notsPriority],[notnFormID],[notnRecUserID],[notdDtCreated],[notnModifyUserID],[notdDtModified],[notnLevelNo],[notdDtInserted])
select distinct casnCaseID,nttnNoteTypeID,DESCRIPTION,DESCRIPTION+CHAR(13) +isnull(note,''),[1],[2],[3],[4],[9],[5],usrnUserID,DATEREVISED,[6],[7] from (
Select  0 as casncaseid,23 as nttnNoteTypeID,a.DESCRIPTION, convert(varchar(max),ltrim(replace(replace(replace(
       dbo.RegExReplace(a.NOTES,'({\\)(.+?)(})|(\\)(.+?)(\b)','')
      ,'}','')
      ,char(13),'')
      ,char(10),'')
      )) as Note,1 as [1],iz.cinnContactID as [2]
,'Normal' as [3],null as [4],case isnull((u1.usrnuserid),'') when '' then 368 else (u1.usrnuserid) end as [9],case (a.datecreated) when null then GETDATE() else (a.datecreated) end as [5],(u2.usrnuserid),(a.daterevised),'' as [6],
case (a.datecreated) when null then GETDATE() else (a.datecreated) end as [7]
FROM [WilliamPagerSaga].[dbo].[NOTE] a
Left Join [WilliamPagerSaga].[dbo].NTMATAS b on a.NOTEID=b.NOTEID
Left Join [WilliamPagerSaga].[dbo].[NOTETYPE] d on d.NOTETYPEID=a.NOTETYPEID
Left Join sma_MST_NoteTypes on nttsDscrptn=d.DESCRIPTION
left join sma_MST_IndvContacts e on e.cinsGrade=a.OTHERPARTYID
left join sma_MST_OrgContacts f on f.connLevelNo=a.OTHERPARTYID
left join sma_MST_IndvContacts l on l.cinsGrade=a.CREATORID
left join sma_mst_users u1 on u1.usrnContactID=l.cinnContactID
left join sma_MST_IndvContacts m on m.cinsGrade=a.REVISORID
left join sma_mst_users u2 on u2.usrnContactID=m.cinnContactID
left join [WilliamPagerSaga].[dbo].[LW_JUDGE] j on j.JUDGERULESNOTEID=a.NOTEID
left join [WilliamPagerSaga].[dbo].[ASSIGN] ass on ass.ENTITYID=j.ENTITYID
  left join [WilliamPagerSaga].[dbo].[erole] r on r.ROLEID=ass.ROLEID
  left join [WilliamPagerSaga].[dbo].[ENTITIES] et on et.ENTITYID=j.ENTITYID
  left join [WilliamPagerSaga].[dbo].[matter] ma on ma.MATTERID=ass.MATTERID
  left join sma_trn_cases on cassCaseNumber=ma.MATTERNUMBER
  left join sma_TRN_Courts on crtnCaseID=casnCaseID
  left join sma_TRN_CourtDocket on crdnCourtsID=crtnPKCourtsID
  left join sma_MST_IndvContacts iz on iz.cinsGrade=j.ENTITYID
where casnCaseID is not null and iz.cinnContactID is not null and  r.DESCRIPTION like 'judge%' and crdnCourtDocketID is not null and ISNULL(j.JUDGERULESNOTEID,'')<>'')a
  Alter table [sma_TRN_Notes] enable trigger all

  Alter table sma_MST_IndvContacts disable trigger all
  Update sma_MST_IndvContacts 
  set cinnContactTypeID=2
  where cinnContactID in (
  select distinct [crtJudgeorClerkContactID] from [sma_trn_caseJudgeorClerk])
  Alter table sma_MST_IndvContacts enable trigger all


go


INSERT INTO [sma_TRN_CourtDocket]
([crdnCourtsID],[crdnIndexTypeID],[crdnDocketNo],[crddDate],[crdnPrice],[crdsPayee],[crdsCheckNo],[crddCheckDt],[crdbActiveInActive],[crdsComments],[crdnRecUserID],[crddDtCreated],[crdnModifyUserID],[crddDtModified],[crdnLevelNo],[crdnDisbID],[crdnPayeeAddID],[crdnElcID],[crdsPayeeCtgID],[crdsEfile])
Select distinct crtnPKCourtsID,10,null,null,null,null,null,null,0,'',ISNULL(casnModifyUserID,casnRecUserID),ISNULL(casdDtModified,casdOpeningDate),null,null,null,null,null,null,null,0
From [WilliamPagerSaga].dbo.matter m
Left Join [WilliamPagerSaga].dbo.MRULASS mr on m.MATTERID=mr.MATTERID
Left join sma_trn_cases  on cassCaseNumber=m.MATTERNUMBER
left join sma_TRN_Courts on crtnCaseID=casnCaseID
left join sma_MST_IndvContacts on cinsGrade=judgeid
where JUDGEID is not null and casnCaseID is not null
and crtnCaseID is not null and NOt exists  (select * from [sma_TRN_CourtDocket] where crdnCourtsID=crtnPKCourtsID)

INSERT INTO [sma_trn_caseJudgeorClerk]
([crtDocketID],[crtJudgeorClerkContactID],[crtJudgeorClerkContactCtgID],[crtJudgeorClerkRoleID],[crtJudgeorClerkCreatedBy],[crtJudgeorClerkCreatedDt],[crtJudgeorClerkModifiedBy],
[crtJudgeorClerkModifiedDt])
 
   Select distinct crdnCourtDocketID,cinnContactID,1,2,368,GETDATE(),null,null
  FROM [WilliamPagerSaga].[dbo].LW_COURT c
  left join WilliamPagerSaga.dbo.assign z on z.assignid=c.ASSIGNID
  left join WilliamPagerSaga.dbo.matrelt mat on mat.assignid=c.assignid 
  left join WilliamPagerSaga.dbo.assign a on a.assignid=mat.relatedassignid
  left join WilliamPagerSaga.dbo.matter m on m.MATTERID=a.MATTERID
  left join WilliamPagerSaga.dbo.entities e on e.ENTITYID=a.entityid
  left join sma_MST_IndvContacts on cinsGrade=e.ENTITYID
  left join sma_TRN_CaseS on cassCaseNumber=MATTERNUMBER
  left join sma_mst_orgcontacts on connLevelNo=z.ENTITYID
  left join sma_TRN_Courts on crtnCaseID=casnCaseID and crtnCourtID=connContactID
  left join sma_TRN_CourtDocket on crdnCourtsID=crtnPKCourtsID
  where  crdnCourtDocketID is  null and cinnContactID is not null
  
  alter table sma_mst_indvcontacts enable trigger all