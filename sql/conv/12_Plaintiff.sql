Declare @RoleID int 

Select @RoleID = MAX(sbrnsubroleid) from sma_MST_SubRole

INSERT INTO [sma_mst_SubRoleCode]
([srcsDscrptn],[srcnRoleID])
Select distinct LTRIM(RTRIM(r.DESCRIPTION)),4 from WilliamPagerSaga.dbo.EROLE r
join WilliamPagerSaga.dbo.ASSIGN a on a.ROLEID=r.ROLEID
where PARTYTYPE=1 and LTRIM(RTRIM(r.DESCRIPTION)) not in (select LTRIM(RTRIM([srcsDscrptn])) from [sma_mst_SubRoleCode] where [srcnRoleID]=4)

INSERT INTO [sma_MST_SubRole]
([sbrsCode],[sbrnRoleID],[sbrsDscrptn],[sbrnCaseTypeID],[sbrnPriority],[sbrnRecUserID],[sbrdDtCreated],[sbrnModifyUserID],[sbrdDtModified],[sbrnLevelNo],[sbrbDefualt],[saga],sbrnTypeCode)
Select distinct '',4,substring(srcsDscrptn,0,50),cstnCaseTypeID,'',368,GETDATE(),null,null,'',null,'',srcnCodeId
from [WilliamPagerSaga].[dbo].[LAWTYPE] c
Left Join sma_MST_CaseType on cstsType=c.DESCRIPTION
cross join [sma_mst_SubRoleCode]
where srcsDscrptn in (Select distinct LTRIM(RTRIM(r.DESCRIPTION)) from WilliamPagerSaga.dbo.EROLE r
join WilliamPagerSaga.dbo.ASSIGN a on a.ROLEID=r.ROLEID
where PARTYTYPE=1)


alter table sma_trn_plaintiff disable trigger all


INSERT INTO   [sma_TRN_Plaintiff]
([plnnCaseID],[plnnContactCtg],[plnnContactID],[plnnAddressID],[plnnRole],[plnbIsPrimary],[plnbWCOut],[plnnPartiallySettled],[plnbSettled],[plnbOut],[plnbSubOut],[plnnSeatBeltUsed],
[plnnCaseValueID],[plnnCaseValueFrom],[plnnCaseValueTo],[plnnPriority],[plnnDisbursmentWt],[plnbDocAttached],[plndFromDt],[plndToDt],[plnnRecUserID],[plndDtCreated],[plnnModifyUserID],
[plndDtModified],[plnnLevelNo],[plnsMarked],[saga],[plnnNoInj],[plnnMissing],[plnnLIPBatchNo],[plnnPlaintiffRole])

select   casnCaseID,case when (isnull(cinncontactid,''))<>'' then (cinnContactCtg) when (isnull(conncontactid,''))<>'' then (connContactCtg) end,
case when (isnull(cinncontactid,''))<>'' then (cinnContactID) when (isnull(conncontactid,''))<>'' then (connContactID) end,
case when (isnull(cinncontactid,''))<>'' then (IndvAddressID) when (isnull(conncontactid,''))<>'' then (orgAddressID) end,
(sbrnSubRoleId),0,0,0,0,0,0,0,0,0,0,0,0,0,(casdDtCreated),null,(casnRecUserID),(casdDtCreated),(casnModifyUserID),(casdDtModified),null,null,null,null,null,null,null
from [WilliamPagerSaga].dbo.matter m
left join sma_trn_cases on cassCaseNumber=MATTERNUMBER
Left join  [WilliamPagerSaga].dbo.status s on  m.statusId=s.statusId
Left Join  [WilliamPagerSaga].dbo.lawtype LT on LT.LAWTYPEID=m.LAWTYPEID
Left Join  [WilliamPagerSaga].dbo.ASSIGN a on m.MATTERID=a.MATTERID
Left Join [WilliamPagerSaga].dbo.EROLE r on r.ROLEID=a.ROLEID
Left Join [WilliamPagerSaga].dbo.entities e on a.ENTITYID=e.ENTITYID
left join sma_MST_IndvContacts  i1 on  i1.cinsGrade=e.ENTITYID
left join sma_MST_OrgContacts o1 on o1.connLevelNo=e.ENTITYID
left join [sma_mst_SubRoleCode] on [srcsDscrptn]=r.DESCRIPTION
outer apply(select top 1 addnaddressid as IndvAddressID from  sma_MST_Address where addnContactID=cinncontactid and addnContactCtgID=1 order by isnull(addbPrimary,0) desc) z
outer apply(select top 1 addnaddressid as orgAddressID from  sma_MST_Address where addnContactID=conncontactid and addnContactCtgID=2 order by isnull(addbPrimary,0) desc) b
outer apply(select top 1 sbrnSubRoleId from  sma_MST_SubRole where sbrnCaseTypeID=casnOrgCaseTypeID and sbrnRoleId=4 and sbrnTypeCode=srcncodeid ) c
Where casnCaseID is not null  and a.PARTYTYPE=1


