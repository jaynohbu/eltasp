<%@ Page language="c#" Inherits="IFF_MAIN.ASPX.OnLines.ScheduleB.ScheduleBCreate" 
CodeFile="ScheduleBCreate.aspx.cs" CodePage="65001" %>

<%@ Register Assembly="iMoon.WebControls.ComboBox" Namespace="iMoon.WebControls"
    TagPrefix="iMoon" %>
<%@ Register TagPrefix="igtbar" Namespace="Infragistics.WebUI.UltraWebToolbar" Assembly="Infragistics.WebUI.UltraWebToolbar, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igtbl" Namespace="Infragistics.WebUI.UltraWebGrid" Assembly="Infragistics.WebUI.UltraWebGrid, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
  <HEAD>
		<title>Schedule B</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<meta content="Microsoft Visual Studio .NET 7.1" name=GENERATOR>
		<meta content=C# name=CODE_LANGUAGE>
		<meta content=JavaScript name=vs_defaultClientScript>
		<meta content=http://schemas.microsoft.com/intellisense/ie5 name=vs_targetSchema>
		<LINK href="/IFF_MAIN/ASPX/CSS/AppStyle.css" type=text/css rel=stylesheet>
		<script language=javascript>

function viewPop(Url) {
var strJavaPop = "";
window.open(Url,'popup','menubar=0, scrollbars=1, staus=0, resizable=1, titlebar=0, toolbar=0, hotkey=0,closeable=0'); 
}
		
function ReqDataCheck() {
	if( document.form1.ComboBox1.value != "") {
		document.form1.txtNum.value = document.form1.ComboBox1.selectedIndex;
		return true;
	 }
}

function cch(gridName,cellId,button) {

var SelectedChild = 'url(../../../Images/mark_o.gif)';
var SelectedParent = 'url(../../../Images/mark_o.gif)';
var row=igtbl_getRowById(cellId);
var cell=igtbl_getCellById(cellId);
var oCell = igtbl_getCellById(cellId);
var cUrl = oCell.Element.style.backgroundImage;

			if(cell.Column.Key=="Chk") {
				if(cUrl==SelectedChild) {
					oCell.Element.style.backgroundImage =  'url(../../../Images/mark_x.gif)';
					row.setSelected(true);
				}
				else {
					oCell.Element.style.backgroundImage =  'url(../../../Images/mark_o.gif)';
					row.setSelected(true);
				}
			}
}


function SelectAllRows(strGrid) {

var oGrid = igtbl_getGridById(strGrid);
var oRows = oGrid.Rows;
oGrid.suspendUpdates(true);
	for(i=0; i<oRows.length; i++) {
		oRow = oRows.getRow(i);
		oRow.getCellFromKey('Chk').Element.style.backgroundImage =  'url(../../../Images/mark_x.gif)';
	}		
	
	oUltraWebGrid2.suspendUpdates(false);
}

function unSelectAllRows(strGrid) {
	
var oGrid = igtbl_getGridById(strGrid);
var oRows = oGrid.Rows;
oGrid.suspendUpdates(true);
	for(i=0; i<oRows.length; i++) {
		oRow = oRows.getRow(i);
		oRow.getCellFromKey('Chk').Element.style.backgroundImage =  'url(../../../Images/mark_o.gif)';
	}		
		
	oUltraWebGrid2.suspendUpdates(false);

}

