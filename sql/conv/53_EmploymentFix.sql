 alter table sma_mst_orgcontacts 
 alter column saga varchar(200)
 go
 INSERT INTO [sma_MST_OrgContacts]
([conbPrimary]
,[connContactTypeID]
,[connContactSubCtgID]
,[consName]
,[conbStatus]
,[consEINNO]
,[consComments]
,[connContactCtg]
,[connRefByCtgID]
,[connReferredBy]
,[connContactPerson]
,[consWorkPhone]
,[conbPreventMailing]
,[connRecUserID]
,[condDtCreated]
,[connModifyUserID]
,[condDtModified]
,[connLevelNo]
,[consOtherName]
,[saga])
Select distinct 1,11
,'',isnull(LAST_COMPANY,'')+isnull(', '+FIRST_DBA,''),1,'',FIRST_DBA+ISNULL(ALIASNAMES,''),2,null,null,'',phone,0,
368,getdate(),null,null,
e.ENTITYID,substring(ENTITYNAME,0,100),'E'+cast(e.ENTITYID as varchar(50))
 from WilliamPagerSaga.dbo.ENTITIES e
Join [WilliamPagerSaga].dbo.assign a on a.ENTITYID=e.ENTITYID
join [WilliamPagerSaga].dbo.matrelt mt on mt.RELATEDASSIGNID=a.ASSIGNID
JOIN [WilliamPagerSaga].dbo.lw_emp e1 on e1.MATRELTID=mt.MATRELTID
where ISPERSON='T' and not exists(select * from sma_mst_orgcontacts where connLevelNo=e.ENTITYID)
go
INSERT INTO [sma_MST_Address]
([addnContactCtgID],[addnContactID],[addnAddressTypeID],[addsAddressType],[addsAddTypeCode],[addsAddress1],[addsAddress2],[addsAddress3],[addsStateCode],[addsCity],[addnZipID],[addsZip],[addsCounty],[addsCountry],[addbIsResidence],[addbPrimary],[adddFromDate],[adddToDate],[addnCompanyID],[addsDepartment],[addsTitle],[addnContactPersonID],[addsComments],[addbIsCurrent],[addbIsMailing],[addnRecUserID],[adddDtCreated],[addnModifyUserID],[adddDtModified],[addnLevelNo],[caseno],[addbDeleted],[addsZipExtn],[saga])
Select 2,connContactID, 12,'Office','WRK',substring(addsAddress1,0,75),substring(isnull(addsAddress2,''),0,75),'',substring(addsStateCode,0,20),substring(addsCity,0,50),'',substring(addsZip,0,6),substring(addsCounty,0,30),'USA',addbIsResidence,addbPrimary,GETDATE(),null,null,null,null,null,'',addbIsCurrent,addbIsMailing,368,GETDATE(),null,null,'','',null,addsZipExtn,''
from sma_MST_OrgContacts o
join sma_MST_IndvContacts i on 'e'+i.cinsGrade=o.saga
join sma_MST_Address on addnContactCtgID=1 and addnContactID=cinnContactID
where o.saga like 'e%'
go
INSERT INTO [sma_MST_ContactNumbers]
([cnnnContactCtgID],[cnnnContactID],[cnnnPhoneTypeID],[cnnsContactNumber],[cnnsExtension],[cnnbPrimary],[cnnbVisible],[cnnnAddressID],[cnnsLabelCaption],[cnnnRecUserID],[cnndDtCreated],[cnnnModifyUserID],[cnndDtModified],[cnnnLevelNo],[caseNo],[saga])	
Select distinct  2, connContactID,[cnnnPhoneTypeID],[cnnsContactNumber],[cnnsExtension],[cnnbPrimary],[cnnbVisible],[cnnnAddressID],[cnnsLabelCaption],[cnnnRecUserID],[cnndDtCreated],[cnnnModifyUserID],[cnndDtModified],[cnnnLevelNo],[caseNo],c.[saga]
from sma_MST_OrgContacts o
join sma_MST_IndvContacts i on 'e'+i.cinsGrade=o.saga
join [sma_MST_ContactNumbers] c on cnnnContactCtgID=1 and cnnnContactID=cinnContactID
where o.saga like 'e%'
go
INSERT INTO [sma_MST_EmailWebsite]
([cewnContactCtgID],[cewnContactID],[cewsEmailWebsiteFlag],[cewsEmailWebSite],[cewbDefault],[cewnRecUserID],[cewdDtCreated],[cewnModifyUserID],[cewdDtModified],[cewnLevelNo],[saga])
Select 2,connContactID,[cewsEmailWebsiteFlag],[cewsEmailWebSite],[cewbDefault],[cewnRecUserID],[cewdDtCreated],[cewnModifyUserID],[cewdDtModified],[cewnLevelNo],e.[saga]
from sma_MST_OrgContacts o
join sma_MST_IndvContacts i on 'e'+i.cinsGrade=o.saga
join [sma_MST_EmailWebsite] e on cewnContactCtgID=1 and cewnContactID=cinnContactID
where o.saga like 'e%'

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
left join sma_mst_orgcontacts o1 on o1.connLevelNo=eemp.ENTITYID and o1.consName=isnull(eemp.LAST_COMPANY,'')+isnull(', '+eemp.FIRST_DBA,'')
left join sma_MST_IndvContacts i2 on i2.cinsGrade=epl.ENTITYID and i2.cinsLastName=epl.LAST_COMPANY
left join sma_mst_orgcontacts o2 on o2.connLevelNo=epl.ENTITYID and o2.consName=epl.LAST_COMPANY
left join sma_TRN_Plaintiff on plnnCaseID=casnCaseID and ((plnnContactID=i2.cinnContactID and plnnContactCtg=1) or (plnnContactID=o2.connContactID and plnnContactCtg=2))
--outer apply(select top 1 addnaddressid,addsAddress1,addsAddress2,addsAddress3,addsCity,addsStateCode,addsZip from  sma_MST_Address where addnContactID=i1.cinnContactID and addnContactCtgID=1 and addbPrimary=1 order by isnull(addbPrimary,0) desc) z1
outer apply(select top 1 addnaddressid,addsAddress1,addsAddress2,addsAddress3,addsCity,addsStateCode,addsZip from  sma_MST_Address where addnContactID=o1.connContactID and addnContactCtgID=2 and addbPrimary=1 order by isnull(addbPrimary,0) desc) z2

