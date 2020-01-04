<%@ Page language="c#" Inherits="IFF_MAIN.ASPX.OnLines.CompanyConfig.CompanySearchDetail" CodeFile="CompanySearchDetail.aspx.cs" %>
<%@ Register TagPrefix="igtbar" Namespace="Infragistics.WebUI.UltraWebToolbar" Assembly="Infragistics.WebUI.UltraWebToolbar, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igtbl" Namespace="Infragistics.WebUI.UltraWebGrid" Assembly="Infragistics.WebUI.UltraWebGrid, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="cc1" Namespace="Infragistics.WebUI.UltraWebGrid.ExcelExport" Assembly="Infragistics.WebUI.UltraWebGrid.ExcelExport, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
  <HEAD>
		<title>CompanySearchDetai</title>
<meta content="Microsoft Visual Studio .NET 7.1" name=GENERATOR>
<meta content=C# name=CODE_LANGUAGE>
<meta content=JavaScript name=vs_defaultClientScript>
<meta content=http://schemas.microsoft.com/intellisense/ie5 name=vs_targetSchema>
<script language=javascript>

function formRest(tr,id) {
	var idText = id.Key

	if(idText == 'Reset' ) {
		__doPostBack("btnReset", "");
		return true;
	}
	else if(idText == 'Back' ) {
		__doPostBack("btnBack", "");   		
		return true;
	}
	else if(idText == 'Hide' ) {
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
	function acuh(tableName,itemName) {
	var cell = igtbl_getElementById(itemName);
		  cell.innerHTML = igS;		
	}

	function bcuh(tableName,itemName) {
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
	
	
		</script>
<LINK href="../../CSS/AppStyle.css" type=text/css rel=stylesheet >
  <!--  #INCLUDE FILE="../../include/common.htm" -->
</HEAD>
<body>
<form id=form1 method=post runat="server">
<TABLE id=Table2 style="WIDTH: 100%; HEIGHT: 600px" cellSpacing=0 cellPadding=0 
bgColor=#ffffff>
  <TR>
    <TD style="HEIGHT: 15px"><FONT face=����></FONT></TD>
      <td style="width: 20px; height: 15px">
      </td>
    <TD style="HEIGHT: 15px"><asp:label id=Label1 runat="server" Width="100%" Font-Bold="True" ForeColor="Black" Font-Size="Larger" DESIGNTIMEDRAGDROP="9087" Height="100%" > Company Search</asp:label></TD>
    <TD style="WIDTH: 2px; HEIGHT: 15px"></TD></TR>
  <TR>
    <TD style="HEIGHT: 15px"></TD>
      <td style="width: 20px; height: 15px">
      </td>
    <TD style="HEIGHT: 15px"><asp:label id=lblNoData runat="server" Width="100%" Font-Bold="True" ForeColor="Navy" Font-Italic="True" Font-Underline="True">...</asp:label></TD>
    <TD style="WIDTH: 2px; HEIGHT: 15px"></TD></TR>
  <TR>
    <TD style="HEIGHT: 4px"></TD>
      <td bgcolor="#cdcc9d" style="width: 20px; height: 4px">
      </td>
    <TD style="HEIGHT: 4px" bgColor=#cdcc9d></TD>
    <TD style="WIDTH: 2px; HEIGHT: 4px"></TD></TR>
  <TR>
    <TD style="HEIGHT: 1px"><FONT face=����></FONT></TD>
      <td style="width: 20px; height: 1px" valign="top">
      </td>
    <TD style="HEIGHT: 1px" vAlign=top><FONT face=����><igtbar:ultrawebtoolbar id=UltraWebToolbar1 runat="server" Width="184px" Font-Size="9pt" ForeColor="White"
							ImageDirectory="/ig_common/images/" MovableImage="ig_tb_move00.gif" ItemWidthDefault="80px" BorderWidth="0px" BorderStyle="None"
							Font-Names="Arial" BackColor="White">
<HoverStyle Cursor="Hand" Font-Size="9pt" Font-Names="Arial" BorderStyle="Outset" ForeColor="Black" BackColor="Silver" TextAlign="Center">
</HoverStyle>

<ClientSideEvents Click="formRest">
</ClientSideEvents>

<SelectedStyle Cursor="Default" Font-Size="9pt" Font-Names="Arial" BorderStyle="Inset" ForeColor="Black" BackColor="Silver" TextAlign="Center">
</SelectedStyle>

<Items>
<igtbar:TBarButton Key="Back" Image="../../../images/button_back.gif">
    <HoverStyle TextAlign="Center">
    </HoverStyle>
    <SelectedStyle TextAlign="Center">
    </SelectedStyle>
    <DefaultStyle TextAlign="Center">
    </DefaultStyle>
</igtbar:TBarButton>
<igtbar:TBarButton Tag="" Key="Reset" HoverImage="" ToolTip="" SelectedImage="" TargetURL="" DisabledImage="" TargetFrame="" Image="../../../images/button_refresh.gif">
    <HoverStyle TextAlign="Center">
    </HoverStyle>
    <SelectedStyle TextAlign="Center">
    </SelectedStyle>
    <DefaultStyle TextAlign="Center">
    </DefaultStyle>
</igtbar:TBarButton>
<igtbar:TBarButton Tag="" Key="Hide" HoverImage="" ToolTip="" SelectedImage="" TargetURL="" DisabledImage="" TargetFrame="" Image="../../../images/button_hide.gif">
    <HoverStyle TextAlign="Center">
    </HoverStyle>
    <SelectedStyle TextAlign="Center">
    </SelectedStyle>
    <DefaultStyle TextAlign="Center">
    </DefaultStyle>
</igtbar:TBarButton>
<igtbar:TBarButton Tag="" Key="Asce" HoverImage="" ToolTip="" SelectedImage="" TargetURL="" DisabledImage="" TargetFrame="" Image="../../../images/button_asce.gif">
    <HoverStyle TextAlign="Center">
    </HoverStyle>
    <SelectedStyle TextAlign="Center">
    </SelectedStyle>
    <DefaultStyle TextAlign="Center">
    </DefaultStyle>
</igtbar:TBarButton>
<igtbar:TBarButton Tag="" Key="Desc" HoverImage="" ToolTip="" SelectedImage="" TargetURL="" DisabledImage="" TargetFrame="" Image="../../../images/button_desc.gif">
    <HoverStyle TextAlign="Center">
    </HoverStyle>
    <SelectedStyle TextAlign="Center">
    </SelectedStyle>
    <DefaultStyle TextAlign="Center">
    </DefaultStyle>
</igtbar:TBarButton>
<igtbar:TBarButton Tag="" Key="Excel" HoverImage="" ToolTip="" SelectedImage="" TargetURL="" DisabledImage="" TargetFrame="" Image="../../../Images/button_exel.gif">
    <HoverStyle TextAlign="Center">
    </HoverStyle>
    <SelectedStyle TextAlign="Center">
    </SelectedStyle>
    <DefaultStyle TextAlign="Center">
    </DefaultStyle>
</igtbar:TBarButton>
<igtbar:TBarButton Tag="" Key="XML" HoverImage="" ToolTip="" SelectedImage="" TargetURL="" DisabledImage="" TargetFrame="" Image="../../../images/button_xmlg.gif">
    <HoverStyle TextAlign="Center">
    </HoverStyle>
    <SelectedStyle TextAlign="Center">
    </SelectedStyle>
    <DefaultStyle TextAlign="Center">
    </DefaultStyle>
</igtbar:TBarButton>
</Items>

<DefaultStyle Cursor="Hand" BorderWidth="0px" Font-Size="9pt" Font-Names="Arial" BorderColor="White" BorderStyle="None" ForeColor="Black" BackColor="White" TextAlign="Center">
</DefaultStyle>
						</igtbar:ultrawebtoolbar></FONT></TD>
    <TD style="WIDTH: 2px; HEIGHT: 1px"></TD></TR>
  <TR>
    <TD></TD>
      <td align="left" style="width: 20px" valign="top">
      </td>
    <TD vAlign=top align=left><igtbl:ultrawebgrid id=UltraWebGrid1 runat="server" Width="100%" Height="600px" OnInitializeLayout="UltraWebGrid1_InitializeLayout1" OnInitializeRow="UltraWebGrid1_InitializeRow" OnPageIndexChanged="UltraWebGrid1_PageIndexChanged">
<DisplayLayout RowHeightDefault="18px" Version="4.00" HeaderClickActionDefault="SortMulti" BorderCollapseDefault="Separate" AllowRowNumberingDefault="Continuous" Name="UltraWebGrid1" TableLayout="Fixed" AllowUpdateDefault="Yes" ViewType="Hierarchical">

<AddNewBox ButtonConnectorColor="Silver" ButtonConnectorStyle="Solid">

<Style BorderWidth="1px" BorderStyle="Solid" BackColor="LightGray">

<BorderDetails ColorTop="White" WidthLeft="1px" WidthTop="1px" ColorLeft="White">
</BorderDetails>

</Style>
    <ButtonStyle BackColor="Gray" BorderColor="White" BorderStyle="Outset" BorderWidth="1px"
        Cursor="Hand">
    </ButtonStyle>

</AddNewBox>

<Pager Alignment="Center">

<Style BorderWidth="1px" BorderStyle="Solid" BackColor="LightGray">

<BorderDetails ColorTop="White" WidthLeft="1px" WidthTop="1px" ColorLeft="White">
</BorderDetails>

</Style>

</Pager>

<HeaderStyleDefault BorderStyle="Solid" HorizontalAlign="Left" ForeColor="Black" BackColor="#CBD6A6" BorderWidth="1px" Font-Names="Tahoma" Font-Size="8pt">

<BorderDetails WidthLeft="1px" ColorLeft="White" ColorTop="White" WidthTop="1px">
</BorderDetails>
    <Padding Left="5px" Right="5px" />

</HeaderStyleDefault>

<FrameStyle Width="100%" BorderWidth="1px" Font-Size="8pt" Font-Names="Tahoma" BorderStyle="Solid" Height="600px" BackColor="#FAFCF1" Cursor="Hand">
</FrameStyle>

<FooterStyleDefault BorderWidth="1px" BorderStyle="Solid" BackColor="LightGray">

<BorderDetails ColorTop="White" WidthLeft="1px" WidthTop="1px" ColorLeft="White">
</BorderDetails>

</FooterStyleDefault>

<ClientSideEvents AfterCellUpdateHandler="acuh" BeforeCellUpdateHandler="bcuh">
</ClientSideEvents>

<GroupByBox ButtonConnectorColor="Silver" ButtonConnectorStyle="Solid">

<BandLabelStyle BackColor="Gray" BorderColor="White" BorderStyle="Outset" BorderWidth="1px" Cursor="Default">
</BandLabelStyle>
    <Style BackColor="DarkGray" BorderColor="White" BorderStyle="Outset" BorderWidth="1px"></Style>

</GroupByBox>

<EditCellStyleDefault BorderWidth="0px" BorderStyle="None" Font-Names="Tahoma" Font-Size="8pt" HorizontalAlign="Left" VerticalAlign="Middle">
</EditCellStyleDefault>

<RowStyleDefault BorderWidth="1px" BorderColor="#AAB883" BorderStyle="Solid" BackColor="White" Font-Names="Tahoma" Font-Size="8pt" ForeColor="#333333" HorizontalAlign="Left" VerticalAlign="Middle">

<Padding Left="7px" Right="7px">
</Padding>

<BorderDetails WidthLeft="0px" WidthTop="0px">
</BorderDetails>

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
								</igtbl:ultrawebgrid></TD>
    <TD style="WIDTH: 1px"></TD></TR>
  <TR>
    <TD style="height: 53px"></TD>
      <td align="left" style="width: 20px; height: 53px" valign="top">
      </td>
    <TD vAlign=top align=left style="height: 53px"><INPUT id=ExpandAll style="WIDTH: 80px; HEIGHT: 20px; BACKGROUND-COLOR: #e0e0e0" onclick=javascript:ExpandAllRows(this); type=button value="Expand All" name=ExpandAll DESIGNTIMEDRAGDROP="28">
<asp:radiobutton id=radSingle runat="server" DESIGNTIMEDRAGDROP="29" Width="100px" GroupName="SingleMulti" Checked="True" AutoPostBack="True" Text="Single Page" oncheckedchanged="radSingle_CheckedChanged"></asp:radiobutton>
<asp:radiobutton id=radMulti runat="server" DESIGNTIMEDRAGDROP="30" Width="100px" GroupName="SingleMulti" AutoPostBack="True" Text="Multi Page" oncheckedchanged="radMulti_CheckedChanged"></asp:radiobutton>
<asp:checkbox id=CheckBox1 runat="server" DESIGNTIMEDRAGDROP="31" Width="104px" Checked="True" AutoPostBack="True" Text="Intelli. Search" oncheckedchanged="CheckBox1_CheckedChanged"></asp:checkbox></TD>
    <TD style="WIDTH: 1px; height: 53px;"></TD></TR></TABLE><asp:button id=btnValidate runat="server" Text="for Validation" Visible="False"></asp:button><asp:linkbutton id=LinkButton1 runat="server" Visible="False">LinkButton</asp:linkbutton><cc1:ultrawebgridexcelexporter 
id=UltraWebGridExcelExporter1 
runat="server"></cc1:ultrawebgridexcelexporter><asp:button id=btnReset runat="server" Width="80px" Text="Reset" Height="20px" BackColor="#E0E0E0" Visible="False" onclick="btnReset_Click"></asp:button><asp:button id=butHideCol runat="server" Width="80px" Text="Hide" Height="20px" BackColor="#E0E0E0" Visible="False" onclick="butHideCol_Click"></asp:button><asp:button id=btnSortAsce runat="server" Width="80px" Text="Asce." Height="20px" BackColor="#E0E0E0" Visible="False" onclick="btnSortAsce_Click"></asp:button><asp:button id=btnSortDesc runat="server" Width="80px" Text="Desc." Height="20px" BackColor="#E0E0E0" Visible="False" onclick="btnSortDesc_Click"></asp:button><asp:button id=btnPrint runat="server" Width="80px" Text="Print" Height="20px" BackColor="#E0E0E0" Visible="False" onclick="btnPrint_Click"></asp:button><asp:button id=btnExcel runat="server" Width="80px" Text="Excel" Height="20px" BackColor="#E0E0E0" Visible="False" onclick="btnExcel_Click"></asp:button><asp:button id=btnXML runat="server" Width="80px" Text="XML" Height="20px" BackColor="#E0E0E0" Visible="False" onclick="btnXML_Click"></asp:button><asp:button id=btnBack runat="server" Width="60px" Text="<< Back" Visible="False" onclick="Button1_Click"></asp:button></form>

	</body>
<!--  #INCLUDE FILE="../../include/StatusFooter.htm" -->
</HTML>
