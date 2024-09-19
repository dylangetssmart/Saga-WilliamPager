## Sequence 0 - Initialize
Script|Purpose|Notes
:---|:---|:---
0.00_init_Initialize.SQL|Creates various functions to extract and massage data|
0.10_init_CaseTypeMixture.SQL|Creates table CaseTypeMixture used to cross reference Caes Types|Harcoded for initial conversion
0.20_init_CaseValueMapping.sql|Creates table CaseValueMapping and populates it with default values|
0.30_init_ImplementationUsersMap.sql|Creates table implementation_users and populates it with users from `[dbo].[staff]`|Optionally, seed the table with user records from the implementation database
0.40_init_NeedlesUserFields.sql|Creates table NeedlesUserFields|
0.50_init_PartyRole.sql|Creates table PartyRoles used to cross reference party roles|Harcoded for initial conversion

## Sequence 1 - Contacts
Script|Purpose|Indv or Org|Notes|Dependency
:---|:---|:---|:---|:---
1.00_cont_Contacts.sql||Indv + Org||
1.01_cont_Insured.SQL|Creates contacts from `[dbo].[insurance]`|Indv||
1.02_cont_PoliceOfficer.SQL|Creates police officer contacts from `[dbo].[police]`|Indv||
1.03_cont_UnidentifiedCourt.sql|Creates Unidentifed Court contact|Org||
1.04_cont_UnidentifiedSchool.sql|Creates Unidentifed School contact|Org||
1.90_cont_EmailWebsite.SQL|Populates `sma_MST_EmailWebsite` from `[dbo].[names]`|Indv + Org||
1.91_cont_PhoneNumber.SQL|Populates `sma_MST_ContactNumbers` from `[dbo].[names]`|Indv + Org||
1.92_cont_Address.SQL|Populates `sma_MST_Address` from `[dbo].[multi_addresses]`|||
1.93_cont_Uniqueness.sql||||
1.95_cont_Comment.SQL||||
1.97_cont_AllContactInfo.sql||||
1.98_cont_IndvOrgContacts.sql||||`1.90_contact_AllContactInfo.sql`
1.99_cont_Notes.SQL||||`1.91_contact_IndvOrgContacts.sql`

## Sequence 2 - Case
Script|Purpose|Indv or Org|Notes|Dependency
:---|:---|:---|:---|:---
2.00_case_CaseType.sql|p|i|n|d
2.01_case_CaseValue.sql||||
2.02_case_CaseStaff.sql||||
2.03_case_CaseStatus.sql||||
2.05_case_CalendarNonCase.sql||||
2.05_case_PlaintiffDefendant.sql||||
2.06_case_Insurance.sql||||
2.10_case_gen_Court.sql||||
2.11_case_gen_CriticalComments.sql||||
2.12_case_gen_CriticalDeadLines.sql||||
2.13_case_gen_Negotiate.sql||||
2.14_case_gen_SOL.sql||||
2.15_case_gen_ReferOut.sql||||
2.16_case_gen_OtherReferral.sql||||
2.17_case_gen_Notes.sql||||
2.18_case_gen_Notes_Value.sql||||
2.19_case_gen_Calendar.sql||||
2.20_case_gen_Incident.sql||||
2.22_case_gen_Investigations_PoliceReport.sql||||
2.23_case_gen_Disbursement.sql||||
2.24_case_gen_Tasks.sql||||
2.25_case_gen_SOL_Checklist.sql||||
2.43_case_pln_Injury.sql||||
2.45_case_pln_Decedent.sql||||
2.49_case_pln_MedicalRecord.sql||||
2.50_case_pln_Defendant_Attorney.sql||||
2.70_case_value_tab_pln_LienTracking.sql||||
2.71_case_value_tab_pln_SpDamages.sql||||
2.72_case_value_tab_pln_MedicalProviders.sql||||
2.73_case_value_tab_gen_Settlements.sql||||
2.74_case_value_tab_othr_TimeTracking.sql||||

### Value Tab
[See Docs](https://smartadvocate.atlassian.net/wiki/spaces/Conversion/pages/2432303109/Needles+System+Conversion#Value-%26-Value-Codes)
**Code modification instructions:**
- [ ] Update temp table with codes from mappinge
```sql
INSERT INTO #MedChargeCodes (code)
VALUES
('MEDICAL')
```

## Sequence 3 - UDF
[See Docs](https://smartadvocate.atlassian.net/wiki/spaces/Conversion/pages/2436366355/SmartAdvocate#UDF)
Script|Purpose|Indv or Org|Notes|Dependency
:---|:---|:---|:---|:---
3.01_udf_Other1_tab1.sql
3.02_udf_Other2_tab2.sql
3.03_udf_Other3_tab3.sql
3.04_udf_Other4_tab4.sql
3.05_udf_Other5_tab5.sql
3.06_udf_Other6_tab6.sql
3.07_udf_Other7_tab7.sql
3.08_udf_Other8_tab8.sql
3.09_udf_Other9_tab9.sql
3.10_udf_Other10_tab10.sql

## Sequence 4 - Miscellaneous
Script|Purpose|Indv or Org|Notes|Dependency
:---|:---|:---|:---|:---
4.00_misc_DefaultDefendant.sql
4.01_misc_User-Contact.sql
4.02_misc_CaseNames.sql
4.03_misc_OtherCaseRelatedContacts.sql
4.04_misc_ContactTypes.sql
4.05_misc_Miscellany.sql

## Sequence 5 - Intake
Script|Purpose|Indv or Org|Notes|Dependency
:---|:---|:---|:---|:---
5.00_intake_cases.sql
5.02_intake_CaseStaff.sql
5.02_intake_Incident.sql
5.07_intake_ReferredBy.sql
5.08_intake_updateContactAddress.sql
5.09_intake_Plaintiffs.sql

