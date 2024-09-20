USE WilliamPagerSA

GO
ALTER TABLE [sma_TRN_Employment]
ALTER COLUMN [empsJobTitle] VARCHAR(500) NULL
ALTER TABLE [sma_TRN_Employment]
ALTER COLUMN [empsComments] VARCHAR(4000) NULL
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
			AND o1.consName = eemp.LAST_COMPANY
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
GO
UPDATE sma_TRN_Employment
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
GO
UPDATE sma_TRN_Employment
SET empsComments = dbo.RemoveNonASCII(empsComments)
GO
INSERT INTO [sma_MST_WagesTypes]
	(
	[wgtsCode]
   ,[wgtsDscrptn]
   ,[wgtnRecUserID]
   ,[wgtdDtCreated]
   ,[wgtnModifyUserID]
   ,[wgtdDtModified]
   ,[wgtnLevelNo]
	)
	SELECT
		'LSTWGS'
	   ,'Lost Wages'
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	UNION
	SELECT
		'GEN'
	   ,'General'
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''

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
				THEN 'General'
			ELSE 'Lost Wages'
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
			AND o1.consName = eemp.LAST_COMPANY
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
GO