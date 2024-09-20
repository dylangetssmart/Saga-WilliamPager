set ansi_warnings off
Alter table sma_mst_subrole disable trigger all

delete from sma_mst_subrole where sbrnroleid=4
and sbrsdscrptn not like '(p%' and sbrnSubRoleId not in (select plnnrole from sma_TRN_Plaintiff)

Delete  from sma_mst_subrole where sbrnroleid=5
and sbrsdscrptn not like '(d%' and sbrnSubRoleId not in (select defnSubRole from sma_TRN_Defendants)

Alter table sma_mst_subrole enable trigger all



Delete from sma_MST_CaseSubType
where cstnGroupID>=1400 and  not exists (select casncasetypeid from sma_trn_cases where cstnCaseSubTypeID=casnCaseTypeID and cstnGroupID=casnOrgCaseTypeID)

truncate table sma_mst_casetypestatusstaff

INSERT INTO [dbo].[sma_MST_CaseTypeStatusStaff]
([csfnCaseTypeID]
,[csfnStatusTypeID]
,[csfnStatusID]
,[csfnStaffID]
,[csfnPriority]
,[csfnRoleID]
,[csfbSystemAssignYN]
,[csfnRecUserID]
,[csfdDtCreated]
,[csfnModifyUserID]
,[csfdDtModified]
,[csfnLevelNo])
Select cstncasetypeid,1,162,8,'',1,0,368,getdate(),null,null,''
from sma_mst_casetype

update sma_mst_casetype 
set cstnStatusID=162,cstnStatusTypeID=1



Alter table sma_TRN_Plaintiff disable trigger all
Update z
set plnnRole=sbrnSubRoleId
from sma_TRN_Plaintiff z
left join sma_trn_cases on casnCaseID=plnnCaseID
left join WilliamPagerSaga.dbo.MATTER m on m.MATTERNUMBER=cassCaseNumber
left join sma_MST_IndvContacts on cinnContactID=plnnContactID and plnnContactCtg=1
left join sma_mst_orgcontacts on connContactID=plnnContactID and plnnContactCtg=2
Left Join  [WilliamPagerSaga].dbo.ASSIGN a on m.MATTERID=a.MATTERID and case  plnnContactCtg when 1 then cinsGrade when 2 then connLevelNo end=a.ENTITYID
Left Join [WilliamPagerSaga].dbo.EROLE r on r.ROLEID=a.ROLEID
left join sma_MST_SubRole on sbrnCaseTypeID=casnOrgCaseTypeID and case when  DESCRIPTION like '%Guardian%' then 'Guardian' else replace(ltrim(rtrim(DESCRIPTION)),'Plaintiff - ','') end=REPLACE(ltrim(rtrim(sbrsDscrptn)),'(p)-','')
Where casnCaseID is not null and a.partytype=1
and sbrnSubRoleId is not null
Alter table sma_TRN_Plaintiff enable trigger all



alter table sma_trn_cases disable trigger all
update b
set casdClosingDate=cssdFromDate,casnStatusValueID=9
from sma_TRN_CaseStatus c left join sma_MST_CaseStatus cs on cs.cssnStatusID=c.cssnStatusID left join sma_trn_cases b on casnCaseID=cssnCaseID where cs.csssDescription='archived' and cs.cssnStatusTypeID=1
alter table sma_trn_cases enable trigger all


alter table sma_TRN_CaseStatus disable trigger all
update c
set cssnStatusID=9
from sma_TRN_CaseStatus c left join sma_MST_CaseStatus cs on cs.cssnStatusID=c.cssnStatusID left join sma_trn_cases b on casnCaseID=cssnCaseID where cs.csssDescription='archived' and cs.cssnStatusTypeID=1
alter table sma_TRN_CaseStatus enable trigger all

delete from sma_MST_CaseStatus
where csssDescription='archived'

INSERT INTO [sma_MST_CaseSubTypeCode]
([stcsDscrptn])
     
Select distinct cstsDscrptn from sma_MST_CaseSubType
 except
Select distinct [stcsDscrptn] from [sma_MST_CaseSubTypeCode]

Update a
set cstnTypeCode=stcncodeid
From sma_MST_CaseSubType a
left join [sma_MST_CaseSubTypeCode] on cstsDscrptn=[stcsDscrptn]
where cstnTypeCode is null

  Update a
  set sbrnTypeCode=srcnCodeId
  from sma_mst_subrole a
  left join [sma_mst_SubRoleCode] on sbrsDscrptn=srcsDscrptn
  where sbrnTypeCode is null
  
  Alter table sma_trn_cases disable trigger all
