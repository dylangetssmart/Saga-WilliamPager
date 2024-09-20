USE WilliamPagerSA

DECLARE @Data VARCHAR(500)

-- Declare a cursor that will get staff contactid


DECLARE Advertising_Cursor CURSOR FAST_FORWARD FOR SELECT DISTINCT
	sa.DESCRIPTION
FROM [WilliamPagerSaga].dbo.matter m
LEFT JOIN [WilliamPagerSaga].dbo.assign a
	ON a.matterid = m.matterid
LEFT JOIN [WilliamPagerSaga].dbo.lw_source so
	ON so.assignid = a.assignid
LEFT JOIN [WilliamPagerSaga].dbo.lw_a_source sa
	ON so.SOURCENONENTITYID = sa.sourceid
LEFT JOIN [WilliamPagerSaga].dbo.entities e
	ON so.sourceentityid = e.entityid
LEFT JOIN [WilliamPagerSaga].dbo.LW_SOURCECAT sc
	ON sc.id = so.SOURCECATEGORY
LEFT JOIN sma_TRN_CaseS
	ON cassCaseNumber = MATTERNUMBER
WHERE sc.description = 'Advertising'
	AND sa.DESCRIPTION IS NOT NULL
--Open a cursor
OPEN Advertising_Cursor

FETCH NEXT FROM Advertising_Cursor INTO @Data

WHILE @@FETCH_STATUS = 0
BEGIN

DECLARE @p1 INT
SET @p1 = SCOPE_IDENTITY()
EXEC save_OrgContacts @connContactID = @p1 OUTPUT
					 ,@cinnContactIDU = NULL
					 ,@blnconbPrimary = 1
					 ,@intconnContactTypeID = 11
					 ,@intconnContactSubCtgID = 0
					 ,@strconsName = @Data
					 ,@blnconbStatus = 1
					 ,@strconsEINNO = '            '
					 ,@strconsComments = NULL
					 ,@intconnContactCtg = 2
					 ,@intconnRefByCtgID = NULL
					 ,@intconnReferredBy = 0
					 ,@intconnContactPerson = 0
					 ,@strconsWorkPhone = '(   )    -    '
					 ,@blnPrevent = 0
					 ,@intconnRecUserID = 368
					 ,@strOthName = NULL
					 ,@strEmail = NULL
					 ,@delete = 0
SELECT
	@p1

DECLARE @p2 INT
SET @p2 = SCOPE_IDENTITY()
EXEC save_Address @addnAddressIDU = NULL
				 ,@addnAddressID = @p2 OUTPUT
				 ,@addnContactCtgID = 2
				 ,@addnContactID = @p1
				 ,@addnAddressTypeID = 9
				 ,@addsAddressType = 'HQ/Main Office'
				 ,@addsAddTypeCode = NULL
				 ,@addsAddress1 = NULL
				 ,@addsAddress2 = NULL
				 ,@addsAddress3 = NULL
				 ,@addsStateCode = NULL
				 ,@addsCity = NULL
				 ,@addnZipID = NULL
				 ,@addsZip = NULL
				 ,@addsCounty = NULL
				 ,@addsCountry = 'USA'
				 ,@addbIsResidence = 0
				 ,@addbPrimary = 1
				 ,@adddFromDate = NULL
				 ,@adddToDate = NULL
				 ,@addnCompanyID = 0
				 ,@addsDepartment = NULL
				 ,@addsTitle = NULL
				 ,@addnContactPersonID = 0
				 ,@addsComments = NULL
				 ,@addbIsCurrent = 1
				 ,@addbIsMailing = 1
				 ,@addsZipExtn = NULL
				 ,@UserID = 368
				 ,@delete = 0
SELECT
	@p2

EXEC Insert_Contact_Numbers @contact_id = @p1
						   ,@contact_ctg_id = 2
						   ,@home_phone_number = NULL
						   ,@work_phone_number = NULL
						   ,@cell_phone_number = NULL
						   ,@other_phone_number = NULL
						   ,@ext = NULL
						   ,@address_id = @p2
						   ,@contact_type_id = 39
						   ,@update = 0
						   ,@primary_id = 2
						   ,@user_id = 368
EXEC save_ContactTypesForContact @ctcnContTypeContID = 0
								,@ctcnContactCtgID = 2
								,@ctcnContactID = @p1
								,@ctcnContactTypeID = 71
								,@ctcnRecUserID = 368
								,@blnDelete = 0


FETCH NEXT FROM Advertising_Cursor INTO @Data
END

