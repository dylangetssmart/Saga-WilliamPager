
------------------------------Insert Phone Numbers Started-------------------------------------------------------------------------

alter table [sma_MST_ContactNumbers] disable trigger all
INSERT INTO [sma_MST_ContactNumbers]
([cnnnContactCtgID],[cnnnContactID],[cnnnPhoneTypeID],[cnnsContactNumber],[cnnsExtension],[cnnbPrimary],[cnnbVisible],[cnnnAddressID],[cnnsLabelCaption],[cnnnRecUserID],[cnndDtCreated],
[cnnnModifyUserID],[cnndDtModified],[cnnnLevelNo],[caseNo],[saga])	
Select 1, c.cinnContactID,1,case when len(PHONE)>2 then isnull('(' + LEFT(Replace(ltrim(substring(dbo.[RemoveAlphaCharactersN](phone),0,11)),'-',''),3)+') '+SUBSTRING(Replace(Replace(substring(dbo.[RemoveAlphaCharactersN](phone),0,11),'-',''),' ',''),4,3)+'-'+RIGHT(Replace(Replace(substring(dbo.[RemoveAlphaCharactersN](phone),0,11),'-',''),' ',''),4),'') else null end,
PHONEEXT,1,1,addnaddressid,'Home 1',case isnull(u1.usrnuserid,'') when '' then 368 else u1.usrnuserid end,case datecreated when null then GETDATE() else datecreated end,u2.usrnuserid,daterevised,
null,null,null
FROM sma_MST_IndvContacts  c
Left Join [WilliamPagerSaga].[dbo].[ENTITIES]  on LTRIM(rtrim(c.cinsGrade))=ENTITYID 
outer apply(select top 1 addnaddressid,addsAddress1,addsAddress2,addsAddress3,addsCity,addsStateCode,addsZip from  sma_MST_Address where addnContactID=cinnContactID and addnContactCtgID=1 order by isnull(addbPrimary,0) desc) e
left join sma_MST_IndvContacts a on a.cinsGrade=CREATORID
left join sma_mst_users u1 on u1.usrnContactID=a.cinnContactID
left join sma_MST_IndvContacts b on b.cinsGrade=REVISORID
left join sma_mst_users u2 on u2.usrnContactID=b.cinnContactID
Where ISPERSON='t' and len(PHONE)>2 and c.cinncontactid is not null

INSERT INTO [sma_MST_ContactNumbers]
([cnnnContactCtgID],[cnnnContactID],[cnnnPhoneTypeID],[cnnsContactNumber],[cnnsExtension],[cnnbPrimary],[cnnbVisible],[cnnnAddressID],[cnnsLabelCaption],[cnnnRecUserID],[cnndDtCreated],
[cnnnModifyUserID],[cnndDtModified],[cnnnLevelNo],[caseNo],[saga])	
Select 1, c.cinnContactID,29,case when len(MOBILEPHONE)>2 then isnull('(' + LEFT(Replace(ltrim(substring(dbo.[RemoveAlphaCharactersN](MOBILEPHONE),0,11)),'-',''),3)+') '+SUBSTRING(Replace(Replace(substring(dbo.[RemoveAlphaCharactersN](MOBILEPHONE),0,11),'-',''),' ',''),4,3)+'-'+RIGHT(Replace(Replace(substring(dbo.[RemoveAlphaCharactersN](MOBILEPHONE),0,11),'-',''),' ',''),4),'') else null end,
MOBILEEXT,Case when len(PHONE)>2 then 0 else 1 end ,1,addnaddressid,'Cell Phone',case isnull(u1.usrnuserid,'') when '' then 368 else u1.usrnuserid end,case datecreated when null then GETDATE() else datecreated end,u2.usrnuserid,daterevised,
null,null,null
FROM sma_MST_IndvContacts  c
Left Join [WilliamPagerSaga].[dbo].[ENTITIES]  on LTRIM(rtrim(c.cinsGrade))=ENTITYID 
outer apply(select top 1 addnaddressid,addsAddress1,addsAddress2,addsAddress3,addsCity,addsStateCode,addsZip from  sma_MST_Address where addnContactID=cinnContactID and addnContactCtgID=1 order by isnull(addbPrimary,0) desc) e
left join sma_MST_IndvContacts a on a.cinsGrade=CREATORID
left join sma_mst_users u1 on u1.usrnContactID=a.cinnContactID
left join sma_MST_IndvContacts b on b.cinsGrade=REVISORID
left join sma_mst_users u2 on u2.usrnContactID=b.cinnContactID
Where ISPERSON='t' and len(MOBILEPHONE)>2 and c.cinncontactid is not null

