go
Alter table sma_TRN_CaseStatus disable trigger all
Update  sma_TRN_CaseStatus 
set cssdToDt=GETDATE(),cssnModifyUserID=368
where cssnCaseStatusID not in (
select max(cssnCaseStatusID) from sma_TRN_CaseStatus
where cssnStatusTypeID=1 and cssdToDt is null
group by cssnCaseID
having count(cssnCaseID)>1
) and cssnCaseID in (select cssnCaseID from sma_TRN_CaseStatus
where cssnStatusTypeID=1 and cssdToDt is null
group by cssnCaseID
having count(cssnCaseID)>1
) and cssdToDt is null and cssnStatusTypeID=1
Alter table sma_TRN_CaseStatus enable trigger all
go


Alter table sma_trn_cases disable trigger all

Update a
set casnStatusValueID=cssnStatusID
From  sma_trn_cases a
left join sma_TRN_CaseStatus on cssnCaseID=casnCaseID

update a  
set casdIncidentDate=IncidentDate
from sma_trn_cases a
left join sma_TRN_Incidents on CaseId=casnCaseID

Alter table sma_trn_cases enable trigger all

Alter table sma_trn_casestatus disable trigger all

    

delete from sma_MST_CaseStatus
where csssDescription ='closed matter'

Alter table sma_trn_casestatus enable trigger all
GO


Update sma_MST_ContactNumbers 
set cnnbPrimary=0
where cnnnContactID in 
(select distinct cnnnContactID from sma_MST_ContactNumbers
where cnnbPrimary=1 and cnnnContactCtgID=1
group by cnnnContactID,cnnbPrimary
having count(cnnnContactID)>1 and cnnbPrimary=1 ) and cnnnContactCtgID=1
and cnnnContactNumberID not in (
Select max(cnnnContactNumberID) from sma_MST_ContactNumbers
where cnnnContactID in (
select distinct cnnnContactID from sma_MST_ContactNumbers
where cnnbPrimary=1 and cnnnContactCtgID=1 
group by cnnnContactID,cnnbPrimary
having count(cnnnContactID)>1 and cnnbPrimary=1 ) and cnnnContactCtgID=1 and cnnbPrimary=1
group by cnnnContactID)

Update sma_MST_ContactNumbers 
set cnnbPrimary=0
where cnnnContactID in 
(select distinct cnnnContactID from sma_MST_ContactNumbers
where cnnbPrimary=1 and cnnnContactCtgID=2 
group by cnnnContactID,cnnbPrimary
having count(cnnnContactID)>1 and cnnbPrimary=1 ) and cnnnContactCtgID=2
and cnnnContactNumberID not in (
Select max(cnnnContactNumberID) from sma_MST_ContactNumbers
where cnnnContactID in (
select distinct cnnnContactID from sma_MST_ContactNumbers
where cnnbPrimary=1 and cnnnContactCtgID=2 
group by cnnnContactID,cnnbPrimary
having count(cnnnContactID)>1 and cnnbPrimary=1 ) and cnnnContactCtgID=2 and cnnbPrimary=1
group by cnnnContactID)

----Set only one primary address
Update sma_MST_Address
set addbPrimary=0
where addnContactID in 
(select distinct addnContactID from sma_MST_Address
where addbPrimary=1 and addnContactCtgID=1
group by addnContactID,addbPrimary
having count(addnContactID)>1 and addbPrimary=1 ) and addnContactCtgID=1
and addnAddressID not in (
Select max(addnAddressID) from sma_MST_Address
where addnContactID in (
select distinct addnContactID from sma_MST_Address
where addbPrimary=1 and addnContactCtgID=1
group by addnContactID,addbPrimary
having count(addnContactID)>1 and addbPrimary=1 ) and addnContactCtgID=1 and addbPrimary=1
group by addnContactID)

Update sma_MST_Address
set addbPrimary=0
where addnContactID in 
(select distinct addnContactID from sma_MST_Address
where addbPrimary=1 and addnContactCtgID=2
group by addnContactID,addbPrimary
having count(addnContactID)>1 and addbPrimary=1 ) and addnContactCtgID=2
and addnAddressID not in (
Select max(addnAddressID) from sma_MST_Address
where addnContactID in (
select distinct addnContactID from sma_MST_Address
where addbPrimary=1 and addnContactCtgID=2
group by addnContactID,addbPrimary
having count(addnContactID)>1 and addbPrimary=1 ) and addnContactCtgID=2 and addbPrimary=1
group by addnContactID)
