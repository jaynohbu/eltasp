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

'	PortCode(0)=""
'   PortAESCode(0)=""   
'   PortDesc(0)="Select One"

    Do While Not rs.EOF

		Set tmpTable = Server.CreateObject("System.Collections.HashTable")
		tmpTable.Add "port_code" ,rs("port_code").value
		tmpTable.Add "port_desc" ,rs("port_desc").value
		port_list.Add tmpTable			

'		PortCode(pIndex)=rs("port_code")
'	    PortDesc(pIndex)=rs("port_desc")
'	    PortAESCode(pIndex)=rs("port_id")	

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
<script language='javascript'>
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