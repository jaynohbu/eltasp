<!--  #INCLUDE FILE="../include/transaction.txt" -->
<%
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<!--  #INCLUDE FILE="../include/connection.asp" -->
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Chart of Accounts</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        body {
	        margin-left: 0px;
	        margin-right: 0px;
	        margin-bottom: 0px;
        }
    </style>
</head>
<!--  #INCLUDE FILE="../include/header.asp" -->
    <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
<!--  #include file="../include/recent_file.asp" -->
<!--  #include file="../include/GOOFY_Util_fun.inc" -->
<%
Dim rs, SQL,add,delete,update,setup,dAccount
Dim glAccount(),glAccountType(),glAccountDesc(),aItemUsed(),a_control_no(),a_gl_default(),glVendorNo()
Dim vglAccount,vglAccountType,vglAccountDesc,vglAccountBal,v_control_no,v_gl_default
Set rs = Server.CreateObject("ADODB.Recordset")
add=Request("add")
setup=Request.QueryString("setup").Item
delete=Request("delete")
update=Request("update")

eltConn.BeginTrans()

if delete="yes" then
	dAccount=Request.QueryString("dAccount")
	if dAccount="" then dAccount=0
	SQL= "delete from gl where elt_account_number = " & elt_account_number & " and gl_account_number=" & dAccount
	eltConn.Execute SQL
	SQL= "delete from all_accounts_journal where elt_account_number = " & elt_account_number & " and gl_account_number=" & dAccount
	eltConn.Execute SQL
end if

if update="yes" then
	rNo=Request.QueryString("rNo")
	vglAccount=Request("glAccount" & rNo)
	if vglAccount="" then vglAccount=0
	vglAccountType=Request("glAccountType" & rNo)
	vglMasterType = get_master_account( vglAccountType )
	vglAccountDesc=Request("glAccountDesc" & rNo)
	v_control_no=Request("txt_control_no" & rNo)
	v_gl_default=Request("chk_gl_default_item" & rNo)

	if v_gl_default = "Y" then 	call reset_default(vglAccount)

	SQL= "select gl_account_type,gl_master_type,gl_account_Desc,control_no,gl_default from gl where elt_account_number = " & elt_account_number & " and gl_account_number=" & vglAccount
	rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
	if Not rs.EOF Then 
		rs("gl_account_type") = vglAccountType
		rs("gl_master_type")=vglMasterType
		rs("gl_account_Desc") = vglAccountDesc
		if v_control_no = "" or isnull(v_control_no) then
			rs("control_no") = null
		else
			rs("control_no") = v_control_no
		end if	
		rs("gl_default") = v_gl_default
		rs.Update
	end if
	rs.Close
end if

TranNo=Session("TranNo")
if TranNo="" then
Session("TranNo")=0
TranNo=0
end if
tNo=CInt(Request.QueryString("tNo"))

if add="yes" And tNo=TranNo then

  	Session("TranNo")=Clng(Session("TranNo"))+1
	TranNo=Clng(Session("TranNo"))
	vglAccount=Request("txtAccount")
	vglAccountType=Request("lstAccountType")
	vglMasterType = get_master_account( vglAccountType )
	vglAccountDesc=Request("txtAccountDesc")
	v_control_no=Request("txt_control_no")
	v_gl_default=Request("chk_gl_default")

	If v_gl_default = "Y" Then
	    call reset_default(vglAccount)
	End If

	SQL= "select * from gl where elt_account_number = " & elt_account_number & " and gl_account_number = " & vglAccount
	rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
	
	if rs.eof then
		rs.AddNew
		rs("elt_account_number") = elt_account_number
		rs("gl_account_number") = vglAccount
		rs("gl_account_type") = vglAccountType
		rs("gl_master_type")=vglMasterType
		rs("gl_account_Desc") = vglAccountDesc
		rs("gl_account_status") = "A"
		rs("gl_account_cDate") = Date
			if v_control_no = "" or isnull(v_control_no) then
				rs("control_no") = null
			else
				rs("control_no") = v_control_no
			end if	
		rs("gl_default") = v_gl_default
		rs.Update
	end if
	rs.Close	

    'insert to all_accounts_journal
	SQL= "select max(tran_seq_num) as SeqNo from all_accounts_journal where elt_account_number = " & elt_account_number
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
	If Not rs.EOF And IsNull(rs("SeqNo"))=False Then
		SeqNo = CLng(rs("SeqNo")) + 1
	Else
		SeqNo=1
	End If
	rs.Close
	
	SQL= "select elt_account_number,tran_seq_num,gl_account_number,gl_account_name,balance,previous_balance,gl_balance,gl_previous_balance,credit_amount,debit_amount,tran_date,tran_type from all_accounts_journal where elt_account_number = " & elt_account_number & " and tran_seq_num=" & SeqNo
	rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText

	if rs.eof then
		rs.AddNew
		rs("elt_account_number")=elt_account_number
		rs("tran_seq_num")=SeqNo
		rs("gl_account_number")=vglAccount
		rs("gl_account_name")=vglAccountDesc
		rs("balance") =0
		rs("previous_balance")=0
		rs("gl_balance") =0
		rs("gl_previous_balance")=0
		rs("credit_amount") =0
		rs("debit_amount") =0
		rs("tran_date")=Now
		rs("tran_type")=""
		rs.Update
	end if
	rs.Close
