<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ai_search.aspx.cs" 
Inherits="ASPX_SEARCH_AI_SEARCH" CodePage="65001" %>

<%@ Register Assembly="iMoon.WebControls.ComboBox" Namespace="iMoon.WebControls"
    TagPrefix="iMoon" %>
<%@ Register TagPrefix="igtxt" Namespace="Infragistics.WebUI.WebDataInput" Assembly="Infragistics.WebUI.WebDataInput, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igsch" Namespace="Infragistics.WebUI.WebSchedule" Assembly="Infragistics.WebUI.WebDateChooser, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igtbl" Namespace="Infragistics.WebUI.UltraWebGrid" Assembly="Infragistics.WebUI.UltraWebGrid, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="uc1" TagName="rdSelectDateControl1" Src="../SelectionControls/rdSelectDateControl1.ascx" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Air Import Search</title>
    <style type="text/css">

	    body {
		    margin-left: 0px;
		    margin-top: 0px;
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

        function searchNumFill(obj,changeFunction,vHeight){
            var qStr = obj.value;
            var keyCode = window.event.keyCode;
            var url;

            if(qStr != "" && keyCode != 229 && keyCode != 27){
                    url = "/IFF_MAIN/ASP/ajaxFunctions/ajax_get_international_mawb_list.asp?mode=AI&qStr=" + qStr;
                FillOutJPED(obj,url,changeFunction,vHeight);
            }
        }
        
        function searchNumFillAll(objName,changeFunction,vHeight){
            var obj = document.getElementById(objName);
                url = "/IFF_MAIN/ASP/ajaxFunctions/ajax_get_international_mawb_list.asp?mode=AI";
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
        
	    function EditClickName(org_No)		
	    {
            url = "/IFF_MAIN/ASP/master_data/client_profile.asp?Action=filter&n=" 
                + org_No + "&WindowName=popUpWindow";
            openWindowFromSearch(url);
		}		
        function EditClick(iType,MAWB,Sec,AgentOrgAcct,HAWB)
        {
            url = "/IFF_MAIN/ASP/air_import/arrival_notice.asp?iType=A&Edit=yes&AgentOrgAcct=" 
                + AgentOrgAcct + "&MAWB=" + encodeURIComponent(MAWB) + "&HAWB=" 
                + encodeURIComponent(HAWB) + "&Sec=" + Sec;
            openWindowFromSearch(url);
        }	
				
        function EditClickHAWB(iType,MAWB,Sec,AgentOrgAcct,HAWB)
        {
            url = "/IFF_MAIN/ASP/air_import/air_import2.asp?iType=A&Edit=yes&MAWB=" 
                + encodeURIComponent(MAWB) + "&Sec=" + Sec + "&AgentOrgAcct=" + AgentOrgAcct  
                + "&WindowName=popUpWindow";
            openWindowFromSearch(url);
        }
        
        function EditClickFILE(iType,FILE,Sec,AgentOrgAcct,HAWB)
        {
            url = "/IFF_MAIN/ASP/air_import/air_import2.asp?iType=A&Edit=yes&JOB=" 
                + encodeURIComponent(FILE) + "&WindowName=popUpWindow";
            openWindowFromSearch(url);
        }
        	
    </script>

    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link href="../CSS/AppStyle.css" rel="stylesheet" type="text/css" />
</head>
<body link="336699" vlink="336699" topmargin="0" onload="self.focus(); loadValues();">
    <form runat="server" id="form1">
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td width="50%" height="32" align="left" valign="middle" class="pageheader">
                    AIR IMPORT SEARCH
                </td>
                <td width="50%" align="right" valign="middle">
                    &nbsp;
                </td>
            </tr>
        </table>
        <div class="selectarea">
        </div>
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#ba9590"
            bgcolor="#ba9590" class="border1px">
            <tr>
                <td>
                    <!--// -->
                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                        <tr bgcolor="#edd3cf">
                            <td align="center" valign="middle" bgcolor="#edd3cf" class="bodyheader" style="height: 8px">
                            </td>
                        </tr>
                        <tr>
                            <td height="1" colspan="9" bgcolor="#ba9590">
                            </td>
                        </tr>
                        <tr align="center">
                            <td valign="top" bgcolor="#f3f3f3" class="bodycopy" style="padding: 34px 34px 24px">
                                <table border="0" cellpadding="0" cellspacing="0" bordercolor="#ba9590" bgcolor="#FFFFFF"
                                    class="border1px" style="padding-left: 10px; width: 46%;" id="TABLE1" language="javascript">
                                    <tr class="bodyheader">
                                        <td align="left" bgcolor="#efe1df" style="height: 18px; width: 111px;">
                                            <span class="style15">Search Type</span>
                                        </td>
                                        <td align="left" bgcolor="#efe1df" style="height: 18px; width: 103px;">
                                            Period</td>
                                        <td align="left" bgcolor="#efe1df" style="height: 18px; width: 250px;">
                                            <table>
                                                <tr class="bodyheader">
                                                    <td width="10%" align="left" valign="middle" bgcolor="#efe1df" style="height: 18px">
                                                        From</td>
                                                    <td width="11%" align="left" valign="middle" bgcolor="#efe1df" style="height: 18px">
                                                        To</td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left" valign="top" style="height: 15px; width: 111px;">
                                            <asp:DropDownList CssClass="bodycopy" Width="130px" runat="server" ID="lstSearchType"
                                                AutoPostBack="true" OnSelectedIndexChanged="Page_change">
                                                <asp:ListItem Text="House AWB No."></asp:ListItem>
                                                <asp:ListItem Text="Master AWB No."></asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                        <td align="left" valign="top" style="height: 15px; width: 103px;">
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
                                        <td colspan="3" bgcolor="#ba9590" style="height: 2px">
                                        </td>
                                    </tr>
                                    <tr class="bodyheader">
                                        <td height="18" align="left" bgcolor="#f3f3f3" style="width: 111px">
                                            MAWB No.</td>
                                        <td align="left" bgcolor="#f3f3f3" class="bodyheader" style="width: 103px">
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
                                                        <asp:TextBox ID="txtlast" runat="server" CssClass="m_shorttextfield" Width="40px"></asp:TextBox>
                                                        <span class="bodyheader style2">Last 4.Digits</span>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td align="left" valign="middle" style="height: 18px">
                                            <asp:TextBox ID="txtFileNo" runat="server" CssClass="m_shorttextfield" Width="120px"></asp:TextBox></td>
                                    </tr>
                                    <tr class="bodyheader">
                                        <td height="18" align="left" bgcolor="#f3f3f3" style="width: 111px">
                                            Departure Port</td>
                                        <td align="left" bgcolor="#f3f3f3" class="bodyheader" style="width: 103px">
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
                                                        <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstShipperName','shipper','lstShipperNameChange')"
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
                                                        <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstConsigneeName','Consignee','lstConsigneeNameChange')"
                                                            style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                            border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                                    <td style="height: 18px">
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr bgcolor="#f3f3f3">
                                        <td height="18" align="left" bgcolor="#f3f3f3" class="bodyheader" style="width: 111px">
                                            NO. of Pieces</td>
                                        <td align="left" bgcolor="#f3f3f3" class="bodyheader" style="width: 103px">
                                        </td>
                                        <td align="left" bgcolor="#f3f3f3" class="bodyheader" style="width: 203px">
                                        </td>
                                    </tr>
                                    <tr>
                                        <!-- style="padding-right:12px" -->
                                        <td align="left" valign="middle" style="height: 18px; width: 111px;">
                                            <asp:TextBox ID="NoPiece" runat="server" CssClass="m_shorttextfield" Width="120px"
                                                Style="behavior: url(/IFF_MAIN/ASP/include/igNumDotChkLeft.htc)"></asp:TextBox></td>
                                        <td align="left" valign="middle" style="height: 18px; width: 103px;">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="1" bgcolor="#ba9590" style="height: 1px; width: 476px;">
                                        </td>
                                        <td colspan="1" bgcolor="#ba9590" style="height: 1px">
                                        </td>
                                        <td colspan="1" bgcolor="#ba9590" style="height: 1px">
                                        </td>
                                    </tr>
                                    <tr bgcolor="#ffffff">
                                        <td valign="top" bgcolor="#ffffff" class="bodycopy" style="width: 111px">
                                            <table border="0" cellpadding="0" cellspacing="0" bordercolor="#ffffff" bgcolor="#FFFFFF"
                                                class="border1px" style="width: 100%;" id="tableHA">
                                                <tr>
                                                    <td height="18" align="left" bgcolor="#f3f3f3" class="bodyheader" style="width: 226px">
                                                        <asp:Label ID="label0" runat="server" /></td>
                                                </tr>
                                                <tr>
                                                    <td height="18" align="left" bgcolor="#FFFFFF" class="bodyheader" style="width: 226px">
                                                        <asp:TextBox ID="Txt1stHawb" runat="server" CssClass="shorttextfield" ForeColor="#000000"
                                                            Width="120px" /></td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td valign="top" bgcolor="#FFFFFF" class="bodycopy" style="width: 103px">
                                            <table border="0" cellpadding="0" cellspacing="0" bordercolor="#ffffff" bgcolor="#FFFFFF"
                                                class="border1px" style="width: 100%;" id="tableLC">
                                                <tr>
                                                    <td height="18" align="left" bgcolor="#f3f3f3" class="bodyheader" style="width: 226px">
                                                        <asp:Label ID="label1" runat="server" /></td>
                                                </tr>
                                                <tr>
                                                    <td height="18" align="left" bgcolor="#FFFFFF" class="bodyheader" style="width: 226px">
                                                        <asp:TextBox ID="LCNO" runat="server" CssClass="m_shorttextfield" Width="120px"></asp:TextBox></td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td align="left" bgcolor="#FFFFFF" style="width: 250px;">
                                            <table id="tableCI">
                                                <tr class="bodyheader">
                                                    <td align="left" bgcolor="#f3f3f3" class="bodyheader" style="height: 5px;">
                                                        <asp:Label ID="label2" runat="server" /></td>
                                                    <td align="left" bgcolor="#f3f3f3" class="bodyheader" style="height: 5px; width: 205px;">
                                                        <asp:Label ID="label3" runat="server" /></td>
                                                </tr>
                                                <tr class="bodyheader">
                                                    <td align="left" bgcolor="#FFFFFF" class="bodyheader" style="width: 141px; height: 14px;">
                                                        <asp:TextBox ID="CINO" runat="server" CssClass="m_shorttextfield" Width="120px"></asp:TextBox></td>
                                                    <td align="left" bgcolor="#FFFFFF" class="bodyheader" style="height: 14px; width: 205px;">
                                                        <asp:TextBox ID="OTH_REF_NO" runat="server" CssClass="m_shorttextfield" Width="120px"></asp:TextBox></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="#f3f3f3" style="width: 111px">
                                            <asp:HiddenField ID="PeriodChange" runat="server" Value="N" />
                                        </td>
                                        <td align="left" bgcolor="#f3f3f3" class="bodyheader" style="width: 250px">
                                            <asp:TextBox ID="sortway" runat="server" CssClass="m_shorttextfield" Width="120px"></asp:TextBox>
                                            <asp:TextBox ID="sortway2" runat="server" CssClass="m_shorttextfield" Width="120px"></asp:TextBox></td>
                                        <td height="24" align="right" valign="middle" bgcolor="#f3f3f3" style="padding-right: 15px;
                                            width: 250px;">
                                            <asp:ImageButton runat="server" ImageUrl="../../Images/button_go.gif" ID="btnGo"
                                                OnClick="btnGo_Click" />
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
                    <asp:Label runat="server" id="lblRecordCount" CssClass="bodycopy" /> 
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
                                                            <td height="1" colspan="12" bgcolor="#ba9590">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="20" style="padding-left: 10px" bgcolor="#efe1df" height="24">
                                                                <span class="style15">HOUSE AWB AIR IMPORT SEARCH</span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td height="1" colspan="12" bgcolor="#ba9590">
                                                            </td>
                                                        </tr>
                                                        <tr bgcolor="#efe1df" class="bodyheader">
                                                            <td height="12%" style="border-bottom: 1px solid #ba9590; border-right: 1px solid #ba9590;
                                                                padding-left: 10PX" width="12%">
                                                                House AWB No.
                                                                <asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif" OnClick="house_Click"
                                                                    ID="Mast_Sort1" /></td>
                                                            <td height="12%" style="border-bottom: 1px solid #ba9590; border-right: 1px solid #ba9590"
                                                                width="10%">
                                                                Master AWB No.<asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif"
                                                                    ID="ImageButton10" OnClick="master_Click" /></td>
                                                            <td width="10%" style="border-bottom: 1px solid #ba9590; border-right: 1px solid #ba9590">
                                                                File No.
                                                                <asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif" ID="ImageButton11"
                                                                    OnClick="File_Click" /></td>
                                                            <td width="6%" style="border-bottom: 1px solid #ba9590; border-right: 1px solid #ba9590">
                                                                SEC
                                                                <asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif" ID="ImageButton12"
                                                                    OnClick="SEC_Click" /></td>
                                                            <td width="10%" style="border-bottom: 1px solid #ba9590; border-right: 1px solid #ba9590">
                                                                Date
                                                                <asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif" ID="ImageButton13"
                                                                    OnClick="Date_Click" /></td>
                                                            <td width="13%" style="border-bottom: 1px solid #ba9590; border-right: 1px solid #ba9590">
                                                                Shipper<asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif" ID="ImageButton14"
                                                                    OnClick="shipper_Click" /></td>
                                                            <td width="13%" style="border-bottom: 1px solid #ba9590; border-right: 1px solid #ba9590">
                                                                Consignee<asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif" ID="ImageButton15"
                                                                    OnClick="Consignee_Click" /></td>
                                                            <td width="13%" align="left" style="border-bottom: 1px solid #ba9590; border-right: 1px solid #ba9590">
                                                                Daparture Port<asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif"
                                                                    ID="ImageButton16" OnClick="Dep_Click" /></td>
                                                            <td width="13%" align="left" style="border-bottom: 1px solid #ba9590; border-right: 1px solid #ba9590">
                                                                Destination Port<asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif"
                                                                    ID="ImageButton17" OnClick="Dest_Click" /></td>
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
                                                <td height="20" style="padding-left: 10px" width="12%" class="searchList">
                                                    <a href="javascript:;" onclick="EditClick('<%# Eval("iType") %>','<%# Eval("MasterNo") %>',<%# Eval("Sec") %>,<%# Eval("acct") %>,'<%# Eval("hawb_num")%>')">
                                                        <%# Eval("hawb_num") %>
                                                    </a>
                                                </td>
                                                <td height="20" style="padding-left: 3px" width="10%">
                                                    <a href="javascript:;" onclick="EditClickHAWB('<%# Eval("iType") %>','<%# Eval("MasterNo") %>',<%# Eval("Sec") %>,<%# Eval("acct") %>,'<%# Eval("hawb_num")%>')">
                                                        <%# Eval("MasterNo") %>
                                                </td>
                                                <td height="20" style="padding-left: 3px" width="10%">
                                                    <a href="javascript:;" onclick="EditClickFILE('<%# Eval("iType") %>','<%# Eval("file#") %>',<%# Eval("Sec") %>,<%# Eval("acct") %>,'<%# Eval("hawb_num")%>')">
                                                        <%# Eval("file#") %>
                                                </td>
                                                <td height="20" style="padding-left: 3px" width="6%">
                                                    <%# Eval("sec") %>
                                                </td>
                                                <td height="20" style="padding-left: 3px" width="10%">
                                                    <%# Eval("tran_date", "{0:MM/dd/yyyy}")%>

                                                </td>
                                                <td height="20" style="padding-left: 3px" width="13%">
                                                    <a href="javascript:;" onclick="EditClickName('<%# Eval("Shipper_acct")%>')">
                                                        <%# Eval("Shipper_Name")%>
                                                    </a>
                                                </td>
                                                <td height="20" style="padding-left: 3px" width="13%">
                                                    <a href="javascript:;" onclick="EditClickName('<%# Eval("consignee_acct")%>')">
                                                        <%# Eval("consignee_name")%>
                                                    </a>
                                                </td>
                                                <td height="20" style="padding-left: 3px" width="13%">
                                                    <%# Eval("P1") %>
                                                </td>
                                                <td height="20" style="padding-left: 3px" width="13%">
                                                    <%# Eval("P2") %>
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
                                                            <td height="1" colspan="12" bgcolor="#ba9590">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="20" style="padding-left: 10px" bgcolor="#efe1df" height="24">
                                                                <span class="style15">Master AWB AIR IMPORT SEARCH</span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td height="1" colspan="12" bgcolor="#ba9590">
                                                            </td>
                                                        </tr>
                                                        <tr bgcolor="#efe1df" class="bodyheader">
                                                            <td height="12%" style="border-bottom: 1px solid #ba9590; border-right: 1px solid #ba9590;
                                                                padding-left: 10PX" width="10%">
                                                                Master AWB No.<asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif"
                                                                    ID="Mast_Sort1" OnClick="master_Click" /></td>
                                                            <td width="10%" style="border-bottom: 1px solid #ba9590; border-right: 1px solid #ba9590">
                                                                File No.<asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif" ID="ImageButton1"
                                                                    OnClick="File_Click" /></td>
                                                            <td width="6%" style="border-bottom: 1px solid #ba9590; border-right: 1px solid #ba9590">
                                                                SEC
                                                                <asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif" ID="ImageButton4"
                                                                    OnClick="SEC_Click" /></td>
                                                            <td width="10%" style="border-bottom: 1px solid #ba9590; border-right: 1px solid #ba9590">
                                                                Date<asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif" ID="ImageButton5"
                                                                    OnClick="Date_Click" /></td>
                                                            <td width="13%" style="border-bottom: 1px solid #ba9590; border-right: 1px solid #ba9590">
                                                                Shipper<asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif" ID="ImageButton6"
                                                                    OnClick="shipper_Click" /></td>
                                                            <td width="13%" style="border-bottom: 1px solid #ba9590; border-right: 1px solid #ba9590">
                                                                Consignee<asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif" ID="ImageButton7"
                                                                    OnClick="Consignee_Click" /></td>
                                                            <td width="13%" style="border-bottom: 1px solid #ba9590; border-right: 1px solid #ba9590">
                                                                Airport of Departure<asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif"
                                                                    ID="ImageButton8" OnClick="Dep_Click" /></td>
                                                            <td width="13%" style="border-bottom: 1px solid #ba9590; border-right: 1px solid #ba9590">
                                                                Airport of Destination<asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif"
                                                                    ID="ImageButton9" OnClick="Dest_Click" /></td>
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
                                                <td height="20" style="padding-left: 10px" width="10%">
                                                    <a href="javascript:;" onclick="EditClickHAWB('<%# Eval("iType") %>','<%# Eval("MasterNo") %>',<%# Eval("Sec") %>,<%# Eval("acct") %>,'<%# Eval("hawb_num")%>')">
                                                        <%# Eval("MasterNo") %>
                                                </td>
                                                <td height="20" style="padding-left: 3px" width="10%">
                                                    <a href="javascript:;" onclick="EditClickFILE('<%# Eval("iType") %>','<%# Eval("file#") %>',<%# Eval("Sec") %>,<%# Eval("acct") %>,'<%# Eval("hawb_num")%>')">
                                                        <%# Eval("file#") %>
                                                </td>
                                                <td height="20" style="padding-left: 3px" width="6%">
                                                    <%# Eval("sec") %>
                                                </td>
                                                <td height="20" style="padding-left: 3px" width="10%">
                                                    <%# Eval("tran_date", "{0:MM/dd/yyyy}")%>
                                                </td>
                                                <td height="20" style="padding-left: 3px" width="13%">
                                                    <a href="javascript:;" onclick="EditClickName('<%# Eval("Shipper_acct")%>')">
                                                        <%# Eval("Shipper_Name")%>
                                                    </a>
                                                </td>
                                                <td height="20" style="padding-left: 3px" width="13%">
                                                    <a href="javascript:;" onclick="EditClickName('<%# Eval("consignee_acct")%>')">
                                                        <%# Eval("consignee_name")%>
                                                    </a>
                                                </td>
                                                <td height="20" style="padding-left: 3px" width="13%">
                                                    <%# Eval("P1") %>
                                                </td>
                                                <td height="20" style="padding-left: 3px" width="13%">
                                                    <%# Eval("P2") %>
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
                <td height="22" colspan="14" align="left" valign="middle" bgcolor="#edd3cf" class="bodycopy">
                    &nbsp;</td>
            </tr>
        </table>
        <p>
            <asp:Button ID="btnValidate" runat="server" Text="for Validation" Visible="False"></asp:Button><asp:LinkButton
                ID="LinkButton3" runat="server" Visible="False">LinkButton</asp:LinkButton><asp:TextBox
                    ID="txtNum" runat="server" Height="1px" Width="1px"></asp:TextBox><!-- end --></p>
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

    <script type="text/javascript">
            if(document.getElementById('Webdatetimeedit2')) {
    			ig_initDropCalendar("CustomDropDownCalendar Webdatetimeedit1 Webdatetimeedit2");
            }
            else
            {
    			ig_initDropCalendar("CustomDropDownCalendar Webdatetimeedit1");            
            }

    </script>

</body>
</html>
