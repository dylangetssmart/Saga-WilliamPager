INSERT INTO [sma_MST_UDFDefinition]
([udfsUDFCtg],[udfnRelatedPK],[udfsUDFName],[udfsScreenName],[udfsType],[udfsLength],[udfsFormat],[udfsTableName],[udfsNewValues],[udfsDefaultValue]
,[udfnSortOrder],[udfbIsActive],[udfnRecUserID],[udfnDtCreated],[udfnModifyUserID],[udfnDtModified],[udfnLevelNo],[udfbIsSystem])
Select 'C',cstnCaseTypeID,text,'Case',case when CTRLNUM between 8 and 11 then 'Date' when CTRLTYPE=202 then 'Dropdown' else 'Text' end,500,NULL,NULL,case when CTRLTYPE=202 then 'Yes~No' end,NULL,
1000+CTRLNUM,1,368,GETDATE(),NULL,NULL,1,NULL 
from WilliamPagerSaga.dbo.LAWTYPE
Left Join sma_MST_CaseType on cstsType=DESCRIPTION
cross join WilliamPagerSaga.dbo.DESCTRL a
left join WilliamPagerSaga.dbo.DESFORM b on a.FORMID=b.FORMID
where b.DESCRIPTION like 'matter%' and CTRLTYPE in (101,202)
Union
Select 'C',cstnCaseTypeID,text,'Plaintiff',case when CTRLNUM between 8 and 11 then 'Date' when CTRLTYPE=202 then 'Dropdown' else 'Text' end,500,NULL,NULL,case when CTRLTYPE=202 then 'Yes~No' end,NULL,
1000+CTRLNUM,1,368,GETDATE(),NULL,NULL,1,NULL 
from WilliamPagerSaga.dbo.LAWTYPE
Left Join sma_MST_CaseType on cstsType=DESCRIPTION
cross join WilliamPagerSaga.dbo.DESCTRL a
left join WilliamPagerSaga.dbo.DESFORM b on a.FORMID=b.FORMID
where b.DESCRIPTION like 'plaint%' and CTRLTYPE in (101,202)
union
Select 'C',cstnCaseTypeID,text,'Defendant',case when CTRLNUM between 8 and 11 then 'Date' when CTRLTYPE=202 then 'Dropdown' else 'Text' end,500,NULL,NULL,case when CTRLTYPE=202 then 'Yes~No' end,NULL,
1000+CTRLNUM,1,368,GETDATE(),NULL,NULL,1,NULL 
from WilliamPagerSaga.dbo.LAWTYPE
Left Join sma_MST_CaseType on cstsType=DESCRIPTION
cross join WilliamPagerSaga.dbo.DESCTRL a
left join WilliamPagerSaga.dbo.DESFORM b on a.FORMID=b.FORMID
where b.DESCRIPTION like 'defen%' and CTRLTYPE in (101,202)


INSERT INTO [sma_TRN_UDFValues]
([udvnUDFID],[udvsScreenName],[udvsUDFCtg],[udvnRelatedID],[udvnSubRelatedID],[udvsUDFValue],[udvnRecUserID],[udvdDtCreated],[udvnModifyUserID],[udvdDtModified],[udvnLevelNo])
select udfnUDFID,'Case','C',casnCaseID,0,FIELD1,368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.AUXUDFMA
left join WilliamPagerSaga.dbo.MATTER on MATTERID=REFERID
left join sma_TRN_CaseS on cassCaseNumber=MATTERNUMBER
left join sma_MST_UDFDefinition on udfnRelatedPK=casnOrgCaseTypeID
where udfsUDFName=(select text from  WilliamPagerSaga.dbo.DESCTRL a
left join WilliamPagerSaga.dbo.DESFORM b on a.FORMID=b.FORMID
where b.DESCRIPTION like 'matter%' and CTRLTYPE in (101,202) and CTRLNUM=2) and ISNULL(FIELD1,'')<>''
Union
select udfnUDFID,'Case','C',casnCaseID,0,FIELD2,368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.AUXUDFMA
left join WilliamPagerSaga.dbo.MATTER on MATTERID=REFERID
left join sma_TRN_CaseS on cassCaseNumber=MATTERNUMBER
left join sma_MST_UDFDefinition on udfnRelatedPK=casnOrgCaseTypeID
where udfsUDFName=(select text from  WilliamPagerSaga.dbo.DESCTRL a
left join WilliamPagerSaga.dbo.DESFORM b on a.FORMID=b.FORMID
where b.DESCRIPTION like 'matter%' and CTRLTYPE in (101,202) and CTRLNUM=3) and ISNULL(FIELD2,'')<>''
Union
select udfnUDFID,'Case','C',casnCaseID,0,FIELD3,368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.AUXUDFMA
left join WilliamPagerSaga.dbo.MATTER on MATTERID=REFERID
left join sma_TRN_CaseS on cassCaseNumber=MATTERNUMBER
left join sma_MST_UDFDefinition on udfnRelatedPK=casnOrgCaseTypeID
where udfsUDFName=(select text from  WilliamPagerSaga.dbo.DESCTRL a
left join WilliamPagerSaga.dbo.DESFORM b on a.FORMID=b.FORMID
where b.DESCRIPTION like 'matter%' and CTRLTYPE in (101,202) and CTRLNUM=4) and ISNULL(FIELD3,'')<>''
Union
select udfnUDFID,'Case','C',casnCaseID,0,FIELD4,368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.AUXUDFMA
left join WilliamPagerSaga.dbo.MATTER on MATTERID=REFERID
left join sma_TRN_CaseS on cassCaseNumber=MATTERNUMBER
left join sma_MST_UDFDefinition on udfnRelatedPK=casnOrgCaseTypeID
where udfsUDFName=(select text from  WilliamPagerSaga.dbo.DESCTRL a
left join WilliamPagerSaga.dbo.DESFORM b on a.FORMID=b.FORMID
where b.DESCRIPTION like 'matter%' and CTRLTYPE in (101,202) and CTRLNUM=5) and ISNULL(FIELD4,'')<>''
Union
select udfnUDFID,'Case','C',casnCaseID,0,FIELD5,368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.AUXUDFMA
left join WilliamPagerSaga.dbo.MATTER on MATTERID=REFERID
left join sma_TRN_CaseS on cassCaseNumber=MATTERNUMBER
left join sma_MST_UDFDefinition on udfnRelatedPK=casnOrgCaseTypeID
where udfsUDFName=(select text from  WilliamPagerSaga.dbo.DESCTRL a
left join WilliamPagerSaga.dbo.DESFORM b on a.FORMID=b.FORMID
where b.DESCRIPTION like 'matter%' and CTRLTYPE in (101,202) and CTRLNUM=6) and ISNULL(FIELD5,'')<>''


