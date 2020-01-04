<%@ Register TagPrefix="cc1" Namespace="Infragistics.WebUI.UltraWebGrid.ExcelExport"
    Assembly="Infragistics.WebUI.UltraWebGrid.ExcelExport, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igtbl" Namespace="Infragistics.WebUI.UltraWebGrid" Assembly="Infragistics.WebUI.UltraWebGrid, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>

<%@ Page Language="c#" Inherits="IFF_MAIN.ASPX.Reports.Accounting.GLDetail" CodeFile="GLDetail.aspx.cs"
    AutoEventWireup="true" EnableEventValidation="false" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<html>
<head>
    <title>Account Report</title>
    <meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
    <meta content="C#" name="CODE_LANGUAGE">
    <meta content="JavaScript" name="vs_defaultClientScript">
    <meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
    <script language="javascript">
        function goBack() {
            var a = '';

            if (history.length >= a) {
                a = -1 * a;
                history.go(a);
            }
            else {
                location.replace('GLSelection.aspx')
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
            else if (idText == 'EMAIL') {

                var osendItems = document.getElementsByName('sendItems');
                var osendMessages = document.getElementsByName('sendMessages');
                var osendEmails = document.getElementsByName('sendEmails');

                var oCompanyList = document.getElementById("CompanyListText");
                var oMessageList = document.getElementById("MessageListText");
                var oEmailList = document.getElementById("EmailListText");

                UpdateEmailList(osendItems, oCompanyList, osendMessages, oMessageList, osendEmails, oEmailList);

                //alert("Sending");
                if (oEmailList.value == "" || oEmailList.value == null) {
                    alert("Please, select customers to send emails.");
                    return false;
                }
                else {
                    var confirmVal = confirm("Click OK to send email(s) now.");
                    if (confirmVal) {
                        __doPostBack("btnEMAIL", "");
                    }
                }
            }
        }
        /*function UpdateEmailList(arg) 
        {
        
        var oDropList = document.getElementById("EmailList");
        //alert(oDropList.type);
        }*/

        function SendOneEmail(arg) {
            var osendItems = document.getElementsByName('sendItems');
            var osendMessages = document.getElementsByName('sendMessages');
            var osendEmails = document.getElementsByName('sendEmails');

            var oCompanyList = document.getElementById("CompanyListText");
            var oMessageList = document.getElementById("MessageListText");
            var oEmailList = document.getElementById("EmailListText");

            oCompanyList.value = osendItems.item(arg).value + '^';
            oMessageList.value = osendMessages.item(arg).value + '^';
            oEmailList.value = osendEmails.item(arg).value + '^';

            var confirmVal = confirm("Click OK to send email(s) now.");
            if (confirmVal) {
                __doPostBack("btnEMAIL", "");
            }
            return false;
        }

        function UpdateEmailList(sList, dList, sListAdd, dListAdd, sListAdd2, dListAdd2) {
            var numItems = 0;
            var addOption;

            for (var i = 0; i < sList.length; i++) {
                if (sList.item(i).checked) {
                    /*
                    addOption = new Option(sList.item(i).value,sList.item(i).value);
                    dList.options[numItems] = addOption;
                    dList.options[numItems].selected = true;
                    numItems++;
                    */
                    dList.value = dList.value + sList.item(i).value + '^';
                    dListAdd.value = dListAdd.value + sListAdd.item(i).value + '^';
                    dListAdd2.value = dListAdd2.value + sListAdd2.item(i).value + '^';
                }
            }
        }

        var igS;
        function acuh(tableName, itemName) {
            alert('a');
            var cell = igtbl_getElementById(itemName);
            cell.innerHTML = igS;
        }

        function bcuh(tableName, itemName) {
            var cell = igtbl_getElementById(itemName);
            igS = cell.innerHTML;
        }

        function ExpandAllRows(btnEl) {
            // Loop thru the rows of Band 0 and expand each one
          
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
            return;
            var eVal = igtbl_getElementById("FindVal");
            findValue = eVal.value;
            var re = new RegExp("^" + findValue, "gi");
            if (btnEl.value == "Find") {
               // igtbl_clearSelectionAll(oug1.Id)
                var oCell = oug1.find(re);
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
                var oCell = oug1.findNext();
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
    <script language="javascript">
        function expandPrim() {
            return;
            if (oug1) {
                var oGrid = oug1;
                var oRows = oGrid.Rows;
                var strV;
                oGrid.suspendUpdates(true);

                for (i = 0; i < oRows.length; i++) {
                    oRow = oRows.getRow(i);
                    band = igtbl_getBandById(oRow.Id);
                    if (band.Key == "HEAD") {
                        oRow.setExpanded(true);
                    }
                    var oChildRows = oRow.Rows;
                    if (oChildRows) {
                        for (j = 0; j < oChildRows.length; j++) {
                            oChildRow = oChildRows.getRow(j);
                            band = igtbl_getBandById(oChildRow.Id);
                            if (band.Key == "HEAD2") {
                                oChildRow.setExpanded(true);
                            }
                        }
                    }
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
            if (document.getElementById("ug1_main") != null) {
                //alert (y);
                document.getElementById("ug1_main").style.height = parseInt(y -
	        document.getElementById("ug1_main").offsetTop - 60) + "px";
            }
        }

        function doCheckAll() {
            var checked = false;

            checked = document.getElementById('sendItemsAll').checked;

            for (var i = 0; i < document.getElementsByName('sendItems').length; i++) {
                document.getElementsByName('sendItems').item(i).checked = checked;
            }
        }

        function DetailOepnClose(index) {
            var obj = document.getElementById("detail_" + index);
            var row = document.getElementById("td_" + index);
            if (obj.style.display == "block") {
                obj.style.display = "none";
                row.style.background = "url('./ig_treeXPPlus.GIF') no-repeat scroll 0px 2px transparent";
            }
            else {
                obj.style.display = "block";
                row.style.background = "url('./ig_treeXPMinus.GIF') no-repeat scroll 0px 2px transparent";
            }
        }

        window.onresize = resize_table; 
	
    </script>
    <style type="text/css">
        table.report-chart
        {
            width: 700px;
            border-collapse: collapse;
        }
        table.report-chart tbody tr th, table.report-chart tbody tr td
        {
            font-weight: normal;
            border: 1px solid #aaa;
        }
        table.report-detail tbody tr th, table.report-detail tbody tr td
        {
            font-weight: normal;
            border: none;
        }
        table.report-chart tbody tr th
        {
            background-color: #D5EBD6;
            text-align: left;
        }
        
        #GridView1 tbody tr th
        {
            width: 0;
        }
        #GridView1 tbody tr td
        {
            border: 1px solid #aaa;
        }
        #GridView1_ctl02_GridView2 tbody tr td
        {
            border: none;
        }
        .AlternatingRowStyle
        {
            display: none;
        }
        .report-detail tbody tr td
        {
            border: none;
        }
        .selectable:hover
        {
            color: Blue;
        }
        .selectable
        {
            cursor: pointer;
            background: url("./ig_treeXPPlus.GIF") no-repeat scroll 0px 2px transparent;
            padding-left: 15px;
        }
    </style>
</head>
<body onload="javascript:expandPrim(); resize_table();">
    <form id="form1" method="post" runat="server">
    <table id="Table2" cellspacing="0" cellpadding="0" width="100%" bgcolor="#ffffff"
        style="height: 420px">
        <tr>
            <td style="height: 20px; width: 30px;">
            </td>
            <td align="left" style="height: 2px" valign="middle">
            </td>
            <td style="height: 2px" valign="middle" align="left">
                <asp:Label ID="lblReportTitle" runat="server" Height="8px" DESIGNTIMEDRAGDROP="18" Font-Size="Larger"
                    ForeColor="Black" Font-Bold="True" Width="100%">Sales Report</asp:Label>
            </td>
            <td style="width: 30px; height: 2px">
            </td>
        </tr>
        <tr>
            <td style="height: 4px; width: 15px;">
            </td>
            <td bgcolor="#d5e8cb" style="height: 4px">
            </td>
            <td style="height: 4px" bgcolor="#D5E8CB">
            </td>
            <td style="width: 2px; height: 4px">
            </td>
        </tr>
        <tr>
            <td style="height: 13px; width: 15px;">
            </td>
            <td bgcolor="whitesmoke" style="height: 13px" valign="top">
            </td>
            <td style="height: 13px" valign="top" bgcolor="whitesmoke">
                <asp:Label ID="Label2" runat="server" Width="100%" Font-Bold="True" ForeColor="Navy"
                    Font-Size="10px" Height="8px" Font-Italic="True"></asp:Label>
            </td>
            <td style="width: 2px; height: 13px">
            </td>
        </tr>
        <tr>
            <td style="height: 2px; width: 15px;">
            </td>
            <td bgcolor="#f5f5f5" style="height: 2px" valign="top">
            </td>
            <td style="height: 2px" valign="top" bgcolor="#f5f5f5">
                <asp:Label ID="lblNoData" runat="server" Width="100%" Font-Bold="True" ForeColor="Navy"
                    Font-Italic="True" Font-Underline="True">...</asp:Label>
            </td>
            <td style="width: 2px; height: 2px">
            </td>
        </tr>
        <tr>
            <td height="5" style="width: 15px">
            </td>
            <td bgcolor="#d5e8cb" height="5" valign="top">
            </td>
            <td valign="top" bgcolor="D5E8CB" height="5">
            </td>
            <td style="width: 2px" height="5">
            </td>
        </tr>
        <tr>
            <td style="height: 1px; width: 15px;">
            </td>
            <td style="height: 1px" valign="top">
            </td>
            <td style="height: 1px" valign="top">
            </td>
            <td style="width: 2px; height: 1px">
            </td>
        </tr>
        <tr>
            <td style="width: 15px;">
            </td>
            <td align="left" valign="top">
            </td>
            <td valign="top" align="left">
                <div style="text-align: right; width: 551px;">
                    <asp:ImageButton ID="btnExcelExport" runat="server" ImageUrl="../../../Images/button_exel.gif"
                        OnClick="btnExcelExport_Click" />
                    <asp:ImageButton ID="btnPDFExport" runat="server" ImageUrl="../../../Images/button_pdf.gif"
                        Style="height: 16px;" OnClick="btnPDF_Click1" />
                </div>
                <asp:GridView ID="GridView1" runat="server" OnRowDataBound="GridView1_RowDataBound"
                    AutoGenerateColumns="False" Width="1000px" GridLines="None">
                    <Columns>
                        <asp:TemplateField>
                            <HeaderTemplate>
                                <td width="342" style="background-color: #DBEDE2">
                                    Customer Name
                                </td>
                                <td width="100" style="background-color: #DBEDE2; text-align: center">
                                    Amount
                                </td>
                                <td width="100" style="background-color: #DBEDE2; text-align: center">
                                    Accumulation
                                </td>
                                <td style="border: none;">
                                </td>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <tr style="background-color: #F2F1C6;">
                                    <th>
                                    </th>
                                    <td onclick="javascript:DetailOepnClose('<%# Container.DataItemIndex %>');" class="selectable"
                                        id="td_<%# Container.DataItemIndex %>">
                                        <%# Eval("Customer_Name")%>
                                        <asp:HiddenField ID="lblCustNum" runat="server" Value='<%# Eval("Customer_Number")%>' />
                                    </td>
                                    <td style="text-align: right">
                                        <%# Eval("Amount")%>
                                    </td>
                                    <td style="text-align: right">
                                        <%# Eval("Amount")%>
                                    </td>
                                    <td style="background-color: #fff; border: none;">
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="5" style="border: none; height: 0px; padding: 0px 0px 0px 94px;">
                                        <div id="detail_<%# Container.DataItemIndex %>" style="display: none;">
                                            <asp:DataList ID="GridView2" runat="server" Width="460px" BorderStyle="None" CssClass="report-detail">
                                                <ItemStyle BorderStyle="None" />
                                                <HeaderStyle BorderStyle="None" />
                                                <HeaderTemplate>
                                                    <td width="60" style="background-color: #eee; border: none;">
                                                        Type
                                                    </td>
                                                    <td width="100" style="background-color: #eee; border: none;">
                                                        Num
                                                    </td>
                                                    <td width="100" style="background-color: #eee; border: none;">
                                                        Date
                                                    </td>
                                                    <td width="100" style="background-color: #eee; text-align: center; border: none;">
                                                        Amount
                                                    </td>
                                                    <td width="100" style="background-color: #eee; text-align: center; border: none;">
                                                        Accumulation
                                                    </td>
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <tr>
                                                        <td width="0" style="border: none;">
                                                        </td>
                                                        <td style="border: none;">
                                                            <%# Eval("Type")%>
                                                        </td>
                                                        <td style="border: none;">
                                                            <%# Eval("Num")%>
                                                        </td>
                                                        <td style="border: none;">
                                                            <%#  Convert.ToDateTime(Eval("Date")).ToString("d") %>
                                                        </td>
                                                        <td style="text-align: right; border: none;">
                                                            <asp:Label ID="lblAmount" runat="server"><%# Eval("Amount")%></asp:Label>
                                                        </td>
                                                        <td style="text-align: right; border: none;">
                                                            <%# Eval("Acc")%>
                                                        </td>
                                                    </tr>
                                                </ItemTemplate>
                                            </asp:DataList>
                                        </div>
                                    </td>
                                </tr>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <AlternatingRowStyle CssClass="AlternatingRowStyle" />
                    <RowStyle CssClass="AlternatingRowStyle" />
                </asp:GridView>
                <br />
                <igtbl:UltraWebGrid Visible="false" ID="ug1" runat="server" OnInitializeLayout="ug1_InitializeLayout1"
                    OnInitializeRow="ug1_InitializeRow" Width="100%">
                    <DisplayLayout BorderCollapseDefault="Separate" ColWidthDefault="80px" HeaderClickActionDefault="SortMulti"
                        Name="ug1" RowHeightDefault="18px" TableLayout="Fixed" Version="4.00" ViewType="Hierarchical"
                        ReadOnly="LevelOne">
                        <AddNewBox ButtonConnectorColor="Silver" ButtonConnectorStyle="Solid">
                            <style backcolor="LightGray" borderstyle="Solid" borderwidth="1px">

<BorderDetails ColorTop="White" WidthLeft="1px" WidthTop="1px" ColorLeft="White">
</BorderDetails>

</style>
                            <ButtonStyle BackColor="Gray" BorderColor="White" BorderStyle="Outset" BorderWidth="1px"
                                Cursor="Hand">
                            </ButtonStyle>
                        </AddNewBox>
                        <Pager Alignment="Center">
                            <style backcolor="LightGray" borderstyle="Solid" borderwidth="1px">

<BorderDetails ColorTop="White" WidthLeft="1px" WidthTop="1px" ColorLeft="White">
</BorderDetails>

</style>
                        </Pager>
                        <HeaderStyleDefault BackColor="#CBD6A6" BorderStyle="Solid" ForeColor="Black" HorizontalAlign="Left"
                            BorderWidth="1px" Font-Names="Tahoma" Font-Size="8pt">
                            <BorderDetails WidthLeft="1px" ColorLeft="White" ColorTop="White" WidthTop="1px" />
                            <Padding Left="5px" Right="5px" />
                        </HeaderStyleDefault>
                        <FrameStyle BorderStyle="Solid" BorderWidth="1px" Font-Names="Tahoma" Font-Size="8pt"
                            Width="100%" Height="400" BackColor="#FAFCF1" Cursor="Hand">
                        </FrameStyle>
                        <FooterStyleDefault BackColor="LightGray" BorderStyle="Solid" BorderWidth="1px">
                            <BorderDetails ColorLeft="White" ColorTop="White" WidthLeft="1px" WidthTop="1px" />
                        </FooterStyleDefault>
                        <ClientSideEvents AfterCellUpdateHandler="acuh" BeforeCellUpdateHandler="bcuh" />
                        <GroupByBox ButtonConnectorColor="Silver" ButtonConnectorStyle="Solid">
                            <BandLabelStyle BackColor="Gray" BorderColor="White" BorderStyle="Outset" BorderWidth="1px"
                                Cursor="Default">
                            </BandLabelStyle>
                            <style backcolor="DarkGray" bordercolor="White" borderstyle="Outset" borderwidth="1px"></style>
                        </GroupByBox>
                        <EditCellStyleDefault BorderStyle="None" BorderWidth="0px" Font-Names="Tahoma" Font-Size="8pt"
                            HorizontalAlign="Left" VerticalAlign="Middle">
                        </EditCellStyleDefault>
                        <RowStyleDefault BorderColor="#AAB883" BorderStyle="Solid" BorderWidth="1px" BackColor="White"
                            Font-Names="Tahoma" Font-Size="8pt" ForeColor="#333333" HorizontalAlign="Left"
                            VerticalAlign="Middle">
                            <Padding Left="7px" Right="7px" />
                            <BorderDetails WidthLeft="0px" WidthTop="0px" />
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
                        <FilterOptionsDefault AllString="(All)" EmptyString="(Empty)" NonEmptyString="(NonEmpty)">
                            <FilterDropDownStyle BackColor="White" BorderColor="Silver" BorderStyle="Solid" BorderWidth="1px"
                                CustomRules="overflow:auto;" Font-Names="Verdana,Arial,Helvetica,sans-serif"
                                Font-Size="11px" Width="200px">
                                <Padding Left="2px" />
                            </FilterDropDownStyle>
                            <FilterHighlightRowStyle BackColor="#151C55" ForeColor="White">
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
                                <FilterHighlightRowStyle BackColor="#151C55" ForeColor="White">
                                </FilterHighlightRowStyle>
                            </FilterOptions>
                        </igtbl:UltraGridBand>
                    </Bands>
                </igtbl:UltraWebGrid>
            </td>
            <td style="width: 1px;">
            </td>
        </tr>
        <tr>
            <td style="height: 17px; width: 15px;">
            </td>
            <td>
            </td>
            <td valign="top" style="height: 17px">
                <table cellpadding="0" cellspacing="1" border="0">
                    <tr>
                        <td style="width: 725px">
                            <asp:RadioButton ID="radSingle" runat="server" Text="Single Page" Width="100px" Checked="True"
                                AutoPostBack="True" GroupName="SingleMulti" OnCheckedChanged="radSingle_CheckedChanged"
                                Visible="false"></asp:RadioButton><asp:RadioButton ID="radMulti" runat="server" Text="Multi Page"
                                    Width="100px" AutoPostBack="True" GroupName="SingleMulti" OnCheckedChanged="radMulti_CheckedChanged"
                                    Visible="false"></asp:RadioButton><asp:CheckBox ID="CheckBox1" runat="server" Text="Intelli. Search"
                                        Width="104px" AutoPostBack="True" OnCheckedChanged="CheckBox1_CheckedChanged"
                                        Visible="False"></asp:CheckBox>
                            <input id="ExpandAll" style="width: 80px; height: 20px; background-color: #e0e0e0;
                                visibility: hidden" onclick="javascript:ExpandAllRows(this);" type="button" value="Expand All"
                                name="ExpandAll">
                        </td>
                        <td align="left" style="height: 17px" valign="top">
                            <asp:CheckBox runat="server" ID="sendItemsAll" Text="Check/Uncheck All" Visible="false"
                                onClick="doCheckAll();" />
                        </td>
                    </tr>
                </table>
            </td>
            <td style="width: 15px;">
            </td>
        </tr>
    </table>
    <asp:Button ID="btnValidate" runat="server" Text="for Validation" Visible="False">
    </asp:Button><asp:LinkButton ID="LinkButton1" runat="server" Visible="False">LinkButton</asp:LinkButton>
    <asp:TextBox ID="TextBox1" runat="server" Width="1px"></asp:TextBox>
    <asp:TextBox ID="TextBox2" runat="server" Width="1px"></asp:TextBox>&nbsp;
    <cc1:UltraWebGridExcelExporter ID="UltraWebGridExcelExporter1" runat="server">
    </cc1:UltraWebGridExcelExporter>
    <asp:Button ID="btnReset" runat="server" Text="Reset" Width="80px" Height="20px"
        BackColor="#E0E0E0" Visible="False" OnClick="btnReset_Click"></asp:Button>
    <asp:Button ID="butHideCol" runat="server" Text="Hide" Width="80px" Height="20px"
        BackColor="#E0E0E0" Visible="False" OnClick="butHideCol_Click"></asp:Button>
    <asp:Button ID="btnSortAsce" runat="server" Text="Asce." Width="80px" Height="20px"
        BackColor="#E0E0E0" Visible="False" OnClick="btnSortAsce_Click"></asp:Button>
    <asp:Button ID="btnSortDesc" runat="server" Text="Desc." Width="80px" Height="20px"
        BackColor="#E0E0E0" Visible="False" OnClick="btnSortDesc_Click"></asp:Button>
    <asp:Button ID="btnPrint" runat="server" Text="Print" Width="80px" Height="20px"
        BackColor="#E0E0E0" Visible="False" OnClick="btnPrint_Click"></asp:Button>
    <asp:Button ID="btnExcel" runat="server" Text="Excel" Width="80px" Height="20px"
        BackColor="#E0E0E0" Visible="False" OnClick="btnExcel_Click"></asp:Button>
    <asp:Button ID="btnXML" runat="server" Text="XML" Width="80px" Height="20px" BackColor="#E0E0E0"
        Visible="False" OnClick="btnXML_Click"></asp:Button>
    <asp:Button ID="btnBack" runat="server" Text="<< Back" Width="60px" DESIGNTIMEDRAGDROP="14"
        Visible="False" OnClick="Button1_Click"></asp:Button>
    <asp:Button ID="Button1" runat="server" Text="<< Back" Width="60px" DESIGNTIMEDRAGDROP="14"
        Visible="False" OnClick="Button1_Click"></asp:Button>
    <asp:Button ID="btnPDF" runat="server" Text="PDF" Width="60px" Visible="False" OnClick="btnPDF_Click">
    </asp:Button>
    <asp:Button ID="btnDOC" runat="server" Text="DOC" Width="60px" Visible="False" OnClick="btnDOC_Click">
    </asp:Button>
    <asp:Button ID="btnEMAIL" runat="server" Text="EMAIL" Width="60px" Visible="False"
        OnClick="btnEMAIL_Click"></asp:Button>
    <!-- <asp:DropDownList ID="EmailList" runat="server" Visible="True" Width="200px"></asp:DropDownList> -->
    <asp:TextBox ID="CompanyListText" runat="server" Width="0px" Height="0Px"></asp:TextBox>
    <asp:TextBox ID="MessageListText" runat="server" Width="0px" Height="0Px"></asp:TextBox>
    <asp:TextBox ID="EmailListText" runat="server" Width="0px" Height="0Px"></asp:TextBox>
    </form>
</body>
</html>
