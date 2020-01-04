<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
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
DIM postBack,cType, hNoItem

		PostBack = Request.QueryString("PostBack")
        if PostBack = "" then PostBack = true
		
		if Not ( PostBack ) then
			cType = Request.QueryString("cType")
		end if
On Error Resume Next :
		if cType = "one" then
			hNoItem = cInt(Request.QueryString("aItem"))
		else
			hNoItem = 0
		end if
%>
<body onload="javascript:myLoad();resize_iframe();">
<form name=form1 method='post'>
<%
	if cType = "one" then
		%>
				<input type="hidden" name="hMAWB">
				<input type="hidden" name="hNoItem">
				<input type="hidden" name="txtStartNo">
				<% if hNoItem > 0 then 
					 for i=0 to hNoItem %>
						<input type='hidden' id="Check">
						<input type='hidden' id="HAWB">
						<input type='hidden' id="NoLabel">
						<input type='hidden' id="Piece">
						<input type='hidden' id="From">
						<input type='hidden' id="Dest">
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
	var oi = opener.document.all("hNoItem").value;
			for(i=1; i <= oi; i++)
			{
					if (opener.document.all("Check").item(i))
					{
						document.all("Check").item(i).value = opener.document.all("Check").item(i).checked
					}
					if (opener.document.all("HAWB").item(i))
					{
						document.all("HAWB").item(i).value = opener.document.all("HAWB").item(i).value;
					}
					if (opener.document.all("NoLabel").item(i))
					{
						document.all("NoLabel").item(i).value = opener.document.all("NoLabel").item(i).value;
					}
					if (opener.document.all("Piece").item(i))
					{
						document.all("Piece").item(i).value = opener.document.all("Piece").item(i).value;
					}
					if (opener.document.all("From").item(i))
					{
						document.all("From").item(i).value = opener.document.all("From").item(i).value;
					}
					if (opener.document.all("Dest").item(i))
					{
						document.all("Dest").item(i).value = opener.document.all("Dest").item(i).value;
					}
			}


			document.form1.hNoItem.value = oi;

			if (opener.document.form1.hMAWB) 
			{
				document.form1.hMAWB.value = opener.document.form1.hMAWB.value;
			}

			if (opener.document.form1.txtStartNo) 
			{
				document.form1.txtStartNo.value = opener.document.form1.txtStartNo.value;
			}


			document.modalFrame.location = 'print_label_pdf.asp?postBack=false&cType=' + '<%=cType%>' + '&oi=' + document.all("hNoItem").value;
}
else
{
	document.modalFrame.location = 'print_label_pdf.asp?cType=' + '<%=cType%>' + '&p=' + window.dialogArguments;
}

}
</script>


</html>
