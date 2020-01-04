<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AirImportSearch.aspx.cs"
    Inherits="ASPX_Search_AirImportSearch" %>
<%@ Register Assembly="Infragistics.WebUI.UltraWebGrid.ExcelExport, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.UltraWebGrid.ExcelExport" TagPrefix="cc1" %>
<%@ Register Assembly="Infragistics.WebUI.UltraWebGrid, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.UltraWebGrid" TagPrefix="igtbl" %>
<%@ Register TagPrefix="igtbl" Namespace="Infragistics.WebUI.UltraWebGrid" Assembly="Infragistics.WebUI.UltraWebGrid, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Search</title> 

    <script src="/IFF_MAIN/ASPX/jScripts/ig_editDrop1.js" type="text/javascript"></script>

    <link href="../CSS/AppStyle.css" rel="stylesheet" type="text/css" />
    
    <link href="../CSS/elt_css.css" rel="stylesheet" type="text/css" />

    <script src="/ASP/ajaxFunctions/ajax.js" type="text/javascript"></script>

    <script src="/ASP/Include/JPED.js" type="text/javascript"></script>

    <script src="/ASP/Include/JPTableDOM.js" type="text/javascript"></script>

    <script type="text/javascript">
    
        function openWindowFromSearch(url){
            window.open(url, "popUpWindow", "menubar=0,toolbar=0,hotkeys=1,status=1,location=0,scrollbars=1,resizable=1,width=900,height=600");
        }
        
        function lstShipperNameChange(orgNum,orgName)
        {
            var hiddenObj = document.getElementById("hShipperAcct");
            var txtObj = document.getElementById("lstShipperName");
            var divObj = document.getElementById("lstShipperNameDiv")
    
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
                url = "/ASP/ajaxFunctions/ajax_get_international_mawb_list.asp?mode=AI&qStr=" + qStr;
                FillOutJPED(obj,url,changeFunction,vHeight);
            }
        }
        
        function searchNumFillAll(objName,changeFunction,vHeight){
            var obj = document.getElementById(objName);
                url = "/ASP/ajaxFunctions/ajax_get_international_mawb_list.asp?mode=AI";
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
        
        function EditClickName(org_No){
            url = "/ASP/master_data/client_profile.asp?Action=filter&n=" + org_No + "&WindowName=popUpWindow";
            openWindowFromSearch(url);
		}
		
        function EditClick(iType,MAWB,Sec,AgentOrgAcct,HAWB){
            url = "/ASP/air_import/arrival_notice.asp?iType=" + iType + "&Edit=yes&AgentOrgAcct=" + AgentOrgAcct 
            + "&MAWB=" + encodeURIComponent(MAWB) + "&HAWB=" + encodeURIComponent(HAWB) + "&Sec=" + Sec;
            openWindowFromSearch(url);
        }	
				
        function EditClickMAWB(iType,MAWB,Sec,AgentOrgAcct){
            url = "/ASP/air_import/air_import2.asp?iType=" + iType + "&Edit=yes&MAWB=" + encodeURIComponent(MAWB) 
            + "&Sec=" + Sec + "&AgentOrgAcct=" + AgentOrgAcct + "&WindowName=popUpWindow";
            openWindowFromSearch(url);
        }
        
        function EditClickFILE(iType,FILE){
            url = "/ASP/air_import/air_import2.asp?iType=" + iType + "&Edit=yes&JOB=" + encodeURIComponent(FILE) + "&WindowName=popUpWindow";
            openWindowFromSearch(url);
        }
        
        function lstSearchType_Change(){

            if(document.getElementById("lstSearchType").value == "house"){
                document.getElementById("MasterFilter").style.position = "absolute";
                document.getElementById("MasterFilter").style.visibility = "hidden";
                document.getElementById("HouseFilter").style.position = "static";
                document.getElementById("HouseFilter").style.visibility = "visible";
            }
            if(document.getElementById("lstSearchType").value == "master"){
                document.getElementById("MasterFilter").style.position = "static";
                document.getElementById("MasterFilter").style.visibility = "visible";
                document.getElementById("HouseFilter").style.position = "absolute";
                document.getElementById("HouseFilter").style.visibility = "hidden";
            }
        }
        
    </script>

     <script src="/Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
    <script src="/Scripts/jquery-ui-1.8.20.min.js" type="text/javascript"></script>
    <script src="/Scripts/jquery.plugin.period.js" type="text/javascript"></script>
     <link href="/Scripts/jquery-ui-1.10.3/themes/base/jquery-ui.css"
        rel="stylesheet" type="text/css" />
    <script type="text/javascript">

        $(document).ready(function () {
            $("#Webdatetimeedit1").datepicker();
            $("#Webdatetimeedit2").datepicker();
            $("#ddlPeriod").PeriodList({ StartDateField: $("#Webdatetimeedit1").get(0), EndDateField: $("#Webdatetimeedit2").get(0) });
        });
    </script>
    <!--  #INCLUDE FILE="../include/common.htm" -->
</head>
<body style="margin: 0px 0px 0px 0px">
    <form id="form1" runat="server">
        <div align="center">
            <table cellpadding="0" cellspacing="0" border="0" style="width: 95%">
                <tr>
                    <td class="pageheader" style="text-align: left">
                        Search
                    </td>
                    <td>
                    </td>
                </tr>
            </table>
            <table cellpadding="0" cellspacing="0" border="0" style="width: 95%; border-color: #ba9590"
                class="border1px">
                <tr>
                    <td style="height: 8px; background-color: #edd3cf">
                    </td>
                </tr>
                <tr>
                    <td style="height: 1px; background-color: #ba9590">
                    </td>
                </tr>
                <tr>
                    <td align="center">
                        <br />
                        <table cellpadding="2" cellspacing="2" border="0" style="width: 700px; text-align: left;
                            background-color: #dddddd; border: solid 1px #aaaaaa">
                            <tr>
                                <td>
                                    <asp:DropDownList runat="server" ID="lstSearchType" Width="150px" AutoPostBack="false"
                                        onChange="lstSearchType_Change()">
                                        <asp:ListItem Text="House AWB No." Value="house" />
                                        <asp:ListItem Text="Master AWB No." Value="master" />
                                    </asp:DropDownList>
                                </td>
                                <td>
                                 <asp:DropDownList CssClass="bodycopy" Width="218px" runat="server" ID="ddlPeriod" />
                                </td>
                                <td colspan="2">
                                    <table cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td>
                                                 <asp:TextBox runat="server" ID="Webdatetimeedit1"></asp:TextBox>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                                <td>
                                    <table cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td>
                                                 <asp:TextBox runat="server" ID="Webdatetimeedit2"></asp:TextBox>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                        <br />
                        <table cellpadding="2" cellspacing="2" border="0" style="width: 700px; text-align: left;
                            background-color: #eeeeee; border: solid 1px #aaaaaa">
                            <tr class="bodyheader">
                                <td>
                                    MAWB No.</td>
                                <td>
                                    File no.</td>
                            </tr>
                            <tr>
                                <td>
                                    <table cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td>
                                                <asp:HiddenField ID="hSearchNum" runat="server" Value="" />
                                                <div id="lstSearchNumDiv">
                                                </div>
                                                <asp:TextBox ID="lstSearchNum" runat="server" autocomplete="off" class="shorttextfield"
                                                    Style="width: 110px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                    border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9; color: Black"
                                                    onkeyup=" searchNumFill(this,'lstSearchNumChange','');" onfocus="initializeJPEDField(this,event);"></asp:TextBox></td>
                                            <td style="width: 16px">
                                                <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="searchNumFillAll('lstSearchNum','lstSearchNumChange',200);"
                                                    style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                    border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                            <td>
                                                <span style="margin-left: 10px; margin-right: 10px">
                                                    <asp:TextBox ID="txtlast" runat="server" CssClass="m_shorttextfield" Width="50px"></asp:TextBox>
                                                </span>
                                            </td>
                                            <td>
                                                <span class="bodyheader">Last 4 Digits/Letters</span></td>
                                        </tr>
                                    </table>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtFileNo" runat="server" CssClass="m_shorttextfield" Width="120px"></asp:TextBox>
                                </td>
                            </tr>
                            <tr class="bodyheader">
                                <td>
                                    Departure Port</td>
                                <td>
                                    Destination Port</td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:DropDownList CssClass="bodycopy" Width="218px" runat="server" ID="OriginPortSelect" />
                                </td>
                                <td>
                                    <asp:DropDownList CssClass="bodycopy" Width="218px" runat="server" ID="DestPortSelect" />
                                </td>
                            </tr>
                            <tr class="bodyheader">
                                <td>
                                    Shipper</td>
                                <td>
                                    Consignee</td>
                            </tr>
                            <tr>
                                <td>
                                    <!-- Start JPED -->
                                    <asp:HiddenField runat="Server" ID="hShipperAcct" Value="" />
                                    <div id="lstShipperNameDiv">
                                    </div>
                                    <table cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                            <td>
                                                <asp:TextBox runat="server" autocomplete="off" ID="lstShipperName" name="lstShipperName"
                                                    value="" class="shorttextfield" Style="width: 200px; border-top: 1px solid #7F9DB9;
                                                    border-bottom: 1px solid #7F9DB9; border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;
                                                    color: #000000" onKeyUp="organizationFill(this,'Shipper','lstShipperNameChange')"
                                                    onfocus="initializeJPEDField(this,event);" /></td>
                                            <td>
                                                <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstShipperName','shipper','lstShipperNameChange')"
                                                    style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                    border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                        </tr>
                                    </table>
                                    <!-- End JPED -->
                                </td>
                                <td>
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
                                                    onfocus="initializeJPEDField(this,event);" /></td>
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
                            <tr class="bodyheader">
                                <td>
                                    Number of Pieces
                                </td>
                                <td>
                                    Sales Person</td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:TextBox ID="NoPiece" runat="server" CssClass="m_shorttextfield" Width="120px"
                                        Style="behavior: url(/ASP/include/igNumDotChkLeft.htc)"></asp:TextBox>
                                </td>
                                <td>
                                    <asp:DropDownList CssClass="bodycopy" Width="150px" runat="server" ID="SaleDroplist" /></td>
                            </tr>
                        </table>
                        <br />
                        <asp:Panel runat="server" ID="HouseFilter">
                            <table cellpadding="2" cellspacing="2" border="0" style="width: 700px; text-align: left;
                                background-color: #eeeeee; border: solid 1px #aaaaaa">
                                <tr class="bodyheader">
                                    <td>
                                        House AWB No.</td>
                                    <td>
                                        LC No.</td>
                                    <td>
                                        CI No.</td>
                                    <td>
                                        Other Reference No.</td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:TextBox ID="txtHouseNo" runat="server" CssClass="shorttextfield" Width="150px" /></td>
                                    <td>
                                        <asp:TextBox ID="LCNO" runat="server" CssClass="m_shorttextfield" Width="120px" />
                                    </td>
                                    <td>
                                        <asp:TextBox ID="CINO" runat="server" CssClass="m_shorttextfield" Width="120px" />
                                    </td>
                                    <td>
                                        <asp:TextBox ID="OTH_REF_NO" runat="server" CssClass="m_shorttextfield" Width="120px" />
                                    </td>
                                </tr>
                            </table>
                        </asp:Panel>
                        <asp:Panel runat="server" ID="MasterFilter">
                        </asp:Panel>
                        <table cellpadding="2" cellspacing="2" border="0" style="width: 700px; text-align: left">
                            <tr>
                                <td colspan="5" style="text-align: right">
                                    <asp:ImageButton runat="server" ImageUrl="../../Images/button_go.gif" ID="btnGo"
                                        OnClick="btnGo_Click" /></td>
                            </tr>
                        </table>
                        <table cellpadding="0" cellspacing="0" border="0" style="width: 98%; text-align: left">
                            <tr>
                                <td>
                                    <asp:Label runat="server" ID="txtResultBox" CssClass="bodycopy" /></td>
                                <td style="text-align: right">
                                    <asp:ImageButton ID="btnExcelExport" runat="server" ImageUrl="/ASP/images/button_exel.gif"
                                        OnClick="btnExcelExport_Click" Visible="false" /></td>
                            </tr>
                        </table>
                        <igtbl:UltraWebGrid ID="UltraWebGrid1" runat="server" Width="95%" OnInitializeLayout="UltraWebGrid1_InitializeLayout"
                            OnInitializeRow="UltraWebGrid1_InitializeRow">
                            <Bands>
                                <igtbl:UltraGridBand>
                                    <FilterOptions EmptyString="" AllString="" NonEmptyString="">
                                        <FilterDropDownStyle BorderWidth="1px" BorderColor="Silver" BorderStyle="Solid" BackColor="White"
                                            Width="200px" CssClass="bodycopy" />
                                        <FilterHighlightRowStyle ForeColor="White" BackColor="#151C55" CssClass="bodycopy" />
                                    </FilterOptions>
                                </igtbl:UltraGridBand>
                            </Bands>
                            <DisplayLayout Name="UltraWebGrid1" BorderCollapseDefault="Separate" RowHeightDefault="20px"
                                SelectTypeRowDefault="None" RowSizingDefault="Free" ViewType="OutlookGroupBy"
                                SelectTypeCellDefault="None" SelectTypeColDefault="None" EnableInternalRowsManagement="True"
                                AllowSortingDefault="Yes" HeaderClickActionDefault="SortSingle" RowSelectorsDefault="No"
                                Version="4.00" TableLayout="Fixed" AllowColSizingDefault="Free" ScrollBarView="Horizontal">
                                <FrameStyle BorderWidth="1px" BorderStyle="Solid" Width="98%" BorderColor="#aaaaaa"
                                    TextOverflow="Ellipsis">
                                </FrameStyle>
                                <GroupByBox >
                                    <Style BorderColor="Window" BackColor="#cccccc" CssClass="bodycopy" Height="25px"></Style>
                                </GroupByBox>
                                <FooterStyleDefault BorderWidth="1px" BorderStyle="Solid" BackColor="LightGray" CssClass="bodycopy">
                                    <BorderDetails ColorTop="White" WidthLeft="1px" WidthTop="1px" ColorLeft="White"></BorderDetails>
                                </FooterStyleDefault>
                                <RowStyleDefault Font-Names="Verdana,Arial,Helvetica,Sans-serif" Font-Size="9px"
                                    BorderWidth="1px" BorderColor="#bcbcbc" BorderStyle="Solid" BackColor="Window"
                                    TextOverflow="Ellipsis">
                                    <BorderDetails ColorTop="Window" ColorLeft="Window"></BorderDetails>
                                    <Padding Left="3px"></Padding>
                                </RowStyleDefault>
                                <FilterOptionsDefault EmptyString="(Empty)" AllString="(All)" NonEmptyString="(NonEmpty)">
                                    <FilterDropDownStyle BorderWidth="1px" BorderColor="Silver" BorderStyle="Solid" BackColor="White"
                                        Width="200px">
                                    </FilterDropDownStyle>
                                    <FilterHighlightRowStyle ForeColor="White" BackColor="#151C55">
                                    </FilterHighlightRowStyle>
                                </FilterOptionsDefault>
                                <HeaderStyleDefault HorizontalAlign="Left" BorderStyle="Solid" BackColor="#dddddd"
                                    ForeColor="Black" Height="19px" Cursor="Hand">
                                </HeaderStyleDefault>
                                <EditCellStyleDefault BorderWidth="0px" BorderStyle="None">
                                </EditCellStyleDefault>
                                <Pager AllowPaging="True" StyleMode="PrevNext" PageSize="100" Alignment="Center" PagerAppearance="Both">
                                    <Style BorderWidth="3px" BorderStyle="Solid" BackColor="#eeeeee" BorderColor="#eeeeee"
                                        CssClass="bodycopy" Height="25px" />
                                </Pager>
                            </DisplayLayout>
                        </igtbl:UltraWebGrid>
                        <br />
                    </td>
                </tr>
                <tr>
                    <td style="height: 1px; background-color: #ba9590">
                    </td>
                </tr>
                <tr>
                    <td style="height: 25px; background-color: #edd3cf">
                    </td>
                </tr>
            </table>
        </div>
        <cc1:UltraWebGridExcelExporter ID="UltraWebGridExcelExporter1" runat="server">
        </cc1:UltraWebGridExcelExporter>
        <br />
        <br />
        <br />
        <div>
            
        </div>
    </form>
</body>

<script type="text/javascript">
   
    lstSearchType_Change();
</script>

<!--  #INCLUDE FILE="../include/StatusFooter.htm" -->
</html>