INSERT INTO [sma_TRN_UDFValues]
([udvnUDFID],[udvsScreenName],[udvsUDFCtg],[udvnRelatedID],[udvnSubRelatedID],[udvsUDFValue],[udvnRecUserID],[udvdDtCreated],[udvnModifyUserID],[udvdDtModified],[udvnLevelNo])
select udfnUDFID,'Case','C',casnCaseID,0,FIELD6,368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.AUXUDFMA
left join WilliamPagerSaga.dbo.MATTER on MATTERID=REFERID
left join sma_TRN_CaseS on cassCaseNumber=MATTERNUMBER
left join sma_MST_UDFDefinition on udfnRelatedPK=casnOrgCaseTypeID
where udfsUDFName=(select text from  WilliamPagerSaga.dbo.DESCTRL a
left join WilliamPagerSaga.dbo.DESFORM b on a.FORMID=b.FORMID
where b.DESCRIPTION like 'matter%' and CTRLTYPE in (101,202) and CTRLNUM=12) and ISNULL(FIELD6,'')<>''
Union
select udfnUDFID,'Case','C',casnCaseID,0,FIELD7,368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.AUXUDFMA
left join WilliamPagerSaga.dbo.MATTER on MATTERID=REFERID
left join sma_TRN_CaseS on cassCaseNumber=MATTERNUMBER
left join sma_MST_UDFDefinition on udfnRelatedPK=casnOrgCaseTypeID
where udfsUDFName=(select text from  WilliamPagerSaga.dbo.DESCTRL a
left join WilliamPagerSaga.dbo.DESFORM b on a.FORMID=b.FORMID
where b.DESCRIPTION like 'matter%' and CTRLTYPE in (101,202) and CTRLNUM=13)  and FIELD7 is not null
Union
select udfnUDFID,'Case','C',casnCaseID,0,FIELD8,368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.AUXUDFMA
left join WilliamPagerSaga.dbo.MATTER on MATTERID=REFERID
left join sma_TRN_CaseS on cassCaseNumber=MATTERNUMBER
left join sma_MST_UDFDefinition on udfnRelatedPK=casnOrgCaseTypeID
where udfsUDFName=(select text from  WilliamPagerSaga.dbo.DESCTRL a
left join WilliamPagerSaga.dbo.DESFORM b on a.FORMID=b.FORMID
where b.DESCRIPTION like 'matter%' and CTRLTYPE in (101,202) and CTRLNUM=14) and FIELD8 is not null

INSERT INTO [sma_TRN_UDFValues]
([udvnUDFID],[udvsScreenName],[udvsUDFCtg],[udvnRelatedID],[udvnSubRelatedID],[udvsUDFValue],[udvnRecUserID],[udvdDtCreated],[udvnModifyUserID],[udvdDtModified],[udvnLevelNo])
select udfnUDFID,'Case','C',casnCaseID,0,case when FIELD9='T' then 'Yes' else FIELD9 end,368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.AUXUDFMA
left join WilliamPagerSaga.dbo.MATTER on MATTERID=REFERID
left join sma_TRN_CaseS on cassCaseNumber=MATTERNUMBER
left join sma_MST_UDFDefinition on udfnRelatedPK=casnOrgCaseTypeID
where udfsUDFName=(select text from  WilliamPagerSaga.dbo.DESCTRL a
left join WilliamPagerSaga.dbo.DESFORM b on a.FORMID=b.FORMID
where b.DESCRIPTION like 'matter%' and CTRLTYPE in (101,202) and CTRLNUM=28) and ISNULL(FIELD9,'')<>'' and FIELD9<>'F'
Union
select udfnUDFID,'Case','C',casnCaseID,0,case when FIELD10='T' then 'Yes' else FIELD10 end,368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.AUXUDFMA
left join WilliamPagerSaga.dbo.MATTER on MATTERID=REFERID
left join sma_TRN_CaseS on cassCaseNumber=MATTERNUMBER
left join sma_MST_UDFDefinition on udfnRelatedPK=casnOrgCaseTypeID
where udfsUDFName=(select text from  WilliamPagerSaga.dbo.DESCTRL a
left join WilliamPagerSaga.dbo.DESFORM b on a.FORMID=b.FORMID
where b.DESCRIPTION like 'matter%' and CTRLTYPE in (101,202) and CTRLNUM=29) and ISNULL(FIELD10,'')<>'' and FIELD10<>'F'


INSERT INTO [sma_TRN_UDFValues]
([udvnUDFID],[udvsScreenName],[udvsUDFCtg],[udvnRelatedID],[udvnSubRelatedID],[udvsUDFValue],[udvnRecUserID],[udvdDtCreated],[udvnModifyUserID],[udvdDtModified],[udvnLevelNo])
select udfnUDFID,'Case','C',casnCaseID,0,case when isdate(FIELD11)=1 then FIELD11 else null end,368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.AUXUDFMA
left join WilliamPagerSaga.dbo.MATTER on MATTERID=REFERID
left join sma_TRN_CaseS on cassCaseNumber=MATTERNUMBER
left join sma_MST_UDFDefinition on udfnRelatedPK=casnOrgCaseTypeID
where udfsUDFName=(select text from  WilliamPagerSaga.dbo.DESCTRL a
left join WilliamPagerSaga.dbo.DESFORM b on a.FORMID=b.FORMID
where b.DESCRIPTION like 'matter%' and CTRLTYPE in (101,202) and CTRLNUM=8) and ISNULL(FIELD11,'')<>''
Union
select udfnUDFID,'Case','C',casnCaseID,0,case when isdate(FIELD12)=1 then FIELD12 else null end,368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.AUXUDFMA
left join WilliamPagerSaga.dbo.MATTER on MATTERID=REFERID
left join sma_TRN_CaseS on cassCaseNumber=MATTERNUMBER
left join sma_MST_UDFDefinition on udfnRelatedPK=casnOrgCaseTypeID
where udfsUDFName=(select text from  WilliamPagerSaga.dbo.DESCTRL a
left join WilliamPagerSaga.dbo.DESFORM b on a.FORMID=b.FORMID
where b.DESCRIPTION like 'matter%' and CTRLTYPE in (101,202) and CTRLNUM=9) and ISNULL(FIELD12,'')<>''
Union
select udfnUDFID,'Case','C',casnCaseID,0,case when isdate(FIELD13)=1 then FIELD13 else null end,368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.AUXUDFMA
left join WilliamPagerSaga.dbo.MATTER on MATTERID=REFERID
left join sma_TRN_CaseS on cassCaseNumber=MATTERNUMBER
left join sma_MST_UDFDefinition on udfnRelatedPK=casnOrgCaseTypeID
where udfsUDFName=(select text from  WilliamPagerSaga.dbo.DESCTRL a
left join WilliamPagerSaga.dbo.DESFORM b on a.FORMID=b.FORMID
where b.DESCRIPTION like 'matter%' and CTRLTYPE in (101,202) and CTRLNUM=10) and ISNULL(FIELD13,'')<>''
Union
select udfnUDFID,'Case','C',casnCaseID,0,case when isdate(FIELD14)=1 then FIELD14 else null end,368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.AUXUDFMA
left join WilliamPagerSaga.dbo.MATTER on MATTERID=REFERID
left join sma_TRN_CaseS on cassCaseNumber=MATTERNUMBER
left join sma_MST_UDFDefinition on udfnRelatedPK=casnOrgCaseTypeID
where udfsUDFName=(select text from  WilliamPagerSaga.dbo.DESCTRL a
left join WilliamPagerSaga.dbo.DESFORM b on a.FORMID=b.FORMID
where b.DESCRIPTION like 'matter%' and CTRLTYPE in (101,202) and CTRLNUM=11) and ISNULL(FIELD14,'')<>''

