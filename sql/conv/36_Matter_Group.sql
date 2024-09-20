----SAGA Overview Screen Group Information
INSERT INTO [sma_MST_UDFDefinition]
([udfsUDFCtg],[udfnRelatedPK],[udfsUDFName],[udfsScreenName],[udfsType],[udfsLength],[udfsFormat],[udfsTableName],[udfsNewValues],[udfsDefaultValue]
,[udfnSortOrder],[udfbIsActive],[udfnRecUserID],[udfnDtCreated],[udfnModifyUserID],[udfnDtModified],[udfnLevelNo],[udfbIsSystem])
Select 'C',cstnCaseTypeID,'Matter Group1 Date','Case','Date',500,NULL,NULL,NULL,NULL,11,1,368,GETDATE(),NULL,NULL,1,NULL 
from WilliamPagerSaga.dbo.LAWTYPE
Left Join sma_MST_CaseType on cstsType=DESCRIPTION
Union
Select 'C',cstnCaseTypeID,'Matter Group1','Case','Text',500,NULL,NULL,NULL,NULL,10,1,368,GETDATE(),NULL,NULL,1,NULL from WilliamPagerSaga.dbo.LAWTYPE
Left Join sma_MST_CaseType on cstsType=DESCRIPTION
Union
Select 'C',cstnCaseTypeID,'Matter Group2 Date','Case','Date',500,NULL,NULL,NULL,NULL,13,1,368,GETDATE(),NULL,NULL,1,NULL 
from WilliamPagerSaga.dbo.LAWTYPE
Left Join sma_MST_CaseType on cstsType=DESCRIPTION
Union
Select 'C',cstnCaseTypeID,'Matter Group2','Case','Text',500,NULL,NULL,NULL,NULL,12,1,368,GETDATE(),NULL,NULL,1,NULL from WilliamPagerSaga.dbo.LAWTYPE
Left Join sma_MST_CaseType on cstsType=DESCRIPTION
Union
Select 'C',cstnCaseTypeID,'Matter Group3 Date','Case','Date',500,NULL,NULL,NULL,NULL,15,1,368,GETDATE(),NULL,NULL,1,NULL 
from WilliamPagerSaga.dbo.LAWTYPE
Left Join sma_MST_CaseType on cstsType=DESCRIPTION
Union
Select 'C',cstnCaseTypeID,'Matter Group3','Case','Text',500,NULL,NULL,NULL,NULL,14,1,368,GETDATE(),NULL,NULL,1,NULL from WilliamPagerSaga.dbo.LAWTYPE
Left Join sma_MST_CaseType on cstsType=DESCRIPTION


INSERT INTO [sma_TRN_UDFValues]
([udvnUDFID],[udvsScreenName],[udvsUDFCtg],[udvnRelatedID],[udvnSubRelatedID],[udvsUDFValue],[udvnRecUserID],[udvdDtCreated],[udvnModifyUserID],[udvdDtModified],[udvnLevelNo])

select distinct udfnUDFID,'Case','C',casnCaseID,0,convert(varchar(10),MATTERGROUP1DATE,101),368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.MATTER a
left join WilliamPagerSaga.dbo.[LW_A_MATTERGROUP] b on a.MATTERGROUP1ID=b.MATTERGROUPID
left join sma_trn_cases on cassCaseNumber=MATTERNUMBER
left join sma_MST_UDFDefinition on udfnRelatedPK=casnOrgCaseTypeID
where udfsUDFName='Matter Group1 Date' and ISNULL(MATTERGROUP1DATE,'')<>''
union
select distinct udfnUDFID,'Case','C',casnCaseID,0,convert(varchar(10),MATTERGROUP2DATE,101),368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.MATTER a
left join WilliamPagerSaga.dbo.[LW_A_MATTERGROUP] b on a.MATTERGROUP2ID=b.MATTERGROUPID
left join sma_trn_cases on cassCaseNumber=MATTERNUMBER
left join sma_MST_UDFDefinition on udfnRelatedPK=casnOrgCaseTypeID
where udfsUDFName='Matter Group2 Date' and ISNULL(MATTERGROUP2DATE,'')<>''
union
select distinct udfnUDFID,'Case','C',casnCaseID,0,convert(varchar(10),MATTERGROUP3DATE,101),368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.MATTER a
left join WilliamPagerSaga.dbo.[LW_A_MATTERGROUP] b on a.MATTERGROUP3ID=b.MATTERGROUPID
left join sma_trn_cases on cassCaseNumber=MATTERNUMBER
left join sma_MST_UDFDefinition on udfnRelatedPK=casnOrgCaseTypeID
where udfsUDFName='Matter Group3 Date' and ISNULL(MATTERGROUP3DATE,'')<>''


INSERT INTO [sma_TRN_UDFValues]
([udvnUDFID],[udvsScreenName],[udvsUDFCtg],[udvnRelatedID],[udvnSubRelatedID],[udvsUDFValue],[udvnRecUserID],[udvdDtCreated],[udvnModifyUserID],[udvdDtModified],[udvnLevelNo])
select distinct udfnUDFID,'Case','C',casnCaseID,0,b.DESCRIPTION,368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.MATTER a
left join WilliamPagerSaga.dbo.[LW_A_MATTERGROUP] b on a.MATTERGROUP1ID=b.MATTERGROUPID
left join sma_trn_cases on cassCaseNumber=MATTERNUMBER
left join sma_MST_UDFDefinition on udfnRelatedPK=casnOrgCaseTypeID
where udfsUDFName='Matter Group1' and ISNULL(b.DESCRIPTION,'')<>''
union
select distinct udfnUDFID,'Case','C',casnCaseID,0,b.DESCRIPTION,368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.MATTER a
left join WilliamPagerSaga.dbo.[LW_A_MATTERGROUP] b on a.MATTERGROUP2ID=b.MATTERGROUPID
left join sma_trn_cases on cassCaseNumber=MATTERNUMBER
left join sma_MST_UDFDefinition on udfnRelatedPK=casnOrgCaseTypeID
where udfsUDFName='Matter Group2' and ISNULL(b.DESCRIPTION,'')<>''
union
select distinct udfnUDFID,'Case','C',casnCaseID,0,b.DESCRIPTION,368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.MATTER a
left join WilliamPagerSaga.dbo.[LW_A_MATTERGROUP] b on a.MATTERGROUP3ID=b.MATTERGROUPID
left join sma_trn_cases on cassCaseNumber=MATTERNUMBER
left join sma_MST_UDFDefinition on udfnRelatedPK=casnOrgCaseTypeID
where udfsUDFName='Matter Group3' and ISNULL(b.DESCRIPTION,'')<>''
