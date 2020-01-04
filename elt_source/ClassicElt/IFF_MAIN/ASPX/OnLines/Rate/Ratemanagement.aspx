<%@ Register TagPrefix="igcmbo" Namespace="Infragistics.WebUI.UltraWebGrid" Assembly="Infragistics.WebUI.UltraWebGrid, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igcmbo" Namespace="Infragistics.WebUI.UltraWebGrid" Assembly="Infragistics.WebUI.UltraWebGrid, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igcmbo" Namespace="Infragistics.WebUI.UltraWebGrid" Assembly="Infragistics.WebUI.UltraWebGrid, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igtbl" Namespace="Infragistics.WebUI.UltraWebGrid" Assembly="Infragistics.WebUI.UltraWebGrid, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>

<%@ Page Language="c#" Inherits="IFF_MAIN.ASPX.OnLines.Rate.Ratemanagement" CodeFile="Ratemanagement.aspx.cs" CodePage="65001" %>

<%@ Register Assembly="iMoon.WebControls.ComboBox" Namespace="iMoon.WebControls"
    TagPrefix="iMoon" %>

<%@ Register TagPrefix="cc4" Namespace="Infragistics.WebUI.UltraWebGrid.ExcelExport" Assembly="Infragistics.WebUI.UltraWebGrid.ExcelExport, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="cc3" Namespace="Infragistics.WebUI.UltraWebGrid" Assembly="Infragistics.WebUI.UltraWebGrid, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igtxt" Namespace="Infragistics.WebUI.WebDataInput" Assembly="Infragistics.WebUI.WebDataInput, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>RateManagement</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta content="C#" name="CODE_LANGUAGE" />
    <meta content="JavaScript" name="vs_defaultClientScript" />
    <meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema" />
    <link href="../../../ASPX/CSS/elt_css.css" rel="stylesheet" type="text/css" />
    <script language='javascript' type="text/jscript">

        function SetCombo(q) {
            fixProgressBar();
            var s = document.form1.DropDownList1.selectedIndex;


            if (s == 1 || s == 3) {
                document.form1.ComboBox1.disabled = true;
                document.form1.ComboBox1_Text.disabled = true;
                document.form1.ComboBox1.value = "";
                document.form1.ComboBox1_Text.value = "";
                document.form1.ComboBox1_Text.style.backgroundColor = "#E0E0E0";
                document.form1.ComboBox1.style.backgroundColor = "#E0E0E0";
            }
            else {
                if (!q) {
                    //document.form1.ComboBox1.value = "";
                    //document.form1.ComboBox1_Text.value = "";	        
                }
                document.form1.ComboBox1_Text.style.backgroundColor = "#FFFFC0";
                document.form1.ComboBox1.style.backgroundColor = "#FFFFC0";
                document.form1.ComboBox1.disabled = false;
                document.form1.ComboBox1_Text.disabled = false;
            }
        }

        function MsgCombo() {
            var s = document.form1.DropDownList1.selectedIndex;

            if (s == 1 || s == 3) {
                document.form1.ComboBox1.value = "";
                alert("You can not select company name for airline or IATA rate.");
            }
        }

        function ReqDataCheck() {
            if (document.form1.ComboBox1.value != "") {
                document.form1.txtNum.value = document.form1.ComboBox1.selectedIndex;
                return true;
            }
        }

        function AddRow(strGrid, strBand) {
            var oGrid = igtbl_getGridById(strGrid);
            if (!oGrid) {
                return false;
            }

            igtbl_addNew(oGrid.Id, strBand);
            igtbl_addNew(oGrid.Id, '1');
            return false;
        }

        function formRest(tr, id) {

            ReqDataCheck();

            var idText = id.Key;

            if (idText == 'NEW') {
                __doPostBack("btnNew", "");
                return true;
            }
            else if (idText == 'CANCEL') {
                __doPostBack("btnReset", "");
                return true;
            }
            else if (idText == 'RESET') {
                __doPostBack("btnReset", "");
                return true;
            }
            else if (idText == 'EXEC') {
                ReqDataCheck();
                __doPostBack("btnShow", "");
                return true;
            }
            else if (idText == 'DCI') {
                __doPostBack("btnDelete", "");
                return true;
            }
            else if (idText == 'SAVE') {
                //		if(!dataValidation()) return true;
                __doPostBack("btnSave", "");
            }
            else if (idText == 'Asce') {
                __doPostBack("btnSortAsce", "");
            }
            else if (idText == 'Desc') {
                __doPostBack("btnSortDesc", "");
            }
            else if (idText == 'EXCEL') {
                __doPostBack("btnExcel", "");
            }
            else if (idText == 'XML') {
                __doPostBack("btnXML", "");
            }
            else if (idText == 'BACK') {
                __doPostBack("btnBack", "");
                return true;
            }


        }

        function SelectAllRows() {

            var oGrid = igtbl_getGridById('UltraWebGrid1');
            var oRows = oGrid.Rows;
            oGrid.suspendUpdates(true);
            for (i = 0; i < oRows.length; i++) {
                oRow = oRows.getRow(i);
                oRow.getCellFromKey('Chk').Element.style.backgroundImage = 'url(../../../Images/mark_x.gif)';
                oRow.getCellFromKey("x").setValue("x");
                oRow.getCellFromKey('e').setValue('e');
                oRow.getCellFromKey("x").Element.style.backgroundColor = "Red";
                oRow.getCellFromKey('e').Element.style.backgroundColor = "Lavender";
                var oChildRows = oRow.Rows;
                for (j = 0; j < oChildRows.length; j++) {
                    oChildRow = oChildRows.getRow(j);
                    oChildRow.getCellFromKey('Chk').Element.style.backgroundImage = 'url(../../../Images/mark_x.gif)';
                    oChildRow.getCellFromKey("x").setValue("x");
                    oChildRow.getCellFromKey('e').setValue('e');
                    oChildRow.getCellFromKey("x").Element.style.backgroundColor = "Red";
                    oChildRow.getCellFromKey('e').Element.style.backgroundColor = "Lavender";
                }
            }

            oGrid.suspendUpdates(false);
        }

        function unSelectAllRows() {

            var oGrid = igtbl_getGridById('UltraWebGrid1');
            var oRows = oGrid.Rows;
            oGrid.suspendUpdates(true);
            for (i = 0; i < oRows.length; i++) {
                oRow = oRows.getRow(i);
                oRow.getCellFromKey('Chk').Element.style.backgroundImage = 'url(../../../Images/mark_o.gif)';
                oRow.getCellFromKey("x").setValue("");
                oRow.getCellFromKey('e').setValue('e');
                oRow.getCellFromKey("x").Element.style.backgroundColor = "Lavender";
                oRow.getCellFromKey('e').Element.style.backgroundColor = "Lavender";
                var oChildRows = oRow.Rows;
                for (j = 0; j < oChildRows.length; j++) {
                    oChildRow = oChildRows.getRow(j);
                    oChildRow.getCellFromKey('Chk').Element.style.backgroundImage = 'url(../../../Images/mark_o.gif)';
                    oChildRow.getCellFromKey("x").setValue("");
                    oChildRow.getCellFromKey('e').setValue('e');
                    oChildRow.getCellFromKey("x").Element.style.backgroundColor = "Lavender";
                    oChildRow.getCellFromKey('e').Element.style.backgroundColor = "Lavender";
                }
            }

            oGrid.suspendUpdates(false);

        }

        function gridRowDelete(strGrid) {
            igtbl_deleteSelRows(strGrid);
        }

        function gridRowDeleteAll(strGrid) {
            var oGrid = igtbl_getGridById(strGrid);
            var oRows = oGrid.Rows;

            for (i = (oRows.length - 1) ; i >= 0; i--) {
                strRow = strGrid + "r_" + i;
                igtbl_deleteRow(strGrid, strRow);
            }
        }

        function DeleteRows() {

            var oGrid = igtbl_getGridById('UltraWebGrid1');
            var oRows = oGrid.Rows;
            oGrid.suspendUpdates(true);

            for (i = oRows.length - 1; i >= 0; i--) {
                oRow = oRows.getRow(i);
                if (oRow.getCellFromKey('Chk').Element.style.backgroundImage == 'url(../../../Images/mark_x.gif)') {
                    if (oRow) oRow.deleteRow();
                }
                var oChildRows = oRow.Rows;
                for (j = oChildRows.length - 1; j >= 0; j--) {
                    oChildRow = oChildRows.getRow(j);
                    if (oChildRow.getCellFromKey('Chk').Element.style.backgroundImage == 'url(../../../Images/mark_x.gif)') {
                        if (oChildRow) oChildRow.deleteRow();
                    }
                }
            }

            oGrid.suspendUpdates(false);
        }


        /*
        var igS;
        function acuh(tableName,itemName) {
        var cell = igtbl_getElementById(itemName);
              cell.innerHTML = igS;		
        }
        
        function bcuh(tableName,itemName) {
        var cell = igtbl_getElementById(itemName);
             igS = cell.innerHTML; 	
        }
        */

        function vlsch(gn, ValueListID, cellId) {

            var cell = igtbl_getCellById(cellId);
            var row = igtbl_getRowById(cellId);

            if (cell.Column.Key == "Company Name") {
                var list = igtbl_getElementById(ValueListID);
                row.getCellFromKey('Code').setValue(list.value);
            }
            //	else if(cell.Column.Key=="Airline") {
            //		var list = igtbl_getElementById(ValueListID);
            //		row.getCellFromKey('Airline_Code').setValue(list.value);
            //	}

        }

        function acuh(gridName, cellId) {

            var row = igtbl_getRowById(cellId);
            var s = row.getCellFromKey("a").getValue();

            var cell = igtbl_getCellById(cellId);
            if (cell.getValue() == 0) {
                cell.setValue("");
            }

            if (s == "a") {
                return false;
            }

            s = row.getCellFromKey("x").getValue();
            if (s == "x") {
                return false;
            }
            row.getCellFromKey('e').setValue('e');
            row.getCellFromKey('e').Element.style.backgroundColor = "Lavender";
            if (row.ParentRow != null) {
                row.ParentRow.getCellFromKey('e').setValue('e');
                row.ParentRow.getCellFromKey('e').Element.style.backgroundColor = "Lavender";
            }
        }

        function arih(gridName, rowId) {

            var s = document.form1.DropDownList1.selectedIndex;

            var row = igtbl_getRowById(rowId);
            row.getCellFromKey("a").setValue("a");
            row.getCellFromKey("a").Element.style.backgroundColor = "LightGreen";
            var band = igtbl_getBandById(rowId);
            if (band.Key == 'RateHeader') {
                row.getCellFromKey('R0').setValue('Min.($)');
                row.getCellFromKey('R0').Element.style.backgroundColor = "Lavender";
                row.getCellFromKey('R1').setValue('+Min.');
                row.getCellFromKey('R1').Element.style.backgroundColor = "Lavender";
                row.getCellFromKey('Blank').setValue('Share');

                if (document.form1.ComboBox1_Text.value != "") {
                    row.getCellFromKey('Company Name').setValue(document.form1.ComboBox1_Text.value);
                    row.getCellFromKey('Code').setValue(document.form1.ComboBox1.value);
                }
                else {
                    row.getCellFromKey('Company Name').setValue('Dbl Click...');
                }

                row.getCellFromKey('Origin').setValue('Dbl Click...');
                row.getCellFromKey('Destination').setValue('Dbl Click...');
                row.getCellFromKey('Kg/Lb').setValue('Dbl Click...');
            }
            else {
                row.ParentRow.getCellFromKey('e').setValue('e');
                row.ParentRow.getCellFromKey('e').Element.style.backgroundColor = "Lavender";
                row.getCellFromKey('Airline').setValue('Dbl Click...');
            }
        }

        function beemh(gridName, cellId) {
            var band = igtbl_getBandById(cellId);
            var cell = igtbl_getCellById(cellId);
            var row = igtbl_getRowById(cellId);

            var s = row.getCellFromKey("a").getValue();
            if (s == "a") {
                return false;
            }

            if (cell.Column.Key == "Add") return true;

            if (band.Key == 'RateDetail') {
                if (cell.Column.Key == "Company Name") {
                    igtbl_EndEditMode(gridName);
                    //				alert( "You can not edit Company name.");
                    return true;
                }
            }
            else if (band.Key == 'RateHeader') {
                if (cell.Column.Key == "Company Name" || cell.Column.Key == "Origin" || cell.Column.Key == "Destination" || cell.Column.Key == "Kg/Lb") {
                    igtbl_EndEditMode(gridName);
                    //				alert( "You can not edit this field.");
                    return true;
                }
            }
        }
        function ccbh(gridName, cellId) {

            //var g=igtbl_getGridById(gridName);
            var row = igtbl_getRowById(cellId);
            var cell = row.getCell(1);

            if (row != null)
                igtbl_setActiveRow(gridName, row.Element);
            else {
                var cell = igtbl_getActiveCell(gridName);
                if (cell != null)
                    igtbl_setActiveCell(gridName, cell.Element);
            }

            igtbl_addNew(gridName, '1');
            return false;

        }

        function cch(gridName, cellId, button) {

            var SelectedChild = 'url(../../../Images/mark_o.gif)';
            var SelectedParent = 'url(../../../Images/mark_o.gif)';
            var row = igtbl_getRowById(cellId);
            var cell = igtbl_getCellById(cellId);
            var oCell = igtbl_getCellById(cellId);
            var cUrl = oCell.Element.style.backgroundImage;
            var band = igtbl_getBandById(row.Id);
            if (band.Key == 'RateDetail') {

                if (cell.Column.Key == "Chk") {
                    if (cUrl == SelectedChild) {
                        oCell.Element.style.backgroundImage = 'url(../../../Images/mark_x.gif)';
                        row.getCellFromKey("x").setValue("x");
                        row.getCellFromKey("x").Element.style.backgroundColor = "Red";
                        row.ParentRow.getCellFromKey('e').setValue('e');
                        row.ParentRow.getCellFromKey('e').Element.style.backgroundColor = "Lavender";
                        row.setSelected(true);
                    }
                    else {
                        if (row.ParentRow.getCellFromKey("x").getValue() == "x") {
                            //						alert('Please uncheck the parent node first.');
                            //						return false;
                            row.ParentRow.getCellFromKey("x").setValue('');
                            row.ParentRow.getCellFromKey("e").setValue('e');
                            row.ParentRow.getCellFromKey("Chk").Element.style.backgroundImage = 'url(../../../Images/mark_o.gif)';
                        }
                        oCell.Element.style.backgroundImage = 'url(../../../Images/mark_o.gif)';
                        row.getCellFromKey("x").setValue('');
                        row.getCellFromKey("x").Element.style.backgroundColor = "Lavender";
                        row.ParentRow.getCellFromKey('e').setValue('e');
                        row.ParentRow.getCellFromKey('e').Element.style.backgroundColor = "Lavender";
                        row.setSelected(true);
                    }
                }
            }
            else if (band.Key == 'RateHeader') {
                if (cell.Column.Key == "Add") {
                    igtbl_addNew(gridName, '1');
                    return false;
                }

                if (cell.Column.Key == "Chk") {
                    if (cUrl == SelectedParent) {

                        oCell.Element.style.backgroundImage = 'url(../../../Images/mark_x.gif)';
                        row.getCellFromKey("x").setValue("x");
                        row.getCellFromKey('e').setValue('e');
                        row.getCellFromKey("x").Element.style.backgroundColor = "Red";
                        row.getCellFromKey('e').Element.style.backgroundColor = "Lavender";

                        row.setSelected(true);
                        var oChildRows = row.Rows;
                        for (j = 0; j < oChildRows.length; j++) {
                            oChildRow = oChildRows.getRow(j);
                            oChildRow.getCellFromKey("x").setValue("x");
                            oChildRow.getCellFromKey("x").Element.style.backgroundColor = "Red";

                            oChildRow.setSelected(true);
                            oChildoCell = oChildRow.getCell(1);
                            oChildoCell.Element.style.backgroundImage = 'url(../../../Images/mark_x.gif)';
                        }
                    }
                    else {

                        oCell.Element.style.backgroundImage = 'url(../../../Images/mark_o.gif)';
                        row.getCellFromKey("x").setValue('');
                        row.getCellFromKey('e').setValue('e');
                        row.getCellFromKey("x").Element.style.backgroundColor = "Lavender";
                        row.getCellFromKey('e').Element.style.backgroundColor = "Lavender";
                        row.setSelected(true);
                        var oChildRows = row.Rows;
                        for (j = 0; j < oChildRows.length; j++) {
                            oChildRow = oChildRows.getRow(j);
                            oChildRow.getCellFromKey("x").setValue('');
                            oChildRow.getCellFromKey("x").Element.style.backgroundColor = "Lavender";
                            oChildRow.setSelected(true);
                            oChildoCell = oChildRow.getCell(1);
                            oChildoCell.Element.style.backgroundImage = 'url(../../../Images/mark_o.gif)';
                        }
                    }
                }
            }

        }

        function ExpandAllRows(btnEl) {
            var oUltraWebGrid1 = igtbl_getGridById('UltraWebGrid1');
            if (!oUltraWebGrid1) return true;
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
            var oUltraWebGrid1 = igtbl_getGridById('UltraWebGrid1');
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
                document.getElementById("UltraWebGrid1_main").style.height = parseInt(y -
                document.getElementById("UltraWebGrid1_main").offsetTop - 30) + "px";
            }
        }

        window.onresize = resize_table;

    </script>
    <link href="../../CSS/AppStyle.css" type="text/css" rel="stylesheet" />
    <!--  #INCLUDE FILE="../../include/common.htm" -->
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

    <style type="text/css">
        body
        {
            margin-left: 0px;
            margin-right: 0px;
            margin-bottom: 0px;
        }
    </style>
