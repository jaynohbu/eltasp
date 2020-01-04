
/****** Object:  Stored Procedure dbo.ig_up_organization_select    Script Date: 7/31/2008 11:07:36 AM ******/

/****** Object:  Stored Procedure dbo.ig_up_organization_select    Script Date: 5/5/2008 2:56:02 PM ******/

/****** Object:  Stored Procedure dbo.ig_up_organization_select    Script Date: 5/5/2008 2:47:35 PM ******/

/****** Object:  Stored Procedure dbo.ig_up_organization_select    Script Date: 5/5/2008 2:24:39 PM ******/

/****** Object:  Stored Procedure dbo.ig_up_organization_select    Script Date: 5/13/2006 10:39:02 PM ******/

CREATE PROCEDURE dbo.ig_up_organization_select
AS
	SET NOCOUNT ON;
SELECT elt_account_number, org_account_number, acct_name, dba_name, class_code, date_opened, last_update, business_legal_name, business_fed_taxid, business_st_taxid, business_address, business_city, business_state, business_zip, business_country, b_country_code, business_phone, business_fax, business_url, owner_ssn, owner_lname, owner_fname, owner_mname, owner_mail_address, owner_mail_city, owner_mail_state, owner_mail_zip, owner_mail_country, owner_phone, owner_email, attn_name, notify_name, is_shipper, is_consignee, broker_info, is_agent, agent_elt_acct, edt, is_vendor, is_carrier, iata_code, carrier_code, carrier_id, carrier_type, account_status, comment, credit_amt, bill_term, is_coloader, coloader_elt_acct, z_is_trucker, z_is_special, z_is_broker, z_is_warehousing, z_is_cfs, z_is_govt, z_bond_number, z_bond_exp_date, z_bond_amount, z_bond_surety, z_bank_name, z_bank_account_no, z_chl_no, z_firm_code, z_carrier_code, z_carrier_prefix FROM organization



