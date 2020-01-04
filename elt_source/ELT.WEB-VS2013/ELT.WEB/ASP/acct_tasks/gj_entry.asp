<!--  #INCLUDE FILE="../include/transaction.txt" -->
<!--  #INCLUDE FILE="../include/connection.asp" -->
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>General Journal Entry</title>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/ASP/ajaxFunctions/ajax.js"></script>
    <script type="text/javascript" src="../Include/JPED.js"></script>
    <script type="text/javascript" src="../Include/JPTableDOM.js"></script>
    <style type="text/css">
        body
        {
            margin-left: 0px;
            margin-right: 0px;
            margin-bottom: 0px;
        }
    </style>
    <!--  #INCLUDE FILE="../include/header.asp" -->
    <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
    <!--  #include file="../include/recent_file.asp" -->
    <!--  #include file="../include/GOOFY_util_fun.inc" -->
    <!--  #include file="../include/GOOFY_Util_Ver_2.inc" -->
    <%
Dim rs, SQL
Set rs = Server.CreateObject("ADODB.Recordset")

Dim aDebit(64),aCredit(64),aAccount(64),aAcctType(64),aMemo(64),aSplit(64),aName(64),aAcct(64)
Dim Save,AddItem,DeleteItem
TranNo=Session("TranNo")
if TranNo="" then
	Session("TranNo")=0
	TranNo=0
end if
tNo=Clng(Request.QueryString("tNo"))
AddItem=Request.QueryString("AddItem")
DeleteItem=Request.QueryString("DeleteItem")
Save=Request.QueryString("save")
View=Request.QueryString("View")
vEntryNo=Request("txtEntryNo")


eltConn.BeginTrans()

'get gl info
Dim glAccount(1024),glType(1024),glDesc(1024),glName ',glName(1000000)
SQL= "select gl_account_number,gl_account_type,gl_account_desc,gl_account_desc from gl where elt_account_number=" & elt_account_number & " order by gl_account_number"
rs.CursorLocation = adUseClient
rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
Set rs.activeConnection = Nothing
glIndex=0
Set glName = Server.CreateObject("Scripting.Dictionary")

Do While Not rs.EOF
	glAccount(glIndex)=cLng(rs("gl_account_number"))
	glType(glIndex)=rs("gl_account_type")
	glDesc(glIndex)=rs("gl_account_desc")
'	glName(rs("gl_account_number"))=rs("gl_account_desc")
	glName.Add rs("gl_account_number").value, rs("gl_account_desc").value
	glIndex=glIndex+1
	rs.MoveNext
Loop
rs.Close

'get vendor or customer info
Dim aOrg_Name(),aOrg_ACCT()

SQL= "select dba_name,org_account_number from organization where elt_account_number=" & elt_account_number & "   and isnull(dba_name,'') <> '' order by dba_name"
rs.CursorLocation = adUseClient
rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
Set rs.activeConnection = Nothing

reDim aOrg_Name(rs.RecordCount+1)
reDim aOrg_ACCT(rs.RecordCount+1)

aOrg_Name(0)="Select One"
aOrg_ACCT(0)=-1
nIndex=1

Do While Not rs.EOF
	aOrg_Name(nIndex)=rs("dba_name")
	aOrg_ACCT(nIndex)=rs("org_account_number")
	if Not IsNull(aOrg_ACCT(nIndex)) then
		aOrg_ACCT(nIndex)=cLng(aOrg_ACCT(nIndex))
	else
		aOrg_ACCT(nIndex)=0
	end if
	rs.MoveNext
	nIndex=nIndex+1
Loop
rs.Close

Dim tIndex
tIndex=0
NoItem=0
vDate=Date

if Save="yes" or AddItem ="yes" or DeleteItem="yes" then
	vDate=Request("txtDate")
	'vEntryNo=Request("txtEntryNo")
	NoItem=Request("hNoItem")
	if NoItem="" then
		NoItem=0
	else
		NoItem=CInt(NoItem)
	end if

