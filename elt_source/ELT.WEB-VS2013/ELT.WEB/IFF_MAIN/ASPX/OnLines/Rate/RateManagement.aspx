<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RateManagement.aspx.cs" Inherits="ASPX_OnLines_Rate_RateManagement" %>
<%@ Register Assembly="DevExpress.Web.v13.2, Version=13.2.9.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"
    Namespace="DevExpress.Web.ASPxEditors" TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.Web.v13.2, Version=13.2.9.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"
    Namespace="DevExpress.Web.ASPxGridView" TagPrefix="dx" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
    <title></title>
    <link href="../../../ASPX/CSS/elt_css.css" rel="stylesheet" type="text/css" />
    <script src="/Scripts/jquery-1.7.1.js" type="text/javascript"></script>
    <script src="/Scripts/jquery-ui-1.8.20.js" type="text/javascript"></script>
    <link href="/Scripts/jquery-ui-1.10.3/themes/base/jquery-ui.css" rel="stylesheet"
        type="text/css" />
    <link href="../../../ASPX/CSS/Tables.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">

        var currentBreaks;
        $(document).ready(function () {

        });
        function GridSlave_RowClick(s, e) {
            saveChangesBtn.SetEnabled(true);
        }
	    function redirectBack(){
 		   // $('#gridMasterWrapper').hide();
	        //window.top.location.href=window.top.location.href;
	        $('#btnRefresh').click();
	        
	    }
        function RefreshSlave(s, e) {
           redirectBack();
        }
        function saveChangesBtn_Click(s, e) {
            GridSlave.UpdateEdit();
        }

        function cancelChangesBtn_Click(s, e) {
            saveChangesBtn.SetEnabled(false);
            GridSlave.CancelEdit();
        }
        function OpenNewRouting() {
            // alert('OpenNewRouting');
            $('#breakTbWrapper').show();
            $('#gridMasterWrapper').hide();
        }
        function CloseNewRouting() {
            // alert('CloseNewRouting');
            $('#gridMasterWrapper').show();
            $('#breakTbWrapper').hide();
        }

        function HideGridMaster(s, e) {
            $('#gridMasterWrapper').hide();
        }
    </script>
