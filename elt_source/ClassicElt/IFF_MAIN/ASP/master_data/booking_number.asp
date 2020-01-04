<!--  #INCLUDE FILE="../include/transaction.txt" -->
<% 
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Booking</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="../css/elt_css.css" rel="stylesheet" type="text/css" />
<!--  #INCLUDE FILE="../include/connection.asp" -->
<style type="text/css">
<!--
.style1 {color: #c16b42}
.style2 {color: #cc6600}
.style4 {color: #cc6600; font-weight: bold; }
.style7 {color: #663366}
-->
</style>
</head>
<!--  #INCLUDE FILE="../include/header.asp" -->
<%
Dim vMAWB, vCarrier,vCarrierDesc
Dim Go

Dim rs, SQL
Save=Request.QueryString("Save")
Go=Request.QueryString("Go")
Close=Request.QueryString("Close")

Set rs = Server.CreateObject("ADODB.Recordset")
if Go="yes" then
	vStartNo=Request("txtStart")
	vEndNo=Request("txtEnd")
	vCarrierDesc=Request("txtCarrierDesc")
	CarrierInfo=Request("lstCarrier")
	pos=0
	pos=instr(CarrierInfo,"-")
	if pos>0 then
		vCarrier=Left(CarrierInfo,pos-1)
		vSCAC=Mid(CarrierInfo,pos+1,200)
	end if

	check=CLng(Mid(vStartNo,8,1))
	StartNo=CLng(Mid(vStartNo,1,7))
	EndNo=CLng(Mid(vEndNo,1,7))

	for i=StartNo To EndNo
		vMAWBTemp=vCarrier & "-" & mid(i,1,4) & " " & mid(i,5,3) & check
		SQL= "select * from mawb_number where elt_account_number = " & elt_account_number & " and mawb_no='" & vMAWBTemp & "'"
		rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
		if rs.EOF then
			rs.AddNew
			rs("elt_account_number") = elt_account_number
			rs("mawb_no") = vCarrier & "-" & mid(i,1,4) & " " & mid(i,5,3) & check
			rs("Carrier_Code")=vCarrier
			rs("Carrier_Desc")=vCarrierDesc
			rs("scac")=vSCAC
			rs("created_date")=date
		end if
		rs("status")="A"
		rs("used")="N"
		rs("is_dome") = ""
        rs("master_type") = ""
		rs.Update
		rs.Close
		check=check+1
		if check=7 then check=0
	next	
	
end if

'get airline info
Dim CarrierName(1024),CarrierCode(1024),SCAC(1024)
SQL= "select dba_name,carrier_code,carrier_id from organization where elt_account_number = " & elt_account_number & " and is_carrier='Y' and carrier_code <> '' order by dba_name"
rs.Open SQL, eltConn, , , adCmdText
aIndex=1
CarrierName(0)="Select One"
CarrierCode(0)=0
Do While Not rs.EOF
	CarrierName(aIndex)=rs("dba_name")
	CarrierCode(aIndex)=rs("carrier_code")
	SCAC(aIndex)=rs("carrier_id")
	aIndex=aIndex+1
	rs.MoveNext
Loop
rs.Close

Set rs=Nothing
%>

<body link="336699" vlink="336699" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<!-- tooltip placeholder -->
<div id="tooltipcontent"></div>
<!-- placeholder ends -->
	<form name="frmMAWBNO" method="post" action="">
	  <input type="hidden" name="txtCarrierDesc">
	  <table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
  <tr>
    <td height="32" align="left" valign="middle" class="pageheader">Master AWB No.</td>
  </tr>
</table>
<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="73beb6" bgcolor="#73beb6" class="border1px">
  <tr bgcolor="ccebed">
    <td width="2" height="8" align="left" valign="top" bgcolor="ccebed"></td>
  </tr>
  <tr bgcolor="73beb6">
    <td height="1" align="left" valign="top"></td>
  </tr>
  <tr align="left" bgcolor="ecf7f8">
    <td height="22" align="center" valign="middle" bgcolor="#f3f3f3"><br>
        <br>
      <table width="65%" border="0" cellpadding="2" cellspacing="0" bordercolor="73beb6" bgcolor="#FFFFFF" class="border1px">      
        <tr bgcolor="ecf7f8">
        <td width="1"></td>
        <td height="20" colspan="2" align="left" valign="middle" bgcolor="ecf7f8" class="bodyheader">
		    <div style="vertical-align:middle">
			<span class="style2">Create Master AWB No.</span>
		    <% if mode_begin then %>
				<div style="width:21px; display:inline; vertical-align:text-bottom" onMouseover="showtip('When you get assigned a block of Master AWB numbers from the airline, enter the starting and ending numbers here. The system will create the numbers in between for your use.')";
onMouseout="hidetip()"><img src="../Images/button_info.gif" align="absbottom"></div>
			<% end if %>
			</div>
</td>
        <td width="376">&nbsp;</td>
        <td width="85">&nbsp;</td>
      </tr>
	    <tr bgcolor="73beb6">
    <td colspan="5" height="1" align="left" valign="top"></td>
  </tr>
        <tr>
            <td bgcolor="#f3f3f3"></td>
            <td width="141" height="18" bgcolor="#f3f3f3"><font color="#000000" class="bodyheader">Starting No.</font></td>
            <td width="163" align="left" bgcolor="#f3f3f3"><font color="#000000" class="bodyheader">Ending No.</font></td>
            <td align="left" bgcolor="#f3f3f3" class="bodyheader">Carrier</td>
            <td bgcolor="#f3f3f3">&nbsp;</td>
        </tr>
        <tr>
        <td></td>
        <td><font color="#000000">
          <input name="txtStart" type="text" class="shorttextfield" size="16" style="BEHAVIOR: url(../include/igNumChkLeftForBook.htc)" maxlength="8" onBlur="chkBookNumStart(this.value)">
        </font></td>
        <td align="left"><font color="#000000">
          <input name="txtEnd" type="text" class="shorttextfield" size="16" style="BEHAVIOR: url(../include/igNumChkLeftForBook.htc)" maxlength="8" onBlur="chkBookNumEnd(this.value)">
        </font></td>
        <td align="left"><select name="lstCarrier" size="1" class="smallselect" style="WIDTH: 280px">
            <% for i=0 to aIndex-1 %>
            <option value="<%= CarrierCode(i) & "-" & SCAC(i) %>"><%= CarrierName(i) %></option>
            <% next %>
            </select></td>
        <td><a href="javascript:;" onClick="GoClick()" style="cursor:pointer"><img src="../images/button_go.gif" alt="Create" width="31" height="18" ></a></td>
      </tr>
    </table>
      <br>
      <br>
      <table width="65%" border="0" cellpadding="2" cellspacing="0" bordercolor="73beb6" bgcolor="#FFFFFF" class="border1px">
          <tr bgcolor="ecf7f8" >
              <td>&nbsp;</td>
              <td height="20" colspan="4" align="left" valign="middle" bgcolor="ecf7f8">			  
				<div style="vertical-align:middle"><span class="style4">Manage Master AWB No. </span>
                 <% if mode_begin then %>
                 <div style="width:21px; display:inline; vertical-align:text-bottom" onMouseover="showtip('Select Master AWB numbers using the criteria here to close them. Closing will not erase them from the system, but will remove them from most menus, keeping old bills from clogging up the system. You may always un-close them at a later time.')";
onMouseout="hidetip()"><img src="../Images/button_info.gif" align="absbottom">				</div>
                <% end if %>
              	</div></td>
              <td width="85">&nbsp;</td>
          </tr>
		  	    <tr bgcolor="73beb6">
    <td colspan="6" height="1" align="left" valign="top"></td>
  </tr>
          <tr bgcolor="ecf7f8" >
              <td bgcolor="#f3f3f3">&nbsp;</td>
              <td height="20" colspan="4" align="left" valign="middle" bgcolor="#f3f3f3"><strong><span class="bodyheader">Carrier</span></strong></td>
              <td width="85" bgcolor="#f3f3f3">&nbsp;</td>
          </tr>
          <tr bgcolor="ecf7f8" >
              <td bgcolor="#FFFFFF">&nbsp;</td>
              <td height="20" colspan="4" align="left" valign="middle" bgcolor="#FFFFFF"><strong>
                  <select name="lstCarrierM" size="1" class="smallselect" style="WIDTH: 280px">
                      <% for i=0 to aIndex-1 %>
                      <option value="<%= CarrierCode(i) & "-" & SCAC(i) %>"><%= CarrierName(i) %></option>
                      <% next %>
                  </select>
              </strong></td>
              <td width="85" bgcolor="#FFFFFF">&nbsp;</td>
          </tr>
          <tr bgcolor="ecf7f8" >
              <td bgcolor="#f3f3f3">&nbsp;</td>
              <td height="20" colspan="2" align="left" valign="middle" bgcolor="#f3f3f3"><strong>ETD</strong></td>
              <td bgcolor="#f3f3f3"><strong>Master AWB No.</strong></td>
              <td colspan="2" bgcolor="#f3f3f3">&nbsp;</td>
          </tr>
          <tr>
              <td width="1" bgcolor="#FFFFFF">&nbsp;</td>
              <td width="170" align="left" valign="top" bgcolor="#FFFFFF">From<br>
                      <input name="txtStartMDate" type="text" class="m_shorttextfield" preset="shortdate" size="16" maxlength="10" ></td>
              <td width="200" align="left" valign="top" bgcolor="#FFFFFF">To<br>
                  <input name="txtEndMDate" type="text" class="m_shorttextfield" preset="shortdate" size="16" maxlength="10" ></td>
              <td width="153" bgcolor="#FFFFFF"><font color="#000000">From<br>
                      <input name="txtStartM" type="text" class="shorttextfield" size="16" style="BEHAVIOR: url(../include/igNumChkLeftForBook.htc)" maxlength="8">
              </font></td>
              <td width="153" bgcolor="#FFFFFF"><font color="#000000">To<br>
                      <input name="txtEndM" type="text" class="shorttextfield" size="16" style="BEHAVIOR: url(../include/igNumChkLeftForBook.htc)" maxlength="8">
              </font></td>
              <td width="85" bgcolor="#FFFFFF">&nbsp;</td>
          </tr>
          
          <tr bgcolor="ecf7f8" >
              <td bgcolor="#f3f3f3">&nbsp;</td>
              <td height="20" colspan="4" bgcolor="#f3f3f3"><strong>Other Options</strong></td>
              <td width="85" bgcolor="#f3f3f3">&nbsp;</td>
          </tr>
          <tr bgcolor="ecf7f8" >
              <td bgcolor="#FFFFFF">&nbsp;</td>
              <td height="20" colspan="4" bgcolor="#FFFFFF">
                  <select name="lstNumberType" size="1" class="smallselect" style="WIDTH: 170px">
                              <option value="" >All</option>
                              <option value="A" >NOT-USED-Number Only</option>
                              <option value="B" >USED-Number Only</option>
                              <option value="C" >Closed Number Only</option>
                          </select>              </td>
              <td width="85" bgcolor="#FFFFFF"><a href="javascript:;" onClick="GoClickM()" style="cursor:pointer"><img src="../images/button_go.gif" alt="Manage" width="31" height="18" ></a></td>
          </tr>
      </table>
      <br>
      <br>
      </td>
  </tr>
  <tr bgcolor="73beb6">
    <td height="1" align="left" valign="top"></td>
  </tr>
  <tr align="center" bgcolor="ccebed">
    <td height="20" valign="middle" bgcolor="ccebed" class="bodycopy">&nbsp;</td>
  </tr>
</table>
<br>
	</form>					
</body>
<script language="javascript">
function GoMAWBNUM(StartNo,EndNo,C_DATE_FROM,C_DATE_TO,strStatus) {

var sURL = "../../aspx/OnLines/MAWB/MAWBNumber.aspx?StartNo="+StartNo+"&EndNo="+EndNo+"&D_FROM="+C_DATE_FROM+"&D_TO="+C_DATE_TO+"&Status="+strStatus+"&WindowName=PopWin";
viewPop(sURL);
}
</script>

<script language="vbscript">
<!---

Sub GoClickM()
Dim StartNo,EndNo,vCarrierDesc,sIndex
sindex=Document.frmMAWBNO.lstCarrierM.Selectedindex

if sindex > 0 then
	vCarrierDesc=document.frmMAWBNO.lstCarrierM.item(sindex).Text
	vCarrierInfo=document.frmMAWBNO.lstCarrierM.item(sindex).Value
	pos=0
	pos=instr(vCarrierInfo,"-")
	if pos>0 then
		vCarrier=Left(vCarrierInfo,pos-1)
		vSCAC=Mid(vCarrierInfo,pos+1,200)
	end if
	
	if vCarrier = "" then
		msgbox "This Carrier does not have a Prefix." & chr(13) & "Please update the client profile."
		exit sub
	end if

else
	msgbox "Please select a carrier"
	exit sub
end if

StartNo=document.frmMAWBNO.txtStartM.Value
EndNo=document.frmMAWBNO.txtEndM.Value

StartMDate=document.frmMAWBNO.txtStartMDate.Value
EndMDate=document.frmMAWBNO.txtEndMDate.Value

if trim(StartNo) = "" and trim(EndNo) = "" and trim(StartMDate) = "" and trim(EndMDate) = "" then
	msgbox "Please enter the ETD or MAWB No."
	exit sub
end if

if trim(StartNo) = "" and trim(StartMDate) = "" then
	msgbox "Please enter the start of ETD or MAWB No."
	exit sub
end if

if trim(EndNo) = "" and trim(EndMDate) = "" then
	msgbox "Please enter the end of ETD or MAWB No."
	exit sub
end if

DIM mStart,mEnd

if 	NOT trim(StartNo) = "" then
	StartNo=CLng(Mid(StartNo,1,7))
else
	StartNo="0000000"
end if

if 	NOT trim(EndNo) = "" then
	EndNo=CLng(Mid(EndNo,1,7))
else
	EndNo="9999999"
end if

mStart = vCarrier & "-" & mid(StartNo,1,4) & " " & mid(StartNo,5,3) & "0"
mEnd = vCarrier & "-" & mid(EndNo,1,4) & " " & mid(EndNo,5,3) & "9"

DIM C_DATE_FROM,C_DATE_TO
C_DATE_FROM=document.frmMAWBNO.txtStartMDate.Value
C_DATE_TO=document.frmMAWBNO.txtEndMDate.Value

if NOT C_DATE_FROM = "" or NOT C_DATE_TO = "" then

	if ( cDate(C_DATE_FROM) > cDate(C_DATE_TO) ) then
		msgbox "Start date must be less then end date"
		exit sub
	end if
	
end if

DIM tindex, strStatus
tindex=Document.frmMAWBNO.lstNumberType.Selectedindex
if  tindex > 0  then 
	strStatus = document.frmMAWBNO.lstNumberType.item(tindex).Value
else
	strStatus = ""
end if

call GoMAWBNUM(mStart,mEnd,C_DATE_FROM,C_DATE_TO,strStatus)

End sub


Sub bsaveclick()
sindex=Document.frmMAWBNO.lstMAWB.Selectedindex
MAWB=document.frmMAWBNO.lstMAWB.item(sindex).Text
pos=0
pos=Instr(MAWB,"###")
if pos>0 then MAWB=Mid(MAWB,1,pos-1)
if sindex>0 then
	DeptDate1=document.frmMAWBNO.txtDeptDate1.Value
	ArrivalDate1=document.frmMAWBNO.txtArrivalDate1.Value
	DeptDate2=document.frmMAWBNO.txtDeptDate2.Value
	ArrivalDate2=document.frmMAWBNO.txtArrivalDate2.Value
	Weight=document.frmMAWBNO.txtWeightReserved.value
	To0=document.frmMAWBNO.txtTo.Value
	To1=document.frmMAWBNO.txtTo1.Value
	To2=document.frmMAWBNO.txtTo2.Value
	Flight2=document.frmMAWBNO.txtFlight2.Value
	if Not Flight2="" then
		if DeptDate2="" or ArrivalDate2="" then
			MsgBox "Please enter Departure Date2 Or Arrival Date2!"
			exit Sub
		end if
	end if
	if Len(To0)>3 or Len(To1)>3 or Len(To2)>3 then
		MsgBox "The To Port has three characters!"
//'	elseif Not IsNumeric(Weight) then
//'		MsgBox "Please enter a numeric value for Reserved Weight!"
	elseif IsDate(DeptDate1)=False then
		MsgBox "Please enter Departure Date in MM/DD/YYYY format!"
	elseif IsDate(ArrivalDate1)=False then
		MsgBox "Please enter Arrival Date in MM/DD/YYYY format!"
	elseif Not DeptDate2="" And IsDate(DeptDate2)=False then
		MsgBox "Please enter Departure Date in MM/DD/YYYY format!"
	elseif Not ArrivalDate2="" and IsDate(ArrivalDate2)=False then
		MsgBox "Please enter Arrival Date in MM/DD/YYYY format!"
	else
		document.frmMAWBNO.action="booking.asp?save=yes&MAWB=" & MAWB & "&WindowName=" & window.name
		document.frmMAWBNO.target="_self"
		document.frmMAWBNO.method="POST"
		frmMAWBNO.submit()
	end if
end if
End Sub

function CheckNumberRange(StartNo,EndNo)
DIM iStart,iEnd,iDiff

iStart = Clng(MID(StartNo,1,7))	
iEnd = Clng(MID(EndNo,1,7))

iDiff = iEnd - iStart

if iDiff < 0  then
	msgbox "End No. must be greater than or equal to Start No."
	CheckNumberRange = false
	exit function	
end if

if iDiff > 100 then

	msgbox "The number range exceeds 100 limit." & chr(13) & "The number range must be less than 100 or equal."
	CheckNumberRange = false
	exit function	
end if
CheckNumberRange = true
end function

Sub GoClick()
Dim StartNo,EndNo,vCarrierDesc,sIndex
sindex=Document.frmMAWBNO.lstCarrier.Selectedindex

vCarrierDesc=document.frmMAWBNO.lstCarrier.item(sindex).Text
vCarrierInfo=document.frmMAWBNO.lstCarrier.item(sindex).Value

pos=0
pos=instr(vCarrierInfo,"-")
if pos>0 then
	vCarrier=Left(vCarrierInfo,pos-1)
	vSCAC=Mid(vCarrierInfo,pos+1,200)
end if

if vCarrier = "" then
	msgbox "This Carrier does not have a Prefix." & chr(13) & "Please update the client profile."
	exit sub
end if

document.frmMAWBNO.txtCarrierDesc.Value=vCarrierDesc
StartNo=document.frmMAWBNO.txtStart.Value

if StartNo = "" then
	msgbox "Please Enter a Start No."
	exit sub
end if

EndNo=document.frmMAWBNO.txtEnd.Value

if EndNo = "" then
	msgbox "Please Enter a End No."
	exit sub

end if

if CheckNumberRange(StartNo,EndNo) = false then
	exit sub
end if

if Not IsNumeric(StartNo) or not len(StartNo)=8 then
	MsgBox "Please enter a 8 digits numerical value for Start No!"
elseif Not IsNumeric(EndNo) or not len(EndNo)>6 then
	MsgBox "Please enter a 7 digits numerical value for End No!"
elseif Not CLng(Mid(EndNo,1,7))>=CLng(Mid(StartNo,1,7)) then
	MsgBox "End No must be great than or equal to Start No!"
elseif sindex<1 then
	MsgBox "Please select an AIRLINE!"
else
	iStart = CLng(MID(StartNo,1,7))	
	iEnd = CLng(MID(EndNo,1,7))
	iDiff = iEnd - iStart
	
	ParamH = iDiff * 20 + 120
	if ParamH > 400 then
	ParamH = 400
end if

jPopUp(ParamH)
document.frmMAWBNO.action="booking_number_ok.asp?go=yes" & "&WindowName=" & window.name
document.frmMAWBNO.method="post"
document.frmMAWBNO.target="popUpWindow"
frmMAWBNO.submit()
	
end if


End Sub

Sub chkBookNumStart(num)
DIM tmpNum,OneNum
tmpNum = Trim(num) 

if Len(tmpNum) > 7 then
	 OneNum = Right(num,1) 
	 if OneNum > 6 then
	 	msgbox "You must enter the last digit with range of 0~6 "
		document.frmMAWBNO.txtStart.focus
		exit sub	
//		document.frmMAWBNO.txtStart.value = MID(tmpNum,1,7) & "0"
	 end if
end if

End Sub

Sub chkBookNumEnd(num)
DIM tmpNum,OneNum
tmpNum = Trim(num) 

if Len(tmpNum) > 7 then
	 OneNum = Right(num,1) 
	 if OneNum > 6 then
	 	msgbox "You must enter the last digit with range of 0~6 "
		document.frmMAWBNO.txtEnd.focus
		exit sub	
//		document.frmMAWBNO.txtEnd.value = MID(tmpNum,1,7) & "0"
	 end if
end if

End Sub

--->
</SCRIPT>
</SCRIPT>
<script language="JavaScript" type="text/javascript" src="../include/tooltips.js"></script>
<!-- //Tooltip ends here// -->
<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
