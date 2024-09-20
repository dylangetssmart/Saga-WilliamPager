USE WilliamPagerSA

ALTER TABLE sma_mst_indvcontacts DISABLE TRIGGER ALL
SET ANSI_WARNINGS OFF
GO
--INSERT INTO [sma_MST_OriginalContactTypes]
--([octsCode],[octnContactCtgID],[octsDscrptn],[octnRecUserID],[octdDtCreated],[octnModifyUserID],[octdDtModified],[octnLevelNo])
-- Select distinct UPPER(SUBSTRING(et.DESCRIPTION,0,5)),1,DESCRIPTION,368,GETDATE(),null,null,''
-- FROM [WilliamPagerSaga].[dbo].[ENTITIES] e
--left join [WilliamPagerSaga].[dbo].enttype et on e.ENTITYTYPEID=et.ENTITYTYPEID
--where   FIRST_DBA is not null
--and et.DESCRIPTION not in (select [octsDscrptn] from [sma_MST_OriginalContactTypes] where [octnContactCtgID]=1)
--and et.DESCRIPTION not like '%judge%' and et.DESCRIPTION not like '%clerk%' and et.DESCRIPTION not like '%doctor%' and et.DESCRIPTION not like '%police%' and et.DESCRIPTION not like '%expert%' and et.DESCRIPTION not like '%adjuster%' and et.DESCRIPTION not like '%attorney%'  and et.DESCRIPTION not like '%investigator%'
------------------------------Insert Individual Contact Started-------------------------------------------------------------------------    
DECLARE @ContactID INT

SELECT
	@ContactID = MAX(cinnContactID)
