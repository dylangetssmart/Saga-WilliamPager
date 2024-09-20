INSERT INTO [sma_MST_VehicleMake]
([vmksCode],[vmksDscrptn],[vmknRecUserID],[vmkdDtCreated],[vmknModifyUserID],[vmkdDtModified],[vmknLevelNo])
select distinct '',make,368,getdate(),null,null,'' from [WilliamPagerSaga].[dbo].[LW_VEHICLE]
except
select '',vmksDscrptn,368,getdate(),null,null,'' from [sma_MST_VehicleMake]

INSERT INTO [sma_MST_VehicleModels]
([vmdsCode],[vmdnMakeID],[vmdsModelDscrptn],[vmdnRecUserID],[vmddDtCreated],[vmdnModifyUserID],[vmddDtModified],[vmdnLevelNo])
select distinct '',vmknMakeID,model,368,getdate(),null,null,'' from [WilliamPagerSaga].[dbo].[LW_VEHICLE]
left join [sma_MST_VehicleMake] on MAKE=vmksDscrptn where vmknMakeID is not null and isnull(model,'') <>''
except
Select '',vmdnMakeID,vmdsModelDscrptn ,368,getdate(),null,null,''from [sma_MST_VehicleModels]
go
alter table [sma_TRN_Vehicles]
alter column [vehsComments] varchar(4000)  null

