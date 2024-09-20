USE WilliamPagerSA

INSERT INTO [sma_MST_VehicleMake]
	(
	[vmksCode]
   ,[vmksDscrptn]
   ,[vmknRecUserID]
   ,[vmkdDtCreated]
   ,[vmknModifyUserID]
   ,[vmkdDtModified]
   ,[vmknLevelNo]
	)
	SELECT DISTINCT
		''
	   ,make
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM [WilliamPagerSaga].[dbo].[LW_VEHICLE]
	EXCEPT
	SELECT
		''
	   ,vmksDscrptn
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM [sma_MST_VehicleMake]

INSERT INTO [sma_MST_VehicleModels]
	(
	[vmdsCode]
   ,[vmdnMakeID]
   ,[vmdsModelDscrptn]
   ,[vmdnRecUserID]
   ,[vmddDtCreated]
   ,[vmdnModifyUserID]
   ,[vmddDtModified]
   ,[vmdnLevelNo]
	)
	SELECT DISTINCT
		''
	   ,vmknMakeID
	   ,model
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM [WilliamPagerSaga].[dbo].[LW_VEHICLE]
	LEFT JOIN [sma_MST_VehicleMake]
		ON MAKE = vmksDscrptn
	WHERE vmknMakeID IS NOT NULL
		AND ISNULL(model, '') <> ''
	EXCEPT
	SELECT
		''
	   ,vmdnMakeID
	   ,vmdsModelDscrptn
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM [sma_MST_VehicleModels]
GO
ALTER TABLE [sma_TRN_Vehicles]
ALTER COLUMN [vehsComments] VARCHAR(4000) NULL