function toLeftRow() {
var oGrid1 = igtbl_getGridById('UltraWebGrid1');
var oGrid2 = igtbl_getGridById('UltraWebGrid2');
var oRows1 = oGrid1.Rows;
var oRows2 = oGrid2.Rows;
var errString = "";

	for(i=0; i<oRows2.length; i++) {
		oRow = oRows2.getRow(i);
		if( oRow.getCellFromKey('Chk').Element.style.backgroundImage ==  'url(../../../Images/mark_x.gif)' ) {
			keyVal = oRow.getCellFromKey('sb').getValue();			
			if(!findDupKey(oGrid1,keyVal)) {
				errString = errString+ keyVal+"\n";
				oRow.getCellFromKey('Chk').Element.style.backgroundImage =  'url(../../../Images/mark_o.gif)';
			}
		}
	}

	if (errString.length > 0) {
		alert(errString + " Aready exists.");
		return;
	}
		
	for(i=0; i<oRows2.length; i++) {
		oRow = oRows2.getRow(i);
		if( oRow.getCellFromKey('Chk').Element.style.backgroundImage ==  'url(../../../Images/mark_x.gif)' ) {
			rowObj = igtbl_addNew(oGrid1.Id,'0');
			rowObj.getCellFromKey('sb').setValue(oRow.getCellFromKey('sb').getValue());
			rowObj.getCellFromKey('sb_unit1').setValue(oRow.getCellFromKey('sb_unit1').getValue());
			rowObj.getCellFromKey('sb_unit2').setValue(oRow.getCellFromKey('sb_unit2').getValue());
			rowObj.getCellFromKey('description').setValue(oRow.getCellFromKey('description').getValue());
			rowObj.getCellFromKey('Chk').Element.style.backgroundImage =  'url(../../../Images/mark_x.gif)' 
		}
	}

	DeleteRows(oGrid2.Id);
	
}

function AddRow(strGrid) {
var oGrid1 = igtbl_getGridById(strGrid);
var oRows1 = oGrid1.Rows;
var errString = "";
igtbl_addNew(oGrid1.Id,'0');	
}

function findDupKey(oGrid,keyVal) {
var oRows = oGrid.Rows;

	for(j=0; j<oRows.length; j++) {
		oRowTmp = oRows.getRow(j);
			if( oRowTmp.getCellFromKey('sb').getValue() == keyVal) {
				return false;
			}			
	}

return true;

}


function toRightRow() {
var oGrid1 = igtbl_getGridById('UltraWebGrid1');
var oGrid2 = igtbl_getGridById('UltraWebGrid2');
var oRows1 = oGrid1.Rows;
var oRows2 = oGrid2.Rows;

	for(i=0; i<oRows1.length; i++) {
		oRow = oRows1.getRow(i);
		if( oRow.getCellFromKey('Chk').Element.style.backgroundImage ==  'url(../../../Images/mark_x.gif)' ) {
			rowObj = igtbl_addNew(oGrid2.Id,'0');
			rowObj.getCellFromKey('sb').setValue(oRow.getCellFromKey('sb').getValue());
			rowObj.getCellFromKey('sb_unit1').setValue(oRow.getCellFromKey('sb_unit1').getValue());
			rowObj.getCellFromKey('sb_unit2').setValue(oRow.getCellFromKey('sb_unit2').getValue());
			rowObj.getCellFromKey('description').setValue(oRow.getCellFromKey('description').getValue());
			rowObj.getCellFromKey('Chk').Element.style.backgroundImage =  'url(../../../Images/mark_x.gif)' 			
		}
	}		
	DeleteRows(oGrid1.Id);	
}

function gridRowDelete(strGrid) {
igtbl_deleteSelRows(strGrid);

}

function gridRowDeleteAll(strGrid) {
	var oGrid = igtbl_getGridById(strGrid);
	var oRows = oGrid.Rows;

	for(i=(oRows.length-1); i>=0; i--) {
	 strRow = strGrid+"r_"+i;
	 igtbl_deleteRow(strGrid,strRow);	 
	}
}

function DeleteRows(strGrid) {

var oGrid = igtbl_getGridById(strGrid);
var oRows = oGrid.Rows;
oGrid.suspendUpdates(true);

	for(i=oRows.length-1; i>=0; i--) {
		oRow = oRows.getRow(i);
		if( oRow.getCellFromKey('Chk').Element.style.backgroundImage ==  'url(../../../Images/mark_x.gif)' ) {
		if( oRow )oRow.deleteRow();
		}
	}		
	

oGrid.suspendUpdates(false);
}

function beemh(gridName,cellId) {
var cell=igtbl_getCellById(cellId);
var row=igtbl_getRowById(cellId);

	if(cell.Column.Key=="Chk") {
		igtbl_EndEditMode(gridName);	
		return true;			
	}
}

		</script>