FROM sma_MST_IndvContacts
INSERT INTO [sma_MST_IndvContacts]
	(
	[cinbPrimary]
   ,[cinnContactTypeID]
   ,[cinnContactSubCtgID]
   ,[cinsPrefix]
   ,[cinsFirstName]
   ,[cinsMiddleName]
   ,[cinsLastName]
   ,[cinsSuffix]
   ,[cinsNickName]
   ,[cinbStatus]
   ,[cinsSSNNo]
   ,[cindBirthDate]
   ,[cinsComments]
   ,[cinnContactCtg]
   ,[cinnRefByCtgID]
   ,[cinnReferredBy]
   ,[cindDateOfDeath]
   ,[cinsCVLink]
   ,[cinnMaritalStatusID]
   ,[cinnGender]
   ,[cinsBirthPlace]
   ,[cinnCountyID]
   ,[cinsCountyOfResidence]
   ,[cinbFlagForPhoto]
   ,[cinsPrimaryContactNo]
   ,[cinsHomePhone]
   ,[cinsWorkPhone]
   ,[cinsMobile]
   ,[cinbPreventMailing]
   ,[cinnRecUserID]
   ,[cindDtCreated]
   ,[cinnModifyUserID]
   ,[cindDtModified]
   ,[cinnLevelNo]
   ,[cinsPrimaryLanguage]
   ,[cinsOtherLanguage]
   ,[cinbDeathFlag]
   ,[cinsCitizenship]
   ,[cinsHeight]
   ,[cinnWeight]
   ,[cinsReligion]
   ,[cindMarriageDate]
   ,[cinsMarriageLoc]
   ,[cinsDeathPlace]
   ,[cinsMaidenName]
   ,[cinsOccupation]
   ,[saga]
   ,[cinsSpouse]
   ,[cinsGrade]
	)
	SELECT DISTINCT
		1
	   ,CASE
			WHEN et.DESCRIPTION LIKE '%judge%'
				THEN 2
			WHEN et.DESCRIPTION LIKE '%clerk%'
				THEN 32
			WHEN et.DESCRIPTION LIKE '%doctor%'
				THEN 1
			WHEN et.DESCRIPTION LIKE '%police%'
				THEN 18
			WHEN et.DESCRIPTION LIKE '%expert%'
				THEN 23
			WHEN et.DESCRIPTION LIKE '%adjuster%'
				THEN 20
			WHEN et.DESCRIPTION LIKE '%attorney%'
				THEN 13
			WHEN et.DESCRIPTION LIKE '%investigator%'
				THEN 17
			ELSE 2
		END
	   ,NULL
	   ,SUBSTRING(e.Title, 0, 19)
	   ,SUBSTRING(FIRST_DBA, 0, 29)
	   ,SUBSTRING(MIDDLE_CONTACT, 0, 29)
	   ,SUBSTRING(LAST_COMPANY, 0, 39)
	   ,NULL
	   ,SUBSTRING(ALIASNAMES, 0, 15)
	   ,1
	   ,SUBSTRING(ssn, 0, 19)
	   ,DATEOFB
	   ,SUBSTRING(ENTITYNAME, 0, 499)
	   ,1
	   ,''
	   ,''
	   ,DOD
	   ,''
	   ,''
	   ,CASE gender
			WHEN 'M'
				THEN 1
			WHEN 'F'
				THEN 2
		END
	   ,''
	   ,1
	   ,1
	   ,NULL
	   ,SUBSTRING(phone, 0, 19)
	   ,''
	   ,''
	   ,SUBSTRING(MOBILEPHONE, 0, 19)
	   ,0
	   ,CASE ISNULL(u1.usrnuserid, '')
			WHEN ''
				THEN 368
			ELSE u1.usrnuserid
		END
	   ,CASE e.datecreated
			WHEN NULL
				THEN GETDATE()
			ELSE e.datecreated
		END
	   ,u2.usrnuserid
	   ,e.daterevised
	   ,0
	   ,''
	   ,''
	   ,''
	   ,''
	   ,HEIGHTFEET + HEIGHTINCH
	   ,WEIGHT
	   ,''
	   ,NULL
	   ,''
	   ,''
	   ,''
	   ,''
	   ,''
	   ,''
	   ,j.JUDGEID
	FROM [WilliamPagerSaga].dbo.MRULASS j
	JOIN [WilliamPagerSaga].[dbo].[ENTITIES] e
		ON j.JUDGEID = e.ENTITYID
	LEFT JOIN [WilliamPagerSaga].[dbo].enttype et
		ON e.ENTITYTYPEID = et.ENTITYTYPEID
	--left join [sma_MST_OriginalContactTypes] on octsDscrptn=et.DESCRIPTION
	LEFT JOIN sma_MST_IndvContacts a
		ON a.cinsGrade = e.CREATORID
	LEFT JOIN sma_mst_users u1
		ON u1.usrnContactID = a.cinnContactID
	LEFT JOIN sma_MST_IndvContacts b
		ON b.cinsGrade = e.REVISORID
	LEFT JOIN sma_mst_users u2
		ON u2.usrnContactID = b.cinnContactID
	WHERE j.JUDGEID NOT IN (
			SELECT
				ISNULL(cinsgrade, 0)
			FROM sma_mst_indvcontacts
		) --and  FIRST_DBA is not null

------------------------------Insert Individual Contact Finished-------------------------------------------------------------------------    

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
	   ,CASE ADDRDESCRIPTION
			WHEN 1001
				THEN 7
			WHEN 4056
				THEN 1
			ELSE 10
		END
	   ,CASE ADDRDESCRIPTION
			WHEN 1001
				THEN 'Work'
			WHEN 4056
				THEN 'Home - Primary'
			ELSE 'Other'
		END
	   ,CASE ADDRDESCRIPTION
			WHEN 1001
				THEN 'WORK'
			WHEN 4056
				THEN 'HM'
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
	   ,EXTERNAL_REFERENCE_ID
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
	   ,''
	   ,CASE
			WHEN ADDRZIPCODE LIKE '%-%'
				THEN SUBSTRING(ADDRZIPCODE, CHARINDEX('-', ADDRZIPCODE) + 1, LEN(ADDRZIPCODE))
			ELSE ''
		END
	   ,''
	FROM [WilliamPagerSaga].[dbo].[Address] ad
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
	WHERE c.cinncontactid IS NOT NULL
		AND c.cinnContactID > @ContactID
