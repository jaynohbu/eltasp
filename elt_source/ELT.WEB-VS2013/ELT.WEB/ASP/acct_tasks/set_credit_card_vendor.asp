<!--  #INCLUDE FILE="../include/transaction.txt" -->
<% 
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<!--  #INCLUDE FILE="../include/connection.asp" -->
<!--  #INCLUDE FILE="../include/Header.asp" -->
<%
    Dim vFileNo,vAgentName,vAgentNo,vIType,vMode,vMAWB

    vMode = Request.QueryString("MODE").Item
    
    If vMode = "save" Then
        vAgentName = Request.Form("lstAgentName").Item
        vAgentNo = Request.Form("hAgentAcct").Item
        vGLAcct = Request.Form("txtGLAcct").Item
        eltConn.BeginTrans()
        Call update_credit_card
        eltConn.CommitTrans()
        Response.Write("<script> window.close(); </script>")
    Else
        vGLAcct = Request.QueryString("glAcct").Item
        vAgentNo = Request.QueryString("agentAcct").Item
        vAgentName = Request.QueryString("agentName").Item
    End If
    
    Sub update_credit_card

        Dim rs,SQL
        Set rs = Server.CreateObject("ADODB.Recordset")
        
        SQL = "UPDATE gl SET gl_vendor_no=" & vAgentNo & " WHERE gl_account_number=" & vGLAcct _
            & " AND elt_account_number=" & elt_account_number
    
        eltConn.execute(SQL)
    End Sub
%>


<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
    <title>Credit Card Vendor</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" language="javascript" src="/ASP/ajaxFunctions/ajax.js"></script>

    <script type="text/javascript" src="../include/JPED.js"></script>

    <script type="text/jscript">
    
    function lstAgentNameChange(orgNum,orgName)
    {
        var hiddenObj = document.getElementById("hAgentAcct");
        var txtObj = document.getElementById("lstAgentName");
        var divObj = document.getElementById("lstAgentNameDiv")

        hiddenObj.value = orgNum;
        txtObj.value = orgName;
    }
    
    function SaveForm(){
        if(document.getElementById("hAgentAcct").value != "")
        {
            var formObj = document.getElementById("form1");
            formObj.action = "set_credit_card_vendor.asp?MODE=save&WindowName=SetCreditCardVendor";
		    formObj.method = "POST";
		    formObj.target = window.name;
		    formObj.submit();
		}
    }
    
    </script>

</head>
<body style="margin: 5px">
<form id="form1" action="">

    
    
    <table cellspacing="0" cellpadding="0" border="0" width="100%">
        <tr>
            <td class="bodyheader">
                Select a vendor assigned to credit card account: <input type="text" id="txtGLAcct" name="txtGLAcct" value="<%=vGLAcct %>" class="shorttextfield" size="10" readonly="readonly" />
            </td>
        </tr>
        <tr>
            <td style="height: 155px" valign="top">
                <!-- Start JPED -->
                <input type="hidden" id="hAgentAcct" name="hAgentAcct" value="<%=vAgentNo %>" />
                <div id="lstAgentNameDiv">
                </div>
                <table cellpadding="0" cellspacing="0" border="0">
                    <tr>
                        <td>
                            <input type="text" autocomplete="off" id="lstAgentName" name="lstAgentName" value="<%=vAgentName %>"
                                class="shorttextfield" style="width: 270px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onkeyup="organizationFill(this,'Vendor','lstAgentNameChange',130,event)"
                                onfocus="initializeJPEDField(this,'fixed');" /></td>
                        <td>
                            <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstAgentName','Vendor','lstAgentNameChange',130,event)"
                                style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                    </tr>
                </table>

                <script type="text/javascript">
                    organizationFillAll('lstAgentName', 'Vendor', 'lstAgentNameChange', 130);
                </script>

                <!-- End JPED -->
            </td>
        </tr>
        <tr>
            <td align="right">
                <table cellspacing="0" cellpadding="0" border="0">
                    <tr>
                        <td>
                            <input type="image" src="../images/button_save_medium.gif" onclick="javascript:SaveForm(); return false;" /></td>
                        <td style="width:15px"></td>
                        <td>
                            <input type="image" src="../images/button_close_window.gif" onclick="javascript:window.close(); return false;" /></td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    </form>
</body>
</html>
