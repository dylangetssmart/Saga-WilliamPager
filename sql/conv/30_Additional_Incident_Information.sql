Update [sma_MST_UDFDefinition]
set udfsUDFName='County'
where udfsUDFCtg ='I' and udfsUDFName='Country'

Insert Into [sma_MST_IncidentTypes]
select distinct 'frmIncident',cgpsDscrptn from sma_trn_cases
left join sma_MST_CaseType on cstnCaseTypeID=casnOrgCaseTypeID
left join sma_MST_CaseGroup CG on cstnGroupID=cgpnCaseGroupID
where LTRIM(RTRIM('frmIncident')) not in (select LTRIM(RTRIM([IncidentType])) from [sma_MST_IncidentTypes])

INSERT INTO [sma_MST_UDFDefinition]
([udfsUDFCtg],[udfnRelatedPK],[udfsUDFName],[udfsScreenName],[udfsType],[udfsLength],[udfsFormat],[udfsTableName],[udfsNewValues],[udfsDefaultValue],[udfnSortOrder]
,[udfbIsActive],[udfnRecUserID],[udfnDtCreated],[udfnModifyUserID],[udfnDtModified],[udfnLevelNo],[udfbIsSystem]) 
select distinct [udfsUDFCtg],IncidentTypeID,[udfsUDFName],[udfsScreenName],[udfsType],[udfsLength],[udfsFormat],[udfsTableName],[udfsNewValues],[udfsDefaultValue],[udfnSortOrder]
,[udfbIsActive],[udfnRecUserID],[udfnDtCreated],[udfnModifyUserID],[udfnDtModified],[udfnLevelNo],[udfbIsSystem] 
from sma_MST_UDFDefinition
cross join [sma_MST_IncidentTypes] 
where IncidentTypeID not in (select udfnRelatedPK from sma_MST_UDFDefinition where udfsUDFCtg ='I') and  udfsUDFCtg ='I' and udfnRelatedPK=2
order by IncidentTypeID,udfnSortOrder



INSERT INTO [sma_MST_UDFDefinition]
([udfsUDFCtg],[udfnRelatedPK],[udfsUDFName],[udfsScreenName],[udfsType],[udfsLength],[udfsFormat],[udfsTableName],[udfsNewValues],[udfsDefaultValue],[udfnSortOrder]
,[udfbIsActive],[udfnRecUserID],[udfnDtCreated],[udfnModifyUserID],[udfnDtModified],[udfnLevelNo],[udfbIsSystem]) 
select distinct [udfsUDFCtg],udfnRelatedPK,'Zip','Incident','Text',[udfsLength],[udfsFormat],[udfsTableName],'',[udfsDefaultValue],11
,[udfbIsActive],368,GETDATE(),[udfnModifyUserID],[udfnDtModified],[udfnLevelNo],[udfbIsSystem] 
from sma_MST_UDFDefinition
where udfsUDFCtg ='I' and udfnRelatedPK   in (select distinct CG.IncidentTypeID from sma_trn_cases
left join sma_MST_CaseType on cstnCaseTypeID=casnOrgCaseTypeID
left join sma_MST_CaseGroup CG on cstnGroupID=cgpnCaseGroupID
left join [sma_MST_IncidentTypes] on LTRIM(RTRIM('frmIncident'))=LTRIM(RTRIM([IncidentType])))
union
select distinct [udfsUDFCtg],udfnRelatedPK,'Country','Incident','Text',[udfsLength],[udfsFormat],[udfsTableName],'',[udfsDefaultValue],12
,[udfbIsActive],368,GETDATE(),[udfnModifyUserID],[udfnDtModified],[udfnLevelNo],[udfbIsSystem] 
from sma_MST_UDFDefinition
where udfsUDFCtg ='I' and udfnRelatedPK   in (select distinct CG.IncidentTypeID from sma_trn_cases
left join sma_MST_CaseType on cstnCaseTypeID=casnOrgCaseTypeID
left join sma_MST_CaseGroup CG on cstnGroupID=cgpnCaseGroupID
left join [sma_MST_IncidentTypes] on LTRIM(RTRIM('frmIncident'))=LTRIM(RTRIM([IncidentType])))
union
select distinct [udfsUDFCtg],udfnRelatedPK,'Incident Description In Pleadings','Incident','MultiText',[udfsLength],[udfsFormat],[udfsTableName],'',[udfsDefaultValue],13
,[udfbIsActive],368,GETDATE(),[udfnModifyUserID],[udfnDtModified],[udfnLevelNo],[udfbIsSystem] 
from sma_MST_UDFDefinition
where udfsUDFCtg ='I' and udfnRelatedPK   in (select distinct CG.IncidentTypeID from sma_trn_cases
left join sma_MST_CaseType on cstnCaseTypeID=casnOrgCaseTypeID
left join sma_MST_CaseGroup CG on cstnGroupID=cgpnCaseGroupID
left join [sma_MST_IncidentTypes] on LTRIM(RTRIM('frmIncident'))=LTRIM(RTRIM([IncidentType])))
union
select distinct [udfsUDFCtg],udfnRelatedPK,'User Defined Date1','Incident','Date',[udfsLength],[udfsFormat],[udfsTableName],'',[udfsDefaultValue],14
,[udfbIsActive],368,GETDATE(),[udfnModifyUserID],[udfnDtModified],[udfnLevelNo],[udfbIsSystem] 
from sma_MST_UDFDefinition
where udfsUDFCtg ='I' and udfnRelatedPK   in (select distinct CG.IncidentTypeID from sma_trn_cases
left join sma_MST_CaseType on cstnCaseTypeID=casnOrgCaseTypeID
left join sma_MST_CaseGroup CG on cstnGroupID=cgpnCaseGroupID
left join [sma_MST_IncidentTypes] on LTRIM(RTRIM('frmIncident'))=LTRIM(RTRIM([IncidentType])))
union
select distinct [udfsUDFCtg],udfnRelatedPK,'User Defined Date2','Incident','Date',[udfsLength],[udfsFormat],[udfsTableName],'',[udfsDefaultValue],15
,[udfbIsActive],368,GETDATE(),[udfnModifyUserID],[udfnDtModified],[udfnLevelNo],[udfbIsSystem] 
from sma_MST_UDFDefinition
where udfsUDFCtg ='I' and udfnRelatedPK   in (select distinct CG.IncidentTypeID from sma_trn_cases
left join sma_MST_CaseType on cstnCaseTypeID=casnOrgCaseTypeID
left join sma_MST_CaseGroup CG on cstnGroupID=cgpnCaseGroupID
left join [sma_MST_IncidentTypes] on LTRIM(RTRIM('frmIncident'))=LTRIM(RTRIM([IncidentType])))
order by udfnRelatedPK



