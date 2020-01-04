<%@ Page language="c#" Inherits="IFF_MAIN.ASPX.Reports.PNL.PnlDetail" CodeFile="PnlDetail_New.aspx.cs" %>
<%@ Register TagPrefix="igtbar" Namespace="Infragistics.WebUI.UltraWebToolbar" Assembly="Infragistics.WebUI.UltraWebToolbar, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igtbl" Namespace="Infragistics.WebUI.UltraWebGrid" Assembly="Infragistics.WebUI.UltraWebGrid, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="cc1" Namespace="Infragistics.WebUI.UltraWebGrid.ExcelExport" Assembly="Infragistics.WebUI.UltraWebGrid.ExcelExport, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
  <HEAD>
		<title>PNL Detail</title>
<meta content=C# name=CODE_LANGUAGE>
<script language=javascript>

function goPNLChart() {
var argS = 'staus=0,titlebar=0,toolbar=0,menubar=0,scrollbars=0,resizable=0,location=0,width=800,height=600,hotkeys=0';
window.open('PNLCharts.aspx','popUpWindow', argS);
}

function goBack() {
var a = '<%=ViewState["Count"]%>';

    if(history.length >= a)
    {
        a = -1 * a;
        history.go(a);
    }
    else
    {
        location.replace('PnlIndex.aspx')
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
	else if (idText == 'Chart') {
		goPNLChart();
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

    window.onresize=resize_table; 	
	
		</script>
<LINK href="../../CSS/AppStyle.css" type=text/css rel=stylesheet >
  <!--  #INCLUDE FILE="../../include/common.htm" -->
</HEAD>
<body onload="javascript:resize_table();">
 


<form id=form1 method=post runat="server">

<TABLE id=Table2 style="WIDTH: 100%;" cellSpacing=0 
cellPadding=0 bgColor=#ffffff>
  <TR>
    <TD style="HEIGHT: 2px; width: 38px;"></TD>
      <td align="left" style="height: 2px" valign="middle">
      </td>
    <TD style="HEIGHT: 2px" vAlign=middle align=left><asp:label id=Label1 runat="server" Width="100%" Height="8px" DESIGNTIMEDRAGDROP="9087" Font-Size="Larger" ForeColor="Black" Font-Bold="True">PNL Detail</asp:label></TD>
    <TD style="WIDTH: 2px; HEIGHT: 2px"></TD></TR>
  <TR>
    <TD style="HEIGHT: 10px; width: 38px;"></TD>
      <td bgcolor="#d5e8cb" style="height: 10px">
      </td>
    <TD style="HEIGHT: 10px" bgcolor="D5E8CB" ></TD>
    <TD style="WIDTH: 2px; HEIGHT: 4px"></TD></TR>
  <TR>
    <TD style="HEIGHT: 1px; width: 38px;"></TD>
      <td bgcolor="whitesmoke" style="height: 1px" valign="top">
      </td>
    <TD style="HEIGHT: 1px" vAlign=top bgColor=whitesmoke 
      ><asp:label id=lblNoData runat="server" Width="100%" Font-Italic="True" ForeColor="Navy" Font-Bold="True" Font-Underline="True"></asp:label></TD>
    <TD style="WIDTH: 2px; HEIGHT: 1px"></TD></TR>
  <TR>
    <TD style="width: 38px; height: 10px;"></TD>
      <td bgcolor="#d5e8cb" valign="top" style="height: 10px">
      </td>
    <TD vAlign=top bgcolor="D5E8CB" style="height: 10px"><FONT 
      face="±¼¸²"></FONT></TD>
    <TD style="WIDTH: 2px; height: 10px;"></TD></TR>
  <TR>
    <TD style="HEIGHT: 1px; width: 38px;"></TD>
      <td style="height: 1px" valign="top">
      </td>
    <TD style="HEIGHT: 1px; text-align: left;" vAlign=top class="bodyheader">
        Summarize by&nbsp;<asp:DropDownList ID="ddlSumBy" runat="server" AutoPostBack="True"
            CssClass="smallselect" OnSelectedIndexChanged="ddlSumBy_SelectedIndexChanged">
            <asp:ListItem>Select One</asp:ListItem>
            <asp:ListItem>Customer</asp:ListItem>
            <asp:ListItem>Master Bill </asp:ListItem>
            <asp:ListItem>File Number</asp:ListItem>
            <asp:ListItem>Reference Number</asp:ListItem>
            <asp:ListItem>Yearly</asp:ListItem>
            <asp:ListItem> Monthly</asp:ListItem>
        </asp:DropDownList>&nbsp;</TD>
    <TD style="WIDTH: 2px; HEIGHT: 1px"></TD></TR>
    <tr>
        <td style="width: 38px; height: 1px">
        </td>
        <td style="height: 1px" valign="top">
        </td>
        <td class="bodyheader" style="height: 1px" valign="top">
            &nbsp;<asp:ImageButton ID="btnExcel" runat="server" ImageUrl="../../../Images/button_exel.gif" OnClick="btnExcel_Click" />
            <asp:ImageButton ID="btnPDF" runat="server" ImageUrl="../../../Images/button_pdf.gif" OnClick="btnPDF_Click" />&nbsp;
        </td>
        <td style="width: 2px; height: 1px">
        </td>
    </tr>
  <TR>
    <TD style="HEIGHT: 403px; width: 38px;"></TD>
      <td align="left" style="height: 403px" valign="top">
      </td>
    <TD vAlign=top align=left style="HEIGHT: 403px; text-align: left;">
        &nbsp;<igtbl:UltraWebGrid ID="UltraWebGridPNL" runat="server" OnInitializeLayout="UltraWebGridPNL_InitializeLayout"
            OnInitializeRow="UltraWebGridPNL_InitializeRow" Width="100%">
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
            <DisplayLayout AllowColSizingDefault="Free" BorderCollapseDefault="Separate" ColWidthDefault="80px"
                HeaderClickActionDefault="SortMulti" Name="UltraWebGrid1" ReadOnly="LevelOne"
                RowHeightDefault="18px" RowSelectorsDefault="No" RowSizingDefault="Free" TableLayout="Fixed"
                Version="4.00" ViewType="Hierarchical">
                <GroupByBox ButtonConnectorColor="Silver" ButtonConnectorStyle="Solid">
                    <BandLabelStyle BackColor="Gray" BorderColor="White" BorderStyle="Outset" BorderWidth="1px"
                        Cursor="Default">
                    </BandLabelStyle>
                    <Style BackColor="DarkGray" BorderColor="White" BorderStyle="Outset" BorderWidth="1px"></Style>
                </GroupByBox>
                <GroupByRowStyleDefault BackColor="DarkGray" BorderColor="White" BorderStyle="Outset"
                    BorderWidth="1px">
                </GroupByRowStyleDefault>
                <ActivationObject BorderColor="170, 184, 131">
                </ActivationObject>
                <RowExpAreaStyleDefault BackColor="WhiteSmoke">
                </RowExpAreaStyleDefault>
                <FooterStyleDefault BackColor="LightGray" BorderStyle="Solid" BorderWidth="1px">
                    <BorderDetails ColorLeft="White" ColorTop="White" WidthLeft="1px" WidthTop="1px" />
                </FooterStyleDefault>
                <SelectedGroupByRowStyleDefault BackColor="#CF5F5B" BorderColor="White" BorderStyle="Outset"
                    BorderWidth="1px" ForeColor="White">
                </SelectedGroupByRowStyleDefault>
                <RowStyleDefault BackColor="White" BorderColor="#AAB883" BorderStyle="Solid" BorderWidth="1px"
                    Font-Names="Tahoma" Font-Size="8pt" ForeColor="#333333" HorizontalAlign="Left"
                    VerticalAlign="Middle">
                    <BorderDetails WidthLeft="0px" WidthTop="0px" />
                    <Padding Left="7px" Right="7px" />
                </RowStyleDefault>
                <FilterOptionsDefault AllString="(All)" EmptyString="(Empty)" NonEmptyString="(NonEmpty)">
                    <FilterDropDownStyle BackColor="White" BorderColor="Silver" BorderStyle="Solid" BorderWidth="1px"
                        CustomRules="overflow:auto;" Font-Names="Verdana,Arial,Helvetica,sans-serif"
                        Font-Size="11px" Width="200px">
                        <Padding Left="2px" />
                    </FilterDropDownStyle>
                    <FilterHighlightRowStyle BackColor="#151C55" ForeColor="White">
                    </FilterHighlightRowStyle>
                </FilterOptionsDefault>
                <ImageUrls CollapseImage="./ig_treeXPMinus.GIF" CurrentEditRowImage="./arrow_brown2_beveled.gif"
                    CurrentRowImage="./arrow_brown2_beveled.gif" ExpandImage="./ig_treeXPPlus.GIF" />
                <RowSelectorStyleDefault BackColor="White" BorderStyle="None" BorderWidth="1px">
                </RowSelectorStyleDefault>
                <ClientSideEvents AfterCellUpdateHandler="acuh" BeforeCellUpdateHandler="bcuh" />
                <SelectedRowStyleDefault BackColor="#BECA98" ForeColor="White">
                </SelectedRowStyleDefault>
                <HeaderStyleDefault BackColor="#CBD6A6" BorderStyle="Solid" BorderWidth="1px" Font-Names="Tahoma"
                    Font-Size="8pt" ForeColor="Black" HorizontalAlign="Left">
                    <BorderDetails ColorLeft="White" ColorTop="White" WidthLeft="1px" WidthTop="1px" />
                    <Padding Left="5px" Right="5px" />
                </HeaderStyleDefault>
                <RowAlternateStyleDefault BackColor="#E0E0E0">
                </RowAlternateStyleDefault>
                <EditCellStyleDefault BorderStyle="None" BorderWidth="0px" Font-Names="Tahoma" Font-Size="8pt"
                    HorizontalAlign="Left" VerticalAlign="Middle">
                </EditCellStyleDefault>
                <FrameStyle BackColor="#FAFCF1" BorderStyle="Solid" BorderWidth="1px" Cursor="Hand"
                    Font-Names="Tahoma" Font-Size="8pt" Height="400px" Width="100%">
                </FrameStyle>
                <Pager Alignment="Center">
                    <Style BackColor="LightGray" BorderStyle="Solid" BorderWidth="1px">
<BorderDetails ColorTop="White" WidthLeft="1px" WidthTop="1px" ColorLeft="White"></BorderDetails>
</Style>
                </Pager>
                <AddNewBox ButtonConnectorColor="Silver" ButtonConnectorStyle="Solid">
                    <ButtonStyle BackColor="Gray" BorderColor="White" BorderStyle="Outset" BorderWidth="1px"
                        Cursor="Hand">
                    </ButtonStyle>
                    <Style BackColor="LightGray" BorderStyle="Solid" BorderWidth="1px">
<BorderDetails ColorTop="White" WidthLeft="1px" WidthTop="1px" ColorLeft="White"></BorderDetails>
</Style>
                </AddNewBox>
            </DisplayLayout>
        </igtbl:UltraWebGrid>
    </TD>
    <TD style="WIDTH: 1px; HEIGHT: 403px"></TD></TR>
  <TR>
    <TD style="height: 13px; width: 38px;"></TD>
      <td align="left" style="height: 13px" valign="top">
      </td>
    <TD vAlign=top align=left style="height: 13px">
        <cc1:UltraWebGridExcelExporter ID="UltraWebGridExcelExporter1" runat="server">
        </cc1:UltraWebGridExcelExporter>
    </TD>
    <TD style="WIDTH: 1px; height: 13px;"></TD></TR></TABLE>
    &nbsp; &nbsp;
</form>

	</body>
</HTML>
