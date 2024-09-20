USE WilliamPagerSA
GO

CREATE FUNCTION [dbo].[RemoveNonASCII] (@nstring VARCHAR(4000))
RETURNS VARCHAR(4000)
AS
BEGIN

	DECLARE @Result VARCHAR(4000)
	SET @Result = ''

	DECLARE @nchar NVARCHAR(1)
	DECLARE @position INT

	SET @position = 1
	WHILE @position <= LEN(@nstring)
	BEGIN
	SET @nchar = SUBSTRING(@nstring, @position, 1)
	--Unicode & ASCII are the same from 1 to 255.
	--Only Unicode goes beyond 255
	--0 to 31 are non-printable characters
	IF ((UNICODE(@nchar) BETWEEN 32 AND 255)
		OR (UNICODE(@nchar) = 10)
		OR (UNICODE(@nchar) = 13))
		SET @Result = @Result + @nchar
	SET @position = @position + 1
	END

	RETURN @Result

END
GO

INSERT INTO [sma_MST_CaseTypeInjury]
	(
	[ctinInjuryID]
   ,[ctinCaseTypeID]
   ,[ctisTreatment]
   ,[ctinRecUserID]
   ,[ctidDtCreated]
   ,[ctinModifyUserID]
   ,[ctidDtModified]
   ,[ctinLevelNo]
	)
	SELECT DISTINCT
		0
	   ,cstnCaseTypeID
	   ,0
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM sma_MST_CaseType
	EXCEPT
	SELECT
		0
	   ,ctinCaseTypeID
	   ,0
	   ,368
	   ,GETDATE()
	   ,NULL
	   ,NULL
	   ,''
	FROM sma_MST_CaseTypeInjury

ALTER TABLE [sma_TRN_Injury] DISABLE TRIGGER ALL
INSERT INTO [sma_TRN_Injury]
	(
	[injnCaseId]
   ,[injnPlaintiffId]
   ,[injnInjuryType]
   ,[injnBodyPartSide]
   ,[injnBodyPartID]
   ,[injnInjuryNameID]
   ,[injsTreatmentIDS]
   ,[injsSequaleadIDS]
   ,[injsDescription]
   ,[injnDuration]
   ,[injdInjuryDt]
   ,[injnBOPInterrogation]
   ,[injbDocAttached]
   ,[injnPriority]
   ,[injsComments]
   ,[injnRecUserID]
   ,[injdDtCreated]
   ,[injnModifyUserID]
   ,[injdDtModified]
   ,[injnLevelNo]
   ,[injnOtherInj]
	)
	SELECT DISTINCT
		casnCaseID
	   ,plnnPlaintiffID
	   ,3
	   ,0
	   ,0
	   ,NULL
	   ,NULL
	   ,NULL
	   ,CONVERT(VARCHAR(4000), ISNULL(n1.NOTES, ''))
	   ,0
	   ,NULL
	   ,NULL
	   ,NULL
	   ,NULL
	   ,CONVERT(VARCHAR(3800), ISNULL(n2.NOTES, '')) + CHAR(13) + ISNULL(CONFINEDHOME, '') + CHAR(13) + ISNULL(CONFINEDBED, '') + CHAR(13) + ISNULL(INHOSPITAL, '') + CHAR(13) + ISNULL(INCAPACITATED, '')
	   ,casnRecUserID
	   ,casdDtCreated
	   ,NULL
	   ,NULL
	   ,''
	   ,''
	FROM [WilliamPagerSaga].dbo.LW_injury li
	LEFT JOIN [WilliamPagerSaga].dbo.NOTE n1
		ON n1.NOTEID = SYNOPSISNOTEID
	LEFT JOIN [WilliamPagerSaga].dbo.NOTE n2
		ON n2.NOTEID = PLEADINGNOTEID
	LEFT JOIN [WilliamPagerSaga].dbo.assign a
		ON li.assignid = a.assignid
	LEFT JOIN [WilliamPagerSaga].dbo.matter m
		ON a.matterid = m.matterid
	LEFT JOIN [WilliamPagerSaga].dbo.LW_A_MATTERTYPE LMT
		ON m.MATTERTYPEID = LMT.MATTERTYPEID
	--outer apply(SELECT top 1  en.code,en.ENTITYID  FROM  [WilliamPagerSaga].dbo.entities en left JOIN  [WilliamPagerSaga].dbo.assign aa on aa.ENTITYID=en.entityid left JOIN  [WilliamPagerSaga].dbo.erole r on r.ROLEID=aa.ROLEID  WHERE  r.rolecategoryid in (1)) pAName     
	LEFT JOIN [WilliamPagerSaga].dbo.entities e
		ON a.entityid = e.entityid
	LEFT JOIN sma_MST_IndvContacts l
		ON l.cinsGrade = e.ENTITYID
	LEFT JOIN sma_MST_OrgContacts k
		ON k.connLevelNo = e.ENTITYID
	LEFT JOIN sma_trn_cases
		ON cassCaseNumber = m.MATTERNUMBER
	LEFT JOIN sma_TRN_Plaintiff
		ON ((plnnContactID = k.conncontactid
					AND plnnContactCtg = 2)
				OR (plnnContactID = l.cinncontactid
					AND plnnContactCtg = 1))
			AND plnnCaseID = casnCaseID
	WHERE casnCaseID IS NOT NULL
		AND plnnPlaintiffID IS NOT NULL

GO
UPDATE sma_TRN_Injury
SET injnOtherInj = CONVERT(VARCHAR(6000), LTRIM(REPLACE(
	dbo.RegExReplace(injsComments, '({\\)(.+?)(})|(\\)(.+?)(\b)', '')
	, '}', '')

	))
   ,injsDescription = CONVERT(VARCHAR(6000), LTRIM(REPLACE(
	dbo.RegExReplace(injsDescription, '({\\)(.+?)(})|(\\)(.+?)(\b)', '')
	, '}', '')

	))
   ,injsComments = ''

GO

UPDATE sma_TRN_Injury
SET injsDescription = dbo.RemoveNonASCII(injsDescription)
   ,injsComments = dbo.RemoveNonASCII(injsComments)
   ,injnOtherInj = dbo.RemoveNonASCII([injnOtherInj]) --where injnCaseId=1694

GO
ALTER TABLE [sma_TRN_Injury] ENABLE TRIGGER ALL

