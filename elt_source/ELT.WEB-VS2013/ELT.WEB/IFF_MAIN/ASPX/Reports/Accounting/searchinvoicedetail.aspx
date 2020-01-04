<%@ Page Language="c#" Inherits="IFF_MAIN.ASPX.Reports.Accounting.SearchInvoiceDetail"
    CodeFile="SearchInvoiceDetail.aspx.cs" %>

<%@ Register TagPrefix="igtbar" Namespace="Infragistics.WebUI.UltraWebToolbar" Assembly="Infragistics.WebUI.UltraWebToolbar, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igtbl" Namespace="Infragistics.WebUI.UltraWebGrid" Assembly="Infragistics.WebUI.UltraWebGrid, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="cc1" Namespace="Infragistics.WebUI.UltraWebGrid.ExcelExport"
    Assembly="Infragistics.WebUI.UltraWebGrid.ExcelExport, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<html>
<head>
    <title>AccountingDetail</title>
    <meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
    <meta content="C#" name="CODE_LANGUAGE">
    <meta content="JavaScript" name="vs_defaultClientScript">
    <meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">

    <script language="javascript">
        function goBack() {
            var a = '<%=ViewState["Count"]%>';

            if (history.length >= a) {
                a = -1 * a;
                history.go(a);
            }
            else {
                location.replace('SearchInvoiceSelection.aspx')
            }
        }
        function formRest(tr, id) {
            var idText = id.Key

            if (idText == 'Reset') {
                __doPostBack("btnReset", "");
                return true;
            }
            else if (idText == 'Back') {
                goBack();
                return true;
            }
            else if (idText == 'Hide') {
                __doPostBack("butHideCol", "");
                return true;
            }
            else if (idText == 'Asce') {
                __doPostBack("btnSortAsce", "");
            }
            else if (idText == 'Desc') {
                __doPostBack("btnSortDesc", "");
            }
            else if (idText == 'Excel') {
                __doPostBack("btnExcel", "");
            }
            else if (idText == 'XML') {
                __doPostBack("btnXML", "");
            }

        }


        var igS;
        function acuh(tableName, itemName) {
            var cell = igtbl_getElementById(itemName);
            cell.innerHTML = igS;
        }

        function bcuh(tableName, itemName) {
            var cell = igtbl_getElementById(itemName);
            igS = cell.innerHTML;
        }

        function ExpandAllRows(btnEl) {
            // Loop thru the rows of Band 0 and expand each one
            var oGrid = oUltraWebGrid1;
            var oBands = oGrid.Bands;
            var oBand = oBands[0];
            var oColumns = oBand.Columns;
            var count = oColumns.length;
            var oRows = oGrid.Rows;
            oGrid.suspendUpdates(true);
            for (i = 0; i < oRows.length; i++) {
                oRow = oRows.getRow(i);
                if (btnEl.value == "Expand All") {
                    oRow.setExpanded(true);
                }
                else {
                    oRow.setExpanded(false);
                }
            }
            oGrid.suspendUpdates(false);
            if (btnEl.value == "Expand All")
                btnEl.value = "Collapse All";
            else
                btnEl.value = "Expand All";
        }

        function resetFind() {
            var btnEl = igtbl_getElementById("Find");
            btnEl.value = "Find";
        }

        function FindValue(btnEl) {
            var eVal = igtbl_getElementById("FindVal");
            findValue = eVal.value;
            var re = new RegExp("^" + findValue, "gi");
            if (btnEl.value == "Find") {
                igtbl_clearSelectionAll(oUltraWebGrid1.Id)
                var oCell = oUltraWebGrid1.find(re);
                if (oCell != null) {
                    btnEl.value = "Find Next";
                    var row = oCell.Row.ParentRow;
                    while (row != null) {
                        row.setExpanded(true);
                        row = row.ParentRow;
                    }
                    oCell.setSelected(true);
                }
                else {
                    alert("Not found! : " + findValue)
                }
            }
            else {
                var oCell = oUltraWebGrid1.findNext();
                if (oCell == null) {
                    btnEl.value = "Find";
                }
                else {
                    var row = oCell.Row.ParentRow;
                    while (row != null) {
                        row.setExpanded(true);
                        row = row.ParentRow;
                    }
                    oCell.setSelected(true);
                }
            }
        }
	
	
    </script>
    <link href="/IFF_MAIN/ASPX/CSS/AppStyle.css" type="text/css" rel="stylesheet">
    <!--  #INCLUDE FILE="../../include/common.htm" -->
