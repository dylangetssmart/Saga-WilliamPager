INSERT INTO [sma_MST_TaskTemplateGroup]
([tskgrpName],[tskgrpRecUserID],[tskgrpDtCreated],[tskgrpModifyUserID],[tskgrpDtModified])
Select 'SAGA',368,GETDATE(),null,null
go
INSERT INTO [sma_mst_Task_Template]
([tskMasterDetails],[tskCategoryID],[tskDoneNoteTypeID],[tskPriority],[tskSubject],[tskDueDateShift],[tskDefAssigneeRole],[tskDocTemplateId],[tskDocTemplateKeyword]
,[tskNewStatusId],[tskChangeStatusId],[tskCreatedBy],[tskCreatedDt],[tskModifiedBy],[tskModifiedDt],[tskDefAssignee],[tskDefSecondaryRole])
Select distinct description, case when atype.description='review' then 3 else 4 end,null,1,null,10,null,null,null,null,null,368,GETDATE(),null,null,null,null 
from   [WilliamPagerSaga].dbo.PLRULE AType
where type in (0,3) and ltrim(rtrim(description)) not in (select LTRIM(rtrim([tskMasterDetails])) from   [sma_mst_Task_Template] )
go
Alter Table sma_mst_TaskCaseStatus NOCHECK CONSTRAINT ALL
  insert into sma_mst_taskcasestatus
  select tskMasterID,0,getdate(),368,null,null
  from [sma_mst_Task_Template] where tskMasterID>=(select MIN(tskMasterID) from [sma_mst_Task_Template] where [tskCreatedDt]>GETDATE()-1)
  go
  Declare @TemplateGroupID int
  Select @TemplateGroupID=max(tskgrpid) from [sma_MST_TaskTemplateGroup] where tskgrpName='SAGA'
  
  insert into [sma_TRN_TaskTemplateGroup]
  Select @TemplateGroupID,tskMasterID,368,GETDATE(),null,null
  From [sma_mst_Task_Template] where tskMasterID>=(select MIN(tskMasterID) from [sma_mst_Task_Template] where [tskCreatedDt]>GETDATE()-1)
  go