ALTER TABLE [sma_MST_Address] ENABLE TRIGGER ALL


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
	WHERE LEN(PHONE) > 2
		AND c.cinncontactid IS NOT NULL
		AND c.cinnContactID > @ContactID

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
	WHERE LEN(MOBILEPHONE) > 2
		AND c.cinncontactid IS NOT NULL
		AND c.cinnContactID > @ContactID

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
	WHERE LEN(ADDRPHONE) > 2
		AND c.cinncontactid IS NOT NULL
		AND c.cinnContactID > @ContactID

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
	WHERE LEN(ADDRDATA) > 2
		AND c.cinncontactid IS NOT NULL
		AND c.cinnContactID > @ContactID

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
	WHERE LEN(ADDRFAX) > 2
		AND c.cinncontactid IS NOT NULL
		AND c.cinnContactID > @ContactID
ALTER TABLE [sma_MST_ContactNumbers] ENABLE TRIGGER ALL

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
	WHERE EMAILADDRESS <> ''
		AND EMAILADDRESS LIKE '%@%'
		AND c.cinncontactid IS NOT NULL
		AND c.cinnContactID > @ContactID
ALTER TABLE [sma_MST_EmailWebsite] ENABLE TRIGGER ALL

ALTER TABLE sma_trn_courts DISABLE TRIGGER ALL
INSERT INTO [sma_TRN_Courts]
	(
	[crtnCaseID]
   ,[crtnCourtID]
   ,[crtnCourtAddId]
   ,[crtnIsJudge]
   ,[crtnJudgeID]
   ,[crtnJudgeAddId]
   ,[crtsComment]
   ,[crtbDocAttached]
   ,[crtdFromDt]
   ,[crtdToDt]
   ,[crtnRecUserID]
   ,[crtdDtCreated]
   ,[crtnModifyUserID]
   ,[crtdDtModified]
   ,[crtnLevelNo]
   ,[crtnDelete]
   ,[crtnIsActive]
	)
	SELECT DISTINCT
		casnCaseID
	   ,connContactID
	   ,addnAddressID
	   ,NULL
	   ,NULL
	   ,NULL
	   ,CONVERT(VARCHAR(MAX), LTRIM(REPLACE(
		dbo.RegExReplace(notes, '({\\)(.+?)(})|(\\)(.+?)(\b)', '')
		, '}', '')

		))
	   ,''
	   ,ISNULL(casdDtModified, casdOpeningDate)
	   ,NULL
	   ,ISNULL(casnModifyUserID, casnRecUserID)
	   ,ISNULL(casdDtModified, casdOpeningDate)
	   ,NULL
	   ,NULL
	   ,NULL
	   ,0
	   ,1
	FROM [WilliamPagerSaga].[dbo].[LW_COURT] b
	LEFT JOIN [WilliamPagerSaga].[dbo].ASSIGN c
		ON b.ASSIGNID = c.ASSIGNID
	LEFT JOIN [WilliamPagerSaga].[dbo].ASSIGN d
		ON b.PARTYASSIGNID = d.ASSIGNID
	LEFT JOIN [WilliamPagerSaga].[dbo].MATTER a
		ON a.MATTERID = c.MATTERID
	LEFT JOIN sma_trn_cases
		ON cassCaseNumber = MATTERNUMBER
	--left join [WilliamPagerSaga].[dbo].[JURISDCT] j on j.JURISDICTIONID=a.JURISDICTIONID
	LEFT JOIN sma_MST_OrgContacts k
		ON k.connLevelNo = c.ENTITYID
	LEFT JOIN WilliamPagerSaga.dbo.ENTITIES en
		ON en.ENTITYID = c.ENTITYID
	LEFT JOIN WilliamPagerSaga.dbo.NOTE n
		ON c.NOTEID = n.noteid
	LEFT JOIN WilliamPagerSaga.dbo.ADDRESS ad
		ON ad.ADDRESSID = en.PRIMARYADDR
	LEFT JOIN sma_MST_Address
		ON addnContactID = connContactID
			AND addbPrimary = 1
			AND addsCity = ad.ADDRCITY
			AND addsAddress1 = ad.ADDRLINE1
			AND addnContactCtgID = 2
	WHERE casnCaseID IS NOT NULL
		AND ISNULL(connContactID, '') <> ''

