


Create FUNCTION [dbo].[RemoveNonASCII] 
(
	@nstring varchar(4000)
)
RETURNS varchar(4000)
AS
BEGIN

	DECLARE @Result varchar(4000)
	SET @Result = ''

	DECLARE @nchar nvarchar(1)
	DECLARE @position int

	SET @position = 1
	WHILE @position <= LEN(@nstring)
	BEGIN
		SET @nchar = SUBSTRING(@nstring, @position, 1)
		--Unicode & ASCII are the same from 1 to 255.
		--Only Unicode goes beyond 255
		--0 to 31 are non-printable characters
		IF ((UNICODE(@nchar) between 32 and 255) or (UNICODE(@nchar)=10) or (UNICODE(@nchar)=13))
			SET @Result = @Result + @nchar
		SET @position = @position + 1
	END

	RETURN @Result

END
go

INSERT INTO [sma_MST_CaseTypeInjury]
           ([ctinInjuryID]
           ,[ctinCaseTypeID]
           ,[ctisTreatment]
           ,[ctinRecUserID]
           ,[ctidDtCreated]
           ,[ctinModifyUserID]
           ,[ctidDtModified]
           ,[ctinLevelNo])
select distinct 0,cstnCaseTypeID,0,368,GETDATE(),null,null,'' from sma_MST_CaseType
except
select 0,ctinCaseTypeID,0,368,GETDATE(),null,null,'' from sma_MST_CaseTypeInjury

alter table [sma_TRN_Injury] disable trigger all
INSERT INTO [sma_TRN_Injury]
([injnCaseId],[injnPlaintiffId],[injnInjuryType],[injnBodyPartSide],[injnBodyPartID],[injnInjuryNameID],[injsTreatmentIDS],[injsSequaleadIDS],[injsDescription]
,[injnDuration],[injdInjuryDt],[injnBOPInterrogation],[injbDocAttached],[injnPriority],[injsComments],[injnRecUserID],[injdDtCreated],[injnModifyUserID],[injdDtModified],[injnLevelNo],[injnOtherInj])
select distinct casnCaseID,plnnPlaintiffID,3,0,0,null,null,null,convert(varchar(4000),isnull(n1.NOTES,'')),0,null,null,null,null,convert(varchar(3800),isnull(n2.NOTES,''))+CHAR(13)+ isnull(CONFINEDHOME,'') +CHAR(13)+ isnull(CONFINEDBED,'')+CHAR(13)+ isnull(INHOSPITAL,'')+CHAR(13)+ isnull(INCAPACITATED,''),casnRecUserID,casdDtCreated,null,null,'',''
from [WilliamPagerSaga].dbo.LW_injury li
left join [WilliamPagerSaga].dbo.NOTE n1 on n1.NOTEID=SYNOPSISNOTEID
left join [WilliamPagerSaga].dbo.NOTE n2 on n2.NOTEID=PLEADINGNOTEID
left join  [WilliamPagerSaga].dbo.assign a on li.assignid=a.assignid 
left join [WilliamPagerSaga].dbo.matter m on a.matterid=m.matterid
left join [WilliamPagerSaga].dbo.LW_A_MATTERTYPE LMT on m.MATTERTYPEID=LMT.MATTERTYPEID
--outer apply(SELECT top 1  en.code,en.ENTITYID  FROM  [WilliamPagerSaga].dbo.entities en left JOIN  [WilliamPagerSaga].dbo.assign aa on aa.ENTITYID=en.entityid left JOIN  [WilliamPagerSaga].dbo.erole r on r.ROLEID=aa.ROLEID  WHERE  r.rolecategoryid in (1)) pAName     
 left join [WilliamPagerSaga].dbo.entities e on a.entityid=e.entityid
left join sma_MST_IndvContacts l on l.cinsGrade=e.ENTITYID
left join sma_MST_OrgContacts k on k.connLevelNo=e.ENTITYID
left join sma_trn_cases on cassCaseNumber=m.MATTERNUMBER
left join sma_TRN_Plaintiff on  ((plnnContactID=k.conncontactid and plnnContactCtg=2) or (plnnContactID=l.cinncontactid and plnnContactCtg=1)) and plnnCaseID=casnCaseID
where casnCaseID is not null and plnnPlaintiffID is not null 

go
update sma_TRN_Injury
set injnOtherInj=convert(varchar(6000),ltrim(replace(
       dbo.RegExReplace(injsComments,'({\\)(.+?)(})|(\\)(.+?)(\b)','')
      ,'}','')
     
      )),injsDescription=convert(varchar(6000),ltrim(replace(
       dbo.RegExReplace(injsDescription,'({\\)(.+?)(})|(\\)(.+?)(\b)','')
      ,'}','')
     
      )),injsComments=''
      
go

Update sma_TRN_Injury set injsDescription=dbo.RemoveNonASCII(injsDescription),injsComments=dbo.RemoveNonASCII(injsComments),injnOtherInj=dbo.RemoveNonASCII([injnOtherInj]) --where injnCaseId=1694

go
alter table [sma_TRN_Injury] enable trigger all

