<%@ Register TagPrefix="cc1" Namespace="Infragistics.WebUI.UltraWebGrid.ExcelExport" Assembly="Infragistics.WebUI.UltraWebGrid.ExcelExport, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<%@ Register TagPrefix="igtbl" Namespace="Infragistics.WebUI.UltraWebGrid" Assembly="Infragistics.WebUI.UltraWebGrid, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>

<%@ Page Language="c#" Inherits="IFF_MAIN.ASPX.Reports.Accounting.BalanceSheet" CodeFile="BalanceSheet.aspx.cs" %>

<%@ Register TagPrefix="igtxt" Namespace="Infragistics.WebUI.WebDataInput" Assembly="Infragistics.WebUI.WebDataInput, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<html>
<head>
    <title>Account Report</title>
    <meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
    <meta content="C#" name="CODE_LANGUAGE">
    <meta content="JavaScript" name="vs_defaultClientScript">
    <meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">

    <script language="javascript">
function goBack() {
var a = '';

    if(history.length >= a)
    {
        a = -1 * a;
        history.go(a);
    }
    else
    {
        location.replace('GLSelection.aspx')
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
	
	
    </script>

    <link href="/IFF_MAIN/ASPX/CSS/AppStyle.css" type="text/css" rel="stylesheet">
    <!--  #INCLUDE FILE="../../include/common.htm" -->

    <script language="javascript">
    function expCall()
    {
    expandPrim(oUltraWebGrid2); 
    expandPrim(oUltraWebGrid3); 
    }
    
    function expandPrim(oUltraWebGrid) 
    {
        if(oUltraWebGrid) 
        {
		var oGrid = oUltraWebGrid;
		var oRows = oGrid.Rows;
        var strV;
		oGrid.suspendUpdates(true);
		
		    for(i=0; i<oRows.length; i++) {
			    oRow = oRows.getRow(i);
                band = igtbl_getBandById(oRow.Id);
                if (band.Key == "HEAD")
                {
	              oRow.setExpanded(true);             
                }
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
        if(document.getElementById("UltraWebGrid2_main")!=null){
            //alert (y);
	        document.getElementById("UltraWebGrid2_main").style.height=parseInt(y-
	        document.getElementById("UltraWebGrid2_main").offsetTop - 60)+"px";
	    }	 
	    if(document.getElementById("UltraWebGrid3_main")!=null){
            //alert (y);
	        document.getElementById("UltraWebGrid3_main").style.height=parseInt(y-
	        document.getElementById("UltraWebGrid3_main").offsetTop - 60)+"px";
	    }	   
    }

    window.onresize=resize_table; 
    	
    </script>

</head>
<body onload="javascript:expCall(); resize_table()">

    <form id="form1" method="post" runat="server">
        <table id="Table2" cellspacing="0" cellpadding="0" width="100%" bgcolor="#ffffff"
            style="height: 420px">
            <tr>
                <td style="height: 2px; width: 15px;">
                    <font face="±¼¸²">
                    </font>
                </td>
                <td align="left" style="height: 2px" valign="middle">
                </td>
                <td style="height: 2px" valign="middle" align="left">
                    <asp:Label ID="Label1" runat="server" Height="8px" DESIGNTIMEDRAGDROP="18" Font-Size="Larger"
                        ForeColor="Black" Font-Bold="True" Width="100%">Sales Report</asp:Label></td>
                <td style="width: 2px; height: 2px">
                </td>
            </tr>
            <tr>
                <td style="height: 4px; width: 15px;">
                </td>
                <td bgcolor="#d5e8cb" style="height: 4px">
                </td>
                <td style="height: 4px" bgcolor="D5E8CB">
                                <asp:Label ID="A_TOTAL" runat="server" BackColor="#CBD6A6" Font-Bold="True" Font-Names="Tahoma"
                                    Font-Size="9px" Height="2px" Width="100px" Visible="False"></asp:Label>
                                <asp:Label ID="LE_TOTAL" runat="server" BackColor="#CBD6A6" Font-Bold="True" Font-Names="Tahoma"
                                    Font-Size="9px" Height="2px" Width="100px" Visible="False"></asp:Label>
                    <igtbl:UltraWebGrid ID="UltraWebGrid1" runat="server" Height="10px" OnInitializeLayout="UltraWebGrid1_InitializeLayout1"
                        OnInitializeRow="UltraWebGrid1_InitializeRow" Width="100%"><Bands>
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
                        <DisplayLayout AllowColSizingDefault="Free" AllowUpdateDefault="Yes" BorderCollapseDefault="Separate"
                            ColWidthDefault="80px" HeaderClickActionDefault="SortMulti" Name="UltraWebGrid1"
                            RowHeightDefault="18px" TableLayout="Fixed" Version="4.00" ViewType="Hierarchical">
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
                            <RowStyleDefault BorderColor="#AAB883" BorderStyle="Solid" BorderWidth="1px" BackColor="White"
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
                            <HeaderStyleDefault BackColor="#CBD6A6" BorderStyle="Solid" ForeColor="Black" HorizontalAlign="Left"
                                BorderWidth="1px" Font-Names="Tahoma" Font-Size="8pt">
                                <BorderDetails WidthLeft="1px" ColorLeft="White" ColorTop="White" WidthTop="1px" />
                                <Padding Left="5px" Right="5px" />
                            </HeaderStyleDefault>
                            <RowAlternateStyleDefault BackColor="#E0E0E0">
                            </RowAlternateStyleDefault>
                            <EditCellStyleDefault BorderStyle="None" BorderWidth="0px" Font-Names="Tahoma" Font-Size="8pt"
                                HorizontalAlign="Left" VerticalAlign="Middle">
                            </EditCellStyleDefault>
                            <FrameStyle BorderStyle="Solid" BorderWidth="1px" Font-Names="Tahoma" Font-Size="8pt"
                                Height="10px" Width="100%" BackColor="#FAFCF1" Cursor="Hand">
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
                    </igtbl:UltraWebGrid></td>
                <td style="width: 2px; height: 4px">
                </td>
            </tr>
            <tr>
                <td style="height: 13px; width: 15px;">
                </td>
                <td bgcolor="whitesmoke" style="height: 13px" valign="top">
                </td>
                <td style="height: 13px" valign="top" bgcolor="whitesmoke">
                    <asp:Label ID="Label2" runat="server" Width="100%" Font-Bold="True" ForeColor="Navy"
                        Font-Size="10px" Height="8px" Font-Italic="True"></asp:Label></td>
                <td style="width: 2px; height: 13px">
                </td>
            </tr>
            <tr>
                <td style="height: 2px; width: 15px;">
                </td>
                <td bgcolor="#f5f5f5" style="height: 2px" valign="top">
                </td>
                <td style="height: 2px" valign="top" bgcolor="#f5f5f5">
                    <asp:Label ID="lblNoData" runat="server" Width="100%" Font-Bold="True" ForeColor="Navy"
                        Font-Italic="True" Font-Underline="True">...</asp:Label></td>
                <td style="width: 2px; height: 2px">
                </td>
            </tr>
            <tr>
                <td height="5" style="width: 15px">
                </td>
                <td bgcolor="#d5e8cb" height="5" valign="top">
                </td>
                <td valign="top" bgcolor="D5E8CB" height="5">
                </td>
                <td style="width: 2px" height="5">
                </td>
            </tr>
            <tr>
                <td style="height: 1px; width: 15px;">
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
                <td style="width: 15px; height: 224px">
                </td>
                <td align="left" style="height: 224px" valign="top">
                </td>
                <td align="left" style="height: 224px" valign="top">
                    <table width="100%" cellspacing="0" cellpadding="0">
                        <tr>
                            <td align="right" style="width: 50%; height: 13px" valign="top">
                            </td>
                            <td align="right" rowspan="1" style="width: 50%; height: 13px" valign="top">
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 50%; height: 315px;" valign="top">
                                <igtbl:UltraWebGrid ID="UltraWebGrid2" runat="server" Height="400px" OnInitializeLayout="UltraWebGrid1_InitializeLayout1"
                        OnInitializeRow="UltraWebGrid1_InitializeRow" Width="100%">
                                    <DisplayLayout AllowColSizingDefault="Free" AllowUpdateDefault="Yes" BorderCollapseDefault="Separate"
                            ColWidthDefault="80px" HeaderClickActionDefault="SortMulti" Name="UltraWebGrid2"
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
                                        <HeaderStyleDefault BackColor="#CBD6A6" BorderStyle="Solid" ForeColor="Black" HorizontalAlign="Left"
                                BorderWidth="1px" Font-Names="Tahoma" Font-Size="8pt" Font-Bold="False">
                                            <BorderDetails WidthLeft="1px" ColorLeft="White" ColorTop="White" WidthTop="1px" />
                                            <Padding Left="5px" Right="5px" />
                                        </HeaderStyleDefault>
                                        <FrameStyle BorderStyle="Solid" BorderWidth="1px" Font-Names="Tahoma" Font-Size="8pt"
                                Height="400px" Width="100%" BackColor="White" Cursor="Hand">
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
                                            <FilterHighlightRowStyle BackColor="#151C55" ForeColor="White">
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
                                                <FilterHighlightRowStyle BackColor="#151C55" ForeColor="White">
                                                </FilterHighlightRowStyle>
                                            </FilterOptions>
                                        </igtbl:UltraGridBand>
                                    </Bands>
                                </igtbl:UltraWebGrid></td>
                            <td rowspan="" style="width: 50%; height: 315px;" valign="top">
                                <igtbl:UltraWebGrid ID="UltraWebGrid3" runat="server" Height="400px" OnInitializeLayout="UltraWebGrid1_InitializeLayout1"
                        OnInitializeRow="UltraWebGrid1_InitializeRow" Width="100%">
                                    <DisplayLayout AllowColSizingDefault="Free" AllowUpdateDefault="Yes" BorderCollapseDefault="Separate"
                            ColWidthDefault="80px" HeaderClickActionDefault="SortMulti" Name="UltraWebGrid3"
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
                                        <HeaderStyleDefault BackColor="#CBD6A6" BorderStyle="Solid" ForeColor="Black" HorizontalAlign="Left"
                                BorderWidth="1px" Font-Names="Tahoma" Font-Size="8pt" Font-Bold="False">
                                            <BorderDetails WidthLeft="1px" ColorLeft="White" ColorTop="White" WidthTop="1px" />
                                            <Padding Left="5px" Right="5px" />
                                        </HeaderStyleDefault>
                                        <FrameStyle BorderStyle="Solid" BorderWidth="1px" Font-Names="Tahoma" Font-Size="8pt"
                                Height="400px" Width="100%" BackColor="White" Cursor="Hand">
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
                                            <FilterHighlightRowStyle BackColor="#151C55" ForeColor="White">
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
                                                <FilterHighlightRowStyle BackColor="#151C55" ForeColor="White">
                                                </FilterHighlightRowStyle>
                                            </FilterOptions>
                                        </igtbl:UltraGridBand>
                                    </Bands>
                                </igtbl:UltraWebGrid></td>
                        </tr>
                    </table>
        <asp:Button ID="btnReset" runat="server" Text="Reset" Width="80px" Height="20px"
            BackColor="#E0E0E0" Visible="False" OnClick="btnReset_Click"></asp:Button><asp:Button
                ID="butHideCol" runat="server" Text="Hide" Width="80px" Height="20px" BackColor="#E0E0E0"
                Visible="False" OnClick="butHideCol_Click"></asp:Button><asp:Button ID="btnSortAsce"
                    runat="server" Text="Asce." Width="80px" Height="20px" BackColor="#E0E0E0" Visible="False"
                    OnClick="btnSortAsce_Click"></asp:Button><asp:Button ID="btnSortDesc" runat="server"
                        Text="Desc." Width="80px" Height="20px" BackColor="#E0E0E0" Visible="False" OnClick="btnSortDesc_Click">
                    </asp:Button><asp:Button ID="btnPrint" runat="server" Text="Print" Width="80px" Height="20px"
                        BackColor="#E0E0E0" Visible="False" OnClick="btnPrint_Click"></asp:Button><asp:Button
                            ID="btnExcel" runat="server" Text="Excel" Width="80px" Height="20px" BackColor="#E0E0E0"
                            Visible="False" OnClick="btnExcel_Click"></asp:Button><asp:Button ID="btnXML" runat="server"
                                Text="XML" Width="80px" Height="20px" BackColor="#E0E0E0" Visible="False" OnClick="btnXML_Click">
                            </asp:Button><asp:Button ID="btnBack" runat="server" Text="<< Back" Width="60px"
                                DESIGNTIMEDRAGDROP="14" Visible="False" OnClick="Button1_Click"></asp:Button></td>
                <td style="width: 1px; height: 224px">
                </td>
            </tr>
            <tr>
                <td style="height: 17px; width: 15px;">
                </td>
                <td align="left" style="height: 17px" valign="top">
                </td>
                <td valign="top" align="left" style="height: 17px">
                    </td>
                <td style="width: 1px; height: 17px;">
                </td>
            </tr>
        </table>
        <asp:Button ID="btnValidate" runat="server" Text="for Validation" Visible="False"></asp:Button><asp:LinkButton
            ID="LinkButton1" runat="server" Visible="False">LinkButton</asp:LinkButton>
        <asp:TextBox ID="TextBox1" runat="server" Width="1px"></asp:TextBox>
        <asp:TextBox ID="TextBox2" runat="server" Width="1px"></asp:TextBox>
        <cc1:UltraWebGridExcelExporter ID="UltraWebGridExcelExporter1" runat="server">
        </cc1:UltraWebGridExcelExporter>
        <asp:Button ID="Button1" runat="server" Text="<< Back" Width="60px"
                                DESIGNTIMEDRAGDROP="14" Visible="False" OnClick="Button1_Click"></asp:Button>
                                <asp:Button ID="btnPDF" runat="server" Text="PDF" Width="60px"
                                Visible="False" OnClick="btnPDF_Click"></asp:Button>
                                <asp:Button ID="btnDOC" runat="server" Text="DOC" Width="60px"
                                Visible="False" OnClick="btnDOC_Click"></asp:Button>
        </form>
</body>
</html>
