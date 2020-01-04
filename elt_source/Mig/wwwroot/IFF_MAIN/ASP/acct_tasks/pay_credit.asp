<!-- #INCLUDE FILE="../include/transaction.txt" -->
<% Option Explicit %>
<!-- #INCLUDE FILE="../include/connection.asp" -->
<!-- #INCLUDE FILE="../include/header.asp" -->
<!-- #INCLUDE FILE="../include/GOOFY_Util_fun.inc" -->
<%
    Dim BankList,ApList,ExpenseList,i,vDate
    
    Call GetGLAccounts
    Call InitializeAll
    
    Sub InitializeAll
        vDate = checkBlank(vDate,Date())
    End Sub
    
    Sub GetGLAccounts
        Dim SQL,rs,tmpTable,BankType
        Set rs = Server.CreateObject("ADODB.Recordset")
        
        SQL= "select gl_account_type,gl_account_number,gl_account_desc,control_no from gl where elt_account_number = " _
            & elt_account_number & " and (gl_account_type='" & CONST__BANK & "' or gl_account_type='" _
            & CONST__ACCOUNT_PAYABLE & "' or gl_account_type='" & CONST__EXPENSE & "' or gl_account_type='" _ 
            & CONST__COST_OF_SALES & "' or gl_account_type='" & CONST__OTHER_EXPENSE _
            & "') order by isnull(gl_default,'') desc, cast(gl_account_number as NVARCHAR)"
        
        rs.CursorLocation = adUseClient
        rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
        Set rs.activeConnection = Nothing

        Set BankList = Server.CreateObject("System.Collections.ArrayList")
        Set ApList = Server.CreateObject("System.Collections.ArrayList")
        Set ExpenseList = Server.CreateObject("System.Collections.ArrayList")

        Do While Not rs.EOF
            Set tmpTable = Server.CreateObject("System.Collections.HashTable")
	        BankType = rs("gl_account_type")
	        If BankType = CONST__BANK Then
		        tmpTable.Add "gl_account_number", rs("gl_account_number").value
		        tmpTable.Add "gl_account_desc", rs("gl_account_desc").value
		        tmpTable.Add "control_no", rs("control_no").value
		        BankList.Add tmpTable
	        Elseif BankType = CONST__ACCOUNT_PAYABLE Then
		        tmpTable.Add "gl_account_number", rs("gl_account_number").value
		        tmpTable.Add "gl_account_desc", rs("gl_account_desc").value
		        tmpTable.Add "control_no", ""
		        ApList.Add tmpTable
	        Else
		        tmpTable.Add "gl_account_number", rs("gl_account_number").value
		        tmpTable.Add "gl_account_desc", rs("gl_account_desc").value
		        tmpTable.Add "control_no", ""
		        ExpenseList.Add tmpTable
	        End if
	        rs.MoveNext
	        Set tmpTable = Nothing
        Loop
        rs.Close
        
    End Sub
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Creditcard Pay</title>
    <meta http-equiv="Content-Type" content="text/html; charset=windows-1252" />
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />

    <script type="text/jscript" src="../Include/JPTableDOM.js"></script>

    <script type="text/jscript" src="../Include/JPXMLDOM.js"></script>

    <script type="text/jscript" src="../ajaxFunctions/ajax.js"></script>

    <script type="text/jscript" src="../Include/JPED.js"></script>

    <script type="text/jscript">
        
        // uses ajax to find balance at real time
        function BankChange(){
            var lstObj = document.getElementById("lstBank");
            var vAccount = lstObj.options[lstObj.selectedIndex].value;
            var url = "/IFF_MAIN/asp/ajaxFunctions/ajax_account_payable.asp?mode=get&type=BankInfo&gl=" + vAccount;
            new ajax.xhr.Request('GET','',url,BankChangeUpdate,'','','','');
		}
    
        function BankChangeUpdate(req,field,vVal_1,vVal_2,vVal_3,url)
        {
            if (req.readyState == 4){   
		        if (req.status == 200){
		            var xmlObj = req.responseXML;

		            try{
                        setField("Balance","txtAcctBalance",xmlObj);
                        setField("CheckNum","txtCheck",xmlObj);
                        
                        var tmpBalance = parseFloat(document.getElementById("txtAcctBalance").value);
                        if(isNaN(tmpBalance)){
                            document.getElementById("txtAcctBalance").value = "";
                        }
                        else{
                            document.getElementById("txtAcctBalance").value = tmpBalance.toFixed(2);
                        }
                        
                    }catch(error){
                        alert(error.description);
                        xmlObj = null;
                    }
                    xmlObj = null;
		        }
		    }
		}
		
        function BodyLoad(){
        
            // call this function at the end
            BankChange();
            cToBePrintClick(true);
            
        }
        
        function cToBePrintClick(vValue){
            var txtCheck = document.getElementById("txtCheck");
            
            if(!isNaN(vValue) && vValue){
                document.getElementById("cToBePrint").checked = vValue;
            }
            
            if(document.getElementById("cToBePrint").checked){
                txtCheck.disabled = true;
                txtCheck.className  = "d_shorttextfield";
            }
            
            else{
		        txtCheck.disabled = false;
		        txtCheck.className  = "m_shorttextfield";
            }
        }
        
    </script>