WHERE    apl.partytype=1 and case  when o1.connContactID  IS NOT NULL then z2.addnAddressID end is not null 
and plnnPlaintiffID is not null and o1.saga like 'e%'
go

Update e 
set empnContactPersonID=0,empnCPAddressId=0,empnSalaryAmt='0.00',empnCommissionAmt='0.00',empnBonusAmt='0.00',empnOverTimeAmt='0.00',empnOtherCompensationAmt='0.00',empbWorksOffBooks=0,empbWorksPartiallyOffBooks=0,empbOnTheJob=0,empbWCClaim=0,empbContinuing=0,empnUDF1=0,empnUDF2=0
from sma_TRN_Employment e
join sma_MST_OrgContacts on e.empnEmployerID=connContactID
where saga like 'e%'
go
Update e set empsComments=dbo.RemoveNonASCII(empsComments)
from sma_TRN_Employment e
join sma_MST_OrgContacts on e.empnEmployerID=connContactID
where saga like 'e%'
go

INSERT INTO [sma_TRN_LostWages]
([ltwnEmploymentID],[ltwsType],[ltwdFrmDt],[ltwdToDt],[ltwnAmount],[ltwnAmtPaid],[ltwnLoss],[ltwdMDConfReqDt],[ltwdMDConfDt]
,[ltwdEmpVerfReqDt],[ltwdEmpVerfRcvdDt],[ltwnRecUserID],[ltwdDtCreated],[ltwnModifyUserID],[ltwdDtModified],[ltwnLevelNo])
 Select    distinct empnEmploymentID,case WAGEUNIT when 0 then 12 else 11 end,case when ISDATE(STARTDATE)=1 and STARTDATE between '1/1/1900' and '12/31/2079' then STARTDATE else null end,
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
left join sma_mst_orgcontacts o1 on o1.connLevelNo=eemp.ENTITYID and o1.consName=isnull(eemp.LAST_COMPANY,'')+isnull(', '+eemp.FIRST_DBA,'')
left join sma_MST_IndvContacts i2 on i2.cinsGrade=epl.ENTITYID and i2.cinsLastName=epl.LAST_COMPANY
left join sma_mst_orgcontacts o2 on o2.connLevelNo=epl.ENTITYID and o2.consName=epl.LAST_COMPANY
left join sma_TRN_Plaintiff on plnnCaseID=casnCaseID and ((plnnContactID=i2.cinnContactID and plnnContactCtg=1) or (plnnContactID=o2.connContactID and plnnContactCtg=2))
left join sma_TRN_Employment on empnPlaintiffID=plnnPlaintiffID 
WHERE    apl.partytype=1 and  o1.connContactID  IS NOT NULL  and plnnPlaintiffID is not null
and empnEmploymentID is not null and o1.saga like 'e%'

go
update [sma_TRN_LostWages] set comments=isnull(Comments,'')+isnull(char(13)+'Wage: $'+cast(ltwnAmount as varchar(20)),'') --where ltwnEmploymentID=3985
go
update e set empnSalaryAmt=ltwnAmount from sma_TRN_Employment e join [sma_TRN_LostWages] on  ltwnEmploymentID=empnEmploymentID
where empnSalaryAmt='0.00' and isnull(ltwnAmount,'0.00')<>'0.00'
