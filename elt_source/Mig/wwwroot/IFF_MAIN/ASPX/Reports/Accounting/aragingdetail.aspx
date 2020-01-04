
<%@ Page Language="c#" Inherits="IFF_MAIN.ASPX.Reports.Accounting.ARAgingDetail"
    CodeFile="ARAgingDetail.aspx.cs" %>
<%@ Register TagPrefix="cc1" 
    Namespace="Infragistics.WebUI.UltraWebGrid.ExcelExport"
    Assembly="Infragistics.WebUI.UltraWebGrid.ExcelExport, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igtbl" Namespace="Infragistics.WebUI.UltraWebGrid" Assembly="Infragistics.WebUI.UltraWebGrid, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
<HEAD>
    <title>ARAgingDetail</title>
    <meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
    <meta content="C#" name="CODE_LANGUAGE">
    <meta content="JavaScript" name="vs_defaultClientScript">
    <meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">

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
    else if (idText == 'PDF') {
        __doPostBack("btnPDF", "");
    }
    else if (idText == 'DOC') {
		__doPostBack("btnDOC", "");
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
    
    // moved link to client-side for flexibility issue
    // Added by Joon on 10/25/2007
    function goFindURL(argType,argHouseVal,argInvoiceVal){
        var vURL = "";
        var argVal = encodeURIComponent(argVal);
        switch(argType){
            case "AI":
                vURL = "/IFF_MAIN/ASP/air_import/arrival_notice.asp?iType=A&Edit=yes&InvoiceNo=" + argInvoiceVal;
                break;
            case "OI":
                vURL = "/IFF_MAIN/ASP/ocean_import/arrival_notice.asp?iType=O&Edit=yes&InvoiceNo="  + argInvoiceVal;
                break;
            case "AE":
                vURL = "/IFF_MAIN/ASP/air_export/new_edit_hawb.asp?Edit=yes&HAWB=" + argHouseVal;
                break;
            case "OE":
                vURL = "/IFF_MAIN/ASP/ocean_export/new_edit_hbol.asp?Edit=yes&HBOL=" + argHouseVal;  
                break;
            case "ARN":
                // go to invoice
                vURL = "/IFF_MAIN/ASP/acct_tasks/edit_invoice.asp?edit=yes&InvoiceNo=" + argInvoiceVal;
                break;
            case "INV":
                // go to invoice
                vURL = "/IFF_MAIN/ASP/acct_tasks/edit_invoice.asp?edit=yes&InvoiceNo=" + argInvoiceVal;
                break;
            case "CRN":
                // go to invoice
                vURL = "/IFF_MAIN/ASP/acct_tasks/edit_credit_note.asp?edit=yes&InvoiceNo=" + argInvoiceVal;
                break;
            case "PMT":
                // go to Pay Receivable
                vURL = "/IFF_MAIN/ASP/acct_tasks/receiv_pay.asp?PaymentNo=" + argInvoiceVal;
                break;
            case "GJE":
                 vURL = "/IFF_MAIN/ASP/acct_tasks/gj_entry.asp?View=yes&EntryNo="  + argInvoiceVal;
                // to to general journal entry
                break;
        }
        viewPop(vURL);
    }
    window.onresize=resize_table; 
	
    </script>

    <LINK href="../../CSS/AppStyle.css" type="text/css" rel="stylesheet">
    <!--  #INCLUDE FILE="../../include/common.htm" -->
</HEAD>
<body onload="javascript:resize_table();">
    <form id="form1" method="post" runat="server">
        <TABLE id="Table2" cellSpacing="0" cellPadding="0" width="100%" bgColor="#ffffff"
            style="height: 420px">
            <TR>
                <TD style="height: 2px">
                </TD>
                <td align="left" style="width: 20px; height: 2px" valign="middle">
                </td>
                <TD style="height: 2px" vAlign="middle" align="left">
                    <asp:Label ID="Label1" runat="server" Height="8px" DESIGNTIMEDRAGDROP="18" Font-Size="Larger"
                        ForeColor="Black" Font-Bold="True" Width="100%"> A/R Aging</asp:Label></TD>
                <TD style="width: 2px; height: 2px">
                </TD>
            </TR>
            <TR>
                <TD style="height: 4px">
                </TD>
                <td bgcolor="#d5e8cb" style="width: 20px; height: 4px">
                </td>
                <TD style="height: 4px" bgcolor="D5E8CB">
                </TD>
                <TD style="width: 2px; height: 4px">
                </TD>
            </TR>
            <TR>
                <TD style="height: 13px">
                </TD>
                <td bgcolor="whitesmoke" style="width: 20px; height: 13px" valign="top">
                </td>
                <TD style="height: 13px" vAlign="top" bgColor="whitesmoke">
                    <asp:Label ID="Label2" runat="server" Width="100%" Font-Bold="True" ForeColor="Navy"
                        Font-Size="10px" Height="8px" Font-Italic="True"></asp:Label></TD>
                <TD style="width: 2px; height: 13px">
                </TD>
            </TR>
            <TR>
                <TD style="height: 2px">
                </TD>
                <td bgcolor="#f5f5f5" style="width: 20px; height: 2px" valign="top">
                </td>
                <TD style="height: 2px" vAlign="top" bgColor="#f5f5f5">
                    <asp:Label ID="lblNoData" runat="server" Width="100%" Font-Bold="True" ForeColor="Navy"
                        Font-Italic="True" Font-Underline="True">...</asp:Label></TD>
                <TD style="width: 2px; height: 2px">
                </TD>
            </TR>
            <TR>
                <TD height="5">
                </TD>
                <td bgcolor="#d5e8cb" height="5" style="width: 20px" valign="top">
                </td>
                <TD vAlign="top" bgcolor="D5E8CB" height="5">
                </TD>
                <TD style="width: 2px" height="5">
                </TD>
            </TR>
            <TR>
                <TD style="height: 1px">
                </TD>
                <td style="width: 20px; height: 1px" valign="top">
                </td>
                <TD style="height: 1px" vAlign="top">
                    <asp:ImageButton ID="btnExcelExport" runat="server" ImageUrl="../../../Images/button_exel.gif"
                            OnClick="btnExcelExport_Click" style="float:right;" />
                    <asp:ImageButton ID="btnPDFExport" runat="server" ImageUrl="../../../Images/button_pdf.gif"
                            style="float:right; height: 16px;" OnClick="btnPDF_Click1" />
                </TD>
                <TD style="width: 2px; height: 1px">
                </TD>
            </TR>
            <TR>
                <TD style="height: 360px">
                </TD>
                <td align="left" style="width: 20px; height: 360px" valign="top">
                </td>
                <TD vAlign="top" align="left" style="height: 360px">
                    <igtbl:UltraWebGrid ID="UltraWebGrid1" runat="server" Height="400px" OnInitializeLayout="UltraWebGrid1_InitializeLayout1"
                        OnInitializeRow="UltraWebGrid1_InitializeRow" Width="100%">
                        <DisplayLayout AllowColSizingDefault="Free" BorderCollapseDefault="Separate" ColWidthDefault="80px"
                            HeaderClickActionDefault="SortMulti" Name="UltraWebGrid1" RowHeightDefault="18px"
                            TableLayout="Fixed" Version="4.00" ViewType="Hierarchical" ReadOnly="LevelOne">
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
                            <HeaderStyleDefault BackColor="#CBD6A6" BorderStyle="Solid" ForeColor="Black" HorizontalAlign="Left"
                                BorderWidth="1px" Font-Names="Tahoma" Font-Size="8pt">
                                <BorderDetails WidthLeft="1px" ColorLeft="White" ColorTop="White" WidthTop="1px" />
                                <Padding Left="5px" Right="5px" />
                            </HeaderStyleDefault>
                            <FrameStyle BorderStyle="Solid" BorderWidth="1px" Font-Names="Tahoma" Font-Size="8pt"
                                Height="400px" Width="100%" BackColor="#FAFCF1" Cursor="Hand">
                            </FrameStyle>
                            <FooterStyleDefault BackColor="LightGray" BorderStyle="Solid" BorderWidth="1px">
                                <BorderDetails ColorLeft="White" ColorTop="White" WidthLeft="1px" WidthTop="1px" />
                            </FooterStyleDefault>
                            <ClientSideEvents AfterCellUpdateHandler="acuh" BeforeCellUpdateHandler="bcuh" />
                            <GroupByBox ButtonConnectorColor="Silver" ButtonConnectorStyle="Solid">
                                <BandLabelStyle BackColor="Gray" BorderColor="White" BorderStyle="Outset" BorderWidth="1px"
                                    Cursor="Default">
                                </BandLabelStyle>
                                <Style BackColor="DarkGray" BorderColor="White" BorderStyle="Outset" BorderWidth="1px"></Style>
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
                    </igtbl:UltraWebGrid></TD>
                <TD style="width: 1px; height: 360px;">
                </TD>
            </TR>
            <TR>
                <TD style="height: 17px">
                </TD>
                <td align="left" style="width: 20px; height: 17px" valign="top">
                </td>
                <TD vAlign="top" align="left" style="height: 17px">
                    <asp:RadioButton ID="radSingle" runat="server" Text="Single Page" Width="100px" Checked="True"
                        AutoPostBack="True" GroupName="SingleMulti" OnCheckedChanged="radSingle_CheckedChanged"
                        Visible="False"></asp:RadioButton><asp:RadioButton ID="radMulti" runat="server" Text="Multi Page"
                            Width="100px" AutoPostBack="True" GroupName="SingleMulti" OnCheckedChanged="radMulti_CheckedChanged"
                            Visible="False"></asp:RadioButton><asp:CheckBox ID="CheckBox1" runat="server" Text="Intelli. Search"
                                Width="104px" Checked="True" AutoPostBack="True" OnCheckedChanged="CheckBox1_CheckedChanged"
                                Visible="False"></asp:CheckBox>
                    <INPUT id="ExpandAll" style="width: 80px; height: 20px; background-color: #e0e0e0;
                        visibility: hidden" onclick="javascript:ExpandAllRows(this);" type="button" value="Expand All"
                        name="ExpandAll"></TD>
                <TD style="width: 1px; height: 17px;">
                </TD>
            </TR>
        </TABLE>
        <asp:Button ID="btnValidate" runat="server" Text="for Validation" Visible="False"></asp:Button><asp:LinkButton
            ID="LinkButton1" runat="server" Visible="False">LinkButton</asp:LinkButton><cc1:UltraWebGridExcelExporter
                ID="UltraWebGridExcelExporter1" runat="server" OnCellExported="UltraWebGridExcelExporter1_CellExported">
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
        <asp:Button ID="btnPDF" runat="server" Text="PDF" Width="80px" Height="20px" BackColor="#E0E0E0"
            Visible="False" OnClick="btnPDF_Click"></asp:Button>
        <asp:Button ID="btnDOC" runat="server" Text="DOC" Width="80px" Height="20px" BackColor="#E0E0E0"
            Visible="False" OnClick="btnDOC_Click"></asp:Button>
        <asp:Button ID="btnBack" runat="server" Text="<< Back" Width="60px" DESIGNTIMEDRAGDROP="14"
            Visible="False" OnClick="Button1_Click"></asp:Button></form>
</body>
</HTML>