end if

If Request.QueryString("setup") = "yes" Then
    SQL = "If NOT EXISTS (SELECT * FROM gl WHERE elt_account_number=" & elt_account_number _
        & ") INSERT INTO gl (elt_account_number, gl_account_number, gl_account_desc, gl_master_type, gl_account_type, gl_account_balance, gl_begin_balance, gl_account_status, gl_account_cdate, gl_last_modified) " _
        & "SELECT '" & elt_account_number  & "', gl_account_number, gl_account_desc, gl_master_type, gl_account_type, 0, gl_begin_balance, 'A', getdate(), getdate() FROM gl AS gl_copy where elt_account_number=10001000"
    eltConn.Execute SQL
End If

SQL= "select gl_account_number,gl_account_type,gl_account_desc,control_no,gl_default,ISNULL(gl_vendor_no,0) AS gl_vendor_no "_
    & "from gl where elt_account_number=" & elt_account_number & " order by cast(gl_account_number as nvarchar)"

rs.CursorLocation = adUseClient
rs.Open SQL, eltConn, adOpenStatic, adLockPessimistic, adCmdText
Set rs.activeConnection = Nothing
tIndex = rs.RecordCount-1

ReDim glAccount(tIndex),glAccountType(tIndex),glAccountDesc(tIndex),a_control_no(tIndex),a_gl_default(tIndex),aItemUsed(tIndex),glVendorNo(tIndex)

tIndex=0
Do While Not rs.EOF
    glAccount(tIndex)=rs("gl_account_number")
    glAccountType(tIndex)=rs("gl_account_type")
    glAccountDesc(tIndex)=rs("gl_account_desc")
    a_control_no(tIndex)=rs("control_no")
    a_gl_default(tIndex)=rs("gl_default")
    glVendorNo(tIndex)=rs("gl_vendor_no")
    tIndex = tIndex+1
    rs.MoveNext
Loop
rs.Close

CALL CHECK_ITEM_USED
Set rs=Nothing

eltConn.CommitTrans()

Sub reset_default(vglAccount)
    SQL = "update gl set gl_default = null where elt_account_number = " & elt_account_number 
    eltConn.Execute(SQL)
end sub

FUNCTION get_master_account( vglAccountType )
	if vglAccountType=CONST__CURRENT_ASSET or vglAccountType=CONST__FIXED_ASSET or vglAccountType=CONST__OTHER_ASSET or vglAccountType=CONST__ACCOUNT_RECEIVABLE or vglAccountType=CONST__BANK then
		get_master_account=CONST__MASTER_ASSET_NAME
	elseif vglAccountType=CONST__CURRENT_LIB or vglAccountType=CONST__LONG_TERM_LIB or vglAccountType=CONST__ACCOUNT_PAYABLE then
		get_master_account=CONST__MASTER_LIABILITY_NAME
	elseif vglAccountType=CONST__EQUITY then
		get_master_account=CONST__MASTER_EQUITY_NAME
	elseif vglAccountType=CONST__REVENUE or vglAccountType=CONST__OTHER_REVENUE then
		get_master_account=CONST__MASTER_REVENUE_NAME
	elseif vglAccountType=CONST__COST_OF_SALES or  vglAccountType=CONST__EXPENSE or vglAccountType=CONST__OTHER_EXPENSE then
		get_master_account=CONST__MASTER_EXPENSE_NAME
	else
		get_master_account=""
	end if
