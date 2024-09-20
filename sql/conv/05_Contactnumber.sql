USE WilliamPagerSA

------------------------------Insert Phone Numbers Started-------------------------------------------------------------------------

ALTER TABLE [sma_MST_ContactNumbers] DISABLE TRIGGER ALL
INSERT INTO [sma_MST_ContactNumbers]
	(
	[cnnnContactCtgID]
   ,[cnnnContactID]
   ,[cnnnPhoneTypeID]
   ,[cnnsContactNumber]
   ,[cnnsExtension]
   ,[cnnbPrimary]
   ,[cnnbVisible]
   ,[cnnnAddressID]
   ,[cnnsLabelCaption]
   ,[cnnnRecUserID]
   ,[cnndDtCreated]
   ,[cnnnModifyUserID]
   ,[cnndDtModified]
   ,[cnnnLevelNo]
   ,[caseNo]
   ,[saga]
	)
	SELECT
		1
	   ,c.cinnContactID
	   ,1
	   ,CASE
			WHEN LEN(PHONE) > 2
				THEN ISNULL('(' + LEFT(REPLACE(LTRIM(SUBSTRING(dbo.[RemoveAlphaCharactersN](phone), 0, 11)), '-', ''), 3) + ') ' + SUBSTRING(REPLACE(REPLACE(SUBSTRING(dbo.[RemoveAlphaCharactersN](phone), 0, 11), '-', ''), ' ', ''), 4, 3) + '-' + RIGHT(REPLACE(REPLACE(SUBSTRING(dbo.[RemoveAlphaCharactersN](phone), 0, 11), '-', ''), ' ', ''), 4), '')
			ELSE NULL
		END
	   ,PHONEEXT
	   ,1
	   ,1
	   ,addnaddressid
	   ,'Home 1'
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
	   ,NULL
	FROM sma_MST_IndvContacts c
	LEFT JOIN [WilliamPagerSaga].[dbo].[ENTITIES]
		ON LTRIM(RTRIM(c.cinsGrade)) = ENTITYID
	OUTER APPLY (
		SELECT TOP 1
			addnaddressid
		   ,addsAddress1
		   ,addsAddress2
		   ,addsAddress3
		   ,addsCity
		   ,addsStateCode
		   ,addsZip
		FROM sma_MST_Address
		WHERE addnContactID = cinnContactID
			AND addnContactCtgID = 1
		ORDER BY ISNULL(addbPrimary, 0) DESC
	) e
	LEFT JOIN sma_MST_IndvContacts a
		ON a.cinsGrade = CREATORID
	LEFT JOIN sma_mst_users u1
		ON u1.usrnContactID = a.cinnContactID
	LEFT JOIN sma_MST_IndvContacts b
		ON b.cinsGrade = REVISORID
	LEFT JOIN sma_mst_users u2
		ON u2.usrnContactID = b.cinnContactID
	WHERE ISPERSON = 't'
		AND LEN(PHONE) > 2
		AND c.cinncontactid IS NOT NULL

