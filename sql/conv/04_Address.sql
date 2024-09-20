set ansi_warnings off
go
alter table [sma_MST_Address]
alter column [addsAddressType] varchar(1000)
go
INSERT INTO [sma_MST_AddressTypes]
([addsCode],[addsDscrptn],[addnContactCategoryID],[addbIsWork],[addnRecUserID],[adddDtCreated],[addnModifyUserID],[adddDtModified],[addnLevelNo]) 
select '',ADDRDESCRIPTION,1,0,368,GETDATE(),null,null,''
From [WilliamPagerSaga].[dbo].[ADDRDESC] where ADDRDESCRIPTION not in (select [addsDscrptn]from [sma_MST_AddressTypes] where [addnContactCategoryID]=1)
go
INSERT INTO [sma_MST_AddressTypes]
([addsCode],[addsDscrptn],[addnContactCategoryID],[addbIsWork],[addnRecUserID],[adddDtCreated],[addnModifyUserID],[adddDtModified],[addnLevelNo]) 
select '',ADDRDESCRIPTION,2,0,368,GETDATE(),null,null,''
From [WilliamPagerSaga].[dbo].[ADDRDESC] where ADDRDESCRIPTION not in (select [addsDscrptn]from [sma_MST_AddressTypes] where [addnContactCategoryID]=2)
go
------------------------------Insert Address Started-------------------------------------------------------------------------
alter table [sma_MST_Address] disable trigger all
INSERT INTO [sma_MST_Address]
([addnContactCtgID],[addnContactID],[addnAddressTypeID],[addsAddressType],[addsAddTypeCode],[addsAddress1],[addsAddress2],[addsAddress3],[addsStateCode],[addsCity],[addnZipID]
,[addsZip],[addsCounty],[addsCountry],[addbIsResidence],[addbPrimary],[adddFromDate],[adddToDate],[addnCompanyID],[addsDepartment],[addsTitle],[addnContactPersonID],[addsComments]
,[addbIsCurrent],[addbIsMailing],[addnRecUserID],[adddDtCreated],[addnModifyUserID],[adddDtModified],[addnLevelNo],[caseno],[addbDeleted],[addsZipExtn],[saga])
Select 1,c.cinnContactID,case when addnAddTypeID IS NOT null then addnAddTypeID  else 10 end,ads.ADDRDESCRIPTION,
case when addsCode is not null then addsCode else 'OTH' end,substring(ADDRLINE1,0,75),substring(ADDRLINE2,0,75),substring(ADDRLINE3,0,75),substring(ADDRSTATE,0,20),substring(ADDRCITY,0,50),'',substring(ADDRZIPCODE,0,6),substring(ADDRCOUNTY,0,30),substring(ADDRCOUNTRY,0,30),
case when PRIMARYADDR  is NOT null then 1 else 0 end,case when PRIMARYADDR  is NOT null then 1 else 0 end,case ad.datecreated when null then GETDATE() else ad.datecreated end,null,null,null,null,null,EXTERNAL_REFERENCE_ID,
case when PRIMARYADDR  is NOT null then 1 else 0 end,case when PRIMARYADDR  is NOT null then 1 else 0 end,
case isnull(u1.usrnuserid,'') when '' then 368 else u1.usrnuserid end,case ad.datecreated when null then GETDATE() else ad.datecreated end,u2.usrnuserid,ad.daterevised,'','',null,case when ADDRZIPCODE like '%-%' then SUBSTRING(ADDRZIPCODE, CHARINDEX('-', ADDRZIPCODE) + 1, LEN(ADDRZIPCODE)) else '' end,''
FROM [WilliamPagerSaga].[dbo].[Address]  ad
left join [WilliamPagerSaga].[dbo].[ADDRDESC] ads on ads.[ADDRDESCRIPTIONID]=ad.ADDRDESCRIPTION
left join sma_MST_AddressTypes on addsDscrptn=ads.ADDRDESCRIPTION and [addnContactCategoryID]=1
left join [WilliamPagerSaga].[dbo].[ENTITIES] en on ad.ENTITYID=en.ENTITYID
left join sma_MST_IndvContacts c on c.cinsGrade=ad.ENTITYID
left join sma_MST_IndvContacts a on a.cinsGrade=ad.CREATORID
left join sma_mst_users u1 on u1.usrnContactID=a.cinnContactID
left join sma_MST_IndvContacts b on b.cinsGrade=ad.REVISORID
left join sma_mst_users u2 on u2.usrnContactID=b.cinnContactID
where  ISPERSON='t' and c.cinncontactid is not null

