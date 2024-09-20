
------------------------------Insert Email / Website Started-------------------------------------------------------------------------
alter table [sma_MST_EmailWebsite] Disable trigger all

INSERT INTO [sma_MST_EmailWebsite]
([cewnContactCtgID],[cewnContactID],[cewsEmailWebsiteFlag],[cewsEmailWebSite],[cewbDefault],[cewnRecUserID],[cewdDtCreated],[cewnModifyUserID],[cewdDtModified],[cewnLevelNo],[saga])
Select 1,c.cinnContactID,'E',EMAILADDRESS,1,
case isnull(u1.usrnuserid,'') when '' then 368 else u1.usrnuserid end,case datecreated when null then GETDATE() else datecreated end,u2.usrnuserid,daterevised,
null,null
FROM sma_MST_IndvContacts c
Left Join [WilliamPagerSaga].dbo.ENTITIES on LTRIM(rtrim(c.cinsGrade))=ENTITYID 
left join sma_MST_IndvContacts a on a.cinsGrade=CREATORID
left join sma_mst_users u1 on u1.usrnContactID=a.cinnContactID
left join sma_MST_IndvContacts b on b.cinsGrade=REVISORID
left join sma_mst_users u2 on u2.usrnContactID=b.cinnContactID
Where ISPERSON='t' and EMAILADDRESS<>'' and EMAILADDRESS  like '%@%' and c.cinncontactid is not null

INSERT INTO [sma_MST_EmailWebsite]
([cewnContactCtgID],[cewnContactID],[cewsEmailWebsiteFlag],[cewsEmailWebSite],[cewbDefault],[cewnRecUserID],[cewdDtCreated],[cewnModifyUserID],[cewdDtModified],[cewnLevelNo],[saga])
Select 1,c.cinnContactID,'E',WEBPAGE,1,
case isnull(u1.usrnuserid,'') when '' then 368 else u1.usrnuserid end,case datecreated when null then GETDATE() else datecreated end,u2.usrnuserid,daterevised,
null,null
FROM sma_MST_IndvContacts c
Left Join [WilliamPagerSaga].dbo.ENTITIES on LTRIM(rtrim(c.cinsGrade))=ENTITYID 
left join sma_MST_IndvContacts a on a.cinsGrade=CREATORID
left join sma_mst_users u1 on u1.usrnContactID=a.cinnContactID
left join sma_MST_IndvContacts b on b.cinsGrade=REVISORID
left join sma_mst_users u2 on u2.usrnContactID=b.cinnContactID
Where ISPERSON='t' and WEBPAGE<>'' and WEBPAGE  like '%@%' and c.cinncontactid is not null


INSERT INTO [sma_MST_EmailWebsite]
([cewnContactCtgID],[cewnContactID],[cewsEmailWebsiteFlag],[cewsEmailWebSite],[cewbDefault],[cewnRecUserID],[cewdDtCreated],[cewnModifyUserID],[cewdDtModified],[cewnLevelNo],[saga])
Select 2,c.connContactID,'E',EMAILADDRESS,1,
case isnull(u1.usrnuserid,'') when '' then 368 else u1.usrnuserid end,case datecreated when null then GETDATE() else datecreated end,u2.usrnuserid,daterevised,
null,null
FROM sma_MST_orgContacts c
Left Join [WilliamPagerSaga].dbo.ENTITIES on LTRIM(rtrim(c.connLevelNo))=ENTITYID 
left join sma_MST_IndvContacts a on a.cinsGrade=CREATORID
left join sma_mst_users u1 on u1.usrnContactID=a.cinnContactID
left join sma_MST_IndvContacts b on b.cinsGrade=REVISORID
left join sma_mst_users u2 on u2.usrnContactID=b.cinnContactID
Where ISPERSON<>'t' and EMAILADDRESS<>'' and EMAILADDRESS  like '%@%' and c.conncontactid is not null

INSERT INTO [sma_MST_EmailWebsite]
([cewnContactCtgID],[cewnContactID],[cewsEmailWebsiteFlag],[cewsEmailWebSite],[cewbDefault],[cewnRecUserID],[cewdDtCreated],[cewnModifyUserID],[cewdDtModified],[cewnLevelNo],[saga])
Select 2,c.connContactID,'W',WEBPAGE,1,
case isnull(u1.usrnuserid,'') when '' then 368 else u1.usrnuserid end,case datecreated when null then GETDATE() else datecreated end,u2.usrnuserid,daterevised,
null,null
FROM sma_MST_orgContacts c
Left Join [WilliamPagerSaga].dbo.ENTITIES on LTRIM(rtrim(c.connLevelNo))=ENTITYID 
left join sma_MST_IndvContacts a on a.cinsGrade=CREATORID
left join sma_mst_users u1 on u1.usrnContactID=a.cinnContactID
left join sma_MST_IndvContacts b on b.cinsGrade=REVISORID
left join sma_mst_users u2 on u2.usrnContactID=b.cinnContactID
Where ISPERSON<>'t' and WEBPAGE<>''  and c.conncontactid is not null

