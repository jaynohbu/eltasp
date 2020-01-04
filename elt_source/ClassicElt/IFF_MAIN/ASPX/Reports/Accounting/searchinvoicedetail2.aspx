<%@ Page Language="c#" Inherits="IFF_MAIN.ASPX.Reports.Accounting.SearchInvoiceDetail2"
    CodeFile="SearchInvoiceDetail2.aspx.cs" %>
<%@ Register TagPrefix="igtbl" Namespace="Infragistics.WebUI.UltraWebGrid" Assembly="Infragistics.WebUI.UltraWebGrid, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="cc1" Namespace="Infragistics.WebUI.UltraWebGrid.ExcelExport"
    Assembly="Infragistics.WebUI.UltraWebGrid.ExcelExport, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<html>
<head>
    <title>AccountingDetail</title>
    <meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR" />
    <meta content="C#" name="CODE_LANGUAGE" />
    <meta content="JavaScript" name="vs_defaultClientScript" />
    <meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema" />

    <script language="javascript">
function goBack() {
var a = '<%=ViewState["Count"]%>';

    if(history.length >= a)
    {
        a = -1 * a;
        history.go(a);
    }
    else
    {
        location.replace('SearchInvoiceSelection.aspx')
    }    
}
function formRest(tr,id) {
	var idText = id.Key

	if(idText == 'Reset' ) {
		__doPostBack("btnReset", "");
		return true;
	}
	else if(idText == 'Back' ) {
		goBack();   		
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
	
	    function resize_table()
        {
            var x,y;
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
            if(document.getElementById("UltraWebGrid1_main")!=null){
                //alert (y);
	            document.getElementById("UltraWebGrid1_main").style.height=parseInt(y-
	            document.getElementById("UltraWebGrid1_main").offsetTop - 60)+"px";
	        }	    
        }
    
        window.onresize = resize_table; 
        window.onload = resize_table;
    </script>

    <link href="../../CSS/AppStyle.css" type="text/css" rel="stylesheet" />
    <!--  #INCLUDE FILE="../../include/common.htm" -->
</head>
<body style="margin:0px 0px 0px 0px">
    <form id="form1" method="post" runat="server">
        <center>
        <table id="Table2" style="width:98%;text-align:left" cellspacing="0" cellpadding="0">
            <tr>
                <td style="height: 2px; width: 19px;">
                </td>
                <td align="left" style="height: 2px" valign="middle">
                </td>
                <td class="bodyheader">
                    Search Invoices</td>
                <td style="width: 2px; height: 2px">
                </td>
            </tr>
            <tr>
                <td style="height: 10px; width: 19px;">
                </td>
                <td bgcolor="#d5e8cb" style="height: 10px">
                </td>
                <td style="height: 10px" bgcolor="D5E8CB">
                </td>
                <td style="width: 2px; height: 4px">
                </td>
            </tr>
            <tr>
                <td style="height: 1px; width: 19px;">
                </td>
                <td bgcolor="whitesmoke" style="height: 1px" valign="top">
                </td>
                <td style="height: 1px" valign="top" bgcolor="whitesmoke">
                    <asp:Label ID="Label2" runat="server" Font-Bold="True" ForeColor="Navy" Font-Size="10px"
                        Height="8px" Font-Italic="True" Width="100%"></asp:Label><asp:Label
                            ID="lblNoData" runat="server" Width="100%" Font-Italic="True" ForeColor="Navy"
                            Font-Bold="True" Font-Underline="True">...</asp:Label></td>
                <td style="width: 2px; height: 1px">
                </td>
            </tr>
            <tr>
                <td height="5" style="width: 19px">
                </td>
                <td bgcolor="#d5e8cb" height="10" valign="top">
                </td>
                <td valign="top" bgcolor="D5E8CB" height="10px">
                </td>
                <td style="width: 2px" height="5">
                </td>
            </tr>
            <tr>
                <td style="height: 1px; width: 19px;">
                </td>
                <td style="height: 1px" valign="top">
                </td>
                <td style="height: 1px" valign="top">
                     <asp:ImageButton ID="btnExcelExport" runat="server" ImageUrl="../../../Images/button_exel.gif"
                            OnClick="btnExcelExport_Click" style="float:right;" />
                </td>
                <td style="width: 2px; height: 1px">
                </td>
            </tr>
            <tr>
                <td style="height: 403px; width: 19px;">
                </td>
                <td align="left" style="height: 403px" valign="top">
                </td>
                <td valign="top" align="left">
                    <igtbl:UltraWebGrid ID="UltraWebGrid1" runat="server" Width="100%"
                        OnInitializeLayout="UltraWebGrid1_InitializeLayout1" OnInitializeRow="UltraWebGrid1_InitializeRow1"
                        OnPageIndexChanged="UltraWebGrid1_PageIndexChanged1">
                        <DisplayLayout ColWidthDefault="80px" RowHeightDefault="18px" Version="4.00" ViewType="Hierarchical"
                            HeaderClickActionDefault="SortMulti" BorderCollapseDefault="Separate" AllowColSizingDefault="Free"
                            Name="UltraWebGrid1" TableLayout="Fixed" ReadOnly="LevelZero">
                            <AddNewBox ButtonConnectorColor="Silver" ButtonConnectorStyle="Solid">
                                <Style BorderWidth="1px" BorderStyle="Solid" BackColor="LightGray">
                                    <BorderDetails ColorTop="White" WidthLeft="1px" WidthTop="1px" ColorLeft="White">
                                    </BorderDetails>
                                </Style>
                                <ButtonStyle BackColor="Gray" BorderColor="White" BorderStyle="Outset" BorderWidth="1px"
                                    Cursor="Hand">
                                </ButtonStyle>
                            </AddNewBox>
                            <Pager PageSize="20" PagerAppearance="Both" Alignment="Center">
                                <Style BorderWidth="1px" BorderStyle="Solid" BackColor="LightGray">
                                    <BorderDetails ColorTop="White" WidthLeft="1px" WidthTop="1px" ColorLeft="White">
                                    </BorderDetails>
                                </Style>
                            </Pager>
                            <HeaderStyleDefault BorderStyle="Solid" HorizontalAlign="Left" ForeColor="Black"
                                BackColor="#CBD6A6" BorderWidth="1px" Font-Names="Tahoma" Font-Size="8pt">
                                <BorderDetails WidthLeft="1px" ColorLeft="White" ColorTop="White" WidthTop="1px"></BorderDetails>
                                <Padding Left="5px" Right="5px" />
                            </HeaderStyleDefault>
                            <FrameStyle BorderWidth="1px" Font-Size="8pt" Font-Names="Tahoma" BorderStyle="Solid"
                                BackColor="#FAFCF1" Cursor="Hand" Height="430px" Width="100%">
                            </FrameStyle>
                            <FooterStyleDefault BorderWidth="1px" BorderStyle="Solid" BackColor="LightGray">
                                <BorderDetails ColorTop="White" WidthLeft="1px" WidthTop="1px" ColorLeft="White"></BorderDetails>
                            </FooterStyleDefault>
                            <ClientSideEvents AfterCellUpdateHandler="acuh" BeforeCellUpdateHandler="bcuh"></ClientSideEvents>
                            <GroupByBox ButtonConnectorColor="Silver" ButtonConnectorStyle="Solid">
                                <BandLabelStyle BackColor="Gray" BorderColor="White" BorderStyle="Outset" BorderWidth="1px"
                                    Cursor="Default">
                                </BandLabelStyle>
                                <Style BackColor="DarkGray" BorderColor="White" BorderStyle="Outset" BorderWidth="1px"></Style>
                            </GroupByBox>
                            <EditCellStyleDefault BorderWidth="0px" BorderStyle="None" Font-Names="Tahoma" Font-Size="8pt"
                                HorizontalAlign="Left" VerticalAlign="Middle">
                            </EditCellStyleDefault>
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
                            <RowAlternateStyleDefault BackColor="#E0E0E0">
                            </RowAlternateStyleDefault>
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
                    </igtbl:UltraWebGrid></td>
                <td style="width: 1px; height: 403px">
                </td>
            </tr>
            <tr>
                <td style="height: 13px; width: 19px;">
                </td>
                <td align="left" style="height: 13px" valign="top">
                </td>
                <td valign="top" align="left" style="height: 13px">
                </td>
                <td style="width: 1px; height: 13px;">
                </td>
            </tr>
        </table>
        </center>
        <asp:Button ID="btnValidate" runat="server" Text="for Validation" Visible="False"></asp:Button><asp:LinkButton
            ID="LinkButton1" runat="server" Visible="False">LinkButton</asp:LinkButton><cc1:UltraWebGridExcelExporter
                ID="UltraWebGridExcelExporter1" runat="server">
            </cc1:UltraWebGridExcelExporter>
        <asp:Button ID="btnReset" runat="server" Width="80px" Text="Reset" Height="20px"
            BackColor="#E0E0E0" Visible="False" OnClick="btnReset_Click"></asp:Button><asp:Button
                ID="butHideCol" runat="server" Width="80px" Text="Hide" Height="20px" BackColor="#E0E0E0"
                Visible="False" OnClick="butHideCol_Click"></asp:Button><asp:Button ID="btnSortAsce"
                    runat="server" Width="80px" Text="Asce." Height="20px" BackColor="#E0E0E0" Visible="False"
                    OnClick="btnSortAsce_Click"></asp:Button><asp:Button ID="btnSortDesc" runat="server"
                        Width="80px" Text="Desc." Height="20px" BackColor="#E0E0E0" Visible="False" OnClick="btnSortDesc_Click">
                    </asp:Button><asp:Button ID="btnPrint" runat="server" Width="80px" Text="Print" Height="20px"
                        BackColor="#E0E0E0" Visible="False" OnClick="btnPrint_Click"></asp:Button><asp:Button
                            ID="btnExcel" runat="server" Width="80px" Text="Excel" Height="20px" BackColor="#E0E0E0"
                            Visible="False" OnClick="btnExcel_Click"></asp:Button><asp:Button ID="btnXML" runat="server"
                                Width="80px" Text="XML" Height="20px" BackColor="#E0E0E0" Visible="False" OnClick="btnXML_Click">
                            </asp:Button><asp:Button ID="btnBack" runat="server" Width="60px" Text="<< Back"
                                DESIGNTIMEDRAGDROP="156" Visible="False" OnClick="btnBack_Click"></asp:Button></form>
</body>
</html>
