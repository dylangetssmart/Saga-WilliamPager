USE WilliamPagerSA

SET ANSI_WARNINGS OFF
GO
ALTER TABLE [sma_MST_Address]
ALTER COLUMN [addsAddressType] VARCHAR(1000)
GO
INSERT INTO [sma_MST_AddressTypes]
	(
	[addsCode]
   ,[addsDscrptn]
   ,[addnContactCategoryID]
   ,[addbIsWork]
   ,[addnRecUserID]
   ,[adddDtCreated]
   ,[addnModifyUserID]
   ,[adddDtModified]
   ,[addnLevelNo]
	)
	SELECT
		''
	   ,ADDRDESCRIPTION
	   ,1
	   ,0
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM [WilliamPagerSaga].[dbo].[ADDRDESC]
	WHERE ADDRDESCRIPTION NOT IN (
			SELECT
				[addsDscrptn]
			FROM [sma_MST_AddressTypes]
			WHERE [addnContactCategoryID] = 1
		)
GO
INSERT INTO [sma_MST_AddressTypes]
	(
	[addsCode]
   ,[addsDscrptn]
   ,[addnContactCategoryID]
   ,[addbIsWork]
   ,[addnRecUserID]
   ,[adddDtCreated]
   ,[addnModifyUserID]
   ,[adddDtModified]
   ,[addnLevelNo]
	)
	SELECT
		''
	   ,ADDRDESCRIPTION
	   ,2
	   ,0
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM [WilliamPagerSaga].[dbo].[ADDRDESC]
	WHERE ADDRDESCRIPTION NOT IN (
			SELECT
				[addsDscrptn]
			FROM [sma_MST_AddressTypes]
			WHERE [addnContactCategoryID] = 2
		)
GO
------------------------------Insert Address Started-------------------------------------------------------------------------
ALTER TABLE [sma_MST_Address] DISABLE TRIGGER ALL
INSERT INTO [sma_MST_Address]
	(
	[addnContactCtgID]
   ,[addnContactID]
   ,[addnAddressTypeID]
   ,[addsAddressType]
   ,[addsAddTypeCode]
   ,[addsAddress1]
   ,[addsAddress2]
   ,[addsAddress3]
   ,[addsStateCode]
   ,[addsCity]
   ,[addnZipID]
   ,[addsZip]
   ,[addsCounty]
   ,[addsCountry]
   ,[addbIsResidence]
   ,[addbPrimary]
   ,[adddFromDate]
   ,[adddToDate]
   ,[addnCompanyID]
   ,[addsDepartment]
   ,[addsTitle]
   ,[addnContactPersonID]
   ,[addsComments]
   ,[addbIsCurrent]
   ,[addbIsMailing]
   ,[addnRecUserID]
   ,[adddDtCreated]
   ,[addnModifyUserID]
   ,[adddDtModified]
   ,[addnLevelNo]
   ,[caseno]
   ,[addbDeleted]
   ,[addsZipExtn]
   ,[saga]
	)
	SELECT
		1
	   ,c.cinnContactID
	   ,CASE
			WHEN addnAddTypeID IS NOT NULL
				THEN addnAddTypeID
			ELSE 10
		END
	   ,ads.ADDRDESCRIPTION
	   ,CASE
			WHEN addsCode IS NOT NULL
				THEN addsCode
			ELSE 'OTH'
		END
	   ,SUBSTRING(ADDRLINE1, 0, 75)
	   ,SUBSTRING(ADDRLINE2, 0, 75)
	   ,SUBSTRING(ADDRLINE3, 0, 75)
	   ,SUBSTRING(ADDRSTATE, 0, 20)
	   ,SUBSTRING(ADDRCITY, 0, 50)
	   ,''
	   ,SUBSTRING(ADDRZIPCODE, 0, 6)
	   ,SUBSTRING(ADDRCOUNTY, 0, 30)
	   ,SUBSTRING(ADDRCOUNTRY, 0, 30)
	   ,CASE
			WHEN PRIMARYADDR IS NOT NULL
				THEN 1
			ELSE 0
		END
	   ,CASE
			WHEN PRIMARYADDR IS NOT NULL
				THEN 1
			ELSE 0
		END
	   ,CASE ad.datecreated
			WHEN NULL
				THEN GETDATE()
			ELSE ad.datecreated
		END
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   --,EXTERNAL_REFERENCE_ID					-- ds 2024-09-20
	   ,null
	   ,CASE
			WHEN PRIMARYADDR IS NOT NULL
				THEN 1
			ELSE 0
		END
	   ,CASE
			WHEN PRIMARYADDR IS NOT NULL
				THEN 1
			ELSE 0
		END
	   ,CASE ISNULL(u1.usrnuserid, '')
			WHEN ''
				THEN 368
			ELSE u1.usrnuserid
		END
	   ,CASE ad.datecreated
			WHEN NULL
				THEN GETDATE()
			ELSE ad.datecreated
		END
	   ,u2.usrnuserid
	   ,ad.daterevised
	   ,''
	   ,''
	   ,NULL
	   ,CASE
			WHEN ADDRZIPCODE LIKE '%-%'
				THEN SUBSTRING(ADDRZIPCODE, CHARINDEX('-', ADDRZIPCODE) + 1, LEN(ADDRZIPCODE))
			ELSE ''
		END
	   ,''
	FROM [WilliamPagerSaga].[dbo].[Address] ad
	LEFT JOIN [WilliamPagerSaga].[dbo].[ADDRDESC] ads
		ON ads.[ADDRDESCRIPTIONID] = ad.ADDRDESCRIPTION
	LEFT JOIN sma_MST_AddressTypes
		ON addsDscrptn = ads.ADDRDESCRIPTION
			AND [addnContactCategoryID] = 1
	LEFT JOIN [WilliamPagerSaga].[dbo].[ENTITIES] en
		ON ad.ENTITYID = en.ENTITYID
	LEFT JOIN sma_MST_IndvContacts c
		ON c.cinsGrade = ad.ENTITYID
	LEFT JOIN sma_MST_IndvContacts a
		ON a.cinsGrade = ad.CREATORID
	LEFT JOIN sma_mst_users u1
		ON u1.usrnContactID = a.cinnContactID
	LEFT JOIN sma_MST_IndvContacts b
		ON b.cinsGrade = ad.REVISORID
	LEFT JOIN sma_mst_users u2
		ON u2.usrnContactID = b.cinnContactID
	WHERE ISPERSON = 't'
		AND c.cinncontactid IS NOT NULL

