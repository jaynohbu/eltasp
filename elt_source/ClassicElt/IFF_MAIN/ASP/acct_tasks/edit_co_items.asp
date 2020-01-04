<!--  #INCLUDE FILE="../include/transaction.txt" -->
<!--  #INCLUDE FILE="../include/connection.asp" -->
<html>
<head>
<title>Edit Cost Items</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../css/elt_css.css" rel="stylesheet" type="text/css" />
<style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
-->
</style></head>
<!--  #INCLUDE FILE="../include/header.asp" -->
<!--  #include file="../include/recent_file.asp" -->
<!--  #include file="../include/GOOFY_Util_Ver_2.inc" -->
<%
Dim rs, SQL,add,delete,update,setup,dAccount
Dim aItemName(512),aItemType(512),aItemDesc(512),aItemNo(512),aItemUsed(512)
Dim aUnitPrice(512),aAR(512),aAP(512),aExpense(512)
Dim vItemNo,vItemName,vItemType,vItemDesc,vUnitPrice
Dim vAR,vAP,vExpense
Set rs = Server.CreateObject("ADODB.Recordset")
add=Request("add")
delete=Request("delete")
update=Request("update")
setup=Request.QueryString("setup")

if delete="yes" then
	rNo=Request.QueryString("rNo")
	vItemNo=Request("txtItemNo" & rNo)
	SQL= "delete item_cost where elt_account_number = " & elt_account_number & " and item_no=" & vItemNo
	eltConn.Execute SQL
end if
if update="yes" or add="yes" then
	rNo=Request.QueryString("rNo")
	vItemNo=Request("txtItemNo" & rNo)
	vItemName=Request("txtItemName" & rNo)
	vItemType=Request("lstItemType" & rNo)
	vItemDesc=Request("txtItemDesc" & rNo)
	vUnitPrice=Request("txtUnitPrice" & rNo)
	vExpense=Request("lstExpense" & rNo)
	if vExpense="" then vExpense=0
	if add="yes" then
		SQL= "select max(item_no) as ItemNo from item_cost where elt_account_number = " & elt_account_number
		rs.CursorLocation = adUseClient
		rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
		Set rs.activeConnection = Nothing
		If Not rs.EOF And IsNull(rs("ItemNo"))=False Then
			vItemNo = CLng(rs("ItemNo")) + 1
		Else
			vItemNo=1
		End If
		rs.Close
	end if
	SQL= "select * from item_cost where elt_account_number = " & elt_account_number & " and item_no=" & vItemNo
	rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
	if rs.EOF Then 
		rs.AddNew
		rs("elt_account_number") = elt_account_number
		rs("item_no")=vItemNo
	end if
	rs("item_name") = vItemName
'	rs("item_type") = vItemType
	rs("item_Desc") = vItemDesc
	if vUnitPrice="" then vUnitPrice=0
	rs("unit_Price") = vUnitPrice
	rs("account_expense") = vExpense
	rs.Update
	rs.Close
end if

If setup = "yes" Then
    SQL = "If NOT EXISTS (SELECT * FROM item_cost WHERE elt_account_number=" & elt_account_number _
        & ") INSERT INTO item_cost (elt_account_number, item_no, item_name, item_type, item_desc, unit_price, account_expense) " _
        & "SELECT '" & elt_account_number & "', item_no, item_name, item_type, item_desc, 0, account_expense FROM item_cost AS item_cost_copy where elt_account_number=10001000"
    eltConn.Execute SQL
End If

SQL= "select item_no,item_name,item_desc,unit_price,account_expense from item_cost where elt_account_number = " & elt_account_number & " order by item_name"
rs.CursorLocation = adUseClient
rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
Set rs.activeConnection = Nothing
tIndex=0
Do While Not rs.EOF
	aItemNo(tIndex)=rs("item_no")
	aItemName(tIndex)=rs("item_name")
	aItemDesc(tIndex)=rs("item_desc")
	aUnitPrice(tIndex)=rs("unit_price")
	aExpense(tIndex)=rs("account_expense")
	if IsNull(aExpense(tIndex)) then aExpense(tIndex)=0
	tIndex=tIndex+1
	rs.MoveNext
Loop
rs.Close

CALL CHECK_ITEM_USED

SQL= "select gl_account_number,gl_account_desc from gl where elt_account_number = " & elt_account_number & " and (gl_master_type='"&CONST__MASTER_EXPENSE_NAME&"') order by gl_account_number"
rs.CursorLocation = adUseClient
rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
Set rs.activeConnection = Nothing
Dim GLExpense(128),GLExpenseName(128)
gleIndex=0
Do While Not rs.EOF
	GLExpense(gleIndex)=rs("gl_account_number")
	GLExpenseName(gleIndex)=rs("gl_account_desc")
	if IsNull(GLExpense(gleIndex)) then GLExpense(gleIndex)=0
	gleIndex=gleIndex+1
	rs.MoveNext
