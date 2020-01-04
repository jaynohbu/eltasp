<%@  language="VBScript" %>
<!--  #INCLUDE FILE="../include/connection.asp" -->
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Print Checks</title>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
.style2 {color: #000000}
-->
</style>
</head>
<!-- #INCLUDE FILE="../include/header.asp" -->
    <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
<!-- #INCLUDE file="../include/recent_file.asp" -->
<!-- #INCLUDE FILE="../include/GOOFY_util_fun.inc" -->
<%
Dim rs, SQL
Set rs = Server.CreateObject("ADODB.Recordset")

Dim CheckDate(256),Vendor(256),CheckAmt(256),CheckType(256),VendorInfo(256),vMemo(256),PrintCheckAs(256)
Dim CheckInfo(256)
Dim Print1

'/////////////////////////////////////////////////// by iMoon multi-Check#
Dim BankAcct(80),BankAcctName(80),ExpenseAcct(100),ExpenseName(100)
DIM bankIndex,exIndex
Dim dpBal(32),QueueId,Del
Print1=Request.QueryString("Print")
vNextCheckNo=Request.QueryString("NextCheckNo")


eltConn.BeginTrans()

Call delete_queue

If IsNumeric(vNextCheckNo) Then
    vNextCheckNo = CLng(vNextCheckNo)
Else
    vNextCheckNo = 0
End If

if Print1="Yes" then
	NoItem=Request("hNoItem")
	for i=0 to NoItem-1
		vChecked=Request("cCheck" & i)
		vStatus=Request("cStatus" & i)
		
		if vChecked="Y" and vStatus = "ok" then
			vCheckInfo=Request("hCheckInfo" & i)
			pos=instr(vCheckInfo,"-")
			if pos>0 then
				CheckQueueID=Mid(vCheckInfo,1,pos-1)
				vCheckInfo=Mid(vCheckInfo,pos+1,200)
			else
				CheckQueueID=0
			end if
			pos=instr(vCheckInfo,"@")
			if pos>0 then
				vCheckNo=Mid(vCheckInfo,pos+1,200)
			end if
			if pos>0 then
			end if
			if CheckQueueID>0 then
				SQL= "select print_status,check_no from check_queue where elt_account_number = " & elt_account_number & " and print_id=" & CheckQueueID & " and pmt_method = 'Check'"
				rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
				if 	( instr(	vCheckNo, "@" ) = 0 )then		
					if not rs.EOF then
						rs("print_status")="N"
						rs("check_no")=vCheckNo
						rs.Update
					end if
				end if
				rs.Close
				SQL= "select check_no from all_accounts_journal where elt_account_number = " & elt_account_number & " and tran_num=" & CheckQueueID & " and (tran_type='CHK' or tran_type='BP-CHK')"
				rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
				Do While not rs.EOF
				 if 	( instr(	vCheckNo, "@" ) = 0 )then		
					rs("check_no")=vCheckNo
					rs.Update
				 end if	
					rs.MoveNext
				Loop
				rs.Close
			end if
		end if
	next
	
	BankAcctNo=Request("lstBank")
	if BankAcctNo="" or isnull(BankAcctNo) then
		BankAcctNo=0
	else
		pos=0
		pos=instr(BankAcctNo,"^")
		if pos>0 then
			BankAcctNo=cLng(Mid(BankAcctNo,1,pos-1))
		else
			BankAcctNo=cLng(BankAcctNo)
		end if
	end if
	
	call check_number_update( BankAcctNo, vNextCheckNo )
'	if Not vNextCheckNo=0 then
'		SQL= "select next_check_no from user_profile where elt_account_number = " & elt_account_number
'		rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
'		if not rs.EOF then
'			rs("next_check_no")=vNextCheckNo
'			rs.Update
'		end if
'		rs.Close
'	end if
end if

'// get bank info and A/P
SQL= "select * from gl where elt_account_number = " & elt_account_number & " and (gl_account_type='"&CONST__BANK&"' or gl_account_type='"& CONST__ACCOUNT_PAYABLE &"' or gl_account_type='"&CONST__EXPENSE&"' or gl_account_type='"&CONST__COST_OF_SALES&"' or gl_account_type='"&CONST__OTHER_EXPENSE&"') order by isnull(gl_default,'') desc, cast(gl_account_number as nvarchar)"
rs.Open SQL, eltConn, , , adCmdText

'///////////////////////////////////////////////////// by iMoon Jan-20-2007 for multi-check#

DIM ChkHashTable
Set ChkHashTable = Server.CreateObject("System.Collections.HashTable")

bankIndex=0
exIndex=0

Do While Not rs.EOF
	BankType=rs("gl_account_type")
	if BankType=CONST__BANK then
		BankAcct(bankIndex)=clng(rs("gl_account_number"))
		BankAcctName(bankIndex)=rs("gl_account_desc")
        ChkHashTable.Add BankAcct(bankIndex), rs("control_no").Value
		bankIndex=bankIndex+1
	else
		ExpenseName(exIndex)=rs("gl_account_desc")
		ExpenseAcct(exIndex)=clng(rs("gl_account_number"))
		exIndex=exIndex+1
	end if

	rs.MoveNext
Loop
rs.Close
if BankAcctNo = 0 then
	BankAcctNo = BankAcct(0)
end if

last_date = get_fiscal_year_of_last_date( year(date) )
first_date = get_fiscal_year_of_first_date( last_date )

'// get bank balance
SQL= "select a.gl_account_number as gl,sum(a.credit_amount+a.debit_amount+ISNULL(a.debit_memo,0)+ISNULL(a.credit_memo,0)) as balance from all_accounts_journal a, gl b where a.elt_account_number=b.elt_account_number and a.elt_account_number= " & elt_account_number  & " and a.gl_account_number=b.gl_account_number and b.gl_account_type='"&CONST__BANK&"' and a.tran_date >='" & first_date & "' and a.tran_date >='" & first_date & "' and a.tran_date < DATEADD(day, 1,'"& last_date &"')   Group by a.gl_account_number order by a.gl_account_number"

rs.Open SQL, eltConn, , , adCmdText
BankAcctNo=cLng(BankAcctNo)
Do While Not rs.EOF
	if BankAcctNo=0 then 
		BankAcctNo=cLng(rs("gl"))
	end if	
	for i = 0 to bankIndex
		if BankAcct(i) = cLng(rs("gl")) then
			dpBal(i)=rs("balance")
			exit for
		end if
	next
	rs.MoveNext
Loop
rs.Close

'// get all checks waiting to print
'// SQL= "select * from check_queue where elt_account_number = " & elt_account_number & " and print_status='A' and print_id=2097 order by bill_due_date"
SQL= "select * from check_queue where elt_account_number = " & elt_account_number & " and print_status='A'"  & " and pmt_method = 'Check'" & " order by bill_due_date"
'// response.write SQL
rs.Open SQL, eltConn, , , adCmdText
tIndex=0
Do While Not rs.EOF
On Error Resume Next:
	PrintID=rs("print_id")
	VendorNo=rs("vendor_number")
	Bank=rs("bank")
	CheckInfo(tIndex)=PrintID & "-" & VendorNo & "-" & Bank
	CheckDate(tIndex)=rs("bill_date")
	'BillDueDate(tIndex)=rs("bill_due_date")
	Vendor(tIndex)=rs("vendor_name")
	PrintCheckAs(tIndex)=rs("print_check_as")
	if isnull(PrintCheckAs(tIndex)) or PrintCheckAs(tIndex)= "" then
		PrintCheckAs(tIndex) = Vendor(tIndex)
	end if
	VendorInfo(tIndex)=rs("vendor_info")
	vMemo(tIndex)=rs("memo")
	CheckAmt(tIndex)=formatNumber(rs("check_amt"),2)
	CheckType(tIndex)=rs("check_type")
	tIndex=tIndex+1
	rs.MoveNext
Loop
rs.Close

'/////////////////////////////////////////////////////////////////////// by ig
DIM BillInvoiceNo(128,64), BillAmt(128,64),detailIndex,aDetailIndex(128) 
'///////////////////////////////////////////////////////////////////////

for i=0 to tIndex-1
	
	pos=Instr(CheckInfo(i),"-")
	
	tmpPrintID = Mid(CheckInfo(i),1,pos-1)

	SQL= "select * from check_detail where elt_account_number=" & elt_account_number & " and print_id=" & tmpPrintID

	rs.Open SQL, eltConn, , , adCmdText
	detailIndex = 0
	Do While Not rs.EOF
		BillInvoiceNo(i,detailIndex)=rs("invoice_no")
		BillAmt(i,detailIndex)=rs("amt_paid")
		detailIndex = detailIndex + 1
		rs.MoveNext
	Loop
	rs.Close
	aDetailIndex(i) = detailIndex
next

'// get next check no
SQL= "select elt_account_number,next_check_no from user_profile where elt_account_number = " & elt_account_number
rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
if Not rs.EOF then
    vNextCheckNo=rs("next_check_no")
else
    rs.AddNew
    vNextCheckNo=1
    rs("elt_account_number")=elt_account_number
    rs("next_check_no")=vNextCheckNo
    rs.Update
end if
rs.Close
Set rs=Nothing
vPrintPort=checkPort

eltConn.CommitTrans()

Sub Delete_queue
    DIM SQL
    QueueId = Request.QueryString("QueueId")
    Del = Request.QueryString("Del")
    if isnull(QueueId) then QueueId = ""
    if isnull(Del) then Del = ""
    if del <> "" and QueueId <> "" then
	    if del = "Yes" then
		    SQL = " update check_queue set print_status = 'N' where elt_account_number=" _
		        & elt_account_number & " and  print_id=" & QueueId
		    eltConn.Execute(SQL)
	    end if
    end if
end sub
%>
<!--  #INCLUDE FILE="functions_for_ap.inc" -->
<body link="336699" vlink="336699" topmargin="0" style="height:1000px" >
    <form name="form1" method="POST">
    <table width="95%" border="0" align="center" cellpadding="2" cellspacing="0" >
        <tr>
            <td width="50%" height="32" align="left" valign="middle" class="pageheader">
                Print Checks
            </td>
            <td width="50%" align="right" valign="middle">
                <div id="print">
                    <img src="/ASP/Images/icon_printer.gif" width="40" height="27" align="absbottom"><a
                        href="javascript:;" onclick="PrintClick();return false;">Print Checks</a></div>
            </td>
        </tr>
    </table>
    <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#89A979"
        bgcolor="#89A979" class="border1px">
        <tr>
            <td>
                <input type="hidden" name="hPrintPort" value="<%= vPrintPort %>" />
                <input type="hidden" name="hClientOS" value="<%= ClientOS %>" />
                <input type="hidden" name="hNoItem" value="<%= tIndex %>" />
                <input type="hidden" name="hCheckNo" value="<%=ChkHashTable(BankAcctNo)%>" />
                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                    <tr bgcolor="D5E8CB">
                        <td colspan="8" height="8" align="left" valign="top" class="bodyheader">
                        </td>
                    </tr>
                    <tr align="left" valign="middle" bgcolor="89A979">
                        <td colspan="8" height="1" class="bodyheader">
                        </td>
                    </tr>
                    <tr align="right" valign="middle" bgcolor="#FFFFFF">
                        <td align="left" bgcolor="#E7F0E2" class="bodycopy">
                            &nbsp;
                        </td>
                        <td height="20" colspan="2" align="left" bgcolor="#E7F0E2">
                            <span class="bodyheader"><span class="bodycopy"><font color="c16b42"><strong>Bank Account</strong></font></span></span>
                        </td>
                        <td align="left" bgcolor="#E7F0E2">
                            <span class="bodycopy style2"><strong>Starting Check No.</strong></span>
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
                            &nbsp;&nbsp;
                        </td>
                        <td height="26" colspan="2" align="left" bgcolor="#FFFFFF">
                            <font size="3"><b>
                                <select name="lstBank" size="1" class="smallselect" style="width: 240px" onchange="BalChange()">
                                    <% for i=0 to bankIndex-1 %>
                                    <option value="<%= BankACCT(i) & "^" & dpBal(i) & "^" & ChkHashTable(BankAcct(i))%>"
                                        <% if cLng(BankAcctNo)=cLng(BankAcct(i)) then response.write("selected") %>>
                                        <%= BankAcctName(i) %></option>
                                    <% next %>
                                </select>
                            </b></font>
                        </td>
                        <td align="left">
                            <span class="bodycopy">
                                <input name="txtCheck" type="text" class="bodyheader" value="<%=ChkHashTable(BankAcctNo)%>"
                                    size="14">
                            </span>
                        </td>
                        <td align="left">
                            &nbsp;
                        </td>
                        <td align="left">
                            &nbsp;
                        </td>
                        <td align="left">
                            &nbsp;
                        </td>
                        <td align="left">
                            <input name="txtAcctBalance" class="readonlyboldright" type="hidden" value="<%= formatnumber(vAcctBalance,2) %>"
                                size="18" style="behavior: url(../include/igNumChkRight.htc)">
                        </td>
                    </tr>
                    <tr align="left" valign="middle" bgcolor="89A979">
                        <td colspan="8" height="2" class="bodyheader">
                        </td>
                    </tr>
                    <tr align="left" valign="middle" bgcolor="ecf7f8">
                        <td width="29" height="20" bgcolor="#f3f3f3">
                            &nbsp;
                        </td>
                        <td width="71" height="20" bgcolor="#f3f3f3" class="bodyheader">
                            Check Date
                        </td>
                        <td width="224" bgcolor="#f3f3f3" class="bodyheader">
                            Vendor
                        </td>
                        <td width="380" bgcolor="#f3f3f3" class="bodyheader">
                            PAY TO THE ORDER OF
                        </td>
                        <td width="128" bgcolor="#f3f3f3" class="bodyheader">
                            Check Amount
                        </td>
                        <td width="107" bgcolor="#f3f3f3" class="bodyheader">
                            Edit Check
                        </td>
                        <td width="229" bgcolor="#f3f3f3" class="bodyheader" align="center">
                            Delete Queue
                        </td>
                        <td width="229" bgcolor="#f3f3f3" class="bodyheader">
                            &nbsp;
                        </td>
                    </tr>
                    <input type="hidden" id="CheckInfo">
                    <input type="hidden" id="CheckDate">
                    <input type="hidden" id="cChecked">
                    <input type="hidden" id="cStatus">
                    <input type="hidden" id="Vendor">
                    <input type="hidden" id="VendorInfo">
                    <input type="hidden" id="vMemo">
                    <input type="hidden" id="vDIndex">
                    <input type="hidden" id="CheckAmt">
                    <input type="hidden" id="CheckType">
                    <input type="hidden" id="PrintCheckAs">
                    <% for i=0 to tIndex-1 %>
                    <tr align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                        <td width="29" align="center" bgcolor="#FFFFFF">
                            <input type="checkbox" id="cChecked" class="cChecked" name="cCheck<%= i %>" value="Y">
                            <input type="hidden" name="hCheckInfo<%= i %>" id="CheckInfo" class="CheckInfo" value="<%= CheckInfo(i) %>">
                        </td>
                        <td>
                            <b>
                                <input name="txtCheckDate<%= i %>" type="text" class="m_shorttextfield date" preset="shortdate"
                                    id="CheckDate" value="<%= CheckDate(i) %>" size="10">
                            </b>
                        </td>
                        <td>
                            <input name="txtVendor<%= i %>" type="text" class="d_shorttextfield" id="Vendor"
                                value="<%= Vendor(i) %>" size="40" readonly="true">
                        </td>
                        <td>
                            <b>
                                <input name="txtPrintCheckAs<%= i %>" type="text" class="d_shorttextfield" id="PrintCheckAs"
                                    value="<%= PrintCheckAs(i) %>" size="60" readonly="true">
                                <input type="hidden" id="VendorInfo" value="<%= VendorInfo(i) %>">
                                <input type="hidden" id="vMemo" value="<%= vMemo(i) %>">
                                <input type="hidden" id="vDIndex" value="<%= aDetailIndex(i) %>">
                        </td>
                        <td>
                            <b>
                                <input name="txtCheckAmt<%= i %>" type="text" class="numberfield" id="CheckAmt" value="<%= CheckAmt(i) %>"
                                    size="14" readonly="true">
                            </b>
                        </td>
                        <td>
                            <img src="../images/button_edit.gif" width="37" height="18" name="bView<%= i %>"
                                onclick="ViewCheck(<%= i%>)" style="cursor: hand">
                        </td>
                        <td bgcolor="#FFFFFF" align="center">
                            <img src="../images/button_delete.gif" width="50" height="17" name="B2" onclick="DeleteClick(<%= i %>)"
                                style="cursor: hand">
                        </td>
                        <td bgcolor="#FFFFFF">
                            <input type="hidden" name="cStatus<%= i %>" id="cStatus" class="cStatus">
                        </td> 
                        <input type="hidden" id="CheckType" class="CheckType" name="CheckType<%= i %>" value="<%= CheckType(i) %>">
                        <input type="hidden" id="BillInvoiceNo<%= i %>">
                        <input type="hidden" id="BillAmt<%= i %>">
                        <% for iii=0 to aDetailIndex(i) - 1 %>
                        <input type="hidden" id="BillInvoiceNo<%= i %>" value="<%= BillInvoiceNo(i,iii) %>">
                        <input type="hidden" id="BillAmt<%= i %>" value="<%= BillAmt(i,iii) %>">
                        <% next %>
                    </tr>
                    <% next %>
                    <tr align="left" valign="middle" bgcolor="D5E8CB">
                        <td height="20" colspan="8" bgcolor="#f3f3f3">
                            &nbsp;<img src="../images/button_selectall.gif" width="61" height="17" name="bSelectAll"
                                onclick="SelectAllClick()" style="cursor: hand">
                        </td>
                    </tr>
                    <tr align="left" valign="middle" bgcolor="89A979">
                        <td colspan="8" height="1" class="bodyheader">
                        </td>
                    </tr>
                    <tr align="center" bgcolor="D5E8CB">
                        <td height="22" colspan="8" valign="middle" class="bodycopy">
                            &nbsp;
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td height="32" align="right" valign="bottom">
                <div id="print">
                    <img src="/ASP/Images/icon_printer.gif" width="40" height="27" align="absbottom"><a
                        href="javascript:;" onclick="PrintClick();return false;">Print Checks</a></div>
            </td>
        </tr>
    </table>
    <br />
    </form>
</body>
<!--  #INCLUDE FILE="../include/shared.asp" -->
<script type="text/javascript">
    function BalChange() {
        var sindex = document.form1.lstBank.selectedIndex;
        var tmpStr = document.form1.lstBank.item(sindex).value;
        var CheckNo, Bal;
        var pos = tmpStr.indexOf("^");
        if (pos >= 0)
            tmpStr = tmpStr.substring(pos + 1, 200);
        pos = tmpStr.indexOf("^");
        if (pos >= 0) {
            Bal = tmpStr.substring(0, pos);
            CheckNo = tmpStr.substring(pos + 1, tmpStr.length);
        }

        document.form1.txtAcctBalance.value = Bal;
        document.form1.hCheckNo.value = CheckNo;
        document.form1.txtCheck.value = document.form1.hCheckNo.value;

    }

    function ViewCheck(k){
        var CheckType=$("input.CheckType").get(k).value;
        var CheckInfo=$("input.CheckInfo").get(k).value;
        var CheckQueueID="";
        var VendorNo="";
        var Bank="";
        var pos=CheckInfo.indexOf("-");
        if (pos>=0){
	        CheckQueueID=CheckInfo.substring(0,pos);
	        CheckInfo = CheckInfo.substring(pos + 1, 100);
        }
        pos=CheckInfo.indexOf("-");
        if (pos>=0){
	        VendorNo=CheckInfo.substring(0,pos);
	        Bank = CheckInfo.substring(pos + 1, 100);
        }

        pos=Bank.indexOf("@");

       if (pos>=0)
	        Bank=Bank.substring(0,pos);

        if (CheckType=="C" )
	        document.form1.action="write_chk.asp?EditCheck=yes&CheckQueueID=" + CheckQueueID + "&VendorNo=" + VendorNo+ "&Bank=" + Bank+ "&WindowName=popupNew" ;
        else
	        document.form1.action="pay_bills.asp?EditCheck=yes&CheckQueueID=" + CheckQueueID + "&VendorNo=" + VendorNo +"&Bank=" + Bank +"&WindowName=popupNew" ;

	    jPopUpNormal();
	    document.form1.method="POST";
	    document.form1.target="popUpWindow";
	    form1.submit();
    }
    function DeleteClick(k){
        if (k>=0 ){
	        var CheckInfo=$("input.CheckInfo").get(k).value;
	        var pos=CheckInfo.indexOf("-");
	        if (pos>=0){
		        CheckQueueID=CheckInfo.substring(0,pos);
	        }
	        if (confirm("Do you really want to delete this item from the queue?")){
		        document.form1.action="print_chk.asp?Del=Yes&QueueId="+ CheckQueueID + "&WindowName=" + window.name;
		        document.form1.method="POST";
		        document.form1.target = "_self";
		        form1.submit();
	        }
    	
        }

    }

    var ModalHandle;
    function trim(sourceString) { return sourceString.replace(/(?:^\s+|\s+$)/ig, ""); }
    function IsNull(what) { return what == null }
    function PrintClick(){
        var startCheck=0;
        var endCheck;
        document.form1.hCheckNo.value = document.form1.txtCheck.value;
        var NoItem=parseInt(document.form1.hNoItem.value);

	    var CheckNo=document.form1.hCheckNo.value;
	    if (IsNull(CheckNo) || trim(CheckNo) == "") {
		    alert( "Please enter the Start Check No.");
		    document.form1.txtCheck.focus();
		    return false;
	    }
    	
	    if ( CheckNo!="" ){
            CheckNo=parseFloat(CheckNo);
	        startCheck = CheckNo;
        
        }
        var iCnt = 0;

	    for (var j=0; j< NoItem; j++){
			if ($("input.cChecked").get(j).checked)
				iCnt = iCnt + 1;
	    }
	    if (iCnt == 0) {
	        alert("Please select at least one item.");
	        return false;
	    }

    ///////////////////////////////////////////////// New logic of Check Printing  by iMoon Nov-13-2006
        var vCheckInfo="";
        var vQueueID="";
        var CheckNo=0;
        var tmpCheckInfo = "^^^";
	    for (var j=0; j< NoItem; j++){
			if ($("input.cChecked").get(j).checked){
				$("input.cStatus").get(j).value = "";
				vCheckInfo = $("input.CheckInfo").get(j).value;
				var pos=vCheckInfo.indexOf("-");
				if (pos>=0 )
					vQueueID= vCheckInfo.substring(0,pos);
				else
					vQueueID=0;

				tmpCheckInfo= tmpCheckInfo + vQueueID + "@" +CheckNo  + "^^^";	
    					
				pos=vCheckInfo.indexOf("@");
				if (pos>=0)
					$("input.CheckInfo").get(j).value=vCheckInfo.substring(0,pos);

				$("input.CheckInfo").get(j).value= vCheckInfo + "@"+ CheckNo;
				CheckNo=CheckNo+1;
				$("input.cStatus").get(j).value = "ok";
			}
	    }
	    function CheckQueue() {	       
	         endCheckNo = parseInt(startCheck) + parseInt(CheckNo) - 1;
	         tmpUrl = "print_check_OK.asp?startCheckNo=" + startCheck + "&endCheckNo=" + endCheckNo;	    
	         ModalHandle.CallBack = GetNextCheckNo;
	         showModalDialogJN(tmpUrl, tmpCheckInfo, wOptions, ModalHandle);
	    };

	    function GetNextCheckNo(qS) {
	        
	        if (parseInt(qS) > 0) {
	            nCheckNo = parseInt(qS) + 1;
	        } else if (parseInt(qS) == 0) {
	            nCheckNo = endCheckNo + 1;
	        }
	    }
       
	    tmpCheckInfo = tmpCheckInfo.substring(0,tmpCheckInfo.length-3);
	    var popUpCheck = null;
	    var wOptions = "dialogWidth:700px; dialogHeight:600px; help:no; status:no; scroll:no;center:yes";
	    var nCheckNo = 0;
	      if (!$.browser.chrome ) { 
	         showModalDialog("check_Dialog_frame.asp?PostBack=false&cType=all", tmpCheckInfo, wOptions);
	        var endCheckNo = parseInt(startCheck) + parseInt(CheckNo)-1;	      
	        var tmpUrl = "print_check_OK.asp?startCheckNo=" + startCheck + "&endCheckNo=" + endCheckNo;	       
	        var qS = showModalDialog(tmpUrl, "", "dialogWidth:700px; dialogHeight:230px; help:no; status:no; scroll:no;center:yes");
	      
	        if (parseInt(qS) > 0) {
	            nCheckNo = parseInt(qS) + 1;
	        } else if (parseInt(qS) == 0) {
	            nCheckNo = endCheckNo + 1;
	        }	     
	              
	    } else {	        
	          ModalHandle.CallBack = CheckQueue;
	          showModalDialogJN("check_Dialog_frame.asp?PostBack=false&cType=all", tmpCheckInfo, wOptions, ModalHandle);
	        
	    }
	      if (nCheckNo > 0) {
	          document.form1.action = "print_chk.asp?Print=Yes&NextCheckNo=" + nCheckNo + "&WindowName=" + window.name;
	         
	          document.form1.method = "POST";
	          document.form1.target = "_self";
	          form1.submit();
	      }
    //////////////////////////////////////////////////////////////////////////////////////////////////////
    	
	  
      
    }


  

    function SelectAllClick(){
        
        if ($("input.cChecked").attr("checked") == "checked")
            $("input.cChecked").removeAttr("checked");
        else
            $("input.cChecked").attr("checked", "checked");
        
    }
</script>
<script language="vbscript" type="text/vbscript">
    Sub MenuMouseOver()
    End Sub
    Sub MenuMouseOut()
    End Sub
</script>
<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