<!--  #INCLUDE FILE="../../include/common.htm" -->
</HEAD>
	<body bottommargin="0" topmargin="0">
		<form id=form1 method=post runat="server">
			<table height=12 cellSpacing=0 cellPadding=0 width="100%" border=0>
				<tr>
					<td vAlign=top align=center><IMG height=6 src="../../../images/spacer.gif" width=200><IMG height=7 src=
					<%     
                    if(Request.UrlReferrer != null && windowName != "PopWin" ) {
                    Response.Write("'../../../images/pointer_md.gif'"); }
                    %> width=11><IMG height=6 src="../../../images/spacer.gif" width=227></td>
				</tr>
			</table>
		
			<TABLE id=Table3 cellSpacing=0 cellPadding=0 width="95%" align=left bgColor=#ffffff style="height: 500px">
				<TR>
					<TD style="WIDTH: 866px; HEIGHT: 16px"><asp:label id=Label8 runat="server" Font-Bold="True" DESIGNTIMEDRAGDROP="214" Width="344px"
							ForeColor="Black" Height="100%" Font-Size="15px">Schedule B</asp:label></TD>
				</TR>
				<TR>
					<TD style="HEIGHT: 11px" scope="HEIGHT: 12px"><asp:label id=lblError runat="server" Font-Bold="True" DESIGNTIMEDRAGDROP="9515" Width="100%"
							ForeColor="Red" Font-Underline="True" Font-Italic="True"></asp:label></TD>
				</TR>
				<TR>
					<TD style="WIDTH: 866px; HEIGHT: 14px" bgColor=#73beb6></TD>
				</TR>
                <tr>
                    <td style="height: 50px" valign="top">
						<TABLE id=Table8 style="HEIGHT: 50px" cellSpacing=0 cellPadding=0 width="100%"
							border=0>
							<TR>
								<TD vAlign=top style="width: 50%">
									<TABLE id=Table1 cellSpacing=0 cellPadding=0 width="100%"
										border=0 height="100%">
										<TR>
											<TD style="WIDTH: 514px; height: 43px;" vAlign=top align=left>
												<TABLE id=Table6 style="WIDTH: 400px; HEIGHT: 24px" height=24 cellSpacing=2 cellPadding=0
													align=left border=0 DESIGNTIMEDRAGDROP="627">
													<TR>
														<TD style="WIDTH: 115px; HEIGHT: 5px" align=right><asp:label id=Label1 runat="server" Width="100%" Height="19px"> Company :</asp:label></TD>
														<TD vAlign=top colspan="2">
                                                            &nbsp;<iMoon:ComboBox ID="ComboBox1" runat="server" CssClass="ComboBox" Rows="20"
                                                                Width="350px">
                                                                <asp:ListItem>Unbound</asp:ListItem>
                                                            </iMoon:ComboBox></TD>
													</TR>
													<TR>
														<TD style="WIDTH: 115px" align=right></TD>
														<TD style="WIDTH: 200px" align=right></TD>
														<TD style="width: 66px"><asp:imagebutton id=btnGo runat="server" ImageUrl="../../../images/button_go.gif"></asp:imagebutton></TD>
													</TR>
												</TABLE>
											</TD>
											<TD vAlign=top align=left style="height: 43px"></TD>
										</TR>
									</TABLE>
								</TD>
								<TD width="50%" align=right><a href="javascript:void(viewPop2('PopWin','http://www.census.gov/foreign-trade/schedules/b/index.html'));"><font color="cc6600">Schedule B Lookup</font></a></TD>
							</TR>
						</TABLE>
                    </td>
                </tr>
				<TR>
					<TD style="HEIGHT: 500px" vAlign=top><asp:panel id=Panel1 runat="server" HorizontalAlign="Left" Width="100%">
      <TABLE id=Table2 cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TR>
          <TD width="50%">
<asp:label id=Label6 runat="server" Font-Size="10px" ForeColor="Navy" Width="144px" Font-Bold="True" BackColor="#ccebed" Font-Names="Verdana"> Schedule B for Company</asp:label></TD>
          <TD style="WIDTH: 16px" width=16></TD>
          <TD width="50%">