INSERT INTO [sma_TRN_Courts]
	(
	[crtnCaseID]
   ,[crtnCourtID]
   ,[crtnCourtAddId]
   ,[crtnIsJudge]
   ,[crtnJudgeID]
   ,[crtnJudgeAddId]
   ,[crtsComment]
   ,[crtbDocAttached]
   ,[crtdFromDt]
   ,[crtdToDt]
   ,[crtnRecUserID]
   ,[crtdDtCreated]
   ,[crtnModifyUserID]
   ,[crtdDtModified]
   ,[crtnLevelNo]
   ,[crtnDelete]
   ,[crtnIsActive]
	)

	SELECT DISTINCT
		casnCaseID
	   ,connContactID
	   ,addnAddressID
	   ,NULL
	   ,NULL
	   ,NULL
	   ,''
	   ,''
	   ,ISNULL(casdDtModified, casdOpeningDate)
	   ,NULL
	   ,ISNULL(casnModifyUserID, casnRecUserID)
	   ,ISNULL(casdDtModified, casdOpeningDate)
	   ,NULL
	   ,NULL
	   ,NULL
	   ,0
	   ,1
	FROM [WilliamPagerSaga].[dbo].[JURISDCT] j
	LEFT JOIN [WilliamPagerSaga].[dbo].MATTER a
		ON a.JURISDICTIONID = j.JURISDICTIONID
	LEFT JOIN sma_trn_cases
		ON cassCaseNumber = MATTERNUMBER
	OUTER APPLY (
		SELECT TOP 1
			conncontactid
		   ,addnAddressID
		FROM sma_MST_OrgContacts k
		LEFT JOIN sma_MST_Address
			ON addnContactID = connContactID
			AND addnContactCtgID = 2
			AND addbPrimary = 1
		WHERE k.consName = j.DESCRIPTION
	) k
	WHERE casnCaseID IS NOT NULL
		AND ISNULL(connContactID, '') <> ''
		AND NOT EXISTS (
			SELECT
				*
			FROM sma_TRN_Courts
			WHERE casnCaseID = crtnCaseID
		)

ALTER TABLE sma_trn_courts ENABLE TRIGGER ALL

ALTER TABLE [sma_TRN_CourtDocket] DISABLE TRIGGER ALL