'///////////////////////////////////	
	if NoItem = 0 then NoItem = 1
'///////////////////////////////////	
		
	for i=0 to NoItem-1
		aInfo=Request("lstAccount" & i)
		pos=0
		pos=instr(aInfo,"-")
		if pos>0 then
			aAccount(i)=cLng(Mid(aInfo,1,pos-1))
			aAcctType(i)=Mid(aInfo,pos+1,100)
		end if
		aCredit(i)=Request("txtCredit" & i)
		if aCredit(i)="" then aCredit(i)=0
		aDebit(i)=Request("txtDebit" & i)
		if aDebit(i)="" then aDebit(i)=0
		aMemo(i)=Request("txtMemo" & i)
		
		aAcct(i) = ConvertAnyValue(Request.Form("hCustomer" & i & "Acct").Item, "Integer", 0)
		aName(i) = Request.Form("lstCustomer" & i & "Name").Item
	next
	tIndex=NoItem

	if DeleteItem="yes" then
		dItemNo=Request.QueryString("dItemNo")
		for i=dItemNo to NoItem+1
			aAccount(i)=aAccount(i+1)
			aAcctType(i)=aAcctType(i+1)
			aCredit(i)=aCredit(i+1)
			aDebit(i)=aDebit(i+1)
			aMemo(i)=aMemo(i+1)
			aAcct(i)=aAcct(i+1)
		next		
		NoItem=NoItem-1
	end if
	tIndex=NoItem
	if save="yes" And TranNo=tNo then
  		Session("TranNo")=Clng(Session("TranNo"))+1
		TranNo=Clng(Session("TranNo"))
'insert to all_accounts_journal for GJE tran type
		SQL= "select max(tran_seq_num) as SeqNo from all_accounts_journal where elt_account_number = " & elt_account_number
		rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
		If Not rs.EOF And IsNull(rs("SeqNo"))=False Then
			SeqNo = CLng(rs("SeqNo")) + 1
		Else
			SeqNo=1
		End If
		rs.Close
		if vEntryNo="" then
			SQL= "select max(cast(tran_num as decimal)) as entry_no from all_accounts_journal where elt_account_number = " & elt_account_number & " and tran_type='GJE'"
			rs.CursorLocation = adUseClient
			rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
			Set rs.activeConnection = Nothing
			If Not rs.EOF And IsNull(rs("entry_no"))=False Then
				vEntryNo = cInt(rs("entry_no")) + 1
			Else
				vEntryNo=1
			End If
			rs.Close
		end if
		SQL= "delete from all_accounts_journal where elt_account_number = " & elt_account_number & " and tran_type='GJE' and tran_num=" & vEntryNo
		eltConn.Execute SQL
		for i=0 to NoItem-1
			SQL= "select * from all_accounts_journal where elt_account_number = " & elt_account_number & " and tran_seq_num=" & SeqNo
			rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
			'rs.Open "all_accounts_journal", eltConn, adOpenDynamic, adLockPessimistic, adCmdTable
			if rs.eof then
				rs.AddNew
				rs("elt_account_number")=elt_account_number
				rs("gl_account_number")=aAccount(i)
				rs("gl_account_name")=glName(aAccount(i))
				rs("tran_seq_num")=SeqNo
				rs("tran_date")=vDate
				rs("tran_type")="GJE"
				rs("tran_num")=vEntryNo
				if aAcct(i)>0 then
					rs("customer_number")=aAcct(i)
					rs("customer_name")=aName(i)
				end if
				rs("split")=""
				rs("tran_date")=vDate
				rs("memo")=aMemo(i)
				rs("debit_amount")=aDebit(i)
				rs("credit_amount")=-aCredit(i)
				rs.Update
				SeqNo=SeqNo+1
			end if
			rs.Close

		next
'insert to general_journal_entry table for GJE tran type
		SQL= "delete from general_journal_entry where elt_account_number = " & elt_account_number & " and entry_no=" & vEntryNo
		eltConn.Execute SQL
		for i=0 to NoItem-1
			SQL= "select elt_account_number,entry_no,item_no,gl_account_number,credit,debit,memo,org_acct,dt from general_journal_entry where elt_account_number = " & elt_account_number & " and entry_no=" & vEntryNo & " and item_no=" & i+1
			rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
