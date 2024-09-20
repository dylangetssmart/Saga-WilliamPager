alter table [sma_MST_OrgContacts] disable trigger all
------------------------------Insert Organization Contact Started-------------------------------------------------------------------------  
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
Select 1,case when et.DESCRIPTION like '%hospital%' then 4 when et.DESCRIPTION like '%nursing%' then 5 when et.DESCRIPTION like '%doctor%' then 28  when  et.DESCRIPTION like '%care center%' then 6 when et.DESCRIPTION like '%police%' then 16 when  et.DESCRIPTION like '%insurance%' then 7 when et.DESCRIPTION like '%pharmacy%' then 26 when  et.DESCRIPTION like '%court%'  then 8 when  et.DESCRIPTION like '%law firm%' then 12 else 11 end
,'',LAST_COMPANY,1,'',FIRST_DBA+ISNULL(ALIASNAMES,''),2,null,null,'',phone,0,
case isnull(u1.usrnuserid,'') when '' then 368 else u1.usrnuserid end,case datecreated when null then GETDATE() else datecreated end,u2.usrnuserid,daterevised,
ENTITYID,substring(ENTITYNAME,0,100),''
FROM [WilliamPagerSaga].[dbo].[ENTITIES]  e
left join [WilliamPagerSaga].[dbo].enttype et on e.ENTITYTYPEID=et.ENTITYTYPEID
left join sma_MST_IndvContacts a on a.cinsGrade=e.CREATORID
left join sma_mst_users u1 on u1.usrnContactID=a.cinnContactID
left join sma_MST_IndvContacts b on b.cinsGrade=e.REVISORID
left join sma_mst_users u2 on u2.usrnContactID=b.cinnContactID
where e.ENTITYTYPEID not in (select isnull(cinsGrade,0) from sma_MST_IndvContacts) and ISPERSON<>'t' 
union
Select 1,case when et.DESCRIPTION like '%hospital%' then 4 when et.DESCRIPTION like '%nursing%' then 5 when et.DESCRIPTION like '%doctor%' then 28 when  et.DESCRIPTION like '%care center%' then 6 when et.DESCRIPTION like '%police%' then 16 when  et.DESCRIPTION like '%insurance%' then 7 when et.DESCRIPTION like '%pharmacy%' then 26 when  et.DESCRIPTION like '%court%'  then 8 when  et.DESCRIPTION like '%law firm%' then 12 else 11 end
,'',LAST_COMPANY,1,'',FIRST_DBA+ISNULL(ALIASNAMES,''),2,null,null,'',phone,0,
case isnull(u1.usrnuserid,'') when '' then 368 else u1.usrnuserid end,case datecreated when null then GETDATE() else datecreated end,u2.usrnuserid,daterevised,
ENTITYID,substring(ENTITYNAME,0,100),''
From WilliamPagerSaga.dbo.ENTITIES e
left join [WilliamPagerSaga].[dbo].enttype et on e.ENTITYTYPEID=et.ENTITYTYPEID
left join sma_MST_IndvContacts a on a.cinsGrade=e.CREATORID
left join sma_mst_users u1 on u1.usrnContactID=a.cinnContactID
left join sma_MST_IndvContacts b on b.cinsGrade=e.REVISORID
left join sma_mst_users u2 on u2.usrnContactID=b.cinnContactID
where e.ENTITYID in
(select entityid from WilliamPagerSaga.dbo.ENTITIES
except
(select connLevelNo from sma_mst_orgcontacts
union
select cinsgrade from sma_MST_IndvContacts))
alter table [sma_MST_OrgContacts] enable trigger all