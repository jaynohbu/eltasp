<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ChartOfAccounts.aspx.cs"
    Inherits="ASPX_Accounting_ChartOfAccounts" %>



<%@ Register assembly="Infragistics.WebUI.UltraWebToolbar, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" namespace="Infragistics.WebUI.UltraWebToolbar" tagprefix="igtbar" %>


<%@ Register Assembly="Infragistics.WebUI.WebDataInput, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.WebDataInput" TagPrefix="igtxt" %>

<%@ Register assembly="Infragistics.WebUI.WebNavBar, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" namespace="Infragistics.WebUI.WebNavBar" tagprefix="ignavbar" %>


<%@ Register Assembly="Infragistics.WebUI.UltraWebGrid, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.UltraWebGrid" TagPrefix="igtbl" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Chart of Accounts</title>
    <link type="text/css" rel="stylesheet" href="../CSS/elt_css.css" />
</head>
<body>
    <form id="form1" runat="server">
        <div align="center">
            <igtbl:UltraWebGrid ID="UltraWebGrid1" runat="server" Width="95%"
                OnUpdateGrid="UltraWebGrid1_UpdateGrid" OnInitializeLayout="UltraWebGrid1_InitializeLayout"
                DataSourceID="ObjectDataSource1">
                <Bands>
                    <igtbl:UltraGridBand>
                        <FilterOptions EmptyString="" AllString="" NonEmptyString="">
                            <FilterDropDownStyle BorderWidth="1px" BorderColor="Silver" BorderStyle="Solid" BackColor="White"
                                Width="200px" CustomRules="overflow:auto;" CssClass="bodycopy" />
                            <FilterHighlightRowStyle ForeColor="White" BackColor="#151C55" CssClass="bodycopy" />
                        </FilterOptions>
                        <AddNewRow View="NotSet" Visible="NotSet">
                        </AddNewRow>
                    </igtbl:UltraGridBand>
                </Bands>
                <DisplayLayout BorderCollapseDefault="Separate" RowHeightDefault="20px" SelectTypeRowDefault="Single"
                    RowSizingDefault="Free" ViewType="OutlookGroupBy" AllowAddNewDefault="Yes" AllowDeleteDefault="Yes"
                    AllowUpdateDefault="Yes" SelectTypeCellDefault="Single" SelectTypeColDefault="Single"
                    EnableInternalRowsManagement="True" AllowSortingDefault="OnClient" HeaderClickActionDefault="SortSingle"
                    RowSelectorsDefault="No" Version="4.00">
                    <FrameStyle BorderWidth="1px" BorderStyle="Solid" Width="95%">
                    </FrameStyle>
                    <GroupByBox>
                        <Style BorderColor="Window" BackColor="ActiveBorder" CssClass="bodycopy"></Style>
                    </GroupByBox>
                    <FooterStyleDefault BorderWidth="1px" BorderStyle="Solid" BackColor="LightGray" CssClass="bodycopy">
                        <BorderDetails ColorTop="White" WidthLeft="1px" WidthTop="1px" ColorLeft="White"></BorderDetails>
                    </FooterStyleDefault>
                    <RowStyleDefault Font-Names="Verdana,Arial,Helvetica,Sans-serif" Font-Size="9px"
                        BorderWidth="1px" BorderColor="#888888" BorderStyle="Solid" BackColor="Window"
                        TextOverflow="Ellipsis">
                        <BorderDetails ColorTop="Window" ColorLeft="Window"></BorderDetails>
                        <Padding Left="3px"></Padding>
                    </RowStyleDefault>
                    <FilterOptionsDefault EmptyString="(Empty)" AllString="(All)" NonEmptyString="(NonEmpty)">
                        <FilterDropDownStyle BorderWidth="1px" BorderColor="Silver" BorderStyle="Solid" BackColor="White"
                            Width="200px" CustomRules="overflow:auto;">
                        </FilterDropDownStyle>
                        <FilterHighlightRowStyle ForeColor="White" BackColor="#151C55">
                        </FilterHighlightRowStyle>
                    </FilterOptionsDefault>
                    <HeaderStyleDefault HorizontalAlign="Left" BorderStyle="Solid" BackColor="#CDCDCA"
                        BackgroundImage="/ig_common/Images/Themes/Aero/header_silver_bg_19.jpg" ForeColor="Black"
                        Height="19px">
                    </HeaderStyleDefault>
                    <EditCellStyleDefault BorderWidth="0px" BorderStyle="None">
                    </EditCellStyleDefault>
                    <AddNewBox Hidden="False" Prompt="Click buttons to add new entry, or double click on each cell to edit."
                        ButtonConnectorStyle="Solid" ButtonConnectorColor="ActiveBorder">
                        <Style BorderWidth="3px" BorderStyle="Solid" BackColor="Info" BorderColor="Info"
                            CssClass="bodycopy" />
                        <ButtonStyle VerticalAlign="Middle" Width="100px" BorderStyle="Outset" BorderWidth="1px"
                            Cursor="Hand" ForeColor="#7f3116">
                        </ButtonStyle>
                    </AddNewBox>
                    <Pager AllowPaging="True" StyleMode="QuickPages" QuickPages="10" PageSize="25">
                        <Style BorderWidth="3px" BorderStyle="Solid" BackColor="Info" BorderColor="Info"
                            CssClass="bodycopy" />
                    </Pager>
                    <ActivationObject BorderColor="168, 167, 191">
                    </ActivationObject>
                    <SelectedRowStyleDefault BackColor="#CCEBED">
                    </SelectedRowStyleDefault>
                    <ImageUrls CollapseImage="/ig_common/Images/ig_treeMinus.gif" ExpandImage="/ig_common/Images/ig_treePlus.gif" />
                    <ClientSideEvents AfterRowInsertHandler="UltraWebGrid1_AfterRowInsertHandler" BeforeEnterEditModeHandler="UltraWebGrid1_BeforeEnterEditModeHandler"
                        BeforeRowDeletedHandler="UltraWebGrid1_BeforeRowDeletedHandler" />
                </DisplayLayout>
            </igtbl:UltraWebGrid>
            <ignavbar:WebNavBar ID="WebNavBar1" runat="server" BorderWidth="1px" BackColor="#EDEDED"
                BorderColor="Gainsboro" ForeColor="" ImageDirectory="/ig_common/Images/" Position="Bottom"
                TabIndex="-1" Width="" BorderStyle="Solid" Movable="True" Theme="XpSilver" Height="20px">
                <Extension>
                    <Submit Visible="false" />
                </Extension>
            </ignavbar:WebNavBar>
        </div>
        <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" OnInit="ObjectDataSource1_Init" />
    </form>
</body>
</html>