--select distinct *   FROM [Needles].[DBA].[multi_addresses]
INSERT INTO [sma_MST_Address]
([addnContactCtgID],[addnContactID],[addnAddressTypeID],[addsAddressType],[addsAddTypeCode],[addsAddress1],[addsAddress2],[addsAddress3],[addsStateCode],[addsCity],[addnZipID]
,[addsZip],[addsCounty],[addsCountry],[addbIsResidence],[addbPrimary],[adddFromDate],[adddToDate],[addnCompanyID],[addsDepartment],[addsTitle],[addnContactPersonID],[addsComments]
,[addbIsCurrent],[addbIsMailing],[addnRecUserID],[adddDtCreated],[addnModifyUserID],[adddDtModified],[addnLevelNo],[caseno],[addbDeleted],[addsZipExtn],[saga])
Select 2,c.connContactID,case when addnAddTypeID IS NOT null then addnAddTypeID   else 12 end,ads.ADDRDESCRIPTION,
case when addsCode is not null then addsCode else 'BRA' end,substring(ADDRLINE1,0,75),substring(ADDRLINE2,0,75),substring(ADDRLINE3,0,75),substring(ADDRSTATE,0,20),substring(ADDRCITY,0,50),'',substring(ADDRZIPCODE,0,6),substring(ADDRCOUNTY,0,30),substring(ADDRCOUNTRY,0,30),
0,case when PRIMARYADDR  is NOT null then 1 else 0 end,case ad.datecreated when null then GETDATE() else ad.datecreated end,null,null,null,null,null,EXTERNAL_REFERENCE_ID,
case when PRIMARYADDR  is NOT null then 1 else 0 end,case when PRIMARYADDR  is NOT null then 1 else 0 end,
case isnull(u1.usrnuserid,'') when '' then 368 else u1.usrnuserid end,case ad.datecreated when null then GETDATE() else ad.datecreated end,u2.usrnuserid,ad.daterevised,'','',null,case when ADDRZIPCODE like '%-%' then SUBSTRING(ADDRZIPCODE, CHARINDEX('-', ADDRZIPCODE) + 1, LEN(ADDRZIPCODE)) else '' end,''
FROM [WilliamPagerSaga].[dbo].[Address]  ad
left join [WilliamPagerSaga].[dbo].[ENTITIES] en on ad.ENTITYID=en.ENTITYID
left join [WilliamPagerSaga].[dbo].[ADDRDESC] ads on ads.[ADDRDESCRIPTIONID]=ad.ADDRDESCRIPTION
left join sma_MST_AddressTypes on addsDscrptn=ads.ADDRDESCRIPTION and [addnContactCategoryID]=2
left join sma_MST_OrgContacts c on c.connLevelNo=ad.ENTITYID
left join sma_MST_IndvContacts a on a.cinsGrade=ad.CREATORID
left join sma_mst_users u1 on u1.usrnContactID=a.cinnContactID
left join sma_MST_IndvContacts b on b.cinsGrade=ad.REVISORID
left join sma_mst_users u2 on u2.usrnContactID=b.cinnContactID
where  ISPERSON<>'t' and c.conncontactid is not null

INSERT INTO [sma_MST_Address]
([addnContactCtgID],[addnContactID],[addnAddressTypeID],[addsAddressType],[addsAddTypeCode],[addsAddress1],[addsAddress2],[addsAddress3],[addsStateCode],[addsCity],[addnZipID]
,[addsZip],[addsCounty],[addsCountry],[addbIsResidence],[addbPrimary],[adddFromDate],[adddToDate],[addnCompanyID],[addsDepartment],[addsTitle],[addnContactPersonID],[addsComments]
,[addbIsCurrent],[addbIsMailing],[addnRecUserID],[adddDtCreated],[addnModifyUserID],[adddDtModified],[addnLevelNo],[caseno],[addbDeleted],[addsZipExtn],[saga])
Select 1,c.cinnContactID,10,'Other' ,
 'OTH' ,'','','','','',''
,'','','',1,1,GETDATE(),null,null,null,null,null,''
,1,1,368,GETDATE(),null,null,'','',null,'',''
 from sma_MST_IndvContacts c
where cinnContactID not in (
select addnContactID from sma_MST_Address where addnContactCtgID=1)
Union
Select 2,c.connContactID,12,'Branch Office 2' ,
 'BRA' ,'','','','','',''
,'','','',1,1,GETDATE(),null,null,null,null,null,''
,1,1,368,GETDATE(),null,null,'','',null,'',''
 from sma_MST_orgContacts c
where connContactID not in (
select addnContactID from sma_MST_Address where addnContactCtgID=2)


Update sma_MST_Address 
set addbPrimary=0,addbIsMailing=0

Update sma_MST_Address 
set addbPrimary=1,addbIsMailing=1
where addnAddressID in (
select MIN(addnaddressid) from sma_MST_Address
where cast(addnContactID as varchar)+cast(addnContactCtgID as varchar) in (
Select distinct cast(addnContactID as varchar)+cast(addnContactCtgID as varchar) from sma_MST_Address
where addbPrimary=0
group by addnContactID,addnContactCtgID
having count(addnContactID)>1)
group by addnContactID,addnContactCtgID)
alter table [sma_MST_Address] enable trigger all
