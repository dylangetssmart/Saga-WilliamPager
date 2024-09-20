set ansi_warnings off
--Insert Negotiation
INSERT INTO [sma_TRN_Negotiations]
([negnCaseID],[negsUniquePartyID],[negdDate],[negnStaffID],[negnPlaintiffID],[negbPartiallySettled],[negnClientAuthAmt],[negbOralConsent],[negdOralDtSent]
,[negdOralDtRcvd],[negnDemand],[negnOffer],[negbConsentType],[negnRecUserID],[negdDtCreated],[negnModifyUserID],[negdDtModified],[negnLevelNo],[negsComments])
SELECT distinct casncaseid,case when oo1.incnCaseID is not null and oo2.incnCaseID is not null  then 'I'+convert(varchar,oo2.incnInsCovgID)
when oo1.incnCaseID is not null then 'I'+convert(varchar,oo1.incnInsCovgID) when oo2.incnCaseID is not null then 'I'+convert(varchar,oo2.incnInsCovgID) when isnull(l1.lwfnLawFirmID,'')<>'' then 'L'+convert(varchar,l1.lwfnLawFirmID) when
 isnull(l2.lwfnLawFirmID,'')<>'' then 'l'+convert(varchar,l2.lwfnLawFirmID) end,case when isdate(l.ADATE)= 1  and YEAR(l.ADATE)between 1900 and 2079  then l.ADATE else GETDATE() end ,
 i1.cinnContactID,plnnPlaintiffID,null,null,null,null,null,l.DEMAND,l.OFFER,null,
case isnull((u2.usrnuserid),'') when '' then 368 else (u2.usrnuserid) end,case  when (m.datecreated) is null then GETDATE() when m.datecreated <'1900-01-01' then getdate() else (m.datecreated) end,
null,null,LW_LOGID,
n.DESCRIPTION+CHAR(13) + convert(varchar(6000),ltrim(replace(replace(replace(dbo.RegExReplace(n.NOTES,'({\\)(.+?)(})|(\\)(.+?)(\b)','') ,'}',''),char(13),'') ,char(10),'')))  
from [WilliamPagerSaga].dbo.LW_log l
Left Join [WilliamPagerSaga].dbo.matter m on m.matterid=l.matterid 
left join [WilliamPagerSaga].dbo.note n on n.NOTEID=l.NOTEID
left join sma_trn_cases on cassCaseNumber=MATTERNUMBER
left join sma_TRN_Plaintiff on plnnCaseID=casnCaseID and plnbIsPrimary=1
left join sma_MST_IndvContacts  i2 on  i2.cinsGrade=l.ADJUSTER_ATTORNEYID and ISNULL(i2.cinsGrade,'')<>''
left join sma_Mst_OrgContacts o1 on o1.connLevelNo= l.ADJUSTER_ATTORNEYID and ISNULL(o1.connLevelNo,'')<>''
left join sma_TRN_InsuranceCoverage oo1 on oo1.incnAdjContactId=i2.cinnContactID and oo1.incnCaseID=casnCaseID
left join sma_TRN_InsuranceCoverage oo2 on oo2.incnInsContactID=o1.connContactID and oo2.incnCaseID=casnCaseID
left join sma_TRN_Defendants on defnCaseID=casnCaseID
left join sma_TRN_LawFirms l1 on l1.lwfnContactID = defnDefendentID and l1.lwfnLawFirmContactID=o1.connContactID and ISNULL(defnDefendentID,'')<>'' and ISNULL(l.ADJUSTER_ATTORNEYID,'')<>'' and l1.lwfnRoleType = 2
left join sma_TRN_LawFirms l2 on l1.lwfnContactID = defnDefendentID and l2.lwfnAttorneyContactID=i2.cinnContactID and ISNULL(defnDefendentID,'')<>'' and ISNULL(l.ADJUSTER_ATTORNEYID,'')<>'' and l2.lwfnRoleType = 2
left join sma_MST_IndvContacts cl on cl.cinsGrade=m.CREATORID
left join sma_mst_users u2 on u2.usrnContactID=cl.cinnContactID
left join sma_MST_IndvContacts  i1 on  i1.cinsGrade=l.USERID
where casnCaseID is not null 
go
if OBJECT_ID('tmpNegotiation')is not null
drop table tmpNegotiation
go
select distinct row_number()over(order by [negsUniquePartyID] desc) as RowNum,(negnid) as negid, [negsUniquePartyID],negnCaseID,negdDate,negnStaffID,negnDemand,negnOffer into tmpNegotiation   from sma_TRN_Negotiations
 order by ([negsUniquePartyID]) desc
go
Delete from sma_TRN_Negotiations where negnID not in (
select  MIN(negid)  from tmpNegotiation 
Group by negnCaseID,negdDate,negnStaffID,negnDemand,negnOffer
union 
select min(negid)  from tmpNegotiation  where [negsUniquePartyID] is not null Group by negnCaseID,negdDate,negnStaffID,negnDemand,negnOffer
)
go
drop table tmpNegotiation
go
Delete from sma_TRN_Negotiations where negnID not in(
select min(negnid)  from sma_TRN_Negotiations  where [negsUniquePartyID] is not null Group by negnCaseID,negdDate,negnStaffID,negnDemand,negnOffer
union
select  max(negnid)  from sma_TRN_Negotiations 
Group by negnCaseID,negdDate,negnStaffID,negnDemand,negnOffer)
go
INSERT INTO [sma_TRN_Settlements]
([stlnNegotID],[stlnCaseID],[stlsUniquePartyID],[stlnPlaintiffID],[stlnStaffID],[stlnSetAmt],[stlbConsentReqd],[stlbCourtConsent],[stldCourtDtSent],[stldCourtDtRcvd]
,[stldDocSendToClientOn],[stldDocReceivedFromClient],[stldDocSendToInsuranceCo],[stldDocExpectedDate],[stlnRecUserID],[stldDtCreated],[stlnModifyUserID],[stldDtModified]
,[stlnLevelNo],[stlnLessDisbursement],[stlnNet],[stlnForwarder],[stlnPrior],[stlnOther],[stlnGrossAttorneyFee],[stldSettlementDate],[stldDateOfDisbursement],[stlnAttFeeType]
,[stlnAttFeeValue],[stlnNetToClientAmt],[stlsComments])
Select negnID,negnCaseID,null,plnnPlaintiffID,null,SETTLEMENT,null,null,null,null
,null,null,null,null,368,getdate(),null,null
,null,null,null,null,null,null,null,negdDate,null,null
,null,null,null
 from [WilliamPagerSaga].dbo.LW_log l
join sma_TRN_Negotiations on negnLevelNo=LW_LOGID
left join sma_TRN_Plaintiff on plnnCaseID=negnCaseID and plnbIsPrimary=1
where isnull(SETTLEMENT,'0.00')<>'0.00'