alter table [sma_TRN_Vehicles]
alter column vehsPlateNo varchar(40) null
go
INSERT INTO [sma_TRN_Vehicles]
([vehnCaseID],[vehbIsPlaintiff],[vehnPlntDefID],[vehnOwnerID],[vehnOwnerCtg],[vehnRegistrantID],[vehnRegistrantCtg],[vehnOperatorID],[vehnOperatorCtg],[vehsLicenceNo],[vehnLicenceStateID],[vehdLicExpDt]
,[vehnVehicleMake],[vehnYear],[vehnModelID],[vehnBodyTypeID],[vehsPlateNo],[vehsColour],[vehnVehicleStateID],[vehsVINNo],[vehdRegExpDt],[vehnIsLeased],[vehnDamageClaim],[vehdEstReqdOn],[vehdEstRecvdOn],[vehdPhotoReqdOn]
,[vehdPhotoRecvdOn],[vehbRepairs],[vehbTotalLoss],[vehnCostOfRepairs],[vehnValueBefAcdnt],[vehnRentalExpense],[vehnOthExpense],[vehnSalvage],[vehnTLRentalExpense],[vehnTLOthExpense],[vehnLoss],[vehnNetLoss],[vehnLicenseHistory]
,[vehnPlateSearch],[vehnTitlesearch],[vehnMV104],[vehdOprLicHistory],[vehdPlateSearchOn],[vehdTitleSearchOn],[vehdMV104On],[vehdOprLicHistoryRecd],[vehdPlateSearchOnRecd],[vehdTitleSearchOnRecd],[vehdMV104OnRecd],[vehsComments]
,[vehbPhotoAttached],[vehnRecUserID],[vehdDtCreated],[vehnModifyUserID],[vehdDtModified],[vehnLevelNo])
Select  distinct casnCaseID,case when p1.plnnPlaintiffID IS NOT null or p2.plnnPlaintiffID IS NOT null then 1 else 0 end,case when d1.defnDefendentID IS NOT null then d1.defnDefendentID when d2.defnDefendentID IS NOT null then d2.defnDefendentID when p1.plnnPlaintiffID IS NOT null then p1.plnnPlaintiffID when p2.plnnPlaintiffID IS NOT null then p2.plnnPlaintiffID end,
case when i4.cinnContactID IS NOT null then i4.cinnContactID when o4.connContactID IS NOT null then o4.connContactID end,case when i4.cinnContactID IS NOT null then 1 when o4.connContactID IS NOT null then 2 end
,case when i3.cinnContactID IS NOT null then i3.cinnContactID when o3.connContactID IS NOT null then o3.connContactID end,case when i3.cinnContactID IS NOT null then 1 when o3.connContactID IS NOT null then 2 end,case when i5.cinnContactID IS NOT null then i5.cinnContactID when o5.connContactID IS NOT null then o5.connContactID end,case when i5.cinnContactID IS NOT null then 1 when o5.connContactID IS NOT null then 2 end
,DRIVERSLICENSENUMBER,sttnStateID,null,vmknMakeID,MODELYEAR,vmdnModelID,null,PLATENUMBER,COLOR,sttnStateID,VIN,null,case ISLEASED when 'F' then 0 when 'T' then 1 end,
NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,isnull(convert(varchar(4000),comment),'')+ case when ISNULL(model,'')<>'' then ' '+'Model: '+' '+model end+isnull(convert(varchar(6000),ltrim(replace(replace(replace(dbo.RegExReplace(n.NOTES,'({\\)(.+?)(})|(\\)(.+?)(\b)','') ,'}',''),char(13),'') ,char(10),''))),'') ,NULL,NULL,NULL,NULL,null,NULL
FROM [WilliamPagerSaga].[dbo].[LW_VEHICLE]  a
left join WilliamPagerSaga.dbo.ASSIGN b on  a.assignid=b.ASSIGNID
left join WilliamPagerSaga.dbo.MATTER c on c.MATTERID=b.MATTERID
left join sma_trn_cases   on cassCaseNumber=MATTERNUMBER
left join WilliamPagerSaga.dbo.ASSIGN d on  a.REGISTEREDOWNERID=d.ASSIGNID and a.REGISTEREDOWNERID is not null
left join WilliamPagerSaga.dbo.ASSIGN e on  a.TITLEOWNERID=e.ASSIGNID and a.TITLEOWNERID is not null
left join WilliamPagerSaga.dbo.ASSIGN f on  a.OPERATORID=f.ASSIGNID and a.OPERATORID is not null
left join  sma_MST_IndvContacts i1 on LTRIM(rtrim(i1.cinsGrade))=b.ENTITYID and b.PARTYTYPE=2
left join  sma_MST_OrgContacts o1 on LTRIM(rtrim(o1.connLevelNo))=b.ENTITYID and b.PARTYTYPE=2
Left Join sma_TRN_Defendants d1 on i1.cinnContactID=d1.defnContactID  and  d1.defnContactCtgID=1 and d1.defnCaseID=casnCaseID
Left Join sma_TRN_Defendants d2 on o1.connContactID=d2.defnContactID  and  d2.defnContactCtgID=2 and d2.defnCaseID=casnCaseID
left join  sma_MST_IndvContacts i2 on LTRIM(rtrim(i2.cinsGrade))=b.ENTITYID and b.PARTYTYPE=1
left join  sma_MST_OrgContacts o2 on LTRIM(rtrim(o2.connLevelNo))=b.ENTITYID and b.PARTYTYPE=1
Left Join sma_TRN_Plaintiff p1 on i2.cinnContactID= p1.plnnContactID and p1.plnnContactCtg=1 and p1.plnnCaseID=casnCaseID
Left Join sma_TRN_Plaintiff p2 on o2.connContactID= p2.plnnContactID and p2.plnnContactCtg=2 and p2.plnnCaseID=casnCaseID
left join  sma_MST_IndvContacts i3 on LTRIM(rtrim(i3.cinsGrade))=d.ENTITYID
left join  sma_MST_OrgContacts o3 on LTRIM(rtrim(o3.connLevelNo))=d.ENTITYID
left join  sma_MST_IndvContacts i4 on LTRIM(rtrim(i4.cinsGrade))=e.ENTITYID
left join  sma_MST_OrgContacts o4 on LTRIM(rtrim(o4.connLevelNo))=e.ENTITYID
left join  sma_MST_IndvContacts i5 on LTRIM(rtrim(i5.cinsGrade))=f.ENTITYID
left join  sma_MST_OrgContacts o5 on LTRIM(rtrim(o5.connLevelNo))=f.ENTITYID
left join sma_MST_States on sttsCode=[state]
left join [sma_MST_VehicleMake] on a.MAKE=vmksDscrptn
left join [sma_MST_VehicleModels] on a.model=[vmdsModelDscrptn] and vmdnMakeID=vmknMakeID
left join WilliamPagerSaga.dbo.NOTE n on n.NOTEID=VIOLATIONHISTORYNOTEID

go