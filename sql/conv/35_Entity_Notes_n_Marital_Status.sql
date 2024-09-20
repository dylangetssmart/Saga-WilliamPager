USE WilliamPagerSA

INSERT INTO sma_MST_Languages
	(
	lngsLanguageCode
   ,lngsLanguageName
   ,lngnRecUserID
   ,lngdDtCreated
	)
	SELECT
		UPPER(SUBSTRING(DESCRIPTION, 0, 5))
	   ,DESCRIPTION
	   ,368
	   ,GETDATE()
	FROM WilliamPagerSaga.dbo.[LW_A_LANGUAGE]
	WHERE LTRIM(RTRIM(DESCRIPTION))
		NOT IN (
			SELECT
				LTRIM(RTRIM(lngsLanguageName))
			FROM sma_MST_Languages
		)

ALTER TABLE sma_mst_indvcontacts
ALTER COLUMN cinsComments VARCHAR(4000)

ALTER TABLE sma_mst_indvcontacts DISABLE TRIGGER ALL
UPDATE a
SET cinsComments = LTRIM(REPLACE(
dbo.RegExReplace(CONVERT(VARCHAR(4000), NOTES), '({\\)(.+?)(})|(\\)(.+?)(\b)', '')
, '}', '')
)
FROM sma_mst_indvcontacts a
LEFT JOIN WilliamPagerSaga.dbo.ENTITIES e
	ON cinsGrade = ENTITYID
LEFT JOIN WilliamPagerSaga.dbo.NOTE n
	ON n.NOTEID = e.NOTEID
WHERE e.NOTEID IS NOT NULL

UPDATE a
SET cinnMaritalStatusID =
CASE e.MARITALSTATUS
	WHEN 0
		THEN 1
	WHEN 1
		THEN 2
	WHEN 3
		THEN 6
	WHEN 4
		THEN 4
	WHEN 5
		THEN 5
END
FROM sma_mst_indvcontacts a
LEFT JOIN WilliamPagerSaga.dbo.ENTITIES e
	ON cinsGrade = ENTITYID
WHERE e.MARITALSTATUS IS NOT NULL

UPDATE a
SET cinsPrimaryLanguage = lngsLanguageName
FROM sma_mst_indvcontacts a
LEFT JOIN WilliamPagerSaga.dbo.ENTITIES e
	ON cinsGrade = ENTITYID
LEFT JOIN WilliamPagerSaga.dbo.[LW_A_LANGUAGE] l
	ON l.LANGUAGEID = e.LANGUAGEID
LEFT JOIN sma_MST_Languages
	ON LTRIM(RTRIM(lngsLanguageName)) = LTRIM(RTRIM(l.DESCRIPTION))
WHERE e.LANGUAGEID IS NOT NULL

ALTER TABLE sma_mst_indvcontacts ENABLE TRIGGER ALL


ALTER TABLE sma_mst_orgcontacts
ALTER COLUMN consComments VARCHAR(4000)

ALTER TABLE sma_mst_orgcontacts DISABLE TRIGGER ALL
UPDATE a
SET consComments = LTRIM(REPLACE(
dbo.RegExReplace(CONVERT(VARCHAR(4000), NOTES), '({\\)(.+?)(})|(\\)(.+?)(\b)', '')
, '}', '')
)
FROM sma_mst_orgcontacts a
LEFT JOIN WilliamPagerSaga.dbo.ENTITIES e
	ON connLevelNo = ENTITYID
LEFT JOIN WilliamPagerSaga.dbo.NOTE n
	ON n.NOTEID = e.NOTEID
WHERE e.NOTEID IS NOT NULL
ALTER TABLE sma_mst_orgcontacts ENABLE TRIGGER ALL


	

