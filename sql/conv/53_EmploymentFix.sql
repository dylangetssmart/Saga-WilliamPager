USE WilliamPagerSA

ALTER TABLE sma_mst_orgcontacts
ALTER COLUMN saga VARCHAR(200)
GO
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
	SELECT DISTINCT
		1
	   ,11
	   ,''
	   ,ISNULL(LAST_COMPANY, '') + ISNULL(', ' + FIRST_DBA, '')
	   ,1
	   ,''
	   ,FIRST_DBA + ISNULL(ALIASNAMES, '')
	   ,2
	   ,NULL
	   ,NULL
	   ,''
	   ,phone
	   ,0
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,e.ENTITYID
	   ,SUBSTRING(ENTITYNAME, 0, 100)
	   ,'E' + CAST(e.ENTITYID AS VARCHAR(50))
	FROM WilliamPagerSaga.dbo.ENTITIES e
	JOIN [WilliamPagerSaga].dbo.assign a
		ON a.ENTITYID = e.ENTITYID
	JOIN [WilliamPagerSaga].dbo.matrelt mt
		ON mt.RELATEDASSIGNID = a.ASSIGNID
	JOIN [WilliamPagerSaga].dbo.lw_emp e1
		ON e1.MATRELTID = mt.MATRELTID
	WHERE ISPERSON = 'T'
		AND NOT EXISTS (
			SELECT
				*
			FROM sma_mst_orgcontacts
			WHERE connLevelNo = e.ENTITYID
		)
GO
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
	   ,connContactID
	   ,12
	   ,'Office'
	   ,'WRK'
	   ,SUBSTRING(addsAddress1, 0, 75)
	   ,SUBSTRING(ISNULL(addsAddress2, ''), 0, 75)
	   ,''
	   ,SUBSTRING(addsStateCode, 0, 20)
	   ,SUBSTRING(addsCity, 0, 50)
	   ,''
	   ,SUBSTRING(addsZip, 0, 6)
	   ,SUBSTRING(addsCounty, 0, 30)
	   ,'USA'
	   ,addbIsResidence
	   ,addbPrimary
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,''
	   ,addbIsCurrent
	   ,addbIsMailing
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	   ,''
	   ,NULL
	   ,addsZipExtn
	   ,''
	FROM sma_MST_OrgContacts o
	JOIN sma_MST_IndvContacts i
		ON 'e' + i.cinsGrade = o.saga
	JOIN sma_MST_Address
		ON addnContactCtgID = 1
			AND addnContactID = cinnContactID
	WHERE o.saga LIKE 'e%'
GO
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
	SELECT DISTINCT
		2
	   ,connContactID
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
	   ,c.[saga]
	FROM sma_MST_OrgContacts o
	JOIN sma_MST_IndvContacts i
		ON 'e' + i.cinsGrade = o.saga
	JOIN [sma_MST_ContactNumbers] c
		ON cnnnContactCtgID = 1
			AND cnnnContactID = cinnContactID
	WHERE o.saga LIKE 'e%'
GO
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
	   ,connContactID
	   ,[cewsEmailWebsiteFlag]
	   ,[cewsEmailWebSite]
	   ,[cewbDefault]
	   ,[cewnRecUserID]
	   ,[cewdDtCreated]
	   ,[cewnModifyUserID]
	   ,[cewdDtModified]
	   ,[cewnLevelNo]
	   ,e.[saga]
	FROM sma_MST_OrgContacts o
	JOIN sma_MST_IndvContacts i
		ON 'e' + i.cinsGrade = o.saga
	JOIN [sma_MST_EmailWebsite] e
		ON cewnContactCtgID = 1
			AND cewnContactID = cinnContactID
	WHERE o.saga LIKE 'e%'

