-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetAgentsInMAWB]
    @MAWB VARCHAR(100),
	@ELT_ACCOUNT_NUMBER INT 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
SELECT a.agent_name,a.agent_no,b.Consignee_acct_num FROM hawb_master a JOIN mawb_master b
 ON (a.mawb_num = b.mawb_num AND a.elt_account_number=b.elt_account_number)
  WHERE a.elt_account_number=@ELT_ACCOUNT_NUMBER AND a.mawb_num=@MAWB
  GROUP BY a.agent_name,a.agent_no,b.Consignee_acct_num  ORDER BY a.agent_name
END
