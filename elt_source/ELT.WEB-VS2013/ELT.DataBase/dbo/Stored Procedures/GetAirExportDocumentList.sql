
CREATE PROCEDURE [dbo].[GetAirExportDocumentList]
	@BillType varchar(20),
	@ELT_ACCOUNT_NUMBER int,
	@BillNum varchar(30)
AS
BEGIN

   If @BillType = 'house' 
        BEGIN
           SELECT 'N' as isDirect,a.mawb_num,b.hawb_num,b.agent_no,b.agent_name,b.shipper_account_number,b.shipper_name,ISNULL(c.invoice_no,-1) as invoice_no,
           d.owner_email as agent_email,
           (select owner_email from dbo.organization where org_account_number =b.shipper_account_number and b.elt_account_number = elt_account_number) as shipper_email,
           d.edt,d.agent_elt_acct,MsgTxt,a.master_agent
           FROM mawb_master a LEFT OUTER JOIN hawb_master b ON (a.elt_account_number=b.elt_account_number AND a.mawb_num=b.mawb_num)
           LEFT OUTER JOIN invoice c ON (b.elt_account_number=c.elt_account_number AND b.mawb_num=c.mawb_num AND b.hawb_num=c.hawb_num AND c.air_ocean='A' AND c.import_export='E')
           LEFT OUTER JOIN organization d ON (b.elt_account_number=d.elt_account_number AND b.agent_no=d.org_account_number)
           LEFT OUTER JOIN greetMessage e ON (b.elt_account_number=e.AgentID AND MsgType='')
           WHERE a.elt_account_number=@ELT_ACCOUNT_NUMBER AND a.mawb_num=(SELECT TOP 1 mawb_num FROM hawb_master
           WHERE elt_account_number=@ELT_ACCOUNT_NUMBER AND hawb_num=@BillNum) AND ISNULL(b.agent_no,0)<>0 ORDER BY b.agent_name, b.hawb_num
        END 
        
    IF @BillType = 'master'
         BEGIN        
           SELECT 'N' as isDirect,a.mawb_num,b.hawb_num,b.agent_no,b.agent_name,b.shipper_account_number,b.shipper_name,ISNULL(c.invoice_no,-1) as invoice_no,
           d.owner_email as agent_email,
             (select owner_email from dbo.organization  where org_account_number =b.shipper_account_number and b.elt_account_number = elt_account_number) as shipper_email,
           d.edt,d.agent_elt_acct,MsgTxt,a.master_agent
           FROM mawb_master a LEFT OUTER JOIN hawb_master b ON (a.elt_account_number=b.elt_account_number AND a.mawb_num=b.mawb_num)
           LEFT OUTER JOIN invoice c ON (b.elt_account_number=c.elt_account_number AND b.mawb_num=c.mawb_num AND b.hawb_num=c.hawb_num AND c.air_ocean='A' AND c.import_export='E')
           LEFT OUTER JOIN organization d ON (b.elt_account_number=d.elt_account_number AND b.agent_no=d.org_account_number)
           LEFT OUTER JOIN greetMessage e ON (b.elt_account_number=e.AgentID AND MsgType='')
           WHERE a.elt_account_number=@ELT_ACCOUNT_NUMBER AND a.mawb_num= @BillNum  AND ISNULL(b.agent_no,0)<>0 ORDER BY b.agent_name, b.hawb_num           
            
            If @@ROWCOUNT =0 
            BEGIN
               SELECT 'Y' as isDirect,a.mawb_num,'' AS hawb_num,a.consignee_acct_num as agent_no,a.consignee_name as agent_name,a.shipper_account_number,a.shipper_name,ISNULL(c.invoice_no,-1) as invoice_no,d.owner_email as agent_email,d.edt,d.agent_elt_acct,MsgTxt,a.master_agent,
                 (select owner_email from dbo.organization where org_account_number =a.shipper_account_number and a.elt_account_number = elt_account_number) as shipper_email
               FROM mawb_master a LEFT OUTER JOIN invoice c ON (a.elt_account_number=c.elt_account_number AND a.mawb_num=c.mawb_num AND ISNULL(c.hawb_num,'')='' AND c.air_ocean='A' AND c.import_export='E')
               LEFT OUTER JOIN organization d ON (a.elt_account_number=d.elt_account_number AND a.consignee_acct_num=d.org_account_number)
               LEFT OUTER JOIN greetMessage e ON (a.elt_account_number=e.AgentID AND MsgType='')
               WHERE a.elt_account_number=@ELT_ACCOUNT_NUMBER AND a.mawb_num=@BillNum AND ISNULL(a.consignee_acct_num,0)<>0 ORDER BY a.consignee_name
            END
        END     
        
        IF  @BillType = 'file'
         BEGIN        
           SELECT 'N' as isDirect,a.mawb_num,f.file#,b.hawb_num,b.agent_no,b.agent_name,b.shipper_account_number,b.shipper_name,ISNULL(c.invoice_no,-1) as invoice_no,
           d.owner_email as agent_email,
             (select owner_email from dbo.organization where org_account_number =b.shipper_account_number and b.elt_account_number = elt_account_number) as shipper_email,
           d.edt,d.agent_elt_acct,MsgTxt,a.master_agent
           FROM mawb_master a LEFT OUTER JOIN hawb_master b ON (a.elt_account_number=b.elt_account_number AND a.mawb_num=b.mawb_num)
           LEFT OUTER JOIN invoice c ON (b.elt_account_number=c.elt_account_number AND b.mawb_num=c.mawb_num AND b.hawb_num=c.hawb_num AND c.air_ocean='A' AND c.import_export='E')
           LEFT OUTER JOIN organization d ON (b.elt_account_number=d.elt_account_number AND b.consignee_acct_num=d.org_account_number)
           LEFT OUTER JOIN greetMessage e ON (b.elt_account_number=e.AgentID AND MsgType='')
           LEFT OUTER JOIN mawb_number f ON (b.elt_account_number=f.elt_account_number AND b.mawb_num=f.mawb_no)
           WHERE a.elt_account_number=@ELT_ACCOUNT_NUMBER AND f.file#=@BillNum AND ISNULL(b.agent_no,0)<>0 ORDER BY agent_name, b.hawb_num        
            
			If @@ROWCOUNT =0 
			 BEGIN
			   SELECT 'Y' as isDirect,a.mawb_num,f.file#,'' AS hawb_num,a.consignee_acct_num as agent_no,a.consignee_name as agent_name,a.shipper_account_number,a.shipper_name,ISNULL(c.invoice_no,-1) as invoice_no,d.owner_email as agent_email,d.edt,d.agent_elt_acct,MsgTxt,a.master_agent ,
			     (select owner_email from dbo.organization  where org_account_number =a.shipper_account_number and a.elt_account_number = elt_account_number) as shipper_email
			   FROM mawb_master a LEFT OUTER JOIN invoice c ON (a.elt_account_number=c.elt_account_number AND a.mawb_num=c.mawb_num AND ISNULL(c.hawb_num,'')='' AND c.air_ocean='A' AND c.import_export='E') 
			   LEFT OUTER JOIN organization d ON (a.elt_account_number=d.elt_account_number AND a.consignee_acct_num=d.org_account_number) 
			   LEFT OUTER JOIN greetMessage e ON (a.elt_account_number=e.AgentID AND MsgType='') 
			   LEFT OUTER JOIN mawb_number f ON (a.elt_account_number=f.elt_account_number AND a.mawb_num=f.mawb_no) 
			   WHERE a.elt_account_number=@ELT_ACCOUNT_NUMBER AND f.file#=@BillNum AND ISNULL(a.consignee_acct_num,0)<>0 ORDER BY a.consignee_name
			END            
         END
        
END
