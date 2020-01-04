
CREATE PROCEDURE [Reporting].[GetPNL]
	@elt_account_number int,
	@MBL_NUM NVARCHAR(100),
	@Begin DateTime,
	@End DateTime
AS
BEGIN

IF ISNULL(@MBL_NUM,'')=''


SELECT 
       [Type]
      ,[ImportExport]
      ,[AirOcean]
      ,[Master_House]
      ,[elt_account_number]
      ,[MBL_NUM]
      ,[HBL_NUM]
      ,[Item_Code]
      ,[Description]
      ,[Customer_ID]
      ,[Amount]
      ,[ORIGIN]
      ,[DEST]
      ,[Customer_Name]
      ,[Date]
  FROM  [Reporting].[PNL]  p WHERE p.[elt_account_number] =@elt_account_number 
  AND [Date] > =@Begin AND [Date] <=@End order by [Customer_Name]
  
  
  ELSE 
  
  SELECT 
       [Type]
      ,[ImportExport]
      ,[AirOcean]
      ,[Master_House]
      ,[elt_account_number]
      ,[MBL_NUM]
      ,[HBL_NUM]
      ,[Item_Code]
      ,[Description]
      ,[Customer_ID]
      ,[Amount]
      ,[ORIGIN]
      ,[DEST]
      ,[Customer_Name]
      ,[Date]
  FROM  [Reporting].[PNL]  p WHERE p.[elt_account_number] =@elt_account_number and ( MBL_NUM =@MBL_NUM )
  order by [Customer_Name]
  
  
  
  


END
