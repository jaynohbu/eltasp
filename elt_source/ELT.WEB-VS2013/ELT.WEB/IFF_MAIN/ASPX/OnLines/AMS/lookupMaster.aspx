<%@ Page language="c#" CodeFile="lookupMaster.aspx.cs" AutoEventWireup="false" Inherits="IFF_MAIN.ASPX.OnLines.AMS.lookupMaster" %>
<%@ Register TagPrefix="igtbar" Namespace="Infragistics.WebUI.UltraWebToolbar" Assembly="Infragistics.WebUI.UltraWebToolbar, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igtbl" Namespace="Infragistics.WebUI.UltraWebGrid" Assembly="Infragistics.WebUI.UltraWebGrid, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
  <HEAD>
    <title>lookup</title>
<meta content="Microsoft Visual Studio .NET 7.1" name=GENERATOR>
<meta content=C# name=CODE_LANGUAGE>
<meta content=JavaScript name=vs_defaultClientScript>
<meta content=http://schemas.microsoft.com/intellisense/ie5 name=vs_targetSchema><LINK href="/IFF_MAIN/ASPX/CSS/AppStyle.css" type=text/css rel=stylesheet >
<script language=javascript>

function ExpandAllRows(btnEl) {		
var oUltraWebGrid1 = igtbl_getGridById('UltraWebGrid1');
if(!oUltraWebGrid1) return true;		
	var oGrid = oUltraWebGrid1;
	var oBands = oGrid.Bands;
	var oBand = oBands[0];
	var oColumns = oBand.Columns;
	var count = oColumns.length;
	var oRows = oGrid.Rows;
	oGrid.suspendUpdates(true);
	for(i=0; i<oRows.length; i++) {
		oRow = oRows.getRow(i);
		if(btnEl.value == "Expand All") {
			oRow.setExpanded(true);
		}
		else {
			oRow.setExpanded(false);
		}
	}
	oGrid.suspendUpdates(false);
	if(btnEl.value == "Expand All") 
		btnEl.value = "Collapse All";
	else		
		btnEl.value = "Expand All";		
}
	
function resetFind() {
	var btnEl = igtbl_getElementById("Find");
	btnEl.value="Find";
}

function FindValue(btnEl) {
var oUltraWebGrid1 = igtbl_getGridById('UltraWebGrid1');
	var eVal = igtbl_getElementById("FindVal");
	findValue = eVal.value;
	var re = new RegExp("^" + findValue, "gi");
	if(btnEl.value=="Find") {
		igtbl_clearSelectionAll(oUltraWebGrid1.Id)
		var oCell = oUltraWebGrid1.find(re);
		if(oCell != null) {
			btnEl.value="Find Next";
			var row = oCell.Row.ParentRow;
			while(row != null) {
				row.setExpanded(true);
				row = row.ParentRow;
			}
			oCell.setSelected(true);
		}
		else
		{
		alert("Not found! : "+findValue)
		}
	}
	else {
		var oCell = oUltraWebGrid1.findNext();
		if(oCell == null) {
			btnEl.value="Find";
		}
		else {
			var row = oCell.Row.ParentRow;
			while(row != null) {
				row.setExpanded(true);
				row = row.ParentRow;
			}
			oCell.setSelected(true);
		}
	}
}


function MyDblClick(gridId, cellId) {

var column = igtbl_getColumnById(cellId);
if(column==null) return;
var row = igtbl_getRowById(cellId);
var strText = row.getCell(1).getValue(); 
window.opener.document.form1.txt_doc_number.value=strText;
window.opener.__doPostBack("btnShow", "");
window.close();
}

function myClose() {
//window.opener.document.form1.drSearch.selectedIndex = 0;
window.close();
}