<asp:label id=Label7 runat="server" Font-Size="10px" ForeColor="Navy" Width="115px" Font-Bold="True" BackColor="#ccebed" Font-Names="Verdana"> Schedule B</asp:label></TD></TR>
        <TR>
          <TD width="50%" style="height: 20px">
<asp:ImageButton id=btnBack runat="server" ImageUrl="../../../images/button_back.gif"></asp:ImageButton><FONT 
            face=����>&nbsp; </FONT>
<asp:ImageButton id=btnSave runat="server" ImageUrl="../../../images/button_save.gif"></asp:ImageButton></TD>
          <TD style="WIDTH: 16px; height: 20px;" width=16></TD>
          <TD width="50%" style="height: 20px">&nbsp;&nbsp;
<asp:ImageButton id=btnReloadAll runat="server" ImageUrl="../../../images/button_reload_all.gif"></asp:ImageButton></TD></TR>
        <TR>
          <TD vAlign=top align=left style="height: 263px">
<igtbl:ultrawebgrid id=UltraWebGrid1 runat="server" Height="450px" Width="100%">
											<DisplayLayout AllowDeleteDefault="Yes" ColWidthDefault="80px" AllowAddNewDefault="Yes" RowHeightDefault="20px"
												Version="4.00" HeaderClickActionDefault="SortMulti" BorderCollapseDefault="Separate" RowSelectorsDefault="No"
												Name="UltraWebGrid1" AllowUpdateDefault="Yes">
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
												<HeaderStyleDefault BorderStyle="Solid" ForeColor="#1B5AA1" BackColor="#CFDDF0" Height="17px">
													<BorderDetails WidthLeft="0px" StyleBottom="Solid" ColorBottom="173, 203, 239" WidthRight="0px"
														StyleTop="None" StyleRight="None" WidthBottom="1px" StyleLeft="None"></BorderDetails>
												</HeaderStyleDefault>
												<FrameStyle Width="100%" BorderWidth="1px" Font-Size="8pt" Font-Names="Tahoma" BorderColor="#7F9DB9"
													BorderStyle="Solid" Height="450px"></FrameStyle>
												<FooterStyleDefault BorderWidth="1px" BorderStyle="Solid" BackColor="#CFDDF0">
													<BorderDetails ColorTop="White" WidthLeft="1px" WidthTop="1px" ColorLeft="White"></BorderDetails>
												</FooterStyleDefault>
												<ClientSideEvents AfterCellUpdateHandler="acuh" BeforeEnterEditModeHandler="beemh" CellClickHandler="cch"></ClientSideEvents>
												<GroupByBox>
													<BandLabelStyle BackColor="White"></BandLabelStyle>
												</GroupByBox>
												<EditCellStyleDefault BorderWidth="0px" BorderStyle="None"></EditCellStyleDefault>
												<RowAlternateStyleDefault BorderColor="#ADCBEF" BackColor="WhiteSmoke">
													<BorderDetails WidthLeft="1px" WidthTop="0px" WidthRight="1px" StyleLeft="None"></BorderDetails>
												</RowAlternateStyleDefault>
												<RowStyleDefault BorderWidth="1px" BorderColor="#ADCBEF" BorderStyle="Solid">
													<Padding Left="3px"></Padding>
													<BorderDetails WidthLeft="1px" WidthTop="0px" WidthRight="1px" StyleLeft="None"></BorderDetails>
												</RowStyleDefault>
											</DisplayLayout>
											<Bands>
												<igtbl:UltraGridBand AddButtonCaption="Column0Column1Column2" Key="Column0Column1Column2">
                                                    <AddNewRow View="NotSet" Visible="NotSet">
                                                    </AddNewRow>
                                                </igtbl:UltraGridBand>
											</Bands>
										</igtbl:ultrawebgrid></TD>
          <TD style="WIDTH: 16px; HEIGHT: 263px"><INPUT onclick=toLeftRow() type=button value="<<" DESIGNTIMEDRAGDROP="576"><INPUT onclick=toRightRow() type=button value=">>"></TD>
          <TD vAlign=top align=left style="height: 263px">
