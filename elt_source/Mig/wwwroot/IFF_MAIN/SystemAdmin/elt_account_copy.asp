<%@ LANGUAGE = VBScript %>
<!--  #INCLUDE FILE="../ASP/include/connection.asp" -->
<html>
<head>
<title>ELT ACCOUNT COPY</title>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<link href="../ASP/css/elt_css.css" rel="stylesheet" type="text/css">
</head>

<%
'/////////////////////////////////////////////////////////
'// Constants for TABLE///////////////////////////////////
'/////////////////////////////////////////////////////////
Const TABLE_colo	= "colo"
Const TABLE_greetMessage	= "greetMessage"
Const TABLE_user_files	= "user_files"
Const TABLE_user_prefix	= "user_prefix"
Const TABLE_user_profile	= "user_profile"
Const TABLE_flight_no	= "flight_no"
Const TABLE_freight_location	= "freight_location"
Const TABLE_agent_rate	= "agent_rate_table"
Const TABLE_all_rate	= "all_rate_table"
Const TABLE_country_code	= "country_code"
Const TABLE_scheduleB	= "scheduleB"
Const TABLE_ig_schedule_b	= "ig_schedule_b"
Const TABLE_organization	= "organization"
Const TABLE_ig_org_comments	= "ig_org_comments"
Const TABLE_ig_org_contact	= "ig_org_contact"
Const TABLE_port	= "port"
Const TABLE_invoice	= "invoice"
Const TABLE_invoice_charge_item	= "invoice_charge_item"
Const TABLE_invoice_cost_item	= "invoice_cost_item"
Const TABLE_invoice_detail	= "invoice_detail"
Const TABLE_invoice_hawb	= "invoice_hawb"
Const TABLE_invoice_queue	= "invoice_queue"
Const TABLE_bill	= "bill"
Const TABLE_bill_detail	= "bill_detail"
Const TABLE_check_detail	= "check_detail"
Const TABLE_check_queue	= "check_queue"
Const TABLE_gl	= "gl"
Const TABLE_all_accounts_journal	= "all_accounts_journal"
Const TABLE_general_journal_entry	= "general_journal_entry"
Const TABLE_customer_balance	= "customer_balance"
Const TABLE_customer_credits	= "customer_credits"
Const TABLE_customer_payment	= "customer_payment"
Const TABLE_customer_payment_detail	= "customer_payment_detail"
Const TABLE_item_charge	= "item_charge"
Const TABLE_item_cost	= "item_cost"
Const TABLE_cargo_tracking	= "cargo_tracking"
Const TABLE_HAWB_master	= "HAWB_master"
Const TABLE_hawb_Other_Charge	= "hawb_Other_Charge"
Const TABLE_hawb_weight_charge	= "hawb_weight_charge"
Const TABLE_MAWB_number	= "MAWB_number"
Const TABLE_MAWB_master	= "MAWB_master"
Const TABLE_Mawb_Other_Charge	= "Mawb_Other_Charge"
Const TABLE_Mawb_weight_charge	= "Mawb_weight_charge"
Const TABLE_hbol_master	= "hbol_master"
Const TABLE_hbol_other_charge	= "hbol_other_charge"
Const TABLE_mbol_master	= "mbol_master"
Const TABLE_mbol_other_charge	= "mbol_other_charge"
Const TABLE_ocean_booking_number	= "ocean_booking_number"
Const TABLE_Ocean_sed_detail	= "Ocean_sed_detail"
Const TABLE_ocean_sed_master	= "ocean_sed_master"
Const TABLE_sed_detail	= "sed_detail"
Const TABLE_sed_master	= "sed_master"
Const TABLE_import_hawb	= "import_hawb"
Const TABLE_import_mawb	= "import_mawb"
Const TABLE_ig_ocean_ams_edi_header	= "ig_ocean_ams_edi_header"
Const TABLE_ig_ocean_ams_edi_item	= "ig_ocean_ams_edi_item"

Const TABLE_DESC_colo	= "Listing as Coloader on HAWB Screen"
Const TABLE_DESC_greetMessage	= "Company default greeting Message for Mail"
Const TABLE_DESC_user_files	= "Attathed Files in Mail program"
Const TABLE_DESC_user_prefix	= "Prefix Number info."
Const TABLE_DESC_user_profile	= "User or ELT account Profile for default"
Const TABLE_DESC_flight_no	= "flight_no"
Const TABLE_DESC_freight_location	= "Freight Location Master"
Const TABLE_DESC_agent_rate	= "Rate information 1"
Const TABLE_DESC_all_rate	= "Rate information 2"
Const TABLE_DESC_country_code	= "Country Code Master"
Const TABLE_DESC_scheduleB	= "Schedule B"
Const TABLE_DESC_ig_schedule_b	= "Schedule B for client specified"
Const TABLE_DESC_organization	= "Client Profile"
Const TABLE_DESC_ig_org_comments = "Comments for Client Profile"
Const TABLE_DESC_ig_org_contact	= "Contact Info. for Client Profile"
Const TABLE_DESC_port	= "Port Master"
Const TABLE_DESC_invoice	= "Invoice"
Const TABLE_DESC_invoice_charge_item	= "Invoice Charge_item"
Const TABLE_DESC_invoice_cost_item	= "Invoice Cost_item"
Const TABLE_DESC_invoice_detail	= "Invoice Detail"
Const TABLE_DESC_invoice_hawb	= "Invoice vs HAWB/HBOL mapping"
Const TABLE_DESC_invoice_queue	= "Invoice Queue"
Const TABLE_DESC_bill	= "Bill"
Const TABLE_DESC_bill_detail	= "Bill Detail"
Const TABLE_DESC_check_detail	= "Check Detail"
Const TABLE_DESC_check_queue	= "Check Queue"
Const TABLE_DESC_gl	= "General Ledger"
Const TABLE_DESC_all_accounts_journal	= "all_accounts_journal"
Const TABLE_DESC_general_journal_entry	= "general_journal_entry"
Const TABLE_DESC_customer_balance	= "customer_balance"
Const TABLE_DESC_customer_credits	= "customer_credits"
Const TABLE_DESC_customer_payment	= "customer_payment"
Const TABLE_DESC_customer_payment_detail	= "customer_payment_detail"
Const TABLE_DESC_item_charge	= "Charge Item Master"
Const TABLE_DESC_item_cost	= "Cost Item Master"
Const TABLE_DESC_cargo_tracking	= "cargo_tracking"
Const TABLE_DESC_HAWB_master	= "HAWB Info."
Const TABLE_DESC_hawb_Other_Charge	= "hawb_Other_Charge"
Const TABLE_DESC_hawb_weight_charge	= "hawb_weight_charge"
Const TABLE_DESC_MAWB_number	= "MAWB_number"
Const TABLE_DESC_MAWB_master	= "MAWB Info."
Const TABLE_DESC_Mawb_Other_Charge	= "Mawb_Other_Charge"
Const TABLE_DESC_Mawb_weight_charge	= "Mawb_weight_charge"
Const TABLE_DESC_hbol_master	= "hbol_master"
Const TABLE_DESC_hbol_other_charge	= "hbol_other_charge"
Const TABLE_DESC_mbol_master	= "mbol_master"
Const TABLE_DESC_mbol_other_charge	= "mbol_other_charge"
Const TABLE_DESC_ocean_booking_number	= "ocean_booking_number"
Const TABLE_DESC_Ocean_sed_detail	= "Ocean_sed_detail"
Const TABLE_DESC_ocean_sed_master	= "ocean_sed_master"
Const TABLE_DESC_sed_detail	= "sed_detail"
Const TABLE_DESC_sed_master	= "sed_master"
Const TABLE_DESC_import_hawb	= "import_hawb"
Const TABLE_DESC_import_mawb	= "import_mawb"
Const TABLE_DESC_ig_ocean_ams_edi_header	= "ig_ocean_ams_edi_header"
Const TABLE_DESC_ig_ocean_ams_edi_item	= "ig_ocean_ams_edi_item"
%>

<%
DIM elt_account_number,login_name
	elt_account_number = Request.Cookies("CurrentUserInfo")("elt_account_number")
	login_name = Request.Cookies("CurrentUserInfo")("login_name")
	
if elt_account_number = "" or login_name <> "system" then 
	'response.Redirect("/")
end if


Dim rs, SQL,vCopy
Dim aTable(100),aTableDesc(100),tIndex,vSourceClient,vTargetClient,aEltAccount(1024),aEltAccountName(1024),aEltAccountTar(1024),aEltAccountNameTar(1024),sIndex,aIndex
Dim atProc(100),adProc(100),acProc(100)
Set rs = Server.CreateObject("ADODB.Recordset")
vCopy = Request.QueryString("Copy")

vSourceClient = 0
vTargetClient = 0

CALL get_elt_account_list_for_source
CALL get_elt_account_list_for_target
CALL get_table_list

if vCopy = "yes" then
	vSourceClient = Request("lstSourceELT")
	vTargetClient = Request("lstTargetELT")
	if isnull(vSourceClient) then vSourceClient = 0
	if isnull(vTargetClient) then vTargetClient = 0
	if ( not vSourceClient = 0 ) AND ( not vTargetClient = 0 ) then
		CALL table_copy
	end if
end if

%>

<%
SUB table_copy
Dim tProc,dProc,cProc
	
'//////////////////////////////// colo	
	tProc=Request("cTable0") 
	dProc=Request("cDelete0")
	cProc=Request("cCopy0")
	atProc(0)=tProc
	adProc(0)=dProc
	acProc(0)=cProc
	if ( tProc = "Y" or dProc = "Y" or cProc = "Y" ) then
		if ( tProc = "Y" or dProc = "Y") and ( not cProc = "Y" ) then
			SQL = "delete colo where colodee_elt_acct=" & vTargetClient
			eltConn.Execute SQL	
		end if
	
		if ( tProc = "Y" or cProc = "Y" ) and ( not dProc = "Y" ) then
			SQL = "INSERT INTO colo(colodee_elt_acct,colodee_name,coloder_elt_acct,coloder_name,colodee_org_num,tran_date) SELECT '"&vTargetClient&"',colodee_name,coloder_elt_acct,coloder_name,colodee_org_num,tran_date from colo where colodee_elt_acct="&vSourceClient
			eltConn.Execute SQL				
		end if
	end if

'//////////////////////////////// greetMessage	
	tProc=Request("cTable1") 
	dProc=Request("cDelete1")
	cProc=Request("cCopy1")
	atProc(1)=tProc
	adProc(1)=dProc
	acProc(1)=cProc
	if ( tProc = "Y" or dProc = "Y" or cProc = "Y" ) then
		if ( tProc = "Y" or dProc = "Y") and ( not cProc = "Y" ) then
			SQL = "delete greetMessage where AgentID=" & vTargetClient
			eltConn.Execute SQL	
		end if
	
		if ( tProc = "Y" or cProc = "Y" ) and ( not dProc = "Y" ) then
			SQL = "INSERT INTO greetMessage(AgentID, MsgType, MsgTxt) SELECT '"&vTargetClient&"',MsgType,MsgTxt from greetMessage where AgentID="&vSourceClient
			eltConn.Execute SQL				
		end if
	end if

'//////////////////////////////// user_files	
	tProc=Request("cTable2") 
	dProc=Request("cDelete2")
	cProc=Request("cCopy2")
	atProc(2)=tProc
	adProc(2)=dProc
	acProc(2)=cProc
	if ( tProc = "Y" or dProc = "Y" or cProc = "Y" ) then
		if ( tProc = "Y" or dProc = "Y") and ( not cProc = "Y" ) then
			SQL = "delete user_files where elt_account_number=" & vTargetClient
			eltConn.Execute SQL	
		end if
	
		if ( tProc = "Y" or cProc = "Y" ) and ( not dProc = "Y" ) then
			SQL = "INSERT INTO user_files (elt_account_number, org_no, file_name, file_size, file_type, file_content, file_checked, in_dt) SELECT     '"&vTargetClient&"', org_no, file_name, file_size, file_type, file_content, file_checked, in_dt FROM user_files AS user_files_1 where elt_account_number="&vSourceClient
			eltConn.Execute SQL				
		end if
	end if

'//////////////////////////////// user_prefix	
	tProc=Request("cTable3") 
	dProc=Request("cDelete3")
	cProc=Request("cCopy3")
	atProc(3)=tProc
	adProc(3)=dProc
	acProc(3)=cProc
	if ( tProc = "Y" or dProc = "Y" or cProc = "Y" ) then
		if ( tProc = "Y" or dProc = "Y") and ( not cProc = "Y" ) then
			SQL = "delete user_prefix where elt_account_number=" & vTargetClient
			eltConn.Execute SQL	
		end if
	
		if ( tProc = "Y" or cProc = "Y" ) and ( not dProc = "Y" ) then
			SQL = "INSERT INTO user_prefix (elt_account_number, branch, seq_num, prefix, type, next_no, [desc]) SELECT '"&vTargetClient&"', branch, seq_num, prefix, type, next_no, [desc] FROM user_prefix AS user_prefix_1 where elt_account_number="&vSourceClient
			eltConn.Execute SQL				
		end if
	end if