INSERT INTO [sma_MST_ContactNumbers]
([cnnnContactCtgID],[cnnnContactID],[cnnnPhoneTypeID],[cnnsContactNumber],[cnnsExtension],[cnnbPrimary],[cnnbVisible],[cnnnAddressID],[cnnsLabelCaption],[cnnnRecUserID],[cnndDtCreated],
[cnnnModifyUserID],[cnndDtModified],[cnnnLevelNo],[caseNo],[saga])	
Select 1, c.cinnContactID,1,case when len(ADDRPHONE)>2 then isnull('(' + LEFT(Replace(ltrim(substring(dbo.[RemoveAlphaCharactersN](ADDRPHONE),0,11)),'-',''),3)+') '+SUBSTRING(Replace(Replace(substring(dbo.[RemoveAlphaCharactersN](ADDRPHONE),0,11),'-',''),' ',''),4,3)+'-'+RIGHT(Replace(Replace(substring(dbo.[RemoveAlphaCharactersN](ADDRPHONE),0,11),'-',''),' ',''),4),'') else null end,
ADDRPHONEEXT,Case when len(PHONE)>2 then 0 when LEN(MOBILEPHONE)>0 then 0 else 1 end ,1,addnaddressid,'Home 1',case isnull(u1.usrnuserid,'') when '' then 368 else u1.usrnuserid end,case f.datecreated when null then GETDATE() else f.datecreated end,u2.usrnuserid,f.daterevised,
null,null,null
FROM sma_MST_IndvContacts  c
Left Join [WilliamPagerSaga].[dbo].[address] f on LTRIM(rtrim(c.cinsGrade))=f.ENTITYID 
Left Join [WilliamPagerSaga].[dbo].[ENTITIES] g on f.ENTITYID =g.ENTITYID 
outer apply(select top 1 addnaddressid,addsAddress1,addsAddress2,addsAddress3,addsCity,addsStateCode,addsZip from  sma_MST_Address where addnContactID=cinnContactID and addnContactCtgID=1 order by isnull(addbPrimary,0) desc) e
left join sma_MST_IndvContacts a on a.cinsGrade=f.CREATORID
left join sma_mst_users u1 on u1.usrnContactID=a.cinnContactID
left join sma_MST_IndvContacts b on b.cinsGrade=f.REVISORID
left join sma_mst_users u2 on u2.usrnContactID=b.cinnContactID
Where ISPERSON='t' and len(ADDRPHONE)>2 and c.cinncontactid is not null

