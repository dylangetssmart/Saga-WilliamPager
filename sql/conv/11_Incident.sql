
alter table [sma_TRN_Incidents] disable trigger all

declare @StateID int
select @StateID=sttnStateID from WilliamPagerSaga.dbo.SETTINGS join sma_MST_States on LTRIM(RTRIM(addrstate))=LTRIM(RTRIM(sttsCode)) or LTRIM(RTRIM(addrstate))=LTRIM(RTRIM(sttsDescription))

--INSERT INTO [sma_TRN_Incidents]
--([CaseId],[IncidentDate],[StateID],[LiabilityCodeId],[IncidentFacts],[MergedFacts],[Comments],[IncidentTime],[RecUserID],[DtCreated],[ModifyUserID],[DtModified])
--Select distinct casnCaseID,DATETIMEOFINCIDENT,case when isnull(sttnStateID,'')='' then @StateID else sttnStateID end,null,convert(varchar(8000),e.notes),convert(varchar(8000),d.notes),convert(varchar(8000),substring(c.notes,0,2000)),CONVERT(time,DATETIMEOFINCIDENT)
--,case isnull((u1.usrnuserid),'') when '' then 368 else (u1.usrnuserid) end,case (b.datecreated) when null then GETDATE() else (b.datecreated) end,(u2.usrnuserid),(b.daterevised)
-- FROM [WilliamPagerSaga].[dbo].[LW_MATTER] a
--Left Join [WilliamPagerSaga].[dbo].[Matter] b on b.MATTERID=a.MATTERID
--Left Join sma_trn_cases on b.MATTERNUMBER=cassCaseNumber
--left join sma_MST_States on ltrim(rtrim(sttsCode))=ltrim(rtrim(LOCATIONSTATE))
--left join [WilliamPagerSaga].[dbo].[NOTE] c on c.NOTEID=a.ALERTNOTEID
--left join [WilliamPagerSaga].[dbo].[NOTE] d on d.NOTEID=a.FACTDETAILNOTEID
--left join [WilliamPagerSaga].[dbo].[NOTE] e on e.NOTEID=a.FACTSUMMARYNOTEID
--left join sma_MST_IndvContacts l on l.cinsGrade=b.CREATORID
--left join sma_mst_users u1 on u1.usrnContactID=l.cinnContactID
--left join sma_MST_IndvContacts m on m.cinsGrade=b.REVISORID
--left join sma_mst_users u2 on u2.usrnContactID=m.cinnContactID
--where casnCaseID is not null

INSERT INTO [sma_TRN_Incidents]
([CaseId],[IncidentDate],[StateID],[LiabilityCodeId],[IncidentFacts],[MergedFacts],[Comments],[IncidentTime],[RecUserID],[DtCreated],[ModifyUserID],[DtModified])
select A.c1,A.c2,A.c3,A.c4,A.c5,A.c6,A.c7,A.c8,A.c9,A.c10,A.c11,A.c12
from
(
Select distinct 
	casnCaseID																	as c1,
	DATETIMEOFINCIDENT															as c2,
	case when isnull(sttnStateID,'')='' then @StateID else sttnStateID end		as c3,
	null																		as c4,
	convert(varchar(8000),e.notes)												as c5,
	convert(varchar(8000),d.notes)												as c6,
	convert(varchar(8000),substring(c.notes,0,2000))							as c7,
	CONVERT(time,DATETIMEOFINCIDENT)											as c8,
	case isnull((u1.usrnuserid),'') when '' then 368 else (u1.usrnuserid) end	as c9,
	case (b.datecreated) when null then GETDATE() else (b.datecreated) end		as c10,
	(u2.usrnuserid)																as c11,
	(b.daterevised)																as c12,
	ROW_NUMBER() over(partition by casnCaseID order by casnCaseID ) row_index
 FROM [WilliamPagerSaga].[dbo].[LW_MATTER] a
Left Join [WilliamPagerSaga].[dbo].[Matter] b on b.MATTERID=a.MATTERID
Left Join sma_trn_cases on b.MATTERNUMBER=cassCaseNumber
left join sma_MST_States on ltrim(rtrim(sttsCode))=ltrim(rtrim(LOCATIONSTATE))
left join [WilliamPagerSaga].[dbo].[NOTE] c on c.NOTEID=a.ALERTNOTEID
left join [WilliamPagerSaga].[dbo].[NOTE] d on d.NOTEID=a.FACTDETAILNOTEID
left join [WilliamPagerSaga].[dbo].[NOTE] e on e.NOTEID=a.FACTSUMMARYNOTEID
left join sma_MST_IndvContacts l on l.cinsGrade=b.CREATORID
left join sma_mst_users u1 on u1.usrnContactID=l.cinnContactID
left join sma_MST_IndvContacts m on m.cinsGrade=b.REVISORID
left join sma_mst_users u2 on u2.usrnContactID=m.cinnContactID
where casnCaseID is not null
) A where A.row_index=1







