

/*
alter table [dbo].[sma_TRN_Documents] disable trigger all
delete from [dbo].[sma_TRN_Documents] 
DBCC CHECKIDENT ('[dbo].[sma_TRN_Documents]', RESEED, 0);
alter table [dbo].[sma_TRN_Documents] enable trigger all
*/


INSERT INTO [sma_MST_ScannedDocCategories]
([sctgsCategoryCode],[sctgsCategoryName],[sctgnRecUserID],[sctgdDtCreated],[sctgnModifyUserID],[sctgdDtModified])
Select CODE,substring(DESCRIPTION,0,50),368,GETDATE(),null,null from [WilliamPagerSaga].dbo.DOCCAT
where not exists(select ctgsCategoryName from sma_MST_CategoriesNew where ctgsCategoryName=DESCRIPTION)
go
--INSERT INTO [sma_MST_ScannedSubCategories]
--([sctgnCategoryID],[scanSubCategoryCode],[scanSubCategoryName],[scanRecUserID],[scanDtCreated],[scanModifyUserID],[scanDtModified])     
--Select distinct sctgnCategoryID,CODE,DESCRIPTION,368,GETDATE(),null,null from [WilliamPagerSaga].dbo.DOCCAT
--join [sma_MST_ScannedDocCategories] on [sctgsCategoryName]=DESCRIPTION
--where not exists(select b.[sctgsCategoryName] from [sma_MST_ScannedSubCategories] a join [sma_MST_ScannedDocCategories] b on a.sctgnCategoryID=b.[sctgnCategoryID] where b.[sctgsCategoryName]=DESCRIPTION)

INSERT INTO [sma_MST_ScannedSubCategories]
([sctgnCategoryID],[scanSubCategoryCode],[scanSubCategoryName],[scanRecUserID],[scanDtCreated],[scanModifyUserID],[scanDtModified])    
Select distinct sctgnCategoryID,'',substring(dtype.DESCRIPTION,0,50),368,getdate(),null,null
From [WilliamPagerSaga].dbo.document d 
Left Join [WilliamPagerSaga].dbo.DOCCAT dcat on  d.CategoryID=dcat.CategoryID  
LEFT Join [WilliamPagerSaga].dbo.doctype dType on  d.TYPEID=dType.TypeID 
left join [sma_MST_ScannedDocCategories] s1 on dcat.DESCRIPTION=[sctgsCategoryName]
go
Alter Table sma_trn_documents disable trigger all

SET QUOTED_IDENTIFIER ON;
GO