INSERT INTO [sma_TRN_UDFValues]
([udvnUDFID],[udvsScreenName],[udvsUDFCtg],[udvnRelatedID],[udvnSubRelatedID],[udvsUDFValue],[udvnRecUserID],[udvdDtCreated],[udvnModifyUserID],[udvdDtModified],[udvnLevelNo])
select distinct udfnUDFID,udfsScreenName,udfsUDFCtg,casnCaseID,'',convert(varchar(10),UDFDATE1,101),368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.MATTER a
left join WilliamPagerSaga.dbo.LW_MATTER b on a.MATTERID=b.MATTERID
left join sma_trn_cases on cassCaseNumber=MATTERNUMBER
left join sma_MST_CaseType on cstnCaseTypeID=casnOrgCaseTypeID
left join sma_MST_CaseGroup CG on cstnGroupID=cgpnCaseGroupID
left join [sma_MST_IncidentTypes] on LTRIM(RTRIM('frmIncident'))=LTRIM(RTRIM([IncidentType]))
left join sma_MST_UDFDefinition on udfnRelatedPK=CG.IncidentTypeID
where udfsUDFName='User Defined Date1' and ISNULL(UDFDATE1,'')<>'' and udfsUDFCtg='I'
Union
select distinct udfnUDFID,udfsScreenName,udfsUDFCtg,casnCaseID,'',convert(varchar(10),UDFDATE2,101),368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.MATTER a
left join WilliamPagerSaga.dbo.LW_MATTER b on a.MATTERID=b.MATTERID
left join sma_trn_cases on cassCaseNumber=MATTERNUMBER
left join sma_MST_CaseType on cstnCaseTypeID=casnOrgCaseTypeID
left join sma_MST_CaseGroup CG on cstnGroupID=cgpnCaseGroupID
left join [sma_MST_IncidentTypes] on LTRIM(RTRIM('frmIncident'))=LTRIM(RTRIM([IncidentType]))
left join sma_MST_UDFDefinition on udfnRelatedPK=CG.IncidentTypeID
where udfsUDFName='User Defined Date2' and ISNULL(UDFDATE2,'')<>'' and udfsUDFCtg='I'

