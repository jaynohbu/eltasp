<%@ Register TagPrefix="igtbl" Namespace="Infragistics.WebUI.UltraWebGrid" Assembly="Infragistics.WebUI.UltraWebGrid, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Page language="c#" Inherits="IFF_MAIN.ASPX.OnLines.CompanyConfig.CompanyShowDialog" CodeFile="CompanyShowDialog.aspx.cs" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
  <HEAD>
		<title>CompanyShowDialog</title>
		<meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
		<meta content="C#" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema"><LINK href="/IFF_MAIN/ASPX/CSS/AppStyle.css" type="text/css" rel="stylesheet">
		<script language="javascript">

function MyDblClick(gridId, cellId) {

var column = igtbl_getColumnById(cellId);
if(column==null) return;
var row = igtbl_getRowById(cellId);
var accID = row.getCell(0).getValue(); 
var accName = row.getCell(1).getValue();					

window.opener.document.CompanyCreate.txtAccountNumber.value=accID;
window.opener.document.CompanyCreate.txtDBA.value=accName;
window.opener.document.CompanyCreate.ComboSearchKey_Text.value='';
window.opener.__doPostBack("btnShow", "");

window.close();
}

function myClose() {
window.close();
}

		</script>
<!--  #INCLUDE FILE="../../include/common.htm" -->
</HEAD>
	<body>
		<form id="form1" method="post" runat="server">
			<TABLE id="Table3" style="HEIGHT: 470px; width: 600px;" height="100%" cellSpacing="0" cellPadding="0" bgColor="#ffffff">
				<TR>
					<TD style="WIDTH: 17px; HEIGHT: 2px"></TD>
					<TD style="HEIGHT: 2px"></TD></TR>
				<TR>
					<TD align="middle" style="WIDTH: 17px; HEIGHT: 30px"></TD>
					<TD align="middle" style="HEIGHT: 30px">
<asp:Label ID="lblError" runat="server" designtimedragdrop="55" ForeColor="MediumSeaGreen" Font-Italic="False" Font-Bold="True" Width="100%"></asp:Label></TD>
				</TR>
				<TR>
					<TD style="WIDTH: 17px; height: 450px;" vAlign="top" align="left"></TD>
					<TD vAlign="top" align="center" style="height: 450px"><igtbl:ultrawebgrid id="UltraWebGrid1" runat="server" OnInitializeLayout="UltraWebGrid1_InitializeLayout1" Height="100%">
							<DisplayLayout StationaryMargins="Header" AllowSortingDefault="OnClient" RowHeightDefault="18px" RowSizingDefault="Free" Version="4.00" SelectTypeRowDefault="Single" HeaderClickActionDefault="SortSingle" RowSelectorsDefault="No" Name="UltraWebGrid1" TableLayout="Fixed" CellClickActionDefault="RowSelect" BorderCollapseDefault="Separate" ViewType="Hierarchical">

								<AddNewBox ButtonConnectorColor="Silver" ButtonConnectorStyle="Solid">

									<Style BorderWidth="1px" BorderStyle="Solid" BackColor="LightGray">

<BorderDetails ColorTop="White" WidthLeft="1px" WidthTop="1px" ColorLeft="White">
</BorderDetails>

									</Style>
                                    <ButtonStyle BackColor="Gray" BorderColor="White" BorderStyle="Outset" BorderWidth="1px"
                                        Cursor="Hand">                                    </ButtonStyle>
								</AddNewBox>

								<Pager Alignment="Center">

									<Style BorderWidth="1px" BorderStyle="Solid" BackColor="LightGray">

