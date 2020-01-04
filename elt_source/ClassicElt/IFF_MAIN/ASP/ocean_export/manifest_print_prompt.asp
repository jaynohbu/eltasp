<!--  #INCLUDE FILE="../include/transaction.txt" -->
<% Option Explicit %>
<!--  #INCLUDE FILE="../include/connection.asp" -->
<!--  #INCLUDE FILE="../include/Header.asp" -->
<!--  #INCLUDE FILE="../include/GOOFY_util_fun.inc" -->

<%
    Dim AgentArray,AgentTable,rs,SQL,booking_num,i
    
    Set AgentArray = Server.CreateObject("System.Collections.ArrayList")
    Set AgentTable = Server.CreateObject("System.Collections.HashTable")
    Set rs = Server.CreateObject("ADODB.Recordset")
    booking_num = checkBlank(Request.QueryString.Item("booking"),"")
    
    SQL = "SELECT a.agent_name,a.agent_no,b.Consignee_acct_num FROM hbol_master a JOIN mbol_master b " _
        & "ON (a.booking_num = b.booking_num AND a.elt_account_number=b.elt_account_number) " _
        & "WHERE a.elt_account_number=" & elt_account_number _
        & " AND a.booking_num = '" & booking_num & "' GROUP BY a.agent_name,a.agent_no,b.Consignee_acct_num" _
        & " ORDER BY a.agent_name"
    rs.Open SQL, eltConn, , , adCmdText	

    Do While Not rs.EOF And Not rs.BOF 
        Set AgentTable = Server.CreateObject("System.Collections.HashTable")
        AgentTable.Add "value", "MBOL=" & booking_num & "&Agent=" & rs("agent_no").value & "&MasterAgentNo=" & rs("Consignee_acct_num").value
        AgentTable.Add "label", rs("agent_name").value
        AgentArray.Add AgentTable
        Set AgentTable = Nothing
        rs.MoveNext
    Loop
%>

<html>
<head><title></title>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252" />
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
<br/><font size="2">Select agent to print manifest document</font><br/><br/>
<form id="form1" action="">

<select id="lstPrintOpt" class="bodyheader" style="width:200px;">
<option value="MBOL=<%=booking_num %>" selected>All Agent</option>
<% For i=0 To AgentArray.Count-1%>
<option value="<%=AgentArray(i)("value") %>"><%=AgentArray(i)("label") %></option>
<% Next %>
</select>
<br /><br />
<input type="button" value="View" class="bodycopy" onclick="javascript:getAnswer();" style="width: 55px" size=""/>
<input type="button" value="Cancel" class="bodycopy" onclick="javascript:window.close();" style="width: 55px"/>

</form>
</center>
</body>
</html>