'//////////////////////////////// user_profile	
	tProc=Request("cTable4") 
	dProc=Request("cDelete4")
	cProc=Request("cCopy4")
	atProc(4)=tProc
	adProc(4)=dProc
	acProc(4)=cProc
	if ( tProc = "Y" or dProc = "Y" or cProc = "Y" ) then
		if ( tProc = "Y" or dProc = "Y") and ( not cProc = "Y" ) then
			SQL = "delete user_profile where elt_account_number=" & vTargetClient
			eltConn.Execute SQL	
		end if
	
		if ( tProc = "Y" or cProc = "Y" ) and ( not dProc = "Y" ) then
			SQL = "INSERT INTO user_profile (elt_account_number, branch, invoice_prefix, next_invoice_no, default_invoice_date, next_check_no, uom, currency, default_cgs, invoiceAttn, default_asset, default_air_charge_item,default_ocean_charge_item) SELECT     '"&vTargetClient&"', branch, invoice_prefix, next_invoice_no, default_invoice_date, next_check_no, uom, currency, default_cgs, invoiceAttn,default_asset, default_air_charge_item,default_ocean_charge_item FROM         user_profile AS user_profile_1 where elt_account_number="&vSourceClient
			eltConn.Execute SQL				
		end if
	end if
	
'//////////////////////////////// flight_no	
	tProc=Request("cTable5") 
	dProc=Request("cDelete5")
	cProc=Request("cCopy5")
	atProc(5)=tProc
	adProc(5)=dProc
	acProc(5)=cProc
	if ( tProc = "Y" or dProc = "Y" or cProc = "Y" ) then
		if ( tProc = "Y" or dProc = "Y") and ( not cProc = "Y" ) then
			SQL = "delete flight_no where elt_account_number=" & vTargetClient
			eltConn.Execute SQL	
		end if
	
		if ( tProc = "Y" or cProc = "Y" ) and ( not dProc = "Y" ) then
			SQL = "INSERT INTO flight_no (elt_account_number, airline_name, airline_code, flight_no, pod, poa) SELECT     '"&vTargetClient&"', airline_name, airline_code, flight_no, pod, poa FROM         flight_no AS flight_no_1 where elt_account_number="&vSourceClient
			eltConn.Execute SQL				
		end if
	end if

'//////////////////////////////// freight_location	
	tProc=Request("cTable6") 
	dProc=Request("cDelete6")
	cProc=Request("cCopy6")
	atProc(6)=tProc
	adProc(6)=dProc
	acProc(6)=cProc
	if ( tProc = "Y" or dProc = "Y" or cProc = "Y" ) then
		if ( tProc = "Y" or dProc = "Y") and ( not cProc = "Y" ) then
			SQL = "delete freight_location where elt_account_number=" & vTargetClient
			eltConn.Execute SQL	
		end if
	
		if ( tProc = "Y" or cProc = "Y" ) and ( not dProc = "Y" ) then
			SQL = "INSERT INTO freight_location (elt_account_number, location, firm_code, phone, fax, address, city, state, country) SELECT     '"&vTargetClient&"', location, firm_code, phone, fax, address, city, state, country FROM         freight_location AS freight_location_1 where elt_account_number="&vSourceClient
			eltConn.Execute SQL				
		end if
	end if

'//////////////////////////////// agent_rate_table	
	tProc=Request("cTable7") 
	dProc=Request("cDelete7")
	cProc=Request("cCopy7")
	atProc(7)=tProc
	adProc(7)=dProc
	acProc(7)=cProc
	if ( tProc = "Y" or dProc = "Y" or cProc = "Y" ) then
		if ( tProc = "Y" or dProc = "Y") and ( not cProc = "Y" ) then
			SQL = "delete agent_rate_table where elt_account_number=" & vTargetClient
			eltConn.Execute SQL	
		end if
	
		if ( tProc = "Y" or cProc = "Y" ) and ( not dProc = "Y" ) then
			SQL = "INSERT INTO agent_rate_table (elt_account_number, agent_no, agent_name, item_no, airline, origin_port, dest_port, weight_break, rate, share) SELECT     '"&vTargetClient&"', agent_no, agent_name, item_no, airline, origin_port, dest_port, weight_break, rate, share FROM agent_rate_table AS agent_rate_table_1 where elt_account_number="&vSourceClient
			eltConn.Execute SQL				
		end if
	end if

'//////////////////////////////// all_rate_table	
	tProc=Request("cTable8") 
	dProc=Request("cDelete8")
	cProc=Request("cCopy8")
	atProc(8)=tProc
	adProc(8)=dProc
	acProc(8)=cProc
	if ( tProc = "Y" or dProc = "Y" or cProc = "Y" ) then
		if ( tProc = "Y" or dProc = "Y") and ( not cProc = "Y" ) then
			SQL = "delete all_rate_table where elt_account_number=" & vTargetClient
			eltConn.Execute SQL	
		end if
	
		if ( tProc = "Y" or cProc = "Y" ) and ( not dProc = "Y" ) then
			SQL = "INSERT INTO all_rate_table (elt_account_number, item_no, agent_no, rate_type, customer_no, airline, origin_port, dest_port, weight_break, rate, kg_lb, share) SELECT     '"&vTargetClient&"', item_no, agent_no, rate_type, customer_no, airline, origin_port, dest_port, weight_break, rate, kg_lb, share FROM         all_rate_table AS all_rate_table_1 where elt_account_number="&vSourceClient
			eltConn.Execute SQL				
		end if
	end if

'//////////////////////////////// country_code	
	tProc=Request("cTable9") 
	dProc=Request("cDelete9")
	cProc=Request("cCopy9")
	atProc(9)=tProc
	adProc(9)=dProc
	acProc(9)=cProc
	if ( tProc = "Y" or dProc = "Y" or cProc = "Y" ) then
		if ( tProc = "Y" or dProc = "Y") and ( not cProc = "Y" ) then
			SQL = "delete country_code where elt_account_number=" & vTargetClient
			eltConn.Execute SQL	
		end if
	
		if ( tProc = "Y" or cProc = "Y" ) and ( not dProc = "Y" ) then
			SQL = "INSERT INTO country_code (elt_account_number, country_name, country_code) SELECT     '"&vTargetClient&"', country_name, country_code FROM         country_code AS country_code_1 where elt_account_number="&vSourceClient
			eltConn.Execute SQL				
		end if
	end if

'//////////////////////////////// scheduleB	
	tProc=Request("cTable10") 
	dProc=Request("cDelete10")
	cProc=Request("cCopy10")
	atProc(10)=tProc
	adProc(10)=dProc
	acProc(10)=cProc
	if ( tProc = "Y" or dProc = "Y" or cProc = "Y" ) then
		if ( tProc = "Y" or dProc = "Y") and ( not cProc = "Y" ) then
			SQL = "delete scheduleB where elt_account_number=" & vTargetClient
			eltConn.Execute SQL	
		end if
	
		if ( tProc = "Y" or cProc = "Y" ) and ( not dProc = "Y" ) then
			SQL = "INSERT INTO scheduleB (elt_account_number, sb, sb_unit1, sb_unit2, description) SELECT     '"&vTargetClient&"', sb, sb_unit1, sb_unit2, description FROM         scheduleB AS scheduleB_1 where elt_account_number="&vSourceClient
			eltConn.Execute SQL				
		end if
	end if

'//////////////////////////////// ig_schedule_b	
	tProc=Request("cTable11") 
	dProc=Request("cDelete11")
	cProc=Request("cCopy11")
	atProc(11)=tProc
	adProc(11)=dProc
	acProc(11)=cProc
	if ( tProc = "Y" or dProc = "Y" or cProc = "Y" ) then
		if ( tProc = "Y" or dProc = "Y") and ( not cProc = "Y" ) then
			SQL = "delete ig_schedule_b where elt_account_number=" & vTargetClient
			eltConn.Execute SQL	
		end if
	
		if ( tProc = "Y" or cProc = "Y" ) and ( not dProc = "Y" ) then
			SQL = "INSERT INTO ig_schedule_b (elt_account_number, org_account_number, sb, sb_unit1, sb_unit2, description) SELECT     '"&vTargetClient&"', org_account_number, sb, sb_unit1, sb_unit2, description FROM         ig_schedule_b AS ig_schedule_b_1 where elt_account_number="&vSourceClient
			eltConn.Execute SQL				
		end if
	end if
	
'//////////////////////////////// organization	
	tProc=Request("cTable12") 
	dProc=Request("cDelete12")
	cProc=Request("cCopy12")
	atProc(12)=tProc
	adProc(12)=dProc
	acProc(12)=cProc
	if ( tProc = "Y" or dProc = "Y" or cProc = "Y" ) then
		if ( tProc = "Y" or dProc = "Y") and ( not cProc = "Y" ) then
			SQL = "delete organization where elt_account_number=" & vTargetClient
			eltConn.Execute SQL	
		end if
	
		if ( tProc = "Y" or cProc = "Y" ) and ( not dProc = "Y" ) then
			SQL = "INSERT INTO organization (elt_account_number, org_account_number, acct_name, dba_name, class_code, date_opened, last_update, business_legal_name, business_fed_taxid, business_st_taxid, business_address, business_city, business_state, business_zip, business_country, b_country_code,business_phone, business_fax, business_url, owner_ssn, owner_lname, owner_fname, owner_mname, owner_mail_address, owner_mail_city, owner_mail_state, owner_mail_zip, owner_mail_country, owner_phone, owner_email, attn_name, notify_name, is_shipper, is_consignee, broker_info,is_agent, agent_elt_acct, edt, is_vendor, is_carrier, iata_code, carrier_code, carrier_id, carrier_type, account_status, comment, credit_amt, bill_term,is_coloader, coloader_elt_acct, z_is_trucker, z_is_special, z_is_broker, z_is_warehousing, z_is_cfs, z_is_govt, z_bond_number, z_bond_exp_date, z_bond_amount, z_bond_surety, z_bank_name, z_bank_account_no, z_chl_no, z_firm_code, z_carrier_code, z_carrier_prefix, z_attn_txt) SELECT     '"&vTargetClient&"', org_account_number, acct_name, dba_name, class_code, date_opened, last_update, business_legal_name, business_fed_taxid, business_st_taxid, business_address, business_city, business_state, business_zip, business_country, b_country_code, business_phone, business_fax, business_url, owner_ssn, owner_lname, owner_fname, owner_mname, owner_mail_address, owner_mail_city, owner_mail_state,owner_mail_zip, owner_mail_country, owner_phone, owner_email, attn_name, notify_name, is_shipper, is_consignee, broker_info, is_agent, agent_elt_acct, edt, is_vendor, is_carrier, iata_code, carrier_code, carrier_id, carrier_type, account_status, comment, credit_amt, bill_term, is_coloader,coloader_elt_acct, z_is_trucker, z_is_special, z_is_broker, z_is_warehousing, z_is_cfs, z_is_govt, z_bond_number, z_bond_exp_date,z_bond_amount, z_bond_surety, z_bank_name, z_bank_account_no, z_chl_no, z_firm_code, z_carrier_code, z_carrier_prefix, z_attn_txt FROM         organization AS organization_1 where elt_account_number="&vSourceClient
			eltConn.Execute SQL				
		end if
	end if

'//////////////////////////////// ig_org_comments	
	tProc=Request("cTable13") 
	dProc=Request("cDelete13")
	cProc=Request("cCopy13")
	atProc(13)=tProc
	adProc(13)=dProc
	acProc(13)=cProc
	if ( tProc = "Y" or dProc = "Y" or cProc = "Y" ) then
		if ( tProc = "Y" or dProc = "Y") and ( not cProc = "Y" ) then
			SQL = "delete ig_org_comments where elt_account_number=" & vTargetClient
			eltConn.Execute SQL	
		end if
	
		if ( tProc = "Y" or cProc = "Y" ) and ( not dProc = "Y" ) then
			SQL = "INSERT INTO ig_org_comments (elt_account_number, org_account_number, item_no, title, comment, date, editedby) SELECT     '"&vTargetClient&"', org_account_number, item_no, title, comment, date, editedby FROM         ig_org_comments AS ig_org_comments_1 where elt_account_number="&vSourceClient
			eltConn.Execute SQL				
		end if
	end if

'//////////////////////////////// ig_org_contact	
	tProc=Request("cTable14") 
	dProc=Request("cDelete14")
	cProc=Request("cCopy14")
	atProc(14)=tProc
	adProc(14)=dProc
	acProc(14)=cProc
	if ( tProc = "Y" or dProc = "Y" or cProc = "Y" ) then
		if ( tProc = "Y" or dProc = "Y") and ( not cProc = "Y" ) then
			SQL = "delete ig_org_contact where elt_account_number=" & vTargetClient
			eltConn.Execute SQL	
		end if
	
		if ( tProc = "Y" or cProc = "Y" ) and ( not dProc = "Y" ) then
			SQL = "INSERT INTO ig_org_contact (elt_account_number, org_account_number, item_no, name, job_title, phone, fax, email, remark, date, editedby) SELECT     '"&vTargetClient&"', org_account_number, item_no, name, job_title, phone, fax, email, remark, date, editedby FROM         ig_org_contact AS ig_org_contact_1 where elt_account_number="&vSourceClient
			eltConn.Execute SQL				
		end if
	end if

'//////////////////////////////// port	
	tProc=Request("cTable15") 
	dProc=Request("cDelete15")
	cProc=Request("cCopy15")
	atProc(15)=tProc
	adProc(15)=dProc
	acProc(15)=cProc
	if ( tProc = "Y" or dProc = "Y" or cProc = "Y" ) then
		if ( tProc = "Y" or dProc = "Y") and ( not cProc = "Y" ) then
			SQL = "delete port where elt_account_number=" & vTargetClient
			eltConn.Execute SQL	
		end if
	
		if ( tProc = "Y" or cProc = "Y" ) and ( not dProc = "Y" ) then
			SQL = "INSERT INTO port (elt_account_number, port_code, port_desc, port_id, port_city, port_country, port_country_code, port_state) SELECT     '"&vTargetClient&"', port_code, port_desc, port_id, port_city, port_country, port_country_code, port_state FROM         port AS port_1 where elt_account_number="&vSourceClient
			eltConn.Execute SQL				
		end if
	end if

