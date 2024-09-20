
Alter table [sma_TRN_PoliceReports] disable trigger all
INSERT INTO [sma_TRN_PoliceReports]
([pornCaseID],[porsDepartment],[porsDivision],[pornPoliceID],[pornPOContactID],[pornPOAddressID],[pornPoliceAdID],[pornPOCtgID],[porsPrecinct],[pornReportTypeID],[porsReportNo],[pordRepRequestDate]
,[pordRepReceivedDate],[pornRepProvidedByADID],[pornRepProvidedBy],[pornReportProvidedCtgID],[pornRepFavourable],[porsComments],[pornRecUserID],[pordDtCreated],[pornModifyUserID],[pordDtModified],[pornLevelNo])
Select casnCaseID,'','','',case when o.cinncontactid IS not null then o.cinncontactid when n.conncontactid IS not null then n.conncontactid end,case when o.cinncontactid IS not null then IndvAddressID when n.conncontactid IS not null then orgAddressID end,
'',case when o.cinncontactid IS not null then 1 when n.conncontactid IS not null then 2 end,substring(ep.FIRST_DBA,0,30),case when REPORTTYPE like '%accident%' then 8 else null end,a.FILENUMBER,case when [REPORT_REQUESTED]between '1/1/1900' and '12/31/2079' then [REPORT_REQUESTED] end,
case when [REPORTDATE] IS null and REPORTRECEIVED ='T' then '1/1/2000' when  REPORTDATE between '1/1/1900' and '12/31/2079' then REPORTDATE end,null,null,null,null,substring(REPORTTYPE,0,199),casnRecUserID,case when casdDtCreated between '1/1/1900' and '12/31/2079' then casdDtCreated else getdate() end,null,null,''
FROM [WilliamPagerSaga].[dbo].[LW_POLICEAGENCY] a
left join [WilliamPagerSaga].[dbo].[ENTITIES] e on ENTITYID=CONTACTID
left join [WilliamPagerSaga].[dbo].[ASSIGN] b on a.ASSIGNID=b.ASSIGNID
left join [WilliamPagerSaga].dbo.matter m on b.matterid=m.matterid
left join sma_trn_cases on cassCaseNumber=m.MATTERNUMBER 
left join sma_MST_IndvContacts l on l.cinsGrade=e.ENTITYID
left join sma_MST_OrgContacts k on k.connLevelNo=e.ENTITYID
left join [WilliamPagerSaga].[dbo].[ENTITIES] ep on ep.ENTITYID=b.ENTITYID
left join sma_MST_IndvContacts o on o.cinsGrade=ep.ENTITYID
left join sma_MST_OrgContacts n on n.connLevelNo=ep.ENTITYID
outer apply(select top 1 addnaddressid as IndvAddressID from  sma_MST_Address where addnContactID=o.cinncontactid and addnContactCtgID=1 order by isnull(addbPrimary,0) desc) z
outer apply(select top 1 addnaddressid as orgAddressID from  sma_MST_Address where addnContactID=n.conncontactid and addnContactCtgID=2 order by isnull(addbPrimary,0) desc) z1
Alter table [sma_TRN_PoliceReports] enable trigger all     


