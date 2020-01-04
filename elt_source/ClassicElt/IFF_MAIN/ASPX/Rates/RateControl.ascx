<%@ Control Language="C#" AutoEventWireup="true" CodeFile="RateControl.ascx.cs" 
Inherits="ASPX_OnLines_Rate_RateControl" %>

<%@ Register Assembly="Infragistics.WebUI.UltraWebToolbar, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.UltraWebToolbar" TagPrefix="igtbar" %>
<%@ Register Assembly="Infragistics.WebUI.WebDataInput, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.WebDataInput" TagPrefix="igtxt" %>
<%@ Register Assembly="Infragistics.WebUI.WebNavBar, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.WebNavBar" TagPrefix="ignavbar" %>
<%@ Register Assembly="Infragistics.WebUI.UltraWebGrid, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb"
    Namespace="Infragistics.WebUI.UltraWebGrid" TagPrefix="igtbl" %>
<div>
    <table class="bodyheader" cellpadding="0" cellspacing="2" border="0" width="95%" align="center">
        <tr>
            <td align="left" valign="middle" class="pageheader" colspan="3">
                Rate Manager</td>
        </tr>
        <tr>
            <td style="width:70px">
                Rate Type:
            </td>
            <td>
                <asp:DropDownList ID="lstRateTypes" runat="server" onchange="changeRateType(this);"
                    CssClass="bodycopy" Width="200px">
                    <asp:ListItem Value="1">Agent Buying</asp:ListItem>
                    <asp:ListItem Value="3">Airline Buying</asp:ListItem>
                    <asp:ListItem Value="4">Customer Selling</asp:ListItem>
                    <asp:ListItem Value="5">IATA</asp:ListItem>
                </asp:DropDownList>
            </td>
            <td align="right">
                <asp:ImageButton runat="server" ImageUrl="../../Images/button_save.gif" ID="btnUpdateRates" /></td>
        </tr>
    </table>
</div>
<div align="center">
    <igtbl:UltraWebGrid ID="UltraWebGrid1" runat="server" Height="400px" Width="95%"
        OnUpdateGrid="UltraWebGrid1_UpdateGrid" OnInitializeLayout="UltraWebGrid1_InitializeLayout"
        DataSourceID="ObjectDataSource1">
        <Bands>
            <igtbl:UltraGridBand>
                <FilterOptions EmptyString="" AllString="" NonEmptyString="">
                    <FilterDropDownStyle BorderWidth="1px" BorderColor="Silver" BorderStyle="Solid" BackColor="White"
                        Width="200px" CustomRules="overflow:auto;" CssClass="bodycopy" />
                    <FilterHighlightRowStyle ForeColor="White" BackColor="#151C55" CssClass="bodycopy" />
                </FilterOptions>
                <AddNewRow View="NotSet" Visible="NotSet">
                </AddNewRow>
            </igtbl:UltraGridBand>
        </Bands>
        <DisplayLayout Name="ctl00xUltraWebGrid1" BorderCollapseDefault="Separate" RowHeightDefault="20px"
            SelectTypeRowDefault="Single" RowSizingDefault="Free" ViewType="OutlookGroupBy"
            AllowAddNewDefault="Yes" AllowDeleteDefault="Yes" AllowUpdateDefault="Yes" SelectTypeCellDefault="Single"
            SelectTypeColDefault="Single" EnableInternalRowsManagement="True" AllowSortingDefault="OnClient"
            HeaderClickActionDefault="SortSingle" RowSelectorsDefault="No" Version="4.00">
            <FrameStyle BorderWidth="1px" BorderStyle="Solid" Height="400px" Width="95%">
            </FrameStyle>
            <GroupByBox>
                <Style BorderColor="Window" BackColor="ActiveBorder" CssClass="bodycopy"></Style>
            </GroupByBox>
            <FooterStyleDefault BorderWidth="1px" BorderStyle="Solid" BackColor="LightGray" CssClass="bodycopy">
                <BorderDetails ColorTop="White" WidthLeft="1px" WidthTop="1px" ColorLeft="White"></BorderDetails>
            </FooterStyleDefault>
            <RowStyleDefault Font-Names="Verdana,Arial,Helvetica,Sans-serif" Font-Size="9px"
                BorderWidth="1px" BorderColor="#888888" BorderStyle="Solid" BackColor="Window"
                TextOverflow="Ellipsis">
                <BorderDetails ColorTop="Window" ColorLeft="Window"></BorderDetails>
                <Padding Left="3px"></Padding>
            </RowStyleDefault>
            <FilterOptionsDefault EmptyString="(Empty)" AllString="(All)" NonEmptyString="(NonEmpty)">
                <FilterDropDownStyle BorderWidth="1px" BorderColor="Silver" BorderStyle="Solid" BackColor="White"
                    Width="200px" CustomRules="overflow:auto;">
                </FilterDropDownStyle>
                <FilterHighlightRowStyle ForeColor="White" BackColor="#151C55">
                </FilterHighlightRowStyle>
            </FilterOptionsDefault>
            <HeaderStyleDefault HorizontalAlign="Left" BorderStyle="Solid" BackColor="#CDCDCA"
                BackgroundImage="/ig_common/Images/Themes/Aero/header_silver_bg_19.jpg" ForeColor="Black"
                Height="19px">
            </HeaderStyleDefault>
            <EditCellStyleDefault BorderWidth="0px" BorderStyle="None">
            </EditCellStyleDefault>
            <AddNewBox Hidden="False" Prompt="Click buttons to add new entry, or double click on each cell to edit."
                ButtonConnectorStyle="Solid" ButtonConnectorColor="ActiveBorder">
                <Style BorderWidth="3px" BorderStyle="Solid" BackColor="Info" BorderColor="Info"
                    CssClass="bodycopy" />
                <ButtonStyle VerticalAlign="Middle" Width="100px" BorderStyle="Outset" BorderWidth="1px"
                    Cursor="Hand" ForeColor="#7f3116">
                </ButtonStyle>
            </AddNewBox>
            <Pager AllowPaging="True" StyleMode="QuickPages" QuickPages="3" PageSize="50">
                <Style BorderWidth="3px" BorderStyle="Solid" BackColor="Info" BorderColor="Info"
                    CssClass="bodycopy" />
            </Pager>
            <ActivationObject BorderColor="168, 167, 191">
            </ActivationObject>
            <SelectedRowStyleDefault BackColor="#CCEBED">
            </SelectedRowStyleDefault>
            <ImageUrls CollapseImage="/ig_common/Images/ig_treeMinus.gif" ExpandImage="/ig_common/Images/ig_treePlus.gif" />
            <ClientSideEvents AfterRowInsertHandler="UltraWebGrid1_AfterRowInsertHandler" BeforeEnterEditModeHandler="UltraWebGrid1_BeforeEnterEditModeHandler"
                BeforeRowDeletedHandler="UltraWebGrid1_BeforeRowDeletedHandler" />
        </DisplayLayout>
    </igtbl:UltraWebGrid>
    <ignavbar:WebNavBar ID="WebNavBar1" runat="server" BorderWidth="1px" BackColor="#EDEDED"
        BorderColor="Gainsboro" ForeColor="" ImageDirectory="/ig_common/Images/" Position="Bottom"
        TabIndex="-1" Width="" BorderStyle="Solid" Movable="True" Theme="XpSilver" Height="20px">
        <Extension>
            <Submit Visible="false" />
        </Extension>
    </ignavbar:WebNavBar>
