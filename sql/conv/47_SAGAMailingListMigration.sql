Set Ansi_warnings off
go
Insert into [sma_MST_MailingLists]
Select distinct code,DESCRIPTION,getdate(),368,null,null
From WilliamPagerSaga.dbo.LW_MAILING 
where not exists (select * from [sma_MST_MailingLists] where DESCRIPTION=MailingListsDescription)
go
Insert Into [sma_MST_MailingListContacts]
select distinct MailingListID,'1'+cast(cinnContactID as varchar(20)),getdate(),368  
from WilliamPagerSaga.dbo.LW_ENTMAILAS a
left join WilliamPagerSaga.dbo.LW_MAILING  b on a.MAILINGID=b.LW_MAILINGID
left join [sma_MST_MailingLists] on DESCRIPTION=MailingListsDescription
join sma_MST_IndvContacts on cinsGrade=ENTITYID
go
Insert Into [sma_MST_MailingListContacts]
select distinct MailingListID,'2'+cast(connContactID as varchar(20)),getdate(),368  
from WilliamPagerSaga.dbo.LW_ENTMAILAS a
left join WilliamPagerSaga.dbo.LW_MAILING  b on a.MAILINGID=b.LW_MAILINGID
left join WilliamPagerSaga.dbo.ENTITIES e on e.ENTITYID=a.ENTITYID
left join [sma_MST_MailingLists] on DESCRIPTION=MailingListsDescription
join sma_MST_orgContacts on consName=isnull(last_company,'') or consName=isnull(ENTITYNAME,'')
where not exists (select * from sma_MST_IndvContacts where cinsGrade=a.ENTITYID)