select distinct MATTERID,t.Data,THREADID into #tmpTask from [WilliamPagerSaga].dbo.MRULASS muu 
cross apply dbo.Split(RESPONSIBLELIST,',')  as t 
where t.Data is not null and MATTERID is not null and RESPONSIBLELIST like '%,%'
order by MATTERID
go
Insert into #tmpTask
select distinct MATTERID,RESPONSIBLELIST,THREADID
from [WilliamPagerSaga].dbo.MRULASS muu 
where RESPONSIBLELIST is not null and MATTERID is not null and RESPONSIBLELIST not like '%,%'
order by MATTERID
go
INSERT INTO [dbo].[sma_TRN_TaskNew]
([tskCaseID],[tskDueDate],[tskStartDate],[tskRequestorID],[tskAssigneeId],[tskReminderDays],[tskDescription]
,[tskCreatedDt],[tskCreatedUserID],[tskCompleted],[tskMasterID],[tskCtgID],[tskSummary],[tskModifiedDt],[tskModifyUserID],[tskPriority])
Select casnCaseID,case when mr.DATE1 between '1/1/1900' and '12/31/2079' then mr.date1 else null end,case when mr.DATECREATED between '1/1/1900' and '12/31/2079' then mr.DATECREATED else null end,u1.usrnUserID,u3.usrnUserID,null,isnull(mr.TITLE,'')+char(13)+convert(varchar(4000),isnull(mr.notes,'')),case when mr.DATECREATED between '1/1/1900' and '12/31/2079' then mr.DATECREATED else getdate() end,u1.usrnUserID,case when mr.Date2 IS not null then 1 else 0 end,
tskMasterID,tskCategoryID,isnull(mr.TITLE,''),case when mr.DATEREVISED between '1/1/1900' and '12/31/2079' then mr.DATEREVISED else null end,u2.usrnUserID,tskPriority 
from [WilliamPagerSaga].dbo.matter m
Left Join [WilliamPagerSaga].dbo.MRULASS mr on m.MATTERID=mr.MATTERID
left join #tmpTask z on z.MATTERID=mr.MATTERID and z.THREADID=mr.THREADID
Left Join [WilliamPagerSaga].dbo.MRULENT mrl on mr.THREADID=mrl.THREADID
Left Join [WilliamPagerSaga].dbo.lw_matter lm on m.matterid=lm.matterid
Left Join [WilliamPagerSaga].dbo.LW_A_MATTERGROUP mg1 on m.MATTERGROUP1ID=mg1.MATTERGROUPID  
left join [WilliamPagerSaga].dbo.LW_A_MATTERGROUP mg2 on  m.MATTERGROUP2ID=mg2.MATTERGROUPID
left join [WilliamPagerSaga].dbo.LW_A_MATTERGROUP mg3 on  m.MATTERGROUP3ID=mg3.MATTERGROUPID
Outer apply (select top 1   pt.description from   [WilliamPagerSaga].dbo.PLRULE pt where mr.RULETYPEID=pt.RULETYPEID) AType
Outer apply(select top 1   aa.partytype   from  [WilliamPagerSaga].dbo.assign aa where m.MATTERID=aa.MATTERID ) CrOurSide
Left join sma_trn_cases  on cassCaseNumber=m.MATTERNUMBER
left join sma_trn_plaintiff on plnncaseid=casncaseid and plnbisprimary=1
left join sma_MST_SOLDetails on sldnCaseTypeID=casnOrgCaseTypeID and casnState=sldnStateID and plnnrole=sldndefrole and sldnsoltypeid=14
left join sma_MST_IndvContacts l on l.cinsGrade=mrl.CREATORID
left join sma_mst_users u1 on u1.usrnContactID=l.cinnContactID
left join sma_MST_IndvContacts g on g.cinsGrade=mrl.REVISORID
left join sma_mst_users u2 on u2.usrnContactID=g.cinnContactID
left join WilliamPagerSaga.dbo.ENTITIES et  on et.WPINITIALS=ltrim(rtrim(data))
left join sma_MST_IndvContacts inew on inew.cinsGrade=et.ENTITYID
left join sma_mst_users u3 on u3.usrnContactID=inew.cinnContactID
left join [sma_mst_Task_Template] on  atype.DESCRIPTION  =tskMasterDetails
Where casncaseid is not null  and mr.type in (0,3)

go
Drop table #tmpTask
go
Delete from sma_TRN_TaskNew 
where  not exists (
select MIN(tskid) as tskid from  [sma_TRN_TaskNew] where tskID=tskID
Group by tskCaseID,tskDueDate,tskStartDate,tskRequestorID,tskAssigneeId,tskDescription,tskCreatedDt,tskCreatedUserID,tskCompleted,tskMasterID,tskCtgID,tskSummary)
go         
update a 
set a.tskCompleted=2,a.tskModifiedDt=getdate(),a.tskModifyUserID=368
from sma_TRN_TaskNew a where tskAssigneeId is null and isnull(tskCompleted,0)=0
and  exists(select * from sma_trn_tasknew b where a.tskCaseID=b.tskCaseID and a.tskDescription=b.tskDescription and a.tskDueDate=b.tskDueDate and isnull(b.tskCompleted,0)=0 and b.tskAssigneeId is not null)
go
--Update a 
--set tskDueDate=getdate(),tskAssigneeId=case when tskassigneeid is null then usrnuserid end
--from sma_trn_tasknew a
--outer apply(select top 1 usrnUserID from sma_trn_casestaff left join sma_mst_users on usrnContactID=cssnStaffID where cssdToDate is null and cssnCaseID=tskCaseID order by replace(replace((cssnRoleID),8,0),5,1) desc)z
--where tskDueDate is null
--go
--Update a 
--set tskAssigneeId=case when tskassigneeid is null then usrnuserid end
--from sma_trn_tasknew a
--outer apply(select top 1 usrnUserID from sma_trn_casestaff left join sma_mst_users on usrnContactID=cssnStaffID where cssdToDate is null and cssnCaseID=tskCaseID order by replace(replace((cssnRoleID),8,0),5,1) desc)z
--where tskAssigneeId is null