GO
INSERT INTO [sma_TRN_Employment]
	(
	[empnPlaintiffID]
   ,[empnEmprAddressID]
   ,[empnEmployerID]
   ,[empnContactPersonID]
   ,[empnCPAddressId]
   ,[empsJobTitle]
   ,[empnSalaryFreqID]
   ,[empnSalaryAmt]
   ,[empnCommissionFreqID]
   ,[empnCommissionAmt]
   ,[empnBonusFreqID]
   ,[empnBonusAmt]
   ,[empnOverTimeFreqID]
   ,[empnOverTimeAmt]
   ,[empnOtherFreqID]
   ,[empnOtherCompensationAmt]
   ,[empsComments]
   ,[empbWorksOffBooks]
   ,[empsCompensationComments]
   ,[empbWorksPartiallyOffBooks]
   ,[empbOnTheJob]
   ,[empbWCClaim]
   ,[empbContinuing]
   ,[empdDateHired]
   ,[empnUDF1]
   ,[empnUDF2]
   ,[empnRecUserID]
   ,[empdDtCreated]
   ,[empnModifyUserID]
   ,[empdDtModified]
   ,[empnLevelNo]
   ,[empnauthtodefcoun]
   ,[empnauthtodefcounDt]
	)
	SELECT DISTINCT
		plnnPlaintiffID
	   ,CASE
			WHEN o1.connContactID IS NOT NULL
				THEN z2.addnAddressID
		END AS AddressID
	   ,o1.connContactID
	   ,NULL
	   ,NULL
	   ,POSITION
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,CONVERT(VARCHAR(4000), LTRIM(REPLACE(
		dbo.RegExReplace(NOTES, '({\\)(.+?)(})|(\\)(.+?)(\b)', '')
		, '}', '')
		))
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,CASE
			WHEN STARTDATE BETWEEN '1/1/1900' AND '12/31/2079'
				THEN STARTDATE
			ELSE NULL
		END
	   ,NULL
	   ,NULL
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	   ,''
	   ,''
	FROM [WilliamPagerSaga].dbo.lw_emp e
	LEFT JOIN [WilliamPagerSaga].dbo.matrelt mt
		ON e.MATRELTID = mt.MATRELTID
	LEFT JOIN [WilliamPagerSaga].dbo.assign aemp
		ON aemp.assignid = mt.RelatedAssignID
	LEFT JOIN [WilliamPagerSaga].dbo.entities eemp
		ON eemp.entityid = aemp.entityid
	LEFT JOIN [WilliamPagerSaga].dbo.matter m
		ON m.MATTERID = aemp.MATTERID
	LEFT JOIN [WilliamPagerSaga].dbo.assign apl
		ON apl.assignid = mt.AssignID
	LEFT JOIN [WilliamPagerSaga].dbo.entities epl
		ON epl.entityid = apl.entityid
			AND apl.partytype = 1
	LEFT JOIN [WilliamPagerSaga].dbo.LW_SPECIALS ls
		ON e.MATRELTID = ls.MATRELTID
	LEFT JOIN [WilliamPagerSaga].dbo.NOTE n
		ON n.NOTEID = mt.NOTEID
	LEFT JOIN sma_trn_cases
		ON m.MATTERNUMBER = cassCaseNumber
	--left join sma_MST_IndvContacts i1 on i1.cinsGrade=eemp.ENTITYID and i1.cinsLastName=eemp.LAST_COMPANY
	LEFT JOIN sma_mst_orgcontacts o1
		ON o1.connLevelNo = eemp.ENTITYID
			AND o1.consName = ISNULL(eemp.LAST_COMPANY, '') + ISNULL(', ' + eemp.FIRST_DBA, '')
	LEFT JOIN sma_MST_IndvContacts i2
		ON i2.cinsGrade = epl.ENTITYID
			AND i2.cinsLastName = epl.LAST_COMPANY
	LEFT JOIN sma_mst_orgcontacts o2
		ON o2.connLevelNo = epl.ENTITYID
			AND o2.consName = epl.LAST_COMPANY
	LEFT JOIN sma_TRN_Plaintiff
		ON plnnCaseID = casnCaseID
			AND ((plnnContactID = i2.cinnContactID
					AND plnnContactCtg = 1)
				OR (plnnContactID = o2.connContactID
					AND plnnContactCtg = 2))
	--outer apply(select top 1 addnaddressid,addsAddress1,addsAddress2,addsAddress3,addsCity,addsStateCode,addsZip from  sma_MST_Address where addnContactID=i1.cinnContactID and addnContactCtgID=1 and addbPrimary=1 order by isnull(addbPrimary,0) desc) z1
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
		WHERE addnContactID = o1.connContactID
			AND addnContactCtgID = 2
			AND addbPrimary = 1
		ORDER BY ISNULL(addbPrimary, 0) DESC
	) z2

	WHERE apl.partytype = 1
		AND CASE
			WHEN o1.connContactID IS NOT NULL
				THEN z2.addnAddressID
		END IS NOT NULL
		AND plnnPlaintiffID IS NOT NULL
		AND o1.saga LIKE 'e%'
GO

UPDATE e
SET empnContactPersonID = 0
   ,empnCPAddressId = 0
   ,empnSalaryAmt = '0.00'
   ,empnCommissionAmt = '0.00'
   ,empnBonusAmt = '0.00'
   ,empnOverTimeAmt = '0.00'
   ,empnOtherCompensationAmt = '0.00'
   ,empbWorksOffBooks = 0
   ,empbWorksPartiallyOffBooks = 0
   ,empbOnTheJob = 0
   ,empbWCClaim = 0
   ,empbContinuing = 0
   ,empnUDF1 = 0
   ,empnUDF2 = 0
FROM sma_TRN_Employment e
JOIN sma_MST_OrgContacts
	ON e.empnEmployerID = connContactID