'			rs.Open "general_journal_entry", eltConn, adOpenDynamic, adLockPessimistic, adCmdTable
			if rs.eof then
				rs.AddNew
				rs("elt_account_number")=elt_account_number
				rs("entry_no")=vEntryNo
				rs("item_no")=i+1
				rs("gl_account_number")=aAccount(i)
				rs("credit")=aCredit(i)
				rs("debit")=aDebit(i)
				rs("memo")=aMemo(i)
				rs("org_acct")=aAcct(i)
				rs("dt")=vDate
				rs.Update
			end if
			rs.Close
		next
'insert to invoice or bill table if acct type is AR or AP
		DeleteInvoice=False
		DeleteBill=False
		for i=0 to NoItem-1
			if aAcctType(i)="Accounts Receivable" then
				if DeleteInvoice=False then
					SQL= "delete from invoice where elt_account_number = " & elt_account_number & " and invoice_type='G' and ref_no='" & vEntryNo & "'"
					eltConn.Execute SQL
					DeleteInvoice=True
				end if
				SQL= "select max(invoice_no) as InvoiceNo from Invoice where elt_account_number = " & elt_account_number
				rs.CursorLocation = adUseClient
				rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
				Set rs.activeConnection = Nothing
				If Not rs.EOF And IsNull(rs("InvoiceNo"))=False Then
					InvoiceNo = CLng(rs("InvoiceNo")) + 1
				Else
					InvoiceNo=10001
				End If
				rs.Close
				SQL = "select elt_account_number,Invoice_No,invoice_type,Invoice_Date,ref_no,Customer_number,customer_name,accounts_receivable,amount_charged,amount_paid,balance,pay_status from invoice where elt_account_number="&elt_account_number&" and invoice_no="&InvoiceNo
				rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
				'rs.Open "invoice", eltConn, adOpenDynamic, adLockPessimistic, adCmdTable
				if rs.eof then
					rs.AddNew
					rs("elt_account_number")=elt_account_number
					rs("Invoice_No")=InvoiceNo
					rs("invoice_type")="G"
					rs("Invoice_Date")=vDate
					rs("ref_no")=vEntryNo
					rs("Customer_number") = aAcct(i)
					rs("customer_name") = aName(i)
					rs("accounts_receivable") = aAccount(i)
					rs("amount_paid") = 0
					rs("amount_charged") = aDebit(i)-aCredit(i)
					rs("balance") = aDebit(i)-aCredit(i)
					rs("pay_status")="A"
					rs.Update
				end if
				rs.Close
			elseif aAcctType(i)="Accounts Payable" then
				if DeleteBill=False then
					SQL= "delete from bill where elt_account_number = " & elt_account_number & " and bill_type='G' and ref_no='" & vEntryNo & "'"
					eltConn.Execute SQL
					DeleteBill=True
				end if
				SQL= "select max(bill_number) as BillNo from bill where elt_account_number = " & elt_account_number
				rs.CursorLocation = adUseClient
				rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
				Set rs.activeConnection = Nothing
				If Not rs.EOF And IsNull(rs("BillNo"))=False Then
					BillNo=CLng(rs("BillNo"))+1
				Else
					BillNo=1
				End If
				rs.Close
				SQL = "select * from bill where elt_account_number="&elt_account_number&" and bill_number="&BillNo
				rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
				
				'// Response.Write(SQL)

				if rs.eof then
					rs.AddNew
					rs("elt_account_number")=elt_account_number
					rs("bill_number")=BillNo
					rs("bill_type")="G"
					rs("bill_Date")=vDate
					rs("bill_due_date")=vDate
					rs("ref_no")=vEntryNo
					rs("vendor_number")=aAcct(i)
					rs("vendor_name")=aName(i)
					rs("bill_ap")=aAccount(i)
					rs("bill_amt")=aCredit(i) - aDebit(i)
					rs("bill_amt_due")=aCredit(i) - aDebit(i)
					rs("bill_status")="A"
					rs.Update
				end if
				rs.Close
			end if
		next
		tIndex=0
		NoItem=0
		aAccount(0)=0
		aAcctType(0)=""
		aDebit(0)=0
		aCredit(0)=0
		aMemo(0)=""
		aName(0)=-1
		If IsNull(vEntryNo) Or Trim(vEntryNo)="" Then
			Response.redirect("gj_entry.asp")
		Else
			SQL= "select gl_account_number,credit,debit,memo,org_acct,dt from general_journal_entry where elt_account_number=" & elt_account_number & " and entry_no=" & vEntryNo & " order by item_no"
			rs.CursorLocation = adUseClient
			rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
			Set rs.activeConnection = Nothing
			tIndex=0
			Do While Not rs.EOF
				aAccount(tIndex)=cLng(rs("gl_account_number"))
				aCredit(tIndex)=rs("credit")
				aDebit(tIndex)=rs("debit")
				aMemo(tIndex)=rs("memo")
				aAcct(tIndex)=cLng(rs("org_acct"))
				'// Response.Write(aName(tIndex))
				vDate=rs("dt")
				tIndex=tIndex+1
				rs.MoveNext
			Loop
			rs.Close
			NoItem=tIndex
		End If
		
	end if
