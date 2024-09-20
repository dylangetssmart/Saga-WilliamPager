
Alter Table sma_trn_casestaff disable trigger all


INSERT INTO [sma_TRN_CaseStaff]
([cssnCaseID],[cssnStaffID],[cssnRoleID],[csssComments],[cssdFromDate],[cssdToDate],[cssnRecUserID],[cssdDtCreated],[cssnModifyUserID],[cssdDtModified],[cssnLevelNo])
Select distinct casncaseid, i1.cinnContactID,case when z.DESCRIPTION='Secretary' then 19000 when z.DESCRIPTION ='Attorney - Primary' then 5 when z.DESCRIPTION='Paralegal - Primary' then 6 when  z.DESCRIPTION ='Attorney  - Primary (our office)' then 5 when z.DESCRIPTION='Attorney - Subsequent' then 1  when  z.DESCRIPTION ='Paralegal' then 3 when  z.DESCRIPTION='Paralegal - Primary' then 6  when  z.DESCRIPTION ='Attorney' then 1 when  z.DESCRIPTION='Primary Attorney' then 5 when  z.DESCRIPTION='Managing Attorney' then 8  when  z.DESCRIPTION='Attorney - Primary (our Staff)' then 5  when z.DESCRIPTION like '%attorney%' then 1 when z.DESCRIPTION like '%paralegal%' then 3 else 19000 end,z.DESCRIPTION,a.DATECREATED,null,u1.usrnUserID,a.DATECREATED,u2.usrnUserID,a.DATEREVISED,null
From [WilliamPagerSaga].[dbo].ASSIGN a
left join [WilliamPagerSaga].[dbo].[Matter] b on b.MATTERID=a.MATTERID
left join [WilliamPagerSaga].[dbo].[erole] z on z.roleid=a.ROLEID
left join sma_trn_cases on cassCaseNumber=MATTERNUMBER
left join  sma_MST_IndvContacts i1 on LTRIM(rtrim(i1.cinsGrade))=a.ENTITYID
--left join sma_MST_SubRole on sbrsDscrptn=case when z.ROLEID in (101,102,105,103,104) then z.DESCRIPTION else 'Attorney' end
left join sma_MST_IndvContacts l on l.cinsGrade=a.CREATORID
left join sma_mst_users u1 on u1.usrnContactID=l.cinnContactID
left join sma_MST_IndvContacts m on m.cinsGrade=a.REVISORID
left join sma_mst_users u2 on u2.usrnContactID=m.cinnContactID
where z.ROLECATEGORYID in (0,1,2,3,4,5)
and a.ENTITYID in (select cinsGrade from sma_mst_users join sma_MST_IndvContacts on cinnContactID=usrnContactID where cinsGrade is NOT null)


INSERT INTO [sma_TRN_CaseStaff]
([cssnCaseID],[cssnStaffID],[cssnRoleID],[csssComments],[cssdFromDate],[cssdToDate],[cssnRecUserID],[cssdDtCreated],[cssnModifyUserID],[cssdDtModified],[cssnLevelNo])
select casnCaseID,8,1,'UnAssigned Staff',GETDATE(),null,368,GETDATE(),null,null,'' from sma_TRN_CaseS
where casnCaseID not in (select cssncaseid from sma_TRN_CaseStaff)

delete from sma_TRN_CaseStaff where cssnPKID not in (
Select MIN(cssnPKID) from sma_TRN_CaseStaff 
Group by cssnCaseID,cssnStaffID)


Alter Table sma_trn_casestaff enable trigger all