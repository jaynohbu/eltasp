<%@ Page Language="c#" Inherits="IFF_MAIN.ASPX.OnLines.MAWB.MAWBNumber" CodeFile="MAWBNumber.aspx.cs"
    CodePage="65001" %>

<%@ Register TagPrefix="igtbar" Namespace="Infragistics.WebUI.UltraWebToolbar" Assembly="Infragistics.WebUI.UltraWebToolbar, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igtbl" Namespace="Infragistics.WebUI.UltraWebGrid" Assembly="Infragistics.WebUI.UltraWebGrid, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>MAWB No.</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR" />
    <meta content="C#" name="CODE_LANGUAGE" />
    <meta content="JavaScript" name="vs_defaultClientScript" />
    <meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema" />
    <link href="../../CSS/AppStyle.css" type="text/css" rel="stylesheet" />

    <script type="text/jscript">

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
	
	oGrid.suspendUpdates(false);
}

function unSelectAllRows(strGrid) {
	
var oGrid = igtbl_getGridById(strGrid);
var oRows = oGrid.Rows;
oGrid.suspendUpdates(true);
	for(i=0; i<oRows.length; i++) {
		oRow = oRows.getRow(i);
		oRow.getCellFromKey('Chk').Element.style.backgroundImage =  'url(../../../Images/mark_o.gif)';
		oRow.getCellFromKey('Closed#').setValue("false");
		oRow.getCellFromKey('Remark').setValue("");
	}		
		
	oGrid.suspendUpdates(false);

}

function AddRow(strGrid) {
var oGrid1 = igtbl_getGridById(strGrid);
var oRows1 = oGrid1.Rows;
var errString = "";
igtbl_addNew(oGrid1.Id,'0');	
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
		    if ( oRow.getCellFromKey('Used').getValue() == 'Y') {
		        oRow.getCellFromKey('Remark').setValue("Can not delete used MAWB No.");
		    }
		    else {
		        if( oRow )oRow.deleteRow();
	        }
		}
	}		

oGrid.suspendUpdates(false);
//gridRowDelete(oGrid.Id);

}

