<!--  #INCLUDE FILE="../include/transaction.txt" -->
<% 
    Option Explicit
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<!--  #INCLUDE VIRTUAL="/ASP/include/connection.asp" -->
<!--  #INCLUDE VIRTUAL="/ASP/include/AspFunctions.inc" -->
<!--  #INCLUDE FILE="../master_data/client_profile_declaration.inc" -->
<!--  #INCLUDE VIRTUAL="/ASP/include/GOOFY_Util_fun.inc" -->
<%  
    Response.Expires = 0  
    Response.AddHeader "Pragma","no-cache"  
    Response.AddHeader "Cache-Control","no-cache,must-revalidate"  


	Action = Request.QueryString("Action")
	if isnull(Action) then
		response.write "e"
		response.end
	end if

    DIM elt_account_number,login_name,UserRight
    Dim Action	

	elt_account_number = Request.Cookies("CurrentUserInfo")("elt_account_number")
	login_name = Request.Cookies("CurrentUserInfo")("login_name")
	UserRight = Request.Cookies("CurrentUserInfo")("user_right")	

	call get_queryString
	call get_db_field
	select case Action
		case "save" 
			 modify_dba()					 
		case "del"
			 v_org_account_number = Request.Querystring("org")
			 if isnull(v_org_account_number) then v_org_account_number = ""
			 if v_org_account_number <> "" then
				delete_org(v_org_account_number)
			 else
				response.write "error #3"
				response.end
			 end if
	end select
	
	eltConn.Close
	Set eltConn = Nothing		
%>
<!--  #INCLUDE FILE="ajax_dba_modify_debug.inc" -->
<%	
sub modify_dba()
'	call org_save_debug
	if isnull(v_org_account_number) or v_org_account_number = "" then
		v_org_account_number = ""
	end if
	v_org_account_number = trim(v_org_account_number)

	if v_org_account_number = "" then
		call save_dba_new()
	else
		call save_dba_update(v_org_account_number)
	end if
	create_new_codes()
	if v_is_coloader =  "Y" then
		call register_colo(v_org_account_number)
	end if
end sub
%>
<%
sub register_colo(orgNum)
	DIM rs,SQL
	SQL = "DELETE colo where coloder_org_num =" & orgNum & " AND colodee_elt_acct =" & elt_account_number 
	
	Set rs = eltConn.Execute(SQL)

	SQL = "INSERT INTO colo ( coloder_elt_acct,coloder_name,colodee_elt_acct,colodee_name, coloder_org_num,tran_date ) " &_
          " VALUES ( "& v_agent_elt_acct & ",N'" & v_dba_name & "'" & "," & elt_account_number &_
          ",N'"& Request.Cookies("CurrentUserInfo")("company_name") & "'" &_
          ","& orgNum & ",'"& now & "' )"
	
	eltConn.Execute(SQL)
end sub
%>
<%
sub create_new_codes()
'// insert to code table
	if(v_class_code <> "") then call register_code (v_class_code, 1)
	if(v_business_city <> "") then call register_code( v_business_city, 2)
	if(v_business_state <> "") then call register_code( v_business_state, 3)
	if(v_business_zip <> "") then call register_code( v_business_zip, 4)
	if(v_owner_mail_city <> "") then call register_code( v_owner_mail_city, 2)
	if(v_owner_mail_state <> "") then call register_code( v_owner_mail_state, 3)
	if(v_owner_mail_zip <> "") then call register_code( v_owner_mail_zip, 4)
	if(v_SalesPerson <> "") then call register_code( v_SalesPerson, 22)
	if(v_refferedBy <> "") then call register_code( v_refferedBy, 23)
	if(v_SubConsignee <> "") then call register_code( v_SubConsignee, 11)
	if(v_SubShipper <> "") then call register_code( v_SubShipper, 12)
	if(v_SubAgent <> "") then call register_code( v_SubAgent, 13)
	if(v_SubCarrier <> "") then call register_code( v_SubCarrier, 14)
	if(v_SubTrucker <> "") then call register_code( v_SubTrucker, 15)
	if(v_SubWarehousing <> "") then call register_code( v_SubWarehousing, 16)
	if(v_SubCFS <> "") then call register_code( v_SubCFS, 17)
	if(v_SubBroker <> "") then call register_code( v_SubBroker, 18)
	if(v_SubGovt <> "") then call register_code( v_SubGovt, 20)
	if(v_SubVendor <> "") then call register_code( v_SubVendor, 19)
	if(v_SubCustomer <> "") then call register_code( v_SubCustomer, 24)
	if(v_SubSpecial <> "") then call register_code( v_SubSpecial,21)

