<%@ Register TagPrefix="cc1" Namespace="Infragistics.WebUI.UltraWebGrid.ExcelExport" Assembly="Infragistics.WebUI.UltraWebGrid.ExcelExport, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igtbl" Namespace="Infragistics.WebUI.UltraWebGrid" Assembly="Infragistics.WebUI.UltraWebGrid, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Page language="c#" Inherits="IFF_MAIN.ASPX.Reports.Accounting.ARAgingDetail2" CodeFile="aragingdetail2.aspx.cs" %>
<%@ Register TagPrefix="igtbar" Namespace="Infragistics.WebUI.UltraWebToolbar" Assembly="Infragistics.WebUI.UltraWebToolbar, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
  <HEAD>
		<title>ARAgingDetail</title>
<meta content="Microsoft Visual Studio .NET 7.1" name=GENERATOR>
<meta content=C# name=CODE_LANGUAGE>
<meta content=JavaScript name=vs_defaultClientScript>
<meta content=http://schemas.microsoft.com/intellisense/ie5 name=vs_targetSchema>
<script language=javascript>
function goBack() {
var a = '<%=ViewState["Count"]%>';

    if(history.length >= a)
    {
        a = -1 * a;
        history.go(a);
    }
    else
    {
        location.replace('ARAgingSelection.aspx')
    }    
}
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
		goBack();   		
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
<TABLE id=Table2 cellSpacing=0 cellPadding=0 width="100%" 
bgColor=#ffffff style="height: 291px">
  <TR>
    <TD style="HEIGHT: 2px"><FONT face=����></FONT></TD>
      <td align="left" style="width: 20px; height: 2px" valign="middle">
      </td>
    <TD style="HEIGHT: 2px" vAlign=middle align=left><asp:label id=Label1 runat="server" Height="8px" DESIGNTIMEDRAGDROP="18" Font-Size="Larger" ForeColor="Black" Font-Bold="True" Width="100%"> A/R Aging</asp:label></TD>
    <TD style="WIDTH: 2px; HEIGHT: 2px"></TD></TR>
  <TR>
    <TD style="HEIGHT: 4px"></TD>
      <td bgcolor="#d5e8cb" style="width: 20px; height: 4px">
      </td>
    <TD style="HEIGHT: 4px" bgcolor="D5E8CB"></TD>
    <TD style="WIDTH: 2px; HEIGHT: 4px"></TD></TR>
  <TR>
    <TD style="HEIGHT: 13px"></TD>
      <td bgcolor="whitesmoke" style="width: 20px; height: 13px" valign="top">
      </td>
    <TD style="HEIGHT: 13px" vAlign=top bgColor=whitesmoke 
      ><asp:label id=Label2 runat="server" Width="100%" Font-Bold="True" ForeColor="Navy" Font-Size="10px" Height="8px" Font-Italic="True"></asp:label></TD>
    <TD style="WIDTH: 2px; HEIGHT: 13px"></TD></TR>
  <TR>
    <TD style="HEIGHT: 2px"></TD>
      <td bgcolor="#f5f5f5" style="width: 20px; height: 2px" valign="top">
      </td>
    <TD style="HEIGHT: 2px" vAlign=top bgColor=#f5f5f5><asp:label id=lblNoData runat="server" Width="100%" Font-Bold="True" ForeColor="Navy" Font-Italic="True" Font-Underline="True">...</asp:label></TD>
    <TD style="WIDTH: 2px; HEIGHT: 2px"></TD></TR>
  <TR>
    <TD height=5></TD>
      <td bgcolor="#d5e8cb" height="5" style="width: 20px" valign="top">
      </td>
    <TD vAlign=top bgcolor="D5E8CB" height=5></TD>
    <TD style="WIDTH: 2px" height=5></TD></TR>
  <TR>
    <TD style="HEIGHT: 1px"></TD>
      <td style="width: 20px; height: 1px" valign="top">
      </td>
    <TD style="HEIGHT: 1px" vAlign=top><igtbar:ultrawebtoolbar id=UltraWebToolbar1 runat="server" Width="184px" Font-Size="9pt" ForeColor="White"
							ImageDirectory="/ig_common/images/" MovableImage="/ig_common/images/ig_tb_move00.gif" ItemWidthDefault="80px" BorderWidth="0px" BorderStyle="None"
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
						</igtbar:ultrawebtoolbar></TD>
    <TD style="WIDTH: 2px; HEIGHT: 1px"></TD></TR>
  <TR>
    <TD style="height: 334px"></TD>
      <td align="left" style="width: 20px; height: 334px" valign="top">
      </td>
    <TD vAlign=top align=left style="height: 334px">
        <igtbl:UltraWebGrid ID="UltraWebGrid1" runat="server" Height="400px" OnInitializeLayout="UltraWebGrid1_InitializeLayout1"
            OnInitializeRow="UltraWebGrid1_InitializeRow" Width="100%">
            <DisplayLayout AllowColSizingDefault="Free" AllowUpdateDefault="Yes" BorderCollapseDefault="Separate"
                ColWidthDefault="80px" HeaderClickActionDefault="SortMulti" Name="UltraWebGrid1"
                RowHeightDefault="18px" TableLayout="Fixed" Version="4.00" ViewType="Hierarchical">
                <AddNewBox ButtonConnectorColor="Silver" ButtonConnectorStyle="Solid">
                    <Style BackColor="LightGray" BorderStyle="Solid" BorderWidth="1px">