'////////////////////////////////  invoice 	
	tProc=Request("cTable16") 
	dProc=Request("cDelete16")
	cProc=Request("cCopy16")
	atProc(16)=tProc
	adProc(16)=dProc
	acProc(16)=cProc
	if ( tProc = "Y" or dProc = "Y" or cProc = "Y" ) then
		if ( tProc = "Y" or dProc = "Y") and ( not cProc = "Y" ) then
			SQL = "delete invoice where elt_account_number=" & vTargetClient
			eltConn.Execute SQL	
		end if
	
		if ( tProc = "Y" or cProc = "Y" ) and ( not dProc = "Y" ) then
			SQL = "INSERT INTO invoice (elt_account_number, invoice_no, invoice_type, import_export, air_ocean, invoice_date, ref_no, ref_no_Our, Customer_info, Total_Gross_Weight, Total_Pieces, Total_Charge_Weight, Description, Origin_Dest, origin, dest, Customer_Name, Customer_Number, shipper, consignee, entry_no, entry_date, Carrier, Arrival_Dept, mawb_num, hawb_num, subtotal, sale_tax, agent_profit, accounts_receivable, amount_charged, amount_paid, balance, total_cost, remarks, pay_status, term_curr, term30, term60, term90, received_amt, pmt_method, existing_credits, deposit_to, lock_ar, lock_ap, in_memo) SELECT     '"&vTargetClient&"', invoice_no, invoice_type, import_export, air_ocean, invoice_date, ref_no, ref_no_Our, Customer_info, Total_Gross_Weight, Total_Pieces, Total_Charge_Weight, Description, Origin_Dest, origin, dest, Customer_Name, Customer_Number, shipper, consignee, entry_no, entry_date, Carrier, Arrival_Dept, mawb_num, hawb_num, subtotal, sale_tax, agent_profit, accounts_receivable, amount_charged, amount_paid, balance, total_cost, remarks, pay_status, term_curr, term30, term60, term90, received_amt, pmt_method, existing_credits, deposit_to, lock_ar, lock_ap, in_memo FROM         invoice AS invoice_1 where elt_account_number="&vSourceClient
			eltConn.Execute SQL				
		end if
	end if
	
'////////////////////////////////  invoice_charge_item 	
	tProc=Request("cTable17") 
	dProc=Request("cDelete17")
	cProc=Request("cCopy17")
	atProc(17)=tProc
	adProc(17)=dProc
	acProc(17)=cProc
	if ( tProc = "Y" or dProc = "Y" or cProc = "Y" ) then
		if ( tProc = "Y" or dProc = "Y") and ( not cProc = "Y" ) then
			SQL = "delete invoice_charge_item where elt_account_number=" & vTargetClient
			eltConn.Execute SQL	
		end if
	
		if ( tProc = "Y" or cProc = "Y" ) and ( not dProc = "Y" ) then
			SQL = "INSERT INTO invoice_charge_item (elt_account_number, invoice_no, item_id, item_no, item_desc, qty, charge_amount) SELECT     '"&vTargetClient&"', invoice_no, item_id, item_no, item_desc, qty, charge_amount FROM         invoice_charge_item AS invoice_charge_item_1 where elt_account_number="&vSourceClient
			eltConn.Execute SQL				
		end if
	end if
	
'////////////////////////////////  invoice_cost_item 	
	tProc=Request("cTable18") 
	dProc=Request("cDelete18")
	cProc=Request("cCopy18")
	atProc(18)=tProc
	adProc(18)=dProc
	acProc(18)=cProc
	if ( tProc = "Y" or dProc = "Y" or cProc = "Y" ) then
		if ( tProc = "Y" or dProc = "Y") and ( not cProc = "Y" ) then
			SQL = "delete invoice_cost_item where elt_account_number=" & vTargetClient
			eltConn.Execute SQL	
		end if
	
		if ( tProc = "Y" or cProc = "Y" ) and ( not dProc = "Y" ) then
			SQL = "INSERT INTO invoice_cost_item (elt_account_number, invoice_no, item_no, item_id, item_desc, qty, ref_no, cost_amount, vendor_no) SELECT     '"&vTargetClient&"', invoice_no, item_no, item_id, item_desc, qty, ref_no, cost_amount, vendor_no FROM         invoice_cost_item AS invoice_cost_item_1 where elt_account_number="&vSourceClient
			eltConn.Execute SQL				
		end if
	end if

'////////////////////////////////  invoice_detail 	
	tProc=Request("cTable19") 
	dProc=Request("cDelete19")
	cProc=Request("cCopy19")
	atProc(19)=tProc
	adProc(19)=dProc
	acProc(19)=cProc
	if ( tProc = "Y" or dProc = "Y" or cProc = "Y" ) then
		if ( tProc = "Y" or dProc = "Y") and ( not cProc = "Y" ) then
			SQL = "delete invoice_detail where elt_account_number=" & vTargetClient
			eltConn.Execute SQL	
		end if
	
		if ( tProc = "Y" or cProc = "Y" ) and ( not dProc = "Y" ) then
			SQL = "INSERT INTO invoice_detail (elt_account_number, item_id, invoice_no, item_no, item_desc, charge_amount, qty, ref_no, cost_amount, vendor_no) SELECT     '"&vTargetClient&"', item_id, invoice_no, item_no, item_desc, charge_amount, qty, ref_no, cost_amount, vendor_no FROM         invoice_detail AS invoice_detail_1 where elt_account_number="&vSourceClient
			eltConn.Execute SQL				
		end if
	end if
	
'////////////////////////////////  invoice_hawb 	
	tProc=Request("cTable20") 
	dProc=Request("cDelete20")
	cProc=Request("cCopy20")
	atProc(20)=tProc
	adProc(20)=dProc
	acProc(20)=cProc
	if ( tProc = "Y" or dProc = "Y" or cProc = "Y" ) then
		if ( tProc = "Y" or dProc = "Y") and ( not cProc = "Y" ) then
			SQL = "delete invoice_hawb where elt_account_number=" & vTargetClient
			eltConn.Execute SQL	
		end if
	
		if ( tProc = "Y" or cProc = "Y" ) and ( not dProc = "Y" ) then
			SQL = "INSERT INTO invoice_hawb (invoice_type, elt_account_number, invoice_no, import_export, air_ocean, hawb_num, hawb_url) SELECT     invoice_type, '"&vTargetClient&"', invoice_no, import_export, air_ocean, hawb_num, hawb_url FROM         invoice_hawb AS invoice_hawb_1 where elt_account_number="&vSourceClient
			eltConn.Execute SQL				
		end if
	end if
	
'////////////////////////////////  invoice_queue 	
	tProc=Request("cTable21") 
	dProc=Request("cDelete21")
	cProc=Request("cCopy21")
	atProc(21)=tProc
	adProc(21)=dProc
	acProc(21)=cProc
	if ( tProc = "Y" or dProc = "Y" or cProc = "Y" ) then
		if ( tProc = "Y" or dProc = "Y") and ( not cProc = "Y" ) then
			SQL = "delete invoice_queue where elt_account_number=" & vTargetClient
			eltConn.Execute SQL	
		end if
	
		if ( tProc = "Y" or cProc = "Y" ) and ( not dProc = "Y" ) then
			SQL = "INSERT INTO invoice_queue (elt_account_number, queue_id, inqueue_date, outqueue_date, agent_shipper, hawb_num, mawb_num, bill_to, bill_to_org_acct, agent_name,agent_org_acct, master_agent, air_ocean, master_only, invoiced) SELECT     '"&vTargetClient&"', queue_id, inqueue_date, outqueue_date, agent_shipper, hawb_num, mawb_num, bill_to, bill_to_org_acct, agent_name, agent_org_acct, master_agent, air_ocean, master_only, invoiced FROM         invoice_queue AS invoice_queue_1 where elt_account_number="&vSourceClient
			eltConn.Execute SQL				
		end if
	end if
	
'//////////////////////////////// bill	
	tProc=Request("cTable22") 
	dProc=Request("cDelete22")
	cProc=Request("cCopy22")
	atProc(22)=tProc
	adProc(22)=dProc
	acProc(22)=cProc
	if ( tProc = "Y" or dProc = "Y" or cProc = "Y" ) then
		if ( tProc = "Y" or dProc = "Y") and ( not cProc = "Y" ) then
			SQL = "delete bill where elt_account_number=" & vTargetClient
			eltConn.Execute SQL	
		end if
	
		if ( tProc = "Y" or cProc = "Y" ) and ( not dProc = "Y" ) then
			SQL = "INSERT INTO bill (elt_account_number, bill_number, bill_type, vendor_number, vendor_name, bill_date, bill_due_date, bill_amt, bill_amt_paid, bill_amt_due, ref_no, bill_expense_acct, bill_ap, bill_status, print_id, lock, pmt_method) SELECT     '"&vTargetClient&"', bill_number, bill_type, vendor_number, vendor_name, bill_date, bill_due_date, bill_amt, bill_amt_paid, bill_amt_due, ref_no, bill_expense_acct, bill_ap, bill_status, print_id, lock, pmt_method FROM         bill AS bill_1 where elt_account_number="&vSourceClient
			eltConn.Execute SQL				
		end if
	end if	
	
'//////////////////////////////// bill_detail	
	tProc=Request("cTable23") 
	dProc=Request("cDelete23")
	cProc=Request("cCopy23")
	atProc(23)=tProc
	adProc(23)=dProc
	acProc(23)=cProc
	if ( tProc = "Y" or dProc = "Y" or cProc = "Y" ) then
		if ( tProc = "Y" or dProc = "Y") and ( not cProc = "Y" ) then
			SQL = "delete bill_detail where elt_account_number=" & vTargetClient
			eltConn.Execute SQL	
		end if
	
		if ( tProc = "Y" or cProc = "Y" ) and ( not dProc = "Y" ) then
			SQL = "INSERT INTO bill_detail (elt_account_number, invoice_no, item_id, bill_number, vendor_number, item_name, item_no, item_expense_acct, item_amt, item_ap, tran_date, ref) SELECT     '"&vTargetClient&"', invoice_no, item_id, bill_number, vendor_number, item_name, item_no, item_expense_acct, item_amt, item_ap, tran_date, ref FROM         bill_detail AS bill_detail_1 where elt_account_number="&vSourceClient
			eltConn.Execute SQL				
		end if
	end if	

'//////////////////////////////// check_detail	
	tProc=Request("cTable24") 
	dProc=Request("cDelete24")
	cProc=Request("cCopy24")
	atProc(24)=tProc
	adProc(24)=dProc
	acProc(24)=cProc
	if ( tProc = "Y" or dProc = "Y" or cProc = "Y" ) then
		if ( tProc = "Y" or dProc = "Y") and ( not cProc = "Y" ) then
			SQL = "delete check_detail where elt_account_number=" & vTargetClient
			eltConn.Execute SQL	
		end if
	
		if ( tProc = "Y" or cProc = "Y" ) and ( not dProc = "Y" ) then
			SQL = "INSERT INTO check_detail(elt_account_number, print_id, tran_id, bill_number, due_date, invoice_no, bill_amt, amt_due, amt_paid, memo, pmt_method) SELECT     '"&vTargetClient&"', print_id, tran_id, bill_number, due_date, invoice_no, bill_amt, amt_due, amt_paid, memo, pmt_method FROM         check_detail AS check_detail_1 where elt_account_number="&vSourceClient
			eltConn.Execute SQL				
		end if
	end if	
	
'//////////////////////////////// check_queue	
	tProc=Request("cTable25") 
	dProc=Request("cDelete25")
	cProc=Request("cCopy25")
	atProc(25)=tProc
	adProc(25)=dProc
	acProc(25)=cProc
	if ( tProc = "Y" or dProc = "Y" or cProc = "Y" ) then
		if ( tProc = "Y" or dProc = "Y") and ( not cProc = "Y" ) then
			SQL = "delete check_queue where elt_account_number=" & vTargetClient
			eltConn.Execute SQL	
		end if
	
		if ( tProc = "Y" or cProc = "Y" ) and ( not dProc = "Y" ) then
			SQL = "INSERT INTO check_queue (print_id, check_no, elt_account_number, check_type, check_amt, vendor_number, vendor_name, vendor_info, bank, ap, print_status, bill_date, bill_due_date, print_date, memo, pmt_method) SELECT     print_id, check_no, '"&vTargetClient&"', check_type, check_amt, vendor_number, vendor_name, vendor_info, bank, ap, print_status, bill_date, bill_due_date, print_date, memo, pmt_method FROM         check_queue AS check_queue_1 where elt_account_number="&vSourceClient
			eltConn.Execute SQL				
		end if
	end if	
		