Update sma_TRN_Plaintiff
set plnbIsPrimary=1
from sma_trn_plaintiff where (plnnContactID in (select cinncontactid from sma_MST_IndvContacts join [WilliamPagerSaga].dbo.MATTER e on cinsGrade=e.CLIENTID) and plnnContactCtg=1)
or (plnnContactID in (select conncontactid from sma_MST_orgContacts join [WilliamPagerSaga].dbo.MATTER e on connLevelNo=e.CLIENTID) and plnnContactCtg=2)


INSERT INTO   [sma_TRN_Plaintiff]
([plnnCaseID],[plnnContactCtg],[plnnContactID],[plnnAddressID],[plnnRole],[plnbIsPrimary],[plnbWCOut],[plnnPartiallySettled],[plnbSettled],[plnbOut],[plnbSubOut],[plnnSeatBeltUsed],
[plnnCaseValueID],[plnnCaseValueFrom],[plnnCaseValueTo],[plnnPriority],[plnnDisbursmentWt],[plnbDocAttached],[plndFromDt],[plndToDt],[plnnRecUserID],[plndDtCreated],[plnnModifyUserID],
[plndDtModified],[plnnLevelNo],[plnsMarked],[saga],[plnnNoInj],[plnnMissing],[plnnLIPBatchNo],[plnnPlaintiffRole])
Select casncaseid,1,9,2,sbrnSubRoleId,1,null,null,null,null,null,null,null,null,null,null,null,null,GETDATE(),null,368,GETDATE(),null,null,null,null,null,null,null,null,null
From sma_trn_cases
outer apply(select top 1 sbrnSubRoleId from  sma_MST_SubRole where sbrnCaseTypeID=casnOrgCaseTypeID and sbrnRoleId=4  order by Replace(sbrsDscrptn,'(P)-Plaintiff',' (P)-Plaintiff') asc) c
Where cassCaseNumber is not null  and casncaseid not in (select distinct plnncaseid from sma_TRN_Plaintiff) 

Update sma_TRN_Plaintiff 
set plnbIsPrimary=1 where plnnPlaintiffID in (
select MIN(plnnplaintiffid) from sma_TRN_Plaintiff
where plnnCaseID in (
select plnnCaseID from sma_TRN_Plaintiff
Except
select plnncaseid  from sma_TRN_Plaintiff where plnbIsPrimary=1)
Group by plnnCaseID)
alter table sma_trn_plaintiff enable trigger all

Alter table sma_MST_SubRole disable trigger all
Delete from sma_MST_SubRole 
where sbrnSubRoleId not in (select plnnRole from sma_TRN_Plaintiff left join sma_TRN_CaseS on casnCaseID=plnnCaseID left join sma_MST_CaseType on cstnCaseTypeID=casnOrgCaseTypeID where cstnCaseTypeID=casnOrgCaseTypeID and cstnCaseTypeID=sbrnCaseTypeID )
and sbrnRoleID=4 and sbrnSubRoleId>@RoleID
Alter table sma_MST_SubRole enable trigger all