</head>
<body>
    <form id="form1" method="post" runat="server">
    <table id="Table2" style="width: 100%;" cellspacing="0" cellpadding="0" bgcolor="#ffffff">
        <tr>
            <td style="height: 2px">
            </td>
            <td align="left" style="width: 20px; height: 2px" valign="middle">
            </td>
            <td style="height: 2px" valign="middle" align="left">
                <asp:Label ID="Label1" runat="server" Width="100%" Height="8px" DESIGNTIMEDRAGDROP="9087"
                    Font-Size="Larger" ForeColor="Black" Font-Bold="True"> Search Invoice</asp:Label>
            </td>
            <td style="width: 2px; height: 2px">
            </td>
        </tr>
        <tr>
            <td style="height: 10px">
            </td>
            <td bgcolor="#d5e8cb" style="width: 20px; height: 10px">
            </td>
            <td style="height: 10px" bgcolor="D5E8CB">
            </td>
            <td style="width: 2px; height: 4px">
            </td>
        </tr>
        <tr>
            <td style="height: 1px">
            </td>
            <td bgcolor="whitesmoke" style="width: 20px; height: 1px" valign="top">
            </td>
            <td style="height: 1px" valign="top" bgcolor="whitesmoke">
                <asp:Label ID="Label2" runat="server" Font-Bold="True" ForeColor="Navy" Font-Size="10px"
                    DESIGNTIMEDRAGDROP="9087" Height="8px" Font-Italic="True" Width="100%"></asp:Label><asp:Label
                        ID="lblNoData" runat="server" Width="100%" Font-Italic="True" ForeColor="Navy"
                        Font-Bold="True" Font-Underline="True">...</asp:Label>
            </td>
            <td style="width: 2px; height: 1px">
            </td>
        </tr>
        <tr>
            <td height="5">
            </td>
            <td bgcolor="#d5e8cb" height="10" style="width: 20px" valign="top">
            </td>
            <td valign="top" bgcolor="D5E8CB" height="10px">
                <font face="±¼¸²"></font>
            </td>
            <td style="width: 2px" height="5">
            </td>
        </tr>
        <tr>
            <td style="height: 1px">
            </td>
            <td style="width: 20px; height: 1px" valign="top">
            </td>
            <td style="height: 1px" valign="top">
                <igtbar:UltraWebToolbar ID="UltraWebToolbar1" runat="server" Width="184px" Font-Size="9pt"
                    ForeColor="White" ImageDirectory="/ig_common/images/" MovableImage="/ig_common/images/ig_tb_move00.gif"
                    ItemWidthDefault="80px" BorderWidth="0px" BorderStyle="None" Font-Names="Arial"
                    BackColor="White">
                    <HoverStyle Cursor="Hand" Font-Size="9pt" Font-Names="Arial" BorderStyle="Outset"
                        ForeColor="Black" BackColor="Silver" TextAlign="Center">
                    </HoverStyle>
                    <ClientSideEvents Click="formRest"></ClientSideEvents>
                    <SelectedStyle Cursor="Default" Font-Size="9pt" Font-Names="Arial" BorderStyle="Inset"
                        ForeColor="Black" BackColor="Silver" TextAlign="Center">
                    </SelectedStyle>
                    <Items>
                        <igtbar:TBarButton Image="../../../images/button_back.gif" Key="Back">
                            <HoverStyle TextAlign="Center">
                            </HoverStyle>
                            <SelectedStyle TextAlign="Center">
                            </SelectedStyle>
                            <DefaultStyle TextAlign="Center">
                            </DefaultStyle>
                        </igtbar:TBarButton>
                        <igtbar:TBarButton DisabledImage="" HoverImage="" Image="../../../images/button_refresh.gif"
                            Key="Reset" SelectedImage="" Tag="" TargetFrame="" TargetURL="" ToolTip="">
                            <HoverStyle TextAlign="Center">
                            </HoverStyle>
                            <SelectedStyle TextAlign="Center">
                            </SelectedStyle>
                            <DefaultStyle TextAlign="Center">
                            </DefaultStyle>
                        </igtbar:TBarButton>
                        <igtbar:TBarButton DisabledImage="" HoverImage="" Image="../../../images/button_hide.gif"
                            Key="Hide" SelectedImage="" Tag="" TargetFrame="" TargetURL="" ToolTip="">
                            <HoverStyle TextAlign="Center">
                            </HoverStyle>
                            <SelectedStyle TextAlign="Center">
                            </SelectedStyle>
                            <DefaultStyle TextAlign="Center">
                            </DefaultStyle>
                        </igtbar:TBarButton>
                        <igtbar:TBarButton DisabledImage="" HoverImage="" Image="../../../images/button_asce.gif"
                            Key="Asce" SelectedImage="" Tag="" TargetFrame="" TargetURL="" ToolTip="">
                            <HoverStyle TextAlign="Center">
                            </HoverStyle>
                            <SelectedStyle TextAlign="Center">
                            </SelectedStyle>
                            <DefaultStyle TextAlign="Center">
                            </DefaultStyle>
                        </igtbar:TBarButton>
                        <igtbar:TBarButton DisabledImage="" HoverImage="" Image="../../../images/button_desc.gif"
                            Key="Desc" SelectedImage="" Tag="" TargetFrame="" TargetURL="" ToolTip="">
                            <HoverStyle TextAlign="Center">
                            </HoverStyle>
                            <SelectedStyle TextAlign="Center">
                            </SelectedStyle>
                            <DefaultStyle TextAlign="Center">
                            </DefaultStyle>
                        </igtbar:TBarButton>
                        <igtbar:TBarButton DisabledImage="" HoverImage="" Image="../../../Images/button_exel.gif"
                            Key="Excel" SelectedImage="" Tag="" TargetFrame="" TargetURL="" ToolTip="">
                            <HoverStyle TextAlign="Center">
                            </HoverStyle>
                            <SelectedStyle TextAlign="Center">
                            </SelectedStyle>
                            <DefaultStyle TextAlign="Center">
                            </DefaultStyle>
                        </igtbar:TBarButton>
                        <igtbar:TBarButton DisabledImage="" HoverImage="" Image="../../../images/button_xmlg.gif"
                            Key="XML" SelectedImage="" Tag="" TargetFrame="" TargetURL="" ToolTip="">
                            <HoverStyle TextAlign="Center">
                            </HoverStyle>
                            <SelectedStyle TextAlign="Center">
                            </SelectedStyle>
                            <DefaultStyle TextAlign="Center">
                            </DefaultStyle>
                        </igtbar:TBarButton>
                    </Items>
                    <DefaultStyle Cursor="Hand" BorderWidth="0px" Font-Size="9pt" Font-Names="Arial"
                        BorderColor="White" BorderStyle="None" ForeColor="Black" BackColor="White" TextAlign="Center">
                    </DefaultStyle>
                </igtbar:UltraWebToolbar>
            </td>
            <td style="width: 2px; height: 1px">
            </td>
        </tr>
        <tr>
            <td style="height: 403px">
            </td>
            <td align="left" style="width: 20px; height: 403px" valign="top">
            </td>
            <td valign="top" align="left" style="height: 403px">
                <igtbl:UltraWebGrid ID="UltraWebGrid1" runat="server" Width="100%" Height="400px"
                    OnInitializeLayout="UltraWebGrid1_InitializeLayout">
                    <DisplayLayout ColWidthDefault="80px" RowHeightDefault="18px" Version="4.00" ViewType="Hierarchical"
                        HeaderClickActionDefault="SortMulti" BorderCollapseDefault="Separate" AllowColSizingDefault="Free"
                        Name="UltraWebGrid1" TableLayout="Fixed" AllowUpdateDefault="Yes">
                        <AddNewBox ButtonConnectorColor="Silver" ButtonConnectorStyle="Solid">
                            <style borderwidth="1px" borderstyle="Solid" backcolor="LightGray">

