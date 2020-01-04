-- =============================================
-- Author:		@Author,,Name>
-- Create date: @Create Date,
-- Description:	@Description,
-- =============================================
CREATE PROCEDURE [dbo].[UpdateAESLineItem]			
		    @id decimal 
           ,@item_no int=0
           ,@dfm nvarchar(1)=''
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
   UPDATE [dbo].[aes_detail]
   SET [item_no] = @item_no
      ,[dfm] = @dfm
      ,[b_number] = @b_number
      ,[item_desc] = @item_desc
      ,[b_qty1] = @b_qty1
      ,[unit1] = @unit1
      ,[b_qty2] = @b_qty2
      ,[unit2] = @unit2
      ,[gross_weight] = @gross_weight
      ,[vin_type] = @vin_type
      ,[vin] = @vin
      ,[vc_title] = @vc_title
      ,[vc_state] = @vc_state
      ,[item_value] = @item_value
      ,[export_code] = @export_code
      ,[license_type] = @license_type
      ,[aes_id] = @aes_id
      ,[eccn] = @eccn
      ,[license_number] = @license_number
 WHERE id=@id 



END
