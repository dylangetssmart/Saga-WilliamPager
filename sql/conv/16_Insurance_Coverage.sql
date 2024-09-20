INSERT INTO [sma_MST_InsuranceType]
([intsCode],[intsDscrptn],[intnRecUserID],[intdDtCreated],[intnModifyUserID],[intdDtModified],[intnLevelNo])
select distinct '',DESCRIPTION,368,GETDATE(),null,null,''  
from  [WilliamPagerSaga].dbo.lw_a_coveragetype icoverage
where DESCRIPTION not in (select intsDscrptn from [sma_MST_InsuranceType])

go
Alter table [sma_TRN_InsuranceCoverage] Disable Trigger All
INSERT INTO [sma_TRN_InsuranceCoverage]
([incnCaseID],[incnInsContactID],[incnInsAddressID],[incbCarrierHasLienYN],[incnInsType],[incnAdjContactId],[incnAdjAddressID],[incsPolicyNo],[incsClaimNo]
,[incnStackedTimes],[incsComments],[incnInsured],[incnCovgAmt],[incnDeductible],[incnUnInsPolicyLimit],[incnUnderPolicyLimit],[incbPolicyTerm],[incbTotCovg],[incsPlaintiffOrDef]
,[incnPlaintiffIDOrDefendantID],[incnTPAdminOrgID],[incnTPAdminAddID],[incnTPAdjContactID],[incnTPAdjAddID],[incsTPAClaimNo],[incnRecUserID],[incdDtCreated],[incnModifyUserID],[incdDtModified]
,[incnLevelNo],[incnUnInsPolicyLimitAcc],[incnUnderPolicyLimitAcc],[incb100Per],[incnMVLeased],[incnPriority],[incbDelete],[incnauthtodefcoun],[incnauthtodefcounDt],incbPrimary)

select distinct casnCaseID,insco.connContactID,ad1.addnAddressID,'',intnInsuranceTypeID,case when i1.cinnContactID is null then o1.connContactID else i1.cinnContactID end,case when ad2.addnAddressID is null then ad3.addnAddressID else ad2.addnAddressID end,i.POLICYNUMBER,i.CLAIMNUMBER
,'',isnull('POLICYSTARTED: '+convert(varchar(20),POLICYSTARTED,101)+char(13),'')+isnull('Expires: '+convert(varchar(20),EXPIRES,101)+char(13),'')+convert(varchar(4000),ltrim(replace(
       dbo.RegExReplace(notes,'({\\)(.+?)(})|(\\)(.+?)(\b)','')
      ,'}','')
      
      )) ,case when ad4.addnAddressID IS not null then ad4.addnAddressID when ad5.addnAddressID IS not null then ad5.addnAddressID end,'0.00','0.00',isnull(i.LIMITLOW,'0.00'),'0.00',1,0,case when p1.plnnPlaintiffID IS NOT null then 'P' when p2.plnnPlaintiffID IS not null then 'P'
