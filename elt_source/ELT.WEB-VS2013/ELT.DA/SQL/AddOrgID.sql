USE [PRDDB]
GO
declare @tmp table(
[elt_account_number] [decimal](8, 0)  ,
	[org_account_number] [decimal](18, 0)  ,
	 [OrgId] decimal (18, 0) )
/****** Object:  Table [dbo].[organization]    Script Date: 04/22/2014 15:04:09 ******/
INSERT INTO @tmp
           ([elt_account_number]
           ,[org_account_number]          
           ,[OrgId])
SELECT    [elt_account_number]
           ,[org_account_number]          
           ,ROW_NUMBER() 
        OVER (ORDER BY [elt_account_number],[org_account_number]) AS Row
        from organization 
        
declare @id int = 1
declare @elt_account_number int
declare @org_account_number int 
declare @rowcount int
select @rowcount =  count(*) from @tmp 
while @id <= @rowcount
begin
 select @elt_account_number = elt_account_number, @org_account_number = org_account_number from @tmp where orgid =@id 
 update organization set orgid = @id 
 where elt_account_number=@elt_account_number and org_account_number=@org_account_number
 set @id=@id+1
end 