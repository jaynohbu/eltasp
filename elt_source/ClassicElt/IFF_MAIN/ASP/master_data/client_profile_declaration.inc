<%
'//////////////////////
'// Common
'//////////////////////
Dim v_dba_name				'txt_dba_name				'dba_name				vchar(128)
Dim v_class_code			'txt_class_code				'class_code				char(20)
Dim v_org_account_number	'txt_org_account_number		'org_account_number		decimal
Dim v_isFrequently			'txt_isFrequently			'isFrequently			char(1)
Dim v_account_status		'txt_account_status			'account_status			char(1)
Dim v_comment				'txt_comment				'comment			vchar(512)

'//////////////////////
'// General Information
'//////////////////////
Dim v_owner_fname			'txt_owner_fname			'owner_fname			vchar(32)
Dim v_owner_mname			'txt_owner_mname			'owner_mname			vchar(32)
Dim v_owner_lname			'txt_owner_lname			'owner_lname			vchar(32)
Dim v_owner_title			'txt_owner_title			'owner_title			vchar(128) 	
Dim v_owner_departm			'txt_owner_departm			'owner_departm			vchar(128) 	
Dim v_business_phone		'txt_business_phone			'business_phone			vchar(32) 
Dim v_business_phone_ext	'txt_business_phone_ext		'business_phone_ext		vchar(16)  
Dim v_business_phone_mask	'txt_business_phone_mask		'business_phone_mask		char(2)  
Dim v_business_phone_mask_exp'txt_business_phone_mask_exp		'business_phone_mask_exp		char(50)  
Dim v_business_phone_mask_pre'txt_business_phone_mask_pre		'business_phone_mask_pre		char(10)  
Dim v_business_phone2		'txt_business_phone2		'business_phone2		vchar(32)  
Dim v_business_phone2_ext	'txt_business_phone2_ext	'business_phone2_ext	vchar(16)  
Dim v_business_phone2_mask	'txt_business_phone2_mask		'business_phone2_mask		char(2)  
Dim v_business_phone2_mask_exp'txt_business_phone2_mask_exp		'business_phone2_mask_exp		char(50)  
Dim v_business_phone2_mask_pre'txt_business_phone2_mask_pre		'business_phone2_mask_pre		char(10)  
Dim v_owner_phone			'txt_owner_phone			'owner_phone			vchar(32)
Dim v_owner_phone_mask		'txt_owner_phone_mask			'owner_phone_mask			char(2)
Dim v_owner_phone_mask_exp	'txt_owner_phone_mask_exp			'owner_phone_mask_exp			char(50)
Dim v_owner_phone_mask_pre	'txt_owner_phone_mask_pre			'owner_phone_mask_pre			char(10)
Dim v_business_fax			'txt_business_fax			'business_fax			vchar(32)
Dim v_business_fax_mask		'txt_business_fax_mask			'business_fax_mask			char(2)
Dim v_business_fax_mask_exp	'txt_business_fax_mask_exp			'business_fax_mask_exp			char(50)
Dim v_business_fax_mask_pre	'txt_business_fax_mask_pre			'business_fax_mask_pre			char(10)
Dim v_owner_email			'txt_owner_email			'owner_email			vchar(64)
Dim v_business_url			'txt_business_url			'business_url			vchar(64)
Dim v_web_login_id			'txt_web_login_id			'web_login_id			vchar(32)
Dim v_web_login_pin			'txt_web_login_pin			'web_login_pin			vchar(32)
Dim v_business_address		'txt_business_address		'business_address		vchar(128)			
Dim v_business_address2		'txt_business_address2		'business_address2		vchar(128)	
'Dim v_business_address3		'txt_business_address3		'business_address3		vchar(128)	
Dim v_business_city			'txt_business_city			'business_city			vchar(32)
Dim v_business_state		'txt_business_state			'business_state			vchar(32)
Dim v_b_country_code		'txt_b_country_code			'b_country_code			vchar(2)
Dim v_b_country_codeName	'txt_business_country		'business_country		vchar(64)
Dim v_business_zip			'txt_business_zip			'business_zip			vchar(32)
Dim v_business_legal_name	'txt_business_legal_name	'business_legal_name	vchar(128)
Dim v_business_fed_taxid	'txt_business_fed_taxid		'business_fed_taxid		vchar(16)	
	
