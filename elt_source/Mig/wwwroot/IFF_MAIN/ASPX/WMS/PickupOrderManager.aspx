<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PickupOrderManager.aspx.cs" Inherits="ASPX_WMS_PickupOrderManager" %>
<%@ Register Assembly="Infragistics.WebUI.UltraWebGrid, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.UltraWebGrid" TagPrefix="igtbl" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Untitled Page</title>
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        .style8 {color: #cc6600;
            font-weight: bold;
        }
        body {
            margin-top: 0px;
	        margin-left: 0px;
	        margin-right: 0px;
	        margin-bottom: 0px;
        }
        .style9 {color: #999999}
        .style10 {color: #cc6600}
    </style>

    <!--  #INCLUDE FILE="../include/common.htm" -->
</head>
<body>
    <form id="form1" runat="server">
        <center>
            <table cellpadding="0" cellspacing="0" border="0" style="width: 95%">
                <tr>
                    <td class="pageheader" style="text-align: left">
                        Pickup Order Manager
                    </td>
                    <td>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: left; vertical-align: bottom">
                    </td>
                    <td id="print" style="text-align: right">
                        <a href="/IFF_MAIN/ASP/pre_shipment/pickup_order.asp">
                            <img src="../../ASP/Images/icon_createhouse.gif" style="border: none 0px; margin-right: 10px"
                                alt="" />Create Pickup Order</a>
                    </td>
                </tr>
            </table>
            <asp:Label runat="server" ID="txtResultBox" Width="95%" Visible="false" />
            <igtbl:UltraWebGrid ID="UltraWebGrid1" runat="server" Width="95%"
                OnInitializeLayout="UltraWebGrid1_InitializeLayout" DataSourceID="SqlDataSource1"
                OnInitializeRow="UltraWebGrid1_InitializeRow">
                <Bands>
                    <igtbl:UltraGridBand>
                        <FilterOptions EmptyString="" AllString="" NonEmptyString="">
                            <FilterDropDownStyle BorderWidth="1px" BorderColor="Silver" BorderStyle="Solid" BackColor="White"
                                Width="200px" CssClass="bodycopy" />
                            <FilterHighlightRowStyle ForeColor="White" BackColor="#151C55" CssClass="bodycopy" />
                        </FilterOptions>
                        <Columns>
                            <igtbl:TemplatedColumn Width="41" AllowGroupBy="No" SortIndicator="Disabled">
                                <HeaderStyle Cursor="Auto" />
                                <CellTemplate>
                                    <asp:ImageButton ID="btnEdit" ImageUrl="../../ASP/Images/button_edit.gif" runat="server"
                                        OnClick="btnEdit_Click" CommandName="Edit" CommandArgument="<%#Container.Cell.Row.Index %>" />
                                </CellTemplate>
                            </igtbl:TemplatedColumn>
                        </Columns>
                    </igtbl:UltraGridBand>
                </Bands>
                <DisplayLayout Name="UltraWebGrid1" BorderCollapseDefault="Separate" RowHeightDefault="20px"
                    SelectTypeRowDefault="None" RowSizingDefault="Free" ViewType="OutlookGroupBy"
                    SelectTypeCellDefault="None" SelectTypeColDefault="None" EnableInternalRowsManagement="True"
                    AllowSortingDefault="Yes" HeaderClickActionDefault="SortSingle" RowSelectorsDefault="No"
                    Version="4.00" TableLayout="Fixed" AllowColSizingDefault="Free" ScrollBarView="Horizontal">
                    <FrameStyle BorderWidth="1px" BorderStyle="Solid" Width="95%" BorderColor="#9e816e" TextOverflow="Ellipsis">
                    </FrameStyle>
                    <GroupByBox>
                        <Style BorderColor="Window" BackColor="#f4e9e0" CssClass="bodycopy"></Style>
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
                    <HeaderStyleDefault HorizontalAlign="Left" BorderStyle="Solid" BackColor="#e5cfbf"
                        ForeColor="Black" Height="19px" Cursor="Hand">
                    </HeaderStyleDefault>
                    <EditCellStyleDefault BorderWidth="0px" BorderStyle="None">
                    </EditCellStyleDefault>
                    <Pager AllowPaging="True" StyleMode="PrevNext" QuickPages="3" PageSize="20" Alignment="Center">
                        <Style BorderWidth="3px" BorderStyle="Solid" BackColor="#f4e9e0" BorderColor="#f4e9e0"
                            CssClass="bodycopy" />
                    </Pager>
                </DisplayLayout>
            </igtbl:UltraWebGrid>
        </center>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" OnInit="SqlDataSource1_Init"></asp:SqlDataSource>
        <br />
        <br />
    </form>
</body>
</html>

