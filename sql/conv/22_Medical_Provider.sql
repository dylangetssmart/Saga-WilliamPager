
set ansi_warnings off
Alter table sma_trn_hospitals disable trigger all

INSERT INTO [sma_TRN_Hospitals]
([hosnCaseID],[hosnContactID],[hosnContactCtg],[hosnAddressID],[hossMedProType],[hosdStartDt],[hosdEndDt],[hosnNoVisits],[hosnImpair],[hosnTotalBill]
,[hosnExpert],[hosnWillTestify],[hosnIsMediConnect],[hosnPlaintiffID],[hosbDocAttached],[hosnParentHospitalId],[hosnRecUserID],[hosdDtCreated],[hosnModifyUserID]
,[hosdDtModified],[hosnLevelNo],[hosnMedRecordFee],[hosnMedReportFee],[hosnIsReferred],[hosnComments],[hosnAuthtoDefCouns],[hosnAuthtoDefCounsDt],[hosnAccountNo])

Select distinct casnCaseID,Case when l.cinnContactID IS NOT null then l.cinnContactID when k.connContactID is not null then k.connContactID end ,Case when l.cinnContactID IS NOT null then l.cinnContactCtg when k.connContactID is not null then k.connContactCtg end
,Case when l.cinnContactID IS NOT null then IndvAddressID when k.connContactID IS not null then orgAddressID end,'M',case when sps.StartDate between'01/01/1900' and '01/01/2050' then sps.STARTDATE else null end, case when sps.endDate  between '01/01/1900' and '01/01/2050'  then sps.ENDDATE else null end,null,null,null
,null,null,null,Case when q.cinnContactID IS NOT null then p1.plnnPlaintiffID else p2.plnnPlaintiffID end ,null,null,
case when u1.usrnuserid is null then 368 else u1.usrnuserid end,case when mt.DATECREATED Is null then GETDATE() when mt.DATECREATED between '01/01/1900' and '01/01/2050'  then GETDATE() else mt.DATECREATED end,u2.usrnUserID
,mt.DATEREVISED,med.MATRELTID,null,null,null,isnull(z.description,'')+CHAR(13)+isnull(convert(varchar(6000),ltrim(replace(
       dbo.RegExReplace(NOTES,'({\\)(.+?)(})|(\\)(.+?)(\b)','')
      ,'}','')
     
      )),'') ,null,null,null
FROM [WilliamPagerSaga].dbo.LW_MEDICAL med
LEFT JOIN [WilliamPagerSaga].dbo.MATRELT mt on med.MATRELTID=mt.MATRELTID
LEFT JOIN [WilliamPagerSaga].dbo.assign aprov on  mt.RelatedAssignID=aprov.assignid
LEFT JOIN [WilliamPagerSaga].dbo.assign aplan on mt.assignid=aplan.assignid
left join WilliamPagerSaga.dbo.NOTE n on n.NOTEID=mt.NOTEID
LEFT JOIN [WilliamPagerSaga].dbo.entities eplan on aplan.entityid=eplan.entityid
LEFT JOIN [WilliamPagerSaga].dbo.entities eprov on aprov.entityid=eprov.entityid
LEFT JOIN [WilliamPagerSaga].dbo.LW_SPECIALS sps on sps.matreltid=med.MATRELTID
LEFT JOIN [WilliamPagerSaga].dbo.matter m on aplan.matterid=m.matterid
LEFT JOIN sma_TRN_CaseS on cassCaseNumber=MATTERNUMBER
LEFT JOIN sma_MST_IndvContacts l on l.cinsGrade=eprov.ENTITYID
LEFT JOIN sma_MST_OrgContacts k on k.connLevelNo=eprov.ENTITYID
outer apply(select top 1 addnaddressid as IndvAddressID from  sma_MST_Address where addnContactID=cinncontactid and addnContactCtgID=1 order by isnull(addbPrimary,0) desc) a
outer apply(select top 1 addnaddressid as orgAddressID from  sma_MST_Address where addnContactID=conncontactid and addnContactCtgID=2 order by isnull(addbPrimary,0) desc) b
LEFT JOIN sma_MST_IndvContacts q on q.cinsGrade=eplan.ENTITYID
LEFT JOIN sma_MST_orgContacts u on u.connLevelNo=eplan.ENTITYID
LEFT JOIN sma_TRN_Plaintiff p1 on p1.plnnContactID= q.cinnContactID and p1.plnnContactCtg=1 and p1.plnnCaseID=casnCaseID
LEFT JOIN sma_TRN_Plaintiff p2 on p2.plnnContactID= u.connContactID and p2.plnnContactCtg=2  and p2.plnnCaseID=casnCaseID
LEFT JOIN sma_MST_IndvContacts v on v.cinsGrade=mt.CREATORID
LEFT JOIN sma_MST_IndvContacts w on w.cinsGrade=mt.REVISORID
LEFT JOIN sma_mst_users u1 on u1.usrnContactID=v.cinnContactID
LEFT JOIN sma_mst_users u2 on u2.usrnContactID=w.cinnContactID
Outer Apply(select top 1 spt.description from [WilliamPagerSaga].dbo.LW_A_SPECIALSSUB spt where spt.SPECIALSSUBID=sps.SPECIALSSUBID) z
where casnCaseID is not null