'/////////////////////
'// Additional Contact
'/////////////////////
Dim v_c2FirstName		'txt_c2FirstName		'c2FirstName			vchar(32)
Dim v_c2MiddleName		'txt_c2MiddleName		'c2MiddleName			vchar(32)
Dim v_c2LastName		'txt_c2LastName			'c2LastName				vchar(32)
Dim v_c2Title			'txt_c2Title			'c2Title				vchar(128)
Dim v_c2Phone			'txt_c2Phone			'c2Phone				vchar(32)
Dim v_c2Ext				'txt_c2Ext				'c2Ext					vchar(16)
Dim v_c2Phone_mask		'txt_c2Phone_mask			'c2Phone_mask				char(2)
Dim v_c2Phone_mask_exp		'txt_c2Phone_mask_exp			'c2Phone_mask_exp				char(50)
Dim v_c2Phone_mask_pre		'txt_c2Phone_mask_pre			'c2Phone_mask_pre				char(10)
Dim v_c2Cell			'txt_c2Cell				'c2Cell					vchar(32)
Dim v_c2Cell_mask		'txt_c2Cell_mask				'c2Cell_mask					char(2)
Dim v_c2Cell_mask_exp		'txt_c2Cell_mask_exp				'c2Cell_mask_exp					char(50)
Dim v_c2Cell_mask_pre		'txt_c2Cell_mask_pre				'c2Cell_mask_pre					char(10)
Dim v_c2Fax				'txt_c2Fax				'c2Fax					vchar(32)
Dim v_c2Fax_mask		'txt_c2Fax_mask				'c2Fax_mask					char(2)
Dim v_c2Fax_mask_exp		'txt_c2Fax_mask_exp				'c2Fax_mask_exp					char(50)
Dim v_c2Fax_mask_pre		'txt_c2Fax_mask_pre				'c2Fax_mask_pre					char(10)
Dim v_c2Email			'txt_c2Email			'c2Email				vchar(64)
Dim v_c3FirstName		'txt_c3FirstName		'c3FirstName			vchar(32)  
Dim v_c3MiddleName		'txt_c3MiddleName		'c3MiddleName			vchar(32)  
Dim v_c3LastName		'txt_c3LastName			'c3LastName				vchar(32)  
Dim v_c3Title			'txt_c3Title			'c3Title				vchar(128) 
Dim v_c3Phone			'txt_c3Phone			'c3Phone				vchar(32)  
Dim v_c3Ext				'txt_c3Ext				'c3Ext					vchar(16)  
Dim v_c3Phone_mask		'txt_c3Phone_mask			'c3Phone_mask				char(2)
Dim v_c3Phone_mask_exp		'txt_c3Phone_mask_exp			'c3Phone_mask_exp				char(50)
Dim v_c3Phone_mask_pre		'txt_c3Phone_mask_pre			'c3Phone_mask_pre				char(10)
Dim v_c3Cell			'txt_c3Cell				'c3Cell					vchar(32)  
Dim v_c3Cell_mask		'txt_c3Cell_mask				'c3Cell_mask					char(2)  
Dim v_c3Cell_mask_exp		'txt_c3Cell_mask_exp				'c3Cell_mask_exp					char(50)  
Dim v_c3Cell_mask_pre		'txt_c3Cell_mask_pre				'c3Cell_mask_pre					char(10)  
Dim v_c3Fax				'txt_c3Fax				'c3Fax					vchar(32)  
Dim v_c3Fax_mask		'txt_c3Fax_mask				'c3Fax_mask					char(2)  
Dim v_c3Fax_mask_exp		'txt_c3Fax_mask_exp				'c3Fax_mask_exp					char(50)  
Dim v_c3Fax_mask_pre		'txt_c3Fax_mask_pre				'c3Fax_mask_pre					char(10)  
Dim v_c3Email			'txt_c3Email			'c3Email				vchar(64)  

