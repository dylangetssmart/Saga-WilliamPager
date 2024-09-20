delete from [sma_MST_ActivityType] where attnActivityCtg<>1

go
INSERT INTO [dbo].[sma_MST_ActivityType]
           ([attsCode]           ,[attsDscrptn]           ,[attnActivityCtg]           ,[attnmoduleID]           ,[attsDefinition]           ,[attnRecUserID]           ,[attdDtCreated]           ,[attnModifyUserID]           ,[attdDtModified]
           ,[attnLevelNo])
select distinct '',pt.DESCRIPTION,1,null,null,368,GETDATE(),null,null,'' from [WilliamPagerSaga].dbo.MRULASS mr
left join [WilliamPagerSaga].dbo.PLRULTYP pt on mr.RULETYPEID=pt.RULETYPEID
where TYPE in (1,4)
except
select distinct '',[attsDscrptn],1,null,null,368,GETDATE(),null,null,'' from [sma_MST_ActivityType]
go
INSERT INTO [sma_TRN_CalendarAppointments]
([FromDate],[ToDate],[AppointmentTypeID],[ActivityTypeID],[CaseID],[LocationContactID],[LocationContactGtgID],[JudgeID],[Comments],[StatusID]
,[Address],[Subject],[RecurranceParentID],[AdjournedID],[RecUserID],[DtCreated],[ModifyUserID],[DtModified],[DepositionType],[Deponants],[OriginalAppointmentID],[OriginalAdjournedID])
--Select distinct mr.date1+isnull(cast(TIMEFROM as TIME),''),mr.date1+isnull(cast(TIMETO as time),''),case when mr.type=4 then 0 else 3 end,attnActivityTypeID,casnCaseID,case when mr.TYPE=4 then  k.connContactID end,case when mr.TYPE=4 then k.connContactCtg end,z.crtJudgeorClerkContactID,isnull(convert(varchar(1800),notes),'')+char(13)+char(13),
--CASE mr.STATUS WHEN 1 THEN 1 WHEN 2 THEN 3 WHEN 3 THEN 2 ELSE 1 END,convert(varchar(200),ISNULL(mr.LOCATION,'')),TITLE,null,null,u1.usrnUserID,mr.DATECREATED,u2.usrnUserID,mr.DATEREVISED,null,mr.THREADID,null,null
Select distinct convert(datetime,mr.date1) + convert(datetime,convert(TIME,TIMEFROM)),convert(datetime,mr.date1) + convert(datetime,convert(TIME,TIMETO)),case when mr.type=4 then 0 else 3 end,attnActivityTypeID,casnCaseID,case when mr.TYPE=4 then  k.connContactID end,case when mr.TYPE=4 then k.connContactCtg end,z.crtJudgeorClerkContactID,isnull(convert(varchar(1800),notes),'')+char(13)+char(13),
CASE mr.STATUS WHEN 1 THEN 1 WHEN 2 THEN 3 WHEN 3 THEN 2 ELSE 1 END,convert(varchar(200),ISNULL(mr.LOCATION,'')),TITLE,null,null,u1.usrnUserID,mr.DATECREATED,u2.usrnUserID,mr.DATEREVISED,null,mr.THREADID,null,null
from [WilliamPagerSaga].dbo.matter m
Left Join [WilliamPagerSaga].dbo.MRULASS mr on m.MATTERID=mr.MATTERID
Left Join [WilliamPagerSaga].dbo.MRULENT mrl on mr.THREADID=mrl.THREADID
left join [WilliamPagerSaga].dbo.PLRULTYP pt on mr.RULETYPEID=pt.RULETYPEID
Left Join [WilliamPagerSaga].dbo.lw_matter lm on m.matterid=lm.matterid
Left Join [WilliamPagerSaga].dbo.LW_A_MATTERGROUP mg1 on m.MATTERGROUP1ID=mg1.MATTERGROUPID  
left join [WilliamPagerSaga].dbo.LW_A_MATTERGROUP mg2 on  m.MATTERGROUP2ID=mg2.MATTERGROUPID
left join [WilliamPagerSaga].dbo.LW_A_MATTERGROUP mg3 on  m.MATTERGROUP3ID=mg3.MATTERGROUPID
Outer apply (select top 1   pt.description from   [WilliamPagerSaga].dbo.PLRULTYP pt where mr.RULETYPEID=pt.RULETYPEID) AType
Outer apply(select top 1   aa.partytype   from  [WilliamPagerSaga].dbo.assign aa where m.MATTERID=aa.MATTERID ) CrOurSide
Left join sma_trn_cases  on cassCaseNumber=m.MATTERNUMBER
left join sma_trn_plaintiff on plnncaseid=casncaseid and plnbisprimary=1
left join sma_MST_IndvContacts l on l.cinsGrade=mr.CREATORID
left join sma_mst_users u1 on u1.usrnContactID=l.cinnContactID
left join sma_MST_IndvContacts g on g.cinsGrade=mr.REVISORID
left join sma_mst_users u2 on u2.usrnContactID=g.cinnContactID
left join [sma_MST_ActivityType] on LTRIM(RTRIM(pt.description))=LTRIM(RTRIM(attsDscrptn))
left join [WilliamPagerSaga].dbo.JURISDCT jurisdct on jurisdct.COURTID=mr.COURTID
left join sma_TRN_Courts on crtnCaseID=casnCaseID
outer apply(select crtJudgeorClerkContactID from sma_trn_caseJudgeorClerk left join sma_TRN_CourtDocket on crdnCourtDocketID=crtDocketID left join sma_TRN_Courts on crtnPKCourtsID=crdnCourtsID left join sma_MST_IndvContacts on JUDGEID=cinsGrade where crtnCaseID=casnCaseID and cinnContactID=crtJudgeorClerkContactid  )z
outer apply(select top 1 connContactID,connContactCtg from  sma_MST_OrgContacts k where connContactID=crtnCourtID and casnCaseID=crtnCaseID)k
outer apply(select top 1 coalesce(courtcasenumber,'') + coalesce('/' + CourtCaseNumberExt,'') as CoutDocketNo from [WilliamPagerSaga].dbo.lw_court lwc left join  [WilliamPagerSaga].dbo.assign a on lwc.assignid = a.assignid  LEFT join [WilliamPagerSaga].dbo.erole er on    er.roleid=a.roleid where er.rolecategoryid=6 and a.matterid=m.matterid)z1
Where casncaseid is not null   and mr.TYPE in (1,4) 
                  