Update a
set casdIncidentDate=IncidentDate
from sma_trn_cases a
left join sma_TRN_Incidents on CaseId=casnCaseID
Alter table sma_trn_cases disable trigger all


Delete from [sma_MST_ContactTypesForContact] 
where ctcnContTypeContID not in (
select MIN(ctcnContTypeContID) from [dbo].[sma_MST_ContactTypesForContact]
group by ctcnContactCtgID,ctcnContactID,ctcnContactTypeID)


Declare @CaseTypID int
Select @CaseTypID=MAX(cstnGroupID) from sma_MST_CaseSubType
insert Into sma_MST_CaseSubType
([cstsCode],[cstnGroupID],[cstsDscrptn],[cstnRecUserId],[cstdDtCreated],[cstnModifyUserID],[cstdDtModified],[cstnLevelNo],[cstbDefualt],[saga],[cstnTypeCode])
Select distinct '',casnOrgCaseTypeID,cstsDscrptn,368,GETDATE(),null,null,'',0,'',cstnTypeCode
from sma_trn_cases
left join sma_MST_CaseSubType on cstnCaseSubTypeID=casnCaseTypeID
where casnOrgCaseTypeID >@CaseTypID

alter table sma_trn_cases disable trigger all
Update a
set casnCaseTypeID=cs2.cstnCaseSubTypeID
From  sma_trn_cases  a
left join sma_MST_CaseSubType cs1  on cs1.cstnCaseSubTypeID=casnCaseTypeID
left join sma_MST_CaseSubType cs2  on cs2.cstnGroupID=casnOrgCaseTypeID and cs1.cstsDscrptn =cs2.cstsDscrptn
where casnOrgCaseTypeID>=(select MIN(cstncasetypeid) from sma_MST_CaseType where cstdDtCreated >GETDATE()-1) 

delete from sma_MST_CaseSubType
where cstnCaseSubTypeID not in (select casncasetypeid from sma_trn_cases) and cstnGroupID>=1406
alter table sma_trn_cases enable trigger all


Delete from sma_mst_casegroup
where cgpncasegroupid not in (select distinct cstngroupid from sma_mst_casetype)

delete from sma_MST_CaseTypeCoCounsel
Delete from sma_mst_casetype where cstncasetypeid<(select MIN(cstncasetypeid) from sma_MST_CaseType where cstdDtCreated >GETDATE()-1)  and cstncasetypeid not in (select casnorgcasetypeid from sma_trn_cases)

Delete from sma_mst_casestatustype where stpnStatusTypeid not in (1,2)

Delete from sma_mst_casestatus where cssnstatustypeid<>1

Delete from sma_mst_casestatus where (cssnstatusid not in (select cssnstatusid from sma_trn_casestatus) or cssnstatusid not in (162,39,9)) and cssnstatusid <=799

delete from [sma_MST_CaseSubType] where cstnTypeCode is null
INSERT INTO [dbo].[sma_MST_CaseSubType]
([cstsCode],[cstnGroupID],[cstsDscrptn],[cstnRecUserId],[cstdDtCreated],[cstnModifyUserID],[cstdDtModified],[cstnLevelNo],[cstbDefualt],[saga],[cstnTypeCode])
select '',cstnCaseTypeID,stcsDscrptn,368,getdate(),null,null,'',1,'',stcnCodeId 
from sma_mst_casetype 
outer apply (select top 1 * from sma_MST_CaseSubTypeCode where stcsDscrptn like '%default%') a
where cstnCaseTypeID not in (
select cstnGroupID from sma_MST_CaseSubType )

Alter table sma_trn_cases disable trigger all
Update a 
set casnCaseTypeID=cstnCaseSubTypeID
from sma_trn_cases a
Outer apply(select top 1 cstnCaseSubTypeID from sma_mst_casesubtype where cstnGroupID=casnOrgCaseTypeID)z
where casnCaseTypeID is null
Alter table sma_trn_cases enable trigger all

alter table sma_TRN_InsuranceCoverage disable trigger all
UPDATE sma_TRN_InsuranceCoverage
SET incnInsured = (SELECT MIN(a.UniqueContactId)
   FROM sma_MST_AllContactInfo a
   WHERE a.AddressId = incnInsured)



			  alter table sma_TRN_InsuranceCoverage enable trigger all