INSERT INTO [sma_MST_ContactNumbers]
	(
	[cnnnContactCtgID]
   ,[cnnnContactID]
   ,[cnnnPhoneTypeID]
   ,[cnnsContactNumber]
   ,[cnnsExtension]
   ,[cnnbPrimary]
   ,[cnnbVisible]
   ,[cnnnAddressID]
   ,[cnnsLabelCaption]
   ,[cnnnRecUserID]
   ,[cnndDtCreated]
   ,[cnnnModifyUserID]
   ,[cnndDtModified]
   ,[cnnnLevelNo]
   ,[caseNo]
   ,[saga]
	)
	SELECT
		1
	   ,c.cinnContactID
	   ,29
	   ,CASE
			WHEN LEN(MOBILEPHONE) > 2
				THEN ISNULL('(' + LEFT(REPLACE(LTRIM(SUBSTRING(dbo.[RemoveAlphaCharactersN](MOBILEPHONE), 0, 11)), '-', ''), 3) + ') ' + SUBSTRING(REPLACE(REPLACE(SUBSTRING(dbo.[RemoveAlphaCharactersN](MOBILEPHONE), 0, 11), '-', ''), ' ', ''), 4, 3) + '-' + RIGHT(REPLACE(REPLACE(SUBSTRING(dbo.[RemoveAlphaCharactersN](MOBILEPHONE), 0, 11), '-', ''), ' ', ''), 4), '')
			ELSE NULL
		END
	   ,MOBILEEXT
	   ,CASE
			WHEN LEN(PHONE) > 2
				THEN 0
			ELSE 1
		END
	   ,1
	   ,addnaddressid
	   ,'Cell Phone'
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
	   ,NULL
	FROM sma_MST_IndvContacts c
	LEFT JOIN [WilliamPagerSaga].[dbo].[ENTITIES]
		ON LTRIM(RTRIM(c.cinsGrade)) = ENTITYID
	OUTER APPLY (
		SELECT TOP 1
			addnaddressid
		   ,addsAddress1
		   ,addsAddress2
		   ,addsAddress3
		   ,addsCity
		   ,addsStateCode
		   ,addsZip
		FROM sma_MST_Address
		WHERE addnContactID = cinnContactID
			AND addnContactCtgID = 1
		ORDER BY ISNULL(addbPrimary, 0) DESC
	) e
	LEFT JOIN sma_MST_IndvContacts a
		ON a.cinsGrade = CREATORID
	LEFT JOIN sma_mst_users u1
		ON u1.usrnContactID = a.cinnContactID
	LEFT JOIN sma_MST_IndvContacts b
		ON b.cinsGrade = REVISORID
	LEFT JOIN sma_mst_users u2
		ON u2.usrnContactID = b.cinnContactID
	WHERE ISPERSON = 't'
		AND LEN(MOBILEPHONE) > 2
		AND c.cinncontactid IS NOT NULL

INSERT INTO [sma_MST_ContactNumbers]
	(
	[cnnnContactCtgID]
   ,[cnnnContactID]
   ,[cnnnPhoneTypeID]
   ,[cnnsContactNumber]
   ,[cnnsExtension]
   ,[cnnbPrimary]
   ,[cnnbVisible]
   ,[cnnnAddressID]
   ,[cnnsLabelCaption]
   ,[cnnnRecUserID]
   ,[cnndDtCreated]
   ,[cnnnModifyUserID]
   ,[cnndDtModified]
   ,[cnnnLevelNo]
   ,[caseNo]
   ,[saga]
	)
	SELECT
		1
	   ,c.cinnContactID
	   ,1
	   ,CASE
			WHEN LEN(ADDRPHONE) > 2
				THEN ISNULL('(' + LEFT(REPLACE(LTRIM(SUBSTRING(dbo.[RemoveAlphaCharactersN](ADDRPHONE), 0, 11)), '-', ''), 3) + ') ' + SUBSTRING(REPLACE(REPLACE(SUBSTRING(dbo.[RemoveAlphaCharactersN](ADDRPHONE), 0, 11), '-', ''), ' ', ''), 4, 3) + '-' + RIGHT(REPLACE(REPLACE(SUBSTRING(dbo.[RemoveAlphaCharactersN](ADDRPHONE), 0, 11), '-', ''), ' ', ''), 4), '')
			ELSE NULL
		END
	   ,ADDRPHONEEXT
	   ,CASE
			WHEN LEN(PHONE) > 2
				THEN 0
			WHEN LEN(MOBILEPHONE) > 0
				THEN 0
			ELSE 1
		END
	   ,1
	   ,addnaddressid
	   ,'Home 1'
	   ,CASE ISNULL(u1.usrnuserid, '')
			WHEN ''
				THEN 368
			ELSE u1.usrnuserid
		END
	   ,CASE f.datecreated
			WHEN NULL
				THEN GETDATE()
			ELSE f.datecreated
		END
	   ,u2.usrnuserid
	   ,f.daterevised
	   ,NULL
	   ,NULL
	   ,NULL
	FROM sma_MST_IndvContacts c
	LEFT JOIN [WilliamPagerSaga].[dbo].[address] f
		ON LTRIM(RTRIM(c.cinsGrade)) = f.ENTITYID
	LEFT JOIN [WilliamPagerSaga].[dbo].[ENTITIES] g
		ON f.ENTITYID = g.ENTITYID
	OUTER APPLY (
		SELECT TOP 1
			addnaddressid
		   ,addsAddress1
		   ,addsAddress2
		   ,addsAddress3
		   ,addsCity
		   ,addsStateCode
		   ,addsZip
		FROM sma_MST_Address
		WHERE addnContactID = cinnContactID
			AND addnContactCtgID = 1
		ORDER BY ISNULL(addbPrimary, 0) DESC
	) e
	LEFT JOIN sma_MST_IndvContacts a
		ON a.cinsGrade = f.CREATORID
	LEFT JOIN sma_mst_users u1
		ON u1.usrnContactID = a.cinnContactID
	LEFT JOIN sma_MST_IndvContacts b
		ON b.cinsGrade = f.REVISORID
	LEFT JOIN sma_mst_users u2
		ON u2.usrnContactID = b.cinnContactID
	WHERE ISPERSON = 't'
		AND LEN(ADDRPHONE) > 2
		AND c.cinncontactid IS NOT NULL