'//////////////////////////////// gl	
	tProc=Request("cTable26") 
	dProc=Request("cDelete26")
	cProc=Request("cCopy26")
	atProc(26)=tProc
	adProc(26)=dProc
	acProc(26)=cProc
	if ( tProc = "Y" or dProc = "Y" or cProc = "Y" ) then
		if ( tProc = "Y" or dProc = "Y") and ( not cProc = "Y" ) then
			SQL = "delete gl where elt_account_number=" & vTargetClient
			eltConn.Execute SQL	
		end if
	
		if ( tProc = "Y" or cProc = "Y" ) and ( not dProc = "Y" ) then
			SQL = "INSERT INTO gl (elt_account_number, gl_account_number, gl_account_desc, gl_master_type, gl_account_type, gl_account_balance, gl_begin_balance, gl_account_status, gl_account_cdate, gl_last_modified) SELECT     '"&vTargetClient&"', gl_account_number, gl_account_desc, gl_master_type, gl_account_type, gl_account_balance, gl_begin_balance, gl_account_status, gl_account_cdate, gl_last_modified FROM         gl AS gl_1 where elt_account_number="&vSourceClient
			eltConn.Execute SQL				
		end if
	end if	


'//////////////////////////////// all_accounts_journal	
	tProc=Request("cTable27") 
	dProc=Request("cDelete27")
	cProc=Request("cCopy27")
	atProc(27)=tProc
	adProc(27)=dProc
	acProc(27)=cProc
	if ( tProc = "Y" or dProc = "Y" or cProc = "Y" ) then
		if ( tProc = "Y" or dProc = "Y") and ( not cProc = "Y" ) then
			SQL = "delete all_accounts_journal where elt_account_number=" & vTargetClient
			eltConn.Execute SQL	
		end if
	
		if ( tProc = "Y" or cProc = "Y" ) and ( not dProc = "Y" ) Then		
			SQL = "INSERT INTO all_accounts_journal (elt_account_number, tran_seq_num, gl_account_number, gl_account_name, tran_type, tran_num, air_ocean, tran_date, customer_name, customer_number, memo, split, check_no, debit_amount, credit_amount, balance, previous_balance, gl_balance, gl_previous_balance, adjust_amount, ModifiedBy, ModifiedDate, debit_memo, credit_memo, flag_close) SELECT '"&vTargetClient&"', tran_seq_num, gl_account_number, gl_account_name, tran_type, tran_num, air_ocean, tran_date, customer_name, customer_number, memo, split, check_no, debit_amount, credit_amount, balance, previous_balance, gl_balance, gl_previous_balance, adjust_amount, ModifiedBy, ModifiedDate, debit_memo, credit_memo, flag_close FROM all_accounts_journal AS all_accounts_journal_1 where elt_account_number="&vSourceClient
			eltConn.Execute SQL				
		end if
	end if		
	
'//////////////////////////////// general_journal_entry	
	tProc=Request("cTable28") 
	dProc=Request("cDelete28")
	cProc=Request("cCopy28")
	atProc(28)=tProc
	adProc(28)=dProc
	acProc(28)=cProc
	if ( tProc = "Y" or dProc = "Y" or cProc = "Y" ) then
		if ( tProc = "Y" or dProc = "Y") and ( not cProc = "Y" ) then
			SQL = "delete general_journal_entry where elt_account_number=" & vTargetClient
			eltConn.Execute SQL	
		end if
	
		if ( tProc = "Y" or cProc = "Y" ) and ( not dProc = "Y" ) then
			SQL = "INSERT INTO general_journal_entry (elt_account_number, item_no, gl_account_number, entry_no, credit, debit, memo, org_acct, dt) SELECT     '"&vTargetClient&"', item_no, gl_account_number, entry_no, credit, debit, memo, org_acct, dt FROM         general_journal_entry AS general_journal_entry_1 where elt_account_number="&vSourceClient
			eltConn.Execute SQL				
		end if
	end if		

'//////////////////////////////// customer_balance	
	tProc=Request("cTable29") 
	dProc=Request("cDelete29")
	cProc=Request("cCopy29")
	atProc(29)=tProc
	adProc(29)=dProc
	acProc(29)=cProc
	if ( tProc = "Y" or dProc = "Y" or cProc = "Y" ) then
		if ( tProc = "Y" or dProc = "Y") and ( not cProc = "Y" ) then
			SQL = "delete customer_balance where elt_account_number=" & vTargetClient
			eltConn.Execute SQL	
		end if
	
		if ( tProc = "Y" or cProc = "Y" ) and ( not dProc = "Y" ) then
			SQL = "INSERT INTO customer_balance (elt_account_number, gl_account_number, customer_name, customer_acct, balance, last_modified) SELECT     '"&vTargetClient&"', gl_account_number, customer_name, customer_acct, balance, last_modified FROM         customer_balance AS customer_balance_1 where elt_account_number="&vSourceClient
			eltConn.Execute SQL				
		end if
	end if			
	
'//////////////////////////////// customer_credits	
	tProc=Request("cTable30") 
	dProc=Request("cDelete30")
	cProc=Request("cCopy30")
	atProc(30)=tProc
	adProc(30)=dProc
	acProc(30)=cProc
	if ( tProc = "Y" or dProc = "Y" or cProc = "Y" ) then
		if ( tProc = "Y" or dProc = "Y") and ( not cProc = "Y" ) then
			SQL = "delete customer_credits where elt_account_number=" & vTargetClient
			eltConn.Execute SQL	
		end if
	
		if ( tProc = "Y" or cProc = "Y" ) and ( not dProc = "Y" ) then
			SQL = "INSERT INTO customer_credits (elt_account_number, customer_name, credit, customer_no) SELECT     '"&vTargetClient&"', customer_name, credit, customer_no FROM         customer_credits AS customer_credits_1 where elt_account_number="&vSourceClient
			eltConn.Execute SQL				
		end if
	end if			
	
'//////////////////////////////// customer_payment	
	tProc=Request("cTable31") 
	dProc=Request("cDelete31")
	cProc=Request("cCopy31")
	atProc(31)=tProc
	adProc(31)=dProc
	acProc(31)=cProc
	if ( tProc = "Y" or dProc = "Y" or cProc = "Y" ) then
		if ( tProc = "Y" or dProc = "Y") and ( not cProc = "Y" ) then
			SQL = "delete customer_payment where elt_account_number=" & vTargetClient
			eltConn.Execute SQL	
		end if
	
		if ( tProc = "Y" or cProc = "Y" ) and ( not dProc = "Y" ) then
			SQL = "INSERT INTO customer_payment (elt_account_number, payment_no, payment_date, branch, ref_no, customer_name, customer_number, accounts_receivable, deposit_to, balance, received_amt, pmt_method, existing_credits, unapplied_amt, added_amt) SELECT     '"&vTargetClient&"', payment_no, payment_date, branch, ref_no, customer_name, customer_number, accounts_receivable, deposit_to, balance, received_amt, pmt_method, existing_credits, unapplied_amt, added_amt FROM         customer_payment AS customer_payment_1 where elt_account_number="&vSourceClient
			eltConn.Execute SQL				
		end if
	end if			
	
'//////////////////////////////// customer_payment_detail	
	tProc=Request("cTable32") 
	dProc=Request("cDelete32")
	cProc=Request("cCopy32")
	atProc(32)=tProc
	adProc(32)=dProc
	acProc(32)=cProc
	if ( tProc = "Y" or dProc = "Y" or cProc = "Y" ) then
		if ( tProc = "Y" or dProc = "Y") and ( not cProc = "Y" ) then
			SQL = "delete customer_payment_detail where elt_account_number=" & vTargetClient
			eltConn.Execute SQL	
		end if
	
		if ( tProc = "Y" or cProc = "Y" ) and ( not dProc = "Y" ) then
			SQL = "INSERT INTO customer_payment_detail (elt_account_number, item_id, payment_no, invoice_date, invoice_no, type, orig_amt, amt_due, payment) SELECT     '"&vTargetClient&"', item_id, payment_no, invoice_date, invoice_no, type, orig_amt, amt_due, payment FROM         customer_payment_detail AS customer_payment_detail_1 where elt_account_number="&vSourceClient
			eltConn.Execute SQL				
		end if
	end if			
	
'//////////////////////////////// item_charge	
	tProc=Request("cTable33") 
	dProc=Request("cDelete33")
	cProc=Request("cCopy33")
	atProc(33)=tProc
	adProc(33)=dProc
	acProc(33)=cProc
	if ( tProc = "Y" or dProc = "Y" or cProc = "Y" ) then
		if ( tProc = "Y" or dProc = "Y") and ( not cProc = "Y" ) then
			SQL = "delete item_charge where elt_account_number=" & vTargetClient
			eltConn.Execute SQL	
		end if
	
		if ( tProc = "Y" or cProc = "Y" ) and ( not dProc = "Y" ) then
			SQL = "INSERT INTO item_charge (elt_account_number, item_no, item_name, item_type, item_desc, unit_price, account_revenue) SELECT     '"&vTargetClient&"', item_no, item_name, item_type, item_desc, unit_price, account_revenue FROM         item_charge AS item_charge_1 where elt_account_number="&vSourceClient
			eltConn.Execute SQL				
		end if
	end if			
	
'//////////////////////////////// item_cost	
	tProc=Request("cTable34") 
	dProc=Request("cDelete34")
	cProc=Request("cCopy34")
	atProc(34)=tProc
	adProc(34)=dProc
	acProc(34)=cProc
	if ( tProc = "Y" or dProc = "Y" or cProc = "Y" ) then
		if ( tProc = "Y" or dProc = "Y") and ( not cProc = "Y" ) then
			SQL = "delete item_cost where elt_account_number=" & vTargetClient
			eltConn.Execute SQL	
		end if
	
		if ( tProc = "Y" or cProc = "Y" ) and ( not dProc = "Y" ) then
			SQL = "INSERT INTO item_cost (elt_account_number, item_no, item_name, item_type, item_desc, unit_price, account_expense) SELECT     '"&vTargetClient&"', item_no, item_name, item_type, item_desc, unit_price, account_expense FROM         item_cost AS item_cost_1 where elt_account_number="&vSourceClient
			eltConn.Execute SQL				
		end if
	end if			

'//////////////////////////////// cargo_tracking	
	tProc=Request("cTable35") 
	dProc=Request("cDelete35")
	cProc=Request("cCopy35")
	atProc(35)=tProc
	adProc(35)=dProc
	acProc(35)=cProc
	if ( tProc = "Y" or dProc = "Y" or cProc = "Y" ) then
		if ( tProc = "Y" or dProc = "Y") and ( not cProc = "Y" ) then
			SQL = "delete cargo_tracking where elt_account_number=" & vTargetClient
			eltConn.Execute SQL	
		end if
	
		if ( tProc = "Y" or cProc = "Y" ) and ( not dProc = "Y" ) then
			SQL = "INSERT INTO cargo_tracking (elt_account_number, request_id, export_agent_name, import_agent_elt_acct, import_agent_name, ref_no, sr_dt, sr_location, shipper_name, shipper_info, shipper_acct, consignee_name, consignee_acct, consignee_import_acct, flight_no, etd, eta, pol, poa, pc_scale, pieces, chg_wt,chg_wt_scale, gross_wt, gross_wt_scale, dims, dims_scale, sr_by, pu_location, pickup_dt, airport_dt, ready_dt, contact, contact_phone, hawb, mawb,note, invoice_no, cargo_location, it_number, wh1_in_tran_dt, wh1_in_dt, wh1_in_pc, wh1_from, wh1_in_trucker, wh1_in_remark, wh1_out_tran_dt,wh1_out_dt, wh1_out_pc, wh1_to, wh1_out_trucker,wh1_out_remark, wh2_in_tran_dt, wh2_in_dt, wh2_in_pc, wh2_in_trucker, wh2_from,wh2_in_remark, wh2_out_tran_dt, wh2_out_dt, wh2_out_pc, wh2_to,wh2_out_trucker, wh2_out_remark, dest_tran_dt, dest_from, dest_dt, dest_pc,dest_trucker, dest_remark, dest_close_remark, dest_close_dt, status) SELECT     '"&vTargetClient&"', request_id, export_agent_name, import_agent_elt_acct, import_agent_name, ref_no, sr_dt, sr_location, shipper_name,                      shipper_info, shipper_acct, consignee_name, consignee_acct, consignee_import_acct, flight_no, etd, eta, pol, poa, pc_scale, pieces, chg_wt,chg_wt_scale, gross_wt, gross_wt_scale, dims, dims_scale, sr_by, pu_location, pickup_dt, airport_dt, ready_dt, contact, contact_phone, hawb, mawb,note, invoice_no, cargo_location, it_number, wh1_in_tran_dt, wh1_in_dt, wh1_in_pc, wh1_from, wh1_in_trucker, wh1_in_remark, wh1_out_tran_dt,wh1_out_dt, wh1_out_pc, wh1_to, wh1_out_trucker, wh1_out_remark, wh2_in_tran_dt, wh2_in_dt, wh2_in_pc, wh2_in_trucker, wh2_from,wh2_in_remark, wh2_out_tran_dt, wh2_out_dt, wh2_out_pc, wh2_to, wh2_out_trucker, wh2_out_remark, dest_tran_dt, dest_from, dest_dt, dest_pc,dest_trucker, dest_remark, dest_close_remark, dest_close_dt, status FROM cargo_tracking AS cargo_tracking_1 where elt_account_number="&vSourceClient
			eltConn.Execute SQL				
		end if
	end if			

