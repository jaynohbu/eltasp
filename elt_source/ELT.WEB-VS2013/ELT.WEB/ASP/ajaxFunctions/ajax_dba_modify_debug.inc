<%
	sub org_save_debug
			response.write "v_dba_name:"                & v_dba_name		   & chr(13)                      
			response.write "v_class_code:"		    & v_class_code		   & chr(13)                     
			response.write "v_org_account_number:"	    & v_org_account_number	   & chr(13)                     
			response.write "v_isFrequently:"		& v_isFrequently		& chr(13)                
			response.write "v_account_status:"	    & v_account_status	           & chr(13)             
			response.write "v_comment:"		    & v_comment		           & chr(13)             
			'//////////////////////			    '//////////////////////        & chr(13)                 
			'// General Information			    '// General Information        & chr(13)                 
			'//////////////////////			    '//////////////////////        & chr(13)                 
			response.write "v_owner_fname:"		    & v_owner_fname		   & chr(13)                     
			response.write "v_owner_mname:"		    & v_owner_mname		   & chr(13)                     
			response.write "v_owner_lname:"		    & v_owner_lname		   & chr(13)                     
			response.write "v_owner_title:"		    & v_owner_title		   & chr(13)                     
			response.write "v_owner_departm:"		& v_owner_departm		& chr(13)                
			response.write "v_business_phone:"	    & v_business_phone	           & chr(13)             
			response.write "v_business_phone_ext:"	    & v_business_phone_ext	   & chr(13)                     
			response.write "v_business_phone_mask:"	    & v_business_phone_mask	   & chr(13)                     
			response.write "v_business_phone2:"	    & v_business_phone2	           & chr(13)             
			response.write "v_business_phone2_ext:"	    & v_business_phone2_ext	   & chr(13)                     
			response.write "v_business_phone2_mask:"	& v_business_phone2_mask	& chr(13)                
			response.write "v_owner_phone:"		    & v_owner_phone		   & chr(13)                     
			response.write "v_owner_phone_mask:"	    & v_owner_phone_mask	   & chr(13)                     
			response.write "v_business_fax:"		& v_business_fax		& chr(13)                
			response.write "v_business_fax_mask:"	    & v_business_fax_mask	   & chr(13)                     
			response.write "v_owner_email:"		    & v_owner_email		   & chr(13)                     
			response.write "v_business_url:"		& v_business_url		& chr(13)                
			response.write "v_web_login_id:"		& v_web_login_id		& chr(13)                
			response.write "v_web_login_pin:"		& v_web_login_pin		& chr(13)                
			response.write "v_business_address:"	    & v_business_address	   & chr(13)                     
			response.write "v_business_address2:"	    & v_business_address2	   & chr(13)                     
			response.write "v_business_city:"		& v_business_city		& chr(13)                
			response.write "v_business_state:"	    & v_business_state	           & chr(13)             
			response.write "v_b_country_code:"	    & v_b_country_code	           & chr(13)             
			response.write "v_b_country_codeName:"	    & v_b_country_codeName	   & chr(13)                     
			response.write "v_business_zip:"		& v_business_zip		& chr(13)                
			response.write "v_business_legal_name:"	    & v_business_legal_name	   & chr(13)                     
			response.write "v_business_fed_taxid:"	    & v_business_fed_taxid	   & chr(13)                     
			'/////////////////////			    '/////////////////////                         
			'// Additional Contact			    '// Additional Contact                         
			'/////////////////////			    '/////////////////////                          
			response.write "v_c2FirstName:"		    & v_c2FirstName		   & chr(13)                     
			response.write "v_c2MiddleName:"		& v_c2MiddleName		& chr(13)                
			response.write "v_c2LastName:"		    & v_c2LastName		   & chr(13)                     
			response.write "v_c2Title:"		    & v_c2Title		           & chr(13)             
			response.write "v_c2Phone:"		    & v_c2Phone		           & chr(13)             
			response.write "v_c2Ext:"			& v_c2Ext			& chr(13)                
			response.write "v_c2Phone_mask:"		& v_c2Phone_mask		& chr(13)                
			response.write "v_c2Cell:"		    & v_c2Cell		           & chr(13)             
			response.write "v_c2Cell_mask:"		    & v_c2Cell_mask		   & chr(13)                     
			response.write "v_c2Fax	:"		    & v_c2Fax			   & chr(13)             
			response.write "v_c2Fax_mask:"		    & v_c2Fax_mask		   & chr(13)                     
			response.write "v_c2Email:"		    & v_c2Email		           & chr(13)             
			response.write "v_c3FirstName:"		    & v_c3FirstName		   & chr(13)                     
			response.write "v_c3MiddleName:"	    & v_c3MiddleName		   & chr(13)             
			response.write "v_c3LastName:"		    & v_c3LastName		   & chr(13)                     
			response.write "v_c3Title:"		    & v_c3Title		           & chr(13)             
			response.write "v_c3Phone:"		    & v_c3Phone		           & chr(13)             
			response.write "v_c3Ext:"			& v_c3Ext			& chr(13)                
			response.write "v_c3Phone_mask:"		& v_c3Phone_mask		& chr(13)                
			response.write "v_c3Cell:"		    & v_c3Cell		           & chr(13)             
			response.write "v_c3Cell_mask:"		    & v_c3Cell_mask		   & chr(13)                     
			response.write "v_c3Fax:"		    & v_c3Fax			   & chr(13)             
			response.write "v_c3Fax_mask:"		    & v_c3Fax_mask		   & chr(13)                     
			response.write "v_c3Email:"		    & v_c3Email		           & chr(13)             
								                                                   
			'///////////////////////		    '///////////////////////                       
			'// Business Information		    '// Business Information                      
			'///////////////////////		    '///////////////////////                     
			response.write "v_is_consignee:"		& v_is_consignee		& chr(13)                
			response.write "v_is_shipper:"		    & v_is_shipper		   & chr(13)                     
			response.write "v_is_agent:"		    & v_is_agent		   & chr(13)                     
			response.write "v_is_carrier:"		    & v_is_carrier		   & chr(13)                     
			response.write "v_z_is_trucker:"		& v_z_is_trucker		& chr(13)                
			response.write "v_z_is_warehousing:"	    & v_z_is_warehousing	   & chr(13)                     
			response.write "v_z_is_cfs:"		    & v_z_is_cfs		   & chr(13)                     
			response.write "v_z_is_broker:"		    & v_z_is_broker		   & chr(13)                     
			response.write "v_z_is_govt:"		    & v_z_is_govt		   & chr(13)                     
			response.write "v_is_vendor:"		    & v_is_vendor		   & chr(13)
			response.write "v_is_customer:"		    & v_is_customer		   & chr(13)                     
			response.write "v_z_is_special:"		& v_z_is_special		& chr(13)                
			response.write "v_SubConsignee:"		& v_SubConsignee		& chr(13)                
			response.write "v_SubShipper:"		    & v_SubShipper		   & chr(13)                     
			response.write "v_SubAgent:"		    & v_SubAgent		   & chr(13)                     
			response.write "v_SubCarrier:"		    & v_SubCarrier		   & chr(13)                     
			response.write "v_SubTrucker:"		    & v_SubTrucker		   & chr(13)                     
			response.write "v_SubWarehousing:"	    & v_SubWarehousing	           & chr(13)             
			response.write "v_SubCFS:"		    & v_SubCFS		           & chr(13)             
			response.write "v_SubBroker:"		    & v_SubBroker		   & chr(13)                     
			response.write "v_SubGovt:"		    & v_SubGovt		           & chr(13)             
			response.write "v_SubVendor:"		    & v_SubVendor		   & chr(13)
			response.write "v_SubCustomer:"		    & v_SubCustomer		   & chr(13)                     
			response.write "v_SubSpecial:"		    & v_SubSpecial		   & chr(13)                     
			response.write "v_DefaultBroker:"		& v_DefaultBroker		& chr(13)                
			response.write "v_DefaultBrokerName:"	    & v_DefaultBrokerName	   & chr(13)                     
			response.write "v_broker_info:"		    & v_broker_info		   & chr(13)                     
			response.write "v_carrier_id:"		    & v_carrier_id		   & chr(13)                     
			response.write "v_carrier_type:"		& v_carrier_type		& chr(13)                
			response.write "v_carrier_code:"		& v_carrier_code		& chr(13)                
			response.write "v_z_chl_no:"		    & v_z_chl_no		   & chr(13)                     
			response.write "v_z_firm_code:"		    & v_z_firm_code		   & chr(13)                     
								                                               
			'//////////////////////			    '//////////////////////                       
			'// Billing Information			    '// Billing Information                       
			'//////////////////////			    '//////////////////////                       
			response.write "v_owner_mail_address:"	    & v_owner_mail_address	   & chr(13)                     
			response.write "v_owner_mail_address2:"	    & v_owner_mail_address2	   & chr(13)                     
			response.write "v_owner_mail_city:"	    & v_owner_mail_city	           & chr(13)             
			response.write "v_owner_mail_state:"	    & v_owner_mail_state	   & chr(13)                     
			response.write "v_owner_mail_zip:"	    & v_owner_mail_zip	           & chr(13)             
			response.write "v_owner_mail_country:"	    & v_owner_mail_country	   & chr(13)                     
			response.write "v_bill_term:"		    & v_bill_term		   & chr(13)                     
			response.write "v_z_attn_txt:"		    & v_z_attn_txt		   & chr(13)                     
			response.write "v_credit_amt:"		    & v_credit_amt		   & chr(13)                     
			response.write "v_z_bank_name:"		    & v_z_bank_name		   & chr(13)                     
			response.write "v_z_bank_account_no:"	    & v_z_bank_account_no	   & chr(13)                     
								                                            
			'///////////////////////		    '///////////////////////              
			'// Managerial Informati		    '// Managerial Informati                   
			'///////////////////////		    '///////////////////////      
			response.write "v_agent_elt_acct:"	    & v_agent_elt_acct	           & chr(13)             
			response.write "v_refferedBy:"		    & v_refferedBy		   & chr(13)                     
			response.write "v_colodee_elt_acct:"	    & v_colodee_elt_acct	   & chr(13)                     
			response.write "v_colodee_elt_acct_name:"	& v_colodee_elt_acct_name	& chr(13)                
			response.write "v_is_colodee:"		    & v_is_colodee		   & chr(13)                     
			response.write "v_edt:"			    & v_edt			     & chr(13)                 
			response.write "v_SalesPerson:"		    & v_SalesPerson		    & chr(13)                  
			'//////////////////////			    '//////////////////////                       
end sub
%>