INSERT INTO [sma_TRN_UDFValues]
([udvnUDFID],[udvsScreenName],[udvsUDFCtg],[udvnRelatedID],[udvnSubRelatedID],[udvsUDFValue],[udvnRecUserID],[udvdDtCreated],[udvnModifyUserID],[udvdDtModified],[udvnLevelNo])
select udfnUDFID,'Defendant','C',casnCaseID,defnDefendentID,FIELD1,368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.AUXUDFDF
left join WilliamPagerSaga.dbo.MATTER on MATTERID=REFERID
left join sma_TRN_CaseS on cassCaseNumber=MATTERNUMBER
left join sma_MST_UDFDefinition on udfnRelatedPK=casnOrgCaseTypeID
left join sma_TRN_Defendants on defnCaseID=casnCaseID and defbIsPrimary=1
where udfsUDFName=(select text from  WilliamPagerSaga.dbo.DESCTRL a
left join WilliamPagerSaga.dbo.DESFORM b on a.FORMID=b.FORMID
where b.DESCRIPTION like 'Defendant%' and CTRLTYPE in (101,202) and CTRLNUM=2) and ISNULL(FIELD1,'')<>''
Union
select udfnUDFID,'Defendant','C',casnCaseID,defnDefendentID,FIELD2,368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.AUXUDFDF
left join WilliamPagerSaga.dbo.MATTER on MATTERID=REFERID
left join sma_TRN_CaseS on cassCaseNumber=MATTERNUMBER
left join sma_MST_UDFDefinition on udfnRelatedPK=casnOrgCaseTypeID
left join sma_TRN_Defendants on defnCaseID=casnCaseID and defbIsPrimary=1
where udfsUDFName=(select text from  WilliamPagerSaga.dbo.DESCTRL a
left join WilliamPagerSaga.dbo.DESFORM b on a.FORMID=b.FORMID
where b.DESCRIPTION like 'Defendant%' and CTRLTYPE in (101,202) and CTRLNUM=3) and ISNULL(FIELD2,'')<>''
Union
select udfnUDFID,'Defendant','C',casnCaseID,defnDefendentID,FIELD3,368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.AUXUDFDF
left join WilliamPagerSaga.dbo.MATTER on MATTERID=REFERID
left join sma_TRN_CaseS on cassCaseNumber=MATTERNUMBER
left join sma_MST_UDFDefinition on udfnRelatedPK=casnOrgCaseTypeID
left join sma_TRN_Defendants on defnCaseID=casnCaseID and defbIsPrimary=1
where udfsUDFName=(select text from  WilliamPagerSaga.dbo.DESCTRL a
left join WilliamPagerSaga.dbo.DESFORM b on a.FORMID=b.FORMID
where b.DESCRIPTION like 'Defendant%' and CTRLTYPE in (101,202) and CTRLNUM=4) and ISNULL(FIELD3,'')<>''
Union
select udfnUDFID,'Defendant','C',casnCaseID,defnDefendentID,FIELD4,368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.AUXUDFDF
left join WilliamPagerSaga.dbo.MATTER on MATTERID=REFERID
left join sma_TRN_CaseS on cassCaseNumber=MATTERNUMBER
left join sma_MST_UDFDefinition on udfnRelatedPK=casnOrgCaseTypeID
left join sma_TRN_Defendants on defnCaseID=casnCaseID and defbIsPrimary=1
where udfsUDFName=(select text from  WilliamPagerSaga.dbo.DESCTRL a
left join WilliamPagerSaga.dbo.DESFORM b on a.FORMID=b.FORMID
where b.DESCRIPTION like 'Defendant%' and CTRLTYPE in (101,202) and CTRLNUM=5) and ISNULL(FIELD4,'')<>''
Union
select udfnUDFID,'Defendant','C',casnCaseID,defnDefendentID,FIELD5,368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.AUXUDFDF
left join WilliamPagerSaga.dbo.MATTER on MATTERID=REFERID
left join sma_TRN_CaseS on cassCaseNumber=MATTERNUMBER
left join sma_MST_UDFDefinition on udfnRelatedPK=casnOrgCaseTypeID
left join sma_TRN_Defendants on defnCaseID=casnCaseID and defbIsPrimary=1
where udfsUDFName=(select text from  WilliamPagerSaga.dbo.DESCTRL a
left join WilliamPagerSaga.dbo.DESFORM b on a.FORMID=b.FORMID
where b.DESCRIPTION like 'Defendant%' and CTRLTYPE in (101,202) and CTRLNUM=6) and ISNULL(FIELD5,'')<>''