INSERT INTO [sma_MST_ContactNumbers]
([cnnnContactCtgID],[cnnnContactID],[cnnnPhoneTypeID],[cnnsContactNumber],[cnnsExtension],[cnnbPrimary],[cnnbVisible],[cnnnAddressID],[cnnsLabelCaption],[cnnnRecUserID],[cnndDtCreated],
[cnnnModifyUserID],[cnndDtModified],[cnnnLevelNo],[caseNo],[saga])	
Select 1, c.cinnContactID,16,case when len(ADDRDATA)>2 then isnull('(' + LEFT(Replace(ltrim(substring(dbo.[RemoveAlphaCharactersN](ADDRDATA),0,11)),'-',''),3)+') '+SUBSTRING(Replace(Replace(substring(dbo.[RemoveAlphaCharactersN](ADDRDATA),0,11),'-',''),' ',''),4,3)+'-'+RIGHT(Replace(Replace(substring(dbo.[RemoveAlphaCharactersN](ADDRDATA),0,11),'-',''),' ',''),4),'') else null end,
'',Case when len(PHONE)>2 then 0 when LEN(MOBILEPHONE)>0 then 0 when LEN(ADDRPHONE)>2 then 0 else 1 end ,1,addnaddressid,'Work 2',case isnull(u1.usrnuserid,'') when '' then 368 else u1.usrnuserid end,case f.datecreated when null then GETDATE() else f.datecreated end,u2.usrnuserid,f.daterevised,
null,null,null
FROM sma_MST_IndvContacts  c
Left Join [WilliamPagerSaga].[dbo].[address] f on LTRIM(rtrim(c.cinsGrade))=f.ENTITYID 
Left Join [WilliamPagerSaga].[dbo].[ENTITIES] g on f.ENTITYID =g.ENTITYID 
outer apply(select top 1 addnaddressid,addsAddress1,addsAddress2,addsAddress3,addsCity,addsStateCode,addsZip from  sma_MST_Address where addnContactID=cinnContactID and addnContactCtgID=1 order by isnull(addbPrimary,0) desc) e
left join sma_MST_IndvContacts a on a.cinsGrade=f.CREATORID
left join sma_mst_users u1 on u1.usrnContactID=a.cinnContactID
left join sma_MST_IndvContacts b on b.cinsGrade=f.REVISORID
left join sma_mst_users u2 on u2.usrnContactID=b.cinnContactID
Where ISPERSON='t' and len(ADDRDATA)>2 and c.cinncontactid is not null

INSERT INTO [sma_MST_ContactNumbers]
([cnnnContactCtgID],[cnnnContactID],[cnnnPhoneTypeID],[cnnsContactNumber],[cnnsExtension],[cnnbPrimary],[cnnbVisible],[cnnnAddressID],[cnnsLabelCaption],[cnnnRecUserID],[cnndDtCreated],[cnnnModifyUserID],[cnndDtModified],[cnnnLevelNo],[caseNo],[saga])	
Select 1, c.cinnContactID,25,case when len(ADDRFAX)>2 then isnull('(' + LEFT(Replace(ltrim(substring(dbo.[RemoveAlphaCharactersN](ADDRFAX),0,11)),'-',''),3)+') '+SUBSTRING(Replace(Replace(substring(dbo.[RemoveAlphaCharactersN](ADDRFAX),0,11),'-',''),' ',''),4,3)+'-'+RIGHT(Replace(Replace(substring(dbo.[RemoveAlphaCharactersN](ADDRFAX),0,11),'-',''),' ',''),4),'') else null end,
'',0,1,addnaddressid,'Home Fax',case isnull(u1.usrnuserid,'') when '' then 368 else u1.usrnuserid end,case f.datecreated when null then GETDATE() else f.datecreated end,u2.usrnuserid,f.daterevised,
null,null,null
FROM sma_MST_IndvContacts  c
Left Join [WilliamPagerSaga].[dbo].[address] f on LTRIM(rtrim(c.cinsGrade))=f.ENTITYID 
Left Join [WilliamPagerSaga].[dbo].[ENTITIES] g on f.ENTITYID =g.ENTITYID 
outer apply(select top 1 addnaddressid,addsAddress1,addsAddress2,addsAddress3,addsCity,addsStateCode,addsZip from  sma_MST_Address where addnContactID=cinnContactID and addnContactCtgID=1 order by isnull(addbPrimary,0) desc) e
left join sma_MST_IndvContacts a on a.cinsGrade=f.CREATORID
left join sma_mst_users u1 on u1.usrnContactID=a.cinnContactID
left join sma_MST_IndvContacts b on b.cinsGrade=f.REVISORID
left join sma_mst_users u2 on u2.usrnContactID=b.cinnContactID
Where ISPERSON='t' and len(ADDRFAX)>2 and c.cinncontactid is not null