end sub
%>
<%
sub register_code( clsVal, cNum )

	DIM rs,SQL
	clsVal = UCASE(clsVal)
	SQL = "select code from all_code where elt_account_number =" & elt_account_number & " and type =" & cNum & " and UPPER(code)=N'" & clsVal & "'"
	
	Set rs = eltConn.Execute(SQL)
	If rs.EOF or rs.BOF then
		SQL = "insert into all_code (elt_account_number,type,code) values (" & elt_account_number & "," & cNum & ",N'" & clsVal & "')"
		eltConn.Execute(SQL)
	end if
	Set rs=Nothing 
	

end sub
%>
<%	
sub delete_org(v_org_account_number)
	if isnull(v_org_account_number) or v_org_account_number = "" then
		v_org_account_number = ""
	end if
	v_org_account_number = trim(v_org_account_number)

	if v_org_account_number = "" then
	else
		save_dba_delete(v_org_account_number)
	end if
end sub
%>

<%
function get_org_number
DIM rs,SQL
	SQL = "select isnull(max(org_account_number),0) + 1 from organization where elt_account_number=" & elt_account_number
	Set rs = eltConn.Execute(SQL)
	get_org_number = rs(0)
	Set rs=Nothing 
end function
%>

<%
sub save_dba_delete(v_o_num)
	DIM rs,SQL
	Set rs = Server.CreateObject("ADODB.Recordset") 

	SQL= "select * from organization where elt_account_number = " & elt_account_number & " AND org_account_number=" & v_o_num
	rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText

	If Not rs.EOF And Not rs.BOF then
		rs.delete
		rs.close
	end if
	
	SQL= "select * from colo where colodee_elt_acct = " & elt_account_number & " AND coloder_org_num=" & v_o_num
	rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText

	If Not rs.EOF And Not rs.BOF then
		rs.delete
		rs.close		
	end if
	
	response.write v_o_num
	set rs = nothing
end sub
%>

<%
sub save_dba_new()
DIM v_o_num,try_cnt
	v_o_num = get_org_number()

	if v_o_num = "" then
		response.write "error #1"
		response.end
	end if

	DIM rs,SQL
	Set rs = Server.CreateObject("ADODB.Recordset") 

	try_cnt = 0
	do while try_cnt < 100 'Try 100 times
		SQL= "select * from organization where elt_account_number = " & elt_account_number & " AND org_account_number=" & v_o_num
		
		rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText

        If Not rs.EOF And Not rs.BOF then
			try_cnt = try_cnt + 1
			v_o_num = get_org_number()
		else
			rs.AddNew
			v_org_account_number = v_o_num
%>
<!--  #INCLUDE FILE="ajax_include_organization_rs.inc" -->
<%
			rs.update
			rs.close
			response.write "ok:" & v_o_num
			try_cnt = 101 'ok lol
		end if
	loop
	put_recent_work "/ASP/MASTER_DATA/client_profile.asp?n="&v_o_num,_
					v_o_num,_
					"Create Client Profile for " & v_dba_name,_
					"Create Client Profile"
Set rs=Nothing 
end sub
%>
<%
sub save_dba_update(v_org_account_number)
	if v_org_account_number = "" then
		response.write "error #2"
		response.end
	end if

	DIM rs,SQL
	Set rs = Server.CreateObject("ADODB.Recordset") 

	SQL= "select * from organization where elt_account_number = " & elt_account_number & " AND org_account_number=" & v_org_account_number
	
	rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText

	If Not rs.EOF And Not rs.BOF then
%>
<!--  #INCLUDE FILE="ajax_include_organization_rs.inc" -->
<%
		rs.update
		rs.close
		response.write v_org_account_number
	end if

	Set rs=Nothing 

	put_recent_work "/ASP/MASTER_DATA/client_profile.asp?n="&v_org_account_number,_
					v_org_account_number,_
					"Modify Client Profile for " & v_dba_name,_
					"Modify Client Profile"