INSERT INTO [sma_TRN_UDFValues]
([udvnUDFID],[udvsScreenName],[udvsUDFCtg],[udvnRelatedID],[udvnSubRelatedID],[udvsUDFValue],[udvnRecUserID],[udvdDtCreated],[udvnModifyUserID],[udvdDtModified],[udvnLevelNo])
select udfnUDFID,'Defendant','C',casnCaseID,defnDefendentID,FIELD6,368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.AUXUDFDF
left join WilliamPagerSaga.dbo.MATTER on MATTERID=REFERID
left join sma_TRN_CaseS on cassCaseNumber=MATTERNUMBER
left join sma_MST_UDFDefinition on udfnRelatedPK=casnOrgCaseTypeID
left join sma_TRN_Defendants on defnCaseID=casnCaseID and defbIsPrimary=1
where udfsUDFName=(select text from  WilliamPagerSaga.dbo.DESCTRL a
left join WilliamPagerSaga.dbo.DESFORM b on a.FORMID=b.FORMID
where b.DESCRIPTION like 'Defendant%' and CTRLTYPE in (101,202) and CTRLNUM=12) and ISNULL(FIELD6,'')<>'' and FIELD6<>0
Union
select udfnUDFID,'Defendant','C',casnCaseID,defnDefendentID,FIELD7,368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.AUXUDFDF
left join WilliamPagerSaga.dbo.MATTER on MATTERID=REFERID
left join sma_TRN_CaseS on cassCaseNumber=MATTERNUMBER
left join sma_MST_UDFDefinition on udfnRelatedPK=casnOrgCaseTypeID
left join sma_TRN_Defendants on defnCaseID=casnCaseID and defbIsPrimary=1
where udfsUDFName=(select text from  WilliamPagerSaga.dbo.DESCTRL a
left join WilliamPagerSaga.dbo.DESFORM b on a.FORMID=b.FORMID
where b.DESCRIPTION like 'Defendant%' and CTRLTYPE in (101,202) and CTRLNUM=13) and FIELD7 is not null and FIELD7<>'0.00'
Union
select udfnUDFID,'Defendant','C',casnCaseID,defnDefendentID,FIELD8,368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.AUXUDFDF
left join WilliamPagerSaga.dbo.MATTER on MATTERID=REFERID
left join sma_TRN_CaseS on cassCaseNumber=MATTERNUMBER
left join sma_MST_UDFDefinition on udfnRelatedPK=casnOrgCaseTypeID
left join sma_TRN_Defendants on defnCaseID=casnCaseID and defbIsPrimary=1
where udfsUDFName=(select text from  WilliamPagerSaga.dbo.DESCTRL a
left join WilliamPagerSaga.dbo.DESFORM b on a.FORMID=b.FORMID
where b.DESCRIPTION like 'Defendant%' and CTRLTYPE in (101,202) and CTRLNUM=14) and FIELD8 is not null and FIELD8<>'0.00'

INSERT INTO [sma_TRN_UDFValues]
([udvnUDFID],[udvsScreenName],[udvsUDFCtg],[udvnRelatedID],[udvnSubRelatedID],[udvsUDFValue],[udvnRecUserID],[udvdDtCreated],[udvnModifyUserID],[udvdDtModified],[udvnLevelNo])
select udfnUDFID,'Defendant','C',casnCaseID,defnDefendentID,case when FIELD9='T' then 'Yes' else FIELD9 end,368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.AUXUDFDF
left join WilliamPagerSaga.dbo.MATTER on MATTERID=REFERID
left join sma_TRN_CaseS on cassCaseNumber=MATTERNUMBER
left join sma_MST_UDFDefinition on udfnRelatedPK=casnOrgCaseTypeID
left join sma_TRN_Defendants on defnCaseID=casnCaseID and defbIsPrimary=1
where udfsUDFName=(select text from  WilliamPagerSaga.dbo.DESCTRL a
left join WilliamPagerSaga.dbo.DESFORM b on a.FORMID=b.FORMID
where b.DESCRIPTION like 'Defendant%' and CTRLTYPE in (101,202) and CTRLNUM=28) and ISNULL(FIELD9,'')<>'' and FIELD9<>'F'
Union
select udfnUDFID,'Defendant','C',casnCaseID,defnDefendentID,case when FIELD10='T' then 'Yes' else FIELD10 end,368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.AUXUDFDF
left join WilliamPagerSaga.dbo.MATTER on MATTERID=REFERID
left join sma_TRN_CaseS on cassCaseNumber=MATTERNUMBER
left join sma_MST_UDFDefinition on udfnRelatedPK=casnOrgCaseTypeID
left join sma_TRN_Defendants on defnCaseID=casnCaseID and defbIsPrimary=1
where udfsUDFName=(select text from  WilliamPagerSaga.dbo.DESCTRL a
left join WilliamPagerSaga.dbo.DESFORM b on a.FORMID=b.FORMID
where b.DESCRIPTION like 'Defendant%' and CTRLTYPE in (101,202) and CTRLNUM=29) and ISNULL(FIELD10,'')<>'' and FIELD10<>'F'

INSERT INTO [sma_TRN_UDFValues]
([udvnUDFID],[udvsScreenName],[udvsUDFCtg],[udvnRelatedID],[udvnSubRelatedID],[udvsUDFValue],[udvnRecUserID],[udvdDtCreated],[udvnModifyUserID],[udvdDtModified],[udvnLevelNo])
select udfnUDFID,'Defendant','C',casnCaseID,defnDefendentID,case when isdate(FIELD11)=1 then FIELD11 else null end,368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.AUXUDFDF
left join WilliamPagerSaga.dbo.MATTER on MATTERID=REFERID
left join sma_TRN_CaseS on cassCaseNumber=MATTERNUMBER
left join sma_MST_UDFDefinition on udfnRelatedPK=casnOrgCaseTypeID
left join sma_TRN_Defendants on defnCaseID=casnCaseID and defbIsPrimary=1
where udfsUDFName=(select text from  WilliamPagerSaga.dbo.DESCTRL a
left join WilliamPagerSaga.dbo.DESFORM b on a.FORMID=b.FORMID
where b.DESCRIPTION like 'Defendant%' and CTRLTYPE in (101,202) and CTRLNUM=8) and ISNULL(FIELD11,'')<>''
Union
select udfnUDFID,'Defendant','C',casnCaseID,defnDefendentID,case when isdate(FIELD12)=1 then FIELD12 else null end,368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.AUXUDFDF
left join WilliamPagerSaga.dbo.MATTER on MATTERID=REFERID
left join sma_TRN_CaseS on cassCaseNumber=MATTERNUMBER
left join sma_MST_UDFDefinition on udfnRelatedPK=casnOrgCaseTypeID
left join sma_TRN_Defendants on defnCaseID=casnCaseID and defbIsPrimary=1
where udfsUDFName=(select text from  WilliamPagerSaga.dbo.DESCTRL a
left join WilliamPagerSaga.dbo.DESFORM b on a.FORMID=b.FORMID
where b.DESCRIPTION like 'Defendant%' and CTRLTYPE in (101,202) and CTRLNUM=9) and ISNULL(FIELD12,'')<>''
Union
select udfnUDFID,'Defendant','C',casnCaseID,defnDefendentID,case when isdate(FIELD13)=1 then FIELD13 else null end,368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.AUXUDFDF
left join WilliamPagerSaga.dbo.MATTER on MATTERID=REFERID
left join sma_TRN_CaseS on cassCaseNumber=MATTERNUMBER
left join sma_MST_UDFDefinition on udfnRelatedPK=casnOrgCaseTypeID
left join sma_TRN_Defendants on defnCaseID=casnCaseID and defbIsPrimary=1
where udfsUDFName=(select text from  WilliamPagerSaga.dbo.DESCTRL a
left join WilliamPagerSaga.dbo.DESFORM b on a.FORMID=b.FORMID
where b.DESCRIPTION like 'Defendant%' and CTRLTYPE in (101,202) and CTRLNUM=10) and ISNULL(FIELD13,'')<>''
Union
select udfnUDFID,'Defendant','C',casnCaseID,defnDefendentID,case when isdate(FIELD14)=1 then FIELD14 else null end,368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.AUXUDFDF
left join WilliamPagerSaga.dbo.MATTER on MATTERID=REFERID
left join sma_TRN_CaseS on cassCaseNumber=MATTERNUMBER
left join sma_MST_UDFDefinition on udfnRelatedPK=casnOrgCaseTypeID
left join sma_TRN_Defendants on defnCaseID=casnCaseID and defbIsPrimary=1
where udfsUDFName=(select text from  WilliamPagerSaga.dbo.DESCTRL a
left join WilliamPagerSaga.dbo.DESFORM b on a.FORMID=b.FORMID
where b.DESCRIPTION like 'Defendant%' and CTRLTYPE in (101,202) and CTRLNUM=11) and ISNULL(FIELD14,'')<>''

