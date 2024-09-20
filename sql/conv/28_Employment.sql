Go
Alter table  [sma_TRN_Employment]
alter column [empsJobTitle] varchar(500) null
Alter table  [sma_TRN_Employment]
alter column [empsComments] varchar(4000) null
go
INSERT INTO [sma_TRN_Employment]
([empnPlaintiffID],[empnEmprAddressID],[empnEmployerID],[empnContactPersonID],[empnCPAddressId],[empsJobTitle],[empnSalaryFreqID],[empnSalaryAmt],[empnCommissionFreqID],[empnCommissionAmt]
,[empnBonusFreqID],[empnBonusAmt],[empnOverTimeFreqID],[empnOverTimeAmt],[empnOtherFreqID],[empnOtherCompensationAmt],[empsComments],[empbWorksOffBooks],[empsCompensationComments],[empbWorksPartiallyOffBooks]
,[empbOnTheJob],[empbWCClaim],[empbContinuing],[empdDateHired],[empnUDF1],[empnUDF2],[empnRecUserID],[empdDtCreated],[empnModifyUserID],[empdDtModified],[empnLevelNo],[empnauthtodefcoun],[empnauthtodefcounDt])    
Select distinct plnnPlaintiffID,case  when o1.connContactID  IS NOT NULL then z2.addnAddressID end as AddressID,o1.connContactID,null,null,POSITION,null,null,null,null,
null,null,null,null,null,null,convert(varchar(4000),ltrim(replace(
       dbo.RegExReplace(NOTES,'({\\)(.+?)(})|(\\)(.+?)(\b)','')
      ,'}','')      
      )),null,null,null
      ,null,null,null,case when STARTDATE between '1/1/1900' and '12/31/2079' then STARTDATE else null end ,null,null,368,GETDATE(),null,null,'','',''
From  [WilliamPagerSaga].dbo.lw_emp e
left join [WilliamPagerSaga].dbo.matrelt mt on e.MATRELTID=mt.MATRELTID 
left join  [WilliamPagerSaga].dbo.assign aemp on aemp.assignid=mt.RelatedAssignID
left join [WilliamPagerSaga].dbo.entities eemp on   eemp.entityid=aemp.entityid
left join [WilliamPagerSaga].dbo.matter m on m.MATTERID=aemp.MATTERID
left join [WilliamPagerSaga].dbo.assign apl on apl.assignid=mt.AssignID
left join [WilliamPagerSaga].dbo.entities epl on epl.entityid=apl.entityid  and apl.partytype=1  
left join [WilliamPagerSaga].dbo.LW_SPECIALS ls on e.MATRELTID=ls.MATRELTID
left join [WilliamPagerSaga].dbo.NOTE n on n.NOTEID=mt.NOTEID
left join sma_trn_cases on m.MATTERNUMBER=cassCaseNumber
--left join sma_MST_IndvContacts i1 on i1.cinsGrade=eemp.ENTITYID and i1.cinsLastName=eemp.LAST_COMPANY
left join sma_mst_orgcontacts o1 on o1.connLevelNo=eemp.ENTITYID and o1.consName=eemp.LAST_COMPANY
left join sma_MST_IndvContacts i2 on i2.cinsGrade=epl.ENTITYID and i2.cinsLastName=epl.LAST_COMPANY
left join sma_mst_orgcontacts o2 on o2.connLevelNo=epl.ENTITYID and o2.consName=epl.LAST_COMPANY
left join sma_TRN_Plaintiff on plnnCaseID=casnCaseID and ((plnnContactID=i2.cinnContactID and plnnContactCtg=1) or (plnnContactID=o2.connContactID and plnnContactCtg=2))
--outer apply(select top 1 addnaddressid,addsAddress1,addsAddress2,addsAddress3,addsCity,addsStateCode,addsZip from  sma_MST_Address where addnContactID=i1.cinnContactID and addnContactCtgID=1 and addbPrimary=1 order by isnull(addbPrimary,0) desc) z1
outer apply(select top 1 addnaddressid,addsAddress1,addsAddress2,addsAddress3,addsCity,addsStateCode,addsZip from  sma_MST_Address where addnContactID=o1.connContactID and addnContactCtgID=2 and addbPrimary=1 order by isnull(addbPrimary,0) desc) z2
WHERE    apl.partytype=1 and case  when o1.connContactID  IS NOT NULL then z2.addnAddressID end is not null and plnnPlaintiffID is not null
go
Update sma_TRN_Employment 
set empnContactPersonID=0,empnCPAddressId=0,empnSalaryAmt='0.00',empnCommissionAmt='0.00',empnBonusAmt='0.00',empnOverTimeAmt='0.00',empnOtherCompensationAmt='0.00',empbWorksOffBooks=0,empbWorksPartiallyOffBooks=0,empbOnTheJob=0,empbWCClaim=0,empbContinuing=0,empnUDF1=0,empnUDF2=0
go
Update sma_TRN_Employment set empsComments=dbo.RemoveNonASCII(empsComments)
go
INSERT INTO [sma_MST_WagesTypes]
([wgtsCode],[wgtsDscrptn],[wgtnRecUserID],[wgtdDtCreated],[wgtnModifyUserID],[wgtdDtModified],[wgtnLevelNo])
Select 'LSTWGS','Lost Wages',368,GETDATE(),null,null,''
Union
Select 'GEN','General',368,GETDATE(),null,null,''

