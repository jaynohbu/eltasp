<html>
<head>
<style type="text/css">
.mouseOut{background:#cccff; color:#000000;}
.mouseOver{background:#6794fd; color:#ffffff;}
</style>
<title>Autocomplet test</title>
<!--  #INCLUDE FILE="include/connection.asp" -->
 
<script language="javascript" type="text/javascript" src="../ASPX/OnLines/jScripts/autocomplete.js"></script>
</head>
<%
Dim testString, SQL, rs
Set rs = Server.CreateObject("ADODB.Recordset")
ddIndex=0
SQL= "select * from organization"
rs.Open SQL, eltConn, , , adCmdText

Do While Not rs.EOF
	testString = testString&"^"&rs("dba_name")	
	rs.MoveNext
	ddIndex=ddIndex+1
Loop
rs.Close

'testString = "aab:bbc:aacd:bbca:acdbef:adfld:alkff:badfad:cadfafds:cafdfadf:jklfasd:afljkdasf"
%>

<body onload="BodyLoad('../Images/');" style="left: 0px; position: relative; top: 0px;">

<form id="form1" method="post" runat="server">

  <input type="hidden" id="hString" value="<%=testString%>"/>  
  
  <table border="0" cellpadding="0" cellspacing="0">
    <tr> 
      <td width="144" align="left" valign="top"> <input id="keyword"  onkeyup="LoadResults(this.value,'searchresults','hString','keyword')" style="height: 20px;" />
       </td>
      <td width="69" align="left" valign="top"><img src="../Images/dd_box.gif" width="17" height="20"  onmousedown="ddPressed(this)"  onmouseup ="ddUp(this);LoadAll('searchresults','hString','keyword');" > 
      </td>
    </tr>
    <tr> 
      <td> 
      <div  align="left"  id="searchresults" class="searchDisp" style="width: 168px; height:200px;  z-index: 1; position: absolute; background-color: #f9f9ff;  overflow-x: hidden; overflow-y: scroll; cursor: default;"> </div></td>
      <td style="font-size: 8px;"> </td>
    </tr>
  </table>
  
</form>
this is just to 
</body>
</html>
