
CREATE PROCEDURE [dbo].[GetImportDocumentList]
	@BillType varchar(20),
	@elt_account_number varchar(20),
	@BillNum varchar(20),
	@iType char(1)
AS
BEGIN
	IF @BillType = 'file' 
		SELECT  a.sec,c.invoice_no, a.mawb_num,b.hawb_num,d.owner_email,e.MsgTxt,d.org_account_number as agent_no,d.dba_name as agent_name,b.pieces,b.gross_wt,b.freight_collect+b.oc_collect as col_amt,b.pickup_date 
		FROM import_mawb a LEFT OUTER JOIN import_hawb b ON (a.elt_account_number=b.elt_account_number AND a.mawb_num=b.mawb_num AND a.sec=b.sec AND a.iType=b.iType) 
		LEFT OUTER JOIN invoice c ON (a.elt_account_number=c.elt_account_number AND a.mawb_num=c.mawb_num AND b.hawb_num=c.hawb_num AND a.iType=c.air_ocean) 
		LEFT OUTER JOIN organization d ON (a.elt_account_number=d.elt_account_number AND a.agent_org_acct=d.org_account_number) 
		LEFT OUTER JOIN greetMessage e ON (a.elt_account_number=e.AgentID AND e.MsgType='') 
		WHERE a.elt_account_number=@elt_account_number   AND a.file_no=@BillNum AND a.iType=@iType AND ISNULL(b.mawb_num,'')<>'' AND c.import_export='I'
	IF @BillType = 'master' 
		 SELECT  a.sec,c.invoice_no, a.mawb_num,b.hawb_num,d.owner_email,e.MsgTxt,d.org_account_number as agent_no,d.dba_name as agent_name,b.pieces,b.gross_wt,b.freight_collect+b.oc_collect as col_amt,b.pickup_date 
		 FROM import_mawb a LEFT OUTER JOIN import_hawb b ON (a.elt_account_number=b.elt_account_number AND a.mawb_num=b.mawb_num AND a.sec=b.sec AND a.iType=b.iType) 
		 LEFT OUTER JOIN invoice c ON (a.elt_account_number=c.elt_account_number AND a.mawb_num=c.mawb_num AND b.hawb_num=c.hawb_num AND a.iType=c.air_ocean) 
		 LEFT OUTER JOIN organization d ON (a.elt_account_number=d.elt_account_number AND a.agent_org_acct=d.org_account_number) 
		 LEFT OUTER JOIN greetMessage e ON (a.elt_account_number=e.AgentID AND e.MsgType='') 
		 WHERE a.elt_account_number=@elt_account_number   AND a.mawb_num=@BillNum AND a.iType=@iType AND ISNULL(b.mawb_num,'')<>'' AND c.import_export='I'
	IF @BillType = 'house' 
		 SELECT  a.sec,c.invoice_no, a.mawb_num,b.hawb_num,d.owner_email,e.MsgTxt,d.org_account_number as agent_no,d.dba_name as agent_name,b.pieces,b.gross_wt,b.freight_collect+b.oc_collect as col_amt,b.pickup_date 
		 FROM import_mawb a LEFT OUTER JOIN import_hawb b ON (a.elt_account_number=b.elt_account_number AND a.mawb_num=b.mawb_num AND a.sec=b.sec AND a.iType=b.iType) 
		 LEFT OUTER JOIN invoice c ON (a.elt_account_number=c.elt_account_number AND a.mawb_num=c.mawb_num AND b.hawb_num=c.hawb_num AND a.iType=c.air_ocean) 
		 LEFT OUTER JOIN organization d ON (a.elt_account_number=d.elt_account_number AND a.agent_org_acct=d.org_account_number) 
		 LEFT OUTER JOIN greetMessage e ON (a.elt_account_number=e.AgentID AND e.MsgType='') 
		 WHERE a.elt_account_number=@elt_account_number   AND b.hawb_num=@BillNum AND a.iType=@iType AND ISNULL(b.mawb_num,'')<>'' AND c.import_export='I'

END