ALTER TABLE [sma_TRN_Vehicles]
ALTER COLUMN vehsPlateNo VARCHAR(40) NULL
GO
INSERT INTO [sma_TRN_Vehicles]
	(
	[vehnCaseID]
   ,[vehbIsPlaintiff]
   ,[vehnPlntDefID]
   ,[vehnOwnerID]
   ,[vehnOwnerCtg]
   ,[vehnRegistrantID]
   ,[vehnRegistrantCtg]
   ,[vehnOperatorID]
   ,[vehnOperatorCtg]
   ,[vehsLicenceNo]
   ,[vehnLicenceStateID]
   ,[vehdLicExpDt]
   ,[vehnVehicleMake]
   ,[vehnYear]
   ,[vehnModelID]
   ,[vehnBodyTypeID]
   ,[vehsPlateNo]
   ,[vehsColour]
   ,[vehnVehicleStateID]
   ,[vehsVINNo]
   ,[vehdRegExpDt]
   ,[vehnIsLeased]
   ,[vehnDamageClaim]
   ,[vehdEstReqdOn]
   ,[vehdEstRecvdOn]
   ,[vehdPhotoReqdOn]
   ,[vehdPhotoRecvdOn]
   ,[vehbRepairs]
   ,[vehbTotalLoss]
   ,[vehnCostOfRepairs]
   ,[vehnValueBefAcdnt]
   ,[vehnRentalExpense]
   ,[vehnOthExpense]
   ,[vehnSalvage]
   ,[vehnTLRentalExpense]
   ,[vehnTLOthExpense]
   ,[vehnLoss]
   ,[vehnNetLoss]
   ,[vehnLicenseHistory]
   ,[vehnPlateSearch]
   ,[vehnTitlesearch]
   ,[vehnMV104]
   ,[vehdOprLicHistory]
   ,[vehdPlateSearchOn]
   ,[vehdTitleSearchOn]
   ,[vehdMV104On]
   ,[vehdOprLicHistoryRecd]
   ,[vehdPlateSearchOnRecd]
   ,[vehdTitleSearchOnRecd]
   ,[vehdMV104OnRecd]
   ,[vehsComments]
   ,[vehbPhotoAttached]
   ,[vehnRecUserID]
   ,[vehdDtCreated]
   ,[vehnModifyUserID]
   ,[vehdDtModified]
   ,[vehnLevelNo]
	)
	SELECT DISTINCT
		casnCaseID
	   ,CASE
			WHEN p1.plnnPlaintiffID IS NOT NULL OR
				p2.plnnPlaintiffID IS NOT NULL
				THEN 1
			ELSE 0
		END
	   ,CASE
			WHEN d1.defnDefendentID IS NOT NULL
				THEN d1.defnDefendentID
			WHEN d2.defnDefendentID IS NOT NULL
				THEN d2.defnDefendentID
			WHEN p1.plnnPlaintiffID IS NOT NULL
				THEN p1.plnnPlaintiffID
			WHEN p2.plnnPlaintiffID IS NOT NULL
				THEN p2.plnnPlaintiffID
		END
	   ,CASE
			WHEN i4.cinnContactID IS NOT NULL
				THEN i4.cinnContactID
			WHEN o4.connContactID IS NOT NULL
				THEN o4.connContactID
		END
	   ,CASE
			WHEN i4.cinnContactID IS NOT NULL
				THEN 1
			WHEN o4.connContactID IS NOT NULL
				THEN 2
		END
	   ,CASE
			WHEN i3.cinnContactID IS NOT NULL
				THEN i3.cinnContactID
			WHEN o3.connContactID IS NOT NULL
				THEN o3.connContactID
		END
	   ,CASE
			WHEN i3.cinnContactID IS NOT NULL
				THEN 1
			WHEN o3.connContactID IS NOT NULL
				THEN 2
		END
	   ,CASE
			WHEN i5.cinnContactID IS NOT NULL
				THEN i5.cinnContactID
			WHEN o5.connContactID IS NOT NULL
				THEN o5.connContactID
		END
	   ,CASE
			WHEN i5.cinnContactID IS NOT NULL
				THEN 1
			WHEN o5.connContactID IS NOT NULL
				THEN 2
		END
	   ,DRIVERSLICENSENUMBER
	   ,sttnStateID
	   ,NULL
	   ,vmknMakeID
	   ,MODELYEAR
	   ,vmdnModelID
	   ,NULL
	   ,PLATENUMBER
	   ,COLOR
	   ,sttnStateID
	   ,VIN
	   ,NULL
	   ,CASE ISLEASED
			WHEN 'F'
				THEN 0
			WHEN 'T'
				THEN 1
		END
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
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,ISNULL(CONVERT(VARCHAR(4000), comment), '') +
		CASE
			WHEN ISNULL(model, '') <> ''
				THEN ' ' + 'Model: ' + ' ' + model
		END + ISNULL(CONVERT(VARCHAR(6000), LTRIM(REPLACE(REPLACE(REPLACE(dbo.RegExReplace(n.NOTES, '({\\)(.+?)(})|(\\)(.+?)(\b)', ''), '}', ''), CHAR(13), ''), CHAR(10), ''))), '')
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	FROM [WilliamPagerSaga].[dbo].[LW_VEHICLE] a
	LEFT JOIN WilliamPagerSaga.dbo.ASSIGN b
		ON a.assignid = b.ASSIGNID
	LEFT JOIN WilliamPagerSaga.dbo.MATTER c
		ON c.MATTERID = b.MATTERID
	LEFT JOIN sma_trn_cases
		ON cassCaseNumber = MATTERNUMBER
	LEFT JOIN WilliamPagerSaga.dbo.ASSIGN d
		ON a.REGISTEREDOWNERID = d.ASSIGNID
			AND a.REGISTEREDOWNERID IS NOT NULL
	LEFT JOIN WilliamPagerSaga.dbo.ASSIGN e
		ON a.TITLEOWNERID = e.ASSIGNID
			AND a.TITLEOWNERID IS NOT NULL
	LEFT JOIN WilliamPagerSaga.dbo.ASSIGN f
		ON a.OPERATORID = f.ASSIGNID
			AND a.OPERATORID IS NOT NULL
	LEFT JOIN sma_MST_IndvContacts i1
		ON LTRIM(RTRIM(i1.cinsGrade)) = b.ENTITYID
			AND b.PARTYTYPE = 2
	LEFT JOIN sma_MST_OrgContacts o1
		ON LTRIM(RTRIM(o1.connLevelNo)) = b.ENTITYID
			AND b.PARTYTYPE = 2
	LEFT JOIN sma_TRN_Defendants d1
		ON i1.cinnContactID = d1.defnContactID
			AND d1.defnContactCtgID = 1
			AND d1.defnCaseID = casnCaseID
	LEFT JOIN sma_TRN_Defendants d2
		ON o1.connContactID = d2.defnContactID
			AND d2.defnContactCtgID = 2
			AND d2.defnCaseID = casnCaseID
	LEFT JOIN sma_MST_IndvContacts i2
		ON LTRIM(RTRIM(i2.cinsGrade)) = b.ENTITYID
			AND b.PARTYTYPE = 1
	LEFT JOIN sma_MST_OrgContacts o2
		ON LTRIM(RTRIM(o2.connLevelNo)) = b.ENTITYID
			AND b.PARTYTYPE = 1
	LEFT JOIN sma_TRN_Plaintiff p1
		ON i2.cinnContactID = p1.plnnContactID
			AND p1.plnnContactCtg = 1
			AND p1.plnnCaseID = casnCaseID
	LEFT JOIN sma_TRN_Plaintiff p2
		ON o2.connContactID = p2.plnnContactID
			AND p2.plnnContactCtg = 2
			AND p2.plnnCaseID = casnCaseID
	LEFT JOIN sma_MST_IndvContacts i3
		ON LTRIM(RTRIM(i3.cinsGrade)) = d.ENTITYID
	LEFT JOIN sma_MST_OrgContacts o3
		ON LTRIM(RTRIM(o3.connLevelNo)) = d.ENTITYID
	LEFT JOIN sma_MST_IndvContacts i4
		ON LTRIM(RTRIM(i4.cinsGrade)) = e.ENTITYID
	LEFT JOIN sma_MST_OrgContacts o4
		ON LTRIM(RTRIM(o4.connLevelNo)) = e.ENTITYID
	LEFT JOIN sma_MST_IndvContacts i5
		ON LTRIM(RTRIM(i5.cinsGrade)) = f.ENTITYID
	LEFT JOIN sma_MST_OrgContacts o5
		ON LTRIM(RTRIM(o5.connLevelNo)) = f.ENTITYID
	LEFT JOIN sma_MST_States
		ON sttsCode = [state]
	LEFT JOIN [sma_MST_VehicleMake]
		ON a.MAKE = vmksDscrptn
	LEFT JOIN [sma_MST_VehicleModels]
		ON a.model = [vmdsModelDscrptn]
			AND vmdnMakeID = vmknMakeID
	LEFT JOIN WilliamPagerSaga.dbo.NOTE n
		ON n.NOTEID = VIOLATIONHISTORYNOTEID

GO