ALTER TABLE [sma_TRN_CourtDocket]
ALTER COLUMN [crdnDocketNo] VARCHAR(100)
INSERT INTO [sma_TRN_CourtDocket]
	(
	[crdnCourtsID]
   ,[crdnIndexTypeID]
   ,[crdnDocketNo]
   ,[crddDate]
   ,[crdnPrice]
   ,[crdsPayee]
   ,[crdsCheckNo]
   ,[crddCheckDt]
   ,[crdbActiveInActive]
   ,[crdsComments]
   ,[crdnRecUserID]
   ,[crddDtCreated]
   ,[crdnModifyUserID]
   ,[crddDtModified]
   ,[crdnLevelNo]
   ,[crdnDisbID]
   ,[crdnPayeeAddID]
   ,[crdnElcID]
   ,[crdsPayeeCtgID]
   ,[crdsEfile]
	)
	SELECT DISTINCT
		crtnPKCourtsID
	   ,3
	   ,ISNULL(b.COURTCASENUMBER, '') +
		CASE
			WHEN ISNULL(b.COURTCASENUMBEREXT, '') <> ''
				THEN '/' + b.COURTCASENUMBEREXT
			ELSE ''
		END
	   ,CASE
			WHEN DATEFILED BETWEEN '1/1/1900' AND '12/31/2079'
				THEN DATEFILED
		END
	   ,NULL
	   ,NULL
	   ,NULL
	   ,CASE
			WHEN DOCKETPURCHASEDATE BETWEEN '1/1/1900' AND '12/31/2079'
				THEN DOCKETPURCHASEDATE
		END
	   ,1
	   ,''
	   ,ISNULL(casnModifyUserID, casnRecUserID)
	   ,ISNULL(casdDtModified, casdOpeningDate)
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,0
	FROM [WilliamPagerSaga].[dbo].[LW_COURT] b
	LEFT JOIN [WilliamPagerSaga].[dbo].ASSIGN c
		ON b.ASSIGNID = c.ASSIGNID
	LEFT JOIN [WilliamPagerSaga].[dbo].ASSIGN d
		ON b.PARTYASSIGNID = d.ASSIGNID
	LEFT JOIN [WilliamPagerSaga].[dbo].MATTER a
		ON a.MATTERID = c.MATTERID
	LEFT JOIN sma_trn_cases
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_mst_orgcontacts
		ON connlevelno = c.ENTITYID
	LEFT JOIN sma_trn_courts
		ON crtncaseid = casncaseid
			AND connContactID = crtnCourtID
	WHERE b.COURTCASENUMBER <> ''
		AND casnCaseID IS NOT NULL
		AND crtnPKCourtsID IS NOT NULL



INSERT INTO [sma_TRN_CourtDocket]
	(
	[crdnCourtsID]
   ,[crdnIndexTypeID]
   ,[crdnDocketNo]
   ,[crddDate]
   ,[crdnPrice]
   ,[crdsPayee]
   ,[crdsCheckNo]
   ,[crddCheckDt]
   ,[crdbActiveInActive]
   ,[crdsComments]
   ,[crdnRecUserID]
   ,[crddDtCreated]
   ,[crdnModifyUserID]
   ,[crddDtModified]
   ,[crdnLevelNo]
   ,[crdnDisbID]
   ,[crdnPayeeAddID]
   ,[crdnElcID]
   ,[crdsPayeeCtgID]
   ,[crdsEfile]
	)
	SELECT DISTINCT
		crtnPKCourtsID
	   ,10
	   ,b.CALENDARNUMBER
	   ,CASE
			WHEN DATEFILED BETWEEN '1/1/1900' AND '12/31/2079'
				THEN DATEFILED
		END
	   ,NULL
	   ,NULL
	   ,NULL
	   ,CASE
			WHEN DOCKETPURCHASEDATE BETWEEN '1/1/1900' AND '12/31/2079'
				THEN DOCKETPURCHASEDATE
		END
	   ,1
	   ,''
	   ,ISNULL(casnModifyUserID, casnRecUserID)
	   ,ISNULL(casdDtModified, casdOpeningDate)
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,0
	FROM [WilliamPagerSaga].[dbo].[LW_COURT] b
	LEFT JOIN [WilliamPagerSaga].[dbo].ASSIGN c
		ON b.ASSIGNID = c.ASSIGNID
	LEFT JOIN [WilliamPagerSaga].[dbo].ASSIGN d
		ON b.PARTYASSIGNID = d.ASSIGNID
	LEFT JOIN [WilliamPagerSaga].[dbo].MATTER a
		ON a.MATTERID = c.MATTERID
	LEFT JOIN sma_trn_cases
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_mst_orgcontacts
		ON connlevelno = c.ENTITYID
	LEFT JOIN sma_trn_courts
		ON crtncaseid = casncaseid
			AND connContactID = crtnCourtID
	WHERE b.CALENDARNUMBER <> ''
		AND casnCaseID IS NOT NULL
		AND crtnPKCourtsID IS NOT NULL

ALTER TABLE [sma_TRN_CourtDocket] ENABLE TRIGGER ALL