---------------------------------------------
INSERT INTO [sma_MST_ContactNumbers]
([cnnnContactCtgID],[cnnnContactID],[cnnnPhoneTypeID],[cnnsContactNumber],[cnnsExtension],[cnnbPrimary],[cnnbVisible],[cnnnAddressID],[cnnsLabelCaption],[cnnnRecUserID],[cnndDtCreated],
[cnnnModifyUserID],[cnndDtModified],[cnnnLevelNo],[caseNo],[saga])	
Select 2, c.connContactID,24,case when len(PHONE)>2 then isnull('(' + LEFT(Replace(ltrim(substring(dbo.[RemoveAlphaCharactersN](phone),0,11)),'-',''),3)+') '+SUBSTRING(Replace(Replace(substring(dbo.[RemoveAlphaCharactersN](phone),0,11),'-',''),' ',''),4,3)+'-'+RIGHT(Replace(Replace(substring(dbo.[RemoveAlphaCharactersN](phone),0,11),'-',''),' ',''),4),'') else null end,
PHONEEXT,1,1,addnaddressid,'Office Phone',case isnull(u1.usrnuserid,'') when '' then 368 else u1.usrnuserid end,case datecreated when null then GETDATE() else datecreated end,u2.usrnuserid,daterevised,
null,null,null
FROM sma_MST_OrgContacts  c
Left Join [WilliamPagerSaga].[dbo].[ENTITIES]  on LTRIM(rtrim(c.connLevelNo))=ENTITYID 
outer apply(select top 1 addnaddressid,addsAddress1,addsAddress2,addsAddress3,addsCity,addsStateCode,addsZip from  sma_MST_Address where addnContactID=connContactID and addnContactCtgID=2 order by isnull(addbPrimary,0) desc) e
left join sma_MST_IndvContacts a on a.cinsGrade=CREATORID
left join sma_mst_users u1 on u1.usrnContactID=a.cinnContactID
left join sma_MST_IndvContacts b on b.cinsGrade=REVISORID
left join sma_mst_users u2 on u2.usrnContactID=b.cinnContactID
Where ISPERSON<>'t' and len(PHONE)>2 and c.conncontactid is not null

INSERT INTO [sma_MST_ContactNumbers]
([cnnnContactCtgID],[cnnnContactID],[cnnnPhoneTypeID],[cnnsContactNumber],[cnnsExtension],[cnnbPrimary],[cnnbVisible],[cnnnAddressID],[cnnsLabelCaption],[cnnnRecUserID],[cnndDtCreated],
[cnnnModifyUserID],[cnndDtModified],[cnnnLevelNo],[caseNo],[saga])	
Select 2, c.connContactID,40,case when len(MOBILEPHONE)>2 then isnull('(' + LEFT(Replace(ltrim(substring(dbo.[RemoveAlphaCharactersN](MOBILEPHONE),0,11)),'-',''),3)+') '+SUBSTRING(Replace(Replace(substring(dbo.[RemoveAlphaCharactersN](MOBILEPHONE),0,11),'-',''),' ',''),4,3)+'-'+RIGHT(Replace(Replace(substring(dbo.[RemoveAlphaCharactersN](MOBILEPHONE),0,11),'-',''),' ',''),4),'') else null end,
MOBILEEXT,Case when len(PHONE)>2 then 0 else 1 end ,1,addnaddressid,'Cell',case isnull(u1.usrnuserid,'') when '' then 368 else u1.usrnuserid end,case datecreated when null then GETDATE() else datecreated end,u2.usrnuserid,daterevised,
null,null,null
FROM sma_MST_OrgContacts  c
Left Join [WilliamPagerSaga].[dbo].[ENTITIES]  on LTRIM(rtrim(c.connLevelNo))=ENTITYID 
outer apply(select top 1 addnaddressid,addsAddress1,addsAddress2,addsAddress3,addsCity,addsStateCode,addsZip from  sma_MST_Address where addnContactID=connContactID and addnContactCtgID=2 order by isnull(addbPrimary,0) desc) e
left join sma_MST_IndvContacts a on a.cinsGrade=CREATORID
left join sma_mst_users u1 on u1.usrnContactID=a.cinnContactID
left join sma_MST_IndvContacts b on b.cinsGrade=REVISORID
left join sma_mst_users u2 on u2.usrnContactID=b.cinnContactID
Where ISPERSON<>'t' and len(MOBILEPHONE)>2 and c.conncontactid is not null

