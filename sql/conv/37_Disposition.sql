--SAGA Disposition Information
INSERT INTO [sma_MST_UDFDefinition]
([udfsUDFCtg],[udfnRelatedPK],[udfsUDFName],[udfsScreenName],[udfsType],[udfsLength],[udfsFormat],[udfsTableName],[udfsNewValues],[udfsDefaultValue]
,[udfnSortOrder],[udfbIsActive],[udfnRecUserID],[udfnDtCreated],[udfnModifyUserID],[udfnDtModified],[udfnLevelNo],[udfbIsSystem])
Select 'C',cstnCaseTypeID,'Settlement/Award Date','Case','Date',500,NULL,NULL,NULL,NULL,1,1,368,GETDATE(),NULL,NULL,1,NULL from WilliamPagerSaga.dbo.LAWTYPE
Left Join sma_MST_CaseType on cstsType=DESCRIPTION
Union
Select 'C',cstnCaseTypeID,'Settlement/Award Amount','Case','Text',500,NULL,NULL,NULL,NULL,2,1,368,GETDATE(),NULL,NULL,1,NULL from WilliamPagerSaga.dbo.LAWTYPE
Left Join sma_MST_CaseType on cstsType=DESCRIPTION
Union
Select 'C',cstnCaseTypeID,'Final Payment Date','Case','Date',500,NULL,NULL,NULL,NULL,3,1,368,GETDATE(),NULL,NULL,1,NULL from WilliamPagerSaga.dbo.LAWTYPE
Left Join sma_MST_CaseType on cstsType=DESCRIPTION
Union
Select 'C',cstnCaseTypeID,'Unsettled Case Disbursement','Case','Text',500,NULL,NULL,NULL,NULL,4,1,368,GETDATE(),NULL,NULL,1,NULL from WilliamPagerSaga.dbo.LAWTYPE
Left Join sma_MST_CaseType on cstsType=DESCRIPTION
Union
Select 'C',cstnCaseTypeID,'Unsettled Liens','Case','Text',500,NULL,NULL,NULL,NULL,5,1,368,GETDATE(),NULL,NULL,1,NULL from WilliamPagerSaga.dbo.LAWTYPE
Left Join sma_MST_CaseType on cstsType=DESCRIPTION
Union
Select 'C',cstnCaseTypeID,'Unsettled Plaintiff Disbursement','Case','Text',500,NULL,NULL,NULL,NULL,6,1,368,GETDATE(),NULL,NULL,1,NULL from WilliamPagerSaga.dbo.LAWTYPE
Left Join sma_MST_CaseType on cstsType=DESCRIPTION
Union
Select 'C',cstnCaseTypeID,'Closed Date','Case','Date',500,NULL,NULL,NULL,NULL,7,1,368,GETDATE(),NULL,NULL,1,NULL from WilliamPagerSaga.dbo.LAWTYPE
Left Join sma_MST_CaseType on cstsType=DESCRIPTION
Union
Select 'C',cstnCaseTypeID,'Closed File#','Case','Text',500,NULL,NULL,NULL,NULL,8,1,368,GETDATE(),NULL,NULL,1,NULL from WilliamPagerSaga.dbo.LAWTYPE
Left Join sma_MST_CaseType on cstsType=DESCRIPTION
Union
Select 'C',cstnCaseTypeID,'Closed File Location','Case','Text',1000,NULL,NULL,NULL,NULL,9,1,368,GETDATE(),NULL,NULL,1,NULL from WilliamPagerSaga.dbo.LAWTYPE
Left Join sma_MST_CaseType on cstsType=DESCRIPTION
--------------------------------------------------------------------

INSERT INTO [sma_TRN_UDFValues]
([udvnUDFID],[udvsScreenName],[udvsUDFCtg],[udvnRelatedID],[udvnSubRelatedID],[udvsUDFValue],[udvnRecUserID],[udvdDtCreated],[udvnModifyUserID],[udvdDtModified],[udvnLevelNo])
select distinct udfnUDFID,'Case','C',casnCaseID,0,CLOSEDMATTERNUMBER,368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.MATTER a
left join WilliamPagerSaga.dbo.LW_MATTER b on a.MATTERID=b.MATTERID
left join sma_trn_cases on cassCaseNumber=MATTERNUMBER
left join sma_MST_UDFDefinition on udfnRelatedPK=casnOrgCaseTypeID
where udfsUDFName='Closed File#' and ISNULL(CLOSEDMATTERNUMBER,'')<>''
union
select distinct udfnUDFID,'Case','C',casnCaseID,0,CLOSEDFILELOCATION,368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.MATTER a
left join WilliamPagerSaga.dbo.LW_MATTER b on a.MATTERID=b.MATTERID
left join sma_trn_cases on cassCaseNumber=MATTERNUMBER
left join sma_MST_UDFDefinition on udfnRelatedPK=casnOrgCaseTypeID
where udfsUDFName='Closed File Location' and ISNULL(CLOSEDFILELOCATION,'')<>''


