<%
If UserRight>=9 then
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
end if
%>
<% if HasBranch="YES" then %>
    <b><font size=3>Branch</font></b><select Name="lstBranch" size="1" style="HEIGHT: 22px; WIDTH: 300px;" OnChange="BranchChange()">
<% for i=0 to bIndex-1 %>
	<option Value="<%= BranchAcct(i) %>" <% if cLng(Branch)=cLng(BranchAcct(i)) then Response.write("Selected") %>><%= BranchName(i) %></option>
<% next %>
	<option Value=0 <% if Branch=0 then response.write("selected") %>>ALL</option>
	</select>
<% end if %>