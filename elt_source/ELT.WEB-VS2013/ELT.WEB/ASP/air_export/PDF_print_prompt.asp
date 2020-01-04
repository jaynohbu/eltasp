<!--  #INCLUDE FILE="../include/transaction.txt" -->
<%
    Option Explicit
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<!--  #INCLUDE FILE="../include/connection.asp" -->
<!--  #INCLUDE FILE="../include/Header.asp" -->
<!--  #INCLUDE FILE="../include/GOOFY_util_fun.inc" -->

<%
    Dim AgentArray,AgentTable,rs,SQL,master_num,Billtype,HMtype,i
    Billtype = "PDF"
    Set AgentArray = Server.CreateObject("System.Collections.ArrayList")
    Set AgentTable = Server.CreateObject("System.Collections.HashTable")
    Set rs = Server.CreateObject("ADODB.Recordset")
    master_num = checkBlank(Request.QueryString.Item("master"),"")
    Billtype = checkBlank(Request.QueryString.Item("Billtype"),"")
    HMtype = checkBlank(Request.QueryString.Item("HMtype"),"")
    master_num = Server.URLEncode(master_num)
    
    If HMtype = "master" then
        HMtype="MAWB"
    Elseif HMtype = "house" then
        HMtype="HAWB"
    Else
        HMtype=""
    End If

%>

<html>
<head><title></title>
    <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="../css/elt_css.css" rel="stylesheet" type="text/css" />
<script language="javascript" type="text/javascript">
function getAnswer()
{
	var selObj = document.getElementById("lstPrintOpt");
	var returnValue = selObj.options[selObj.selectedIndex].value;
	window.returnValue = returnValue;
	window.close();
}

</script>
</head>
<body class="bodyheader"><center>
<br/><font size="2">Select Copy to print <%= Billtype %> document</font><br/><br/>
<form id="form1" action="">

<select id="lstPrintOpt" class="bodyheader" style="width:200px;">
    <option value="<%=HMtype%>=<%=master_num %>&Copy=SHIPPER" selected="selected" >Shipper Copy</option>
    <option value="<%=HMtype%>=<%=master_num %>&Copy=SHIPPER&IATA=Y" >Shipper Copy with IATA Terms</option>
    <option value="<%=HMtype%>=<%=master_num %>&Copy=CONSIGNEE" >Consignee Copy</option>
    <option value="<%=HMtype%>=<%=master_num %>&Copy=CONSIGNEE&IATA=Y" >Consignee Copy with IATA Terms</option>
<%If HMtype="MAWB" then %>
    <option value="<%=HMtype%>=<%=master_num %>&Copy=CARRIER" >Issuing Copy</option>
    <option value="<%=HMtype%>=<%=master_num %>&Copy=CARRIER&IATA=Y" >Issuing Copy with IATA Terms</option>
    <option value="<%=HMtype%>=<%=master_num %>&Copy=COPY" >Copy</option>
    <option value="<%=HMtype%>=<%=master_num %>&Copy=COPY&IATA=Y" >Copy with IATA Terms</option>
<%End If %>
</select>

<br />
<br />
<input type="button" value="View" class="bodycopy" onclick="javascript:getAnswer();" style="width: 55px" size=""/>
<input type="button" value="Cancel" class="bodycopy" onclick="javascript:window.close();" style="width: 55px"/>

</form>
</center>
</body>
</html>