INSERT INTO [sma_MST_ContactNumbers]
	(
	[cnnnContactCtgID]
   ,[cnnnContactID]
   ,[cnnnPhoneTypeID]
   ,[cnnsContactNumber]
   ,[cnnsExtension]
   ,[cnnbPrimary]
   ,[cnnbVisible]
   ,[cnnnAddressID]
   ,[cnnsLabelCaption]
   ,[cnnnRecUserID]
   ,[cnndDtCreated]
   ,[cnnnModifyUserID]
   ,[cnndDtModified]
   ,[cnnnLevelNo]
   ,[caseNo]
   ,[saga]
	)
	SELECT
		1
	   ,c.cinnContactID
	   ,16
	   ,CASE
			WHEN LEN(ADDRDATA) > 2
				THEN ISNULL('(' + LEFT(REPLACE(LTRIM(SUBSTRING(dbo.[RemoveAlphaCharactersN](ADDRDATA), 0, 11)), '-', ''), 3) + ') ' + SUBSTRING(REPLACE(REPLACE(SUBSTRING(dbo.[RemoveAlphaCharactersN](ADDRDATA), 0, 11), '-', ''), ' ', ''), 4, 3) + '-' + RIGHT(REPLACE(REPLACE(SUBSTRING(dbo.[RemoveAlphaCharactersN](ADDRDATA), 0, 11), '-', ''), ' ', ''), 4), '')
			ELSE NULL
		END
	   ,''
	   ,CASE
			WHEN LEN(PHONE) > 2
				THEN 0
			WHEN LEN(MOBILEPHONE) > 0
				THEN 0
			WHEN LEN(ADDRPHONE) > 2
				THEN 0
			ELSE 1
		END
	   ,1
	   ,addnaddressid
	   ,'Work 2'
	   ,CASE ISNULL(u1.usrnuserid, '')
			WHEN ''
				THEN 368
			ELSE u1.usrnuserid
		END
	   ,CASE f.datecreated
			WHEN NULL
				THEN GETDATE()
			ELSE f.datecreated
		END
	   ,u2.usrnuserid
	   ,f.daterevised
	   ,NULL
	   ,NULL
	   ,NULL
	FROM sma_MST_IndvContacts c
	LEFT JOIN [WilliamPagerSaga].[dbo].[address] f
		ON LTRIM(RTRIM(c.cinsGrade)) = f.ENTITYID
	LEFT JOIN [WilliamPagerSaga].[dbo].[ENTITIES] g
		ON f.ENTITYID = g.ENTITYID
	OUTER APPLY (
		SELECT TOP 1
			addnaddressid
		   ,addsAddress1
		   ,addsAddress2
		   ,addsAddress3
		   ,addsCity
		   ,addsStateCode
		   ,addsZip
		FROM sma_MST_Address
		WHERE addnContactID = cinnContactID
			AND addnContactCtgID = 1
		ORDER BY ISNULL(addbPrimary, 0) DESC
	) e
	LEFT JOIN sma_MST_IndvContacts a
		ON a.cinsGrade = f.CREATORID
	LEFT JOIN sma_mst_users u1
		ON u1.usrnContactID = a.cinnContactID
	LEFT JOIN sma_MST_IndvContacts b
		ON b.cinsGrade = f.REVISORID
	LEFT JOIN sma_mst_users u2
		ON u2.usrnContactID = b.cinnContactID
	WHERE ISPERSON = 't'
		AND LEN(ADDRDATA) > 2
		AND c.cinncontactid IS NOT NULL