'//////////////////////////////// HAWB_master	
	tProc=Request("cTable36") 
	dProc=Request("cDelete36")
	cProc=Request("cCopy36")
	atProc(36)=tProc
	adProc(36)=dProc
	acProc(36)=cProc
	if ( tProc = "Y" or dProc = "Y" or cProc = "Y" ) then
		if ( tProc = "Y" or dProc = "Y") and ( not cProc = "Y" ) then
			SQL = "delete HAWB_master where elt_account_number=" & vTargetClient
			eltConn.Execute SQL	
		end if
	
		if ( tProc = "Y" or cProc = "Y" ) and ( not dProc = "Y" ) then
			SQL = "INSERT INTO HAWB_master (elt_account_number, HAWB_NUM, MAWB_NUM, DEP_AIRPORT_CODE, airline_vendor_num, Agent_Name, Agent_Info, Agent_No, Shipper_Name,Shipper_Info, ff_shipper_acct, Shipper_account_number, Consignee_Name, Consignee_Info, Consignee_acct_num, ff_consignee_acct,Agent_IATA_Code, Issue_Carrier_agent, Account_No, Departure_Airport, departure_state, IssuedBy, Account_Info, to_1, by_1, to_2, by_2, to_3, by_3,Currency, Charge_Code, PPO_1, COLL_1, PPO_2, COLL_2, Declared_Value_Carriage, Declared_Value_Customs, Dest_Airport, flight_no, Flight_Date_1,Flight_Date_2, export_date, Insurance_AMT, Handling_Info, dest_country, SCI, Total_Pieces, Adjusted_Weight, Total_Gross_Weight,Total_Chargeable_Weight, Weight_Scale, Total_Weight_Charge_HAWB, af_cost, agent_profit, agent_profit_share, other_agent_profit_carrier,other_agent_profit_agent, Total_Weight_Charge_ACCT, Total_Other_Charges, Prepaid_Weight_Charge, Collect_Weight_Charge,Prepaid_Valuation_Charge, Collect_Valuation_Charge, Prepaid_Tax, Collect_Tax, Prepaid_Due_Agent, Collect_Due_Agent, Prepaid_Due_Carrier,Collect_Due_Carrier, Prepaid_Unused, Collect_Unused, Prepaid_Total, Collect_Total, Signature, Date_Executed, Execution, Date_Last_Modified,Currency_Conv_Rate, CC_Charge_Dest_Rate, Charge_at_Dest, Total_Collect_Charge, Desc1, Desc2, manifest_desc, lc, ci, other_ref,           Show_Weight_Charge_Shipper, Show_Weight_Charge_Consignee, Show_Prepaid_Other_Charge_Shipper, Show_Collect_Other_Charge_Shipper,               Show_Prepaid_Other_Charge_Consignee, Prepaid_Invoiced, Collect_Invoiced, Show_Collect_Other_Charge_Consignee, colo, colo_pay,coloder_invoiced, coloder_elt_acct, Notify_no) SELECT     '"&vTargetClient&"', HAWB_NUM, MAWB_NUM, DEP_AIRPORT_CODE, airline_vendor_num, Agent_Name, Agent_Info, Agent_No, Shipper_Name,                      Shipper_Info, ff_shipper_acct, Shipper_account_number, Consignee_Name, Consignee_Info, Consignee_acct_num, ff_consignee_acct,                      Agent_IATA_Code, Issue_Carrier_agent, Account_No, Departure_Airport, departure_state, IssuedBy, Account_Info, to_1, by_1, to_2, by_2, to_3, by_3,                     Currency, Charge_Code, PPO_1, COLL_1, PPO_2, COLL_2, Declared_Value_Carriage, Declared_Value_Customs, Dest_Airport, flight_no, Flight_Date_1,                     Flight_Date_2, export_date, Insurance_AMT, Handling_Info, dest_country, SCI, Total_Pieces, Adjusted_Weight, Total_Gross_Weight,                      Total_Chargeable_Weight, Weight_Scale, Total_Weight_Charge_HAWB, af_cost, agent_profit, agent_profit_share, other_agent_profit_carrier,                      other_agent_profit_agent, Total_Weight_Charge_ACCT, Total_Other_Charges, Prepaid_Weight_Charge, Collect_Weight_Charge,                    Prepaid_Valuation_Charge, Collect_Valuation_Charge, Prepaid_Tax, Collect_Tax, Prepaid_Due_Agent, Collect_Due_Agent, Prepaid_Due_Carrier,                    Collect_Due_Carrier, Prepaid_Unused, Collect_Unused, Prepaid_Total, Collect_Total, Signature, Date_Executed, Execution, Date_Last_Modified,                      Currency_Conv_Rate, CC_Charge_Dest_Rate, Charge_at_Dest, Total_Collect_Charge, Desc1, Desc2, manifest_desc, lc, ci, other_ref,                     Show_Weight_Charge_Shipper, Show_Weight_Charge_Consignee, Show_Prepaid_Other_Charge_Shipper, Show_Collect_Other_Charge_Shipper,                     Show_Prepaid_Other_Charge_Consignee, Prepaid_Invoiced, Collect_Invoiced, Show_Collect_Other_Charge_Consignee, colo, colo_pay,                      coloder_invoiced, coloder_elt_acct, Notify_no FROM         HAWB_master AS HAWB_master_1 where elt_account_number="&vSourceClient
			
			eltConn.Execute SQL				
		end if
	end if				
	
'//////////////////////////////// hawb_Other_Charge	
	tProc=Request("cTable37") 
	dProc=Request("cDelete37")
	cProc=Request("cCopy37")
	atProc(37)=tProc
	adProc(37)=dProc
	acProc(37)=cProc
	if ( tProc = "Y" or dProc = "Y" or cProc = "Y" ) then
		if ( tProc = "Y" or dProc = "Y") and ( not cProc = "Y" ) then
			SQL = "delete hawb_Other_Charge where elt_account_number=" & vTargetClient
			eltConn.Execute SQL	
		end if
	
		if ( tProc = "Y" or cProc = "Y" ) and ( not dProc = "Y" ) then
			SQL = "INSERT INTO hawb_Other_Charge (elt_account_number, HAWB_NUM, Tran_No, Coll_Prepaid, Carrier_Agent, charge_code, Charge_Desc, Amt_HAWB, Amt_Acct, Cost_Amt, Vendor_Num) SELECT     '"&vTargetClient&"', HAWB_NUM, Tran_No, Coll_Prepaid, Carrier_Agent, charge_code, Charge_Desc, Amt_HAWB, Amt_Acct, Cost_Amt, Vendor_Num FROM         hawb_Other_Charge AS hawb_Other_Charge_1  where elt_account_number="&vSourceClient
			eltConn.Execute SQL				
		end if
	end if				
	
'//////////////////////////////// hawb_weight_charge	
	tProc=Request("cTable38") 
	dProc=Request("cDelete38")
	cProc=Request("cCopy38")
	atProc(38)=tProc
	adProc(38)=dProc
	acProc(38)=cProc
	if ( tProc = "Y" or dProc = "Y" or cProc = "Y" ) then
		if ( tProc = "Y" or dProc = "Y") and ( not cProc = "Y" ) then
			SQL = "delete hawb_weight_charge where elt_account_number=" & vTargetClient
			eltConn.Execute SQL	
		end if
	
		if ( tProc = "Y" or cProc = "Y" ) and ( not dProc = "Y" ) then
			SQL = "INSERT INTO hawb_weight_charge (elt_account_number, HAWB_NUM, Tran_No, No_Pieces, unit_qty, Gross_Weight, Adjusted_Weight, Kg_Lb, Service_Code, Rate_Class, Commodity_Item_No, length, width, height, Dimension, Dem_Detail, Chargeable_Weight, Rate_Charge, Total_Charge, Desc1, Desc2) SELECT     '"&vTargetClient&"', HAWB_NUM, Tran_No, No_Pieces, unit_qty, Gross_Weight, Adjusted_Weight, Kg_Lb, Service_Code, Rate_Class, Commodity_Item_No, length, width, height, Dimension, Dem_Detail, Chargeable_Weight, Rate_Charge, Total_Charge, Desc1, Desc2 FROM         hawb_weight_charge AS hawb_weight_charge_1 where elt_account_number="&vSourceClient
			eltConn.Execute SQL				
		end if
	end if				
	
'//////////////////////////////// MAWB_number	
	tProc=Request("cTable39") 
	dProc=Request("cDelete39")
	cProc=Request("cCopy39")
	atProc(39)=tProc
	adProc(39)=dProc
	acProc(39)=cProc
	if ( tProc = "Y" or dProc = "Y" or cProc = "Y" ) then
		if ( tProc = "Y" or dProc = "Y") and ( not cProc = "Y" ) then
			SQL = "delete MAWB_number where elt_account_number=" & vTargetClient
			eltConn.Execute SQL	
		end if
	
		if ( tProc = "Y" or cProc = "Y" ) and ( not dProc = "Y" ) then
			SQL = "INSERT INTO MAWB_NUMBER (elt_account_number, mawb_no, Carrier_Code, Carrier_Desc, scac, Flight#, File#, Created_Date, Origin_Port_ID, origin_port_aes_code,Origin_Port_Location, Origin_Port_State, Origin_Port_Country, Dest_Port_ID, dest_port_aes_code, Dest_Port_Location, Dest_Port_Country,      dest_country_code, [By], To_1, [To], By_1, To_2, By_2, Flight#2, Flight#1, ETD_DATE1, ETA_DATE1, ETD_DATE2, ETA_DATE2, Weight_Reserved,Weight_Scale, airline_staff, Status, used) SELECT     '"&vTargetClient&"', mawb_no, Carrier_Code, Carrier_Desc, scac, Flight#, File#, Created_Date, Origin_Port_ID, origin_port_aes_code,       Origin_Port_Location, Origin_Port_State, Origin_Port_Country, Dest_Port_ID, dest_port_aes_code, Dest_Port_Location, Dest_Port_Country,                     dest_country_code, [By], To_1, [To], By_1, To_2, By_2, Flight#2, Flight#1, ETD_DATE1, ETA_DATE1, ETD_DATE2, ETA_DATE2, Weight_Reserved,    Weight_Scale, airline_staff, Status, used FROM         MAWB_NUMBER AS MAWB_NUMBER_1 where elt_account_number="&vSourceClient
			eltConn.Execute SQL				
		end if
	end if				
	
'//////////////////////////////// MAWB_master	
	tProc=Request("cTable40") 
	dProc=Request("cDelete40")
	cProc=Request("cCopy40")
	atProc(40)=tProc
	adProc(40)=dProc
	acProc(40)=cProc
	if ( tProc = "Y" or dProc = "Y" or cProc = "Y" ) then
		if ( tProc = "Y" or dProc = "Y") and ( not cProc = "Y" ) then
			SQL = "delete MAWB_master where elt_account_number=" & vTargetClient
			eltConn.Execute SQL	
		end if
	
		if ( tProc = "Y" or cProc = "Y" ) and ( not dProc = "Y" ) then
			SQL = "INSERT INTO MAWB_MASTER (elt_account_number, MAWB_NUM, DEP_AIRPORT_CODE, master_agent, airline_vendor_num, Shipper_Name, Shipper_Info,       Shipper_account_number, ff_shipper_acct, Consignee_Name, Consignee_Info, Consignee_acct_num, ff_consignee_acct, Issue_Carrier_agent,                      Agent_IATA_Code, Account_No, Departure_Airport, IssuedBy, Account_Info, by_1, to_1, to_2, by_2, to_3, by_3, Currency, Charge_Code, PPO_1,COLL_1, PPO_2, COLL_2, Declared_Value_Carriage, Declared_Value_Customs, Dest_Airport, Flight_Date_1, Flight_Date_2, Insurance_AMT,Handling_Info, dest_country, SCI, Total_Pieces, Adjusted_Weight, Total_Gross_Weight, total_chargeable_weight, Weight_Scale, Total_Weight_Charge_HAWB, Total_Weight_Charge_ACCT, Total_Other_Charges, Prepaid_Weight_Charge, Collect_Weight_Charge, Prepaid_Valuation_Charge, Collect_Valuation_Charge, Prepaid_Tax, Collect_Tax, Prepaid_Due_Agent, Collect_Due_Agent, Prepaid_Due_Carrier,Collect_Due_Carrier, Prepaid_Unused, Collect_Unused, Prepaid_Total, Collect_Total, Signature, Date_Executed, Place_Executed, Execution,Date_Last_Modified, CC_Charge_Dest_Rate, Currency_Conv_Rate, Charge_at_Dest, Total_Collect_Charge, Desc1, Desc2,                      Show_Weight_Charge_Shipper, Show_Weight_Charge_Consignee, Show_Prepaid_Other_Charge_Shipper, Show_Collect_Other_Charge_Shipper,                      Show_Prepaid_Other_Charge_Consignee, Show_Collect_Other_Charge_Consignee, Invoiced, Notify_no) SELECT     '"&vTargetClient&"', MAWB_NUM, DEP_AIRPORT_CODE, master_agent, airline_vendor_num, Shipper_Name, Shipper_Info, Shipper_account_number,ff_shipper_acct, Consignee_Name, Consignee_Info, Consignee_acct_num, ff_consignee_acct, Issue_Carrier_agent, Agent_IATA_Code, Account_No,Departure_Airport, IssuedBy, Account_Info, by_1, to_1, to_2, by_2, to_3, by_3, Currency, Charge_Code, PPO_1, COLL_1, PPO_2, COLL_2,Declared_Value_Carriage, Declared_Value_Customs, Dest_Airport, Flight_Date_1, Flight_Date_2, Insurance_AMT, Handling_Info, dest_country, SCI,Total_Pieces, Adjusted_Weight, Total_Gross_Weight, total_chargeable_weight, Weight_Scale, Total_Weight_Charge_HAWB,Total_Weight_Charge_ACCT, Total_Other_Charges, Prepaid_Weight_Charge, Collect_Weight_Charge, Prepaid_Valuation_Charge,Collect_Valuation_Charge, Prepaid_Tax, Collect_Tax, Prepaid_Due_Agent, Collect_Due_Agent, Prepaid_Due_Carrier, Collect_Due_Carrier,Prepaid_Unused, Collect_Unused, Prepaid_Total, Collect_Total, Signature, Date_Executed, Place_Executed, Execution, Date_Last_Modified,CC_Charge_Dest_Rate, Currency_Conv_Rate, Charge_at_Dest, Total_Collect_Charge, Desc1, Desc2, Show_Weight_Charge_Shipper,                   Show_Weight_Charge_Consignee, Show_Prepaid_Other_Charge_Shipper, Show_Collect_Other_Charge_Shipper,Show_Prepaid_Other_Charge_Consignee, Show_Collect_Other_Charge_Consignee, Invoiced, Notify_no FROM         MAWB_MASTER AS MAWB_MASTER_1 where elt_account_number="&vSourceClient
			eltConn.Execute SQL				
		end if
	end if				
	