Loop
rs.Close
Set rs=Nothing
Dim iType(12)
iType(0)="Air Freight"
iType(1)="Ocean Freight"
iType(2)="Service"
iType(3)="Non-inventory Part"
iType(4)="Other Charge"
iType(5)="Subtotal"
iType(6)="Group"
iType(7)="Discount"
iType(8)="Payment"
iType(9)="Sales Tax Item"
iType(10)="Sales Tax Group"
iType(11)="Other Expense"
itIndex=12

%>

<%
SUB CHECK_ITEM_USED

for iii=0 to tIndex-1
	if not aItemNo(iii) = "" then
		SQL= "select top 1 item_no from invoice_cost_item where elt_account_number = " _
		    & elt_account_number & " and item_no=" & aItemNo(iii)
		rs.CursorLocation = adUseClient
		rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
		Set rs.activeConnection = Nothing
		if not rs.eof then
			aItemUsed(iii) = "Y"
		end if
		rs.close
	end if
next

END SUB

%>
<!--added by stanley on 11/8/2007-->
<script  type="text/javascript" language="javascript">
    function checkLimit(obj, limit,limit2)
    {
        var num=obj.value;
        var tempArray = new Array();
        tempArray = num.split(".");
        if(num <= limit)
        {
            return true;
        }
        else
        {
            if(num > limit){
                obj.value = num.substring(0,limit2);
            }
            else{
                obj.value = parseFloat(obj.value).toFixed(2);
            }

        }
    }
    
    function CheckError(obj)
    {
        var num=obj.value;
        if (num =="" || num=="NaN")
        {
            obj.value = "0.00";
        }
    }

</script>

<body link="336699" vlink="336699" topmargin="0" onLoad="self.focus()">
<form name=form1 method="post" action="">

<table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
  <tr>
    <td height="32" align="left" valign="middle" class="pageheader">Edit Cost 
      Items </td>
  </tr>
</table>
<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0"bgcolor="#89A979">
  <tr> 
    <td> 
      
	  <input type=hidden name="hNoItem" Value="<%= tIndex %>">
  	  <input type=hidden name="ItemName">
            <!-- start of scroll bar -->		
            <input type="hidden" name="scrollPositionX">
	        <input type="hidden" name="scrollPositionY">
            <!-- end of scroll bar -->
	  
        <table width="100%" border="0" cellpadding="2" cellspacing="0" bordercolor="89A979" class="border1px">
          <tr bgcolor="D5E8CB"> 
            <td colspan="7" height="8" align="left" valign="top" class="bodyheader"></td>
          </tr>
          <tr align="left" valign="middle" bgcolor="89A979"> 
            <td colspan="7" height="1" class="bodyheader"></td>
          </tr>
          <tr align="left" valign="middle" bgcolor="ecf7f8">
              <td width="0%" bgcolor="E7F0E2" class="bodyheader">&nbsp;</td> 
            <td width="13%" height="20" bgcolor="E7F0E2" class="bodyheader">Item 
              Name </td>
            <td width="33%" bgcolor="E7F0E2" class="bodyheader">Description</td>
            <td width="9%" bgcolor="E7F0E2" class="bodyheader">Unit Price</td>
            <td width="28%" bgcolor="E7F0E2" class="bodyheader">GL-Expense </td>
            <td width="10%" bgcolor="E7F0E2" class="bodyheader">&nbsp;</td>
            <td width="7%" bgcolor="E7F0E2" class="bodyheader">&nbsp;</td>
          </tr>
          <tr align="left" valign="middle" bgcolor="f3f3f3">
              <td bgcolor="#FFFFFF">&nbsp;</td> 
            <td height="26" bgcolor="#FFFFFF"><input name="txtItemName" class="shorttextfield" maxlength="32" size="16"></td>
            <td bgcolor="#FFFFFF"><input name="txtItemDesc" class="shorttextfield" maxlength="32" size="54"></td>
            <td bgcolor="#FFFFFF"><input name="txtUnitPrice" onKeyup="checkLimit(this,100000000,8)" onblur="CheckError(this)" class="shorttextfield" size="9" style="BEHAVIOR: url(../include/igNumChkRight.htc)"></td>
            <td bgcolor="#FFFFFF">
                <select Name="lstExpense" size="1" class="shorttextfield" id="select4" style="WIDTH: 240px">
                <option value="">Select One</option>
                <% for k=0 to gleIndex-1 %>
                <option Value="<%= GLExpense(k) %>"><%= GLExpenseName(k) %></option>
                <% next %>
              </select></td>
            <td colspan="2" bgcolor="#FFFFFF"><img src="../images/button_add.gif" width="37" height="17" OnClick="AddItem(<%= tIndex+1 %>)" style="cursor:hand"></td>
          </tr>
		  <tr align="left" valign="middle" bgcolor="89A979"> 
            <td colspan="7" height="2" class="bodyheader"></td>
          </tr>
          <tr> 
            <td height="8" colspan="7" bgcolor="#FFFFFF"></td>
          </tr>
          <input type=hidden id="GlExpense">
	  	  <input type=hidden ID="hItemUsed">	  
          <% for i=0 to tIndex-1 %>
          <tr align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
              <td width="0%" bgcolor="#FFFFFF">&nbsp;</td> 
            <td width="13%" bgcolor="#FFFFFF"><input Name="txtItemName<%= i %>" class="d_shorttextfield" id="ItemName"  Value="<%= aItemName(i) %>" size="16" readonly="true"> 
              <input type=hidden Name="txtItemNo<%= i %>" value="<%= aItemNo(i) %>" readonly="true"> 
              <input type=hidden ID="hItemUsed" value="<%= aItemUsed(i) %>">            </td>
            <td><b> 
              <input Name="txtItemDesc<%= i %>" class="shorttextfield" maxlength="32" Value="<%= aItemDesc(i) %>" size="54">
              </b></td>
            <td><b> 
              <input Name="txtUnitPrice<%= i %>" class="shorttextfield" onKeyup="checkLimit(this,100000000,8)" onblur="CheckError(this)" Value="<%= ConvertAnyValue(aUnitPrice(i),"Amount",0) %>" size="9" style="BEHAVIOR: url(../include/igNumChkRight.htc)">
              </b></td>
            <td>
            <select Name="lstExpense<%= i %>" size="1" class="shorttextfield" id="select3" style="WIDTH: 240px">
                <option value=""></option>
                <% for k=0 to gleIndex-1 %>
                <option Value="<%= GLExpense(k) %>" <% if CLng(aExpense(i))=CLng(GLExpense(k)) then response.write("selected") %>><%= GLExpense(k) & "-" & GLExpenseName(k) %></option>
                <% next %>
              </select></td>
            <td><% if Not aItemUsed(i) = "Y" then %><img src="../images/button_delete.gif" width="50" height="17" OnClick="DeleteItem(<%= i %>)" style="cursor:hand" /><%end if%></td>
            <td><img src="../images/button_update.gif" width="52" height="18" OnClick="UpdateItem(<%= i %>,'<%=aItemUsed(i) %>')" style="cursor:hand" /></td>
          </tr>
          <% Response.Flush() %>
          <% next %>
		            <tr> 
            <td height="8" colspan="7" bgcolor="#FFFFFF"></td>
          </tr>
		  <tr align="left" valign="middle" bgcolor="89A979"> 
            <td colspan="7" height="1" class="bodyheader"></td>
          </tr>
          <tr align="center" bgcolor="D5E8CB"> 
            <td height="24" colspan="7" valign="middle" bgcolor="D5E8CB" class="bodycopy">&nbsp;</td>
          </tr>
        </table>
      </td>
  </tr>
