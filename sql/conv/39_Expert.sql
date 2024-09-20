INSERT INTO [dbo].[sma_MST_ExpertType]
([extsCode],[extsDscrptn],[extnRecUserID],[extdDtCreated],[extnModifyUserID],[extdDtModified],[extnLevelNo])
Select UPPER(SUBSTRING(ltrim(rtrim(DESCRIPTION)),0,4)),ltrim(rtrim(DESCRIPTION)),368,getdate(),null,null,''
From [WilliamPagerSaga].dbo.LW_A_EXPERTTYPE where ltrim(rtrim(DESCRIPTION)) not in (select ltrim(rtrim(extsDscrptn)) from sma_MST_ExpertType)
go
INSERT INTO [dbo].[sma_MST_Speciality]
([splsCode],[splnContactTypeID],[splsSpeciality],[splsSubspeciality],[splnRecUserID],[spldDtCreated],[splnModifyUserID],[spldDtModified],[splnLevelNo])
Select UPPER(SUBSTRING(ltrim(rtrim(DESCRIPTION)),0,4)),23,ltrim(rtrim(DESCRIPTION)),null,368,getdate(),null,null,'' from 
[WilliamPagerSaga].dbo.LW_A_SPECIALTY where ltrim(rtrim(DESCRIPTION)) not in (select ltrim(rtrim([splsSpeciality])) from sma_MST_Speciality)
go

insert into sma_TRN_ExpertContacts  
(ectnCaseID, ectnexpContactID,ectnExpAddressID, ectnExpertFor,ectnExpertTypeID,ectnWillTestifyYN,ectnDisclosureReqd,ectdDisclosureDt,  
  ectnSpeciality,ectnSubspeciality,ectdRetDte,ectsRetainerDoc,ectnRetainerPaid,ectsComment,ectbDocAttached,ectnRecUserID ,ectdDtCreated, ectnLevelNo)  
select distinct casnCaseID,case when i1.cinnContactID is not null then i1.cinnContactID when o1.connContactID is not null then o1.connContactID  end,
case when i1.cinnContactID is not null then ad2.addnAddressID when o1.connContactID is not null then ad1.addnAddressID  end,case when asg.PARTYTYPE=2 then 1 when asg.PARTYTYPE=1 then 0 end,extnExpertTypeID,
Case when ISTESTIFY='T' then 1 else 0 end,null,null,
splnSpecialityID,null,null,null,'0.00',case when REPORTDATE is not null then 'Report Date: '+convert(varchar,REPORTDATE)+char(13) end + case when DATEREVIEWED is not null then 'Date Reviewed: '+convert(varchar,DATEREVIEWED)+char(13) end +isnull(convert(varchar(max),n.NOTES),''),null,null,null,''
from [WilliamPagerSaga].dbo.LW_EXPERT a
left join [WilliamPagerSaga].dbo.LW_A_EXPERTTYPE b on a.EXPERTTYPEID=b.EXPERTTYPEID
left join [sma_MST_ExpertType] on ltrim(rtrim(DESCRIPTION))=ltrim(rtrim(extsDscrptn))
LEFT JOIN [WilliamPagerSaga].dbo.matrelt mat on  mat.matreltid=a.matreltid 
LEFT JOIN [WilliamPagerSaga].dbo.ASSIGN asg on asg.ASSIGNID=mat.ASSIGNID
LEFT JOIN [WilliamPagerSaga].dbo.ASSIGN expe  on mat.RELATEDASSIGNID=expe.assignID
LEFT JOIN [WilliamPagerSaga].dbo.ENTITIES e1 on e1.ENTITYID=asg.ENTITYID
LEFT JOIN [WilliamPagerSaga].dbo.ENTITIES e2 on e2.ENTITYID=expe.ENTITYID
LEFT JOIN [WilliamPagerSaga].dbo.EROLE r1 on r1.ROLEID=asg.ROLEID
LEFT JOIN [WilliamPagerSaga].dbo.EROLE r2 on r2.ROLEID=expe.ROLEID
LEFT JOIN [WilliamPagerSaga].dbo.matter m on m.matterid=expe.matterid
left join sma_trn_cases on cassCaseNumber=MATTERNUMBER
left join sma_MST_IndvContacts i1 on i1.cinsGrade=e2.ENTITYID
left join sma_mst_orgcontacts o1 on o1.connLevelNo=e2.ENTITYID 
Outer apply(Select top 1 addnAddressID from sma_MST_Address where addnContactID=o1.connContactID and addbPrimary=1 and addnContactCtgID=2) ad1
Outer apply(Select top 1 addnAddressID from sma_MST_Address where addnContactID=i1.cinnContactID and addbPrimary=1 and addnContactCtgID=1) ad2
left join [WilliamPagerSaga].dbo.LW_A_SPECIALTY s1 on s1.SPECIALTYID=a.SPECIALTYID
left join sma_MST_Speciality on  ltrim(rtrim([splsSpeciality])) =  ltrim(rtrim(s1.DESCRIPTION))
left join [WilliamPagerSaga].dbo.NOTE n on n.NOTEID=mat.NOTEID
where casnCaseID is not null 
go
Update sma_TRN_ExpertContacts
set ectsComment=convert(varchar(max),ltrim(replace(
       dbo.RegExReplace(ectsComment,'({\\)(.+?)(})|(\\)(.+?)(\b)','')
      ,'}','')     
      )) 