'///////////////////////
'// Business Information
'///////////////////////
Dim v_is_consignee		'txt_is_consignee			'is_consignee			char(1)
Dim v_is_shipper		'txt_is_shipper				'is_shipper				char(1)
Dim v_is_agent			'txt_is_agent				'is_agent				char(1)
Dim v_is_carrier		'txt_is_carrier				'is_carrier				char(1)
Dim v_z_is_trucker		'txt_z_is_trucker			'z_is_trucker			char(1)
Dim v_z_is_warehousing	'txt_z_is_warehousing		'z_is_warehousing		char(1)	
Dim v_z_is_cfs			'txt_z_is_cfs				'z_is_cfs				char(1)
Dim v_z_is_broker		'txt_z_is_broker			'z_is_broker			char(1)
Dim v_z_is_govt			'txt_z_is_govt				'z_is_govt				char(1)
Dim v_is_vendor			'txt_is_vendor				'is_vendor				char(1)
Dim v_is_customer		'txt_is_customer			'is_customer			char(1)
Dim v_z_is_special		'txt_z_is_special			'z_is_special			char(1)
Dim v_SubConsignee		'txt_SubConsignee			'SubConsignee			vchar(32)
Dim v_SubShipper		'txt_SubShipper				'SubShipper				vchar(32)
Dim v_SubAgent			'txt_SubAgent				'SubAgent				vchar(32)
Dim v_SubCarrier		'txt_SubCarrier				'SubCarrier				vchar(32)
Dim v_SubTrucker		'txt_SubTrucker				'SubTrucker				vchar(32)
Dim v_SubWarehousing	'txt_SubWarehousing			'SubWarehousing			vchar(32)
Dim v_SubCFS			'txt_SubCFS					'SubCFS					vchar(32)
Dim v_SubBroker			'txt_SubBroker				'SubBroker				vchar(32)
Dim v_SubGovt			'txt_SubGovt				'SubGovt				vchar(32)
Dim v_SubVendor			'txt_SubVendor				'SubVendor				vchar(32)
Dim v_SubCustomer		'txt_SubCustomer			'SubCustomer			vchar(32)
Dim v_SubSpecial		'txt_SubSpecial				'SubSpecial				vchar(32)
Dim v_defaultBroker		'txt_DefaultBroker			'DefaultBroker decimal	// org_account_number
Dim v_defaultBrokerName	'txt_DefaultBrokerName		'text					// dba_name
Dim v_broker_info		'txt_broker_info			'broker_info			vchar(256)
Dim v_carrier_id		'txt_carrier_id				'carrier_id				vchar(16)  
Dim v_carrier_type		'txt_carrier_type			'carrier_type				char(1)  
Dim vAirLineCode		'							'carrier_id				vchar(16)  /*  z_carrier_code ( to be deleted )
Dim v_carrier_code		'txt_carrier_code			'carrier_code			vchar(16)  /*  z_carrier_prefix ( to be deleted ), iata_code ( to be deleted )
Dim v_z_chl_no			'txt_z_chl_no				'z_chl_no				vchar(30)	
Dim v_z_firm_code		'txt_z_firm_code			'z_firm_code 			vchar(30)

'//////////////////////
'// Billing Information
'//////////////////////
Dim v_owner_mail_address		'txt_owner_mail_address		'owner_mail_address		vchar(128)
Dim v_owner_mail_address2		'txt_owner_mail_address2	'owner_mail_address2	vchar(128)
'Dim v_owner_mail_address3		'txt_owner_mail_address3	'owner_mail_address3	vchar(128)
Dim v_owner_mail_city			'txt_owner_mail_city		'owner_mail_city		vchar(32)
Dim v_owner_mail_state			'txt_owner_mail_state		'owner_mail_state		vchar(32)
Dim v_owner_mail_zip			'txt_owner_mail_zip			'owner_mail_zip			vchar(32)
Dim v_owner_mail_country		'txt_owner_mail_country		'owner_mail_country		vchar(64)
Dim v_bill_term					'txt_bill_term				'bill_term				int(4)
Dim v_z_attn_txt				'txt_z_attn_txt				'z_attn_txt				vchar(64)
Dim v_credit_amt				'txt_credit_amt				'credit_amt				decimal
Dim v_z_bank_name				'txt_z_bank_name			'z_bank_name			vchar(50)
Dim v_z_bank_account_no			'txt_z_bank_account_no		'z_bank_account_no		char(20)

'/////////////////////////
'// Managerial Information
'/////////////////////////
Dim v_agent_elt_acct		'txt_agent_elt_acct			'agent_elt_acct			char(8)
Dim v_refferedBy			'txt_refferedBy				'refferedBy				vchar(64)
Dim v_coloader_elt_acct		'txt_coloader_elt_acct		'coloader_elt_acct		decimal
Dim v_coloader_elt_acct_name	'txt_coloader_elt_acct_name	'text
Dim v_is_coloader			'txt_is_coloader				'is_coloader				char(1)
Dim v_edt					'txt_edt					'edt					char(1)
Dim v_salesperson			'txt_salesperson			'salesperson			vchar(64)
Dim v_print_check_as		'txt_print_check_as			'print_check_as			vchar(128)
Dim v_print_check_as_info		'txt_print_check_as_info			'print_check_as_info			vchar(512)
DIM v_known_shipper			'chk_known_shipper			'known_shipper			char(1)
Dim v_ICC_MC				'txt_ICC_MC					'ICC_MC					vchar(64)
Dim v_FF_account			'txt_FF_account				'FF_account_no          vchar(64)
'//////////////////////
%>