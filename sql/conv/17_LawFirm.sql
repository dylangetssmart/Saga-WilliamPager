alter table [sma_MST_AttorneyTypes]
alter column atnsAtorneyDscrptn varchar(500) null

Alter Table sma_trn_lawfirms disable trigger all

INSERT INTO [sma_MST_AttorneyTypes]
([atnsAtorneyCode],[atnsAtorneyDscrptn],[atnnRecUserID],[atndDtCreated],[atnnModifyUserID],[atndDtModified],[atnnLevelNo])
Select '',DESCRIPTION,368,GETDATE(),null,null,null from  [WilliamPagerSaga].dbo.EROLE where DESCRIPTION like '%attorney%' and DESCRIPTION not like 'primary%' and DESCRIPTION not like 'secondary%' and DESCRIPTION not like 'managing%'

go
INSERT INTO [sma_TRN_LawFirms]
([lwfnLawFirmContactID],[lwfnLawFirmAddressID],[lwfnAttorneyContactID],[lwfnAttorneyAddressID],[lwfnAttorneyTypeID],[lwfsFileNumber],[lwfnRoleType],[lwfnContactID]
,[lwfnRecUserID],[lwfdDtCreated],[lwfnModifyUserID],[lwfdDtModified],[lwfnLevelNo],[lwfnAdjusterID])
select distinct o1.connContactID,ad1.addnAddressID,attorney.cinnContactID,ad2.addnAddressID,atnnAtorneyTypeID,substring(f.FILENUMBER,0,30),2,case when d1.defnDefendentID IS NOT NULL then d1.defnDefendentID when d2.defnDefendentID IS NOT NULL then d2.defnDefendentID end,368,GETDATE(),null,null,null,null 
from  WilliamPagerSaga.dbo.LW_FIRM f  
 left join WilliamPagerSaga.dbo.matrelt mat on f.MATRELTID=mat.MATRELTID
 left join WilliamPagerSaga.dbo.assign aatty on f.ATTORNEYASSIGNID=aatty.ASSIGNID 
 left join WilliamPagerSaga.dbo.entities eatty on aatty.entityid=eatty.entityid 
 left join sma_MST_IndvContacts attorney on attorney.cinsGrade=eatty.ENTITYID
 Left join WilliamPagerSaga.dbo.assign acomp on acomp.assignid=mat.RELATEDASSIGNID 
 left join WilliamPagerSaga.dbo.matter m on acomp.matterid=m.matterid 
 left join WilliamPagerSaga.dbo.entities ecomp on acomp.entityid=ecomp.entityid 
 left join WilliamPagerSaga.dbo.erole r on r.roleid=aatty.roleid 
 left join WilliamPagerSaga.dbo.assign aparty on aparty.assignid=mat.ASSIGNID and aparty.partytype=2  
 left join WilliamPagerSaga.dbo.entities eparty on eparty.entityid=aparty.entityid  
left join WilliamPagerSaga.dbo.ADDRESS ad on ad.ADDRESSID=ecomp.PRIMARYADDR
Left Join sma_MST_AttorneyTypes on r.DESCRIPTION=atnsAtorneyDscrptn
Left Join sma_TRN_CaseS on cassCaseNumber=m.MATTERNUMBER
left join sma_MST_IndvContacts i1 on i1.cinsGrade=acomp.ENTITYID
left join sma_mst_orgcontacts o1 on o1.connLevelNo=acomp.ENTITYID
left join sma_MST_IndvContacts i2 on i2.cinsGrade=aparty.ENTITYID
left join sma_mst_orgcontacts o2 on o2.connLevelNo=aparty.ENTITYID
left join sma_TRN_Defendants d1 on d1.defnContactCtgID=1 and d1.defnContactID=i2.cinnContactID  and d1.defnCaseID=casnCaseID
left join sma_TRN_Defendants d2 on d2.defnContactCtgID=2 and d2.defnContactID=o2.connContactID  and d2.defnCaseID=casnCaseID
left join sma_MST_Address ad1 on ad1.addnContactID=o1.connContactID and ad1.addbPrimary=1 and ad1.addsCity=ad.ADDRCITY and ad1.addsAddress1=ad.ADDRLINE1 and ad1.addnContactCtgID=2
left join sma_MST_Address ad2 on ad2.addnContactID=attorney.cinnContactID and ad2.addbPrimary=1 and ad2.addnContactCtgID=1
--Outer apply(Select top 1 addnAddressID from sma_MST_Address where addnContactID=connContactID and addnContactCtgID=2 and addbPrimary=1 ) ad1
--Outer apply(Select top 1 addnAddressID from sma_MST_Address where addnContactID=connContactID and addnContactCtgID=2 and addbPrimary=1) ad2
where casnCaseID is not null --and connContactID is not null--and aparty.ROLEID in (Select ROLEID from   [WilliamPagerSaga].dbo.EROLE where DESCRIPTION like '%defe%') and LawFrimContactID is not null
and (attorney.cinnContactID is not null or o1.connContactID is not null)
go
--drop table #lwfrmEntity