INSERT INTO [sma_MST_ContactNumbers]
	(
	[cnnnContactCtgID]
   ,[cnnnContactID]
   ,[cnnnPhoneTypeID]
   ,[cnnsContactNumber]
   ,[cnnsExtension]
   ,[cnnbPrimary]
   ,[cnnbVisible]
   ,[cnnnAddressID]
   ,[cnnsLabelCaption]
   ,[cnnnRecUserID]
   ,[cnndDtCreated]
   ,[cnnnModifyUserID]
   ,[cnndDtModified]
   ,[cnnnLevelNo]
   ,[caseNo]
   ,[saga]
	)
	SELECT
		1
	   ,c.cinnContactID
	   ,25
	   ,CASE
			WHEN LEN(ADDRFAX) > 2
				THEN ISNULL('(' + LEFT(REPLACE(LTRIM(SUBSTRING(dbo.[RemoveAlphaCharactersN](ADDRFAX), 0, 11)), '-', ''), 3) + ') ' + SUBSTRING(REPLACE(REPLACE(SUBSTRING(dbo.[RemoveAlphaCharactersN](ADDRFAX), 0, 11), '-', ''), ' ', ''), 4, 3) + '-' + RIGHT(REPLACE(REPLACE(SUBSTRING(dbo.[RemoveAlphaCharactersN](ADDRFAX), 0, 11), '-', ''), ' ', ''), 4), '')
			ELSE NULL
		END
	   ,''
	   ,0
	   ,1
	   ,addnaddressid
	   ,'Home Fax'
	   ,CASE ISNULL(u1.usrnuserid, '')
			WHEN ''
				THEN 368
			ELSE u1.usrnuserid
		END
	   ,CASE f.datecreated
			WHEN NULL
				THEN GETDATE()
			ELSE f.datecreated
		END
	   ,u2.usrnuserid
	   ,f.daterevised
	   ,NULL
	   ,NULL
	   ,NULL
	FROM sma_MST_IndvContacts c
	LEFT JOIN [WilliamPagerSaga].[dbo].[address] f
		ON LTRIM(RTRIM(c.cinsGrade)) = f.ENTITYID
	LEFT JOIN [WilliamPagerSaga].[dbo].[ENTITIES] g
		ON f.ENTITYID = g.ENTITYID
	OUTER APPLY (
		SELECT TOP 1
			addnaddressid
		   ,addsAddress1
		   ,addsAddress2
		   ,addsAddress3
		   ,addsCity
		   ,addsStateCode
		   ,addsZip
		FROM sma_MST_Address
		WHERE addnContactID = cinnContactID
			AND addnContactCtgID = 1
		ORDER BY ISNULL(addbPrimary, 0) DESC
	) e
	LEFT JOIN sma_MST_IndvContacts a
		ON a.cinsGrade = f.CREATORID
	LEFT JOIN sma_mst_users u1
		ON u1.usrnContactID = a.cinnContactID
	LEFT JOIN sma_MST_IndvContacts b
		ON b.cinsGrade = f.REVISORID
	LEFT JOIN sma_mst_users u2
		ON u2.usrnContactID = b.cinnContactID
	WHERE ISPERSON = 't'
		AND LEN(ADDRFAX) > 2
		AND c.cinncontactid IS NOT NULL

