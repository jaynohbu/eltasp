<!--  #INCLUDE FILE="../include/transaction.txt" -->
<%
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
    
    SC=Request.QueryString("S")
%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>DIMCAL</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="../css/elt_css.css" rel="stylesheet" type="text/css" />

<script type="text/vbscript">
<!--
Sub bAddDemClick()
Dim D1,D2,D3,D4,DD
D1=document.form1.txtQty.Value
D2=document.form1.txtLength.Value
D3=document.form1.txtWidth.Value
D4=document.form1.txtHeight.Value
If IsNumeric(D1)=false Or IsNumeric(D2)=false Or IsNumeric(D3)=false Or IsNumeric(D4)=false then
	msgbox "Please enter numerical values only!"
Else
	DD=D1 & "@" & D2 & "X" & D3 & "X" & D4 & Chr(10)
	document.form1.txtDemDetail.Value=document.form1.txtDemDetail.Value & DD
	document.form1.txtQty.Value=""
	document.form1.txtLength.Value=""
	document.form1.txtWidth.Value=""
	document.form1.txtHeight.Value=""
End If
End Sub
Sub DoneClick(Scale)
Dim Dem,pos,pos1,DD,D1,D2,D3,D4,TotalDem,TemDem,NoPiece,nPiece,Factor
document.form1.txtDemDetail.Value = UCASE(document.form1.txtDemDetail.Value)
Dem=document.form1.txtDemDetail.Value & Chr(10)
if Dem="" then 
	Dem="0@0X0X0"
else
	HiddenDEM=Dem
end if
pos=InStr(Dem,Chr(10))
TotalDem=0
TotalPieces=0
do While(pos>0)
	if len(Dem)>0 then
		DD=Left(Dem,pos-1)
	end if
	pos1=InStr(DD,"@")
	if pos1>0 then
		D1=Left(DD,pos1-1)
		TotalPieces=TotalPieces+D1
		DD=Mid(DD,pos1+1,1000)
	else
		D1=0
	end if
	pos1=Instr(DD,"X")
	if pos1>0 then
		D2=Left(DD,pos1-1)
		DD=Mid(DD,pos1+1,100)
	else
		D2=0
	end if
	pos1=Instr(DD,"X")
	if pos1>0 then
		D3=Left(DD,pos1-1)
		D4=Mid(DD,pos1+1,100)
	else
		D3=0
	end if
	if IsNumeric(D4)=false then D4=0
	TemDem=D1*D2*D3*D4
	TotalDem=TotalDem + TemDem
	dem=Mid(dem,pos+1,2000)
	pos=InStr(Dem,Chr(10))
loop

if Scale="CBM" then
	TotalDemCBM=TotalDem/1000000
	TotalDemCFT=TotalDemCBM*35.314666721
	self.opener.document.getElementById("txtDimension").value = Round(TotalDemCBM,2)
else
	TotalDemCFT=TotalDem/1728
	TotalDemCBM=TotalDemCFT/35.314666721
	self.opener.document.getElementById("txtDimension").value = Round(TotalDemCFT,2)
end if


window.close
end sub
// End -->
</script>
</head>

<body link="336699" vlink="336699" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#FFFFFF"  bgcolor="#FFFFFF">
  <tr> 
    <td>
<form name=form1 method="POST">
        <table width="100%" border="0" cellpadding="2" cellspacing="1">
          <tr> 
            <td height="8" align="left" valign="top" class="bodyheader"></td>
          </tr>
          <tr align="center" valign="middle"> 
            <td bgcolor="#FFFFFF"> 
              <table width="90%" border="0" cellpadding="2" cellspacing="0" bordercolor="BFD0C9" class="border1px">
                <tr align="left" valign="middle"> 
                  <td bgcolor="E0EDE8" class="bodyheader">Qty</td>
                  <td bgcolor="E0EDE8" class="bodyheader">L</td>
                  <td bgcolor="E0EDE8" class="bodyheader">W</td>
                  <td bgcolor="E0EDE8" class="bodyheader">H</td>
                  <td width="45" bgcolor="E0EDE8" class="bodyheader">&nbsp;</td>
                </tr>
                <tr> 
                  <td height="1" colspan="5" bgcolor="BFD0C9"></td>
                </tr>
                <tr align="left" valign="middle" class="bodycopy"> 
                  <td bgcolor="#FFFFFF"><input type="text" name="txtQty" size="8" class="shorttextfield"></td>
                  <td bgcolor="#FFFFFF"><input type="text" name="txtLength" size="8" class="shorttextfield"></td>
                  <td bgcolor="#FFFFFF"><input type="text" name="txtWidth" size="8" class="shorttextfield"></td>
                  <td bgcolor="#FFFFFF"><input type="text" name="txtHeight" size="8" class="shorttextfield"></td>
                  <td bgcolor="#FFFFFF"><img src="../images/button_add.gif" width="37" height="17" name="bAddDem" OnClick="bAddDemClick()"  style="cursor:hand"></td>
                </tr>
                <tr align="center" valign="middle" bgcolor="#F3f3f3" class="bodycopy"> 
                  <td height="20" colspan="5" ><font size="2px" color="#0000CC">
                    <% if SC="CFT" then response.write("<strong>*Please enter value in inches.</strong>") else response.write("<strong>*Please enter value in centimeters.</strong>") %>
                    </font></td>
                </tr>
                <tr align="center" valign="middle" bgcolor="#F3f3f3" class="bodycopy"> 
                  <td colspan="5" ><textarea WRAP=hard rows="6" name="txtDemDetail" cols="20"></textarea>
                  </td>
                </tr>
                <tr align="left" valign="middle" bgcolor="#F3f3f3" class="bodycopy"> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td height="1" colspan="5" bgcolor="#A0829C"></td>
                </tr>
                <tr align="center" valign="middle" bgcolor="E0EDE8" class="bodycopy"> 
                  <td colspan="5" ><img src="../images/button_done.gif" width="49" height="18" name="bDone" OnClick="DoneClick('<%= SC %>')"  style="cursor:hand"></td>
                </tr>
                <tr bgcolor="BFD0C9"> 
                  <td height="24" colspan="5"></td>
                </tr>
              </table>
              
            </td>
          </tr>
          <tr align="left" valign="middle" bgcolor="E5D4E3"> 
            <td height="22" bgcolor="#FFFFFF" class="bodyheader">&nbsp;</td>
          </tr>
        </table>
		</form></td>
        </tr>
</table>
<br />
<script type="text/javascript">
function trim(sourceString) { return sourceString.replace(/(?:^\s+|\s+$)/ig, ""); }
try {
	var text = trim(document.getElementById('txtDemDetail').value);
	if (text == '' ) {
		document.getElementById('txtDemDetail').value = self.opener.document.form1.dimtext.value;
	}
} catch(f) {}
	
</script>
</body>
</html>
