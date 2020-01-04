
CREATE PROCEDURE [dbo].[GetOceanExportDocumentList]
	@BillType varchar(20),
	@ELT_ACCOUNT_NUMBER int,
	@BillNum varchar(30)
AS
BEGIN
  
   If @BillType = 'house' 
        BEGIN
             select 'N' as isDirect,b.booking_num,b.mbol_num,b.hbol_num,b.agent_no,b.agent_name, b.shipper_acct_num, b.shipper_name,a.consignee_acct_num as master_agent,ISNULL(c.invoice_no,-1) as invoice_no, d.owner_email as agent_email, d.edt,d.agent_elt_acct,e.MsgTxt 
             ,(select owner_email from dbo.organization  where org_account_number =b.shipper_acct_num and b.elt_account_number = elt_account_number) as shipper_email
             FROM mbol_master a 
             LEFT OUTER JOIN hbol_master b ON (a.elt_account_number=b.elt_account_number AND a.booking_num=b.booking_num) 
             LEFT OUTER JOIN invoice c ON (b.elt_account_number=c.elt_account_number AND b.booking_num=c.mawb_num AND b.hbol_num=c.hawb_num AND c.air_ocean='O' AND c.import_export='E') 
             LEFT OUTER JOIN organization d ON (b.elt_account_number=d.elt_account_number AND b.agent_no=d.org_account_number) 
             LEFT OUTER JOIN greetMessage e ON (b.elt_account_number=e.AgentID AND MsgType='') 
             WHERE a.elt_account_number=@ELT_ACCOUNT_NUMBER AND b.booking_num=
             (SELECT booking_num FROM hbol_master WHERE elt_account_number=@ELT_ACCOUNT_NUMBER AND hbol_num=@BillNum) 
             AND ISNULL(b.agent_no,0)<>0 ORDER BY b.agent_name, b.hbol_num
               
        END 
        
    IF @BillType = 'master'
         BEGIN  
         
             SELECT 'N' as isDirect,b.booking_num,b.mbol_num,b.hbol_num,b.agent_no,b.agent_name,a.consignee_acct_num as master_agent, b.shipper_acct_num,b.shipper_name,ISNULL(c.invoice_no,-1) as invoice_no,d.owner_email as agent_email,d.edt,d.agent_elt_acct,e.MsgTxt 
                          ,(select owner_email from dbo.organization where org_account_number =b.shipper_acct_num and b.elt_account_number = elt_account_number) as shipper_email

             FROM mbol_master a LEFT OUTER JOIN hbol_master b ON (a.elt_account_number=b.elt_account_number AND a.booking_num=b.booking_num) 
             LEFT OUTER JOIN invoice c ON (b.elt_account_number=c.elt_account_number AND b.booking_num=c.mawb_num AND b.hbol_num=c.hawb_num AND c.air_ocean='O' AND c.import_export='E') 
             LEFT OUTER JOIN organization d ON (b.elt_account_number=d.elt_account_number AND b.agent_no=d.org_account_number) 
             LEFT OUTER JOIN greetMessage e ON (b.elt_account_number=e.AgentID AND MsgType='') 
             WHERE a.elt_account_number= @ELT_ACCOUNT_NUMBER  AND b.booking_num= @BillNum AND ISNULL(b.agent_no,0)<>0 ORDER BY b.agent_name, b.hbol_num             
             
            If @@ROWCOUNT =0 
            BEGIN
                 SELECT 'Y' as isDirect,a.booking_num,a.mbol_num,'' AS hbol_num,a.consignee_acct_num as agent_no,a.shipper_acct_num,a.shipper_name,a.consignee_name as agent_name,a.consignee_acct_num as master_agent,ISNULL(c.invoice_no,-1) as invoice_no,d.owner_email as agent_email,d.edt,d.agent_elt_acct,e.MsgTxt 
                  ,(select owner_email from dbo.organization where org_account_number =a.shipper_acct_num and a.elt_account_number = elt_account_number) as shipper_email

                 FROM mbol_master a LEFT OUTER JOIN invoice c ON (a.elt_account_number=c.elt_account_number AND a.booking_num=c.mawb_num AND ISNULL(c.hawb_num,'')='' AND c.air_ocean='O' AND c.import_export='E') 
                 LEFT OUTER JOIN organization d ON (a.elt_account_number=d.elt_account_number AND a.consignee_acct_num=d.org_account_number) 
                 LEFT OUTER JOIN greetMessage e ON (a.elt_account_number=e.AgentID AND MsgType='') 
                 WHERE a.elt_account_number= @ELT_ACCOUNT_NUMBER AND a.booking_num = @BillNum AND ISNULL(a.consignee_acct_num,0)<>0 ORDER BY a.consignee_name 
                 

            END
        END     
        
        IF  @BillType = 'file'
         BEGIN        
             SELECT 'N' as isDirect,b.booking_num,b.mbol_num,b.hbol_num,b.agent_no,b.agent_name,b.shipper_acct_num,b.shipper_name,a.consignee_acct_num as master_agent,ISNULL(c.invoice_no,-1) as invoice_no,d.owner_email as agent_email,d.edt,d.agent_elt_acct,e.MsgTxt 
                          ,(select owner_email from dbo.organization  where org_account_number =b.shipper_acct_num and b.elt_account_number = elt_account_number) as shipper_email

             FROM mbol_master a LEFT OUTER JOIN hbol_master b ON (a.elt_account_number=b.elt_account_number AND a.booking_num=b.booking_num) 
             LEFT OUTER JOIN invoice c ON (b.elt_account_number=c.elt_account_number AND b.booking_num=c.mawb_num AND b.hbol_num=c.hawb_num AND c.air_ocean='O' AND c.import_export='E') 
             LEFT OUTER JOIN organization d ON (b.elt_account_number=d.elt_account_number AND b.agent_no=d.org_account_number) 
             LEFT OUTER JOIN greetMessage e ON (b.elt_account_number=e.AgentID AND MsgType='') 
             LEFT OUTER JOIN ocean_booking_number f ON (a.elt_account_number=f.elt_account_number AND a.booking_num=f.booking_num) 
             WHERE a.elt_account_number= @ELT_ACCOUNT_NUMBER AND f.file_no=@BillNum AND ISNULL(b.agent_no,0)<>0 ORDER BY b.agent_name, b.hbol_num 
            
			If @@ROWCOUNT =0 
			 BEGIN
				SELECT 'Y' as isDirect,a.booking_num,a.mbol_num,'' AS hbol_num,a.consignee_acct_num as agent_no,a.shipper_acct_num,a.shipper_name,a.consignee_name as agent_name,a.consignee_acct_num as master_agent,ISNULL(c.invoice_no,-1) as invoice_no,d.owner_email as agent_email,d.edt,d.agent_elt_acct,e.MsgTxt 
				,(select owner_email from dbo.organization  where org_account_number =a.shipper_acct_num and a.elt_account_number = elt_account_number) as shipper_email

				FROM mbol_master a LEFT OUTER JOIN invoice c ON (a.elt_account_number=c.elt_account_number AND a.booking_num=c.mawb_num AND ISNULL(c.hawb_num,'')='' AND c.air_ocean='O' AND c.import_export='E') 
				LEFT OUTER JOIN organization d ON (a.elt_account_number=d.elt_account_number AND a.consignee_acct_num=d.org_account_number) 
				LEFT OUTER JOIN greetMessage e ON (a.elt_account_number=e.AgentID AND MsgType='') 
				LEFT OUTER JOIN ocean_booking_number f ON (a.elt_account_number=f.elt_account_number AND a.booking_num=f.booking_num) 
				WHERE a.elt_account_number=@ELT_ACCOUNT_NUMBER AND f.file_no=@BillNum AND ISNULL(a.consignee_acct_num,0)<>0 ORDER BY a.consignee_name
			END            
         END
        
        
END
