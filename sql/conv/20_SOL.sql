Alter table [sma_TRN_SOLs] Disable Trigger all

INSERT INTO [sma_TRN_SOLs]
([solnCaseID],[solnSOLTypeID],[soldSOLDate],[soldToProcessServerDt],[soldSnCFilingDate],[soldServiceDate],[soldLastDtToServe],[solnServiceMethodID],[solnMailingReqd]
,[soldLastDateToMail],[soldMailedDate],[solnFileAffidavitReqd],[soldLastDateToFile],[soldFiledDate],[soldProcessServerDt],[solnDefendentID],[soldDefAnsDueDt]
,[soldRcvdDate],[solsComments],[solnRecUserID],[soldDtCreated],[solnModifyUserID],[soldDtModified],[solnLevelNo],[soldLastDtFileSc],[soldDateComplied]
,[solsType],[solbIsOld],[intCriticalDeadline],[soldComments])
Select distinct casnCaseID,sldnSOLdetID,case when date1 between '1/1/1900' and '12/31/2079' then DATE1 end,null,null,null,null,null,null
,null,null,'',null,null,null,defndefendentid,null
,null,title,case isnull((u1.usrnuserid),'') when '' then 368 else (u1.usrnuserid) end,case (a.datecreated) when null then GETDATE() else (a.datecreated) end,case isnull((u2.usrnuserid),'') when '' then 368 else (u2.usrnuserid) end,case (a.daterevised) when null then GETDATE() else (a.daterevised) end,null,case when date1 between '1/1/1900' and '12/31/2079' then DATE1 end,case when   DATE2 between'1/1/1900' and '12/31/2079' then DATE2 else null end date2
,'D','','',isnull(convert(varchar(4000),a.NOTES),'')
from [WilliamPagerSaga].dbo.MRULASS a
Left join  [WilliamPagerSaga].dbo.MATTER b on a.MATTERID=b.MATTERID
Left join sma_trn_cases  on cassCaseNumber=MATTERNUMBER
left join sma_trn_defendants on defncaseid=casncaseid and defbisprimary=1
left join sma_MST_SOLDetails on sldnCaseTypeID=casnOrgCaseTypeID and casnState=sldnStateID and defnsubrole=sldndefrole and sldnsoltypeid<>37
left join sma_MST_IndvContacts l on l.cinsGrade=a.CREATORID
left join sma_mst_users u1 on u1.usrnContactID=l.cinnContactID
left join sma_MST_IndvContacts m on m.cinsGrade=a.REVISORID
left join sma_mst_users u2 on u2.usrnContactID=m.cinnContactID
Where casncaseid is not null  and a.type=2 and a.title  like '%statute%'  
order by DATE2 desc
INSERT INTO [sma_TRN_SOLs]
([solnCaseID],[solnSOLTypeID],[soldSOLDate],[soldToProcessServerDt],[soldSnCFilingDate],[soldServiceDate],[soldLastDtToServe],[solnServiceMethodID],[solnMailingReqd]
,[soldLastDateToMail],[soldMailedDate],[solnFileAffidavitReqd],[soldLastDateToFile],[soldFiledDate],[soldProcessServerDt],[solnDefendentID],[soldDefAnsDueDt]
,[soldRcvdDate],[solsComments],[solnRecUserID],[soldDtCreated],[solnModifyUserID],[soldDtModified],[solnLevelNo],[soldLastDtFileSc],[soldDateComplied]
,[solsType],[solbIsOld],[intCriticalDeadline],[soldComments])
Select distinct casnCaseID,sldnSOLdetID,case when isdate(DATE1)= 1  and YEAR(DATE1)between 1900 and 2050  then DATE1 else null end ,null,null,null,null,null,null
,null,null,'',null,null,null,plnnPlaintiffID,null
,null,title,case isnull((u1.usrnuserid),'') when '' then 368 else (u1.usrnuserid) end,case (a.datecreated) when null then GETDATE() else (a.datecreated) end,case isnull((u2.usrnuserid),'') when '' then 368 else (u2.usrnuserid) end,case (a.daterevised) when null then GETDATE() else (a.daterevised) end,null,case when isdate(DATE1)= 1  and YEAR(DATE1)between 1900 and 2050  then DATE1 else null end,case when isdate(DATE2)= 1  and YEAR(DATE2)between 1900 and 2050  then DATE2 else null end
,'P','','',isnull(convert(varchar(4000),a.NOTES),'')
from [WilliamPagerSaga].dbo.MRULASS a
Left join  [WilliamPagerSaga].dbo.MATTER b on a.MATTERID=b.MATTERID
Left join sma_trn_cases  on cassCaseNumber=MATTERNUMBER
left join sma_trn_plaintiff on plnncaseid=casncaseid and plnbisprimary=1
left join sma_MST_SOLDetails on sldnCaseTypeID=casnOrgCaseTypeID and casnState=sldnStateID and plnnrole=sldndefrole and sldnsoltypeid=14
left join sma_MST_IndvContacts l on l.cinsGrade=a.CREATORID
left join sma_mst_users u1 on u1.usrnContactID=l.cinnContactID
left join sma_MST_IndvContacts m on m.cinsGrade=a.REVISORID
left join sma_mst_users u2 on u2.usrnContactID=m.cinnContactID
Where casncaseid is not null  and a.type=2 and a.title  like 'no fault%'

Update a 
set [solnSOLTypeID]=sldnSOLdetID
From sma_trn_sols a
left join sma_trn_cases on casncaseid=solncaseid
outer apply(select top 1 sldnSOLdetID from sma_mst_soldetails where sldncasetypeid=casnorgcasetypeid and sldnsoltypeid<>37 and sldnstateid=26) z
where [solnSOLTypeID] is null and solstype='d'

Update a 
set [solnSOLTypeID]=sldnSOLdetID
From sma_trn_sols a
left join sma_trn_cases on casncaseid=solncaseid
outer apply(select top 1 sldnSOLdetID from sma_mst_soldetails where sldncasetypeid=casnorgcasetypeid and sldnsoltypeid=14 and sldnstateid=26) z
where [solnSOLTypeID] is null and solstype='p'

Delete from sma_TRN_SOLs where solnSOLID not in (
select MIN(solnSOLID) from sma_trn_sols
Group by soldSOLDate,solnCaseID)
Alter table [sma_TRN_SOLs] Enable Trigger all

