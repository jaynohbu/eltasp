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
     <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
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
    <div id="tooltipcontent">
    </div>
    <!-- placeholder ends -->
    <form name="frmMAWBNO" method="post" action="">
    <input type="hidden" name="txtCarrierDesc">
    <table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
        <tr>
            <td height="32" align="left" valign="middle" class="pageheader">
                Master AWB No.
            </td>
        </tr>
    </table>
    <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="73beb6"
        bgcolor="#73beb6" class="border1px">
        <tr bgcolor="ccebed">
            <td width="2" height="8" align="left" valign="top" bgcolor="ccebed">
            </td>
        </tr>
        <tr bgcolor="73beb6">
            <td height="1" align="left" valign="top">
            </td>
        </tr>
        <tr align="left" bgcolor="ecf7f8">
            <td height="22" align="center" valign="middle" bgcolor="#f3f3f3">
                <br>
                <br>
                <table width="65%" border="0" cellpadding="2" cellspacing="0" bordercolor="73beb6"
                    bgcolor="#FFFFFF" class="border1px">
                    <tr bgcolor="ecf7f8">
                        <td width="1">
                        </td>
                        <td height="20" colspan="2" align="left" valign="middle" bgcolor="ecf7f8" class="bodyheader">
                            <div style="vertical-align: middle">
                                <span class="style2">Create Master AWB No.</span>
                                <% if mode_begin then %>
                                <div style="width: 21px; display: inline; vertical-align: text-bottom" onmouseover="showtip('When you get assigned a block of Master AWB numbers from the airline, enter the starting and ending numbers here. The system will create the numbers in between for your use.');"
                                    onmouseout="hidetip()">
                                    <img src="../Images/button_info.gif" align="absbottom"></div>
                                <% end if %>
                            </div>
                        </td>
                        <td width="376">
                            &nbsp;
                        </td>
                        <td width="85">
                            &nbsp;
                        </td>
                    </tr>
                    <tr bgcolor="73beb6">
                        <td colspan="5" height="1" align="left" valign="top">
                        </td>
                    </tr>
                    <tr>
                        <td bgcolor="#f3f3f3">
                        </td>
                        <td width="141" height="18" bgcolor="#f3f3f3">
                            <font color="#000000" class="bodyheader">Starting No.</font>
                        </td>
                        <td width="163" align="left" bgcolor="#f3f3f3">
                            <font color="#000000" class="bodyheader">Ending No.</font>
                        </td>
                        <td align="left" bgcolor="#f3f3f3" class="bodyheader">
                            Carrier
                        </td>
                        <td bgcolor="#f3f3f3">
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td>
                        </td>
                        <td>
                            <font color="#000000">
                                <input name="txtStart" type="text" class="shorttextfield" size="16" style="behavior: url(../include/igNumChkLeftForBook.htc)"
                                    maxlength="8" onblur="chkBookNumStart(this.value)">
                            </font>
                        </td>
                        <td align="left">
                            <font color="#000000">
                                <input name="txtEnd" type="text" class="shorttextfield" size="16" style="behavior: url(../include/igNumChkLeftForBook.htc)"
                                    maxlength="8" onblur="chkBookNumEnd(this.value)">
                            </font>
                        </td>
                        <td align="left">
                            <select name="lstCarrier" size="1" class="smallselect" style="width: 280px">
                                <% for i=0 to aIndex-1 %>
                                <option value="<%= CarrierCode(i) & "-" & SCAC(i) %>">
                                    <%= CarrierName(i) %></option>
                                <% next %>
                            </select>
                        </td>
                        <td>
                            <a href="javascript:;" onclick="GoClick()" style="cursor: pointer">
                                <img src="../images/button_go.gif" alt="Create" width="31" height="18"></a>
                        </td>
                    </tr>
                </table>
                <br>
                <br>
                <table width="65%" border="0" cellpadding="2" cellspacing="0" bordercolor="73beb6"
                    bgcolor="#FFFFFF" class="border1px">
                    <tr bgcolor="ecf7f8">
                        <td>
                            &nbsp;
                        </td>
                        <td height="20" colspan="4" align="left" valign="middle" bgcolor="ecf7f8">
                            <div style="vertical-align: middle">
                                <span class="style4">Manage Master AWB No. </span>
                                <% if mode_begin then %>
                                <div style="width: 21px; display: inline; vertical-align: text-bottom" onmouseover="showtip('Select Master AWB numbers using the criteria here to close them. Closing will not erase them from the system, but will remove them from most menus, keeping old bills from clogging up the system. You may always un-close them at a later time.');"
                                    onmouseout="hidetip()">
                                    <img src="../Images/button_info.gif" align="absbottom">
                                </div>
                                <% end if %>
                            </div>
                        </td>
                        <td width="85">
                            &nbsp;
                        </td>
                    </tr>
                    <tr bgcolor="73beb6">
                        <td colspan="6" height="1" align="left" valign="top">
                        </td>
                    </tr>
                    <tr bgcolor="ecf7f8">
                        <td bgcolor="#f3f3f3">
                            &nbsp;
                        </td>
                        <td height="20" colspan="4" align="left" valign="middle" bgcolor="#f3f3f3">
                            <strong><span class="bodyheader">Carrier</span></strong>
                        </td>
                        <td width="85" bgcolor="#f3f3f3">
                            &nbsp;
                        </td>
                    </tr>
                    <tr bgcolor="ecf7f8">
                        <td bgcolor="#FFFFFF">
                            &nbsp;
                        </td>
                        <td height="20" colspan="4" align="left" valign="middle" bgcolor="#FFFFFF">
                            <strong>
                                <select name="lstCarrierM" size="1" class="smallselect" style="width: 280px">
                                    <% for i=0 to aIndex-1 %>
                                    <option value="<%= CarrierCode(i) & "-" & SCAC(i) %>">
                                        <%= CarrierName(i) %></option>
                                    <% next %>
                                </select>
                            </strong>
                        </td>
                        <td width="85" bgcolor="#FFFFFF">
                            &nbsp;
                        </td>
                    </tr>
                    <tr bgcolor="ecf7f8">
                        <td bgcolor="#f3f3f3">
                            &nbsp;
                        </td>
                        <td height="20" colspan="2" align="left" valign="middle" bgcolor="#f3f3f3">
                            <strong>ETD</strong>
                        </td>
                        <td bgcolor="#f3f3f3">
                            <strong>Master AWB No.</strong>
                        </td>
                        <td colspan="2" bgcolor="#f3f3f3">
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td width="1" bgcolor="#FFFFFF">
                            &nbsp;
                        </td>
                        <td width="170" align="left" valign="top" bgcolor="#FFFFFF">
                            From<br>
                            <input name="txtStartMDate" id="txtStartMDate"  type="text" class="m_shorttextfield date" preset="shortdate"
                                size="16" maxlength="10">
                        </td>
                        <td width="200" align="left" valign="top" bgcolor="#FFFFFF">
                            To<br>
                            <input name="txtEndMDate" id="txtEndMDate"  type="text" class="m_shorttextfield date" preset="shortdate"
                                size="16" maxlength="10">
                        </td>
                        <td width="153" bgcolor="#FFFFFF">
                            <font color="#000000">From<br>
                                <input name="txtStartM" type="text" class="shorttextfield" size="16" style="behavior: url(../include/igNumChkLeftForBook.htc)"
                                    maxlength="8">
                            </font>
                        </td>
                        <td width="153" bgcolor="#FFFFFF">
                            <font color="#000000">To<br>
                                <input name="txtEndM"  type="text" class="shorttextfield" size="16" style="behavior: url(../include/igNumChkLeftForBook.htc)"
                                    maxlength="8">
                            </font>
                        </td>
                        <td width="85" bgcolor="#FFFFFF">
                            &nbsp;
                        </td>
                    </tr>
                    <tr bgcolor="ecf7f8">
                        <td bgcolor="#f3f3f3">
                            &nbsp;
                        </td>
                        <td height="20" colspan="4" bgcolor="#f3f3f3">
                            <strong>Other Options</strong>
                        </td>
                        <td width="85" bgcolor="#f3f3f3">
                            &nbsp;
                        </td>
                    </tr>
                    <tr bgcolor="ecf7f8">
                        <td bgcolor="#FFFFFF">
                            &nbsp;
                        </td>
                        <td height="20" colspan="4" bgcolor="#FFFFFF">
                            <select name="lstNumberType" size="1" class="smallselect" style="width: 170px">
                                <option value="">All</option>
                                <option value="A">NOT-USED-Number Only</option>
                                <option value="B">USED-Number Only</option>
                                <option value="C">Closed Number Only</option>
                            </select>
                        </td>
                        <td width="85" bgcolor="#FFFFFF">
                            <a href="javascript:;" onclick="GoClickM()" style="cursor: pointer">
                                <img src="../images/button_go.gif" alt="Manage" width="31" height="18"></a>
                        </td>
                    </tr>
                </table>
                <br>
                <br>
            </td>
        </tr>
        <tr bgcolor="73beb6">
            <td height="1" align="left" valign="top">
            </td>
        </tr>
        <tr align="center" bgcolor="ccebed">
            <td height="20" valign="middle" bgcolor="ccebed" class="bodycopy">
                &nbsp;
            </td>
        </tr>
    </table>
    <br>
    </form>