alter table [sma_MST_EmailWebsite] Enable trigger all





------------------------------Insert Email / Website Finished-------------------------------------------------------------------------
GO
alter table sma_mst_address disable trigger all
Update sma_MST_Address
set addbPrimary=1,addbIsCurrent=1,addbIsMailing=1
where addnAddressID in (
select MIN(addnAddressID) from sma_MST_Address
group by addnContactID,addnContactCtgID
having min(convert(varchar,addbPrimary)) =0)

Update a 
set addsCounty=b.zpcsCounty
From sma_MST_Address a
Outer apply (select top 1 zpcsCounty from sma_mst_ZipCodes where  zpcsZip=addsZip)b

Update sma_MST_Address
set addnZipID=null, addbDeleted=null

Delete from sma_MST_Address
where addnAddressID not in (
select distinct min(addnAddressID) from sma_MST_Address
group by addnContactID,addnContactCtgID,addsAddress1,addsCity,addsStateCode,addsZip)
alter table sma_mst_address enable trigger all



Update sma_MST_ContactNumbers 
set cnnbPrimary=0
where cnnnContactID in 
(select distinct cnnnContactID from sma_MST_ContactNumbers
where cnnbPrimary=1 and cnnnContactCtgID=1
group by cnnnContactID,cnnbPrimary
having count(cnnnContactID)>1 and cnnbPrimary=1 ) and cnnnContactCtgID=1
and cnnnContactNumberID not in (
Select max(cnnnContactNumberID) from sma_MST_ContactNumbers
where cnnnContactID in (
select distinct cnnnContactID from sma_MST_ContactNumbers
where cnnbPrimary=1 and cnnnContactCtgID=1 
group by cnnnContactID,cnnbPrimary
having count(cnnnContactID)>1 and cnnbPrimary=1 ) and cnnnContactCtgID=1 and cnnbPrimary=1
group by cnnnContactID)

Update sma_MST_ContactNumbers 
set cnnbPrimary=0
where cnnnContactID in 
(select distinct cnnnContactID from sma_MST_ContactNumbers
where cnnbPrimary=1 and cnnnContactCtgID=2 
group by cnnnContactID,cnnbPrimary
having count(cnnnContactID)>1 and cnnbPrimary=1 ) and cnnnContactCtgID=2
and cnnnContactNumberID not in (
Select max(cnnnContactNumberID) from sma_MST_ContactNumbers
where cnnnContactID in (
select distinct cnnnContactID from sma_MST_ContactNumbers
where cnnbPrimary=1 and cnnnContactCtgID=2 
group by cnnnContactID,cnnbPrimary
having count(cnnnContactID)>1 and cnnbPrimary=1 ) and cnnnContactCtgID=2 and cnnbPrimary=1
group by cnnnContactID)

----Set only one primary address
Update sma_MST_Address
set addbPrimary=0
where addnContactID in 
(select distinct addnContactID from sma_MST_Address
where addbPrimary=1 and addnContactCtgID=1
group by addnContactID,addbPrimary
having count(addnContactID)>1 and addbPrimary=1 ) and addnContactCtgID=1
and addnAddressID not in (
Select max(addnAddressID) from sma_MST_Address
where addnContactID in (
select distinct addnContactID from sma_MST_Address
where addbPrimary=1 and addnContactCtgID=1
group by addnContactID,addbPrimary
having count(addnContactID)>1 and addbPrimary=1 ) and addnContactCtgID=1 and addbPrimary=1
group by addnContactID)

Update sma_MST_Address
set addbPrimary=0
where addnContactID in 
(select distinct addnContactID from sma_MST_Address
where addbPrimary=1 and addnContactCtgID=2
group by addnContactID,addbPrimary
having count(addnContactID)>1 and addbPrimary=1 ) and addnContactCtgID=2
and addnAddressID not in (
Select max(addnAddressID) from sma_MST_Address
where addnContactID in (
select distinct addnContactID from sma_MST_Address
where addbPrimary=1 and addnContactCtgID=2
group by addnContactID,addbPrimary
having count(addnContactID)>1 and addbPrimary=1 ) and addnContactCtgID=2 and addbPrimary=1
group by addnContactID)
