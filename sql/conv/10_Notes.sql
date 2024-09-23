USE WilliamPagerSA

SET STATISTICS TIME ON;
SET STATISTICS IO ON;

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

-- ds 2024-09-23 create indexes to speed up query
--CREATE INDEX idx_noteid ON [WilliamPagerSaga].[dbo].[NOTE] (NOTEID);
--CREATE INDEX idx_matterid ON [WilliamPagerSaga].[dbo].[MATTER] (MATTERID);
--CREATE INDEX idx_matternumber ON sma_TRN_Cases (cassCaseNumber);

--INSERT INTO [sma_TRN_Notes]
--	(
--	[notnCaseID]
--   ,[notnNoteTypeID]
--   ,[notmDescription]
--   ,[notmPlainText]
--   ,[notnContactCtgID]
--   ,[notnContactId]
--   ,[notsPriority]
--   ,[notnFormID]
--   ,[notnRecUserID]
--   ,[notdDtCreated]
--   ,[notnModifyUserID]
--   ,[notdDtModified]
--   ,[notnLevelNo]
--   ,[notdDtInserted]
--   ,notnSubject
--	)
--	SELECT
--		casnCaseID
--	   ,nttnNoteTypeID
--	   ,DESCRIPTION
--	   ,ISNULL(NOTE, '')
--	   ,[1]
--	   ,[2]
--	   ,[3]
--	   ,[4]
--	   ,[9]
--	   ,[5]
--	   ,usrnUserID
--	   ,DATEREVISED
--	   ,[6]
--	   ,[7]
--	   ,SUBSTRING(DESCRIPTION, 0, 200)
--	FROM (
--		SELECT
--			casnCaseID
--		   ,nttnNoteTypeID
--		   ,a.DESCRIPTION
--		   ,CONVERT(VARCHAR(MAX), a.NOTES) AS Note
--		   ,CASE
--				WHEN e.cinnContactID IS NOT NULL
--					THEN 1
--				WHEN f.connContactID IS NOT NULL
--					THEN 2
--			END AS [1]
--		   ,CASE
--				WHEN e.cinnContactID IS NOT NULL
--					THEN e.cinnContactID
--				WHEN f.connContactID IS NOT NULL
--					THEN f.connContactID
--			END AS [2]
--		   ,'Normal' AS [3]
--		   ,a.NOTEID AS [4]
--		   ,CASE ISNULL((u1.usrnUserID), '')
--				WHEN ''
--					THEN 368
--				ELSE (u1.usrnUserID)
--			END AS [9]
--		   ,CASE
--				WHEN (a.DATECREATED NOT BETWEEN '1900-01-01' AND '2079-12-31')
--					THEN GETDATE()
--				ELSE (a.DATECREATED)
--			END AS [5]
--		   ,(u2.usrnUserID)
--		   ,CASE
--				WHEN (a.DATEREVISED NOT BETWEEN '1900-01-01' AND '2079-12-31')
--					THEN GETDATE()
--				ELSE (a.DATEREVISED)
--			END AS DATEREVISED
--		   ,'' AS [6]
--		   ,CASE
--				WHEN (a.DATECREATED NOT BETWEEN '1900-01-01' AND '2079-12-31')
--					THEN GETDATE()
--				ELSE (a.DATECREATED)
--			END AS [7]
--		FROM [WilliamPagerSaga].[dbo].[Note] a
--		LEFT JOIN [WilliamPagerSaga].[dbo].NTMATAS b
--			ON a.NOTEID = b.NOTEID
--		LEFT JOIN [WilliamPagerSaga].[dbo].[MATTER] c
--			ON c.MATTERID = b.MATTERID
--		LEFT JOIN [WilliamPagerSaga].[dbo].[NOTETYPE] d
--			ON d.NOTETYPEID = a.NOTETYPEID
--		LEFT JOIN sma_TRN_Cases
--			ON c.MATTERNUMBER = cassCaseNumber
--		LEFT JOIN sma_MST_NoteTypes
--			ON nttsDscrptn = d.DESCRIPTION
--		LEFT JOIN sma_MST_IndvContacts e
--			ON e.cinsGrade = a.OTHERPARTYID
--		LEFT JOIN sma_MST_OrgContacts f
--			ON f.connLevelNo = a.OTHERPARTYID
--		LEFT JOIN sma_MST_IndvContacts l
--			ON l.cinsGrade = a.CREATORID
--		LEFT JOIN sma_MST_Users u1
--			ON u1.usrnContactID = l.cinnContactID
--		LEFT JOIN sma_MST_IndvContacts m
--			ON m.cinsGrade = a.REVISORID
--		LEFT JOIN sma_MST_Users u2
--			ON u2.usrnContactID = m.cinnContactID
--		WHERE casnCaseID IS NOT NULL
--	) a