INSERT INTO [sma_trn_caseJudgeorClerk]
	(
	[crtDocketID]
   ,[crtJudgeorClerkContactID]
   ,[crtJudgeorClerkContactCtgID]
   ,[crtJudgeorClerkRoleID]
   ,[crtJudgeorClerkCreatedBy]
   ,[crtJudgeorClerkCreatedDt]
   ,[crtJudgeorClerkModifiedBy]
   ,[crtJudgeorClerkModifiedDt]
	)

	SELECT DISTINCT
		crdnCourtDocketID
	   ,cinnContactID
	   ,1
	   ,2
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	FROM [WilliamPagerSaga].[dbo].LW_COURT c
	LEFT JOIN WilliamPagerSaga.dbo.assign z
		ON z.assignid = c.ASSIGNID
	LEFT JOIN WilliamPagerSaga.dbo.matrelt mat
		ON mat.assignid = c.assignid
	LEFT JOIN WilliamPagerSaga.dbo.assign a
		ON a.assignid = mat.relatedassignid
	LEFT JOIN WilliamPagerSaga.dbo.matter m
		ON m.MATTERID = a.MATTERID
	LEFT JOIN WilliamPagerSaga.dbo.entities e
		ON e.ENTITYID = a.entityid
	LEFT JOIN sma_MST_IndvContacts
		ON cinsGrade = e.ENTITYID
	LEFT JOIN sma_TRN_CaseS
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_mst_orgcontacts
		ON connLevelNo = z.ENTITYID
	LEFT JOIN sma_TRN_Courts
		ON crtnCaseID = casnCaseID
			AND crtnCourtID = connContactID
	LEFT JOIN sma_TRN_CourtDocket
		ON crdnCourtsID = crtnPKCourtsID
	WHERE crdnCourtDocketID IS NOT NULL
		AND cinnContactID IS NOT NULL --and crtnCaseID=6340

SET ANSI_WARNINGS ON

INSERT INTO [sma_TRN_UDFValues]
	(
	[udvnUDFID]
   ,[udvsScreenName]
   ,[udvsUDFCtg]
   ,[udvnRelatedID]
   ,[udvnSubRelatedID]
   ,[udvsUDFValue]
   ,[udvnRecUserID]
   ,[udvdDtCreated]
   ,[udvnModifyUserID]
   ,[udvdDtModified]
   ,[udvnLevelNo]
	)
	SELECT DISTINCT
		377
	   ,''
	   ,'R'
	   ,cinnContactID
	   ,1
	   ,PARTNUMBER
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM [WilliamPagerSaga].[dbo].[LW_JUDGE] j
	LEFT JOIN [WilliamPagerSaga].[dbo].[ASSIGN] a
		ON a.ENTITYID = j.ENTITYID
	LEFT JOIN [WilliamPagerSaga].[dbo].[erole] r
		ON r.ROLEID = a.ROLEID
	LEFT JOIN [WilliamPagerSaga].[dbo].[ENTITIES] et
		ON et.ENTITYID = j.ENTITYID
	LEFT JOIN [WilliamPagerSaga].[dbo].[matter] m
		ON m.MATTERID = a.MATTERID
	LEFT JOIN sma_trn_cases
		ON cassCaseNumber = m.MATTERNUMBER
	LEFT JOIN sma_TRN_Courts
		ON crtnCaseID = casnCaseID
	LEFT JOIN sma_TRN_CourtDocket
		ON crdnCourtsID = crtnPKCourtsID
	LEFT JOIN sma_MST_IndvContacts
		ON cinsGrade = j.ENTITYID
	WHERE DESCRIPTION LIKE 'judge%'
		AND crdnCourtDocketID IS NOT NULL
		AND ISNULL(PARTNUMBER, '') <> ''
		AND cinnContactID IS NOT NULL
	UNION
	SELECT DISTINCT
		378
	   ,''
	   ,'R'
	   ,cinnContactID
	   ,1
	   ,ROOMNUMBER
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM [WilliamPagerSaga].[dbo].[LW_JUDGE] j
	LEFT JOIN [WilliamPagerSaga].[dbo].[ASSIGN] a
		ON a.ENTITYID = j.ENTITYID
	LEFT JOIN [WilliamPagerSaga].[dbo].[erole] r
		ON r.ROLEID = a.ROLEID
	LEFT JOIN [WilliamPagerSaga].[dbo].[ENTITIES] et
		ON et.ENTITYID = j.ENTITYID
	LEFT JOIN [WilliamPagerSaga].[dbo].[matter] m
		ON m.MATTERID = a.MATTERID
	LEFT JOIN sma_trn_cases
		ON cassCaseNumber = m.MATTERNUMBER
	LEFT JOIN sma_TRN_Courts
		ON crtnCaseID = casnCaseID
	LEFT JOIN sma_TRN_CourtDocket
		ON crdnCourtsID = crtnPKCourtsID
	LEFT JOIN sma_MST_IndvContacts
		ON cinsGrade = j.ENTITYID
	WHERE DESCRIPTION LIKE 'judge%'
		AND crdnCourtDocketID IS NOT NULL
		AND ISNULL(ROOMNUMBER, '') <> ''
		AND cinnContactID IS NOT NULL

