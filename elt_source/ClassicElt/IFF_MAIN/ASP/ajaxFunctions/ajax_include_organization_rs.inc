<%
			rs("elt_account_number") =      elt_account_number		                        
			rs("dba_name") =                v_dba_name		                        
			rs("class_code") = 				v_class_code		                       
			rs("org_account_number") = 	    v_org_account_number	                       
			rs("isFrequently") = 			v_isFrequently		               
			rs("account_status") = 			v_account_status	                       
			rs("comment") = 				v_comment		                       
			'//////////////////////			    '//////////////////////                        
			'// General Information			    '// General Information                        
			'//////////////////////			    '//////////////////////                        
			rs("owner_fname") = 		    v_owner_fname		                       
			rs("owner_mname") = 		    v_owner_mname		                       
			rs("owner_lname") = 		    v_owner_lname		                       
			rs("owner_title") = 		    v_owner_title		                       
			rs("owner_departm") = 		v_owner_departm		               
			rs("business_phone") = 	    v_business_phone	
			rs("business_phone_ext") = 	    v_business_phone_ext	                       
			rs("business_phone_mask") = 	    v_business_phone_mask	                       
			rs("business_phone_mask_exp") = 	    v_business_phone_mask_exp	                       
			rs("business_phone_mask_pre") = 	    v_business_phone_mask_pre
			rs("business_phone2") = 	    v_business_phone2	                       
			rs("business_phone2_ext") = 	    v_business_phone2_ext	                       
			rs("business_phone2_mask") = 	v_business_phone2_mask	               
			rs("business_phone2_mask_exp") = 	v_business_phone2_mask_exp	               
			rs("business_phone2_mask_pre") = 	v_business_phone2_mask_pre
			rs("owner_phone") = 		    v_owner_phone		                       
			rs("owner_phone_mask") = 	    v_owner_phone_mask	                       
			rs("owner_phone_mask_exp") = 	    v_owner_phone_mask_exp	                       
			rs("owner_phone_mask_pre") = 	    v_owner_phone_mask_pre
			rs("business_fax") = 		v_business_fax		               
			rs("business_fax_mask") = 	    v_business_fax_mask	                       
			rs("business_fax_mask_exp") = 	    v_business_fax_mask_exp	                       
			rs("business_fax_mask_pre") = 	    v_business_fax_mask_pre
			rs("owner_email") = 		    v_owner_email		                       
			rs("business_url") = 		v_business_url		               
			rs("web_login_id") = 		v_web_login_id		               
			rs("web_login_pin") = 		v_web_login_pin		               
			rs("business_address") = 	    v_business_address	                       
			rs("business_address2") = 	    v_business_address2	                       
			rs("business_city") = 		v_business_city		               
			rs("business_state") = 	    v_business_state	                       
			'// rs("b_country_code") = 	    v_b_country_code
            rs("b_country_code") = 	    GetSQLResult("SELECT country_code FROM country_code WHERE country_name='" & Trim(v_b_country_codeName) & "' AND elt_account_number=" & elt_account_number, Null)
			rs("business_country") = 	    v_b_country_codeName	                       
			rs("business_zip") = 		v_business_zip		               
			rs("business_legal_name") = 	    v_business_legal_name	                       
			rs("business_fed_taxid") = 	    v_business_fed_taxid	                       
			'/////////////////////			    '/////////////////////                         
			'// Additional Contact			    '// Additional Contact                         
			'/////////////////////			    '/////////////////////                          
			rs("c2FirstName") = 		    v_c2FirstName		                       
			rs("c2MiddleName") = 		v_c2MiddleName		               
			rs("c2LastName") = 		    v_c2LastName		                       
			rs("c2Title") = 		    v_c2Title		                       
			rs("c2Phone") = 		    v_c2Phone		                       
			rs("c2Ext") = 			v_c2Ext			               
			rs("c2Phone_mask") = 		v_c2Phone_mask		               
			rs("c2Phone_mask_exp") = 		v_c2Phone_mask_exp
			rs("c2Phone_mask_pre") = 		v_c2Phone_mask_pre
			rs("c2Cell") = 		    v_c2Cell		                       
			rs("c2Cell_mask") = 		    v_c2Cell_mask		                       
			rs("c2Cell_mask_exp") = 		    v_c2Cell_mask_exp
			rs("c2Cell_mask_pre") = 		    v_c2Cell_mask_pre
			rs("c2Fax") = 		    v_c2Fax			               
			rs("c2Fax_mask") = 		    v_c2Fax_mask		                       
			rs("c2Fax_mask_exp") = 		    v_c2Fax_mask_exp
			rs("c2Fax_mask_pre") = 		    v_c2Fax_mask_pre
			rs("c2Email") = 		    v_c2Email		                       
			rs("c3FirstName") = 		    v_c3FirstName		                       
			rs("c3MiddleName") = 	    v_c3MiddleName		               
			rs("c3LastName") = 		    v_c3LastName		                       
			rs("c3Title") = 		    v_c3Title		                       
			rs("c3Phone") = 		    v_c3Phone		                       
			rs("c3Ext") = 			v_c3Ext			               
			rs("c3Phone_mask") = 		v_c3Phone_mask		               
			rs("c3Phone_mask_exp") = 		v_c3Phone_mask_exp
			rs("c3Phone_mask_pre") = 		v_c3Phone_mask_pre
			rs("c3Cell") = 		    v_c3Cell		                       
			rs("c3Cell_mask") = 		    v_c3Cell_mask		                       
			rs("c3Cell_mask_exp") = 		    v_c3Cell_mask_exp
			rs("c3Cell_mask_pre") = 		    v_c3Cell_mask_pre
			rs("c3Fax") = 		    v_c3Fax			               
			rs("c3Fax_mask") = 		    v_c3Fax_mask		                       
			rs("c3Fax_mask_exp") = 		    v_c3Fax_mask_exp
			rs("c3Fax_mask_pre") = 		    v_c3Fax_mask_pre
			rs("c3Email") = 		    v_c3Email		                       
								                                                   
			'///////////////////////		    '///////////////////////                       
			'// Business Information		    '// Business Information                      
			'///////////////////////		    '///////////////////////                     
			rs("is_consignee") = 		v_is_consignee		               
			rs("is_shipper") = 		    v_is_shipper		                       
			rs("is_agent") = 		    v_is_agent		                       
			rs("is_carrier") = 		    v_is_carrier		                       
			rs("z_is_trucker") = 		v_z_is_trucker		               
			rs("z_is_warehousing") = 	    v_z_is_warehousing	                       
			rs("z_is_cfs") = 		    v_z_is_cfs		                       
			rs("z_is_broker") = 		    v_z_is_broker		                       
			rs("z_is_govt") = 		    v_z_is_govt		                       
			rs("is_vendor") = 		    v_is_vendor		
			rs("is_customer") = 		v_is_customer	                       
			rs("z_is_special") = 		v_z_is_special		               
			rs("SubConsignee") = 		v_SubConsignee		               
			rs("SubShipper") = 		    v_SubShipper		                       
			rs("SubAgent") = 		    v_SubAgent		                       
			rs("SubCarrier") = 		    v_SubCarrier		                       
			rs("SubTrucker") = 		    v_SubTrucker		                       
			rs("SubWarehousing") = 	    v_SubWarehousing	                       
			rs("SubCFS") = 		    v_SubCFS		                       
			rs("SubBroker") = 		    v_SubBroker		                       
			rs("SubGovt") = 		    v_SubGovt		                       
			rs("SubVendor") = 		    v_SubVendor
			rs("SubCustomer") = 		v_SubCustomer	                       
			rs("SubSpecial") = 		    v_SubSpecial		                       
			rs("defaultBroker") = 		v_defaultBroker		               
			rs("defaultBrokerName") = 	    v_defaultBrokerName	                       
			rs("broker_info") = 		    v_broker_info		                       
			rs("carrier_type") = 		v_carrier_type		               
			rs("carrier_code") = 		v_carrier_code	

			if trim(v_carrier_code) <> "" then
				rs("carrier_id") = 		    vAirLineCode		                       
			else
				rs("carrier_id") = 		    v_carrier_id		                       
			end if
			
			rs("z_chl_no") = 		    v_z_chl_no		                       
			rs("z_firm_code") = 		    v_z_firm_code		                       
								                                               
			'//////////////////////			    '//////////////////////                       
			'// Billing Information			    '// Billing Information                       
			'//////////////////////			    '//////////////////////                       
			rs("owner_mail_address") = 	    v_owner_mail_address	                       
			rs("owner_mail_address2") = 	    v_owner_mail_address2	                       
			rs("owner_mail_city") = 	    v_owner_mail_city	                       
			rs("owner_mail_state") = 	    v_owner_mail_state	                       
			rs("owner_mail_zip") = 	    v_owner_mail_zip	                       
			rs("owner_mail_country") = 	    v_owner_mail_country	   
			rs("bill_term") = 		    v_bill_term		                       
			rs("z_attn_txt") = 		    v_z_attn_txt		                       
			rs("credit_amt") = 		    v_credit_amt		                       
			rs("z_bank_name") = 		    v_z_bank_name		                       
			rs("z_bank_account_no") = 	    v_z_bank_account_no	                       
								                                            
			'///////////////////////		    '///////////////////////              
			'// Managerial Informati		    '// Managerial Informati                   
			'///////////////////////		    '///////////////////////      
			rs("agent_elt_acct") = 	    v_agent_elt_acct	
			rs("refferedBy") = 		    v_refferedBy		                       
			rs("coloader_elt_acct") = 	    v_coloader_elt_acct	                       
			rs("coloader_elt_acct_name") = 	v_coloader_elt_acct_name	               
			rs("is_coloader") = 		    v_is_coloader		                       
			rs("edt") = 			    v_edt			                     
			rs("SalesPerson") = 		    v_SalesPerson		                     
			rs("print_check_as") = 		    v_print_check_as		                     
			rs("print_check_as_info") = 		    v_print_check_as_info		                     
			rs("known_shipper") =			v_known_shipper
			rs("ICC_MC") =					v_ICC_MC	
			rs("FF_account_no") =			v_FF_account
			'//////////////////////			    '//////////////////////                       
%>