function CloseRows(strGrid) {

var oGrid = igtbl_getGridById(strGrid);
var oRows = oGrid.Rows;
oGrid.suspendUpdates(true);

	for(i=oRows.length-1; i>=0; i--) {
		oRow = oRows.getRow(i);
		if( oRow.getCellFromKey('Chk').Element.style.backgroundImage ==  'url(../../../Images/mark_x.gif)' ) {
		if( oRow )oRow.getCellFromKey('Closed#').setValue("true");
		}
	}		

oGrid.suspendUpdates(false);
//gridRowDelete(oGrid.Id);

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
</head>
<body bottommargin="0" topmargin="0">
    <form id="form1" method="post" runat="server">
        <table height="12" cellspacing="0" cellpadding="0" width="100%" border="0">
            <tr>
                <td valign="top" align="center">
                    <img height="6" src="../../../images/spacer.gif" width="200"><img height="7" src=<%     
                    if(Request.UrlReferrer != null && windowName != "PopWin" ) {
                    Response.Write("'../../../images/pointer_md.gif'"); }
                    %> width="11"><img height="6" src="../../../images/spacer.gif" width="227"></td>
            </tr>
        </table>
        <table id="Table3" cellspacing="0" cellpadding="0" align="left" bgcolor="#ffffff"
            style="height: 500px; width: 800px;">
            <tr>
                <td style="width: 866px; height: 16px">
                    <asp:Label ID="Label8" runat="server" Font-Bold="True" DESIGNTIMEDRAGDROP="214" Width="344px"
                        ForeColor="Black" Height="100%" Font-Size="15px">MAWB No.</asp:Label></td>
            </tr>
            <tr>
                <td style="height: 11px" scope="HEIGHT: 12px">
                    <asp:Label ID="lblError" runat="server" Font-Bold="True" DESIGNTIMEDRAGDROP="9515"
                        Width="100%" ForeColor="Red" Font-Underline="True" Font-Italic="True"></asp:Label></td>
            </tr>
            <tr>
                <td style="width: 866px; height: 14px" bgcolor="ecf7f8">
                </td>
            </tr>
            <tr>
                <td style="height: 500px" valign="top">
                    <asp:Label ID="lblMessage" runat="server" Font-Bold="True" Font-Names="Verdana"></asp:Label>
                    <table id="Table2" cellspacing="0" cellpadding="0" width="100%" border="0">
                        <tr>
                            <td style="height: 20px; width: 91px;">
                                <asp:ImageButton ID="btnSave" runat="server" ImageUrl="../../../images/button_save.gif"
                                    OnClick="btnSave_Click1"></asp:ImageButton></td>
                        </tr>
                        <tr>
                            <td valign="top" align="left" width="50%">
                                <igtbl:UltraWebGrid ID="UltraWebGrid1" runat="server" Height="450px" Width="100%"
                                    OnInitializeLayout="UltraWebGrid1_InitializeLayout1" OnInitializeRow="UltraWebGrid1_InitializeRow">
                                    <DisplayLayout AllowDeleteDefault="Yes" ColWidthDefault="80px" AllowAddNewDefault="Yes"
                                        RowHeightDefault="18px" Version="4.00" HeaderClickActionDefault="SortMulti" BorderCollapseDefault="Separate"
                                        RowSelectorsDefault="No" Name="UltraWebGrid1" TableLayout="Fixed" ViewType="Hierarchical">
                                        <AddNewBox ButtonConnectorColor="Silver" ButtonConnectorStyle="Solid">
                                            <Style BorderWidth="1px" BorderStyle="Solid" BackColor="LightGray">

<BorderDetails ColorTop="White" WidthLeft="1px" WidthTop="1px" ColorLeft="White">
</BorderDetails>

													</Style>
                                            <ButtonStyle BackColor="Gray" BorderColor="White" BorderStyle="Outset" BorderWidth="1px"
                                                Cursor="Hand">
                                            </ButtonStyle>
                                        </AddNewBox>
                                        <Pager Alignment="Center" PagerAppearance="Both" PageSize="20">
                                            <Style BorderWidth="1px" BorderStyle="Solid" BackColor="LightGray">

<BorderDetails ColorTop="White" WidthLeft="1px" WidthTop="1px" ColorLeft="White">
</BorderDetails>

													</Style>
                                        </Pager>
                                        <HeaderStyleDefault BorderStyle="Solid" ForeColor="Black" BackColor="#CBD6A6" BorderWidth="1px"
                                            Font-Names="Tahoma" Font-Size="8pt" HorizontalAlign="Left">
                                            <BorderDetails WidthLeft="1px" ColorLeft="White" ColorTop="White" WidthTop="1px"></BorderDetails>
                                            <Padding Left="5px" Right="5px" />
                                        </HeaderStyleDefault>
                                        <FrameStyle Width="100%" BorderWidth="1px" Font-Size="8pt" Font-Names="Tahoma" BorderStyle="Solid"
                                            Height="450px" BackColor="#FAFCF1" Cursor="Hand">
                                        </FrameStyle>
                                        <FooterStyleDefault BorderWidth="1px" BorderStyle="Solid" BackColor="LightGray">
                                            <BorderDetails ColorTop="White" WidthLeft="1px" WidthTop="1px" ColorLeft="White"></BorderDetails>
                                        </FooterStyleDefault>
                                        <ClientSideEvents AfterCellUpdateHandler="acuh" BeforeEnterEditModeHandler="beemh"
                                            CellClickHandler="cch"></ClientSideEvents>
                                        <GroupByBox ButtonConnectorColor="Silver" ButtonConnectorStyle="Solid">
                                            <BandLabelStyle BackColor="Gray" BorderColor="White" BorderStyle="Outset" BorderWidth="1px"
                                                Cursor="Default">
                                            </BandLabelStyle>
                                            <Style BackColor="DarkGray" BorderColor="White" BorderStyle="Outset" BorderWidth="1px"></Style>
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
                                    </DisplayLayout>
                                    <Bands>
                                        <igtbl:UltraGridBand AddButtonCaption="Column0Column1Column2" Key="Column0Column1Column2">
                                            <AddNewRow View="NotSet" Visible="NotSet">
                                            </AddNewRow>
                                        </igtbl:UltraGridBand>
                                    </Bands>
                                </igtbl:UltraWebGrid></td>
                        </tr>
                        <tr>
                            <td style="height: 5px" valign="top" align="left">
                                <img onclick="SelectAllRows('UltraWebGrid1')" alt="Select All" src="../../../images/button_selectall.gif"><img
                                    onclick="unSelectAllRows('UltraWebGrid1')" alt="Clear All" src="../../../images/button_clear.gif"><img
                                        onclick="DeleteRows('UltraWebGrid1')" alt="Delete Checked" src="../../../images/button_delete_ckitem.gif"
                                        designtimedragdrop="189">
                                <img onclick="CloseRows('UltraWebGrid1')" alt="Close Checked" src="../../../images/button_close_selected.gif"
                                    designtimedragdrop="189">
                                <asp:ImageButton ID="btnBack" runat="server" ImageUrl="../../../images/button_back.gif"
                                    Visible="False"></asp:ImageButton></td>
                        </tr>
                    </table>
                    <asp:TextBox ID="txtStart" runat="server" Width="1px"></asp:TextBox><asp:TextBox
                        ID="txtEnd" runat="server" Width="1px"></asp:TextBox><asp:TextBox ID="txt_D_From"
                            runat="server" Width="1px"></asp:TextBox><asp:TextBox ID="txt_D_To" runat="server"
                                Width="1px"></asp:TextBox><asp:TextBox ID="txtStatus" runat="server" Width="1px"></asp:TextBox><asp:TextBox
                                    ID="TextBox1" runat="server" Width="1px"></asp:TextBox></td>
            </tr>
        </table>
        <asp:TextBox ID="txtNum" runat="server" Width="1px" Height="1px"></asp:TextBox></form>
</body>
<!--  #INCLUDE FILE="../../include/StatusFooter.htm" -->
</html>
