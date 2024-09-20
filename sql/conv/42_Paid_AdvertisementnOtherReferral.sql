
  
 DECLARE @Data varchar(500)
   
    -- Declare a cursor that will get staff contactid

	
DECLARE Advertising_Cursor CURSOR FAST_FORWARD FOR 
Select distinct sa.DESCRIPTION 
From [WilliamPagerSaga].dbo.matter m
LEFT Join [WilliamPagerSaga].dbo.assign a on a.matterid=m.matterid
LEFT Join [WilliamPagerSaga].dbo.lw_source so on so.assignid=a.assignid
LEFT Join [WilliamPagerSaga].dbo.lw_a_source sa on so.SOURCENONENTITYID=sa.sourceid
LEFT Join [WilliamPagerSaga].dbo.entities e on so.sourceentityid=e.entityid
LEFT Join [WilliamPagerSaga].dbo.LW_SOURCECAT sc on sc.id=so.SOURCECATEGORY
LEFT Join sma_TRN_CaseS on cassCaseNumber=MATTERNUMBER
Where sc.description='Advertising' and sa.DESCRIPTION is not null
--Open a cursor
OPEN Advertising_Cursor 

FETCH NEXT FROM Advertising_Cursor INTO @Data

WHILE @@FETCH_STATUS = 0
BEGIN

declare @p1 int
set @p1=scope_identity()
exec save_OrgContacts @connContactID=@p1 output,@cinnContactIDU=NULL,@blnconbPrimary=1,@intconnContactTypeID=11,@intconnContactSubCtgID=0,@strconsName=@Data,@blnconbStatus=1,@strconsEINNO='            ',@strconsComments=NULL,@intconnContactCtg=2,@intconnRefByCtgID=NULL,@intconnReferredBy=0,@intconnContactPerson=0,@strconsWorkPhone='(   )    -    ',@blnPrevent=0,@intconnRecUserID=368,@strOthName=NULL,@strEmail=NULL,@delete=0
select @p1

declare @p2 int
set @p2=scope_identity()
exec save_Address @addnAddressIDU=NULL,@addnAddressID=@p2 output,@addnContactCtgID=2,@addnContactID=@p1,@addnAddressTypeID=9,@addsAddressType='HQ/Main Office',@addsAddTypeCode=NULL,@addsAddress1=NULL,@addsAddress2=NULL,@addsAddress3=NULL,@addsStateCode=NULL,@addsCity=NULL,@addnZipID=NULL,@addsZip=NULL,@addsCounty=NULL,@addsCountry='USA',@addbIsResidence=0,@addbPrimary=1,@adddFromDate=NULL,@adddToDate=NULL,@addnCompanyID=0,@addsDepartment=NULL,@addsTitle=NULL,@addnContactPersonID=0,@addsComments=NULL,@addbIsCurrent=1,@addbIsMailing=1,@addsZipExtn=NULL,@UserID=368,@delete=0
select @p2

exec Insert_Contact_Numbers @contact_id=@p1,@contact_ctg_id=2,@home_phone_number=NULL,@work_phone_number=NULL,@cell_phone_number=NULL,@other_phone_number=NULL,@ext=NULL,@address_id=@p2,@contact_type_id=39,@update=0,@primary_id=2,@user_id=368
exec save_ContactTypesForContact @ctcnContTypeContID=0,@ctcnContactCtgID=2,@ctcnContactID=@p1,@ctcnContactTypeID=71,@ctcnRecUserID=368,@blnDelete=0


FETCH NEXT FROM Advertising_Cursor INTO @Data
END

CLOSE Advertising_Cursor
DEALLOCATE Advertising_Cursor