'//////////////////////////////// Mawb_Other_Charge	
	tProc=Request("cTable41") 
	dProc=Request("cDelete41")
	cProc=Request("cCopy41")
	atProc(41)=tProc
	adProc(41)=dProc
	acProc(41)=cProc
	if ( tProc = "Y" or dProc = "Y" or cProc = "Y" ) then
		if ( tProc = "Y" or dProc = "Y") and ( not cProc = "Y" ) then
			SQL = "delete Mawb_Other_Charge where elt_account_number=" & vTargetClient
			eltConn.Execute SQL	
		end if
	
		if ( tProc = "Y" or cProc = "Y" ) and ( not dProc = "Y" ) then
			SQL = "INSERT INTO MAWB_Other_Charge (elt_account_number, MAWB_NUM, Tran_No, Carrier_Agent, charge_code, Coll_Prepaid, Charge_Desc, Amt_MAWB, Amt_Acct, Vendor_Num, Cost_Amt) SELECT      '"&vTargetClient&"', MAWB_NUM, Tran_No, Carrier_Agent, charge_code, Coll_Prepaid, Charge_Desc, Amt_MAWB, Amt_Acct, Vendor_Num,Cost_Amt FROM         MAWB_Other_Charge AS MAWB_Other_Charge_1 where elt_account_number="&vSourceClient
			eltConn.Execute SQL				
		end if
	end if			
	
'//////////////////////////////// Mawb_weight_charge	
	tProc=Request("cTable42") 
	dProc=Request("cDelete42")
	cProc=Request("cCopy42")
	atProc(42)=tProc
	adProc(42)=dProc
	acProc(42)=cProc
	if ( tProc = "Y" or dProc = "Y" or cProc = "Y" ) then
		if ( tProc = "Y" or dProc = "Y") and ( not cProc = "Y" ) then
			SQL = "delete Mawb_weight_charge where elt_account_number=" & vTargetClient
			eltConn.Execute SQL	
		end if
	
		if ( tProc = "Y" or cProc = "Y" ) and ( not dProc = "Y" ) then
			SQL = "INSERT INTO MAWB_Weight_Charge (MAWB_NUM, elt_account_number, Tran_No, No_Pieces, Gross_Weight, Kg_Lb, Service_Code, Rate_Class, Commodity_Item_No, Dem_Detail,Chargeable_Weight, Rate_Charge, Total_Charge, Desc1, Desc2) SELECT     MAWB_NUM, '"&vTargetClient&"', Tran_No, No_Pieces, Gross_Weight, Kg_Lb, Service_Code, Rate_Class, Commodity_Item_No, Dem_Detail,Chargeable_Weight, Rate_Charge, Total_Charge, Desc1, Desc2 FROM         MAWB_Weight_Charge AS MAWB_Weight_Charge_1 where elt_account_number="&vSourceClient
			eltConn.Execute SQL				
		end if
	end if			
	
'//////////////////////////////// sed_detail	
	tProc=Request("cTable43") 
	dProc=Request("cDelete43")
	cProc=Request("cCopy43")
	atProc(43)=tProc
	adProc(43)=dProc
	acProc(43)=cProc
	if ( tProc = "Y" or dProc = "Y" or cProc = "Y" ) then
		if ( tProc = "Y" or dProc = "Y") and ( not cProc = "Y" ) then
			SQL = "delete sed_detail where elt_account_number=" & vTargetClient
			eltConn.Execute SQL	
		end if
	
		if ( tProc = "Y" or cProc = "Y" ) and ( not dProc = "Y" ) then
			SQL = "INSERT INTO sed_detail (elt_account_number, item_no, hawb_num, dfm, b_number, item_desc, b_qty1, unit1, b_qty2, unit2, gross_weight, vin, item_value, export_code,license_type) SELECT     '"&vTargetClient&"', item_no, hawb_num, dfm, b_number, item_desc, b_qty1, unit1, b_qty2, unit2, gross_weight, vin, item_value, export_code,license_type FROM         sed_detail AS sed_detail_1 where elt_account_number="&vSourceClient
			eltConn.Execute SQL				
		end if
	end if			

'//////////////////////////////// sed_master	
	tProc=Request("cTable44") 
	dProc=Request("cDelete44")
	cProc=Request("cCopy44")
	atProc(44)=tProc
	adProc(44)=dProc
	acProc(44)=cProc
	if ( tProc = "Y" or dProc = "Y" or cProc = "Y" ) then
		if ( tProc = "Y" or dProc = "Y") and ( not cProc = "Y" ) then
			SQL = "delete sed_master where elt_account_number=" & vTargetClient
			eltConn.Execute SQL	
		end if
	
		if ( tProc = "Y" or cProc = "Y" ) and ( not dProc = "Y" ) then
			SQL = "INSERT INTO sed_master(elt_account_number, HAWB_NUM, mawb_num, flight_no, shipper_acct, USPPI, usppi_contact_firstname, usppi_contact_lastname, USPPI_taxid,party_to_transaction, zip_code, export_date, tran_ref_no, consignee_acct, consignee_country_code, ulti_consignee, inter_consignee, forward_agent,origin_state, dest_country, loading_pier, tran_method, export_carrier, export_port, unloading_port, containerized, carrier_id_code, shipment_ref_no,entry_no, hazardous_materials, in_bond_code, route_export_tran, license_no, ECCN, duly, title, phone, email, tran_date, last_modified) SELECT     '"&vTargetClient&"', HAWB_NUM, mawb_num, flight_no, shipper_acct, USPPI, usppi_contact_firstname, usppi_contact_lastname, USPPI_taxid,party_to_transaction, zip_code, export_date, tran_ref_no, consignee_acct, consignee_country_code, ulti_consignee, inter_consignee, forward_agent,origin_state, dest_country, loading_pier, tran_method, export_carrier, export_port, unloading_port, containerized, carrier_id_code, shipment_ref_no,entry_no, hazardous_materials, in_bond_code, route_export_tran, license_no, ECCN, duly, title, phone, email, tran_date, last_modified FROM         sed_master AS sed_master_1 where elt_account_number="&vSourceClient
			eltConn.Execute SQL				
		end if
	end if			
	
'//////////////////////////////// hbol_master	
	tProc=Request("cTable45") 
	dProc=Request("cDelete45")
	cProc=Request("cCopy45")
	atProc(45)=tProc
	adProc(45)=dProc
	acProc(45)=cProc
	if ( tProc = "Y" or dProc = "Y" or cProc = "Y" ) then
		if ( tProc = "Y" or dProc = "Y") and ( not cProc = "Y" ) then
			SQL = "delete hbol_master where elt_account_number=" & vTargetClient
			eltConn.Execute SQL	
		end if
	
		if ( tProc = "Y" or cProc = "Y" ) and ( not dProc = "Y" ) then
			SQL = "INSERT INTO hbol_master  (elt_account_number, hbol_num, booking_num, agent_info, mbol_num, agent_name, agent_no, forward_agent_name, forward_agent_info,forward_agent_acct_num, Shipper_Name, Shipper_Info, Shipper_acct_num, Consignee_Name, Consignee_Info, Consignee_acct_num, export_ref,origin_country, dest_country, loading_pier, export_instr, move_type, containerized, pre_carriage, pre_receipt_place, export_carrier, loading_port,unloading_port, vessel_name, departure_date, delivery_place, desc2, desc1, desc3, desc4, desc5, manifest_desc, weight_cp, prepaid_other_charge,collect_other_charge, pieces, scale, gross_weight, measurement, width, length, height, dem_detail, charge_rate, total_weight_charge,Show_Prepaid_Weight_Charge, Show_Collect_Weight_Charge, Show_Prepaid_Other_Charge, Show_Collect_Other_Charge, declared_value, tran_by,tran_date, tran_place, last_modified, prepaid_invoiced, collect_invoiced, ci, Notify_Name, Notify_Info, Notify_acct_num, unit_qty) SELECT      '"&vTargetClient&"', hbol_num, booking_num, agent_info, mbol_num, agent_name, agent_no, forward_agent_name, forward_agent_info,forward_agent_acct_num, Shipper_Name, Shipper_Info, Shipper_acct_num, Consignee_Name, Consignee_Info, Consignee_acct_num, export_ref,origin_country, dest_country, loading_pier, export_instr, move_type, containerized, pre_carriage, pre_receipt_place, export_carrier, loading_port,unloading_port, vessel_name, departure_date, delivery_place, desc2, desc1, desc3, desc4, desc5, manifest_desc, weight_cp, prepaid_other_charge,collect_other_charge, pieces, scale, gross_weight, measurement, width, length, height, dem_detail, charge_rate, total_weight_charge,Show_Prepaid_Weight_Charge, Show_Collect_Weight_Charge, Show_Prepaid_Other_Charge, Show_Collect_Other_Charge, declared_value, tran_by,tran_date, tran_place, last_modified, prepaid_invoiced, collect_invoiced, ci, Notify_Name, Notify_Info, Notify_acct_num, unit_qty FROM         hbol_master AS hbol_master_1 where elt_account_number="&vSourceClient
			eltConn.Execute SQL				
		end if
	end if			
	
'//////////////////////////////// hbol_other_charge	
	tProc=Request("cTable46") 
	dProc=Request("cDelete46")
	cProc=Request("cCopy46")
	atProc(46)=tProc
	adProc(46)=dProc
	acProc(46)=cProc
	if ( tProc = "Y" or dProc = "Y" or cProc = "Y" ) then
		if ( tProc = "Y" or dProc = "Y") and ( not cProc = "Y" ) then
			SQL = "delete hbol_other_charge where elt_account_number=" & vTargetClient
			eltConn.Execute SQL	
		end if
	
		if ( tProc = "Y" or cProc = "Y" ) and ( not dProc = "Y" ) then
			SQL = "INSERT INTO hbol_other_charge (elt_account_number, hbol_num, tran_no, Coll_Prepaid, charge_code, charge_desc, charge_amt, vendor_num, cost_amt) SELECT     '"&vTargetClient&"', hbol_num, tran_no, Coll_Prepaid, charge_code, charge_desc, charge_amt, vendor_num, cost_amt FROM         hbol_other_charge AS hbol_other_charge_1 where elt_account_number="&vSourceClient
			eltConn.Execute SQL				
		end if
	end if				
	
'//////////////////////////////// mbol_master	
	tProc=Request("cTable47") 
	dProc=Request("cDelete47")
	cProc=Request("cCopy47")
	atProc(47)=tProc
	adProc(47)=dProc
	acProc(47)=cProc
	if ( tProc = "Y" or dProc = "Y" or cProc = "Y" ) then
		if ( tProc = "Y" or dProc = "Y") and ( not cProc = "Y" ) then
			SQL = "delete mbol_master where elt_account_number=" & vTargetClient
			eltConn.Execute SQL	
		end if
	
		if ( tProc = "Y" or cProc = "Y" ) and ( not dProc = "Y" ) then
			SQL = "INSERT INTO mbol_master (elt_account_number, booking_num, mbol_num, agent_name, agent_info, agent_acct_num, Shipper_Name, Shipper_Info, Shipper_acct_num,Consignee_Name, Consignee_Info, Consignee_acct_num, export_ref, origin_country, export_instr, move_type, loading_pier, containerized,pre_carriage, pre_receipt_place, export_carrier, loading_port, unloading_port, departure_date, delivery_place, desc1, desc2, desc3, desc4, desc5,pieces, gross_weight, measurement, tran_date, last_modified, Notify_Name, Notify_Info, Notify_acct_num, dest_country, manifest_desc, vessel_name,weight_cp, prepaid_other_charge, collect_other_charge, scale, length, height, width, dem_detail, charge_rate, total_weight_charge, declared_value,tran_by, tran_place, prepaid_invoiced, collect_invoiced, ci, unit_qty) SELECT      '"&vTargetClient&"', booking_num, mbol_num, agent_name, agent_info, agent_acct_num, Shipper_Name, Shipper_Info, Shipper_acct_num,Consignee_Name, Consignee_Info, Consignee_acct_num, export_ref, origin_country, export_instr, move_type, loading_pier, containerized,pre_carriage, pre_receipt_place, export_carrier, loading_port, unloading_port, departure_date, delivery_place, desc1, desc2, desc3, desc4, desc5,pieces, gross_weight, measurement, tran_date, last_modified, Notify_Name, Notify_Info, Notify_acct_num, dest_country, manifest_desc, vessel_name,weight_cp, prepaid_other_charge, collect_other_charge, scale, length, height, width, dem_detail, charge_rate, total_weight_charge, declared_value,tran_by, tran_place, prepaid_invoiced, collect_invoiced, ci, unit_qty FROM         mbol_master where elt_account_number="&vSourceClient
			eltConn.Execute SQL				
		end if
	end if				