WHERE saga LIKE 'e%'
GO
UPDATE e
SET empsComments = dbo.RemoveNonASCII(empsComments)
FROM sma_TRN_Employment e
JOIN sma_MST_OrgContacts
	ON e.empnEmployerID = connContactID
WHERE saga LIKE 'e%'
GO

INSERT INTO [sma_TRN_LostWages]
	(
	[ltwnEmploymentID]
   ,[ltwsType]
   ,[ltwdFrmDt]
   ,[ltwdToDt]
   ,[ltwnAmount]
   ,[ltwnAmtPaid]
   ,[ltwnLoss]
   ,[ltwdMDConfReqDt]
   ,[ltwdMDConfDt]
   ,[ltwdEmpVerfReqDt]
   ,[ltwdEmpVerfRcvdDt]
   ,[ltwnRecUserID]
   ,[ltwdDtCreated]
   ,[ltwnModifyUserID]
   ,[ltwdDtModified]
   ,[ltwnLevelNo]
	)
	SELECT DISTINCT
		empnEmploymentID
	   ,CASE WAGEUNIT
			WHEN 0
				THEN 12
			ELSE 11
		END
	   ,CASE
			WHEN ISDATE(STARTDATE) = 1 AND
				STARTDATE BETWEEN '1/1/1900' AND '12/31/2079'
				THEN STARTDATE
			ELSE NULL
		END
	   ,CASE
			WHEN ISDATE(ENDDATE) = 1 AND
				ENDDATE BETWEEN '1/1/1900' AND '12/31/2079'
				THEN ENDDATE
			ELSE NULL
		END
	   ,WAGE
	   ,'0.00'
	   ,SERVICEAMOUNT
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM [WilliamPagerSaga].dbo.lw_emp e
	LEFT JOIN [WilliamPagerSaga].dbo.matrelt mt
		ON e.MATRELTID = mt.MATRELTID
	LEFT JOIN [WilliamPagerSaga].dbo.assign aemp
		ON aemp.assignid = mt.RelatedAssignID
	LEFT JOIN [WilliamPagerSaga].dbo.entities eemp
		ON eemp.entityid = aemp.entityid
	LEFT JOIN [WilliamPagerSaga].dbo.matter m
		ON m.MATTERID = aemp.MATTERID
	LEFT JOIN [WilliamPagerSaga].dbo.assign apl
		ON apl.assignid = mt.AssignID
	LEFT JOIN [WilliamPagerSaga].dbo.entities epl
		ON epl.entityid = apl.entityid
			AND apl.partytype = 1
	LEFT JOIN [WilliamPagerSaga].dbo.LW_SPECIALS ls
		ON e.MATRELTID = ls.MATRELTID
	LEFT JOIN [WilliamPagerSaga].dbo.NOTE n
		ON n.NOTEID = mt.NOTEID
	LEFT JOIN sma_trn_cases
		ON m.MATTERNUMBER = cassCaseNumber
	--left join sma_MST_IndvContacts i1 on i1.cinsGrade=eemp.ENTITYID and i1.cinsLastName=eemp.LAST_COMPANY
	LEFT JOIN sma_mst_orgcontacts o1
		ON o1.connLevelNo = eemp.ENTITYID
			AND o1.consName = ISNULL(eemp.LAST_COMPANY, '') + ISNULL(', ' + eemp.FIRST_DBA, '')
	LEFT JOIN sma_MST_IndvContacts i2
		ON i2.cinsGrade = epl.ENTITYID
			AND i2.cinsLastName = epl.LAST_COMPANY
	LEFT JOIN sma_mst_orgcontacts o2
		ON o2.connLevelNo = epl.ENTITYID
			AND o2.consName = epl.LAST_COMPANY
	LEFT JOIN sma_TRN_Plaintiff
		ON plnnCaseID = casnCaseID
			AND ((plnnContactID = i2.cinnContactID
					AND plnnContactCtg = 1)
				OR (plnnContactID = o2.connContactID
					AND plnnContactCtg = 2))
	LEFT JOIN sma_TRN_Employment
		ON empnPlaintiffID = plnnPlaintiffID
	WHERE apl.partytype = 1
		AND o1.connContactID IS NOT NULL
		AND plnnPlaintiffID IS NOT NULL
		AND empnEmploymentID IS NOT NULL
		AND o1.saga LIKE 'e%'

GO
UPDATE [sma_TRN_LostWages]
SET comments = ISNULL(Comments, '') + ISNULL(CHAR(13) + 'Wage: $' + CAST(ltwnAmount AS VARCHAR(20)), '') --where ltwnEmploymentID=3985
GO
UPDATE e
SET empnSalaryAmt = ltwnAmount
FROM sma_TRN_Employment e
JOIN [sma_TRN_LostWages]
	ON ltwnEmploymentID = empnEmploymentID
WHERE empnSalaryAmt = '0.00'
AND ISNULL(ltwnAmount, '0.00') <> '0.00'