---------------------------------------------
INSERT INTO [sma_MST_ContactNumbers]
	(
	[cnnnContactCtgID]
   ,[cnnnContactID]
   ,[cnnnPhoneTypeID]
   ,[cnnsContactNumber]
   ,[cnnsExtension]
   ,[cnnbPrimary]
   ,[cnnbVisible]
   ,[cnnnAddressID]
   ,[cnnsLabelCaption]
   ,[cnnnRecUserID]
   ,[cnndDtCreated]
   ,[cnnnModifyUserID]
   ,[cnndDtModified]
   ,[cnnnLevelNo]
   ,[caseNo]
   ,[saga]
	)
	SELECT
		2
	   ,c.connContactID
	   ,24
	   ,CASE
			WHEN LEN(PHONE) > 2
				THEN ISNULL('(' + LEFT(REPLACE(LTRIM(SUBSTRING(dbo.[RemoveAlphaCharactersN](phone), 0, 11)), '-', ''), 3) + ') ' + SUBSTRING(REPLACE(REPLACE(SUBSTRING(dbo.[RemoveAlphaCharactersN](phone), 0, 11), '-', ''), ' ', ''), 4, 3) + '-' + RIGHT(REPLACE(REPLACE(SUBSTRING(dbo.[RemoveAlphaCharactersN](phone), 0, 11), '-', ''), ' ', ''), 4), '')
			ELSE NULL
		END
	   ,PHONEEXT
	   ,1
	   ,1
	   ,addnaddressid
	   ,'Office Phone'
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
	   ,NULL
	FROM sma_MST_OrgContacts c
	LEFT JOIN [WilliamPagerSaga].[dbo].[ENTITIES]
		ON LTRIM(RTRIM(c.connLevelNo)) = ENTITYID
	OUTER APPLY (
		SELECT TOP 1
			addnaddressid
		   ,addsAddress1
		   ,addsAddress2
		   ,addsAddress3
		   ,addsCity
		   ,addsStateCode
		   ,addsZip
		FROM sma_MST_Address
		WHERE addnContactID = connContactID
			AND addnContactCtgID = 2
		ORDER BY ISNULL(addbPrimary, 0) DESC
	) e
	LEFT JOIN sma_MST_IndvContacts a
		ON a.cinsGrade = CREATORID
	LEFT JOIN sma_mst_users u1
		ON u1.usrnContactID = a.cinnContactID
	LEFT JOIN sma_MST_IndvContacts b
		ON b.cinsGrade = REVISORID
	LEFT JOIN sma_mst_users u2
		ON u2.usrnContactID = b.cinnContactID
	WHERE ISPERSON <> 't'
		AND LEN(PHONE) > 2
		AND c.conncontactid IS NOT NULL

