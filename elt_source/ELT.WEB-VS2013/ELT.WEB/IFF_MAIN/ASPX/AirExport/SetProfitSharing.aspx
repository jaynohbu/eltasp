<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SetProfitSharing.aspx.cs"
    Inherits="ASPX_AirExport_SetProfitSharing" %>

<%@ Register Assembly="Infragistics.WebUI.UltraWebGrid, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.UltraWebGrid" TagPrefix="igtbl" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Agent Credit</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link href="/IFF_MAIN/ASPX/CSS/elt_css.css" rel="stylesheet" type="text/css" />
    <base target="_self" />

    <script type="text/javascript" language="javascript" src="/ASP/ajaxFunctions/ajax.js"></script>

    <script type="text/javascript" src="/ASP/include/JPED.js"></script>

    <script type="text/javascript">
    
        function CalculateRate(vRate)
        {
            var vItemAmount = document.getElementById("txtItemAmt").value;
            document.getElementById("txtCostAmt").value = (vItemAmount * vRate).toFixed(2);
        }
        
        function lstCostItemChange(vValue,vLabel)
        {
            if(vValue != "") {
                var hiddenObj = document.getElementById("hCostItem");
                var divObj = document.getElementById("lstCostItemDiv");
                
                hiddenObj.value = vValue;
                getCostItemInfo(vValue,vLabel);
                
                try{
                    divObj.style.position = "absolute";
                    divObj.style.visibility = "hidden";
                }catch(err){}
            }
        }
        
        function getCostItemInfo(arg1,arg2){
            var url = "/ASP/ajaxFunctions/ajax_account_payable.asp?mode=CostItemInfo&cid=" + arg1
            new ajax.xhr.Request('GET','',url,displayCostItem,arg2,null,null);
        }
        
        function displayCostItem(req,v1,v2,v3,v4,url)
        {
            if (req.readyState == 4)
            {   
		        if (req.status == 200)
		        {
		            try{
		                var xmlObj = req.responseXML;
		                
		                setField("item_desc", "lstCostItem", xmlObj);
		                
                    }catch(error)
                    {
                        alert(error.description);
                        xmlObj = null;
                    }
                    xmlObj = null;
		        }
		    }
		}
        
        function setField(xmlTag,htmlTag,xmlObj)
        {
            if(xmlObj.getElementsByTagName(xmlTag)[0] != null && xmlObj.getElementsByTagName(xmlTag)[0].childNodes[0] != null)
            {
                document.getElementById(htmlTag).value = xmlObj.getElementsByTagName(xmlTag)[0].childNodes[0].nodeValue;
            }
            else
            {
                document.getElementById(htmlTag).value = "";
            }
        }
        
        window.onunload = function(){
            window.returnValue = document.getElementById("hSaved").value;
        };
        
        window.onload = function(){
            if(document.getElementById("hSaved").value == "Y"){
                window.close();
            }
        };
        
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
    <form id="form1" runat="server">
        <center>
            <asp:HiddenField ID="hSaved" runat="server" Value="N" />
            <div style="width: 95%; text-align: left" class="pageheader">
                Profit Sharing</div>
            <div style="width: 95%; text-align: left" class="bodycopy">
                <table cellpadding="2" cellspacing="0" border="0" class="bodycopy" style="width: 100%">
                    <tr>
                        <td>
                            Master AWB:
                        </td>
                        <td>
                            <asp:TextBox ID="txtMAWB" runat="server" CssClass="d_shorttextfield" ReadOnly="true" /></td>
                        <td>
                            House AWB:
                        </td>
                        <td>
                            <asp:TextBox ID="txtHAWB" runat="server" CssClass="d_shorttextfield" ReadOnly="true" /></td>
                    </tr>
                    <tr>
                        <td>
                            Departure:
                        </td>
                        <td>
                            <asp:TextBox ID="txtFrom" runat="server" CssClass="d_shorttextfield" ReadOnly="true"
                                Width="40px" /></td>
                        <td>
                            Destination:
                        </td>
                        <td>
                            <asp:TextBox ID="txtTo" runat="server" CssClass="d_shorttextfield" ReadOnly="true"
                                Width="40px" /></td>
                    </tr>
                    <tr>
                        <td>
                            Carrier:
                        </td>
                        <td>
                            <asp:TextBox ID="txtCarrierDesc" runat="server" CssClass="d_shorttextfield" ReadOnly="true"
                                Width="200px" /></td>
                        <td>
                            Carrier Code:
                        </td>
                        <td>
                            <asp:TextBox ID="txtCarrierCode" runat="server" CssClass="d_shorttextfield" ReadOnly="true"
                                Width="40px" /></td>
                    </tr>
                    <tr>
                        <td>
                            Charge Item:
                        </td>
                        <td>
                            <asp:TextBox ID="txtItemName" runat="server" CssClass="d_shorttextfield" ReadOnly="true"
                                Width="200px" /></td>
                        <td>
                            Charge Amount:
                        </td>
                        <td>
                            <asp:TextBox ID="txtItemAmt" runat="server" CssClass="d_shorttextfield" ReadOnly="true"
                                Width="70px" /></td>
                    </tr>
                    <tr>
                        <td>
                            Weight:
                        </td>
                        <td>
                            <asp:TextBox ID="txtWeight" runat="server" CssClass="shorttextfield" Width="70px" /></td>
                        <td>
                            Scale:
                        </td>
                        <td>
                            <asp:TextBox ID="txtWeightScale" runat="server" CssClass="d_shorttextfield" ReadOnly="true"
                                Width="20px" /></td>
                    </tr>
                    <tr>
                        <td>
                            Agent:
                        </td>
                        <td>
                            <asp:DropDownList ID="lstCustomer" runat="server" CssClass="bodycopy" Width="250px">
                            </asp:DropDownList><asp:RequiredFieldValidator ID="rqfv_lstCustomer" runat="server"
                                Text="*" ControlToValidate="lstCustomer" /></td>
                        <td>
                            Rate Type:
                        </td>
                        <td>
                            <asp:DropDownList ID="lstRateType" runat="server" CssClass="bodycopy">
                                <asp:ListItem Value="1" Selected="True">Agent Buying</asp:ListItem>
                                <asp:ListItem Value="3">Airline Buying</asp:ListItem>
                                <asp:ListItem Value="4">Customer Selling</asp:ListItem>
                                <asp:ListItem Value="5">IATA</asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right" colspan="4">
                            <asp:Button ID="btnGetRateList" runat="Server" OnClick="btnGetRateList_Click" Text="Get Rate Table"
                                CssClass="bodycopy" Width="100px" /></td>
                    </tr>
                </table>
                <asp:TextBox ID="txtItem" runat="server" Visible="false" />
            </div>
            <br />
            <div style="width: 95%; text-align: left" class="bodycopy">
                <igtbl:UltraWebGrid ID="UltraWebGrid1" runat="server" OnInitializeLayout="UltraWebGrid1_InitializeLayout"
                    OnInitializeRow="UltraWebGrid1_InitializeRow">
                    <DisplayLayout Name="UltraWebGrid1" BorderCollapseDefault="Separate" RowHeightDefault="20px"
                        SelectTypeRowDefault="None" RowSizingDefault="Free" ViewType="OutlookGroupBy"
                        SelectTypeCellDefault="None" SelectTypeColDefault="None" EnableInternalRowsManagement="True"
                        AllowSortingDefault="No" HeaderClickActionDefault="NotSet" RowSelectorsDefault="No"
                        Version="4.00" TableLayout="Fixed" AllowColSizingDefault="Free">
                        <FrameStyle BorderWidth="1px" BorderStyle="Solid" BorderColor="#a0829c" Height="130px"
                            Width="100%">
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
                        <HeaderStyleDefault HorizontalAlign="Left" BorderStyle="Solid" BackColor="#E5D4E3"
                            ForeColor="Black" Height="19px">
                        </HeaderStyleDefault>
                        <EditCellStyleDefault BorderWidth="0px" BorderStyle="None">
                        </EditCellStyleDefault>
                        <Pager AllowPaging="False" StyleMode="PrevNext" QuickPages="3" PageSize="25" Alignment="Center">
                            <Style BorderWidth="3px" BorderStyle="Solid" BackColor="#f0e7ef" BorderColor="#f0e7ef"
                                CssClass="bodycopy" />
                        </Pager>
                    </DisplayLayout>
                </igtbl:UltraWebGrid>
            </div>
            <br />
            <div style="width: 95%; text-align: left; height: 300px" class="bodycopy">
                <table cellpadding="2" cellspacing="0" border="0" class="bodycopy" style="width: 100%">
                    <tr>
                        <td>
                            Cost Item:
                        </td>
                        <td>
                            <!-- Start JPED -->
                            <asp:HiddenField ID="hCostItem" runat="server" Value="" />
                            <div id="lstCostItemDiv">
                            </div>
                            <table cellpadding="0" cellspacing="0" border="0">
                                <tr>
                                    <td>
                                        <asp:TextBox autocomplete="off" ID="lstCostItem" runat="server" CssClass="shorttextfield"
                                            Style="width: 250px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                            border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9;" onkeyup="GLItemFill(this,'ItemCostNameDesc','lstCostItemChange',100)"
                                            onfocus="initializeJPEDField(this,event);" /></td>
                                    <td>
                                        <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="GLItemFillAll('lstCostItem','ItemCostNameDesc','lstCostItemChange',100)"
                                            style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                            border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                    <td>
                                    </td>
                                </tr>
                            </table>
                            <!-- End JPED -->
                        </td>
                        <td>
                            Amount:
                        </td>
                        <td>
                            <asp:TextBox ID="txtCostAmt" runat="Server" CssClass="shorttextfield" Width="70px" />
                        </td>
                        <td style="text-align: right">
                            <asp:Button ID="btnSave" runat="Server" OnClick="btnSave_Click" Text="Save Item"
                                CssClass="bodycopy" Width="100px" /></td>
                    </tr>
                </table>
            </div>
        </center>
    </form>
</body>
</html>
