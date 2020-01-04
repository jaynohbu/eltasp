<!--  #INCLUDE FILE="transaction.txt" -->
<% 
    Option Explicit
    Session.CodePage = "65001"
    Response.CharSet = "UTF-8"
    
%>
<!--  #INCLUDE FILE="connection.asp" -->
<html>
<head>
    <title>Edit List</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css">
    <script type="text/jscript">
		window.name = 'AllDba';
		function closeReturn(s) 
		{
			window.returnValue = s;
			window.close();
		}		
		
    </script>
	<script language="javascript" type="text/javascript" src="../ajaxFunctions/ajax.js"></script>
	<script language="javascript" type="text/javascript" src="../ajaxFunctions/otherFunctions.js"></script>
<%  
Response.Expires = 0  
Response.AddHeader "Pragma","no-cache"  
Response.AddHeader "Cache-Control","no-cache,must-revalidate"  
%>		
</head>
<!--  #INCLUDE FILE="../master_data/client_profile_declaration.inc" -->

<%
Dim v_other_options,v_other_field,SQL_filter,v_chkEmpty
Dim PostBack,Action	
Dim i,Page,Page_c,First_Page,Block,PageCount,End_Page,id_num
DIM code_str, code_type,elt_account_number,login_name,UserRight,code_list,default,Ret
DIM aPageArray,aOtherField,aOtherFieldText,recordCount,totalCount,filter_string

	call get_queryString
	if PostBack = "" then PostBack = true
	if not PostBack then
		filter_string = Request.QueryString("filter")
		get_dba_list(default)
	end if
	call set_other_field()
%>

<%
sub get_queryString
	elt_account_number = Request.Cookies("CurrentUserInfo")("elt_account_number")
	login_name = Request.Cookies("CurrentUserInfo")("login_name")
	UserRight = Request.Cookies("CurrentUserInfo")("user_right")	
	default = Request.QueryString("default")
	Page_c = Request.QueryString("Page")
	PostBack = Request.QueryString("PostBack")
	filter_string = ""
end sub 
%>
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/master_data/client_profile_asp_functions.inc" -->
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/master_data/client_profile_set_page.inc" -->
<!--  #INCLUDE FILE="client_profile_page_tag.inc" -->

<body leftmargin="0" link="336699" marginheight="0" marginwidth="0" topmargin="0"
    vlink="336699">
    <form action="all_dba_manage.asp" method="post" name="form1">
        <table align="center" border="0" bordercolor="#73beb6" cellpadding="3" cellspacing="0"
            class="border1px" width="100%">
            <tr bgcolor="D5E8CB">
              <td align="left" bgcolor="#f3f3f3" class="bodyheader" valign="top" colspan="2"></td>
            </tr>
            <tr bgcolor="D5E8CB">
              <td align="left" bgcolor="#f3f3f3" class="bodyheader" valign="middle" colspan="2"><table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr>
					  <td class="font" align="center"></td>
			    </tr>
					<tr>
					  <td class="font" align="left"> </td>
					</tr>
					
					<tr>
					  <td class="font" align="left"></td>
			    </tr>
					<tr>
					  <td class="font" align="left"><table border="0" bordercolor="#ffffff" cellpadding="0" cellspacing="0" class="border1px" width="585">
                                                            <tr>
                                                              <td align="left"class="bodycopy" valign="middle">&nbsp;</td>
                                                              <td align="left" valign="middle" class="bodyheader">&nbsp;</td>
                                                              <td align="left" valign="middle" class="bodyheader">&nbsp;</td>
                                                              <td align="right" valign="middle" class="bodyheader"></td>
                                                            </tr>
                                                            <tr>
                                                              <td align="left"class="bodycopy" valign="middle">DBA Name like </td>
                                                              <td align="left" valign="middle" class="bodyheader"><input id="txt_dba_name" class="shorttextfield" name="txt_dba_name" style="width: 250px;"
                                                                            value="<%= v_dba_name%>"></td>
                                                              <td align="left" valign="middle" class="bodyheader">&nbsp;</td>
                                                              <td align="right" valign="middle" class="bodyheader">&nbsp;</td>
                                                            </tr>
                                                            <tr>
                                                                <td align="left" width="120"class="bodycopy" valign="middle">&nbsp;                                                              </td>
                                                                <td width="200" align="left" valign="middle" class="bodyheader">
                                                                    Main Category</td>
                                                                <td width="63" align="left" valign="middle" class="bodyheader">&nbsp;</td>
                                                                <td width="200" align="left" valign="middle" class="bodyheader">&nbsp;</td>
                                                            </tr>
                                                            <tr>
                                                              <td align="left" class="bodycopy" valign="middle">&nbsp;</td>
                                                              <td align="left" class="bodycopy" valign="middle"><table border="0" cellpadding="0" cellspacing="0" class="bodycopy"><tr><td id='td_class_code'><input id="txt_class_code" class="shorttextfield" name="txt_class_code" style="width: 150px;" type="text" value="<%= v_class_code%>" /></td><td></td><td id='td_class_code_href'>
