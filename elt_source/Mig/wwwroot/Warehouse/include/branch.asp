<%
	Dim BranchName(64),BranchAcct(64)
	Set rs = Server.CreateObject("ADODB.Recordset")
	SQL= "select elt_account_number,dba_name from agent where left(elt_account_number,5) = " & left(elt_account_number,5)
	rs.Open SQL, eltConn, adOpenStatic, , adCmdText
	bIndex=0
	do While Not rs.EOF
		BranchName(bIndex)=rs("dba_name")
		BranchAcct(bIndex)=rs("elt_account_number")
		rs.MoveNext
		bIndex=bIndex+1
	Loop	
	rs.close
	Set rs=Nothing
	if bIndex>1 then
		HasBranch="YES"
	end if
%>
<% if HasBranch="YES" then %>
<link href="../css/elt_css.css" rel="stylesheet" type="text/css">

  <tr>
    
  <td height="24" align="center" valign="middle" class="bodycopy" colsapn="10"><strong>Branch</strong> 
    &nbsp; 
    <select name="lstBranch" size="1" class="smallselect" style="WIDTH: 175px;" onChange="BranchChange()">
      <% for i=0 to bIndex-1 %>
      <option value="<%= BranchAcct(i) %>" <% if cLng(Branch)=cLng(BranchAcct(i)) then Response.write("Selected") %>><%= BranchName(i) %></option>
      <% next %>
      <option value=0 <% if Branch=0 then response.write("selected") %>>ALL</option>
    </select></td>
  </tr>
<% end if %>