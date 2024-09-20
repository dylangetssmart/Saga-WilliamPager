
set ansi_warnings off
insert into [sma_MST_CriticalDeadlineTypes] ([cdtsCode],[cdtsDscrptn],[cdtnRecUserID],[cdtdDtCreated],[cdtnModifyUserID],[cdtdDtModified],[cdtnLevelNo]
,[ctdnCheckin],[ctdnCheckinn],[ctdnCriteria],cdtbActive )
Select distinct upper(SUBSTRING(DESCRIPTION,0,4)) ,DESCRIPTION,368,GETDATE(),null,null,0,null,null,null,1
FROM [WilliamPagerSaga].[dbo].PLRULTYP AType
left join WilliamPagerSaga.dbo.MRULASS m on m.RULETYPEID=Atype.RULETYPEID
where m.type =2 and LTRIM(RTRIM(description)) not in (select [cdtsDscrptn] from [sma_MST_CriticalDeadlineTypes])

Alter table [sma_TRN_CriticalDeadlines] disable trigger all

INSERT INTO [sma_TRN_CriticalDeadlines]
([crdnCaseID],[crdnCriticalDeadlineTypeID],[crdsPartyFlag],[crdsPlntDefFlag],[crdnPlntDefID],[crddDueDate],[crddCompliedDate],[crdsComments],[crdnRecUserID]
,[crddDtCreated],[crdnModifyUserID],[crddDtModified],[crdnLevelNo],[crdnContactCtgId],[crdnContactId],[id_discovery],[crdnDiscoveryTypeId],[crdsWaivedFlag],[crdsSupercededFlag]
,[crdsCriteria])
Select distinct casnCaseID,cdtnCriticalTypeID,'D','D',defnDefendentID,case when date1 between '1/1/1900' and '12/31/2079' then DATE1 end,case when   DATE2 between '1/1/1900' and '12/31/2079' then DATE2 else null end date2,
isnull(convert(varchar(3800),a.NOTES),'')+char(13)+isnull(title,'')+char(13)+isnull(COMPDESCRIPTION,''),case isnull((u1.usrnuserid),'') when '' then 368 else (u1.usrnuserid) end,case when (a.datecreated) is null then GETDATE() when (a.datecreated) between '1/1/1900' and '12/31/2079' then a.DATECREATED else GETDATE() end,
case isnull((u2.usrnuserid),'') when '' then 368 else (u2.usrnuserid) end,case  when (a.daterevised) is null then GETDATE() when a.DATEREVISED between '1/1/1900' and '12/31/2079' then a.DATEREVISED else GETDATE() end,0,
null,null,null,null,null,null,null
from [WilliamPagerSaga].dbo.MRULASS a
Left join [WilliamPagerSaga].[dbo].PLRULTYP AType on a.RULETYPEID=Atype.RULETYPEID
LEFT join [sma_MST_CriticalDeadlineTypes] on  LTRIM(RTRIM(description))=cdtsDscrptn
Left join  [WilliamPagerSaga].dbo.MATTER b on a.MATTERID=b.MATTERID
Left join sma_trn_cases  on cassCaseNumber=MATTERNUMBER
left join sma_trn_defendants on defncaseid=casncaseid and defbisprimary=1
left join sma_MST_SOLDetails on sldnCaseTypeID=casnOrgCaseTypeID and casnState=sldnStateID and defnsubrole=sldndefrole and sldnsoltypeid<>37
left join sma_MST_IndvContacts l on l.cinsGrade=a.CREATORID
left join sma_mst_users u1 on u1.usrnContactID=l.cinnContactID
left join sma_MST_IndvContacts m on m.cinsGrade=a.REVISORID
left join sma_mst_users u2 on u2.usrnContactID=m.cinnContactID
Where casncaseid is not null  and a.type=2 and a.title not like 'no fault%'  and a.TITLE not like '%statute%' 
order by DATE2 desc   

Alter table [sma_TRN_CriticalDeadlines] enable trigger all

