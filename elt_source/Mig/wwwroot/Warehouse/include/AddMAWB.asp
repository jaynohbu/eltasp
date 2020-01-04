<!--  #INCLUDE FILE="transaction.txt" -->
<!--  #INCLUDE FILE="connection.asp" -->
<!--  #INCLUDE FILE="header.asp" -->
<!--  #INCLUDE FILE="GOOFY_util_fun.inc" -->

<html>
<head>
<%  
Response.Expires = 0  
Response.AddHeader "Pragma","no-cache"  
Response.AddHeader "Cache-Control","no-cache,must-revalidate"  
%>	
<title>MAWB No. Quick Add</title>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<link href="../css/elt_css.css" rel="stylesheet" type="text/css">
<script language='javascript'>
window.name = 'AddClient';

function closeReturn(s) 
{
	window.returnValue = s;
	window.close();
}
</script>
</head>

<%
DIM rs,SQL,dome_type
Dim vPrefix,vMiddleName,vLastName,vCarrier,vSCAC
Dim Action
Dim PostBack	
Dim CarrierName(),CarrierCode(),SCAC(),aIndex,CarrierInfo,vMAWB,pos,returnVal
	
	    dome_type = checkBlank(Request.QueryString("dome").Item,"")
		PostBack = Request.QueryString("PostBack")
        if PostBack = "" then PostBack = true
		
		if Not ( PostBack ) then
			vCarrier = Request.QueryString("p")
	
			vMAWB = Request.QueryString("s")
			if ( NOT vMAWB  = "" ) and ( vCarrier = "" ) then
				pos=0
				pos=instr(vMAWB,"-")
				if pos>0 then
					vPrefix=Left(vMAWB,pos-1)
					vMiddleName = MID(vMAWB,pos+1,4)
				end if

			else
				vMAWB = ""
			end if
		else
			vCarrier =  Request("txtPrefix")
		end if
		
		Action = Request.QueryString("Action")
		
		Set rs = Server.CreateObject("ADODB.Recordset")
					
		select case Action
			case "save" 
				 call read_screen	
				 call save_mawb 
				 response.write "<script language='javascript'>closeReturn('" & returnVal & "');</script>"
		end select
	    
		call get_carrier 
		Set rs=Nothing

		DIM isExist
		if Not PostBack then
			isExist = false
			if Not (vPrefix = "" ) then isExist = true
		end if
%>

<%
sub get_carrier
DIM iCnt
SQL= "select count(*) as iCnt from organization where elt_account_number = " & elt_account_number & " and is_carrier='Y' and carrier_code <> ''"

Set rs = eltConn.execute (SQL)
iCnt = 0
if NOT rs.eof and NOT rs.bof then
	iCnt = rs("iCnt")
end if	
rs.Close

iCnt = iCnt + 1
ReDim CarrierName(iCnt),CarrierCode(iCnt),SCAC(iCnt)

SQL= "select dba_name,carrier_code,carrier_id from organization where elt_account_number = " & elt_account_number & " and is_carrier='Y' and carrier_code <> '' order by dba_name"

rs.Open SQL, eltConn, , , adCmdText
aIndex=1
CarrierName(0)=" "
CarrierCode(0)=0
Do While Not rs.EOF
	CarrierName(aIndex)=rs("dba_name")
	CarrierCode(aIndex)=rs("carrier_code")
	SCAC(aIndex)=rs("carrier_id")
	if not vPrefix = "" then
		if vPrefix = CarrierCode(aIndex) then
			vCarrier = CarrierName(aIndex)
		end if
	end if
	aIndex=aIndex+1
	rs.MoveNext
Loop
rs.Close

end sub
%>

<%
sub read_screen
	 vSCAC = Request("txtSCAC")	
	 vPrefix = Request("txtPrefix")	
	 vMiddleName = Request("txtMiddleName")	
	 vLastName = Request("txtLastName")	
	 vCarrier = Request("txtCarrier")	
