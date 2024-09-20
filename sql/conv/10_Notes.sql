USE WilliamPagerSA

ALTER TABLE [sma_MST_NoteTypes]
ALTER COLUMN [nttsDscrptn] VARCHAR(200)
INSERT INTO [sma_MST_NoteTypes]
	(
	[nttsCode]
   ,[nttsDscrptn]
   ,[nttsNoteText]
   ,[nttnRecUserID]
   ,[nttdDtCreated]
	)
	SELECT
		[CODE]
	   ,[DESCRIPTION]
	   ,[DESCRIPTION]
	   ,368
	   ,GETDATE()
	FROM [WilliamPagerSaga].[dbo].[NOTETYPE]
	WHERE [DESCRIPTION] NOT IN (
			SELECT
				[nttsDscrptn]
			FROM [sma_MST_NoteTypes]
		)


ALTER TABLE [sma_TRN_Notes] DISABLE TRIGGER ALL
--Truncate table sma_trn_notes
INSERT INTO [sma_TRN_Notes]
	(
	[notnCaseID]
   ,[notnNoteTypeID]
   ,[notmDescription]
   ,[notmPlainText]
   ,[notnContactCtgID]
   ,[notnContactId]
   ,[notsPriority]
   ,[notnFormID]
   ,[notnRecUserID]
   ,[notdDtCreated]
   ,[notnModifyUserID]
   ,[notdDtModified]
   ,[notnLevelNo]
   ,[notdDtInserted]
   ,notnSubject
	)
	SELECT
		casnCaseID
	   ,nttnNoteTypeID
	   ,DESCRIPTION
	   ,ISNULL(note, '')
	   ,[1]
	   ,[2]
	   ,[3]
	   ,[4]
	   ,[9]
	   ,[5]
	   ,usrnUserID
	   ,DATEREVISED
	   ,[6]
	   ,[7]
	   ,SUBSTRING(DESCRIPTION, 0, 200)
	FROM (
		SELECT
			casnCaseID
		   ,nttnNoteTypeID
		   ,a.DESCRIPTION
		   ,CONVERT(VARCHAR(MAX), a.notes) AS Note
		   ,CASE
				WHEN e.cinnContactID IS NOT NULL
					THEN 1
				WHEN f.connContactid IS NOT NULL
					THEN 2
			END AS [1]
		   ,CASE
				WHEN e.cinnContactID IS NOT NULL
					THEN e.cinnContactID
				WHEN f.connContactid IS NOT NULL
					THEN f.connContactID
			END AS [2]
		   ,'Normal' AS [3]
		   ,a.noteid AS [4]
		   ,CASE ISNULL((u1.usrnuserid), '')
				WHEN ''
					THEN 368
				ELSE (u1.usrnuserid)
			END AS [9]
		   ,CASE (a.datecreated)
				WHEN NULL
					THEN GETDATE()
				ELSE (a.datecreated)
			END AS [5]
		   ,(u2.usrnuserid)
		   ,(a.daterevised)
		   ,'' AS [6]
		   ,CASE (a.datecreated)
				WHEN NULL
					THEN GETDATE()
				ELSE (a.datecreated)
			END AS [7]
		FROM [WilliamPagerSaga].[dbo].[Note] a
		LEFT JOIN [WilliamPagerSaga].[dbo].NTMATAS b
			ON a.NOTEID = b.NOTEID
		LEFT JOIN [WilliamPagerSaga].[dbo].[Matter] c
			ON c.MATTERID = b.MATTERID
		LEFT JOIN [WilliamPagerSaga].[dbo].[NOTETYPE] d
			ON d.NOTETYPEID = a.NOTETYPEID
		LEFT JOIN sma_trn_cases
			ON c.MATTERNUMBER = cassCaseNumber
		LEFT JOIN sma_MST_NoteTypes
			ON nttsDscrptn = d.DESCRIPTION
		LEFT JOIN sma_MST_IndvContacts e
			ON e.cinsGrade = a.OTHERPARTYID
		LEFT JOIN sma_MST_OrgContacts f
			ON f.connLevelNo = a.OTHERPARTYID
		LEFT JOIN sma_MST_IndvContacts l
			ON l.cinsGrade = a.CREATORID
		LEFT JOIN sma_mst_users u1
			ON u1.usrnContactID = l.cinnContactID
		LEFT JOIN sma_MST_IndvContacts m
			ON m.cinsGrade = a.REVISORID
		LEFT JOIN sma_mst_users u2
			ON u2.usrnContactID = m.cinnContactID
		WHERE casnCaseID IS NOT NULL
	) a

