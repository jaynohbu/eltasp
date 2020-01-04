<!--  #INCLUDE FILE="../include/transaction.txt" -->
<% Option Explicit %>
<!--  #INCLUDE FILE="../include/connection.asp" -->
<!--  #INCLUDE FILE="../include/Header.asp" -->
<!--  #INCLUDE FILE="../include/GOOFY_util_fun.inc" -->

<%
    Dim AgentArray,AgentTable,rs,SQL,master_num,i
    
    Set AgentArray = Server.CreateObject("System.Collections.ArrayList")
    Set AgentTable = Server.CreateObject("System.Collections.HashTable")
    Set rs = Server.CreateObject("ADODB.Recordset")
    master_num = checkBlank(Request.QueryString.Item("master"),"")
    
    SQL = "SELECT a.agent_name,a.agent_no,b.Consignee_acct_num FROM hawb_master a JOIN mawb_master b " _
        & "ON (a.mawb_num = b.mawb_num AND a.elt_account_number=b.elt_account_number) " _
        & "WHERE a.elt_account_number=" & elt_account_number _
        & " AND a.mawb_num='" & master_num & "' GROUP BY a.agent_name,a.agent_no,b.Consignee_acct_num " _
        & " ORDER BY a.agent_name"
    
    rs.Open SQL, eltConn, , , adCmdText	

    Do While Not rs.EOF And Not rs.BOF 
        Set AgentTable = Server.CreateObject("System.Collections.HashTable")
        AgentTable.Add "value", "MAWB=" & master_num & "&Agent=" & rs("agent_no").value & "&MasterAgentNo=" & rs("Consignee_acct_num").value
        AgentTable.Add "label", rs("agent_name").value
        AgentArray.Add AgentTable
        Set AgentTable = Nothing
        rs.MoveNext
    Loop
%>

<html>
<head><title></title>
     <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252" />
<link href="../css/elt_css.css" rel="stylesheet" type="text/css" />
<script language="javascript" type="text/javascript">
function getAnswer()
{
	var selObj = document.getElementById("lstPrintOpt");
	var returnValue = selObj.options[selObj.selectedIndex].value;
	window.returnValue = returnValue + "&AddInfo=" + document.getElementById("hAddInfo").value;
	window.close();
}
function addInfoChange(chkObj)
{
    var hObj = document.getElementById("hAddInfo");
    
    if(chkObj.checked){
        hObj.value = "Y";
    }
    else{
        hObj.value = "N";
    }
}
</script>
</head>
<body class="bodyheader"><center>
<br/><font size="2">Select agent to print manifest document</font><br/><br/>
<form id="form1" action="">

<select id="lstPrintOpt" class="bodyheader" style="width:200px;">
<option value="MAWB=<%=master_num %>" selected>Consolidated Manifest</option>
<% For i=0 To AgentArray.Count-1%>
<option value="<%=AgentArray(i)("value") %>"><%=AgentArray(i)("label") %></option>
<% Next %>
</select>
<br />
Include contact infomation for shiper and consignee <input type="checkbox" id="chkAddInfo" checked="checked" onclick="addInfoChange(this);" />
<input type="hidden" id="hAddInfo" value="Y" />
<br />
<br />
<input type="button" value="View" class="bodycopy" onclick="javascript:getAnswer();" style="width: 55px" size=""/>
<input type="button" value="Cancel" class="bodycopy" onclick="javascript:window.close();" style="width: 55px"/>

</form>
</center>
</body>
</html>