end sub
%>

<%
sub save_mawb

DIM newMAWB

	 newMAWB = vPrefix & "-" & vMiddleName & " " & vLastName

	 SQL = "select * from mawb_number where elt_account_number = " & elt_account_number & " and mawb_no = '" & newMAWB & "'"	

	 rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText	

	 If rs.EOF Then
			rs.AddNew
			rs("elt_account_number") = elt_account_number
			rs("mawb_no") = newMAWB
			rs("Carrier_Code")=vPrefix
			rs("Carrier_Desc")=vCarrier
			rs("scac")=vSCAC
			rs("status")="A"
			rs("used")="N"
			rs("created_date")=date

			rs("master_type")=dome_type
			If dome_type = "DA" Or dome_type = "DG" Then
			    rs("is_dome")="Y"
			Else
			    rs("is_dome")="N"
			End If
			rs.Update
	 else
		 	%>
				<script language="javascript">alert('MAWB No.: <%= newMAWB %> already exists!');</script> 				
			<%
	 end if
			rs.Close
				newMAWB = Replace(newMAWB,"-","^")
	 			returnVal = newMAWB & "-" & vCarrier

end sub
%>

<body link="336699" vlink="336699" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="javascript:fixProgressBar();">
<table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
  <tr>
      <td height="32" align="left" valign="middle" class="pageheader"></td>
  </tr>
</table>
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0"bgcolor="#73beb6">
  <tr> 
    <td> 
     <form name=form1 method="post" action="AddClient.asp">
	 <input type="hidden" name="txtCarrier" id="txtCarrier" value="<%=vCarrier%>">
       <table width="100%" border="0" cellpadding="3" cellspacing="0" bordercolor="#73beb6" class="border1px">
          <tr bgcolor="D5E8CB"> 
            <td height="8" colspan="6" align="center" valign="top" bgcolor="#ccebed" class="bodyheader">&nbsp;</td>
          </tr>
		            <tr align="left" valign="middle" bgcolor="#73beb6"> 
            <td colspan="2" height="1" class="bodyheader"></td>
          </tr>
                    
                    <tr align="left" valign="middle" bgcolor="f3f3f3">
                      <td height="22" align="right" bgcolor="f3f3f3" class="bodyheader"><STRONG>Airline Carrier</STRONG></td>
                      <td align="left"><select name="lstCarrier" size="1" class="bodycopy" style="WIDTH: 200px" tabindex=3 onChange="vbscript:lstCarrierChange()">
                          <% for i=0 to aIndex-1 %>
           <option value="<%= CarrierCode(i) & "-" & SCAC(i) %>" <% if CarrierName(i) = vCarrier then response.write("selected") %> ><%= CarrierName(i) %></option>

<%

if CarrierName(i) = vCarrier then
	CarrierInfo = CarrierCode(i) & "-" & SCAC(i)
  	pos=0
	pos=instr(CarrierInfo,"-")
	if pos>0 then
		vPrefix=Left(CarrierInfo,pos-1)
		vSCAC=Mid(CarrierInfo,pos+1,200)
	end if
