Alter table [sma_TRN_Emails]
Alter column [emlsSubject] varchar(2000)
Alter table [sma_TRN_Emails]
Alter column [emlsFromEmailID] varchar(1000)
Alter table [sma_TRN_Emails]
Alter column [emlsOutLookUserEmailID] varchar(1000)
Go
set ansi_warnings off
INSERT INTO [sma_TRN_Emails]
([emlnCaseID],[emlnFrom],[emlsTableName],[emlsColumnName],[emlnRecordID],[emlsSubject],[emlsSentReceived],[emlsContents],[emlbAcknowledged],[emldDate]
,[emlsFromEmailID],[emlsOutLookUserEmailID],[emlnTemplateID],[emlnPriority],[emlnRecUserID],[emldDtCreated],[emlnModifyUserID],[emldDtModified]
,[emlnLevelNo],[emlnReviewerContactId],[emlnReviewDate],[emlnDocumentAnalysisResultId],[emlnIsReviewed],[emlnToContactID],[emlnToContactCtgID],[emlnDocPriority])
select distinct casnCaseID,null,'','',0,MR.SUBJECT,case mr.INCOMING when 'T' then 'D' else 'S' end,
--CONVERT(nVARCHAR(MAX),cast(WMESSAGE as nvarchar(max))),null,BEGINTIME,WFROM,WTO,0,0,u1.usrnUserID,mr.DATECREATED,u2.usrnUserID,mr.DATEREVISED,'' <-- chinmong comment
  '',null,BEGINTIME,WFROM,WTO,0,0,u1.usrnUserID,mr.DATECREATED,u2.usrnUserID,mr.DATEREVISED,''
,null,null,null,null,null,null,3
from WilliamPagerSaga.DBO.MATRULE MR
Left join WilliamPagerSaga.DBO.MATTER M on M.MATTERID=MR.MATTERID
left join sma_trn_cases on cassCaseNumber=m.MATTERNUMBER
left join sma_MST_IndvContacts i1 on i1.cinsGrade=mr.CREATORID
left join sma_MST_Users u1 on u1.usrnContactID=i1.cinnContactID
left join sma_MST_IndvContacts i2 on i2.cinsGrade=mr.REVISORID
left join sma_MST_Users u2 on u2.usrnContactID=i2.cinnContactID
where casnCaseID is not null
go
  