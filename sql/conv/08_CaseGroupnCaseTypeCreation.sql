Declare @CaseTypeID int
Select @CaseTypeID =max(cstncasetypeid) from sma_MST_CaseType 

INSERT INTO [sma_MST_CaseStatus]
([csssCode],[csssDescription],[cssnStatusTypeID],[cssnClientStatusID],[cssnExpNoOfDays],[cssnRecUserID],[cssdDtCreated],[cssnModifyUserID],[cssdDtModified],[cssnLevelNo],[cssbBlockRetComment],[SGsStatusType])
Select '',DESCRIPTION,1,null,'',case isnull(u1.usrnuserid,'') when '' then 368 else u1.usrnuserid end,GETDATE(),u2.usrnuserid,GETDATE(),'',SHOWMODE,STATUSID  FROM [WilliamPagerSaga].[dbo].[STATUS]
left join sma_MST_IndvContacts a on a.cinsGrade=CREATORID
left join sma_mst_users u1 on u1.usrnContactID=a.cinnContactID
left join sma_MST_IndvContacts b on b.cinsGrade=REVISORID
left join sma_mst_users u2 on u2.usrnContactID=b.cinnContactID
where LTRIM(RTRIM(DESCRIPTION)) not in (select LTRIM(rtrim(csssDescription)) from sma_MST_CaseStatus where cssnStatusTypeID=1) and LTRIM(RTRIM(DESCRIPTION)) not like '%closed%'


Insert into sma_TRN_CaseStagesStatus(StageID,StatusID,CreatedDt,CreatedBy)
Select 5,cssnStatusID,GETDATE(),368 from sma_MST_CaseStatus
where csssDescription in ('Rejected','Settled','Rejected and scanned','SET7 - Settled and Scanned','Withdrew','Discontinued') and cssnStatusTypeID=1

--alter table sma_mst_casegroup 
--alter column [incident_type] varchar(500)

INSERT INTO [sma_MST_CaseGroup]
([cgpsCode],[cgpsDscrptn],[cgpnRecUserId],[cgpdDtCreated],[cgpnModifyUserID],[cgpdDtModified],[cgpnLevelNo])--,[cgpsIncidentScreen],[incident_type])
Select  [CODE],[description], 368 ,getdate(),null,null,
''--,'frmIncident'+code,[description]
From [WilliamPagerSaga].[dbo].[LAWCAT] a
where [description] not in (Select [cgpsDscrptn] FROM [sma_MST_CaseGroup])


INSERT INTO [sma_MST_CaseType]
([cstsCode],[cstsType],[cstsSubType],[cstnWorkflowTemplateID],[cstnExpectedResolutionDays],[cstnRecUserID],[cstdDtCreated],[cstnModifyUserID]
,[cstdDtModified],[cstnLevelNo],[cstbTimeTracking],[cstnGroupID],[cstnGovtMunType],[cstnIsMassTort],cstbActive)
     
select distinct '',c.DESCRIPTION,'',NULL,720,1,GETDATE(),null,null,'',0,cgpncasegroupid,NULL,NULL,1
 from [WilliamPagerSaga].[dbo].[LAWTYPE] c
Left Join sma_MST_CaseType on cstsType=c.DESCRIPTION
left join [WilliamPagerSaga].[dbo].[LAWCAT] a on a.[LAWCATEGORYID]=c.[LAWCATEGORYID]
left join sma_mst_casegroup on cgpsdscrptn=a.description
where c.DESCRIPTION not in (select cststype from sma_mst_casetype)

INSERT INTO[sma_MST_CaseSubType]
([cstsCode],[cstnGroupID],[cstsDscrptn],[cstnRecUserId],[cstdDtCreated],[cstnModifyUserID],[cstdDtModified],[cstnLevelNo],[cstbDefualt],[saga])
select distinct '',cstncasetypeid,d.description,368,getdate(),null,null,null,1,''
 from [WilliamPagerSaga].[dbo].[LAWTYPE] c
Left Join sma_MST_CaseType on cstsType=c.DESCRIPTION  
cross join  WilliamPagerSaga.dbo.LW_A_MATTERTYPE d
where cstncasetypeid>=@CaseTypeID

INSERT INTO [sma_MST_SubRole]
([sbrsCode],[sbrnRoleID],[sbrsDscrptn],[sbrnCaseTypeID],[sbrnPriority],[sbrnRecUserID],[sbrdDtCreated],[sbrnModifyUserID],[sbrdDtModified],[sbrnLevelNo],[sbrbDefualt],[saga])
Select [sbrsCode],[sbrnRoleID],[sbrsDscrptn],cstncasetypeid,[sbrnPriority],[sbrnRecUserID],[sbrdDtCreated],[sbrnModifyUserID],[sbrdDtModified],[sbrnLevelNo],[sbrbDefualt],[saga] from
   [WilliamPagerSaga].[dbo].[LAWTYPE] c
Left Join sma_MST_CaseType on cstsType=c.DESCRIPTION 
left join   sma_mst_subrole on cstncasetypeid=[sbrnCaseTypeID] or [sbrnCaseTypeID]=1
where cstncasetypeid>=@CaseTypeID

INSERT INTO [sma_MST_StateCaseTypes]([stcnCaseTypeID],[stcnStateID])
Select distinct cstnCaseTypeID,sttnStateID from   [WilliamPagerSaga].[dbo].[LAWTYPE] c
Left Join sma_MST_CaseType on cstsType=c.DESCRIPTION
cross join sma_mst_states
where cstnCaseTypeID not in (select stcncasetypeid from sma_MST_StateCaseTypes)



INSERT INTO [sma_MST_CaseTypeDefualtDefs]
([cddnCaseTypeID],[cddnDefContatID],[cddnDefContactCtgID],[cddnRoleID],[cddnDefAddressID])
Select cstncasetypeid,9,1,sbrnSubRoleId,2
From sma_MST_CaseType
Left Join sma_MST_SubRole on    sbrnCaseTypeID=cstnCaseTypeID and sbrnRoleID=5 and sbrbDefualt=1
where cstnCaseTypeID>=@CaseTypeID