CLOSE Advertising_Cursor
DEALLOCATE Advertising_Cursor

INSERT INTO [sma_TRN_PdAdvt]
	(
	[advnCaseID]
   ,[advnSrcContactCtg]
   ,[advnSrcContactID]
   ,[advnSrcAddressID]
   ,[advnSubTypeID]
   ,[advnPlaintiffID]
   ,[advdDateTime]
   ,[advdRetainedDt]
   ,[advnFeeStruID]
   ,[advsComments]
   ,[advnRecUserID]
   ,[advdDtCreated]
   ,[advnModifyUserID]
   ,[advdDtModified]
   ,[advnLevelNo]
	)
	SELECT DISTINCT
		casnCaseID
	   ,2
	   ,connContactID
	   ,orgAddressID
	   ,0
	   ,plnnplaintiffid
	   ,MIN(a.DATECREATED)
	   ,NULL
	   ,0
	   ,''
	   ,MIN(u1.usrnUserID)
	   ,MIN(a.DATECREATED)
	   ,MIN(u2.usrnUserID)
	   ,MIN(a.DATEREVISED)
	   ,''
	FROM [WilliamPagerSaga].dbo.matter m
	LEFT JOIN [WilliamPagerSaga].dbo.assign a
		ON a.matterid = m.matterid
	LEFT JOIN [WilliamPagerSaga].dbo.lw_source so
		ON so.assignid = a.assignid
	LEFT JOIN [WilliamPagerSaga].dbo.lw_a_source sa
		ON so.SOURCENONENTITYID = sa.sourceid
	LEFT JOIN [WilliamPagerSaga].dbo.entities e
		ON so.sourceentityid = e.entityid
	LEFT JOIN [WilliamPagerSaga].dbo.LW_SOURCECAT sc
		ON sc.id = so.SOURCECATEGORY
	LEFT JOIN sma_TRN_CaseS
		ON cassCaseNumber = MATTERNUMBER
	OUTER APPLY (
		SELECT TOP 1
			conncontactid
		FROM sma_mst_orgcontacts
		WHERE consName = sa.DESCRIPTION
	) z
	OUTER APPLY (
		SELECT TOP 1
			addnaddressid AS orgAddressID
		FROM sma_MST_Address
		WHERE addnContactID = conncontactid
			AND addnContactCtgID = 2
		ORDER BY ISNULL(addbPrimary, 0) DESC
	) b
	OUTER APPLY (
		SELECT TOP 1
			plnnplaintiffid
		FROM sma_TRN_Plaintiff
		WHERE plnnCaseID = casnCaseID
		ORDER BY ISNULL(plnbIsPrimary, 0) DESC
	) c
	LEFT JOIN sma_MST_IndvContacts l
		ON l.cinsGrade = a.CREATORID
	LEFT JOIN sma_mst_users u1
		ON u1.usrnContactID = l.cinnContactID
	LEFT JOIN sma_MST_IndvContacts n
		ON n.cinsGrade = a.REVISORID
	LEFT JOIN sma_mst_users u2
		ON u2.usrnContactID = n.cinnContactID
	WHERE sc.description = 'Advertising'
		AND casnCaseID IS NOT NULL
	GROUP BY casnCaseID
			,connContactID
			,orgAddressID
			,plnnplaintiffid


