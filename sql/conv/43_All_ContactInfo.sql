set ansi_warnings off
go
drop table [sma_MST_AllContactInfo]
GO

/****** Object:  Table [dbo].[sma_MST_AllContactInfo]    Script Date: 10/13/2014 12:21:32 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[sma_MST_AllContactInfo](
	[uId] [bigint] IDENTITY(1,1) NOT NULL,
	[UniqueContactId] [bigint] NOT NULL,
	[ContactId] [bigint] NOT NULL,
	[ContactCtg] [tinyint] NOT NULL,
	[Name] [varchar](110) NULL,
	[FirstName] [varchar](50) NULL,
	[LastName] [varchar](90) NULL,
	[AddressId] [bigint] NULL,
	[Address1] [varchar](75) NULL,
	[Address2] [varchar](75) NULL,
	[Address3] [varchar](75) NULL,
	[City] [varchar](50) NULL,
	[State] [varchar](20) NULL,
	[Zip] [varchar](10) NULL,
	[ContactNumber] [varchar](80) NULL,
	[ContactEmail] [varchar](255) NULL,
	[ContactTypeId] [int] NULL,
	[ContactType] [varchar](50) NULL,
	[Comments] [varchar](500) NULL,
	[DateModified] [datetime] NULL,
	[ModifyUserId] [int] NULL,
	[IsDeleted] [bit] NULL,
	[NameForLetters] [nvarchar](255) NULL,
	[DateOfBirth] [datetime] NULL,
	[SSNNo] [varchar](20) NULL,
 CONSTRAINT [PK_sma_MST_AllContactInfo] PRIMARY KEY CLUSTERED 
(
	[uId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO



delete from sma_MST_AllContactInfo
go
--insert org contacts

INSERT INTO [dbo].[sma_MST_AllContactInfo]
           ([UniqueContactId]
           ,[ContactId]
           ,[ContactCtg]
           ,[Name]
,[NameForLetters]
           ,[FirstName]
           ,[LastName]
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
           ,[IsDeleted])
     
	 SELECT convert(bigint, ('2' + convert(varchar(30),sma_MST_OrgContacts.connContactID))) as UniqueContactId,
			 convert(bigint,sma_MST_OrgContacts.connContactID) as ContactId,
			 2 as ContactCtg ,
			 sma_MST_OrgContacts.consName as Name,
			sma_MST_OrgContacts.consName,
			 null as FirstName,
			 null as LastName, 
			 null as AddressId,
			 null as Address1,
			 null as Address2,
			 null as Address3,
			 null as City,
			 null as State,
			 null as Zip,
			 null as ContactNumber,
			 null as ContactEmail,
			 sma_MST_OrgContacts.connContactTypeID as ContactTypeId,
			 sma_MST_OriginalContactTypes.octsDscrptn as ContactType,
			 sma_MST_OrgContacts.consComments as Comments, 
			 GetDate() as DateModified,
			 347 as ModifyUserId,
			 0 as IsDeleted
	 FROM sma_MST_OrgContacts
	 left join sma_MST_OriginalContactTypes on sma_MST_OriginalContactTypes.octnOrigContactTypeID = sma_MST_OrgContacts.connContactTypeID
GO
--insert individual contacts

INSERT INTO [dbo].[sma_MST_AllContactInfo]
           ([UniqueContactId]
           ,[ContactId]
           ,[ContactCtg]
           ,[Name]
           ,[NameForLetters]
           ,[FirstName]
           ,[LastName]
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
	,[DateOfBirth],
[SSNNo] )
     
	 SELECT convert(bigint, ('1' + convert(varchar(30),sma_MST_IndvContacts.cinnContactID))) as UniqueContactId,
			 convert(bigint,sma_MST_IndvContacts.cinnContactID) as ContactId,
			 1 as ContactCtg ,
			  CASE ISNULL(cinsLastName,'') WHEN  '' THEN '' ELSE cinsLastName + ', ' END +
				CASE ISNULL([cinsFirstName],'') WHEN '' THEN '' ELSE [cinsFirstName] END 
				+ CASE ISNULL(cinsMiddleName, '') WHEN '' THEN '' ELSE  ' ' + SUBSTRING(cinsMiddleName, 1, 1) + '.' END 
				+ CASE ISNULL(cinsSuffix, '') WHEN '' THEN '' ELSE  ', ' + cinsSuffix END   as Name,
			CASE ISNULL([cinsFirstName],'') WHEN '' THEN '' ELSE [cinsFirstName] END 
			+  CASE ISNULL(cinsMiddleName, '') WHEN '' THEN '' ELSE  ' ' + SUBSTRING(cinsMiddleName, 1, 1) + '.' END 
			+ CASE ISNULL(cinsLastName,'') WHEN '' THEN '' ELSE ' ' + cinsLastName END 
			+ CASE ISNULL(cinsSuffix, '') WHEN '' THEN '' ELSE ', ' + cinsSuffix END AS [NameForLetters],

			 isnull(sma_MST_IndvContacts.cinsFirstName, '') as FirstName,
			 isnull(sma_MST_IndvContacts.cinsLastName, '') as LastName,
			 null as AddressId,
			 null as Address1,
			 null as Address2,
			 null as Address3,
			 null as City,
			 null as State,
			 null as Zip,
			 null as ContactNumber,
			 null as ContactEmail,
			 sma_MST_IndvContacts.cinnContactTypeID as ContactTypeId,
			 sma_MST_OriginalContactTypes.octsDscrptn as ContactType,
			 sma_MST_IndvContacts.cinsComments as Comments, 
			 GetDate() as DateModified,
			 347 as ModifyUserId,
			 0 as IsDeleted,
			[cindBirthDate],
			[cinsSSNNo]
	 FROM sma_MST_IndvContacts
	 left join sma_MST_OriginalContactTypes on sma_MST_OriginalContactTypes.octnOrigContactTypeID = sma_MST_IndvContacts.cinnContactTypeID

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
 FROM
    sma_MST_AllContactInfo AllInfo
INNER JOIN sma_MST_Address Addrr ON (AllInfo.ContactId = Addrr.addnContactID)  AND (AllInfo.ContactCtg = Addrr.addnContactCtgID) 
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
 FROM
    sma_MST_AllContactInfo AllInfo
INNER JOIN sma_MST_Address Addrr ON (AllInfo.ContactId = Addrr.addnContactID)  AND (AllInfo.ContactCtg = Addrr.addnContactCtgID) AND Addrr.addbPrimary = 1
GO
--fill out email information
UPDATE [dbo].[sma_MST_AllContactInfo]
   SET [ContactEmail] = Email.cewsEmailWebSite
  FROM
    sma_MST_AllContactInfo AllInfo
INNER JOIN sma_MST_EmailWebsite Email ON (AllInfo.ContactId = Email.cewnContactID)  AND (AllInfo.ContactCtg = Email.cewnContactCtgID) AND Email.cewsEmailWebsiteFlag = 'E' 
GO

--fill out default email information
UPDATE [dbo].[sma_MST_AllContactInfo]
   SET [ContactEmail] = Email.cewsEmailWebSite
  FROM
    sma_MST_AllContactInfo AllInfo
INNER JOIN sma_MST_EmailWebsite Email ON (AllInfo.ContactId = Email.cewnContactID)  AND (AllInfo.ContactCtg = Email.cewnContactCtgID) AND Email.cewsEmailWebsiteFlag = 'E' AND Email.cewbDefault = 1
GO
--fill out phone information
UPDATE [dbo].[sma_MST_AllContactInfo]
   SET ContactNumber = Phones.cnnsContactNumber + (CASE WHEN Phones.[cnnsExtension] IS NULL THEN '' WHEN Phones.[cnnsExtension] = '' THEN '' ELSE ' x' + Phones.[cnnsExtension] + '' END) 
  FROM
    sma_MST_AllContactInfo AllInfo
INNER JOIN sma_MST_ContactNumbers Phones ON (AllInfo.ContactId = Phones.cnnnContactID)  AND (AllInfo.ContactCtg = Phones.cnnnContactCtgID) 
GO

--fill out default phone information
UPDATE [dbo].[sma_MST_AllContactInfo]
   SET ContactNumber = Phones.cnnsContactNumber+ (CASE WHEN Phones.[cnnsExtension] IS NULL THEN '' WHEN Phones.[cnnsExtension] = '' THEN '' ELSE ' x' + Phones.[cnnsExtension] + '' END) 
  FROM
    sma_MST_AllContactInfo AllInfo
INNER JOIN sma_MST_ContactNumbers Phones ON (AllInfo.ContactId = Phones.cnnnContactID)  AND (AllInfo.ContactCtg = Phones.cnnnContactCtgID)  AND Phones.cnnbPrimary = 1

GO
delete from [sma_MST_ContactTypesForContact]
INSERT INTO [sma_MST_ContactTypesForContact]
([ctcnContactCtgID],[ctcnContactID],[ctcnContactTypeID],[ctcnRecUserID],[ctcdDtCreated])
Select distinct  advnSrcContactCtg,advnSrcContactID,71,368,getdate() from sma_TRN_PdAdvt
Union
Select distinct 2,lwfnLawFirmContactID,9,368,GETDATE() from sma_TRN_LawFirms
Union
Select distinct 1,lwfnAttorneyContactID,7,368,GETDATE() from sma_TRN_LawFirms    
Union
Select distinct 2,incnInsContactID,11,368,GETDATE() from sma_TRN_InsuranceCoverage
Union
Select distinct 1,incnAdjContactId,8,368,GETDATE() from sma_TRN_InsuranceCoverage
Union
select distinct 1,pornPOContactID,86,368,GETDATE() from sma_TRN_PoliceReports
Union
Select distinct 1,usrncontactid,44,368,GETDATE() from sma_mst_users
