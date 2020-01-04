CREATE PROCEDURE [dbo].[Insert_all_rate_table]
			@elt_account_number decimal
           ,@item_no decimal
           ,@rate_type int
           ,@agent_no int
           ,@customer_no int
           ,@airline nvarchar(50)
           ,@origin_port nvarchar(50)
           ,@dest_port nvarchar(50)
           ,@weight_break decimal
           ,@rate decimal(8,2)
           ,@kg_lb nchar(1)
           ,@share decimal(8,2)         
           ,@rate_table_id decimal

AS
BEGIN

	INSERT INTO [dbo].[all_rate_table]
			   ([elt_account_number]
			   ,[item_no]
			   ,[rate_type]
			   ,[agent_no]
			   ,[customer_no]
			   ,[airline]
			   ,[origin_port]
			   ,[dest_port]
			   ,[weight_break]
			   ,[rate]
			   ,[kg_lb]
			   ,[share]			   
			   ,[rate_table_id])
		 VALUES
			   (@elt_account_number 
			   ,@item_no 
			   ,@rate_type 
			   ,@agent_no 
			   ,@customer_no 
			   ,@airline 
			   ,@origin_port 
			   ,@dest_port 
			   ,@weight_break 
			   ,@rate 
			   ,@kg_lb 
			   ,@share 			   
			   ,@rate_table_id )

END

GO