'//////////////////////////////// mbol_other_charge	
	tProc=Request("cTable48") 
	dProc=Request("cDelete48")
	cProc=Request("cCopy48")
	atProc(48)=tProc
	adProc(48)=dProc
	acProc(48)=cProc
	if ( tProc = "Y" or dProc = "Y" or cProc = "Y" ) then
		if ( tProc = "Y" or dProc = "Y") and ( not cProc = "Y" ) then
			SQL = "delete mbol_other_charge where elt_account_number=" & vTargetClient
			eltConn.Execute SQL	
		end if
	
		if ( tProc = "Y" or cProc = "Y" ) and ( not dProc = "Y" ) then
			SQL = "INSERT INTO mbol_other_charge (elt_account_number, booking_num, tran_no, mbol_num, Coll_Prepaid, charge_code, charge_desc, charge_amt, vendor_num, cost_amt) SELECT     '"&vTargetClient&"', booking_num, tran_no, mbol_num, Coll_Prepaid, charge_code, charge_desc, charge_amt, vendor_num, cost_amt FROM         mbol_other_charge AS mbol_other_charge_1 where elt_account_number="&vSourceClient
			eltConn.Execute SQL				
		end if
	end if				
	
'//////////////////////////////// ocean_booking_number	
	tProc=Request("cTable49") 
	dProc=Request("cDelete49")
	cProc=Request("cCopy49")
	atProc(49)=tProc
	adProc(49)=dProc
	acProc(49)=cProc
	if ( tProc = "Y" or dProc = "Y" or cProc = "Y" ) then
		if ( tProc = "Y" or dProc = "Y") and ( not cProc = "Y" ) then
			SQL = "delete ocean_booking_number where elt_account_number=" & vTargetClient
			eltConn.Execute SQL	
		end if
	
		if ( tProc = "Y" or cProc = "Y" ) and ( not dProc = "Y" ) then
			SQL = "INSERT INTO ocean_booking_number (elt_account_number, booking_num, mbol_num, departure_date, arrival_date, receipt_place, origin_port_id, origin_port_aes_code, origin_port_location,origin_port_state, origin_port_country, dest_port_id, dest_port_aes_code, dest_port_location, dest_port_country, dest_country_code, delivery_place,carrier_desc, carrier_code, scac, consolidator_name, consolidator_code, voyage_no, vsl_name, move_type, cutoff_time, cutoff, fcl_lcl, container_type,file_no, status) SELECT  '"&vTargetClient&"', booking_num, mbol_num, departure_date, arrival_date, receipt_place, origin_port_id, origin_port_aes_code, origin_port_location,origin_port_state, origin_port_country, dest_port_id, dest_port_aes_code, dest_port_location, dest_port_country, dest_country_code, delivery_place,carrier_desc, carrier_code, scac, consolidator_name, consolidator_code, voyage_no, vsl_name, move_type, cutoff_time, cutoff, fcl_lcl, container_type,file_no, status FROM         ocean_booking_number AS ocean_booking_number_1 where elt_account_number="&vSourceClient
			eltConn.Execute SQL				
		end if
	end if				

'//////////////////////////////// Ocean_sed_detail	
	tProc=Request("cTable50") 
	dProc=Request("cDelete50")
	cProc=Request("cCopy50")
	atProc(50)=tProc
	adProc(50)=dProc
	acProc(50)=cProc
	if ( tProc = "Y" or dProc = "Y" or cProc = "Y" ) then
		if ( tProc = "Y" or dProc = "Y") and ( not cProc = "Y" ) then
			SQL = "delete Ocean_sed_detail where elt_account_number=" & vTargetClient
			eltConn.Execute SQL	
		end if
	
		if ( tProc = "Y" or cProc = "Y" ) and ( not dProc = "Y" ) then
			SQL = "INSERT INTO Ocean_sed_detail (elt_account_number, hbol_num, item_no, dfm, b_number, b_qty1, unit1, b_qty2, unit2, gross_weight, vin, item_value, export_code, license_type,item_desc) SELECT     '"&vTargetClient&"', hbol_num, item_no, dfm, b_number, b_qty1, unit1, b_qty2, unit2, gross_weight, vin, item_value, export_code, license_type, item_desc FROM         Ocean_sed_detail AS Ocean_sed_detail_1 where elt_account_number="&vSourceClient
			eltConn.Execute SQL				
		end if
	end if				

'//////////////////////////////// ocean_sed_master	
	tProc=Request("cTable51") 
	dProc=Request("cDelete51")
	cProc=Request("cCopy51")
	atProc(51)=tProc
	adProc(51)=dProc
	acProc(51)=cProc
	if ( tProc = "Y" or dProc = "Y" or cProc = "Y" ) then
		if ( tProc = "Y" or dProc = "Y") and ( not cProc = "Y" ) then
			SQL = "delete ocean_sed_master where elt_account_number=" & vTargetClient
			eltConn.Execute SQL	
		end if
	
		if ( tProc = "Y" or cProc = "Y" ) and ( not dProc = "Y" ) then
			SQL = "INSERT INTO ocean_sed_master (elt_account_number, hbol_num, booking_num, shipper_acct, USPPI, USPPI_taxid, usppi_contact_firstname, usppi_contact_lastname,party_to_transaction, zip_code, export_date, tran_ref_no, consignee_acct, ulti_consignee, inter_consignee, forward_agent, origin_state, dest_country,loading_pier, export_carrier, tran_method, vessel_name, export_port, unloading_port, containerized, carrier_id_code, shipment_ref_no, entry_no,hazardous_materials, in_bond_code, route_export_tran, license_no, ECCN, duly, title, phone, email, tran_date, last_modified) SELECT      '"&vTargetClient&"', hbol_num, booking_num, shipper_acct, USPPI, USPPI_taxid, usppi_contact_firstname, usppi_contact_lastname,party_to_transaction, zip_code, export_date, tran_ref_no, consignee_acct, ulti_consignee, inter_consignee, forward_agent, origin_state, dest_country,loading_pier, export_carrier, tran_method, vessel_name, export_port, unloading_port, containerized, carrier_id_code, shipment_ref_no, entry_no,hazardous_materials, in_bond_code, route_export_tran, license_no, ECCN, duly, title, phone, email, tran_date, last_modified FROM ocean_sed_master AS ocean_sed_master_1 where elt_account_number="&vSourceClient
			eltConn.Execute SQL				
		end if
	end if				
	
'//////////////////////////////// import_hawb	
	tProc=Request("cTable52") 
	dProc=Request("cDelete52")
	cProc=Request("cCopy52")
	atProc(52)=tProc
	adProc(52)=dProc
	acProc(52)=cProc
	if ( tProc = "Y" or dProc = "Y" or cProc = "Y" ) then
		if ( tProc = "Y" or dProc = "Y") and ( not cProc = "Y" ) then
			SQL = "delete import_hawb where elt_account_number=" & vTargetClient
			eltConn.Execute SQL	
		end if
	
		if ( tProc = "Y" or cProc = "Y" ) and ( not dProc = "Y" ) then
SQL = "INSERT INTO import_hawb (elt_account_number, agent_elt_acct, agent_org_acct, tran_dt, iType, mawb_num, hawb_num, sec, invoice_no, process_dt, processed, shipper_name,shipper_info, shipper_acct, consignee_name, consignee_info, consignee_acct, notify_name, notify_info, notify_acct, broker_info, broker_acct, pieces,uom, gross_wt, scale1, chg_wt, scale2, prepaid_collect, freight_collect, oc_collect, prepared_by, sub_mawb1, sub_mawb2, customer_ref,delivery_place, etd2, eta2,container_location, destination, free_date, go_date, it_number, it_date, it_entry_port, cargo_location, desc1, desc2, desc3,desc4, desc5, remarks, term,pickup_date, igSub_HAWB, SalesPerson, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, fc_rate, fc_charge,total_other_charge, dep_code, arr_code, is_default_rate) SELECT '"&vTargetClient&"', agent_elt_acct, agent_org_acct, tran_dt, iType, mawb_num, hawb_num, sec, invoice_no, process_dt, processed, shipper_name,shipper_info, shipper_acct, consignee_name, consignee_info, consignee_acct, notify_name, notify_info, notify_acct, broker_info, broker_acct, pieces,uom, gross_wt, scale1, chg_wt, scale2, prepaid_collect, freight_collect, oc_collect, prepared_by, sub_mawb1, sub_mawb2, customer_ref,delivery_place, etd2, eta2, container_location, destination, free_date, go_date, it_number, it_date, it_entry_port, cargo_location, desc1, desc2, desc3,desc4, desc5, remarks, term, pickup_date, igSub_HAWB, SalesPerson, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, fc_rate, fc_charge,total_other_charge, dep_code, arr_code, is_default_rate FROM import_hawb AS import_hawb_1 where elt_account_number="&vSourceClient
			eltConn.Execute SQL				
		SQL = "INSERT INTO mb_cost_item (elt_account_number, mb_no, item_id, item_no, item_desc, qty, ref_no, cost_amount, vendor_no, iType, lock_ap) SELECT     '"&vTargetClient&"', mb_no, item_id, item_no, item_desc, qty, ref_no, cost_amount, vendor_no, iType, lock_ap FROM         mb_cost_item AS mb_cost_item_1 where elt_account_number="&vSourceClient
		end if
	end if				
	
'//////////////////////////////// import_mawb	
	tProc=Request("cTable53") 
	dProc=Request("cDelete53")
	cProc=Request("cCopy53")
	atProc(53)=tProc
	adProc(53)=dProc
	acProc(53)=cProc
	if ( tProc = "Y" or dProc = "Y" or cProc = "Y" ) then
		if ( tProc = "Y" or dProc = "Y") and ( not cProc = "Y" ) then
			SQL = "delete import_mawb where elt_account_number=" & vTargetClient
			eltConn.Execute SQL	
		end if
	
		if ( tProc = "Y" or cProc = "Y" ) and ( not dProc = "Y" ) then
SQL = "INSERT INTO import_mawb (elt_account_number, agent_elt_acct, export_agent_name, agent_org_acct, tran_dt, iType, mawb_num, sec, sub_mawb, process_dt, processed, carrier,vessel_name, file_no, voyage_no, flt_no, etd, eta, dep_port, arr_port, cargo_location, last_free_date, pieces, scale1, gross_wt, scale2, chg_wt, scale3, agent_debit_no, agent_debit_amt, it_number, it_date, it_entry_port, place_of_delivery, SalesPerson, CreatedBy, CreatedDate, ModifiedBy,ModifiedDate, dep_code, arr_code, carrier_code) SELECT     '"&vTargetClient&"', agent_elt_acct, export_agent_name, agent_org_acct, tran_dt, iType, mawb_num, sec, sub_mawb, process_dt, processed, carrier,vessel_name, file_no, voyage_no, flt_no, etd, eta, dep_port, arr_port, cargo_location, last_free_date, pieces, scale1, gross_wt, scale2, chg_wt, scale3,agent_debit_no, agent_debit_amt, it_number, it_date, it_entry_port, place_of_delivery, SalesPerson, CreatedBy, CreatedDate, ModifiedBy,ModifiedDate, dep_code, arr_code, carrier_code FROM import_mawb AS import_mawb_1 where elt_account_number="&vSourceClient
			eltConn.Execute SQL				
		end if
	end if				

'///////////////////////	
End sub
%>

<%
Sub get_elt_account_list_for_source
SQL= "SELECT * from agent order by elt_account_number"
rs.Open SQL, eltConn, , , adCmdText
sIndex = 0
Do While Not rs.EOF 
	aEltAccount(sIndex)=rs("elt_account_number")
	aEltAccountName(sIndex)=aEltAccount(sIndex) & " ---- " & rs("dba_name")
	sIndex=sIndex+1
	rs.MoveNext
Loop	
rs.Close
End Sub
%>

<%
Sub get_elt_account_list_for_target
SQL= "SELECT * from agent where ISNULL(account_statue,'')='' OR account_statue='T' order by elt_account_number"

rs.Open SQL, eltConn, , , adCmdText
aIndex = 0
Do While Not rs.EOF 
	aEltAccountTar(aIndex)=rs("elt_account_number")
	aEltAccountNameTar(aIndex)=aEltAccountTar(aIndex) & " ---- " & rs("dba_name")
	aIndex=aIndex+1
	rs.MoveNext
Loop	
rs.Close
End Sub
%>