elseif View="yes" then
	vEntryNo=Request.QueryString("EntryNo")
	SQL= "select gl_account_number,credit,debit,memo,org_acct,dt from general_journal_entry where elt_account_number=" & elt_account_number & " and entry_no=" & vEntryNo & " order by item_no"
	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing
	tIndex=0
	Do While Not rs.EOF
		aAccount(tIndex)=cLng(rs("gl_account_number"))
		aCredit(tIndex)=rs("credit")
		aDebit(tIndex)=rs("debit")
		aMemo(tIndex)=rs("memo")
		aAcct(tIndex)=cLng(rs("org_acct"))
		vDate=rs("dt")
		tIndex=tIndex+1
		rs.MoveNext
	Loop
	rs.Close
	NoItem=tIndex
ElseIf Request.QueryString("DeleteAll")="yes" Then
	SQL = "delete from general_journal_entry where elt_account_number=" _
		& elt_account_number & " and entry_no=" & vEntryNo
	eltConn.Execute SQL
	SQL = "delete from all_accounts_journal where elt_account_number=" _
		& elt_account_number & " and tran_type='GJE' and tran_num=" & vEntryNo
	eltConn.Execute SQL
	'// vEntryNo=""
end If


Set rs=Nothing

eltConn.CommitTrans()


    %>
    <script type="text/javascript">
        <% For i=0 To tIndex %>
        function lstCustomer<%=i %>NameChange(orgNum,orgName){
            var hiddenObj = document.getElementById("hCustomer<%=i %>Acct");
            var txtObj = document.getElementById("lstCustomer<%=i %>Name");
            var divObj = document.getElementById("lstCustomer<%=i %>NameDiv");

            hiddenObj.value = orgNum;
            txtObj.value = orgName;
            
            try{
                divObj.style.position = "absolute";
                divObj.style.visibility = "hidden";
                divObj.style.height = "0px";
            }catch(err){}
        }
        <% Next %>
    </script>
