USE WilliamPagerSA

SET ANSI_WARNINGS OFF
GO
INSERT INTO [sma_MST_MailingLists]
	SELECT DISTINCT
		code
	   ,DESCRIPTION
	   ,GETDATE()
	   ,368
	   ,NULL
	   ,NULL
	FROM WilliamPagerSaga.dbo.LW_MAILING
	WHERE NOT EXISTS (
			SELECT
				*
			FROM [sma_MST_MailingLists]
			WHERE DESCRIPTION = MailingListsDescription
		)
GO
INSERT INTO [sma_MST_MailingListContacts]
	SELECT DISTINCT
		MailingListID
	   ,'1' + CAST(cinnContactID AS VARCHAR(20))
	   ,GETDATE()
	   ,368
	FROM WilliamPagerSaga.dbo.LW_ENTMAILAS a
	LEFT JOIN WilliamPagerSaga.dbo.LW_MAILING b
		ON a.MAILINGID = b.LW_MAILINGID
	LEFT JOIN [sma_MST_MailingLists]
		ON DESCRIPTION = MailingListsDescription
	JOIN sma_MST_IndvContacts
		ON cinsGrade = ENTITYID
GO
INSERT INTO [sma_MST_MailingListContacts]
	SELECT DISTINCT
		MailingListID
	   ,'2' + CAST(connContactID AS VARCHAR(20))
	   ,GETDATE()
	   ,368
	FROM WilliamPagerSaga.dbo.LW_ENTMAILAS a
	LEFT JOIN WilliamPagerSaga.dbo.LW_MAILING b
		ON a.MAILINGID = b.LW_MAILINGID
	LEFT JOIN WilliamPagerSaga.dbo.ENTITIES e
		ON e.ENTITYID = a.ENTITYID
	LEFT JOIN [sma_MST_MailingLists]
		ON DESCRIPTION = MailingListsDescription
	JOIN sma_MST_orgContacts
		ON consName = ISNULL(last_company, '')
			OR consName = ISNULL(ENTITYNAME, '')
	WHERE NOT EXISTS (
			SELECT
				*
			FROM sma_MST_IndvContacts
			WHERE cinsGrade = a.ENTITYID
		)