INSERT INTO [sma_MST_ContactNumbers]
	(
	[cnnnContactCtgID]
   ,[cnnnContactID]
   ,[cnnnPhoneTypeID]
   ,[cnnsContactNumber]
   ,[cnnsExtension]
   ,[cnnbPrimary]
   ,[cnnbVisible]
   ,[cnnnAddressID]
   ,[cnnsLabelCaption]
   ,[cnnnRecUserID]
   ,[cnndDtCreated]
   ,[cnnnModifyUserID]
   ,[cnndDtModified]
   ,[cnnnLevelNo]
   ,[caseNo]
   ,[saga]
	)
	SELECT
		2
	   ,c.connContactID
	   ,40
	   ,CASE
			WHEN LEN(MOBILEPHONE) > 2
				THEN ISNULL('(' + LEFT(REPLACE(LTRIM(SUBSTRING(dbo.[RemoveAlphaCharactersN](MOBILEPHONE), 0, 11)), '-', ''), 3) + ') ' + SUBSTRING(REPLACE(REPLACE(SUBSTRING(dbo.[RemoveAlphaCharactersN](MOBILEPHONE), 0, 11), '-', ''), ' ', ''), 4, 3) + '-' + RIGHT(REPLACE(REPLACE(SUBSTRING(dbo.[RemoveAlphaCharactersN](MOBILEPHONE), 0, 11), '-', ''), ' ', ''), 4), '')
			ELSE NULL
		END
	   ,MOBILEEXT
	   ,CASE
			WHEN LEN(PHONE) > 2
				THEN 0
			ELSE 1
		END
	   ,1
	   ,addnaddressid
	   ,'Cell'
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
	   ,NULL
	FROM sma_MST_OrgContacts c
	LEFT JOIN [WilliamPagerSaga].[dbo].[ENTITIES]
		ON LTRIM(RTRIM(c.connLevelNo)) = ENTITYID
	OUTER APPLY (
		SELECT TOP 1
			addnaddressid
		   ,addsAddress1
		   ,addsAddress2
		   ,addsAddress3
		   ,addsCity
		   ,addsStateCode
		   ,addsZip
		FROM sma_MST_Address
		WHERE addnContactID = connContactID
			AND addnContactCtgID = 2
		ORDER BY ISNULL(addbPrimary, 0) DESC
	) e
	LEFT JOIN sma_MST_IndvContacts a
		ON a.cinsGrade = CREATORID
	LEFT JOIN sma_mst_users u1
		ON u1.usrnContactID = a.cinnContactID
	LEFT JOIN sma_MST_IndvContacts b
		ON b.cinsGrade = REVISORID
	LEFT JOIN sma_mst_users u2
		ON u2.usrnContactID = b.cinnContactID
	WHERE ISPERSON <> 't'
		AND LEN(MOBILEPHONE) > 2
		AND c.conncontactid IS NOT NULL

INSERT INTO [sma_MST_ContactNumbers]
	(
	[cnnnContactCtgID]
   ,[cnnnContactID]
   ,[cnnnPhoneTypeID]
   ,[cnnsContactNumber]
   ,[cnnsExtension]
   ,[cnnbPrimary]
   ,[cnnbVisible]
   ,[cnnnAddressID]
   ,[cnnsLabelCaption]
   ,[cnnnRecUserID]
   ,[cnndDtCreated]
   ,[cnnnModifyUserID]
   ,[cnndDtModified]
   ,[cnnnLevelNo]
   ,[caseNo]
   ,[saga]
	)
	SELECT
		2
	   ,c.connContactID
	   ,24
	   ,CASE
			WHEN LEN(ADDRPHONE) > 2
				THEN ISNULL('(' + LEFT(REPLACE(LTRIM(SUBSTRING(dbo.[RemoveAlphaCharactersN](ADDRPHONE), 0, 11)), '-', ''), 3) + ') ' + SUBSTRING(REPLACE(REPLACE(SUBSTRING(dbo.[RemoveAlphaCharactersN](ADDRPHONE), 0, 11), '-', ''), ' ', ''), 4, 3) + '-' + RIGHT(REPLACE(REPLACE(SUBSTRING(dbo.[RemoveAlphaCharactersN](ADDRPHONE), 0, 11), '-', ''), ' ', ''), 4), '')
			ELSE NULL
		END
	   ,ADDRPHONEEXT
	   ,CASE
			WHEN LEN(PHONE) > 2
				THEN 0
			WHEN LEN(MOBILEPHONE) > 0
				THEN 0
			ELSE 1
		END
	   ,1
	   ,addnaddressid
	   ,'Office Phone'
	   ,CASE ISNULL(u1.usrnuserid, '')
			WHEN ''
				THEN 368
			ELSE u1.usrnuserid
		END
	   ,CASE f.datecreated
			WHEN NULL
				THEN GETDATE()
			ELSE f.datecreated
		END
	   ,u2.usrnuserid
	   ,f.daterevised
	   ,NULL
	   ,NULL
	   ,NULL
	FROM sma_MST_orgContacts c
	LEFT JOIN [WilliamPagerSaga].[dbo].[address] f
		ON LTRIM(RTRIM(c.connLevelNo)) = f.ENTITYID
	LEFT JOIN [WilliamPagerSaga].[dbo].[ENTITIES] g
		ON f.ENTITYID = g.ENTITYID
	OUTER APPLY (
		SELECT TOP 1
			addnaddressid
		   ,addsAddress1
		   ,addsAddress2
		   ,addsAddress3
		   ,addsCity
		   ,addsStateCode
		   ,addsZip
		FROM sma_MST_Address
		WHERE addnContactID = connContactID
			AND addnContactCtgID = 2
		ORDER BY ISNULL(addbPrimary, 0) DESC
	) e
	LEFT JOIN sma_MST_IndvContacts a
		ON a.cinsGrade = f.CREATORID
	LEFT JOIN sma_mst_users u1
		ON u1.usrnContactID = a.cinnContactID
	LEFT JOIN sma_MST_IndvContacts b
		ON b.cinsGrade = f.REVISORID
	LEFT JOIN sma_mst_users u2
		ON u2.usrnContactID = b.cinnContactID
	WHERE ISPERSON <> 't'
		AND LEN(ADDRPHONE) > 2
		AND c.conncontactid IS NOT NULL

