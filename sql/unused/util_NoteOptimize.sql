USE WilliamPagerSA
GO

SET STATISTICS TIME ON;
SET STATISTICS IO ON;

-- gemini
WITH SourceData AS (
    SELECT
        casnCaseID,
        nttnNoteTypeID,
        a.DESCRIPTION,
        CONVERT(VARCHAR(MAX), a.notes) AS Note,
        CASE WHEN e.cinnContactID IS NOT NULL THEN 1 ELSE 2 END AS ContactCtgID,
        CASE WHEN e.cinnContactID IS NOT NULL THEN e.cinnContactID ELSE f.connContactID END AS ContactID,
        'Normal' AS Priority,
        a.noteid AS FormID,
        COALESCE(u1.usrnuserid, 368) AS RecUserID,
        COALESCE(a.datecreated, GETDATE()) AS DtCreated,
        u2.usrnuserid AS ModifyUserID,
        COALESCE(a.daterevised, GETDATE()) AS DtModified,
        '' AS LevelNo,
        COALESCE(a.datecreated, GETDATE()) AS DtInserted,
        SUBSTRING(a.DESCRIPTION, 0, 200) AS Subject
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
)
INSERT INTO [sma_TRN_Notes]
(
    [notnCaseID],
    [notnNoteTypeID],
    [notmDescription],
    [notmPlainText],
    [notnContactCtgID],
    [notnContactId],
    [notsPriority],
    [notnFormID],
    [notnRecUserID],
    [notdDtCreated],
    [notnModifyUserID],
    [notdDtModified],
    [notnLevelNo],
    [notdDtInserted],
    notnSubject
)
SELECT * FROM SourceData;


-- chatgpt
INSERT INTO [sma_TRN_Notes]
(
	[notnCaseID],
	[notnNoteTypeID],
	[notmDescription],
	[notmPlainText],
	[notnContactCtgID],
	[notnContactId],
	[notsPriority],
	[notnFormID],
	[notnRecUserID],
	[notdDtCreated],
	[notnModifyUserID],
	[notdDtModified],
	[notnLevelNo],
	[notdDtInserted],
	[notnSubject]
)
SELECT
	casnCaseID,
	nttnNoteTypeID,
	DESCRIPTION,
	ISNULL(Note, ''),
	CASE WHEN e.cinnContactID IS NOT NULL THEN 1 ELSE 2 END,   -- Optimized CASE
	COALESCE(e.cinnContactID, f.connContactID),               -- Simplified with COALESCE
	'Normal',                                                  -- Static value
	a.noteid,
	ISNULL(u1.usrnuserid, 368),                                -- Use ISNULL directly
	ISNULL(a.datecreated, GETDATE()),                          -- Simplified ISNULL for date handling
	u2.usrnuserid,
	a.daterevised,
	'',                                                        -- Static value
	ISNULL(a.datecreated, GETDATE()),                          -- Simplified ISNULL for date handling
	LEFT(DESCRIPTION, 200)                                     -- Use LEFT instead of SUBSTRING
FROM
	[WilliamPagerSaga].[dbo].[Note] a
	LEFT JOIN [WilliamPagerSaga].[dbo].NTMATAS b ON a.NOTEID = b.NOTEID
	LEFT JOIN [WilliamPagerSaga].[dbo].[Matter] c ON c.MATTERID = b.MATTERID
	LEFT JOIN [WilliamPagerSaga].[dbo].[NOTETYPE] d ON d.NOTETYPEID = a.NOTETYPEID
	LEFT JOIN sma_trn_cases ON c.MATTERNUMBER = cassCaseNumber
	LEFT JOIN sma_MST_NoteTypes ON nttsDscrptn = d.DESCRIPTION
	LEFT JOIN sma_MST_IndvContacts e ON e.cinsGrade = a.OTHERPARTYID
	LEFT JOIN sma_MST_OrgContacts f ON f.connLevelNo = a.OTHERPARTYID
	LEFT JOIN sma_MST_IndvContacts l ON l.cinsGrade = a.CREATORID
	LEFT JOIN sma_mst_users u1 ON u1.usrnContactID = l.cinnContactID
	LEFT JOIN sma_MST_IndvContacts m ON m.cinsGrade = a.REVISORID
	LEFT JOIN sma_mst_users u2 ON u2.usrnContactID = m.cinnContactID
WHERE
	casnCaseID IS NOT NULL;

