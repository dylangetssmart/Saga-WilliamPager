INSERT INTO [sma_TRN_Retainer]
([rtnnCaseID],[rtnnPlaintiffID],[rtndSentDt],[rtndRcvdDt],[rtndRetainerDt],[rtnbCopyRefAttFee],[rtnnFeeStru],[rtnbMultiFeeStru],[rtnnBeforeTrial],[rtnnAfterTrial],[rtnnAtAppeal],[rtnnUDF1],[rtnnUDF2],
[rtnnUDF3],[rtnbComplexStru],[rtnbWrittenAgree],[rtnnStaffID],[rtnsComments],[rtnnUserID],[rtndDtCreated],[rtnnModifyUserID],[rtndDtModified],[rtnnLevelNo],[rtnnPlntfAdv],[rtnnFeeAmt],[rtnsRetNo],rtndClosingStmtSent,rtnsClosingRetNo)
select distinct casnCaseID,case when p1.plnnPlaintiffID is not null then p1.plnnPlaintiffID when p2.plnnPlaintiffID is not null then p2.plnnPlaintiffID else null end,null,case when FILEDDATE between '1/1/1900' and '12/31/2079' then FILEDDATE end,case when FILEDDATE between '1/1/1900' and '12/31/2079' then FILEDDATE end,0,NULL,0,'0.00','0.00','0.00','0.00','0.00','0.00',0,NULL,NULL,NULL,368,GETDATE(),NULL,NULL,1,'0.00','0.00',RETAINERNUMBER,DATECLOSED,CLOSEDMATTERNUMBER
from WilliamPagerSaga.dbo.lw_party a
left join WilliamPagerSaga.dbo.ASSIGN b on  a.assignid=b.ASSIGNID
left join WilliamPagerSaga.dbo.MATTER c on c.MATTERID=b.MATTERID
left join sma_trn_cases   on cassCaseNumber=MATTERNUMBER
left join sma_MST_IndvContacts on b.ENTITYID=cinsGrade
left join sma_MST_OrgContacts on connLevelNo=b.ENTITYID
left join sma_TRN_Plaintiff p1 on p1.plnnCaseID=casnCaseID and p1.plnnContactID=cinnContactID and p1.plnnContactCtg=1
left join sma_TRN_Plaintiff p2 on p2.plnnCaseID=casnCaseID and p2.plnncontactid=connContactID and p2.plnnContactCtg=2
where casnCaseID is not null