</head>
<body onload="javascript:BodyLoad();">
    <form id="form1" method="post" action="" style="text-align: center">
        <!-- start of scroll bar -->
        <input type="hidden" name="scrollPositionX" />
        <input type="hidden" name="scrollPositionY" />
        <!-- end of scroll bar -->
        <table width="95%" border="0" cellpadding="2" cellspacing="0">
            <tr>
                <td align="left" valign="middle" class="pageheader">
                    Creditcard Pay</td>
                <td align="right" valign="middle">
                    <div id="print">
                        <img src="/iff_main/ASP/Images/icon_printer.gif" width="40" height="27" alt="" /><a
                            href="javascript:return;">Print Check Now</a></div>
                </td>
            </tr>
        </table>
        <table width="95%" border="0" cellpadding="0" cellspacing="0" style="border-color: #89A979;
            background-color: #89A979;" class="border1px">
            <tr>
                <td>
                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                        <tr style="background-color: #D5E8CB">
                            <td colspan="10" style="height: 24px" align="center" valign="middle" class="bodyheader">
                                <table width="98%" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td align="right" style="width: 50%" valign="middle">
                                            <img src="../images/button_smallsave.gif" onclick="" style="cursor: hand" alt="" /></td>
                                        <td align="right" style="width: 50%" valign="middle">
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 1px" colspan="10">
                            </td>
                        </tr>
                        <tr valign="middle" style="background-color: #E7F0E2">
                            <td colspan="10" style="background-color: #f3f3f3; text-align: center" class="bodycopy">
                                <br />
                                <table border="0" cellspacing="0" cellpadding="0" style="width: 648px; height: 28px">
                                    <tr>
                                        <td style="height: 28" align="right">
                                            <span class="bodyheader">
                                                <img src="/iff_main/ASP/Images/required.gif" alt="" />Required field</span></td>
                                    </tr>
                                </table>
                                <table border="0" cellpadding="2" cellspacing="0" style="border-color: #89A979; background-color: #D5E8CB;
                                    width: 648px" class="border1px">
                                    <tr align="left" valign="middle" style="background-color: #E7F0E2">
                                        <td class="bodycopy">
                                            &nbsp;</td>
                                        <td style="width: 42%; height: 20px">
                                            <span class="bodyheader">Bank Account</span></td>
                                        <td colspan="-2" class="bodyheader">
                                            Balance&nbsp;</td>
                                    </tr>
                                    <tr align="left" valign="middle" style="background-color: #E7F0E2">
                                        <td style="width: 1px; background: #ffffff" class="bodycopy">
                                            &nbsp;</td>
                                        <td style="background: #ffffff">
                                            <select name="lstBank" id="lstBank" size="1" class="smallselect" style="width: 240px"
                                                onchange="BankChange();">
                                                <% For i=0 To BankList.Count-1 %>
                                                <option value="<%=BankList(i)("gl_account_number") %>">
                                                    <%=BankList(i)("gl_account_desc") %>
                                                </option>
                                                <% Next %>
                                            </select>
                                        </td>
                                        <td style="width: 57%; background-color: #ffffff">
                                            <input name="txtAcctBalance" id="txtAcctBalance" class="readonlyboldright" value=""
                                                size="18" style="behavior: url(../include/igNumChkRight.htc)" />
                                        </td>
                                    </tr>
                                    <tr align="left" valign="middle" style="background-color: #E7F0E2">
                                        <td style="background-color: #ffffff" class="bodycopy">
                                            &nbsp;</td>
                                        <td colspan="2" style="background-color: #ffffff">
                                        </td>
                                    </tr>
                                </table>
                                <br />
                                <table border="0" cellpadding="0" cellspacing="0" style="width: 648px; height: 261px;
                                    border-color: #89A979; background-image: url(../../Images/checkback.gif)">
                                    <tr align="left" valign="top">
                                        <td style="width: 556; height: 34" valign="bottom">
                                            &nbsp;</td>
                                        <td style="width: 90" valign="bottom">
                                            <input name="txtCheck" id="txtCheck" class="shorttextfield" value="" size="12" /></td>
                                    </tr>
                                    <tr align="left" valign="top">
                                        <td style="width: 556; height: 31" valign="bottom">
                                            &nbsp;</td>
                                        <td style="width: 90" valign="bottom">
                                            <input name="txtDate" class="m_shorttextfield" preset="shortdate" size="12" value="<%=vDate %>" /></td>
                                    </tr>
                                    <tr align="left" valign="top">
                                        <td style="height: 29" colspan="2">
                                            <table style="width: 100%; height: 100%" border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td style="width: 13%" align="left" valign="bottom">
                                                        &nbsp;</td>
                                                    <td style="width: 61%" align="left" valign="bottom">
                                                        <input name="txt_print_check_as" type="text" id="txt_print_check_as" class="shorttextfield"
                                                            style="width: 98%; vertical-align: middle" value="" /></td>
                                                    <td style="width: 4%" align="left" valign="bottom">
                                                        &nbsp;</td>
                                                    <td style="width: 22%" align="left" valign="bottom">
                                                        <input name="txtAmount" class="readonlyboldright" value="" size="15" readonly="readonly" />
                                                        <input type="hidden" name="txtOldAmount" value="" /></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr align="left" valign="middle">
                                        <td style="height: 39px" colspan="2" align="left" valign="top">
                                            <table style="width: 100%; height: 100%" border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td style="width: 6%" align="right" valign="bottom">
                                                        &nbsp;</td>
                                                    <td style="width: 94%" align="left" valign="bottom">
                                                        <input name="txtMoney" type="text" class="readonly" size="95" readonly="readonly" />
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr align="left" valign="middle">
                                        <td style="height: 75px" colspan="2" valign="top">
                                            <table style="width: 100%; height: 100%" border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td style="width: 6%; height: 20px" align="left" valign="top">
                                                    </td>
                                                    <td style="width: 94%" align="left" valign="top">
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="left" valign="top">
                                                        &nbsp;</td>
                                                    <td align="left" valign="top">
                                                        <textarea name="txtVendorInfo" cols="45" rows="4" class="multilinetextfield"></textarea></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr align="left" valign="middle">
                                        <td style="height: 40px" colspan="2" valign="top">
                                            <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td style="width: 6%; height: 26px" align="left" valign="bottom">
                                                        &nbsp;</td>
                                                    <td style="width: 94%" align="left" valign="bottom">
                                                        <input name="txtMemo" class="shorttextfield" value="" size="47" maxlength="35" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="left" valign="bottom">
                                                    </td>
                                                    <td align="left" valign="bottom">
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                                <br>
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 2px" colspan="10">
                            </td>
                        </tr>
                        <tr valign="middle" style="background-color: #D5E8CB">
                            <td style="height: 22px" class="bodyheader">
                                &nbsp;</td>
                            <td class="bodyheader">
                                Due Date</td>
                            <td class="bodyheader">
                                Invoice No.</td>
                            <td class="bodyheader">
                                Bill Amount</td>
                            <td class="bodyheader">
                                &nbsp;</td>
                            <td class="bodyheader">
                                Amount Due</td>
                            <td class="bodyheader">
                                Amount Paid</td>
                            <td class="bodyheader">
                                Item Name</td>
                            <td class="bodyheader">
                                Memo</td>
                            <td>
                            </td>
                        </tr>
                        <tr valign="middle" style="background-color: #f3f3f3">
                            <td>
                                &nbsp;</td>
                            <td style="height: 20px">
                                &nbsp;</td>
                            <td>
                                &nbsp;</td>
                            <td align="right" valign="middle" class="bodyheader" style="color: #c16b42">
                                TOTAL</td>
                            <td class="bodyheader">
                                &nbsp;</td>
                            <td class="bodyheader">
                                <input name="txtTotalAmtDue" class="readonlyboldright" value="" size="14" style="behavior: url(../include/igNumChkRight.htc);
                                    width: 70px" readonly="readonly" /></td>
                            <td class="bodyheader">
                                <input name="txtTotalAmtPaid" class="readonlyboldright" value="" size="14" style="behavior: url(../include/igNumChkRight.htc);
                                    width: 70px" readonly="readonly" /></td>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr valign="middle" style="background-color: #ffffff">
                            <td align="center">
                                <input type="checkbox" name="cToBePrint" id="cToBePrint" onclick="cToBePrintClick(false)" /></td>
                            <td colspan="2">
                                <span class="bodycopy"><strong>To Be Printed Later </strong></span>
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td class="bodyheader">
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 1px" colspan="10">
                            </td>
                        </tr>
                        <tr valign="middle" style="background-color: #D5E8CB">
                            <td style="height: 24px" colspan="10" align="center">
                                <table width="98%" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td align="right" style="width: 50%" valign="middle">
                                            <img src="../images/button_smallsave.gif" onclick="" style="cursor: hand" alt="" /></td>
                                        <td style="width: 50%" align="right" class="bodyheader">
                                            <input id="chk_isCom" name="chk_isCom" type="checkbox" style="cursor: hand" /><label
                                                for="chk_isCom">Complete check</label>
                                            <input id="chk_isVoid" name="chk_isVoid" type="checkbox" style="cursor: hand" /><label
                                                for="chk_isVoid">Void check</label>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        <table width="95%" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td style="height: 32px" align="right" valign="bottom">
                    <div id="print">
                        <img src="/iff_main/ASP/Images/icon_printer.gif" width="40" height="27" alt="" /><a
                            href="javascript:;">Print Check Now</a></div>
                </td>
            </tr>
        </table>
        <br />
    </form>
</body>
<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