--select distinct *   FROM [Needles].[DBA].[multi_addresses]
INSERT INTO [sma_MST_Address]
	(
	[addnContactCtgID]
   ,[addnContactID]
   ,[addnAddressTypeID]
   ,[addsAddressType]
   ,[addsAddTypeCode]
   ,[addsAddress1]
   ,[addsAddress2]
   ,[addsAddress3]
   ,[addsStateCode]
   ,[addsCity]
   ,[addnZipID]
   ,[addsZip]
   ,[addsCounty]
   ,[addsCountry]
   ,[addbIsResidence]
   ,[addbPrimary]
   ,[adddFromDate]
   ,[adddToDate]
   ,[addnCompanyID]
   ,[addsDepartment]
   ,[addsTitle]
   ,[addnContactPersonID]
   ,[addsComments]
   ,[addbIsCurrent]
   ,[addbIsMailing]
   ,[addnRecUserID]
   ,[adddDtCreated]
   ,[addnModifyUserID]
   ,[adddDtModified]
   ,[addnLevelNo]
   ,[caseno]
   ,[addbDeleted]
   ,[addsZipExtn]
   ,[saga]
	)
	SELECT
		2
	   ,c.connContactID
	   ,CASE
			WHEN addnAddTypeID IS NOT NULL
				THEN addnAddTypeID
			ELSE 12
		END
	   ,ads.ADDRDESCRIPTION
	   ,CASE
			WHEN addsCode IS NOT NULL
				THEN addsCode
			ELSE 'BRA'
		END
	   ,SUBSTRING(ADDRLINE1, 0, 75)
	   ,SUBSTRING(ADDRLINE2, 0, 75)
	   ,SUBSTRING(ADDRLINE3, 0, 75)
	   ,SUBSTRING(ADDRSTATE, 0, 20)
	   ,SUBSTRING(ADDRCITY, 0, 50)
	   ,''
	   ,SUBSTRING(ADDRZIPCODE, 0, 6)
	   ,SUBSTRING(ADDRCOUNTY, 0, 30)
	   ,SUBSTRING(ADDRCOUNTRY, 0, 30)
	   ,0
	   ,CASE
			WHEN PRIMARYADDR IS NOT NULL
				THEN 1
			ELSE 0
		END
	   ,CASE ad.datecreated
			WHEN NULL
				THEN GETDATE()
			ELSE ad.datecreated
		END
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
--	   ,EXTERNAL_REFERENCE_ID						-- ds 2024-09-20
		,null
	   ,CASE
			WHEN PRIMARYADDR IS NOT NULL
				THEN 1
			ELSE 0
		END
	   ,CASE
			WHEN PRIMARYADDR IS NOT NULL
				THEN 1
			ELSE 0
		END
	   ,CASE ISNULL(u1.usrnuserid, '')
			WHEN ''
				THEN 368
			ELSE u1.usrnuserid
		END
	   ,CASE ad.datecreated
			WHEN NULL
				THEN GETDATE()
			ELSE ad.datecreated
		END
	   ,u2.usrnuserid
	   ,ad.daterevised
	   ,''
	   ,''
	   ,NULL
	   ,CASE
			WHEN ADDRZIPCODE LIKE '%-%'
				THEN SUBSTRING(ADDRZIPCODE, CHARINDEX('-', ADDRZIPCODE) + 1, LEN(ADDRZIPCODE))
			ELSE ''
		END
	   ,''
	FROM [WilliamPagerSaga].[dbo].[Address] ad
	LEFT JOIN [WilliamPagerSaga].[dbo].[ENTITIES] en
		ON ad.ENTITYID = en.ENTITYID
	LEFT JOIN [WilliamPagerSaga].[dbo].[ADDRDESC] ads
		ON ads.[ADDRDESCRIPTIONID] = ad.ADDRDESCRIPTION
	LEFT JOIN sma_MST_AddressTypes
		ON addsDscrptn = ads.ADDRDESCRIPTION
			AND [addnContactCategoryID] = 2
	LEFT JOIN sma_MST_OrgContacts c
		ON c.connLevelNo = ad.ENTITYID
	LEFT JOIN sma_MST_IndvContacts a
		ON a.cinsGrade = ad.CREATORID
	LEFT JOIN sma_mst_users u1
		ON u1.usrnContactID = a.cinnContactID
	LEFT JOIN sma_MST_IndvContacts b
		ON b.cinsGrade = ad.REVISORID
	LEFT JOIN sma_mst_users u2
		ON u2.usrnContactID = b.cinnContactID
	WHERE ISPERSON <> 't'
		AND c.conncontactid IS NOT NULL