go

Insert Into [sma_mst_SubRoleCode]
select distinct [DESCRIPTION],5 
FROM [WilliamPagerSaga].[dbo].[LW_A_WITNESSTYPE] where [DESCRIPTION] not in (select [srcsDscrptn] from [sma_mst_SubRoleCode] where srcnroleid=5)
go
 INSERT INTO sma_TRN_CaseWitness
(witnCaseID,witnWitnesContactID,witnWitnesAdID,witnRoleID,witnFavorable,witnTestify,witdStmtReqDate,witdStmtDate,witbHasRec,witsDoc,witsComment,witnRecUserID,witdDtCreated,witnLevelNo)
Select casncaseid,case when i1.cinncontactid is not null then '1'+cast(i1.cinncontactid as varchar(20)) when o1.conncontactid is not null then '2'+cast(o1.conncontactid as varchar(20)) end,
case when i1.cinncontactid is not null then ad1.addnAddressID when o1.conncontactid is not null then ad2.addnAddressID end,[srcnCodeId],null,case when [ISTESTIFY]='T' then 2 when [ISTESTIFY]='F' then 3 else null end,
case when report_requested between '1/1/1900' and '12/31/2079' then report_requested else null end,null,null,null,isnull('REPORT DATE: '+convert(varchar(100),ReportDate),'')
+isnull(char(13)+'DATE REVIEWED: '+convert(varchar(100),[DATEREVIEWED]),'')
+isnull(char(13)+'REPORT RECEIVED: '+[REPORTRECEIVED],''),368,getdate(),''
FROM [WilliamPagerSaga].[dbo].[LW_WITNESS] w
Left join  [WilliamPagerSaga].[dbo].[Assign] a on w.assignid=a.assignid
left join [WilliamPagerSaga].[dbo].[Matter] m on m.matterid=a.matterid
left join sma_trn_cases on casscasenumber=matternumber
left join sma_mst_indvcontacts i1 on i1.cinsgrade=a.entityid
left join sma_mst_orgcontacts o1 on o1.connlevelno=a.entityid
Outer apply(Select top 1 addnAddressID from sma_MST_Address where addnContactID=i1.cinnContactID and addbPrimary=1 and addnContactCtgID=1) ad1
Outer apply(Select top 1 addnAddressID from sma_MST_Address where addnContactID=o1.connContactID and addbPrimary=1 and addnContactCtgID=2) ad2
left join [WilliamPagerSaga].[dbo].[LW_A_WITNESSTYPE] wt on wt.[WITNESSTYPEID]=w.[WITNESSTYPEID]
Outer apply(Select top 1 [srcnCodeId] from [sma_mst_SubRoleCode] where [srcsDscrptn]=wt.[DESCRIPTION] and srcnroleid=5) typ
go
alter table sma_TRN_CriticalComments disable trigger all
insert into sma_TRN_CriticalComments
select distinct caseid,0,comments,1,RecUserID,DtCreated,null,null,1,'RET' from sma_TRN_Incidents where isnull(comments,'')<>''
alter table sma_TRN_CriticalComments enable trigger all
go
update [sma_MST_CaseType]
set [cstbUseIncident1]=1,[cstsIncidentLabel1]='Incident'
go