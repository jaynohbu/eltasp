<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ChargeItems.aspx.cs" Inherits="ASPX_AirExport_ChargeItems" %>

<%@ Register Assembly="Infragistics.WebUI.UltraWebGrid.ExcelExport, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.UltraWebGrid.ExcelExport" TagPrefix="cc1" %>
<%@ Register Assembly="Infragistics.WebUI.UltraWebGrid, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.UltraWebGrid" TagPrefix="igtbl" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Agent Credit</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" language="javascript" src="../../ASP/ajaxFunctions/ajax.js"></script>

    <script type="text/javascript" src="../../ASP/include/JPED.js"></script>

    <script type="text/javascript">
        
        function resize_table()
        {
            var x,y;
            if (self.innerHeight) // all except Explorer
            {
	            x = self.innerWidth;
	            y = self.innerHeight;
            }
            else if (document.documentElement && document.documentElement.clientHeight)
	            // Explorer 6 Strict Mode
            {
	            x = document.documentElement.clientWidth;
	            y = document.documentElement.clientHeight;
            }
            else if (document.body) // other Explorers
            {
	            x = document.body.clientWidth;
	            y = document.body.clientHeight;
            }
            if(document.getElementById("UltraWebGrid1_main")!=null){
	            document.getElementById("UltraWebGrid1_main").style.height=parseInt(y-
	            document.getElementById("UltraWebGrid1_main").offsetTop - 60)+"px";
	        }	    
        }
        
        window.onresize = resize_table; 
        window.onload = resize_table;
        
        function selectSearchType()
        {
            document.getElementById("lstSearchNum").value = "";
            document.getElementById("hSearchNum").value = "";
        }
        
        function lstSearchNumChange(argV,argL){
            var typeValue = document.getElementById("lstSearchType").value
	        var url = "ChargeItems.aspx?SearchType=" + typeValue + "&SearchNo=" + argV;
            self.window.location.href = encodeURI(url);
        }
        
        function searchNumFill(obj,eType,changeFunction,vHeight){
            var qStr = obj.value;
            var keyCode = window.event.keyCode;
            var typeValue = document.getElementById("lstSearchType").value

            if(qStr != "" && keyCode != 229 && keyCode != 27 && typeValue != ""){
                var url = "/IFF_MAIN/asp/ajaxFunctions/ajax_get_bills.asp?mode=list&export=" + eType + "&qStr=" 
                    + qStr + "&type=" + typeValue;
                FillOutJPED(obj,url,changeFunction,vHeight);
            }
        }
        
        function searchNumFillAll(objName,eType,changeFunction,vHeight){
            var obj = document.getElementById(objName);
            var typeValue = document.getElementById("lstSearchType").value;
            var url;
            
            if(typeValue != "")
            {
                url = "/IFF_MAIN/asp/ajaxFunctions/ajax_get_bills.asp?mode=list&type=" 
                    + typeValue + "&export=" + eType;
                FillOutJPED(obj,url,changeFunction,vHeight);
            }
        }
        
        function setProfitShare(masterBill, houseBill, itemCode){
            var vURL = "./SetProfitSharing.aspx?MAWB=" + masterBill + "&HAWB=" + houseBill + "&ITEM=" + itemCode
            returnArray = showModalDialog(vURL, "PSPOP", 
                "dialogWidth:650px; dialogHeight:550px; help:0; status:1; scroll:0; center:1; Sunken;");
            
            if(returnArray == "Y"){
                window.location.href = window.location.href;
            }
        }
        
    </script>

    <style type="text/css">
        body {
			margin-left: 0px;
			margin-right: 0px;
			margin-bottom: 0px;
		}
    </style>
</head>
<!--  #INCLUDE FILE="../include/common.htm" -->
<body>
    <form id="form1" action="" runat="server">
        <center>
            <div class="pageheader" style="width: 95%; text-align: left">
                Profit Share</div>
            <div class="selectarea" style="width: 95%; text-align: left">
                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td style="height: 15px; width: 200px" valign="top" colspan="2">
                            <span class="select">Select AWB Type and No.</span></td>
                    </tr>
                    <tr>
                        <td style="width: 130px">
                            <asp:DropDownList runat="server" ID="lstSearchType" CssClass="bodyheader" Width="120px"
                                onchange="javascript:selectSearchType();" AutoPostBack="false">
                                <asp:ListItem Value="house">House AWB No.</asp:ListItem>
                                <asp:ListItem Value="master">Master AWB No.</asp:ListItem>
                                <asp:ListItem Value="file">File No.</asp:ListItem>
                            </asp:DropDownList>
                        </td>
                        <td>
                            <!-- Start JPED -->
                            <asp:HiddenField ID="hSearchNum" runat="server" />
                            <div id="lstSearchNumDiv">
                            </div>
                            <table cellpadding="0" cellspacing="0" border="0">
                                <tr>
                                    <td>
                                        <asp:TextBox autocomplete="off" ID="lstSearchNum" runat="server" value="" CssClass="shorttextfield"
                                            Style="width: 150px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                            border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9; color: #000000"
                                            onkeyup="searchNumFill(this,'A','lstSearchNumChange',200);" onfocus="initializeJPEDField(this);" /></td>
                                    <td>
                                        <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="searchNumFillAll('lstSearchNum','A','lstSearchNumChange',200);"
                                            style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                            border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                </tr>
                            </table>
                            <!-- End JPED -->
                        </td>
                    </tr>
                </table>
            </div>
            <div style="width: 95%; text-align: left" class="bodycopy">
                <igtbl:UltraWebGrid ID="UltraWebGrid1" runat="server" Width="100%" OnInitializeLayout="UltraWebGrid1_InitializeLayout"
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
                        AllowSortingDefault="No" HeaderClickActionDefault="NotSet" RowSelectorsDefault="No"
                        Version="4.00" TableLayout="Fixed" AllowColSizingDefault="Free">
                        <FrameStyle BorderWidth="1px" BorderStyle="Solid" Width="100%" BorderColor="#a0829c"
                            Height="100%">
                        </FrameStyle>
                        <GroupByBox Hidden="true">
                            <Style BorderColor="Window" BackColor="#f0e7ef" CssClass="bodycopy"></Style>
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
                        <HeaderStyleDefault HorizontalAlign="Left" BorderStyle="Solid" BackColor="#E5D4E3"
                            ForeColor="Black" Height="19px">
                        </HeaderStyleDefault>
                        <EditCellStyleDefault BorderWidth="0px" BorderStyle="None">
                        </EditCellStyleDefault>
                        <Pager AllowPaging="False" />
                    </DisplayLayout>
                </igtbl:UltraWebGrid>
            </div>
        </center>
        <cc1:UltraWebGridExcelExporter ID="UltraWebGridExcelExporter1" runat="server">
        </cc1:UltraWebGridExcelExporter>
    </form>
</body>
</html>