<a href="#" onClick="javascript:actionRequestForAll('class_code','/IFF_MAIN/asp/ajaxFunctions/ajax_get_all_code.asp?t=class_code','150px');">[List]</a></td></tr></table></td>
                                                              <td align="left" class="bodycopy" valign="middle">&nbsp;</td>
                                                              <td align="left" class="bodycopy" valign="middle">&nbsp;</td>
                                                            </tr>
                                                            <tr>
                                                              <td align="left" class="bodycopy" valign="middle">&nbsp;</td>
                                                              <td width="200" align="left" valign="middle" class="bodyheader">
                                                                    &nbsp;Sub Category</td>
                                                              <td align="left" valign="middle" class="bodyheader">&nbsp;</td>
                                                              <td width="200" align="left" valign="middle" class="bodyheader">Address</td>
                                                            </tr>
                                                            <tr>
                                                                <td height="22" align="left" valign="middle" class="bodycopy">
                                                              <input id="chk_is_consignee" <% if v_is_consignee="Y" then response.write("checked") %>=""
                                                                        name="chk_is_consignee" onClick="javascript:cClick(this);" type="checkbox" value="Y"/><label for="chk_is_consignee">Consignee</label></td>
                                                                <td align="left" class="bodycopy" valign="middle"><table border="0" cellpadding="0" cellspacing="0" class="bodycopy"><tr><td id='td_SubConsignee'><input id="txt_SubConsignee" class="shorttextfield" name="txt_SubConsignee" style="width: 150px;" type="text" value="<%= v_SubConsignee%>" /></td><td></td><td id='td_SubConsignee_href'><a href="#" onClick="javascript:actionRequestForAll('SubConsignee','/IFF_MAIN/asp/ajaxFunctions/ajax_get_all_code.asp?t=SubConsignee','150px');">[List]</a></td></tr></table></td>
                                                                <td align="right" class="bodyheader" valign="middle">City&nbsp;&nbsp;</td>
                                                                <td align="left" class="bodycopy" valign="middle"><table border="0" cellpadding="0" cellspacing="0" class="bodycopy"><tr><td id='td_business_city'><input id="txt_business_city" class="shorttextfield" name="txt_business_city" style="width: 150px;" type="text" value="<%= v_business_city%>" /></td><td></td><td id='td_business_city_href'><a href="#" onClick="javascript:actionRequestForAll('business_city','/IFF_MAIN/asp/ajaxFunctions/ajax_get_all_code.asp?t=business_city','150px');">[List]</a></td></tr></table></td>
                                                            </tr>
                                                            <tr>
                                                                <td align="left" class="bodycopy" valign="middle">                                                                </td>
                                                                <td align="left" class="bodycopy" valign="middle">                                                                </td>
                                                                <td align="left" class="bodycopy" valign="middle"></td>
                                                                <td align="left" class="bodycopy" valign="middle"></td>
                                                            </tr>
                                                            <tr>
                                                                <td align="left" class="bodycopy" valign="middle">
                                                                    <input id="chk_is_shipper" <% if v_is_shipper="Y" then response.write("checked") %>=""
                                                                        name="chk_is_shipper" onClick="javascript:cClick(this);" type="checkbox" value="Y"/><label for="chk_is_shipper">Shipper</label></td>
                                                                <td align="left" class="bodycopy" valign="middle"><table border="0" cellpadding="0" cellspacing="0" class="bodycopy"><tr><td id='td_SubShipper'><input id="txt_SubShipper" class="shorttextfield" name="txt_SubShipper" style="width: 150px;" type="text" value="<%= v_SubShipper%>" /></td><td></td><td id='td_SubShipper_href'><a href="#" onClick="javascript:actionRequestForAll('SubShipper','/IFF_MAIN/asp/ajaxFunctions/ajax_get_all_code.asp?t=SubShipper','150px');">[List]</a></td></tr></table></td>
                                                                <td align="right" class="bodyheader" valign="middle">State&nbsp;&nbsp;</td>
                                                                <td align="left" class="bodycopy" valign="middle"><table border="0" cellpadding="0" cellspacing="0" class="bodycopy"><tr><td id='td_business_state'><input id="txt_business_state" class="shorttextfield" name="txt_business_state" style="width: 150px;" type="text" value="<%= v_business_state%>" /></td><td></td><td id='td_business_state_href'><a href="#" onClick="javascript:actionRequestForAll('business_state','/IFF_MAIN/asp/ajaxFunctions/ajax_get_all_code.asp?t=business_state','150px');">[List]</a></td></tr></table></td>
                                                            </tr>
                                                            <tr>
                                                                <td align="left" class="bodycopy" valign="middle">
                                                                    <input id="chk_is_agent" <% if v_is_agent="Y" then response.write("checked") %>="" name="chk_is_agent"
                                                                        onclick="javascript:cClick(this);" type="checkbox" value="Y"/><label for="chk_is_agent">Agent</label></td>
                                                                <td align="left" class="bodycopy" valign="middle"><table border="0" cellpadding="0" cellspacing="0" class="bodycopy"><tr><td id='td_SubAgent'><input id="txt_SubAgent" class="shorttextfield" name="txt_SubAgent" style="width: 150px;" type="text" value="<%= v_SubAgent%>" /></td><td></td><td id='td_SubAgent_href'><a href="#" onClick="javascript:actionRequestForAll('SubAgent','/IFF_MAIN/asp/ajaxFunctions/ajax_get_all_code.asp?t=SubAgent','150px');">[List]</a></td></tr></table></td>
                                                                <td align="right" class="bodyheader" valign="middle">Zip&nbsp;&nbsp;</td>
                                                                <td align="left" class="bodycopy" valign="middle"><table border="0" cellpadding="0" cellspacing="0" class="bodycopy"><tr><td id='td_business_zip'><input id="txt_business_zip" class="shorttextfield" name="txt_business_zip" style="width: 150px;" type="text" value="<%= v_business_zip%>" /></td><td></td><td id='td_business_zip_href'><a href="#" onClick="javascript:actionRequestForAll('business_zip','/IFF_MAIN/asp/ajaxFunctions/ajax_get_all_code.asp?t=business_zip','150px');">[List]</a></td></tr></table></td>
                                                            </tr>
                                                            <tr>
                                                                <td align="left" class="bodycopy" style="height: 20px" valign="middle">
                                                                    <input id="chk_is_carrier" <% if v_is_carrier="Y" then response.write("checked") %>=""
                                                                        name="chk_is_carrier" onClick="javascript:cClick(this);" type="checkbox" value="Y"/><label for="chk_is_carrier">Carrier</label></td>
                                                                <td align="left" class="bodycopy" style="height: 20px" valign="middle"><table border="0" cellpadding="0" cellspacing="0" class="bodycopy"><tr><td id='td_SubCarrier'><input id="txt_SubCarrier" class="shorttextfield" name="txt_SubCarrier" style="width: 150px;" type="text" value="<%= v_SubCarrier%>" /></td><td></td><td id='td_SubCarrier_href'><a href="#" onClick="javascript:actionRequestForAll('SubCarrier','/IFF_MAIN/asp/ajaxFunctions/ajax_get_all_code.asp?t=SubCarrier','150px');">[List]</a></td></tr></table></td>
                                                                <td align="right" class="bodyheader" style="height: 20px" valign="middle">Country&nbsp;&nbsp;</td>
                                                                <td align="left" class="bodycopy" style="height: 20px" valign="middle"><table border="0" cellpadding="0" cellspacing="0" class="bodycopy"><tr><td id='td_business_country'><input id="txt_business_country" class="shorttextfield" name="txt_business_country" style="width: 150px;" type="text" value="<%= v_b_country_codeName %>" /></td><td></td><td id='td_business_country_href'><a href="#" onClick="javascript:actionRequestForAll('business_country','/IFF_MAIN/asp/ajaxFunctions/ajax_get_country_code.asp','150px');">[List]</a></td></tr></table></td>
                                                            </tr>
                                                            <tr>
                                                                <td align="left" class="bodycopy" style="height: 20px" valign="middle">
                                                                    <input id="chk_z_is_trucker" <% if v_z_is_trucker="Y" then response.write("checked") %>=""
                                                                        name="chk_z_is_trucker" onClick="javascript:cClick(this);" type="checkbox" value="Y"/><label for="chk_z_is_trucker">Trucker</label></td>
                                                                <td align="left" class="bodycopy" style="height: 20px" valign="middle"><table border="0" cellpadding="0" cellspacing="0" class="bodycopy"><tr><td id='td_SubTrucker'><input id="txt_SubTrucker" class="shorttextfield" name="txt_SubTrucker" style="width: 150px;" type="text" value="<%= v_SubTrucker%>" /></td><td></td><td id='td_SubTrucker_href'><a href="#" onClick="javascript:actionRequestForAll('SubTrucker','/IFF_MAIN/asp/ajaxFunctions/ajax_get_all_code.asp?t=SubTrucker','150px');">[List]</a></td></tr></table></td>
                                                                <td align="left" class="bodycopy" style="height: 20px" valign="middle">&nbsp;</td>
                                                                <td align="left" class="bodycopy" style="height: 20px" valign="middle">&nbsp;</td>
                                                            </tr>
                                                            <tr>
                                                                <td align="left" class="bodycopy" style="height: 20px" valign="middle">
                                                                    <input id="chk_z_is_warehousing" <% if v_z_is_warehousing="Y" then response.write("checked") %>=""
                                                                        name="chk_z_is_warehousing" onClick="javascript:cClick(this);" type="checkbox" value="Y"/><label for="chk_z_is_warehousing">Warehouse</label></td>
                                                                <td align="left" class="bodycopy" style="height: 20px" valign="middle"><table border="0" cellpadding="0" cellspacing="0" class="bodycopy"><tr><td id='td_SubWarehousing'><input id="txt_SubWarehousing" class="shorttextfield" name="txt_SubWarehousing" style="width: 150px;" type="text" value="<%= v_SubWarehousing%>" /></td><td></td><td id='td_SubWarehousing_href'><a href="#" onClick="javascript:actionRequestForAll('SubWarehousing','/IFF_MAIN/asp/ajaxFunctions/ajax_get_all_code.asp?t=SubWarehousing','150px');">[List]</a></td></tr></table></td>
                                                                <td align="left" class="bodycopy" style="height: 20px" valign="middle">&nbsp;</td>
                                                                <td align="left" class="bodycopy" style="height: 20px" valign="middle"><span class="bodyheader" style="height: 20px">* Other Option </span></td>
                                                            </tr>
                                                            <tr>
                                                                <td align="left" class="bodycopy" style="height: 20px" valign="middle">
                                                                    <input id="chk_z_is_cfs" <% if v_z_is_cfs="Y" then response.write("checked") %>="" name="chk_z_is_cfs" onClick="javascript:cClick(this);" type="checkbox" value="Y"/><label for="chk_z_is_cfs">Terminal/CFS</label></td>
                                                                <td align="left" class="bodycopy" style="height: 20px" valign="middle"><table border="0" cellpadding="0" cellspacing="0" class="bodycopy"><tr><td id='td_SubCFS'><input id="txt_SubCFS" class="shorttextfield" name="txt_SubCFS" style="width: 150px;" type="text" value="<%= v_SubCFS%>" /></td><td></td><td id='td_SubCFS_href'><a href="#" onClick="javascript:actionRequestForAll('SubCFS','/IFF_MAIN/asp/ajaxFunctions/ajax_get_all_code.asp?t=SubCFS','150px');">[List]</a></td></tr></table></td>
                                                                <td align="left" class="bodycopy" style="height: 20px" valign="middle" colspan="2">
							<select class="smallselect" name="lst_other_options" onChange="javascript:lst_other_options_change(this)" size="1" style="width: 100%">
							<option value=""></option>
                              <% for i=0 To aOtherField.count-1 %>
                             <option <% 
										if aOtherField(i) = v_other_field then 
												response.write "selected " 
										end if	
							%> value="<%=aOtherField(i)%>"><%= aOtherFieldText(i) %></option>
                              <% next %>
                           </select></td>
                                                            </tr>
                                                            <tr>
                                                                <td align="left" class="bodycopy" style="height: 20px" valign="middle">
                                                                    <input id="chk_z_is_broker" <% if v_z_is_broker="Y" then response.write("checked") %>="" name="chk_z_is_broker" onClick="javascript:cClick(this);" type="checkbox" value="Y"/><label for="chk_z_is_broker">CHB</label></td>
                                                                <td align="left" class="bodycopy" style="height: 20px" valign="middle"><table border="0" cellpadding="0" cellspacing="0" class="bodycopy"><tr><td id='td_SubBroker'><input id="txt_SubBroker" class="shorttextfield" name="txt_SubBroker" style="width: 150px;" type="text" value="<%= v_SubBroker%>" /></td><td></td><td id='td_SubBroker_href'><a href="#" onClick="javascript:actionRequestForAll('SubBroker','/IFF_MAIN/asp/ajaxFunctions/ajax_get_all_code.asp?t=SubBroker','150px');">[List]</a></td></tr></table></td>
                                                                <td align="left" class="bodycopy" style="height: 20px" valign="middle" colspan="2"><span class="bodycopy" style="height: 20px">
                                                                  <input id="txt_other_options" class="shorttextfield" name="txt_other_options" style="width: 100%" type="text" value="<%= v_other_options%>"/>
                                                                </span></td>
                                                            </tr>
                                                            <tr>
                                                                <td align="left" class="bodycopy" style="height: 20px" valign="middle">
                                                                    <input id="chk_z_is_govt" <% if v_z_is_govt="Y" then response.write("checked") %>="" name="chk_z_is_govt" onClick="javascript:cClick(this);" type="checkbox" value="Y"/><label for="chk_z_is_govt">Gov't</label></td>
                                                                <td align="left" class="bodycopy" style="height: 20px" valign="middle"><table border="0" cellpadding="0" cellspacing="0" class="bodycopy"><tr><td id='td_SubGovt'><input id="txt_SubGovt" class="shorttextfield" name="txt_SubGovt" style="width: 150px;" type="text" value="<%= v_SubGovt%>" /></td><td></td><td id='td_SubGovt_href'><a href="#" onClick="javascript:actionRequestForAll('SubGovt','/IFF_MAIN/asp/ajaxFunctions/ajax_get_all_code.asp?t=SubGovt','150px');">[List]</a></td></tr></table></td>
                                                                <td align="left" class="bodycopy" style="height: 20px" valign="middle" colspan="2"><input id="chkEmpty" name="chkEmpty" type="checkbox"  style="cursor:hand" onClick="javascript:clickEmpty(this)" <% if v_chkEmpty="Y" Then response.write("checked") %> />
                                                                <label for="chkEmpty">Empty field </label></td>
                                                            </tr>
                                                            <tr>
                                                                <td align="left" class="bodycopy" style="height: 20px" valign="middle">
                                                                    <input id="chk_is_vendor" <% if v_is_vendor="Y" then response.write("checked") %>="" name="chk_is_vendor" onClick="javascript:cClick(this);" type="checkbox" value="Y"/><label for="chk_is_vendor">Vendor</label></td>
                                                                <td align="left" class="bodycopy" style="height: 20px" valign="middle"><table border="0" cellpadding="0" cellspacing="0" class="bodycopy"><tr><td id='td_SubVendor'><input id="txt_SubVendor" class="shorttextfield" name="txt_SubVendor" style="width: 150px;" type="text" value="<%= v_SubVendor%>" /></td><td></td><td id='td_SubVendor_href'><a href="#" onClick="javascript:actionRequestForAll('SubVendor','/IFF_MAIN/asp/ajaxFunctions/ajax_get_all_code.asp?t=SubVendor','150px');">[List]</a></td></tr></table></td>
                                                                <td align="left" class="bodycopy" style="height: 20px" valign="middle" colspan="2"><span class="bodycopy" style="height: 20px">
                                                                  <input type="hidden" name="filter_string" value="<%=filter_string%>" class="shorttextfield">
                                                                </span></td>
                                                            </tr>
                                                            <tr>
                                                                <td align="left" class="bodycopy" style="height: 20px" valign="middle">
                                                                    <input id="chk_z_is_special" <% if v_z_is_special="Y" then response.write("checked") %>=""
                                                                        name="chk_z_is_special" onClick="javascript:cClick(this);" type="checkbox" value="Y"/><label for="chk_z_is_special">Other</label></td>
                                                                <td align="left" class="bodycopy" style="height: 20px; width: 200px" valign="middle"><table border="0" cellpadding="0" cellspacing="0" class="bodycopy"><tr><td id='td_SubSpecial'><input id="txt_SubSpecial" class="shorttextfield" name="txt_SubSpecial" style="width: 150px;" type="text" value="<%= v_SubSpecial%>" /></td><td></td><td id='td_SubSpecial_href'><a href="#" onClick="javascript:actionRequestForAll('SubSpecial','/IFF_MAIN/asp/ajaxFunctions/ajax_get_all_code.asp?t=SubSpecial','150px');">[List]</a></td></tr></table></td>
                                                                <td align="left" class="bodycopy" style="height: 20px; width: 200px" valign="middle" colspan="2"><div align="left"><img src="../images/button_NEWsearch.gif" id="bGo" width="25" height="18" align="absmiddle"  style="cursor:hand" onClick="javascript:doBtn(this);"><input id="txt_status" class="bodycopy" name="txt_status" style="width: 100px; text-align:left; border-style:none; background-color:#f3f3f3" type="text"  readonly="true"/>
                                                                </div></td>
                                                            </tr>
                                                            <tr>
                                                                <td align="left" class="bodycopy" style="height: 20px" valign="middle">
                                                                    <input id="chk_is_customer" <% if v_is_customer="Y" then response.write("checked") %>="" name="chk_is_customer" onClick="javascript:cClick(this);" type="checkbox" value="Y"/><label for="chk_is_customer">Customer</label></td>
                                                                <td align="left" class="bodycopy" style="height: 20px" valign="middle"><table border="0" cellpadding="0" cellspacing="0" class="bodycopy"><tr><td id='td_SubCustomer'><input id="txt_SubCustomer" class="shorttextfield" name="txt_SubCustomer" style="width: 150px;" type="text" value="<%= v_SubCustomer%>" /></td><td></td><td id='td_SubCustomer_href'><a href="#" onClick="javascript:actionRequestForAll('SubCustomer','/IFF_MAIN/asp/ajaxFunctions/ajax_get_all_code.asp?t=SubCustomer','150px');">[List]</a></td></tr></table></td>
                                                                <td align="left" class="bodycopy" style="height: 20px" valign="middle" colspan="2"><span class="bodycopy" style="height: 20px">
                                                                  <input type="hidden" name="filter_string" value="<%=filter_string%>" class="shorttextfield">
                                                                </span></td>
                                                            </tr>
                                                        </table></td>
			    </tr>
					<tr>
						<td class="font" align="center"></td>
					</tr>
			</table></td>
            </tr>
            <tr bgcolor="D5E8CB">
              <td align="right" bgcolor="#f3f3f3" class="bodycopy" valign="top"><span class="bodyheader">
              <input id="txt_lessOrGreaterTop" class="bodyheader" name="txt_lessOrGreaterTop" style="width: 100px; text-align:right; border-style:none; background-color:#f3f3f3" type="text"  readonly="true" value="<%=recordCount&"/"&totalCount%>"/>
              </span></td>
              <td align="left" bgcolor="#f3f3f3" class="bodyheader" valign="middle">(Filtered / Total)</td>
            </tr>
            <tr bgcolor="D5E8CB">
                <td align="left" bgcolor="#f3f3f3" class="bodyheader" valign="top" width="29%" id="td_result"><select class="smallselect" id="lst_code" name="lst_code" size="4" style="height: 300px; width: 485px; font-size: 11px; font-family: 'Courier New', Courier, monospace;"  multiple="multiple" onChange="lst_code_on_change(this)" onDBLClick="javascript:doBtn(this.form.bOK);">
                  <% if Not IsNull(code_list) And Not isEmpty(code_list) Then %>
				  <% dim sCnt %>
				  <% sCnt = 0 %>
                  <% for i=0 To code_list.count-1 %>
                  <option <% 
						if code_list(i)("dba_name") = default then 
								response.write "selected " 
								sCnt = i
						end if	
						if instr(code_list(i)("code_description"),"Deactivated") > 0 then 
								response.write "style='color:#FF0000;font:bold'" 
						end if										
						%> value="<%=code_list(i)("code")%>"><%= code_list(i)("code_description") %></option>
                  <% next %>
				  <% if sCnt = 0 and default <> "" then %>
						<script language="javascript">
							var listValue = '<%=default%>';
							var Len = listValue.length;
							var oSelect = document.getElementById('lst_code')
							var items = oSelect.options;
							for( var i = 0; i < items.length; i++ ) {
							var item = items[i];
								if( item.text.substring(0,Len).toLowerCase() == listValue.toLowerCase() ) {
									oSelect.selectedIndex = i;
									// Please enable if you want to fill out the dba_name field automatically.
									// document.getElementById('txt_dba_name').value = item.text;									
									break;
								}
							}													
						</script>
				  <% end if %>
                  <% end if %>
                </select></td>
                <td align="left" bgcolor="#f3f3f3" class="bodyheader" valign="middle" width="71%">
                    <table border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                        <tr>
                        <td><input class="bodycopy" id="bOK" style="width: 110px; height:25px" type="button" value="OK" onClick="javascript:doBtn(this);"></td></tr>
						<tr align="left" valign="middle" bgcolor="#f3f3f3">
					    <td height="4" align="left"></td></tr>
                        <tr>
                        <td><input class="bodycopy" id="bCANCEL" style="width: 110px; height:25px" type="button" value="Cancel" onClick="javascript:doBtn(this);"></td></tr>
						<tr align="left" valign="middle" bgcolor="#f3f3f3">
					    <td height="32" align="left"></td></tr>
                        <tr>
                        <td><input class="bodycopy" id="bADD" style="width: 110px; height:25px" type="button" value="Add..." onClick="javascript:doBtn(this);"></td></tr>
						<tr align="left" valign="middle" bgcolor="#f3f3f3">
					    <td height="4" align="left"></td></tr>
                        <tr>
                        <td><input class="bodycopy" id="bACTIVATE" style="width: 110px; height:25px" type="button" value="Activate" onClick="javascript:doBtn(this);"></td></tr>
						<tr align="left" valign="middle" bgcolor="#f3f3f3">
					    <td height="4" align="left"></td></tr>
                        <tr>
                        <td><input class="bodycopy" id="bDEACTIVATE" style="width: 110px; height:25px" type="button" value="Deactivate" onClick="javascript:doBtn(this);"></td></tr>																		
                    </table></td>
            </tr>
            <tr bgcolor="D5E8CB">
              <td align="left" bgcolor="#f3f3f3" class="bodyheader" valign="top" colspan="2">
                                            <table border="0" bordercolor="#A0829C" cellpadding="0" cellspacing="0" width="100%">
                                                <tr align="left" bgcolor="#f3f3f3" valign="middle">
                                                    <td width="38%" class="bodyheader">                                                    </td>
                                                </tr>
                                                
                                                <tr align="left" bgcolor="#f3f3f3" valign="middle">
                                                    <td align="left"></td>
                                                </tr>
                                                <tr align="left" bgcolor="#f3f3f3" valign="middle">
                                                    <td height="22" align="center" id="td_page_break"><% call page_tag %></td>
                                                </tr>
                                                <tr align="left" bgcolor="#f3f3f3" valign="middle">
                                                  <td height="22" align="center">&nbsp;</td>
                                                </tr>
                                          </table>  
