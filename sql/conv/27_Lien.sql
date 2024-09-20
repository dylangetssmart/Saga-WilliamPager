
INSERT INTO [sma_MST_LienType]
([lntsCode],[lntsDscrptn],[lntnRecUserID],[lntdDtCreated],[lntnModifyUserID],[lntdDtModified],[lntnLevelNo])
SELECT distinct '',DESCRIPTION,368,GETDATE(),null,null,''  FROM [WilliamPagerSaga].[dbo].[LW_LIENS] a
join [WilliamPagerSaga].[dbo].[LW_A_LIENCATEGORY] b on a.[LIENCATEGORYID]= b.[LIENCATEGORYID]
  except 
SELECT distinct '',[lntsDscrptn],368,GETDATE(),null,null,'' FROM [sma_MST_LienType]  

Alter table [sma_TRN_Lienors] disable trigger all

INSERT INTO [sma_TRN_Lienors]
([lnrnLienorContactCtgID],[lnrnLienorContactID],[lnrnLienorAddressID],[lnrnLienorRelaContactID],[lnrnPlaintiffID],[lnrnCaseID],[lnrnLienorTypeID],[lnrnAgentContactCtg],[lnrnAgentContactID],[lnrnAgentAddressID]
,[lnrnUnCnfrmdLienAmount],[lnrnCnfrmdLienAmount],[lnrnNegLienAmount],[lnrsFileNo],[lnrnPolicyReceipt],[lnrnERISA],[lnrdNoticeDate],[lnrsCertifiedMail],[lnrdRcptSignedDt],[lnrsComments],[lnrbDocAttached]
,[lnrnRecUserID],[lnrdDtCreated],[lnrnModifyUserID],[lnrdDtModified],[lnrnLevelNo],[lnrnAgentPersonCtg],[lnrnAgentPersonContactID],[lnrnAgentPersonAddID],[lnrnLienorRelaAddID],[lnrnFinal])
Select  case when o.connContactID IS NOT null then 2 when p.cinnContactID is not null then 1 end,  case when o.connContactID IS NOT null then o.connContactID when p.cinnContactID is not null then p.cinnContactID end
,case when o.connContactID IS NOT null then orgAddressID when p.cinnContactID is not null then IndvAddressID end,null,plnnPlaintiffID,casnCaseID,lntnLienTypeID,null,null,null,
LIENDENIEDAMOUNT,LIENAMOUNT,LIENPAIDAMOUNT,CLAIMFILENUMBER,null,null,null,null,case when isdate(LIENRECEIVEDDATE) = 1 and year(LIENRECEIVEDDATE) between 1900 and 2050  then LIENRECEIVEDDATE else null end,substring(ll.COMMENTS,0,2000),'',casnRecUserID,casdDtCreated,null,null,'',null,null,null,null,null
FROM [WilliamPagerSaga].[dbo].[LW_LIENS] ll
left join [WilliamPagerSaga].[dbo].LW_A_LIENCATEGORY lc on ll.LIENCATEGORYID=lc.LIENCATEGORYID
left join [WilliamPagerSaga].[dbo].assign ahol on ll.LIENHOLDERASSIGNID=ahol.assignid 
left join [WilliamPagerSaga].[dbo].assign apl on ll.PLAINTIFFASSIGNID=apl.assignid
left join [WilliamPagerSaga].[dbo].entities ehol on ehol.entityid=ahol.entityid 
left join [WilliamPagerSaga].[dbo].entities epl on epl.entityid=apl.entityid
left join [WilliamPagerSaga].[dbo].matter m on apl.matterid=m.matterid
left join [WilliamPagerSaga].[dbo].LW_DENIALS ld on ld.LW_LIENSID=ll.LW_LIENSID
left join sma_MST_IndvContacts l on l.cinsGrade=epl.ENTITYID
left join sma_MST_OrgContacts k on k.connLevelNo=epl.ENTITYID
left join sma_trn_cases on cassCaseNumber=m.MATTERNUMBER
left join sma_TRN_Plaintiff on  ((plnnContactID=k.conncontactid and plnnContactCtg=2) or (plnnContactID=l.cinncontactid and plnnContactCtg=1)) and plnnCaseID=casnCaseID
left join sma_MST_OrgContacts o on o.connLevelNo=ehol.ENTITYID
left join sma_MST_IndvContacts p on p.cinsGrade=ehol.ENTITYID
outer apply(select top 1 addnaddressid as IndvAddressID from  sma_MST_Address where addnContactID=p.cinncontactid and addnContactCtgID=1 order by isnull(addbPrimary,0) desc) z
outer apply(select top 1 addnaddressid as orgAddressID from  sma_MST_Address where addnContactID=o.conncontactid and addnContactCtgID=2 order by isnull(addbPrimary,0) desc) z1
left join [sma_MST_LienType] on lntsDscrptn=lc.DESCRIPTION
where apl.partytype=1
Alter table [sma_TRN_Lienors] enable trigger all