</body>

   
     <link href="/Scripts/jquery-ui-1.10.3/themes/base/jquery-ui.css"
        rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $(document).ready(function () {

           

            $("#txtStartMDate").datepicker();
            if ($("#txtStartMDate").val() == "") {

                var currentDate = new Date();
                var day = currentDate.getDate()
                var month = currentDate.getMonth() + 1
                var year = currentDate.getFullYear()
                var today = month + "/" + day + "/" + year;
                $("#txtStartMDate").val(today)
            }

            $("#txtEndMDate").datepicker();
            if ($("#txtEndMDate").val() == "") {

                var currentDate = new Date();
                var day = currentDate.getDate()
                var month = currentDate.getMonth() + 1
                var year = currentDate.getFullYear()
                var today = month + "/" + day + "/" + year;
                $("#txtEndMDate").val(today)
            }


        });
    </script>
<script type="text/javascript">
    function GoMAWBNUM(StartNo, EndNo, C_DATE_FROM, C_DATE_TO, strStatus) {
        var sURL = "/IFF_MAIN/ASPX/OnLines/MAWB/MAWBNumber.aspx?StartNo=" + StartNo
        + "&EndNo=" + EndNo + "&D_FROM=" + C_DATE_FROM 
        + "&D_TO=" + C_DATE_TO + "&Status=" + strStatus + "&WindowName=PopWin";
        viewPop(sURL);
    }

    function GoClickM(){
        var StartNo,EndNo,vCarrierDesc,vCarrierInfo,vCarrier,vSCAC;
        var sindex=document.frmMAWBNO.lstCarrierM.selectedIndex;

        if( sindex >= 0) {
            vCarrierDesc=document.frmMAWBNO.lstCarrierM.item(sindex).text;
            vCarrierInfo=document.frmMAWBNO.lstCarrierM.item(sindex).value;
            var pos=0;
            pos=vCarrierInfo.indexOf("-");
            if (pos >= 0) {
                vCarrier=vCarrierInfo.substring(0,pos);
                vSCAC=vCarrierInfo.substring(pos+1,200);
            }
	
            if (vCarrier == "" ){
                alert( "This Carrier does not have a Prefix. \r\nPlease update the client profile.");
                return false;
            }
        }
        else{
            alert( "Please select a carrier");
            return false;
        }

        var StartNo=document.frmMAWBNO.txtStartM.value;
        var EndNo=document.frmMAWBNO.txtEndM.value;

        var StartMDate=document.frmMAWBNO.txtStartMDate.value;
        var EndMDate=document.frmMAWBNO.txtEndMDate.value;

        if (StartNo.trim() == "" && EndNo.trim() == "" && StartMDate.trim() == "" && EndMDate.trim() == "" ){
            alert("Please enter the ETD or MAWB No.");
            return false;
        }

        if (StartNo.trim() == "" && StartMDate.trim() == "" ){
            alert("Please enter the start of ETD or MAWB No.");
            return false;
        }

        if (EndNo.trim() == "" &&  EndMDate.trim() == "" ){
            msalert("Please enter the end of ETD or MAWB No.");
            return false;
        }

        if (StartNo.trim() != "") {
            StartNo = parseFloat(StartNo.substring(0, 7));
            StartNo = StartNo.toString();
        }
        else
	        StartNo="0000000";
        

        if (EndNo.trim() != "") {
            EndNo = parseFloat(EndNo.substring(0, 7));
            EndNo = EndNo.toString();
        }
        else
            EndNo = "9999999";
        
        var mStart = vCarrier+ "-"+ StartNo.substring(0,4) + " "+ StartNo.substring(4,3) + "0";
        var mEnd = vCarrier + "-"+ EndNo.substring(0,4) + " " + EndNo.substring(4,3) + "9";

        var C_DATE_FROM=document.frmMAWBNO.txtStartMDate.value;
        var C_DATE_TO=document.frmMAWBNO.txtEndMDate.value;

        if ( C_DATE_FROM != "" || C_DATE_TO != "" ){
	        if ( cDate(C_DATE_FROM) > cDate(C_DATE_TO) ) {
		        alert( "Start date must be less then end date");
		        return false;
	        }
        }

        var strStatus = "";
        var tindex=document.frmMAWBNO.lstNumberType.selectedIndex;
        if  (tindex > 0)  
	        strStatus = document.frmMAWBNO.lstNumberType.item(tindex).value;

        GoMAWBNUM(mStart,mEnd,C_DATE_FROM,C_DATE_TO,strStatus);

    }

   
    function bsaveclick(){
        var sindex=document.frmMAWBNO.lstMAWB.selectedIndex;
        var MAWB=document.frmMAWBNO.lstMAWB.item(sindex).Text
        var pos=-1;
        pos=MAWB.indexOf("###");
        if (pos>=0) 
            MAWB=MAWB.substring(0,pos);

        if (sindex>=0 ){
	        var DeptDate1=document.frmMAWBNO.txtDeptDate1.value;
	        var ArrivalDate1=document.frmMAWBNO.txtArrivalDate1.value;
	        var DeptDate2=document.frmMAWBNO.txtDeptDate2.value;
	        var ArrivalDate2=document.frmMAWBNO.txtArrivalDate2.value;
	        var Weight=document.frmMAWBNO.txtWeightReserved.value;
	        var To0=document.frmMAWBNO.txtTo.value;
	        var To1=document.frmMAWBNO.txtTo1.value;
	        var To2=document.frmMAWBNO.txtTo2.value;
	        var Flight2=document.frmMAWBNO.txtFlight2.value;
	        if ( Flight2!="" ){
		        if (DeptDate2=="" || ArrivalDate2=="" ){
			        alert("Please enter Departure Date2 Or Arrival Date2!");
			        return false;
		        }
	        }
	        if (To0.length>3 || To1.length>3 || To2.length>3 )
		        alert( "The To Port has three characters!");
	        else if (!IsDate(DeptDate1))
		        alert( "Please enter Departure Date in MM/DD/YYYY format!");
	        else if (!IsDate(ArrivalDate1))
		        alert( "Please enter Arrival Date in MM/DD/YYYY format!");
	        else if ( DeptDate2!="" && !IsDate(DeptDate2))
		        alert( "Please enter Departure Date in MM/DD/YYYY format!");
	        else if ( ArrivalDate2!="" && !IsDate(ArrivalDate2))
		        alert( "Please enter Arrival Date in MM/DD/YYYY format!");
	        else{
		        document.frmMAWBNO.action="booking.asp?save=yes&MAWB=" + MAWB + "&WindowName=" +window.name;
		        document.frmMAWBNO.target="_self";
		        document.frmMAWBNO.method="POST";
		        frmMAWBNO.submit();
	       }
        }
   }

    function CheckNumberRange(StartNo,EndNo){
        var iStart = parseFloat(StartNo.substring(0,7))	;
        var iEnd = parseFloat(EndNo.substring(0,7));
        var iDiff = iEnd - iStart;

        if (iDiff < 0){
	        alert( "End No. must be greater than or equal to Start No.");
	        return false;
        }

        if (iDiff > 100){

	        alert( "The number range exceeds 100 limit. \r\nThe number range must be less than 100 or equal.");
	        return false;
        }
        return true;
    }

    function GoClick(){
        var sindex=document.frmMAWBNO.lstCarrier.selectedIndex;

        var vCarrierDesc=document.frmMAWBNO.lstCarrier.item(sindex).text;
        var vCarrierInfo=document.frmMAWBNO.lstCarrier.item(sindex).value;
        var vCarrier,vSCAC;
        var pos=-1;
        pos=vCarrierInfo.indexOf("-");
        if (pos>=0 ){
	        vCarrier=vCarrierInfo.substring(0,pos);
	        vSCAC=vCarrierInfo.substring(pos+1,200);
        }
        if (vCarrier == ""){
	        alert("This Carrier does not have a Prefix. \r\nPlease update the client profile.");
	        return false;
        }
        document.frmMAWBNO.txtCarrierDesc.value=vCarrierDesc;
        var StartNo=document.frmMAWBNO.txtStart.value;

        if (StartNo == "" ){
	        alert( "Please Enter a Start No.");
	        return false;
       }

        var EndNo=document.frmMAWBNO.txtEnd.value;

        if (EndNo == "" ){
	        alert( "Please Enter a End No.");
	        return false;
        }

        if (!CheckNumberRange(StartNo,EndNo) )
	        return false;

        if (!IsNumeric(StartNo) || StartNo.length!=8 )
	        alert( "Please enter a 8 digits numerical value for Start No!");
        else if (! IsNumeric(EndNo) ||  EndNo.length<=6  )
	        alert( "Please enter a 7 digits numerical value for End No!");
        else if ( parseFloat(EndNo.substring(0,7))<parseFloat(StartNo.substring(0,7)))
	        alert( "End No must be great than or equal to Start No!");
        else if (sindex<0)
	        alert( "Please select an AIRLINE!");
        else{
	        iStart = parseFloat(StartNo.substring(0,7))	;
	        iEnd = parseFloat(EndNo.substring(0,7));
	        iDiff = iEnd - iStart;
	
	        ParamH = iDiff * 20 + 120;
	        if (ParamH > 400 )
	            ParamH = 400;

            jPopUp(ParamH);
            document.frmMAWBNO.action="booking_number_ok.asp?go=yes" + "&WindowName=" + window.name;
            document.frmMAWBNO.method="post";
            document.frmMAWBNO.target="popUpWindow";
            frmMAWBNO.submit();
        }
    }

    function chkBookNumStart(num){
        var tmpNum = num.trim();

        if (tmpNum.length > 7 ){
	         var OneNum = num.substring(num.length-1,num.length);// Right(num,1) 
	         if (OneNum > 6 ){
	 	        alert( "You must enter the last digit with range of 0~6 ");
		        document.frmMAWBNO.txtStart.focus();
        //		document.frmMAWBNO.txtStart.value = MID(tmpNum,1,7) & "0"
	         }
        }

    }
    function chkBookNumEnd(num){
        var tmpNum =num.trim();

        if (tmpNum.length > 7 ){
	         var OneNum = num.substring(num.length-1,num.length);
	         if (OneNum > 6 ){
	 	        alert( "You must enter the last digit with range of 0~6 ");
		        document.frmMAWBNO.txtEnd.focus();
	         }
       }
    }
</script>
<script language="JavaScript" type="text/javascript" src="../include/tooltips.js"></script>
<!-- //Tooltip ends here// -->
<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