INSERT INTO [sma_MST_Address]
	(
	[addnContactCtgID]
   ,[addnContactID]
   ,[addnAddressTypeID]
   ,[addsAddressType]
   ,[addsAddTypeCode]
   ,[addsAddress1]
   ,[addsAddress2]
   ,[addsAddress3]
   ,[addsStateCode]
   ,[addsCity]
   ,[addnZipID]
   ,[addsZip]
   ,[addsCounty]
   ,[addsCountry]
   ,[addbIsResidence]
   ,[addbPrimary]
   ,[adddFromDate]
   ,[adddToDate]
   ,[addnCompanyID]
   ,[addsDepartment]
   ,[addsTitle]
   ,[addnContactPersonID]
   ,[addsComments]
   ,[addbIsCurrent]
   ,[addbIsMailing]
   ,[addnRecUserID]
   ,[adddDtCreated]
   ,[addnModifyUserID]
   ,[adddDtModified]
   ,[addnLevelNo]
   ,[caseno]
   ,[addbDeleted]
   ,[addsZipExtn]
   ,[saga]
	)
	SELECT
		1
	   ,c.cinnContactID
	   ,10
	   ,'Other'
	   ,'OTH'
	   ,''
	   ,''
	   ,''
	   ,''
	   ,''
	   ,''
	   ,''
	   ,''
	   ,''
	   ,1
	   ,1
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,''
	   ,1
	   ,1
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	   ,''
	   ,NULL
	   ,''
	   ,''
	FROM sma_MST_IndvContacts c
	WHERE cinnContactID NOT IN (
			SELECT
				addnContactID
			FROM sma_MST_Address
			WHERE addnContactCtgID = 1
		)
	UNION
	SELECT
		2
	   ,c.connContactID
	   ,12
	   ,'Branch Office 2'
	   ,'BRA'
	   ,''
	   ,''
	   ,''
	   ,''
	   ,''
	   ,''
	   ,''
	   ,''
	   ,''
	   ,1
	   ,1
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,''
	   ,1
	   ,1
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	   ,''
	   ,NULL
	   ,''
	   ,''
	FROM sma_MST_orgContacts c
	WHERE connContactID NOT IN (
			SELECT
				addnContactID
			FROM sma_MST_Address
			WHERE addnContactCtgID = 2
		)


UPDATE sma_MST_Address
SET addbPrimary = 0
   ,addbIsMailing = 0

UPDATE sma_MST_Address
SET addbPrimary = 1
   ,addbIsMailing = 1
WHERE addnAddressID IN (
	SELECT
		MIN(addnaddressid)
	FROM sma_MST_Address
	WHERE CAST(addnContactID AS VARCHAR) + CAST(addnContactCtgID AS VARCHAR) IN (
			SELECT DISTINCT
				CAST(addnContactID AS VARCHAR) + CAST(addnContactCtgID AS VARCHAR)
			FROM sma_MST_Address
			WHERE addbPrimary = 0
			GROUP BY addnContactID
					,addnContactCtgID
			HAVING COUNT(addnContactID) > 1
		)
	GROUP BY addnContactID
			,addnContactCtgID
)
ALTER TABLE [sma_MST_Address] ENABLE TRIGGER ALL