go 
 DELETE
 FROM sma_TRN_Hospitals
 WHERE hosnHospitalID NOT IN
 (
 SELECT MAX(hosnHospitalID)
 FROM sma_TRN_Hospitals
 GROUP BY hosnCaseID,hosnContactCtg,hosnContactID,hosnPlaintiffID)
 go
Alter table sma_trn_hospitals enable trigger all    
go
INSERT INTO [sma_MST_AdmissionType]
([amtsCode],[amtsDscrptn],[amtnRecUserID],[amtdDtCreated],[amtnModifyUserID],[amtdDtModified],[amtnLevelNo])
Select UPPER(SUBSTRING(ls.DESCRIPTION,0,4)),ls.DESCRIPTION,368,getdate(),null,null,''
From WilliamPagerSaga.dbo.[LW_A_SPECIALSSUB] ls
where ls.DESCRIPTION not in (select [amtsDscrptn] from [sma_MST_AdmissionType])
go

alter table sma_TRN_Visits 
alter column vissComments varchar(4000)

Alter table [sma_TRN_Visits] disable trigger all

INSERT INTO [sma_TRN_Visits]
([vissRefTable],[visnRecordID],[visdAdmissionDt],[visnAdmissionTypeID],[visdDischargeDt],
[vissAccountNo],[visdReq4RecSent],[visdRecExpDt],[visdRecRcvdDate],[visnRecAllVisits],[visdReq4RepSent]
,[visdRepExpDt],[visdRepRcvdDate],[visnRepAllVisits],[vissComplaint],[vissTesting],[vissDiagnosis],[vissTreatmentPlan],[visnAmount],[vissChkNo],[visdChkDt],
[vissRequestId1],[vissRequestId2],[vissRecordType]
,[visbTreatmentEnded],[visnParentVisitID],[visnRecUserID],[visdDtCreated],[visnModifyUserID],[visdDtModified],[visnLevelNo],[visnRepAmount],
[visnRecAmount],[visnRepID],[visnRecID],[vissComments],[visdReq4RecSent2],[visdReq4RepSent2],[visitResultTypeID])
Select 'Hospitals',hosnHospitalID,case when ls.STARTDATE between '01/01/1900' and '12/31/2079' then  ls.STARTDATE else null end,amtnAdmsnTypeID,case when ls.ENDDATE between '01/01/1900' and '12/31/2079' then  ls.ENDDATE else null end,
NULL,NULL,NULL,NULL,0,NULL,
NULL,NULL,0,NULL,NULL,NULL,NULL,'0.00',NULL,NULL,
NULL,null,NULL,0,NULL,368,GETDATE(),NULL,NULL,NULL,NULL,NULL,NULL,NULL,
isnull('Category: '+lsp.DESCRIPTION,'') +CHAR(13)
+isnull(case when RECORDSRECEIVED='F' then 'RECORDSRECEIVED: '+'No'+CHAR(13) when RECORDSRECEIVED='T' then 'RECORDSRECEIVED: '+'Yes'+CHAR(13) end,'')
+isnull(case when REPORTRECEIVED='F' then 'REPORTRECEIVED: '+'No'+CHAR(13) when REPORTRECEIVED='T' then 'REPORTRECEIVED: '+'Yes'+CHAR(13) end,'')
+isnull(case when REPORTDATE IS not null then 'REPORTDATE: '+convert(varchar(10),REPORTDATE,101)+CHAR(13) end,'')
+isnull(case when RECORDS_REQUESTED IS not null then 'Records Requested: '+convert(varchar(10),RECORDS_REQUESTED,101)+CHAR(13) end,'')
+isnull(case when REVIEWDATE IS not null then 'REVIEWDATE: '+convert(varchar(10),REVIEWDATE,101)+CHAR(13) end,'')
+isnull(case when VISITS IS not null then 'VISITS: '+convert(varchar,VISITS)+CHAR(13) end,'')
+isnull('Comments: '+convert(varchar(4000),comments),''),NULL,null,null
From WilliamPagerSaga.dbo.[LW_SPECIALS] ls
left join WilliamPagerSaga.dbo.[LW_A_SPECIALSSUB] lss on lss.SPECIALSSUBID=ls.SPECIALSSUBID
left join [sma_MST_AdmissionType] on amtsDscrptn=lss.DESCRIPTION
left join [WilliamPagerSaga].[dbo].[LW_MEDICAL] lm on lm.MATRELTID=ls.MATRELTID
left join WilliamPagerSaga.dbo.[LW_A_SPECIALS] lsp on lsp.SPECIALSID=ls.SPECIALSID
left join sma_TRN_Hospitals on hosnLevelNo=lm.MATRELTID
--where lsp.DESCRIPTION like '%medical%'
Alter table [sma_TRN_Visits] enable trigger all     
go
alter table sma_TRN_SpDamages disable trigger all
insert into sma_TRN_SpDamages
( spdsRefTable,spdnRecordID,spdsBillNo,spdnBillAmt,spddSubmittedDt,spdnPayerInsCoID,spdnRole,spdsAccntNo,spdnAmtPaid,spdnAdjustment,spdnBalance,spdnLienAmt,spdbLienConfirmed,spdnStaffID,spddCommunicateDt,spddWrittenDt,spddFinalConfirmed,spddFirmAckSignOff,spdnLienorContact,spdsComments,spdbDocAttached,spdnRecUserID,spddDtCreated,spdnLevelNo, spdnVisitId)
select distinct 'Hospitals',hosnHospitalID,null,SERVICEAMOUNT,SUBMITTEDDATE,
null,null,null,null,null,null,null,0,0,null,null,null,null,null,null,null,368,GETDATE(),'', null
From WilliamPagerSaga.dbo.[LW_SPECIALS] ls
left join WilliamPagerSaga.dbo.[LW_A_SPECIALSSUB] lss on lss.SPECIALSSUBID=ls.SPECIALSSUBID
left join [sma_MST_AdmissionType] on amtsDscrptn=lss.DESCRIPTION
left join [WilliamPagerSaga].[dbo].[LW_MEDICAL] lm on lm.MATRELTID=ls.MATRELTID
left join WilliamPagerSaga.dbo.[LW_A_SPECIALS] lsp on lsp.SPECIALSID=ls.SPECIALSID
left join sma_TRN_Hospitals on hosnLevelNo=lm.MATRELTID
where hosnHospitalID is not null and ISNULL(SERVICEAMOUNT,0)>0
alter table sma_TRN_SpDamages enable trigger all
go
INSERT INTO [sma_TRN_MedicalProviderRequest]
([MedPrvCaseID],[MedPrvPlaintiffID],[MedPrvRequestdate],[MedPrvCompleteDate],[MedPrvFromDate],[MedPrvToDate],[MedPrvComments],[MedPrvAssignee]
,[MedPrvHighPriority],[MedPrvAssignedBy],[MedPrvRecUserID],[MedPrvRecCreatedDt],[MedPrvModifiedUserId],[MedPrvModifiedDt],[MedPrvSendRecordsTo]
,[MedPrvRecordType],[MedPrvhosnHospitalID],[MedPrvCancel],[MedPrvIsAllRecords],[MedPrvStatusId],[MedPrvStatusDate]
,[MedPrvFollowUpDate],[MedPrvUntilToday],[MedPrvAuthorisationReceived])
select distinct hosnCaseID,hosnPlaintiffID,case when RECORDS_REQUESTED between '1/1/1900' and '12/31/2079' then RECORDS_REQUESTED end,
case when RECORDS_REQUESTED between '1/1/1900' and '12/31/2079' then RECORDS_REQUESTED end,
case when RECORDS_REQUESTED between '1/1/1900' and '12/31/2079' then RECORDS_REQUESTED end,
null,ISNULL(convert(varchar(max),comments),''),usrnUserID,0,usrnUserID,usrnUserID,case when RECORDS_REQUESTED between '1/1/1900' and '12/31/2079' then RECORDS_REQUESTED end,null,null
,0,0,hosnHospitalID,NULL,0,case when RECORDSRECEIVED='T' then 3 else 2 end,case when RECORDS_REQUESTED between '1/1/1900' and '12/31/2079' then RECORDS_REQUESTED end,case when RECORDS_REQUESTED between '1/1/1900' and '12/31/2079' then RECORDS_REQUESTED end,1,NULL
From WilliamPagerSaga.dbo.[LW_SPECIALS] ls
left join WilliamPagerSaga.dbo.[LW_A_SPECIALSSUB] lss on lss.SPECIALSSUBID=ls.SPECIALSSUBID
left join [sma_MST_AdmissionType] on amtsDscrptn=lss.DESCRIPTION
left join [WilliamPagerSaga].[dbo].[LW_MEDICAL] lm on lm.MATRELTID=ls.MATRELTID
left join WilliamPagerSaga.dbo.[LW_A_SPECIALS] lsp on lsp.SPECIALSID=ls.SPECIALSID
left join sma_TRN_Hospitals on hosnLevelNo=lm.MATRELTID
outer apply(select top 1 usrnuserid from sma_TRN_CaseStaff left join sma_MST_SubRole on sbrnSubRoleId=cssnRoleID join sma_MST_Users on usrnContactID=cssnStaffID where cssdToDate is null and cssnCaseID=hosnCaseID order by case when sbrsDscrptn like '%primary paralegal%' then 2 when sbrsDscrptn like '%paralegal%' then 1  else 0 end desc) z
--where RECORDS_REQUESTED is not null and REPORTRECEIVED='F' and RECORDSRECEIVED='F'
go