</div>
<div style="visibility: hidden;">
    <div id="igtxtRateWebGrid_TextCustomerDiv">
    </div>
    <div style="position: absolute">
        <igtxt:WebTextEdit runat="server" ID="TextCustomer" BackColor="AliceBlue" ToolTip="Typing any word will bring a list of customers">
            <ClientSideEvents Focus="TextCustomer_Focus" />
        </igtxt:WebTextEdit>
    </div>
</div>
<div style="visibility: hidden">
    <div id="igtxtRateWebGrid_TextAgentDiv">
    </div>
    <div style="position: absolute">
        <igtxt:WebTextEdit runat="server" ID="TextAgent" BackColor="AliceBlue" ToolTip="Typing any word will bring a list of agents">
            <ClientSideEvents Focus="TextAgent_Focus" />
        </igtxt:WebTextEdit>
    </div>
</div>

<script type="text/jscript">
    function TextCustomer_Focus(oEdit, text, oEvent){
        // Binding JPED to WebTextEdit
        initializeJPEDField(oEdit.Element);
        oEdit.Element.onkeyup = function(){organizationFill(oEdit.Element,"Customer","lstCustomerNameChange");};
        
        if(text == "" ){
            organizationFillAll(oEdit.Element.id,"Customer","lstCustomerNameChange");
        }
        else{
            organizationFill(oEdit.Element,"Customer","lstCustomerNameChange");
        }
    }
    
    function lstCustomerNameChange(orgNum,orgName)
    {
        try{
            var activeRow = igtbl_getActiveRow(gridNameMemory);
            activeRow.getCellFromKey("customer_no").setValue(orgNum);
            activeRow.getCellFromKey("dba_name").setValue(orgName);
            
            var divObj = document.getElementById("igtxtRateWebGrid_TextCustomerDiv");
            divObj.innerHTML = "";
            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";
        }catch(err){}
    }
    
    function TextAgent_Focus(oEdit, text, oEvent){
        // Binding JPED to WebTextEdit
        initializeJPEDField(oEdit.Element);
        oEdit.Element.onkeyup = function(){organizationFill(oEdit.Element,"Agent","lstAgentNameChange");};
        if(text == "" ){
            organizationFillAll(oEdit.Element.id,"Agent","lstAgentNameChange");
        }
        else{
            organizationFill(oEdit.Element,"Agent","lstAgentNameChange");
        }
    }
    
    function lstAgentNameChange(orgNum, orgName)
    {
        try{
            var activeRow = igtbl_getActiveRow(gridNameMemory);
            activeRow.getCellFromKey("agent_no").setValue(orgNum);
            activeRow.getCellFromKey("dba_name").setValue(orgName);
            
            var divObj = document.getElementById("igtxtRateWebGrid_TextAgentDiv");
            divObj.innerHTML = "";
            divObj.style.position = "absolute";
            divObj.style.visibility = "hidden";
        }catch(err){ alert(gridNameMemory); }
    }
    
    function CopyRoutes(currentRow, parentRow)
    {
        currentRow.getCellFromKey("elt_account_number").setValue(parentRow.getCellFromKey("elt_account_number").getValue());
        currentRow.getCellFromKey("rate_type").setValue(parentRow.getCellFromKey("rate_type").getValue());
        currentRow.getCellFromKey("origin_port").setValue(parentRow.getCellFromKey("origin_port").getValue());
        currentRow.getCellFromKey("dest_port").setValue(parentRow.getCellFromKey("dest_port").getValue());
        currentRow.getCellFromKey("kg_lb").setValue(parentRow.getCellFromKey("kg_lb").getValue());
    }
    
    function CopyAirline(currentRow, parentRow)
    {
        currentRow.getCellFromKey("elt_account_number").setValue(parentRow.getCellFromKey("elt_account_number").getValue());
        currentRow.getCellFromKey("rate_type").setValue(parentRow.getCellFromKey("rate_type").getValue());
        currentRow.getCellFromKey("origin_port").setValue(parentRow.getCellFromKey("origin_port").getValue());
        currentRow.getCellFromKey("dest_port").setValue(parentRow.getCellFromKey("dest_port").getValue());
        currentRow.getCellFromKey("kg_lb").setValue(parentRow.getCellFromKey("kg_lb").getValue());
        currentRow.getCellFromKey("airline").setValue(parentRow.getCellFromKey("airline").getValue());
        currentRow.getCellFromKey("share").setValue(parentRow.getCellFromKey("share").getValue());
        currentRow.getCellFromKey("fl_rate").setValue(parentRow.getCellFromKey("fl_rate").getValue());
        currentRow.getCellFromKey("sec_rate").setValue(parentRow.getCellFromKey("sec_rate").getValue());
        currentRow.getCellFromKey("include_fl_rate").setValue(parentRow.getCellFromKey("include_fl_rate").getValue());
        currentRow.getCellFromKey("include_sec_rate").setValue(parentRow.getCellFromKey("include_sec_rate").getValue());
        
        if(parentRow.Rows){
            if(parentRow.Rows.length == 1)
            {
                currentRow.getCellFromKey("weight_break").setValue("Min($)");
            }
            if(parentRow.Rows.length == 2)
            {
                currentRow.getCellFromKey("weight_break").setValue("+Min");
            }
        }
        currentRow.getCellFromKey("item_no").setValue(parentRow.Rows.length-1);
    }
    
    function changeRateType(thisObj){
    
        switch (thisObj.value)
        {
            case "1":
                window.location.href="AgentBuying.aspx";
                break;
            case "3":
                window.location.href="AirlineBuying.aspx";
                break;
            case "4":
                window.location.href="CustomerSelling.aspx";
                break;
            case "5":
                window.location.href="IATA.aspx";
                break;
        }
    }
    
    function UltraWebGrid1_BeforeEnterEditModeHandler(gridName, cellId)
    {
        var currentCell = igtbl_getCellById(cellId);
        var currentRow = igtbl_getRowById(cellId);
        
        if(currentRow.Rows){
            if(currentRow.Rows.length > 0){
                if(currentCell.Column.Key == "share"){
                    return false;
                }
                if(currentCell.Column.Key == "fl_rate"){
                    return false;
                }
                if(currentCell.Column.Key == "sec_rate"){
                    return false;
                }
                if(currentCell.Column.Key == "include_fl_rate"){
                    return false;
                }
                if(currentCell.Column.Key == "include_sec_rate"){
                    return false;
                }
                else{
                    return true;
                }
            }
        }
        
    	else if(currentCell.getValue() == "Min($)" || currentCell.getValue()  == "+Min")
    	{
    	    // cancel action
    	    return true;
    	}
    }
    
    function UltraWebGrid1_BeforeRowDeletedHandler(gridName, rowId){
    	var currentRow = igtbl_getRowById(rowId);
    	var weightBreak = currentRow.getCellFromKey("weight_break").getValue();
    	
    	if(weightBreak == "Min($)" || weightBreak == "+Min")
    	{
    	    // cancel action
    	    return true;
    	}
    }
</script>

