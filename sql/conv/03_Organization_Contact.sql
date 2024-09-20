USE WilliamPagerSA

ALTER TABLE [sma_MST_OrgContacts] DISABLE TRIGGER ALL
------------------------------Insert Organization Contact Started-------------------------------------------------------------------------  
INSERT INTO [sma_MST_OrgContacts]
	(
	[conbPrimary]
   ,[connContactTypeID]
   ,[connContactSubCtgID]
   ,[consName]
   ,[conbStatus]
   ,[consEINNO]
   ,[consComments]
   ,[connContactCtg]
   ,[connRefByCtgID]
   ,[connReferredBy]
   ,[connContactPerson]
   ,[consWorkPhone]
   ,[conbPreventMailing]
   ,[connRecUserID]
   ,[condDtCreated]
   ,[connModifyUserID]
   ,[condDtModified]
   ,[connLevelNo]
   ,[consOtherName]
   ,[saga]
	)
	SELECT
		1
	   ,CASE
			WHEN et.DESCRIPTION LIKE '%hospital%'
				THEN 4
			WHEN et.DESCRIPTION LIKE '%nursing%'
				THEN 5
			WHEN et.DESCRIPTION LIKE '%doctor%'
				THEN 28
			WHEN et.DESCRIPTION LIKE '%care center%'
				THEN 6
			WHEN et.DESCRIPTION LIKE '%police%'
				THEN 16
			WHEN et.DESCRIPTION LIKE '%insurance%'
				THEN 7
			WHEN et.DESCRIPTION LIKE '%pharmacy%'
				THEN 26
			WHEN et.DESCRIPTION LIKE '%court%'
				THEN 8
			WHEN et.DESCRIPTION LIKE '%law firm%'
				THEN 12
			ELSE 11
		END
	   ,''
	   ,LAST_COMPANY
	   ,1
	   ,''
	   ,FIRST_DBA --+ ISNULL(ALIASNAMES, '')			-- ds 2024-09-20
	   ,2
	   ,NULL
	   ,NULL
	   ,''
	   ,phone
	   ,0
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
	   ,ENTITYID
	   ,SUBSTRING(ENTITYNAME, 0, 100)
	   ,''
	FROM [WilliamPagerSaga].[dbo].[ENTITIES] e
	LEFT JOIN [WilliamPagerSaga].[dbo].enttype et
		ON e.ENTITYTYPEID = et.ENTITYTYPEID
	LEFT JOIN sma_MST_IndvContacts a
		ON a.cinsGrade = e.CREATORID
	LEFT JOIN sma_mst_users u1
		ON u1.usrnContactID = a.cinnContactID
	LEFT JOIN sma_MST_IndvContacts b
		ON b.cinsGrade = e.REVISORID
	LEFT JOIN sma_mst_users u2
		ON u2.usrnContactID = b.cinnContactID
	WHERE e.ENTITYTYPEID NOT IN (
			SELECT
				ISNULL(cinsGrade, 0)
			FROM sma_MST_IndvContacts
		)
		AND ISPERSON <> 't'
	UNION
	SELECT
		1
	   ,CASE
			WHEN et.DESCRIPTION LIKE '%hospital%'
				THEN 4
			WHEN et.DESCRIPTION LIKE '%nursing%'
				THEN 5
			WHEN et.DESCRIPTION LIKE '%doctor%'
				THEN 28
			WHEN et.DESCRIPTION LIKE '%care center%'
				THEN 6
			WHEN et.DESCRIPTION LIKE '%police%'
				THEN 16
			WHEN et.DESCRIPTION LIKE '%insurance%'
				THEN 7
			WHEN et.DESCRIPTION LIKE '%pharmacy%'
				THEN 26
			WHEN et.DESCRIPTION LIKE '%court%'
				THEN 8
			WHEN et.DESCRIPTION LIKE '%law firm%'
				THEN 12
			ELSE 11
		END
	   ,''
	   ,LAST_COMPANY
	   ,1
	   ,''
	   ,FIRST_DBA --+ ISNULL(ALIASNAMES, '')			-- ds 2024-09-20
	   ,2
	   ,NULL
	   ,NULL
	   ,''
	   ,phone
	   ,0
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
	   ,ENTITYID
	   ,SUBSTRING(ENTITYNAME, 0, 100)
	   ,''
	FROM WilliamPagerSaga.dbo.ENTITIES e
	LEFT JOIN [WilliamPagerSaga].[dbo].enttype et
		ON e.ENTITYTYPEID = et.ENTITYTYPEID
	LEFT JOIN sma_MST_IndvContacts a
		ON a.cinsGrade = e.CREATORID
	LEFT JOIN sma_mst_users u1
		ON u1.usrnContactID = a.cinnContactID
	LEFT JOIN sma_MST_IndvContacts b
		ON b.cinsGrade = e.REVISORID
	LEFT JOIN sma_mst_users u2
		ON u2.usrnContactID = b.cinnContactID
	WHERE e.ENTITYID IN (
			SELECT
				entityid
			FROM WilliamPagerSaga.dbo.ENTITIES
			EXCEPT
			(SELECT
				connLevelNo
			FROM sma_mst_orgcontacts
			UNION
			SELECT
				cinsgrade
			FROM sma_MST_IndvContacts)
		)
ALTER TABLE [sma_MST_OrgContacts] ENABLE TRIGGER ALL