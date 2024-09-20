USE WilliamPagerSA

------------------------------Insert Email / Website Started-------------------------------------------------------------------------
ALTER TABLE [sma_MST_EmailWebsite] DISABLE TRIGGER ALL

INSERT INTO [sma_MST_EmailWebsite]
	(
	[cewnContactCtgID]
   ,[cewnContactID]
   ,[cewsEmailWebsiteFlag]
   ,[cewsEmailWebSite]
   ,[cewbDefault]
   ,[cewnRecUserID]
   ,[cewdDtCreated]
   ,[cewnModifyUserID]
   ,[cewdDtModified]
   ,[cewnLevelNo]
   ,[saga]
	)
	SELECT
		1
	   ,c.cinnContactID
	   ,'E'
	   ,EMAILADDRESS
	   ,1
	   ,CASE ISNULL(u1.usrnuserid, '')
			WHEN ''
				THEN 368
			ELSE u1.usrnuserid
		END
	   ,CASE datecreated
			WHEN NULL
				THEN GETDATE()
			ELSE datecreated
		END
	   ,u2.usrnuserid
	   ,daterevised
	   ,NULL
	   ,NULL
	FROM sma_MST_IndvContacts c
	LEFT JOIN [WilliamPagerSaga].dbo.ENTITIES
		ON LTRIM(RTRIM(c.cinsGrade)) = ENTITYID
	LEFT JOIN sma_MST_IndvContacts a
		ON a.cinsGrade = CREATORID
	LEFT JOIN sma_mst_users u1
		ON u1.usrnContactID = a.cinnContactID
	LEFT JOIN sma_MST_IndvContacts b
		ON b.cinsGrade = REVISORID
	LEFT JOIN sma_mst_users u2
		ON u2.usrnContactID = b.cinnContactID
	WHERE ISPERSON = 't'
		AND EMAILADDRESS <> ''
		AND EMAILADDRESS LIKE '%@%'
		AND c.cinncontactid IS NOT NULL

INSERT INTO [sma_MST_EmailWebsite]
	(
	[cewnContactCtgID]
   ,[cewnContactID]
   ,[cewsEmailWebsiteFlag]
   ,[cewsEmailWebSite]
   ,[cewbDefault]
   ,[cewnRecUserID]
   ,[cewdDtCreated]
   ,[cewnModifyUserID]
   ,[cewdDtModified]
   ,[cewnLevelNo]
   ,[saga]
	)
	SELECT
		1
	   ,c.cinnContactID
	   ,'E'
	   ,WEBPAGE
	   ,1
	   ,CASE ISNULL(u1.usrnuserid, '')
			WHEN ''
				THEN 368
			ELSE u1.usrnuserid
		END
	   ,CASE datecreated
			WHEN NULL
				THEN GETDATE()
			ELSE datecreated
		END
	   ,u2.usrnuserid
	   ,daterevised
	   ,NULL
	   ,NULL
	FROM sma_MST_IndvContacts c
	LEFT JOIN [WilliamPagerSaga].dbo.ENTITIES
		ON LTRIM(RTRIM(c.cinsGrade)) = ENTITYID
	LEFT JOIN sma_MST_IndvContacts a
		ON a.cinsGrade = CREATORID
	LEFT JOIN sma_mst_users u1
		ON u1.usrnContactID = a.cinnContactID
	LEFT JOIN sma_MST_IndvContacts b
		ON b.cinsGrade = REVISORID
	LEFT JOIN sma_mst_users u2
		ON u2.usrnContactID = b.cinnContactID
	WHERE ISPERSON = 't'
		AND WEBPAGE <> ''
		AND WEBPAGE LIKE '%@%'
		AND c.cinncontactid IS NOT NULL


