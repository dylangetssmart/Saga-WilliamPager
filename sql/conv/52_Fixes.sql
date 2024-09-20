go
alter table sma_TRN_Plaintiff disable trigger all
delete from sma_TRN_Plaintiff where plnnPlaintiffID not in (
select min(plnnPlaintiffID) from sma_TRN_Plaintiff group by plnnCaseID,plnnContactID,plnnContactCtg)
alter table sma_TRN_Plaintiff enable trigger all
go

INSERT INTO [sma_MST_OriginalContactTypes]
([octsCode],[octnContactCtgID],[octsDscrptn],[octnRecUserID],[octdDtCreated],[octnModifyUserID],[octdDtModified],[octnLevelNo])
 Select distinct UPPER(SUBSTRING(et.DESCRIPTION,0,5)),1,DESCRIPTION,368,GETDATE(),null,null,''
 FROM [WilliamPagerSaga].[dbo].[ENTITIES] e
left join [WilliamPagerSaga].[dbo].enttype et on e.ENTITYTYPEID=et.ENTITYTYPEID
where  ISPERSON='t' and FIRST_DBA is not null
and et.DESCRIPTION not in (select [octsDscrptn] from [sma_MST_OriginalContactTypes] where [octnContactCtgID]=1)
go
alter table [sma_TRN_Notes] disable trigger all
--Truncate table sma_trn_notes
INSERT INTO [sma_TRN_Notes]
([notnCaseID],[notnNoteTypeID],[notmDescription],[notmPlainText],[notnContactCtgID],[notnContactId],[notsPriority],[notnFormID],[notnRecUserID],[notdDtCreated],[notnModifyUserID],[notdDtModified],[notnLevelNo],[notdDtInserted],notnSubject)
select Caseid,nttnNoteTypeID,comments,isnull(comments,''),NULL,NULL,'Normal',NULL,RecUserID,DtCreated,NULL,NULL,0,DtCreated,NULL 
 from sma_TRN_Incidents cross join sma_MST_NoteTypes where isnull(comments,'')<>''
 and nttsDscrptn='General & Miscellaneous Notes'
 alter table [sma_TRN_Notes] enable trigger all

 go

 alter table sma_TRN_Incidents disable trigger all
--Truncate table sma_trn_notes
 update sma_TRN_Incidents set Comments=''
 alter table sma_TRN_Incidents enable trigger all
 go
 insert into sma_mst_SubRoleCode
 select distinct csssComments,10 from sma_TRN_CaseStaff where isnull(csssComments,'')<>'' and  not exists(
 select * from sma_mst_SubRoleCode  where  srcnRoleID=10 and  srcsDscrptn=csssComments)
 go
insert into sma_MST_SubRole
select distinct '',10,srcsDscrptn,0,0,368,getdate(),null,null,0,null,null,srcnCodeId
FROM sma_mst_SubRoleCode where  srcnRoleID=10 and not exists(select * from sma_MST_SubRole where sbrnRoleID=10 and sbrnTypeCode=srcnCodeId)
go
update sma_MST_SOLDetails set  sldnSOLTypeID=14 where sldnSOLTypeID =3
go
update sma_MST_SOLDetails set  sldnFromIncident=0 where sldnFromIncident is null
go
alter table sma_TRN_Negotiations disable trigger all
update sma_TRN_Negotiations set negsComments=replace(negsComments,'Default Entity Note Description','')

alter table sma_TRN_Negotiations enable trigger all
go  
update sma_MST_AdminParameters set adpsKeyValue ='1000'  where adpsKeyGroup='CaseDisbursement' and adpsKeyName='DefaultDisbursementLimit'
and isnull(adpsKeyValue,'') ='' 
go

Alter table sma_TRN_Incidents disable trigger all

Update i set IncidentFacts= ltrim(replace(
       dbo.RegExReplace(notes,'({\\)(.+?)(})|(\\)(.+?)(\b)','')
      ,'}','')      
      )
from sma_TRN_Incidents i
JOIN sma_trn_cases on casnCaseID=CaseId
JOIN [WilliamPagerSaga].[dbo].[Matter] b on b.MATTERNUMBER=cassCaseNumber
JOIN [WilliamPagerSaga].[dbo].[LW_MATTER] a on a.MATTERID=b.MATTERID
join [WilliamPagerSaga].[dbo].[NOTE] e on e.NOTEID=a.FACTSUMMARYNOTEID 
where isnull(IncidentFacts,'') =''