<igtbl:ultrawebgrid id=UltraWebGrid2 runat="server" Height="450px" Width="100%" DESIGNTIMEDRAGDROP="1508">
											<DisplayLayout AllowDeleteDefault="Yes" ColWidthDefault="80px" AllowAddNewDefault="Yes" RowHeightDefault="20px"
												Version="4.00" HeaderClickActionDefault="SortMulti" BorderCollapseDefault="Separate" RowSelectorsDefault="No"
												Name="UltraWebGrid2">
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
												<HeaderStyleDefault BorderStyle="Solid" ForeColor="#1B5AA1" BackColor="#CFDDF0" Height="17px">
													<BorderDetails WidthLeft="0px" StyleBottom="Solid" ColorBottom="173, 203, 239" WidthRight="0px"
														StyleTop="None" StyleRight="None" WidthBottom="1px" StyleLeft="None"></BorderDetails>
												</HeaderStyleDefault>
												<FrameStyle Width="100%" BorderWidth="1px" Font-Size="8pt" Font-Names="Tahoma" BorderColor="#7F9DB9"
													BorderStyle="Solid" Height="450px"></FrameStyle>
												<FooterStyleDefault BorderWidth="1px" BorderStyle="Solid" BackColor="#CFDDF0">
													<BorderDetails ColorTop="White" WidthLeft="1px" WidthTop="1px" ColorLeft="White"></BorderDetails>
												</FooterStyleDefault>
												<ClientSideEvents AfterCellUpdateHandler="acuh" CellClickHandler="cch"></ClientSideEvents>
												<GroupByBox>
													<BandLabelStyle BackColor="White"></BandLabelStyle>
												</GroupByBox>
												<EditCellStyleDefault BorderWidth="0px" BorderStyle="None"></EditCellStyleDefault>
												<RowAlternateStyleDefault BorderColor="#ADCBEF" BackColor="WhiteSmoke">
													<BorderDetails WidthLeft="1px" WidthTop="0px" WidthRight="1px" StyleLeft="None"></BorderDetails>
												</RowAlternateStyleDefault>
												<RowStyleDefault BorderWidth="1px" BorderColor="#ADCBEF" BorderStyle="Solid">
													<Padding Left="3px"></Padding>
													<BorderDetails WidthLeft="1px" WidthTop="0px" WidthRight="1px" StyleLeft="None"></BorderDetails>
												</RowStyleDefault>
											</DisplayLayout>
											<Bands>
												<igtbl:UltraGridBand AddButtonCaption="Column0Column1Column2" Key="Column0Column1Column2">
                                                    <AddNewRow View="NotSet" Visible="NotSet">
                                                    </AddNewRow>
                                                </igtbl:UltraGridBand>
											</Bands>
										</igtbl:ultrawebgrid></TD></TR>
        <TR>
          <TD style="HEIGHT: 5px" vAlign=top align=left><IMG 
            onclick="SelectAllRows('UltraWebGrid1')" alt="Select All" 
            src="../../../images/button_selectall.gif"><IMG 
            onclick="unSelectAllRows('UltraWebGrid1')" alt="Clear All" 
            src="../../../images/button_clear.gif"><IMG 
            onclick="DeleteRows('UltraWebGrid1')" alt="Delete Checked" 
            src="../../../images/button_delete_ckitem.gif" 
            DESIGNTIMEDRAGDROP="189">&nbsp;<IMG 
            onclick="AddRow('UltraWebGrid1')" alt="Add Item" 
            src="../../../images/button_add_ig.gif"></TD>
          <TD style="WIDTH: 16px; HEIGHT: 5px"></TD>
          <TD style="HEIGHT: 5px" vAlign=top align=left><IMG 
            onclick="SelectAllRows('UltraWebGrid2')" alt="Select All" 
            src="../../../images/button_selectall.gif"><IMG 
            onclick="unSelectAllRows('UltraWebGrid2')" alt="Clear All" 
            src="../../../images/button_clear.gif"></TD></TR></TABLE>
						</asp:panel></TD>
				</TR>
			</TABLE>
			<asp:textbox id=txtNum runat="server" Width="1px" Height="1px"></asp:textbox></form>
	</body>
<!--  #INCLUDE FILE="../../include/StatusFooter.htm" -->
</HTML>
