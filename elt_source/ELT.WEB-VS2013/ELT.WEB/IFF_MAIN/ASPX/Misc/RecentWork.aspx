<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RecentWork.aspx.cs" Inherits="ASPX_Misc_RecentWork" %>

<%@ Register TagPrefix="igtbl" Namespace="Infragistics.WebUI.UltraWebGrid" Assembly="Infragistics.WebUI.UltraWebGrid, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Recent Work</title>
		<LINK href="../CSS/AppStyle.css" type=text/css rel=stylesheet>
		<script language=javascript>

function myClose() {
window.close();
}

function cch(gridName,cellId,button) {

var SelectedChild = 'url(../../Images/mark_o.gif)';
var row=igtbl_getRowById(cellId);
var cell=igtbl_getCellById(cellId);
var oCell = igtbl_getCellById(cellId);
var cUrl = oCell.Element.style.backgroundImage;
var band = igtbl_getBandById(row.Id);

		if(band.Key == 'RCDETAIL') {
			if(cell.Column.Key=="STATUS") {
				if(cUrl==SelectedChild) {
				    row.getCellFromKey("x").setValue('X');
					oCell.Element.style.backgroundImage =  'url(../../Images/mark_x.gif)';
				}
				else {
					oCell.Element.style.backgroundImage =  'url(../../Images/mark_o.gif)';
				    row.getCellFromKey("x").setValue(' ');
				}
			}
		}
}