</head>
<body link="336699" vlink="336699" topmargin="0" onload="self.focus()">
    <form name="form1" method="post">
    <table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
        <tr>
            <td height="32" align="left" valign="middle" class="pageheader">
                General Journal Entry
            </td>
        </tr>
    </table>
    <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#89A979"
        bgcolor="#89A979" class="border1px">
        <tr>
            <td>
                <!-- start of scroll bar -->
                <input type="hidden" name="scrollPositionX" />
                <input type="hidden" name="scrollPositionY" />
                <!-- end of scroll bar -->
                <input type="hidden" name="hNoItem" value="<%= NoItem %>">
                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                    <tr bgcolor="D5E8CB">
                        <td height="24" colspan="8" align="center" valign="middle" bgcolor="D5E8CB" class="bodyheader">
                            <table width="98%" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td width="25%">
                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    </td>
                                    <td width="50%" align="center" valign="middle">
                                        <img src="../images/button_save_medium.gif" name="bSave" onclick="SaveClick(<%= TranNo %>)"
                                            <% if UserRight<5 or Not Branch="" then response.write("disabled") %> style="cursor: hand">
                                    </td>
                                    <td width="12%" align="right" valign="middle">
                                        &nbsp;
                                    </td>
                                    <td width="13%" align="right" valign="middle">
                                        <% If vEntryNo <> "" And (UserRight<5 Or Not Branch="") Then %>
                                        <img src="../images/button_delete_medium.gif" name="bDelete" onclick="DeleteClick(<%= TranNo %>)"
                                            style="cursor: hand" alt="" />
                                        <% End If %>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr align="left" valign="middle" bgcolor="89A979">
                        <td colspan="8" height="1" class="bodyheader">
                        </td>
                    </tr>
                    <tr align="right" valign="middle" bgcolor="ecf7f8">
                        <td align="left" bgcolor="#E7F0E2" class="bodycopy">
                            &nbsp;
                        </td>
                        <td height="20" align="left" bgcolor="#E7F0E2" class="bodycopy">
                            <strong><font color="c16b42">Entry No.</font></strong>&nbsp;&nbsp;
                        </td>
                        <td align="left" bgcolor="#E7F0E2">
                            <span class="bodycopy"><strong>Date</strong></span>
                        </td>
                        <td align="left" bgcolor="#E7F0E2">
                            &nbsp;
                        </td>
                        <td align="left" bgcolor="#E7F0E2">
                            &nbsp;
                        </td>
                        <td align="left" bgcolor="#E7F0E2">
                        </td>
                        <td align="left" bgcolor="#E7F0E2">
                        </td>
                        <td align="left" bgcolor="#E7F0E2">
                        </td>
                    </tr>
                    <tr align="right" valign="middle" bgcolor="#FFFFFF">
                        <td align="left" class="bodycopy">
                            &nbsp;
                        </td>
                        <td height="20" align="left" class="bodycopy">
                            <input name="txtEntryNo" class="readonlybold" value="<%= vEntryNo %>" size="16" readonly>
                        </td>
                        <td align="left">
                            <span class="bodycopy">
                                <input name="txtDate" class="m_shorttextfield date" preset="shortdate" value="<%= vDate %>"
                                    size="16">
                            </span>
                        </td>
                        <td align="left">
                            &nbsp;
                        </td>
                        <td align="left">
                            &nbsp;
                        </td>
                        <td align="left">
                        </td>
                        <td align="left">
                        </td>
                        <td align="left">
                        </td>
                    </tr>
                    <tr align="left" valign="middle" bgcolor="89A979">
                        <td colspan="8" height="2" class="bodyheader">
                        </td>
                    </tr>
                    <tr align="left" valign="middle" bgcolor="ecf7f8">
                        <td width="7" bgcolor="#f3f3f3" class="bodyheader">
                            &nbsp;
                        </td>
                        <td width="163" height="22" bgcolor="#f3f3f3" class="bodyheader">
                            Account
                        </td>
                        <td width="193" bgcolor="#f3f3f3" class="bodyheader">
                            &nbsp;
                        </td>
                        <td width="104" bgcolor="#f3f3f3" class="bodyheader">
                            Debit
                        </td>
                        <td width="110" bgcolor="#f3f3f3" class="bodyheader">
                            Credit
                        </td>
                        <td width="229" bgcolor="#f3f3f3" class="bodyheader">
                            Memo
                        </td>
                        <td width="289" bgcolor="#f3f3f3" class="bodyheader">
                            Name
                        </td>
                        <td width="73" bgcolor="#f3f3f3" class="bodyheader">
                            &nbsp;
                        </td>
                    </tr>
                    <input type="hidden" id="Account" />
                    <input type="hidden" id="Debit" />
                    <input type="hidden" id="Credit" />
                    <input type="hidden" id="Memo" />
                    <% for i=0 to tIndex-1 %>
                    <tr align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                        <td width="7" bgcolor="#FFFFFF">
                            &nbsp;
                        </td>
                        <td height="20" colspan="2" bgcolor="#FFFFFF">
                            <select name="lstAccount<%= i %>" class="smallselect Account" id="Account" style="width: 290px">
                                <option value="0">Select One</option>
                                <% for j=0 to glIndex-1 %>
                                <option value="<%= glAccount(j) & "-" & glType(j) %>" <% if aAccount(i)=glAccount(j) then response.write("selected") %>>
                                    <%= glType(j) & string(30-len(glType(j)),"-") & glDesc(j) %>
                                </option>
                                <% next %>
                            </select>
                        </td>
                        <td>
                            <input name="txtDebit<%= i %>" class="numberfield Debit" id="Debit" style="behavior: url(../include/igNumDotChkLeft.htc)"
                                value="<%=formatnumber( aDebit(i),2,,,0) %>" size="10" />
                        </td>
                        <td>
                            <input name="txtCredit<%= i %>" class="numberfield Credit" id="Credit" style="behavior: url(../include/igNumDotChkLeft.htc)"
                                value="<%= formatnumber(aCredit(i),2,,,0) %>" size="10" />
                        </td>
                        <td>
                            <input name="txtMemo<%= i %>" class="shorttextfield Memo" id="Memo" value="<%= aMemo(i) %>"
                                size="30" />
                        </td>
                        <td>
                            <!-- Start JPED -->
                            <input type="hidden" id="hCustomer<%=i %>Acct" name="hCustomer<%=i %>Acct" value="<%=aAcct(i) %>" />
                            <div id="lstCustomer<%=i %>NameDiv">
                            </div>
                            <table cellpadding="0" cellspacing="0" border="0">
                                <tr>
                                    <td>
                                        <input type="text" autocomplete="off" id="lstCustomer<%=i %>Name" name="lstCustomer<%=i %>Name"
                                            value="<%=GetBusinessName(aAcct(i)) %>" class="shorttextfield" style="width: 220px;
                                            border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-left: 1px solid #7F9DB9;
                                            border-right: 0px solid #7F9DB9;" onkeyup="organizationFill(this,'All','lstCustomer<%=i %>NameChange',null,event)"
                                            onfocus="initializeJPEDField(this,event);" />
                                    </td>
                                    <td>
                                        <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstCustomer<%=i %>Name','All','lstCustomer<%=i %>NameChange',null,event)"
                                            style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                            border-left: 0px solid #7F9DB9; cursor: hand;" />
                                    </td>
                                </tr>
                            </table>
                            <!-- End JPED -->
                        </td>
                        <td>
                            <img src="../images/button_delete.gif" width="50" height="17" onclick="DeleteItem(<%= i %>)"
                                <% if UserRight<5 or Not Branch="" then response.write("disabled") %> style="cursor: hand">
                        </td>
                    </tr>
                    <% next %>
                    <tr align="left" valign="middle" bgcolor="f3f3f3">
                        <td width="7" bgcolor="#FFFFFF">
                            &nbsp;
                        </td>
                        <td height="20" colspan="2" bgcolor="#FFFFFF">
                            <select name="lstAccount<%=tIndex %>" class="smallselect Account" id="Account" style="width: 290px">
                                <option value="0">Select One</option>
                                <% for j=0 to glIndex-1 %>
                                <option value="<%= glAccount(j) & "-" & glType(j) %>">
                                    <%= glType(j) & string(30-len(glType(j)),"-") & glDesc(j) %>
                                </option>
                                <% next %>
                            </select>
                        </td>
                        <td bgcolor="#FFFFFF">
                            <input name="txtDebit<%=tIndex %>" style="behavior: url(../include/igNumDotChkLeft.htc)"
                                class="numberfield Debit" id="Debit" value="" size="10">
                        </td>
                        <td bgcolor="#FFFFFF">
                            <input name="txtCredit<%=tIndex %>" style="behavior: url(../include/igNumDotChkLeft.htc)"
                                class="numberfield Credit" id="Credit" value="" size="10">
                        </td>
                        <td bgcolor="#FFFFFF">
                            <input name="txtMemo<%=tIndex %>" class="shorttextfield Memo" id="Memo" value="" size="30">
                        </td>
                        <td bgcolor="#FFFFFF">
                            <!-- Start JPED -->
                            <input type="hidden" id="hCustomer<%=tIndex %>Acct" name="hCustomer<%=tIndex %>Acct"
                                value="" />
                            <div id="lstCustomer<%=tIndex %>NameDiv">
                            </div>
                            <table cellpadding="0" cellspacing="0" border="0">
                                <tr>
                                    <td>
                                        <input type="text" autocomplete="off" id="lstCustomer<%=tIndex %>Name" name="lstCustomer<%=tIndex %>Name"
                                            value="" class="shorttextfield" style="width: 220px; border-top: 1px solid #7F9DB9;
                                            border-bottom: 1px solid #7F9DB9; border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;"
                                            onkeyup="organizationFill(this,'All','lstCustomer<%=tIndex %>NameChange',null,event)"
                                            onfocus="initializeJPEDField(this,event);" />
                                    </td>
                                    <td>
                                        <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstCustomer<%=tIndex %>Name','All','lstCustomer<%=tIndex %>NameChange',null,event)"
                                            style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                            border-left: 0px solid #7F9DB9; cursor: hand;" />
                                    </td>
                                </tr>
                            </table>
                            <!-- End JPED -->
                        </td>
                        <td bgcolor="#FFFFFF">
                            <img src="../images/button_additem.gif" width="64" height="18" name="bAddItem" onclick="AddItem()"
                                <% if UserRight<5 or Not Branch="" then response.write("disabled") %> style="cursor: hand">
                        </td>
                    </tr>
                    <tr>
                        <td colspan="8" style="height: 10px; background-color: #ffffff">
                        </td>
                    </tr>
                    <tr align="left" valign="middle" bgcolor="89A979">
                        <td colspan="8" height="1" class="bodyheader">
                        </td>
                    </tr>
                    <tr align="center" bgcolor="D5E8CB">
                        <td height="24" colspan="8" valign="middle" bgcolor="D5E8CB" class="bodycopy">
                            <table width="98%" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td width="25%">
                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    </td>
                                    <td width="50%" align="center" valign="middle">
                                        <img src="../images/button_save_medium.gif" name="bSave" onclick="SaveClick(<%= TranNo %>)"
                                            <% if UserRight<5 or Not Branch="" then response.write("disabled") %> style="cursor: hand">
                                    </td>
                                    <td width="12%" align="right" valign="middle">
                                        &nbsp;
                                    </td>
                                    <td width="13%" align="right" valign="middle">
                                        <% If vEntryNo <> "" And (UserRight<5 Or Not Branch="") Then %>
                                        <img src="../images/button_delete_medium.gif" name="bDelete" onclick="DeleteClick(<%= TranNo %>)"
                                            style="cursor: hand" alt="" />
                                        <% End If %>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br />
    </form>