</script>
</HEAD>
<BODY>
<form id=form1 method=post runat="server"><FONT face=±¼¸²>
<TABLE id=Table3 style="WIDTH: 600px" height="100%" cellSpacing=0 cellPadding=0 
bgColor=#ffffff>
  <TR>
    <TD style="WIDTH: 17px; HEIGHT: 2px"></TD>
    <TD style="WIDTH: 540px; HEIGHT: 2px"><FONT face=±¼¸² 
      ></FONT></TD></TR>
  <TR>
    <TD style="WIDTH: 17px; HEIGHT: 4px"></TD>
    <TD style="WIDTH: 540px; HEIGHT: 4px"><asp:label id=lblError runat="server" Font-Bold="True" Font-Italic="True" ForeColor="Red" DESIGNTIMEDRAGDROP="55" Font-Underline="True" Width="100%"></asp:label></TD></TR>
  <TR>
    <TD style="WIDTH: 17px; HEIGHT: 14px"></TD>
    <TD style="WIDTH: 540px; HEIGHT: 14px"><FONT face=±¼¸² 
      ><asp:label id=Label1 runat="server" Font-Bold="True" Font-Italic="True" ForeColor="Navy" Font-Underline="True" Width="100%" Font-Size="8pt">* Please 'double click', if you want to tansfer the item.</asp:label></FONT></TD></TR>
  <TR>
    <TD style="WIDTH: 17px; HEIGHT: 14px"></TD>
    <TD style="WIDTH: 540px; HEIGHT: 14px"><INPUT id=ExpandAll style="WIDTH: 80px; HEIGHT: 20px; BACKGROUND-COLOR: #e0e0e0" onclick=javascript:ExpandAllRows(this); type=button value="Expand All" name=ExpandAll><INPUT 
      id=FindVal onkeydown=javascript:resetFind(this); 
      style="WIDTH: 304px; HEIGHT: 17px" type=text size=45 name=FindVal 
      ><INPUT id=Find style="WIDTH: 32px; HEIGHT: 20px; BACKGROUND-COLOR: #e0e0e0" onclick=javascript:FindValue(this); type=button value=Find name=Find></TD></TR>
  <TR>
    <TD style="WIDTH: 17px" vAlign=top align=left></TD>
    <TD vAlign=top align=left width="100%"><igtbl:ultrawebgrid id=UltraWebGrid1 runat="server">
<DisplayLayout ColWidthDefault="120px" StationaryMargins="Header" AllowSortingDefault="OnClient" RowHeightDefault="20px" RowSizingDefault="Free" Version="4.00" SelectTypeRowDefault="Single" ViewType="Hierarchical" HeaderClickActionDefault="SortSingle" BorderCollapseDefault="Separate" AllowColSizingDefault="Free" RowSelectorsDefault="No" Name="UltraWebGrid1" TableLayout="Fixed" CellClickActionDefault="RowSelect">

<AddNewBox>

<Style BorderWidth="1px" BorderStyle="Solid" BackColor="LightGray">

<BorderDetails ColorTop="White" WidthLeft="1px" WidthTop="1px" ColorLeft="White">
</BorderDetails>

</Style>

</AddNewBox>

<Pager>

<Style BorderWidth="1px" BorderStyle="Solid" BackColor="LightGray">

<BorderDetails ColorTop="White" WidthLeft="1px" WidthTop="1px" ColorLeft="White">
</BorderDetails>

</Style>

</Pager>

<HeaderStyleDefault BorderStyle="Solid" HorizontalAlign="Left" ForeColor="#1B5AA1" BackColor="#CFDDF0" Height="17px">

<BorderDetails WidthLeft="0px" StyleBottom="Solid" ColorBottom="173, 203, 239" WidthRight="0px" StyleTop="None" StyleRight="None" WidthBottom="1px" StyleLeft="None">
</BorderDetails>

</HeaderStyleDefault>

<FrameStyle BorderWidth="1px" Font-Size="8pt" Font-Names="Tahoma" BorderColor="#7F9DB9" BorderStyle="Solid">
</FrameStyle>

<FooterStyleDefault BorderWidth="1px" BorderStyle="Solid" BackColor="#CFDDF0">

<BorderDetails ColorTop="White" WidthLeft="1px" WidthTop="1px" ColorLeft="White">
</BorderDetails>

</FooterStyleDefault>

<ClientSideEvents DblClickHandler="MyDblClick">
</ClientSideEvents>

<GroupByBox>

<BandLabelStyle BackColor="White">
</BandLabelStyle>

</GroupByBox>

<EditCellStyleDefault BorderWidth="0px" BorderStyle="None">
</EditCellStyleDefault>

<RowStyleDefault Cursor="Hand" BorderWidth="1px" BorderColor="#ADCBEF" BorderStyle="Solid">

<Padding Left="3px">
</Padding>

<BorderDetails WidthLeft="1px" WidthTop="0px" WidthRight="1px" StyleLeft="None">
</BorderDetails>

</RowStyleDefault>

</DisplayLayout>

<Bands>
<igtbl:UltraGridBand></igtbl:UltraGridBand>
</Bands>
						</igtbl:ultrawebgrid></TD></TR>
  <TR>
    <TD style="WIDTH: 17px" vAlign=top align=left></TD>
    <TD style="WIDTH: 540px" vAlign=top align=center><INPUT id=Close style="BACKGROUND-COLOR: #e0e0e0" onclick=javascript:myClose(); type=button value=Close name=Close></TD></TR></TABLE></FONT></form>
	
  </BODY>
</HTML>
