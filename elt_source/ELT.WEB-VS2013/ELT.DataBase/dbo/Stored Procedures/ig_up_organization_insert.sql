
/****** Object:  Stored Procedure dbo.ig_up_organization_insert    Script Date: 7/31/2008 11:07:36 AM ******/

/****** Object:  Stored Procedure dbo.ig_up_organization_insert    Script Date: 5/5/2008 2:56:02 PM ******/

/****** Object:  Stored Procedure dbo.ig_up_organization_insert    Script Date: 5/5/2008 2:47:35 PM ******/

/****** Object:  Stored Procedure dbo.ig_up_organization_insert    Script Date: 5/5/2008 2:24:39 PM ******/

/****** Object:  Stored Procedure dbo.ig_up_organization_insert    Script Date: 5/13/2006 10:39:02 PM ******/

CREATE PROCEDURE dbo.ig_up_organization_insert
(
	@elt_account_number numeric(8),
	@org_account_number numeric(7),
	@acct_name nvarchar(16),
	@dba_name nvarchar(128),
	@class_code nchar(1),
	@date_opened datetime,
	@last_update datetime,
	@business_legal_name nvarchar(128),
	@business_fed_taxid nvarchar(16),
	@business_st_taxid nvarchar(16),
	@business_address nvarchar(128),
	@business_city nvarchar(32),
	@business_state nvarchar(2),
	@business_zip nvarchar(10),
	@business_country nvarchar(16),
	@b_country_code nvarchar(2),
	@business_phone nvarchar(32),
	@business_fax nvarchar(32),
	@business_url nvarchar(64),
	@owner_ssn nvarchar(9),
	@owner_lname nvarchar(32),
	@owner_fname nvarchar(32),
	@owner_mname nvarchar(32),
	@owner_mail_address nvarchar(128),
	@owner_mail_city nvarchar(32),
	@owner_mail_state nvarchar(2),
	@owner_mail_zip nvarchar(10),
	@owner_mail_country nvarchar(16),
	@owner_phone nvarchar(32),
	@owner_email nvarchar(64),
	@attn_name nvarchar(64),
	@notify_name nvarchar(64),
	@is_shipper nchar(1),
	@is_consignee nchar(1),
	@broker_info nvarchar(256),
	@is_agent nchar(1),
	@agent_elt_acct nchar(8),
	@edt nchar(1),
	@is_vendor nchar(1),
	@is_carrier nchar(1),
	@iata_code nvarchar(16),
	@carrier_code nvarchar(16),
	@carrier_id nvarchar(16),
	@carrier_type nchar(1),
	@account_status nvarchar(1),
	@comment nvarchar(512),
	@credit_amt numeric(12,2),
	@bill_term int,
	@is_coloader nchar(1),
	@coloader_elt_acct numeric(8),
	@z_is_trucker nchar(1),
	@z_is_special nchar(1),
	@z_is_broker nchar(1),
	@z_is_warehousing nchar(1),
	@z_is_cfs nchar(1),
	@z_is_govt nchar(1),
	@z_bond_number numeric(18),
	@z_bond_exp_date datetime,
	@z_bond_amount numeric(18),
	@z_bond_surety nchar(30),
	@z_bank_name nchar(50),
	@z_bank_account_no nchar(20),
	@z_chl_no nchar(30),
	@z_firm_code nchar(20),
	@z_carrier_code nchar(20),
	@z_carrier_prefix nchar(10)
)
AS
	SET NOCOUNT OFF;
INSERT INTO organization(elt_account_number, org_account_number, acct_name, dba_name, class_code, date_opened, last_update, business_legal_name, business_fed_taxid, business_st_taxid, business_address, business_city, business_state, business_zip, business_country, b_country_code, business_phone, business_fax, business_url, owner_ssn, owner_lname, owner_fname, owner_mname, owner_mail_address, owner_mail_city, owner_mail_state, owner_mail_zip, owner_mail_country, owner_phone, owner_email, attn_name, notify_name, is_shipper, is_consignee, broker_info, is_agent, agent_elt_acct, edt, is_vendor, is_carrier, iata_code, carrier_code, carrier_id, carrier_type, account_status, comment, credit_amt, bill_term, is_coloader, coloader_elt_acct, z_is_trucker, z_is_special, z_is_broker, z_is_warehousing, z_is_cfs, z_is_govt, z_bond_number, z_bond_exp_date, z_bond_amount, z_bond_surety, z_bank_name, z_bank_account_no, z_chl_no, z_firm_code, z_carrier_code, z_carrier_prefix) VALUES (@elt_account_number, @org_account_number, @acct_name, @dba_name, @class_code, @date_opened, @last_update, @business_legal_name, @business_fed_taxid, @business_st_taxid, @business_address, @business_city, @business_state, @business_zip, @business_country, @b_country_code, @business_phone, @business_fax, @business_url, @owner_ssn, @owner_lname, @owner_fname, @owner_mname, @owner_mail_address, @owner_mail_city, @owner_mail_state, @owner_mail_zip, @owner_mail_country, @owner_phone, @owner_email, @attn_name, @notify_name, @is_shipper, @is_consignee, @broker_info, @is_agent, @agent_elt_acct, @edt, @is_vendor, @is_carrier, @iata_code, @carrier_code, @carrier_id, @carrier_type, @account_status, @comment, @credit_amt, @bill_term, @is_coloader, @coloader_elt_acct, @z_is_trucker, @z_is_special, @z_is_broker, @z_is_warehousing, @z_is_cfs, @z_is_govt, @z_bond_number, @z_bond_exp_date, @z_bond_amount, @z_bond_surety, @z_bank_name, @z_bank_account_no, @z_chl_no, @z_firm_code, @z_carrier_code, @z_carrier_prefix);
	SELECT elt_account_number, org_account_number, acct_name, dba_name, class_code, date_opened, last_update, business_legal_name, business_fed_taxid, business_st_taxid, business_address, business_city, business_state, business_zip, business_country, b_country_code, business_phone, business_fax, business_url, owner_ssn, owner_lname, owner_fname, owner_mname, owner_mail_address, owner_mail_city, owner_mail_state, owner_mail_zip, owner_mail_country, owner_phone, owner_email, attn_name, notify_name, is_shipper, is_consignee, broker_info, is_agent, agent_elt_acct, edt, is_vendor, is_carrier, iata_code, carrier_code, carrier_id, carrier_type, account_status, comment, credit_amt, bill_term, is_coloader, coloader_elt_acct, z_is_trucker, z_is_special, z_is_broker, z_is_warehousing, z_is_cfs, z_is_govt, z_bond_number, z_bond_exp_date, z_bond_amount, z_bond_surety, z_bank_name, z_bank_account_no, z_chl_no, z_firm_code, z_carrier_code, z_carrier_prefix FROM organization WHERE (elt_account_number = @elt_account_number) AND (org_account_number = @org_account_number)



