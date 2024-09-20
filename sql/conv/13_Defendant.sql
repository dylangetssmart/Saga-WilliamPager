set ansi_warnings off
Declare @RoleID int 

Select @RoleID = MAX(sbrnsubroleid) from sma_MST_SubRole

INSERT INTO [sma_mst_SubRoleCode]
([srcsDscrptn],[srcnRoleID])
Select distinct LTRIM(RTRIM(r.DESCRIPTION)),5 from WilliamPagerSaga.dbo.EROLE r
join WilliamPagerSaga.dbo.ASSIGN a on a.ROLEID=r.ROLEID
where PARTYTYPE=2 and LTRIM(RTRIM(r.DESCRIPTION)) not in (select LTRIM(RTRIM([srcsDscrptn])) from [sma_mst_SubRoleCode] where [srcnRoleID]=5)

INSERT INTO [sma_MST_SubRole]
([sbrsCode],[sbrnRoleID],[sbrsDscrptn],[sbrnCaseTypeID],[sbrnPriority],[sbrnRecUserID],[sbrdDtCreated],[sbrnModifyUserID],[sbrdDtModified],[sbrnLevelNo],[sbrbDefualt],[saga],sbrnTypeCode)
Select distinct '',5,substring(srcsDscrptn,0,50),cstnCaseTypeID,'',368,GETDATE(),null,null,'',null,'',srcnCodeId
from [WilliamPagerSaga].[dbo].[LAWTYPE] c
Left Join sma_MST_CaseType on cstsType=c.DESCRIPTION
cross join [sma_mst_SubRoleCode]
where srcsDscrptn in (Select distinct LTRIM(RTRIM(r.DESCRIPTION)) from WilliamPagerSaga.dbo.EROLE r
join WilliamPagerSaga.dbo.ASSIGN a on a.ROLEID=r.ROLEID
where PARTYTYPE=2)

alter table sma_trn_defendants disable trigger all

INSERT INTO [sma_TRN_Defendants]
([defnCaseID],[defnContactCtgID],[defnContactID],[defnAddressID],[defnSubRole],[defbIsPrimary],[defbCounterClaim],[defbThirdParty],[defsThirdPartyRole],[defnPriority],[defdFrmDt],[defdToDt],[defnRecUserID],
[defdDtCreated],[defnModifyUserID],[defdDtModified],[defnLevelNo],[defsMarked],[saga],defsComments)  
Select casnCaseID,case when (isnull(cinncontactid,''))<>'' then (cinnContactCtg) when (isnull(conncontactid,''))<>'' then (connContactCtg) else 1 end ,
case when (isnull(cinncontactid,''))<>'' then (cinnContactID) when (isnull(conncontactid,''))<>'' then (connContactID) else 11 end,
case when (isnull(cinncontactid,''))<>'' then (d.addnaddressid) when (isnull(conncontactid,''))<>'' then (e.addnaddressid) else 3 end,
(sbrnSubRoleId),0,0,0,substring((z.DESCRIPTION),0,30),0,(casdDtCreated),null,(casnRecUserID),(casdDtCreated),(casnModifyUserID),(casdDtModified),null,null,null,
 convert(varchar(max),ltrim(replace(
       dbo.RegExReplace(n.NOTES,'({\\)(.+?)(})|(\\)(.+?)(\b)','')
      ,'}','')
     
      )) 
FROM [WilliamPagerSaga].[dbo].ASSIGN a
left join [WilliamPagerSaga].[dbo].[Matter] b on b.MATTERID=a.MATTERID
left join [WilliamPagerSaga].[dbo].[erole] z on z.roleid=a.ROLEID
left join [WilliamPagerSaga].[dbo].note n on n.noteid=a.NOTEID
left join sma_trn_cases on cassCaseNumber=MATTERNUMBER
left join  sma_MST_IndvContacts i1 on LTRIM(rtrim(i1.cinsGrade))=a.ENTITYID
left join  sma_MST_OrgContacts o1 on LTRIM(rtrim(o1.connLevelNo))=a.ENTITYID
left join sma_MST_Address d on d.addnContactID=cinncontactid and d.addnContactCtgID=1 and d.addbPrimary=1
left join sma_MST_Address e on e.addnContactID=cinncontactid and e.addnContactCtgID=1 and e.addbPrimary=1
--outer apply(select top 1 addnaddressid as orgAddressID from  sma_MST_Address where addnContactID=conncontactid and addnContactCtgID=2 order by isnull(addbPrimary,0) desc) e
--outer apply(select top 1 sbrnSubRoleId from  sma_MST_SubRole where sbrnCaseTypeID=casnOrgCaseTypeID and sbrnRoleId=5  order by isnull(sbrbDefualt,0) desc) c
--left join sma_MST_SubRole on sbrnCaseTypeID=casnOrgCaseTypeID and sbrnRoleId=5 and sbrsdscrptn like '%(D)-Owner/Operator%'
left join [sma_mst_SubRoleCode] on [srcsDscrptn]=z.DESCRIPTION
outer apply(select top 1 sbrnSubRoleId from  sma_MST_SubRole where sbrnCaseTypeID=casnOrgCaseTypeID and sbrnRoleId=5 and sbrsDscrptn=z.DESCRIPTION ) c
Where casnCaseID is not null  and a.PARTYTYPE=2
--and z.DESCRIPTION like '%defenda%' and z.DESCRIPTION not like '%carrier%' and z.DESCRIPTION not like '%insured%' and z.DESCRIPTION not like '%adjuster%' and z.DESCRIPTION not like '%attorney%'