INSERT INTO [sma_MST_EmailWebsite]
	(
	[cewnContactCtgID]
   ,[cewnContactID]
   ,[cewsEmailWebsiteFlag]
   ,[cewsEmailWebSite]
   ,[cewbDefault]
   ,[cewnRecUserID]
   ,[cewdDtCreated]
   ,[cewnModifyUserID]
   ,[cewdDtModified]
   ,[cewnLevelNo]
   ,[saga]
	)
	SELECT
		2
	   ,c.connContactID
	   ,'E'
	   ,EMAILADDRESS
	   ,1
	   ,CASE ISNULL(u1.usrnuserid, '')
			WHEN ''
				THEN 368
			ELSE u1.usrnuserid
		END
	   ,CASE datecreated
			WHEN NULL
				THEN GETDATE()
			ELSE datecreated
		END
	   ,u2.usrnuserid
	   ,daterevised
	   ,NULL
	   ,NULL
	FROM sma_MST_orgContacts c
	LEFT JOIN [WilliamPagerSaga].dbo.ENTITIES
		ON LTRIM(RTRIM(c.connLevelNo)) = ENTITYID
	LEFT JOIN sma_MST_IndvContacts a
		ON a.cinsGrade = CREATORID
	LEFT JOIN sma_mst_users u1
		ON u1.usrnContactID = a.cinnContactID
	LEFT JOIN sma_MST_IndvContacts b
		ON b.cinsGrade = REVISORID
	LEFT JOIN sma_mst_users u2
		ON u2.usrnContactID = b.cinnContactID
	WHERE ISPERSON <> 't'
		AND EMAILADDRESS <> ''
		AND EMAILADDRESS LIKE '%@%'
		AND c.conncontactid IS NOT NULL

INSERT INTO [sma_MST_EmailWebsite]
	(
	[cewnContactCtgID]
   ,[cewnContactID]
   ,[cewsEmailWebsiteFlag]
   ,[cewsEmailWebSite]
   ,[cewbDefault]
   ,[cewnRecUserID]
   ,[cewdDtCreated]
   ,[cewnModifyUserID]
   ,[cewdDtModified]
   ,[cewnLevelNo]
   ,[saga]
	)
	SELECT
		2
	   ,c.connContactID
	   ,'W'
	   ,WEBPAGE
	   ,1
	   ,CASE ISNULL(u1.usrnuserid, '')
			WHEN ''
				THEN 368
			ELSE u1.usrnuserid
		END
	   ,CASE datecreated
			WHEN NULL
				THEN GETDATE()
			ELSE datecreated
		END
	   ,u2.usrnuserid
	   ,daterevised
	   ,NULL
	   ,NULL
	FROM sma_MST_orgContacts c
	LEFT JOIN [WilliamPagerSaga].dbo.ENTITIES
		ON LTRIM(RTRIM(c.connLevelNo)) = ENTITYID
	LEFT JOIN sma_MST_IndvContacts a
		ON a.cinsGrade = CREATORID
	LEFT JOIN sma_mst_users u1
		ON u1.usrnContactID = a.cinnContactID
	LEFT JOIN sma_MST_IndvContacts b
		ON b.cinsGrade = REVISORID
	LEFT JOIN sma_mst_users u2
		ON u2.usrnContactID = b.cinnContactID
	WHERE ISPERSON <> 't'
		AND WEBPAGE <> ''
		AND c.conncontactid IS NOT NULL

ALTER TABLE [sma_MST_EmailWebsite] ENABLE TRIGGER ALL





------------------------------Insert Email / Website Finished-------------------------------------------------------------------------
GO
ALTER TABLE sma_mst_address DISABLE TRIGGER ALL
UPDATE sma_MST_Address
SET addbPrimary = 1
   ,addbIsCurrent = 1
   ,addbIsMailing = 1
WHERE addnAddressID IN (
	SELECT
		MIN(addnAddressID)
	FROM sma_MST_Address
	GROUP BY addnContactID
			,addnContactCtgID
	HAVING MIN(CONVERT(VARCHAR, addbPrimary)) = 0
)

UPDATE a
SET addsCounty = b.zpcsCounty
FROM sma_MST_Address a
OUTER APPLY (
	SELECT TOP 1
		zpcsCounty
	FROM sma_mst_ZipCodes
	WHERE zpcsZip = addsZip
) b

UPDATE sma_MST_Address
SET addnZipID = NULL
   ,addbDeleted = NULL

DELETE FROM sma_MST_Address
WHERE addnAddressID NOT IN (
		SELECT DISTINCT
			MIN(addnAddressID)
		FROM sma_MST_Address
		GROUP BY addnContactID
				,addnContactCtgID
				,addsAddress1
				,addsCity
				,addsStateCode
				,addsZip
	)
ALTER TABLE sma_mst_address ENABLE TRIGGER ALL