select spdnRecordID,sum(spdnBillAmt) as TotBillAmt into #tmpspbilamt from sma_TRN_SpDamages
where spdsRefTable='Hospitals'
group by spdnRecordID


alter table sma_TRN_Hospitals disable trigger all
update a
set hosnTotalBill=TotBillAmt
from sma_TRN_Hospitals a
join  #tmpspbilamt on  hosnHospitalID=spdnRecordID
where hosnTotalBill is null
alter table sma_TRN_Hospitals enable trigger all

drop table  #tmpspbilamt
go
If not exists(select * from sma_MST_ProviderTypes where prvsDscrptn='Property Damage')
begin
Insert into sma_MST_ProviderTypes
select 'PROPDAM','Property Damage',368,GETDATE(),null,null,'' 
end
INSERT INTO [dbo].[sma_TRN_OthrProviders]
([otpnCaseID],[otpnAddressID],[otpnContactID],[otpnContactCtg],[otpnType],[otpdStartDt],[otpdEndDt],[otpnNoVisits],[otpnTotalBill]
,[otpnPlaintiffID],[otpbDocAttached],[otpnRecUserID],[otpdDtCreated],[otpnModifyUserID],[otpdDtModified],[otpnLevelNo])
select distinct casnCaseID,Case when l.cinnContactID IS NOT null then IndvAddressID when k.connContactID IS not null then orgAddressID end,
Case when l.cinnContactID IS NOT null then l.cinnContactID when k.connContactID is not null then k.connContactID end ,
Case when l.cinnContactID IS NOT null then l.cinnContactCtg when k.connContactID is not null then k.connContactCtg end,
prvnProvTypeID,
case when ls.StartDate between'01/01/1900' and '01/01/2050' then ls.STARTDATE else null end, case when ls.endDate  between '01/01/1900' and '01/01/2050'  then ls.ENDDATE else null end,
null,null,Case when q.cinnContactID IS NOT null then p1.plnnPlaintiffID else p2.plnnPlaintiffID end,null,
case when u1.usrnuserid is null then 368 else u1.usrnuserid end,case when mt.DATECREATED Is null then GETDATE() when mt.DATECREATED between '01/01/1900' and '01/01/2050'  then GETDATE() else mt.DATECREATED end,u2.usrnUserID,
mt.DATEREVISED,ls.LW_SPECIALSID
From WilliamPagerSaga.dbo.[LW_SPECIALS] ls
LEFT JOIN [WilliamPagerSaga].dbo.MATRELT mt on ls.MATRELTID=mt.MATRELTID
LEFT JOIN [WilliamPagerSaga].dbo.assign aprov on  mt.RelatedAssignID=aprov.assignid
LEFT JOIN [WilliamPagerSaga].dbo.assign aplan on mt.assignid=aplan.assignid
left join WilliamPagerSaga.dbo.NOTE n on n.NOTEID=mt.NOTEID
LEFT JOIN [WilliamPagerSaga].dbo.matter m on aplan.matterid=m.matterid
LEFT JOIN sma_TRN_CaseS on cassCaseNumber=MATTERNUMBER
LEFT JOIN sma_MST_IndvContacts l on l.cinsGrade=aprov.ENTITYID
LEFT JOIN sma_MST_OrgContacts k on k.connLevelNo=aprov.ENTITYID
outer apply(select top 1 addnaddressid as IndvAddressID from  sma_MST_Address where addnContactID=cinncontactid and addnContactCtgID=1 order by isnull(addbPrimary,0) desc) a
outer apply(select top 1 addnaddressid as orgAddressID from  sma_MST_Address where addnContactID=conncontactid and addnContactCtgID=2 order by isnull(addbPrimary,0) desc) b
LEFT JOIN sma_MST_IndvContacts q on q.cinsGrade=aplan.ENTITYID
LEFT JOIN sma_MST_orgContacts u on u.connLevelNo=aplan.ENTITYID
LEFT JOIN sma_TRN_Plaintiff p1 on p1.plnnContactID= q.cinnContactID and p1.plnnContactCtg=1 and p1.plnnCaseID=casnCaseID
LEFT JOIN sma_TRN_Plaintiff p2 on p2.plnnContactID= u.connContactID and p2.plnnContactCtg=2  and p2.plnnCaseID=casnCaseID
LEFT JOIN sma_MST_IndvContacts v on v.cinsGrade=mt.CREATORID
LEFT JOIN sma_MST_IndvContacts w on w.cinsGrade=mt.REVISORID
LEFT JOIN sma_mst_users u1 on u1.usrnContactID=v.cinnContactID
LEFT JOIN sma_mst_users u2 on u2.usrnContactID=w.cinnContactID
left join WilliamPagerSaga.dbo.[LW_A_SPECIALSSUB] lss on lss.SPECIALSSUBID=ls.SPECIALSSUBID 
cross join  sma_MST_ProviderTypes 
where lss.DESCRIPTION like '%damage%' and  prvsDscrptn='Property Damage'