go
Delete from sma_TRN_CalendarAppointments
where   AppointmentID not in (select min(AppointmentID) from sma_TRN_CalendarAppointments group by FromDate,ActivityTypeID,caseid,[subject])               


  go
select distinct MATTERID,t.Data,THREADID into #tmpapptss from [WilliamPagerSaga].dbo.MRULASS muu 
cross apply dbo.Split(RESPONSIBLELIST,',')  as t 
where t.Data is not null and MATTERID is not null and RESPONSIBLELIST like '%,%'  and muu.TYPE in (1,4)
order by MATTERID
go
Insert into sma_trn_AppointmentStaff
Select appointmentid,case when usrnContactID is not null then usrnContactID else  cssnStaffID end  
from #tmpapptss
left join   sma_TRN_CalendarAppointments  on THREADID=Deponants
--left join   [WilliamPagerSaga].dbo.MRULASS mu on mu.THREADID=Deponants 
left join WilliamPagerSaga.dbo.ENTITIES et  on et.WPINITIALS=ltrim(rtrim(data)) 
left join sma_MST_IndvContacts on cinsGrade=et.ENTITYID
left join sma_mst_users on usrnContactID=cinnContactID        
left join sma_TRN_CaseStaff on cssnCaseID=CaseID and cssdToDate is null and cssnStaffID is not null   
where cssnStaffID is not null and appointmentid is not null 
go
Insert into sma_trn_AppointmentStaff
Select appointmentid,case when usrnContactID is not null then usrnContactID else  cssnStaffID end  
from sma_TRN_CalendarAppointments
left join   [WilliamPagerSaga].dbo.MRULASS on THREADID=Deponants 
left join WilliamPagerSaga.dbo.ENTITIES et  on et.WPINITIALS=ltrim(rtrim(RESPONSIBLELIST)) 
left join sma_MST_IndvContacts on cinsGrade=et.ENTITYID
left join sma_mst_users on usrnContactID=cinnContactID        
left join sma_TRN_CaseStaff on cssnCaseID=CaseID and cssdToDate is null and cssnStaffID is not null   
where cssnStaffID is not null   and RESPONSIBLELIST not like '%,%' and [TYPE] in (1,4)
go
drop table #tmpapptss
go
go
Update sma_TRN_CalendarAppointments
set Deponants=null
go
--go
--Insert into sma_trn_AppointmentStaff
--Select appointmentid,cssnStaffID  from sma_TRN_CalendarAppointments
--left join sma_TRN_CaseStaff on cssnCaseID=CaseID and cssdToDate is null and cssnStaffID is not null               
--where cssnStaffID is not null   