INSERT INTO [sma_TRN_OtherReferral]
	(
	[otrnCaseID]
   ,[otrnRefContactCtg]
   ,[otrnRefContactID]
   ,[otrnRefAddressID]
   ,[otrnPlaintiffID]
   ,[otrnRelationshipID]
   ,[otrdRetainedDt]
   ,[otrnFeeStruID]
   ,[otrsComments]
   ,[otrnUserID]
   ,[otrdDtCreated]
   ,[otrnModifyUserID]
   ,[otrdDtModified]
   ,[otrnLevelNo]
   ,[otrnReferralType]
	)
	SELECT DISTINCT
		casnCaseID
	   ,CASE
			WHEN conncontactid IS NOT NULL
				THEN 2
			WHEN i.cinncontactid IS NOT NULL
				THEN 1
		END
	   ,CASE
			WHEN conncontactid IS NOT NULL
				THEN connContactID
			WHEN i.cinncontactid IS NOT NULL
				THEN i.cinnContactID
		END
	   ,CASE
			WHEN conncontactid IS NOT NULL
				THEN orgAddressID
			WHEN i.cinncontactid IS NOT NULL
				THEN indAddressID
		END
	   ,0
	   ,0
	   ,NULL
	   ,0
	   ,CONVERT(VARCHAR(4000), s.COMMENTS)
	   ,(u1.usrnUserID)
	   ,(a.DATECREATED)
	   ,(u2.usrnUserID)
	   ,(a.DATEREVISED)
	   ,''
	   ,1
	FROM [WilliamPagerSaga].dbo.lw_source s
	LEFT JOIN [WilliamPagerSaga].dbo.ENTITIES e
		ON e.ENTITYID = s.SOURCEENTITYID
	LEFT JOIN [WilliamPagerSaga].dbo.ASSIGN a
		ON a.ASSIGNID = s.ASSIGNID
	LEFT JOIN [WilliamPagerSaga].dbo.MATTER m
		ON m.MATTERID = a.MATTERID
	LEFT JOIN sma_MST_IndvContacts i
		ON i.cinsGrade = e.ENTITYID
	LEFT JOIN sma_MST_orgContacts o
		ON o.connLevelNo = e.ENTITYID
	LEFT JOIN sma_trn_cases
		ON cassCaseNumber = MATTERNUMBER
	OUTER APPLY (
		SELECT TOP 1
			addnaddressid AS orgAddressID
		FROM sma_MST_Address
		WHERE addnContactID = conncontactid
			AND addnContactCtgID = 2
		ORDER BY ISNULL(addbPrimary, 0) DESC
	) b
	OUTER APPLY (
		SELECT TOP 1
			addnaddressid AS indAddressID
		FROM sma_MST_Address
		WHERE addnContactID = cinncontactid
			AND addnContactCtgID = 1
		ORDER BY ISNULL(addbPrimary, 0) DESC
	) bb
	LEFT JOIN sma_MST_IndvContacts l
		ON l.cinsGrade = a.CREATORID
	LEFT JOIN sma_mst_users u1
		ON u1.usrnContactID = l.cinnContactID
	LEFT JOIN sma_MST_IndvContacts n
		ON n.cinsGrade = a.REVISORID
	LEFT JOIN sma_mst_users u2
		ON u2.usrnContactID = n.cinnContactID
	WHERE ISENTITY = 'T'
		AND casnCaseID IS NOT NULL

INSERT INTO [sma_TRN_OtherReferral]
	(
	[otrnCaseID]
   ,[otrnRefContactCtg]
   ,[otrnRefContactID]
   ,[otrnRefAddressID]
   ,[otrnPlaintiffID]
   ,[otrnRelationshipID]
   ,[otrdRetainedDt]
   ,[otrnFeeStruID]
   ,[otrsComments]
   ,[otrnUserID]
   ,[otrdDtCreated]
   ,[otrnModifyUserID]
   ,[otrdDtModified]
   ,[otrnLevelNo]
   ,[otrnReferralType]
	)
	SELECT DISTINCT
		casnCaseID
	   ,CASE
			WHEN conncontactid IS NOT NULL
				THEN 2
		END
	   ,CASE
			WHEN conncontactid IS NOT NULL
				THEN connContactID
		END
	   ,CASE
			WHEN conncontactid IS NOT NULL
				THEN orgAddressID
		END
	   ,0
	   ,0
	   ,NULL
	   ,0
	   ,CONVERT(VARCHAR(4000), so.COMMENTS)
	   ,(u1.usrnUserID)
	   ,(a.DATECREATED)
	   ,(u2.usrnUserID)
	   ,(a.DATEREVISED)
	   ,''
	   ,1
	FROM [WilliamPagerSaga].dbo.matter m
	LEFT JOIN [WilliamPagerSaga].dbo.assign a
		ON a.matterid = m.matterid
	LEFT JOIN [WilliamPagerSaga].dbo.lw_source so
		ON so.assignid = a.assignid
	LEFT JOIN [WilliamPagerSaga].dbo.lw_a_source sa
		ON so.SOURCENONENTITYID = sa.sourceid
	LEFT JOIN [WilliamPagerSaga].dbo.entities e
		ON so.sourceentityid = e.entityid
	LEFT JOIN [WilliamPagerSaga].dbo.entities es
		ON m.CLIENTID = es.entityid
	LEFT JOIN [WilliamPagerSaga].dbo.LW_SOURCECAT sc
		ON sc.id = so.SOURCECATEGORY
	LEFT JOIN sma_TRN_CaseS
		ON cassCaseNumber = MATTERNUMBER
	OUTER APPLY (
		SELECT TOP 1
			conncontactid
		FROM sma_mst_orgcontacts
		WHERE consName = sa.DESCRIPTION
	) z
	OUTER APPLY (
		SELECT TOP 1
			addnaddressid AS orgAddressID
		FROM sma_MST_Address
		WHERE addnContactID = conncontactid
			AND addnContactCtgID = 2
		ORDER BY ISNULL(addbPrimary, 0) DESC
	) b
	OUTER APPLY (
		SELECT TOP 1
			plnnplaintiffid
		FROM sma_TRN_Plaintiff
		WHERE plnnCaseID = casnCaseID
		ORDER BY ISNULL(plnbIsPrimary, 0) DESC
	) c
	LEFT JOIN sma_MST_IndvContacts l
		ON l.cinsGrade = a.CREATORID
	LEFT JOIN sma_mst_users u1
		ON u1.usrnContactID = l.cinnContactID
	LEFT JOIN sma_MST_IndvContacts n
		ON n.cinsGrade = a.REVISORID
	LEFT JOIN sma_mst_users u2
		ON u2.usrnContactID = n.cinnContactID
	WHERE sc.description <> 'Advertising'
		AND sc.Description NOT LIKE '%referral%'
		AND casnCaseID IS NOT NULL