<%
Sub get_table_list
'// Master
aTable(0) =  TABLE_colo	
aTable(1) =  TABLE_greetMessage
aTable(2) =  TABLE_user_files
aTable(3) =  TABLE_user_prefix
aTable(4) =  TABLE_user_profile
aTable(5) =  TABLE_flight_no
aTable(6) =  TABLE_freight_location
aTable(7) =  TABLE_agent_rate
aTable(8) =  TABLE_all_rate
aTable(9) =  TABLE_country_code
aTable(10) =  TABLE_scheduleB
aTable(11) =  TABLE_ig_schedule_b
aTable(12) =  TABLE_organization
aTable(13) =  TABLE_ig_org_comments
aTable(14) =  TABLE_ig_org_contact
aTable(15) =  TABLE_port
'// Accounting
aTable(16) =  TABLE_invoice
aTable(17) =  TABLE_invoice_charge_item
aTable(18) =  TABLE_invoice_cost_item
aTable(19) =  TABLE_invoice_detail
aTable(20) =  TABLE_invoice_hawb
aTable(21) =  TABLE_invoice_queue
aTable(22) =  TABLE_bill
aTable(23) =  TABLE_bill_detail
aTable(24) =  TABLE_check_detail
aTable(25) =  TABLE_check_queue
aTable(26) =  TABLE_gl
aTable(27) =  TABLE_all_accounts_journal
aTable(28) =  TABLE_general_journal_entry
aTable(29) =  TABLE_customer_balance
aTable(30) =  TABLE_customer_credits
aTable(31) =  TABLE_customer_payment
aTable(32) =  TABLE_customer_payment_detail
aTable(33) =  TABLE_item_charge
aTable(34) =  TABLE_item_cost
'// Air Export
aTable(35) =  TABLE_cargo_tracking
aTable(36) =  TABLE_HAWB_master
aTable(37) =  TABLE_hawb_Other_Charge
aTable(38) =  TABLE_hawb_weight_charge
aTable(39) =  TABLE_MAWB_number
aTable(40) =  TABLE_MAWB_master
aTable(41) =  TABLE_Mawb_Other_Charge
aTable(42) =  TABLE_Mawb_weight_charge
aTable(43) =  TABLE_sed_detail
aTable(44) =  TABLE_sed_master

'// Ocean Export
aTable(45) =  TABLE_hbol_master
aTable(46) =  TABLE_hbol_other_charge
aTable(47) =  TABLE_mbol_master
aTable(48) =  TABLE_mbol_other_charge
aTable(49) =  TABLE_ocean_booking_number
aTable(50) =  TABLE_Ocean_sed_detail
aTable(51) =  TABLE_ocean_sed_master
'// Import
aTable(52) =  TABLE_import_hawb
aTable(53) =  TABLE_import_mawb
aTable(54) =  TABLE_ig_ocean_ams_edi_header
aTable(55) =  TABLE_ig_ocean_ams_edi_item

'// Master
aTableDesc(0) =  TABLE_DESC_colo	
aTableDesc(1) =  TABLE_DESC_greetMessage
aTableDesc(2) =  TABLE_DESC_user_files
aTableDesc(3) =  TABLE_DESC_user_prefix
aTableDesc(4) =  TABLE_DESC_user_profile
aTableDesc(5) =  TABLE_DESC_flight_no
aTableDesc(6) =  TABLE_DESC_freight_location
aTableDesc(7) =  TABLE_DESC_agent_rate
aTableDesc(8) =  TABLE_DESC_all_rate
aTableDesc(9) =  TABLE_DESC_country_code
aTableDesc(10) =  TABLE_DESC_scheduleB
aTableDesc(11) =  TABLE_DESC_ig_schedule_b
aTableDesc(12) =  TABLE_DESC_organization
aTableDesc(13) =  TABLE_DESC_ig_org_comments
aTableDesc(14) =  TABLE_DESC_ig_org_contact
aTableDesc(15) =  TABLE_DESC_port
'// Accounting
aTableDesc(16) =  TABLE_DESC_invoice
aTableDesc(17) =  TABLE_DESC_invoice_charge_item
aTableDesc(18) =  TABLE_DESC_invoice_cost_item
aTableDesc(19) =  TABLE_DESC_invoice_detail
aTableDesc(20) =  TABLE_DESC_invoice_hawb
aTableDesc(21) =  TABLE_DESC_invoice_queue
aTableDesc(22) =  TABLE_DESC_bill
aTableDesc(23) =  TABLE_DESC_bill_detail
aTableDesc(24) =  TABLE_DESC_check_detail
aTableDesc(25) =  TABLE_DESC_check_queue
aTableDesc(26) =  TABLE_DESC_gl
aTableDesc(27) =  TABLE_DESC_all_accounts_journal
aTableDesc(28) =  TABLE_DESC_general_journal_entry
aTableDesc(29) =  TABLE_DESC_customer_balance
aTableDesc(30) =  TABLE_DESC_customer_credits
aTableDesc(31) =  TABLE_DESC_customer_payment
aTableDesc(32) =  TABLE_DESC_customer_payment_detail
aTableDesc(33) =  TABLE_DESC_item_charge
aTableDesc(34) =  TABLE_DESC_item_cost
'// Air Export
aTableDesc(35) =  TABLE_DESC_cargo_tracking
aTableDesc(36) =  TABLE_DESC_HAWB_master
aTableDesc(37) =  TABLE_DESC_hawb_Other_Charge
aTableDesc(38) =  TABLE_DESC_hawb_weight_charge
aTableDesc(39) =  TABLE_DESC_MAWB_number
aTableDesc(40) =  TABLE_DESC_MAWB_master
aTableDesc(41) =  TABLE_DESC_Mawb_Other_Charge
aTableDesc(42) =  TABLE_DESC_Mawb_weight_charge
aTableDesc(43) =  TABLE_DESC_sed_detail
aTableDesc(44) =  TABLE_DESC_sed_master

'// Ocean Export
aTableDesc(45) =  TABLE_DESC_hbol_master
aTableDesc(46) =  TABLE_DESC_hbol_other_charge
aTableDesc(47) =  TABLE_DESC_mbol_master
aTableDesc(48) =  TABLE_DESC_mbol_other_charge
aTableDesc(49) =  TABLE_DESC_ocean_booking_number
aTableDesc(50) =  TABLE_DESC_Ocean_sed_detail
aTableDesc(51) =  TABLE_DESC_ocean_sed_master
'// Import
aTableDesc(52) =  TABLE_DESC_import_hawb
aTableDesc(53) =  TABLE_DESC_import_mawb
'aTableDesc(54) =  TABLE_DESC_ig_ocean_ams_edi_header
'aTableDesc(55) =  TABLE_DESC_ig_ocean_ams_edi_item
tIndex = 54

End sub
%>

<%
Set rs=Nothing
eltConn.Close
Set eltConn=Nothing
%>

<body link="336699" vlink="336699" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0"bgcolor="73beb6">
  <tr> 
    <td> 
      <form name=form1 method="POST">
	  	<input type="hidden" name="hNoItem" value="<%= tIndex %>">
        <table width="100%" border="0" cellpadding="2" cellspacing="1">
          <tr bgcolor="#73beb6"> 
            <td colspan="6" height="8" align="left" valign="top" class="bodyheader"></td>
          </tr>
          <tr align="left" valign="middle" bgcolor="#FFFFFF">
            <td colspan="6" class="bodyheader">Soruce <select name="lstSourceELT" size="1" class="smallselect" style="WIDTH: 500px"> 
          <option value=0>Select One</option>
          <% for i=0 to sIndex-1 %>
		  
          <option value="<%= aEltAccount(i) %>" <% if cLng(vSourceClient) = cLng(aEltAccount(i)) then response.write("selected") %> ><%= aEltAccountNAme(i) %></option>
          <% next %>
        </select></td>
          </tr>
          <tr align="left" valign="middle" bgcolor="#FFFFFF">
            <td colspan="6" class="bodyheader">Target <select name="lstTargetELT" size="1" class="smallselect" style="WIDTH: 500px"> 
          <option value=0>Select One</option>
          <% for i=0 to aIndex-1 %>
          <option value="<%= aEltAccountTar(i) %>" <% if cLng(vTargetClient) = cLng(aEltAccountTar(i)) then response.write("selected") %> ><%= aEltAccountNameTar(i) %></option>
          <% next %>
        </select>
            <span class="bodycopy"><img src="../images/button_go.gif" width="31" height="18" onClick="GoClick()"></span></td>
          </tr>
          
          <tr align="left" valign="middle" bgcolor="73beb6"> 
            <td colspan="6" height="1" class="bodyheader"></td>
          </tr>
          <tr align="left" valign="middle" bgcolor="ecf7f8"> 
            <td width="89" height="20" bgcolor="ccebed" class="bodyheader">Category</td>
            <td width="143" height="20" bgcolor="ccebed"><span class="bodyheader">Delete Target and Copy </span></td>
            <td width="188" bgcolor="ccebed" class="bodyheader">Table Name </td>
            <td width="361" bgcolor="ccebed" class="bodyheader">&nbsp;</td>
            <td width="310" bgcolor="ccebed" class="bodyheader">Delete Only </td>
            <td width="66" bgcolor="ccebed" class="bodyheader">&nbsp;</td>
          </tr>
          <input type=hidden id="cTable">
          <input type=hidden id="cDelete">
          <input type=hidden id="cCopy">

          <tr align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
            <td></td>
            <td><img src="../images/button_selectall.GIF" width="61" height="17" name="bSelectAll" OnClick="SelectAllClick('cTable')">&nbsp;<img src="../images/button_clear.gif" width="56" height="17" name="bSelectAll" OnClick="ClearAllClick('cTable')"></td>
            <td>&nbsp;</td>
            <td bgcolor="#FFFFFF">&nbsp;</td>
            <td bgcolor="#FFFFFF">&nbsp;<img src="../images/button_selectall.GIF" width="61" height="17" name="bSelectAll" onClick="SelectAllClick('cDelete')"><img src="../images/button_clear.gif" width="56" height="17" name="bSelectAll" onClick="ClearAllClick('cDelete')"></td>
            <td bgcolor="#FFFFFF"><img src="../images/button_selectall.GIF" width="1" height="17" name="bSelectAll" onClick="SelectAllClick('cCopy')" style="visibility:hidden" ><img src="../images/button_clear.gif" width="1" height="17" name="bSelectAll" onClick="ClearAllClick('cCopy')" style="visibility:hidden" ></td>
          </tr>
          <% for i=0 to tIndex-1 %>		  
			<% 
			dim bgcolor
			if i = 0 then 
				bgcolor = "#ecf7f8"
			elseif i = 16 then 
				bgcolor = "#E7F0E2"
			elseif i = 35 then 
				bgcolor = "#E5D4E3"
			elseif i = 45 then 
				bgcolor = "#BFD0C9"
			elseif i = 52 then 
				bgcolor = "#FFFFF5"
			end if
			%>
          <tr align="left" valign="middle" bgcolor="<%=bgcolor%>" class="bodycopy"> 
            <td width="89" bgcolor="<%=bgcolor%>" class="bodyheader">
			<% 
			if i = 0 then 
				response.write ("Master")
			elseif i = 16 then 
				response.write ("Accounting")
			elseif i = 35 then 
				response.write ("Air Export")										
			elseif i = 45 then 
				response.write ("Ocean Export")										
			elseif i = 52 then 
				response.write ("Import")										
			end if
			%>			</td>
            <td> <input type="checkbox" id="cTable" name="cTable<%= i %>" value="Y" <% if  atProc(i) = "Y" then response.write("checked")%> ><% 'response.write i%> </td>
            <td><b><%response.write (aTable(i))%></b></td>
            <td><%response.write (aTableDesc(i))%></td>
            <td><input type="checkbox" id="cDelete" name="cDelete<%= i %>" value="Y" <% if  adProc(i) = "Y" then response.write("checked")%>></td>
            <td><input type="hidden" id="cCopy" name="cCopy<%= i %>" value="" <% if  acProc(i) = "Y" then response.write("checked")%>></td>
          </tr>
          <% next %>
          
          <tr align="center" bgcolor="ccebed"> 
            <td height="22" colspan="6" valign="middle" class="bodycopy"><img src="../images/button_go.gif" width="31" height="18" onClick="GoClick()"></td>
          </tr>
        </table>
      </form></td>
  </tr>
</table>
</body>
<script language="VBScript">
<!--
Sub GoClick()

Dim sIndex1,sIndex2
sIndex1 = Document.form1.lstSourceELT.Selectedindex
sIndex2 = Document.form1.lstTargetELT.Selectedindex

if ( sIndex1 = 0 or sIndex2 = 0 ) then
	msgbox "Please select Source and Target ELT ACCOUNT."
	exit sub
end if


if ( sIndex1 = sIndex2 ) then
	msgbox "Target ELT ACCOUNT must be different from source ELT ACCOUNT."
	exit sub
end if

Dim Table,iCntT,iCntD,iCntC
iCntT = 0
iCntD = 0
iCntC = 0
NoItem=cInt(document.form1.hNoItem.Value)

for j=1 to NoItem
	if document.all("cTable").item(j).checked=true then
		iCntT=iCntT+1
	end if
	if document.all("cDelete").item(j).checked=true then
		iCntD=iCntD+1
	end if
	if document.all("cCopy").item(j).checked=true then
		iCntC=iCntC+1
	end if	
	
next

if iCntT>0 or iCntD > 0 or iCntC > 0 then
	document.form1.action="elt_account_copy.asp?Copy=yes"
	document.form1.method="POST"
	form1.submit()
else
	msgbox "No item was selected."
end if
End Sub

Sub SelectAllClick(obj)
Dim aItem(128)
NoItem=cInt(document.form1.hNoItem.Value)
for j=1 to NoItem
	document.all(obj).item(j).checked=true
next
End Sub
Sub ClearAllClick(obj)
Dim aItem(128)
NoItem=cInt(document.form1.hNoItem.Value)
for j=1 to NoItem
	document.all(obj).item(j).checked=false
next
End Sub
-->
</script>
</html>
