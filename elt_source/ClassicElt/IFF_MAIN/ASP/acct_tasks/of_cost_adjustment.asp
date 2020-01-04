<!--  #INCLUDE FILE="../include/transaction.txt" -->
<!--  #INCLUDE FILE="../include/connection.asp" -->

<html>
<head>
<title>Profit Adjustment</title>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<link href="../css/elt_css.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/JavaScript">
<!--



function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}
//-->
</script>
<link href="../css/elt_css.css" rel="stylesheet" type="text/css">
</head>
<!--  #INCLUDE FILE="../include/header.asp" -->
<!--  #INCLUDE FILE="../include/GOOFY_util_fun.inc" -->
<!--  #include file="../include/recent_file.asp" -->
<%
Dim aHAWB(64),aCollect(32),aCost(32),aAdjCost(32),aPS(32),aAdjPS(32),aShare(32)
Dim aOCarrier(32),aOAgent(32)
Dim rs,SQL

    Set rs=Server.CreateObject("ADODB.Recordset")
    InvoiceNo=Request.QueryString("InvoiceNo")
    vMAWB=checkBlank(Request.QueryString("MAWB"),checkBlank(Request("txtMAWB"),""))
    vAgent=checkBlank(Request.QueryString("Agent"),checkBlank(Request("txtCustomerNumber"),0))
    Save=Request.QueryString("SSave")

    if Save="yes" then
        NoItem=Request("hNoItem")
        tPS=0
        
        for i=0 to NoItem-1
            vHAWB=Request("txtHAWB" & i)
            vCost=Request("txtADJCost" & i)
            vLastPS=Request("txtPS" & i)
            vPS=Request("txtADJPS" & i)
            if not vPS="" then
                tPS=tPS+cDbl(vPS)
            else
                tPS=tPS+cDbl(vLastPS)
            end if
            vOCarrier=Request("txtOCarrier" & i)
            if Not vOCarrier="" then
                tPS=tPS+cDbl(vOCarrier)
            end if
            vOAgent=Request("txtOAgent" & i)
            if Not vOAgent="" then
                tPS=tPS+cDbl(vOAgent)
            end if
            
            if Not vCost="" or Not vPS="" or Not vOCarrier="" or Not vOAgent="" then
				SQL= "select hbol_num,total_weight_charge,of_cost,agent_profit,agent_profit_share,other_agent_profit_carrier,other_agent_profit_agent from HBOL_master "
				SQL=SQL & " where elt_account_number=" & elt_account_number 
				SQL=SQL & " and mbol_num='" & vMAWB & "'"
				SQL=SQL & " and agent_no=" & vAgent
                rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
				if rs.eof then
					rs.close
					SQL= "select BOOKING_NUM,total_weight_charge,of_cost,agent_profit,agent_profit_share,other_agent_profit_carrier,other_agent_profit_agent from MBOL_master "
					SQL=SQL & " where elt_account_number=" & elt_account_number 
					SQL=SQL & " and mbol_num='" & vMAWB & "'"
					SQL=SQL & " and agent_acct_num=" & vAgent
					rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
					if Not vCost="" then
						rs("of_cost")=vCost
					end if
					if Not vPS="" then
						rs("agent_profit")=vPS
					end if
					if Not vOCarrier="" then
						rs("other_agent_profit_carrier")=vOCarrier
					end if
					if Not vOAgent="" then
						rs("other_agent_profit_agent")=vOAgent
					end if
					rs.Update	
					rs.Close				
				else
					if Not vCost="" then
						rs("of_cost")=vCost
					end if
					if Not vPS="" then
						rs("agent_profit")=vPS
					end if
					if Not vOCarrier="" then
						rs("other_agent_profit_carrier")=vOCarrier
					end if
					if Not vOAgent="" then
						rs("other_agent_profit_agent")=vOAgent
					end if
					rs.Update
					rs.Close
				end if	
           end if
           
        next

        if Not InvoiceNo="" and Not InvoiceNo="0" then
            SQL="select agent_profit,subtotal,amount_charged,balance from invoice where elt_account_number=" & elt_account_number & " and invoice_no=" & InvoiceNo
            rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
            if Not rs.EOF then
                rs("agent_profit")=tPS
                rs("amount_charged")=cDbl(rs("subtotal"))-tPS
                rs("balance")=cDbl(rs("subtotal"))-tPS
                rs.Update
            end if
            rs.Close
			tmpTarget = "edit_invoice.asp?edit=yes&InvoiceNo=" & InvoiceNo
			%>
				<script language="javascript">
					window.opener.location.replace('<%= tmpTarget %>');
					window.close();
				</script>
			<%
