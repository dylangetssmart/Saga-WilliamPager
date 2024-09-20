alter table sma_mst_indvcontacts disable trigger all
--INSERT INTO [sma_MST_OriginalContactTypes]
--([octsCode],[octnContactCtgID],[octsDscrptn],[octnRecUserID],[octdDtCreated],[octnModifyUserID],[octdDtModified],[octnLevelNo])
-- Select distinct UPPER(SUBSTRING(et.DESCRIPTION,0,5)),1,DESCRIPTION,368,GETDATE(),null,null,''
-- FROM [WilliamPagerSaga].[dbo].[ENTITIES] e
--left join [WilliamPagerSaga].[dbo].enttype et on e.ENTITYTYPEID=et.ENTITYTYPEID
--where  ISPERSON='t' and FIRST_DBA is not null
--and et.DESCRIPTION not in (select [octsDscrptn] from [sma_MST_OriginalContactTypes] where [octnContactCtgID]=1)
--and et.DESCRIPTION not like '%judge%' and et.DESCRIPTION not like '%clerk%' and et.DESCRIPTION not like '%doctor%' and et.DESCRIPTION not like '%police%' and et.DESCRIPTION not like '%expert%' and et.DESCRIPTION not like '%adjuster%' and et.DESCRIPTION not like '%attorney%'  and et.DESCRIPTION not like '%investigator%'
------------------------------Insert Individual Contact Started-------------------------------------------------------------------------    
INSERT INTO [sma_MST_IndvContacts]
([cinbPrimary]
,[cinnContactTypeID]
,[cinnContactSubCtgID]
,[cinsPrefix]
,[cinsFirstName]
,[cinsMiddleName]
,[cinsLastName]
,[cinsSuffix]
,[cinsNickName]
,[cinbStatus]
,[cinsSSNNo]
,[cindBirthDate]
,[cinsComments]
,[cinnContactCtg]
,[cinnRefByCtgID]
,[cinnReferredBy]
,[cindDateOfDeath]
,[cinsCVLink]
,[cinnMaritalStatusID]
,[cinnGender]
,[cinsBirthPlace]
,[cinnCountyID]
,[cinsCountyOfResidence]
,[cinbFlagForPhoto]
,[cinsPrimaryContactNo]
,[cinsHomePhone]
,[cinsWorkPhone]
,[cinsMobile]
,[cinbPreventMailing]
,[cinnRecUserID]
,[cindDtCreated]
,[cinnModifyUserID]
,[cindDtModified]
,[cinnLevelNo]
,[cinsPrimaryLanguage]
,[cinsOtherLanguage]
,[cinbDeathFlag]
,[cinsCitizenship]
,[cinsHeight]
,[cinnWeight]
,[cinsReligion]
,[cindMarriageDate]
,[cinsMarriageLoc]
,[cinsDeathPlace]
,[cinsMaidenName]
,[cinsOccupation]
,[saga]
,[cinsSpouse]
,[cinsGrade])
   
SELECT distinct 
	1,
	case 
		when et.DESCRIPTION like '%judge%' then (select octnOrigContactTypeID from sma_MST_OriginalContactTypes where octnContactCtgID=1 and octsDscrptn='Judge') 
		when et.DESCRIPTION like '%clerk%' then (select octnOrigContactTypeID from sma_MST_OriginalContactTypes where octnContactCtgID=1 and octsDscrptn='Courtroom Clerk') 
		when et.DESCRIPTION like '%doctor%' then (select octnOrigContactTypeID from sma_MST_OriginalContactTypes where octnContactCtgID=1 and octsDscrptn='Doctor') 
		when et.DESCRIPTION like '%police%' then (select octnOrigContactTypeID from sma_MST_OriginalContactTypes where octnContactCtgID=1 and octsDscrptn='Police Officer') 
		when et.DESCRIPTION like '%expert%' then (select octnOrigContactTypeID from sma_MST_OriginalContactTypes where octnContactCtgID=1 and octsDscrptn='Expert') 
		when et.DESCRIPTION like '%adjuster%' then (select octnOrigContactTypeID from sma_MST_OriginalContactTypes where octnContactCtgID=1 and octsDscrptn='Adjuster') 
		when  et.DESCRIPTION like '%attorney%'  then (select octnOrigContactTypeID from sma_MST_OriginalContactTypes where octnContactCtgID=1 and octsDscrptn='Attorney') 
		when  et.DESCRIPTION like '%investigator%' then (select octnOrigContactTypeID from sma_MST_OriginalContactTypes where octnContactCtgID=1 and octsDscrptn='Investigator') 
		else (select octnOrigContactTypeID from sma_MST_OriginalContactTypes where octnContactCtgID=1 and octsDscrptn='General') 
	end,
	null,
substring(TITLE,0,19),substring(FIRST_DBA,0,29),substring(MIDDLE_CONTACT,0,29),substring(LAST_COMPANY,0,39),SUBSTRING(PROFEXT,0,10),substring(ALIASNAMES,0,15), 1,substring(ssn,0,19),
DATEOFB,substring(ENTITYNAME,0,499),1,'','',DOD,'','',case gender when 'M' then 1 when 'F' then 2 end,'',1,1,null,substring(phone,0,19),'','',substring(MOBILEPHONE,0,19),0,
case isnull(u1.usrnuserid,'') when '' then 368 else u1.usrnuserid end,case datecreated when null then GETDATE() else datecreated end,u2.usrnuserid,daterevised,0,'','','','',HEIGHTFEET+HEIGHTINCH,WEIGHT,'',Null,'','','','','','',
ENTITYID
FROM [WilliamPagerSaga].[dbo].[ENTITIES]  e
left join [WilliamPagerSaga].[dbo].enttype et on e.ENTITYTYPEID=et.ENTITYTYPEID
--left join [sma_MST_OriginalContactTypes] on octsDscrptn=et.DESCRIPTION
left join sma_MST_IndvContacts a on a.cinsGrade=e.CREATORID
left join sma_mst_users u1 on u1.usrnContactID=a.cinnContactID
left join sma_MST_IndvContacts b on b.cinsGrade=e.REVISORID
left join sma_mst_users u2 on u2.usrnContactID=b.cinnContactID
where ENTITYID not in (select isnull(cinsgrade,0) from sma_mst_indvcontacts) and ISPERSON='t' and FIRST_DBA is not null
------------------------------Insert Individual Contact Finished-------------------------------------------------------------------------    

alter table sma_mst_indvcontacts enable trigger all