-- ds 2024-09-23 - Handle out-of-range datetime values
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
	   ,a.DESCRIPTION
	   ,ISNULL(a.NOTES, '')
	   ,CASE
			WHEN e.cinnContactID IS NOT NULL
				THEN 1
			ELSE 2
		END
	   ,CASE
			WHEN e.cinnContactID IS NOT NULL
				THEN e.cinnContactID
			ELSE f.connContactID
		END
	   ,'Normal'
	   ,a.NOTEID
	   ,COALESCE(u1.usrnUserID, 368)
	   ,CASE
			WHEN (a.DATECREATED NOT BETWEEN '1900-01-01' AND '2079-12-31')
				THEN GETDATE()
			ELSE (a.DATECREATED)
		END
	   ,u2.usrnUserID
	   ,CASE
			WHEN (a.DATEREVISED NOT BETWEEN '1900-01-01' AND '2079-12-31')
				THEN GETDATE()
			ELSE (a.DATEREVISED)
		END
	   ,''
	   ,CASE
			WHEN (a.DATECREATED NOT BETWEEN '1900-01-01' AND '2079-12-31')
				THEN GETDATE()
			ELSE (a.DATECREATED)
		END
	   ,SUBSTRING(a.DESCRIPTION, 0, 200)
	FROM [WilliamPagerSaga].[dbo].[NOTE] a
	LEFT JOIN [WilliamPagerSaga].[dbo].NTMATAS b
		ON a.NOTEID = b.NOTEID
	LEFT JOIN [WilliamPagerSaga].[dbo].[MATTER] c
		ON c.MATTERID = b.MATTERID
	LEFT JOIN [WilliamPagerSaga].[dbo].[NOTETYPE] d
		ON d.NOTETYPEID = a.NOTETYPEID
	LEFT JOIN sma_TRN_Cases
		ON c.MATTERNUMBER = cassCaseNumber
	LEFT JOIN sma_MST_NoteTypes
		ON nttsDscrptn = d.DESCRIPTION
	LEFT JOIN sma_MST_IndvContacts e
		ON e.cinsGrade = a.OTHERPARTYID
	LEFT JOIN sma_MST_OrgContacts f
		ON f.connLevelNo = a.OTHERPARTYID
	LEFT JOIN sma_MST_IndvContacts l
		ON l.cinsGrade = a.CREATORID
	LEFT JOIN sma_MST_Users u1
		ON u1.usrnContactID = l.cinnContactID
	LEFT JOIN sma_MST_IndvContacts m
		ON m.cinsGrade = a.REVISORID
	LEFT JOIN sma_MST_Users u2
		ON u2.usrnContactID = m.cinnContactID
	WHERE casnCaseID IS NOT NULL;


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
	   ,ISNULL(NOTE, '')
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
				WHEN f.connContactID IS NOT NULL
					THEN 2
			END AS [1]
		   ,CASE
				WHEN e.cinnContactID IS NOT NULL
					THEN e.cinnContactID
				WHEN f.connContactID IS NOT NULL
					THEN f.connContactID
			END AS [2]
		   ,'Normal' AS [3]
		   ,a.NOTEID AS [4]
		   ,CASE ISNULL((u1.usrnUserID), '')
				WHEN ''
					THEN 368
				ELSE (u1.usrnUserID)
			END AS [9]
		   ,CASE (a.DATECREATED)
				WHEN NULL
					THEN GETDATE()
				ELSE (a.DATECREATED)
			END AS [5]
		   ,(u2.usrnUserID)
		   ,(a.DATEREVISED)
		   ,'' AS [6]
		   ,CASE (a.DATECREATED)
				WHEN NULL
					THEN GETDATE()
				ELSE (a.DATECREATED)
			END AS [7]
		FROM [WilliamPagerSaga].[dbo].[Note] a
		LEFT JOIN [WilliamPagerSaga].[dbo].[MATTER] c
			ON c.STATUSCOMMENTSID = a.NOTEID
		LEFT JOIN sma_TRN_Cases
			ON c.MATTERNUMBER = cassCaseNumber
		LEFT JOIN sma_MST_NoteTypes
			ON nttsDscrptn = 'No fault Exam Results'
		LEFT JOIN sma_MST_IndvContacts e
			ON e.cinsGrade = a.OTHERPARTYID
		LEFT JOIN sma_MST_OrgContacts f
			ON f.connLevelNo = a.OTHERPARTYID
		LEFT JOIN sma_MST_IndvContacts l
			ON l.cinsGrade = a.CREATORID
		LEFT JOIN sma_MST_Users u1
			ON u1.usrnContactID = l.cinnContactID
		LEFT JOIN sma_MST_IndvContacts m
			ON m.cinsGrade = a.REVISORID
		LEFT JOIN sma_MST_Users u2
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
		casnCaseID
	   ,@NoteTypeID
	   ,DESCRIPTION
	   ,CONVERT(VARCHAR(MAX), LTRIM(REPLACE(
		dbo.RegExReplace(n.NOTES, '({\\)(.+?)(})|(\\)(.+?)(\b)', '')
		, '}', '')
		))
	   ,NULL
	   ,NULL
	   ,'Normal'
	   ,n.NOTEID
	   ,usrnUserID
	   ,n.DATECREATED
	   ,NULL
	   ,n.DATEREVISED
	   ,''
	   ,n.DATECREATED
	   ,DESCRIPTION
	FROM sma_TRN_Cases
	LEFT JOIN WilliamPagerSaga.dbo.MATTER m
		ON MATTERNUMBER = cassCaseNumber
	LEFT JOIN [WilliamPagerSaga].[dbo].[LW_MATTER] a
		ON a.MATTERID = m.MATTERID
	LEFT JOIN WilliamPagerSaga.dbo.NOTE n
		ON n.NOTEID = a.ALERTNOTEID
	LEFT JOIN sma_MST_IndvContacts l
		ON l.cinsGrade = n.CREATORID
	LEFT JOIN sma_MST_Users u1
		ON u1.usrnContactID = l.cinnContactID
	WHERE n.NOTEID IS NOT NULL


DELETE FROM sma_TRN_Notes
WHERE notnFormID IN (
		SELECT
			NOTEID
		FROM [WilliamPagerSaga].dbo.LW_LOG l
	)

UPDATE sma_TRN_Notes
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