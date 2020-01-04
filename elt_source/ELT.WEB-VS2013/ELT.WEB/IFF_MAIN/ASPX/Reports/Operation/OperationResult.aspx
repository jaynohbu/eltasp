<%@ Page CodeFile="OperationResult.aspx.cs" Inherits="IFF_MAIN.ASPX.Reports.Operation.OperationResult"
    Language="c#" %>

<%@ Register Assembly="Infragistics.WebUI.UltraWebGrid, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.UltraWebGrid" TagPrefix="igtbl" %>
<%@ Register Assembly="Infragistics.WebUI.UltraWebGrid.ExcelExport, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.UltraWebGrid.ExcelExport" TagPrefix="cc1" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<html>
<head>
    <title>AEOpResult</title>
    <meta content="C#" name="CODE_LANGUAGE">

    <script type="text/javascript">

        function goPNLChart() {
            var argS = 'staus=0,titlebar=0,toolbar=0,menubar=0,scrollbars=0,resizable=0,location=0,width=800,height=600,hotkeys=0';
            window.open('PNLCharts.aspx', 'popUpWindow', argS);
        }

        function goBack() {
            var a = '<%=ViewState["Count"]%>';

            if (history.length >= a) {
                a = -1 * a;
                history.go(a);
            }
            else {
                location.replace('PnlIndex.aspx')
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
            else if (idText == 'Chart') {
                goPNLChart();
            }
            else if (idText == 'PDF') {
                __doPostBack("btnPDF", "");
            }
            else if (idText == 'DOC') {
                __doPostBack("btnDOC", "");
            }
        }



        function resize_table() {
            var x, y;
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
            if (document.getElementById("UltraWebGrid1_main") != null) {
                //alert (y);
                document.getElementById("UltraWebGrid1_main").style.height = parseInt(y -
                document.getElementById("UltraWebGrid1_main").offsetTop - 60) + "px";
            }
        }

        window.onresize = resize_table;

    </script>

    <link href="/IFF_MAIN/ASPX/CSS/AppStyle.css" rel="stylesheet" type="text/css">
    <!--  #INCLUDE FILE="../../include/common.htm" -->
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <style type="text/css">
        <!--
        body
        {
            margin-left: 0px;
            margin-right: 0px;
            margin-bottom: 0px;
        }

        .style1
        {
            color: #cc6600;
        }
        -->
    </style>
</head>
<body onload="javascript:resize_table();">
    <form id="form1" runat="server" method="post">
        <table width="95%" align="center" cellpadding="0" cellspacing="0" bgcolor="#ffffff" id="Table2">
            <tr>
                <td align="left" style="height: 78px" valign="middle">
                    <asp:Label CssClass="pageheader" ID="lblTitle" runat="server" DESIGNTIMEDRAGDROP="9087" Width="100%"></asp:Label>
                    <span class="style1">
                        <asp:Label ForeColor="#cc6600" CssClass="bodyheader" ID="lblSubTitle2" runat="server" DESIGNTIMEDRAGDROP="9087" Width="100%"></asp:Label>
                        <asp:Label ForeColor="#cc6600" CssClass="reportdetail" ID="lblSubTitle" runat="server" DESIGNTIMEDRAGDROP="9087" Width="100%"></asp:Label>
                    </span></td>
            </tr>
            <tr>
                <td bgcolor="#cdcc9d" style="height: 10px"><span style="height: 1px">
                    <asp:Label ID="Label2" runat="server" designtimedragdrop="9087" Font-Bold="True"
                        Font-Italic="True" Font-Size="10px" ForeColor="Navy" Height="8px" Width="100%"></asp:Label>
                    <asp:Label
                        ID="lblNoData" runat="server" Font-Bold="True" Font-Italic="True" Font-Underline="True"
                        ForeColor="Navy" Width="100%" Height="10px">...</asp:Label>
                </span></td>
            </tr>

            <tr>
                <td style="height: 1px" valign="middle">
                   
                </td>
            </tr>
            <tr>
                <td align="left" style="height: 403px" valign="top">
                     <asp:ImageButton ID="btnExcelExport" runat="server" ImageUrl="../../../Images/button_exel.gif"
                            OnClick="btnExcelExport_Click" />
                    <igtbl:UltraWebGrid ID="UltraWebGrid1" runat="server" OnInitializeLayout="UltraWebGrid1_InitializeLayout1"
                    OnInitializeRow="UltraWebGrid1_InitializeRow1" Width="100%">
                    <Bands>
                        <igtbl:UltraGridBand>
                            <AddNewRow View="NotSet" Visible="NotSet">
                            </AddNewRow>
                            <FilterOptions AllString="" EmptyString="" NonEmptyString="">
                                <FilterDropDownStyle BackColor="White" BorderColor="Silver" BorderStyle="Solid" BorderWidth="1px"
                                    CustomRules="overflow:auto;" Font-Names="Verdana,Arial,Helvetica,sans-serif"
                                    Font-Size="11px" Width="200px">
                                    <Padding Left="2px" />
                                </FilterDropDownStyle>
                                <FilterHighlightRowStyle BackColor="#151C55" ForeColor="White">
                                </FilterHighlightRowStyle>
                            </FilterOptions>
                        </igtbl:UltraGridBand>
                    </Bands>
                    <DisplayLayout BorderCollapseDefault="Separate" ColWidthDefault="80px" HeaderClickActionDefault="SortMulti"
                        Name="ug1" ReadOnly="LevelOne" RowHeightDefault="18px" RowSelectorsDefault="No"
                        TableLayout="Fixed" Version="4.00" ViewType="Hierarchical">
                        <GroupByBox ButtonConnectorColor="Silver" ButtonConnectorStyle="Solid">
                            <BandLabelStyle BackColor="Gray" BorderColor="White" BorderStyle="Outset" BorderWidth="1px"
                                Cursor="Default">
                            </BandLabelStyle>
                            <style backcolor="DarkGray" bordercolor="White" borderstyle="Outset" borderwidth="1px"></style>
                        </GroupByBox>
                        <GroupByRowStyleDefault BackColor="DarkGray" BorderColor="White" BorderStyle="Outset"
                            BorderWidth="1px">
                        </GroupByRowStyleDefault>
                        <ActivationObject BorderColor="170, 184, 131">
                        </ActivationObject>
                        <RowExpAreaStyleDefault BackColor="WhiteSmoke">
                        </RowExpAreaStyleDefault>
                        <FooterStyleDefault BackColor="LightGray" BorderStyle="Solid" BorderWidth="1px">
                            <BorderDetails ColorLeft="White" ColorTop="White" WidthLeft="1px" WidthTop="1px" />
                        </FooterStyleDefault>
                        <SelectedGroupByRowStyleDefault BackColor="#CF5F5B" BorderColor="White" BorderStyle="Outset"
                            BorderWidth="1px" ForeColor="White">
                        </SelectedGroupByRowStyleDefault>
                        <RowStyleDefault BackColor="White" BorderColor="#AAB883" BorderStyle="Solid" BorderWidth="1px"
                            Font-Names="Tahoma" Font-Size="8pt" ForeColor="#333333" HorizontalAlign="Left"
                            VerticalAlign="Middle">
                            <BorderDetails WidthLeft="0px" WidthTop="0px" />
                            <Padding Left="7px" Right="7px" />
                        </RowStyleDefault>
                        <FilterOptionsDefault AllString="(All)" EmptyString="(Empty)" NonEmptyString="(NonEmpty)">
                            <FilterDropDownStyle BackColor="White" BorderColor="Silver" BorderStyle="Solid" BorderWidth="1px"
                                CustomRules="overflow:auto;" Font-Names="Verdana,Arial,Helvetica,sans-serif"
                                Font-Size="11px" Width="200px">
                                <Padding Left="2px" />
                            </FilterDropDownStyle>
                            <FilterHighlightRowStyle BackColor="#151C55" ForeColor="White">
                            </FilterHighlightRowStyle>
                        </FilterOptionsDefault>
                        <ImageUrls CollapseImage="./ig_treeXPMinus.GIF" CurrentEditRowImage="./arrow_brown2_beveled.gif"
                            CurrentRowImage="./arrow_brown2_beveled.gif" ExpandImage="./ig_treeXPPlus.GIF" />
                        <RowSelectorStyleDefault BackColor="White" BorderStyle="None" BorderWidth="1px">
                        </RowSelectorStyleDefault>
                        <ClientSideEvents AfterCellUpdateHandler="acuh" BeforeCellUpdateHandler="bcuh" />
                        <SelectedRowStyleDefault BackColor="#BECA98" ForeColor="White">
                        </SelectedRowStyleDefault>
                        <HeaderStyleDefault BackColor="#CBD6A6" BorderStyle="Solid" BorderWidth="1px" Font-Names="Tahoma"
                            Font-Size="8pt" ForeColor="Black" HorizontalAlign="Left">
                            <BorderDetails ColorLeft="White" ColorTop="White" WidthLeft="1px" WidthTop="1px" />
                            <Padding Left="5px" Right="5px" />
                        </HeaderStyleDefault>
                        <RowAlternateStyleDefault BackColor="#E0E0E0">
                        </RowAlternateStyleDefault>
                        <EditCellStyleDefault BorderStyle="None" BorderWidth="0px" Font-Names="Tahoma" Font-Size="8pt"
                            HorizontalAlign="Left" VerticalAlign="Middle">
                        </EditCellStyleDefault>
                        <FrameStyle BackColor="#FAFCF1" BorderStyle="Solid" BorderWidth="1px" Cursor="Hand"
                            Font-Names="Tahoma" Font-Size="8pt" Height="400px" Width="100%">
                        </FrameStyle>
                        <Pager Alignment="Center">
                            <style backcolor="LightGray" borderstyle="Solid" borderwidth="1px">
                                <BorderDetails ColorTop="White" WidthLeft="1px" WidthTop="1px" ColorLeft="White" > </BorderDetails >
                            </style>
                        </Pager>
                        <AddNewBox ButtonConnectorColor="Silver" ButtonConnectorStyle="Solid">
                            <ButtonStyle BackColor="Gray" BorderColor="White" BorderStyle="Outset" BorderWidth="1px"
                                Cursor="Hand">
                            </ButtonStyle>
                            <style backcolor="LightGray" borderstyle="Solid" borderwidth="1px">
                                <BorderDetails ColorTop="White" WidthLeft="1px" WidthTop="1px" ColorLeft="White" > </BorderDetails >
                            </style>
                        </AddNewBox>
                    </DisplayLayout>
                </igtbl:UltraWebGrid></td>
            </tr>
            <tr>
                <td height="13" align="left" valign="top" bgcolor="#cdcc9d"></td>
            </tr>
        </table>
        <asp:LinkButton ID="LinkButton1" runat="server" Visible="False">LinkButton</asp:LinkButton><asp:Button
            ID="btnReset" runat="server" BackColor="#E0E0E0" Height="20px" OnClick="btnReset_Click"
            Text="Reset" Visible="False" Width="80px" /><asp:Button
                    ID="btnXML" runat="server" BackColor="#E0E0E0" Height="20px" OnClick="btnXML_Click"
                    Text="XML" Visible="False" Width="80px" />
        <cc1:UltraWebGridExcelExporter ID="UltraWebGridExcelExporter1" runat="server">
        </cc1:UltraWebGridExcelExporter>
        <asp:Button ID="btnPDF" runat="server" OnClick="btnPDF_Click" Text="PDF" Visible="False"
            Width="60px" />
        <asp:Button ID="btnDOC" runat="server" OnClick="btnDOC_Click" Text="DOC" Visible="False"
            Width="60px" />
    </form>
</body>

</html>