function myUnLoad() {
var rVal = document.fShowModal.hReturnValue.value;

	if (rVal == 'cancel') 
	{
	window.returnValue = '';
	}
	else
	{
	window.returnValue = document.fShowModal.hReturnValue.value;
	}
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

    function expandToday() 
    {
		var oGrid = oUltraWebGrid1;
		var oBands = oGrid.Bands;
		var oBand = oBands[0];
		var oColumns = oBand.Columns;
		var count = oColumns.length;
		var oRows = oGrid.Rows;
		var rDate;
		
//		var today=new Date();
//		var thisMonth = (today.getMonth()+1).toString();
//		var thisDate = today.getDate().toString();

//		if ( thisMonth.length == 1 ) 
//		{
//		    thisMonth = '0' + thisMonth;
//		}
//		if ( thisDate.length == 1 ) 
//		{
//		    thisDate = '0' + thisDate;
//		}
//		
//		var cDate = thisMonth + "/" + thisDate + "/" + today.getYear().toString();

		oGrid.suspendUpdates(true);
		for(i=0; i<oRows.length; i++) {
			oRow = oRows.getRow(i);
			rDate = oRow.getCellFromKey("DATE").getValue();
			
            if ( rDate = 'Today' )
            {
    			oRow.setExpanded(true); 
    			break ;
 			}
		}
	}	
        
function mySave()
 {
 		__doPostBack("btnSave", "");

 }        
		</script>

</HEAD>
	<body  onunload="javascript:myUnLoad();" onload="javascript:expandToday();">
    
        <form method="post" name="fShowModal">
	        <input type=hidden name="hReturnValue">
        </FORM>        
        <form id=form1 method=post runat="server">
            <table id="Table2" bgcolor="#ffffff" cellpadding="0" cellspacing="0" height="100%"
                width="100%">
                <tr>
                    <td align="left" valign="top">
                        <input name="CloseMe" type="button" onClick="javascript:window.close();" value="Close"/>
                        <img onclick="javascript:mySave();" src="../../Images/button_save_small.gif" style="cursor: hand;
                border-top-style: none; border-right-style: none; border-left-style: none; border-bottom-style: none" /></td>
                    <td style="width: 1px">
                    </td>
                </tr>
                <tr align="center" bgcolor="ccebed">
                    <td valign="middle" style="height: 14px">
                    </td>
                    <td style="width: 1px; height: 14px;">
                    </td>
                </tr>
                <tr>
                    <td style="height: 320px" align="left" valign="top">
        <igtbl:UltraWebGrid ID="UltraWebGrid1" runat="server" Height="300px" OnInitializeLayout="UltraWebGrid1_InitializeLayout1"
            OnInitializeRow="UltraWebGrid1_InitializeRow" Width="100%">
                <Bands>
                    <igtbl:UltraGridBand AddButtonCaption="Column0Column1Column2" Key="Column0Column1Column2">
                        <AddNewRow View="NotSet" Visible="NotSet">
                        </AddNewRow>
                    </igtbl:UltraGridBand>
                </Bands>
                <DisplayLayout AllowColSizingDefault="Free" AllowUpdateDefault="Yes" BorderCollapseDefault="Separate"
                    HeaderClickActionDefault="SortMulti" Name="UltraWebGrid1" RowHeightDefault="20px"
                    TableLayout="Fixed" Version="4.00" ViewType="Hierarchical">
                    <GroupByBox>
                        <BandLabelStyle BackColor="White">
                        </BandLabelStyle>
                    </GroupByBox>
                    <FooterStyleDefault BackColor="#CFDDF0" BorderStyle="Solid" BorderWidth="1px">
                        <BorderDetails ColorLeft="White" ColorTop="White" WidthLeft="1px" WidthTop="1px"  />
                    </FooterStyleDefault>
                    <RowStyleDefault BorderColor="#ADCBEF" BorderStyle="Solid" BorderWidth="1px">
                        <BorderDetails StyleLeft="None" WidthLeft="1px" WidthRight="1px" WidthTop="0px"  />
                        <Padding Left="3px"  />
                    </RowStyleDefault>
                    <ClientSideEvents ClickCellButtonHandler="ccbh" AfterCellUpdateHandler="acuh" ValueListSelChangeHandler="vlsch" BeforeEnterEditModeHandler="beemh" CellClickHandler="cch" AfterRowInsertHandler="arih"  />
                    <HeaderStyleDefault BackColor="#CFDDF0" BorderStyle="Solid" ForeColor="#1B5AA1" Height="17px"
                        HorizontalAlign="Left">
                        <BorderDetails ColorBottom="173, 203, 239" StyleBottom="Solid" StyleLeft="None" StyleRight="None"
                            StyleTop="None" WidthBottom="1px" WidthLeft="0px" WidthRight="0px"  />
                    </HeaderStyleDefault>
                    <EditCellStyleDefault BorderStyle="None" BorderWidth="0px">
                    </EditCellStyleDefault>
                    <FrameStyle BorderColor="White" BorderStyle="Solid" BorderWidth="1px" Font-Names="Tahoma"
                        Font-Size="8pt" Height="300px" Width="100%">
                    </FrameStyle>
                    <Pager Alignment="Center" PagerAppearance="Top" PageSize="20">
                        <Style BackColor="LightGray" BorderStyle="Solid" BorderWidth="1px">
<BorderDetails ColorTop="White" WidthLeft="1px" WidthTop="1px" ColorLeft="White"></BorderDetails>
</Style>
                    </Pager>
                    <AddNewBox>
                        <Style BackColor="LightGray" BorderStyle="Solid" BorderWidth="1px">
<BorderDetails ColorTop="White" WidthLeft="1px" WidthTop="1px" ColorLeft="White"></BorderDetails>
</Style>
                    </AddNewBox>
                </DisplayLayout>
            </igtbl:UltraWebGrid>
                    </td>
                    <td style="width: 1px; height: 338px">
                    </td>
                </tr>
                <tr>
                    <td align="left" valign="top">
                    </td>
                    <td style="width: 1px">
                    </td>
                </tr>
                <tr align="center" bgcolor="ccebed">
                    <td valign="middle" style="height: 14px">
                    </td>
                    <td style="width: 1px; height: 14px;">
                    </td>
                </tr>
                <tr>
                    <td align="left" style="height: 417px" valign="top">
                        <asp:Button ID="btnSave" runat="server" DESIGNTIMEDRAGDROP="266"
            Font-Size="Larger" OnClick="btnSave_Click" Visible="False" Width="60px" /><asp:LinkButton ID="LinkButton1" runat="server" Visible="False">LinkButton</asp:LinkButton>
                        </td>
                    <td style="width: 1px; height: 417px">
                    </td>
                </tr>
            </table>
        </form>	
</body>
</html>