INSERT INTO [sma_MST_ContactNumbers]
([cnnnContactCtgID],[cnnnContactID],[cnnnPhoneTypeID],[cnnsContactNumber],[cnnsExtension],[cnnbPrimary],[cnnbVisible],[cnnnAddressID],[cnnsLabelCaption],[cnnnRecUserID],[cnndDtCreated],
[cnnnModifyUserID],[cnndDtModified],[cnnnLevelNo],[caseNo],[saga])	
Select 2, c.connContactID,24,case when len(ADDRPHONE)>2 then isnull('(' + LEFT(Replace(ltrim(substring(dbo.[RemoveAlphaCharactersN](ADDRPHONE),0,11)),'-',''),3)+') '+SUBSTRING(Replace(Replace(substring(dbo.[RemoveAlphaCharactersN](ADDRPHONE),0,11),'-',''),' ',''),4,3)+'-'+RIGHT(Replace(Replace(substring(dbo.[RemoveAlphaCharactersN](ADDRPHONE),0,11),'-',''),' ',''),4),'') else null end,
ADDRPHONEEXT,Case when len(PHONE)>2 then 0 when LEN(MOBILEPHONE)>0 then 0 else 1 end ,1,addnaddressid,'Office Phone',case isnull(u1.usrnuserid,'') when '' then 368 else u1.usrnuserid end,case f.datecreated when null then GETDATE() else f.datecreated end,u2.usrnuserid,f.daterevised,
null,null,null
FROM sma_MST_orgContacts  c
Left Join [WilliamPagerSaga].[dbo].[address] f on LTRIM(rtrim(c.connLevelNo))=f.ENTITYID 
Left Join [WilliamPagerSaga].[dbo].[ENTITIES] g on f.ENTITYID =g.ENTITYID 
outer apply(select top 1 addnaddressid,addsAddress1,addsAddress2,addsAddress3,addsCity,addsStateCode,addsZip from  sma_MST_Address where addnContactID=connContactID and addnContactCtgID=2 order by isnull(addbPrimary,0) desc) e
left join sma_MST_IndvContacts a on a.cinsGrade=f.CREATORID
left join sma_mst_users u1 on u1.usrnContactID=a.cinnContactID
left join sma_MST_IndvContacts b on b.cinsGrade=f.REVISORID
left join sma_mst_users u2 on u2.usrnContactID=b.cinnContactID
Where ISPERSON<>'t' and len(ADDRPHONE)>2 and c.conncontactid is not null