'            Response.Redirect("edit_invoice.asp?edit=yes&InvoiceNo=" & InvoiceNo)
        else
            url=Request("hQueryString")
			%>
				<script language="javascript">
					window.opener.location.replace('<%= url %>');
					window.close();
				</script>
			<%
'            Response.Redirect("edit_invoice.asp?" & url)
        end if
    else

	    SQL= "select hbol_num,total_weight_charge,of_cost,agent_profit,agent_profit_share,other_agent_profit_carrier,other_agent_profit_agent from HBOL_master "
	    SQL=SQL & " where elt_account_number=" & elt_account_number 
	    SQL=SQL & " and mbol_num='" & vMAWB & "'"
	    SQL=SQL & " and agent_no=" & vAgent
	    SQL=SQL & " order by HBOL_NUM"

	    rs.Open SQL, eltConn, , , adCmdText
	    tIndex=0
		if rs.eof then
			rs.Close
			SQL= "select BOOKING_NUM,total_weight_charge,of_cost,agent_profit,agent_profit_share,other_agent_profit_carrier,other_agent_profit_agent from MBOL_master "
			SQL=SQL & " where elt_account_number=" & elt_account_number 
			SQL=SQL & " and mbol_num='" & vMAWB & "'"
			SQL=SQL & " and agent_acct_num=" & vAgent
			rs.Open SQL, eltConn, , , adCmdText
			if Not rs.EOF then
				aHAWB(tIndex)=rs("BOOKING_NUM")
				aCollect(tIndex)=rs("total_weight_charge")
				aCost(tIndex)=rs("of_cost")
				aPS(tIndex)=rs("agent_profit")
				aShare(tIndex)=rs("agent_profit_share")
				aOCarrier(tIndex)=rs("other_agent_profit_carrier")
				aOAgent(tIndex)=rs("other_agent_profit_agent")
				tIndex=tIndex+1
			end if
			rs.Close						
		else
			Do While Not rs.EOF
				aHAWB(tIndex)=rs("hbol_num")
				aCollect(tIndex)=rs("total_weight_charge")
				aCost(tIndex)=rs("of_cost")
				aPS(tIndex)=rs("agent_profit")
				aShare(tIndex)=rs("agent_profit_share")
				aOCarrier(tIndex)=rs("other_agent_profit_carrier")
				aOAgent(tIndex)=rs("other_agent_profit_agent")
				tIndex=tIndex+1
				rs.MoveNext
			Loop
			rs.Close
		end If

    end if
    
%>

<body link="336699" vlink="336699" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="self.focus()" >
<br>
<table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
  <tr>
    <td height="32" align="left" valign="middle" class="pageheader">Profit Adjustment</td>
  </tr>
</table>
<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0"bgcolor="#89A979">
  <tr> 
    <td> 
     <form name=form1>
	  <input type=hidden name="hNoItem" value="<%= tIndex %>">
<input type=hidden name="hQueryString" value="<%= query_string %>">
<input type=hidden name="hInvoiceNo" value="<%= InvoiceNo %>">
        <table width="100%" border="0" cellpadding="2" cellspacing="1">
          <tr bgcolor="D5E8CB"> 
            <td width="10%" height="8" align="left" valign="top" class="bodyheader"></td>
          </tr>
          <tr align="left" valign="middle" bgcolor="ecf7f8"> 
            <td height="24" bgcolor="E7F0E2" class="bodyheader"><br> <table width="60%" border="0" align="center" cellpadding="2" cellspacing="1" bgcolor="89A979" class="bodycopy">
                <tr> 
                  <td height="20" bgcolor="D5E8CB"><strong> B/L </strong></td>
                  <td bgcolor="D5E8CB"><strong>Frt Cost</strong></td>
                  <td bgcolor="D5E8CB"><strong>Adjusted Cost</strong></td>
                  <td bgcolor="D5E8CB"><strong>P/S</strong></td>
                  <td bgcolor="D5E8CB"><strong>Adjusted P/S</strong></td>
                  <td bgcolor="D5E8CB"><strong>O/C Carrier</strong></td>
                  <td bgcolor="D5E8CB"><strong>O/C Agent</strong></td>
                </tr>
				<input type=hidden id=CollectAmt>
			  <input type=hidden id=ADJCost>
			   <input type=hidden id=ADJPS>
			   <input type=hidden id=Share>
			   <input type=hidden id=OCarrier>
			   <input type=hidden id=OAgent>