</head>
<body onload='javascript:SetCombo(true); resize_table();'>
    <!--
				<table  style="height:12;width:100%" cellspacing='0' cellpadding='0'  border='0'>
				<tr>
					<td valign='top' align='center' style="height: 7px"><IMG src='../../../images/spacer.gif' height=6 width=338><IMG height=7 src=
					<%	
        if (Request.UrlReferrer != null && windowName != "PopWin")
        {
            Response.Write("'../../../images/pointer_md.gif'");
        }
                    %>
                    width=11><IMG height=6 src='../../../images/spacer.gif' width=300></td>
				</tr>
			</table>
			-->
    <form id="form1" method="post" runat="server">
        <table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
            <tr>
                <td height="32" align="left" valign="middle" class="pageheader">Rate Manager</td>
            </tr>
        </table>
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="73beb6" bgcolor="#73beb6" class="border1px">
            <tr bgcolor="ccebed">
                <td height="8" align="left" valign="top" bgcolor="ccebed">
                    <asp:Label ID='lblError' runat="server" Width="100%" Font-Bold="True" ForeColor="Red" Font-Italic="True"
                        Font-Underline="True"></asp:Label></td>
            </tr>
            <tr bgcolor="73beb6">
                <td height="1" align="left" valign="top"></td>
            </tr>
            <tr align="left" bgcolor="ecf7f8">
                <td align="center" valign="middle" bgcolor="ecf7f8" style="height: 20px">
                    <br>
                    <table width="75%" border="0" cellpadding="4" cellspacing="0" bordercolor="73beb6" bgcolor="#FFFFFF" class="border1px">
                        <tr bgcolor="ecf7f8">
                            <td width="1%">&nbsp;</td>
                            <td width="8%" height="24" bgcolor="ecf7f8" class="bodyheader">Rate Type</td>
                            <td width="31%" bgcolor="ecf7f8">
                                <asp:DropDownList CssClass="bodycopy" ID="DropDownList1" runat="server" Width="140px">
                                    <asp:ListItem Value="Customer Selling Rate" Selected="True">Customer Selling Rate</asp:ListItem>
                                    <asp:ListItem Value="Airline Buying Rate">Airline Buying Rate</asp:ListItem>
                                    <asp:ListItem Value="Agent Buying Rate">Agent Buying Rate</asp:ListItem>
                                    <asp:ListItem Value="IATA Rate">IATA Rate</asp:ListItem>
                                </asp:DropDownList></td>
                            <td width="20%" align="left" valign="middle" bgcolor="ecf7f8" class="bodycopy"><span class="bodyheader">Business Name </span>(Optional)</td>
                            <td width="33%" bgcolor="ecf7f8" class="smallselect" valign="middle">
                                <iMoon:ComboBox ID="ComboBox1" runat="server" CssClass="ComboBox" Rows="20" Width="350px">
                                    <asp:ListItem>Unbound</asp:ListItem>
                                </iMoon:ComboBox></td>
                            <td align="right" bgcolor="#ecf7f8" width="7%"></td>
                            <td width="7%" align="right" bgcolor="ecf7f8">
                                <asp:ImageButton ID='goBtn' runat="server" ImageUrl="../../../images/button_go.gif" OnClick="ImageButton1_Click1"></asp:ImageButton>
                            </td>
                        </tr>
                    </table>
                    <br>
                </td>
            </tr>
            <tr bgcolor="73beb6">
                <td height="1" align="left" valign="top"></td>
            </tr>
            <tr align="center" bgcolor="ccebed">
                <td valign="middle" class="bodycopy" style="height: 1px">
                    <asp:ImageButton runat="server" ImageUrl="../../../Images/button_save.gif" ID="btnSave" OnClick="btnSave_Click"  />
                   
                    &nbsp;</td>
            </tr>
        </table>
        <table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
            <tr>
                <td style="height: 13px">


                    <table id='Table2' cellspacing='0' cellpadding='0' width="100%">

                        <tr>
                            <td>
                                <asp:Panel ID="Panel1" runat="server" Height="10px" Visible="False">
                                     <asp:ImageButton ID="btnExcelExport" runat="server" ImageUrl="../../../Images/button_exel.gif"
                            OnClick="btnExcelExport_Click" style="float:right;" />
                                    <img alt="Select All" onclick="SelectAllRows()" src="../../../images/button_selectall.gif" style="cursor: hand" />&nbsp;&nbsp;&nbsp;&nbsp;
                          <img alt="Clear All" onclick="unSelectAllRows()" src="../../../images/button_clear.gif" style="cursor: hand" />&nbsp;&nbsp;&nbsp;&nbsp;<img
                              alt="Delete Checked" designtimedragdrop="189" onclick="DeleteRows('UltraWebGrid1')"
                              src="../../../images/button_delete_ckitem.gif" style="cursor: hand" />&nbsp;&nbsp;&nbsp;&nbsp;<img alt="Add Item" onclick="AddRow('UltraWebGrid1','0')"
                                  src="../../../images/button_add_ig.gif" style="cursor: hand" />
                                    
                                     </asp:Panel>
                            </td>
                        </tr>
                        <tr>
                            <td valign='top' style="height: 341px">
                                <igtbl:UltraWebGrid ID='UltraWebGrid1' runat="server" Height="340px" Width="100%" OnInitializeLayout="UltraWebGrid1_InitializeLayout1" OnInitializeRow="UltraWebGrid1_InitializeRow1" OnPageIndexChanged="UltraWebGrid1_PageIndexChanged1" Visible="False">
                                    <DisplayLayout ColWidthDefault="80px" AllowAddNewDefault="Yes" RowHeightDefault="20px" Version="4.00" ViewType="Hierarchical" HeaderClickActionDefault="SortMulti" BorderCollapseDefault="Separate" Name="UltraWebGrid1" CellClickActionDefault="Edit" NoDataMessage="Please select a rate type. And then click the 'GO' button." AllowUpdateDefault="Yes" RowSelectorsDefault="No" AllowDeleteDefault="Yes">

                                        <AddNewBox Prompt="Enter New Company" Location="Top">

                                            <style borderwidth="1px" borderstyle="Solid" backcolor="LightGray">
                                                <BorderDetails ColorTop="White" WidthLeft="1px" StyleBottom="Outset" WidthTop="1px" StyleTop="Outset" StyleRight="Outset" StyleLeft="Outset" ColorLeft="White" > </BorderDetails >
                                            </style>

                                            <ButtonStyle Width="70px" Cursor="Hand" BackgroundImage="../../../Images/button_add.gif" CustomRules="background-repeat:no-repeat"></ButtonStyle>
                                        </AddNewBox>

                                        <Pager>

                                            <style borderwidth="1px" borderstyle="Solid" backcolor="LightGray">
                                                <BorderDetails ColorTop="White" WidthLeft="1px" WidthTop="1px" ColorLeft="White" > </BorderDetails >
                                            </style>
                                        </Pager>

                                        <HeaderStyleDefault BorderStyle="Solid" ForeColor="Black" BackColor="#CCEBED" Height="0px">

                                            <BorderDetails WidthLeft="0px" StyleBottom="Solid" ColorBottom="204, 235, 237" WidthRight="0px" StyleTop="None" StyleRight="None" WidthBottom="1px" StyleLeft="None"></BorderDetails>
                                            <Margin Bottom="0px" Left="0px" Right="0px" Top="0px" />
                                            <Padding Bottom="0px" Left="0px" Right="0px" Top="0px" />
                                        </HeaderStyleDefault>

                                        <RowSelectorStyleDefault Cursor="Hand" BackColor="#CCEBED" CustomRules="background-position:center center;background-repeat:no-repeat">

                                            <BorderDetails WidthLeft="0px" ColorBottom="224, 224, 224" WidthTop="0px" WidthRight="0px" WidthBottom="0px"></BorderDetails>
                                        </RowSelectorStyleDefault>

                                        <FrameStyle Width="100%" Height="400" BorderWidth="1px" Font-Size="8pt" Font-Names="Tahoma" BorderColor="#CCEBED" BorderStyle="Solid"></FrameStyle>

                                        <FooterStyleDefault BorderWidth="1px" BorderStyle="Solid" BackColor="#CFDDF0">

                                            <BorderDetails ColorTop="White" WidthLeft="1px" WidthTop="1px" ColorLeft="White"></BorderDetails>
                                        </FooterStyleDefault>

                                        <ClientSideEvents ClickCellButtonHandler="ccbh" AfterCellUpdateHandler="acuh" ValueListSelChangeHandler="vlsch" BeforeEnterEditModeHandler="beemh" CellClickHandler="cch" AfterRowInsertHandler="arih"></ClientSideEvents>

                                        <GroupByBox>

                                            <BandLabelStyle BackColor="White"></BandLabelStyle>
                                        </GroupByBox>

                                        <EditCellStyleDefault BorderWidth="0px" BorderStyle="None"></EditCellStyleDefault>

                                        <RowStyleDefault BorderWidth="1px" BorderColor="#CCEBED" BorderStyle="Solid">

                                            <Padding Left="3px"></Padding>

                                            <BorderDetails WidthLeft="0px" WidthTop="0px" WidthRight="1px" StyleLeft="None"></BorderDetails>
                                        </RowStyleDefault>
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

                                    <bands>
                                        <igcmbo:ultragridband>
                                            <AddNewRow View="NotSet" Visible="NotSet"></AddNewRow>
                                            <filteroptions allstring="" emptystring="" nonemptystring="">
                                            <FilterDropDownStyle BorderWidth="1px" BorderColor="Silver" BorderStyle="Solid" Font-Size="11px" Font-Names="Verdana,Arial,Helvetica,sans-serif" BackColor="White" Width="200px" CustomRules="overflow:auto;">
                                                <Padding Left="2px"></Padding>
                                            </FilterDropDownStyle>
                                            <FilterHighlightRowStyle ForeColor="#FFFFFF" BackColor="#151C55"></FilterHighlightRowStyle>
                                            </filteroptions>
                                        </igcmbo:ultragridband>
                                    </bands>
                                </igtbl:UltraWebGrid></td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        <asp:Button ID="btnValidate" runat="server" Visible="False" Text="for Validation"></asp:Button><asp:LinkButton ID="LinkButton1" runat="server" Visible="False">LinkButton</asp:LinkButton><asp:Button ID="btnPrint" runat="server" Height="20px" Width="80px" BackColor="#E0E0E0" Visible="False"
                Text="Print" OnClick="btnPrint_Click"></asp:Button><asp:Button ID="btnXML" runat="server" Height="20px" Width="80px" BackColor="#E0E0E0" Visible="False"
                        Text="XML" OnClick="btnXML_Click"></asp:Button><igtxt:WebNumericEdit ID="WebNumericEdit1" runat="server" Width="50px" Visible="False" MinDecimalPlaces="Two" BorderColor="Lime" BorderStyle="Solid"></igtxt:WebNumericEdit>
        <igtxt:WebPercentEdit ID="WebPercentEdit1" runat="server" Width="50px" Visible="False" MinDecimalPlaces="Two"
            MaxLength="999" BorderColor="Lime" BorderStyle="Solid">
        </igtxt:WebPercentEdit>
        <igtxt:WebNumericEdit ID="WebNumericEdit2" runat="server" Width="50px" Visible="False" BorderColor="Lime" BorderStyle="Solid">
        </igtxt:WebNumericEdit>
        <asp:TextBox ID="txtNum" runat="server" Width="1px"></asp:TextBox><asp:TextBox ID="txtSavedRateType" runat="server" Width="1px"></asp:TextBox><asp:TextBox ID="txtSavedOrg" runat="server" Width="1px"></asp:TextBox>
        <asp:Button ID="btnShow" runat="server" Width="60px" Font-Size="Larger"
            Visible="False" OnClick="btnShow_Click"></asp:Button>
        <cc4:UltraWebGridExcelExporter ID="UltraWebGridExcelExporter1" runat="server">
        </cc4:UltraWebGridExcelExporter>
    </form>
</body>
<!--  #INCLUDE FILE="../../include/StatusFooter.htm" -->
</html>