INSERT INTO [sma_MST_ContactNumbers]
	(
	[cnnnContactCtgID]
   ,[cnnnContactID]
   ,[cnnnPhoneTypeID]
   ,[cnnsContactNumber]
   ,[cnnsExtension]
   ,[cnnbPrimary]
   ,[cnnbVisible]
   ,[cnnnAddressID]
   ,[cnnsLabelCaption]
   ,[cnnnRecUserID]
   ,[cnndDtCreated]
   ,[cnnnModifyUserID]
   ,[cnndDtModified]
   ,[cnnnLevelNo]
   ,[caseNo]
   ,[saga]
	)
	SELECT
		2
	   ,c.connContactID
	   ,35
	   ,CASE
			WHEN LEN(ADDRDATA) > 2
				THEN ISNULL('(' + LEFT(REPLACE(LTRIM(SUBSTRING(dbo.[RemoveAlphaCharactersN](ADDRDATA), 0, 11)), '-', ''), 3) + ') ' + SUBSTRING(REPLACE(REPLACE(SUBSTRING(dbo.[RemoveAlphaCharactersN](ADDRDATA), 0, 11), '-', ''), ' ', ''), 4, 3) + '-' + RIGHT(REPLACE(REPLACE(SUBSTRING(dbo.[RemoveAlphaCharactersN](ADDRDATA), 0, 11), '-', ''), ' ', ''), 4), '')
			ELSE NULL
		END
	   ,''
	   ,CASE
			WHEN LEN(PHONE) > 2
				THEN 0
			WHEN LEN(MOBILEPHONE) > 0
				THEN 0
			WHEN LEN(ADDRPHONE) > 2
				THEN 0
			ELSE 1
		END
	   ,1
	   ,addnaddressid
	   ,'HQ/Main Office'
	   ,CASE ISNULL(u1.usrnuserid, '')
			WHEN ''
				THEN 368
			ELSE u1.usrnuserid
		END
	   ,CASE f.datecreated
			WHEN NULL
				THEN GETDATE()
			ELSE f.datecreated
		END
	   ,u2.usrnuserid
	   ,f.daterevised
	   ,NULL
	   ,NULL
	   ,NULL
	FROM sma_MST_orgContacts c
	LEFT JOIN [WilliamPagerSaga].[dbo].[address] f
		ON LTRIM(RTRIM(c.connLevelNo)) = f.ENTITYID
	LEFT JOIN [WilliamPagerSaga].[dbo].[ENTITIES] g
		ON f.ENTITYID = g.ENTITYID
	OUTER APPLY (
		SELECT TOP 1
			addnaddressid
		   ,addsAddress1
		   ,addsAddress2
		   ,addsAddress3
		   ,addsCity
		   ,addsStateCode
		   ,addsZip
		FROM sma_MST_Address
		WHERE addnContactID = connContactID
			AND addnContactCtgID = 2
		ORDER BY ISNULL(addbPrimary, 0) DESC
	) e
	LEFT JOIN sma_MST_IndvContacts a
		ON a.cinsGrade = f.CREATORID
	LEFT JOIN sma_mst_users u1
		ON u1.usrnContactID = a.cinnContactID
	LEFT JOIN sma_MST_IndvContacts b
		ON b.cinsGrade = f.REVISORID
	LEFT JOIN sma_mst_users u2
		ON u2.usrnContactID = b.cinnContactID
	WHERE ISPERSON <> 't'
		AND LEN(ADDRDATA) > 2
		AND c.conncontactid IS NOT NULL