<% for i=0 to tIndex-1 %>
                <tr bgcolor="#FFFFFF"> 
                  <td><input name="txtHAWB<%= i %>" type="text" class="d_shorttextfield" value="<%= aHAWB(i) %>" size="22" ReadOnly></td>
                  <td><input name="txtCost<%= i %>" type="text" class="d_shorttextfield" value="<%= aCost(i) %>" size="12" ReadOnly></td>
                  <td><input name="txtADJCost<%= i %>" type="text" class="numberfield" id="ADJCost" OnChange="CostChange(<%= i+1 %>)" value="<%= aAdjCost(i) %>" size="12"></td>
                  <td><input name="txtPS<%= i %>" type="text" class="d_shorttextfield" value="<%= aPS(i) %>" size="12" ReadOnly></td>
                  <td><input name="txtADJPS<%= i %>" type="text" class="numberfield" id="ADJPS" value="<%= aADJPS(i) %>" size="12"></td>
                  <td><input name="txtOCarrier<%= i %>" type="text" class="numberfield" id="OCarrier" value="<%= aOCarrier(i) %>" size="12"></td>
                  <td><input name="txtOAgent<%= i %>" type="text" class="numberfield" id="OAgent" value="<%= aOAgent(i) %>" size="12"></td>
				<input type=hidden id=CollectAmt Value="<%= aCollect(i) %>">
				<input type=hidden id=Share Value="<%= aShare(i) %>">
                </tr>
<% next %>
                <tr bgcolor="#FFFFFF"> 
                  <td height="20" colspan="7" bgcolor="f3f3f3">&nbsp;</td>
                </tr>
                <tr align="center" bgcolor="89A979"> 
                  <td height="22" colspan="7"><img src="../images/button_save_medium.gif" width="46" height="18" name="bSave" OnClick="SaveClick()" style="cursor:hand"></td>
                </tr>
              </table>
              <br> </td>
          </tr>
          <tr align="left" valign="middle" bgcolor="89A979"> 
            <td height="22" bgcolor="D5E8CB" class="bodyheader">&nbsp;</td>
          </tr>

        </table>
      </form></td>
  </tr>
</table>
<br>
</body>
<script language="VBScript">
<!--
Sub SaveClick()
Save=True
NoItem=document.form1.hNoItem.Value
for i=1 to NoItem
	if Not document.all("ADJCOST").item(i).Value="" and IsNumeric(document.all("ADJCOST").item(i).Value)=False then
		MsgBox "Please enter a numeric value for Adjusted Freight Cost!"
		Save=False
		exit for
	end if
	if Not document.all("ADJPS").item(i).Value="" and IsNumeric(document.all("ADJPS").item(i).Value)=False then
		MsgBox "Please enter a numeric value for Adjusted Agent Profit!"
		Save=False
		exit for
	end if
	if Not document.all("OCarrier").item(i).Value="" and IsNumeric(document.all("OCarrier").item(i).Value)=False then
		MsgBox "Please enter a numeric value for other charge agent profit!"
		Save=False
		exit for
	end if
	if Not document.all("OAgent").item(i).Value="" and IsNumeric(document.all("OAgent").item(i).Value)=False then
		MsgBox "Please enter a numeric value for other charge agent profit!"
		Save=False
		exit for
	end if
next
if Save=True then
	document.form1.action="of_cost_adjustment.asp?SSave=yes&InvoiceNo=<%= InvoiceNo %>&MAWB=<%= vMAWB %>&Agent=<%= vAgent %>" & "&WindowName=" & window.name
	document.form1.method="POST"
	Document.form1.target="_self"
	form1.submit()
end if
End Sub
Sub CostChange(ItemNo)
CollectAmt=document.all("CollectAmt").item(ItemNo).Value
Share=document.all("Share").item(ItemNo).Value
if Share="" then Share=0
ADJCost=document.all("ADJCost").item(ItemNo).Value
If Not IsNumeric(ADJCost) then
	MsgBox "Please enter a numeric number for adjusted COST!"
	exit sub
end if
PS=(CollectAmt-ADJCost)*cDbl(Share)
document.all("ADJPS").item(ItemNo).Value=PS
end Sub
Sub MenuMouseOut()
End Sub
-->
</script>
</html>
