<!--  #INCLUDE FILE="../include/transaction.txt" -->
<% 
    Option Explicit
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<!--  #INCLUDE FILE="../include/connection.asp" -->
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Edit List</title>
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />
    <script language="javascript" type="text/javascript" src="../ajaxFunctions/ajax.js"></script>
    <script language="javascript" type="text/javascript" src="../ajaxFunctions/otherFunctions.js"></script>

   
    <script type="text/javascript">
        function on_lst_SubConsignee_change() { }
        function on_lst_SubShipper_change() { }
        function on_lst_SubTrucker_change() { }
        function on_lst_SubCarrier_change() { }
        function on_lst_SubAgent_change() { }
        function on_lst_SubWarehousing_change() { }
        function on_lst_SubCFS_change() { }
        function on_lst_SubBroker_change() { }
        function on_lst_SubCustomer_change() { }
        function on_lst_SubGovt_change() { }
        function on_lst_SubVendor_change() { }
        function on_lst_SubSpecial_change() { }
    </script>
    <style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
a {
	font-size: 9px;
	font-weight: bold;
	color: #000000;
	text-decoration: none;
	font-family: Verdana;
}
a:hover {
	color: #b83423;
}
.style5 {color: #c16b42}
-->
    </style>
</head>
<!--  #INCLUDE FILE="../include/header.asp" -->
     <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
<!--  #INCLUDE FILE="client_profile_declaration.inc" -->
<%
Dim v_other_options,v_other_field,SQL_filter,v_chkEmpty
Dim PostBack,Action	
Dim i,Page,Page_c,First_Page,Block,PageCount,End_Page,id_num
DIM code_str, code_type,code_list,default,Ret
DIM aPageArray,aOtherField,aOtherFieldText,recordCount,totalCount,filter_string

	call get_queryString
	if PostBack = "" then PostBack = true
	if not PostBack then
		filter_string = set_default_filter_string()
%>
<script language='javascript'>
    if (window.parent.historyStorage) { window.parent.historyStorage.reset() };
</script>
<%
	end if
	call set_other_field()
%>
<%
function set_default_filter_string()
filter_string = Request.QueryString("filter")
if  isnull(filter_string) then
	filter_string = ""
end if

if filter_string = "" then
	DIM rs,SQL
	SQL = "select org_account_number from organization where elt_account_number="& elt_account_number & " and isFrequently='Y'"
	Set rs = eltConn.Execute(SQL)

	Do While Not rs.EOF
		filter_string = filter_string & rs(0) & ":"
		rs.MoveNext
	Loop
	rs.Close	
	set rs = nothing
end if
	set_default_filter_string = filter_string

end function
%>
<%
sub get_queryString
	default = Request.QueryString("default")
	Page_c = Request.QueryString("Page")
	PostBack = Request.QueryString("PostBack")
	filter_string = ""
end sub 
%>
<!--  #INCLUDE VIRTUAL="/ASP/master_data/client_profile_asp_functions.inc" -->
<!--  #INCLUDE VIRTUAL="/ASP/master_data/client_profile_set_page.inc" -->
<!--  #INCLUDE FILE="client_profile_page_tag.inc" -->
<body leftmargin="0" link="336699" marginheight="0" marginwidth="0" topmargin="0"
    vlink="336699">
    <!-- tooltip placeholder -->
    <div id="tooltipcontent">
    </div>
    <!-- placeholder ends -->
    <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td height="32" align="left" valign="middle" class="pageheader">
                CLIENT/PARTNER PROFILE
            </td>
        </tr>
    </table>
    <table width="95%" height="40" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td width="45%">
                &nbsp;
            </td>
            <td width="55%" align="right" valign="middle">
                &nbsp;
            </td>
        </tr>
    </table>
    <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#73beb6"
        class="border1px">
        <tr>
            <td align="right" valign="middle" bgcolor="#f3f3f3" class="bodycopy">
                <form action="/asp/include/all_dba_manage.asp" method="post" name="form1">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td height="24" align="center" valign="middle" bgcolor="#ccebed">
                            <table width="98%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td width="24%">
                                        &nbsp;
                                    </td>
                                    <td width="52%">
                                        &nbsp;
                                    </td>
                                    <td width="12%" align="right" valign="middle">
                                        <img src="/ASP/Images/button_new.gif" width="42" height="17" border="0" id="bNew"
                                            onclick="javascript:doBtn(this);" style="cursor: hand" alt="Create new profile">
                                    </td>
                                    <td width="12%">
                                        &nbsp;
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td height="1" colspan="6" bgcolor="#73beb6">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <input type="hidden" name="lblStatus" id="lblStatus">
                        </td>
                    </tr>
                    <tr>
                        <td height="40" align="right" valign="middle" class="bodycopy">
                            <table width="57%" height="24" border="0" align="center" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td width="19%" align="left" valign="bottom">
                                        &nbsp;
                                    </td>
                                    <td width="81%" height="20" align="right" valign="bottom">
                                        <span class="bodyheader">
                                            <input id="txt_lessOrGreaterTop" class="bodyheader" name="txt_lessOrGreaterTop" style="width: 100px;
                                                text-align: right; border-style: none; background-color: #f3f3f3" type="text"
                                                readonly="true" value="<%=recordCount&"/"&totalCount%>" />
                                            (Filtered / Total)</span>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table width="57%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#73beb6"
                                class="border1px" id="wPri">
                                <tr>
                                    <td width="1%" height="20" bgcolor="#ecf7f8">
                                        &nbsp;
                                    </td>
                                    <td width="49%" height="20" bgcolor="#ecf7f8" class="bodyheader style5">
                                        Search
                                    </td>
                                    <td width="41%" height="20" bgcolor="#ecf7f8">
                                        <span class="bodyheader">
                                            <input id="txt_status" class="bodycopy" name="txt_status" style="width: 70px; text-align: left;
                                                border-style: none; background-color: #ecf7f8" type="text" readonly="true" />
                                        </span>
                                    </td>
                                    <td width="9%" bgcolor="#ecf7f8">
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td height="1" colspan="4" bgcolor="#73beb6">
                                    </td>
                                </tr>
                                <tr>
                                    <td bgcolor="#f3f3f3">
                                        &nbsp;
                                    </td>
                                    <td height="20" bgcolor="#f3f3f3" class="bodyheader">
                                        Company
                                    </td>
                                    <td bgcolor="#f3f3f3" class="bodyheader">
                                        Class
                                    </td>
                                    <td bgcolor="#f3f3f3">
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td bgcolor="#FFFFFF">
                                        &nbsp;
                                    </td>
                                    <td height="24" bgcolor="#FFFFFF">
                                        <span class="bodyheader">
                                            <input id="txt_dba_name" class="shorttextfield" name="txt_dba_name" style="width: 250px;"
                                                value="<%= v_dba_name%>">
                                        </span>
                                    </td>
                                    <td bgcolor="#FFFFFF">
                                        <table border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                                            <tr>
                                                <td id='td_class_code'>
                                                    <input id="txt_class_code" class="shorttextfield" name="txt_class_code" style="width: 120px;"
                                                        type="text" value="<%= v_class_code%>" />
                                                </td>
                                                <td id='td_class_code_href'>
                                                    <a href="javascript:" class="list" onclick="javascript:actionRequestForAll('class_code','/ASP/ajaxFunctions/ajax_get_all_code.asp?t=class_code','120px');return false;">
                                                        [List]</a>
                                                    <% if mode_begin then %>
                                                    <div style="width: 21px; display: inline; vertical-align: text-bottom" onmouseover="showtip('Clicking on [List] will make this field a dropdown. Clicking on [Text] will allow you to enter text freely. ');"
                                                        onmouseout="hidetip()">
                                                        <img src="../Images/button_info.gif" align="absmiddle" class="bodylistheader"></div>
                                                    <% end if %>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td bgcolor="#FFFFFF">
                                        &nbsp;
                                    </td>
                                </tr>
                                <!--       
								<tr>
                        			<td height="2" colspan="4" bgcolor="#73beb6"></td>
                    			</tr>
								-->
                                <tr>
                                    <td height="20" bgcolor="#f3f3f3">
                                        &nbsp;
                                    </td>
                                    <td height="20" valign="middle" bgcolor="#f3f3f3" class="bodylistheader">
                                        Advanced Search &nbsp;<img id='bToggle' alt="Expand/Collapse" height="7" onclick="javascript:view_layer('wAdd',true);"
                                            src='/iff_main/Images/collapse.gif' style="cursor: hand" width="10">
                                        <% if mode_begin then %>
                                        <div style="width: 21px; display: inline; vertical-align: middle" onmouseover="showtip('Advanced Search will allow you to search by almost any field available in the Client Partner Profile.');"
                                            onmouseout="hidetip()">
                                            <img src="../Images/button_info.gif" align="absmiddle" class="bodylistheader"></div>
                                        <% end if %>
                                    </td>
                                    <td bgcolor="#f3f3f3">
                                        &nbsp;
                                    </td>
                                    <td bgcolor="#f3f3f3">
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" bgcolor="#FFFFFF">
                                        <!-- start of other options -->
                                        <div id="wAdd" style="<!--display: none; -->width: 100%; background: #FFFFFF">
                                            <table border="0" bordercolor="#ffffff" cellpadding="0" cellspacing="0" class="bodycopy"
                                                width="100%">
                                                <tr>
                                                    <td align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                                    </td>
                                                    <td height="8" colspan="5" align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td width="10" align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                                        &nbsp;
                                                    </td>
                                                    <td width="117" align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                                        <input id="chk_is_consignee" <% if v_is_consignee="y" then response.write("checked") %>=""
                                                            name="chk_is_consignee" onclick="javascript:cClick(this);" type="checkbox" value="Y" />
                                                        <label for="chk_is_consignee">
                                                            Consignee</label>
                                                    </td>
                                                    <td colspan="2" align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                                        <table border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                                                            <tr>
                                                                <td id='td_SubConsignee'>
                                                                    <input id="txt_SubConsignee" class="shorttextfield" name="txt_SubConsignee" style="width: 120px;"
                                                                        type="text" value="<%= v_SubConsignee%>" />
                                                                </td>
                                                                <!--
																<td></td>
																<td id='td_SubConsignee_href'><a href="javascript:" onClick="javascript:actionRequestForAll('SubConsignee','/ASP/ajaxFunctions/ajax_get_all_code.asp?t=SubConsignee','120px');return false;">[List]</a></td>
																-->
                                                            </tr>
                                                        </table>
                                                    </td>
                                                    <td width="115" align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                                        <input id="chk_is_shipper" <% if v_is_shipper="y" then response.write("checked") %>=""
                                                            name="chk_is_shipper" onclick="javascript:cClick(this);" type="checkbox" value="Y" />
                                                        <label for="chk_is_shipper">
                                                            Shipper</label>
                                                        &nbsp;&nbsp;&nbsp;&nbsp;
                                                    </td>
                                                    <td width="271" align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                                        <table border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                                                            <tr>
                                                                <td id='td_SubShipper'>
                                                                    <input id="txt_SubShipper" class="shorttextfield" name="txt_SubShipper" style="width: 120px;"
                                                                        type="text" value="<%= v_SubShipper%>" />
                                                                </td>
                                                                <!--
                                                                  <td></td>
                                                                  <td id='td_SubShipper_href'><a href="javascript:" onClick="javascript:actionRequestForAll('SubShipper','/ASP/ajaxFunctions/ajax_get_all_code.asp?t=SubShipper','120px');return false;">[List]</a></td>
																  -->
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                                    </td>
                                                    <td align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                                    </td>
                                                    <td width="89" align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                                    </td>
                                                    <td width="93" align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                                    </td>
                                                    <td align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                                    </td>
                                                    <td align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                                        &nbsp;
                                                    </td>
                                                    <td align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                                        <input id="chk_is_agent" <% if v_is_agent="y" then response.write("checked") %>=""
                                                            name="chk_is_agent" onclick="javascript:cClick(this);" type="checkbox" value="Y" />
                                                        <label for="chk_is_agent">
                                                            Agent</label>
                                                    </td>
                                                    <td colspan="2" align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                                        <table border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                                                            <tr>
                                                                <td id='td_SubAgent'>
                                                                    <input id="txt_SubAgent" class="shorttextfield" name="txt_SubAgent" style="width: 120px;"
                                                                        type="text" value="<%= v_SubAgent%>" />
                                                                </td>
                                                                <!--
																<td></td>
																<td id='td_SubAgent_href'><a href="javascript:" onClick="javascript:actionRequestForAll('SubAgent','/ASP/ajaxFunctions/ajax_get_all_code.asp?t=SubAgent','120px');return false;">[List]</a></td>
																-->
                                                            </tr>
                                                        </table>
                                                    </td>
                                                    <td align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                                        <input id="chk_is_carrier" <% if v_is_carrier="y" then response.write("checked") %>=""
                                                            name="chk_is_carrier" onclick="javascript:cClick(this);" type="checkbox" value="Y" />
                                                        <label for="chk_is_carrier">
                                                            Carrier</label>
                                                        &nbsp;&nbsp;
                                                    </td>
                                                    <td align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                                        <table border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                                                            <tr>
                                                                <td id='td_SubCarrier'>
                                                                    <input id="txt_SubCarrier" class="shorttextfield" name="txt_SubCarrier" style="width: 120px;"
                                                                        type="text" value="<%= v_SubCarrier%>" />
                                                                </td>
                                                                <!--
                                                                  <td></td>
                                                                  <td id='td_SubCarrier_href'><a href="javascript:" onClick="javascript:actionRequestForAll('SubCarrier','/ASP/ajaxFunctions/ajax_get_all_code.asp?t=SubCarrier','120px');return false;">[List]</a></td>
																  -->
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy" style="height: 20px">
                                                        &nbsp;
                                                    </td>
                                                    <td align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy" style="height: 20px">
                                                        <input id="chk_z_is_trucker" <% if v_z_is_trucker="y" then response.write("checked") %>=""
                                                            name="chk_z_is_trucker" onclick="javascript:cClick(this);" type="checkbox" value="Y" />
                                                        <label for="chk_z_is_trucker">
                                                            Trucker</label>
                                                    </td>
                                                    <td colspan="2" align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy" style="height: 20px">
                                                        <table border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                                                            <tr>
                                                                <td id='td_SubTrucker'>
                                                                    <input id="txt_SubTrucker" class="shorttextfield" name="txt_SubTrucker" style="width: 120px;"
                                                                        type="text" value="<%= v_SubTrucker%>" />
                                                                </td>
                                                                <!--
																<td></td>
																<td id='td_SubTrucker_href'><a href="javascript:" onClick="javascript:actionRequestForAll('SubTrucker','/ASP/ajaxFunctions/ajax_get_all_code.asp?t=SubTrucker','120px');return false;">[List]</a></td>
																-->
                                                            </tr>
                                                        </table>
                                                    </td>
                                                    <td align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                                        <input id="chk_z_is_warehousing" <% if v_z_is_warehousing="y" then response.write("checked") %>=""
                                                            name="chk_z_is_warehousing" onclick="javascript:cClick(this);" type="checkbox"
                                                            value="Y" />
                                                        <label for="chk_z_is_warehousing">
                                                            Warehouse</label>
                                                    </td>
                                                    <td align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                                        <table border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                                                            <tr>
                                                                <td id='td_SubWarehousing'>
                                                                    <input id="txt_SubWarehousing" class="shorttextfield" name="txt_SubWarehousing" style="width: 120px;"
                                                                        type="text" value="<%= v_SubWarehousing%>" />
                                                                </td>
                                                                <!--
                                                                  <td></td>
                                                                  <td id='td_SubWarehousing_href'><a href="javascript:" onClick="javascript:actionRequestForAll('SubWarehousing','/ASP/ajaxFunctions/ajax_get_all_code.asp?t=SubWarehousing','120px');return false;">[List]</a></td>
																  -->
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                                        &nbsp;
                                                    </td>
                                                    <td align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                                        <input id="chk_z_is_cfs" <% if v_z_is_cfs="y" then response.write("checked") %>=""
                                                            name="chk_z_is_cfs" onclick="javascript:cClick(this);" type="checkbox" value="Y" />
                                                        <label for="chk_z_is_cfs">
                                                            Terminal/CFS</label>
                                                    </td>
                                                    <td colspan="2" align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                                        <table border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                                                            <tr>
                                                                <td id='td_SubCFS'>
                                                                    <input id="txt_SubCFS" class="shorttextfield" name="txt_SubCFS" style="width: 120px;"
                                                                        type="text" value="<%= v_SubCFS%>" />
                                                                </td>
                                                                <!--
																<td></td>
																<td id='td_SubCFS_href'><a href="javascript:" onClick="javascript:actionRequestForAll('SubCFS','/ASP/ajaxFunctions/ajax_get_all_code.asp?t=SubCFS','120px');return false;">[List]</a></td>
																-->
                                                            </tr>
                                                        </table>
                                                    </td>
                                                    <td align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                                        <input id="chk_z_is_broker" <% if v_z_is_broker="y" then response.write("checked") %>=""
                                                            name="chk_z_is_broker" onclick="javascript:cClick(this);" type="checkbox" value="Y" />
                                                        <label for="chk_z_is_broker">
                                                            CHB</label>
                                                    </td>
                                                    <td align="left" valign="middle" bgcolor="#FFFFFF">
                                                        <table border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                                                            <tr>
                                                                <td id='td_SubBroker'>
                                                                    <input id="txt_SubBroker" class="shorttextfield" name="txt_SubBroker" style="width: 120px;"
                                                                        type="text" value="<%= v_SubBroker%>" />
                                                                </td>
                                                                <!--
                                                                  <td></td>
                                                                  <td id='td_SubBroker_href'><a href="javascript:" onClick="javascript:actionRequestForAll('SubBroker','/ASP/ajaxFunctions/ajax_get_all_code.asp?t=SubBroker','120px');return false;">[List]</a></td>
																  -->
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                                        &nbsp;
                                                    </td>
                                                    <td align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                                        <input id="chk_z_is_govt" <% if v_z_is_govt="y" then response.write("checked") %>=""
                                                            name="chk_z_is_govt" onclick="javascript:cClick(this);" type="checkbox" value="Y" />
                                                        <label for="chk_z_is_govt">
                                                            Gov't</label>
                                                    </td>
                                                    <td colspan="2" align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                                        <table border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                                                            <tr>
                                                                <td id='td_SubGovt'>
                                                                    <input id="txt_SubGovt" class="shorttextfield" name="txt_SubGovt" type="text" style="width: 120px;"
                                                                        value="<%= v_SubGovt%>" />
                                                                </td>
                                                                <!--
																<td></td>
																<td id='td_SubGovt_href'><a href="javascript:" onClick="javascript:actionRequestForAll('SubGovt','/ASP/ajaxFunctions/ajax_get_all_code.asp?t=SubGovt','120px');return false;">[List]</a></td>
																-->
                                                            </tr>
                                                        </table>
                                                    </td>
                                                    <td align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                                        <input id="chk_is_vendor" <% if v_is_vendor="y" then response.write("checked") %>=""
                                                            name="chk_is_vendor" onclick="javascript:cClick(this);" type="checkbox" value="Y" />
                                                        <label for="chkEmpty">
                                                            Vendor</label>
                                                    </td>
                                                    <td align="left" valign="middle" bgcolor="#FFFFFF">
                                                        <table border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                                                            <tr>
                                                                <td id='td_SubVendor'>
                                                                    <input id="txt_SubVendor" class="shorttextfield" name="txt_SubVendor" type="text"
                                                                        style="width: 120px;" value="<%= v_SubVendor%>" />
                                                                </td>
                                                                <!--
                                                                    <td></td>
                                                                    <td id='td_SubVendor_href'><a href="javascript:" onClick="javascript:actionRequestForAll('SubVendor','/ASP/ajaxFunctions/ajax_get_all_code.asp?t=SubVendor','120px');return false;">[List]</a></td>
																	-->
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                                        &nbsp;
                                                    </td>
                                                    <td align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                                        <input id="chk_z_is_special" <% if v_z_is_special="y" then response.write("checked") %>=""
                                                            name="chk_z_is_special" onclick="javascript:cClick(this);" type="checkbox" value="Y" />
                                                        <label for="chk_z_is_special">
                                                            Other</label>
                                                    </td>
                                                    <td colspan="2" align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                                        <table border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                                                            <tr>
                                                                <td id='td_SubSpecial'>
                                                                    <input id="txt_SubSpecial" class="shorttextfield" name="txt_SubSpecial" style="width: 120px;"
                                                                        type="text" value="<%= v_SubSpecial%>" />
                                                                </td>
                                                                <!--
																<td></td>
																<td id='td_SubSpecial_href'><a href="javascript:" onClick="javascript:actionRequestForAll('SubSpecial','/ASP/ajaxFunctions/ajax_get_all_code.asp?t=SubSpecial','120px'); return false;">[List]</a></td>
																-->
                                                            </tr>
                                                        </table>
                                                    </td>
                                                    <td align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                                        <input id="chk_is_customer" <% if v_is_customer="y" then response.write("checked") %>=""
                                                            name="chk_is_customer" onclick="javascript:cClick(this);" type="checkbox" value="Y" />
                                                        <label for="chkEmpty">
                                                            Customer</label>
                                                    </td>
                                                    <td align="left" valign="middle" bgcolor="#FFFFFF">
                                                        <table border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                                                            <tr>
                                                                <td id='td_SubCustomer'>
                                                                    <input id="txt_SubCustomer" class="shorttextfield" name="txt_SubCustomer" type="text"
                                                                        style="width: 120px;" value="<%= v_SubCustomer%>" />
                                                                </td>
                                                                <!--
                                                                    <td></td>
                                                                    <td id='td_SubCustomer_href'><a href="javascript:" onClick="javascript:actionRequestForAll('SubCustomer','/ASP/ajaxFunctions/ajax_get_all_code.asp?t=SubCustomer','120px');return false;">[List]</a></td>
																	-->
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                                    </td>
                                                    <td height="8" colspan="5" align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="left" valign="middle" bgcolor="#F3F3F3" class="bodycopy">
                                                        &nbsp;
                                                    </td>
                                                    <td height="20" align="left" valign="middle" bgcolor="#F3F3F3" class="bodyheader">
                                                        City
                                                    </td>
                                                    <td align="left" valign="middle" bgcolor="#F3F3F3" class="bodycopy">
                                                        &nbsp;
                                                    </td>
                                                    <td colspan="2" align="left" valign="middle" bgcolor="#F3F3F3" class="bodyheader">
                                                        State/Province
                                                    </td>
                                                    <td align="left" valign="middle" bgcolor="#F3F3F3" class="bodycopy">
                                                        <span class="bodyheader">Zip</span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                    </td>
                                                    <td colspan="2" align="left" valign="middle" class="bodycopy" style="height: 20px">
                                                        <table border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                                                            <tr>
                                                                <td id='td_business_city'>
                                                                    <input id="txt_business_city" class="shorttextfield" name="txt_business_city" style="width: 120px;"
                                                                        type="text" value="<%= v_business_city%>" />
                                                                </td>
                                                                <td id='td_business_city_href'>
                                                                    <a href="javascript:" class="list" onclick="javascript:actionRequestForAll('business_city','/ASP/ajaxFunctions/ajax_get_all_code.asp?t=business_city','120px');return false;">
                                                                        [List]</a>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                    <td colspan="2" align="left" valign="middle" class="bodycopy">
                                                        <table border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                                                            <td>
                                                            </td>
                                                            <tr>
                                                                <td id='td_business_state'>
                                                                    <input id="txt_business_state" class="shorttextfield" name="txt_business_state" style="width: 100px;"
                                                                        type="text" value="<%= v_business_state%>" />
                                                                </td>
                                                                <td id='td_business_state_href'>
                                                                    <a href="javascript:" class="list" onclick="javascript:actionRequestForAll('business_state','/ASP/ajaxFunctions/ajax_get_all_code.asp?t=business_state','120px');return false;">
                                                                        [List]</a>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                    <td>
                                                        <table border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                                                            <tr>
                                                                <td id='td_business_zip'>
                                                                    <input id="txt_business_zip" class="shorttextfield" name="txt_business_zip" style="width: 100px;"
                                                                        type="text" value="<%= v_business_zip%>" />
                                                                </td>
                                                                <td id='td_business_zip_href'>
                                                                    <a href="javascript:" class="list" onclick="javascript:actionRequestForAll('business_zip','/ASP/ajaxFunctions/ajax_get_all_code.asp?t=business_zip','100px');return false;">
                                                                        [List]</a>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="left" valign="middle" bgcolor="#F3F3F3" class="bodycopy">
                                                        &nbsp;
                                                    </td>
                                                    <td height="20" align="left" valign="middle" bgcolor="#F3F3F3" class="bodyheader">
                                                        Country
                                                    </td>
                                                    <td align="left" valign="middle" bgcolor="#F3F3F3" class="bodycopy">
                                                        &nbsp;
                                                    </td>
                                                    <td colspan="2" align="left" valign="middle" bgcolor="#F3F3F3" class="bodyheader">
                                                        &nbsp;
                                                    </td>
                                                    <td align="left" valign="middle" bgcolor="#F3F3F3" class="bodycopy">
                                                        &nbsp;
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                    </td>
                                                    <td colspan="2" align="left" valign="middle" class="bodycopy" style="height: 20px">
                                                        <table border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                                                            <tr>
                                                                <td id='td_business_country'>
                                                                    <input id="txt_business_country" class="shorttextfield" name="txt_business_country"
                                                                        style="width: 120px;" type="text" value="<%= v_b_country_codeName %>" />
                                                                </td>
                                                                <td id='td_business_country_href'>
                                                                    <a href="javascript:" class="list" onclick="javascript:actionRequestForAll('business_country','/ASP/ajaxFunctions/ajax_get_country_code.asp','120px');return false;">
                                                                        [List]</a>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                    <td colspan="3" align="left" valign="middle" class="bodycopy" style="height: 20px;
                                                        width: 200px">
                                                        &nbsp;
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="left" valign="middle" bgcolor="#f3f3f3" class="bodycopy">
                                                        &nbsp;
                                                    </td>
                                                    <td height="20" align="left" valign="middle" bgcolor="#f3f3f3" class="bodyheader">
                                                        More Options
                                                    </td>
                                                    <td align="left" valign="middle" bgcolor="#f3f3f3" class="bodycopy">
                                                        &nbsp;
                                                    </td>
                                                    <td align="left" valign="middle" bgcolor="#f3f3f3" class="bodycopy">
                                                        &nbsp;
                                                    </td>
                                                    <td align="left" valign="middle" bgcolor="#f3f3f3" class="bodycopy">
                                                        &nbsp;
                                                    </td>
                                                    <td align="left" valign="middle" bgcolor="#f3f3f3" class="bodycopy">
                                                        &nbsp;
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                    </td>
                                                    <td colspan="4" align="left" valign="middle" class="bodycopy">
                                                        <select class="smallselect" name="lst_other_options" id="lst_other_options" onchange="javascript:lst_other_options_change(this)"
                                                            size="1" style="width: 200px">
                                                            <option value=""></option>
                                                            <% for i=0 To aOtherField.count-1 %>
                                                            <option <% 
																			if aOtherField(i) = v_other_field then 
																					response.write "selected " 
																			end if	
																%> value="<%=aOtherField(i)%>">
                                                                <%= aOtherFieldText(i) %></option>
                                                            <% next %>
                                                        </select><% if mode_begin then %>
                                                        <div style="width: 21px; display: inline; vertical-align: text-bottom" onmouseover="showtip('This area allows searches by many miscellaneous fields. Choose one catagory and then enter the criteria you wish to match below it.');"
                                                            onmouseout="hidetip()">
                                                            <img src="../Images/button_info.gif" align="absmiddle" class="bodylistheader"></div>
                                                        <% end if %>
                                                        </span>
                                                    </td>
                                                    <td align="left" class="bodycopy" style="height: 20px" valign="middle">
                                                        <span class="bodycopy" style="height: 20px">
                                                            <input type="hidden" name="filter_string" id="filter_string" value="<%=filter_string%>">
                                                        </span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                    </td>
                                                    <td colspan="5" align="left" class="bodycopy">
                                                        <input id="txt_other_options" class="shorttextfield" name="txt_other_options" style="width: 200px"
                                                            type="text" value="<%= v_other_options%>" />
                                                        <input id="chkEmpty" name="chkEmpty" type="checkbox" style="cursor: hand" onclick="javascript:clickEmpty(this)"
                                                            <% if v_chkEmpty="Y" Then response.write("checked") %> />
                                                        <label for="chkEmpty">
                                                            Clear this field</label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                    </td>
                                                    <td height="36" colspan="5" align="left" valign="bottom" class="bodycopy">
                                                        <span class="bodyheader"><a href="javascript:;" onclick="javascript:document.form1.reset();return false;"
                                                            style="cursor: pointer">
                                                            <img src="/ASP/Images/button_reset_options.gif" width="88" height="18" id="bReset"
                                                                alt="Reset all search options"></a></span>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                        <!-- end of other options -->
                                    </td>
                                </tr>
                                <tr>
                                    <td bgcolor="#FFFFFF">
                                        &nbsp;
                                    </td>
                                    <td height="28" bgcolor="#FFFFFF">
                                        &nbsp;
                                    </td>
                                    <td align="center" valign="middle" bgcolor="#FFFFFF">
                                        &nbsp;
                                    </td>
                                    <td align="left" valign="top" bgcolor="#FFFFFF">
                                        <a id="bGo" href="javascript:;" style="cursor: pointer" onclick="javascript:doBtn(this);">
                                            <img src="../images/icon_search.gif" name="bGo" width="33" height="27" align="absmiddle"></a>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            &nbsp;
                        </td>
                    </tr>
                </table>
                </form>
            </td>
        </tr>
        <tr>
            <td align="left" valign="middle" class="bodycopy">
                <form name="form2">
                <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                        <td>
                            <!-- start of result panel -->
                            <div id="ResultDiv" align="center" style="display: block">
                                <table width="100%" border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                                    <tr align="left" bgcolor="#f3f3f3" valign="middle">
                                        <td width="38%" class="bodyheader">
                                        </td>
                                    </tr>
                                    <tr align="left" bgcolor="#f3f3f3" valign="top">
                                        <td height="24" align="left" valign="middle" bgcolor="#f3f3f3">
                                            <table width="99%" border="0" align="center" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td width="10%" class="bodyheader">
                                                        <a href="javascript:; " onclick="javascript:doBtn(this);" style="cursor: pointer"
                                                            id="bSelAll">
                                                            <img src="/ASP/Images/button_selectall.gif" width="61" height="17" alt="Select all companies"></a>
                                                    </td>
                                                    <td width="10%" class="bodyheader">
                                                        <a href="javascript:;" onclick="javascript:doBtn(this);" style="cursor: hand" id="bUselAll">
                                                            <img src="../Images/button_clear.gif" width="56" height="17" alt="Clear all selected companies"></a>
                                                    </td>
                                                    <td width="14%">
                                                        <a href="javascript:;" onclick="javascript:doBtn(this);" style="cursor: pointer"
                                                            id="bMODIFY">
                                                            <img src="/ASP/Images/button_edit_bold_selected.gif" width="86" height="18" alt="Edit selected companies"></a>
                                                    </td>
                                                    <td width="66%" align="right" id="td_page_break">
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr align="left" bgcolor="#f3f3f3" valign="middle">
                                        <td height="1" align="left" bgcolor="#73beb6">
                                        </td>
                                    </tr>
                                    <tr align="left" bgcolor="#f3f3f3" valign="top">
                                        <td height="22" align="center" valign="middle" bgcolor="#ecf7f8" id="td_result">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td height="1" colspan="10" bgcolor="#73beb6">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td height="24" bgcolor="#ccebed">
                                            &nbsp;
                                        </td>
                                    </tr>
                                </table>
                            </div>
                            <!-- end of result panel -->
                        </td>
                    </tr>
                </table>
                <input type="hidden" name="selItems" id="selItems">
                </form>
            </td>
        </tr>
    </table>
    <script language="javascript" type="text/javascript" src="/asp/include/client_profile_f_shared.js"></script>
    <script language="javascript">

        function showResponseFindResult(req, field, tmpVal, tWidth, tMaxLength, url, post_parameter) {
            if (req.readyState == 4) {
                if (req.status == 200) {
                    //			alert(req.responseText);
                    create_innerHTML_for_result(req.responseText);
                    document.getElementById('txt_status').value = '';
                    if (req.responseText.indexOf('No data was found.') < 0) {
                        put_history(url, post_parameter);
                    }
                } else {
                    alert(req.responseText);
                }
            }
        }
        function submit_page(url, actType) {
            var td = document.getElementById('td_result');
            var msgBox = document.getElementById('txt_status');
            msgBox.value = 'Loading...';
            var post_parameter = get_post_parameters(document.form1, actType);
            new ajax.xhr.Request('POST', post_parameter, url, showResponseFindResult, '', '', '');
        }
        function goPage(p) {
            document.getElementById('selItems').value = '';
            submit_page("/ASP/ajaxFunctions/ajax_get_dba_result_html.asp?PostBack=true&Action=Page&Page="
							+ encodeURIComponent(p)
							+ "&WindowName="
							+ window.name, "");
        }
        function doBtn(o) {

            try {
                switch (o.id) {
                    case 'bGo':
                        document.getElementById('selItems').value = '';
                        document.getElementById('filter_string').value = '';
                        submit_page("/ASP/ajaxFunctions/ajax_get_dba_result_html.asp?PostBack=true&Action=Search&WindowName="
							 + window.name, '');
                        break;
                    case 'bOK':
                        break;
                    case 'bNew':
                        goProfile(null);
                        break;
                    case 'bMODIFY':
                        var retVal = document.getElementById('selItems').value;
                        if (retVal == '') {
                            alert('Please select at least one item.');
                            break;
                        }
                        retVal = convert_org_str(retVal);
                        var cnt = retVal.split(':').length - 1;
                        if (cnt > 100) {
                            if (!confirm('You selected ' + cnt + ' items to modify profile.\n Do you want to continue ?')) {
                                break;
                            }
                        }
                        goProfile(retVal + ':');
                        break;
                    case 'bSelAll':
                        sel_all_table(true);
                        break;
                    case 'bUselAll':
                        sel_all_table(false);
                        break;
                    default:
                        break;
                }
            } catch (ex) { }

        }
        function convert_org_str(retVal) {
            while (retVal.indexOf("^") != -1) { retVal = retVal.replace('^', ':'); }
            if (retVal.substr(0, 1) == ':') {
                retVal = retVal.substr(1);
            }
            return retVal;
        }

        function sel_all_table(how) {

            var itemL = document.all.chk.length;

            var selStr = '';
            if (itemL) {
                for (i = 0; i < itemL; i++) {

                    set_table_chk_box(how, eval("document.form2.img" + $(document.all.chk[i]).attr("seq")));
                    if (how) { selStr += $(document.all.chk[i]).attr("seq")+ '^'; }
                }
            } else {
                set_table_chk_box(how, eval("document.form2.img" + document.all.chk.seq));
                if (how) { selStr += document.all.chk.seq + '^'; }
            }

            document.getElementById('selItems').value = selStr;
        }

        function set_table_chk_box(how, obj) {
            if (how) {
                obj.checkeditem = "Y";
                obj.src = "../images/checkbox_o.gif";
                eval("document.form2.chk" + obj.id + ".value='on'");

            } else {
                obj.checkeditem = "N";
                obj.src = "../images/checkbox_n.gif";
                eval("document.form2.chk" + obj.id + ".value='off'");
            }
        }

        function DoChecking(seq) {
            eval("document.form2.img" + seq + ".click()");
        }
        function ItemWasChecked(obj) {
            if (obj.checkeditem == "N") {
                obj.checkeditem = "Y";
                obj.src = "../images/checkbox_o.gif";
                eval("document.form2.chk" + obj.id + ".value='on'");
                document.getElementById('selItems').value = document.getElementById('selItems').value + '^' + obj.id.substr(3);
            } else {
                obj.checkeditem = "N";
                obj.src = "../images/checkbox_n.gif";
                eval("document.form2.chk" + obj.id + ".value='off'");
                var str = document.getElementById('selItems').value;
                document.getElementById('selItems').value = str.replace(obj.id.substr(3), '');
                document.getElementById('selItems').value = document.getElementById('selItems').value.replace('^^', '');
            }
        }
        function goProfile(n) {

            if (n) {
                if (n.indexOf(':') < 0) { n += ':'; }
                var url = 'client_profile.asp?Action=filter' + '&n=' + n;
                
                window.location = url;
            } else {
                var url = 'client_profile.asp';
                window.location = url;
            }
        }

        // start of history
        var objectHistory = null;
        if (window.parent.dhtmlHistory != null && typeof (window.parent.dhtmlHistory) != 'undefined') {
            objectHistory = window.parent;
        }
        else {
            document.write("<scr" + "ipt type=text/javascript src='../ajaxFunctions/lib/dhtmlHistory.js'><\/scr" + "ipt>");
            objectHistory = window;
        }
        window.onload = initialize;

        function initialize() {
            objectHistory.dhtmlHistory.initialize();
            objectHistory.dhtmlHistory.addListener(historyfunc);
            if (objectHistory.dhtmlHistory.isFirstLoad()) {
                var url = "/ASP/ajaxFunctions/ajax_get_dba_result_html.asp?PostBack=true&Action=Search&isFirst=y";
                var post_parameter = 'isFrequently=Y';
                go_search(url, post_parameter);
            }
        }

        function historyfunc(HistoryName, HistoryValue) {
            if (HistoryValue == null) return;
            var storage_data = objectHistory.historyStorage.get(HistoryValue);
            // key
            if (storage_data != null) {
                var url = storage_data.split(':')[0] + '&sel=' + document.getElementById('selItems').value;
                var post_parameter = storage_data.split(':')[1];
                go_search(url, post_parameter);
            }
            //
        }

        function $() {
            var element = arguments[0];
            var elength = document.getElementsByName(element).length;
            return (elength > 1)
			? document.getElementsByName(element)
			: document.getElementById(element);
        }

        var his_id = '';

        function put_history(url, post_parameter) {
            var historyID = 'HIS_ID:' + his_id;
            var historyDATAID = 'HIS_DATA_ID_' + his_id;
            objectHistory.dhtmlHistory.add(historyID, historyDATAID);
            objectHistory.historyStorage.put(historyDATAID, url + ":" + post_parameter);
        }
        // end of history

        function go_search(url, post_parameter) {
            var msgBox = document.getElementById('txt_status');
            msgBox.value = 'loading...';
            new ajax.xhr.Request('POST', post_parameter, url, showResponseFindResult, '', '', '');
        }

        function result_sort(oTd) {

            var storage_data = objectHistory.historyStorage.get('HIS_DATA_ID_');
            if (storage_data != null) {
                var sortVal = '';
                if (oTd.value == '') {
                    sortVal = '&sortA=' + oTd.id;
                }
                else {
                    if (oTd.value == 'A') {
                        sortVal = '&sortD=' + oTd.id;
                    } else {
                        sortVal = '&sortA=' + oTd.id;
                    }
                }
                var tmpurl = storage_data.split(':')[0];
                var sIndex = tmpurl.indexOf('&sortA=');
                if (sIndex > 0) {
                    tmpurl = tmpurl.substring(0, sIndex);
                }
                sIndex = tmpurl.indexOf('&sortD=');
                if (sIndex > 0) {
                    tmpurl = tmpurl.substring(0, sIndex);
                }

                var url = tmpurl + sortVal;
                var post_parameter = storage_data.split(':')[1];
                go_search(url, post_parameter);
            }
        }
    </script>
    <script language="javascript">
        function view_layer(name, t) {
            var obj = document.all[name];
            if (!obj) return;
            var mObj = document.all['wPri'];
            var bObj = document.all['bToggle'];
            //var bObj2=document.all['bToggle2'];
            var sObj = document.getElementById('lblStatus');
            var eObj = document.getElementById('ResultDiv');

            var _tmpx, _tmpy, marginx, marginy;

            _tmpx = parseInt(mObj.offsetLeft);
            _tmpy = parseInt(mObj.offsetTop) + parseInt(mObj.offsetHeight);

            obj.style.posLeft = _tmpx;
            obj.style.posTop = _tmpy - 1;

            wstatus = obj.style.display;

            if (t) {
                if (wstatus == 'block') {
                    wstatus = 'none';
                    bObj.src = '/iff_main/Images/collapse.gif';
                } else {
                    wstatus = 'block';
                    bObj.src = '/iff_main/Images/expand.gif';
                }
            }
            else {
                obj.style.display = 'block';
            }

            obj.style.display = wstatus;
            sObj.value = wstatus;

            if (sObj.value != obj.style.display) {
                view_layer('wAdd', true);
            }
            eObj.style.posLeft = obj.style.posLeft;
            eObj.style.posTop = _tmpy + parseInt(obj.offsetHeight) + 1;
            //bObj2.src = bObj.src;

        }
       
    </script>
    <!-- //for Tooltip// -->
    <script language="JavaScript" type="text/javascript" src="../include/tooltips.js"></script>
              <script src="/Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
    <!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