INSERT INTO [sma_TRN_Documents]
([docnCaseID],[docsDocumentName],[docsDocumentPath],[docsDocumentData],[docnCategoryID],[docnSubCategoryID],[docnFromContactCtgID]
,[docnFromContactID],[docsToContact],[docsDocType],[docnTemplateID],[docbAttachFlag],[docsDescrptn],[docnAuthor],[docsDocsrflag]
,[docnRecUserID],[docdDtCreated],[docnModifyUserID],[docdDtModified],[docnLevelNo],[ctgnCategoryID],[sctnSubCategoryID],[sctssSubSubCategoryID]
,[sctsssSubSubSubCategoryID],[docnMedProvContactctgID],[docnMedProvContactID],[docnComments],[docnReasonReject],[docsReviewerContactId]
,[docsReviewDate],[docsDocumentAnalysisResultId],[docsIsReviewed],[docsToContactID],[docsToContactCtgID],[docdLastUpdated],[docnPriority])
Select distinct casnCaseID,substring(FILENAME,0,200),substring(PATH,0,1000),'',s1.sctgnCategoryID,s2.scanSubCategoryID,case when froml.cinnContactID is not null then 1 when fromo.connContactID is not null then 2 end
,case when froml.cinnContactID is not null then froml.cinnContactID when fromo.connContactID is not null then fromo.connContactID end,'','Doc',null,null,substring(d.DESCRIPTION,0,200),0,'',u1.usrnUserID,case isdate(d.datecreated) when 0 then GETDATE() else (d.datecreated) end,
u2.usrnUserID,case when DOCDATE between '1/1/1900' and '12/31/2079' then DOCDATE end,'',s1.sctgnCategoryID,s2.scanSubCategoryid,'','','','','','',null,null,null,null,null,null,d.DATEREVISED,3
From [WilliamPagerSaga].dbo.document d   
Left Join [WilliamPagerSaga].dbo.MATTER m on m.MATTERID=d.MATTERID
Left Join [WilliamPagerSaga].dbo.entities e on d.AUTHORID=e.entityid
Left Join [WilliamPagerSaga].dbo.DOCCAT dcat on  d.CategoryID=dcat.CategoryID  
LEFT Join [WilliamPagerSaga].dbo.Docent r on d.documentid=r.documentid
LEFT Join [WilliamPagerSaga].dbo.doctype dType on  d.TYPEID=dType.TypeID 
LEFT Join [WilliamPagerSaga].dbo.LW_A_MATTERTYPE LMT on  m.MATTERTYPEID=LMT.MATTERTYPEID
Left join sma_trn_cases  on cassCaseNumber=m.MATTERNUMBER
left join sma_MST_IndvContacts l on l.cinsGrade=d.CREATORID
left join sma_mst_users u1 on u1.usrnContactID=l.cinnContactID
left join sma_MST_IndvContacts g on g.cinsGrade=d.REVISORID
left join sma_mst_users u2 on u2.usrnContactID=g.cinnContactID
left join sma_MST_IndvContacts froml on froml.cinsGrade=d.AUTHORID
left join sma_MST_OrgContacts fromo on fromo.connLevelNo=d.AUTHORID
left join [sma_MST_ScannedDocCategories] s1 on substring(dcat.DESCRIPTION,0,50)=[sctgsCategoryName]
left join [sma_MST_ScannedSubCategories] s2 on s2.sctgnCategoryID=s1.sctgnCategoryID and substring(dtype.DESCRIPTION,0,50)=s2.scanSubCategoryName
where  casnCaseID is not null

GO

SET QUOTED_IDENTIFIER OFF;

Alter Table sma_trn_documents Enable trigger all



GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_sma_TRN_MassMailing_sma_MST_Templates]') AND parent_object_id = OBJECT_ID(N'[dbo].[sma_TRN_MassMailing]'))
ALTER TABLE [dbo].[sma_TRN_MassMailing] DROP CONSTRAINT [FK_sma_TRN_MassMailing_sma_MST_Templates]
GO

Truncate table sma_MST_Templates
GO

ALTER TABLE [dbo].[sma_TRN_MassMailing]  WITH CHECK ADD  CONSTRAINT [FK_sma_TRN_MassMailing_sma_MST_Templates] FOREIGN KEY([masmailTemplateID])
REFERENCES [dbo].[sma_MST_Templates] ([tmlnTemplateId])
GO

ALTER TABLE [dbo].[sma_TRN_MassMailing] CHECK CONSTRAINT [FK_sma_TRN_MassMailing_sma_MST_Templates]
GO


INSERT INTO [dbo].[sma_MST_ScannedSubCategories]
([sctgnCategoryID],[scanSubCategoryCode],[scanSubCategoryName],[scanRecUserID],[scanDtCreated],[scanModifyUserID],[scanDtModified]) 
select d.sctgnCategoryID,upper(substring(c.DESCRIPTION,0,5)),substring(c.DESCRIPTION,0,50),368,getdate(),null,null
From  [WilliamPagerSaga].dbo.DOCTEMPL a
left join [WilliamPagerSaga].[dbo].[DOCTYPE] c on c.TYPEID=a.TYPEID
left join [WilliamPagerSaga].dbo.DOCCAT b on a.CATEGORYID=b.CATEGORYID
left join sma_MST_ScannedDocCategories d on sctgsCategoryName=substring(b.DESCRIPTION,0,50)
left join [sma_MST_ScannedSubCategories] e on d.sctgnCategoryID=e.sctgnCategoryID and [scanSubCategoryName]=substring(c.DESCRIPTION,0,50)
where not exists (select * from [sma_MST_ScannedSubCategories] f where e.scanSubCategoryID=f.scanSubCategoryID)
and d.sctgnCategoryID is not null and isnull(substring(c.DESCRIPTION,0,50),'')<>''

