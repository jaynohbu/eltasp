-- =============================================
-- Author:		@Author,,Name>
-- Create date: @Create Date,
-- Description:	@Description,
-- =============================================
CREATE PROCEDURE [dbo].[DeleteAESLineItem]			
		    @id decimal          
AS
BEGIN	
   Delete from  [dbo].[aes_detail]  
 WHERE id=@id 
END