<BorderDetails ColorTop="White" WidthLeft="1px" WidthTop="1px" ColorLeft="White">
</BorderDetails>

</style>
                            <ButtonStyle BackColor="Gray" BorderColor="White" BorderStyle="Outset" BorderWidth="1px"
                                Cursor="Hand">
                            </ButtonStyle>
                        </AddNewBox>
                        <Pager PageSize="20" PagerAppearance="Both" Alignment="Center">
                            <style borderwidth="1px" borderstyle="Solid" backcolor="LightGray">

<BorderDetails ColorTop="White" WidthLeft="1px" WidthTop="1px" ColorLeft="White">
</BorderDetails>

</style>
                        </Pager>
                        <HeaderStyleDefault BorderStyle="Solid" HorizontalAlign="Left" ForeColor="Black"
                            BackColor="#CBD6A6" BorderWidth="1px" Font-Names="Tahoma" Font-Size="8pt">
                            <BorderDetails WidthLeft="1px" ColorLeft="White" ColorTop="White" WidthTop="1px">
                            </BorderDetails>
                            <Padding Left="5px" Right="5px" />
                        </HeaderStyleDefault>
                        <FrameStyle Width="100%" BorderWidth="1px" Font-Size="8pt" Font-Names="Tahoma" BorderStyle="Solid"
                            Height="400px" BackColor="#FAFCF1" Cursor="Hand">
                        </FrameStyle>
                        <FooterStyleDefault BorderWidth="1px" BorderStyle="Solid" BackColor="LightGray">
                            <BorderDetails ColorTop="White" WidthLeft="1px" WidthTop="1px" ColorLeft="White">
                            </BorderDetails>
                        </FooterStyleDefault>
                        <ClientSideEvents AfterCellUpdateHandler="acuh" BeforeCellUpdateHandler="bcuh"></ClientSideEvents>
                        <GroupByBox ButtonConnectorColor="Silver" ButtonConnectorStyle="Solid">
                            <BandLabelStyle BackColor="Gray" BorderColor="White" BorderStyle="Outset" BorderWidth="1px"
                                Cursor="Default">
                            </BandLabelStyle>
                            <style backcolor="DarkGray" bordercolor="White" borderstyle="Outset" borderwidth="1px"></style>
                        </GroupByBox>
                        <EditCellStyleDefault BorderWidth="0px" BorderStyle="None" Font-Names="Tahoma" Font-Size="8pt"
                            HorizontalAlign="Left" VerticalAlign="Middle">
                        </EditCellStyleDefault>
                        <RowStyleDefault BorderWidth="1px" BorderColor="#AAB883" BorderStyle="Solid" BackColor="White"
                            Font-Names="Tahoma" Font-Size="8pt" ForeColor="#333333" HorizontalAlign="Left"
                            VerticalAlign="Middle">
                            <Padding Left="7px" Right="7px"></Padding>
                            <BorderDetails WidthLeft="0px" WidthTop="0px"></BorderDetails>
                        </RowStyleDefault>
                        <GroupByRowStyleDefault BackColor="DarkGray" BorderColor="White" BorderStyle="Outset"
                            BorderWidth="1px">
                        </GroupByRowStyleDefault>
                        <ActivationObject BorderColor="170, 184, 131">
                        </ActivationObject>
                        <RowExpAreaStyleDefault BackColor="WhiteSmoke">
                        </RowExpAreaStyleDefault>
                        <SelectedGroupByRowStyleDefault BackColor="#CF5F5B" BorderColor="White" BorderStyle="Outset"
                            BorderWidth="1px" ForeColor="White">
                        </SelectedGroupByRowStyleDefault>
                        <ImageUrls CollapseImage="./ig_treeXPMinus.GIF" CurrentEditRowImage="./arrow_brown2_beveled.gif"
                            CurrentRowImage="./arrow_brown2_beveled.gif" ExpandImage="./ig_treeXPPlus.GIF" />
                        <RowSelectorStyleDefault BackColor="White" BorderStyle="None" BorderWidth="1px">
                        </RowSelectorStyleDefault>
                        <SelectedRowStyleDefault BackColor="#BECA98" ForeColor="White">
                        </SelectedRowStyleDefault>
                        <RowAlternateStyleDefault BackColor="#E0E0E0">
                        </RowAlternateStyleDefault>
                    </DisplayLayout>
                    <Bands>
                        <igtbl:UltraGridBand AddButtonCaption="Column0Column1Column2" Key="Column0Column1Column2">
                            <AddNewRow View="NotSet" Visible="NotSet">
                            </AddNewRow>
                        </igtbl:UltraGridBand>
                    </Bands>
                </igtbl:UltraWebGrid>
                    <style type="text/css">
    #G_UltraWebGrid1 td,#G_UltraWebGrid1 th
    {
        color: #333333;
    font-family: Tahoma;
    font-size: 8pt;
    text-align: left;
    border:none;
    }
    #G_UltraWebGrid1, #G_UltraWebGrid1 td,#G_UltraWebGrid1 th,#UltraWebGrid1_r_0 > td
    {border:none;
    }
    </style>
            </td>
            <td style="width: 1px; height: 403px">
            </td>
        </tr>
        <tr>
            <td style="height: 13px">
            </td>
            <td align="left" style="width: 20px; height: 13px" valign="top">
            </td>
            <td valign="top" align="left" style="height: 13px">
                <font face="±¼¸²">
                    <input id="ExpandAll" name="ExpandAll" onclick="javascript:ExpandAllRows(this);"
                        style="width: 80px; height: 20px; background-color: #e0e0e0" type="button" value="Expand All" />
                    <asp:RadioButton ID="radSingle" runat="server" AutoPostBack="True" Checked="True"
                        GroupName="SingleMulti" OnCheckedChanged="radSingle_CheckedChanged" Text="Single Page"
                        Width="100px" /><asp:RadioButton ID="radMulti" runat="server" AutoPostBack="True"
                            GroupName="SingleMulti" OnCheckedChanged="radMulti_CheckedChanged" Text="Multi Page"
                            Width="100px" /><asp:CheckBox ID="CheckBox1" runat="server" AutoPostBack="True" Checked="True"
                                OnCheckedChanged="CheckBox1_CheckedChanged" Text="Intelli. Search" Visible="False"
                                Width="104px" /></font>
            </td>
            <td style="width: 1px; height: 13px;">
            </td>
        </tr>
    </table>
    <asp:Button ID="btnValidate" runat="server" Text="for Validation" Visible="False">
    </asp:Button><asp:LinkButton ID="LinkButton1" runat="server" Visible="False">LinkButton</asp:LinkButton><cc1:UltraWebGridExcelExporter
        ID="UltraWebGridExcelExporter1" runat="server">
    </cc1:UltraWebGridExcelExporter>
    <asp:Button ID="btnReset" runat="server" Width="80px" Text="Reset" Height="20px"
        BackColor="#E0E0E0" Visible="False" OnClick="btnReset_Click"></asp:Button><asp:Button
            ID="butHideCol" runat="server" Width="80px" Text="Hide" Height="20px" BackColor="#E0E0E0"
            Visible="False" OnClick="butHideCol_Click"></asp:Button><asp:Button ID="btnSortAsce"
                runat="server" Width="80px" Text="Asce." Height="20px" BackColor="#E0E0E0" Visible="False"
                OnClick="btnSortAsce_Click"></asp:Button><asp:Button ID="btnSortDesc" runat="server"
                    Width="80px" Text="Desc." Height="20px" BackColor="#E0E0E0" Visible="False" OnClick="btnSortDesc_Click">
                </asp:Button><asp:Button ID="btnPrint" runat="server" Width="80px" Text="Print" Height="20px"
                    BackColor="#E0E0E0" Visible="False" OnClick="btnPrint_Click"></asp:Button><asp:Button
                        ID="btnExcel" runat="server" Width="80px" Text="Excel" Height="20px" BackColor="#E0E0E0"
                        Visible="False" OnClick="btnExcel_Click"></asp:Button><asp:Button ID="btnXML" runat="server"
                            Width="80px" Text="XML" Height="20px" BackColor="#E0E0E0" Visible="False" OnClick="btnXML_Click">
                        </asp:Button><asp:Button ID="btnBack" runat="server" Width="60px" Text="<< Back"
                            DESIGNTIMEDRAGDROP="156" Visible="False" OnClick="btnBack_Click">
    </asp:Button></form>
</body>
</html>