INSERT INTO [sma_TRN_UDFValues]
([udvnUDFID],[udvsScreenName],[udvsUDFCtg],[udvnRelatedID],[udvnSubRelatedID],[udvsUDFValue],[udvnRecUserID],[udvdDtCreated],[udvnModifyUserID],[udvdDtModified],[udvnLevelNo])
select distinct udfnUDFID,udfsScreenName,udfsUDFCtg,casnCaseID,'',convert(varchar(4000),LOCATIONSTREET),368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.MATTER a
left join WilliamPagerSaga.dbo.LW_MATTER b on a.MATTERID=b.MATTERID
left join sma_trn_cases on cassCaseNumber=MATTERNUMBER
left join sma_MST_CaseType on cstnCaseTypeID=casnOrgCaseTypeID
left join sma_MST_CaseGroup CG on cstnGroupID=cgpnCaseGroupID
left join [sma_MST_IncidentTypes] on LTRIM(RTRIM('frmIncident'))=LTRIM(RTRIM([IncidentType]))
left join sma_MST_UDFDefinition on udfnRelatedPK=CG.IncidentTypeID
where udfsUDFName='location' and ISNULL(LOCATIONSTREET,'')<>'' and udfsUDFCtg='I'
Union
select distinct udfnUDFID,udfsScreenName,udfsUDFCtg,casnCaseID,'',LOCATIONCITY,368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.MATTER a
left join WilliamPagerSaga.dbo.LW_MATTER b on a.MATTERID=b.MATTERID
left join sma_trn_cases on cassCaseNumber=MATTERNUMBER
left join sma_MST_CaseType on cstnCaseTypeID=casnOrgCaseTypeID
left join sma_MST_CaseGroup CG on cstnGroupID=cgpnCaseGroupID
left join [sma_MST_IncidentTypes] on LTRIM(RTRIM('frmIncident'))=LTRIM(RTRIM([IncidentType]))
left join sma_MST_UDFDefinition on udfnRelatedPK=CG.IncidentTypeID
where udfsUDFName='city' and ISNULL(LOCATIONCITY,'')<>'' and udfsUDFCtg='I'
Union
select distinct udfnUDFID,udfsScreenName,udfsUDFCtg,casnCaseID,'',LOCATIONCOUNTY,368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.MATTER a
left join WilliamPagerSaga.dbo.LW_MATTER b on a.MATTERID=b.MATTERID
left join sma_trn_cases on cassCaseNumber=MATTERNUMBER
left join sma_MST_CaseType on cstnCaseTypeID=casnOrgCaseTypeID
left join sma_MST_CaseGroup CG on cstnGroupID=cgpnCaseGroupID
left join [sma_MST_IncidentTypes] on LTRIM(RTRIM('frmIncident'))=LTRIM(RTRIM([IncidentType]))
left join sma_MST_UDFDefinition on udfnRelatedPK=CG.IncidentTypeID
where udfsUDFName='county' and ISNULL(LOCATIONCOUNTY,'')<>'' and udfsUDFCtg='I'
Union
select distinct udfnUDFID,udfsScreenName,udfsUDFCtg,casnCaseID,'',LOCATIONCOUNTRY,368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.MATTER a
left join WilliamPagerSaga.dbo.LW_MATTER b on a.MATTERID=b.MATTERID
left join sma_trn_cases on cassCaseNumber=MATTERNUMBER
left join sma_MST_CaseType on cstnCaseTypeID=casnOrgCaseTypeID
left join sma_MST_CaseGroup CG on cstnGroupID=cgpnCaseGroupID
left join [sma_MST_IncidentTypes] on LTRIM(RTRIM('frmIncident'))=LTRIM(RTRIM([IncidentType]))
left join sma_MST_UDFDefinition on udfnRelatedPK=CG.IncidentTypeID
where udfsUDFName='country' and ISNULL(LOCATIONCOUNTRY,'')<>'' and udfsUDFCtg='I'
Union
select distinct udfnUDFID,udfsScreenName,udfsUDFCtg,casnCaseID,'',LOCATIONZIP,368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.MATTER a
left join WilliamPagerSaga.dbo.LW_MATTER b on a.MATTERID=b.MATTERID
left join sma_trn_cases on cassCaseNumber=MATTERNUMBER
left join sma_MST_CaseType on cstnCaseTypeID=casnOrgCaseTypeID
left join sma_MST_CaseGroup CG on cstnGroupID=cgpnCaseGroupID
left join [sma_MST_IncidentTypes] on LTRIM(RTRIM('frmIncident'))=LTRIM(RTRIM([IncidentType]))
left join sma_MST_UDFDefinition on udfnRelatedPK=CG.IncidentTypeID
where udfsUDFName='zip' and ISNULL(LOCATIONZIP,'')<>'' and udfsUDFCtg='I'
Union
select distinct udfnUDFID,udfsScreenName,udfsUDFCtg,casnCaseID,'',convert(varchar(4000),COMMENTS),368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.MATTER a
left join WilliamPagerSaga.dbo.LW_MATTER b on a.MATTERID=b.MATTERID
left join sma_trn_cases on cassCaseNumber=MATTERNUMBER
left join sma_MST_CaseType on cstnCaseTypeID=casnOrgCaseTypeID
left join sma_MST_CaseGroup CG on cstnGroupID=cgpnCaseGroupID
left join [sma_MST_IncidentTypes] on LTRIM(RTRIM('frmIncident'))=LTRIM(RTRIM([IncidentType]))
left join sma_MST_UDFDefinition on udfnRelatedPK=CG.IncidentTypeID
where udfsUDFName='Incident Description In Pleadings' and ISNULL(convert(varchar(4000),COMMENTS),'')<>'' and udfsUDFCtg='I'

