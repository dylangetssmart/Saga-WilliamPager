
Alter Table [sma_MST_NoteTypes]
Alter column [nttsDscrptn] varchar(200)
INSERT INTO [sma_MST_NoteTypes]
([nttsCode],[nttsDscrptn],[nttsNoteText],[nttnRecUserID],[nttdDtCreated])
SELECT [CODE],[DESCRIPTION],[DESCRIPTION],368,GETDATE()FROM [WilliamPagerSaga].[dbo].[NOTETYPE]   
where  [DESCRIPTION] not in (select [nttsDscrptn] from [sma_MST_NoteTypes])


alter table [sma_TRN_Notes] disable trigger all
--Truncate table sma_trn_notes
INSERT INTO [sma_TRN_Notes]
([notnCaseID],[notnNoteTypeID],[notmDescription],[notmPlainText],[notnContactCtgID],[notnContactId],[notsPriority],[notnFormID],[notnRecUserID],[notdDtCreated],[notnModifyUserID],[notdDtModified],[notnLevelNo],[notdDtInserted],notnSubject)
select casnCaseID,nttnNoteTypeID,DESCRIPTION,isnull(note,''),[1],[2],[3],[4],[9],[5],usrnUserID,DATEREVISED,[6],[7],substring(DESCRIPTION,0,200) from (
Select  casnCaseID,nttnNoteTypeID,a.DESCRIPTION, convert(varchar(max),a.notes) as Note,case when e.cinnContactID IS NOT null then 1 when f.connContactid IS not null then 2 end as [1],case when e.cinnContactID IS NOT null then e.cinnContactID when f.connContactid IS not null then f.connContactID end as [2]
,'Normal' as [3],a.noteid as [4],case isnull((u1.usrnuserid),'') when '' then 368 else (u1.usrnuserid) end as [9],case (a.datecreated) when null then GETDATE() else (a.datecreated) end as [5],(u2.usrnuserid),(a.daterevised),'' as [6],
case (a.datecreated) when null then GETDATE() else (a.datecreated) end as [7]
FROM [WilliamPagerSaga].[dbo].[NOTE] a
Left Join [WilliamPagerSaga].[dbo].NTMATAS b on a.NOTEID=b.NOTEID
Left Join [WilliamPagerSaga].[dbo].[Matter] c on c.MATTERID=b.MATTERID
Left Join [WilliamPagerSaga].[dbo].[NOTETYPE] d on d.NOTETYPEID=a.NOTETYPEID
Left Join sma_trn_cases on c.MATTERNUMBER=cassCaseNumber
Left Join sma_MST_NoteTypes on nttsDscrptn=d.DESCRIPTION
left join sma_MST_IndvContacts e on e.cinsGrade=a.OTHERPARTYID
left join sma_MST_OrgContacts f on f.connLevelNo=a.OTHERPARTYID
left join sma_MST_IndvContacts l on l.cinsGrade=a.CREATORID
left join sma_mst_users u1 on u1.usrnContactID=l.cinnContactID
left join sma_MST_IndvContacts m on m.cinsGrade=a.REVISORID
left join sma_mst_users u2 on u2.usrnContactID=m.cinnContactID
where casnCaseID is not null)a

--Update sma_TRN_Notes 
--set notmPlainText =convert(varchar(max),ltrim(replace(
--       dbo.RegExReplace(notmPlainText,'({\\)(.+?)(})|(\\)(.+?)(\b)','')
--      ,'}','')
    
--      )) 

INSERT INTO [sma_MST_NoteTypes]
([nttsCode],[nttsDscrptn],[nttsNoteText],[nttnRecUserID],[nttdDtCreated])
SELECT 'NFEXMRSLT','No fault Exam Results','No fault Exam Results',368,GETDATE()