Alter table sma_TRN_Incidents enable trigger all
go
Insert into sma_TRN_PlaintiffInjury
select injnPlaintiffId,injnCaseId,injnOtherInj,null,null,null,null,null,null,injnRecUserID,isnull(injdDtCreated,getdate()),NULL,NULL
from sma_TRN_Injury where not exists(
select * from sma_TRN_PlaintiffInjury where plinPlaintiffID=injnPlaintiffId and injnCaseId=plinCaseID)
go
update p set  plisInjuriesSummary = injnOtherInj from sma_TRN_Injury
JOIN sma_TRN_PlaintiffInjury p on injnCaseId=plinCaseID and injnPlaintiffId=plinPlaintiffID
where isnull(cast(plisInjuriesSummary as nvarchar(max)),'')='' and isnull(injnOtherInj,'')<>''
go
update sma_TRN_Injury
set injnOtherInj=injsDescription,injsDescription=''
go
update sma_TRN_PlaintiffInjury
set plisPleadingsSummary=plisInjuriesSummary
go
update p set  plisInjuriesSummary = injnOtherInj from sma_TRN_Injury
JOIN sma_TRN_PlaintiffInjury p on injnCaseId=plinCaseID and injnPlaintiffId=plinPlaintiffID
go

Insert into sma_MST_MedicalProvideSpeciality
Select distinct DESCRIPTION,getdatE(),368,NULL,NULL FROM [WilliamPagerSaga].[dbo].[LW_A_SPECIALTY] where not exists(select * from sma_MST_MedicalProvideSpeciality where spDescription=DESCRIPTION)
and isnull(DESCRIPTION,'')<>''
go
Insert into sma_MST_MedicalProvideSubSpeciality
Select distinct sub.DESCRIPTION,getdatE(),368,null,null,splid
FROM [WilliamPagerSaga].dbo.LW_MEDICAL med
JOIN  [WilliamPagerSaga].[dbo].[LW_A_SUBSPECIALTY] sub on med.SUBSPECIALTYID=sub.SUBSPECIALTYID
left join [WilliamPagerSaga].[dbo].[LW_A_SPECIALTY] spe on spe.SPECIALTYID=med.SPECIALTYID
outer apply(select top 1 * from sma_MST_MedicalProvideSpeciality where spDescription=spe.DESCRIPTION)z
where isnull(sub.DESCRIPTION ,'')<>'' and not exists(select * from sma_MST_MedicalProvideSubSpeciality where sub.DESCRIPTION=subspDescription and spid=splID)
go

Insert into sma_TRN_MedicalProviderSpecialitySubSpeciality
select distinct splid,subsplID,cinnContactID,1,getdate(),368,null,null FROM [WilliamPagerSaga].dbo.LW_MEDICAL med
LEFT JOIN [WilliamPagerSaga].dbo.MATRELT mt on med.MATRELTID=mt.MATRELTID
LEFT JOIN [WilliamPagerSaga].dbo.assign aprov on  mt.RelatedAssignID=aprov.assignid
LEFT JOIN [WilliamPagerSaga].dbo.assign aplan on mt.assignid=aplan.assignid
left join WilliamPagerSaga.dbo.NOTE n on n.NOTEID=mt.NOTEID
LEFT JOIN [WilliamPagerSaga].dbo.entities eplan on aplan.entityid=eplan.entityid
LEFT JOIN [WilliamPagerSaga].dbo.entities eprov on aprov.entityid=eprov.entityid
LEFT JOIN [WilliamPagerSaga].dbo.LW_SPECIALS sps on sps.matreltid=med.MATRELTID
LEFT JOIN [WilliamPagerSaga].dbo.matter m on aplan.matterid=m.matterid
LEFT JOIN sma_TRN_CaseS on cassCaseNumber=MATTERNUMBER
 JOIN sma_MST_IndvContacts l on l.cinsGrade=eprov.ENTITYID
 LEFT JOIN [WilliamPagerSaga].[dbo].[LW_A_SPECIALTY] m1 on m1.SPECIALTYID=med.SPECIALTYID
