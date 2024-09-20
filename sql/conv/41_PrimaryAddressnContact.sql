USE WilliamPagerSA

GO
ALTER TABLE sma_TRN_CaseStatus DISABLE TRIGGER ALL
UPDATE sma_TRN_CaseStatus
SET cssdToDt = GETDATE()
   ,cssnModifyUserID = 368
WHERE cssnCaseStatusID NOT IN (
	SELECT
		MAX(cssnCaseStatusID)
	FROM sma_TRN_CaseStatus
	WHERE cssnStatusTypeID = 1
		AND cssdToDt IS NULL
	GROUP BY cssnCaseID
	HAVING COUNT(cssnCaseID) > 1
)
AND cssnCaseID IN (
	SELECT
		cssnCaseID
	FROM sma_TRN_CaseStatus
	WHERE cssnStatusTypeID = 1
		AND cssdToDt IS NULL
	GROUP BY cssnCaseID
	HAVING COUNT(cssnCaseID) > 1
)
AND cssdToDt IS NULL
AND cssnStatusTypeID = 1
ALTER TABLE sma_TRN_CaseStatus ENABLE TRIGGER ALL
GO


ALTER TABLE sma_trn_cases DISABLE TRIGGER ALL

UPDATE a
SET casnStatusValueID = cssnStatusID
FROM sma_trn_cases a
LEFT JOIN sma_TRN_CaseStatus
	ON cssnCaseID = casnCaseID

UPDATE a
SET casdIncidentDate = IncidentDate
FROM sma_trn_cases a
LEFT JOIN sma_TRN_Incidents
	ON CaseId = casnCaseID

ALTER TABLE sma_trn_cases ENABLE TRIGGER ALL

ALTER TABLE sma_trn_casestatus DISABLE TRIGGER ALL



DELETE FROM sma_MST_CaseStatus
WHERE csssDescription = 'closed matter'

ALTER TABLE sma_trn_casestatus ENABLE TRIGGER ALL
GO


UPDATE sma_MST_ContactNumbers
SET cnnbPrimary = 0
WHERE cnnnContactID IN (
	SELECT DISTINCT
		cnnnContactID
	FROM sma_MST_ContactNumbers
	WHERE cnnbPrimary = 1
		AND cnnnContactCtgID = 1
	GROUP BY cnnnContactID
			,cnnbPrimary
	HAVING COUNT(cnnnContactID) > 1
	AND cnnbPrimary = 1
)
AND cnnnContactCtgID = 1
AND cnnnContactNumberID NOT IN (
	SELECT
		MAX(cnnnContactNumberID)
	FROM sma_MST_ContactNumbers
	WHERE cnnnContactID IN (
			SELECT DISTINCT
				cnnnContactID
			FROM sma_MST_ContactNumbers
			WHERE cnnbPrimary = 1
				AND cnnnContactCtgID = 1
			GROUP BY cnnnContactID
					,cnnbPrimary
			HAVING COUNT(cnnnContactID) > 1
			AND cnnbPrimary = 1
		)
		AND cnnnContactCtgID = 1
		AND cnnbPrimary = 1
	GROUP BY cnnnContactID
)

UPDATE sma_MST_ContactNumbers
SET cnnbPrimary = 0
WHERE cnnnContactID IN (
	SELECT DISTINCT
		cnnnContactID
	FROM sma_MST_ContactNumbers
	WHERE cnnbPrimary = 1
		AND cnnnContactCtgID = 2
	GROUP BY cnnnContactID
			,cnnbPrimary
	HAVING COUNT(cnnnContactID) > 1
	AND cnnbPrimary = 1
)
AND cnnnContactCtgID = 2
AND cnnnContactNumberID NOT IN (
	SELECT
		MAX(cnnnContactNumberID)
	FROM sma_MST_ContactNumbers
	WHERE cnnnContactID IN (
			SELECT DISTINCT
				cnnnContactID
			FROM sma_MST_ContactNumbers
			WHERE cnnbPrimary = 1
				AND cnnnContactCtgID = 2
			GROUP BY cnnnContactID
					,cnnbPrimary
			HAVING COUNT(cnnnContactID) > 1
			AND cnnbPrimary = 1
		)
		AND cnnnContactCtgID = 2
		AND cnnbPrimary = 1
	GROUP BY cnnnContactID
)

----Set only one primary address
UPDATE sma_MST_Address
SET addbPrimary = 0
WHERE addnContactID IN (
	SELECT DISTINCT
		addnContactID
	FROM sma_MST_Address
	WHERE addbPrimary = 1
		AND addnContactCtgID = 1
	GROUP BY addnContactID
			,addbPrimary
	HAVING COUNT(addnContactID) > 1
	AND addbPrimary = 1
)
AND addnContactCtgID = 1
AND addnAddressID NOT IN (
	SELECT
		MAX(addnAddressID)
	FROM sma_MST_Address
	WHERE addnContactID IN (
			SELECT DISTINCT
				addnContactID
			FROM sma_MST_Address
			WHERE addbPrimary = 1
				AND addnContactCtgID = 1
			GROUP BY addnContactID
					,addbPrimary
			HAVING COUNT(addnContactID) > 1
			AND addbPrimary = 1
		)
		AND addnContactCtgID = 1
		AND addbPrimary = 1
	GROUP BY addnContactID
)

UPDATE sma_MST_Address
SET addbPrimary = 0
WHERE addnContactID IN (
	SELECT DISTINCT
		addnContactID
	FROM sma_MST_Address
	WHERE addbPrimary = 1
		AND addnContactCtgID = 2
	GROUP BY addnContactID
			,addbPrimary
	HAVING COUNT(addnContactID) > 1
	AND addbPrimary = 1
)
AND addnContactCtgID = 2
AND addnAddressID NOT IN (
	SELECT
		MAX(addnAddressID)
	FROM sma_MST_Address
	WHERE addnContactID IN (
			SELECT DISTINCT
				addnContactID
			FROM sma_MST_Address
			WHERE addbPrimary = 1
				AND addnContactCtgID = 2
			GROUP BY addnContactID
					,addbPrimary
			HAVING COUNT(addnContactID) > 1
			AND addbPrimary = 1
		)
		AND addnContactCtgID = 2
		AND addbPrimary = 1
	GROUP BY addnContactID
)