END FUNCTION

SUB CHECK_ITEM_USED
    for iii=0 to tIndex-1
	    if not glAccount(iii) = "" then
		    SQL= "select top 1 gl_account_number from all_accounts_journal where elt_account_number = " & elt_account_number & " and isnull(tran_type,'') <> '' and gl_account_number=" & glAccount(iii)
		    rs.CursorLocation = adUseClient
		    rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
		    Set rs.activeConnection = Nothing
		    if not rs.eof then
			    aItemUsed(iii) = "Y"
		    end if
		    rs.close
	    end if
    next
END SUB

%>
<body link="336699" vlink="336699" topmargin="0">
    <form name="form1" method="post" action="edit_account.asp">
        <table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
            <tr>
                <td height="32" align="left" valign="middle" class="pageheader">
                    Chart of Accounts</td>
            </tr>
        </table>
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#89A979"
            bgcolor="#89A979" class="border1px">
            <tr>
                <td>
                    <input type="hidden" name="hNoItem" value="<%= tIndex %>" />
                    <input type="hidden" name="glAccount" />
                    <!-- start of scroll bar -->
                    <input type="hidden" name="scrollPositionX" />
                    <input type="hidden" name="scrollPositionY" />
                    <!-- end of scroll bar -->
                    <table width="100%" cellpadding="0" cellspacing="0" >
                        <tr bgcolor="D5E8CB">
                            <td colspan="9" height="8" align="left" valign="top" class="bodyheader">
                            </td>
                        </tr>
                        <tr align="left" valign="middle" bgcolor="89A979">
                            <td colspan="9" height="1" class="bodyheader">
                            </td>
                        </tr>
                        <tr align="left" valign="middle" bgcolor="ecf7f8">
                            <td bgcolor="E7F0E2" class="bodyheader">
                                &nbsp;</td>
                            <td bgcolor="E7F0E2" class="bodyheader">
                                Account No.</td>
                            <td bgcolor="E7F0E2" class="bodyheader">
                                Account Type</td>
                            <td bgcolor="E7F0E2" class="bodyheader">
                                Description</td>
                            <td bgcolor="E7F0E2" class="bodyheader"></td>
                            <td bgcolor="E7F0E2" class="bodyheader" id="td_check_no">
                                Check No.
                            </td>
                            <td bgcolor="E7F0E2" class="bodyheader" id="td_def">
                                Default Bank
                            </td>
                            <td bgcolor="E7F0E2" class="bodyheader">
                                &nbsp;</td>
                            <td bgcolor="E7F0E2" class="bodyheader">
                                &nbsp;</td>
                        </tr>
                        <tr align="left" valign="middle" bgcolor="f3f3f3">
                            <td bgcolor="#FFFFFF">
                                &nbsp;</td>
                            <td height="26" bgcolor="#FFFFFF">
                                <input name="txtAccount" class="shorttextfield" size="14" style="behavior: url(../include/igNumChkLeft.htc)"
                                    maxlength="5"></td>
                            <td bgcolor="#FFFFFF">
                                <select name="lstAccountType" size="1" class="smallselect" style="width: 170px" onchange="javascript:on_type_change(this);">
                                    <option>
                                        <%=CONST__CURRENT_ASSET%>
                                    </option>
                                    <option>
                                        <%=CONST__ACCOUNT_RECEIVABLE%>
                                    </option>
                                    <option>
                                        <%=CONST__FIXED_ASSET%>
                                    </option>
                                    <option>
                                        <%=CONST__OTHER_ASSET%>
                                    </option>
                                    <option>
                                        <%=CONST__BANK%>
                                    </option>
                                    <option>
                                        <%=CONST__CURRENT_LIB%>
                                    </option>
                                    <option>
                                        <%=CONST__ACCOUNT_PAYABLE%>
                                    </option>
                                    <option>
                                        <%=CONST__LONG_TERM_LIB%>
                                    </option>
                                    <option>
                                        <%=CONST__EQUITY%>
                                    </option>
                                    <option>
                                        <%=CONST__REVENUE%>
                                    </option>
                                    <option>
                                        <%=CONST__COST_OF_SALES%>
                                    </option>
                                    <option>
                                        <%=CONST__EXPENSE%>
                                    </option>
                                    <option>
                                        <%=CONST__OTHER_REVENUE%>
                                    </option>
                                    <option>
                                        <%=CONST__OTHER_EXPENSE%>
                                    </option>
                                </select>
                            </td>
                            <td bgcolor="#FFFFFF" class="bodyheader">
                                <input name="txtAccountDesc" maxlength="128" class="shorttextfield" size="50"></td>
                            <td bgcolor="#FFFFFF"></td>
                            <td bgcolor="#FFFFFF">
                                <input id="txt_control_no" type="text" name="txt_control_no" maxlength="18" class="shorttextfield"
                                    size="10" style="behavior: url(../include/igNumChkLeft.htc); visibility: hidden"></td>
                            <td bgcolor="#FFFFFF">
                                <input id="chk_gl_default" name="chk_gl_default" type="checkbox" style="cursor: hand;
                                    visibility: hidden" onclick="javascript:cClick(this);" /></td>
                            <td colspan="2" bgcolor="#FFFFFF">
                                <img src="../images/button_add.gif" width="37" height="17" onclick="AddAccount(<%= TranNo %>)"
                                    style="cursor: hand" alt="" /></td>
                        </tr>
                        <tr align="left" valign="middle" bgcolor="89A979">
                            <td colspan="9" height="2" class="bodyheader">
                            </td>
                        </tr>
                        <tr align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                            <td height="8" colspan="9" bgcolor="#FFFFFF">
                            </td>
                        </tr>
                        <input type="hidden" id="hItemUsed" />
                        <% for i=0 to tIndex-1 %>
                        <tr align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                            <td width="6" bgcolor="#FFFFFF">
                                &nbsp;</td>
                            <td width="116" bgcolor="#FFFFFF">
                                <input name="glAccount<%= i %>" class="d_shorttextfield glAccount" id="glAccount" value="<%= glAccount(i) %>"
                                    size="14" style="behavior: url(../include/igNumChkLeft.htc)" readonly="true"><input
                                        type="hidden" id="hItemUsed" class="hItemUsed" value="<%= aItemUsed(i) %>">
                            </td>
                            <td height="20" bgcolor="#FFFFFF">
                                <b>
                                    <select name="glAccountType<%= i %>" id="glAccountType<%= i %>" size="1" class="smallselect glAccountType" style="width: 170px"
                                        onchange="javascript:on_type_change_item(this,<%=i%>);">
                                        <option <% if glAccountType(i)=CONST__CURRENT_ASSET then response.write("Selected") %>>
                                            <%=CONST__CURRENT_ASSET%>
                                        </option>
                                        <option <% if glAccountType(i)=CONST__ACCOUNT_RECEIVABLE then response.write("Selected") %>>
                                            <%=CONST__ACCOUNT_RECEIVABLE%>
                                        </option>
                                        <option <% if glAccountType(i)=CONST__FIXED_ASSET then response.write("Selected") %>>
                                            <%=CONST__FIXED_ASSET%>
                                        </option>
                                        <option <% if glAccountType(i)=CONST__OTHER_ASSET then response.write("Selected") %>>
                                            <%=CONST__OTHER_ASSET%>
                                        </option>
                                        <option <% if glAccountType(i)=CONST__BANK then response.write("Selected") %>>
                                            <%=CONST__BANK%>
                                        </option>
                                        <option <% if glAccountType(i)=CONST__CURRENT_LIB then response.write("Selected") %>>
                                            <%=CONST__CURRENT_LIB%>
                                        </option>
                                        <option <% if glAccountType(i)=CONST__ACCOUNT_PAYABLE then response.write("Selected") %>>
                                            <%=CONST__ACCOUNT_PAYABLE%>
                                        </option>
                                        <option <% if glAccountType(i)=CONST__LONG_TERM_LIB then response.write("Selected") %>>
                                            <%=CONST__LONG_TERM_LIB%>
                                        </option>
                                        <option <% if glAccountType(i)=CONST__EQUITY then response.write("Selected") %>>
                                            <%=CONST__EQUITY%>
                                        </option>
                                        <option <% if glAccountType(i)=CONST__REVENUE then response.write("Selected") %>>
                                            <%=CONST__REVENUE%>
                                        </option>
                                        <option <% if glAccountType(i)=CONST__COST_OF_SALES then response.write("Selected") %>>
                                            <%=CONST__COST_OF_SALES%>
                                        </option>
                                        <option <% if glAccountType(i)=CONST__EXPENSE then response.write("Selected") %>>
                                            <%=CONST__EXPENSE%>
                                        </option>
                                        <option <% if glAccountType(i)=CONST__OTHER_REVENUE then response.write("Selected") %>>
                                            <%=CONST__OTHER_REVENUE%>
                                        </option>
                                        <option <% if glAccountType(i)=CONST__OTHER_EXPENSE then response.write("Selected") %>>
                                            <%=CONST__OTHER_EXPENSE%>
                                        </option>
                                    </select>
                                </b>
                            </td>
                            <td>
                                <b>
                                    <input name="glAccountDesc<%= i %>" class="shorttextfield" maxlength="128" value="<%= glAccountDesc(i) %>"
                                        size="50" />
                                </b>
                            </td>
                            <td bgcolor="#FFFFFF">
                            <!--
                            <% If (glAccountType(i)=CONST__CURRENT_LIB Or glAccountType(i)=CONST__LONG_TERM_LIB) Then %>
                                <% If glVendorNo(i)<>"0" Then %>
                                    <% if Not aItemUsed(i) = "Y" then %>
                                        <a href="javascript:SetCreditCardVendor('<%=glAccount(i) %>','<%=glVendorNo(i) %>','<%=GetBusinessName(glVendorNo(i)) %>')"><%=GetBusinessName(glVendorNo(i)) %></a>
                                    <% Else %>
                                        <%=GetBusinessName(glVendorNo(i)) %>
                                    <% End If %>
                                <% Else %>
                                    <input name="btnCreditCard" type="button" value="Credit Card" class="bodycopy" onclick="SetCreditCardVendor('<%=glAccount(i) %>','','')"/>              
                                <% End If %>
                            <% End If %>
                            -->
                            </td>
                            <td>
                                <input id="txt_control_no<%= i %>" type="text" name="txt_control_no<%= i %>" maxlength="18"
                                    class="shorttextfield" size="10" style="behavior: url(../include/igNumChkLeft.htc);
                                    visibility: <% if glAccountType(i) = CONST__BANK then response.write("visible") else response.write("hidden") end if%>"
                                    value='<%=a_control_no(i)%>' /></td>
                            <td>
                                <input id="chk_gl_default_item<%= i %>" name="chk_gl_default_item<%= i %>" type="checkbox"
                                    style="cursor: hand; visibility: <% if glAccountType(i) = CONST__BANK then response.write("visible") else response.write("hidden") end if%>"
                                    onclick="javascript:cClickItem(this);" value='<%=a_gl_default(i)%>' <% if a_gl_default(i) = "Y" then response.write "checked='checked'"%> /></td>
                            <td>
                                <b>
                                    <% if Not aItemUsed(i) = "Y" then %>
                                    <img src="../images/button_delete.gif" width="50" height="17" onclick="DeleteAccount(<%= glAccount(i) %>)"
                                        style="cursor: hand" alt="" />
                                </b>
                                <% end if%>
                            </td>
                            <td>
                                <img src="../images/button_update.gif" width="52" height="18" onclick="UpdateAccount(<%= i %>)"
                                    style="cursor: hand" alt="" /></td>
                        </tr>
                        <tr align="left" valign="middle" bgcolor="#ccddcc" class="bodycopy">
                            <td height="1" colspan="8">
                            </td>
                        </tr>
                        <% next %>
                        <tr align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                            <td height="8" colspan="9">
                            </td>
                        </tr>
                        <tr align="left" valign="middle" bgcolor="#89A979">
                            <td colspan="9" height="1" class="bodyheader">
                            </td>
                        </tr>
                        <tr align="center" bgcolor="#D5E8CB">
                            <td height="24" colspan="9" valign="middle" bgcolor="D5E8CB" class="bodycopy">
                                &nbsp;</td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        <br>
    </form>