INSERT INTO [sma_MST_ContactNumbers]
([cnnnContactCtgID],[cnnnContactID],[cnnnPhoneTypeID],[cnnsContactNumber],[cnnsExtension],[cnnbPrimary],[cnnbVisible],[cnnnAddressID],[cnnsLabelCaption],[cnnnRecUserID],[cnndDtCreated],
[cnnnModifyUserID],[cnndDtModified],[cnnnLevelNo],[caseNo],[saga])	
Select 2, c.connContactID,35,case when len(ADDRDATA)>2 then isnull('(' + LEFT(Replace(ltrim(substring(dbo.[RemoveAlphaCharactersN](ADDRDATA),0,11)),'-',''),3)+') '+SUBSTRING(Replace(Replace(substring(dbo.[RemoveAlphaCharactersN](ADDRDATA),0,11),'-',''),' ',''),4,3)+'-'+RIGHT(Replace(Replace(substring(dbo.[RemoveAlphaCharactersN](ADDRDATA),0,11),'-',''),' ',''),4),'') else null end,
'',Case when len(PHONE)>2 then 0 when LEN(MOBILEPHONE)>0 then 0 when len(ADDRPHONE)>2 then 0 else 1 end ,1,addnaddressid,'HQ/Main Office',case isnull(u1.usrnuserid,'') when '' then 368 else u1.usrnuserid end,case f.datecreated when null then GETDATE() else f.datecreated end,u2.usrnuserid,f.daterevised,
null,null,null
FROM sma_MST_orgContacts  c
Left Join [WilliamPagerSaga].[dbo].[address] f on LTRIM(rtrim(c.connLevelNo))=f.ENTITYID 
Left Join [WilliamPagerSaga].[dbo].[ENTITIES] g on f.ENTITYID =g.ENTITYID 
outer apply(select top 1 addnaddressid,addsAddress1,addsAddress2,addsAddress3,addsCity,addsStateCode,addsZip from  sma_MST_Address where addnContactID=connContactID and addnContactCtgID=2 order by isnull(addbPrimary,0) desc) e
left join sma_MST_IndvContacts a on a.cinsGrade=f.CREATORID
left join sma_mst_users u1 on u1.usrnContactID=a.cinnContactID
left join sma_MST_IndvContacts b on b.cinsGrade=f.REVISORID
left join sma_mst_users u2 on u2.usrnContactID=b.cinnContactID
Where ISPERSON<>'t' and len(ADDRDATA)>2 and c.conncontactid is not null


INSERT INTO [sma_MST_ContactNumbers]
([cnnnContactCtgID],[cnnnContactID],[cnnnPhoneTypeID],[cnnsContactNumber],[cnnsExtension],[cnnbPrimary],[cnnbVisible],[cnnnAddressID],[cnnsLabelCaption],[cnnnRecUserID],[cnndDtCreated],[cnnnModifyUserID],[cnndDtModified],[cnnnLevelNo],[caseNo],[saga])	
Select 2, c.connContactID,28,case when len(ADDRFAX)>2 then isnull('(' + LEFT(Replace(ltrim(substring(dbo.[RemoveAlphaCharactersN](ADDRFAX),0,11)),'-',''),3)+') '+SUBSTRING(Replace(Replace(substring(dbo.[RemoveAlphaCharactersN](ADDRFAX),0,11),'-',''),' ',''),4,3)+'-'+RIGHT(Replace(Replace(substring(dbo.[RemoveAlphaCharactersN](ADDRFAX),0,11),'-',''),' ',''),4),'') else null end,
'',0,1,addnaddressid,'Office Fax',case isnull(u1.usrnuserid,'') when '' then 368 else u1.usrnuserid end,case f.datecreated when null then GETDATE() else f.datecreated end,u2.usrnuserid,f.daterevised,
null,null,null
FROM sma_MST_orgContacts  c
Left Join [WilliamPagerSaga].[dbo].[address] f on LTRIM(rtrim(c.connLevelNo))=f.ENTITYID 
Left Join [WilliamPagerSaga].[dbo].[ENTITIES] g on f.ENTITYID =g.ENTITYID 
outer apply(select top 1 addnaddressid,addsAddress1,addsAddress2,addsAddress3,addsCity,addsStateCode,addsZip from  sma_MST_Address where addnContactID=connContactID and addnContactCtgID=2 order by isnull(addbPrimary,0) desc) e
left join sma_MST_IndvContacts a on a.cinsGrade=f.CREATORID
left join sma_mst_users u1 on u1.usrnContactID=a.cinnContactID
left join sma_MST_IndvContacts b on b.cinsGrade=f.REVISORID
left join sma_mst_users u2 on u2.usrnContactID=b.cinnContactID
Where ISPERSON<>'t' and len(ADDRFAX)>2 and c.conncontactid is not null

alter table [sma_MST_ContactNumbers] Enable trigger all