<!-- End of search options -->			  </td>
            </tr>
            <tr bgcolor="D5E8CB">
              <td align="left" bgcolor="#f3f3f3" class="bodyheader" valign="middle"  colspan="2"></td>
            </tr>
        </table>
    </form>
</body>
<script language="javascript" type="text/javascript" src="client_profile_f_shared.js"></script>
<script language="javascript">
function showResponseFindResult(req,field,tmpVal,tWidth,url) {
	if (req.readyState == 4) {
		if (req.status == 200) {
//			alert(req.responseText);
			create_innerHTML_for_result(req.responseText);
			document.getElementById('txt_status').value= '';
		}
	}	
}
function submit_page(url,actType) {
	var td = document.getElementById('td_result');
	var msgBox = document.getElementById('txt_status');
	msgBox.value= 'loading...';
	var post_parameter = get_post_parameters(document.form1,actType);
	new ajax.xhr.Request('POST',post_parameter,url,showResponseFindResult,'','','');	
}

function goPage(p) {
	document.getElementById('txt_dba_name').value = '';
	submit_page("/IFF_MAIN/asp/ajaxFunctions/ajax_get_dba_result.asp?PostBack=true&Action=Page&Page="
				+encodeURIComponent(p)
				+"&WindowName="
				+window.name,"");
}
function doBtn(o) {
	try {
			var oSelect = document.getElementById('lst_code');
			
			if (oSelect.options.selectedIndex >= 0) {
				var	s = oSelect.options[ oSelect.options.selectedIndex ].value;
			}
			else {
				var	s = '';
			}	
	
			switch(o.id) {
				case 'bGo' :
							document.getElementById('filter_string').value = '';				
							submit_page("/IFF_MAIN/asp/ajaxFunctions/ajax_get_dba_result.asp?PostBack=true&Action=Search&WindowName="
							 +window.name,'');
							break;
				case 'bOK' :
				s = '';
				for(var i = 0;i < oSelect.length;i++){
					if(oSelect.options[i].selected == true){
						s += oSelect.options[i].value + ':';
					}
				} 
				window.returnValue = s; 
				window.close();			
					break;
				case 'bCANCEL' :
				window.returnValue = '';
				window.close();			
					break;
				case 'bADD' :
		var param = 'type=' + '<%=code_type%>' + '&mode=Add';
		var retVal = showModalDialog("all_dba_edit.asp?"
										+param,"EditCode",
										"dialogWidth:540px; dialogHeight:150px; help:0; status:0; scroll:0;center:1;Sunken;");   
					if (retVal != '' && typeof(retVal) != 'undefined') {
						var code = retVal;
						var goStop = false
						if (!check_dupe(code,oSelect.options)) {
							goStop = true;
						}
						else {
							if(confirm('The DBA NAME: ' + code + ' already exists in Client list. \nDo you want to add anyway?')) {
							 goStop = true
							}		
						}
						
						if(goStop) {
						document.getElementById('filter_string').value = '';
				submit_page("/IFF_MAIN/asp/ajaxFunctions/ajax_get_dba_result.asp?PostBack=true&Action=save&retVal="
								+encodeURIComponent(code)
								+"&Page="
								+code.substring(0,1)
								+"&WindowName="
								+window.name,
								o.id)
						}
					}
					break;
				case 'bDEACTIVATE' :
					if(confirm('Are you sure you want to deactivate the selected item(s)?')) {
						submit_page("/IFF_MAIN/asp/ajaxFunctions/ajax_get_dba_result.asp?PostBack=true&Action=delete&WindowName="
									 +window.name,
									 o.id)
					}
					break;
				case 'bACTIVATE' :
					var tmpStr = oSelect.options[ oSelect.options.selectedIndex ].text;
					submit_page("/IFF_MAIN/asp/ajaxFunctions/ajax_get_dba_result.asp?PostBack=true&Action=activate&WindowName="
								+window.name,
								o.id)
					break;
				default :
					break;
			}
	} catch(ex) {}
		
}