</head>
<body>
    <form id="form1" method="post" runat="server">
    <asp:ScriptManager ID="ScriptManager" runat="server" />
    <br />
    <asp:HiddenField runat="server" Value="0" ID="h_org_account_number" />
    <asp:HiddenField runat="server" Value="0" ID="h_rate_type" />
    <table width="90%" border="0" align="center" cellpadding="2" cellspacing="0">
        <tr>
            <td height="32" align="left" valign="middle" class="pageheader">
                Rate Manager
            </td>
        </tr>
    </table>
    <table width="90%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="73beb6"
        bgcolor="#73beb6" class="border1px">
        <tr bgcolor="ccebed">
            <td height="8" align="left" valign="top" bgcolor="ccebed">
                <asp:Label ID='lblError' runat="server" Width="100%" Font-Bold="True" ForeColor="Red"
                    Font-Italic="True" Font-Underline="True"></asp:Label>
            </td>
        </tr>
        <tr bgcolor="73beb6">
            <td height="1" align="left" valign="top">
            </td>
        </tr>
        <tr align="left" bgcolor="ecf7f8">
            <td align="center" valign="middle" bgcolor="ecf7f8" style="height: 20px">
                <br />
                <table width="75%" border="0" cellpadding="4" cellspacing="0" bordercolor="73beb6"
                    bgcolor="#FFFFFF" class="border1px">
                    <tr bgcolor="ecf7f8">
                        <td width="1%">
                            &nbsp;
                        </td>
                        <td width="8%" height="24" bgcolor="ecf7f8" class="bodyheader">
                            Rate Type
                        </td>
                        <td width="31%" bgcolor="ecf7f8">
                            <asp:DropDownList CssClass="bodycopy" ID="ddlRateType" ClientIDMode="Static" runat="server"
                                Width="140px" OnSelectedIndexChanged="ddlRateType_SelectedIndexChanged" AutoPostBack="True">
                                <asp:ListItem Value="4" Selected="True">Customer Selling Rate</asp:ListItem>
                                <asp:ListItem Value="3">Airline Buying Rate</asp:ListItem>
                                <asp:ListItem Value="1">Agent Buying Rate</asp:ListItem>
                                <asp:ListItem Value="5">IATA Rate</asp:ListItem>
                            </asp:DropDownList>
                        </td>
                        <td width="20%" align="left" valign="middle" bgcolor="ecf7f8" class="bodycopy">
                            <span class="bodyheader">Business Name </span>(Optional)
                        </td>
                        <td width="1" bgcolor="ecf7f8" class="smallselect" valign="middle">
                            &nbsp;
                        </td>
                        <td width="200" bgcolor="ecf7f8" class="smallselect" valign="middle" style="padding-right: 0;">
                            <dx:ASPxComboBox ID="ComboCompanyList" runat="server" CallbackPageSize="10" DataSourceID="SQLDsClientProfile"
                                EnableCallbackMode="true" ValueType="System.String" ValueField="org_account_number"
                                TextField="dba_name" DropDownStyle="DropDown" IncrementalFilteringMode="Contains"
                                OnItemRequestedByValue="ComboCompanyList_ItemRequestedByValue" OnItemsRequestedByFilterCondition="ComboCompanyList_ItemsRequestedByFilterCondition">
                            </dx:ASPxComboBox>
                        </td>
                        <td bgcolor="ecf7f8" valign="middle" style="padding-left: 0;">
                        </td>
                        <td width="7%" align="right" bgcolor="ecf7f8">
                            <asp:ImageButton ID='goBtn' runat="server" ImageUrl="../../../images/button_go.gif"
                                OnClick="goBtn_Click"></asp:ImageButton>
                        </td>
                    </tr>
                </table>
                <br />
            </td>
        </tr>
        <tr bgcolor="73beb6">
            <td height="1" align="left" valign="top">
            </td>
        </tr>
        <tr align="center" bgcolor="ffffff">
            <td valign="top" class="bodycopy" style="">
                <div style="padding: 10px;height: 400px; overflow: scroll"  id="gridMasterWrapper">
                    <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                        <ContentTemplate>
                        <asp:Button ID="btnRefresh" runat="server" Text="" onclick="btnRefresh_Click" style="display:none" />
                            <dx:ASPxGridView ID="GridMaster" Caption="Route" runat="server" OnInit="GridMaster_Init"
                                KeyFieldName="ID"
                                DataSourceID="OdsRoutings" OnHtmlRowCreated="GridMaster_HtmlRowCreated" AutoGenerateColumns="False"
                                OnBeforePerformDataSelect="GridMaster_BeforePerformDataSelect" Visible="False"
                                OnDetailRowExpandedChanged="GridMaster_DetailRowExpandedChanged" 
                                ondatabound="GridMaster_DataBound">
                                <ClientSideEvents Init="function(s, e) {}" BeginCallback="function(s, e) { CloseNewRouting();}"
                                    EndCallback="function(s, e) {}" />
                                <Columns>
                                    <dx:GridViewCommandColumn VisibleIndex="0">
                                        <DeleteButton Visible="true" />
                                        <HeaderCaptionTemplate>
                                            <dx:ASPxHyperLink ID="btnNew" runat="server" Text="New">
                                                <ClientSideEvents Click="function (s, e) {  $('#btnTriggerBreakTable').click();}" />
                                            </dx:ASPxHyperLink>
                                        </HeaderCaptionTemplate>
                                    </dx:GridViewCommandColumn>
                                    <dx:GridViewDataColumn FieldName="CustomerOrgName" Caption="Company Name" Name="CustomerOrgName"
                                        EditFormSettings-Visible="False" VisibleIndex="1">
                                        <EditFormSettings Visible="False"></EditFormSettings>
                                    </dx:GridViewDataColumn>
                                     <dx:GridViewDataColumn FieldName="AgentOrgName" Caption="Agent" Name="AgentOrgName"
                                        EditFormSettings-Visible="False" VisibleIndex="2">
                                        <EditFormSettings Visible="False"></EditFormSettings>
                                    </dx:GridViewDataColumn>
                                  
                                    <dx:GridViewDataColumn FieldName="ID" Caption="ID" VisibleIndex="6" Name="ID" Visible="false">
                                    </dx:GridViewDataColumn>
                                    <dx:GridViewDataComboBoxColumn FieldName="Origin" Caption="Origin" VisibleIndex="3">
                                        <PropertiesComboBox DataSourceID="SqlDsPort" ValueType="System.String" ValueField="port_code"
                                            TextField="port_name">
                                        </PropertiesComboBox>
                                    </dx:GridViewDataComboBoxColumn>
                                    <dx:GridViewDataComboBoxColumn FieldName="Dest" Caption="Destination" VisibleIndex="4">
                                        <PropertiesComboBox DataSourceID="SqlDsPort" ValueType="System.String" ValueField="port_code"
                                            TextField="port_name">
                                        </PropertiesComboBox>
                                    </dx:GridViewDataComboBoxColumn>
                                    <dx:GridViewDataComboBoxColumn FieldName="UnitText" Caption="KG\LB" VisibleIndex="5">
                                        <PropertiesComboBox ValueType="System.String">
                                            <Items>
                                                <dx:ListEditItem Text="KG" Value="K" />
                                                <dx:ListEditItem Text="LB" Value="L" />
                                            </Items>
                                        </PropertiesComboBox>
                                    </dx:GridViewDataComboBoxColumn>
                                </Columns>
                                <Templates>
                                    <DetailRow>
                                        <dataitemtemplate>
                    			<asp:hiddenfield runat="server" enableviewstate="true" id="hRouteId"  value='<%#Eval("ID")%>'/> 
                    			</dataitemtemplate>
                                        <dx:ASPxGridView ID="GridSlave"  runat="server"
                                            ClientInstanceName="GridSlave" KeyFieldName="RateID" Width="100%"
                                            OnInit="GridSlave_Init" OnBatchUpdate="GridSlave_BatchUpdate" >
                                            <ClientSideEvents EndCallback="RefreshSlave"  />
                                            <Columns>
                                                <dx:GridViewCommandColumn ShowNewButtonInHeader="true" ShowDeleteButton="True" ShowUpdateButton="false" />
                                                <dx:GridViewDataComboBoxColumn FieldName="CarrierCode" Caption="Carrier" VisibleIndex="1">
                                                    <PropertiesComboBox DataSourceID="SqlCarrier" ValueType="System.String" ValueField="org_account_number"
                                                        TextField="carrier_name">
                                                    </PropertiesComboBox>
                                                </dx:GridViewDataComboBoxColumn>
                                            </Columns>
                                            <Templates>                                                
                                            </Templates>
                                            <SettingsEditing Mode="Batch" NewItemRowPosition="Bottom"/>
                                        </dx:ASPxGridView>
                                    </DetailRow>
                                </Templates>
                                <SettingsEditing NewItemRowPosition="Bottom">
                                </SettingsEditing>
                                <SettingsDetail ShowDetailRow="true" />
                            </dx:ASPxGridView>
                            
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
                <div id="breakTbWrapper" style="display:none ; padding: 10px">
                    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                        <ContentTemplate>
                            <div>
                                <table class="DevFromTable" id="tbWeightBreak">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <table>
                                                    <tr>
                                                        <td rowspan="3" align="center" valign="top">
                                                            <div style="margin-bottom: 5px;" class="bodylistheader">
                                                                Weight Range Start</div>
                                                            <asp:GridView ID="GridBreak" runat="server" AutoGenerateColumns="False" 
                                                                CssClass="DevFromTable"  ShowFooter="True"
                                                                ShowHeader="False">
                                                                <Columns>
                                                                    <asp:TemplateField>
                                                                        <ItemTemplate>
                                                                            <asp:ImageButton ID="btnDeleteBreak" OnClick="btnDeleteBreak_Click" CommandArgument="<%# ((GridViewRow) Container).RowIndex %>"
                                                                                runat="server" ImageUrl="~/Images/button_delete.gif" />
                                                                        </ItemTemplate>
                                                                    </asp:TemplateField>
                                                                    <asp:TemplateField HeaderText="Range Start">
                                                                        <ItemTemplate>
                                                                            <asp:TextBox ID="txtRateStart" runat="server" Text='<%#Eval("Text")%>'></asp:TextBox>
                                                                        </ItemTemplate>
                                                                    </asp:TemplateField>
                                                                </Columns>
                                                                <FooterStyle HorizontalAlign="Right" />
                                                                <HeaderStyle CssClass="Header" BorderStyle="None" />
                                                                <RowStyle BorderStyle="None" />
                                                            </asp:GridView>
                                                            <div style="margin-top: 5px; text-align: right">
                                                                <asp:ImageButton ID="btnAddNewBreak" runat="server" ImageUrl="~/Images/button_new.gif"
                                                                    OnClick="btnAddNewBreak_Click" /></div>
                                                            <asp:Button ID="btnTriggerBreakTable" runat="server" OnClick="btnTriggerBreakTable_Click"
                                                                Text="" Style="display: none" />
                                                        </td>
                                                        <td>
                                                            Orign
                                                        </td>
                                                        <td>
                                                            <dx:ASPxComboBox ID="ComboOrigin" runat="server" CallbackPageSize="10" DataSourceID="SqlDsPort"
                                                                EnableCallbackMode="true" ValueType="System.String" ValueField="port_code" TextField="port_name"
                                                                DropDownStyle="DropDown" IncrementalFilteringMode="Contains">
                                                            </dx:ASPxComboBox>
                                                        </td>
                                                        <td>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            Destination
                                                        </td>
                                                        <td>
                                                            <dx:ASPxComboBox ID="ComboDestination" runat="server" CallbackPageSize="10" DataSourceID="SqlDsPort"
                                                                EnableCallbackMode="true" ValueType="System.String" ValueField="port_code" TextField="port_name"
                                                                DropDownStyle="DropDown" IncrementalFilteringMode="Contains">
                                                            </dx:ASPxComboBox>
                                                        </td>
                                                        <td>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            Unit
                                                        </td>
                                                        <td align="left">
                                                            <asp:DropDownList CssClass="bodycopy" ID="ddlUnit" ClientIDMode="Static" runat="server"
                                                                Width="140px" AutoPostBack="false">
                                                                <asp:ListItem Value="K" Selected="True">KG</asp:ListItem>
                                                                <asp:ListItem Value="L">LB</asp:ListItem>
                                                            </asp:DropDownList>
                                                        </td>
                                                        <td align="right">
                                                          
                                                           <asp:ImageButton runat="server" ID="btnCancelCreate" 
                                                                ImageUrl="~/Images/button_cancel.gif" onclientclick="CloseNewRouting();"></asp:ImageButton>
                                                            <asp:ImageButton runat="server" ID="btnCreate" ImageUrl="~/Images/button_create.gif"
                                                                OnClick="btnCreate_Click"></asp:ImageButton>
                                                            &nbsp;&nbsp;&nbsp;&nbsp;
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                </table>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </td>
        </tr>
        <tr bgcolor="73beb6">
            <td height="1" align="left" valign="top">
            </td>
        </tr>
        <tr align="center" bgcolor="ccebed">
            <td valign="middle" class="bodycopy" style="height: 1px">
                &nbsp;</td>
        </tr>
    </table>
    <asp:ObjectDataSource ID="OdsRoutings" runat="server" SelectMethod="GetRateRoutings"
        DeleteMethod="DeleteRoute" DataObjectTypeName="ELT.CDT.RateRouting" TypeName="ELT.BL.RateManagementBL"
        InsertMethod="InsertRoute">
        <SelectParameters>
            <asp:Parameter Name="elt_account_number" Type="Int32" />
            <asp:Parameter Name="customer_org_num" Type="Int32" />
            <asp:Parameter Name="rate_type" Type="Int32" DefaultValue="-1" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:SqlDataSource ID="SQLDsClientProfile" runat="server"></asp:SqlDataSource>
    <asp:SqlDataSource ID="SqlCarrier" OnInit="SqlCarrier_Init" runat="server"></asp:SqlDataSource>
    <asp:SqlDataSource ID="SqlDsPort" runat="server" OnInit="SqlDsPort_Init"></asp:SqlDataSource>
   <%-- <asp:SqlDataSource ID="SqlDsAgentOrg" runat="server" OnInit="SqlDsAgentOrg_Init"></asp:SqlDataSource>--%>
    
    </form>
</body>
</html>

