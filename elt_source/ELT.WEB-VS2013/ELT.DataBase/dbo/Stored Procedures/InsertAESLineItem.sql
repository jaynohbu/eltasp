-- =============================================
-- Author:		@Author,,Name>
-- Create date: @Create Date,
-- Description:	@Description,
-- =============================================
CREATE PROCEDURE [dbo].[InsertAESLineItem]
			@elt_account_number decimal(8,0)
           ,@item_no int=0
           ,@dfm nvarchar(1)
           ,@b_number nvarchar(32)
           ,@item_desc nvarchar(128)=''
           ,@b_qty1 int=0
           ,@unit1 nvarchar(16)=''
           ,@b_qty2 int=0
           ,@unit2 nvarchar(16)=''
           ,@gross_weight decimal(12,2)=0
           ,@vin_type nvarchar(1)=''
           ,@vin nvarchar(32)=''
           ,@vc_title nvarchar(15)=''
           ,@vc_state nvarchar(2)=''
           ,@item_value decimal(12,2)=0
           ,@export_code nvarchar(32)=''
           ,@license_type nvarchar(32)=''
           ,@aes_id decimal(18,0)
           ,@eccn nvarchar(5)=''
           ,@license_number nvarchar(12)=''
AS
BEGIN	
   INSERT INTO [dbo].[aes_detail]
           ([elt_account_number]
           ,[item_no]
           ,[dfm]
           ,[b_number]
           ,[item_desc]
           ,[b_qty1]
           ,[unit1]
           ,[b_qty2]
           ,[unit2]
           ,[gross_weight]
           ,[vin_type]
           ,[vin]
           ,[vc_title]
           ,[vc_state]
           ,[item_value]
           ,[export_code]
           ,[license_type]
           ,[aes_id]
           ,[eccn]
           ,[license_number])
     VALUES
           (@elt_account_number
           ,@item_no
           ,@dfm
           ,@b_number
           ,@item_desc
           ,@b_qty1
           ,@unit1
           ,@b_qty2
           ,@unit2
           ,@gross_weight
           ,@vin_type
           ,@vin
           ,@vc_title
           ,@vc_state
           ,@item_value
           ,@export_code
           ,@license_type
           ,@aes_id
           ,@eccn
           ,@license_number)
END
