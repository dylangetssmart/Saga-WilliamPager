

























INSERT INTO [sma_TRN_Cases]
([cassCaseNumber],[casbAppName],[cassCaseName],[casnCaseTypeID],[casnState],[casdStatusFromDt],[casnStatusValueID],[casdsubstatusfromdt],[casnSubStatusValueID]
,[casdOpeningDate],[casdClosingDate],[casnCaseValueID],[casnCaseValueFrom],[casnCaseValueTo],[casnCurrentCourt],[casnCurrentJudge],[casnCurrentMagistrate],[casnCaptionID]
,[cassCaptionText],[casbMainCase],[casbCaseOut],[casbSubOut],[casbWCOut],[casbPartialOut],[casbPartialSubOut],[casbPartiallySettled],[casbInHouse],[casbAutoTimer]
,[casdExpResolutionDate],[casdIncidentDate],[casnTotalLiability],[cassSharingCodeID],[casnStateID],[casnLastModifiedBy],[casdLastModifiedDate],[casnRecUserID],[casdDtCreated]
,[casnModifyUserID],[casdDtModified],[casnLevelNo],[cassCaseValueComments],[casbRefIn],[casbDelete],[casbIntaken],[casnOrgCaseTypeID],[CassCaption],[cassMdl],[office_id],[saga]
,[LIP],[casnSeriousInj],[casnCorpDefn],[casnWebImporter],[casnRecoveryClient],[cas],[ngage],[casnClientRecoveredDt],[CloseReason])
select distinct (MATTERNUMBER),null,min(SHORTMATTERNAME),min(cstnCaseSubTypeID),case  when min(sttnStateID) IS null  then 67 when min(sttnStateID)= '' then 67 else min(sttnStateID) end,
MIN(a.STATUSDATE) as [casdStatusFromDt],MIN(i.cssnStatusID) as [casnStatusValueID],null as [casdsubstatusfromdt],'' as [casnSubStatusValueID],
case when year(min(a.DATEOPENED))<1900 then '2000-01-01 00:00:00.000' when min(DATEOPENED) IS  null then '2000-01-01 00:00:00.000'  else convert(datetime,min(DATEOPENED)) end,
case when year(min(DATECLOSED))<1900 and year(min(DATEOPENED))>1900 then convert(datetime,min(DATEOPENED))+1 when year(min(DATECLOSED))<1900 and (year(min(DATEOPENED))<1900 OR min(DATEOPENED) IS null ) then null when min(DATECLOSED) IS  null then null  else convert(datetime,min(DATECLOSED)) end,
null,0,0,MIN(connContactID),null,null,null,MIN(convert(varchar(4000),CAPTION)),1,
0 as [casbCaseOut],0 as [casbSubOut],0 as [casbWCOut],0 as [casbPartialOut],0 as [casbPartialSubOut],0 as [casbPartiallySettled],1 as [casbInHouse],0 as [casbAutoTimer]
,null as [casdExpResolutionDate],
null,
0 as [casnTotalLiability],MIN(MATTERID) as [cassSharingCodeID],'' as [casnStateID],
min(u2.usrnuserid),min(a.daterevised),
case isnull(min(u1.usrnuserid),'') when '' then 368 else min(u1.usrnuserid) end,case min(a.datecreated) when null then GETDATE() else min(a.datecreated) end,min(u2.usrnuserid),min(a.daterevised),
'' as [casnLevelNo],'' as [cassCaseValueComments],0 as [casbRefIn],0 as [casbDelete],1 as [casbIntaken],
min(cstnCaseTypeID) as [casnOrgCaseTypeID],'' as [CassCaption],'' as [cassMdl],2 as [office_id],'' as [saga],
''as [LIP],'' as [casnSeriousInj],'' as [casnCorpDefn],'' as [casnWebImporter],'' as [casnRecoveryClient],'' as [cas],'' as [ngage],null as [casnClientRecoveredDt],'' as [CloseReason]
FROM [WilliamPagerSaga].[dbo].[Matter] a
Left Join [WilliamPagerSaga].[dbo].[ENTITIES] b  on CLIENTID=ENTITYID
Left Join [WilliamPagerSaga].[dbo].[LAWTYPE] c on a.LawTypeid=c.LawTypeid
 Left Join [WilliamPagerSaga].dbo.LW_A_MATTERTYPE t on t.mattertypeid=a.mattertypeid
 Left Join sma_MST_CaseType z on cstsType=c.DESCRIPTION
 left join sma_mst_casesubtype z1 on cstsdscrptn=t.DESCRIPTION and z1.cstnGroupID=z.cstnCaseTypeID
left join sma_MST_IndvContacts d on d.cinsGrade=a.CLIENTID
Outer apply(select top 1 STATUSDATE from [WilliamPagerSaga].[dbo].[MATTER_STATUS_HISTORY] e where e.MATTERID=a.MATTERID order by e.STATUSDATE desc)e
outer apply(select top 1 sttnStateID,sttsCode from  sma_MST_Address left join sma_MST_States on ltrim(rtrim(addsStateCode))=sttsCode where addnContactID=d.cinnContactID and addnContactCtgID=1 order by isnull(addbPrimary,0) desc) g
left join [WilliamPagerSaga].[dbo].[STATUS] h on h.STATUSID=a.STATUSID
left join sma_MST_CaseStatus i on i.csssDescription=h.DESCRIPTION and i.cssnStatusTypeID=1
left join [WilliamPagerSaga].[dbo].[JURISDCT] j on j.JURISDICTIONID=a.JURISDICTIONID
left join sma_MST_OrgContacts k on k.connLevelNo=j.COURTID
left join sma_MST_IndvContacts l on l.cinsGrade=a.CREATORID
left join sma_mst_users u1 on u1.usrnContactID=l.cinnContactID
left join sma_MST_IndvContacts m on m.cinsGrade=a.REVISORID
left join sma_mst_users u2 on u2.usrnContactID=m.cinnContactID
where isnull(matternumber,'') <>''
Group by a.MATTERNUMBER 