INSERT INTO [sma_TRN_UDFValues]
([udvnUDFID],[udvsScreenName],[udvsUDFCtg],[udvnRelatedID],[udvnSubRelatedID],[udvsUDFValue],[udvnRecUserID],[udvdDtCreated],[udvnModifyUserID],[udvdDtModified],[udvnLevelNo])
select udfnUDFID,'Plaintiff','C',casnCaseID,plnnplaintiffid,FIELD1,368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.AUXUDFPL
left join WilliamPagerSaga.dbo.MATTER on MATTERID=REFERID
left join sma_TRN_CaseS on cassCaseNumber=MATTERNUMBER
left join sma_MST_UDFDefinition on udfnRelatedPK=casnOrgCaseTypeID
left join sma_TRN_Plaintiff on plnnCaseID=casnCaseID and plnbIsPrimary=1
where udfsUDFName=(select text from  WilliamPagerSaga.dbo.DESCTRL a
left join WilliamPagerSaga.dbo.DESFORM b on a.FORMID=b.FORMID
where b.DESCRIPTION like 'Plaintiff%' and CTRLTYPE in (101,202) and CTRLNUM=2) and ISNULL(FIELD1,'')<>''
Union
select udfnUDFID,'Plaintiff','C',casnCaseID,plnnPlaintiffID,FIELD2,368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.AUXUDFPL
left join WilliamPagerSaga.dbo.MATTER on MATTERID=REFERID
left join sma_TRN_CaseS on cassCaseNumber=MATTERNUMBER
left join sma_MST_UDFDefinition on udfnRelatedPK=casnOrgCaseTypeID
left join sma_TRN_Plaintiff on plnnCaseID=casnCaseID and plnbIsPrimary=1
where udfsUDFName=(select text from  WilliamPagerSaga.dbo.DESCTRL a
left join WilliamPagerSaga.dbo.DESFORM b on a.FORMID=b.FORMID
where b.DESCRIPTION like 'Plaintiff%' and CTRLTYPE in (101,202) and CTRLNUM=3) and ISNULL(FIELD2,'')<>''
Union
select udfnUDFID,'Plaintiff','C',casnCaseID,plnnPlaintiffID,FIELD3,368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.AUXUDFPL
left join WilliamPagerSaga.dbo.MATTER on MATTERID=REFERID
left join sma_TRN_CaseS on cassCaseNumber=MATTERNUMBER
left join sma_MST_UDFDefinition on udfnRelatedPK=casnOrgCaseTypeID
left join sma_TRN_Plaintiff on plnnCaseID=casnCaseID and plnbIsPrimary=1
where udfsUDFName=(select text from  WilliamPagerSaga.dbo.DESCTRL a
left join WilliamPagerSaga.dbo.DESFORM b on a.FORMID=b.FORMID
where b.DESCRIPTION like 'Plaintiff%' and CTRLTYPE in (101,202) and CTRLNUM=4) and ISNULL(FIELD3,'')<>''
Union
select udfnUDFID,'Plaintiff','C',casnCaseID,plnnPlaintiffID,FIELD4,368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.AUXUDFPL
left join WilliamPagerSaga.dbo.MATTER on MATTERID=REFERID
left join sma_TRN_CaseS on cassCaseNumber=MATTERNUMBER
left join sma_MST_UDFDefinition on udfnRelatedPK=casnOrgCaseTypeID
left join sma_TRN_Plaintiff on plnnCaseID=casnCaseID and plnbIsPrimary=1
where udfsUDFName=(select text from  WilliamPagerSaga.dbo.DESCTRL a
left join WilliamPagerSaga.dbo.DESFORM b on a.FORMID=b.FORMID
where b.DESCRIPTION like 'Plaintiff%' and CTRLTYPE in (101,202) and CTRLNUM=5) and ISNULL(FIELD4,'')<>''
Union
select udfnUDFID,'Plaintiff','C',casnCaseID,plnnPlaintiffID,FIELD5,368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.AUXUDFPL
left join WilliamPagerSaga.dbo.MATTER on MATTERID=REFERID
left join sma_TRN_CaseS on cassCaseNumber=MATTERNUMBER
left join sma_MST_UDFDefinition on udfnRelatedPK=casnOrgCaseTypeID
left join sma_TRN_Plaintiff on plnnCaseID=casnCaseID and plnbIsPrimary=1
where udfsUDFName=(select text from  WilliamPagerSaga.dbo.DESCTRL a
left join WilliamPagerSaga.dbo.DESFORM b on a.FORMID=b.FORMID
where b.DESCRIPTION like 'Plaintiff%' and CTRLTYPE in (101,202) and CTRLNUM=6) and ISNULL(FIELD5,'')<>''

