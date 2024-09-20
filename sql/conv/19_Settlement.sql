
INSERT INTO [sma_TRN_Settlements]
([stlnNegotID],[stlnCaseID],[stlsUniquePartyID],[stlnPlaintiffID],[stlnStaffID],[stlnSetAmt],[stlbConsentReqd],[stlbCourtConsent],[stldCourtDtSent],[stldCourtDtRcvd]
,[stldDocSendToClientOn],[stldDocReceivedFromClient],[stldDocSendToInsuranceCo],[stldDocExpectedDate],[stlnRecUserID],[stldDtCreated],[stlnModifyUserID],[stldDtModified]
,[stlnLevelNo],[stlnLessDisbursement],[stlnNet],[stlnForwarder],[stlnPrior],[stlnOther],[stlnGrossAttorneyFee],[stldSettlementDate],[stldDateOfDisbursement],[stlnAttFeeType]
,[stlnAttFeeValue],[stlnNetToClientAmt],[stlsComments])
Select distinct negnID,casnCaseID,null,plnnPlaintiffID,i1.cinnContactID,b.AMOUNTDUE,null,null,null,null,null,null,null,null, 
case isnull((u2.usrnuserid),'') when '' then 368 else (u2.usrnuserid) end,case (m.datecreated) when null then GETDATE() else (m.datecreated) end,null,null,b.LW_SETTLEID,null,b.AMOUNTDUE,null,null
,null,l.SETTLEMENT/3,case when isdate(l.ADATE)= 1  and YEAR(l.ADATE)<2100  then l.ADATE else GETDATE() end,null,null,null,null,
n.DESCRIPTION+CHAR(13) + convert(varchar(6000),ltrim(replace(replace(replace(dbo.RegExReplace(n.NOTES,'({\\)(.+?)(})|(\\)(.+?)(\b)','') ,'}',''),char(13),'') ,char(10),''))) 
From WilliamPagerSaga.dbo.LW_SETTLE b
left join WilliamPagerSaga.dbo.ASSIGN a on a.ASSIGNID=b.ASSIGNID
left join WilliamPagerSaga.dbo.MATTER m on m.MATTERID=a.MATTERID
left join sma_TRN_CaseS on cassCaseNumber=MATTERNUMBER
outer apply(select top 1 negnid from sma_TRN_Negotiations where negnCaseID=casnCaseID)z
LEFT join WilliamPagerSaga.dbo.LW_PAY p on p.LW_SETTLEID=b.LW_SETTLEID
Left Join [WilliamPagerSaga].dbo.LW_log l on m.matterid=l.matterid
left join WilliamPagerSaga.dbo.ASSIGN carr on carr.ASSIGNID=b.CARRIERASSIGNID 
left join WilliamPagerSaga.dbo.ASSIGN def on def.ASSIGNID=b.DEFENDANTASSIGNID
left join WilliamPagerSaga.dbo.ASSIGN firm on firm.ASSIGNID=b.FIRMASSIGNID
Left Join [WilliamPagerSaga].dbo.entities estaff on l.userid=estaff.entityid
Left Join [WilliamPagerSaga].dbo.entities espoke on l.ADJUSTER_ATTORNEYID=espoke.entityid
Left Join [WilliamPagerSaga].dbo.LW_matter lm on l.matterid=lm.matterid
left join sma_TRN_Plaintiff on plnnCaseID=casnCaseID and plnbIsPrimary=1
left join sma_MST_IndvContacts  i1 on  i1.cinsGrade=estaff.ENTITYID
left join sma_MST_IndvContacts  i2 on  i2.cinsGrade=espoke.ENTITYID
left join sma_MST_IndvContacts cl on cl.cinsGrade=m.CREATORID
left join sma_mst_users u2 on u2.usrnContactID=cl.cinnContactID
left join [WilliamPagerSaga].dbo.note n on n.NOTEID=l.NOTEID
where casnCaseID is not null --and  l.Settlement is not null  and CONVERT(varchar,negdDate,101)=CONVERT(varchar,l.ADATE,101)
go
INSERT INTO [sma_TRN_CheckReceivedFeeRecorded]
([crfnSettlementID],[crfnAmount],[crfdReceivedDate],[crfsTypeOfAmount])     
select stlnID,PAID,PAIDDATE,'s' from sma_TRN_Settlements 
left join WilliamPagerSaga.dbo.LW_PAY on LW_SETTLEID=stlnLevelNo
where stlnID is not null 
go
alter table sma_trn_settlements
alter column stlsComments varchar(max)
go
Update a
set stlsComments=isnull('Due: '+isnull(convert(varchar,due,101),'')+char(13)+'Amount: '+isnull(convert(varchar,amount),'')+char(13),'') +isnull('Paid Date: '+convert(varchar(10),PAIDDATE,101) +char(13),'')+isnull('Paid: '+cast(paid as varchar(200)) +char(13),'')+isnull(convert(varchar(max),comments),'')+isnull(stlsComments  ,'')
from sma_TRN_Settlements a
left join WilliamPagerSaga.dbo.LW_PAY on LW_SETTLEID=stlnLevelNo
where stlnID is not null
go
Delete from sma_TRN_Settlements where stlnID not in(
select min(stlnID)  from sma_TRN_Settlements  where stlsUniquePartyID is not null Group by stlnNegotID,stlnCaseID,stlnSetAmt
union
select  max(stlnID)  from  sma_TRN_Settlements  where stlsUniquePartyID is null Group by stlnNegotID,stlnCaseID,stlnSetAmt) 
go