GO
DECLARE @Data1 VARCHAR(500)

-- Declare a cursor that will get staff contactid


DECLARE Advertising1_Cursor CURSOR FAST_FORWARD FOR SELECT DISTINCT
	sa.DESCRIPTION
FROM [WilliamPagerSaga].dbo.lw_a_source sa
LEFT JOIN [WilliamPagerSaga].dbo.lw_source so
	ON so.SOURCENONENTITYID = sa.sourceid
LEFT JOIN [WilliamPagerSaga].dbo.LW_SOURCECAT sc
	ON sc.id = so.SOURCECATEGORY
WHERE sc.description <> 'Advertising'
	AND sa.DESCRIPTION IS NOT NULL
	AND NOT EXISTS (
		SELECT
			*
		FROM sma_mst_orgcontacts
		WHERE consName = sa.DESCRIPTION
	)
--Open a cursor
OPEN Advertising1_Cursor

FETCH NEXT FROM Advertising1_Cursor INTO @Data1

WHILE @@FETCH_STATUS = 0
BEGIN

DECLARE @p1 INT
SET @p1 = SCOPE_IDENTITY()
EXEC save_OrgContacts @connContactID = @p1 OUTPUT
					 ,@cinnContactIDU = NULL
					 ,@blnconbPrimary = 1
					 ,@intconnContactTypeID = 11
					 ,@intconnContactSubCtgID = 0
					 ,@strconsName = @Data1
					 ,@blnconbStatus = 1
					 ,@strconsEINNO = '            '
					 ,@strconsComments = NULL
					 ,@intconnContactCtg = 2
					 ,@intconnRefByCtgID = NULL
					 ,@intconnReferredBy = 0
					 ,@intconnContactPerson = 0
					 ,@strconsWorkPhone = '(   )    -    '
					 ,@blnPrevent = 0
					 ,@intconnRecUserID = 368
					 ,@strOthName = NULL
					 ,@strEmail = NULL
					 ,@delete = 0
SELECT
	@p1

DECLARE @p2 INT
SET @p2 = SCOPE_IDENTITY()
EXEC save_Address @addnAddressIDU = NULL
				 ,@addnAddressID = @p2 OUTPUT
				 ,@addnContactCtgID = 2
				 ,@addnContactID = @p1
				 ,@addnAddressTypeID = 9
				 ,@addsAddressType = 'HQ/Main Office'
				 ,@addsAddTypeCode = NULL
				 ,@addsAddress1 = NULL
				 ,@addsAddress2 = NULL
				 ,@addsAddress3 = NULL
				 ,@addsStateCode = NULL
				 ,@addsCity = NULL
				 ,@addnZipID = NULL
				 ,@addsZip = NULL
				 ,@addsCounty = NULL
				 ,@addsCountry = 'USA'
				 ,@addbIsResidence = 0
				 ,@addbPrimary = 1
				 ,@adddFromDate = NULL
				 ,@adddToDate = NULL
				 ,@addnCompanyID = 0
				 ,@addsDepartment = NULL
				 ,@addsTitle = NULL
				 ,@addnContactPersonID = 0
				 ,@addsComments = NULL
				 ,@addbIsCurrent = 1
				 ,@addbIsMailing = 1
				 ,@addsZipExtn = NULL
				 ,@UserID = 368
				 ,@delete = 0
SELECT
	@p2

