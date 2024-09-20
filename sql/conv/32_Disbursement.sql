
INSERT INTO [sma_MST_DisbursmentType]
([disnTypeCode],[dissTypeName],[disnRecUserID],[disnDtCreated],[disnModifyUserID],[disnDtModified],[disnLevelNo])
select CODE,LTRIM(RTRIM(convert(varchar(100),(DESCRIPTION)))),368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.TRANSACT where LTRIM(RTRIM(convert(varchar(100),(DESCRIPTION)))) not in (select LTRIM(RTRIM(disstypename)) from sma_MST_DisbursmentType)


Alter table [sma_TRN_Disbursement]
alter column [dissDescription] varchar(8000)
INSERT INTO [sma_TRN_Disbursement]
([disnCaseID],[disdCheckDt],[dissCheckNo__],[disnAmount__],[disbIsLinior],[disnPayeeContactCtgID],[disnPayeeContactID],[dissDescription__],[disnPlaintiffID]
,[disnShareAcrossPlaintiffs],[disnEqualWeighted],[disnRecoverable],[disnWaived],[dissComments__],[disbDocAttachedFlag],[disnRecUserID],[disdDtCreated],[disnModifyUserID]
,[disdDtModified],[disnLevelNo],[dissGeneralLedger__],[dissDisbursementType],[dissQukBkName],[dissCheckNo],[disnAmount],[dissDescription],[dissComments],[dissGeneralLedger],[dissInvoiceNumber],[disdCheckMailedD],[UniquePayeeID])
Select  casnCaseID,case when t.tdate between '1/1/1900' and '12/31/2079' then t.tdate end,t.CHECKNUMBER,null,'',case when cinnContactID is not null then 1 when connContactID is not null then 2 end,case when cinnContactID is not null then cinnContactID when connContactID is not null then connContactID end,
null,null,null,0,case BSTATUS when 'b' then 1 when 'h' then 1 when 'c' then 1 else 0 end,case BSTATUS when 'N' then 1  else 0 end,'','',368,GETDATE(),null,null,'','',disnTypeID,'',CHECKNUMBER,cast(AMOUNTCHARGED as float),isnull(convert(varchar(4000),t.DESCRIPTION),'')+CHAR(13)+isnull(convert(varchar(4000),ts.DESCRIPTION),''),'',
'','',null,cast(case when cinnContactID is not null then 1 when connContactID is not null then 2 end as varchar)+CAST(case when cinnContactID is not null then cinnContactID when connContactID is not null then connContactID end as varchar)
from WilliamPagerSaga.dbo.TRANSACT ts   
Left Join   WilliamPagerSaga.dbo.timeslip t on t.TRANSACTIONID=ts.TRANSACTIONID 
left join WilliamPagerSaga.dbo. matter m on m.MATTERID=t.MATTERID
left join sma_trn_cases on cassCaseNumber=MATTERNUMBER
left join sma_MST_DisbursmentType  on LTRIM(RTRIM(disstypename))=LTRIM(RTRIM(convert(varchar(100),(ts.[description]))))
left join  sma_MST_IndvContacts i1 on LTRIM(rtrim(i1.cinsGrade))=t.PAIDID 
left join  sma_MST_OrgContacts o1 on LTRIM(rtrim(o1.connLevelNo))=t.PAIDID 
where ISNULL(t.AMODE,'e')<>'T'

GO

INSERT INTO [dbo].[sma_TRN_CaseUserTime]
([cutnCaseID],[cutnStaffID],[cutnActivityID],[cutdFromDtTime],[cutdToDtTime],[cutsDuration],[cutnBillingRate],[cutnBillingAmt],[cutsComments],[cutnRecUserID]
,[cutdDtCreated],[cutnModifyUserID],[cutdDtModified],[cutnLevelNo],[cutnAddTime],[cutnPlaintiffID],[cutbSharedExpenses])    
Select  casnCaseID,u1.usrnContactID,0,timein,timeout,hours,ratecharged,cast(AMOUNTCHARGED as float),
isnull(convert(varchar(4000),t.DESCRIPTION),'')+CHAR(13)+isnull(convert(varchar(4000),ts.DESCRIPTION),''),
u3.usrnUserID,t.DATECREATED,u4.usrnContactID,t.DATEREVISED,null,1,plnnPlaintiffID,0
from WilliamPagerSaga.dbo.TRANSACT ts   
Left Join   WilliamPagerSaga.dbo.timeslip t on t.TRANSACTIONID=ts.TRANSACTIONID 
left join WilliamPagerSaga.dbo. matter m on m.MATTERID=t.MATTERID
left join sma_MST_IndvContacts i2 on i2.cinsGrade=t.ENTITYID
left join sma_MST_Users u1 on u1.usrnContactID=i2.cinnContactID
left join sma_MST_IndvContacts i3 on i3.cinsGrade=t.CREATORID
left join sma_MST_Users u3 on u3.usrnContactID=i3.cinnContactID
left join sma_MST_IndvContacts i4 on i4.cinsGrade=t.REVISORID
left join sma_MST_Users u4 on u4.usrnContactID=i4.cinnContactID
left join sma_trn_cases on cassCaseNumber=ltrim(rtrim(MATTERNUMBER))
left join sma_trn_plaintiff on plnncaseid=casncaseid and plnbisprimary=1
where t.AMODE='T' and timein between '1/1/1900' and '12/31/2079'