INSERT INTO [sma_TRN_PdAdvt]
([advnCaseID],[advnSrcContactCtg],[advnSrcContactID],[advnSrcAddressID],[advnSubTypeID],[advnPlaintiffID],[advdDateTime],[advdRetainedDt]
,[advnFeeStruID],[advsComments],[advnRecUserID],[advdDtCreated],[advnModifyUserID],[advdDtModified],[advnLevelNo])
Select distinct casnCaseID,2,connContactID,orgAddressID,0,plnnplaintiffid,min(a.DATECREATED),null,0,'',min(u1.usrnUserID),min(a.DATECREATED),min(u2.usrnUserID),min(a.DATEREVISED),''
From [WilliamPagerSaga].dbo.matter m
LEFT Join [WilliamPagerSaga].dbo.assign a on a.matterid=m.matterid
LEFT Join [WilliamPagerSaga].dbo.lw_source so on so.assignid=a.assignid
LEFT Join [WilliamPagerSaga].dbo.lw_a_source sa on so.SOURCENONENTITYID=sa.sourceid
LEFT Join [WilliamPagerSaga].dbo.entities e on so.sourceentityid=e.entityid
LEFT Join [WilliamPagerSaga].dbo.LW_SOURCECAT sc on sc.id=so.SOURCECATEGORY
LEFT Join sma_TRN_CaseS on cassCaseNumber=MATTERNUMBER
Outer Apply (Select top 1 conncontactid from sma_mst_orgcontacts where consName=sa.DESCRIPTION)z
outer apply (select top 1 addnaddressid as orgAddressID from  sma_MST_Address where addnContactID=conncontactid and addnContactCtgID=2 order by isnull(addbPrimary,0) desc) b
Outer Apply (Select top 1 plnnplaintiffid from sma_TRN_Plaintiff where plnnCaseID=casnCaseID order by ISNULL(plnbIsPrimary,0) desc)c
left join sma_MST_IndvContacts l on l.cinsGrade=a.CREATORID
left join sma_mst_users u1 on u1.usrnContactID=l.cinnContactID
left join sma_MST_IndvContacts n on n.cinsGrade=a.REVISORID
left join sma_mst_users u2 on u2.usrnContactID=n.cinnContactID
Where sc.description='Advertising' and casnCaseID is not null
Group By casnCaseID,connContactID,orgAddressID,plnnplaintiffid

          
INSERT INTO [sma_TRN_OtherReferral]
([otrnCaseID],[otrnRefContactCtg],[otrnRefContactID],[otrnRefAddressID],[otrnPlaintiffID],[otrnRelationshipID],[otrdRetainedDt]
,[otrnFeeStruID],[otrsComments],[otrnUserID],[otrdDtCreated],[otrnModifyUserID],[otrdDtModified],[otrnLevelNo],[otrnReferralType])
Select distinct casnCaseID,case when conncontactid IS NOT null then 2  when i.cinncontactid IS NOT null then 1 end,
case when conncontactid IS NOT null then connContactID  when i.cinncontactid IS NOT null then i.cinnContactID end,case when conncontactid IS NOT null then orgAddressID  when i.cinncontactid IS NOT null then indAddressID end,
0,0,null,0,convert(varchar(4000),s.COMMENTS),(u1.usrnUserID),(a.DATECREATED),(u2.usrnUserID),(a.DATEREVISED),'',1
  from [WilliamPagerSaga].dbo.lw_source s
         left join [WilliamPagerSaga].dbo.ENTITIES e on e.ENTITYID=s.SOURCEENTITYID
         left join [WilliamPagerSaga].dbo.ASSIGN a on a.ASSIGNID=s.ASSIGNID
         left join [WilliamPagerSaga].dbo.MATTER m on m.MATTERID=a.MATTERID
         left join sma_MST_IndvContacts i on i.cinsGrade=e.ENTITYID
         left join sma_MST_orgContacts o on o.connLevelNo=e.ENTITYID
         left join sma_trn_cases on cassCaseNumber=MATTERNUMBER
         outer apply (select top 1 addnaddressid as orgAddressID from  sma_MST_Address where addnContactID=conncontactid and addnContactCtgID=2 order by isnull(addbPrimary,0) desc) b
		 outer apply (select top 1 addnaddressid as indAddressID from  sma_MST_Address where addnContactID=cinncontactid and addnContactCtgID=1 order by isnull(addbPrimary,0) desc) bb
		 left join sma_MST_IndvContacts l on l.cinsGrade=a.CREATORID
left join sma_mst_users u1 on u1.usrnContactID=l.cinnContactID
left join sma_MST_IndvContacts n on n.cinsGrade=a.REVISORID
left join sma_mst_users u2 on u2.usrnContactID=n.cinnContactID
         where ISENTITY='T' and casnCaseID is not null
     
	 INSERT INTO [sma_TRN_OtherReferral]
