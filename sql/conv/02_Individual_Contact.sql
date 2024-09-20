USE WilliamPagerSA

ALTER TABLE sma_mst_indvcontacts DISABLE TRIGGER ALL
--INSERT INTO [sma_MST_OriginalContactTypes]
--([octsCode],[octnContactCtgID],[octsDscrptn],[octnRecUserID],[octdDtCreated],[octnModifyUserID],[octdDtModified],[octnLevelNo])
-- Select distinct UPPER(SUBSTRING(et.DESCRIPTION,0,5)),1,DESCRIPTION,368,GETDATE(),null,null,''
-- FROM [WilliamPagerSaga].[dbo].[ENTITIES] e
--left join [WilliamPagerSaga].[dbo].enttype et on e.ENTITYTYPEID=et.ENTITYTYPEID
--where  ISPERSON='t' and FIRST_DBA is not null
--and et.DESCRIPTION not in (select [octsDscrptn] from [sma_MST_OriginalContactTypes] where [octnContactCtgID]=1)
--and et.DESCRIPTION not like '%judge%' and et.DESCRIPTION not like '%clerk%' and et.DESCRIPTION not like '%doctor%' and et.DESCRIPTION not like '%police%' and et.DESCRIPTION not like '%expert%' and et.DESCRIPTION not like '%adjuster%' and et.DESCRIPTION not like '%attorney%'  and et.DESCRIPTION not like '%investigator%'
------------------------------Insert Individual Contact Started-------------------------------------------------------------------------    
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
				THEN (
						SELECT
							octnOrigContactTypeID
						FROM sma_MST_OriginalContactTypes
						WHERE octnContactCtgID = 1
							AND octsDscrptn = 'Judge'
					)
			WHEN et.DESCRIPTION LIKE '%clerk%'
				THEN (
						SELECT
							octnOrigContactTypeID
						FROM sma_MST_OriginalContactTypes
						WHERE octnContactCtgID = 1
							AND octsDscrptn = 'Courtroom Clerk'
					)
			WHEN et.DESCRIPTION LIKE '%doctor%'
				THEN (
						SELECT
							octnOrigContactTypeID
						FROM sma_MST_OriginalContactTypes
						WHERE octnContactCtgID = 1
							AND octsDscrptn = 'Doctor'
					)
			WHEN et.DESCRIPTION LIKE '%police%'
				THEN (
						SELECT
							octnOrigContactTypeID
						FROM sma_MST_OriginalContactTypes
						WHERE octnContactCtgID = 1
							AND octsDscrptn = 'Police Officer'
					)
			WHEN et.DESCRIPTION LIKE '%expert%'
				THEN (
						SELECT
							octnOrigContactTypeID
						FROM sma_MST_OriginalContactTypes
						WHERE octnContactCtgID = 1
							AND octsDscrptn = 'Expert'
					)
			WHEN et.DESCRIPTION LIKE '%adjuster%'
				THEN (
						SELECT
							octnOrigContactTypeID
						FROM sma_MST_OriginalContactTypes
						WHERE octnContactCtgID = 1
							AND octsDscrptn = 'Adjuster'
					)
			WHEN et.DESCRIPTION LIKE '%attorney%'
				THEN (
						SELECT
							octnOrigContactTypeID
						FROM sma_MST_OriginalContactTypes
						WHERE octnContactCtgID = 1
							AND octsDscrptn = 'Attorney'
					)
			WHEN et.DESCRIPTION LIKE '%investigator%'
				THEN (
						SELECT
							octnOrigContactTypeID
						FROM sma_MST_OriginalContactTypes
						WHERE octnContactCtgID = 1
							AND octsDscrptn = 'Investigator'
					)
			ELSE (
					SELECT
						octnOrigContactTypeID
					FROM sma_MST_OriginalContactTypes
					WHERE octnContactCtgID = 1
						AND octsDscrptn = 'General'
				)
		END
	   ,NULL
	   ,SUBSTRING(TITLE, 0, 19)
	   ,SUBSTRING(FIRST_DBA, 0, 29)
	   ,SUBSTRING(MIDDLE_CONTACT, 0, 29)
	   ,SUBSTRING(LAST_COMPANY, 0, 39)
	   ,SUBSTRING(PROFEXT, 0, 10)
	   --,SUBSTRING(ALIASNAMES, 0, 15)		-- ds 2024-09-20
	   ,null
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
	   ,CASE datecreated
			WHEN NULL
				THEN GETDATE()
			ELSE datecreated
		END
	   ,u2.usrnuserid
	   ,daterevised
	   ,0
	   ,''
	   ,''
	   ,''
	   ,''
	   --,HEIGHTFEET + HEIGHTINCH			-- ds 2024-09-20
	   --,WEIGHT							-- ds 2024-09-20
	   ,NULL
	   ,null
	   ,''
	   ,NULL
	   ,''
	   ,''
	   ,''
	   ,''
	   ,''
	   ,''
	   ,ENTITYID
	FROM [WilliamPagerSaga].[dbo].[ENTITIES] e
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
	WHERE ENTITYID NOT IN (
			SELECT
				ISNULL(cinsgrade, 0)
			FROM sma_mst_indvcontacts
		)
		AND ISPERSON = 't'
		AND FIRST_DBA IS NOT NULL
------------------------------Insert Individual Contact Finished-------------------------------------------------------------------------    

ALTER TABLE sma_mst_indvcontacts ENABLE TRIGGER ALL



