USE WilliamPagerSA

DROP TABLE [sma_MST_AllContactInfo]
GO

/****** Object:  Table [dbo].[sma_MST_AllContactInfo]    Script Date: 9/9/2015 12:29:41 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[sma_MST_AllContactInfo] (
	[uId] [BIGINT] IDENTITY (1, 1) NOT NULL
   ,[UniqueContactId] [BIGINT] NOT NULL
   ,[ContactId] [BIGINT] NOT NULL
   ,[ContactCtg] [TINYINT] NOT NULL
   ,[Name] [VARCHAR](110) NULL
   ,[FirstName] [VARCHAR](50) NULL
   ,[LastName] [VARCHAR](90) NULL
   ,[OtherName] [NVARCHAR](255) NULL
   ,[AddressId] [BIGINT] NULL
   ,[Address1] [VARCHAR](75) NULL
   ,[Address2] [VARCHAR](75) NULL
   ,[Address3] [VARCHAR](75) NULL
   ,[City] [VARCHAR](50) NULL
   ,[State] [VARCHAR](20) NULL
   ,[Zip] [VARCHAR](10) NULL
   ,[ContactNumber] [VARCHAR](80) NULL
   ,[ContactEmail] [VARCHAR](255) NULL
   ,[ContactTypeId] [INT] NULL
   ,[ContactType] [VARCHAR](50) NULL
   ,[Comments] [VARCHAR](500) NULL
   ,[DateModified] [DATETIME] NULL
   ,[ModifyUserId] [INT] NULL
   ,[IsDeleted] [BIT] NULL
   ,[NameForLetters] [NVARCHAR](255) NULL
   ,[DateOfBirth] [DATETIME] NULL
   ,
	--                [SSNNo] [varchar](20) NULL,
	[SSNNo] [VARCHAR](80) NULL
   ,[County] [VARCHAR](50) NULL
   ,[IsActive] [BIT] NULL
   ,CONSTRAINT [PK_sma_MST_AllContactInfo] PRIMARY KEY CLUSTERED
	(
	[uId] ASC
	) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


DELETE FROM sma_MST_AllContactInfo
GO
--insert org contacts

INSERT INTO [dbo].[sma_MST_AllContactInfo]
	(
	[UniqueContactId]
   ,[ContactId]
   ,[ContactCtg]
   ,[Name]
   ,[NameForLetters]
   ,[FirstName]
   ,[LastName]
   ,[OtherName]
   ,[AddressId]
   ,[Address1]
   ,[Address2]
   ,[Address3]
   ,[City]
   ,[State]
   ,[Zip]
   ,[ContactNumber]
   ,[ContactEmail]
   ,[ContactTypeId]
   ,[ContactType]
   ,[Comments]
   ,[DateModified]
   ,[ModifyUserId]
   ,[IsDeleted]
   ,[IsActive]
	)

	SELECT
		CONVERT(BIGINT, ('2' + CONVERT(VARCHAR(30), sma_MST_OrgContacts.connContactID))) AS UniqueContactId
	   ,CONVERT(BIGINT, sma_MST_OrgContacts.connContactID)								 AS ContactId
	   ,2																				 AS ContactCtg
	   ,sma_MST_OrgContacts.consName													 AS Name
	   ,sma_MST_OrgContacts.consName
	   ,NULL																			 AS FirstName
	   ,NULL																			 AS LastName
	   ,NULL																			 AS OtherName
	   ,NULL																			 AS AddressId
	   ,NULL																			 AS Address1
	   ,NULL																			 AS Address2
	   ,NULL																			 AS Address3
	   ,NULL																			 AS City
	   ,NULL																			 AS State
	   ,NULL																			 AS Zip
	   ,NULL																			 AS ContactNumber
	   ,NULL																			 AS ContactEmail
	   ,sma_MST_OrgContacts.connContactTypeID											 AS ContactTypeId
	   ,sma_MST_OriginalContactTypes.octsDscrptn										 AS ContactType
	   ,LEFT(sma_MST_OrgContacts.consComments, 500)										 AS Comments
	   ,GETDATE()																		 AS DateModified
	   ,347																				 AS ModifyUserId
	   ,0																				 AS IsDeleted
	   ,[conbStatus]
	FROM sma_MST_OrgContacts
	LEFT JOIN sma_MST_OriginalContactTypes
		ON sma_MST_OriginalContactTypes.octnOrigContactTypeID = sma_MST_OrgContacts.connContactTypeID
GO
--insert individual contacts

INSERT INTO [dbo].[sma_MST_AllContactInfo]
	(
	[UniqueContactId]
   ,[ContactId]
   ,[ContactCtg]
   ,[Name]
   ,[NameForLetters]
   ,[FirstName]
   ,[LastName]
   ,[OtherName]
   ,[AddressId]
   ,[Address1]
   ,[Address2]
   ,[Address3]
   ,[City]
   ,[State]
   ,[Zip]
   ,[ContactNumber]
   ,[ContactEmail]
   ,[ContactTypeId]
   ,[ContactType]
   ,[Comments]
   ,[DateModified]
   ,[ModifyUserId]
   ,[IsDeleted]
   ,[DateOfBirth]
   ,[SSNNo]
   ,[IsActive]
	)

	SELECT
		CONVERT(BIGINT, ('1' + CONVERT(VARCHAR(30), sma_MST_IndvContacts.cinnContactID))) AS UniqueContactId
	   ,CONVERT(BIGINT, sma_MST_IndvContacts.cinnContactID)								  AS ContactId
	   ,1																				  AS ContactCtg
	   ,CASE ISNULL(cinsLastName, '')
			WHEN ''
				THEN ''
			ELSE cinsLastName + ', '
		END +
		CASE ISNULL([cinsFirstName], '')
			WHEN ''
				THEN ''
			ELSE [cinsFirstName]
		END
		+
		CASE ISNULL(cinsMiddleName, '')
			WHEN ''
				THEN ''
			ELSE ' ' + SUBSTRING(cinsMiddleName, 1, 1) + '.'
		END
		+
		CASE ISNULL(cinsSuffix, '')
			WHEN ''
				THEN ''
			ELSE ', ' + cinsSuffix
		END																				  AS Name
	   ,CASE ISNULL([cinsFirstName], '')
			WHEN ''
				THEN ''
			ELSE [cinsFirstName]
		END
		+
		CASE ISNULL(cinsMiddleName, '')
			WHEN ''
				THEN ''
			ELSE ' ' + SUBSTRING(cinsMiddleName, 1, 1) + '.'
		END
		+
		CASE ISNULL(cinsLastName, '')
			WHEN ''
				THEN ''
			ELSE ' ' + cinsLastName
		END
		+
		CASE ISNULL(cinsSuffix, '')
			WHEN ''
				THEN ''
			ELSE ', ' + cinsSuffix
		END																				  AS [NameForLetters]
	   ,ISNULL(sma_MST_IndvContacts.cinsFirstName, '')									  AS FirstName
	   ,ISNULL(sma_MST_IndvContacts.cinsLastName, '')									  AS LastName
	   ,ISNULL(sma_MST_IndvContacts.cinsNickName, '')									  AS OtherName
	   ,NULL																			  AS AddressId
	   ,NULL																			  AS Address1
	   ,NULL																			  AS Address2
	   ,NULL																			  AS Address3
	   ,NULL																			  AS City
	   ,NULL																			  AS State
	   ,NULL																			  AS Zip
	   ,NULL																			  AS ContactNumber
	   ,NULL																			  AS ContactEmail
	   ,sma_MST_IndvContacts.cinnContactTypeID											  AS ContactTypeId
	   ,sma_MST_OriginalContactTypes.octsDscrptn										  AS ContactType
	   ,sma_MST_IndvContacts.cinsComments												  AS Comments
	   ,GETDATE()																		  AS DateModified
	   ,347																				  AS ModifyUserId
	   ,0																				  AS IsDeleted
	   ,[cindBirthDate]
	   ,[cinsSSNNo]
	   ,[cinbStatus]
	FROM sma_MST_IndvContacts
	LEFT JOIN sma_MST_OriginalContactTypes
		ON sma_MST_OriginalContactTypes.octnOrigContactTypeID = sma_MST_IndvContacts.cinnContactTypeID

GO
--fill out address information for all contact types
UPDATE [dbo].[sma_MST_AllContactInfo]
SET [AddressId] = Addrr.addnAddressID
   ,[Address1] = Addrr.addsAddress1
   ,[Address2] = Addrr.addsAddress2
   ,[Address3] = Addrr.addsAddress3
   ,[City] = Addrr.addsCity
   ,[State] = Addrr.addsStateCode
   ,[Zip] = Addrr.addsZip
   ,[County] = Addrr.addsCounty
FROM sma_MST_AllContactInfo AllInfo
INNER JOIN sma_MST_Address Addrr
	ON (AllInfo.ContactId = Addrr.addnContactID)
	AND (AllInfo.ContactCtg = Addrr.addnContactCtgID)
GO

--fill out address information for all contact types, overwriting with primary addresses
UPDATE [dbo].[sma_MST_AllContactInfo]
SET [AddressId] = Addrr.addnAddressID
   ,[Address1] = Addrr.addsAddress1
   ,[Address2] = Addrr.addsAddress2
   ,[Address3] = Addrr.addsAddress3
   ,[City] = Addrr.addsCity
   ,[State] = Addrr.addsStateCode
   ,[Zip] = Addrr.addsZip
   ,[County] = Addrr.addsCounty
FROM sma_MST_AllContactInfo AllInfo
INNER JOIN sma_MST_Address Addrr
	ON (AllInfo.ContactId = Addrr.addnContactID)
	AND (AllInfo.ContactCtg = Addrr.addnContactCtgID)
	AND Addrr.addbPrimary = 1
GO
--fill out email information
UPDATE [dbo].[sma_MST_AllContactInfo]
SET [ContactEmail] = Email.cewsEmailWebSite
FROM sma_MST_AllContactInfo AllInfo
INNER JOIN sma_MST_EmailWebsite Email
	ON (AllInfo.ContactId = Email.cewnContactID)
	AND (AllInfo.ContactCtg = Email.cewnContactCtgID)
	AND Email.cewsEmailWebsiteFlag = 'E'
GO

--fill out default email information
UPDATE [dbo].[sma_MST_AllContactInfo]
SET [ContactEmail] = Email.cewsEmailWebSite
FROM sma_MST_AllContactInfo AllInfo
INNER JOIN sma_MST_EmailWebsite Email
	ON (AllInfo.ContactId = Email.cewnContactID)
	AND (AllInfo.ContactCtg = Email.cewnContactCtgID)
	AND Email.cewsEmailWebsiteFlag = 'E'
	AND Email.cewbDefault = 1
GO
--fill out phone information
UPDATE [dbo].[sma_MST_AllContactInfo]
SET ContactNumber = Phones.cnnsContactNumber + (CASE
	WHEN Phones.[cnnsExtension] IS NULL
		THEN ''
	WHEN Phones.[cnnsExtension] = ''
		THEN ''
	ELSE ' x' + Phones.[cnnsExtension] + ''
END)
FROM sma_MST_AllContactInfo AllInfo
INNER JOIN sma_MST_ContactNumbers Phones
	ON (AllInfo.ContactId = Phones.cnnnContactID)
	AND (AllInfo.ContactCtg = Phones.cnnnContactCtgID)
GO

--fill out default phone information
UPDATE [dbo].[sma_MST_AllContactInfo]
SET ContactNumber = Phones.cnnsContactNumber + (CASE
	WHEN Phones.[cnnsExtension] IS NULL
		THEN ''
	WHEN Phones.[cnnsExtension] = ''
		THEN ''
	ELSE ' x' + Phones.[cnnsExtension] + ''
END)
FROM sma_MST_AllContactInfo AllInfo
INNER JOIN sma_MST_ContactNumbers Phones
	ON (AllInfo.ContactId = Phones.cnnnContactID)
	AND (AllInfo.ContactCtg = Phones.cnnnContactCtgID)
	AND Phones.cnnbPrimary = 1
GO
GO
DELETE FROM [sma_MST_ContactTypesForContact]
INSERT INTO [sma_MST_ContactTypesForContact]
	(
	[ctcnContactCtgID]
   ,[ctcnContactID]
   ,[ctcnContactTypeID]
   ,[ctcnRecUserID]
   ,[ctcdDtCreated]
	)
	SELECT DISTINCT
		advnSrcContactCtg
	   ,advnSrcContactID
	   ,71
	   ,368
	   ,GETDATE()
	FROM sma_TRN_PdAdvt
	UNION
	SELECT DISTINCT
		2
	   ,lwfnLawFirmContactID
	   ,9
	   ,368
	   ,GETDATE()
	FROM sma_TRN_LawFirms
	UNION
	SELECT DISTINCT
		1
	   ,lwfnAttorneyContactID
	   ,7
	   ,368
	   ,GETDATE()
	FROM sma_TRN_LawFirms
	UNION
	SELECT DISTINCT
		2
	   ,incnInsContactID
	   ,11
	   ,368
	   ,GETDATE()
	FROM sma_TRN_InsuranceCoverage
	UNION
	SELECT DISTINCT
		1
	   ,incnAdjContactId
	   ,8
	   ,368
	   ,GETDATE()
	FROM sma_TRN_InsuranceCoverage
	UNION
	SELECT DISTINCT
		1
	   ,pornPOContactID
	   ,86
	   ,368
	   ,GETDATE()
	FROM sma_TRN_PoliceReports
	UNION
	SELECT DISTINCT
		1
	   ,usrnContactID
	   ,44
	   ,368
	   ,GETDATE()
	FROM sma_MST_Users
GO

GO

/****** Object:  Index [UniqueContactId]    Script Date: 9/21/2015 12:46:06 PM ******/
CREATE NONCLUSTERED INDEX [UniqueContactId] ON [dbo].[sma_MST_AllContactInfo]
(
[UniqueContactId] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
GO



GO

/****** Object:  Index [NonClusteredIndex-20141119-152835]    Script Date: 9/21/2015 12:45:52 PM ******/
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20141119-152835] ON [dbo].[sma_MST_AllContactInfo]
(
[UniqueContactId] ASC,
[ContactId] ASC,
[ContactCtg] ASC,
[Name] ASC,
[IsDeleted] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
GO



GO

/****** Object:  Index [index_Zip]    Script Date: 9/21/2015 12:45:38 PM ******/
CREATE NONCLUSTERED INDEX [index_Zip] ON [dbo].[sma_MST_AllContactInfo]
(
[Zip] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
GO



GO

/****** Object:  Index [index_State]    Script Date: 9/21/2015 12:45:17 PM ******/
CREATE NONCLUSTERED INDEX [index_State] ON [dbo].[sma_MST_AllContactInfo]
(
[State] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
GO



GO

/****** Object:  Index [index_Name_UID]    Script Date: 9/21/2015 12:45:00 PM ******/
CREATE NONCLUSTERED INDEX [index_Name_UID] ON [dbo].[sma_MST_AllContactInfo]
(
[Name] ASC,
[UniqueContactId] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
GO



GO

/****** Object:  Index [index_ContactTypeId]    Script Date: 9/21/2015 12:44:40 PM ******/
CREATE NONCLUSTERED INDEX [index_ContactTypeId] ON [dbo].[sma_MST_AllContactInfo]
(
[ContactTypeId] ASC,
[ContactId] ASC,
[ContactCtg] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
GO



GO

/****** Object:  Index [index_ContactCtg]    Script Date: 9/21/2015 12:44:20 PM ******/
CREATE NONCLUSTERED INDEX [index_ContactCtg] ON [dbo].[sma_MST_AllContactInfo]
(
[ContactCtg] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
GO



GO

/****** Object:  Index [index_City]    Script Date: 9/21/2015 12:44:03 PM ******/
CREATE NONCLUSTERED INDEX [index_City] ON [dbo].[sma_MST_AllContactInfo]
(
[City] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
GO



GO

/****** Object:  Index [IDX_ContactID_CTG]    Script Date: 9/21/2015 12:43:35 PM ******/
CREATE NONCLUSTERED INDEX [IDX_ContactID_CTG] ON [dbo].[sma_MST_AllContactInfo]
(
[ContactId] ASC,
[ContactCtg] ASC
)
INCLUDE ([NameForLetters]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
GO



GO

/****** Object:  Index [ContactTypeIndex]    Script Date: 9/21/2015 12:43:17 PM ******/
CREATE NONCLUSTERED INDEX [ContactTypeIndex] ON [dbo].[sma_MST_AllContactInfo]
(
[ContactType] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
GO



GO

/****** Object:  Index [CategoryId_ContactId]    Script Date: 9/21/2015 12:42:59 PM ******/
CREATE NONCLUSTERED INDEX [CategoryId_ContactId] ON [dbo].[sma_MST_AllContactInfo]
(
[ContactCtg] ASC,
[ContactId] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
GO



GO

/****** Object:  Index [AddressId]    Script Date: 9/21/2015 12:42:53 PM ******/
CREATE NONCLUSTERED INDEX [AddressId] ON [dbo].[sma_MST_AllContactInfo]
(
[AddressId] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
GO

