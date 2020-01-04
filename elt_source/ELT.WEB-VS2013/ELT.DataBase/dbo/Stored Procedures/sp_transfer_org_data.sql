
/****** Object:  Stored Procedure dbo.sp_transfer_org_data    Script Date: 7/31/2008 11:07:36 AM ******/

/****** Object:  Stored Procedure dbo.sp_transfer_org_data    Script Date: 5/5/2008 2:56:02 PM ******/

/****** Object:  Stored Procedure dbo.sp_transfer_org_data    Script Date: 5/5/2008 2:47:35 PM ******/

/****** Object:  Stored Procedure dbo.sp_transfer_org_data    Script Date: 5/5/2008 2:24:42 PM ******/

/****** Object:  Stored Procedure dbo.sp_transfer_org_data    Script Date: 2/21/2007 5:34:08 PM ******/



CREATE PROCEDURE dbo.sp_transfer_org_data
(
	@nElt_account_number As nvarchar(8),
	@source_org decimal(8),
	@target_org decimal(8)

)
AS

SET NOCOUNT OFF;

DECLARE @target_org_name As nvarchar(128)

SET @target_org_name = ( select dba_name from organization 
where elt_account_number = @nElt_account_number and org_account_number = @target_org )

-- 'agent_rate_table'
update agent_rate_table set agent_no=@target_org,agent_name = @target_org_name 
where elt_account_number = @nElt_account_number and isnull(agent_no,0) = @source_org
-- 'agent_view_object'
update agent_view_object set agent_no=@target_org 
where elt_account_number = @nElt_account_number and isnull(agent_no,0) = @source_org
-- 'all_accounts_journal'
update all_accounts_journal set customer_number=@target_org,customer_name = @target_org_name 
where elt_account_number = @nElt_account_number and isnull(customer_number,0) = @source_org
-- 'all_rate_table'
update all_rate_table set agent_no = @target_org 
where elt_account_number = @nElt_account_number and agent_no = @source_org
update all_rate_table set customer_no = @target_org 
where elt_account_number = @nElt_account_number and customer_no = @source_org
-- 'bill'
update bill set vendor_number = @target_org, vendor_name=@target_org_name  
where elt_account_number = @nElt_account_number and isnull(vendor_number,0) = @source_org
-- 'bill_detail'
update bill_detail set vendor_number = @target_org 
where elt_account_number = @nElt_account_number and isnull(vendor_number,0) = @source_org
-- 'cargo_tracking'
update cargo_tracking set shipper_acct = @target_org,shipper_name=@target_org_name 
where elt_account_number = @nElt_account_number and isnull(shipper_acct,0) = @source_org
update cargo_tracking set consignee_acct = @target_org,consignee_name=@target_org_name 
where elt_account_number = @nElt_account_number and isnull(consignee_acct,0) = @source_org
-- 'certificate_origin_air'
update certificate_origin_air set shipper_acct_num = @target_org,shipper_name=@target_org_name 
where elt_account_number = @nElt_account_number and isnull(shipper_acct_num,0) = @source_org
update certificate_origin_air set consignee_acct_num = @target_org,consignee_name=@target_org_name 
where elt_account_number = @nElt_account_number and isnull(consignee_acct_num,0) = @source_org
update certificate_origin_air set agent_acct_num = @target_org,agent_name=@target_org_name 
where elt_account_number = @nElt_account_number and isnull(agent_acct_num,0) = @source_org
update certificate_origin_air set notify_acct_num = @target_org,notify_name=@target_org_name 
where elt_account_number = @nElt_account_number and isnull(notify_acct_num,0) = @source_org
-- 'certificate_origin_ocean'
update certificate_origin_ocean set shipper_acct_num = @target_org,shipper_name=@target_org_name 
where elt_account_number = @nElt_account_number and isnull(shipper_acct_num,0) = @source_org
update certificate_origin_ocean set consignee_acct_num = @target_org,consignee_name=@target_org_name 
where elt_account_number = @nElt_account_number and isnull(consignee_acct_num,0) = @source_org
update certificate_origin_ocean set agent_acct_num = @target_org,agent_name=@target_org_name 
where elt_account_number = @nElt_account_number and isnull(agent_acct_num,0) = @source_org
update certificate_origin_ocean set notify_acct_num = @target_org,notify_name=@target_org_name 
where elt_account_number = @nElt_account_number and isnull(notify_acct_num,0) = @source_org
-- 'check_queue'
update check_queue set vendor_number = @target_org,vendor_name = @target_org_name 
where elt_account_number = @nElt_account_number and isnull(vendor_number,0) = @source_org
-- 'colo'
update colo set colodee_org_num = @target_org 
where colodee_elt_acct = @nElt_account_number and isnull(colodee_org_num,0) = @source_org
-- 'customer_balance'
ALTER TABLE customer_balance ALTER COLUMN customer_name [nvarchar] (128) NULL
update customer_balance set customer_acct = @target_org, customer_name = @target_org_name  
where elt_account_number = @nElt_account_number and isnull(customer_acct,0) = @source_org
-- 'customer_credits'
ALTER TABLE customer_credits ALTER COLUMN customer_name [nvarchar] (128) NULL
if exists (select * from customer_credits where elt_account_number = @nElt_account_number and isnull(customer_no,0) = @source_org)
begin
update customer_credits set credit = credit + (select credit from customer_credits where elt_account_number = @nElt_account_number and isnull(customer_no,0) = @source_org)
delete from customer_credits where elt_account_number = @nElt_account_number and isnull(customer_no,0) = @source_org
end
else
update customer_credits set customer_no = @target_org, customer_name = @target_org_name where elt_account_number = @nElt_account_number and isnull(customer_no,0) = @source_org
-- 'customer_payment'
update customer_payment set customer_number = @target_org, customer_name = @target_org_name  
where elt_account_number = @nElt_account_number and isnull(customer_number,0) = @source_org
-- 'delivery_order'
update delivery_order set shipper_acct = @target_org,shipper_name=@target_org_name 
where elt_account_number = @nElt_account_number and isnull(shipper_acct,0) = @source_org
update delivery_order set consignee_acct = @target_org,consignee_name=@target_org_name 
where elt_account_number = @nElt_account_number and isnull(consignee_acct,0) = @source_org
-- 'email_history'
update email_history set to_org_id = @target_org,to_org_name=@target_org_name 
where elt_account_number = @nElt_account_number and isnull(to_org_id,0) = @source_org
-- 'email_report'
update email_report set company = @target_org 
where elt_account_number = @nElt_account_number and isnull(company,0) = @source_org
-- 'general_journal_entry'
update general_journal_entry set org_acct = @target_org 
where elt_account_number = @nElt_account_number and isnull(org_acct,0) = @source_org
-- 'HAWB_master'
update HAWB_master set airline_vendor_num = @target_org 
where elt_account_number = @nElt_account_number and isnull(airline_vendor_num,0) = @source_org
update HAWB_master set Agent_No = @target_org,Agent_Name=@target_org_name 
where elt_account_number = @nElt_account_number and isnull(Agent_No,0) = @source_org
update HAWB_master set Shipper_account_number = @target_org,Shipper_Name=@target_org_name 
where elt_account_number = @nElt_account_number and isnull(Shipper_account_number,'') = cast( @source_org as nvarchar )
update HAWB_master set Consignee_acct_num = @target_org,Consignee_Name=@target_org_name 
where elt_account_number = @nElt_account_number and isnull(Consignee_acct_num,'') = cast( @source_org as nvarchar )
update HAWB_master set Notify_no = @target_org 
where elt_account_number = @nElt_account_number and isnull(Notify_no,'') = cast( @source_org as nvarchar )
-- 'hbol_master'
update hbol_master set Agent_No = @target_org,Agent_Name=@target_org_name 
where elt_account_number = @nElt_account_number and isnull(Agent_No,0) = @source_org
update hbol_master set forward_agent_acct_num = @target_org,forward_agent_name=@target_org_name 
where elt_account_number = @nElt_account_number and isnull(forward_agent_acct_num,0) = @source_org
update hbol_master set Shipper_acct_num = @target_org,Shipper_Name=@target_org_name 
where elt_account_number = @nElt_account_number and isnull(Shipper_acct_num,0) = @source_org
update hbol_master set Consignee_acct_num = @target_org,Consignee_Name=@target_org_name 
where elt_account_number = @nElt_account_number and isnull(Consignee_acct_num,0) = @source_org
update hbol_master set Notify_acct_num = @target_org,Notify_Name=@target_org_name 
where elt_account_number = @nElt_account_number and isnull(Notify_acct_num,0) = @source_org
-- 'ig_org_comments'
update ig_org_comments set org_account_number = @target_org 
where elt_account_number = @nElt_account_number and isnull(org_account_number,0) = @source_org
-- 'ig_org_contact'
update ig_org_contact set org_account_number = @target_org 
where elt_account_number = @nElt_account_number and isnull(org_account_number,0) = @source_org
-- 'ig_schedule_b'
update ig_schedule_b set org_account_number = @target_org 
where elt_account_number = @nElt_account_number and isnull(org_account_number,0) = @source_org
-- 'import_hawb'
update import_hawb set agent_org_acct = @target_org 
where elt_account_number = @nElt_account_number and isnull(agent_org_acct,0) = @source_org
update import_hawb set shipper_acct = @target_org,shipper_name=@target_org_name  
where elt_account_number = @nElt_account_number and isnull(shipper_acct,0) = @source_org
update import_hawb set consignee_acct = @target_org,consignee_name=@target_org_name  
where elt_account_number = @nElt_account_number and isnull(consignee_acct,0) = @source_org
update import_hawb set notify_acct = @target_org,notify_name=@target_org_name  
where elt_account_number = @nElt_account_number and isnull(notify_acct,0) = @source_org
update import_hawb set broker_acct = @target_org,broker_name=@target_org_name  
where elt_account_number = @nElt_account_number and isnull(broker_acct,0) = @source_org
-- 'import_mawb'
update import_mawb set agent_org_acct = @target_org 
where elt_account_number = @nElt_account_number and isnull(agent_org_acct,0) = @source_org
-- 'invoice'
update invoice set Customer_Number = @target_org,Customer_Name=@target_org_name  
where elt_account_number = @nElt_account_number and isnull(Customer_Number,0) = @source_org
-- 'invoice_cost_item'
update invoice_cost_item set vendor_no = @target_org 
where elt_account_number = @nElt_account_number and isnull(vendor_no,0) = @source_org
-- 'invoice_detail'
update invoice_detail set vendor_no = @target_org 
where elt_account_number = @nElt_account_number and isnull(vendor_no,0) = @source_org
-- 'MAWB_MASTER'
update MAWB_MASTER set airline_vendor_num = @target_org 
where elt_account_number = @nElt_account_number and isnull(airline_vendor_num,0) = @source_org
update MAWB_MASTER set master_agent = @target_org 
where elt_account_number = @nElt_account_number and isnull(master_agent,0) = @source_org
update MAWB_MASTER set Shipper_account_number = @target_org,Shipper_Name=@target_org_name 
where elt_account_number = @nElt_account_number and isnull(Shipper_account_number,'') = cast( @source_org as nvarchar )
update MAWB_MASTER set Consignee_acct_num = @target_org,Consignee_Name=@target_org_name 
where elt_account_number = @nElt_account_number and isnull(Consignee_acct_num,'') = cast( @source_org as nvarchar )
update MAWB_MASTER set Notify_no = @target_org 
where elt_account_number = @nElt_account_number and isnull(Notify_no,'') = cast( @source_org as nvarchar )
-- 'MAWB_Other_Charge'
update MAWB_Other_Charge set vendor_num = @target_org 
where elt_account_number = @nElt_account_number and isnull(vendor_num,0) = @source_org
-- 'mb_cost_item'
update mb_cost_item set vendor_no = @target_org 
where elt_account_number = @nElt_account_number and isnull(vendor_no,0) = @source_org
-- 'mbol_master'
update mbol_master set agent_acct_num = @target_org,Agent_Name=@target_org_name 
where elt_account_number = @nElt_account_number and isnull(agent_acct_num,0) = @source_org
update mbol_master set Shipper_acct_num = @target_org,Shipper_Name=@target_org_name 
where elt_account_number = @nElt_account_number and isnull(Shipper_acct_num,0) = @source_org
update mbol_master set Consignee_acct_num = @target_org,Consignee_Name=@target_org_name 
where elt_account_number = @nElt_account_number and isnull(Consignee_acct_num,0) = @source_org
update mbol_master set Notify_acct_num = @target_org,Notify_Name=@target_org_name 
where elt_account_number = @nElt_account_number and isnull(Notify_acct_num,0) = @source_org
-- 'mbol_other_charge'
update mbol_other_charge set vendor_num = @target_org 
where elt_account_number = @nElt_account_number and isnull(vendor_num,0) =  @source_org 
-- 'sed_master'
update ocean_sed_master set shipper_acct = @target_org 
where elt_account_number = @nElt_account_number and isnull(shipper_acct,0) = @source_org
update sed_master set shipper_acct = @target_org 
where elt_account_number = @nElt_account_number and isnull(shipper_acct,0) = @source_org
-- 'pickup_order'
update pickup_order set Shipper_account_number = @target_org,Shipper_Name=@target_org_name 
where elt_account_number = @nElt_account_number and isnull(Shipper_account_number,0) = @source_org
update pickup_order set pickup_account_number = @target_org,pickup_Name=@target_org_name 
where elt_account_number = @nElt_account_number and isnull(pickup_account_number,0) = @source_org
-- 'users'
update users set org_acct = @target_org 
where elt_account_number = @nElt_account_number and isnull(org_acct,0) = @source_org