ALTER TABLE [sma_TRN_Notes] DISABLE TRIGGER ALL
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
	)
	SELECT DISTINCT
		casnCaseID
	   ,nttnNoteTypeID
	   ,DESCRIPTION
	   ,DESCRIPTION + CHAR(13) + ISNULL(note, '')
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
	FROM (
		SELECT
			0 AS casncaseid
		   ,23 AS nttnNoteTypeID
		   ,a.DESCRIPTION
		   ,CONVERT(VARCHAR(MAX), LTRIM(REPLACE(REPLACE(REPLACE(
			dbo.RegExReplace(a.NOTES, '({\\)(.+?)(})|(\\)(.+?)(\b)', '')
			, '}', '')
			, CHAR(13), '')
			, CHAR(10), '')
			)) AS Note
		   ,1 AS [1]
		   ,iz.cinnContactID AS [2]
		   ,'Normal' AS [3]
		   ,NULL AS [4]
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
		LEFT JOIN [WilliamPagerSaga].[dbo].[NOTETYPE] d
			ON d.NOTETYPEID = a.NOTETYPEID
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
		LEFT JOIN [WilliamPagerSaga].[dbo].[LW_JUDGE] j
			ON j.JUDGERULESNOTEID = a.NOTEID
		LEFT JOIN [WilliamPagerSaga].[dbo].[ASSIGN] ass
			ON ass.ENTITYID = j.ENTITYID
		LEFT JOIN [WilliamPagerSaga].[dbo].[erole] r
			ON r.ROLEID = ass.ROLEID
		LEFT JOIN [WilliamPagerSaga].[dbo].[ENTITIES] et
			ON et.ENTITYID = j.ENTITYID
		LEFT JOIN [WilliamPagerSaga].[dbo].[matter] ma
			ON ma.MATTERID = ass.MATTERID
		LEFT JOIN sma_trn_cases
			ON cassCaseNumber = ma.MATTERNUMBER
		LEFT JOIN sma_TRN_Courts
			ON crtnCaseID = casncaseid
		LEFT JOIN sma_TRN_CourtDocket
			ON crdnCourtsID = crtnPKCourtsID
		LEFT JOIN sma_MST_IndvContacts iz
			ON iz.cinsGrade = j.ENTITYID
		WHERE casncaseid IS NOT NULL
			AND iz.cinnContactID IS NOT NULL
			AND r.DESCRIPTION LIKE 'judge%'
			AND crdnCourtDocketID IS NOT NULL
			AND ISNULL(j.JUDGERULESNOTEID, '') <> ''
	) a
ALTER TABLE [sma_TRN_Notes] ENABLE TRIGGER ALL

