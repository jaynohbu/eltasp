<%
Public PortCode,PortAESCode,PortDesc
Public port_list
Public vDepPort,vArrPort
Public vDepCode,vArrCode

Sub GET_PORT_LIST
DIM tmpTable
	set port_list = Server.CreateObject("System.Collections.ArrayList")

	Dim rs,SQL
    Set rs=Server.CreateObject("ADODB.Recordset")   
    SQL= "select port_code,port_desc from port where elt_account_number = " & elt_account_number & " AND ISNULL(port_desc,'') <> '' order by port_desc"

	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing


	Set tmpTable = Server.CreateObject("System.Collections.HashTable")
    
	tmpTable.Add "port_code" ,""
	tmpTable.Add "port_desc" ,""
	port_list.Add tmpTable	


    Do While Not rs.EOF

		Set tmpTable = Server.CreateObject("System.Collections.HashTable")
		tmpTable.Add "port_code" ,rs("port_code").value
		tmpTable.Add "port_desc" ,rs("port_desc").value
		port_list.Add tmpTable			

		rs.MoveNext
    Loop
    rs.Close
    Set rs=Nothing 

End Sub


Sub GET_DOME_PORT_LIST
DIM tmpTable
	set port_list = Server.CreateObject("System.Collections.ArrayList")

	Dim rs,SQL
    Set rs=Server.CreateObject("ADODB.Recordset")   
    SQL= "select port_code,port_desc from port where elt_account_number = " & elt_account_number & " AND ISNULL(port_code,'') <> '' AND port_country_code='US' order by port_desc"

	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing


	Set tmpTable = Server.CreateObject("System.Collections.HashTable")
    
	tmpTable.Add "port_code" ,""
	tmpTable.Add "port_desc" ,""
	port_list.Add tmpTable	

    Do While Not rs.EOF

		Set tmpTable = Server.CreateObject("System.Collections.HashTable")
		tmpTable.Add "port_code", rs("port_code").value
		tmpTable.Add "port_desc", rs("port_code").value & "-" & rs("port_desc").value
		port_list.Add tmpTable			

        rs.MoveNext
    Loop
    rs.Close
    Set rs=Nothing 

End Sub

Function checkBlank(arg1,arg2)
    Dim result
    If IsNull(arg1) Then 
        result = arg2
    Else
		If Trim(arg1)="" Then
			result = arg2
		Else
			result = Trim(arg1)
		End If
    End If    
    checkBlank = result
    
End Function

%>
<script type="text/jscript">
    function trim(sourceString) { return sourceString.replace(/(?:^\s+|\s+$)/ig, ""); }
    
    function setSelect(sName,text) {
	    var oSelect = document.getElementById(sName);
	    var items = oSelect.options;
	    for( var i = 0; i < items.length; i++ ) {
			    var item = items[i];
			    if( item.value.toLowerCase() == text.toLowerCase() ) {
				    oSelect.selectedIndex = i;
				    break;
			    }
	    }
    }
</script>