INSERT INTO [sma_TRN_UDFValues]
([udvnUDFID],[udvsScreenName],[udvsUDFCtg],[udvnRelatedID],[udvnSubRelatedID],[udvsUDFValue],[udvnRecUserID],[udvdDtCreated],[udvnModifyUserID],[udvdDtModified],[udvnLevelNo])
select udfnUDFID,'Plaintiff','C',casnCaseID,plnnPlaintiffID,FIELD6,368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.AUXUDFPL
left join WilliamPagerSaga.dbo.MATTER on MATTERID=REFERID
left join sma_TRN_CaseS on cassCaseNumber=MATTERNUMBER
left join sma_MST_UDFDefinition on udfnRelatedPK=casnOrgCaseTypeID
left join sma_TRN_Plaintiff on plnnCaseID=casnCaseID and plnbIsPrimary=1
where udfsUDFName=(select text from  WilliamPagerSaga.dbo.DESCTRL a
left join WilliamPagerSaga.dbo.DESFORM b on a.FORMID=b.FORMID
where b.DESCRIPTION like 'Plaintiff%' and CTRLTYPE in (101,202) and CTRLNUM=12) and FIELD6 is not null and FIELD6<>0
Union
select udfnUDFID,'Plaintiff','C',casnCaseID,plnnPlaintiffID,FIELD7,368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.AUXUDFPL
left join WilliamPagerSaga.dbo.MATTER on MATTERID=REFERID
left join sma_TRN_CaseS on cassCaseNumber=MATTERNUMBER
left join sma_MST_UDFDefinition on udfnRelatedPK=casnOrgCaseTypeID
left join sma_TRN_Plaintiff on plnnCaseID=casnCaseID and plnbIsPrimary=1
where udfsUDFName=(select text from  WilliamPagerSaga.dbo.DESCTRL a
left join WilliamPagerSaga.dbo.DESFORM b on a.FORMID=b.FORMID
where b.DESCRIPTION like 'Plaintiff%' and CTRLTYPE in (101,202) and CTRLNUM=13) and  FIELD7 is not null and FIELD7<>'0.00'
Union
select udfnUDFID,'Plaintiff','C',casnCaseID,plnnPlaintiffID,FIELD8,368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.AUXUDFPL
left join WilliamPagerSaga.dbo.MATTER on MATTERID=REFERID
left join sma_TRN_CaseS on cassCaseNumber=MATTERNUMBER
left join sma_MST_UDFDefinition on udfnRelatedPK=casnOrgCaseTypeID
left join sma_TRN_Plaintiff on plnnCaseID=casnCaseID and plnbIsPrimary=1
where udfsUDFName=(select text from  WilliamPagerSaga.dbo.DESCTRL a
left join WilliamPagerSaga.dbo.DESFORM b on a.FORMID=b.FORMID
where b.DESCRIPTION like 'Plaintiff%' and CTRLTYPE in (101,202) and CTRLNUM=14) and FIELD8 is not null and FIELD8<>'0.00'

INSERT INTO [sma_TRN_UDFValues]
([udvnUDFID],[udvsScreenName],[udvsUDFCtg],[udvnRelatedID],[udvnSubRelatedID],[udvsUDFValue],[udvnRecUserID],[udvdDtCreated],[udvnModifyUserID],[udvdDtModified],[udvnLevelNo])

select udfnUDFID,'Plaintiff','C',casnCaseID,plnnPlaintiffID,case when FIELD9='T' then 'Yes' else FIELD9 end,368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.AUXUDFPL
left join WilliamPagerSaga.dbo.MATTER on MATTERID=REFERID
left join sma_TRN_CaseS on cassCaseNumber=MATTERNUMBER
left join sma_MST_UDFDefinition on udfnRelatedPK=casnOrgCaseTypeID
left join sma_TRN_Plaintiff on plnnCaseID=casnCaseID and plnbIsPrimary=1
where udfsUDFName=(select text from  WilliamPagerSaga.dbo.DESCTRL a
left join WilliamPagerSaga.dbo.DESFORM b on a.FORMID=b.FORMID
where b.DESCRIPTION like 'Plaintiff%' and CTRLTYPE in (101,202) and CTRLNUM=28) and ISNULL(FIELD9,'')<>'' and FIELD9<>'F'
Union
select udfnUDFID,'Plaintiff','C',casnCaseID,plnnPlaintiffID,case when FIELD10='T' then 'Yes' else FIELD10 end,368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.AUXUDFPL
left join WilliamPagerSaga.dbo.MATTER on MATTERID=REFERID
left join sma_TRN_CaseS on cassCaseNumber=MATTERNUMBER
left join sma_MST_UDFDefinition on udfnRelatedPK=casnOrgCaseTypeID
left join sma_TRN_Plaintiff on plnnCaseID=casnCaseID and plnbIsPrimary=1
where udfsUDFName=(select text from  WilliamPagerSaga.dbo.DESCTRL a
left join WilliamPagerSaga.dbo.DESFORM b on a.FORMID=b.FORMID
where b.DESCRIPTION like 'Plaintiff%' and CTRLTYPE in (101,202) and CTRLNUM=29) and FIELD10 is not null and FIELD10<>'F'

INSERT INTO [sma_TRN_UDFValues]
([udvnUDFID],[udvsScreenName],[udvsUDFCtg],[udvnRelatedID],[udvnSubRelatedID],[udvsUDFValue],[udvnRecUserID],[udvdDtCreated],[udvnModifyUserID],[udvdDtModified],[udvnLevelNo])
select udfnUDFID,'Plaintiff','C',casnCaseID,plnnPlaintiffID,case when isdate(FIELD11)=1 then FIELD11 else null end,368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.AUXUDFPL
left join WilliamPagerSaga.dbo.MATTER on MATTERID=REFERID
left join sma_TRN_CaseS on cassCaseNumber=MATTERNUMBER
left join sma_MST_UDFDefinition on udfnRelatedPK=casnOrgCaseTypeID
left join sma_TRN_Plaintiff on plnnCaseID=casnCaseID and plnbIsPrimary=1
where udfsUDFName=(select text from  WilliamPagerSaga.dbo.DESCTRL a
left join WilliamPagerSaga.dbo.DESFORM b on a.FORMID=b.FORMID
where b.DESCRIPTION like 'Plaintiff%' and CTRLTYPE in (101,202) and CTRLNUM=8) and ISNULL(FIELD11,'')<>''
Union
select udfnUDFID,'Plaintiff','C',casnCaseID,plnnPlaintiffID,case when isdate(FIELD12)=1 then FIELD12 else null end,368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.AUXUDFPL
left join WilliamPagerSaga.dbo.MATTER on MATTERID=REFERID
left join sma_TRN_CaseS on cassCaseNumber=MATTERNUMBER
left join sma_MST_UDFDefinition on udfnRelatedPK=casnOrgCaseTypeID
left join sma_TRN_Plaintiff on plnnCaseID=casnCaseID and plnbIsPrimary=1
where udfsUDFName=(select text from  WilliamPagerSaga.dbo.DESCTRL a
left join WilliamPagerSaga.dbo.DESFORM b on a.FORMID=b.FORMID
where b.DESCRIPTION like 'Plaintiff%' and CTRLTYPE in (101,202) and CTRLNUM=9) and ISNULL(FIELD12,'')<>''
Union
select udfnUDFID,'Plaintiff','C',casnCaseID,plnnPlaintiffID,case when isdate(FIELD13)=1 then FIELD13 else null end,368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.AUXUDFPL
left join WilliamPagerSaga.dbo.MATTER on MATTERID=REFERID
left join sma_TRN_CaseS on cassCaseNumber=MATTERNUMBER
left join sma_MST_UDFDefinition on udfnRelatedPK=casnOrgCaseTypeID
left join sma_TRN_Plaintiff on plnnCaseID=casnCaseID and plnbIsPrimary=1
where udfsUDFName=(select text from  WilliamPagerSaga.dbo.DESCTRL a
left join WilliamPagerSaga.dbo.DESFORM b on a.FORMID=b.FORMID
where b.DESCRIPTION like 'Plaintiff%' and CTRLTYPE in (101,202) and CTRLNUM=10) and ISNULL(FIELD13,'')<>''
Union
select udfnUDFID,'Plaintiff','C',casnCaseID,plnnPlaintiffID,case when isdate(FIELD14)=1 then FIELD14 else null end,368,GETDATE(),null,null,''
from WilliamPagerSaga.dbo.AUXUDFPL
left join WilliamPagerSaga.dbo.MATTER on MATTERID=REFERID
left join sma_TRN_CaseS on cassCaseNumber=MATTERNUMBER
left join sma_MST_UDFDefinition on udfnRelatedPK=casnOrgCaseTypeID
left join sma_TRN_Plaintiff on plnnCaseID=casnCaseID and plnbIsPrimary=1
where udfsUDFName=(select text from  WilliamPagerSaga.dbo.DESCTRL a
left join WilliamPagerSaga.dbo.DESFORM b on a.FORMID=b.FORMID
where b.DESCRIPTION like 'Plaintiff%' and CTRLTYPE in (101,202) and CTRLNUM=11) and ISNULL(FIELD14,'')<>''