function lst_code_on_change(o) {
var Ao = document.getElementById('bACTIVATE');
var Do = document.getElementById('bDEACTIVATE');
	try {
			if(GetSelectValues(o) > 1) {
				Ao.disabled="";			
				Do.disabled="";			
			}	
			else {
				if ( o.options[ o.options.selectedIndex ].text.indexOf('Deactivated') > 0 ) {
					Ao.disabled="";			
					Do.disabled="disabled";			
				} else {	
					Ao.disabled="disabled";			
					Do.disabled="";			
				}	
			}
	} catch(ex) {}		
}

function btn_init() {
var Ao = document.getElementById('bACTIVATE');
var Do = document.getElementById('bDEACTIVATE');

	try {
		var o = document.getElementById('lst_code');
			if(GetSelectValues(o) == 0) {
				Ao.disabled="disabled";	
				Do.disabled="disabled";	
			}
	} catch(ex) {}		
}

set_screen_default();

function set_screen_default() {
	btn_init();
	oScroll(document.getElementById('lst_code'),10);
}
function oScroll(oSelect,middle){
	try {
		var opt=oSelect.options;
		for (var i=0;i<opt.length;i++){
			if(opt[i].selected){
				if(( opt.length - i) <= middle ) {
					opt[opt.length-1].selected=true;
					opt[opt.length-1].selected=false;				
				} else {
					opt[i+middle].selected=true;
					opt[i+middle].selected=false;								
				}
				opt[i].selected=false;
				opt[i].selected=true;
				return;
			}
		}
	} catch(f) {}	
}
</script>

</html>