</body>

<script type="text/javascript">
    function on_type_change(oSelect) {
	    var CONST__BANK = '<%=CONST__BANK%>';
	    if(CONST__BANK == '') {
		    return false;
	    }
	    try {
			var o = document.getElementById('txt_control_no');
			var oc = document.getElementById('chk_gl_default');
			var oTd_o = document.getElementById('td_check_no');
			var oTd_oc = document.getElementById('td_def');
		
			if( CONST__BANK == oSelect.options[ oSelect.options.selectedIndex ].text ){
				o.style.visibility = "visible";
			} else {
				o.style.visibility = "hidden";
			}

			oc.style.visibility = o.style.visibility;
		} catch(f) {}
        return false;	
    }
    
    function SetCreditCardVendor(glAcct,agentAcct,agentName){
        var vURL = "set_credit_card_vendor.asp?WindowName=SetCreditCardVendor&glAcct=" + glAcct 
            + "&agentAcct=" + agentAcct + "&agentName=" + encodeURIComponent(agentName);
        showJPModal(vURL, "chart_acct.asp", 450, 280, "SetCreditCardVendor");
    }
    
    function on_type_change_item(oSelect,i) {

	    var CONST__BANK = '<%=CONST__BANK%>';
    	
	    if(CONST__BANK == '') {
		    return false;
	    }

	    try {
			    var o = document.getElementById('txt_control_no'+i);
			    var oc = document.getElementById('chk_gl_default_item'+i);
			    var oTd_o = document.getElementById('td_check_no'+i);
			    var oTd_oc = document.getElementById('td_def'+i);
    		
			    if( CONST__BANK == oSelect.options[ oSelect.options.selectedIndex ].text ){
				    o.style.visibility = "visible";
			    } else {
				    o.style.visibility = "hidden";
			    }
			    oc.style.visibility = o.style.visibility;
		    } catch(f) {}
	    return false;	
    }