alter table sma_TRN_Lienors disable trigger all
update sma_TRN_Lienors
set lnrnFinal=0,lnrnLienorRelaAddID=0,lnrnAgentPersonAddID=0,lnrnAgentPersonContactID=0,lnrnAgentPersonCtg=0,lnrnNegLienAmount='0.00',lnrnUnCnfrmdLienAmount='0.00',lnrnAgentContactCtg=0,lnrnAgentContactID=0,lnrnAgentAddressID=0,lnrnLienorRelaContactID=0
where lnrnFinal is null and lnrnLienorRelaAddID is null and lnrnAgentPersonAddID is null and lnrnAgentPersonContactID is null and lnrnAgentPersonCtg is null and lnrnNegLienAmount is null and lnrnUnCnfrmdLienAmount is null and lnrnAgentContactCtg is null and lnrnAgentContactID is null and lnrnAgentAddressID is null and lnrnLienorRelaContactID is null
alter table sma_TRN_Lienors enable trigger all

alter table sma_TRN_Lienors disable trigger all
update sma_TRN_Lienors
set lnrnFinal=0,lnrnLienorRelaAddID=0,lnrnAgentPersonAddID=0,lnrnAgentPersonContactID=0,lnrnAgentPersonCtg=0,lnrnAgentContactCtg=0,lnrnAgentContactID=0,lnrnAgentAddressID=0,lnrnLienorRelaContactID=0
where lnrnFinal is null and lnrnLienorRelaAddID is null and lnrnAgentPersonAddID is null and lnrnAgentPersonContactID is null and lnrnAgentPersonCtg is null  and lnrnAgentContactCtg is null and lnrnAgentContactID is null and lnrnAgentAddressID is null and lnrnLienorRelaContactID is null
alter table sma_TRN_Lienors enable trigger all

Alter table sma_TRN_LienDetails disable trigger all
INSERT INTO sma_TRN_LienDetails
(lndnLienorID,lnddLienDt,lndnLienAmt,lndnCommTypeID,lndnUnCnfrmdLienAmount,lndnCnfrmdLienAmount,lnddConfrmtnReceivedDt,lndnLienTypeID,lndbIsConffirmed,lnddItemizReqDate,lnddItemizRcvdDate,lnddClientNotifiedDate,lnddClientRespDate,lndsComments,lndbWaived,lndsRefTable,lndnRecordID,lndnRecUserID,lnddDtCreated,lndnLevelNo)
Select lnrnLienorID,lnrdRcptSignedDt,null,null,null,lnrnCnfrmdLienAmount,null,lnrnLienorTypeID,null,null,null,null,null,'',null,'sma_TRN_Lienors',lnrnLienorID,lnrnRecUserID,lnrdDtCreated,0
from sma_TRN_Lienors
Alter table sma_TRN_LienDetails enable trigger all