--select notes,* from ASSIGN a left join note n on n.NOTEID=a.NOTEID where  ROLEDETAILS like '145-%'

INSERT INTO [sma_MST_UDFDefinition]
([udfsUDFCtg],[udfnRelatedPK],[udfsUDFName],[udfsScreenName],[udfsType],[udfsLength],[udfsFormat],[udfsTableName],[udfsNewValues],[udfsDefaultValue]
,[udfnSortOrder],[udfbIsActive],[udfnRecUserID],[udfnDtCreated],[udfnModifyUserID],[udfnDtModified],[udfnLevelNo],[udfbIsSystem])
Select 'C',cstnCaseTypeID,'Role  Details','Plaintiff', 'Text' ,5000,NULL,NULL,'',NULL,
2001,1,368,GETDATE(),NULL,NULL,1,NULL 
from WilliamPagerSaga.dbo.LAWTYPE
Left Join sma_MST_CaseType on cstsType=DESCRIPTION
union
Select 'C',cstnCaseTypeID,'Plaintiff Comments','Plaintiff', 'Text' ,50000,NULL,NULL,'',NULL,
2002,1,368,GETDATE(),NULL,NULL,1,NULL 
from WilliamPagerSaga.dbo.LAWTYPE
Left Join sma_MST_CaseType on cstsType=DESCRIPTION



INSERT INTO [sma_TRN_UDFValues]
([udvnUDFID],[udvsScreenName],[udvsUDFCtg],[udvnRelatedID],[udvnSubRelatedID],[udvsUDFValue],[udvnRecUserID],[udvdDtCreated],[udvnModifyUserID],[udvdDtModified],[udvnLevelNo])
select udfnUDFID,'Plaintiff','C',casnCaseID,case when p1.plnnPlaintiffID is not null then p1.plnnPlaintiffID when p2.plnnPlaintiffID is not null then p2.plnnPlaintiffID end,ROLEDETAILS,368,GETDATE(),null,null,''
From WilliamPagerSaga.dbo.ASSIGN a 
left join WilliamPagerSaga.dbo.matter m on a.MATTERID=m.MATTERID
left join sma_trn_cases on cassCaseNumber=MATTERNUMBER
outer apply(select top 1 plnnplaintiffid from sma_TRN_Plaintiff left join sma_MST_IndvContacts on plnnContactID=cinnContactID and plnnContactCtg=1  where plnnCaseid=casnCaseID and cinsGrade=a.ENTITYID and plnnContactCtg=1 )p1
outer apply(select top 1 plnnplaintiffid from sma_TRN_Plaintiff left join sma_MST_orgContacts on plnnContactID=connContactID and plnnContactCtg=2  where plnnCaseid=casnCaseID and connLevelNo=a.ENTITYID and plnnContactCtg=1 )p2
left join sma_MST_UDFDefinition on udfnRelatedPK=casnOrgCaseTypeID and udfsUDFName='Role  Details'
where a.partytype=1 and isnull(ROLEDETAILS,'')<>''


INSERT INTO [sma_TRN_UDFValues]
([udvnUDFID],[udvsScreenName],[udvsUDFCtg],[udvnRelatedID],[udvnSubRelatedID],[udvsUDFValue],[udvnRecUserID],[udvdDtCreated],[udvnModifyUserID],[udvdDtModified],[udvnLevelNo])
select udfnUDFID,'Plaintiff','C',casnCaseID,case when p1.plnnPlaintiffID is not null then p1.plnnPlaintiffID when p2.plnnPlaintiffID is not null then p2.plnnPlaintiffID end,convert(varchar(max),ltrim(replace(
       dbo.RegExReplace(notes,'({\\)(.+?)(})|(\\)(.+?)(\b)','')
      ,'}','')      
      )) ,368,GETDATE(),null,null,''
From WilliamPagerSaga.dbo.ASSIGN a 
left join WilliamPagerSaga.dbo.matter m on a.MATTERID=m.MATTERID
left join WilliamPagerSaga.dbo.note n on n.NOTEID=a.NOTEID 
left join sma_trn_cases on cassCaseNumber=MATTERNUMBER
outer apply(select top 1 plnnplaintiffid from sma_TRN_Plaintiff left join sma_MST_IndvContacts on plnnContactID=cinnContactID and plnnContactCtg=1  where plnnCaseid=casnCaseID and cinsGrade=a.ENTITYID and plnnContactCtg=1 )p1
outer apply(select top 1 plnnplaintiffid from sma_TRN_Plaintiff left join sma_MST_orgContacts on plnnContactID=connContactID and plnnContactCtg=2  where plnnCaseid=casnCaseID and connLevelNo=a.ENTITYID and plnnContactCtg=1 )p2
left join sma_MST_UDFDefinition on udfnRelatedPK=casnOrgCaseTypeID and udfsUDFName='Plaintiff Comments'
where a.partytype=1 and isnull(convert(varchar(max),ltrim(replace(
       dbo.RegExReplace(notes,'({\\)(.+?)(})|(\\)(.+?)(\b)','')
      ,'}','')
     
      )) ,'')<>''

--select * from  WilliamPagerSaga.dbo.DESCTRL a
--left join WilliamPagerSaga.dbo.DESFORM b on a.FORMID=b.FORMID
--where b.DESCRIPTION like 'plain%' and CTRLTYPE in (101,202)
go

