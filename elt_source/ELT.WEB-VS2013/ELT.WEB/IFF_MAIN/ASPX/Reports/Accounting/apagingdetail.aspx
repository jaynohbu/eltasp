<%@ Register TagPrefix="cc1" Namespace="Infragistics.WebUI.UltraWebGrid.ExcelExport"
    Assembly="Infragistics.WebUI.UltraWebGrid.ExcelExport, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igtbl" Namespace="Infragistics.WebUI.UltraWebGrid" Assembly="Infragistics.WebUI.UltraWebGrid, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>

<%@ Page Language="c#" Inherits="IFF_MAIN.ASPX.Reports.Accounting.APAgingDetail"
    CodeFile="APAgingDetail.aspx.cs" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<html>
<head>
    <title>APAging</title>
    <meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
    <meta content="C#" name="CODE_LANGUAGE">
    <meta content="JavaScript" name="vs_defaultClientScript">
    <meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
    <style type="text/css">
    th {
font-family: Verdana;
font-size: 9px;

height:18px;


}
#G_UltraWebGrid1 td
{padding:2px;

 border-collapse:collapse;
}
#G_UltraWebGrid1 th a
{
    color:#000;
}


    </style>
    <script language="javascript">
        function goBack() {
            var a = '<%=ViewState["Count"]%>';
            if (history.length >= a) {
                a = -1 * a;
                history.go(a);
            }
            else {
                location.replace('APAgingSelection.aspx')
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
            else if (idText == 'PDF') {
                __doPostBack("btnPDF", "");
            }
            else if (idText == 'DOC') {
                __doPostBack("btnDOC", "");
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

        //Added by stanley on 10/25/2007 -- joon modifed again 12-04-2007
        function goFindURL(argType, argDocVal, argRefVal, impType, impType2, ID, VenNum, md) {
            var vURL = "";
            var argVal = encodeURIComponent(argVal);
            switch (argType) {
                case "BILL":
                    // go to invoice
                    vURL = "/ASP/acct_tasks/enter_bill.asp?ViewBill=yes&BillNo=" + argDocVal;
                    break;
                case "GJE":
                    vURL = "/ASP/acct_tasks/gj_entry.asp?View=yes&EntryNo=" + argRefVal;
                    // to to general journal entry
                    break;
                case "INV":
                    // to to invoice
                    if (argDocVal == "Direct Entry") {
                        vURL = "/ASP/acct_tasks/enter_bill.asp?ViewBill=yes&item_id=" + ID + "&vendor_number=" + VenNum;
                    }
                    else {
                        vURL = "/ASP/acct_tasks/edit_invoice.asp?edit=yes&InvoiceNo=" + argDocVal;
                    }
                    break;
                case "ARN":
                    if (impType == "AI") {
                        // to to Air Import
                        vURL = "/ASP/air_import/arrival_notice.asp?iType=A&Edit=yes&InvoiceNo=" + argDocVal;
                    }
                    else {
                        // to to Ocean Import
                        vURL = "/ASP/ocean_import/arrival_notice.asp?iType=O&Edit=yes&InvoiceNo=" + argDocVal;
                    }
                    break;
                case "ADN":
                    if (impType2 == "A") {
                        // to to Air Import
                        vURL = "/ASP/air_import/air_import2.asp?iType=A&Edit=yes&MAWB=" + md;
                    }
                    else {
                        // to to Ocean Import
                        vURL = "/ASP/ocean_import/ocean_import2.asp?iType=O&Edit=yes&MAWB=" + md;
                    }
                    break;
                case "Direct Entry":
                    // to to Enter Bill
                    vURL = "/ASP/acct_tasks/enter_bill.asp?ViewBill=yes&item_id=" + ID + "&vendor_number=" + VenNum;
                    break;
            }
            viewPop(vURL);
        }
        window.onresize = resize_table; 	
    </script>
    <link href="/IFF_MAIN/ASPX/CSS/AppStyle.css" type="text/css" rel="stylesheet"></link>
    <!--  #INCLUDE FILE="../../include/common.htm" -->
</head>
<body onload="javascript:resize_table();">
    <form id="form1" method="post" runat="server">
    <table id="Table2" height="388" cellspacing="0" cellpadding="0" width="100%" bgcolor="#ffffff"
        style="height: 388px">
        <tr>
            <td height="19" style="height: 19px">
                <font face="±¼¸²"></font>
            </td>
            <td height="19" style="width: 20px; height: 19px">
            </td>
            <td height="19" style="height: 19px">
                <asp:Label ID="Label1" runat="server" Width="100%" Font-Bold="True" ForeColor="Black"
                    Font-Size="Larger" Height="8px"> A/P Aging - Posted</asp:Label>
            </td>
            <td style="width: 2px; height: 19px" height="19">
            </td>
        </tr>
        <tr>
            <td style="height: 2px">
            </td>
            <td align="left" style="width: 20px; height: 2px" valign="middle">
            </td>
            <td style="height: 2px" valign="middle" align="left">
                <font face="±¼¸²">
                    <asp:Label ID="Label2" runat="server" Height="8px" Font-Size="10px" ForeColor="Navy"
                        Font-Bold="True" Width="100%" Font-Italic="True"></asp:Label></font>
            </td>
            <td style="width: 2px; height: 2px">
            </td>
        </tr>
        <tr>
            <td style="height: 4px">
            </td>
            <td style="width: 20px; height: 4px">
            </td>
            <td style="height: 4px">
                <font face="±¼¸²">
                    <asp:Label ID="lblNoData" runat="server" Width="100%" Font-Bold="True" ForeColor="Navy"
                        Font-Italic="True" Font-Underline="True">...</asp:Label></font>
            </td>
            <td style="width: 2px; height: 4px">
            </td>
        </tr>
        <tr>
            <td style="height: 4px">
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
            <td style="width: 20px; height: 1px" valign="top">
            </td>
            <td style="height: 1px" valign="top">
                <asp:ImageButton ID="btnExcelExport" runat="server" ImageUrl="../../../Images/button_exel.gif"
                    OnClick="btnExcelExport_Click" Style="float: right;" />
                <asp:ImageButton ID="btnPDFExport" runat="server" ImageUrl="../../../Images/button_pdf.gif"
                    Style="float: right; height: 16px;" OnClick="btnPDF_Click1" />
            </td>
            <td style="width: 2px; height: 1px">
            </td>
        </tr>
        <tr>
            <td style="height: 413px">
            </td>
            <td align="left" style="width: 20px; height: 413px" valign="top">
            </td>
            <td valign="top" align="left" style="height: 413px">
                <igtbl:UltraWebGrid ID="UltraWebGrid1" runat="server" Height="400px" OnInitializeLayout="UltraWebGrid1_InitializeLayout1"
                    Width="100%">
                    <DisplayLayout ColWidthDefault="80px" RowHeightDefault="18px" Version="4.00" ViewType="Hierarchical"
                        HeaderClickActionDefault="SortMulti" BorderCollapseDefault="Separate" Name="UltraWebGrid1"
                        TableLayout="Fixed" ReadOnly="LevelOne">
                        <AddNewBox ButtonConnectorColor="Silver" ButtonConnectorStyle="Solid">
                            <style borderwidth="1px" borderstyle="Solid" backcolor="LightGray">

<BorderDetails ColorTop="White" WidthLeft="1px" WidthTop="1px" ColorLeft="White">
</BorderDetails>

</style>
                            <ButtonStyle BackColor="Gray" BorderColor="White" BorderStyle="Outset" BorderWidth="1px"
                                Cursor="Hand">
                            </ButtonStyle>
                        </AddNewBox>
                        <Pager Alignment="Center">
                            <style borderwidth="1px" borderstyle="Solid" backcolor="LightGray">

<BorderDetails ColorTop="White" WidthLeft="1px" WidthTop="1px" ColorLeft="White">
</BorderDetails>

</style>
                        </Pager>
                        <HeaderStyleDefault BorderStyle="Solid" ForeColor="Black" BackColor="#CBD6A6" BorderWidth="1px"
                            Font-Names="Tahoma" Font-Size="8pt" HorizontalAlign="Left">
                            <BorderDetails WidthLeft="1px" ColorLeft="White" ColorTop="White" WidthTop="1px">
                            </BorderDetails>
                            <Padding Left="5px" Right="5px" />
                        </HeaderStyleDefault>
                        <FrameStyle BorderWidth="1px" Font-Size="8pt" Font-Names="Tahoma" BorderStyle="Solid"
                            BackColor="#FAFCF1" Cursor="Hand" Height="400px" Width="100%">
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
                        <RowAlternateStyleDefault BackColor="#E0E0E0">
                        </RowAlternateStyleDefault>
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
                        <FilterOptionsDefault AllString="(All)" EmptyString="(Empty)" NonEmptyString="(NonEmpty)">
                            <FilterDropDownStyle BackColor="White" BorderColor="Silver" BorderStyle="Solid" BorderWidth="1px"
                                CustomRules="overflow:auto;" Font-Names="Verdana,Arial,Helvetica,sans-serif"
                                Font-Size="11px" Width="200px">
                                <Padding Left="2px" />
                            </FilterDropDownStyle>
                            <FilterHighlightRowStyle BackColor="#151C55" ForeColor="#FFFFFF">
                            </FilterHighlightRowStyle>
                        </FilterOptionsDefault>
                    </DisplayLayout>
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
                                <FilterHighlightRowStyle BackColor="#151C55" ForeColor="#FFFFFF">
                                </FilterHighlightRowStyle>
                            </FilterOptions>
                        </igtbl:UltraGridBand>
                    </Bands>
                </igtbl:UltraWebGrid>
            </td>
            <td style="width: 1px; height: 413px;">
            </td>
        </tr>
        <tr>
            <td>
            </td>
            <td align="left" style="width: 20px" valign="top">
            </td>
            <td valign="top" align="left">
                <asp:RadioButton ID="radSingle" runat="server" Width="100px" Text="Single Page" AutoPostBack="True"
                    Checked="True" GroupName="SingleMulti" OnCheckedChanged="radSingle_CheckedChanged"
                    Visible="False"></asp:RadioButton><asp:RadioButton ID="radMulti" runat="server" Width="100px"
                        Text="Multi Page" AutoPostBack="True" GroupName="SingleMulti" OnCheckedChanged="radMulti_CheckedChanged"
                        Visible="False"></asp:RadioButton><asp:CheckBox ID="CheckBox1" runat="server" Width="104px"
                            Text="Intelli. Search" AutoPostBack="True" Checked="True" OnCheckedChanged="CheckBox1_CheckedChanged"
                            Visible="False"></asp:CheckBox>
                <input id="ExpandAll" style="width: 80px; height: 20px; background-color: #e0e0e0;
                    visibility: hidden" onclick="javascript:ExpandAllRows(this);" type="button" value="Expand All"
                    name="ExpandAll">
            </td>
            <td style="width: 1px">
            </td>
        </tr>
    </table>
    <asp:Button ID="btnValidate" runat="server" Text="for Validation" Visible="False">
    </asp:Button><asp:LinkButton ID="LinkButton1" runat="server" Visible="False">LinkButton</asp:LinkButton><cc1:UltraWebGridExcelExporter
        ID="UltraWebGridExcelExporter1" runat="server" OnCellExported="UltraWebGridExcelExporter1_CellExported">
    </cc1:UltraWebGridExcelExporter>
    <asp:Button ID="btnBack" runat="server" Text="<< Back" Width="60px" DESIGNTIMEDRAGDROP="14"
        OnClick="Button1_Click" Visible="False"></asp:Button><asp:Button ID="btnReset" runat="server"
            Text="Reset" Width="80px" Height="20px" DESIGNTIMEDRAGDROP="32" BackColor="#E0E0E0"
            Visible="False" OnClick="btnReset_Click"></asp:Button><asp:Button ID="butHideCol"
                runat="server" Text="Hide" Width="80px" Height="20px" DESIGNTIMEDRAGDROP="40"
                BackColor="#E0E0E0" Visible="False" OnClick="butHideCol_Click"></asp:Button><asp:Button
                    ID="btnSortAsce" runat="server" Text="Asce." Width="80px" Height="20px" DESIGNTIMEDRAGDROP="47"
                    BackColor="#E0E0E0" Visible="False" OnClick="btnSortAsce_Click">
    </asp:Button><asp:Button ID="btnSortDesc" runat="server" Text="Desc." Width="80px"
        Height="20px" DESIGNTIMEDRAGDROP="48" BackColor="#E0E0E0" Visible="False" OnClick="btnSortDesc_Click">
    </asp:Button><asp:Button ID="btnPrint" runat="server" Text="Print" Width="80px" Height="20px"
        DESIGNTIMEDRAGDROP="52" BackColor="#E0E0E0" Visible="False" OnClick="btnPrint_Click">
    </asp:Button><asp:Button ID="btnExcel" runat="server" Text="Excel" Width="80px" Height="20px"
        DESIGNTIMEDRAGDROP="56" BackColor="#E0E0E0" Visible="False" OnClick="btnExcel_Click">
    </asp:Button><asp:Button ID="btnXML" runat="server" Text="XML" Width="80px" Height="20px"
        DESIGNTIMEDRAGDROP="57" BackColor="#E0E0E0" Visible="False" OnClick="btnXML_Click">
    </asp:Button>
    <asp:Button ID="btnDOC" runat="server" Text="DOC" Width="80px" Height="20px" BackColor="#E0E0E0"
        Visible="False" OnClick="btnDOC_Click"></asp:Button>
    </form>
</body>
</html>