outer apply(select top 1 * from sma_MST_MedicalProvideSpeciality where spDescription=m1.DESCRIPTION)z
LEFT JOIN [WilliamPagerSaga].[dbo].[LW_A_SUBSPECIALTY] sub on med.SUBSPECIALTYID=sub.SUBSPECIALTYID
Left join sma_MST_MedicalProvideSubSpeciality on sub.DESCRIPTION=subspDescription and spid=splID
--LEFT JOIN sma_MST_OrgContacts k on k.connLevelNo=eprov.ENTITYID
where  med.SPECIALTYID is not null
and not exists(select * from sma_TRN_MedicalProviderSpecialitySubSpeciality where mdprvContactctgID=1 and mdprvContactID=cinnContactID)
go

Insert into sma_TRN_MedicalProviderSpecialitySubSpeciality
select distinct splid,subsplID,connContactID,2,getdate(),368,null,null FROM [WilliamPagerSaga].dbo.LW_MEDICAL med
LEFT JOIN [WilliamPagerSaga].dbo.MATRELT mt on med.MATRELTID=mt.MATRELTID
LEFT JOIN [WilliamPagerSaga].dbo.assign aprov on  mt.RelatedAssignID=aprov.assignid
LEFT JOIN [WilliamPagerSaga].dbo.assign aplan on mt.assignid=aplan.assignid
left join WilliamPagerSaga.dbo.NOTE n on n.NOTEID=mt.NOTEID
LEFT JOIN [WilliamPagerSaga].dbo.entities eplan on aplan.entityid=eplan.entityid
LEFT JOIN [WilliamPagerSaga].dbo.entities eprov on aprov.entityid=eprov.entityid
LEFT JOIN [WilliamPagerSaga].dbo.LW_SPECIALS sps on sps.matreltid=med.MATRELTID
LEFT JOIN [WilliamPagerSaga].dbo.matter m on aplan.matterid=m.matterid
LEFT JOIN sma_TRN_CaseS on cassCaseNumber=MATTERNUMBER
JOIN sma_MST_OrgContacts k on k.connLevelNo=eprov.ENTITYID
 LEFT JOIN [WilliamPagerSaga].[dbo].[LW_A_SPECIALTY] m1 on m1.SPECIALTYID=med.SPECIALTYID
outer apply(select top 1 * from sma_MST_MedicalProvideSpeciality where spDescription=m1.DESCRIPTION)z
LEFT JOIN [WilliamPagerSaga].[dbo].[LW_A_SUBSPECIALTY] sub on med.SUBSPECIALTYID=sub.SUBSPECIALTYID
Left join sma_MST_MedicalProvideSubSpeciality on sub.DESCRIPTION=subspDescription and spid=splID

where  med.SPECIALTYID is not null
and not exists(select * from sma_TRN_MedicalProviderSpecialitySubSpeciality where mdprvContactctgID=2 and mdprvContactID=connContactID)
go
update sma_MST_CaseGroup set IncidentTypeID=1 where IncidentTypeID is null
go
update sma_TRN_LostWages set ltwsType=11 where ltwsType='Lost Wages'
go
update sma_TRN_LostWages set ltwsType=12 where ltwsType='General'
go
INSERT INTO [sma_TRN_UDFValues]
([udvnUDFID],[udvsScreenName],[udvsUDFCtg],[udvnRelatedID],[udvnSubRelatedID],[udvsUDFValue],[udvnRecUserID],[udvdDtCreated],[udvnModifyUserID],[udvdDtModified],[udvnLevelNo])
select distinct udfnUDFID,udfsScreenName,udfsUDFCtg,casnCaseID,'',convert(varchar(4000),LOCATIONSTREET),368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.MATTER a
left join WilliamPagerSaga.dbo.LW_MATTER b on a.MATTERID=b.MATTERID
left join sma_trn_cases on cassCaseNumber=MATTERNUMBER
left join sma_MST_CaseType on cstnCaseTypeID=casnOrgCaseTypeID
left join sma_MST_CaseGroup CG on cstnGroupID=cgpnCaseGroupID
left join [sma_MST_IncidentTypes] on LTRIM(RTRIM('frmIncident'))=LTRIM(RTRIM([IncidentType]))
left join sma_MST_UDFDefinition on udfnRelatedPK=CG.IncidentTypeID
where udfsUDFName='location' and ISNULL(LOCATIONSTREET,'')<>'' and udfsUDFCtg='I' and not exists(select * from sma_TRN_UDFValues where udvnRelatedID=casnCaseID and udvnUDFID=udfnUDFID)