INSERT INTO [sma_MST_UDFDefinition]
([udfsUDFCtg],[udfnRelatedPK],[udfsUDFName],[udfsScreenName],[udfsType],[udfsLength],[udfsFormat],[udfsTableName],[udfsNewValues],[udfsDefaultValue]
,[udfnSortOrder],[udfbIsActive],[udfnRecUserID],[udfnDtCreated],[udfnModifyUserID],[udfnDtModified],[udfnLevelNo],[udfbIsSystem])
Select distinct 'C',cstnCaseTypeID,'In hospital','Plaintiff', 'Text',1000,NULL,NULL,null,NULL,
2001,1,368,GETDATE(),NULL,NULL,1,NULL 
from WilliamPagerSaga.dbo.LAWTYPE
Left Join sma_MST_CaseType on cstsType=DESCRIPTION
union
Select distinct 'C',cstnCaseTypeID,'Confined to home','Plaintiff', 'Text',1000,NULL,NULL,null,NULL,
2002,1,368,GETDATE(),NULL,NULL,1,NULL 
from WilliamPagerSaga.dbo.LAWTYPE
Left Join sma_MST_CaseType on cstsType=DESCRIPTION
union
Select distinct 'C',cstnCaseTypeID,'Confined to bed','Plaintiff', 'Text',1000,NULL,NULL,null,NULL,
2003,1,368,GETDATE(),NULL,NULL,1,NULL 
from WilliamPagerSaga.dbo.LAWTYPE
Left Join sma_MST_CaseType on cstsType=DESCRIPTION
union
Select distinct 'C',cstnCaseTypeID,'Incapacitated','Plaintiff', 'Text',1000,NULL,NULL,null,NULL,
2004,1,368,GETDATE(),NULL,NULL,1,NULL 
from WilliamPagerSaga.dbo.LAWTYPE
Left Join sma_MST_CaseType on cstsType=DESCRIPTION

go
INSERT INTO [sma_TRN_UDFValues]
([udvnUDFID],[udvsScreenName],[udvsUDFCtg],[udvnRelatedID],[udvnSubRelatedID],[udvsUDFValue],[udvnRecUserID],[udvdDtCreated],[udvnModifyUserID],[udvdDtModified],[udvnLevelNo])
select distinct udfnUDFID,'Plaintiff','C',casnCaseID,plnnPlaintiffID,INHOSPITAL,368,GETDATE(),null,null,''
from [WilliamPagerSaga].dbo.LW_injury li
left join  [WilliamPagerSaga].dbo.assign a on li.assignid=a.assignid 
left join [WilliamPagerSaga].dbo.matter m on a.matterid=m.matterid
left join [WilliamPagerSaga].dbo.entities e on a.entityid=e.entityid
left join sma_MST_IndvContacts l on l.cinsGrade=e.ENTITYID
left join sma_MST_OrgContacts k on k.connLevelNo=e.ENTITYID
left join sma_trn_cases on cassCaseNumber=m.MATTERNUMBER
left join sma_TRN_Plaintiff on  ((plnnContactID=k.conncontactid and plnnContactCtg=2) or (plnnContactID=l.cinncontactid and plnnContactCtg=1)) and plnnCaseID=casnCaseID
left join sma_MST_UDFDefinition on udfnRelatedPK=casnOrgCaseTypeID
where casnCaseID is not null and plnnPlaintiffID is not null  and udfsUDFName='In hospital' and ISNULL(INHOSPITAL,'')<>'' 
union
select distinct udfnUDFID,'Plaintiff','C',casnCaseID,plnnPlaintiffID,CONFINEDHOME,368,GETDATE(),null,null,''
from [WilliamPagerSaga].dbo.LW_injury li
left join  [WilliamPagerSaga].dbo.assign a on li.assignid=a.assignid 
left join [WilliamPagerSaga].dbo.matter m on a.matterid=m.matterid
left join [WilliamPagerSaga].dbo.entities e on a.entityid=e.entityid
left join sma_MST_IndvContacts l on l.cinsGrade=e.ENTITYID
left join sma_MST_OrgContacts k on k.connLevelNo=e.ENTITYID
left join sma_trn_cases on cassCaseNumber=m.MATTERNUMBER
left join sma_TRN_Plaintiff on  ((plnnContactID=k.conncontactid and plnnContactCtg=2) or (plnnContactID=l.cinncontactid and plnnContactCtg=1)) and plnnCaseID=casnCaseID
left join sma_MST_UDFDefinition on udfnRelatedPK=casnOrgCaseTypeID
where casnCaseID is not null and plnnPlaintiffID is not null  and udfsUDFName='Confined to home' and ISNULL(CONFINEDHOME,'')<>'' 
union
select distinct udfnUDFID,'Plaintiff','C',casnCaseID,plnnPlaintiffID,CONFINEDBED,368,GETDATE(),null,null,''
from [WilliamPagerSaga].dbo.LW_injury li
left join  [WilliamPagerSaga].dbo.assign a on li.assignid=a.assignid 
left join [WilliamPagerSaga].dbo.matter m on a.matterid=m.matterid
left join [WilliamPagerSaga].dbo.entities e on a.entityid=e.entityid
left join sma_MST_IndvContacts l on l.cinsGrade=e.ENTITYID
left join sma_MST_OrgContacts k on k.connLevelNo=e.ENTITYID
left join sma_trn_cases on cassCaseNumber=m.MATTERNUMBER
left join sma_TRN_Plaintiff on  ((plnnContactID=k.conncontactid and plnnContactCtg=2) or (plnnContactID=l.cinncontactid and plnnContactCtg=1)) and plnnCaseID=casnCaseID
left join sma_MST_UDFDefinition on udfnRelatedPK=casnOrgCaseTypeID
where casnCaseID is not null and plnnPlaintiffID is not null  and udfsUDFName='Confined to bed' and ISNULL(CONFINEDBED,'')<>'' 
union
select distinct udfnUDFID,'Plaintiff','C',casnCaseID,plnnPlaintiffID,INCAPACITATED,368,GETDATE(),null,null,''
from [WilliamPagerSaga].dbo.LW_injury li
left join  [WilliamPagerSaga].dbo.assign a on li.assignid=a.assignid 
left join [WilliamPagerSaga].dbo.matter m on a.matterid=m.matterid
left join [WilliamPagerSaga].dbo.entities e on a.entityid=e.entityid
left join sma_MST_IndvContacts l on l.cinsGrade=e.ENTITYID
left join sma_MST_OrgContacts k on k.connLevelNo=e.ENTITYID
left join sma_trn_cases on cassCaseNumber=m.MATTERNUMBER
left join sma_TRN_Plaintiff on  ((plnnContactID=k.conncontactid and plnnContactCtg=2) or (plnnContactID=l.cinncontactid and plnnContactCtg=1)) and plnnCaseID=casnCaseID
left join sma_MST_UDFDefinition on udfnRelatedPK=casnOrgCaseTypeID
where casnCaseID is not null and plnnPlaintiffID is not null  and udfsUDFName='Incapacitated' and ISNULL(INCAPACITATED,'')<>'' 