alter table sma_TRN_InsuranceCoverage disable trigger all
delete from sma_TRN_InsuranceCoverage where incsPlaintiffOrDef='d' 
and incnPlaintiffIDOrDefendantID not in (select defnDefendentID from sma_TRN_Defendants)
alter table sma_TRN_InsuranceCoverage enable trigger all
go
go
 select distinct case when (connLevelNo) is not null then  (connLevelNo) else (cinsgrade) end as Entity,caseid into #tmpAllCaseContact from sma_VU_AllCaseContact
 left join sma_MST_IndvContacts on cinnContactID=casecontactid and CaseContactCategoryID=1
 left join sma_MST_OrgContacts on connContactID=casecontactid and CaseContactCategoryID=2
 where  isnull(case when (connLevelNo) is not null then  (connLevelNo) else (cinsgrade) end,1)<>1 and caseid is not null
 go
INSERT INTO [dbo].[sma_TRN_CaseContactComment]
([CaseContactCaseID],[CaseRelContactID],[CaseRelContactCtgID],[CaseContactComment],[CaseContactCreaatedBy],[CaseContactCreateddt],[caseContactModifyBy],[CaseContactModifiedDt])
select distinct casncaseid,case when connLevelNo is not null then connContactID else cinnContactID end,case when connLevelNo is not null then 2 else 1 end
,'',368,getdate(),null,null
 from [WilliamPagerSaga].dbo.ASSIGN a