([otrnCaseID],[otrnRefContactCtg],[otrnRefContactID],[otrnRefAddressID],[otrnPlaintiffID],[otrnRelationshipID],[otrdRetainedDt]
,[otrnFeeStruID],[otrsComments],[otrnUserID],[otrdDtCreated],[otrnModifyUserID],[otrdDtModified],[otrnLevelNo],[otrnReferralType])
Select distinct casnCaseID,case when conncontactid IS NOT null then 2  end,
case when conncontactid IS NOT null then connContactID   end,case when conncontactid IS NOT null then orgAddressID   end,
0,0,null,0,convert(varchar(4000),so.COMMENTS),(u1.usrnUserID),(a.DATECREATED),(u2.usrnUserID),(a.DATEREVISED),'',1
	 From [WilliamPagerSaga].dbo.matter m
LEFT Join [WilliamPagerSaga].dbo.assign a on a.matterid=m.matterid
LEFT Join [WilliamPagerSaga].dbo.lw_source so on so.assignid=a.assignid
LEFT Join [WilliamPagerSaga].dbo.lw_a_source sa on so.SOURCENONENTITYID=sa.sourceid
LEFT Join [WilliamPagerSaga].dbo.entities e on so.sourceentityid=e.entityid
LEFT Join [WilliamPagerSaga].dbo.entities es on m.CLIENTID=es.entityid
LEFT Join [WilliamPagerSaga].dbo.LW_SOURCECAT sc on sc.id=so.SOURCECATEGORY
LEFT Join sma_TRN_CaseS on cassCaseNumber=MATTERNUMBER
Outer Apply (Select top 1 conncontactid from sma_mst_orgcontacts where consName=sa.DESCRIPTION)z
outer apply (select top 1 addnaddressid as orgAddressID from  sma_MST_Address where addnContactID=conncontactid and addnContactCtgID=2 order by isnull(addbPrimary,0) desc) b
Outer Apply (Select top 1 plnnplaintiffid from sma_TRN_Plaintiff where plnnCaseID=casnCaseID order by ISNULL(plnbIsPrimary,0) desc)c
left join sma_MST_IndvContacts l on l.cinsGrade=a.CREATORID
left join sma_mst_users u1 on u1.usrnContactID=l.cinnContactID
left join sma_MST_IndvContacts n on n.cinsGrade=a.REVISORID
left join sma_mst_users u2 on u2.usrnContactID=n.cinnContactID
Where sc.description<>'Advertising' and sc.Description not like '%referral%'   and casnCaseID is not null
go
 DECLARE @Data1 varchar(500)
   
    -- Declare a cursor that will get staff contactid

	
DECLARE Advertising1_Cursor CURSOR FAST_FORWARD FOR 
Select distinct sa.DESCRIPTION 
From [WilliamPagerSaga].dbo.lw_a_source sa
LEFT Join [WilliamPagerSaga].dbo.lw_source so on so.SOURCENONENTITYID=sa.sourceid
LEFT Join [WilliamPagerSaga].dbo.LW_SOURCECAT sc on sc.id=so.SOURCECATEGORY
Where sc.description<>'Advertising' and sa.DESCRIPTION is not null and  not exists (select * from sma_mst_orgcontacts where consName=sa.DESCRIPTION)
--Open a cursor
OPEN Advertising1_Cursor 

FETCH NEXT FROM Advertising1_Cursor INTO @Data1

WHILE @@FETCH_STATUS = 0
BEGIN

declare @p1 int
set @p1=scope_identity()
exec save_OrgContacts @connContactID=@p1 output,@cinnContactIDU=NULL,@blnconbPrimary=1,@intconnContactTypeID=11,@intconnContactSubCtgID=0,@strconsName=@Data1,@blnconbStatus=1,@strconsEINNO='            ',@strconsComments=NULL,@intconnContactCtg=2,@intconnRefByCtgID=NULL,@intconnReferredBy=0,@intconnContactPerson=0,@strconsWorkPhone='(   )    -    ',@blnPrevent=0,@intconnRecUserID=368,@strOthName=NULL,@strEmail=NULL,@delete=0
select @p1