end if
%>		   				
                          <% next %>
                        </select></td>
                    </tr>

	 <input type="hidden" name="txtSCAC" id="txtSCAC" value="<%=vSCAC%>">
					
                    <tr align="left" valign="middle" bgcolor="f3f3f3">
                      <td width="28%" height="22" align="right" bgcolor="f3f3f3" class="bodyheader">MAWB No.</td>
                      <td width="72%" align="left"><table border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                            <tr>
                                <td>
                             <input name="txtPrefix" type="text" id="txtPrefix" style="width:30px;" value="<%= vPrefix%>" maxlength="3" 
							 <% if isExist then 
							 	response.write ( "class='d_shorttextfield'" ) 
								response.write ( " readonly='true'" )
								else 
								response.write ( "class='shorttextfield'" ) 
								end if 
								%>/>-</td>
                                <td>
                 <input name="txtMiddleName" type="text" id="txtMiddleName" class="m_shorttextfield" style="width:35px;BEHAVIOR: url(igNumChkLeftForBook.htc)" value="<%= vMiddleName%>" maxlength="4"/>-</td>
                                <td>
                 <input name="txtLastName" type="text" id="txtLastName" class="m_shorttextfield" style="width:35px;BEHAVIOR: url(igNumChkLeftForBook.htc)" value="<%= vLastName%>" maxlength="4"/></td>
                            </tr>
                        </table></td>
                    </tr>
                    
                    
		  <tr align="center" bgcolor="D5E8CB"> 
            <td height="20" colspan="6" valign="middle" bgcolor="#ccebed" class="bodycopy">
            <input type="button" class="bodycopy" id=Button2 style="WIDTH: 100px; BACKGROUND-COLOR: #f4f2e8" value='Create MAWB No.' name="AddTo" onClick="javascript:addToMAWB();">
            <input type="button" class="bodycopy" id=Button3 style="WIDTH: 100px; BACKGROUND-COLOR: #f4f2e8" onClick="javascript:window.close();" value="Close" name="CloseMe"></td>
          </tr>
        </table>
      </form></td>
  </tr>
</table>
</body>

<script language='vbscript'>
sub lstCarrierChange()
DIM CarrierInfo,sindex,pos

	sindex = document.all.lstCarrier.selectedIndex
	CarrierInfo = document.all.lstCarrier.item(sindex).value

  	pos=0
	pos=instr(CarrierInfo,"-")
	if pos>0 then
		document.all.txtPrefix.value=Left(CarrierInfo,pos-1)
		document.all.txtSCAC.value=Mid(CarrierInfo,pos+1,200)
		document.all.txtCarrier.value=document.all.lstCarrier.item(sindex).innerText
	end if

end sub
</script>
<script language="javascript">
function trim(sourceString) { return sourceString.replace(/(?:^\s+|\s+$)/ig, ""); }

function addToMAWB() {
	
	if (document.all.lstCarrier.selectedIndex == 0 ) { alert('Please select a Carrier!'); 	document.all.lstCarrier.focus();  return; }
	
	var strPrefix = document.all.txtPrefix.value;	
	if(trim(strPrefix) == "" )
	{
		alert('Please enter a Prefix!');
		document.all.txtPrefix.focus();
		return;
	}
	
	var strMiddleName = document.all.txtMiddleName.value;	
	if(trim(strMiddleName) == "" ) 	{ alert('Please enter a Middle No.!'); 	document.all.txtMiddleName.focus();  return; }
	if(strMiddleName.length < 4 ) 	{ alert('Please enter a Middle No. with 4 digit!'); 	document.all.txtMiddleName.focus();  return; }

	var strLastName = document.all.txtLastName.value;	
	if(trim(strLastName) == "" )  { alert('Please enter a Last No.!'); 	document.all.txtLastName.focus(); 	return; }
	if(strLastName.length < 4 ) 	{ alert('Please enter a Last No. with 4 digit!'); 	document.all.txtLastName.focus();  return; }

	
	var OneNum = Right(strLastName,1)

	if( OneNum > 6 )  { alert("You must enter the last digit with range of 0~6 "); 	document.all.txtLastName.focus(); 	return; }
	
	document.form1.action="AddMAWB.asp?Action=save&dome=<%=dome_type %>&"+"&WindowName="+window.name;
	document.form1.method="POST";
	document.form1.target = window.name;
	document.form1.submit();
}

function Right(str, n){ 
  if (n <= 0) 
     return ""; 
  else if (n > String(str).length) 
     return str; 
  else { 
     var iLen = String(str).length; 
     return String(str).substring(iLen, iLen - n); 
  } 
} 


</script>
</html>