<BorderDetails ColorTop="White" WidthLeft="1px" WidthTop="1px" ColorLeft="White">
</BorderDetails>

									</Style>
								</Pager>

								<HeaderStyleDefault BorderStyle="Solid" ForeColor="Black" BackColor="#CBD6A6" BorderWidth="1px" Font-Names="Tahoma" Font-Size="8pt" HorizontalAlign="Left">

									<BorderDetails ColorTop="White" WidthLeft="1px" WidthTop="1px" ColorLeft="White">									</BorderDetails>
                                    <Padding Left="5px" Right="5px" />
								</HeaderStyleDefault>

								<RowSelectorStyleDefault BorderStyle="None" BackColor="White" BorderWidth="1px">								</RowSelectorStyleDefault>

								<FrameStyle Cursor="Hand" BorderWidth="1px" Font-Size="8pt" Font-Names="Tahoma" BorderStyle="Solid" BackColor="#FAFCF1" Height="100%">								</FrameStyle>

								<FooterStyleDefault BorderWidth="1px" BorderStyle="Solid" BackColor="LightGray">

									<BorderDetails ColorTop="White" WidthLeft="1px" WidthTop="1px" ColorLeft="White">									</BorderDetails>
								</FooterStyleDefault>

								<ClientSideEvents CellClickHandler="MyDblClick">								</ClientSideEvents>

								<ActivationObject BorderColor="170, 184, 131">								</ActivationObject>

								<GroupByBox ButtonConnectorColor="Silver" ButtonConnectorStyle="Solid">

									<BandLabelStyle BackColor="Gray" BorderColor="White" BorderStyle="Outset" BorderWidth="1px" Cursor="Default">									</BandLabelStyle>
                                    <Style BackColor="DarkGray" BorderColor="White" BorderStyle="Outset" BorderWidth="1px"></Style>
								</GroupByBox>

								<SelectedRowStyleDefault ForeColor="White" BackColor="#BECA98">								</SelectedRowStyleDefault>

								<RowAlternateStyleDefault BackColor="#E0E0E0">								</RowAlternateStyleDefault>

								<RowStyleDefault BorderWidth="1px" BorderColor="#AAB883" BorderStyle="Solid" ForeColor="#333333" BackColor="White" Font-Names="Tahoma" Font-Size="8pt" HorizontalAlign="Left" VerticalAlign="Middle">

									<Padding Left="7px" Right="7px">									</Padding>

									<BorderDetails WidthLeft="0px" WidthTop="0px">									</BorderDetails>
								</RowStyleDefault>
                                <FilterOptionsDefault AllString="(All)" EmptyString="(Empty)" NonEmptyString="(NonEmpty)">
                                    <FilterDropDownStyle BackColor="White" BorderColor="Silver" BorderStyle="Solid" BorderWidth="1px"
                                        CustomRules="overflow:auto;" Font-Names="Verdana,Arial,Helvetica,sans-serif"
                                        Font-Size="11px" Width="200px">
                                        <Padding Left="2px" />
                                    </FilterDropDownStyle>
                                    <FilterHighlightRowStyle BackColor="#151C55" ForeColor="White">                                    </FilterHighlightRowStyle>
                                </FilterOptionsDefault>
                                <GroupByRowStyleDefault BackColor="DarkGray" BorderColor="White" BorderStyle="Outset"
                                    BorderWidth="1px">                                </GroupByRowStyleDefault>
                                <RowExpAreaStyleDefault BackColor="WhiteSmoke">                                </RowExpAreaStyleDefault>
                                <SelectedGroupByRowStyleDefault BackColor="#CF5F5B" BorderColor="White" BorderStyle="Outset"
                                    BorderWidth="1px" ForeColor="White">                                </SelectedGroupByRowStyleDefault>
                                <ImageUrls CollapseImage="./ig_treeXPMinus.GIF" CurrentEditRowImage="./arrow_brown2_beveled.gif"
                                    CurrentRowImage="./arrow_brown2_beveled.gif" ExpandImage="./ig_treeXPPlus.GIF" />
                                <EditCellStyleDefault BorderStyle="None" BorderWidth="0px" Font-Names="Tahoma" Font-Size="8pt"
                                    HorizontalAlign="Left" VerticalAlign="Middle">                                </EditCellStyleDefault>
							</DisplayLayout>

							<Bands>
								<igtbl:UltraGridBand>
                                    <AddNewRow View="NotSet" Visible="NotSet">                                    </AddNewRow>
                                    <FilterOptions AllString="" EmptyString="" NonEmptyString="">
                                        <FilterDropDownStyle BackColor="White" BorderColor="Silver" BorderStyle="Solid" BorderWidth="1px"
                                            CustomRules="overflow:auto;" Font-Names="Verdana,Arial,Helvetica,sans-serif"
                                            Font-Size="11px" Width="200px">
                                            <Padding Left="2px" />
                                        </FilterDropDownStyle>
                                        <FilterHighlightRowStyle BackColor="#151C55" ForeColor="White">                                        </FilterHighlightRowStyle>
                                    </FilterOptions>
                                </igtbl:UltraGridBand>
							</Bands>
						</igtbl:ultrawebgrid></TD></TR>
				<TR>
					<TD style="WIDTH: 17px; height: 18px;" vAlign="top" align="left"></TD>
					<TD style="height: 18px;" vAlign="top" align="center"><asp:textbox id="txtAccNum" runat="server" DESIGNTIMEDRAGDROP="177" Width="0px" Height="1px"></asp:textbox><asp:textbox id="txtDbaName" runat="server" Width="0px" Height="1px"></asp:textbox>
                        <INPUT id="Close" style="BACKGROUND-COLOR: #e0e0e0" onClick="javascript:myClose();" type="button" value="Close" name="Close"></TD></TR>
            </TABLE>
		</form>

	</body>

<script language='javascript'> 
    var text  = document.getElementById( 'Close' );
    text.focus();
</script>

</HTML>
