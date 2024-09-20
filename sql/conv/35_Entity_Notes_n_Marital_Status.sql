Insert Into sma_MST_Languages(lngsLanguageCode,lngsLanguageName,lngnRecUserID,lngdDtCreated)
Select UPPER(SUBSTRING(DESCRIPTION,0,5)),DESCRIPTION,368,GETDATE()
From WilliamPagerSaga.dbo.[LW_A_LANGUAGE]
where LTRIM(RTRIM(DESCRIPTION))
not in (select LTRIM(RTRIM(lngsLanguageName)) from sma_MST_Languages)

Alter table sma_mst_indvcontacts
Alter column cinsComments varchar(4000)

Alter table sma_mst_indvcontacts disable trigger all
Update a
set cinsComments=ltrim(replace(
       dbo.RegExReplace(convert(varchar(4000),NOTES),'({\\)(.+?)(})|(\\)(.+?)(\b)','')
      ,'}','')     
      )
from sma_mst_indvcontacts a
left join WilliamPagerSaga.dbo.ENTITIES e on cinsGrade=ENTITYID
left join WilliamPagerSaga.dbo.NOTE n on n.NOTEID=e.NOTEID
where e.NOTEID is not null

Update a
set cinnMaritalStatusID=case e.MARITALSTATUS when 0 then 1 when 1 then 2 when 3 then 6 when 4 then 4 when 5 then 5 end
from sma_mst_indvcontacts a
left join WilliamPagerSaga.dbo.ENTITIES e on cinsGrade=ENTITYID
where e.MARITALSTATUS is not null

update a
set cinsPrimaryLanguage=lngsLanguageName
from sma_mst_indvcontacts a
left join WilliamPagerSaga.dbo.ENTITIES e on cinsGrade=ENTITYID
left join WilliamPagerSaga.dbo.[LW_A_LANGUAGE] l on l.LANGUAGEID=e.LANGUAGEID
left join sma_MST_Languages on LTRIM(RTRIM(lngsLanguageName))=LTRIM(RTRIM(l.DESCRIPTION))
where e.LANGUAGEID is not null

Alter table sma_mst_indvcontacts enable trigger all


Alter table sma_mst_orgcontacts
Alter column consComments varchar(4000)

Alter table sma_mst_orgcontacts disable trigger all
Update a
set consComments=ltrim(replace(
       dbo.RegExReplace(convert(varchar(4000),NOTES),'({\\)(.+?)(})|(\\)(.+?)(\b)','')
      ,'}','')     
      )
from sma_mst_orgcontacts a
left join WilliamPagerSaga.dbo.ENTITIES e on connLevelNo=ENTITYID
left join WilliamPagerSaga.dbo.NOTE n on n.NOTEID=e.NOTEID
where e.NOTEID is not null
Alter table sma_mst_orgcontacts enable trigger all


	