EXEC Insert_Contact_Numbers @contact_id = @p1
						   ,@contact_ctg_id = 2
						   ,@home_phone_number = NULL
						   ,@work_phone_number = NULL
						   ,@cell_phone_number = NULL
						   ,@other_phone_number = NULL
						   ,@ext = NULL
						   ,@address_id = @p2
						   ,@contact_type_id = 39
						   ,@update = 0
						   ,@primary_id = 2
						   ,@user_id = 368
EXEC save_ContactTypesForContact @ctcnContTypeContID = 0
								,@ctcnContactCtgID = 2
								,@ctcnContactID = @p1
								,@ctcnContactTypeID = 71
								,@ctcnRecUserID = 368
								,@blnDelete = 0


FETCH NEXT FROM Advertising1_Cursor INTO @Data1
END

CLOSE Advertising1_Cursor
DEALLOCATE Advertising1_Cursor
GO
INSERT INTO [sma_TRN_OtherReferral]
	(
	[otrnCaseID]
   ,[otrnRefContactCtg]
   ,[otrnRefContactID]
   ,[otrnRefAddressID]
   ,[otrnPlaintiffID]
   ,[otrnRelationshipID]
   ,[otrdRetainedDt]
   ,[otrnFeeStruID]
   ,[otrsComments]
   ,[otrnUserID]
   ,[otrdDtCreated]
   ,[otrnModifyUserID]
   ,[otrdDtModified]
   ,[otrnLevelNo]
   ,[otrnReferralType]
	)
	SELECT DISTINCT
		casnCaseID
	   ,CASE
			WHEN conncontactid IS NOT NULL
				THEN 2
		END
	   ,CASE
			WHEN conncontactid IS NOT NULL
				THEN connContactID
		END
	   ,CASE
			WHEN conncontactid IS NOT NULL
				THEN orgAddressID
		END
	   ,0
	   ,0
	   ,NULL
	   ,0
	   ,CONVERT(VARCHAR(4000), so.COMMENTS)
	   ,(u1.usrnUserID)
	   ,(a.DATECREATED)
	   ,(u2.usrnUserID)
	   ,(a.DATEREVISED)
	   ,''
	   ,1
	FROM [WilliamPagerSaga].dbo.matter m
	LEFT JOIN [WilliamPagerSaga].dbo.assign a
		ON a.matterid = m.matterid
	LEFT JOIN [WilliamPagerSaga].dbo.lw_source so
		ON so.assignid = a.assignid
	LEFT JOIN [WilliamPagerSaga].dbo.lw_a_source sa
		ON so.SOURCENONENTITYID = sa.sourceid
	LEFT JOIN [WilliamPagerSaga].dbo.entities e
		ON so.sourceentityid = e.entityid
	LEFT JOIN [WilliamPagerSaga].dbo.entities es
		ON m.CLIENTID = es.entityid
	LEFT JOIN [WilliamPagerSaga].dbo.LW_SOURCECAT sc
		ON sc.id = so.SOURCECATEGORY
	LEFT JOIN sma_TRN_CaseS
		ON cassCaseNumber = MATTERNUMBER
	OUTER APPLY (
		SELECT TOP 1
			conncontactid
		FROM sma_mst_orgcontacts
		WHERE consName = sa.DESCRIPTION
	) z
	OUTER APPLY (
		SELECT TOP 1
			addnaddressid AS orgAddressID
		FROM sma_MST_Address
		WHERE addnContactID = conncontactid
			AND addnContactCtgID = 2
		ORDER BY ISNULL(addbPrimary, 0) DESC
	) b
	OUTER APPLY (
		SELECT TOP 1
			plnnplaintiffid
		FROM sma_TRN_Plaintiff
		WHERE plnnCaseID = casnCaseID
		ORDER BY ISNULL(plnbIsPrimary, 0) DESC
	) c
	LEFT JOIN sma_MST_IndvContacts l
		ON l.cinsGrade = a.CREATORID
	LEFT JOIN sma_mst_users u1
		ON u1.usrnContactID = l.cinnContactID
	LEFT JOIN sma_MST_IndvContacts n
		ON n.cinsGrade = a.REVISORID
	LEFT JOIN sma_mst_users u2
		ON u2.usrnContactID = n.cinnContactID
	WHERE casnCaseID IS NOT NULL
		AND casnCaseID NOT IN (
			SELECT
				advncaseid
			FROM sma_trn_pdadvt
		)
		AND casnCaseID NOT IN (
			SELECT
				otrncaseid
			FROM [sma_TRN_OtherReferral]
		)
		AND CASE
			WHEN conncontactid IS NOT NULL
				THEN connContactID
		END IS NOT NULL