INSERT INTO [sma_MST_ContactNumbers]
	(
	[cnnnContactCtgID]
   ,[cnnnContactID]
   ,[cnnnPhoneTypeID]
   ,[cnnsContactNumber]
   ,[cnnsExtension]
   ,[cnnbPrimary]
   ,[cnnbVisible]
   ,[cnnnAddressID]
   ,[cnnsLabelCaption]
   ,[cnnnRecUserID]
   ,[cnndDtCreated]
   ,[cnnnModifyUserID]
   ,[cnndDtModified]
   ,[cnnnLevelNo]
   ,[caseNo]
   ,[saga]
	)
	SELECT
		2
	   ,c.connContactID
	   ,28
	   ,CASE
			WHEN LEN(ADDRFAX) > 2
				THEN ISNULL('(' + LEFT(REPLACE(LTRIM(SUBSTRING(dbo.[RemoveAlphaCharactersN](ADDRFAX), 0, 11)), '-', ''), 3) + ') ' + SUBSTRING(REPLACE(REPLACE(SUBSTRING(dbo.[RemoveAlphaCharactersN](ADDRFAX), 0, 11), '-', ''), ' ', ''), 4, 3) + '-' + RIGHT(REPLACE(REPLACE(SUBSTRING(dbo.[RemoveAlphaCharactersN](ADDRFAX), 0, 11), '-', ''), ' ', ''), 4), '')
			ELSE NULL
		END
	   ,''
	   ,0
	   ,1
	   ,addnaddressid
	   ,'Office Fax'
	   ,CASE ISNULL(u1.usrnuserid, '')
			WHEN ''
				THEN 368
			ELSE u1.usrnuserid
		END
	   ,CASE f.datecreated
			WHEN NULL
				THEN GETDATE()
			ELSE f.datecreated
		END
	   ,u2.usrnuserid
	   ,f.daterevised
	   ,NULL
	   ,NULL
	   ,NULL
	FROM sma_MST_orgContacts c
	LEFT JOIN [WilliamPagerSaga].[dbo].[address] f
		ON LTRIM(RTRIM(c.connLevelNo)) = f.ENTITYID
	LEFT JOIN [WilliamPagerSaga].[dbo].[ENTITIES] g
		ON f.ENTITYID = g.ENTITYID
	OUTER APPLY (
		SELECT TOP 1
			addnaddressid
		   ,addsAddress1
		   ,addsAddress2
		   ,addsAddress3
		   ,addsCity
		   ,addsStateCode
		   ,addsZip
		FROM sma_MST_Address
		WHERE addnContactID = connContactID
			AND addnContactCtgID = 2
		ORDER BY ISNULL(addbPrimary, 0) DESC
	) e
	LEFT JOIN sma_MST_IndvContacts a
		ON a.cinsGrade = f.CREATORID
	LEFT JOIN sma_mst_users u1
		ON u1.usrnContactID = a.cinnContactID
	LEFT JOIN sma_MST_IndvContacts b
		ON b.cinsGrade = f.REVISORID
	LEFT JOIN sma_mst_users u2
		ON u2.usrnContactID = b.cinnContactID
	WHERE ISPERSON <> 't'
		AND LEN(ADDRFAX) > 2
		AND c.conncontactid IS NOT NULL

ALTER TABLE [sma_MST_ContactNumbers] ENABLE TRIGGER ALL


