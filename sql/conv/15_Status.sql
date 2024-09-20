
Alter table [sma_TRN_CaseStatus] disable trigger all

Insert Into sma_MST_CaseStatus(csssDescription,cssnStatusTypeID,cssnRecUserID,cssdDtCreated,SGsStatusType)
select  LTRIM(RTRIM(description)),1,8,GETDATE(),'Status' from [WilliamPagerSaga].[dbo].[STATUS] where DESCRIPTION not like '%closed%'
Except 
Select LTRIM(RTRIM(csssdescription)),1,8,GETDATE(),'Status' from sma_MST_CaseStatus
where csssDescription in (select description from [WilliamPagerSaga].[dbo].[STATUS]) and cssnStatusTypeID=1


INSERT INTO [sma_TRN_CaseStatus]
([cssnCaseID],[cssnStatusTypeID],[cssnStatusID],[cssnExpDays],[cssdFromDate],[cssdToDt],[csssComments],[cssnRecUserID],[cssdDtCreated],[cssnModifyUserID],[cssdDtModified],[cssnLevelNo],[cssnDelFlag])
select casnCaseID,1,case when b.DESCRIPTION like '%closed%' then 9 else cssnStatusID end,cssnExpNoOfDays,a.STATUSDATE,null,case when b.DESCRIPTION like '%closed%' then b.DESCRIPTION else '' end,u1.usrnUserID,a.STATUSDATE,u2.usrnUserID,a.DATEREVISED,null,null
FROM [WilliamPagerSaga].[dbo].[Matter] a
left join sma_trn_cases on cassCaseNumber=MATTERNUMBER
left join [WilliamPagerSaga].[dbo].[STATUS]b on a.STATUSID=b.STATUSID
left join sma_MST_CaseStatus on csssDescription= LTRIM(RTRIM(b.description))
left join sma_MST_IndvContacts l on l.cinsGrade=a.CREATORID
left join sma_mst_users u1 on u1.usrnContactID=l.cinnContactID
left join sma_MST_IndvContacts m on m.cinsGrade=a.REVISORID
left join sma_mst_users u2 on u2.usrnContactID=m.cinnContactID
where casnCaseID is not null

INSERT INTO [sma_TRN_CaseStatus]
([cssnCaseID],[cssnStatusTypeID],[cssnStatusID],[cssnExpDays],[cssdFromDate],[cssdToDt],[csssComments],[cssnRecUserID],[cssdDtCreated],[cssnModifyUserID],[cssdDtModified],[cssnLevelNo],[cssnDelFlag])
select distinct casnCaseID,1,cssnStatusID,cssnExpNoOfDays,b.STATUSDATE,DATEPOSTED,'',u1.usrnUserID,b.STATUSDATE,u1.usrnUserID,b.DATEPOSTED,null,null
FROM [WilliamPagerSaga].[dbo].[MATTER_STATUS_HISTORY] b
left join  [WilliamPagerSaga].[dbo].[Matter] a on a.matterid=b.MATTERID
left join sma_trn_cases on cassCaseNumber=MATTERNUMBER
left join sma_MST_CaseStatus on csssDescription= LTRIM(RTRIM(b.STATUS))
left join sma_MST_IndvContacts l on l.cinsGrade=b.POSTEDBY
left join sma_mst_users u1 on u1.usrnContactID=l.cinnContactID
where casnCaseID is not null
Alter table [sma_TRN_CaseStatus] enable trigger all


Alter table sma_trn_cases disable trigger all

Update a 
set casdClosingDate=cssdfromdate
From sma_trn_cases a
LEFT join sma_TRN_CaseStatus on cssnCaseID = casnCaseID
where cssnStatusID in (select StatusID from sma_TRN_CaseStagesStatus where StageID=5) and cssdToDt is null

Alter table sma_trn_cases Enable trigger all

Alter table sma_TRN_CaseStatus disable trigger all
Update cs
set csssComments=isnull(case when LASTREVIEW is not null then isnull('Last Review: '+convert(varchar(20),LASTREVIEW,101),'') else '' end,'')+
isnull(case when LASTREVIEWBYID is not null then isnull(char(13)+'Last Reviewed By: '+cinsLastName+', '+cinsFirstName,'') else '' end,'')
from WilliamPagerSaga.dbo.MATTER m
left join sma_trn_cases on cassCaseNumber=MATTERNUMBER
left join sma_TRN_CaseStatus cs on cssnCaseID=casnCaseID and cssdToDt is null and cssnStatusTypeID=1
left join sma_mst_indvcontacts on cinsGrade= LASTREVIEWBYID
where isnull(case when LASTREVIEW is not null then isnull('Last Review: '+convert(varchar(20),LASTREVIEW,101),'') else '' end,'')+
isnull(case when LASTREVIEWBYID is not null then isnull(char(13)+'Last Reviewed By: '+cinsLastName+', '+cinsFirstName,'') else '' end,'')<>''
Alter table sma_TRN_CaseStatus enable trigger all

go
