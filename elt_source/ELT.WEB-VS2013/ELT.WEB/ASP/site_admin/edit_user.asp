<!--  #INCLUDE FILE="../include/transaction.txt" -->
<% 
    Option Explicit
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"


%>
<!--  #INCLUDE FILE="../include/connection.asp" -->
<!--  #INCLUDE FILE="../include/header.asp" -->
<!--  #INCLUDE FILE="../include/CountryStates.asp" -->
<!--  #INCLUDE FILE="../include/GOOFY_Util_Ver_2.inc" -->
<!--  #INCLUDE FILE="../include/GOOFY_Util_Fun.inc" -->
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Edit User</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
.style1 {color: #cc6600}
a {
	border:none;
}

-->
</style>
</head>
<%
Dim rs, SQL
Dim vLabelType, vAdd_Info
Dim vOrgAcct,vTitle,vWH,vAWBPort,vBOLPort,vSEDPort,vInvoicePort,vCheckPort,vShippingLabelPort,vAWBQueue,vBOLQueue
Dim vSEDQueue,vInvoiceQueue,vCheckQueue,vShippingLabelQueue,vRecent
Dim vSEDPrn,vInvoicePrn,vCheckPrn,vShippingLabelPrn,vAWBPrn,vBOLPrn
Dim vUserType,varr_LoginID,vLastName,vFirstName,vAddress,vCity,vState,vZip,vCountry,vPhone
Dim vEmail,vPassword1,vPassword2,vIg_user_ssn,vIg_user_dob,vIg_user_cell
Dim UserID,AddUser,UpdateUser,EditUser,DeleteUser
Dim aDefaultPageID(100),aDefaultPage(100),pageIndex,vDefaultPage
Dim arr_LoginID(128),arr_User_ID(128),tIndex
Dim aOrgName(),aOrgAcct(),oIndex
Dim aPort(8),pIndex
Dim TranNo,tNo,strSoTitle
Dim i
DIM v_maxUser
DIM v_curUser
Dim code_list_all

eltConn.BeginTrans
'////////////////////////////////////////////////////////////////////

Set rs = Server.CreateObject("ADODB.Recordset")

UserID=CInt(Request.QueryString("UserID"))
AddUser=Request.QueryString("AddUser")
UpdateUser=Request.QueryString("UpdateUser")
EditUser=Request.QueryString("EditUser")
DeleteUser=Request.QueryString("DeleteUser")


if NOT isAdmin then
	EditUser = "yes"
	UserID = user_id
end if

TranNo=Session("TranNo")
if TranNo="" then
	Session("TranNo")=0
	TranNo=0
end if
tNo=Clng(Request.QueryString("tNo"))
vUserType=0

if NOT tNo=TranNo then
	EditUser = "yes"
	UpdateUser = AddUser = DeleteUser = ""
end if

CALL GetAllCountryCodes
CALL MAIN_PROCESS	
CALL GET_USER_LIST
'CALL GET_ORG_NAME
CALL SET_DEFAULT_PRINT_PORT


if isnull(vRecent) or vRecent = "" then vRecent = 3


'// Default Page by Joon on 9/19/2007

Dim PageArrayList, PageTable
Set PageArrayList = Server.CreateObject("System.Collections.ArrayList")


SQL = "SELECT * from tab_master WHERE page_label <> 'Default Page' AND page_label <> 'Default Module Page' ORDER BY top_seq_id,sub_seq_id,page_seq_id"
rs.CursorLocation = adUseClient
rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
Set rs.activeConnection = Nothing
Do While Not rs.EOF 
    Set PageTable = Server.CreateObject("System.Collections.HashTable")
    PageTable.Add "label", rs("page_label").Value
    PageTable.Add "sub", rs("sub_module").Value
    PageTable.Add "top", rs("top_module").Value
    PageTable.Add "id", ConvertAnyValue(rs("page_id").value, "Long", 0)
	PageArrayList.Add PageTable
	rs.MoveNext()
Loop	
rs.Close

Set rs=Nothing 

'////////////////////////////////////////////////////////////////////
eltConn.CommitTrans

%>
<% 
SUB MAIN_PROCESS

call check_max_user

if (AddUser="yes") or ( UpdateUser="yes") then
	if tNo=TranNo then
		Session("TranNo")=Clng(Session("TranNo"))+1
		TranNo=Clng(Session("TranNo"))
		
		CALL GET_FROM_SCREEN
		if AddUser="yes" then
			CALL CREATE_NEW_USER
		elseif UpdateUser="yes" then
			CALL UPDATE_USER
		end if
	
		if ( Trim(user_id) = Trim(UserID) ) Then
			CALL UPDATE_CURRENT_SESSION_IN_VIEW_LOGIN
		end if
	end if
elseif EditUser="yes" then
	CALL GET_FROM_TABLE	
elseif DeleteUser="yes" then
	if tNo=TranNo then
		CALL DELETE_USER
	end if
end if

END SUB
%>
<%
        sub check_max_user
			
			SQL= "select isnull(maxuser,3) as maxuser  from agent where elt_account_number = " & elt_account_number

			rs.CursorLocation = adUseClient
			rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
			Set rs.activeConnection = Nothing
			If Not rs.EOF Then
				   v_maxuser = rs(0) 
			else
				   v_maxuser = "3"
			end if
			rs.Close
			
			SQL = "select count(*) as iCnt from users where elt_account_number = " & elt_account_number
			Set rs = eltConn.execute (SQL)
			v_curUser = 0
			if NOT rs.eof and NOT rs.bof then
				v_curUser = rs("iCnt")
			end if	
			rs.Close
        end sub
%>
<%
SUB SET_DEFAULT_PRINT_PORT
aPort(0)="LPT1"
aPort(1)="LPT2"
aPort(2)="LPT3"
aPort(3)="LPT4"
aPort(4)="LPT5"
aPort(5)="LPT6"
aPort(6)="LPT7"
aPort(7)="LPT8"
pIndex=8
END SUB
%>
<%
SUB GET_ORG_NAME

SQL= "select org_account_number,DBA_NAME from organization where elt_account_number = " & elt_account_number & " and (is_shipper='Y' or is_consignee='Y') and (account_status='A') order by dba_name"



rs.CursorLocation = adUseClient
rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
Set rs.activeConnection = Nothing

reDim aOrgName(3000)
reDim aOrgAcct(3000)

aOrgName(0)="Select One"
aOrgAcct(0)=0
oIndex=1

Do While Not rs.EOF 
	aOrgName(oIndex)=rs("DBA_NAME")
	aOrgAcct(oIndex)=cLng(rs("org_account_number"))
	oIndex=oIndex+1
	rs.MoveNext
Loop	
rs.Close
END SUB
%>
<%
SUB GET_USER_LIST
tIndex=0
SQL= "select userid,login_name from users where elt_account_number = " & elt_account_number & " order by login_name"
rs.CursorLocation = adUseClient
rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
Set rs.activeConnection = Nothing
do While not rs.EOF
	arr_LoginID(tIndex)=rs("login_name")
	arr_User_ID(tIndex)=CInt(rs("userid"))
	rs.MoveNext
	tIndex=tIndex+1
Loop
rs.Close
END SUB
%>
<%
SUB DELETE_USER
DIM LoginUser,tmp_id
	LoginUser=cLng(user_id)

	if LoginUser=UserID then
		ErrMsg="You can't delete your ID!"
		Response.Redirect("../extra/err_msg.asp?ErrMSG=" & ErrMsg)
	else
		SQL= "delete users where elt_account_number = " & elt_account_number & " and userid=" & UserID
		eltConn.execute (SQL)

		tmp_id = elt_account_number & UserID
		SQL= "delete view_login where elt_account_number = " & elt_account_number & " and user_id='" & tmp_id & "'"
		eltConn.execute (SQL)
	end if

END SUB
%>
<%
SUB GET_FROM_TABLE
	SQL= "select * from users where elt_account_number = " & elt_account_number & " and userid=" & UserID
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
	If Not rs.EOF Then
		vUserType=rs("user_type")
		vOrgAcct=rs("org_acct")
		if vOrgAcct="" or IsNull(vOrgAcct) then vOrgAcct=0
		vLastName=rs("user_lname")
		vFirstName=rs("user_fname")
		vTitle=rs("user_title")
		varr_LoginID=rs("login_name")
		vPassword1=rs("password")
		vPassword2=rs("password")
		vAddress=rs("user_address")
		vCity=rs("user_city")
		vState=rs("user_state")
		vZip=rs("user_zip")
		vCountry=rs("user_country")
		vPhone=rs("user_phone")
		vEmail=rs("user_email")
		vWH=rs("default_warehouse")
		vAWBPort=rs("awb_port")
		vBOLPort=rs("bol_port")
		vSEDPort=rs("sed_port")
		vInvoicePort=rs("invoice_port")
		vCheckPort=rs("check_port")
		vShippingLabelPort=rs("shipping_label_port")
		vAWBQueue=rs("awb_queue")
		vBOLQueue=rs("bol_queue")
		vSEDQueue=rs("sed_queue")
		vInvoiceQueue=rs("invoice_queue")
		vCheckQueue=rs("check_queue")
		vShippingLabelQueue=rs("shipping_label_queue")
		vIg_user_ssn=rs("ig_user_ssn")
		vIg_user_dob=rs("ig_user_dob")
		vIg_user_cell=rs("ig_user_cell")
		vRecent=rs("ig_recent_work")	
		vDefaultPage=rs("page_tab_id")	
		vLabelType=rs("label_type")
		
		vAWBPrn = rs("awb_prn_name") 
		vBOLPrn = rs("bol_prn_name")
		vSEDPrn = rs("sed_prn_name")
		vInvoicePrn = rs("invoice_prn_name")
		vCheckPrn =	rs("check_prn_name")
		vShippingLabelPrn = rs("shipping_label_prn_name")
		
		if isnull(vLabelType) then
			 vLabelType =1
		end if 
		
		vAdd_Info=rs("add_to_label")

	End If
	rs.Close

END SUB
%>
<%
SUB UPDATE_CURRENT_SESSION_IN_VIEW_LOGIN
		dim SQL_c,tmp_id
		tmp_id = elt_account_number & user_id
		If vOrgAcct = "" Then vOrgAcct = 0

			SQL_c = " Select * from view_login where elt_account_number="&elt_account_number&" AND user_id ='"&tmp_id&"'"
			rs.Open SQL_c, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
			If not rs.EOF then

				rs("user_name") = varr_LoginID
				rs("user_type") = vUserType
				rs("user_right") = vUserType
				rs("login_name") = varr_LoginID
				rs("password") = vPassword1
				rs("org_acct") = vOrgAcct
				rs("user_lname") = vLastName
				rs("user_fname") = vFirstName
				rs("user_title") = vTitle
				rs("user_address") = vAddress
				rs("user_city") = vCity
				rs("user_state") = vState
				rs("user_zip") = vZip
				rs("user_country") = vCountry
				rs("user_phone") = vPhone
				rs("user_email") = vEmail
				rs("default_warehouse") = vWH
				
				rs("awb_port") = vAWBPort
				rs("bol_port") = vBOLPort
				rs("sed_port") = vSEDPort
				rs("invoice_port") = vInvoicePort
				rs("check_port") = vCheckPort
				rs("shipping_label_port") = vShippingLabelPort
				
				rs("awb_queue") = vAWBQueue
				rs("bol_queue") = vBOLQueue
				rs("sed_queue") = vSEDQueue
				rs("invoice_queue") = vInvoiceQueue
				rs("check_queue") = vCheckQueue
				rs("shipping_label_queue") = vShippingLabelQueue

				rs("awb_prn_name") = vAWBPrn
				rs("bol_prn_name") = vBOLPrn
				rs("sed_prn_name") = vSEDPrn
				rs("invoice_prn_name") = vInvoicePrn
				rs("check_prn_name") = vCheckPrn
				rs("shipping_label_prn_name") = vShippingLabelPrn
				
				rs("ig_user_ssn") = MID(vIg_user_ssn,1,9)
				rs("ig_user_dob") = vIg_user_dob
				rs("ig_user_cell") = vIg_user_cell
				rs("ig_recent_work") = vRecent
				rs.update
				rs.close
			end if
END SUB
%>
<%
SUB UPDATE_USER
			if Trim(varr_LoginID) = "" then
				exit sub
			end if	
			
			if UserID = 0 then
				exit sub
			end if	
			
			if elt_account_number = "" then
				exit sub
			end if	

			DIM iCnt
			SQL = "select count(*) as iCnt from users where elt_account_number = " & elt_account_number & " and userid=" & UserID
			Set rs = eltConn.execute (SQL)
			iCnt = 0
			if NOT rs.eof and NOT rs.bof then
				iCnt = rs("iCnt")
			end if	
			rs.Close
			
			if cLng(iCnt) = 1 then
				SQL= "select * from users where elt_account_number = " & elt_account_number & " and userid=" & UserID
				rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
				If NOT rs.EOF then
					if trim(varr_LoginID) = "admin" then
						vUserType = 9
					end if

					rs("user_type")=vUserType
					if Not vOrgAcct="" then rs("org_acct")=vOrgAcct
					rs("login_name")=varr_LoginID
					rs("password")=vPassword1
					rs("user_lname")=vLastName
					rs("user_fname")=vFirstName
					rs("user_title")=vTitle
					rs("user_address")=vAddress
					rs("user_city")=vCity
					rs("user_state")=vState
					rs("user_zip")=vZip
					rs("user_country")=vCountry
					rs("user_phone")=vPhone
					rs("user_email")=vEmail
					rs("default_warehouse")=vWH
					rs("awb_port")=vAWBPort
					rs("bol_port")=vBOLPort
					rs("sed_port")=vSEDPort
					rs("invoice_port")=vInvoicePort
					rs("check_port")=vCheckPort
					rs("shipping_label_port")=vShippingLabelPort
					rs("awb_queue")=vAWBQueue
					rs("bol_queue")=vBOLQueue
					rs("sed_queue")=vSEDQueue
					rs("invoice_queue")=vInvoiceQueue
					rs("check_queue")=vCheckQueue
					rs("shipping_label_queue")=vShippingLabelQueue
					rs("last_modified")=Now
					rs("ig_user_ssn")=MID(vIg_user_ssn,1,9)
					rs("ig_user_dob")=MID(vIg_user_dob,1,10)
					rs("ig_user_cell")=vIg_user_cell
					rs("ig_recent_work")=vRecent
					rs("user_right")=vUserType
					rs("page_tab_id")= ConvertAnyValue(vDefaultPage,"Long",0)
					rs("label_type")=vLabelType
					rs("add_to_label")=vAdd_Info
'// by iMoon 2/7/2007 for Printer Name					
					rs("awb_prn_name") = vAWBPrn
					rs("bol_prn_name") = vBOLPrn
					rs("sed_prn_name") = vSEDPrn
					rs("invoice_prn_name") = vInvoicePrn
					rs("check_prn_name") = vCheckPrn
					rs("shipping_label_prn_name") = vShippingLabelPrn
					rs.Update
					rs.Close		
				end if
			else
			end if

    
	SQL= "EXEC	[AddTabAccessForUserType] @elt_account_number=" & elt_account_number & ", @login_name=" & varr_LoginID
	eltConn.Execute SQL
END SUB
%>
<%
SUB GET_FROM_SCREEN
    vLabelType=cint(Request("labelType"))
	vAdd_Info=Request("add_info")
	vOrgAcct=Request("lstUserOrg")
	if vOrgAcct="" then vOrgAcct=0
	vUserType=Cint(Request("lstUserType"))
	vLastName=Request("txtLastName")
	vFirstName=Request("txtFirstName")
	vTitle=Request("txtTitle")
	varr_LoginID=Request("txtarr_LoginID")
	vPassword1=Request("txtPassword1")
	vPassword2=Request("txtPassword2")
	vAddress=Request("txtAddress")
	vCity=Request("txtCity")

	If checkBlank(Request("lstState"),"") <> "" Then
	    vState=Request("lstState")
	Else
	    vState=Request("txtState")
	End If
	
	vZip=Request("txtZip")
	vCountry=Request("lstCountry")
	vPhone=Request("txtPhone")
	vEmail=Request("txtEmail")
	vWH=Request("lstWH")
	vAWBPort=Request("lstAWBPort")
	vBOLPort=Request("lstBOLPort")
	vSEDPort=Request("lstSEDPort")
	vInvoicePort=Request("lstInvoicePort")
	vCheckPort=Request("lstCheckPort")
	vShippingLabelPort=Request("lstShippingLabelPort")
	vAWBQueue=Request("txtAWBQueue")
	vBOLQueue=Request("txtBOLQueue")
	vSEDQueue=Request("txtSEDQueue")
	vInvoiceQueue=Request("txtInvoiceQueue")
	vCheckQueue=Request("txtCheckQueue")
	vShippingLabelQueue=Request("txtShippingLabelQueue")
	vIg_user_ssn=Request("txtIg_user_ssn")
	vIg_user_dob=Request("txtIg_user_dob")
	vIg_user_cell=Request("txtIg_user_cell")
	vRecent=Request("txtRecent")
	vDefaultPage=Request("lstDefaultPage")	
	
'// by iMoon 2/7/2007 for Printer Name					
	vAWBPrn=Request("txt_awb_prn_name") 
	vBOLPrn=Request("txt_bol_prn_name")
	vSEDPrn=Request("txt_sed_prn_name")
	vInvoicePrn=Request("txt_invoice_prn_name")
	vCheckPrn=Request("txt_check_prn_name")
	vShippingLabelPrn=Request("txt_shipping_label_prn_name")
	
END SUB
%>
<%
SUB CREATE_NEW_USER
    response.Write "here"
if Trim(varr_LoginID) = "" then
	exit sub
end if	
		SQL= "select max(userid) as userid from users where elt_account_number = " & elt_account_number
		rs.CursorLocation = adUseClient
		rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
		Set rs.activeConnection = Nothing
		If Not rs.EOF And IsNull(rs("userid"))=False Then
			UserID = CLng(rs("userid")) + 1
		Else
			UserID=1001
		End If
		rs.Close
		
		SQL= "select * from users where elt_account_number = " & elt_account_number & " and userid=" & UserID
		rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
		If rs.EOF then
			rs.AddNew
			rs("elt_account_number")=elt_account_number
			rs("userid")=UserID
			rs("create_date")=Now
			rs("user_type")=vUserType
			if Not vOrgAcct="" then rs("org_acct")=vOrgAcct
			rs("login_name")=varr_LoginID
			rs("password")=vPassword1
			rs("user_lname")=vLastName
			rs("user_fname")=vFirstName
			rs("user_title")=vTitle
			rs("user_address")=vAddress
			rs("user_city")=vCity
			rs("user_state")=vState
			rs("user_zip")=vZip
			rs("user_country")=vCountry
			rs("user_phone")=vPhone
			rs("user_email")=vEmail
			rs("default_warehouse")=vWH
			rs("awb_port")=vAWBPort
			rs("bol_port")=vBOLPort
			rs("sed_port")=vSEDPort
			rs("invoice_port")=vInvoicePort
			rs("check_port")=vCheckPort
			rs("shipping_label_port")=vShippingLabelPort
			rs("awb_queue")=vAWBQueue
			rs("bol_queue")=vBOLQueue
			rs("sed_queue")=vSEDQueue
			rs("invoice_queue")=vInvoiceQueue
			rs("check_queue")=vCheckQueue
			rs("shipping_label_queue")=vShippingLabelQueue
			rs("last_modified")=Now
			rs("ig_user_ssn")=MID(vIg_user_ssn,1,9)
			rs("ig_user_dob")=MID(vIg_user_dob,1,10)
			rs("ig_user_cell")=vIg_user_cell
			rs("ig_recent_work")=vRecent
			rs("user_right")=vUserType
            rs("page_tab_id")= ConvertAnyValue(vDefaultPage,"Long",0)
'// by iMoon 2/7/2007 for Printer Name					
			rs("awb_prn_name") = vAWBPrn
			rs("bol_prn_name") = vBOLPrn
			rs("sed_prn_name") = vSEDPrn
			rs("invoice_prn_name") = vInvoicePrn
			rs("check_prn_name") = vCheckPrn
			rs("shipping_label_prn_name") = vShippingLabelPrn

			rs.Update
			rs.Close
		end if	



	SQL= "EXEC	[AddTabAccessForUserType] @elt_account_number=" & elt_account_number & ", @login_name=" & varr_LoginID
	eltConn.Execute SQL
	

END SUB

Sub GetAllCountryCodes
    Dim tmpTable, SQL, rs
    
    set code_list_all = Server.CreateObject("System.Collections.ArrayList")
	SQL = "select country_code, substring(country_name,0,40) as country_name from all_country_code order by country_name" 

	Set rs = eltConn.Execute(SQL)

	Do While Not rs.EOF
		Set tmpTable = Server.CreateObject("System.Collections.HashTable")
		tmpTable.Add "code",rs("country_code").value
		tmpTable.Add "code_description", rs("country_name").value '& fill_space(rs("country_name").value,35) & rs("country_code").value
		
		tmpTable.Add "description",rs("country_name").value  
		code_list_all.Add tmpTable	
		rs.MoveNext
	Loop
	rs.Close
End Sub

%>
<!--  #include file="../include/recent_file.asp" -->
<body link="336699" vlink="336699" topmargin="0">
    <form name="form1" id="form1" method="post" action="edit_user.asp" webbot-action="--WEBBOT-SELF--">
        <input type="image" style="position: absolute; visibility: hidden" onclick="return false;" />
        <!-- tooltip placeholder -->
        <div id="tooltipcontent">
        </div>
        <!-- placeholder ends -->
        <table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
            <tr>
                <td height="32" align="left" valign="middle" class="pageheader">
                    User Admin/Profile</td>
            </tr>
        </table>
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="9190A5"
            bgcolor="#9190A5" class="border1px">
            <tr>
                <td>
                    <input type="hidden" name="hNoItem" id="hNoItem" value="<%= tIndex %>">
                    <table width="100%" border="0" cellpadding="2" cellspacing="0">
                        <tr bgcolor="C7C6E1">
                            <td colspan="9" height="8" align="left" valign="top" class="bodyheader">
                            </td>
                        </tr>
                        <tr bgcolor="9190A5">
                            <td colspan="9" height="1" align="left" valign="top">
                            </td>
                        </tr>
                        <tr align="left" bgcolor="DDDDED">
                            <td valign="middle" bgcolor="DDDDED" class="bodyheader">
                                &nbsp;</td>
                            <td width="110" valign="middle" bgcolor="DDDDED" class="bodyheader style1">
                                Login ID</td>
                            <td colspan="2" valign="middle" bgcolor="DDDDED" class="bodyheader">
                                <% if NOT isAdmin then response.write "    " & login_name end if%>
                                <select name="lstUser" id="lstUser" size="1" class="smallselect" style="width: 127px" onchange="ChangeUser()"
                                    <% if NOT isAdmin then response.write "style='visibility:hidden'" %>>
                                    <option value="0" <% if UserID=0 then response.write("selected") %>>New User</option>
                                    <% DIM selectedID %>
                                    <% for i=0 to tIndex-1 %>
                                    <option value="<%= arr_User_ID(i) %>" <% 
		  									if UserID=arr_User_ID(i) then 
											selectedID = arr_LoginID(i)
		  									response.write("selected") 
											end if
											%>>
                                        <%= arr_LoginID(i) %>
                                    </option>
                                    <% next %>
                                </select>
                            </td>
                            <td width="173" class="bodycopy">
                                <% if isAdmin then %>
                                <span class="bodyheader">User Type</span><% end if %>
                            </td>
                            <td class="bodycopy">
                                <select name="lstUserType" id="lstUserType" size="1" class="smallselect" style="width: 140px" <% if NOT isAdmin then response.write "style='visibility:hidden'" %>
                                    <% if trim(LCASE(selectedID)) = "admin" then response.write " disabled='disabled'" %>>

                                    <option value="2" <%  if vUserType=2 then response.write("selected") %>>Agent</option>
                                    <option value="3" <%  if vUserType=3 then response.write("selected") %>>Operation</option>
                                    <option value="5" <%  if vUserType=5 then response.write("selected") %>>Accounting</option>
                                    <option value="7" <%  if vUserType=7 then response.write("selected") %>>Operation &
                                        Accounting</option>
                                    <% if cInt(UserRight)=9 or trim(LCASE(selectedID)) = "admin" or trim(LCASE(selectedID)) = "system" then %>
                                    <option value="9" <%  if vUserType=9 then response.write("selected") %>>Super User</option>
                                    <% end if %>
                                </select>
                                <!--Super User<input type="checkbox" ID="chkIsShipper" <% If cInt(UserRight)=9 or trim(LCASE(selectedID)) = "admin" or trim(LCASE(selectedID)) = "system" then %> readonly="readonly" <% End If %>/>
          -->
                                <% if isAdmin then %>
                                <div style="display: inline">
                                    <% if mode_begin then %>
                                    <div style="width: 21px; display: inline; vertical-align: text-bottom" onmouseover="showtip('Type of Account. Super Users have admin level access. The other types DO NOT limit access to pages. This must be done at Authorized Pages.')"
                                        onmouseout="hidetip()">
                                        <img src="../Images/button_info.gif" align="bottom" class="bodylistheader"></div>
                                    <% end if %>
                                </div>
                                <% end if %>
                            </td>
                            <td class="bodycopy">
                               
                            </td>
                            <td width="281" colspan="2" class="bodycopy">
                                <select name="lstUserOrg" id="lstUserOrg" size="1" class="smallselect" style="width: 210px;display:none" <% if NOT isAdmin then response.write "style='visibility:hidden'" %>>
                                    <% for i=0 to oIndex-1 %>
                                    <option value="<%= aOrgAcct(i) %>" <% if cLng(vOrgAcct)=aOrgAcct(i) then response.write("selected") %>>
                                        <%= aOrgName(i) %>
                                    </option>
                                    <% next %>
                                </select>
                                <% if isAdmin then %>
                                <div style="display: inline">
                                    <% if mode_begin then %>
                                    <div style="width: 21px; display: inline; vertical-align: text-bottom" onmouseover="showtip('List of all system pages. Those pages specified in this area will be accessible to the selected user.')"
                                        onmouseout="hidetip()">
                                        <img src="../Images/button_info.gif" align="bottom" class="bodylistheader"></div>
                                    <% end if %>
                                </div>
                                <% end if %>
                            </td>
                        </tr>
                        <tr bgcolor="9190A5">
                            <td colspan="9" height="1" align="left" valign="top">
                            </td>
                        </tr>
                        <tr align="left" bgcolor="#f3f3f3" class="bodycopy">
                            <td width="2" valign="middle">
                                &nbsp;</td>
                            <td valign="middle">
                                First Name</td>
                            <td colspan="2" valign="middle">
                                <b><font color="#36255a">
                                    <input name="txtFirstName" id="txtFirstName" class="bodyheader" value="<%= vFirstName %>" size="23">
                                </font></b>
                            </td>
                            <td valign="middle">
                                Last Name</td>
                            <td width="261" valign="middle">
                                <b><font color="#36255a">
                                    <input name="txtLastName" id="txtLastName" class="bodyheader" value="<%= vLastName %>" size="20">
                                </font></b>
                            </td>
                            <td width="108" valign="middle">
                                Title</td>
                            <td colspan="2" valign="middle">
                                <b><font color="#36255a">
                                    <input name="txtTitle" id="txtTitle" class="shorttextfield" value="<%= vTitle %>" size="24">
                                </font></b>
                            </td>
                        </tr>
                        <tr align="left" bgcolor="#FFFFFF" class="bodycopy">
                            <td width="2" valign="middle">
                                &nbsp;</td>
                            <td valign="middle">
                                Login ID</td>
                            <td colspan="2" valign="middle">
                                <b><font color="#36255a">
                                    <input name="txtarr_LoginID" id="txtarr_LoginID" class="shorttextfield" value="<%= varr_LoginID %>" size="23">
                                </font></b>
                            </td>
                            <td valign="middle">
                                Password</td>
                            <td valign="middle">
                                <b><font color="#36255a">
                                    <input name="txtPassword1" id="txtPassword1" type="password" class="shorttextfield" value="<%= vPassword1 %>"
                                        size="20">
                                </font></b>
                            </td>
                            <td valign="middle">
                                Repeat Password</td>
                            <td colspan="2" valign="middle">
                                <b><font color="#36255a">
                                    <input name="txtPassword2" id="txtPassword2" type="password" class="shorttextfield" value="<%= vPassword2 %>"
                                        size="24">
                                </font></b>
                            </td>
                        </tr>
                        <tr align="left" bgcolor="#f3f3f3" class="bodycopy">
                            <td width="2" valign="middle">
                                &nbsp;</td>
                            <td valign="middle">
                                SSN</td>
                            <td colspan="2" valign="middle">
                                <b>
                                    <input name="txtIg_user_ssn" id="txtIg_user_ssn" type="text" class="shorttextfield" value="<%= vIg_user_ssn %>"
                                        size="23">
                                </b>
                            </td>
                            <td valign="middle">
                                Date of Birth
                            </td>
                            <td valign="middle">
                                <b>
                                    <input name="txtIg_user_dob" id="txtIg_user_dob" type="text" class="m_shorttextfield" preset="shortdate"
                                        value="<%= vIg_user_dob %>" size="20">
                                </b>
                            </td>
                            <td valign="middle">
                                <% if isAdmin then %>
                                Authorized Pages
                                <% end if%>
                            </td>
                            <td colspan="2" valign="middle">
                                <b><font size="2">
                                    <% if isAdmin then %>
                                    <input name="btnCountry" id="btnCountry" type="button" class="formbody" value="Go" onclick="javascript:GoPageSet();"
                                        style="cursor: hand">
                                    <% end if %>
                                </font></b>
                            </td>
                        </tr>
                        <tr align="left" bgcolor="#FFFFFF" class="bodycopy">
                            <td width="2" valign="middle">
                                &nbsp;</td>
                            <td valign="middle">
                                Address</td>
                            <td colspan="2" valign="middle">
                                <b><font color="#36255a">
                                    <input name="txtAddress" id="txtAddress" class="shorttextfield" value="<%= vAddress %>" size="36">
                                </font></b>
                            </td>
                            <td valign="middle">
                                City</td>
                            <td colspan="4" valign="middle">
                                <b><font color="#36255a">
                                    <input name="txtCity" id="txtCity" class="shorttextfield" value="<%= vCity %>" size="20">
                                </font></b>
                            </td>
                        </tr>
                        <tr align="left" bgcolor="#F3f3f3" class="bodycopy">
                            <td width="2" valign="middle">
                                &nbsp;</td>
                            <td valign="middle">
                                State/Province</td>
                            <td colspan="2" valign="middle">
                                <select name="lstState" size="1" class="smallselect">
                                    <option></option>
                                    <% for i=0 to 50 %>
                                    <option <% if vState=USState(i) then response.write("selected") %>>
                                        <%= USState(i) %>
                                    </option>
                                    <% next %>
                                </select>
                                <input type="text" id="txtState" name="txtState" value="<%=vState %>" class="shorttextfield" /></td>
                            <td valign="middle">
                                Zip</td>
                            <td valign="middle">
                                <b><font color="#36255a">
                                    <input name="txtZip" class="m_shorttextfield" value="<%= vZip %>" size="20">
                                </font></b>
                            </td>
                            <td valign="middle">
                                Country</td>
                            <td colspan="2" valign="middle">
                                <b><font color="#36255a">
                                    <select name="lstCountry" id="lstCountry" size="1" class="smallselect" style="width: 160px">
                                        <option></option>
                                        <% For i=0 To code_list_all.Count-1 %>
                                        <option value="<%=code_list_all(i)("code") %>" <% If vCountry=code_list_all(i)("code") Then Response.Write("selected=selected") %>>
                                            <%=code_list_all(i)("description") %>
                                        </option>
                                        <% next %>
                                    </select>
                                    <div style="width: 21px; display: inline; vertical-align: text-bottom" onmouseover="showtip('Country default setting for the user allows localized form statments to be shown.')"
                                        onmouseout="hidetip()">
                                        <img src="../Images/button_info.gif" align="bottom" class="bodylistheader" /></div>
                                </font></b>
                            </td>
                        </tr>
                        <tr align="left" bgcolor="#FFFFFF" class="bodycopy">
                            <td width="2" valign="middle">
                                &nbsp;</td>
                            <td valign="middle">
                                Phone No.</td>
                            <td colspan="2" valign="middle">
                                <b><font color="#36255a">
                                    <input name="txtPhone" class="m_shorttextfield" value="<%= vPhone %>" size="23">
                                </font></b>
                            </td>
                            <td valign="middle">
                                Cell No.</td>
                            <td valign="middle">
                                <b>
                                    <input name="txtIg_user_cell" type="text" class="m_shorttextfield" value="<%= vIg_user_cell %>"
                                        size="20">
                                </b>
                            </td>
                            <td valign="middle">
                                E-Mail</td>
                            <td colspan="2" valign="middle">
                                <b><font color="#36255a">
                                    <input name="txteMail" class="shorttextfield" value="<%= vEmail %>" size="30">
                                </font></b>
                            </td>
                        </tr>
                        <tr align="left" bgcolor="#F3f3f3" class="bodycopy">
                            <td valign="middle">
                                &nbsp;</td>
                            <td valign="middle">
                                Default Page
                            </td>
                            <td colspan="2" valign="middle">
                                <select name="lstDefaultPage" size="1" class="smallselect">
                                    <option></option>
                                    <% For i=0 To PageArrayList.count-1 %>
                                    <% If (PageArrayList(i)("top")="International" And agent_is_intl="N") Or (PageArrayList(i)("top")="Domestic" And agent_is_dome="N") Or PageArrayList(i)("top")="Accounting Beta" Then  %>
                                    <% Else %>
                                    <option value="<%=PageArrayList(i)("id") %>" <% If PageArrayList(i)("id") = ConvertAnyValue(vDefaultPage,"Long",0) Then Response.Write("selected") %>>
                                        <%=PageArrayList(i)("top") %>
                                        >
                                        <%=PageArrayList(i)("sub") %>
                                        >
                                        <%=PageArrayList(i)("label") %>
                                    </option>
                                    <% End If %>
                                    <% Next %>
                                </select>
                            </td>
                            <td valign="middle">
                                &nbsp;</td>
                            <td valign="middle">
                                &nbsp;</td>
                            <td valign="middle">
                                &nbsp;</td>
                            <td colspan="2" valign="middle">
                                &nbsp;</td>
                        </tr>
                        <tr bgcolor="9190A5">
                            <td colspan="9" height="2" align="left" valign="top">
                            </td>
                        </tr>
                        <tr align="left" bgcolor="#DDDDED">
                            <td height="20" valign="middle" class="bodycopy">
                                &nbsp;</td>
                            <td colspan="2" valign="middle" bgcolor="#DDDDED" class="bodyheader">
                                Document Name
                            </td>
                            <td colspan="2" valign="middle" class="bodycopy">
                                &nbsp;</td>
                            <td colspan="4" valign="middle" class="bodycopy">
                                <strong>Local Port &nbsp;&nbsp;&nbsp;&nbsp;Networked Printer </strong>
                            </td>
                        </tr>
                        <tr align="left" bgcolor="#F3f3f3">
                            <td height="22" valign="middle" class="bodycopy">
                                &nbsp;</td>
                            <td valign="middle" class="bodycopy">
                                AWB</td>
                            <td width="223" valign="middle" class="bodycopy">
                                <input name='txt_awb_prn_name' type="text" class="shorttextfield" value="<%= vAWBPrn %>"
                                    style="width: 210px"></td>
                            <td colspan="2" valign="middle" class="bodycopy">
                                <span class="bodyheader">
                                    <input id="Button1" class="bodycopy" onclick="javascript:findPrinter('txt_awb_prn_name','txtAWBQueue','lstAWBPort');"
                                        style="width: 70px" type="button" value="Find Printer">
                                    <% if isAdmin then %>
                                </span>
                                <div style="display: inline">
                                    <% if mode_begin then %>
                                    <div style="width: 21px; display: inline; vertical-align: text-bottom" onmouseover="showtip('Use this function to list all the printers installed on your Windows operating system.  When selected, the path or port will be inputted automatically by the system.  When done this way you DO NOT have to enter this information manually.')"
                                        onmouseout="hidetip()">
                                        <img src="../Images/button_info.gif" align="bottom" class="bodylistheader"></div>
                                    <% end if %>
                                </div>
                                <% end if %>
                                <span class="bodyheader"></span>
                            </td>
                            <td colspan="4" valign="middle" class="bodycopy">
                                <select name="lstAWBPort" size="1" class="smallselect" style="width: 60px">
                                    <option value="">N/A</option>
                                    <% for i=0 to pIndex-1 %>
                                    <option <% if vAWBPort=aPort(i) then response.write("selected") %>>
                                        <%= aPort(i) %>
                                    </option>
                                    <% next %>
                                </select>
                                <input name='txtAWBQueue' type="text" class="shorttextfield" value="<%= vAWBQueue %>"
                                    style="width: 240px"></td>
                        </tr>
                        <tr align="left" bgcolor="#FFFFFF">
                            <td height="22" valign="middle" class="bodycopy">
                                &nbsp;</td>
                            <td valign="middle" class="bodycopy">
                                B/L</td>
                            <td valign="middle" class="bodycopy">
                                <input name='txt_bol_prn_name' type="text" class="shorttextfield" value="<%= vBOLPrn %>"
                                    style="width: 210px"></td>
                            <td colspan="2" valign="middle" class="bodycopy">
                                <span class="bodyheader">
                                    <input id="Button1" class="bodycopy" onclick="javascript:findPrinter('txt_bol_prn_name','txtBOLQueue','lstBOLPort');"
                                        style="width: 70px" type="button" value="Find Printer">
                                </span>
                            </td>
                            <td colspan="4" valign="middle" class="bodycopy">
                                <b><font color="#36255a">
                                    <select name="lstBOLPort" size="1" class="smallselect" style="width: 60px">
                                        <option value="">N/A</option>
                                        <% for i=0 to pIndex-1 %>
                                        <option <% if vBOLPort=aPort(i) then response.write("selected") %>>
                                            <%= aPort(i) %>
                                        </option>
                                        <% next %>
                                    </select>
                                    <input name="txtBOLQueue" type="text" class="shorttextfield" value="<%= vBOLQueue %>"
                                        style="width: 240px">
                                </font></b>
                            </td>
                        </tr>
                        <tr align="left" bgcolor="#F3f3f3">
                            <td height="22" valign="middle" class="bodycopy">
                                &nbsp;</td>
                            <td valign="middle" class="bodycopy">
                                SED</td>
                            <td valign="middle" class="bodycopy">
                                <input name='txt_sed_prn_name' type="text" class="shorttextfield" value="<%= vSEDPrn %>"
                                    style="width: 210px"></td>
                            <td colspan="2" valign="middle" class="bodycopy">
                                <span class="bodyheader">
                                    <input id="Button1" class="bodycopy" onclick="javascript:findPrinter('txt_sed_prn_name','txtSEDQueue','lstSEDPort');"
                                        style="width: 70px" type="button" value="Find Printer">
                                </span>
                            </td>
                            <td colspan="4" valign="middle" class="bodycopy">
                                <b><font color="#36255a">
                                    <select name="lstSEDPort" size="1" class="smallselect" style="width: 60px">
                                        <option value="">N/A</option>
                                        <% for i=0 to pIndex-1 %>
                                        <option <% if vSEDPort=aPort(i) then response.write("selected") %>>
                                            <%= aPort(i) %>
                                        </option>
                                        <% next %>
                                    </select>
                                    <input name="txtSEDQueue" type="text" class="shorttextfield" value="<%= vSEDQueue %>"
                                        style="width: 240px">
                                </font></b>
                            </td>
                        </tr>
                        <tr align="left" bgcolor="#FFFFFF">
                            <td height="22" valign="middle" class="bodycopy">
                                &nbsp;</td>
                            <td valign="middle" class="bodycopy">
                                Invoice</td>
                            <td valign="middle" class="bodycopy">
                                <input name='txt_invoice_prn_name' type="text" class="shorttextfield" value="<%= vInvoicePrn %>"
                                    style="width: 210px"></td>
                            <td colspan="2" valign="middle" class="bodycopy">
                                <span class="bodyheader">
                                    <input id="Button1" class="bodycopy" onclick="javascript:findPrinter('txt_invoice_prn_name','txtInvoiceQueue','lstInvoicePort');"
                                        style="width: 70px" type="button" value="Find Printer">
                                </span>
                            </td>
                            <td colspan="4" valign="middle" class="bodycopy">
                                <b><font color="#36255a">
                                    <select name="lstInvoicePort" size="1" class="smallselect" style="width: 60px">
                                        <option value="">N/A</option>
                                        <% for i=0 to pIndex-1 %>
                                        <option <% if vInvoicePort=aPort(i) then response.write("selected") %>>
                                            <%= aPort(i) %>
                                        </option>
                                        <% next %>
                                    </select>
                                    <input name="txtInvoiceQueue" type="text" class="shorttextfield" value="<%= vInvoiceQueue %>"
                                        style="width: 240px">
                                </font></b>
                            </td>
                        </tr>
                        <tr align="left" bgcolor="#FFFFFF">
                            <td height="22" valign="middle" bgcolor="#f3f3f3" class="bodycopy">
                                &nbsp;</td>
                            <td valign="middle" bgcolor="#f3f3f3" class="bodycopy">
                                Shipping Label(Zebra)</td>
                            <td valign="middle" bgcolor="#f3f3f3" class="bodycopy">
                                <input name='txt_shipping_label_prn_name' class="shorttextfield" value="<%= vShippingLabelPrn %>"
                                    style="width: 210px"></td>
                            <td colspan="2" valign="middle" bgcolor="#f3f3f3" class="bodycopy">
                                <span class="bodyheader">
                                    <input id="Button1" class="bodycopy" onclick="javascript:findPrinter('txt_shipping_label_prn_name','txtShippingLabelQueue','lstShippingLabelPort');"
                                        style="width: 70px" type="button" value="Find Printer">
                                </span>
                            </td>
                            <td colspan="4" valign="middle" class="bodycopy">
                                <b><font color="#36255a"><b><font color="#36255a">
                                    <select name="lstShippingLabelPort" size="1" class="smallselect" style="width: 60px;">
                                        <option value="">N/A</option>
                                        <% for i=0 to pIndex-1 %>
                                        <option <% if vShippingLabelPort=aPort(i) then response.write("selected") %>>
                                            <%= aPort(i) %>
                                        </option>
                                        <% next %>
                                    </select>
                                    <input name='txtShippingLabelQueue' class="shorttextfield" value="<%= vShippingLabelQueue %>"
                                        style="width: 240px">
                                </font></b></font></b>
                                <input type="checkbox" name="add_info" value="<%=vAdd_Info%>" onclick="check_click(this)"
                                    <%if vAdd_Info = "Y" then response.write("Checked")%> style="cursor: hand">
                                Always print extra copy of address</td>
                        </tr>
                        <tr bgcolor="9190A5">
                            <td colspan="9" height="1" align="left" valign="top">
                            </td>
                        </tr>
                        <tr align="left" bgcolor="#DDDDED">
                            <td height="20" valign="middle" class="bodycopy">
                                &nbsp;</td>
                            <td valign="middle" class="bodycopy">
                                &nbsp;</td>
                            <td valign="middle" class="bodycopy">
                                <b><font color="#36255a">
                                    <select name="lstCheckPort" size="1" class="smallselect" style="width: 60px; visibility: hidden">
                                        <% for i=0 to pIndex-1 %>
                                        <option <% if vCheckPort=aPort(i) then response.write("selected") %>>
                                            <%= aPort(i) %>
                                        </option>
                                        <% next %>
                                    </select>
                                </font></b>
                            </td>
                            <td colspan="6" valign="middle" class="bodycopy">
                                <input name="txtCheckQueue" type="hidden" class="shorttextfield" value="<%= vCheckQueue %>"><input
                                    name="txt_check_prn_name" type="hidden" class="shorttextfield" value="<%= vCheckPrn %>"></td>
                        </tr>
                        <tr align="left" bgcolor="#FFFFFF" class="bodycopy">
                            <td width="2" valign="middle">
                                &nbsp;</td>
                            <td colspan="3" valign="middle">
                                Retention period for recent works (Weeks) <b><font color="#36255a">
                                    <input name="txtRecent" class="shorttextfield" style="behavior: url(../include/igNumChkLeft.htc)"
                                        value="<%= vRecent %>" size="4" maxlength="1"></font></b></td>
                            <td valign="middle">
                                <!-- <label>-->
                                <input type="radio" name="labelType" value="1" <%if cint(vLabelType)=1 then response.Write("Checked")%>
                                    style="visibility: hidden">
                                <!-- System Default</label><br><label> -->
                                <input type="radio" name="labelType" value="2" <%if cint(vLabelType)=2 then response.Write("Checked")%>
                                    style="visibility: hidden"><!--IATA (Standard)</label><br>--></td>
                            <td valign="middle">
                                &nbsp;</td>
                            <td valign="middle">
                                &nbsp;</td>
                            <td colspan="2" valign="middle">
                                &nbsp;</td>
                        </tr>
                        <tr bgcolor="9190A5">
                            <td colspan="9" height="1" align="left" valign="top">
                            </td>
                        </tr>
                        <tr align="center" valign="middle" bgcolor="#C7C6E1">
                            <td height="22" colspan="9" class="bodycopy">
                                <% if isAdmin then %>
                                <input type="image" src="../images/button_adduser.gif" width="87" height="18" onclick="AddClick(<%= TranNo %>); return false"
                                    value="Add New User" name="bAdd" style="cursor: pointer; margin-right: 30px;">
                                <%end if%>
                                <input type="image" src="../images/button_updateuser.gif" width="79" height="18"
                                    value="Update User" onclick="UpdateClick(); return false;" name="bUpdate" style="cursor: pointer;
                                    margin-right: 30px;">
                                <% if isAdmin then %>
                                <a href="javascript:;">
                                    <input type="image" src="../images/button_deleteuser.gif" width="76" height="18"
                                        value="Delete User" name="bDelete" style="cursor: pointer" onclick="DeleteClick();     return false;">
                                </a>
                                <%end if%>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        <br>
    </form>
</body>

<script type="text/javascript">
    function findPrinter(txt_name,txt_q_name,txt_port_name) {
        var strPrinter = document.getElementById(txt_name).value;
        var tmpUrl = "l=" + encodeURIComponent(strPrinter) ;
        var retVal = showModalDialog("/IFF_MAIN/ASP/include/find_print.asp?PostBack=false&"+tmpUrl,"find_print","dialogWidth:350px; dialogHeight:370px; help:0; status:0; scroll:0;center:1;Sunken;");	
        if(retVal) {
            var rs = retVal.split("^^^");
            document.getElementById(txt_name).value = rs[0];
            document.getElementById(txt_q_name).value = rs[1];
            setSelectPort(txt_port_name, rs[2] );
        }				
    }
    function setSelectPort(sName, text ) {
        var oSelect = document.getElementById(sName);
        oSelect.selectedIndex = 0;
        var items = oSelect.options;
        for( var i = 0; i < items.length; i++ ) {
            var item = items[i];
            if( item.text.toLowerCase() == text.toLowerCase() ) {
                oSelect.selectedIndex = i;
                break;
            }
        }						
    }

    function DeleteClick(){
        var sIndex=parseInt(form1.lstUser.selectedIndex);
        var UserName=document.form1.lstUser.item(sIndex).text;
        if (UserName =="admin"){
            alert("You can not delete the user [Admin]");
        }else{
            var UserID=document.form1.lstUser.value;
            if(sIndex>0){
                if(confirm("Do you really want to delete " + UserName + "?" )){	
                    document.form1.action="edit_user.asp?DeleteUser=yes&UserID=" + UserID + "&WindowName=" + window.name + "&tNo=" + "<%=TranNo%>"
                    document.form1.method="post";
                    document.form1.target = "_self";
                    form1.submit();
                }
            }
        }
    }
    function check_max_user(){     
        var   v_curUser = "<%=v_curUser%>";
        var  v_maxUser = "<%=v_maxUser%>";

        if (parseInt(v_curUser) >= parseInt(v_maxUser)){          
            alert('Maximum user account reached. Please contact system administrator.');
            return false;
        }
        return true;
    }
    function  AddClick(TranNo){
        if(!check_max_user()){          
            return;
        }      
        var NoItem=document.getElementById('hNoItem').value;        
        var arr_LoginID=document.form1.txtarr_LoginID.value.toLowerCase();
        var OrgAcct="<%=elt_account_number%>";   
        var sindex1=document.form1.lstUserType.selectedIndex;  
        var  UserType=document.form1.lstUserType.item(sindex1).value;    
        var dob=document.form1.txtIg_user_dob.value;   
        if (arr_LoginID == "admin"|| arr_LoginID == "system"||"<%=isAdmin%>" == "True")
        {  
            if (arr_LoginID==""||arr_LoginID==undefined)
            {
                alert('Please enter a Login ID!');
                return;
            }
            for (i=0;i< NoItem;i++)
            {
                if (arr_LoginID==document.form1.lstUser.item(i).text.toLowerCase()){

                    alert("Login ID: " + arr_LoginID + " exists already.");
                    return ;
                }              
            } 
            if (form1.txtPassword1.value!=form1.txtPassword2.value){
                alert( "The second password doesn't march the first password!");
                return ;
            }
            document.form1.action="edit_user.asp?AddUser=yes&tNo=" + TranNo + "&WindowName=" + window.name;
            document.form1.target = "_self";
            document.form1.method="POST";
            form1.submit();
        }
    }

    function UpdateClick(){  

        var arr_LoginID=form1.txtarr_LoginID.value.toLowerCase();
        if (arr_LoginID==""|| arr_LoginID==undefined){
            alert( "Please enter the login ID!");   
            return;
        }        
        var NoItem=parseInt(document.form1.hNoItem.value);
        var sIndex=0;
        var UserID=0;
        var UserName="";

        if ("<%=isAdmin%>" == "True")
        {            
            sIndex=parseInt(form1.lstUser.selectedIndex);
            UserID=parseInt(document.form1.lstUser.item(sIndex).value);
            UserName =  document.form1.lstUser.item(sIndex).text;
            if (sIndex == 0 && ( arr_LoginID =="admin" || arr_LoginID == "system")) {
                alert( "ID: admin exists already!");
                return; 
            }   
            if(UserName.toLowerCase()== "admin" &&   arr_LoginID != "admin" )
            {
                alert( "You can't change admin ID!");
                return;
            } 
        }else
        {
            UserID="<%=user_id%>";
            UserName="<%=login_name%>";
            sIndex=1;

            if ( arr_LoginID =="admin" || arr_LoginID == "system") {
                alert( "ID: admin exists already!");
                return; 
            }   

            if(UserName.toLowerCase()== "admin" &&   arr_LoginID != "admin" )
            {
                alert( "You can't change admin ID!");
                return;
            }
        }      
        if(arr_LoginID.toLowerCase() != UserName.toLowerCase()) 
        {
            var iCnt = 0	;
            for( i=0 ;i< NoItem;i++)
            {
                if (arr_LoginID.toLowerCase()==document.form1.lstUser.item(i).text.toLowerCase()) 
                {
                    iCnt = iCnt + 1;           
                }
            }		
            if (iCnt > 0 )
            {
                alert( "ID: " + arr_LoginID + " exists already.");
            }
        }
	
        var sindex2=document.form1.lstUserOrg.selectedIndex;
        var OrgAcct="<%=elt_account_number%>";
        var sindex1=document.form1.lstUserType.selectedIndex;
        var UserType=parseInt(document.form1.lstUserType.item(sindex1).value);     

        if( form1.txtPassword1.value!=form1.txtPassword2.value){           
            alert( "The second password doesn't match the first password!");
            return;
        }
        if (sIndex==0 ){
            alert( "Please select a user to update!");
            return;
        }
        document.form1.action="edit_user.asp?UpdateUser=yes&UserID=" + UserID +  "&tNo=" + "<%=TranNo%>" + "&WindowName=" +  window.name;
        document.form1.target = "_self";
        document.form1.method="POST";
        form1.submit();
    }

    
    function ChangeUser(){

        var sIndex=form1.lstUser.selectedIndex;
        var UserID=parseInt(document.form1.lstUser.item(sIndex).value);
        document.form1.action="edit_user.asp?EditUser=yes&UserID=" + UserID + "&tNo=" + "<%=TranNo%>" + "&WindowName=" + window.name;
        document.form1.target = "_self";
        document.form1.method="POST";
        form1.submit();
    }
    function check_click(obj){
        if(obj.value=="Y"){
            obj.value="N";
        }else{
            obj.value="Y";
        }
    }
    function GoPageSet() {
        if(document.form1.lstUser.selectedIndex > 0){
            var UserID=document.form1.lstUser.value;
            // var sURL = "../../aspx/OnLines/UserAuth/UserAuth.aspx?ff="+UserID+"&WindowName=PopWin";
            var sURL = "module_manager.asp?UID=" + UserID;
            viewPop(sURL);
        }
        else
        {
            alert('Please select Login ID for user.');
        }
    }
</script>

<!-- //for Tooltip// -->

<script language="JavaScript" type="text/javascript" src="../include/tooltips.js"></script>

<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