Update sma_TRN_Incidents
set StateID=67 
where StateID is null

update sma_TRN_Incidents
set IncidentFacts=ltrim(replace(
       dbo.RegExReplace(IncidentFacts,'({\\)(.+?)(})|(\\)(.+?)(\b)','')
      ,'}','')      
      ),Comments=ltrim(replace(
       dbo.RegExReplace(Comments,'({\\)(.+?)(})|(\\)(.+?)(\b)','')
      ,'}','')      
      ),MergedFacts = ltrim(replace(
       dbo.RegExReplace(MergedFacts,'({\\)(.+?)(})|(\\)(.+?)(\b)','')
      ,'}','')      
      )

alter table [sma_TRN_Incidents] enable trigger all


Alter table sma_trn_cases disable trigger all

Update a 
set casnState=StateID
From sma_trn_cases a
LEFT join sma_trn_incidents on caseid = casnCaseID

Alter table sma_trn_cases Enable trigger all
go

Insert into sma_MST_CaseValue
select distinct 'Range',valuelow,valuehigh,'',368,getdate(),NULL,NULL,NULL,NULL
FROM [WilliamPagerSaga].[dbo].[LW_EVAL] ev
where cast(valuelow as varchar(50))+'-'+ cast(valuehigh as varchar(50)) not in (select cast(csvnFromValue as varchar(50))+'-'+ cast(csvnToValue as varchar(50)) from sma_MST_CaseValue)
go

INSERT INTO [dbo].[sma_TRN_CaseValue]
([csvnCaseID],[csvnValueID],[csvnValue],[csvsComments],[csvdFromDate],[csvdToDate],[csvnRecUserID],[csvdDtCreated],[csvnModifyUserID],[csvdDtModified],[csvnLevelNo],[csvnMinSettlementValue])
select distinct casnCaseID,csvnValueID,csvnFromValue,convert(varchar(2000),ltrim(replace(dbo.RegExReplace(n.NOTES,'({\\)(.+?)(})|(\\)(.+?)(\b)',''),'}',''))) ,getdate(),NULL,368,getdatE(),NULL,NULL,1,NULL
FROM [WilliamPagerSaga].[dbo].[LW_EVAL] ev
left join [WilliamPagerSaga].[dbo].[Assign] a on a.assignid=ev.assignid
left join [WilliamPagerSaga].[dbo].[Matter] m on m.matterid=a.matterid
left join [WilliamPagerSaga].[dbo].[note] n on n.noteid=ev.noteid
left join sma_MST_CaseValue  on cast(csvnFromValue as varchar(50))+'-'+ cast(csvnToValue as varchar(50)) = cast(valuelow as varchar(50))+'-'+ cast(valuehigh as varchar(50))
left join sma_trn_cases z on z.casscasenumber=m.matternumber
go
update z 
set casnCaseValueFrom=valuelow,casnCaseValueTo=valuehigh,casncasevalueid=csvnValueID
FROM [WilliamPagerSaga].[dbo].[LW_EVAL] ev
left join [WilliamPagerSaga].[dbo].[Assign] a on a.assignid=ev.assignid
left join [WilliamPagerSaga].[dbo].[Matter] m on m.matterid=a.matterid
left join sma_MST_CaseValue n on cast(csvnFromValue as varchar(50))+'-'+ cast(csvnToValue as varchar(50)) = cast(valuelow as varchar(50))+'-'+ cast(valuehigh as varchar(50))
left join sma_trn_cases z on z.casscasenumber=m.matternumber
go
delete from [sma_MST_LiabilityCode]
INSERT INTO [dbo].[sma_MST_LiabilityCode]
([lbcsCode],[lbcsDscrptn],[lbcnRecUserID],[lbcdDtCreated],[lbcnModifyUserID],[lbcdDtModified],[lbcnLevelNo])
Select distinct '',liability,368,getdate(),null,null,'' FROM [WilliamPagerSaga].[dbo].[LW_EVAL] where liability is not null
go
Update x
set x.LiabilityCodeId=lbcnLiabilityID
FROM [WilliamPagerSaga].[dbo].[LW_EVAL] ev
left join [WilliamPagerSaga].[dbo].[Assign] a on a.assignid=ev.assignid
left join [WilliamPagerSaga].[dbo].[Matter] m on m.matterid=a.matterid
left join sma_MST_CaseValue n on cast(csvnFromValue as varchar(50))+'-'+ cast(csvnToValue as varchar(50)) = cast(valuelow as varchar(50))+'-'+ cast(valuehigh as varchar(50))
left join sma_trn_cases z on z.casscasenumber=m.matternumber
left join sma_trn_incidents x on x.caseid=casncaseid
left join [sma_MST_LiabilityCode]  on [lbcsDscrptn]=liability
where liability is not null 
go