INSERT INTO [sma_TRN_Notes]
([notnCaseID],[notnNoteTypeID],[notmDescription],[notmPlainText],[notnContactCtgID],[notnContactId],[notsPriority],[notnFormID],[notnRecUserID],[notdDtCreated],[notnModifyUserID],[notdDtModified],[notnLevelNo],[notdDtInserted],notnSubject)
select casnCaseID,nttnNoteTypeID,DESCRIPTION,isnull(note,''),[1],[2],[3],[4],[9],[5],usrnUserID,DATEREVISED,[6],[7],DESCRIPTION from (
Select  casnCaseID,nttnNoteTypeID,a.DESCRIPTION, convert(varchar(max),ltrim(replace(
       dbo.RegExReplace(a.NOTES,'({\\)(.+?)(})|(\\)(.+?)(\b)','')
      ,'}','')
     
      )) as Note,case when e.cinnContactID IS NOT null then 1 when f.connContactid IS not null then 2 end as [1],case when e.cinnContactID IS NOT null then e.cinnContactID when f.connContactid IS not null then f.connContactID end as [2]
,'Normal' as [3],a.noteid as [4],case isnull((u1.usrnuserid),'') when '' then 368 else (u1.usrnuserid) end as [9],case (a.datecreated) when null then GETDATE() else (a.datecreated) end as [5],(u2.usrnuserid),(a.daterevised),'' as [6],
case (a.datecreated) when null then GETDATE() else (a.datecreated) end as [7]
FROM [WilliamPagerSaga].[dbo].[NOTE] a
Left Join [WilliamPagerSaga].[dbo].[Matter] c on c.STATUSCOMMENTSID=a.NOTEID
Left Join sma_trn_cases on c.MATTERNUMBER=cassCaseNumber
Left Join sma_MST_NoteTypes on nttsDscrptn='No fault Exam Results'
left join sma_MST_IndvContacts e on e.cinsGrade=a.OTHERPARTYID
left join sma_MST_OrgContacts f on f.connLevelNo=a.OTHERPARTYID
left join sma_MST_IndvContacts l on l.cinsGrade=a.CREATORID
left join sma_mst_users u1 on u1.usrnContactID=l.cinnContactID
left join sma_MST_IndvContacts m on m.cinsGrade=a.REVISORID
left join sma_mst_users u2 on u2.usrnContactID=m.cinnContactID
where a.NOTEID is not null and casnCaseID is not null)a

--Delete from sma_TRN_Notes 
--where notnNoteID not in (
--select MIN(notnNoteID)
--from sma_TRN_Notes
--left join sma_mst_users on usrnUserID=notnRecUserID
--left join sma_MST_IndvContacts on cinnContactID=usrnContactID
--Group by notncaseid,notnNoteTypeID,ltrim(rtrim(convert(varchar(max),notmPlainText))),isnull(cinsLastName,'')+ISNULL(cinsfirstname,''),convert(date,notdDtCreated

INSERT INTO [sma_MST_NoteTypes]
([nttsCode],[nttsDscrptn],[nttsNoteText],[nttnRecUserID],[nttdDtCreated])
SELECT 'QUKNOTES','Quick Note','Quick Note',368,GETDATE()

Declare @NoteTypeID int
Select @NoteTypeID=nttnNoteTypeID from sma_MST_NoteTypes where nttsNoteText='Quick Note'

INSERT INTO [sma_TRN_Notes]
([notnCaseID],[notnNoteTypeID],[notmDescription],[notmPlainText],[notnContactCtgID],[notnContactId],[notsPriority],[notnFormID],[notnRecUserID],[notdDtCreated],[notnModifyUserID],[notdDtModified],[notnLevelNo],[notdDtInserted],notnSubject)

Select distinct casncaseid,@NoteTypeID,DESCRIPTION,convert(varchar(max),ltrim(replace(
       dbo.RegExReplace(n.NOTES,'({\\)(.+?)(})|(\\)(.+?)(\b)','')
      ,'}','')      
      )) ,null,
null,'Normal',n.noteid,usrnUserID,n.DATECREATED,null,n.DATEREVISED,'',n.DATECREATED,DESCRIPTION
from  sma_trn_cases  
left join WilliamPagerSaga.dbo.MATTER m on MATTERNUMBER=cassCaseNumber
Left Join [WilliamPagerSaga].[dbo].[LW_MATTER] a on a.MATTERID=m.MATTERID
left join WilliamPagerSaga.dbo.NOTE n on n.NOTEID=a.ALERTNOTEID
left join sma_MST_IndvContacts l on l.cinsGrade=n.CREATORID
left join sma_mst_users u1 on u1.usrnContactID=l.cinnContactID
where n.NOTEID is not null


delete from sma_trn_notes where notnFormID in (select noteid From [WilliamPagerSaga].dbo.LW_log l)

update sma_trn_notes set notnFormID=null
alter table [sma_TRN_Notes] enable trigger all
go
alter table [sma_TRN_Notes] disable trigger all
Update sma_TRN_Notes 
set notmPlainText =convert(varchar(max),ltrim(replace(
       dbo.RegExReplace(notmPlainText,'({\\)(.+?)(})|(\\)(.+?)(\b)','')
      ,'}','')
    
      )) 
	  alter table [sma_TRN_Notes] enable trigger all