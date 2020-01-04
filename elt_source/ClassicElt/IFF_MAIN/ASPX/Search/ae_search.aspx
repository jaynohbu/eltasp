<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ae_search.aspx.cs" 
    CodePage="65001" Inherits="ASPX_SEARCH_AE_SEARCH" %>
<%@ Register Assembly="iMoon.WebControls.ComboBox" Namespace="iMoon.WebControls"
    TagPrefix="iMoon" %>
<%@ Register TagPrefix="igtxt" Namespace="Infragistics.WebUI.WebDataInput" Assembly="Infragistics.WebUI.WebDataInput, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igsch" Namespace="Infragistics.WebUI.WebSchedule" Assembly="Infragistics.WebUI.WebDateChooser, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igtbl" Namespace="Infragistics.WebUI.UltraWebGrid" Assembly="Infragistics.WebUI.UltraWebGrid, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="uc1" TagName="rdSelectDateControl1" Src="../SelectionControls/rdSelectDateControl1.ascx" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Air Export Search</title>
    <style type="text/css">
    <!--
	    body {
		    margin-left: 0px;
		    margin-top: 0px;
		    margin-right: 0px;
		    margin-bottom: 0px;
	    }
	    .style2 {color: #cc6600}
        body {
	        margin-left: 0px;
	        margin-right: 0px;
	        margin-bottom: 0px;
        }
	    .style15 {
		    color: #C6603E
	    }
	    
	    .FromCalendar{
            position:absolute; 
            top:0px; 
            left:20px; 
            background-color:#ffffff;
            z-index:2;
        }
        
        .ToCalendar{
            position:absolute; 
            top:0px; 
            left:20px;
            background-color:#ffffff;
            z-index:2;
        }
    -->
    </style>

    <script type="text/javascript" src="../../ASP/include/simpletab.js"></script>

    <script src="../jScripts/WebDateSet1.js" type="text/javascript"></script>

    <script src="../jScripts/ig_dropCalendar.js" type="text/javascript"></script>

    <script src="../jScripts/ig_editDrop1.js" type="text/javascript"></script>

    <script type="text/javascript" language="javascript" src="../../ASP/ajaxFunctions/ajax.js"></script>

    <script type="text/javascript" src="../../ASP/include/JPED.js"></script>

    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript">
    
        function openWindowFromSearch(url){
            window.open(url, "popUpWindow", "menubar=0,toolbar=0,hotkeys=1,status=1,location=0,scrollbars=1,resizable=1,width=900,height=600");
        }
        
        function loadValues()
        {
            if( document.getElementById("PeriodDropDownList").value == "ALLTIME")
            {
                datetextboxchange1();
            }
        }
        
        function datetextboxchange1()
        {
        	document.getElementById("Webdatetimeedit1").style.background="#CCCCCC";
        	document.getElementById("Webdatetimeedit2").style.background="#CCCCCC";
        }
         
        function datetextboxchange2()
        {
            document.getElementById("Webdatetimeedit1").style.background="#FFFFFF";
        	document.getElementById("Webdatetimeedit2").style.background="#FFFFFF";
        }
         
        function lstShipperNameChange(orgNum,orgName)
        {
            var hiddenObj = document.getElementById("hShipperAcct");
            var txtObj = document.getElementById("lstShipperName");
            var divObj = document.getElementById("lstshipperNameDiv")
    
            hiddenObj.value = orgNum;
            txtObj.value = orgName;
            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";
        }
        
        function lstCarrierNameChange(orgNum,orgName){
	        var c_hiddenObj = document.getElementById("hCarrierAcct");
	        var c_txtObj = document.getElementById("lstCarrierName");
	        var c_divObj = document.getElementById("lstCarrierNameDiv");
        	
	        c_hiddenObj.value = orgNum;
	        c_txtObj.value = orgName;
	        c_divObj.style.position = "absolute";
	        c_divObj.style.visibility = "hidden";
	    }
	    
	   function searchNumFill(obj,changeFunction,vHeight){
            var qStr = obj.value;
            var keyCode = window.event.keyCode;
            var url;

            if(qStr != "" && keyCode != 229 && keyCode != 27){
                    url = "/IFF_MAIN/ASP/ajaxFunctions/ajax_get_international_mawb_list.asp?mode=AE&qStr=" + qStr;
                FillOutJPED(obj,url,changeFunction,vHeight);
            }
        }
        
        function searchNumFillAll(objName,changeFunction,vHeight){
            var obj = document.getElementById(objName);
                url = "/IFF_MAIN/ASP/ajaxFunctions/ajax_get_international_mawb_list.asp?mode=AE";
            FillOutJPED(obj,url,changeFunction,vHeight);
        }
       
        function lstSearchNumChange(argV,argL){
            var divObj = document.getElementById("lstSearchNumDiv");
		    var hiddenObj = document.getElementById("hSearchNum");
		    var txtObj = document.getElementById("lstSearchNum");	
            hiddenObj.value = argV;
		    txtObj.value = argL;	    
            divObj.style.visibility = "hidden";
            divObj.style.position = "absolute";
		    divObj.innerHTML = "";
        }
        
        function lstAgentNameChange(ANum,AName){
		    var AhiddenObj = document.getElementById("hAgentAcct");
		    var AtxtObj = document.getElementById("lstAgentName");
		    var AdivObj = document.getElementById("lstAgentNameDiv");
		
		    AhiddenObj.value = ANum;
		    AtxtObj.value = AName;
		    AdivObj.style.position = "absolute";
		    AdivObj.style.visibility = "hidden";
	    }
	    
        function lstConsigneeNameChange(orgNum,orgName){
            var hiddenObj = document.getElementById("hConsigneeAcct");
            var txtObj = document.getElementById("lstConsigneeName");
            var divObj = document.getElementById("lstConsigneeNameDiv");
                    
            hiddenObj.value = orgNum;
            txtObj.value = orgName;
            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";
		    divObj.innerHTML = "";
        }
        
        function EditClick(MAWB,status)
        {
               if (status != "C")
               {
                   url ="/IFF_MAIN/ASP/air_export/new_edit_mawb.asp?Edit=yes&mawb=" + encodeURIComponent(MAWB) + "&WindowName=popUpWindow";
                   openWindowFromSearch(url);
               }
               else
               {
                    alert("Master AWB No.#"+ MAWB +" is Closed!");
               }
        }
        
        function EditClickName(org_No)		
	    {
	        var eltno = document.getElementById("hELTNO").value; 
	        if ( org_No == eltno)
	        {
	            url ="/IFF_MAIN/ASP/site_admin/co_config.asp?WindowName=popUpWindow";
	        }
	        else
	        {
                url ="/IFF_MAIN/ASP/master_data/client_profile.asp?Action=filter&n="+ org_No + "&WindowName=popUpWindow";
            }
            openWindowFromSearch(url);
		}	
        
        function EditClickFILE(FILENO,status)
        {
            if (status != "C")
            {
                url ="/IFF_MAIN/ASP/air_export/booking.asp?Edit=yes&FILENO=" + encodeURIComponent(FILENO) + "&WindowName=popUpWindow";
                openWindowFromSearch(url);
            }
            else
            {
                alert("That Master AWB No Was Be Closed!");
            }
        }
               		
        function EditClickHAWB(HAWB)
        {
            url ="/IFF_MAIN/ASP/air_export/new_edit_hawb.asp?Edit=yes&hawb=" + encodeURIComponent(HAWB) + "&WindowName=popUpWindow";
            openWindowFromSearch(url);
        }
			
        
        function Master_checked()
        {
            if(document.getElementById("CheckMaster").checked==false){
                document.getElementById("CheckAllH").checked=true;
            }
            else{
                document.getElementById("CheckSub").checked=false;
                document.getElementById("CheckAllH").checked=false;
            }
        }	
        
        function Sub_checked()
        {
            if(document.getElementById("CheckSub").checked==false)
            {
                document.getElementById("CheckAllH").checked=true;
            }
            else
            {
                document.getElementById("CheckMaster").checked=false;
                document.getElementById("CheckAllH").checked=false;
            }
        }
        
        function AH_checked()
        {
            if(document.getElementById("CheckAllH").checked==false)
            {
                document.getElementById("CheckAllH").checked=true;
            }
            else
            {
                document.getElementById("CheckSub").checked=false;
                document.getElementById("CheckMaster").checked=false;
            }
        }
        
        function DS_checked()
        {
             if(document.getElementById("CheckDS").checked==false)
             {
                document.getElementById("CheckAT").checked=true;
             }
             else
             {
                document.getElementById("CheckCon").checked=false;
                document.getElementById("CheckAT").checked=false;
             }
        }
        	
        function Con_checked()
        {
             if(document.getElementById("CheckCon").checked==false)
             {
                document.getElementById("CheckAT").checked=true;
             }
             else
             {
                document.getElementById("CheckAT").checked=false;
                document.getElementById("CheckDS").checked=false;
             }
        }
        
        function AT_checked()
        {
             if(document.getElementById("CheckAT").checked==false)
             {
                document.getElementById("CheckAT").checked=true;
             }
             else
             {
                document.getElementById("CheckDS").checked=false;
                document.getElementById("CheckCon").checked=false;
             }
        }
        
        function Closed_checked()
        {
             if(document.getElementById("CheckClosed").checked==false)
             {
                document.getElementById("CheckAM").checked=true;
             }
             else
             {
               document.getElementById("CheckUsed").checked=false;
               document.getElementById("CheckAM").checked=false;
             }
        }
        	
        function Used_checked()
        {
             if(document.getElementById("CheckUsed").checked==false)
             {
                document.getElementById("CheckAM").checked=true;
             }
             else
             {
                document.getElementById("CheckClosed").checked=false;
                document.getElementById("CheckAM").checked=false;
             }
        }
        
        function AM_checked()
        {
             if(document.getElementById("CheckAM").checked==false)
             {
                document.getElementById("CheckAM").checked=true;
             }
             else
             {
                document.getElementById("CheckClosed").checked=false;
                document.getElementById("CheckUsed").checked=false;
             }
        }
        
        function ViewClickH(hawbno)
        {
            url ="/IFF_MAIN/ASP/air_export/view_print.asp?sType=house&hawb=" + encodeURIComponent(hawbno) + "&WindowName=popUpWindow";
            openWindowFromSearch(url);
        }
        
        function ViewClickM(mawbno)
        {
            url ="/IFF_MAIN/ASP/air_export/view_print.asp?sType=master&hawb=" + encodeURIComponent(mawbno) + "&WindowName=popUpWindow";
            openWindowFromSearch(url);
        }
        
    </script>

    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link href="../CSS/AppStyle.css" rel="stylesheet" type="text/css" />
</head>
<body link="336699" vlink="336699" topmargin="0" onLoad="self.focus(); loadValues();">
    <form runat="server" id="form1">
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td width="50%" height="32" align="left" valign="middle" class="pageheader">
                    AE SEARCH
                </td>
                <td width="50%" align="right" valign="middle">
                    &nbsp;
                </td>
            </tr>
        </table>
        <div class="selectarea">
        </div>
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#A0829C"
            bgcolor="#A0829C" class="border1px">
            <tr>
                <td>
                    <!--// -->
                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                        <tr bgcolor="#edd3cf">
                            <td align="center" valign="middle" bgcolor="#E5D4E3" class="bodyheader" style="height: 8px">
                            </td>
                        </tr>
                        <tr>
                            <td colspan="9" bgcolor="#A0829C" style="height: 1px">
                            </td>
                        </tr>
                        <tr align="center">
                            <td valign="top" bgcolor="#f3f3f3" class="bodycopy" style="padding: 14px 14px 14px 14px">
                                <table border="0" cellpadding="0" cellspacing="0" bordercolor="#A0829C" bgcolor="#FFFFFF"
                                    class="border1px" style="padding-left: 10px; width: 57%;" id="TABLE1" language="javascript">
                                    <tr class="bodyheader">
                                        <td align="left" bgcolor="#e8d9e6" style="height: 18px; width: 557px;">
                                            <span class="style15">Search Type</span>
                                        </td>
                                        <td align="left" bgcolor="#e8d9e6" style="height: 18px; width: 208px;">
                                            Period</td>
                                        <td align="left" bgcolor="#e8d9e6" style="height: 18px; width: 444px;">
                                            <table>
                                                <tr class="bodyheader">
                                                    <td width="7%" align="left" valign="middle" bgcolor="#e8d9e6" style="height: 18px"">
                                                        From</td>
                                                    <td width="11%" align="left" valign="middle" bgcolor="#e8d9e6" style="height: 18px"">
                                                        To</td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left" valign="top" style="height: 15px; width: 557px;">
                                            <asp:DropDownList CssClass="bodycopy" Width="130px" runat="server" ID="lstSearchType"
                                                AutoPostBack="true" OnSelectedIndexChanged="Page_change">
                                                <asp:ListItem Text="House AWB No."></asp:ListItem>
                                                <asp:ListItem Text="Master AWB No."></asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                        <td align="left" valign="top" style="height: 15px; width: 208px;">
                                            <asp:DropDownList runat="server" AutoPostBack="true" OnSelectedIndexChanged="Date_Changed"
                                                ID="PeriodDropDownList" CssClass="bodycopy">
                                                <asp:ListItem Value="" Text="Select One"></asp:ListItem>
                                                <asp:ListItem Value="Today" Text="Today"></asp:ListItem>
                                                <asp:ListItem Value="MonthtoDate" Text="Month To Date"></asp:ListItem>
                                                <asp:ListItem Value="YeartoDate" Text="Year To Date"></asp:ListItem>
                                                <asp:ListItem Value="thisMonth" Text="This Month"></asp:ListItem>
                                                <asp:ListItem Value="thisQuarter" Text="This Quarter"></asp:ListItem>
                                                <asp:ListItem Value="thisyear" Text="This Year"></asp:ListItem>
                                                <asp:ListItem Value="lastMonth" Text="Last Month"></asp:ListItem>
                                                <asp:ListItem Value="lastQuarter" Text="last Quarter"></asp:ListItem>
                                                <asp:ListItem Value="lastyear" Text="Last Year"></asp:ListItem>
                                                <asp:ListItem Value="ALLTIME" Text="All Time"></asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                        <td align="left" style="width: 222px">
                                            <table>
                                                <tr class="bodyheader">
                                                    <td align="left" valign="top" style="width: 100px; height: 15px;">
                                                        <table cellpadding="0" cellspacing="0" border="0">
                                                            <tr>
                                                                <td style="height: 18px">
                                                                    <igtxt:WebDateTimeEdit ID="Webdatetimeedit1" AccessKey="e" runat="server" ForeColor="Black"
                                                                        Width="120px" Fields="" EditModeFormat="MM/dd/yyyy" PromptChar=" " OnValueChange="period_change_back"
                                                                        onmousedown="datetextboxchange2()" Height="17px">
                                                                        <ButtonsAppearance CustomButtonDisplay="OnRight">
                                                                        </ButtonsAppearance>
                                                                        <SpinButtons Display="OnLeft" SpinOnReadOnly="True"></SpinButtons>
                                                                    </igtxt:WebDateTimeEdit>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                    <td align="left" valign="top" style="height: 15px">
                                                        <table cellpadding="0" cellspacing="0" border="0">
                                                            <tr>
                                                                <td>
                                                                    <igtxt:WebDateTimeEdit ID="Webdatetimeedit2" AccessKey="e" runat="server" ForeColor="Black"
                                                                        Width="120px" Fields="" EditModeFormat="MM/dd/yyyy" PromptChar=" " OnValueChange="period_change_back"
                                                                        onmousedown="datetextboxchange2()" Height="17px">
                                                                        <ButtonsAppearance CustomButtonDisplay="OnRight">
                                                                        </ButtonsAppearance>
                                                                        <SpinButtons Display="OnLeft" SpinOnReadOnly="True" />
                                                                    </igtxt:WebDateTimeEdit>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="3" bgcolor="#A0829C" style="height: 2px">
                                        </td>
                                    </tr>
                                    <tr class="bodyheader">
                                        <td height="18" align="left" bgcolor="#f3f3f3" style="width: 557px">
                                            MAWB No.</td>
                                        <td align="left" bgcolor="#f3f3f3" class="bodyheader" style="width: 208px">
                                            &nbsp;</td>
                                        <td align="left" bgcolor="#f3f3f3" style="width: 222px">
                                            File no.</td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" align="left" style="height: 18px">
                                            <table cellpadding="0" cellspacing="0" border="0">
                                                <tr>
                                                    <td>
                                                        <asp:HiddenField ID="hSearchNum" runat="server" Value="" />
                                                        <!--<input type="hidden" id="hSearchNum" name="hSearchNum" />-->
                                                        <div id="lstSearchNumDiv">
                                                        </div>
                                                        <!--<input type="text"-->
                                                        <asp:TextBox ID="lstSearchNum" runat="server" autocomplete="off" class="shorttextfield"
                                                            Style="width: 110px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                            border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9; color: Black"
                                                            onkeyup=" searchNumFill(this,'lstSearchNumChange','');" onfocus="initializeJPEDField(this);"></asp:TextBox></td>
                                                    <td style="width: 16px">
                                                        <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="searchNumFillAll('lstSearchNum','lstSearchNumChange',200);"
                                                            style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                            border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                    <td>
                                                        <asp:TextBox ID="txtlast" runat="server" CssClass="m_shorttextfield" Width="50px"></asp:TextBox>
                                                        <span class="bodyheader style2">Last 4.Digits</span></td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td align="left" valign="middle" style="height: 18px">
                                            <asp:TextBox ID="txtFileNo" runat="server" CssClass="m_shorttextfield" Width="120px"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr class="bodyheader">
                                        <td height="18" align="left" bgcolor="#f3f3f3" style="width: 557px">
                                            Departure Port</td>
                                        <td align="left" bgcolor="#f3f3f3" class="bodyheader" style="width: 208px">
                                            &nbsp;</td>
                                        <td align="left" bgcolor="#f3f3f3" style="width: 222px">
                                            Destination Port</td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" align="left" style="height: 18px">
                                            <asp:DropDownList CssClass="bodycopy" Width="218px" runat="server" ID="OriginPortSelect">
                                                <asp:ListItem Text="Select One" Value="" />
                                            </asp:DropDownList>
                                        </td>
                                        <td align="left" style="width: 222px; height: 18px;">
                                            <asp:DropDownList CssClass="bodycopy" Width="218px" runat="server" ID="DestPortSelect">
                                                <asp:ListItem Text="Select One" Value="" />
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr class="bodyheader">
                                        <td height="18" colspan="2" align="left" bgcolor="#f3f3f3">
                                            Shipper</td>
                                        <td align="left" valign="middle" bgcolor="#f3f3f3" style="padding-left: 10px; width: 222px;">
                                            Consignee</td>
                                    </tr>
                                    <tr>
                                        <td height="20" colspan="2" align="left" bgcolor="#FFFFFF">
                                            <!-- Start JPED -->
                                            <asp:HiddenField runat="Server" ID="hShipperAcct" Value="" />
                                            <div id="lstshipperNameDiv">
                                            </div>
                                            <table cellpadding="0" cellspacing="0" border="0">
                                                <tr>
                                                    <td>
                                                        <asp:TextBox runat="server" autocomplete="off" ID="lstShipperName" name="lstShipperName"
                                                            value="" class="shorttextfield" Style="width: 200px; border-top: 1px solid #7F9DB9;
                                                            border-bottom: 1px solid #7F9DB9; border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;
                                                            color: #000000" onKeyUp="organizationFill(this,'Shipper','lstShipperNameChange')"
                                                            onfocus="initializeJPEDField(this);" /></td>
                                                    <td>
                                                        <img src="/ig_common/Images/combobox_drop.gif" alt="" onClick="organizationFillAll('lstShipperName','shipper','lstShipperNameChange')"
                                                            style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                            border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                </tr>
                                            </table>
                                            <!-- End JPED -->
                                        </td>
                                        <td colspan="2" align="left">
                                            <asp:HiddenField runat="Server" ID="hConsigneeAcct" Value="" />
                                            <div id="lstConsigneeNameDiv">
                                            </div>
                                            <table cellpadding="0" cellspacing="0" border="0">
                                                <tr>
                                                    <td style="height: 18px">
                                                        <asp:TextBox runat="server" autocomplete="off" ID="lstConsigneeName" name="lstConsigneeName"
                                                            CssClass="shorttextfield" Style="width: 200px; border-top: 1px solid #7F9DB9;
                                                            border-bottom: 1px solid #7F9DB9; border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;
                                                            color: #000000" onKeyUp="organizationFill(this,'Consignee','lstConsigneeNameChange')"
                                                            onfocus="initializeJPEDField(this);" /></td>
                                                    <td style="height: 18px">
                                                        <img src="/ig_common/Images/combobox_drop.gif" alt="" onClick="organizationFillAll('lstConsigneeName','Consignee','lstConsigneeNameChange')"
                                                            style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                            border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                    <td style="height: 18px">
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr bgcolor="#f3f3f3">
                                        <td height="18" align="left" bgcolor="#f3f3f3" class="bodyheader" style="width: 557px">
                                            Airline Carrier</td>
                                        <td align="left" bgcolor="#f3f3f3" class="bodyheader" style="width: 208px">
                                        </td>
                                        <td align="left" bgcolor="#f3f3f3" class="bodyheader" style="width: 300px">
                                            <table id="table2">
                                                <tr class="bodyheader">
                                                    <td align="left" bgcolor="#f3f3f3" class="bodyheader" style="height: 5px; width: 129px;">
                                                        No. of Pieces</td>
                                                    <td align="left" bgcolor="#f3f3f3" class="bodyheader" style="height: 5px; width: 112px;">
                                                        Sales Rep.</td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <!-- style="padding-right:12px" -->
                                        <td colspan="2" align="left">
                                            <asp:HiddenField runat="Server" ID="hCarrierAcct" Value="" />
                                            <div id="lstCarrierNameDiv">
                                            </div>
                                            <table cellpadding="0" cellspacing="0" border="0">
                                                <tr>
                                                    <td style="height: 18px">
                                                        <asp:TextBox runat="server" autocomplete="off" ID="lstCarrierName" name="lstCarrierName"
                                                            CssClass="shorttextfield" Style="width: 200px; border-top: 1px solid #7F9DB9;
                                                            border-bottom: 1px solid #7F9DB9; border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;
                                                            color: #000000" onKeyUp="organizationFill(this, 'Carrier','lstCarrierNameChange')"
                                                            onfocus="initializeJPEDField(this);" /></td>
                                                    <td style="height: 18px">
                                                        <img src="/ig_common/Images/combobox_drop.gif" alt="" id="img1" onClick="organizationFillAll('lstCarrierName','Carrier','lstCarrierNameChange')"
                                                            style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                            border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                    <td style="height: 18px">
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td align="left" bgcolor="#ffffff" class="bodyheader" style="width: 300px">
                                            <table>
                                                <tr class="bodyheader">
                                                    <td align="left" bgcolor="#ffffff" class="bodyheader" style="height: 5px; width: 129px;">
                                                        <asp:TextBox ID="NoPiece" runat="server" CssClass="m_shorttextfield" Width="120px"
                                                            style="behavior: url(/IFF_MAIN/ASP/include/igNumDotChkLeft.htc)"></asp:TextBox></td>
                                                    <td align="left" bgcolor="#ffffff" class="bodyheader" style="height: 5px; width: 112px;">
                                                        <asp:DropDownList CssClass="bodycopy" Width="150px" runat="server" ID="SaleDroplist">
                                                            <asp:ListItem Text="Select One" Value="" />
                                                        </asp:DropDownList>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr bgcolor="#f3f3f3">
                                        <td height="18" align="left" bgcolor="#f3f3f3" class="bodyheader" style="width: 557px">
                                        </td>
                                        <td height="18" align="left" bgcolor="#f3f3f3" class="bodyheader" style="width: 208px">
                                            &nbsp;</td>
                                        <td height="18" align="left" bgcolor="#f3f3f3" class="bodyheader" style="width: 111px">
                                            &nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td colspan="1" bgcolor="#A0829C" style="height: 1px; width: 557px;">
                                        </td>
                                        <td colspan="1" bgcolor="#A0829C" style="height: 1px; width: 208px;">
                                        </td>
                                        <td colspan="1" bgcolor="#A0829C" style="height: 1px">
                                        </td>
                                    </tr>
                                    <tr bgcolor="#f3f3f3">
                                        <td align="left" bgcolor="#f3f3f3" class="bodyheader" style="width: 557px; height: 18px;">
                                            <asp:Label ID="label0" runat="server" /></td>
                                        <td align="left" bgcolor="#f3f3f3" class="bodyheader" style="width: 208px; height: 18px;">
                                            <asp:Label ID="label5" runat="server" /></td>
                                        <td align="left" bgcolor="#f3f3f3" class="bodyheader" style="height: 18px; width: 129px;">
                                            <asp:Label ID="label4" runat="server" /></td>
                                    </tr>
                                    <tr bgcolor="#ffffff">
                                        <td align="left" bgcolor="#ffffff" class="bodyheader" style="width: 557px; height: 43px;">
                                            <asp:TextBox ID="Txt1stHawb" runat="server" CssClass="shorttextfield" ForeColor="#000000"
                                                Width="150px" />
                                            <table width="100%">
                                                <tr>
                                                    <td align="left" bgcolor="#ffffff" class="bodyheader">
                                                        <asp:CheckBox ID="CheckDS" Text="Direct" TextAlign="Right" runat="server"
                                                            onClick="DS_checked()" />
                                                    </td>
                                                    <td align="left" bgcolor="#ffffff" class="bodyheader">
                                                        <asp:CheckBox ID="CheckCon" Text="Consol" TextAlign="Right" runat="server" onClick="Con_checked()" />
                                                    </td>
                                                    <td align="left" bgcolor="#ffffff" class="bodyheader">
                                                        <asp:CheckBox ID="CheckAT" Text="All" Checked="TRUE" TextAlign="Right" runat="server"
                                                            onClick="AT_checked()" />
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td align="left" bgcolor="#ffffff" class="bodyheader" style="width: 208px; height: 43px;">
                                            <table width="100%" height="12">
                                                <tr>
                                                    <td align="left" bgcolor="#ffffff" class="bodyheader" style="width: 40px; height: 12px;">
                                                        <asp:CheckBox ID="CheckMaster" Text="Master" TextAlign="Right" runat="server" onClick="Master_checked()" />
                                                    </td>
                                                    <td align="left" bgcolor="#ffffff" class="bodyheader" style="width: 40px; height: 12px;">
                                                        <asp:CheckBox ID="CheckSub" Text="Sub" TextAlign="Right" runat="server" onClick="Sub_checked()" />
                                                    </td>
                                                    <td align="left" bgcolor="#ffffff" class="bodyheader" style="width: 40px; height: 12px;">
                                                        <asp:CheckBox ID="CheckAllH" Text="All" Checked="TRUE" TextAlign="Right" runat="server"
                                                            Font-Size="6.4pt" onClick="AH_checked()" />
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td valign="top" align="left" bgcolor="#ffffff" class="bodycopy" style="width: 130px;
                                            height: 43px;">
                                            <!-- Start JPED -->
                                            <asp:HiddenField runat="Server" ID="hAgentAcct" Value="" />
                                            <div id="lstAgentNameDiv">
                                            </div>
                                            <table cellpadding="0" cellspacing="0" border="0" runAt="server" ID="tblAgent">
                                                <tr>
                                                    <td>
                                                        <asp:TextBox runat="server" autocomplete="off" ID="lstAgentName" name="lstAgentName"
                                                            value="" class="shorttextfield" Style="width: 200px; border-top: 1px solid #7F9DB9;
                                                            border-bottom: 1px solid #7F9DB9; border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;
                                                            color: #000000" onKeyUp="organizationFill(this,'Agent','lstAgentNameChange')"
                                                            onfocus="initializeJPEDField(this);" /></td>
                                                    <td>
                                                        <img src="/ig_common/Images/combobox_drop.gif" alt="" onClick="organizationFillAll('lstAgentName','Agent','lstAgentNameChange')"
                                                            style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                            border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                </tr>
                                            </table>
                                            <!-- End JPED -->
                                            <table width="100%" height="12">
                                                <tr>
                                                    <td height="12" valign="top" align="left" bgcolor="#ffffff" class="bodyheader" style="width: 40px">
                                                        <asp:CheckBox ID="CheckClosed" Text="Closed" TextAlign="Right" runat="server" onClick="Closed_checked()" />
                                                    </td>
                                                    <td height="12" valign="top" align="left" bgcolor="#ffffff" class="bodyheader" style="width: 40px">
                                                        <asp:CheckBox ID="CheckUsed" Text="Used" TextAlign="Right" runat="server" onClick="Used_checked()" />
                                                    </td>
                                                    <td height="12" valign="top" align="left" bgcolor="#ffffff" class="bodyheader" style="width: 40px">
                                                        <asp:CheckBox ID="CheckAM" Text="All" Checked="TRUE" TextAlign="Right" runat="server"
                                                            Font-Size="6.4pt" onClick="AM_checked()" />
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr bgcolor="#f3f3f3">
                                        <td height="18" align="left" bgcolor="#f3f3f3" class="bodyheader" style="width: 557px">
                                            <asp:Label ID="label1" runat="server" /></td>
                                        <td align="left" bgcolor="#f3f3f3" class="bodyheader" style="height: 5px; width: 208px;">
                                            <asp:Label ID="label2" runat="server" /></td>
                                        <td align="left" bgcolor="#f3f3f3" class="bodyheader" style="width: 300px">
                                            <table id="table3">
                                                <tr class="bodyheader">
                                                    <td align="left" bgcolor="#f3f3f3" class="bodyheader" style="height: 5px; width: 205px;">
                                                        <asp:Label ID="label3" runat="server" /></td>
                                                    <td align="left" bgcolor="#f3f3f3" class="bodyheader" style="height: 5px; width: 205px;">
                                                        <asp:Label ID="label6" runat="server" /></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr bgcolor="#ffffff">
                                        <td align="left" bgcolor="#ffffff" class="bodyheader" style="width: 557px; height: 18px;">
                                            <asp:TextBox ID="LCNO" runat="server" CssClass="m_shorttextfield" Width="120px"></asp:TextBox></td>
                                        <td align="left" bgcolor="#FFFFFF" class="bodyheader" style="width: 208px; height: 18px;">
                                            <asp:TextBox ID="CINO" runat="server" CssClass="m_shorttextfield" Width="120px"></asp:TextBox></td>
                                        <td align="left" bgcolor="#ffffff" class="bodyheader" style="width: 300px">
                                            <table id="table4">
                                                <tr class="bodyheader">
                                                    <td align="left" bgcolor="#FFFFFF" class="bodyheader" style="height: 18px; width: 205px;">
                                                        <asp:TextBox ID="OTH_REF_NO" runat="server" CssClass="m_shorttextfield" Width="120px"></asp:TextBox>
                                                    </td>
                                                    <td align="left" bgcolor="#FFFFFF" class="bodyheader" style="height: 18px; width: 205px;">
                                                        <asp:TextBox ID="AESNO" runat="server" CssClass="m_shorttextfield" Width="120px"></asp:TextBox>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="#f3f3f3" style="width: 557px; height: 24px;">
                                            <asp:HiddenField ID="PeriodChange" runat="server" Value="N" />
                                        </td>
                                        <td align="left" bgcolor="#f3f3f3" class="bodyheader" style="width: 208px; height: 24px;">
                                            <asp:TextBox ID="sortway" runat="server" CssClass="m_shorttextfield" Width="120px"></asp:TextBox>
                                            <asp:TextBox ID="sortway2" runat="server" CssClass="m_shorttextfield" Width="120px"></asp:TextBox>
                                            <asp:HiddenField ID="hELTNO" runat="server" Value="" />
                                        </td>
                                        <td align="right" valign="middle" bgcolor="#f3f3f3" style="padding-right: 10px; width: 270px;
                                            height: 24px;">
                                            <asp:ImageButton runat="server" ImageUrl="../../Images/button_go.gif" ID="btnGo"
                                                OnClick="btnGo_Click" />&nbsp;&nbsp;&nbsp;&nbsp;
                                            <asp:ImageButton runat="server" ImageUrl="../../Images/button_refresh.gif" ID="refreshpage"
                                                OnClick="refresh_Click" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td align="left" bgcolor="#f3f3f3">
                    <table cellpadding="0" cellspacing="0" border="0">
                        <tr>
                            <td><asp:Label runat="server" id="lblRecordCount" CssClass="bodycopy" /></td>
                            <td style="width:10px"></td>
                            <td><asp:ImageButton ID="btnExcelExport" runat="server" ImageUrl="../../Images/button_exel.gif" OnClick="btnExcelExport_Click" Visible="false" /></td>
                        </tr>
                    </table>
                    <div style="width: 100%">
                        <asp:GridView ID="GridViewHouse" runat="server" AllowPaging="True" AutoGenerateColumns="False"
                            OnPageIndexChanging="GridViewHouse_PageIndexChanging" Width="100%" BorderWidth="0px"
                            BorderStyle="None" CellPadding="0">
                            <PagerSettings Position="Top" Mode="Numeric" />
                            <PagerStyle CssClass="bodyheader" HorizontalAlign="Right" BorderStyle="None" BackColor="White" />
                            <HeaderStyle BorderStyle="None" HorizontalAlign="Left" VerticalAlign="Middle" Width="100%" />
                            <RowStyle BackColor="White" BorderStyle="None" />
                            <AlternatingRowStyle BackColor="#F3F3F3" />
                            <Columns>
                                <asp:TemplateField>
                                    <HeaderTemplate>
                                        <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                            <tr>
                                                <td>
                                                    <table border="0" cellpadding="2" cellspacing="1" style="width: 100%">
                                                        <tr>
                                                            <td height="1" colspan="12" bgcolor="#A0829C">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="20" style="padding-left: 10px" bgcolor="#e8d9e6" height="24">
                                                                <span class="style15">HOUSE AWB AIR EXPORT SEARCH</span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td height="1" colspan="12" bgcolor="#A0829C">
                                                            </td>
                                                        </tr>
                                                        <tr bgcolor="#e8d9e6" class="bodyheader">
                                                            <td height="12%" style="border-bottom: 1px solid #A0829C; border-right: 1px solid #A0829C;
                                                                padding-left: 10PX" width="10%">
                                                                House AWB No.
                                                                <asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif" OnClick="house_Click"
                                                                    ID="Mast_Sort1" /></td>
                                                            <td height="12%" style="border-bottom: 1px solid #A0829C; border-right: 1px solid #A0829C"
                                                                width="10%">
                                                                Master AWB No.<asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif"
                                                                    ID="ImageButton10" OnClick="master_Click" /></td>
                                                            <td width="10%" style="border-bottom: 1px solid #A0829C; border-right: 1px solid #A0829C">
                                                                ETD
                                                                <asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif" ID="ImageButton13"
                                                                    OnClick="ETD_Click" /></td>
                                                            <td width="8%" style="border-bottom: 1px solid #A0829C; border-right: 1px solid #A0829C">
                                                                File No.
                                                                <asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif" ID="ImageButton11"
                                                                    OnClick="File_Click" /></td>
                                                            <td width="10%" align="left" style="border-bottom: 1px solid #A0829C; border-right: 1px solid #A0829C">
                                                                Daparture Port<asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif"
                                                                    ID="ImageButton16" OnClick="Dep_Click" /></td>
                                                            <td width="10%" align="left" style="border-bottom: 1px solid #A0829C; border-right: 1px solid #A0829C">
                                                                Destination Port<asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif"
                                                                    ID="ImageButton17" OnClick="Dest_Click" /></td>
                                                            <td width="11%" style="border-bottom: 1px solid #A0829C; border-right: 1px solid #A0829C">
                                                                Shipper<asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif" ID="ImageButton14"
                                                                    OnClick="shipper_Click" /></td>
                                                            <td width="11%" style="border-bottom: 1px solid #A0829C; border-right: 1px solid #A0829C">
                                                                Consignee<asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif" ID="ImageButton15"
                                                                    OnClick="Consignee_Click" /></td>
                                                            <td width="10%" style="border-bottom: 1px solid #A0829C; border-right: 1px solid #A0829C">
                                                                Agent
                                                                <asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif" ID="ImageButton5"
                                                                    OnClick="Agent_Click" /></td>
                                                            <td width="6%" style="border-bottom: 1px solid #A0829C; border-right: 1px solid #A0829C">
                                                                Type of House</td>
                                                            <td width="4%" style="border-bottom: 1px solid #A0829C; border-right: 1px solid #A0829C">
                                                                &nbsp;</td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <!-- list item -->
                                        <table cellpadding="0" cellspacing="0" border="0" style="width: 100%">
                                            <tr>
                                                <td height="20" style="padding-left: 10px" width="10%" class="searchList">
                                                    <a href="javascript:;" onClick="EditClickHAWB('<%# Eval("hawb_num")%>')">
                                                        <%# Eval("hawb_num") %>
                                                    </a>
                                                </td>
                                                <td height="20" style="padding-left: 3px" width="10%" class="searchList">
                                                    <a href="javascript:;" onClick="EditClick('<%# Eval("MasterNo") %>', '<%# Eval("status") %>' )">
                                                        <%# Eval("MasterNo") %>
                                                    </a>
                                                    <%# GetStatus(Eval("status"),"K")%>
                                                </td>
                                                <td height="20" style="padding-left: 3px" width="10%">
                                                    <%# GetShortDate(Eval("CreatedDate"))%>
                                                </td>
                                                <td height="20" style="padding-left: 3px" width="8%">
                                                    <a href="javascript:;" onClick="EditClickFILE('<%# Eval("file#")%>', '<%# Eval("status") %>')">
                                                        <%# Eval("file#")%>
                                                    </a>
                                                </td>
                                                <td height="20" style="padding-left: 3px" width="10%">
                                                    <%# Eval("Departure_Airport")%>
                                                </td>
                                                <td height="20" style="padding-left: 3px" width="10%">
                                                    <%# Eval("Dest_Airport") %>
                                                </td>
                                                <td height="20" style="padding-left: 3px" width="11%">
                                                    <a href="javascript:;" onClick="EditClickName('<%# Eval("shipper_account_number")%>')">
                                                        <%# Eval("Shipper_Info")%>
                                                    </a>
                                                </td>
                                                <td height="20" style="padding-left: 3px" width="11%">
                                                    <a href="javascript:;" onClick="EditClickName('<%# Eval("Consignee_acct_num")%>')">
                                                        <%# Eval("consignee_name")%>
                                                    </a>
                                                </td>
                                                <td height="20" style="padding-left: 3px" width="10%">
                                                    <a href="javascript:;" onClick="EditClickName('<%# Eval("Agent_no")%>')">
                                                        <%# Eval("agent_name")%>
                                                </td>
                                                <td height="20" style="padding-left: 3px" width="6%">
                                                    <%# GetHouse(Eval("is_master"),Eval("is_sub"))%>
                                                </td>
                                                <td width="4%" align="center">
                                                    <img src="../../images/button_view.gif" width="42" height="18" name="View" onClick="ViewClickH('<%# Eval("hawb_num") %>')"
                                                        style="cursor: hand">
                                                </td>
                                            </tr>
                                        </table>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                    <div>
                        <asp:GridView ID="GridViewMaster" runat="server" AllowPaging="True" AutoGenerateColumns="False"
                            OnPageIndexChanging="GridViewMaster_PageIndexChanging" Width="100%" BorderWidth="0px"
                            BorderStyle="None" CellPadding="0" >
                            <PagerSettings Position="Top" Mode="Numeric" />
                            <PagerStyle CssClass="bodyheader" HorizontalAlign="Right" BorderStyle="None" BackColor="White" />
                            <HeaderStyle BorderStyle="None" HorizontalAlign="Left" VerticalAlign="Middle" Width="100%" />
                            <RowStyle BackColor="White" BorderStyle="None" />
                            <AlternatingRowStyle BackColor="#F3F3F3" />
                            <Columns>
                                <asp:TemplateField>
                                    <HeaderTemplate>
                                        <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                            <tr>
                                                <td>
                                                    <table border="0" cellpadding="2" cellspacing="1" style="width: 100%">
                                                        <tr>
                                                            <td height="1" colspan="12" bgcolor="#A0829C">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="20" style="padding-left: 10px" bgcolor="#e8d9e6" height="24">
                                                                <span class="style15">Master AWB AIR EXPORT SEARCH</span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td height="1" colspan="12" bgcolor="#A0829C">
                                                            </td>
                                                        </tr>
                                                        <tr bgcolor="#e8d9e6" class="bodyheader">
                                                            <td height="12%" style="border-bottom: 1px solid #A0829C; border-right: 1px solid #A0829C;
                                                                padding-left: 10PX" width="10%">
                                                                Master AWB No.<asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif"
                                                                    ID="Mast_Sort1" OnClick="master_Click" /></td>
                                                            <td width="10%" style="border-bottom: 1px solid #A0829C; border-right: 1px solid #A0829C">
                                                                ETD
                                                                <asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif" ID="ImageButton4"
                                                                    OnClick="ETD_Click" /></td>
                                                            <td width="10%" style="border-bottom: 1px solid #A0829C; border-right: 1px solid #A0829C">
                                                                File No.<asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif" ID="ImageButton1"
                                                                    OnClick="File_Click" /></td>
                                                            <td width="12%" style="border-bottom: 1px solid #A0829C; border-right: 1px solid #A0829C">
                                                                Daparture Port<asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif"
                                                                    ID="ImageButton8" OnClick="Dep_Click" /></td>
                                                            <td width="12%" style="border-bottom: 1px solid #A0829C; border-right: 1px solid #A0829C">
                                                                Destination Port<asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif"
                                                                    ID="ImageButton9" OnClick="Dest_Click" /></td>
                                                            <td width="12%" style="border-bottom: 1px solid #A0829C; border-right: 1px solid #A0829C">
                                                                Shipper<asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif" ID="ImageButton6"
                                                                    OnClick="shipper_Click" /></td>
                                                            <td width="12%" style="border-bottom: 1px solid #A0829C; border-right: 1px solid #A0829C">
                                                                Consignee<asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif" ID="ImageButton7"
                                                                    OnClick="Consignee_Click" /></td>
                                                            <td width="10%" style="border-bottom: 1px solid #A0829C; border-right: 1px solid #A0829C">
                                                                Type of Shipment</td>
                                                            <td width="8%" style="border-bottom: 1px solid #A0829C; border-right: 1px solid #A0829C">
                                                                MAWB Status</td>
                                                            <td width="4%" style="border-bottom: 1px solid #A0829C; border-right: 1px solid #A0829C">
                                                                &nbsp;</td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <!-- list item -->
                                        <table cellpadding="0" cellspacing="0" border="0" style="width: 100%">
                                            <tr>
                                                <td height="20" style="padding-left: 10px" width="10%" class="searchList">
                                                    <a href="javascript:;" onClick="EditClick('<%# Eval("MasterNo") %>', '<%# Eval("status") %>' )">
                                                        <%# Eval("MasterNo") %>
                                                    </a>
                                                    <%# GetStatus(Eval("status"),"K")%>
                                                </td>
                                                <td height="20" style="padding-left: 3px" width="10%">
                                                    <%# GetShortDate(Eval("CreatedDate"))%>
                                                </td>
                                                <td height="20" style="padding-left: 3px" width="10%">
                                                    <a href="javascript:;" onClick="EditClickFILE('<%# Eval("file#")%>', '<%# Eval("status") %>')">
                                                        <%# Eval("file#")%>
                                                    </a>
                                                </td>
                                                <td height="20" style="padding-left: 3px" width="12%">
                                                    <%# Eval("Departure_Airport")%>
                                                </td>
                                                <td height="20" style="padding-left: 3px" width="12%">
                                                    <%# Eval("Dest_Airport")%>
                                                </td>
                                                <td height="20" style="padding-left: 3px" width="12%">
                                                    <a href="javascript:;" onClick="EditClickName('<%# Eval("shipper_account_number")%>')">
                                                        <%# Eval("shipper_name")%>
                                                </td>
                                                <td height="20" style="padding-left: 3px" width="12%">
                                                    <a href="javascript:;" onClick="EditClickName('<%# Eval("Consignee_acct_num")%>')">
                                                        <%# Eval("consignee_name")%>
                                                    </a>
                                                </td>
                                                <td height="20" style="padding-left: 3px" width="10%">
                                                    <%# GetShipType(Eval("MasterNo"))%>
                                                </td>
                                                <td height="20" style="padding-left: 3px" width="8%">
                                                    <%# GetStatus(Eval("status"),Eval("used"))%>
                                                </td>
                                                <td width="4%" align="center">
                                                    <img src="../../images/button_view.gif" width="42" height="18" name="View" onClick="ViewClickM('<%# Eval("MasterNo") %>')"
                                                        style="cursor: hand">
                                                </td>
                                            </tr>
                                        </table>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </td>
            </tr>
            <tr bgcolor="#F2DEBF">
                <td height="22" colspan="14" align="left" valign="middle" bgcolor="#E5D4E3" class="bodycopy">
                    &nbsp;</td>
            </tr>
        </table>
        <P>
            <asp:Button ID="btnValidate" runat="server" Text="for Validation" Visible="False"></asp:Button><asp:LinkButton
                ID="LinkButton3" runat="server" Visible="False">LinkButton</asp:LinkButton><asp:TextBox
                    ID="txtNum" runat="server" Height="1px" Width="1px"></asp:TextBox><!-- end --></P>
        <igsch:WebCalendar ID="CustomDropDownCalendar" runat="server" Width="180px" Height="126px">
            <Layout CellPadding="0" FooterFormat="" NextMonthText="&gt;&gt;" PrevMonthText="&lt;&lt;"
                ShowFooter="False" ShowMonthDropDown="False" ShowYearDropDown="False" TitleFormat="Month">
                <DayStyle BackColor="White" CssClass="CalDay" />
                <SelectedDayStyle BackColor="#C5D5FC" CssClass="CalSelectedDay" />
                <OtherMonthDayStyle ForeColor="Silver" />
                <NextPrevStyle CssClass="NextPrevStyle" />
                <CalendarStyle CssClass="CalStyle" Height="126px" Width="180px">
                </CalendarStyle>
                <TodayDayStyle CssClass="CalToday" />
                <DayHeaderStyle CssClass="CalDayHeader" Font-Bold="False">
                    <BorderDetails StyleBottom="None" />
                </DayHeaderStyle>
                <TitleStyle CssClass="TitleStyle" Font-Bold="True" />
            </Layout>
        </igsch:WebCalendar>
    </form>

    <SCRIPT type="text/javascript">
            if(document.getElementById('Webdatetimeedit2')) {
    			ig_initDropCalendar("CustomDropDownCalendar Webdatetimeedit1 Webdatetimeedit2");
            }
            else
            {
    			ig_initDropCalendar("CustomDropDownCalendar Webdatetimeedit1");            
            }

    </SCRIPT>

</body>
<!--  #INCLUDE FILE="../include/StatusFooter.htm" -->
</html>