Insert into sma_MST_CaseValue
select distinct 'Range',isnull(valuelow,'0.00'),isnull(valuehigh,'0.00'),'',368,getdate(),NULL,NULL,NULL,NULL
FROM [WilliamPagerSaga].[dbo].[LW_EVAL] ev
where cast(isnull(valuelow,'0.00') as varchar(50))+'-'+ cast(isnull(VALUEHIGH,'0.00') as varchar(50)) not in (select cast(isnull(csvnFromValue,'0.00') as varchar(50))+'-'+ cast(isnull(csvnToValue,'0.00') as varchar(50)) from sma_MST_CaseValue)
and (VALUELOW is null and VALUEHIGH is not null) or (VALUELOW is not null and VALUEHIGH is  null)
go

INSERT INTO [dbo].[sma_TRN_CaseValue]
([csvnCaseID],[csvnValueID],[csvnValue],[csvsComments],[csvdFromDate],[csvdToDate],[csvnRecUserID],[csvdDtCreated],[csvnModifyUserID],[csvdDtModified],[csvnLevelNo],[csvnMinSettlementValue])
select distinct casnCaseID,csvnValueID,csvnFromValue,convert(varchar(2000),ltrim(replace(dbo.RegExReplace(n.NOTES,'({\\)(.+?)(})|(\\)(.+?)(\b)',''),'}',''))) ,getdate(),NULL,368,getdatE(),NULL,NULL,1,NULL
FROM [WilliamPagerSaga].[dbo].[LW_EVAL] ev
left join [WilliamPagerSaga].[dbo].[Assign] a on a.assignid=ev.assignid
left join [WilliamPagerSaga].[dbo].[Matter] m on m.matterid=a.matterid
left join [WilliamPagerSaga].[dbo].[note] n on n.noteid=ev.noteid
left join sma_MST_CaseValue  on  cast(isnull(csvnFromValue,'0.00') as varchar(50))+'-'+ cast(isnull(csvnToValue,'0.00') as varchar(50)) = cast(isnull(valuelow,'0.00') as varchar(50))+'-'+ cast(isnull(valuehigh,'0.00') as varchar(50))
left join sma_trn_cases z on z.casscasenumber=m.matternumber
where (VALUELOW is null and VALUEHIGH is not null) or (VALUELOW is not null and VALUEHIGH is  null) and casnCaseID not in (select csvncaseid from [sma_TRN_CaseValue])
go

  update z 
set casnCaseValueFrom=isnull(valuelow,'0.00'),casnCaseValueTo=isnull(valuehigh,'0.00'),casncasevalueid=csvnValueID
FROM [WilliamPagerSaga].[dbo].[LW_EVAL] ev
left join [WilliamPagerSaga].[dbo].[Assign] a on a.assignid=ev.assignid
left join [WilliamPagerSaga].[dbo].[Matter] m on m.matterid=a.matterid
left join sma_MST_CaseValue n on cast(isnull(csvnFromValue,'0.00') as varchar(50))+'-'+ cast(isnull(csvnToValue,'0.00') as varchar(50)) = cast(isnull(valuelow,'0.00') as varchar(50))+'-'+ cast(isnull(valuehigh,'0.00') as varchar(50))
left join sma_trn_cases z on z.casscasenumber=m.matternumber
where (VALUELOW is null and VALUEHIGH is not null) or (VALUELOW is not null and VALUEHIGH is  null)