declare @p2 int
set @p2=scope_identity()
exec save_Address @addnAddressIDU=NULL,@addnAddressID=@p2 output,@addnContactCtgID=2,@addnContactID=@p1,@addnAddressTypeID=9,@addsAddressType='HQ/Main Office',@addsAddTypeCode=NULL,@addsAddress1=NULL,@addsAddress2=NULL,@addsAddress3=NULL,@addsStateCode=NULL,@addsCity=NULL,@addnZipID=NULL,@addsZip=NULL,@addsCounty=NULL,@addsCountry='USA',@addbIsResidence=0,@addbPrimary=1,@adddFromDate=NULL,@adddToDate=NULL,@addnCompanyID=0,@addsDepartment=NULL,@addsTitle=NULL,@addnContactPersonID=0,@addsComments=NULL,@addbIsCurrent=1,@addbIsMailing=1,@addsZipExtn=NULL,@UserID=368,@delete=0
select @p2

exec Insert_Contact_Numbers @contact_id=@p1,@contact_ctg_id=2,@home_phone_number=NULL,@work_phone_number=NULL,@cell_phone_number=NULL,@other_phone_number=NULL,@ext=NULL,@address_id=@p2,@contact_type_id=39,@update=0,@primary_id=2,@user_id=368
exec save_ContactTypesForContact @ctcnContTypeContID=0,@ctcnContactCtgID=2,@ctcnContactID=@p1,@ctcnContactTypeID=71,@ctcnRecUserID=368,@blnDelete=0


FETCH NEXT FROM Advertising1_Cursor INTO @Data1
END

CLOSE Advertising1_Cursor
DEALLOCATE Advertising1_Cursor
go
	 INSERT INTO [sma_TRN_OtherReferral]
([otrnCaseID],[otrnRefContactCtg],[otrnRefContactID],[otrnRefAddressID],[otrnPlaintiffID],[otrnRelationshipID],[otrdRetainedDt]
,[otrnFeeStruID],[otrsComments],[otrnUserID],[otrdDtCreated],[otrnModifyUserID],[otrdDtModified],[otrnLevelNo],[otrnReferralType])
Select distinct casnCaseID,case when conncontactid IS NOT null then 2  end,
case when conncontactid IS NOT null then connContactID   end,case when conncontactid IS NOT null then orgAddressID   end,
0,0,null,0,convert(varchar(4000),so.COMMENTS),(u1.usrnUserID),(a.DATECREATED),(u2.usrnUserID),(a.DATEREVISED),'',1
	 From [WilliamPagerSaga].dbo.matter m
LEFT Join [WilliamPagerSaga].dbo.assign a on a.matterid=m.matterid
LEFT Join [WilliamPagerSaga].dbo.lw_source so on so.assignid=a.assignid
LEFT Join [WilliamPagerSaga].dbo.lw_a_source sa on so.SOURCENONENTITYID=sa.sourceid
LEFT Join [WilliamPagerSaga].dbo.entities e on so.sourceentityid=e.entityid
LEFT Join [WilliamPagerSaga].dbo.entities es on m.CLIENTID=es.entityid
LEFT Join [WilliamPagerSaga].dbo.LW_SOURCECAT sc on sc.id=so.SOURCECATEGORY
LEFT Join sma_TRN_CaseS on cassCaseNumber=MATTERNUMBER
Outer Apply (Select top 1 conncontactid from sma_mst_orgcontacts where consName=sa.DESCRIPTION)z
outer apply (select top 1 addnaddressid as orgAddressID from  sma_MST_Address where addnContactID=conncontactid and addnContactCtgID=2 order by isnull(addbPrimary,0) desc) b
Outer Apply (Select top 1 plnnplaintiffid from sma_TRN_Plaintiff where plnnCaseID=casnCaseID order by ISNULL(plnbIsPrimary,0) desc)c
left join sma_MST_IndvContacts l on l.cinsGrade=a.CREATORID
left join sma_mst_users u1 on u1.usrnContactID=l.cinnContactID
left join sma_MST_IndvContacts n on n.cinsGrade=a.REVISORID
left join sma_mst_users u2 on u2.usrnContactID=n.cinnContactID
Where  casnCaseID is not null and casnCaseID not in (select advncaseid from sma_trn_pdadvt) and casnCaseID not in (select otrncaseid from [sma_TRN_OtherReferral])
and case when conncontactid IS NOT null then connContactID   end is not null