function cClick(o) {
	if(o.checked) {
		o.value = 'Y';
	} else	{
		o.value = '';
	}
}
function cClickItem(o) {
var s = o.checked;
	reset_default();
	if(s) {
		o.value = 'Y';
	} else	{
		o.value = '';
	}
	o.checked = s;
}

function reset_default() {

		var CONST__BANK = '<%=CONST__BANK%>';
		if(CONST__BANK == '') { return false; }
		var  index = '<%=tIndex%>';	
		for( i=0; i<index;i++) {
			oSelect = document.getElementById('glAccountType'+i);
			if (CONST__BANK == oSelect.options[oSelect.options.selectedIndex].text) {
				$("chk_gl_default_item"+i).value = '';
				$("chk_gl_default_item"+i).checked = false;
			}
		}
}

function AddAccount(TranNo){
    var AddOK=false;
    var Account = document.form1.txtAccount.value;
    var tIndex=parseInt(document.form1.hNoItem.value);

    if ( Account!="") {
	    AddOK=true;
	    if (!IsNumeric(Account)) {
		    AddOK=false;
		    alert( "Please enter a numerical value for account number");
	    }
    }
    else{
	    alert( "Please enter a account number");
	    return false;
    }

    for (var i=0; i< tIndex; i++){
	    if (Account == $("input.glAccount").get(i).value ){
	         alert( "Account Number: " + Account + " exists already. ");
	         return false;
	    }
    }

    if (AddOK) {
        document.form1.action = "chart_acct.asp?add=yes" + "&tNo=" + TranNo + "&WindowName=" + window.name;
        document.form1.method = "POST";
        document.form1.target = "_self";
        form1.submit();
    }
}
function DeleteAccount(Account){
	if (confirm("Are you sure you want to delete this account? \r\nContinue?")){
		document.form1.action="chart_acct.asp?delete=yes&dAccount=" + Account+ "&WindowName=" +window.name;
		document.form1.method="POST";
	    document.form1.target="_self";
		form1.submit();
	}
}
function UpdateAccount(rNo){
    if ($("input.hItemUsed").get(rNo).value == "Y" ){
        if (!confirm("This Account No. is belong to some account document already. \r\nAre you want to update this item? \r\nContinue?"))
          return false;
    }
    document.form1.action = "chart_acct.asp?update=yes&rNo=" + rNo + "&WindowName=" + window.name;
    document.form1.method = "POST";
    document.form1.target = "_self";
    form1.submit();
}

</script>

<script type="text/vbscript">
<!---


Sub MenuMouseOver()
End Sub
Sub MenuMouseOut()
End Sub
--->
</script>

<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
