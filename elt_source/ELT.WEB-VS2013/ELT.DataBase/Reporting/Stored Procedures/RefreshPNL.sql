-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE Reporting.RefreshPNL
	@elt_account_number int
AS
BEGIN
	BEGIN TRANSACTION
		BEGIN TRY	
			DELETE FROM [Reporting].[PNL] WHERE elt_account_number =@elt_account_number
																																				INSERT INTO [Reporting].[PNL]
		([Type]
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
		,[Date])

		SELECT 
		'Revenue'
		,[ImportExport]
		,[AirOcean]
		,[Master_House]
		,R.[elt_account_number]
		,[MBL_NUM]
		,[HBL_NUM]
		,[Item_Code]
		,[Charge_Desc]
		,[Bill_To]
		,[Amount]
		,[ORIGIN]
		,[DEST]
		,CI.Customer_Name
		,[Date]
		FROM [dbo].[VW_OperationalCharge] R inner join VW_CustomerInfo CI on R.Bill_To = CI.org_account_number and R.elt_account_number = CI.elt_account_number
		WHERE R.elt_account_number =@elt_account_number 
																																				INSERT INTO [Reporting].[PNL]
		([Type]
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
		,[Date]) 

		SELECT 
		'Expense'
		,[ImportExport]
		,[AirOcean]
		,[Master_House]
		,R.[elt_account_number]
		,[MBL_NUM]
		,[HBL_NUM]
		,[Item_Code]
		,[Cost_Desc]
		,[Bill_From]
		,[Amount]
		,[ORIGIN]
		,[DEST]
		,CI.Customer_Name
		,[Date]
		FROM [dbo].[VW_OperationalCost] R inner join VW_CustomerInfo CI on R.Bill_From = CI.org_account_number and R.elt_account_number = CI.elt_account_number

		WHERE R.elt_account_number =@elt_account_number 
		COMMIT TRANSACTION ;
	END TRY
	BEGIN CATCH 
		ROLLBACK;
	END CATCH
END
