<!--  #INCLUDE FILE="../include/transaction.txt" -->
<html>
<head>
    <title>Air Export</title>
    <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css">
    <!--  #INCLUDE FILE="../include/connection.asp" -->
    <style type="text/css">
<!--
.style3 {color: #FF0000}
.style4 {
	color: #000000;
	font-weight: bold;
}
-->
</style>
</head>
<!--  #INCLUDE FILE="../include/header.asp" -->
    <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
<%

DIM NOT_Exists
DIM VendorNo,VendorName
    VendorNo = Request.QueryString("Vendor")
    VendorName = Request.QueryString("VendorName")

	Save=Request.QueryString("Save")
	qCancel=Request.QueryString("Cancel")
	vINVOICE=Request.QueryString("INVOICE")

if qCancel = "yes" then
		session("INVOICE_NO") = ""
%>
<script type="text/javascript">
    parent.fShowModal.hReturnValue.value = 'cancel';
    window.top.close();
</script>
<%	
end if
	
if Save="yes" then

		NOT_Exists = true
		
		CALL VERIFY_NEW_NUM ( vINVOICE,VendorNo )

		if not NOT_Exists then
			session("INVOICE_NO") = vINVOICE
%>
<script language="javascript">
    parent.fShowModal.hReturnValue.value = '<%= vINVOICE %>';
    window.top.close();
</script>
<%
		else
		   NOT_Exists = true
		end if

end if
	
%>
<%
SUB VERIFY_NEW_NUM ( vINVOICE, VendorNo )
	Dim rs, SQL
	Set rs = Server.CreateObject("ADODB.Recordset")
	
if 	not vINVOICE = "" then
'	SQL= "select invoice_no from invoice_cost_item where elt_account_number = " & elt_account_number & " and invoice_no = " & vINVOICE & " and vendor_no = " & VendorNo

	SQL= "select invoice_no from invoice where elt_account_number = " & elt_account_number & " and invoice_no = " & vINVOICE 

	rs.Open SQL, eltConn, adOpenStatic, , adCmdText
	if Not rs.EOF then
		NOT_Exists = false
	end if
	rs.close
	Set rs = Nothing
end if

END SUB
%>
<body link="336699" vlink="336699" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0"
    onload="self.focus()">
    <br>
    <form method="post" name="frmHAWB">
    <input type="hidden" name="hHAWB" value="<%= vHAWB %>">
    <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF"
        class="bodycopy">
        <tr>
            <td height="22px" class="formbody">
                <div align="center" class="style4">
                    You must assign a Invoice No. for [Cost of Sales ]
                </div>
            </td>
        </tr>
        <tr>
            <td class="formbody">
            </td>
        </tr>
        <tr>
            <td height="12px" align="center">
                &nbsp;
            </td>
        </tr>
        <tr>
            <td height="22" align="center">
                &nbsp;<font color="c16b42"><strong>I/V No</strong></font>&nbsp;&nbsp;
                <input name="txtIV" class="shorttextfieldbold" style="width: 100px" tabindex="1"
                    value="<%= vINVOICE %>" size="20" />
            </td>
        </tr>
        <%if NOT_Exists then%>
        <tr>
            <td height="18" align="center">
                <p align="center">
                    <span class="style3">
                        <% response.write "Invoice Number: " & vINVOICE & " does not exist!" %></span></p>
            </td>
        </tr>
        <%end if%>
    </table>
    <p align="center">
        <input name="OK" type="button" id="OK" value="OK" onclick="OkClick()" style="width: 70px">
        <input name="Cancel" type="button" id="Cancel" value="Cancel" onclick="CancelClick()"
            style="width: 70px">
    </p>
    </form>
</body>
<script type="text/javascript">
function OkClick(){
    var not_e = "<%= NOT_Exists %>";
    var errIV = "<%= errIV %>";
    var vINVOICE = document.frmHAWB.txtIV.value;

    if (not_e == "True" ){
        if (errIV == vINVOICE )
	        return false;
    }

	document.frmHAWB.action="get_invoice_no.asp?Save=yes&INVOICE=" + vINVOICE+ "&Vendor="+"<%=VendorNo%>" + "&VendorName=" + "<%=VendorName%>" + "&WindowName=" + window.name;
	document.frmHAWB.method="POST";
	document.frmHAWB.target="_self";
	frmHAWB.submit();
}

function CancelClick() {
    document.frmHAWB.action = "get_invoice_no.asp?Cancel=yes" + "&WindowName=" + window.name;
    document.frmHAWB.method = "POST";
    document.frmHAWB.target = "_self";
    frmHAWB.submit();
}
</script>
</html>