end sub
%>
<%
sub get_queryString
	elt_account_number = Request.Cookies("CurrentUserInfo")("elt_account_number")
	login_name = Request.Cookies("CurrentUserInfo")("login_name")
	UserRight = Request.Cookies("CurrentUserInfo")("user_right")	
end sub 
%>
<%
sub get_db_field
			v_dba_name				= text_trim(Request("txt_dba_name"))
			v_class_code			= text_trim(Request("txt_class_code"))			
			v_org_account_number	= Request("txt_org_account_number")		
			v_isFrequently			= Request("chk_isFrequently")		
			v_account_status		= Request("chk_account_status")		
			if v_account_status = "Y" then
				v_account_status = ""
			else
				v_account_status = "A"
			end if
			v_known_shipper			= text_trim(Request("chk_known_shipper"))		

			v_comment				= text_trim(Request("txt_comment"))		
			'//////////////////////
			'// General Information
			'//////////////////////
			v_owner_fname			= text_trim(Request("txt_owner_fname"))		
			v_owner_mname			= text_trim(Request("txt_owner_mname"))		
			v_owner_lname			= text_trim(Request("txt_owner_lname"))		
			v_owner_title			= text_trim(Request("txt_owner_title"))		
			v_owner_departm			= text_trim(Request("txt_owner_departm"))		
			v_business_phone		= text_trim(Request("txt_business_phone"))		
			v_business_phone_ext	= text_trim( Request("txt_business_phone_ext"))		
			v_business_phone_mask	= text_trim( Request("txt_business_phone_mask"))	
			v_business_phone_mask_exp=text_trim( Request("txt_business_phone_mask_exp"))
			v_business_phone_mask_pre=text_trim( Request("txt_business_phone_mask_pre"))	
			v_business_phone2		= text_trim(Request("txt_business_phone2"))		
			v_business_phone2_ext	= text_trim(Request("txt_business_phone2_ext"))	
			v_business_phone2_mask	= text_trim(Request("txt_business_phone2_mask"))	
			v_business_phone2_mask_exp= text_trim(Request("txt_business_phone2_mask_exp"))	
			v_business_phone2_mask_pre= text_trim(Request("txt_business_phone2_mask_pre"))	
			v_owner_phone			= text_trim(Request("txt_owner_phone"))		
			v_owner_phone_mask		= text_trim(Request("txt_owner_phone_mask"))		
			v_owner_phone_mask_exp	= text_trim(Request("txt_owner_phone_mask_exp"))		
			v_owner_phone_mask_pre	= text_trim(Request("txt_owner_phone_mask_pre"))		
			v_business_fax			= text_trim(Request("txt_business_fax"))		
			v_business_fax_mask		= text_trim(Request("txt_business_fax_mask"))		
			v_business_fax_mask_exp	= text_trim(Request("txt_business_fax_mask_exp"))		
			v_business_fax_mask_pre	= text_trim(Request("txt_business_fax_mask_pre"))		
			v_owner_email			= text_trim(Request("txt_owner_email"))		
			v_business_url			= text_trim(Request("txt_business_url"))		
			v_web_login_id			= text_trim(Request("txt_web_login_id"))		
			v_web_login_pin			= text_trim(Request("txt_web_login_pin"))		
			v_business_address		= text_trim(Request("txt_business_address"))		
			v_business_address2		= text_trim(Request("txt_business_address2"))		
			v_business_city			= text_trim(Request("txt_business_city"))		
			v_business_state		= text_trim(Request("txt_business_state"))		
			v_b_country_code		= text_trim(Request("txt_b_country_code"))		
			v_b_country_codeName	= text_trim(Request("txt_business_country"))	
			v_business_zip			= text_trim(Request("txt_business_zip"))		
			v_business_legal_name	= text_trim(Request("txt_business_legal_name"))	
			v_business_fed_taxid	= text_trim(Request("txt_business_fed_taxid"))		
				
			'/////////////////////
			'// Additional Contact
			'/////////////////////

			v_c2FirstName			= text_trim(Request("txt_c2FirstName"))		
			v_c2MiddleName			= text_trim(Request("txt_c2MiddleName"))		
			v_c2LastName			= text_trim(Request("txt_c2LastName"))			
			v_c2Title				= text_trim(Request("txt_c2Title"))			
			v_c2Phone				= text_trim(Request("txt_c2Phone"))			
			v_c2Ext					= text_trim(Request("txt_c2Ext"))			
			v_c2Phone_mask			= text_trim(Request("txt_c2Phone_mask"))		
			v_c2Phone_mask_exp		= text_trim(Request("txt_c2Phone_mask_exp"))		
			v_c2Phone_mask_pre		= text_trim(Request("txt_c2Phone_mask_pre"))		
			v_c2Cell				= text_trim(Request("txt_c2Cell"))			
			v_c2Cell_mask			= text_trim(Request("txt_c2Cell_mask"))		
			v_c2Cell_mask_exp		= text_trim(Request("txt_c2Cell_mask_exp"))		
			v_c2Cell_mask_pre		= text_trim(Request("txt_c2Cell_mask_pre"))		
			v_c2Fax					= text_trim(Request("txt_c2Fax"))			
			v_c2Fax_mask			= text_trim(Request("txt_c2Fax_mask"))		
			v_c2Fax_mask_exp		= text_trim(Request("txt_c2Fax_mask_exp"))		
			v_c2Fax_mask_pre		= text_trim(Request("txt_c2Fax_mask_pre"))		
			v_c2Email				= text_trim(Request("txt_c2Email"))			
			v_c3FirstName			= text_trim(Request("txt_c3FirstName"))		
			v_c3MiddleName			= text_trim(Request("txt_c3MiddleName"))		
			v_c3LastName			= text_trim(Request("txt_c3LastName"))			
			v_c3Title				= text_trim(Request("txt_c3Title"))			
			v_c3Phone				= text_trim(Request("txt_c3Phone"))			
			v_c3Ext					= text_trim(Request("txt_c3Ext"))			
			v_c3Phone_mask			= text_trim(Request("txt_c3Phone_mask"))		
			v_c3Phone_mask_exp		= text_trim(Request("txt_c3Phone_mask_exp"))		
			v_c3Phone_mask_pre		= text_trim(Request("txt_c3Phone_mask_pre"))		
			v_c3Cell				= text_trim(Request("txt_c3Cell"))			
			v_c3Cell_mask			= text_trim(Request("txt_c3Cell_mask"))		
			v_c3Cell_mask_exp		= text_trim(Request("txt_c3Cell_mask_exp"))		
			v_c3Cell_mask_pre		= text_trim(Request("txt_c3Cell_mask_pre"))		
			v_c3Fax					= text_trim(Request("txt_c3Fax"))			
			v_c3Fax_mask			= text_trim(Request("txt_c3Fax_mask"))			
			v_c3Fax_mask_exp		= text_trim(Request("txt_c3Fax_mask_exp"))			
			v_c3Fax_mask_pre		= text_trim(Request("txt_c3Fax_mask_pre"))			
			v_c3Email				= text_trim(Request("txt_c3Email"))			

			'///////////////////////
			'// Business Information
			'///////////////////////
			v_is_consignee			= text_trim(Request("chk_is_consignee"))		
			v_is_shipper			= text_trim(Request("chk_is_shipper"))			
			v_is_agent				= text_trim(Request("chk_is_agent"))			
			v_is_carrier			= text_trim(Request("chk_is_carrier"))		
			v_z_is_trucker			= text_trim(Request("chk_z_is_trucker"))		
			v_z_is_warehousing		= text_trim(Request("chk_z_is_warehousing"))		
			v_z_is_cfs				= text_trim(Request("chk_z_is_cfs"))			
			v_z_is_broker			= text_trim(Request("chk_z_is_broker"))		
			v_z_is_govt				= text_trim(Request("chk_z_is_govt"))			
			v_is_vendor				= text_trim(Request("chk_is_vendor"))			
			v_is_customer           = text_trim(Request("chk_is_customer"))
			v_z_is_special			= text_trim(Request("chk_z_is_special"))		
			v_SubConsignee			= text_trim(Request("txt_SubConsignee"))	
			v_SubShipper			= text_trim(Request("txt_SubShipper"))			
			v_SubAgent				= text_trim(Request("txt_SubAgent"))			
			v_SubCarrier			= text_trim(Request("txt_SubCarrier"))			
			v_SubTrucker			= text_trim(Request("txt_SubTrucker"))			
			v_SubWarehousing		= text_trim(Request("txt_SubWarehousing"))		
			v_SubCFS				= text_trim(Request("txt_SubCFS"))			
			v_SubBroker				= text_trim(Request("txt_SubBroker"))			
			v_SubGovt				= text_trim(Request("txt_SubGovt"))			
			v_SubVendor				= text_trim(Request("txt_SubVendor"))
			v_SubCustomer			= text_trim(Request("txt_SubCustomer"))				
			v_SubSpecial			= text_trim(Request("txt_SubSpecial"))			
			v_DefaultBroker			= text_trim(Request("txt_DefaultBroker"))		
			v_DefaultBrokerName		= text_trim(Request("txt_DefaultBrokerName"))		
			v_broker_info			= text_trim(Request("txt_broker_info"))		
			v_carrier_id			= text_trim(Request("txt_carrier_id"))	
			vAirLineCode			= text_trim(Request("txtAirLineCode"))	
			v_ICC_MC                = text_trim(Request("txt_ICC_MC"))
			
			'// v_carrier_type			= text_trim(Request("txt_carrier_type"))
			If v_carrier_id <> "" Then
			    v_carrier_type = "O"
			Elseif vAirLineCode <> "" Then
			    v_carrier_type = "A"
			Elseif v_ICC_MC <> "" Then
			    v_carrier_type = "D"
			Else
			    v_carrier_type = text_trim(Request("txt_carrier_type"))
			End If
				
			v_carrier_code			= text_trim(Request("txt_carrier_code"))		
			v_z_chl_no				= text_trim(Request("txt_z_chl_no"))			
			v_z_firm_code			= text_trim(Request("txt_z_firm_code"))		

			'//////////////////////
			'// Billing Information
			'//////////////////////
			v_owner_mail_address	= text_trim(Request("txt_owner_mail_address"))	
			v_owner_mail_address2	= text_trim(Request("txt_owner_mail_address2"))	
			v_owner_mail_city		= text_trim(Request("txt_owner_mail_city"))		
			v_owner_mail_state		= text_trim(Request("txt_owner_mail_state"))		
			v_owner_mail_zip		= text_trim(Request("txt_owner_mail_zip"))		
			v_owner_mail_country	= text_trim(Request("txt_owner_mail_country"))	

			v_bill_term				= text_trim(Request("txt_bill_term"))			
			if isnull(v_bill_term) or  v_bill_term = "" then
				v_bill_term = 0
			end if


			v_z_attn_txt			= text_trim(Request("txt_z_attn_txt"))			
			v_credit_amt			= text_trim(Request("txt_credit_amt"))			
			if isnull(v_credit_amt) or  v_credit_amt = "" then
				v_credit_amt = 0
			end if

			v_z_bank_name			= text_trim(Request("txt_z_bank_name"))		
			v_z_bank_account_no		= text_trim(Request("txt_z_bank_account_no"))		

			'/////////////////////////
			'// Managerial Information
			'/////////////////////////
			v_agent_elt_acct		= text_trim(Request("txt_agent_elt_acct"))		
			v_refferedBy			= text_trim(Request("txt_refferedBy"))		
			
			v_coloader_elt_acct		= text_trim(Request("txt_coloader_elt_acct"))		

			if isnull(v_coloader_elt_acct) or  v_coloader_elt_acct = "" then
				v_coloader_elt_acct = 0
			end if

			v_coloader_elt_acct_name	= text_trim(Request("txt_coloader_elt_acct_name"))	
			v_is_coloader			= text_trim(Request("chk_is_coloader"))			
			v_edt					= text_trim(Request("chk_edt"))			
			v_SalesPerson			= text_trim(Request("txt_SalesPerson"))		
			v_print_check_as		= text_trim(Request("txt_print_check_as"))		
			v_print_check_as_info   = text_trim(Request("txt_print_check_as_info"))		
			v_FF_account            = text_trim(Request("txt_FF_account"))
			'//////////////////////

end sub
%>

<% 
function text_trim(text)

if isnull(text) then 
	text_trim = text
	exit function
Else
    text = RemoveQuotations(text)
end if

text_trim = trim(text) 	
		
end function

Function RemoveQuotations(arg)
    Dim temp
    If IsNull(arg) Or Trim(arg) = "" Then
        temp = ""
    Else
        temp = Replace(arg,chr(34)," ")
        temp = Replace(temp,chr(39),"`")
    End If
    RemoveQuotations = temp
End Function
%>