ALTER TABLE sma_MST_IndvContacts DISABLE TRIGGER ALL
UPDATE sma_MST_IndvContacts
SET cinnContactTypeID = 2
WHERE cinnContactID IN (
	SELECT DISTINCT
		[crtJudgeorClerkContactID]
	FROM [sma_trn_caseJudgeorClerk]
)
ALTER TABLE sma_MST_IndvContacts ENABLE TRIGGER ALL


GO


INSERT INTO [sma_TRN_CourtDocket]
	(
	[crdnCourtsID]
   ,[crdnIndexTypeID]
   ,[crdnDocketNo]
   ,[crddDate]
   ,[crdnPrice]
   ,[crdsPayee]
   ,[crdsCheckNo]
   ,[crddCheckDt]
   ,[crdbActiveInActive]
   ,[crdsComments]
   ,[crdnRecUserID]
   ,[crddDtCreated]
   ,[crdnModifyUserID]
   ,[crddDtModified]
   ,[crdnLevelNo]
   ,[crdnDisbID]
   ,[crdnPayeeAddID]
   ,[crdnElcID]
   ,[crdsPayeeCtgID]
   ,[crdsEfile]
	)
	SELECT DISTINCT
		crtnPKCourtsID
	   ,10
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,0
	   ,''
	   ,ISNULL(casnModifyUserID, casnRecUserID)
	   ,ISNULL(casdDtModified, casdOpeningDate)
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,0
	FROM [WilliamPagerSaga].dbo.matter m
	LEFT JOIN [WilliamPagerSaga].dbo.MRULASS mr
		ON m.MATTERID = mr.MATTERID
	LEFT JOIN sma_trn_cases
		ON cassCaseNumber = m.MATTERNUMBER
	LEFT JOIN sma_TRN_Courts
		ON crtnCaseID = casnCaseID
	LEFT JOIN sma_MST_IndvContacts
		ON cinsGrade = judgeid
	WHERE JUDGEID IS NOT NULL
		AND casnCaseID IS NOT NULL
		AND crtnCaseID IS NOT NULL
		AND NOT EXISTS (
			SELECT
				*
			FROM [sma_TRN_CourtDocket]
			WHERE crdnCourtsID = crtnPKCourtsID
		)

INSERT INTO [sma_trn_caseJudgeorClerk]
	(
	[crtDocketID]
   ,[crtJudgeorClerkContactID]
   ,[crtJudgeorClerkContactCtgID]
   ,[crtJudgeorClerkRoleID]
   ,[crtJudgeorClerkCreatedBy]
   ,[crtJudgeorClerkCreatedDt]
   ,[crtJudgeorClerkModifiedBy]
   ,[crtJudgeorClerkModifiedDt]
	)

	SELECT DISTINCT
		crdnCourtDocketID
	   ,cinnContactID
	   ,1
	   ,2
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	FROM [WilliamPagerSaga].[dbo].LW_COURT c
	LEFT JOIN WilliamPagerSaga.dbo.assign z
		ON z.assignid = c.ASSIGNID
	LEFT JOIN WilliamPagerSaga.dbo.matrelt mat
		ON mat.assignid = c.assignid
	LEFT JOIN WilliamPagerSaga.dbo.assign a
		ON a.assignid = mat.relatedassignid
	LEFT JOIN WilliamPagerSaga.dbo.matter m
		ON m.MATTERID = a.MATTERID
	LEFT JOIN WilliamPagerSaga.dbo.entities e
		ON e.ENTITYID = a.entityid
	LEFT JOIN sma_MST_IndvContacts
		ON cinsGrade = e.ENTITYID
	LEFT JOIN sma_TRN_CaseS
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN sma_mst_orgcontacts
		ON connLevelNo = z.ENTITYID
	LEFT JOIN sma_TRN_Courts
		ON crtnCaseID = casnCaseID
			AND crtnCourtID = connContactID
	LEFT JOIN sma_TRN_CourtDocket
		ON crdnCourtsID = crtnPKCourtsID
	WHERE crdnCourtDocketID IS NULL
		AND cinnContactID IS NOT NULL

ALTER TABLE sma_mst_indvcontacts ENABLE TRIGGER ALL