--Update sma_TRN_Notes 
--set notmPlainText =convert(varchar(max),ltrim(replace(
--       dbo.RegExReplace(notmPlainText,'({\\)(.+?)(})|(\\)(.+?)(\b)','')
--      ,'}','')

--      )) 

INSERT INTO [sma_MST_NoteTypes]
	(
	[nttsCode]
   ,[nttsDscrptn]
   ,[nttsNoteText]
   ,[nttnRecUserID]
   ,[nttdDtCreated]
	)
	SELECT
		'NFEXMRSLT'
	   ,'No fault Exam Results'
	   ,'No fault Exam Results'
	   ,368
	   ,GETDATE()


INSERT INTO [sma_TRN_Notes]
	(
	[notnCaseID]
   ,[notnNoteTypeID]
   ,[notmDescription]
   ,[notmPlainText]
   ,[notnContactCtgID]
   ,[notnContactId]
   ,[notsPriority]
   ,[notnFormID]
   ,[notnRecUserID]
   ,[notdDtCreated]
   ,[notnModifyUserID]
   ,[notdDtModified]
   ,[notnLevelNo]
   ,[notdDtInserted]
   ,notnSubject
	)
	SELECT
		casnCaseID
	   ,nttnNoteTypeID
	   ,DESCRIPTION
	   ,ISNULL(note, '')
	   ,[1]
	   ,[2]
	   ,[3]
	   ,[4]
	   ,[9]
	   ,[5]
	   ,usrnUserID
	   ,DATEREVISED
	   ,[6]
	   ,[7]
	   ,DESCRIPTION
	FROM (
		SELECT
			casnCaseID
		   ,nttnNoteTypeID
		   ,a.DESCRIPTION
		   ,CONVERT(VARCHAR(MAX), LTRIM(REPLACE(
			dbo.RegExReplace(a.NOTES, '({\\)(.+?)(})|(\\)(.+?)(\b)', '')
			, '}', '')

			)) AS Note
		   ,CASE
				WHEN e.cinnContactID IS NOT NULL
					THEN 1
				WHEN f.connContactid IS NOT NULL
					THEN 2
			END AS [1]
		   ,CASE
				WHEN e.cinnContactID IS NOT NULL
					THEN e.cinnContactID
				WHEN f.connContactid IS NOT NULL
					THEN f.connContactID
			END AS [2]
		   ,'Normal' AS [3]
		   ,a.noteid AS [4]
		   ,CASE ISNULL((u1.usrnuserid), '')
				WHEN ''
					THEN 368
				ELSE (u1.usrnuserid)
			END AS [9]
		   ,CASE (a.datecreated)
				WHEN NULL
					THEN GETDATE()
				ELSE (a.datecreated)
			END AS [5]
		   ,(u2.usrnuserid)
		   ,(a.daterevised)
		   ,'' AS [6]
		   ,CASE (a.datecreated)
				WHEN NULL
					THEN GETDATE()
				ELSE (a.datecreated)
			END AS [7]
		FROM [WilliamPagerSaga].[dbo].[Note] a
		LEFT JOIN [WilliamPagerSaga].[dbo].[Matter] c
			ON c.STATUSCOMMENTSID = a.NOTEID
		LEFT JOIN sma_trn_cases
			ON c.MATTERNUMBER = cassCaseNumber
		LEFT JOIN sma_MST_NoteTypes
			ON nttsDscrptn = 'No fault Exam Results'
		LEFT JOIN sma_MST_IndvContacts e
			ON e.cinsGrade = a.OTHERPARTYID
		LEFT JOIN sma_MST_OrgContacts f
			ON f.connLevelNo = a.OTHERPARTYID
		LEFT JOIN sma_MST_IndvContacts l
			ON l.cinsGrade = a.CREATORID
		LEFT JOIN sma_mst_users u1
			ON u1.usrnContactID = l.cinnContactID
		LEFT JOIN sma_MST_IndvContacts m
			ON m.cinsGrade = a.REVISORID
		LEFT JOIN sma_mst_users u2
			ON u2.usrnContactID = m.cinnContactID
		WHERE a.NOTEID IS NOT NULL
			AND casnCaseID IS NOT NULL
	) a