UPDATE sma_MST_ContactNumbers
SET cnnbPrimary = 0
WHERE cnnnContactID IN (
	SELECT DISTINCT
		cnnnContactID
	FROM sma_MST_ContactNumbers
	WHERE cnnbPrimary = 1
		AND cnnnContactCtgID = 1
	GROUP BY cnnnContactID
			,cnnbPrimary
	HAVING COUNT(cnnnContactID) > 1
	AND cnnbPrimary = 1
)
AND cnnnContactCtgID = 1
AND cnnnContactNumberID NOT IN (
	SELECT
		MAX(cnnnContactNumberID)
	FROM sma_MST_ContactNumbers
	WHERE cnnnContactID IN (
			SELECT DISTINCT
				cnnnContactID
			FROM sma_MST_ContactNumbers
			WHERE cnnbPrimary = 1
				AND cnnnContactCtgID = 1
			GROUP BY cnnnContactID
					,cnnbPrimary
			HAVING COUNT(cnnnContactID) > 1
			AND cnnbPrimary = 1
		)
		AND cnnnContactCtgID = 1
		AND cnnbPrimary = 1
	GROUP BY cnnnContactID
)

UPDATE sma_MST_ContactNumbers
SET cnnbPrimary = 0
WHERE cnnnContactID IN (
	SELECT DISTINCT
		cnnnContactID
	FROM sma_MST_ContactNumbers
	WHERE cnnbPrimary = 1
		AND cnnnContactCtgID = 2
	GROUP BY cnnnContactID
			,cnnbPrimary
	HAVING COUNT(cnnnContactID) > 1
	AND cnnbPrimary = 1
)
AND cnnnContactCtgID = 2
AND cnnnContactNumberID NOT IN (
	SELECT
		MAX(cnnnContactNumberID)
	FROM sma_MST_ContactNumbers
	WHERE cnnnContactID IN (
			SELECT DISTINCT
				cnnnContactID
			FROM sma_MST_ContactNumbers
			WHERE cnnbPrimary = 1
				AND cnnnContactCtgID = 2
			GROUP BY cnnnContactID
					,cnnbPrimary
			HAVING COUNT(cnnnContactID) > 1
			AND cnnbPrimary = 1
		)
		AND cnnnContactCtgID = 2
		AND cnnbPrimary = 1
	GROUP BY cnnnContactID
)

----Set only one primary address
UPDATE sma_MST_Address
SET addbPrimary = 0
WHERE addnContactID IN (
	SELECT DISTINCT
		addnContactID
	FROM sma_MST_Address
	WHERE addbPrimary = 1
		AND addnContactCtgID = 1
	GROUP BY addnContactID
			,addbPrimary
	HAVING COUNT(addnContactID) > 1
	AND addbPrimary = 1
)
AND addnContactCtgID = 1
AND addnAddressID NOT IN (
	SELECT
		MAX(addnAddressID)
	FROM sma_MST_Address
	WHERE addnContactID IN (
			SELECT DISTINCT
				addnContactID
			FROM sma_MST_Address
			WHERE addbPrimary = 1
				AND addnContactCtgID = 1
			GROUP BY addnContactID
					,addbPrimary
			HAVING COUNT(addnContactID) > 1
			AND addbPrimary = 1
		)
		AND addnContactCtgID = 1
		AND addbPrimary = 1
	GROUP BY addnContactID
)

UPDATE sma_MST_Address
SET addbPrimary = 0
WHERE addnContactID IN (
	SELECT DISTINCT
		addnContactID
	FROM sma_MST_Address
	WHERE addbPrimary = 1
		AND addnContactCtgID = 2
	GROUP BY addnContactID
			,addbPrimary
	HAVING COUNT(addnContactID) > 1
	AND addbPrimary = 1
)
AND addnContactCtgID = 2
AND addnAddressID NOT IN (
	SELECT
		MAX(addnAddressID)
	FROM sma_MST_Address
	WHERE addnContactID IN (
			SELECT DISTINCT
				addnContactID
			FROM sma_MST_Address
			WHERE addbPrimary = 1
				AND addnContactCtgID = 2
			GROUP BY addnContactID
					,addbPrimary
			HAVING COUNT(addnContactID) > 1
			AND addbPrimary = 1
		)
		AND addnContactCtgID = 2
		AND addbPrimary = 1
	GROUP BY addnContactID
)