<BorderDetails ColorTop="White" WidthLeft="1px" WidthTop="1px" ColorLeft="White">
</BorderDetails>

</Style>
                    <ButtonStyle BackColor="Gray" BorderColor="White" BorderStyle="Outset" BorderWidth="1px"
                        Cursor="Hand">
                    </ButtonStyle>
                </AddNewBox>
                <Pager Alignment="Center">
                    <Style BackColor="LightGray" BorderStyle="Solid" BorderWidth="1px">

<BorderDetails ColorTop="White" WidthLeft="1px" WidthTop="1px" ColorLeft="White">
</BorderDetails>

</Style>
                </Pager>
                <HeaderStyleDefault BackColor="#CBD6A6" BorderStyle="Solid" ForeColor="Black"
                    HorizontalAlign="Left" BorderWidth="1px" Font-Names="Tahoma" Font-Size="8pt">
                    <BorderDetails WidthLeft="1px" ColorLeft="White" ColorTop="White" WidthTop="1px" />
                    <Padding Left="5px" Right="5px" />
                </HeaderStyleDefault>
                <FrameStyle BorderStyle="Solid" BorderWidth="1px" Font-Names="Tahoma"
                    Font-Size="8pt" Height="400px" Width="100%" BackColor="#FAFCF1" Cursor="Hand">
                </FrameStyle>
                <FooterStyleDefault BackColor="LightGray" BorderStyle="Solid" BorderWidth="1px">
                    <BorderDetails ColorLeft="White" ColorTop="White" WidthLeft="1px" WidthTop="1px" />
                </FooterStyleDefault>
                <ClientSideEvents AfterCellUpdateHandler="acuh" BeforeCellUpdateHandler="bcuh" />
                <GroupByBox ButtonConnectorColor="Silver" ButtonConnectorStyle="Solid">
                    <BandLabelStyle BackColor="Gray" BorderColor="White" BorderStyle="Outset" BorderWidth="1px" Cursor="Default">
                    </BandLabelStyle>
                    <Style BackColor="DarkGray" BorderColor="White" BorderStyle="Outset" BorderWidth="1px"></Style>
                </GroupByBox>
                <EditCellStyleDefault BorderStyle="None" BorderWidth="0px" Font-Names="Tahoma" Font-Size="8pt" HorizontalAlign="Left" VerticalAlign="Middle">
                </EditCellStyleDefault>
                <RowStyleDefault BorderColor="#AAB883" BorderStyle="Solid" BorderWidth="1px" BackColor="White" Font-Names="Tahoma" Font-Size="8pt" ForeColor="#333333" HorizontalAlign="Left" VerticalAlign="Middle">
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
            </DisplayLayout>
            <Bands>
                <igtbl:UltraGridBand AddButtonCaption="Column0Column1Column2" Key="Column0Column1Column2">
                    <AddNewRow View="NotSet" Visible="NotSet">
                    </AddNewRow>
                </igtbl:UltraGridBand>
            </Bands>
        </igtbl:UltraWebGrid></TD>
    <TD style="WIDTH: 1px; height: 334px;"></TD></TR>
  <TR>
    <TD></TD>
      <td align="left" height="20" style="width: 20px" valign="top">
      </td>
    <TD vAlign=top align=left height="20"><INPUT id=ExpandAll style="WIDTH: 80px; HEIGHT: 20px; BACKGROUND-COLOR: #e0e0e0" onclick=javascript:ExpandAllRows(this); type=button value="Expand All" name=ExpandAll><asp:radiobutton id=radSingle runat="server" Text="Single Page" Width="100px" Checked="True" AutoPostBack="True" GroupName="SingleMulti" oncheckedchanged="radSingle_CheckedChanged"></asp:radiobutton><asp:radiobutton id=radMulti runat="server" Text="Multi Page" Width="100px" AutoPostBack="True" GroupName="SingleMulti" oncheckedchanged="radMulti_CheckedChanged"></asp:radiobutton><asp:checkbox id=CheckBox1 runat="server" Text="Intelli. Search" Width="104px" Checked="True" AutoPostBack="True" oncheckedchanged="CheckBox1_CheckedChanged" Visible="False"></asp:checkbox></TD>
    <TD style="WIDTH: 1px"></TD></TR></TABLE><asp:button id=btnValidate runat="server" Text="for Validation" Visible="False"></asp:button><asp:linkbutton id=LinkButton1 runat="server" Visible="False">LinkButton</asp:linkbutton><cc1:ultrawebgridexcelexporter 
