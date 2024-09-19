# SmartAdvocate Conversion Boilerplate
Conversion project template.

## Installation
1. [Install python](https://www.python.org/downloads/)
	- Add python to PATH
2. Update `.env` (in the project root)
```bash
SERVER=your_server_here							# Ex: DylanS\MSSQLSERVER2022
SOURCE_DB=name_of_source_database				# Ex: TestClientNeedles
TARGET_DB=name_of_target_SA_db					# Ex: TestClientSA
SQL_SCRIPTS_DIR=where_your_SQL_scripts_live		# Ex: sql\conv
```

Create a [virtual environment](https://docs.python.org/3/library/venv.html#creating-virtual-environments)
```bash
python -m venv venv
```

Activate the virtual environment
```bash
.\venv\Scripts\activate
```

Install `sa-conversion-utils`
```bash
pip install -e C:\LocalConv\sa-conversion-utils
```


## Usage

- Logs are output to `/logs`
- Backups go to `/backups/`

Invoke `conv` with the help flag `-h` to see all available commands
```bash
conv -h
```
> [!TIP]
> `-h` or `--help` is available for all subcommands to view any necessary parameters and flags.

**Example:**

The below command invokes the `exec` command for SQL script sequence `0` (initialize) and creates a backup when done `--backup`.
```bash
conv exec 0 --backup
```

# SQL Scripts

## Key Concepts

The following documentation outlines generically applicable scripts.
> [!NOTE]
> The sql scripts in this repo omit `USE {database}`, as the database is passed as a [sqlcmd option](https://learn.microsoft.com/en-us/sql/tools/sqlcmd/sqlcmd-utility?view=sql-server-ver16&tabs=go%2Cwindows&pivots=cs1-bash#-d-db_name) when using the python CLI.
>
> When running sql scripts manually, be sure to restore the `USE` command.

### Sequence
"Sequence" refers to the _step_ or _series_ that a script belongs to.

Sequence|Purpose
:---:|:---
0|Initialize
1|Contacts
2|Cases
3|UDF
4|Intake
5|Misc
9|Post

> [!CAUTION]
> Sequence is baked into my filenaming convention shown below and is a integral part of how the python CLI works. When you invoke the `exec` command, Sequence is a [positional argument](https://docs.python.org/3/library/argparse.html#name-or-flags) that is **required** for the program to know which scripts it should execute.
> 
> When renaming scripts or creating new ones, **Sequence** must remain in tact as per the table above if you plan to use the python CLI.

### Filenaming Convention
The included SQL scripts use a four-part file naming convention.

**Convention**
1. [Sequence](#sequence)
2. SmartAdvocate Screen
3. Screen Section/sub-section
4. Data source (optional)

My philospohy for this convention is that a script file should:
- Use an appropriate sequence (order matters)
- Indicate what screen and section it affects
- Optionally, include the source of the data if it is unexpected or otherwise relevant.

`2.47-Plaintiff_SpDamages-user_tab.sql`
Sequence|Screen|Section|Data Source (optional)
:--|:--|:--|:--
2.47a|Plaintiff|Special Damages|user_tab|

> [!NOTE]
> **On mixing hyphens and underscores**
>
> Although it looks disgusting, I mix underscores and hyphens for easier filename navigation using `ctrl` + arrow keys. Try renaming a script to see what I mean.




## Sequence 2 - Cases

##### Value Tab
_info about value tab_

###### Medical Providers
_Script name here_
**Code modification instructions:**
- [ ] Update temp table with codes from mapping
```sql
INSERT INTO #MedChargeCodes (code)
VALUES
('MEDICAL')
```

###### Lien Tracking
_Script name here_
**Code modification instructions:**
- [ ] Update temp table with codes from mapping
```sql
INSERT INTO #LienValueCodes (code)
VALUES
('SUBRO')
```

###### Disbursements
_Script name here_
**Code modification instructions:**
- [ ] Update temp table with codes from mapping
```sql
INSERT INTO #DisbursementValueCodes (code)
VALUES
('CEX'), ('DTF')
```

###### Negotiation/Settlement
_Script name here_
**Code modification instructions:**
- [ ] Update temp table with codes from mapping
```sql
INSERT INTO #NegSetValueCodes (code)
VALUES
('FEE'), ('SET')
```
- [ ] Create necessary settlement types
```sql
INSERT INTO [sma_MST_SettlementType] (SettlTypeName)
SELECT 'Recovery'
UNION SELECT 'Attorney Fee'
EXCEPT SELECT SettlTypeName FROM [sma_MST_SettlementType]
GO
```
- [ ] Update `case` for `stlTypeID`
```sql
    ,(
        select ID
        from [sma_MST_SettlementType]
        where SettlTypeName = case
                                    when v.[code] in ('SET')
                                        then 'Settlement Recovery'
			                        when v.[code] in ('MP')
                                        then 'MedPay'
                                    when v.[code] in ('PTC' )
                                        then 'Paid To Client' 
                                    end 
    )                               as stlTypeID
```

## Sequence 3 - UDF

## Sequence 4 - Intake

## Sequence 5 - Misc

## Sequence P - Post 


#### General

##### Summary
##### Case Type

##### Status
1. Create "Grade" status type in sma_mst_CaseStatusType
2. Add distinct Grade values into sma_mst_CaseStatus
3. Update appropriate cases with the Grade status type and description
```sql
--select distinct Grade from NeedlesSLF..user_case_data where isnull(grade,'')<>''
select top (1) * from SANeedlesSLF..sma_TRN_Cases
select * from SANeedlesSLF..sma_MST_CaseStatusType
select * from SANeedlesSLF..sma_MST_CaseStatus where cssnStatusTypeID = 24
select * from SANeedlesSLF..sma_TRN_CaseStatus where cssnCaseID = 1
```

##### Investigations
sma_TRN_CaseWitness
- Create witness contact card
- saga_ref = 'witness'
- saga = user_party_data.case_id (which is really case number)

1.33_Witness_Contacts.sql
2.26_General_Investigations_Witness.sql

##### Disbursements
**Key Concepts**
Create Disbursement (`[sma_TRN_Disbursement]`) records from the `value` table. Add user fields to the disbursement record as necessary.

**Script Readme**
- Creates DisbursementTypes that don't exist for mapped value codes.
- Creates helper tables to collate contact information for the Provider ("due to firm") and Plaintiff.
- Creates disbursement records.

**Value Codes**
- 1
- 2
- 3