</table>
<br />
</form>
</body>
<script type="text/vbscript">

Sub AddItem(tIndex)
newName = document.form1.txtItemName.Value

	if newName="" then
		MsgBox "Please enter an item name!"
    elseif document.form1.lstExpense.value = "" Then
        MsgBox "Please select GL-Expense!"
	else
		NoItem=document.form1.hNoItem.Value
		for i=1 to NoItem
			if newName = document.all("ItemName").item(i).value then
			 msgbox "Item name " & newName & " exists already. "
			 exit sub
			end if
		next
	
		document.form1.action="edit_co_items.asp?add=yes" & "&WindowName=" & window.name
		document.form1.method="POST"
		document.form1.target="_self"
		form1.submit()
	end if
End Sub
Sub DeleteItem(rNo)
	ok=MsgBox ("Are you sure you want to delete this item?" & chr(13) & "Continue?",36,"Message")
	if ok=6 then	
		document.form1.action="edit_co_items.asp?delete=yes&rNo=" & rNo & "&WindowName=" & window.name
		document.form1.method="POST"
		document.form1.target="_self"
		form1.submit()
	end if
End Sub

Sub UpdateItem(rNo,warning)
    If document.all("lstExpense"&rNo).value = "" Then
        msgbox "Please, select GL-Expense account." 
        Exit Sub
    End If
    if warning= "Y" then
        ok=MsgBox ("This item belongs to some existing invoices." & chr(13) & "Do you want to update it anyway?" & chr(13) & "",36,"Message")
        if Not ok=6 then
            exit sub
        end if
    end if

    document.form1.action="edit_co_items.asp?update=yes&rNo=" & rNo & "&WindowName=" & window.name
    document.form1.method="POST"
    document.form1.target="_self"
    form1.submit()
End Sub

Sub MenuMouseOver()
NoItem=document.form1.hNoItem.Value
for i=1 to NoItem+1
	document.all("GlExpense").item(i).style.visibility="hidden"
next
End Sub
Sub MenuMouseOut()
NoItem=document.form1.hNoItem.Value
for i=1 to NoItem+1
	document.all("GlExpense").item(i).style.visibility="visible"
next
End Sub

</script>
<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