Alter table sma_mst_templates 
alter column [tmlsTemplateName] varchar(250)
INSERT INTO [sma_MST_Templates]
([tmlsTemplateName],[tmlsTemplateData],[tmlnCategoryID],[tmlnSubCategoryID],[tmldDtCreated],[tmlnRecUserId],[tmldDtModified]
,[tmlnModifyUserId],[tmlnLevelNo],[tmpsmrgCodeID],[tmlnnCategoryID],[tmlnnSubCategoryID],[tmlnSubSubCategoryID],[tmlnSubSubSubCategoryID]
,[tmlnIsMassMailing],[tmlnTemplateCaseGroup],[tmlnEnvelopeTemplateID],[tmlnIsArchived])
     
select a.DESCRIPTION,case when FRMFILE like '%.%' then replace(replace(FRMFILE,'.frm','.Doc'),'.wpd','.Doc') 
 else case when filename like '%.%' then left(FILENAME, charindex('.', FILENAME) - 1)+'.doc' else filename+'.doc' end  end,null,null,GETDATE(),368,null,null,'','',case when d.sctgnCategoryID is not null then d.sctgnCategoryID else 52 end,case when e.scanSubCategoryID is not null then e.scanSubCategoryID else 371 end,'','','','',null,'' 
from [WilliamPagerSaga].dbo.DOCTEMPL a
left join [WilliamPagerSaga].dbo.CMPNNTS z on z.DESCRIPTION=a.DESCRIPTION
left join [WilliamPagerSaga].[dbo].[DOCTYPE] c on c.TYPEID=a.TYPEID
left join [WilliamPagerSaga].dbo.DOCCAT b on a.CATEGORYID=b.CATEGORYID
left join sma_MST_ScannedDocCategories d on sctgsCategoryName=substring(b.DESCRIPTION,0,50)
left join [sma_MST_ScannedSubCategories] e on d.sctgnCategoryID=e.sctgnCategoryID and [scanSubCategoryName]=substring(c.DESCRIPTION,0,50)
where case when FRMFILE is not null then replace(replace(FRMFILE,'.frm','.Doc'),'.wpd','.Doc') else replace(replace(replace(FILENAME,'.frm','.Doc'),'.wpd','.Doc'),'.do','.doc') end is not null
go
INSERT INTO [sma_MST_Templates]
([tmlsTemplateName],[tmlsTemplateData],[tmlnCategoryID],[tmlnSubCategoryID],[tmldDtCreated],[tmlnRecUserId],[tmldDtModified]
,[tmlnModifyUserId],[tmlnLevelNo],[tmpsmrgCodeID],[tmlnnCategoryID],[tmlnnSubCategoryID],[tmlnSubSubCategoryID],[tmlnSubSubSubCategoryID]
,[tmlnIsMassMailing],[tmlnTemplateCaseGroup],[tmlnEnvelopeTemplateID],[tmlnIsArchived])
     
select DESCRIPTION,replace(replace(FRMFILE,'.frm','.Doc'),'.wpd','.Doc'),null,null,GETDATE(),368,null,null,'','',52,371,'','','','','','' from [WilliamPagerSaga].dbo.CMPNNTS
where COMPONENTTYPEID=14 and not exists(select * from sma_mst_templates where tmlsTemplateName=DESCRIPTION)
and not exists(select * from sma_mst_templates where convert(varchar(max),tmlsTemplateData)=replace(replace(FRMFILE,'.frm','.Doc'),'.wpd','.Doc'))


go