</body>
<script type="text/javascript">
function AddItem(){
    var sindex=document.form1.hNoItem.value;
    if (sindex=="" )
	    sindex=0;
    else
	    sindex=parseInt(sindex);

    if ($("select.Account").get(sindex).selectedIndex>0 ){
	    document.form1.hNoItem.value=sindex+1;
	    document.form1.action="gj_entry.asp?AddItem=yes"+ "&WindowName=" + window.name ;
	    document.form1.method="POST";
	    document.form1.target="_self";
	    form1.submit();
    }
    else
	    alert( "Please select an Account!");

}
function DeleteItem(ItemNo){
    if (confirm("Do you really want to delete this item? \r\nContinue?")) {
        document.form1.action = "gj_entry.asp?DeleteItem=yes&dItemNo=" + ItemNo + "&WindowName=" + window.name;
        document.form1.method = "POST";
        document.form1.target = "_self";
        form1.submit();
    }
}

function DeleteClick(TranNo){
    var NoItem=document.form1.hNoItem.value;
    var EnteyNo = document.form1.txtEntryNo.value;
    if (NoItem <= 0 ){
	    alert( "There are no items to delete");
	    return false;
    }
 
    if (EnteyNo == "" ){
        alert( "There are no Entey No. to delete");
     	return false;
    }

  if (confirm("Do you really want to delete this General Journal Entry ? \r\nContinue?")) {
        document.form1.action = "gj_entry.asp?DeleteAll=yes&dItemNo=" + ItemNo + "&WindowName=" + window.name;
        document.form1.method = "POST";
        document.form1.target = "_self";
        form1.submit();
    }
}
function SaveClick(TranNo){
    var NoItem = document.form1.hNoItem.value;
    if (NoItem <= 0 ){
	    alert( "Please add at least one item.");
	    return false;
    }

    var save="yes";
	var tCredit=0;
	var tDebit=0;
	
	for (var i=0; i<NoItem; i++){
		var Credit=$("input.Credit").get(i).value;
		if (Credit=="" ) 
            Credit=0;
		if (!IsNumeric(Credit) ){
			alert( "Please enter a numeric value for Credit!");
			save="no";
			break;
		}
		tCredit=tCredit+ parseFloat(Credit);
		var Debit=$("input.Debit").get(i).value;
		
		if (Debit == "" ) 
            Debit = 0;
		
		if (!IsNumeric(Debit) ){
			alert("Please enter a numeric value for Debit!");
			save="no";
			break;
		}
		tDebit=tDebit+parseFloat(Debit);
		var sindex = $("select.Account").get(i).selectedIndex
		var aInfo = $("select.Account").get(i).children.item(sindex).text;
		var pos=aInfo.indexOf("-");

		if( pos>=0 ){
		    var aType=aInfo.substring(0,pos);
			var s1 = document.getElementById("hCustomer"+i+ "Acct").value;
			if( s1 == "" ) 
                s1 = 0;
			
			if (aType=="Accounts Receivable") {
				if (s1 == 0 ){
					alert("Please select a Customer!");
					save = "no";
					break;
				}
			}	
			else if (aType=="Accounts Payable" ){
				if (s1 == 0 ){
					alert( "Please select a Vendor!");
					save = "no";
					break;
				}
			}
		}
	}
	
	if (save=="yes" ){
		if ( tCredit!=tDebit ){
			alert("The transaction is not in balance. Please make sure the total amount in the debit column \r\nequals the total amount in the credit column.");
			save="no";
		}
	}
	
	if (save=="yes" ){
	    document.form1.action = "gj_entry.asp?save=yes&tNo=" + TranNo + "&WindowName=" + window.name;
	    document.form1.method = "POST";
	    document.form1.target = "_self";
	    form1.submit();
	}
}

function ItemChange(rNo) { // no ItemName here
    //    var sIndex=document.all("ItemName").item(rNo).selectedIndex
//    if sIndex=1 then
//	    'document.form1.action="edit_invoice.asp?new=yes&Delete=yes&rNo=" & rNo
//	    'document.form1.method="POST"
//	     window.open "add_item.asp" & "?WindowName=" & window.name,"PopupNew", "<%=StrWindow %>"
//    end if
}
</script>
<script type="text/vbscript" language="vbscript">



Sub MenuMouseOver()
    NoItem=document.form1.hNoItem.Value
    for i=1 to NoItem+1
	    document.all("Name").item(i).style.visibility="hidden"
    next
End Sub

Sub MenuMouseOut()
    NoItem=document.form1.hNoItem.Value
    for i=1 to NoItem+1
	    document.all("Name").item(i).style.visibility="visible"
    next
End Sub

</script>
<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
