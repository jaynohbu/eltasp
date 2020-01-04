<%@ LANGUAGE = VBScript %>
<html>
<head>
<title>Air Import Search</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script type="text/jscript" language="javascript" src="../include/WebDateSetJN.js" >  
</script>	
<link href="../css/elt_css.css" rel="stylesheet" type="text/css">
<!--  #INCLUDE FILE="../include/connection.asp" -->
<style type="text/css">
<!--
.style1 {color: #cc6600}
body {
	margin-left: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
-->
</style>
</head>
<!--  #INCLUDE FILE="../include/header.asp" -->
 <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
<!--  #include file="../include/recent_file.asp" -->


<%

dim vNoResult
vNoResult=false

SearchType=Request.QueryString("SearchType")
FormID=Request.QueryString("FormID")
vStartDate=Request("txtStartDate")
vEndDate=Request("txtEndDate")
if vStartDate="" then vStartDate=Date
if vEndDate="" then vEndDate=Date+1
vDeptPort=Request("txtDeptPort")
vDestPort=Request("txtDestPort")
vShipper=Request("txtShipper")
vConsignee=Request("txtConsignee")

vLC=Request("txtLC")
vInvoice=Request("txtInvoice")
vUserRef=Request("txtUserRef")
vNoPiece=Request("txtNoPiece")

myServer=Request.ServerVariables("SERVER_NAME")
if myServer="10.1.1.53" then
	DM="#"
else
	DM="'"
end if
%>
<body link="336699" vlink="336699" topmargin="0" onLoad="self.focus()" id="as">
<form name="frmSearch" action="Post" method="post">
<!-- pointer disabled
<table width="100%" height="12" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td align="center" valign="top"><img src="../images/spacer.gif" width="640" height="6"><img src=<% 
	
	if Not isPopWin then  
	response.write("'../images/pointer_ai.gif'") 
	end if%> width="11" height="7"><img src="../images/spacer.gif" width="27" height="6"></td>
  </tr>
</table>
-->
<table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
  <tr>
    <td height="32" align="left" valign="middle" class="pageheader">Air import 
      search </td>
  </tr>
</table>
<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#ba9590">
  <tr> 
    <td>
      
        <table width="100%" border="0" cellpadding="2" cellspacing="1">
          <tr bgcolor="edd3cf"> 
            <td colspan="10" height="8" align="left" valign="top" class="bodyheader"></td>
          </tr>
          <tr align="center" valign="middle" bgcolor="efe1df"> 
            <td height="24" colspan="10" align="center" bgcolor="#F3F3F3" class="bodyheader"><br> 
                <table width="64%" border="0" cellpadding="2" cellspacing="0" bordercolor="ba9590" bgcolor="edd3cf" class="border1px">
                <tr align="left" valign="middle"> 
                  
                  <td colspan="7" align="left" valign="middle" bgcolor="efe1df" class="bodycopy"></td>
                </tr>

                <tr bgcolor="#efe1df">
                    <td align="left" valign="middle">&nbsp;</td>
                    <td width="121" height="20" align="left" valign="middle" bgcolor="#efe1df"><strong class="bodycopy style1">Search Type</strong></td>
                    <td width="130" align="left" valign="middle" class="bodyheader">Period</td>
                    <td width="109" align="left" valign="middle" class="bodyheader">Start Date</td>
                    <td width="130" align="left" valign="middle" bgcolor="#efe1df" class="bodyheader">End Date</td>
                    <td width="49" align="left" valign="middle">&nbsp;</td>
                    <td width="88" align="left" valign="middle"></td>
                    </tr>
                <tr bgcolor="#FFFFFF">
                    <td align="left" valign="middle">&nbsp;</td>
                    <td align="left" valign="middle" class="bodyheader"><strong>
                        <select name="lstSearchType" size="1" class="bodyheader" style="WIDTH: 106px">
                            <option value="HAWB" <% if SearchType="HAWB" then response.write("selected") %>>House AWB No.</option>
                            <option value="MAWB" <% if SearchType="MAWB" then response.write("selected") %>>Master AWB No.</option>
                        </select>
                    </strong></td>
                    <td align="left" valign="middle"><select name="select"  class="smallselect"onChange= "Javascript:myRadioButtonforDateSet1CheckDate(this)">
                        <option value="Clear" > Select </option>
                        <option value="Today">Today</option>
                        <option value="Month to Date">Month to Date</option>
                        <option value="Quarter to Date">Quarter to Date</option>
                        <option value="Year to Date">Year to Date</option>
                        <option value="This Month">This Month</option>
                        <option value="This Quarter">This Quarter</option>
                        <option value="This Year">This Year</option>
                        <option value="Last Month">Last Month</option>
                        <option value="Last Quarter">Last Quarter</option>
                        <option value="Last Year">Last Year</option>
                    </select></td>
                    <td align="left" valign="middle" class="bodyheader"><span class="bodycopy">
                        <input name="txtStartDate" class="m_shorttextfield " preset="shortdate" value="<%= vStartDate %>" size="16">
                    </span></td>
                    <td align="left" valign="middle" class="bodycopy"><input name="txtEndDate" class="m_shorttextfield " preset="shortdate" value="<%= vEndDate %>" size="16"></td>
                    <td align="left" valign="middle" class="bodyheader">&nbsp;</td>
                    <td align="left" valign="middle" class="bodyheader">&nbsp;</td>
                    </tr>
                
				<tr> 
                  <td height="2" colspan="7" align="left" valign="middle" bgcolor="ba9590"></td>
                </tr>
                <tr bgcolor="#F3F3F3">
                    <td align="left" valign="middle">&nbsp;</td>
                    <td align="left" valign="middle" class="bodyheader">Departure 
                    Port</td>
                    <td height="20" colspan="2" align="left" valign="middle" class="bodyheader">&nbsp;</td>
                    <td align="left" valign="middle" class="bodyheader">Destination 
                    Port</td>
                    <td colspan="2" align="left" valign="middle">&nbsp;</td>
                    </tr>
                <tr bgcolor="#F3f3f3"> 
                  <td width="1" align="left" valign="middle" bgcolor="#FFFFFF">&nbsp;</td>
                  <td colspan="3" align="left" valign="middle" bgcolor="#FFFFFF"><input name="txtDeptPort" class="shorttextfield" value="<%= vDeptPort %>" size="48"></td>
                  <td colspan="3" align="left" valign="middle" bgcolor="#FFFFFF"><input name="txtDestPort" class="shorttextfield" value="<%= vDestPort %>" size="48"></td>
                  </tr>
                <tr bgcolor="#FFFFFF"> 
                  <td align="left" valign="middle" bgcolor="#f3f3f3">&nbsp;</td>
                  <td align="left" valign="middle" bgcolor="#f3f3f3" class="bodyheader">Shipper</td>
                  <td height="20" colspan="2" align="left" valign="middle" bgcolor="#f3f3f3" class="bodyheader">&nbsp;</td>
                  <td align="left" valign="middle" bgcolor="#f3f3f3" class="bodyheader">Consignee</td>
                  <td colspan="2" align="left" valign="middle" bgcolor="#f3f3f3">&nbsp;</td>
                  </tr>
                <tr bgcolor="#F3f3f3">
                    <td align="left" valign="middle" bgcolor="#FFFFFF">&nbsp;</td>
                    <td colspan="3" align="left" valign="middle" bgcolor="#FFFFFF"><input name="txtShipper" class="shorttextfield" value="<%= vShipper %>" size="48"></td>
                    <td colspan="3" align="left" valign="middle" bgcolor="#FFFFFF"><b><font color="#36255A">
                        <input name="txtConsignee" class="shorttextfield" value="<%= vConsignee %>" size="48">
                    </font></b></td>
                    </tr>
                <tr bgcolor="#F3f3f3">
                    <td align="left" valign="middle">&nbsp;</td>
                    <td align="left" valign="middle" class="bodyheader">No. of Pieces</td>
                    <td height="20" colspan="2" align="left" valign="middle" class="bodyheader">LC No.</td>
                    <td align="left" valign="middle" class="bodyheader">C.I. No.</td>
                    <td colspan="2" align="left" valign="middle" class="bodyheader">Other Reference No.</td>
                    </tr>
                <tr bgcolor="#F3f3f3"> 
                  <td align="left" valign="middle" bgcolor="#FFFFFF">&nbsp;</td>
                  <td align="left" valign="middle" bgcolor="#FFFFFF"><input name="txtNoPiece" class="shorttextfield" value="<%= vNoPiece %>" size="14"></td>
                  <td colspan="2" align="left" valign="middle" bgcolor="#FFFFFF"><input name="txtLC" class="shorttextfield" value="<%= vLC %>" size="20"></td>
                  <td align="left" valign="middle" bgcolor="#FFFFFF"><input name="txtInvoice" class="shorttextfield" value="<%= vInvoice %>" size="20"></td>
                  <td colspan="2" align="left" valign="middle" bgcolor="#FFFFFF"><input name="txtUserRef" class="shorttextfield" value="<%= vUserRef %>" size="20"></td>
                  </tr>
                <tr bgcolor="#FFFFFF"> 
                  <td align="left" valign="middle" bgcolor="#f3f3f3">&nbsp;</td>
                  <td align="left" valign="middle" bgcolor="#f3f3f3">&nbsp;</td>
                  <td colspan="2" align="left" valign="middle" bgcolor="#f3f3f3">&nbsp;</td>
                  <td align="left" valign="middle" bgcolor="#f3f3f3">&nbsp;</td>
                  <td colspan="2" align="center" valign="middle" bgcolor="#f3f3f3"><img src="../images/button_go.gif" width="31" height="18" onClick="AllClick()"  style="cursor:hand"></td>
                  </tr>
              </table>
              <br> </td>
          <tr bgcolor="ba9590"> 
            <td height="1" colspan="10" align="left" valign="middle" class="bodycopy"></td>
          </tr>
          <tr bgcolor="edd3cf"> 
            <td width="120" height="20" align="left" valign="middle" bgcolor="#efe1df" class="bodyheader"> 
            <% if SearchType="HAWB" THEN response.write("House AWB No.") ELSE response.write("Master AWB No.")END IF  %> </td>
            <td width="104" align="left" valign="middle" bgcolor="#efe1df" class="bodyheader"> <% if SearchType="MAWB" THEN response.write("House AWB No.") ELSE response.write("Master AWB No.") END IF%> </td>
            <td width="113" align="left" valign="middle" bgcolor="#efe1df" class="bodyheader">File No.</td>
            <td width="35" align="left" valign="middle" bgcolor="#efe1df" class="bodyheader">SEC</td>
            <td width="81" align="left" valign="middle" bgcolor="#efe1df" class="bodyheader">Date</td>
            <td width="158" align="left" valign="middle" bgcolor="#efe1df" class="bodyheader">Shipper</td>
            <td width="185" align="left" valign="middle" bgcolor="#efe1df" class="bodyheader">Consignee</td>
            <td width="136" align="left" valign="middle" bgcolor="#efe1df" class="bodyheader">Departure 
              Port</td>
            <td width="158" align="left" valign="middle" bgcolor="#efe1df" class="bodyheader">Destination 
              Port</td>
            <td width="55" align="left" valign="middle" bgcolor="#efe1df" class="bodycopy">&nbsp;</td>
          </tr>
          <%
Dim rs, SQL
	Set rs = Server.CreateObject("ADODB.Recordset")

if NOT searchType = "" then
	if searchType = "HAWB" THEN'<------------------------add file_no
		SQL= "select b.file_no as file#,a.iType,a.agent_org_acct as acct,a.HAWB_NUM as h,b.MAWB_NUM as m,b.sec,convert(char(10),a.CreatedDate,101) as tran_date,a.Shipper_name as shipper,a.consignee_name as consignee,a.dep_port as p1,a.arr_port as p2 from import_hawb a,import_mawb b where a.elt_account_number=b.elt_account_number and a.elt_account_number=" & elt_account_number & " and a.agent_org_acct=b.agent_org_acct and a.mawb_num=b.mawb_num and a.sec=b.sec and a.iType ='A'"
		SQL=SQL & " and b.iType='A'"
		if Not FormID="" then
				SQL=SQL & " and a.hawb_num='" & FormID & "'"
		else
		'--------------------------------------------------------------------------------------------------------------------------------------------------------------
		if vLC = "" and vInvoice = "" and vUserRef = "" then
			if not vStartDate="" Then
				SQL=SQL & " and a.CreatedDate Between " & DM & vStartDate & DM & " and DATEADD(day, 1," & DM  & vEndDate & DM & ")"
			end If
		end if
			
		'--------------------------------------------------------------------------------------------------------------------------------------------------------------
			if not vDeptPort="" Then
				SQL=SQL & " and a.Dep_port like '%" & vDeptPort & "%'"
			end if
			if not vDestPort="" Then
				SQL=SQL & " and a.Arr_port like '%" & vDestPort & "%'"
			end if
			if not vShipper="" then
				SQL=SQL & " and Shipper_name like '%" & vShipper & "%'"
			end if
			if not vConsignee="" then
				SQL=SQL & " and consignee_name like '%" & vConsignee & "%'"
			end if
			if Not vLC="" then
				SQL=SQL & " and Desc1 like '%" & vLC & "%'"
			end if
			if Not vInvoice="" then
				SQL=SQL & " and Desc2 like '%" & vInvoice & "%'"
			end if
			if Not vUserRef="" Then
				SQL=SQL & " and customer_ref like '%" & vUserRef & "%'"
			end if
			if not vNoPiece="" then
				SQL=SQL & " and b.Pieces=" & vNoPiece
			end if
				SQL=SQL & " order by a.mawb_num,a.sec,hawb_num"
		end if	
		rs.Open SQL, eltConn, , , adCmdText
		if rs.EOF =true then vNoResult=true
		'response.Write("-------------"&SQL)
		Do While Not rs.EOF

			AgentOrgAcct=rs("acct")
			iType=rs("iType")
			HAWB=rs("h")
			MAWB=rs("m")'<------------------------------get from DB
			FileNo=rs("file#")
			Sec=rs("sec")
				EditID=HAWB
			Tran_Date=rs("tran_date")			
			Shipper=rs("Shipper")
			Consignee=rs("consignee")
			DeptPort=rs("p1")
			DestPort=rs("p2")
	%>
          <tr bgcolor="#FFFFFF"> 
          
            <td height="22" align="left" valign="middle" class="bodyheader"><%=HAWB %></td>
            <td align="left" valign="middle" class="bodyheader"><%= MAWB %></td>
            <td align="left" valign="middle" class="bodycopy"><%= FileNo %></td>
            <td align="left" valign="middle" class="bodycopy"><%= Sec %></td>
            <td align="left" valign="middle" class="bodycopy"><%= Tran_Date %></td>
            <td align="left" valign="middle" class="bodycopy"><%= Shipper %></td>
            <td align="left" valign="middle" class="bodycopy"><%= Consignee %></td>
            <td align="left" valign="middle" class="bodycopy"><%= DeptPort %></td>
            <td align="left" valign="middle" class="bodycopy"><%= DestPort %></td>
            <td align="left" valign="middle" class="bodycopy"><img src="../images/button_edit.gif" width="37" height="18" onClick="EditClick('<%= iType %>','<%= MAWB %>',<%= Sec %>,<%= AgentOrgAcct %>,'<%=HAWB%>')"  style="cursor:hand"></td>
          </tr>
          <%
			rs.MoveNext
		Loop
		rs.Close
	else		'////////////// searchType = "MBOL"
		SQL= "select a.file_no as file#,a.iType,a.agent_org_acct as acct,a.MAWB_NUM as m, a.sec,convert(char(10),a.CreatedDate,101) as tran_date,a.dep_port as p1,a.arr_port as p2,b.hawb_num as hawb_num,b.Shipper_name as Shipper_name,b.consignee_name as consignee_name from import_mawb a left outer join import_hawb b on  a.elt_account_number=b.elt_account_number and a.mawb_num=b.mawb_num where a.elt_account_number=" & elt_account_number & " and a.iType ='A'"
		if Not FormID="" then
				SQL=SQL & " and a.mawb_num='" & FormID & "'"
		else
		'--------------------------------------------------------------------------------------------------------------------------------------------------------------
		if vLC = "" and vInvoice = "" and vUserRef = "" then
			if not vStartDate="" Then
				SQL=SQL & " and a.CreatedDate Between " & DM & vStartDate & DM & " and DATEADD(day, 1," & DM  & vEndDate & DM & ")"
			end If
		end if
	    '--------------------------------------------------------------------------------------------------------------------------------------------------------------
			if not vDeptPort="" Then
				SQL=SQL & " and a.Dep_port like '%" & vDeptPort & "%'"
			end if
			if not vDestPort="" Then
				SQL=SQL & " and a.Arr_port like '%" & vDestPort & "%'"
			end if
			if not vNoPiece="" then
				SQL=SQL & " and a.Pieces=" & vNoPiece
			end if
		end if		
			
			SQL=SQL & " order by a.mawb_num"
'	response.write SQL	
		rs.Open SQL, eltConn, , , adCmdText
		
		if rs.EOF =true then vNoResult=true
		Do While Not rs.EOF
			AgentOrgAcct=rs("acct")
			MAWB=rs("m")
			FileNo=rs("file#")
			Sec=rs("sec")			
			EditID=MAWB
			Tran_Date=rs("tran_date")
			DeptPort=rs("p1")
			DestPort=rs("p2")

			HAWB = rs("hawb_num")
			Shipper=rs("Shipper_name")
			Consignee=rs("consignee_name")

'			HAWB = ""
'			Shipper = ""		
'			Consignee = ""		

'			Set rs1=Server.CreateObject("ADODB.Recordset")
'			SQL2 = "select * from import_hawb where elt_account_number="&elt_account_number&" AND MAWB_NUM='"&MAWB&"' and iType='A'"
'			if not vShipper="" then
'				SQL2=SQL2 & " and Shipper_name like '%" & vShipper & "%'"
'			end if
'			if not vConsignee="" then
'				SQL2=SQL2 & " and consignee_name like '%" & vConsignee & "%'"
'			end if
'			if Not vLC="" then
'				SQL2=SQL2 & " and Desc1 like '%" & vLC & "%'"
'			end if
'			if Not vInvoice="" then
'				SQL2=SQL2 & " and Desc2 like '%" & vInvoice & "%'"
'			end if
'			if Not vUserRef="" Then
'				SQL=SQL & " and customer_ref like '%" & vUserRef & "%'"
'			end if
			
'			rs1.Open SQL2, eltConn, , , adCmdText
'			if NOT rs1.EOF then
'				HAWB = rs1("hawb_num")
'				Shipper=rs1("Shipper_name")
'				Consignee=rs1("consignee_name")
'			END iF
'			rs1.Close
	%>
          <tr bgcolor="#FFFFFF"> 
            <td height="22" align="left" valign="middle" class="bodyheader"><%= MAWB %></td>
            <td align="left" valign="middle" class="bodyheader"><%= HAWB %></td>
            <td align="left" valign="middle" class="bodycopy"><%= FileNo %></td>
            <td align="left" valign="middle" class="bodycopy"><%= Sec %></td>
            <td align="left" valign="middle" class="bodycopy"><%= Tran_Date %></td>
            <td align="left" valign="middle" class="bodycopy"><%= Shipper %></td>
            <td align="left" valign="middle" class="bodycopy"><%= Consignee %></td>
            <td align="left" valign="middle" class="bodycopy"><%= DeptPort %></td>
            <td align="left" valign="middle" class="bodycopy"><%= DestPort %></td>
            <td align="left" valign="middle" class="bodycopy"><img src="../images/button_edit.gif" width="37" height="18" onClick="EditClick('<%= iType %>','<%= MAWB %>',<%= Sec %>,<%= AgentOrgAcct %>,'<%=HAWB%>')"  style="cursor:hand"></td>
          </tr>
          <%
			rs.MoveNext
		Loop
		rs.Close
	end if
end if 			'////////////// NOT searchType = ""


Set rs=Nothing


if vNoResult=true then 
		%> <tr bgcolor="ffffff"> 
            <td colspan="10" height="22" align="center" valign="middle" class="bodycopy"><font color="#FF0000">No result found from the search!</font> </td>
          </tr><%
end if 

%>
          <tr bgcolor="edd3cf"> 
            <td colspan="10" height="22" align="left" valign="middle" class="bodycopy">&nbsp;</td>
          </tr>
        </table>
      
	  </td>
    </tr>
</table>
</form>
</body>
<SCRIPT LANGUAGE="vbscript">
<!---
Sub GoClick()
Dim FormID
FormID=""
sIndex=document.frmSearch.lstSearchType.selectedindex
sType=document.frmSearch.lstSearchType.item(sIndex).Value
if Not FormID="" then
	document.frmSearch.action="ai_search.asp?SearchType=" & sType &"&FormID=" & FormID
	document.frmSearch.method="POST"
	document.frmSearch.target = "_self"	
	frmSearch.submit()
else
	MsgBox "Please enter an AWB number first!"
end if
End Sub

Sub Allclick()
Dim StartDate,EndDate,NoPiece,GrossWeight
sIndex=document.frmSearch.lstSearchType.selectedindex
sType=document.frmSearch.lstSearchType.item(sIndex).Value
StartDate=document.frmSearch.txtStartDate.Value
EndDate=document.frmSearch.txtEndDate.Value
NoPiece=document.frmSearch.txtNoPiece.Value

If Not StartDate="" And IsDate(StartDate)=False Then
	MsgBox "Please enter a correct date! (MM/DD/YYYY)"
	document.frmSearch.txtStartDate.Value=""
Elseif Not EndDate="" And IsDate(EndDate)=False Then
	MsgBox "Please enter a correct date! (MM/DD/YYYY)"
	document.frmSearch.txtEndDate.Value=""
ElseIf Not NoPiece="" And IsNumeric(NoPiece)=False Then
	MsgBox "Please enter a numeric value!"
	document.frmSearch.txtNoPiece.Value=""
Else
	document.frmSearch.action="ai_Search.asp?SearchType=" & sType
	document.frmSearch.method="POST"
	document.frmSearch.target = "_self"	
	frmSearch.submit()
End If
End Sub

Sub EditClick(iType,MAWB,Sec,AgentOrgAcct,HAWB)
    sIndex=document.frmSearch.lstSearchType.selectedindex
    sType=document.frmSearch.lstSearchType.item(sIndex).Value

jPopUpNormal()
	
    if sIndex=1 then      
		document.frmSearch.action= "air_import2.asp?iType=A&Edit=yes&MAWB=" & MAWB & "&Sec=" & Sec & "&AgentOrgAcct=" & AgentOrgAcct  & "&WindowName=popUpWindow"
    else       
		document.frmSearch.action= "arrival_notice.asp?iType=A" &  "&Edit=yes&AgentOrgAcct=" & AgentOrgAcct & "&MAWB=" & MAWB & "&HAWB=" & HAWB & "&Sec=" & Sec & "&ItemNo=" & ItemNo  & "&WindowName=popUpWindow"
    end if
document.frmSearch.target="popUpWindow"
document.frmSearch.method="POST"
frmSearch.submit()
	
End Sub

--->
</SCRIPT>
<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