INSERT INTO [sma_TRN_Defendants]
([defnCaseID],[defnContactCtgID],[defnContactID],[defnAddressID],[defnSubRole],[defbIsPrimary],[defbCounterClaim],[defbThirdParty],[defsThirdPartyRole],[defnPriority],[defdFrmDt],[defdToDt],[defnRecUserID],
[defdDtCreated],[defnModifyUserID],[defdDtModified],[defnLevelNo],[defsMarked],[saga])  
Select casnCaseID, 1 ,
9,
2,
(sbrnSubRoleId),1,0,0,null,0,getdate(),null,368,getdate(),null,null,null,null,null
from sma_trn_cases
outer apply(select top 1 sbrnSubRoleId from  sma_MST_SubRole where sbrnCaseTypeID=casnOrgCaseTypeID and sbrnRoleId=5  order by isnull(sbrbDefualt,0) desc) c
where casncaseid not in (select defncaseid from sma_trn_defendants )

Update sma_TRN_Defendants 
set defbIsPrimary=1
where defnDefendentID in (
select MIN(defnDefendentID) from sma_TRN_Defendants
where defnCaseID in (
select defnCaseID from sma_TRN_Defendants
Except
select defnCaseID from sma_TRN_Defendants where defbIsPrimary=1)
Group by defnCaseID)
alter table sma_trn_defendants enable trigger all

Alter table sma_MST_SubRole disable trigger all
Delete from sma_MST_SubRole 
where sbrnSubRoleId not in (select defnSubRole from sma_TRN_Defendants left join sma_TRN_CaseS on casnCaseID=defnCaseID left join sma_MST_CaseType on cstnCaseTypeID=casnOrgCaseTypeID where cstnCaseTypeID=casnOrgCaseTypeID and cstnCaseTypeID=sbrnCaseTypeID )
and sbrnRoleID=5 and sbrnSubRoleId>@RoleID
Alter table sma_MST_SubRole enable trigger all

go
INSERT INTO [sma_MST_SOLDetails]
([sldnSOLTypeID],[sldnCaseTypeID],[sldnDefRole],[sldnStateID],[sldnYears],[sldnMonths],[sldnDays],[sldnSOLDays],[sldnRecUserID]
,[slddDtCreated],[sldnModifyUserID],[slddDtModified],[sldnLevelNo],[sldsDorP],[sldsSOLName],[sldbIsIncidDtEffect],[sldbDefualt])
Select 16,cstnCaseTypeID,sbrnSubRoleId,stcnStateID,1,0,0,0,368,GETDATE(),null,null,0,'D','SOL',null,0 from   sma_MST_CaseType 
left join sma_MST_SubRole on sbrnCaseTypeID=cstnCaseTypeID and sbrnRoleID=5
left join [sma_MST_StateCaseTypes] on stcnCaseTypeID=cstnCaseTypeID
where cstnCaseTypeID>=(select MIN(cstncasetypeid) from sma_MST_CaseType where cstdDtCreated >GETDATE()-1) 

INSERT INTO [sma_MST_SOLDetails]
([sldnSOLTypeID],[sldnCaseTypeID],[sldnDefRole],[sldnStateID],[sldnYears],[sldnMonths],[sldnDays],[sldnSOLDays],[sldnRecUserID]
,[slddDtCreated],[sldnModifyUserID],[slddDtModified],[sldnLevelNo],[sldsDorP],[sldsSOLName],[sldbIsIncidDtEffect],[sldbDefualt])
Select 3,cstnCaseTypeID,sbrnSubRoleId,stcnStateID,0,0,30,0,368,GETDATE(),null,null,0,'P','No Fault',null,0 from   sma_MST_CaseType 
left join sma_MST_SubRole on sbrnCaseTypeID=cstnCaseTypeID and sbrnRoleID=4 and sbrsDscrptn='(P)-Plaintiff'
left join [sma_MST_StateCaseTypes] on stcnCaseTypeID=cstnCaseTypeID
where cstnCaseTypeID>=(select MIN(cstncasetypeid) from sma_MST_CaseType where cstdDtCreated >GETDATE()-1)  

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