INSERT INTO [sma_TRN_PlaintiffAttorney]
([planPlaintffID],[planCaseID],[planPlCtgID],[planPlContactID],[planLawfrmAddID],[planLawfrmContactID],[planAtorneyAddID],[planAtorneyContactID]
,[planAtnTypeID],[plasFileNo],[planRecUserID],[pladDtCreated],[planModifyUserID],[pladDtModified],[planLevelNo],[planRefOutID])
select plnnPlaintiffID,plnnCaseID,plnnContactCtg,plnnContactID,ad1.addnAddressID,LawFrimContactID,null,null,
atnnAtorneyTypeID,lw.FILENUMBER,368,GETDATE(),null,null,null,null
from [WilliamPagerSaga].dbo.lw_firm lw
left join [WilliamPagerSaga].dbo.matrelt ml on ml.MATRELTID=lw.MATRELTID
left join [WilliamPagerSaga].dbo.ASSIGN afirm on ml.relatedASSIGNID=afirm.ASSIGNID
left join [WilliamPagerSaga].dbo.MATTER m on afirm.matterid=m.matterid
left join [WilliamPagerSaga].dbo.EROLE r on  r.ROLEID=afirm.ROLEID
left join [WilliamPagerSaga].dbo.assign aparty on ml.assignid=aparty.assignid 
Left Join sma_MST_AttorneyTypes on r.DESCRIPTION=atnsAtorneyDscrptn
Left Join sma_TRN_CaseS on cassCaseNumber=m.FILENUMBER
Outer Apply (select top 1  case when cinnContactCtg IS not null then 1 when connContactCtg IS not null then 2 end as ContactCtg, case when cinnContactID IS not null then cinnContactID when connContactID IS not null then connContactID end as ContactID  from [WilliamPagerSaga].dbo.entities en LEFT JOIN sma_MST_IndvContacts l on l.cinsGrade=en.ENTITYID LEFT JOIN sma_MST_OrgContacts k on k.connLevelNo=en.ENTITYID where en.entityid=aparty.entityid) Party
left join sma_TRN_Plaintiff on plnnCaseID=casnCaseID and plnnContactID=ContactID and plnnContactCtg=ContactCtg
OUTER APPLY (select top 1 case when connContactID IS not null then connContactID end as LawFrimContactID from [WilliamPagerSaga].dbo.entities efirm LEFT JOIN sma_MST_OrgContacts k on k.connLevelNo=efirm.ENTITYID where afirm.ENTITYID=efirm.ENTITYID)efrim
Outer apply(Select top 1 addnAddressID from sma_MST_Address where addnContactID=LawFrimContactID and addbPrimary=1 and addnContactCtgID=2) ad1
where plnnCaseID is not null and aparty.ROLEID in (Select ROLEID from   [WilliamPagerSaga].dbo.EROLE where DESCRIPTION like '%plain%')   
    
Alter Table sma_trn_lawfirms Enable trigger all
go