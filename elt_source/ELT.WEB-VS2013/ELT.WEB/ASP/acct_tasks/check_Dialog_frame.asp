<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Check Print</title>

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
<body onload="javascript:myLoad();" >
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
<iframe id="modalFrame" name="modalFrame" width="100%" frameborder="0"  style="overflow-y: scroll"  height="1000px;" scrolling="yes" ></iframe>
</body>

<script language="javascript">
    function myLoad() {
    
var cType = '<%=cType%>';
if ( cType == 'one' )
{
    //var opener = window.dialogArguments;
   // alert(self.opener.document.form1.hNoItem.value);
    
	var oi = self.opener.document.all("hNoItem").value;
	var j = 1;
			for(i=0; i < oi; i++) {

			    
				if ( self.opener.document.all("BillCheck").item(i+1).checked )
				{	
					if (self.opener.document.all("hBillNo").item(i+1))
					{
						document.all("hBillNo").item(j).value = self.opener.document.all("hBillNo").item(i+1).value;
					}
					if (self.opener.document.all("BillAmtPaid").item(i+1))
					{
						document.all("BillAmt").item(j).value = self.opener.document.all("BillAmtPaid").item(i+1).value;
					}
					if (self.opener.document.all("BillMemo").item(i+1))
					{
						document.all("BillMemo").item(j).value = self.opener.document.all("BillMemo").item(i+1).value;
					}
					j++;
				}
			}
			document.all("detailItem").value = j-1;
			if (self.opener.document.form1.txtDate) 
			{
				document.all('txtDate').value = self.opener.document.form1.txtDate.value;
			}
			if (self.opener.document.form1.txt_print_check_as) 
			{
			document.all('txtVendor').value = self.opener.document.form1.txt_print_check_as.value;
			}
			if (self.opener.document.form1.txtVendorInfo) 
			{
			document.all('txtVendorInfo').value = self.opener.document.form1.txtVendorInfo.value;
			}
			if ( self.opener.document.form1.txtAmount) 
			{
			document.all('txtAmount').value = self.opener.document.form1.txtAmount.value;
			}
			if (self.opener.document.form1.txtMoney) 
			{
			document.all('txtMoney').value = self.opener.document.form1.txtMoney.value;
			}
			if (self.opener.document.form1.txtMemo) 
			{
			document.all('txtMemo').value = self.opener.document.form1.txtMemo.value;
			}
            
			document.getElementById("modalFrame").src = 'check_pdf.asp?postBack=false&cType=' + '<%=cType%>' + '&oi=' + document.all("detailItem").value;
}
else {
    
    document.getElementById("modalFrame").src = 'check_pdf.asp?cType=' + '<%=cType%>' + '&p=' + window.dialogArguments;
}

}
</script>


</html>