--Delete from sma_TRN_Notes 
--where notnNoteID not in (
--select MIN(notnNoteID)
--from sma_TRN_Notes
--left join sma_mst_users on usrnUserID=notnRecUserID
--left join sma_MST_IndvContacts on cinnContactID=usrnContactID
--Group by notncaseid,notnNoteTypeID,ltrim(rtrim(convert(varchar(max),notmPlainText))),isnull(cinsLastName,'')+ISNULL(cinsfirstname,''),convert(date,notdDtCreated

INSERT INTO [sma_MST_NoteTypes]
	(
	[nttsCode]
   ,[nttsDscrptn]
   ,[nttsNoteText]
   ,[nttnRecUserID]
   ,[nttdDtCreated]
	)
	SELECT
		'QUKNOTES'
	   ,'Quick Note'
	   ,'Quick Note'
	   ,368
	   ,GETDATE()

DECLARE @NoteTypeID INT
SELECT
	@NoteTypeID = nttnNoteTypeID
FROM sma_MST_NoteTypes
WHERE nttsNoteText = 'Quick Note'

INSERT INTO [sma_TRN_Notes]
	(
	[notnCaseID]
   ,[notnNoteTypeID]
   ,[notmDescription]
   ,[notmPlainText]
   ,[notnContactCtgID]
   ,[notnContactId]
   ,[notsPriority]
   ,[notnFormID]
   ,[notnRecUserID]
   ,[notdDtCreated]
   ,[notnModifyUserID]
   ,[notdDtModified]
   ,[notnLevelNo]
   ,[notdDtInserted]
   ,notnSubject
	)

	SELECT DISTINCT
		casncaseid
	   ,@NoteTypeID
	   ,DESCRIPTION
	   ,CONVERT(VARCHAR(MAX), LTRIM(REPLACE(
		dbo.RegExReplace(n.NOTES, '({\\)(.+?)(})|(\\)(.+?)(\b)', '')
		, '}', '')
		))
	   ,NULL
	   ,NULL
	   ,'Normal'
	   ,n.noteid
	   ,usrnUserID
	   ,n.DATECREATED
	   ,NULL
	   ,n.DATEREVISED
	   ,''
	   ,n.DATECREATED
	   ,DESCRIPTION
	FROM sma_trn_cases
	LEFT JOIN WilliamPagerSaga.dbo.MATTER m
		ON MATTERNUMBER = cassCaseNumber
	LEFT JOIN [WilliamPagerSaga].[dbo].[LW_MATTER] a
		ON a.MATTERID = m.MATTERID
	LEFT JOIN WilliamPagerSaga.dbo.NOTE n
		ON n.NOTEID = a.ALERTNOTEID
	LEFT JOIN sma_MST_IndvContacts l
		ON l.cinsGrade = n.CREATORID
	LEFT JOIN sma_mst_users u1
		ON u1.usrnContactID = l.cinnContactID
	WHERE n.NOTEID IS NOT NULL


DELETE FROM sma_trn_notes
WHERE notnFormID IN (
		SELECT
			noteid
		FROM [WilliamPagerSaga].dbo.LW_log l
	)

UPDATE sma_trn_notes
SET notnFormID = NULL
ALTER TABLE [sma_TRN_Notes] ENABLE TRIGGER ALL
GO
ALTER TABLE [sma_TRN_Notes] DISABLE TRIGGER ALL
UPDATE sma_TRN_Notes
SET notmPlainText = CONVERT(VARCHAR(MAX), LTRIM(REPLACE(
dbo.RegExReplace(notmPlainText, '({\\)(.+?)(})|(\\)(.+?)(\b)', '')
, '}', '')

))
ALTER TABLE [sma_TRN_Notes] ENABLE TRIGGER ALL