id=UltraWebGridExcelExporter1 
runat="server"></cc1:ultrawebgridexcelexporter><asp:button id=btnReset runat="server" Text="Reset" Width="80px" Height="20px" BackColor="#E0E0E0" Visible="False" onclick="btnReset_Click"></asp:button><asp:button id=butHideCol runat="server" Text="Hide" Width="80px" Height="20px" BackColor="#E0E0E0" Visible="False" onclick="butHideCol_Click"></asp:button><asp:button id=btnSortAsce runat="server" Text="Asce." Width="80px" Height="20px" BackColor="#E0E0E0" Visible="False" onclick="btnSortAsce_Click"></asp:button><asp:button id=btnSortDesc runat="server" Text="Desc." Width="80px" Height="20px" BackColor="#E0E0E0" Visible="False" onclick="btnSortDesc_Click"></asp:button><asp:button id=btnPrint runat="server" Text="Print" Width="80px" Height="20px" BackColor="#E0E0E0" Visible="False" onclick="btnPrint_Click"></asp:button><asp:button id=btnExcel runat="server" Text="Excel" Width="80px" Height="20px" BackColor="#E0E0E0" Visible="False" onclick="btnExcel_Click"></asp:button><asp:button id=btnXML runat="server" Text="XML" Width="80px" Height="20px" BackColor="#E0E0E0" Visible="False" onclick="btnXML_Click"></asp:button><asp:button id=btnBack runat="server" Text="<< Back" Width="60px" DESIGNTIMEDRAGDROP="14" Visible="False" onclick="Button1_Click"></asp:button></form>

	</body>
<!--  #INCLUDE FILE="../../include/StatusFooter.htm" -->
</HTML>