INSERT INTO [sma_TRN_LostWages]
([ltwnEmploymentID],[ltwsType],[ltwdFrmDt],[ltwdToDt],[ltwnAmount],[ltwnAmtPaid],[ltwnLoss],[ltwdMDConfReqDt],[ltwdMDConfDt]
,[ltwdEmpVerfReqDt],[ltwdEmpVerfRcvdDt],[ltwnRecUserID],[ltwdDtCreated],[ltwnModifyUserID],[ltwdDtModified],[ltwnLevelNo])
 Select    distinct empnEmploymentID,case WAGEUNIT when 0 then 'General' else 'Lost Wages' end,case when ISDATE(STARTDATE)=1 and STARTDATE between '1/1/1900' and '12/31/2079' then STARTDATE else null end,
 case when ISDATE(ENDDATE)=1 and ENDDATE between '1/1/1900' and '12/31/2079' then ENDDATE else null end,
 WAGE,'0.00',SERVICEAMOUNT,null,null,
 null,null,368,GETDATE(),null,null,''
 From  [WilliamPagerSaga].dbo.lw_emp e
left join [WilliamPagerSaga].dbo.matrelt mt on e.MATRELTID=mt.MATRELTID 
left join  [WilliamPagerSaga].dbo.assign aemp on aemp.assignid=mt.RelatedAssignID
left join [WilliamPagerSaga].dbo.entities eemp on   eemp.entityid=aemp.entityid
left join [WilliamPagerSaga].dbo.matter m on m.MATTERID=aemp.MATTERID
left join [WilliamPagerSaga].dbo.assign apl on apl.assignid=mt.AssignID
left join [WilliamPagerSaga].dbo.entities epl on epl.entityid=apl.entityid  and apl.partytype=1  
left join [WilliamPagerSaga].dbo.LW_SPECIALS ls on e.MATRELTID=ls.MATRELTID
left join [WilliamPagerSaga].dbo.NOTE n on n.NOTEID=mt.NOTEID
left join sma_trn_cases on m.MATTERNUMBER=cassCaseNumber
--left join sma_MST_IndvContacts i1 on i1.cinsGrade=eemp.ENTITYID and i1.cinsLastName=eemp.LAST_COMPANY
left join sma_mst_orgcontacts o1 on o1.connLevelNo=eemp.ENTITYID and o1.consName=eemp.LAST_COMPANY
left join sma_MST_IndvContacts i2 on i2.cinsGrade=epl.ENTITYID and i2.cinsLastName=epl.LAST_COMPANY
left join sma_mst_orgcontacts o2 on o2.connLevelNo=epl.ENTITYID and o2.consName=epl.LAST_COMPANY
left join sma_TRN_Plaintiff on plnnCaseID=casnCaseID and ((plnnContactID=i2.cinnContactID and plnnContactCtg=1) or (plnnContactID=o2.connContactID and plnnContactCtg=2))
left join sma_TRN_Employment on empnPlaintiffID=plnnPlaintiffID 
WHERE    apl.partytype=1 and  o1.connContactID  IS NOT NULL  and plnnPlaintiffID is not null
and empnEmploymentID is not null
go