INSERT INTO [sma_TRN_UDFValues]
([udvnUDFID],[udvsScreenName],[udvsUDFCtg],[udvnRelatedID],[udvnSubRelatedID],[udvsUDFValue],[udvnRecUserID],[udvdDtCreated],[udvnModifyUserID],[udvdDtModified],[udvnLevelNo])
select distinct udfnUDFID,'Case','C',casnCaseID,0,'$'+CONVERT(varchar, CAST(TotalSettleAward AS money), 1),368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.MATTER a
left join WilliamPagerSaga.dbo.LW_MATTER b on a.MATTERID=b.MATTERID
left join sma_trn_cases on cassCaseNumber=MATTERNUMBER
left join sma_MST_UDFDefinition on udfnRelatedPK=casnOrgCaseTypeID
where udfsUDFName='Settlement/Award Amount' and ISNULL(TotalSettleAward,'')<>''
union
select distinct udfnUDFID,'Case','C',casnCaseID,0,'$'+CONVERT(varchar, CAST(UNSETTLEDPLAINTIFFEXPENSES AS money), 1),368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.MATTER a
left join WilliamPagerSaga.dbo.LW_MATTER b on a.MATTERID=b.MATTERID
left join sma_trn_cases on cassCaseNumber=MATTERNUMBER
left join sma_MST_UDFDefinition on udfnRelatedPK=casnOrgCaseTypeID
where udfsUDFName='Unsettled Plaintiff Disbursement' and ISNULL(UNSETTLEDPLAINTIFFEXPENSES,'')<>''
union
select distinct udfnUDFID,'Case','C',casnCaseID,0,'$'+CONVERT(varchar, CAST(UnsettledLiens AS money), 1),368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.MATTER a
left join WilliamPagerSaga.dbo.LW_MATTER b on a.MATTERID=b.MATTERID
left join sma_trn_cases on cassCaseNumber=MATTERNUMBER
left join sma_MST_UDFDefinition on udfnRelatedPK=casnOrgCaseTypeID
where udfsUDFName='Unsettled Liens' and ISNULL(UnsettledLiens,'')<>''
union
select distinct udfnUDFID,'Case','C',casnCaseID,0,'$'+CONVERT(varchar, CAST(UNSETTLEDDISBURSEMENTS AS money), 1),368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.MATTER a
left join WilliamPagerSaga.dbo.LW_MATTER b on a.MATTERID=b.MATTERID
left join sma_trn_cases on cassCaseNumber=MATTERNUMBER
left join sma_MST_UDFDefinition on udfnRelatedPK=casnOrgCaseTypeID
where udfsUDFName='Unsettled Case Disbursement' and ISNULL(UNSETTLEDDISBURSEMENTS,'')<>''



INSERT INTO [sma_TRN_UDFValues]
([udvnUDFID],[udvsScreenName],[udvsUDFCtg],[udvnRelatedID],[udvnSubRelatedID],[udvsUDFValue],[udvnRecUserID],[udvdDtCreated],[udvnModifyUserID],[udvdDtModified],[udvnLevelNo])

select distinct udfnUDFID,'Case','C',casnCaseID,0,convert(varchar(10),DATECLOSED,101),368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.MATTER a
left join WilliamPagerSaga.dbo.LW_MATTER b on a.MATTERID=b.MATTERID
left join sma_trn_cases on cassCaseNumber=MATTERNUMBER
left join sma_MST_UDFDefinition on udfnRelatedPK=casnOrgCaseTypeID
where udfsUDFName='Closed Date' and ISNULL(DATECLOSED,'')<>''
union
select distinct udfnUDFID,'Case','C',casnCaseID,0,convert(varchar(10),FinalPaymentDate,101),368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.MATTER a
left join WilliamPagerSaga.dbo.LW_MATTER b on a.MATTERID=b.MATTERID
left join sma_trn_cases on cassCaseNumber=MATTERNUMBER
left join sma_MST_UDFDefinition on udfnRelatedPK=casnOrgCaseTypeID
where udfsUDFName='Final Payment Date' and ISNULL(FinalPaymentDate,'')<>''
union
select distinct udfnUDFID,'Case','C',casnCaseID,0,convert(varchar(10),Settlement_AwardDate,101),368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.MATTER a
left join WilliamPagerSaga.dbo.LW_MATTER b on a.MATTERID=b.MATTERID
left join sma_trn_cases on cassCaseNumber=MATTERNUMBER
left join sma_MST_UDFDefinition on udfnRelatedPK=casnOrgCaseTypeID
where udfsUDFName='Settlement/Award Date' and ISNULL(Settlement_AwardDate,'')<>''
--,CLOSEDFILELOCATION,DATECLOSED,UNSETTLEDPLAINTIFFEXPENSES,UnsettledLiens,UNSETTLEDDISBURSEMENTS,FinalPaymentDate,TotalSettleAward,Settlement_AwardDate 
--select * from [sma_TRN_UDFValues]

INSERT INTO [sma_TRN_Settlements]
([stlnNegotID],[stlnCaseID],[stlsUniquePartyID],[stlnPlaintiffID],[stlnStaffID],[stlnSetAmt],[stlbConsentReqd],[stlbCourtConsent],[stldCourtDtSent],[stldCourtDtRcvd]
,[stldDocSendToClientOn],[stldDocReceivedFromClient],[stldDocSendToInsuranceCo],[stldDocExpectedDate],[stlnRecUserID],[stldDtCreated],[stlnModifyUserID],[stldDtModified]
,[stlnLevelNo],[stlnLessDisbursement],[stlnNet],[stlnForwarder],[stlnPrior],[stlnOther],[stlnGrossAttorneyFee],[stldSettlementDate],[stldDateOfDisbursement],[stlnAttFeeType]
,[stlnAttFeeValue],[stlnNetToClientAmt],[stlsComments])
Select null,casncaseid,null,-1,null,TotalSettleAward,null,null,null,null
,null,null,null,null,368,getdate(),null,null
,null,null,null,null,null,null,null,Settlement_AwardDate,null,null
,null,null,COMMENTSDISPOSITION
 from WilliamPagerSaga.dbo.LW_MATTER a
 left join WilliamPagerSaga.dbo.matter b on a.MATTERID=b.MATTERID
left join sma_trn_cases on cassCaseNumber=b.MATTERNUMBER
--left join sma_TRN_Plaintiff on plnnCaseID=casnCaseID and plnbIsPrimary=1
where isnull(TotalSettleAward,'0.00')<>'0.00'

