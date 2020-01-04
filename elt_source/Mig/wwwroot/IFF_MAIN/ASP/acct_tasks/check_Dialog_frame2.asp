<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Check Print</title>
<script language="javascript">
function resize_iframe()
{
    var x,y;
    if (self.innerHeight) // all except Explorer
    {
	    x = self.innerWidth;
	    y = self.innerHeight;
    }
    else if (document.documentElement && document.documentElement.clientHeight)
	    // Explorer 6 Strict Mode
    {
	    x = document.documentElement.clientWidth;
	    y = document.documentElement.clientHeight;
    }
    else if (document.body) // other Explorers
    {
	    x = document.body.clientWidth;
	    y = document.body.clientHeight;
    }

	document.getElementById("modalFrame").style.height=x;
}

window.onresize=resize_iframe; 
</script>
</head>
<%
DIM postBack,cType, detailItem

		PostBack = Request.QueryString("PostBack")
        if PostBack = "" then PostBack = true
		
		if Not ( PostBack ) then
			cType = Request.QueryString("cType")
		end if
On Error Resume Next :
		if cType = "one" then
			detailItem = cInt(Request.QueryString("aItem"))
		else
			detailItem = 0
		end if
%>
<body onload="javascript:myLoad();resize_iframe();">
<form name=form1 method='post'>
<%
	if cType = "one" then
		%>
				<input type="hidden" id="hBillNo">
				<input type="hidden" id="BillAmt">
				<input type="hidden" id="BillMemo">
				<input type="hidden" name="detailItem">		  
				<input type='hidden' name="txtDate">
				<input type='hidden' name="txtVendor">
				<input type='hidden' name="txtAmount">
				<input type='hidden' name="txtMoney">
				<input type='hidden' name="txtVendorInfo">
				<input type='hidden' name="txtMemo">
				<% if detailItem > 0 then 
					 for i=0 to detailItem %>
						<input type='hidden' id="hBillNo">
						<input type='hidden' id="BillAmt">
						<input type='hidden' id="BillMemo">
				<%	 next 
					end if %>
		<%
	end if
%>
</form>
<IFRAME id="modalFrame" name="modalFrame" width="100%" frameBorder="no" style="PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; MARGIN: 0px; PADDING-TOP: 0px" language="javascript" height="100%"></IFRAME>
</body>

<script language="javascript">
function myLoad() {
var cType = '<%=cType%>';
if ( cType == 'one' )
{
	var opener = dialogArguments;
	
	
	if (opener.document.form1.dDate) 
	{
		document.all('txtDate').value = opener.document.form1.dDate.value;
	}
	if (opener.document.form1.txt_print_check_as) 
	{
	document.all('txtVendor').value = opener.document.form1.txt_print_check_as.value;
	}
	if (opener.document.form1.txtAddress) 
	{
	document.all('txtVendorInfo').value = opener.document.form1.txtAddress.value;
	}
	if ( opener.document.form1.txtAmount) 
	{
	document.all('txtAmount').value = opener.document.form1.txtAmount.value;
	}
	if (opener.document.form1.txtMoneyEnglish) 
	{
	document.all('txtMoney').value = opener.document.form1.txtMoneyEnglish.value;
	}
	if (opener.document.form1.txtMemo) 
	{
	document.all('txtMemo').value = opener.document.form1.txtMemo.value;
	}

	document.modalFrame.location = 'check_pdf.asp?postBack=false&cType=' + '<%=cType%>' + '&oi=0';
}
else
{
document.modalFrame.location = 'check_pdf.asp?cType=' + '<%=cType%>' + '&p=' + window.dialogArguments;
}

}
</script>


</html>