go
insert into sma_TRN_SpDamages
( spdsRefTable,spdnRecordID,spdsBillNo,spdnBillAmt,spddSubmittedDt,spdnPayerInsCoID,spdnRole,spdsAccntNo,spdnAmtPaid,spdnAdjustment,spdnBalance,spdnLienAmt,spdbLienConfirmed,spdnStaffID,spddCommunicateDt,spddWrittenDt,spddFinalConfirmed,spddFirmAckSignOff,spdnLienorContact,spdsComments,spdbDocAttached,spdnRecUserID,spddDtCreated,spdnLevelNo, spdnVisitId)
select distinct 'OthrProviders',otpnProviderID,null,SERVICEAMOUNT,SUBMITTEDDATE,
null,null,null,null,null,null,null,0,0,null,null,null,null,null,null,null,368,GETDATE(),'', null
From WilliamPagerSaga.dbo.[LW_SPECIALS] ls
left join WilliamPagerSaga.dbo.[LW_A_SPECIALSSUB] lss on lss.SPECIALSSUBID=ls.SPECIALSSUBID
left join [sma_MST_AdmissionType] on amtsDscrptn=lss.DESCRIPTION
left join WilliamPagerSaga.dbo.[LW_A_SPECIALS] lsp on lsp.SPECIALSID=ls.SPECIALSID
left join sma_TRN_OthrProviders on otpnLevelNo=ls.LW_SPECIALSID
where otpnProviderID is not null and ISNULL(SERVICEAMOUNT,0)>0 and lss.DESCRIPTION like '%damage%'