when d1.defnDefendentID IS NOT null then 'D' when d2.defnDefendentID IS not null then 'D' end,case when p1.plnnPlaintiffID IS NOT null then p1.plnnPlaintiffID when p2.plnnPlaintiffID IS not null then p2.plnnPlaintiffID
when d1.defnDefendentID IS NOT null then d1.defnDefendentID when d2.defnDefendentID IS not null then d2.defnDefendentID end,0,0,0,0,'',368,GETDATE(),'',''
,'',isnull(i.LIMITHIGH,'0.00'),'0.00',0,0,1,0,'',null,0
From [WilliamPagerSaga].dbo.lw_ins i
left join WilliamPagerSaga.dbo.ASSIGN a on a.ASSIGNID=i.ADJUSTERASSIGNID
LEFT JOIN [WilliamPagerSaga].dbo.matrelt mat on  mat.matreltid=i.matreltid 
LEFT JOIN [WilliamPagerSaga].dbo.ASSIGN asg on asg.ASSIGNID=mat.ASSIGNID
LEFT JOIN [WilliamPagerSaga].dbo.ASSIGN ainscomp  on mat.RELATEDASSIGNID=ainscomp.assignID
LEFT JOIN [WilliamPagerSaga].dbo.assign aparty on i.INSUREDASSIGNID=aparty.assignid
LEFT JOIN [WilliamPagerSaga].dbo.assign adjuster on i.ADJUSTERASSIGNID=adjuster.assignid
LEFT JOIN [WilliamPagerSaga].dbo.lw_a_coveragetype icoverage on icoverage.coveragetypeid=i.coveragetypeid
LEFT JOIN [WilliamPagerSaga].dbo.ASSIGN ains  on i.insuredassignid=ains.assignid
left join [WilliamPagerSaga].dbo.matter matter on matter.MATTERID=asg.MATTERID
LEFT JOIN [WilliamPagerSaga].dbo.entities einscompany on ainscomp.entityid=einscompany.entityid
LEFT JOIN [WilliamPagerSaga].dbo.entities einsadjuster on adjuster.ASSIGNID=einsadjuster.entityid
LEFT JOIN [WilliamPagerSaga].dbo.entities eparty on asg.ENTITYID=eparty.entityid
LEFT JOIN sma_TRN_CaseS on cassCaseNumber=MATTERNUMBER
LEFT JOIN sma_MST_OrgContacts insco on insco.connLevelNo=einscompany.ENTITYID
left join WilliamPagerSaga.dbo.ENTITIES e on e.ENTITYID=a.ENTITYID
left join sma_MST_IndvContacts i1 on i1.cinsGrade=a.ENTITYID
left join sma_MST_OrgContacts o1 on o1.connLevelNo=a.ENTITYID
left join sma_MST_IndvContacts i5 on i5.cinsGrade=aparty.ENTITYID
left join sma_MST_OrgContacts o5 on o5.connLevelNo=aparty.ENTITYID
Outer apply(Select top 1 addnAddressID from sma_MST_Address where addnContactID=o1.connContactID and addbPrimary=1 and addnContactCtgID=2) ad3
left join sma_mst_orgcontacts o2 on o2.connLevelNo=eparty.ENTITYID 
left join sma_MST_IndvContacts i2 on i2.cinsGrade=eparty.ENTITYID 
left join sma_TRN_Defendants d1 on d1.defnContactID=o2.connContactID and d1.defnContactCtgID=2 and d1.defnCaseID=casncaseid
left join sma_TRN_Defendants d2 on d2.defnContactID=i2.cinnContactID and d2.defnContactCtgID=1 and d2.defnCaseID=casncaseid
left join sma_TRN_Plaintiff p1 on p1.plnnContactID=o2.connContactID and p1.plnnContactCtg=2 and p1.plnnCaseID=casncaseid
left join sma_TRN_Plaintiff p2 on p2.plnnContactID=i2.cinnContactID and p2.plnnContactCtg=1 and p2.plnnCaseID=casncaseid
Outer apply(Select top 1 addnAddressID from sma_MST_Address where addnContactID=insco.connContactID and addbPrimary=1 and addnContactCtgID=2) ad1
Outer apply(Select top 1 addnAddressID from sma_MST_Address where addnContactID=i1.cinnContactID and addbPrimary=1 and addnContactCtgID=1) ad2
Outer apply(Select top 1 addnAddressID from sma_MST_Address where addnContactID=i5.cinnContactID and addbPrimary=1 and addnContactCtgID=1) ad4
Outer apply(Select top 1 addnAddressID from sma_MST_Address where addnContactID=o5.connContactID and addbPrimary=1 and addnContactCtgID=2) ad5
LEFT JOIN [sma_MST_InsuranceType] on intsDscrptn=icoverage.DESCRIPTION
left join WilliamPagerSaga.dbo.NOTE n on n.NOTEID=mat.NOTEID
where  casnCaseID is not null 
go
Update a
set incsPlaintiffOrDef='P',incnPlaintiffIDOrDefendantID=plnnPlaintiffID
from sma_TRN_InsuranceCoverage a
left join sma_TRN_Plaintiff on plnnCaseID=incnCaseID and plnbIsPrimary=1
where incsPlaintiffOrDef is null
Alter table [sma_TRN_InsuranceCoverage] eNABLE Trigger All
go

alter table sma_TRN_InsuranceCoverage disable trigger all
delete from sma_TRN_InsuranceCoverage where incnInsCovgID not in (
select min(incnInsCovgID) from sma_TRN_InsuranceCoverage
where incnAdjContactId is null and incnAdjAddressID is null and incsPolicyNo is null
group by incnCaseID,incnInsContactID,incnInsType,incnInsAddressID,incsPlaintiffOrDef,incnPlaintiffIDOrDefendantID,incnInsured)
and incnAdjContactId is null and incnAdjAddressID is null and incsPolicyNo is null
alter table sma_TRN_InsuranceCoverage enable trigger all

alter table sma_TRN_InsuranceCoverage disable trigger all
delete from sma_TRN_InsuranceCoverage where incnInsCovgID not in (
select min(incnInsCovgID) from sma_TRN_InsuranceCoverage
where incnAdjContactId is not null and incnAdjAddressID is not null and incsPolicyNo is null
group by incnCaseID,incnInsContactID,incnInsType,incnInsAddressID,incsPlaintiffOrDef,incnPlaintiffIDOrDefendantID,incnInsured,incnAdjContactId,incnAdjAddressID)
and incnAdjContactId is not null and incnAdjAddressID is not null and incsPolicyNo is null
alter table sma_TRN_InsuranceCoverage enable trigger all


alter table sma_TRN_InsuranceCoverage disable trigger all
delete from sma_TRN_InsuranceCoverage where incnInsCovgID not in (
select min(incnInsCovgID) from sma_TRN_InsuranceCoverage
where incnAdjContactId is  null and incnAdjAddressID is  null and incsPolicyNo is not null
group by incnCaseID,incnInsContactID,incnInsType,incnInsAddressID,incsPlaintiffOrDef,incnPlaintiffIDOrDefendantID,incnInsured,incsPolicyNo)
and incnAdjContactId is  null and incnAdjAddressID is  null and incsPolicyNo is not null
alter table sma_TRN_InsuranceCoverage enable trigger all