left join [WilliamPagerSaga].dbo.EROLE r on r.ROLEID=a.roleid
left join [WilliamPagerSaga].dbo.matter m on m.MATTERID=a.MATTERID
left join sma_trn_cases on cassCaseNumber=matternumber
left join sma_mst_indvcontacts on a.ENTITYID=cinsGrade
left join sma_mst_orgcontacts on a.ENTITYID=connLevelNo
where a.ENTITYID not in (select Entity from #tmpAllCaseContact where caseid=casnCaseID)
and (case when connLevelNo is not null then connContactID else cinsGrade end is not null)
and casnCaseID is not null
go
INSERT INTO [dbo].[sma_MST_OtherCasesContact]
([OtherCasesID],[OtherCasesContactID],[OtherCasesContactCtgID],[OtherCaseContactAddressID],[OtherCasesContactRole],[OtherCasesCreatedUserID],[OtherCasesContactCreatedDt],[OtherCasesModifyUserID]
,[OtherCasesContactModifieddt])
select distinct casncaseid,case when connLevelNo is not null then connContactID else cinnContactID end,case when connLevelNo is not null then 2 else 1 end,null
,r.DESCRIPTION,368,getdate(),null,null
 from [WilliamPagerSaga].dbo.ASSIGN a
left join [WilliamPagerSaga].dbo.EROLE r on r.ROLEID=a.roleid
left join [WilliamPagerSaga].dbo.matter m on m.MATTERID=a.MATTERID
left join sma_trn_cases on cassCaseNumber=matternumber
left join sma_mst_indvcontacts on a.ENTITYID=cinsGrade
left join sma_mst_orgcontacts on a.ENTITYID=connLevelNo
where a.ENTITYID not in (select Entity from #tmpAllCaseContact where caseid=casnCaseID)
and (case when connLevelNo is not null then connContactID else cinsGrade end is not null)
go
drop table #tmpAllCaseContact     

go

alter table [sma_MST_RelContacts] disable trigger all
INSERT INTO [dbo].[sma_MST_RelContacts]
([rlcnPrimaryCtgID],[rlcnPrimaryContactID],[rlcnPrimaryAddressID],[rlcnRelCtgID],[rlcnRelContactID],[rlcnRelAddressID],[rlcnRelTypeID],[rlcnRecUserID],[rlcdDtCreated]
,[rlcnModifyUserID],[rlcdDtModified],[rlcnLevelNo],[rlcsBizFam],[rlcnOrgTypeID])
Select distinct case when i1.cinnContactID is not null then 1 when o1.connContactID is not null then 2 end,
case when i1.cinnContactID is not null then i1.cinnContactID when o1.connContactID is not null then o1.connContactID end,
case when i1.cinnContactID is not null then z.IndvAddressID when o1.connContactID is not null then z1.orgAddressID end,
case when i2.cinnContactID is not null then 1 when o2.connContactID is not null then 2 end,
case when i2.cinnContactID is not null then i2.cinnContactID when o2.connContactID is not null then o2.connContactID end,
case when i2.cinnContactID is not null then z2.IndvAddressID when o2.connContactID is not null then z3.orgAddressID end,26,368,getdate(),null,null,'',null,null
From WilliamPagerSaga.dbo.ENTITIES e --ll
left join sma_MST_IndvContacts i1 on i1.cinsGrade=e.ENTITYID
left join sma_MST_orgContacts o1 on o1.connLevelNo=e.ENTITYID
outer apply(select top 1 addnaddressid as IndvAddressID from  sma_MST_Address where addnContactID=i1.cinncontactid and addnContactCtgID=1 order by isnull(addbPrimary,0) desc) z
outer apply(select top 1 addnaddressid as orgAddressID from  sma_MST_Address where addnContactID=o1.conncontactid and addnContactCtgID=2 order by isnull(addbPrimary,0) desc) z1
left join sma_MST_IndvContacts i2 on i2.cinsGrade=e.SUPERIORID
left join sma_MST_orgContacts o2 on o2.connLevelNo=e.SUPERIORID
outer apply(select top 1 addnaddressid as IndvAddressID from  sma_MST_Address where addnContactID=i2.cinncontactid and addnContactCtgID=1 order by isnull(addbPrimary,0) desc) z2
outer apply(select top 1 addnaddressid as orgAddressID from  sma_MST_Address where addnContactID=o2.conncontactid and addnContactCtgID=2 order by isnull(addbPrimary,0) desc) z3
where SUPERIORID is not null
and case when i2.cinnContactID is not null then 1 when o2.connContactID is not null then 2 end is not null
go
INSERT INTO [dbo].[sma_MST_RelContacts]
([rlcnPrimaryCtgID],[rlcnPrimaryContactID],[rlcnPrimaryAddressID],[rlcnRelCtgID],[rlcnRelContactID],[rlcnRelAddressID],[rlcnRelTypeID],[rlcnRecUserID],[rlcdDtCreated]
,[rlcnModifyUserID],[rlcdDtModified],[rlcnLevelNo],[rlcsBizFam],[rlcnOrgTypeID])
Select [rlcnRelCtgID]
      ,[rlcnRelContactID]
      ,[rlcnRelAddressID]
	  ,[rlcnPrimaryCtgID]
      ,[rlcnPrimaryContactID]
      ,[rlcnPrimaryAddressID]      
      ,[rlcnRelTypeID]
      ,[rlcnRecUserID]
      ,[rlcdDtCreated]
      ,[rlcnModifyUserID]
      ,[rlcdDtModified]
      ,[rlcnLevelNo]
      ,[rlcsBizFam]
      ,[rlcnOrgTypeID]
	  From [sma_MST_RelContacts]
go
go
update [sma_MST_RelContacts]
set [rlcnRelTypeID]=case when [rlcnPrimaryCtgID]=1 and [rlcnRelCtgID]=2 then 2  when [rlcnPrimaryCtgID]=2 and [rlcnRelCtgID]=1 then 1 else 26 end
go
alter table [sma_MST_RelContacts] enable trigger all


go
go
select distinct plnnPlaintiffID,sb1.sbrnSubRoleId as bb1,sb2.sbrnSubRoleId as sb2,plnnRole,sb1.sbrsDscrptn as sb1ds,sb2.sbrsDscrptn as sb2ds 
into #tmpplntf
from sma_TRN_Plaintiff
left join sma_trn_cases on casnCaseID=plnnCaseID
left join sma_MST_CaseType on cstnCaseTypeID=casnOrgCaseTypeID
left join sma_mst_subrole sb1 on sb1.sbrnSubRoleId=plnnRole 
left join sma_mst_subrole sb2 on sb2.sbrnCaseTypeID=cstnCaseTypeID and sb2.sbrsDscrptn=sb1.sbrsDscrptn and sb2.sbrnRoleID=4
where sb1.sbrnSubRoleId<>sb2.sbrnSubRoleId 

Alter table sma_trn_plaintiff disable trigger all
Update a
set plnnRole=sb2,plnnPlaintiffRole=sb2
from sma_TRN_Plaintiff a
join #tmpplntf p on p.plnnPlaintiffID=a.plnnPlaintiffID
where p.plnnPlaintiffID=a.plnnPlaintiffID 
Alter table sma_trn_plaintiff enable trigger all

drop table #tmpplntf

go
select distinct defnDefendentID,sb1.sbrnSubRoleId as bb1,sb2.sbrnSubRoleId as sb2,defnSubRole,sb1.sbrsDscrptn as sb1ds,sb2.sbrsDscrptn as sb2ds 
into #tmpdef
from sma_TRN_Defendants
left join sma_trn_cases on casnCaseID=defnCaseID
left join sma_MST_CaseType on cstnCaseTypeID=casnOrgCaseTypeID
left join sma_mst_subrole sb1 on sb1.sbrnSubRoleId=defnSubRole 
left join sma_mst_subrole sb2 on sb2.sbrnCaseTypeID=cstnCaseTypeID and sb2.sbrsDscrptn=sb1.sbrsDscrptn and sb2.sbrnRoleID=5
where sb1.sbrnSubRoleId<>sb2.sbrnSubRoleId 

Alter table sma_TRN_Defendants disable trigger all
Update a
set defnSubRole=sb2
from sma_TRN_Defendants a
join #tmpdef p on p.defnDefendentID=a.defnDefendentID
where p.defnDefendentID=a.defnDefendentID 
Alter table sma_TRN_Defendants enable trigger all

drop table #tmpdef
go

alter table sma_TRN_SOLs disable trigger all
Update a 
set solnSOLTypeID=sldnSOLDetID
from sma_TRN_SOLs a
left join sma_TRN_CaseS on casnCaseID=solnCaseID
outer apply(select top 1 sldnSOLDetID from sma_MST_SOLDetails where sldnCaseTypeID=casnOrgCaseTypeID and sldsSOLName='No Fault' )z
where solnSOLTypeID is null and solsComments like '%no fault%'
alter table sma_TRN_SOLs enable trigger all
go
alter table sma_TRN_CaseS disable trigger all
update sma_TRN_CaseS
set casdClosingDate =null where casnCaseID in (
select cssnCaseID from sma_TRN_CaseStatus where cssdToDt is null and cssnStatusID <>9
and cssnCaseID in (select casnCaseID from sma_TRN_CaseS where casdClosingDate is not null))
alter table sma_TRN_CaseS enable trigger all

go
set identity_insert sma_mst_casestatustype on
insert into sma_mst_casestatustype([stpnStatusTypeID]
      ,[stpsCode]
      ,[stpsStatusType]
      ,[stpnRecUserID]
      ,[stpdDtCreated]
      ,[stpnModifyUserID]
      ,[stpdDtModified]
      ,[stpnLevelNo])
      
      select 21,'M1','M1',368,GETDATE(),null,null,1
      union
      select 22,'M2','M2',368,GETDATE(),null,null,1
      union
      select 23,'M3','M3',368,GETDATE(),null,null,1
      
      go
      
alter table sma_TRN_CaseS disable trigger all
update a
set casdClosingDate=cssdFromDate
 from sma_TRN_CaseS a
left join sma_TRN_CaseStatus on cssnCaseID=casnCaseID
where casnStatusValueID=9 and casdClosingDate is null and cssdToDt is null and cssnStatusTypeID=1
alter table sma_TRN_CaseS enable trigger all
go

insert into sma_MST_CaseStatus
select distinct '',description,21,null,NULL,368,GETDATE(),NULL,NULL,NULL,NULL,NULL,NULL,NULL
 from WilliamPagerSaga.dbo.MATTER a
left join WilliamPagerSaga.dbo.[LW_A_MATTERGROUP] b on a.MATTERGROUP1ID=b.MATTERGROUPID
where a.MATTERGROUP1ID is not null and 
not exists (select * from sma_MST_CaseStatus where csssDescription =DESCRIPTION and cssnStatusTypeID=21)

insert into sma_MST_CaseStatus
select distinct '',description,22,NULL,null,368,GETDATE(),NULL,NULL,NULL,NULL,NULL,NULL,NULL
 from WilliamPagerSaga.dbo.MATTER a
left join WilliamPagerSaga.dbo.[LW_A_MATTERGROUP] b on a.MATTERGROUP2ID=b.MATTERGROUPID
where a.MATTERGROUP2ID is not null
and not exists (select * from sma_MST_CaseStatus where csssDescription =DESCRIPTION and cssnStatusTypeID=22)

insert into sma_MST_CaseStatus
select distinct '',description,23,NULL,null,368,GETDATE(),NULL,NULL,NULL,NULL,NULL,NULL,NULL
 from WilliamPagerSaga.dbo.MATTER a
left join WilliamPagerSaga.dbo.[LW_A_MATTERGROUP] b on a.MATTERGROUP3ID=b.MATTERGROUPID
where a.MATTERGROUP3ID is not null
and not exists (select * from sma_MST_CaseStatus where csssDescription =DESCRIPTION and cssnStatusTypeID=23)

go
insert into sma_TRN_CaseStatus
select distinct casncaseid,21,cssnstatusid,null,GETDATE(),null,case when a.MATTERGROUP1DATE IS not null then 'MatterGroup1Date: '+convert(varchar(10),MATTERGROUP1DATE,101) else '' end,368,GETDATE(),NULL,NULL,NULL,NULL
from WilliamPagerSaga.dbo.MATTER a
left join WilliamPagerSaga.dbo.[LW_A_MATTERGROUP] b on a.MATTERGROUP1ID=b.MATTERGROUPID
left join sma_trn_cases on cassCaseNumber=MATTERNUMBER
left join sma_MST_CaseStatus on csssDescription=DESCRIPTION and cssnStatusTypeID=21
where a.MATTERGROUP1ID is not null

insert into sma_TRN_CaseStatus
select distinct casncaseid,22,cssnstatusid,null,GETDATE(),null,case when a.MATTERGROUP2DATE IS not null then 'MatterGroup2Date: '+convert(varchar(10),MATTERGROUP2DATE,101) else '' end,368,GETDATE(),NULL,NULL,NULL,NULL
from WilliamPagerSaga.dbo.MATTER a
left join WilliamPagerSaga.dbo.[LW_A_MATTERGROUP] b on a.MATTERGROUP2ID=b.MATTERGROUPID
left join sma_trn_cases on cassCaseNumber=MATTERNUMBER
left join sma_MST_CaseStatus on csssDescription=DESCRIPTION and cssnStatusTypeID=22
where a.MATTERGROUP2ID is not null

insert into sma_TRN_CaseStatus
select distinct casncaseid,23,cssnstatusid,null,GETDATE(),null,case when a.MATTERGROUP3DATE IS not null then 'MatterGroup3Date: '+convert(varchar(10),MATTERGROUP3DATE,101) else '' end,368,GETDATE(),NULL,NULL,NULL,NULL
from WilliamPagerSaga.dbo.MATTER a
left join WilliamPagerSaga.dbo.[LW_A_MATTERGROUP] b on a.MATTERGROUP3ID=b.MATTERGROUPID
left join sma_trn_cases on cassCaseNumber=MATTERNUMBER
left join sma_MST_CaseStatus on csssDescription=DESCRIPTION and cssnStatusTypeID=23
where a.MATTERGROUP3ID is not null

go
update sma_mst_users set usrnFirmRoleID=21862,usrnFirmTitleID=21866 where usrnUserID=368

insert into Account_UsersInRoles

select usrnUserID,2 from sma_mst_users where usrnUserID not in (
select user_id from Account_UsersInRoles)
go
delete from sma_MST_AllContactInfo
go
--insert org contacts

INSERT INTO [dbo].[sma_MST_AllContactInfo]
           ([UniqueContactId]
           ,[ContactId]
           ,[ContactCtg]
           ,[Name]
,[NameForLetters]
           ,[FirstName]
           ,[LastName]
           ,[AddressId]
           ,[Address1]
           ,[Address2]
           ,[Address3]
           ,[City]
           ,[State]
           ,[Zip]
           ,[ContactNumber]
           ,[ContactEmail]
           ,[ContactTypeId]
           ,[ContactType]
           ,[Comments]
           ,[DateModified]
           ,[ModifyUserId]
           ,[IsDeleted])
     
	 SELECT convert(bigint, ('2' + convert(varchar(30),sma_MST_OrgContacts.connContactID))) as UniqueContactId,
			 convert(bigint,sma_MST_OrgContacts.connContactID) as ContactId,
			 2 as ContactCtg ,
			 sma_MST_OrgContacts.consName as Name,
			sma_MST_OrgContacts.consName,
			 null as FirstName,
			 null as LastName, 
			 null as AddressId,
			 null as Address1,
			 null as Address2,
			 null as Address3,
			 null as City,
			 null as State,
			 null as Zip,
			 null as ContactNumber,
			 null as ContactEmail,
			 sma_MST_OrgContacts.connContactTypeID as ContactTypeId,
			 sma_MST_OriginalContactTypes.octsDscrptn as ContactType,
			 sma_MST_OrgContacts.consComments as Comments, 
			 GetDate() as DateModified,
			 347 as ModifyUserId,
			 0 as IsDeleted
	 FROM sma_MST_OrgContacts
	 left join sma_MST_OriginalContactTypes on sma_MST_OriginalContactTypes.octnOrigContactTypeID = sma_MST_OrgContacts.connContactTypeID
GO
--insert individual contacts

INSERT INTO [dbo].[sma_MST_AllContactInfo]
           ([UniqueContactId]
           ,[ContactId]
           ,[ContactCtg]
           ,[Name]
           ,[NameForLetters]
           ,[FirstName]
           ,[LastName]
           ,[AddressId]
           ,[Address1]
           ,[Address2]
           ,[Address3]
           ,[City]
           ,[State]
           ,[Zip]
           ,[ContactNumber]
           ,[ContactEmail]
           ,[ContactTypeId]
           ,[ContactType]
           ,[Comments]
           ,[DateModified]
           ,[ModifyUserId]
           ,[IsDeleted]
	,[DateOfBirth],
[SSNNo] )
     
	 SELECT convert(bigint, ('1' + convert(varchar(30),sma_MST_IndvContacts.cinnContactID))) as UniqueContactId,
			 convert(bigint,sma_MST_IndvContacts.cinnContactID) as ContactId,
			 1 as ContactCtg ,
			  CASE ISNULL(cinsLastName,'') WHEN  '' THEN '' ELSE cinsLastName + ', ' END +
				CASE ISNULL([cinsFirstName],'') WHEN '' THEN '' ELSE [cinsFirstName] END 
				+ CASE ISNULL(cinsMiddleName, '') WHEN '' THEN '' ELSE  ' ' + SUBSTRING(cinsMiddleName, 1, 1) + '.' END 
				+ CASE ISNULL(cinsSuffix, '') WHEN '' THEN '' ELSE  ', ' + cinsSuffix END   as Name,
			CASE ISNULL([cinsFirstName],'') WHEN '' THEN '' ELSE [cinsFirstName] END 
			+  CASE ISNULL(cinsMiddleName, '') WHEN '' THEN '' ELSE  ' ' + SUBSTRING(cinsMiddleName, 1, 1) + '.' END 
			+ CASE ISNULL(cinsLastName,'') WHEN '' THEN '' ELSE ' ' + cinsLastName END 
			+ CASE ISNULL(cinsSuffix, '') WHEN '' THEN '' ELSE ', ' + cinsSuffix END AS [NameForLetters],

			 isnull(sma_MST_IndvContacts.cinsFirstName, '') as FirstName,
			 isnull(sma_MST_IndvContacts.cinsLastName, '') as LastName,
			 null as AddressId,
			 null as Address1,
			 null as Address2,
			 null as Address3,
			 null as City,
			 null as State,
			 null as Zip,
			 null as ContactNumber,
			 null as ContactEmail,
			 sma_MST_IndvContacts.cinnContactTypeID as ContactTypeId,
			 sma_MST_OriginalContactTypes.octsDscrptn as ContactType,
			 sma_MST_IndvContacts.cinsComments as Comments, 
			 GetDate() as DateModified,
			 347 as ModifyUserId,
			 0 as IsDeleted,
			[cindBirthDate],
			[cinsSSNNo]
	 FROM sma_MST_IndvContacts
	 left join sma_MST_OriginalContactTypes on sma_MST_OriginalContactTypes.octnOrigContactTypeID = sma_MST_IndvContacts.cinnContactTypeID

GO
--fill out address information for all contact types
UPDATE [dbo].[sma_MST_AllContactInfo]
   SET [AddressId] = Addrr.addnAddressID
      ,[Address1] = Addrr.addsAddress1
      ,[Address2] = Addrr.addsAddress2
      ,[Address3] = Addrr.addsAddress3
      ,[City] = Addrr.addsCity
      ,[State] = Addrr.addsStateCode
      ,[Zip] = Addrr.addsZip
 FROM
    sma_MST_AllContactInfo AllInfo
INNER JOIN sma_MST_Address Addrr ON (AllInfo.ContactId = Addrr.addnContactID)  AND (AllInfo.ContactCtg = Addrr.addnContactCtgID) 
GO

--fill out address information for all contact types, overwriting with primary addresses
UPDATE [dbo].[sma_MST_AllContactInfo]
   SET [AddressId] = Addrr.addnAddressID
      ,[Address1] = Addrr.addsAddress1
      ,[Address2] = Addrr.addsAddress2
      ,[Address3] = Addrr.addsAddress3
      ,[City] = Addrr.addsCity
      ,[State] = Addrr.addsStateCode
      ,[Zip] = Addrr.addsZip
 FROM
    sma_MST_AllContactInfo AllInfo
INNER JOIN sma_MST_Address Addrr ON (AllInfo.ContactId = Addrr.addnContactID)  AND (AllInfo.ContactCtg = Addrr.addnContactCtgID) AND Addrr.addbPrimary = 1
GO
--fill out email information
UPDATE [dbo].[sma_MST_AllContactInfo]
   SET [ContactEmail] = Email.cewsEmailWebSite
  FROM
    sma_MST_AllContactInfo AllInfo
INNER JOIN sma_MST_EmailWebsite Email ON (AllInfo.ContactId = Email.cewnContactID)  AND (AllInfo.ContactCtg = Email.cewnContactCtgID) AND Email.cewsEmailWebsiteFlag = 'E' 
GO

--fill out default email information
UPDATE [dbo].[sma_MST_AllContactInfo]
   SET [ContactEmail] = Email.cewsEmailWebSite
  FROM
    sma_MST_AllContactInfo AllInfo
INNER JOIN sma_MST_EmailWebsite Email ON (AllInfo.ContactId = Email.cewnContactID)  AND (AllInfo.ContactCtg = Email.cewnContactCtgID) AND Email.cewsEmailWebsiteFlag = 'E' AND Email.cewbDefault = 1
GO
--fill out phone information
UPDATE [dbo].[sma_MST_AllContactInfo]
   SET ContactNumber = Phones.cnnsContactNumber + (CASE WHEN Phones.[cnnsExtension] IS NULL THEN '' WHEN Phones.[cnnsExtension] = '' THEN '' ELSE ' x' + Phones.[cnnsExtension] + '' END) 
  FROM
    sma_MST_AllContactInfo AllInfo
INNER JOIN sma_MST_ContactNumbers Phones ON (AllInfo.ContactId = Phones.cnnnContactID)  AND (AllInfo.ContactCtg = Phones.cnnnContactCtgID) 
GO

--fill out default phone information
UPDATE [dbo].[sma_MST_AllContactInfo]
   SET ContactNumber = Phones.cnnsContactNumber+ (CASE WHEN Phones.[cnnsExtension] IS NULL THEN '' WHEN Phones.[cnnsExtension] = '' THEN '' ELSE ' x' + Phones.[cnnsExtension] + '' END) 
  FROM
    sma_MST_AllContactInfo AllInfo
INNER JOIN sma_MST_ContactNumbers Phones ON (AllInfo.ContactId = Phones.cnnnContactID)  AND (AllInfo.ContactCtg = Phones.cnnnContactCtgID)  AND Phones.cnnbPrimary = 1
GO
delete from Account_UsersInRoles
where user_id<>368

insert into Account_UsersInRoles
select usrnuserid,2 from sma_MST_Users
where usrnUserID<>368

update sma_MST_Users
set usrnFirmRoleID=(select usrnFirmRoleID from sma_MST_Users where usrnUserID=368)
, usrnFirmTitleID=(select usrnFirmTitleID from sma_MST_Users where usrnUserID=368)
where usrnUserID<>368
go
delete from sma_MST_CaseGroup
where not exists(select * from sma_MST_CaseType where cstnGroupID=cgpnCaseGroupID)
go
go
if object_id('RemoveInvalidXMLCharacters','FN')is not null
drop function [RemoveInvalidXMLCharacters]
GO
/****** Object:  UserDefinedFunction [dbo].[RemoveInvalidXMLCharacters]    Script Date: 12/23/2015 11:15:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create FUNCTION [dbo].[RemoveInvalidXMLCharacters] (@InputString VARCHAR(MAX))
RETURNS VARCHAR(MAX)
AS
BEGIN
    IF @InputString IS NOT NULL
    BEGIN
      DECLARE @Counter INT, @TestString NVARCHAR(40)

      SET @TestString = '%[' + NCHAR(0) + NCHAR(1) + NCHAR(2) + NCHAR(3) + NCHAR(4) + NCHAR(5) + NCHAR(6) + NCHAR(7) + NCHAR(8) + NCHAR(11) + NCHAR(12) + NCHAR(14) + NCHAR(15) + NCHAR(16) + NCHAR(17) + NCHAR(18) + NCHAR(19) + NCHAR(20) + NCHAR(21) + NCHAR(22) + NCHAR(23) + NCHAR(24) + NCHAR(25) + NCHAR(26) + NCHAR(27) + NCHAR(28) + NCHAR(29) + NCHAR(30) + NCHAR(31) + ']%'

      SELECT @Counter = PATINDEX (@TestString, @InputString COLLATE Latin1_General_BIN)

      WHILE @Counter <> 0
      BEGIN
        SELECT @InputString = STUFF(@InputString, @Counter, 1, ' ')
        SELECT @Counter = PATINDEX (@TestString, @InputString COLLATE Latin1_General_BIN)
      END
    END
    RETURN(@InputString)
END
go
alter table sma_trn_incidents disable trigger all
update sma_trn_incidents set IncidentFacts=dbo.[RemoveInvalidXMLCharacters](isnull(IncidentFacts,'')),MergedFacts=dbo.[RemoveInvalidXMLCharacters](isnull(MergedFacts,'')),Comments=dbo.[RemoveInvalidXMLCharacters](isnull(Comments,''))
alter table sma_trn_incidents enable trigger all
go