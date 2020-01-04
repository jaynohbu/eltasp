<!--  #INCLUDE FILE="../include/transaction.txt" -->
<% 
    Option Explicit
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<!--  #INCLUDE FILE="../include/connection.asp" -->
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Client Profile</title>
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />

    <script type="text/javascript">
        function showtip() { }
        function ToUpCase(obj) {
            var word = obj.value;
            obj.value = word.toUpperCase();

        }
    </script>

    <style type="text/css">
        <!--
        body
        {
            margin-left: 0px;
            margin-right: 0px;
            margin-bottom: 0px;
        }

        a
        {
            font-size: 9px;
            font-weight: bold;
            color: #000000;
            text-decoration: none;
            font-family: Verdana;
        }

            a:hover
            {
                color: #b83423;
            }

        .style7
        {
            color: #c16b42;
        }

        .style11
        {
            color: #336699;
        }

        .style13
        {
            color: #999999;
        }

        .style15
        {
            color: #666666;
        }
        -->
    </style>
</head>
<!--  #INCLUDE FILE="../include/header.asp" -->
<!--  #INCLUDE FILE="client_profile_declaration.inc" -->
<%
Dim PostBack
Dim vOrg
Dim i
%>
<%
		PostBack = Request.QueryString("PostBack")
		if isnull(PostBack) then PostBack = ""
        if PostBack = "" then PostBack = false
		vOrg = Request.QueryString("n")
		if isnull(vOrg) then vOrg = ""
%>
<body leftmargin="0" link="336699" marginheight="0" marginwidth="0" topmargin="0"
    vlink="336699">
    <!-- tooltip placeholder -->
    <div id="tooltipcontent">
    </div>
    <!-- placeholder ends -->
    <form method="post" name="form1">
        <input type="hidden" name="txt_carrier_type" value="<%= v_carrier_type%>">
        <input type="hidden" name="txt_orginal_dba_name">
        <input type="hidden" name="txt_date_opened">
        <input type="hidden" name="txt_last_update">
        <input type="hidden" name="txt_attn_name">
        <input type="hidden" name="txt_notify_name">
        <input type="hidden" name="txt_z_bond_number">
        <input type="hidden" name="txt_z_bond_exp_date">
        <input type="hidden" name="txt_z_bond_amount">
        <input type="hidden" name="txt_iata_code">
        <input type="hidden" name="txt_z_bond_surety">
        <input type="hidden" name="txt_z_carrier_prefix">
        <input type="hidden" name="txt_business_st_taxid">
        <input type="hidden" name="txt_owner_ssn">
        <input type="hidden" name="txt_z_carrier_code">
        <input type="hidden" name="txt_acct_name">
        <!-- phone mask -->
        <input type="hidden" name="txt_business_phone_mask" value="<%= v_business_phone_mask%>">
        <input type="hidden" name="txt_business_phone2_mask" value="<%= v_business_phone2_mask%>">
        <input type="hidden" name="txt_owner_phone_mask" value="<%= v_owner_phone_mask%>">
        <input type="hidden" name="txt_business_fax_mask" value="<%= v_business_fax_mask%>">
        <input type="hidden" name="txt_c2Phone_mask" value="<%= v_c2Phone_mask%>">
        <input type="hidden" name="txt_c2Cell_mask" value="<%= v_c2Cell_mask%>">
        <input type="hidden" name="txt_c2Fax_mask" value="<%= v_c2Fax_mask%>">
        <input type="hidden" name="txt_c3Phone_mask" value="<%= v_c3Phone_mask%>">
        <input type="hidden" name="txt_c3Cell_mask" value="<%= v_c3Cell_mask%>">
        <input type="hidden" name="txt_c3Fax_mask" value="<%= v_c3Fax_mask%>">
        <input type="hidden" name="txt_business_phone_mask_exp" value="<%= v_business_phone_mask_exp%>">
        <input type="hidden" name="txt_business_phone2_mask_exp" value="<%= v_business_phone2_mask_exp%>">
        <input type="hidden" name="txt_owner_phone_mask_exp" value="<%= v_owner_phone_mask_exp%>">
        <input type="hidden" name="txt_business_fax_mask_exp" value="<%= v_business_fax_mask_exp%>">
        <input type="hidden" name="txt_c2Phone_mask_exp" value="<%= v_c2Phone_mask_exp%>">
        <input type="hidden" name="txt_c2Cell_mask_exp" value="<%= v_c2Cell_mask_exp%>">
        <input type="hidden" name="txt_c2Fax_mask_exp" value="<%= v_c2Fax_mask_exp%>">
        <input type="hidden" name="txt_c3Phone_mask_exp" value="<%= v_c3Phone_mask_exp%>">
        <input type="hidden" name="txt_c3Cell_mask_exp" value="<%= v_c3Cell_mask_exp%>">
        <input type="hidden" name="txt_c3Fax_mask_exp" value="<%= v_c3Fax_mask_exp%>">
        <input type="hidden" name="txt_business_phone_mask_pre" value="<%= v_business_phone_mask_pre%>">
        <input type="hidden" name="txt_business_phone2_mask_pre" value="<%= v_business_phone2_mask_pre%>">
        <input type="hidden" name="txt_owner_phone_mask_pre" value="<%= v_owner_phone_mask_pre%>">
        <input type="hidden" name="txt_business_fax_mask_pre" value="<%= v_business_fax_mask_pre%>">
        <input type="hidden" name="txt_c2Phone_mask_pre" value="<%= v_c2Phone_mask_pre%>">
        <input type="hidden" name="txt_c2Cell_mask_pre" value="<%= v_c2Cell_mask_pre%>">
        <input type="hidden" name="txt_c2Fax_mask_pre" value="<%= v_c2Fax_mask_pre%>">
        <input type="hidden" name="txt_c3Phone_mask_pre" value="<%= v_c3Phone_mask_pre%>">
        <input type="hidden" name="txt_c3Cell_mask_pre" value="<%= v_c3Cell_mask_pre%>">
        <input type="hidden" name="txt_c3Fax_mask_pre" value="<%= v_c3Fax_mask_pre%>">
        <!-- end of phone mask -->
        <input type="hidden" name="filter_string">
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td width="50%" height="32" align="left" valign="middle" class="pageheader">CLIENT/PARTNER PROFILE
                </td>
                <td width="50%" align="right" valign="top">
                    <div id="print">
                        <img src="/iff_main/ASP/Images/icon_printer_preview.gif" align="absbottom"><a href="javascript:;"
                            onclick="viewPDF(); return false;" tabindex="-1">Client/Partner Profile </a>
                    </div>
                </td>
            </tr>
        </table>
        <table width="95%" height="40" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td width="45%">&nbsp;</td>
                <td width="55%" align="right" valign="middle">
                    <span class="bodyheader">
                        <img src="/iff_main/ASP/Images/required.gif" align="absbottom" />Required field</span></td>
            </tr>
        </table>
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#73beb6"
            class="border1px">
            <tr bgcolor="#ccebed">
                <td height="24" align="center" valign="middle" bgcolor="#ccebed" class="bodyheader">
                    <table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                            <td width="26%"></td>
                            <td width="48%" align="center">
                                <img height="18" name="bSave" onclick="saveOrganization(1);" src="../images/button_save_medium.gif"
                                    style="cursor: hand" width="46" /></td>
                            <td width="13%" align="right" valign="middle">
                                <img src="/iff_main/ASP/Images/button_new.gif" width="42" height="17" border="0"
                                    id="bNew" onclick="javascript:client_new();" style="cursor: hand"></td>
                            <td width="13%" align="right" valign="middle">
                                <img src="../images/button_delete_medium.gif" width="51" height="17" id="bDelete"
                                    name="bDeleteHAWB" onclick="javascript:saveOrganization(2);" style="cursor: hand"></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td height="1" colspan="10" bgcolor="#73beb6"></td>
            </tr>
            <tr align="left" bgcolor="#f3f3f3" valign="middle">
                <td align="left" bgcolor="#f3f3f3">
                    <br>
                    <table width="68%" border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr align="left" bgcolor="#f3f3f3" valign="middle">
                            <td width="72%" align="right" valign="middle" bgcolor="#f3f3f3" class="bodyheader">
                                <input id="bClearF" class="bodycopy" onclick="javascript: clear_filter();" style="width: 80px"
                                    type="button" value="Clear Filter"></td>
                            <td width="28%" height="30" align="right" valign="middle" bgcolor="#f3f3f3">
                                <span class="bodyheader">
                                    <img height="9" name="bNext" onclick="javascript:PrevNext(0);" src='../Images/left_arrow_end.gif'
                                        style="cursor: hand" width="7">
                                    &nbsp;&nbsp;
                                    <img height="9" name="bNext" onclick="javascript:PrevNext(1);" src='../Images/left_arrow.gif'
                                        style="cursor: hand" width="7">
                                    <input id="txt_lessOrGreaterTop" class="bodyheader" name="txt_lessOrGreaterTop" style="width: 100px; text-align: center; border-style: none; background-color: #f3f3f3"
                                        type="text"
                                        readonly="true" tabindex="-1" />
                                    <img height="9" name="bNext" onclick="javascript:PrevNext(2);" src='../Images/right_arrow.gif'
                                        style="cursor: hand" width="7">
                                    &nbsp;&nbsp;
                                    <img height="9" name="bNext" onclick="javascript:PrevNext(3);" src='../Images/right_arrow_end.gif'
                                        style="cursor: hand" width="7"></span></td>
                        </tr>
                    </table>
                    <table width="68%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#73beb6"
                        class="border1px">
                        <tr>
                            <td width="1%" align="left" valign="middle" bgcolor="#ecf7f8">&nbsp;</td>
                            <td height="20" align="left" valign="middle" bgcolor="#ecf7f8" class="bodyheader">
                                <img src="/iff_main/ASP/Images/required.gif" align="absbottom"><span class="style7">Company
                                    Name (DBA)</span></td>
                            <td width="24%" bgcolor="#ecf7f8" class="bodyheader">Class</td>
                            <td width="12%" bgcolor="#ecf7f8" class="bodyheader">&nbsp;</td>
                            <td width="17%" bgcolor="#ecf7f8" class="bodyheader">&nbsp;</td>
                        </tr>
                        <tr>
                            <td bgcolor="#FFFFFF">&nbsp;</td>
                            <td height="24" bgcolor="#FFFFFF">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td width="62%" id="td_dba_name">
                                            <input id="txt_dba_name" class="shorttextfield" name="txt_dba_name" style="width: 250px;"
                                                value="<%= v_dba_name%>" maxlength="128">
                                        </td>
                                        <td width="38%" align="left" valign="middle" class="bodycopy" id="td_dba_name_href">
                                            <a href="javascript:" class="list" onclick="javascript:actionRequestForAll('dba_name','/IFF_MAIN/asp/ajaxFunctions/ajax_get_all_code.asp?t=dba_name','250px','128');return false;">[List]</a></td>
                                    </tr>
                                </table>
                            </td>
                            <td bgcolor="#FFFFFF" colspan="2">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <td></td>
                            <tr>
                                <td width="39%" id='td_class_code'>
                                    <span class="bodycopy">
                                        <input id="txt_class_code" class="shorttextfield" name="txt_class_code" style="width: 140px;"
                                            type="text" value="<%= v_class_code%>" maxlength="20" />
                                    </span>
                                </td>
                                <td width="61%" align="left" valign="middle" class="bodycopy" id="td_class_code_href">
                                    <a href="javascript:" class="list" onclick="javascript:actionRequestForAll('class_code','/IFF_MAIN/asp/ajaxFunctions/ajax_get_all_code.asp?t=class_code','140px','32');">[List]</a></td>
                            </tr>
                    </table>
                </td>
                <td align="center" valign="middle" bgcolor="#FFFFFF">
                    <span class="bodyheader"><a href="javascript:;" onclick="javascript:goSearch('dba_name');">
                        <img src="/iff_main/ASP/Images/icon_quicksearch.gif" width="32" height="25" style="cursor: pointer"></a></span></td>
            </tr>
            <tr>
                <td height="2" colspan="10" bgcolor="#73beb6"></td>
            </tr>
            <tr>
                <td bgcolor="#f3f3f3">&nbsp;</td>
                <td width="46%" height="24" align="left" valign="middle" bgcolor="#f3f3f3">
                    <span class="bodyheader">
                        <input id="chk_isFrequently" name="chk_isFrequently" type="checkbox" style="cursor: pointer" />
                        <label for="chk_isFrequently">
                            Frequently referenced</label>
                    </span>
                    <% if mode_begin then %>
                    <div style="width: 21px; display: inline; vertical-align: text-bottom" onmouseover="showtip('Checking this box will make the business show up in the initial list when you load the C/P Profile page, allowing for quick access.');"
                        onmouseout="hidetip()">
                        <img src="../Images/button_info.gif" align="absmiddle" class="bodylistheader">
                    </div>
                    <% end if %>
                </td>
                <td valign="middle" bgcolor="#f3f3f3">&nbsp;</td>
                <td colspan="2" valign="middle" bgcolor="#f3f3f3">&nbsp;</td>
            </tr>
            <tr>
                <td bgcolor="#FFFFFF">&nbsp;</td>
                <td height="24" align="left" valign="middle" bgcolor="#FFFFFF">
                    <span class="bodyheader">
                        <input id="chk_account_status" name="chk_account_status" type="checkbox" style="cursor: hand" />
                        <label for="chk_account_status">
                            Deactivate this client</label>
                        <% if mode_begin then %>
                    </span>
                    <div style="width: 21px; display: inline; vertical-align: text-bottom" onmouseover="showtip('Checking this box will remove this business from the drop-down lists in the operation portions of FE, while still saving the data and allowing access to it here.');"
                        onmouseout="hidetip()">
                        <img src="../Images/button_info.gif" align="absmiddle" class="bodylistheader">
                    </div>
                    <% end if %>
                </td>
                <td colspan="3" valign="middle" bgcolor="#FFFFFF" class="bodyheader">&nbsp;</td>
            </tr>
            <tr>
                <td bgcolor="#f3f3f3">&nbsp;</td>
                <td height="24" align="left" valign="middle" bgcolor="#f3f3f3">
                    <span class="bodyheader">
                        <input id="chk_known_shipper" name="chk_known_shipper" type="checkbox" style="cursor: hand" />
                        <label for="chk_known_shipper">
                            Known Shipper</label>
                    </span>
                </td>
                <td colspan="3" valign="middle" bgcolor="#f3f3f3">&nbsp;</td>
            </tr>
        </table>
        <br />
        <br />
        <table width="99%" border="0" align="center" cellpadding="0" cellspacing="0" class="bodycopy">
            <tr>
                <td style="width: 150px">
                    <a href="javascript:;" onclick="edit_scheduleB(); return false;">
                        <img src="/iff_main/ASP/Images/icon_edit.gif" align="absmiddle" alt="" />Edit Schedule
                                    B</a>
                </td>
                <td style="width: 150px; <% if UserRight <> 9 then response.write "visibility:hidden" %>">
                    <a href="javascript:;" onclick="edit_Rate(); return false;">
                        <img src="/iff_main/ASP/Images/icon_edit.gif" align="absmiddle" alt="" />Edit Rate
                                    Manager</a>
                </td>
                <td style="text-align: right; <% if UserRight <> 9 then response.write "visibility:hidden" %>">
                    <input class="bodycopy" id="bList" style="width: 80px" type="button" value="Back to List"
                        onclick="javascript: location = '/iff_main/ASP/Master_Data/client_profile_list.asp'" />
                    &nbsp;&nbsp;&nbsp;<input class="bodycopy" id="bAdjust" style="width: 80px" type="button"
                        value="Adjust Data" onclick="javascript: saveOrganization(5);" />
                    &nbsp;&nbsp;&nbsp;<input class="bodycopy" id="bTrans" style="width: 80px" type="button"
                        value="Data Trans." onclick="javascript: saveOrganization(4);" /></td>
            </tr>
        </table>
        <br />
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td height="2" colspan="6" bgcolor="#73beb6"></td>
            </tr>
            <tr align="left" bgcolor="#f3f3f3" valign="middle">
                <td width="1%"></td>
                <td height="22" colspan="3" align="left" bgcolor="#ecf7f8" class="bodyheader style7">General Information
                </td>
            </tr>
            <tr>
                <td height="1" colspan="6" bgcolor="#73beb6"></td>
            </tr>
            <tr>
                <td align="left" bgcolor="#f3f3f3" class="bodyheader">&nbsp;</td>
                <td width="31%" height="22" align="left" bgcolor="#f3f3f3" class="bodyheader">Legal Name</td>
                <td width="32%" align="left" bgcolor="#f3f3f3">&nbsp;</td>
                <td width="36%" align="left" bgcolor="#f3f3f3">&nbsp;</td>
            </tr>
            <tr align="left" bgcolor="#f3f3f3" valign="middle">
                <td align="left" bgcolor="#FFFFFF" class="bodyheader">&nbsp;</td>
                <td height="22" align="left" bgcolor="#FFFFFF" class="bodyheader">
                    <input id="txt_business_legal_name" class="shorttextfield" name="txt_business_legal_name"
                        size="40" value="<%=v_business_legal_name%>"></td>
                <td align="left" bgcolor="#FFFFFF">&nbsp;</td>
                <td align="left" bgcolor="#FFFFFF">&nbsp;</td>
            </tr>
            <tr align="left" bgcolor="#f3f3f3" valign="middle">
                <td align="left" bgcolor="#f3f3f3" class="bodyheader">&nbsp;</td>
                <td height="22" align="left" bgcolor="#f3f3f3" class="bodyheader">Address</td>
                <td align="left" bgcolor="#f3f3f3">
                    <span class="bodyheader">City</span></td>
                <td align="left" bgcolor="#f3f3f3">
                    <span class="bodyheader">State/Province</span></td>
            </tr>
            <tr align="left" bgcolor="#f3f3f3" valign="middle">
                <td height="22" align="left" bgcolor="#FFFFFF" class="bodyheader">&nbsp;</td>
                <td rowspan="3" align="left" valign="top" bgcolor="#FFFFFF" class="bodycopy">
                    <span class="style13">Address Line 1</span><br>
                    <input id="txt_business_address" class="shorttextfield" name="txt_business_address"
                        size="40" value="<%=v_business_address%>">
                    <br>
                    <span class="style13">Address Line 2</span>
                    <br>
                    <input id="txt_business_address2" class="shorttextfield" name="txt_business_address2"
                        size="40" value="<%=v_business_address2%>"></td>
                <td align="left" bgcolor="#FFFFFF">
                    <table border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                        <tr>
                            <td id='td_business_city'>
                                <input id="txt_business_city" class="shorttextfield" name="txt_business_city" style="width: 150px;"
                                    type="text" value="<%= v_business_city%>" maxlength='32' /></td>
                            <td id='td_business_city_href'>
                                <a href="javascript:" class="list" onclick="actionRequestForAll('business_city','/IFF_MAIN/asp/ajaxFunctions/ajax_get_all_code.asp?t=business_city','150px','32');return false;">[List]</a></td>
                        </tr>
                    </table>
                </td>
                <td align="left" bgcolor="#FFFFFF">
                    <table border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                        <tr>
                            <td id='td_business_state'>
                                <input id="txt_business_state" class="shorttextfield" name="txt_business_state" style="width: 150px;"
                                    type="text" value="<%= v_business_state%>" maxlength='32' /></td>
                            <td id='td_business_state_href'>
                                <a href="javascript:" class="list" onclick="javascript:actionRequestForAll('business_state','/IFF_MAIN/asp/ajaxFunctions/ajax_get_all_code.asp?t=business_state','150px','32');return false;">[List]</a></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr align="left" bgcolor="#f3f3f3" valign="middle">
                <td height="22" align="left" bgcolor="#FFFFFF" class="bodyheader">&nbsp;</td>
                <td align="left" bgcolor="#f3f3f3">
                    <span class="bodyheader">Zip</span></td>
                <td align="left" bgcolor="#f3f3f3">
                    <span class="bodyheader">Country</span></td>
            </tr>
            <tr align="left" bgcolor="#f3f3f3" valign="middle">
                <td height="22" align="left" bgcolor="#FFFFFF" class="bodyheader">&nbsp;</td>
                <td align="left" bgcolor="#FFFFFF">
                    <table border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                        <tr>
                            <td id="td_business_zip">
                                <input id="txt_business_zip" class="shorttextfield" name="txt_business_zip" style="width: 100px;"
                                    type="text" value="<%= v_business_zip%>" maxlength='32' /></td>
                            <td id="td_business_zip_href">
                                <a href="javascript:" class="list" onclick="javascript:actionRequestForAll('business_zip','/IFF_MAIN/asp/ajaxFunctions/ajax_get_all_code.asp?t=business_zip','100px','32');return false;">[List]</a></td>
                        </tr>
                    </table>
                </td>
                <td align="left" bgcolor="#FFFFFF">
                    <table border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                        <tr>
                            <td id="td_business_country">
                                <input id="txt_business_country" class="shorttextfield" name="txt_business_country"
                                    style="width: 150px;" type="text" value="<%= v_b_country_code %>" maxlength='64' /></td>
                            <td id='td_business_country_href'>
                                <a href="javascript:" class="list" onclick="javascript:actionRequestForAll('business_country','/IFF_MAIN/asp/ajaxFunctions/ajax_get_country_code.asp','150px','64');return false;">[List]</a>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr align="left" bgcolor="#f3f3f3" valign="middle">
                <td height="22" align="left" valign="middle" bgcolor="#f3f3f3" class="bodyheader">&nbsp;</td>
                <td align="left" valign="middle" bgcolor="#f3f3f3" class="bodycopy">
                    <span class="bodyheader">Phone No. 1</span></td>
                <td align="left" valign="middle" bgcolor="#f3f3f3">
                    <span class="bodyheader">Phone No. 2</span></td>
                <td align="left" valign="middle" bgcolor="#f3f3f3">
                    <span class="bodyheader">Fax No.</span></td>
            </tr>
            <tr align="left" bgcolor="#f3f3f3" valign="middle">
                <td height="22" align="left" bgcolor="#FFFFFF" class="bodyheader">&nbsp;</td>
                <td align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                    <table border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                        <tr>
                            <td>
                                <input id="txt_business_phone" class="shorttextfield" name="txt_business_phone" style="width: 110px;"
                                    type="text" value="<%=v_business_phone%>" maxlength="32" /></td>
                            <td class="bodyheader">
                                <a href="javascript:;" onclick="javascript:adjustMask('txt_business_phone');" style="cursor: pointer">
                                    <img src="/iff_main/ASP/Images/icon_format.gif" alt="Phone number format"></a></td>
                            <td class="bodyheader">&nbsp;Ext.&nbsp;</td>
                            <td>
                                <input id="txt_business_phone_ext" class="shorttextfield" name="txt_business_phone_ext"
                                    style="width: 40px;" type="text" value="<%=v_business_phone_ext%>" maxlength="16" /></td>
                        </tr>
                    </table>
                </td>
                <td align="left" valign="middle" bgcolor="#FFFFFF">
                    <table border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                        <tr>
                            <td>
                                <input id="txt_business_phone2" class="shorttextfield" name="txt_business_phone2"
                                    style="width: 110px;" type="text" value="<%= v_business_phone2%>" maxlength="32" /></td>
                            <td align="left" valign="middle" class="bodyheader">
                                <a href="javascript:;" onclick="javascript:adjustMask('txt_business_phone2');" style="cursor: hand">
                                    <img src="/iff_main/ASP/Images/icon_format.gif" alt="Phone number format"></a></td>
                            <td align="left" valign="middle" class="bodyheader">&nbsp;Ext.&nbsp;</td>
                            <td>
                                <input id="txt_business_phone2_ext" class="shorttextfield" name="txt_business_phone2_ext"
                                    style="width: 40px;" type="text" value="<%=v_business_phone2_ext%>" maxlength="16" /></td>
                        </tr>
                    </table>
                </td>
                <td align="left" valign="middle" bgcolor="#FFFFFF">
                    <span class="bodyheader">
                        <input id="txt_business_fax" class="shorttextfield" name="txt_business_fax" style="width: 110px;"
                            type="text" value="<%= v_business_fax%>" /><a style="cursor: pointer" href="javascript:;"
                                onclick="javascript:adjustMask('txt_business_fax');"><img src="/iff_main/ASP/Images/icon_format.gif"
                                    align="absmiddle" alt="Phone number format"></a></span></td>
            </tr>
            <tr>
                <td height="1" colspan="6" bgcolor="#73beb6"></td>
            </tr>
            <tr align="left" bgcolor="#f3f3f3" valign="middle">
                <td align="left" bgcolor="#f3f3f3" class="bodyheader">&nbsp;</td>
                <td height="22" align="left" bgcolor="#f3f3f3" class="bodyheader">Billing Address <span class="bodyheader" style="height: 20px; cursor: hand">&nbsp;&nbsp;
                                    <input id="chkCopyAbove" name="chkCopyAbove" onclick="javascript: copyAsAbove(this);"
                                        type="checkbox" />
                    <span class="style11">
                        <label for="chkCopyAbove">
                            Same as above
                        </label>
                    </span>
                    <label for="chkCopyAbove">
                    </label>
                </span>
                </td>
                <td align="left" bgcolor="#f3f3f3">
                    <span class="bodyheader">City</span></td>
                <td align="left" bgcolor="#f3f3f3">
                    <span class="bodyheader">State/Province</span></td>
            </tr>
            <tr align="left" bgcolor="#f3f3f3" valign="middle">
                <td height="22" align="left" bgcolor="#FFFFFF" class="bodyheader">&nbsp;</td>
                <td rowspan="3" align="left" valign="top" bgcolor="#FFFFFF" class="bodycopy">
                    <span class="style13">Address Line 1</span>
                    <br>
                    <input id="txt_owner_mail_address" class="shorttextfield" name="txt_owner_mail_address"
                        size="40" value="<%=v_owner_mail_address%>">
                    <br>
                    <span class="style13">Address Line 2</span>
                    <br>
                    <input id="txt_owner_mail_address2" class="shorttextfield" name="txt_owner_mail_address2"
                        size="40" value="<%=v_owner_mail_address2%>" maxlength="128"></td>
                <td align="left" bgcolor="#FFFFFF">
                    <table border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                        <tr>
                            <td id='td_owner_mail_city'>
                                <input id="txt_owner_mail_city" class="shorttextfield" name="txt_owner_mail_city"
                                    style="width: 150px;" type="text" value="<%= v_owner_mail_city%>" maxlength="32" /></td>
                            <td id='td_owner_mail_city_href'>
                                <a href="javascript:" class="list" onclick="javascript:actionRequestForAll('owner_mail_city','/IFF_MAIN/asp/ajaxFunctions/ajax_get_all_code.asp?t=owner_mail_city','150px','32');return false;">[List]</a></td>
                        </tr>
                    </table>
                </td>
                <td align="left" bgcolor="#FFFFFF">
                    <table border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                        <tr>
                            <td id='td_owner_mail_state'>
                                <input id="txt_owner_mail_state" class="shorttextfield" name="txt_owner_mail_state"
                                    style="width: 150px;" type="text" value="<%= v_owner_mail_state%>" maxlength="32" /></td>
                            <td id='td_owner_mail_state_href'>
                                <a href="javascript:" class="list" onclick="javascript:actionRequestForAll('owner_mail_state','/IFF_MAIN/asp/ajaxFunctions/ajax_get_all_code.asp?t=owner_mail_state','150px','32');return false;">[List]</a></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr align="left" bgcolor="#f3f3f3" valign="middle">
                <td height="22" align="left" bgcolor="#FFFFFF" class="bodyheader">&nbsp;</td>
                <td align="left" bgcolor="#f3f3f3">
                    <span class="bodyheader">Zip</span></td>
                <td align="left" bgcolor="#f3f3f3">
                    <span class="bodyheader">Country</span></td>
            </tr>
            <tr align="left" bgcolor="#f3f3f3" valign="middle">
                <td height="22" align="left" bgcolor="#FFFFFF" class="bodyheader">&nbsp;</td>
                <td align="left" bgcolor="#FFFFFF">
                    <table border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                        <tr>
                            <td id='td_owner_mail_zip'>
                                <input id="txt_owner_mail_zip" class="shorttextfield" name="txt_owner_mail_zip" style="width: 100px;"
                                    type="text" value="<%= v_owner_mail_zip%>" maxlength="32" /></td>
                            <td id='td_owner_mail_zip_href'>
                                <a href="javascript:" class="list" onclick="javascript:actionRequestForAll('owner_mail_zip','/IFF_MAIN/asp/ajaxFunctions/ajax_get_all_code.asp?t=owner_mail_zip','100px','32');return false;">[List]</a></td>
                        </tr>
                    </table>
                </td>
                <td align="left" bgcolor="#FFFFFF">
                    <table border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                        <tr>
                            <td id='td_owner_mail_country'>
                                <input id="txt_owner_mail_country" class="shorttextfield" name="txt_owner_mail_country"
                                    style="width: 150px;" type="text" value="<%= v_owner_mail_country%>" maxlength="64" /></td>
                            <td id='td_owner_mail_country_href'>
                                <a href="javascript:" class="list" onclick="javascript:actionRequestForAll('owner_mail_country','/IFF_MAIN/asp/ajaxFunctions/ajax_get_country_code.asp','150px','64');return false;">[List]</a></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td height="1" colspan="6" bgcolor="#73beb6"></td>
            </tr>
            <tr align="left" bgcolor="#f3f3f3" valign="middle">
                <td height="22" align="left" bgcolor="#f3f3f3" class="bodyheader">&nbsp;</td>
                <td align="left" valign="middle" bgcolor="#f3f3f3" class="bodyheader">Remarks</td>
                <td align="left" valign="middle" bgcolor="#f3f3f3">
                    <span class="bodyheader">Tax ID/USPPI</span></td>
                <td align="left" valign="middle" bgcolor="#f3f3f3">
                    <span class="bodyheader">Website</span></td>
            </tr>
            <tr align="left" bgcolor="#f3f3f3" valign="middle">
                <td height="22" align="left" bgcolor="#FFFFFF" class="bodyheader">&nbsp;</td>
                <td rowspan="3" align="left" valign="top" bgcolor="#FFFFFF" class="bodycopy">
                    <textarea id="txt_comment" class="multilinetextfield" name="txt_comment" rows="5"
                        style="width: 240px;" wrap="hard" onkeyup="textLimit(this,512);"><%= v_comment %></textarea>
                    <br>
                    <span class="bodyheader">
                        <input type="hidden" name="txt_add_remarks">
                        <a href="javascript:;" onclick="goRemarks(); return false;" id="btnRemark">
                            <img src="/iff_main/ASP/Images/icon_edit.gif" align="absmiddle" />
                            More Remarks</a></span></td>
                <td align="left" valign="middle" bgcolor="#FFFFFF">
                    <span class="bodycopy" style="height: 20px">
                        <input id="txt_business_fed_taxid" class="shorttextfield" name="txt_business_fed_taxid"
                            style="width: 150px" type="text" value="<%=v_business_fed_taxid%>" maxlength="16" />
                    </span>
                </td>
                <td align="left" valign="middle" bgcolor="#FFFFFF">
                    <span class="bodyheader">
                        <input id="txt_business_url" class="shorttextfield" name="txt_business_url" style="width: 180px;"
                            type="text" value="<%=v_business_url%>" maxlength="64" />
                        <a href="javascript:;" onclick="javascript:goWeb('txt_business_url');" style="cursor: pointer"
                            id="bWebSite">
                            <img src="/iff_main/ASP/Images/icon_go.gif" alt="Go to website" width="26" height="16"
                                align="absmiddle"></a></span>
                </td>
            </tr>
            <tr align="left" bgcolor="#f3f3f3" valign="middle">
                <td height="22" align="left" bgcolor="#FFFFFF" class="bodyheader">&nbsp;</td>
                <td align="left" bgcolor="#FFFFFF" class="bodyheader">&nbsp;</td>
                <td align="left" bgcolor="#f3f3f3">
                    <span class="bodyheader" style="visibility: hidden">Client Log-In Information </span>
                </td>
            </tr>
            <tr align="left" bgcolor="#f3f3f3" valign="middle">
                <td height="22" align="left" bgcolor="#FFFFFF" class="bodyheader">&nbsp;</td>
                <td align="left" bgcolor="#FFFFFF">&nbsp;</td>
                <td align="left" bgcolor="#FFFFFF">
                    <table width="250" border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                        <tr>
                            <td width="113">
                                <span class="style13">User Name </span>
                                <input id="txt_web_login_id" class="shorttextfield" name="txt_web_login_id" style="width: 100px;"
                                    type="text" value="<%=v_web_login_id%>" maxlength="32" /></td>
                            <td width="137">
                                <span class="style13">Password </span>
                                <input id="txt_web_login_pin" class="shorttextfield" name="txt_web_login_pin" style="width: 100px;"
                                    type="text" value="<%=v_web_login_pin%>" maxlength="32" /></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr style="height: 10px">
                <td colspan="4"></td>
            </tr>
            <tr>
                <td height="2" colspan="6" bgcolor="#73beb6"></td>
            </tr>
            <tr align="left" bgcolor="#f3f3f3" valign="middle">
                <td width="1%"></td>
                <td height="22" colspan="3" align="left" bgcolor="#ecf7f8" class="bodyheader style7">Contact Information
                </td>
            </tr>
            <tr>
                <td height="1" colspan="6" bgcolor="#73beb6"></td>
            </tr>
            <tr align="left" bgcolor="#f3f3f3" valign="middle">
                <td align="left" bgcolor="#f3f3f3" class="bodyheader">&nbsp;</td>
                <td height="22" align="left" bgcolor="#f3f3f3" class="bodyheader">Contact Person<a href="#"></a></td>
                <td align="left" bgcolor="#f3f3f3">
                    <span class="bodyheader">Title</span></td>
                <td align="left" bgcolor="#f3f3f3">
                    <span class="bodyheader">Department</span></td>
            </tr>
            <tr align="left" bgcolor="#f3f3f3" valign="middle">
                <td height="22" align="left" bgcolor="#FFFFFF" class="bodyheader">&nbsp;</td>
                <td rowspan="3" align="left" valign="top" bgcolor="#FFFFFF" class="bodyheader">
                    <table width="302" border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                        <tr>
                            <td width="112" class="bodycopy style13">First Name
                            </td>
                            <td width="42" class="bodycopy style13">M.I.</td>
                            <td width="148" class="bodycopy style13">Last Name
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <input id="txt_owner_fname" class="shorttextfield" name="txt_owner_fname" style="width: 100px;"
                                    type="text" value="<%= v_owner_fname%>" maxlength="32" /></td>
                            <td>
                                <input id="txt_owner_mname" class="shorttextfield" name="txt_owner_mname" style="width: 30px;"
                                    type="text" value="<%= v_owner_mname%>" maxlength="32" /></td>
                            <td>
                                <input id="txt_owner_lname" class="shorttextfield" name="txt_owner_lname" style="width: 100px;"
                                    type="text" value="<%= v_owner_lname%>" maxlength="32" /></td>
                        </tr>
                    </table>
                </td>
                <td align="left" valign="middle" bgcolor="#FFFFFF">
                    <span class="bodyheader">
                        <input id="txt_owner_title" class="shorttextfield" name="txt_owner_title" style="width: 180px;"
                            value="<%=v_owner_title%>">
                    </span>
                </td>
                <td align="left" valign="middle" bgcolor="#FFFFFF">
                    <span class="bodyheader">
                        <input id="txt_owner_departm" class="shorttextfield" name="txt_owner_departm" style="width: 180px;"
                            value="<%=v_owner_departm%>" maxlength="128">
                    </span>
                </td>
            </tr>
            <tr align="left" bgcolor="#f3f3f3" valign="middle">
                <td height="22" align="left" bgcolor="#FFFFFF" class="bodyheader">&nbsp;</td>
                <td align="left" bgcolor="#f3f3f3">
                    <span class="bodyheader">Cell Phone No. </span>
                </td>
                <td align="left" bgcolor="#f3f3f3">
                    <span class="bodyheader">Email Address</span></td>
            </tr>
            <tr align="left" bgcolor="#f3f3f3" valign="middle">
                <td height="22" align="left" bgcolor="#FFFFFF" class="bodyheader">&nbsp;</td>
                <td align="left" bgcolor="#FFFFFF">
                    <span class="bodyheader">
                        <input id="txt_owner_phone" class="shorttextfield" name="txt_owner_phone" style="width: 110px;"
                            type="text" value="<%= v_owner_phone%>" maxlength="32" />
                        <a href="javascript:;" style="cursor: pointer" onclick="javascript:adjustMask('txt_owner_phone');"
                            alt="Phone number format">
                            <img src="/iff_main/ASP/Images/icon_format.gif" align="absmiddle">
                        </a></span>
                </td>
                <td align="left" bgcolor="#FFFFFF">
                    <span class="bodyheader">
                        <input id="txt_owner_email" class="shorttextfield" name="txt_owner_email" style="width: 160px;"
                            type="text" value="<%= v_owner_email%>" />
                        <a href="javascript:;" onclick="javascript:goMail('txt_owner_email');" style="cursor: pointer"
                            id="button1">
                            <img src="/iff_main/ASP/Images/icon_go.gif" alt="Send email" width="26" height="16"
                                align="absmiddle"></a></span></td>
            </tr>
            <tr>
                <td height="1" colspan="6" bgcolor="#73beb6"></td>
            </tr>
            <tr align="left" bgcolor="#f3f3f3" valign="middle">
                <td height="22" colspan="4" align="left" valign="middle" bgcolor="#FFFFFF" class="bodyheader">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td width="1%" bgcolor="#f3f3f3">&nbsp;</td>
                            <td width="55%" height="22" bgcolor="#f3f3f3" class="bodyheader">2nd Contact Information</td>
                            <td width="44%" bgcolor="#f3f3f3" class="bodyheader">3rd Contact
                            </td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td>
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td colspan="2" class="bodyheader">
                                            <table width="302" border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                                                <tr>
                                                    <td width="109" class="bodycopy style13">First Name
                                                    </td>
                                                    <td width="43" class="bodycopy style13">M.I.</td>
                                                    <td width="150" class="bodycopy style13">Last Name
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <input id="txt_c2FirstName" class="shorttextfield" name="txt_c2FirstName" style="width: 100px;"
                                                            type="text" value="<%= v_c2FirstName%>" maxlength="32" /></td>
                                                    <td>
                                                        <input id="txt_c2MiddleName" class="shorttextfield" name="txt_c2MiddleName" style="width: 30px;"
                                                            type="text" value="<%= v_c2MiddleName%>" maxlength="32" /></td>
                                                    <td>
                                                        <input id="txt_c2LastName" class="shorttextfield" name="txt_c2LastName" style="width: 100px;"
                                                            type="text" value="<%= v_c2LastName%>" maxlength="32" /></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td width="43%" height="18" bgcolor="#f3f3f3" class="bodyheader">Title/Department</td>
                                        <td width="43%" height="18" bgcolor="#f3f3f3" class="bodyheader">&nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <input id="txt_c2Title" class="shorttextfield" name="txt_c2Title" style="width: 180px;"
                                                value="<%=v_c2Title%>" maxlength="128"></td>
                                        <td>&nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td height="18" align="left" valign="middle" bgcolor="#f3f3f3" class="bodyheader">Phone No.
                                        </td>
                                        <td align="left" valign="middle" bgcolor="#f3f3f3" class="bodyheader">Fax No.
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <table border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                                                <tr>
                                                    <td>
                                                        <input id="txt_c2Phone" class="shorttextfield" name="txt_c2Phone" style="width: 110px;"
                                                            type="text" value="<%= v_c2Phone%>" maxlength="32" /></td>
                                                    <td class="bodyheader">
                                                        <a href="javascript:;" style="cursor: pointer" onclick="javascript:adjustMask('txt_c2Phone');">
                                                            <img src="/iff_main/ASP/Images/icon_format.gif" align="absmiddle"></a></td>
                                                    <td class="bodyheader">&nbsp;Ext.&nbsp;</td>
                                                    <td>
                                                        <input id="txt_c2Ext" class="shorttextfield" name="txt_c2Ext" style="width: 40px;"
                                                            type="text" value="<%=v_c2Ext%>" maxlength="16" /></td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td>
                                            <input id="txt_c2Fax" class="shorttextfield" name="txt_c2Fax" style="width: 110px;"
                                                type="text" value="<%= v_c2Fax%>" maxlength="32" /><a href="javascript:;" style="cursor: pointer"
                                                    onclick="javascript:adjustMask('txt_c2Fax');" id="bC2Fax"><img src="/iff_main/ASP/Images/icon_format.gif"
                                                        align="absmiddle" /></a></td>
                                    </tr>
                                    <tr>
                                        <td height="18" bgcolor="#f3f3f3" class="bodyheader">Cell Phone No.
                                        </td>
                                        <td bgcolor="#f3f3f3" class="bodyheader">Email Address</td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <input id="txt_c2Cell" class="shorttextfield" name="txt_c2Cell" style="width: 110px;"
                                                type="text" value="<%= v_c2Cell%>" maxlength="32" />
                                            <a href="javascript:;" style="cursor: pointer" onclick="javascript:adjustMask('txt_c2Cell');"
                                                id="bC2Cell">
                                                <img src="/iff_main/ASP/Images/icon_format.gif" align="absmiddle" alt="Phone number format"></a></td>
                                        <td>
                                            <input id="txt_c2Email" class="shorttextfield" name="txt_c2Email" style="width: 160px;"
                                                type="text" value="<%= v_c2Email%>" maxlength="64" />
                                            <a href="javascript:;" onclick="javascript:goMail('txt_c2Email');" style="cursor: pointer"
                                                id="bC2Email">
                                                <img src="/iff_main/ASP/Images/icon_go.gif" alt="Send email" width="26" height="16"
                                                    align="absmiddle" /></a></td>
                                    </tr>
                                </table>
                            </td>
                            <td align="left" valign="top">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td colspan="2">
                                            <table width="302" border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                                                <tr>
                                                    <td width="110" class="bodycopy style13">First Name
                                                    </td>
                                                    <td width="43" class="bodycopy style13">M.I.</td>
                                                    <td width="149" class="bodycopy style13">Last Name
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <input id="txt_c3FirstName" class="shorttextfield" name="txt_c3FirstName" style="width: 100px;"
                                                            type="text" value="<%= v_c2FirstName%>" /></td>
                                                    <td>
                                                        <input id="txt_c3MiddleName" class="shorttextfield" name="txt_c3MiddleName" style="width: 30px;"
                                                            type="text" value="<%= v_c2MiddleName%>" /></td>
                                                    <td>
                                                        <input id="txt_c3LastName" class="shorttextfield" name="txt_c3LastName" style="width: 100px;"
                                                            type="text" value="<%= v_c2LastName%>" /></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td width="54%" bgcolor="#f3f3f3" class="bodyheader">Title/Department</td>
                                        <td width="46%" bgcolor="#f3f3f3">&nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <input id="txt_c3Title" class="shorttextfield" name="txt_c3Title" style="width: 180px;"
                                                value="<%=v_c3Title%>" maxlength="128"></td>
                                        <td>&nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td height="18" bgcolor="#f3f3f3" class="bodyheader">Phone No.
                                        </td>
                                        <td bgcolor="#f3f3f3" class="bodyheader">Fax No.</td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <table border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                                                <tr>
                                                    <td colspan="2">
                                                        <input id="txt_c3Phone" class="shorttextfield" name="txt_c3Phone" style="width: 110px;"
                                                            type="text" value="<%= v_c3Phone%>" maxlength="32" /></td>
                                                    <td class="bodyheader">
                                                        <a href="javascript:;" style="cursor: pointer" onclick="javascript:adjustMask('txt_c3Phone');"
                                                            id="bC3Phone">
                                                            <img src="/iff_main/ASP/Images/icon_format.gif" align="absmiddle" alt=""></a></td>
                                                    <td class="bodyheader">&nbsp;Ext.&nbsp;</td>
                                                    <td>
                                                        <input id="txt_c3Ext" class="shorttextfield" name="txt_c3Ext" style="width: 40px;"
                                                            type="text" value="<%=v_c3Ext%>" maxlength="16" /></td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td>
                                            <input id="txt_c3Fax" class="shorttextfield" name="txt_c3Fax" style="width: 110px;"
                                                type="text" value="<%= v_c3Fax%>" maxlength="32" />
                                            <a href="javascript:;" style="cursor: pointer" onclick="javascript:adjustMask('txt_c3Fax');"
                                                id="bC3Fax">
                                                <img src="/iff_main/ASP/Images/icon_format.gif" align="absmiddle" alt="Phone number format"></a></td>
                                    </tr>
                                    <tr>
                                        <td height="18" bgcolor="#f3f3f3" class="bodyheader">Cell Phone No.
                                        </td>
                                        <td bgcolor="#f3f3f3" class="bodyheader">Email Address</td>
                                    </tr>
                                    <tr>
                                        <td height="18" bgcolor="#FFFFFF" class="bodyheader">
                                            <input id="txt_c3Cell" class="shorttextfield" name="txt_c3Cell" style="width: 110px;"
                                                type="text" value="<%= v_c3Cell%>" maxlength="32" /><a href="javascript:;" onclick="javascript:adjustMask('txt_c3Cell');"
                                                    style="cursor: hand" id="bC3Cell"><img src="/iff_main/ASP/Images/icon_format.gif"
                                                        align="absmiddle" alt="Phone number format" /></a></td>
                                        <td align="left" valign="middle" bgcolor="#FFFFFF" class="bodyheader">
                                            <input id="txt_c3Email" class="shorttextfield" name="txt_c3Email" style="width: 160px;"
                                                type="text" value="<%= v_c3Email%>" maxlength="64" />
                                            <a href="javascript:;" style="cursor: pointer" onclick="javascript:goMail('txt_c3Email');"
                                                id="bC3Email">
                                                <img src="/iff_main/ASP/Images/icon_go.gif" alt="Send email" width="26" height="16"
                                                    align="absmiddle"></a></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <!-- end of general information -->
            <!-- start of addtional contact -->
            <tr align="left" bgcolor="#f3f3f3" valign="middle">
                <td align="left" bgcolor="#f3f3f3">&nbsp;</td>
                <td height="22" align="left" bgcolor="#f3f3f3" class="bodyheader">
                    <input type="hidden" name="txt_add_contact">
                    <span class="bodyheader"><a href="javascript:;" onclick="return goAddContact(); return false;"
                        id="btnContact">
                        <img src="/iff_main/ASP/Images/icon_edit.gif" align="absmiddle">More Contacts</a></td>
                <td align="left" bgcolor="#f3f3f3">
                    <!--	
													<input id="btnContact" class="bodycopy" onClick="return goAddContact();" style="width: 120px; background-color: #f4f2e8" type="button" value="Additional Contact">
													-->
                </td>
                <td align="left" bgcolor="#f3f3f3">&nbsp;</td>
            </tr>
        </table>

        <!-- end of additional contact -->
        <!-- start of business information -->
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td height="2" colspan="5" bgcolor="#73beb6"></td>
            </tr>
            <tr align="left" bgcolor="#f3f3f3" valign="middle">
                <td bgcolor="#ecf7f8"></td>
                <td height="22" colspan="4" bgcolor="#ecf7f8" class="bodyheader style7">Business Information
                </td>
            </tr>
            <tr>
                <td height="1" colspan="5" bgcolor="#73beb6"></td>
            </tr>
            <tr>
                <td width="1%">&nbsp;</td>
                <td height="18" colspan="2" align="left" valign="middle" class="bodyheader">
                    <span class="bodycopy">Business Type</span><span style="height: 20px; cursor: pointer; margin-left: 20px"><input id="all_Click" name="all_Click" onclick="javascript: allClick(this);"
                        type="checkbox" />
                        <span class="style11">
                            <label for="all_Click">
                                Select All Types
                            </label>
                        </span>
                        <label for="all_Click">
                        </label>
                    </span>
                </td>
                <td></td>
                <td>
                    <span class="bodycopy"><span class="bodyheader">Default Broker</span></span></td>
            </tr>
            <tr>
                <td bgcolor="#FFFFFF">&nbsp;</td>
                <td colspan="3" align="left" valign="top" bgcolor="#FFFFFF">
                    <table border="0" bordercolor="#ffffff" cellpadding="0" cellspacing="0" class="bodycopy"
                        width="100%">
                        <tr>
                            <td height="6" colspan="5" align="left" valign="middle" bgcolor="#FFFFFF"></td>
                        </tr>
                        <tr>
                            <td width="133" align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                <input id="chk_is_consignee" <% if v_is_consignee="y" then response.write("checked") %>=""
                                    name="chk_is_consignee" onclick="javascript: cClick(this);" type="checkbox" value="Y" />
                                <label for="chk_is_consignee">
                                    Consignee</label></td>
                            <td colspan="2" align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                <table border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                                    <tr>
                                        <td width="41%" align="left" valign="middle" id='td_SubConsignee'>
                                            <input id="txt_SubConsignee" class="shorttextfield" name="txt_SubConsignee" style="width: 120px;"
                                                type="text" value="<%= v_SubConsignee%>" /></td>
                                        <td width="59%" id='td_SubConsignee_href'>
                                            <a href="javascript:" class="list" onclick="javascript:actionRequestForAll('SubConsignee','/IFF_MAIN/asp/ajaxFunctions/ajax_get_all_code.asp?t=SubConsignee','120px');return false;">[List]</a></td>
                                    </tr>
                                </table>
                            </td>
                            <td width="124" align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                <input id="chk_is_shipper" <% if v_is_shipper="y" then response.write("checked") %>=""
                                    name="chk_is_shipper" onclick="javascript: cClick(this);" type="checkbox" value="Y" />
                                <label for="chk_is_shipper">
                                    Shipper</label>
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                            <td width="347" align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                <table border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                                    <tr>
                                        <td id='td_SubShipper'>
                                            <input id="txt_SubShipper" class="shorttextfield" name="txt_SubShipper" style="width: 120px;"
                                                type="text" value="<%= v_SubShipper%>" /></td>
                                        <td id='td_SubShipper_href'>
                                            <a href="javascript:" class="list" onclick="javascript:actionRequestForAll('SubShipper','/IFF_MAIN/asp/ajaxFunctions/ajax_get_all_code.asp?t=SubShipper','120px');return false;">[List]</a></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy"></td>
                            <td width="164" align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy"></td>
                            <td width="82" align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy"></td>
                            <td align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy"></td>
                            <td align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy"></td>
                        </tr>
                        <tr>
                            <td align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                <input id="chk_is_agent" <% if v_is_agent="y" then response.write("checked") %>=""
                                    name="chk_is_agent" onclick="javascript: cClick(this);" type="checkbox" value="Y" />
                                <label for="chk_is_agent">
                                    Agent</label></td>
                            <td colspan="2" align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                <table border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                                    <tr>
                                        <td width="41%" align="left" valign="middle" id='td_SubAgent'>
                                            <input id="txt_SubAgent" class="shorttextfield" name="txt_SubAgent" style="width: 120px;"
                                                type="text" value="<%= v_SubAgent%>" /></td>
                                        <td width="59%" id='td_SubAgent_href'>
                                            <a href="javascript:" class="list" onclick="javascript:actionRequestForAll('SubAgent','/IFF_MAIN/asp/ajaxFunctions/ajax_get_all_code.asp?t=SubAgent','120px');return false;">[List]</a></td>
                                    </tr>
                                </table>
                            </td>
                            <td align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                <input id="chk_is_carrier" <% if v_is_carrier="y" then response.write("checked") %>=""
                                    name="chk_is_carrier" onclick="javascript: cClick(this);" type="checkbox" value="Y" />
                                <label for="chk_is_carrier">
                                    Carrier</label>
                                &nbsp;&nbsp;</td>
                            <td align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                <table border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                                    <tr>
                                        <td id='td_SubCarrier'>
                                            <input id="txt_SubCarrier" class="shorttextfield" name="txt_SubCarrier" style="width: 120px;"
                                                type="text" value="<%= v_SubCarrier%>" /></td>
                                        <td id='td_SubCarrier_href'>
                                            <a href="javascript:" class="list" onclick="javascript:actionRequestForAll('SubCarrier','/IFF_MAIN/asp/ajaxFunctions/ajax_get_all_code.asp?t=SubCarrier','120px');return false;">[List]</a></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy" style="height: 20px">
                                <input id="chk_z_is_trucker" <% if v_z_is_trucker="y" then response.write("checked") %>=""
                                    name="chk_z_is_trucker" onclick="javascript: cClick(this);" type="checkbox" value="Y" />
                                <label for="chk_z_is_trucker">
                                    Trucker</label></td>
                            <td colspan="2" align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy" style="height: 20px">
                                <table border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                                    <tr>
                                        <td width="41%" align="left" valign="middle" id='td_SubTrucker'>
                                            <input id="txt_SubTrucker" class="shorttextfield" name="txt_SubTrucker" style="width: 120px;"
                                                type="text" value="<%= v_SubTrucker%>" /></td>
                                        <td width="59%" id='td_SubTrucker_href'>
                                            <a href="javascript:" class="list" onclick="javascript:actionRequestForAll('SubTrucker','/IFF_MAIN/asp/ajaxFunctions/ajax_get_all_code.asp?t=SubTrucker','120px');return false;">[List]</a></td>
                                    </tr>
                                </table>
                            </td>
                            <td align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                <input id="chk_z_is_warehousing" <% if v_z_is_warehousing="y" then response.write("checked") %>=""
                                    name="chk_z_is_warehousing" onclick="javascript: cClick(this);" type="checkbox"
                                    value="Y" />
                                <label for="chk_z_is_warehousing">
                                    Warehouse</label>
                            </td>
                            <td align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                <table border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                                    <tr>
                                        <td id='td_SubWarehousing'>
                                            <input id="txt_SubWarehousing" class="shorttextfield" name="txt_SubWarehousing" style="width: 120px;"
                                                type="text" value="<%= v_SubWarehousing%>" /></td>
                                        <td id='td_SubWarehousing_href'>
                                            <a href="javascript:" class="list" onclick="javascript:actionRequestForAll('SubWarehousing','/IFF_MAIN/asp/ajaxFunctions/ajax_get_all_code.asp?t=SubWarehousing','120px');return false;">[List]</a></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                <input id="chk_z_is_cfs" <% if v_z_is_cfs="y" then response.write("checked") %>=""
                                    name="chk_z_is_cfs" onclick="javascript: cClick(this);" type="checkbox" value="Y" />
                                <label for="chk_z_is_cfs">
                                    Terminal/CFS</label></td>
                            <td colspan="2" align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                <table border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                                    <tr>
                                        <td width="41%" align="left" valign="middle" id='td_SubCFS'>
                                            <input id="txt_SubCFS" class="shorttextfield" name="txt_SubCFS" style="width: 120px;"
                                                type="text" value="<%= v_SubCFS%>" /></td>
                                        <td width="59%" id='td_SubCFS_href'>
                                            <a href="javascript:" class="list" onclick="javascript:actionRequestForAll('SubCFS','/IFF_MAIN/asp/ajaxFunctions/ajax_get_all_code.asp?t=SubCFS','120px');return false;">[List]</a></td>
                                    </tr>
                                </table>
                            </td>
                            <td align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                <input id="chk_z_is_broker" <% if v_z_is_broker="y" then response.write("checked") %>=""
                                    name="chk_z_is_broker" onclick="javascript: cClick(this);" type="checkbox" value="Y" />
                                <label for="chk_z_is_broker">
                                    CHB</label>
                            </td>
                            <td align="left" valign="middle" bgcolor="#FFFFFF">
                                <table border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                                    <tr>
                                        <td id='td_SubBroker'>
                                            <input id="txt_SubBroker" class="shorttextfield" name="txt_SubBroker" style="width: 120px;"
                                                type="text" value="<%= v_SubBroker%>" /></td>
                                        <td id='td_SubBroker_href'>
                                            <a href="javascript:" class="list" onclick="javascript:actionRequestForAll('SubBroker','/IFF_MAIN/asp/ajaxFunctions/ajax_get_all_code.asp?t=SubBroker','120px');return false;">[List]</a></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                <input id="chk_z_is_govt" <% if v_z_is_govt="y" then response.write("checked") %>=""
                                    name="chk_z_is_govt" onclick="javascript: cClick(this);" type="checkbox" value="Y" />
                                <label for="chk_z_is_govt">
                                    Gov't</label></td>
                            <td colspan="2" align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                <table border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                                    <tr>
                                        <td width="41%" align="left" valign="middle" id='td_SubGovt'>
                                            <input id="txt_SubGovt" class="shorttextfield" name="txt_SubGovt" type="text" style="width: 120px;"
                                                value="<%= v_SubGovt%>" /></td>
                                        <td width="59%" id='td_SubGovt_href'>
                                            <a href="javascript:" class="list" onclick="javascript:actionRequestForAll('SubGovt','/IFF_MAIN/asp/ajaxFunctions/ajax_get_all_code.asp?t=SubGovt','120px');return false;">[List]</a></td>
                                    </tr>
                                </table>
                            </td>
                            <td align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                <input id="chk_is_vendor" <% if v_is_vendor="y" then response.write("checked") %>=""
                                    name="chk_is_vendor" onclick="javascript: cClick(this);" type="checkbox" value="Y" />
                                <label for="chkEmpty">
                                    Vendor</label></td>
                            <td align="left" valign="middle" bgcolor="#FFFFFF">
                                <table border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                                    <tr>
                                        <td id='td_SubVendor'>
                                            <input id="txt_SubVendor" class="shorttextfield" name="txt_SubVendor" type="text"
                                                style="width: 120px;" value="<%= v_SubVendor%>" /></td>
                                        <td id='td_SubVendor_href'>
                                            <a href="javascript:" class="list" onclick="javascript:actionRequestForAll('SubVendor','/IFF_MAIN/asp/ajaxFunctions/ajax_get_all_code.asp?t=SubVendor','120px');return false;">[List]</a></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                <input id="chk_z_is_special" <% if v_z_is_special="y" then response.write("checked") %>=""
                                    name="chk_z_is_special" onclick="javascript: cClick(this);" type="checkbox" value="Y" />
                                <label for="chk_z_is_special">
                                    Other</label></td>
                            <td colspan="2" align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                <table border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                                    <tr>
                                        <td width="41%" align="left" valign="middle" id='td_SubSpecial'>
                                            <input id="txt_SubSpecial" class="shorttextfield" name="txt_SubSpecial" style="width: 120px;"
                                                type="text" value="<%= v_SubSpecial%>" /></td>
                                        <td width="59%" id='td_SubSpecial_href'>
                                            <a href="javascript:" class="list" onclick="javascript:actionRequestForAll('SubSpecial','/IFF_MAIN/asp/ajaxFunctions/ajax_get_all_code.asp?t=SubSpecial','120px'); return false;">[List]</a></td>
                                    </tr>
                                </table>
                            </td>
                            <td align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                <input style="visibility: hidden" id="chk_is_customer" <% if v_is_customer="y" then response.write("checked") %>=""
                                    name="chk_is_customer" onclick="javascript: cClick(this);" type="checkbox" value="Y" />
                                <label style="visibility: hidden" for="chkEmpty">
                                    Customer</label>
                            </td>
                            <td colspan="2" align="left" valign="middle" bgcolor="#FFFFFF">
                                <table border="0" cellpadding="0" cellspacing="0" class="bodycopy" style="visibility: hidden">
                                    <tr>
                                        <td id='td_SubCustomer'>
                                            <input id="txt_SubCustomer" class="shorttextfield" name="txt_SubCustomer" type="text"
                                                style="width: 120px;" value="<%= v_SubCustomer%>" /></td>
                                        <td id='td_SubCustomer_href'>
                                            <a href="javascript:" class="list" onclick="javascript:actionRequestForAll('SubCustomer','/IFF_MAIN/asp/ajaxFunctions/ajax_get_all_code.asp?t=SubCustomer','120px');return false;">[List]</a></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
                <td width="34%" align="left" valign="top" bgcolor="#FFFFFF">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td align="left" valign="top">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td id='td_defaultBrokerName'>
                                            <input id="txt_defaultBrokerName" class="shorttextfield" name="txt_defaultBrokerName"
                                                style="width: 220px;" type="text" value="<%= v_DefaultBrokerName%>" maxlength="128" /></td>
                                        <td width="61%" align="left" valign="middle" class="bodycopy" id="td_defaultBrokerName_href">
                                            <a href="javascript:" class="list" onclick="javascript:actionRequestForAll('defaultBrokerName','/IFF_MAIN/asp/ajaxFunctions/ajax_get_organization_list.asp?t=defaultBrokerName','220px','128');return false;">[List]</a></td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <span class="bodycopy" style="height: 20px">
                                                <textarea id="txt_broker_info" class="multilinetextfield" cols="40" name="txt_broker_info"
                                                    rows="5" wrap="hard" onkeyup="return checkMaxRows(this);"><%= v_broker_info %></textarea>
                                            </span>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td height="1" colspan="5" bgcolor="#73beb6"></td>
            </tr>
            <tr>
                <td align="left" valign="middle" bgcolor="#f3f3f3">&nbsp;</td>
                <td width="18%" align="left" bgcolor="#f3f3f3">
                    <div style="display: inline; height: 18px; padding-top: 3px" class="bodyheader">
                        SCAC Code (Ocean)
                    </div>
                    <% if mode_begin then %>
                    <div style="width: 21px; display: inline;" onmouseover="showtip('This is typically two to four alphabetic letters to identify freight carriers.');"
                        onmouseout="hidetip()">
                        <img src="../Images/button_info.gif">
                    </div>
                    <% end if %>
                </td>
                <td width="20%" align="left" valign="middle" bgcolor="#f3f3f3">
                    <div style="display: inline; height: 18px; padding-top: 3px" class="bodyheader">
                        IATA Airline Code
                    </div>
                    <% if mode_begin then %>
                    <div style="width: 21px; display: inline;" onmouseover="showtip('This is two-character codes assigned by the International Air Transport Association. Example: AA for America Airline');"
                        onmouseout="hidetip()">
                        <img src="../Images/button_info.gif">
                    </div>
                    <% end if %>
                </td>
                <td width="27%" align="left" valign="middle" bgcolor="#f3f3f3">
                    <div style="display: inline; height: 18px; padding-top: 3px" class="bodyheader">
                        Airline Prefix Code
                    </div>
                    <% if mode_begin then %>
                    <div style="width: 21px; display: inline;" onmouseover="showtip('This is three-numeric codes. Example: 988 for Asiana Airline');"
                        onmouseout="hidetip()">
                        <img src="../Images/button_info.gif">
                    </div>
                    <% end if %>
                </td>
                <td height="18" align="left" valign="middle" bgcolor="#f3f3f3" class="bodyheader">ICC MC No. (Domestic Freight Ground)
                </td>
            </tr>
            <tr>
                <td bgcolor="#FFFFFF">&nbsp;</td>
                <td align="left" valign="top" bgcolor="#FFFFFF">
                    <span class="bodycopy" style="height: 20px"><span class="bodycopy" style="height: 20px">
                        <input id="txt_carrier_id" class="shorttextfield" name="txt_carrier_id" style="width: 100px"
                            type="text" value="<%=v_carrier_id%>" maxlength="16" />
                    </span></span>
                </td>
                <td align="left" valign="top" bgcolor="#FFFFFF">
                    <span class="bodycopy" style="height: 20px">
                        <input id="txtAirLineCode" class="shorttextfield" name="txtAirLineCode" style="width: 100px"
                            type="text" onblur="ToUpCase(this)" value="<%=vAirLineCode%>" maxlength="2" />
                    </span>
                </td>
                <td bgcolor="#FFFFFF">
                    <span class="bodycopy" style="height: 20px"><span class="bodycopy" style="height: 20px">
                        <input id="txt_carrier_code" class="shorttextfield" name="txt_carrier_code" type="text"
                            value="<%=v_carrier_code%>" style="behavior: url(../include/igNumDotChkLeft.htc); width: 100px"
                            maxlength="3" />
                    </span></span>
                </td>
                <td bgcolor="#FFFFFF">
                    <input id="txt_ICC_MC" class="shorttextfield" name="txt_ICC_MC" style="width: 100px;"
                        value="<%=v_ICC_MC%>" maxlength="64"></td>
            </tr>
            <tr>
                <td align="left" valign="middle" bgcolor="#f3f3f3">&nbsp;</td>
                <td height="18" align="left" valign="middle" bgcolor="#f3f3f3" class="bodyheader">C.H.L No.</td>
                <td align="left" valign="middle" bgcolor="#f3f3f3" class="bodyheader">Firms Code</td>
                <td align="left" valign="middle" bgcolor="#f3f3f3" class="bodyheader">FF Account No.</td>
                <td rowspan="2" bgcolor="#FFFFFF" class="bodyheader"></td>
            </tr>
            <tr>
                <td bgcolor="#FFFFFF">&nbsp;</td>
                <td align="left" valign="top" bgcolor="#FFFFFF">
                    <span class="bodycopy" style="height: 20px">
                        <input id="txt_z_chl_no" class="shorttextfield" name="txt_z_chl_no" style="width: 100px"
                            type="text" value="<%=v_z_chl_no%>" maxlength="16" />
                    </span>
                </td>
                <td align="left" valign="top" bgcolor="#FFFFFF">
                    <span class="bodycopy" style="height: 20px"><span class="bodycopy" style="height: 20px">
                        <input id="txt_z_firm_code" class="shorttextfield" name="txt_z_firm_code" style="width: 100px"
                            type="text" value="<%=v_z_firm_code%>" maxlength="16" />
                    </span></span>
                </td>
                <td align="left" valign="top" bgcolor="#FFFFFF">
                    <span class="bodycopy" style="height: 20px"><span class="bodycopy" style="height: 20px">
                        <input id="txt_z_firm_code" class="shorttextfield" name="txt_FF_account" style="width: 100px"
                            type="text" value="<%=v_FF_account%>" maxlength="16" />
                    </span></span>
                </td>
            </tr>
        </table>
        <br />
        <!-- end of business information -->
        <!-- start of billing information -->
        <!-- manager access informations" -->
        <div <%if UserRight <> 9 then response.write "style='display:none'"%>>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td height="2" bgcolor="#73beb6" colspan="2"></td>
                </tr>
                <tr>
                    <td width="45%" align="left" valign="top">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td bgcolor="#ecf7f8" class="bodyheader">&nbsp;</td>
                                <td height="22" bgcolor="#ecf7f8" class="bodyheader">
                                    <span class="bodyheader style7">Accounting Information </span>
                                </td>
                                <td bgcolor="#ecf7f8" class="bodyheader">&nbsp;</td>
                            </tr>
                            <tr>
                                <td height="1" colspan="3" bgcolor="#73beb6"></td>
                            </tr>
                            <tr>
                                <td width="2%" bgcolor="#f3f3f3" class="bodyheader">&nbsp;</td>
                                <td width="40%" height="18" bgcolor="#f3f3f3" class="bodyheader">Invoice Term
                                </td>
                                <td width="58%" bgcolor="#f3f3f3" class="bodyheader">Credit Amount</td>
                            </tr>
                            <tr>
                                <td bgcolor="#FFFFFF" class="bodyheader">&nbsp;</td>
                                <td bgcolor="#FFFFFF" class="bodyheader">
                                    <input id="txt_bill_term" class="shorttextfield" name="txt_bill_term" type="text"
                                        style="behavior: url(../include/igNumDotChkLeft.htc); width: 100px" value="<%=v_bill_term%>"
                                        maxlength="4" /></td>
                                <td bgcolor="#FFFFFF" class="bodyheader">
                                    <input id="txt_credit_amt" class="shorttextfield" name="txt_credit_amt" type="text"
                                        style="behavior: url(../include/igNumDotChkLeft.htc); width: 100px" value="<%=v_credit_amt%>"
                                        maxlength="9" /></td>
                            </tr>
                            <tr>
                                <td height="18" align="left" valign="middle" bgcolor="#f3f3f3" class="bodyheader">&nbsp;</td>
                                <td height="18" align="left" valign="middle" bgcolor="#f3f3f3" class="bodyheader">Invoice ATTN.
                                </td>
                                <td height="18" align="left" valign="middle" bgcolor="#f3f3f3" class="bodyheader">&nbsp;</td>
                            </tr>
                            <tr>
                                <td bgcolor="#FFFFFF"></td>
                                <td colspan="2" bgcolor="#FFFFFF" class="bodyheader">
                                    <input id="txt_z_attn_txt" class="shorttextfield" name="txt_z_attn_txt" size="50"
                                        value="<%=v_z_attn_txt%>" maxlength="50"></td>
                            </tr>
                            <tr>
                                <td bgcolor="#FFFFFF" class="bodyheader">&nbsp;</td>
                                <td bgcolor="#FFFFFF" class="bodyheader">&nbsp;</td>
                                <td bgcolor="#FFFFFF" class="bodyheader">&nbsp;</td>
                            </tr>
                            <tr>
                                <td bgcolor="#FFFFFF" class="bodyheader">&nbsp;</td>
                                <td bgcolor="#FFFFFF" class="bodyheader">&nbsp;</td>
                                <td bgcolor="#FFFFFF" class="bodyheader">&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                    <td width="55%" valign="top">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td height="22" bgcolor="#ecf7f8">&nbsp;</td>
                            </tr>
                            <tr>
                                <td height="1" colspan="3" bgcolor="#73beb6"></td>
                            </tr>
                            <tr>
                                <td height="18" bgcolor="#f3f3f3">
                                    <span class="bodyheader">Bank Name </span>
                                </td>
                            </tr>
                            <tr>
                                <td bgcolor="#FFFFFF">
                                    <input id="txt_z_bank_name" class="shorttextfield" name="txt_z_bank_name" style="width: 270px"
                                        value="<%= v_z_bank_name%>" maxlength="50"></td>
                            </tr>
                            <tr>
                                <td height="18" align="left" valign="middle" bgcolor="#f3f3f3">
                                    <span class="bodyheader">Account No.</span></td>
                            </tr>
                            <tr>
                                <td bgcolor="#FFFFFF">
                                    <span class="bodycopy" style="height: 20px">
                                        <input id="txt_z_bank_account_no" class="shorttextfield" name="txt_z_bank_account_no"
                                            style="width: 270px" type="text" value="<%=v_z_bank_account_no%>" maxlength="20" />
                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <td height="18" align="left" valign="middle" bgcolor="#f3f3f3">
                                    <span class="bodyheader">Print Check As </span>
                                </td>
                            </tr>
                            <tr>
                                <td bgcolor="#FFFFFF">
                                    <input id="txt_print_check_as" class="shorttextfield" name="txt_print_check_as" style="width: 270px"
                                        value="<%=v_print_check_as%>" maxlength="128"></td>
                            </tr>
                            <tr>
                                <td bgcolor="#FFFFFF">
                                    <span class="bodyheader"><span class="bodycopy" style="height: 20px">
                                        <textarea id="txt_print_check_as_info" class="multilinetextfield" cols="50" name="txt_print_check_as_info"
                                            rows="5" wrap="hard" onkeyup="return checkMaxRows(this);"><%= v_broker_info %></textarea>
                                    </span></span>
                                </td>
                            </tr>
                        </table>
                        <br />
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td height="2" colspan="4" bgcolor="#73beb6"></td>
                            </tr>
                            <tr>
                                <td width="1%" bgcolor="#ecf7f8">&nbsp;</td>
                                <td width="22%" height="22" align="left" bgcolor="#ecf7f8" class="bodyheader style7">Managerial Information
                                </td>
                                <td width="23%" align="left" bgcolor="#ecf7f8">&nbsp;</td>
                                <td width="54%" align="left" bgcolor="#ecf7f8">&nbsp;</td>
                            </tr>
                            <tr>
                                <td height="1" colspan="4" bgcolor="#73beb6"></td>
                            </tr>
                            <tr>
                                <td bgcolor="#f3f3f3">&nbsp;</td>
                                <td bgcolor="#f3f3f3" class="bodyheader">Agent Account No.
                                                <input type="hidden" name="txt_coloader_elt_acct" value="<%= v_coloader_elt_acct%>"></td>
                                <td bgcolor="#f3f3f3" class="bodyheader">&nbsp;</td>
                                <td bgcolor="#f3f3f3">&nbsp;</td>
                            </tr>
                            <tr>
                                <td bgcolor="#FFFFFF">&nbsp;</td>
                                <td bgcolor="#FFFFFF" class="bodyheader">
                                    <table border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                                        <tr>
                                            <td align="left" valign="middle" id='td_coloader_elt_acct_name_href'>
                                                <!--<a href="javascript:" onClick="javascript:actionRequestForAll('coloader_elt_acct_name','/IFF_MAIN/asp/ajaxFunctions/ajax_get_organization_list.asp?t=coloader_elt_acct_name','150px','64');return false;">[List]</a>-->
                                                <span class="bodycopy" style="height: 20px">
                                                    <input id="txt_agent_elt_acct" class="shorttextfield" name="txt_agent_elt_acct" type="text"
                                                        value="<%=v_agent_elt_acct%>" style="behavior: url(../include/igNumDotChkLeft.htc); widows: 100px" />
                                                </span>
                                            </td>
                                            <td id='td_coloader_elt_acct_name_href'>&nbsp;</td>
                                            <td id='td_coloader_elt_acct_name_href'>
                                                <input id="txt_coloader_elt_acct_name" class="shorttextfield" name="txt_coloader_elt_acct_name"
                                                    style="width: 150px;" type="hidden" value="<%= v_coloader_elt_acct_name%>" maxlength="64" /></td>
                                        </tr>
                                    </table>
                                </td>
                                <td bgcolor="#FFFFFF" class="bodyheader">
                                    <input id="chk_is_coloader" <% if v_is_coloader="y" then response.write("checked") %>=""
                                        name="chk_is_coloader" onclick="javascript: cClick(this);" type="checkbox" />
                                    <label for="chk_is_coloader">
                                        Enable Coloading</label>
                                    <% if mode_begin then %>
                                    <div style="width: 21px; display: inline; vertical-align: text-bottom" onmouseover="showtip('If this business is also a member of Freight Easy, checking this box will allow for the electrionic transfer of HAWB information between their account and your own for coload purposes.');"
                                        onmouseout="hidetip()">
                                        <img src="../Images/button_info.gif" align="absmiddle" class="bodylistheader">
                                    </div>
                                    <% end if %>
                                </td>
                                <td bgcolor="#FFFFFF">
                                    <span class="bodyheader">
                                        <input id="chk_edt" <% if v_edt="y" then response.write("checked") %>="" name="chk_edt"
                                            onclick="javascript: cClick(this);" type="checkbox" />
                                        <label for="chk_edt">
                                            Enable EDT</label>
                                    </span>
                                    <% if mode_begin then %>
                                    <div style="width: 21px; display: inline; vertical-align: text-bottom" onmouseover="showtip('Checking this will enable Electronic Data Transfer between the FE account of this business and yours for such features as the Deconsolidation Queue.  ');"
                                        onmouseout="hidetip()">
                                        <img src="../Images/button_info.gif" align="absmiddle" class="bodylistheader">
                                    </div>
                                    <% end if %>
                                </td>
                            </tr>
                            <tr>
                                <td bgcolor="#f3f3f3">&nbsp;</td>
                                <td bgcolor="#f3f3f3" class="bodyheader">Sales Rep.
                                </td>
                                <td bgcolor="#f3f3f3">
                                    <span class="bodyheader">Referred By </span>
                                </td>
                                <td bgcolor="#f3f3f3">
                                    <span class="bodyheader">
                                        <input id="txt_org_account_number" class="shorttextfield" name="txt_org_account_number"
                                            type="hidden" value="<%=v_org_account_number%>" style="width: 100%; text-align: center; border-style: none; background-color: #f3f3f3" />
                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <td align="left" valign="middle" bgcolor="#FFFFFF">&nbsp;</td>
                                <td height="36" align="left" valign="top" bgcolor="#FFFFFF">
                                    <table border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                                        <tr>
                                            <td id='td_salesperson'>
                                                <input id="txt_salesperson" class="shorttextfield" name="txt_salesperson" style="width: 150px;"
                                                    type="text" value="<%= v_salesperson%>" maxlength="32" /></td>
                                            <td id='td_salesperson_href'>
                                                <a href="javascript:" class="list" onclick="javascript:actionRequestForAll('salesperson','/IFF_MAIN/asp/ajaxFunctions/ajax_get_all_code.asp?t=salesperson','150px','32');return false;">[List]</a></td>
                                        </tr>
                                    </table>
                                </td>
                                <td align="left" valign="top" bgcolor="#FFFFFF">
                                    <table border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                                        <tr>
                                            <td id='td_refferedBy'>
                                                <input id="txt_refferedBy" class="shorttextfield" name="txt_refferedBy" style="width: 150px;"
                                                    type="text" value="<%= v_refferedBy%>" maxlength="32" /></td>
                                            <td id='td_refferedBy_href'>
                                                <a href="javascript:" class="list" onclick="javascript:actionRequestForAll('refferedBy','/IFF_MAIN/asp/ajaxFunctions/ajax_get_all_code.asp?t=refferedBy','150px','32');return false;">[List]</a></td>
                                        </tr>
                                    </table>
                                </td>
                                <td align="left" valign="top" bgcolor="#FFFFFF"></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
        <!-- manager access informations end -->
        <table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td width="183" height="1" colspan="7" bgcolor="#73beb6"></td>
            </tr>
            <!-- end of billing information -->
            <!-- start of Managerial information -->
            <!--
                                                <tr align="left" bgcolor="#f3f3f3" valign="middle">
                                                    <td align="left"></td>
                                                    <td align="left" bgcolor="#f3f3f3" class="bodyheader" height="22">&nbsp;</td>
                                                  <td align="left" bgcolor="#f3f3f3"><span class="bodyheader"><img height="9" name="bNext" onClick="javascript:PrevNext(0);"
                                                src='../Images/left_arrow_end.gif' style="cursor: hand" width="7">
                                                &nbsp;&nbsp;&nbsp;&nbsp;
                                                <img height="9" name="bNext" onClick="javascript:PrevNext(1);" src='../Images/left_arrow.gif'
                                                    style="cursor: hand" width="7">
<input id="txt_lessOrGreaterBottom" class="bodyheader" name="txt_lessOrGreaterBottom" style="width: 100px; text-align:center; border-style:none; background-color:#f3f3f3" type="text"  readonly="true"/>
                                                <img height="9" name="bNext" onClick="javascript:PrevNext(2);" src='../Images/right_arrow.gif'
                                                    style="cursor: hand" width="7">
                                                &nbsp;&nbsp;&nbsp;&nbsp;
                                                <img height="9" name="bNext" onClick="javascript:PrevNext(3);" src='../Images/right_arrow_end.gif'
                                                    style="cursor: hand" width="7"></span></td>
                                                  <td align="left" bgcolor="#f3f3f3">&nbsp;</td>
                                                </tr>
												-->
        </table>

        <!-- end of Managerial information -->
        <table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td width="26%"></td>
                <td width="48%" align="center">
                    <a href="javascript:;" onclick="saveOrganization(1);" style="cursor: pointer">
                        <img height="18" name="bSave" src="../images/button_save_medium.gif" width="46" /></a></td>
                <td width="13%" align="right" valign="middle">
                    <a href="javascript:;" onclick="javascript:client_new();" style="cursor: pointer">
                        <img src="/iff_main/ASP/Images/button_new.gif" width="42" height="17" border="0"
                            id="bNew" /></a></td>
                <td width="13%" align="right" valign="middle">
                    <a href="javascript:;" onclick="javascript:saveOrganization(2);" style="cursor: pointer">
                        <img src="../images/button_delete_medium.gif" width="51" height="17" id="bDelete"
                            name="bDeleteHAWB"></a></td>
            </tr>
        </table>

        <br>
    </form>
</body>

<script language="javascript" type="text/javascript" src="../ajaxFunctions/ajax.js"></script>

<script language="javascript" type="text/javascript" src="../ajaxFunctions/otherFunctions.js"></script>

<script language="javascript" type="text/javascript" src="../include/edit_mask.js"></script>

<script language="javascript">

    function textLimit(field, maxlen) {
        if (field.value.length > maxlen + 1)
            alert('Your input has exceeded the maximum character!');
        if (field.value.length > maxlen)
            field.value = field.value.substring(0, maxlen);
    }
    function checkMaxRows(txtObj) {
        var nomoretext = false;
        var str = txtObj.value;
        var allowedRows = txtObj.getAttribute("rows");
        var allowedCols = txtObj.getAttribute("cols");
        var lines = str.split("\r\n");

        if (lines.length > allowedRows) {
            if (window.event.keyCode != 8 && (window.event.keyCode < 37 || window.event.keyCode > 40)) {
                alert("Can't add more line!")
                nomoretext = true;
                txtObj.value = "";
                for (var i = 0; i < allowedRows; i++) {
                    if (i == allowedRows - 1) {
                        txtObj.value = txtObj.value + lines[i];
                    }
                    else {
                        txtObj.value = txtObj.value + lines[i] + "\n";
                    }
                }
            }
        }
        return !nomoretext;
    }
</script>

<script language="javascript">
    function get_post_parameters(oForm, actType) {
        var all = oForm.all;
        var str = '';
        for (i = 0; i < all.length; i++) {
            var tagType = all[i].type;
            if (tagType == 'text' || tagType == 'checkbox' || tagType == 'hidden' || tagType == 'textarea') {
                if (!all[i].readonly) {
                    switch (tagType) {
                        case 'hidden':
                            str += all[i].name + "=" + escape(all[i].value) + "&";
                            break;
                        case 'textarea':
                            str += all[i].name + "=" + escape(all[i].value) + "&";
                            break;
                        case 'text':
                            str += all[i].name + "=" + escape(all[i].value) + "&";
                            break;
                        case 'checkbox':
                            if (all[i].checked) {
                                str += all[i].name + "=Y&";
                            } else {
                                str += all[i].name + "=&";
                            }
                            break;
                        default:
                            break;
                    }
                }
            }
        }
        return str;
    }
    function display_msg(str) {
        alert(str);
    }

    function client_new() {
        document.form1.reset();
        document.form1.txt_dba_name.value = '';
        reset_dba_field();
    }
    function reset_dba_field() {
        var url = '/IFF_MAIN/asp/ajaxFunctions/ajax_get_all_code.asp?t=dba_name';
        makeTextBox('txt_dba_name', 'td_dba_name', 'lst_dba_name', '250px', '128', 'td_dba_name_href', 'actionRequestForAll', 'dba_name', url);
    }
    function saveOrganization(actType) {

        if (actType == 1) { // save
            if (org_validation()) {
                var post_parameter = get_post_parameters(document.form1, actType);
                var url = '/IFF_MAIN/asp/ajaxFunctions/ajax_modify_dba.asp?Action=save';
                new ajax.xhr.Request('POST', post_parameter, url, showResponseSaveResult, '', '', '');
            }
        } else if (actType == 2) { // delete
            var iOrg = parseInt(document.getElementById('txt_org_account_number').value);
            if (iOrg > 0) {
                var record_list = check_transaction_with_org_for_delete(iOrg)
                if (record_list == null) {
                    if (confirm('Do you really want to delete this Client profile?')) {
                        var url = '/IFF_MAIN/asp/ajaxFunctions/ajax_modify_dba.asp?Action=del&org=' + iOrg;
                        new ajax.xhr.Request('POST', '', url, showResponseDelResult, '', '', '');
                    }
                } else {
                    recheck_org_for_delete(iOrg, record_list);
                }
            } else { alert('Please select a Client to delete.'); }
        } else if (actType == 4) { // data Transfer
            var iOrg = parseInt(document.getElementById('txt_org_account_number').value);
            var orginal_dba_name = document.getElementById('txt_orginal_dba_name').value;
            if (iOrg > 0) {

                if (!confirm('* Warning *\n\nThis function will merge all data from this client into the client selected on the next screen.\nAfter this action is completed, any system data that had belonged to this client will no longer be accessible\nby the old client name.\n\nWould you like to continue?')) { return false; }

                var retVal = showModalDialog("client_data_Transfer.asp?PostBack=false&src="
                                                + iOrg
                                                + "&dba=" + encodeURIComponent(orginal_dba_name),
                                                "TransClient", "dialogWidth:600px; dialogHeight:380px; help:0; status:0; scroll:0;center:1;Sunken;");
            } else {
                alert('Please select a source Client.');
            }
        } else if (actType == 5) { // Adjust Data
            var iOrg = parseInt(document.getElementById('txt_org_account_number').value);
            if (iOrg > 0) {
                if (!confirm('* Information *\n\nThis will allow you to update old data with current client profile in the system.\nWould you like to continue?')) { return false; }
                adjust_data(iOrg, true);
            } else {
                alert('Please select a Client.');
            }
        }
    }

    function recheck_org_for_delete(org, str) {
        var sourceCode = str;
        if (trim(sourceCode) != '') {
            sourceCode = "* Warning *\n\nThe system has found existing transactional data belonging to this client.\nIt is strongly recommended that you transfer this data to another client before deleting\n in order to avoid data inconsistency.\n"
                         + "====================================================\n"
                         + sourceCode + "\n"
                         + "====================================================\n"
                         + "Would you like to transfer all data to another client before deleting?\n"
                         + "Pressing 'Ok' will continue to the first step for tranfering.";

            if (confirm(sourceCode)) {
                var orginal_dba_name = document.getElementById('txt_orginal_dba_name').value;
                var retVal = showModalDialog("client_data_Transfer.asp?PostBack=false&src="
                + org
                + "&dba=" + encodeURIComponent(orginal_dba_name),
                "TransClient", "dialogWidth:600px; dialogHeight:370px; help:0; status:0; scroll:0;center:1;Sunken;");
                var record_list = check_transaction_with_org_for_delete(org);
                if (record_list == null) {
                    if (confirm('Do you really want to delete this Client profile?')) {
                        var url = '/IFF_MAIN/asp/ajaxFunctions/ajax_modify_dba.asp?Action=del&org=' + org;
                        new ajax.xhr.Request('POST', '', url, showResponseDelResult, '', '', '');
                    }
                } else {
                    sourceCode = '* Warning *\n\nSorry,The system still has found existing transactional data belonging to this client.\n'
                                 + '====================================================\n'
                                 + record_list
                                 + '====================================================\nPlease contact ELT administrator for deleting this client.';
                    alert(sourceCode);
                    return false
                }

            }
            return false;
        }
    }
    function adjust_after_saving(iOrg) {

        var orginal_dba_name = document.getElementById('txt_orginal_dba_name').value;
        var new_dba_name = document.getElementById('txt_dba_name').value;

        orginal_dba_name = verify_dba_name(orginal_dba_name);
        new_dba_name = verify_dba_name(new_dba_name);

        var iOrg = parseInt(document.getElementById('txt_org_account_number').value);
        if ((orginal_dba_name != '') && (orginal_dba_name != new_dba_name) && (iOrg > 0)) {
            adjust_data(iOrg, false);
        }
    }
    function showResponseSaveResult(req, field, tmpVal, tWidth, tMaxLength, url, post_parameter) {
        if (req.readyState == 4) {
            if (req.status == 200) {
                var tmpVal = req.responseText.substring(req.responseText.indexOf(':') + 1);
                if (tmpVal) {
                    document.all.txt_org_account_number.value = tmpVal;
                    adjust_after_saving(tmpVal);
                    display_msg('Client profile of [' + document.all.txt_dba_name.value + '] was saved successfully.');
                    document.getElementById('txt_orginal_dba_name').value = document.all.txt_dba_name.value;
                }
                else {
                    document.write(req.responseText);
                }

            }
            else {
                document.write(req.responseText);
            }
        }
    }
    function showResponseDelResult(req, field, tmpVal, tWidth, tMaxLength, url, post_parameter) {
        if (req.readyState == 4) {
            if (req.status == 200) {
                var tmpVal = req.responseText.substring(req.responseText.indexOf(':') + 1);
                if (tmpVal) {
                    var tmpDba = document.all.txt_dba_name.value;
                    document.form1.reset();
                    display_msg('Client profile of [' + tmpDba + '] was deleted successfully.');
                    document.form1.reset();
                    document.form1.txt_dba_name.value = '';
                    reset_dba_field();
                }
                else {
                    document.write(req.responseText);
                }
            }
            else {
                document.write(req.responseText);
            }
        }
    }

    function verify_dba_name(s) {
        while (s.indexOf("\"") != -1) { s = s.replace("\"", "''"); }
        return s;
    }
    function org_validation() {
        var orginal_dba_name = document.getElementById('txt_orginal_dba_name').value;
        var new_dba_name = document.getElementById('txt_dba_name').value;

        orginal_dba_name = verify_dba_name(orginal_dba_name);
        new_dba_name = verify_dba_name(new_dba_name);

        var iOrg = parseInt(document.getElementById('txt_org_account_number').value);
        if ((orginal_dba_name != new_dba_name) && (iOrg > 0)) {

            if (!check_transaction_with_org(iOrg)) {
                return false;
            }
        }
        if (!isEmpty(trim(document.form1.txt_coloader_elt_acct_name.value))) {
            if (document.form1.txt_coloader_elt_acct.value == document.form1.txt_agent_elt_acct.value) {
                alert('Please select another Coloadee!');
                if (document.getElementById('lst_coloader_elt_acct_name')) {
                    document.form1.lst_coloader_elt_acct_name.focus();
                } else {
                    document.form1.txt_coloader_elt_acct_name.focus();
                }
                return false;
            }
        }
        if (document.form1.chk_is_coloader.checked || document.form1.chk_edt.checked) {
            if (isEmpty(trim(document.form1.txt_agent_elt_acct.value)) || document.form1.txt_agent_elt_acct.value == 0) {
                alert('Please enter the Agent Acct. No.\n for coloader and/or EDT!');
                document.form1.txt_agent_elt_acct.focus();
                return false;
            }
        }
        if (!isEmpty(trim(document.form1.txt_z_chl_no.value))) {
            if (!isInteger(document.form1.txt_z_chl_no.value)) {
                alert("Please enter a numeric value for C.H.L No.");
                document.form1.txt_z_chl_no.focus();
                return false;
            }
        }
        if (isEmpty(new_dba_name)) {
            alert("Please enter a business name!");
            document.form1.txt_dba_name.focus();
            return false;
        }

        if (document.form1.chk_is_carrier.checked) {
            //		if(document.form1.txt_z_firm_code.value=="") {
            //			alert("Please input the Firms code");
            //			document.form1.txt_z_firm_code.focus();
            //			return false;
            //		}
            if (!isEmpty(trim(document.form1.txt_carrier_code.value)) && isEmpty(trim(document.form1.txtAirLineCode.value))) {
                alert("Please input the Air Line Code.");
                document.form1.txtAirLineCode.focus();
                return false;
            }
            if (isEmpty(trim(document.form1.txt_carrier_id.value))
                && isEmpty(trim(document.form1.txtAirLineCode.value))
                && isEmpty(trim(document.form1.txt_ICC_MC.value))) {
                alert("Please input the SCAC code or Air Line Code");
                document.form1.txt_carrier_id.focus();
                return false;
            }
            if (!isEmpty(trim(document.form1.txtAirLineCode.value)) && isEmpty(trim(document.form1.txt_carrier_code.value))) {
                alert("Please input the Carrier prefix.");
                document.form1.txt_carrier_code.focus();
                return false;
            }
        }
        if (check_org_data((iOrg > 0 ? 'U' : 'C'), iOrg, new_dba_name, document.form1.txt_carrier_code.value)) {
            return true;
        }

        return false;
    }
    function create_direct_xmlHTTP() {
        if (window.ActiveXObject) {
            try {
                xmlHTTP = new ActiveXObject("Msxml2.XMLHTTP");
            } catch (e) {
                try {
                    xmlHTTP = new ActiveXObject("Microsoft.XMLHTTP");
                } catch (e1) {
                    alert('Your browser does not support this method!\nPlease upgrade your browser.');
                    return false;
                }
            }
        } else if (window.XMLHttpRequest) {
            xmlHTTP = new XMLHttpRequest();
        } else {
            alert('Your browser does not support this method!\nPlease upgrade your browser.');
            return false;
        }
        return xmlHTTP;
    }
    function check_transaction_with_org(org) {
        var xmlHTTP = create_direct_xmlHTTP();
        if (!xmlHTTP) { return false; }
        //		try {    
        xmlHTTP.open("get", "/iff_main/asp/ajaxFunctions/ajax_check_transaction_client.asp?src=" + org, false);
        xmlHTTP.send();
        var sourceCode = xmlHTTP.responseText;
        if (sourceCode) {
            if (trim(sourceCode) != '') {
                sourceCode = '* Warning *\n\nThe DBA name was changed!\nThe following record(s) will be affected for Data consistency.\n'
                             + '\n==========================\n'
                             + sourceCode
                             + '\n==========================\n';
                sourceCode += '\nDo you really want to change DBA name?\n'
                if (!confirm(sourceCode)) {
                    return false;
                }
            }
        }
        //		} catch (e) {}	
        return true;
    }
    function check_transaction_with_org_for_delete(org) {
        var xmlHTTP = create_direct_xmlHTTP();
        if (!xmlHTTP) { return false; }
        //		try {    
        xmlHTTP.open("get", "/iff_main/asp/ajaxFunctions/ajax_check_transaction_client.asp?src=" + org, false);
        xmlHTTP.send();
        var sourceCode = xmlHTTP.responseText;
        if (sourceCode) {
            return sourceCode;
        }
        //		} catch (e) {}	
        return null;
    }

    function adjust_data(src, msg) {
        var xmlHTTP = create_direct_xmlHTTP();
        if (!xmlHTTP) { return false; }
        try {
            xmlHTTP.open("get", "/iff_main/asp/ajaxFunctions/ajax_transfer_client.asp?src=" + src + "&target=" + src, false);
            xmlHTTP.send();
            var sourceCode = xmlHTTP.responseText;
            if (sourceCode) {
                if (sourceCode == 'ok') {
                    if (msg) {
                        alert('Adjusted successfully!');
                    }
                } else {
                    document.write(req.responseText);
                }
            }
        } catch (e) { }
    }
    function check_org_data(cType, org, strDbaName, air_prefix) {
        var xmlHTTP = create_direct_xmlHTTP();
        if (!xmlHTTP) { return false; }

        var url = "/IFF_MAIN/asp/ajaxFunctions/ajax_chkdata_organization.asp"
                    + "?t=" + cType
                    + "&o=" + org
                    + "&s=" + encodeURIComponent(strDbaName)
                    + "&pre=" + encodeURIComponent(air_prefix);

        //    try {    
        xmlHTTP.open("get", url, false);
        xmlHTTP.send();
        var sourceCode = xmlHTTP.responseText;
        if (sourceCode) {
            if (trim(sourceCode) == 'ok') {
                return true;
            }
            else {
                switch (trim(sourceCode)) {
                    case 'error#0':
                        alert('call type error!');
                        break;
                    case 'error#1':
                        alert('Invalid acct num for update!');
                        break;
                    case 'error#2':
                        alert('Invalid DBA name!');
                        break;
                    case 'error#3':
                        if (confirm('DBA Name [' + strDbaName + '] exists already.\nDo you want to save anyway?')) {
                            return true;
                        }
                        break;
                    default:
                        var eStr = sourceCode.substring(0, sourceCode.indexOf(':'));
                        switch (eStr) {
                            case 'error#4':
                                if (confirm('The Carrier Prefix ('
                                    + air_prefix
                                    + ') already being used by ['
                                    + sourceCode.substring(sourceCode.indexOf(':') + 1) + '].'
                                    + '\nDo you want to save anyway?')) { return true; }
                                break;
                            case 'error#3':
                                if (confirm('Please check the followings.\nThe DBA Name :\n=========================\n'
                                + sourceCode.substring(sourceCode.indexOf(':') + 1) + ''
                                + '\n=========================\nexists already.\nDo you want to save anyway?')) { return true; }
                                break;
                            default:
                                alert(sourceCode);
                                break;
                        }
                        break;
                }
                return false;
            }
        }

        //    }   catch(e) {}

    }

    function set_lst_country(oSelect, listValue) {
        var items = oSelect.options;
        for (var i = 0; i < items.length; i++) {
            var item = items[i];
            if (item.text.toLowerCase().indexOf(listValue.toLowerCase()) == 0) {

                oSelect.selectedIndex = i;
                on_lst_business_country_change(oSelect);
                return;
            }
        }
    }

    function setSelectionValue_for_listup(oSelect, listValue) {
        if (oSelect) {
            if (oSelect.id == 'lst_dba_name' || oSelect.id == 'lst_business_country' || oSelect.id == 'lst_owner_mail_country') {
                var items = oSelect.options;
                for (var i = 0; i < items.length; i++) {
                    var item = items[i];
                    if (item.text.toLowerCase() == listValue.toLowerCase()) {
                        oSelect.selectedIndex = i;
                        break;
                    }
                }
            }
            else if (oSelect.id == 'lst_defaultBrokerName') {
                set_default_broker(oSelect, listValue);
            }
            else if (oSelect.id == 'lst_coloader_elt_acct_name') {
                set_default_broker(oSelect, listValue);
            }
            else {
                var items = oSelect.options;
                for (var i = 0; i < items.length; i++) {
                    var item = items[i];
                    if (trim(item.value.toLowerCase()) == trim(listValue.toLowerCase())) {
                        oSelect.selectedIndex = i;
                        break;
                    }
                }
            }
        }
    }
    function set_default_broker(oSelect, listValue) {
        if (trim(listValue) == '') {
            oSelect.selectedIndex = -1;
            return;
        }

        var items = oSelect.options;
        for (var i = 0; i < items.length; i++) {
            var item = items[i];
            if (item.text.toLowerCase() == listValue.toLowerCase()) {
                oSelect.selectedIndex = i;
                return;
            }
        }
    }
    function setSelectionValue(listName, listValue) {
        var oSelect = document.getElementById(listName);
        if (oSelect) {
            switch (listName) {
                case 'lst_owner_mail_country':
                    set_lst_country(oSelect, listValue);
                    break;
                case 'lst_business_country':
                    set_lst_country(oSelect, listValue);
                    break;
                case 'lst_defaultBrokerName':
                    set_default_broker(oSelect, listValue);
                    break;
                    break;
                case 'lst_coloader_elt_acct_name':
                    set_default_broker(oSelect, listValue);
                    break;
                    break;
                case 'lst_dba_name':
                    var items = oSelect.options;
                    for (var i = 0; i < items.length; i++) {
                        var item = items[i];
                        if (item.text.toLowerCase().indexOf(listValue.toLowerCase()) == 0) {
                            oSelect.selectedIndex = i;
                            on_lst_dba_name_change(oSelect);
                            return;
                        }
                    }
                    break;
                default:
                    break;
            }
            var items = oSelect.options;
            for (var i = 0; i < items.length; i++) {
                var item = items[i];
                if (trim(item.value.toLowerCase()) == trim(listValue.toLowerCase())) {
                    oSelect.selectedIndex = i;
                    break;
                }
            }
        }
    }

    // Prev Next
    function actionRequestForPrevNext(i) {
        var strDbaName = document.all.txt_dba_name.value;
        var org_account_number = document.all.txt_org_account_number.value;
        var strAction

        switch (i) {
            case -1:
                strAction = 'this';
                break;
            case 0:
                strAction = 'first';
                break;
            case 1:
                strAction = 'prev';
                break;
            case 2:
                strAction = 'next';
                break;
            case 3:
                strAction = 'last';
                break;
            case 4:
                strAction = 'getByOrg';
                break;
        }
        var filterStr = trim(document.getElementById('filter_string').value);
        var url = "/IFF_MAIN/asp/ajaxFunctions/ajax_get_organization_PrevNext.asp"
					+ "?s=" + encodeURIComponent(strDbaName)
					+ "&o=" + org_account_number
					+ "&f=" + encodeURIComponent(filterStr)
					+ "&Action=" + strAction;
        if (strAction == 'getByOrg') {
            document.getElementById('filter_string').value = '';
        }
        new ajax.xhr.Request('GET', '', url, showResponsePrevNext, '', '', '');
    }

    function showResponsePrevNext(req, field, tmpVal, tWidth, tMaxLength, url, post_parameter) {
        if (req.readyState == 4) {
            if (req.status == 200) {
                prevNextMain(req);
                setClearBtn();
                set_all_phone_mask();
                set_remarks();
                set_contact();
            }
            else {
                document.write(req.responseText);
            }
        }
    }
    function set_remarks() {
        var txt = document.getElementById('txt_add_remarks');
        var btn = document.getElementById('btnRemark');
        if (txt.value == 'Y') {
            btn.style.background = '#FFFF00';
        } else {
            btn.style.background = '#f4f2e8';

        }
    }

    function set_contact() {
        var txt = document.getElementById('txt_add_contact');
        var btn = document.getElementById('btnContact');
        if (txt.value == 'Y') {
            btn.style.background = '#FFFF00';
        } else {
            btn.style.background = '#f4f2e8';
        }
    }

    function prevNextMain(xmlHttp) {
        var xmlData = xmlHttp.responseXML;
        var itemNode = xmlData.getElementsByTagName("item");
        var codeNode = xmlData.getElementsByTagName("itemcode");
        var descNode = xmlData.getElementsByTagName("itemdesc");
        var itemLength = itemNode.length;
        if (itemLength == 0) {
            document.Write(xmlHttp.responseText);
        }

        var resultXML = "", cd, ds, txtField

        for (i = 0; i < itemLength; i++) {
            try {
                cd = codeNode[i].childNodes[0].nodeValue;
                ds = descNode[i].childNodes[0].nodeValue;
            }
            catch (e) { ds = ""; }

            chkField = document.getElementById('chk_' + cd);
            if (chkField) {
                set_checkbox_field(chkField, ds);
                continue;
            }
            txtField = document.getElementById('txt_' + cd);
            lstField = document.getElementById('lst_' + cd);
            if (lstField) {
                setSelectionValue_for_listup(lstField, ds)
            }
            if (txtField) {
                txtField.value = ds;
            }
        }
        document.getElementById('txtAirLineCode').value = "";
        if (trim(document.getElementById('txt_carrier_code').value) != "") {
            document.getElementById('txtAirLineCode').value = document.getElementById('txt_carrier_id').value;
            document.getElementById('txt_carrier_id').value = "";
        }
        document.getElementById('txt_orginal_dba_name').value = document.getElementById('txt_dba_name').value;

    }

    function set_checkbox_field(chkField, ds) {
        if (chkField.id == 'chk_account_status') {
            if (ds == '') {
                chkField.checked = true;
            }
            else {
                chkField.checked = false;
            }
        } else {
            if (ds == 'Y') {
                chkField.checked = true;
            }
            else {
                chkField.checked = false;
            }
        }
    }

    function goSearch(strGroupName) {
        var oTxtClass = document.getElementById('txt_' + strGroupName);
        var param = 'PostBack=false&default=' + encodeURIComponent(oTxtClass.value) + '&filter=' + document.getElementById('filter_string').value;
        var retVal = showModalDialog("../Include/all_dba_manage.asp?" + param, "AllDba", "dialogWidth:620px; dialogHeight:720px; help:0; status:0; scroll:0;center:1;Sunken;");
        get_dba_by_filter(retVal);
        try {
            if (retVal != '' && typeof (retVal) != 'undefined') {
                gather_list_again(strGroupName, oSelect.style.width, retVal);
            }
        } catch (f) { }
    }

    function clear_filter() {
        actionRequestForPrevNext(-1);
        document.getElementById('filter_string').value = '';
    }

    function on_lst_business_country_change(oSelect) {
        change_country(oSelect);
    }

    function on_lst_owner_mail_country_change(oSelect) {
        change_country(oSelect);
    }
    function get_dba_by_filter(retVal) {

        try {
            if (retVal.indexOf(':') > 0) {
                document.getElementById('filter_string').value = '';
                var strAction = 'filter';
                var url = "/IFF_MAIN/asp/ajaxFunctions/ajax_get_organization_PrevNext.asp?c=" + encodeURIComponent(retVal) + "&f=''&Action=" + strAction;
                new ajax.xhr.Request('GET', '', url, showResponsePrevNext, '', '', '');
                var aFilter = retVal.split(':');

                if (aFilter.length > 2) {
                    document.getElementById('filter_string').value = retVal;
                }
            }
        } catch (f) { }
    }

    function edit_country(oSelect) {
        var strGroupName = oSelect.id.substring(oSelect.id.indexOf('lst_') + 4);
        var oTxtClass = document.getElementById('txt_' + strGroupName);
        var param = 'PostBack=false&type=' + strGroupName + '&default=' + oTxtClass.value;
        var retVal = showModalDialog("../Include/all_country_manage.asp?" + param, "AllCountry", "dialogWidth:660px; dialogHeight:398px; help:0; status:0; scroll:0;center:1;Sunken;");

        try {
            if (retVal != '' && typeof (retVal) != 'undefined') {
                gather_list_again_country(strGroupName, oSelect.style.width, retVal);
            }
        } catch (f) { }
    }

    function edit_scheduleB() {
        var acc_num = document.getElementById('txt_org_account_number').value;
        var dba_name = document.getElementById('txt_orginal_dba_name').value;
        if (!acc_num) {
            alert('Please select a Client! or Please save the Client data.');
            return false;
        }
        viewPop("/IFF_MAIN/ASPX/Onlines/ScheduleB/SBSelect.aspx?OrgID=" + acc_num);
        return false;
    }

    function edit_Rate() {
        var acc_num = document.getElementById('txt_org_account_number').value;
        var dba_name = document.getElementById('txt_orginal_dba_name').value;
        if (!acc_num) {
            alert('Please select a Client! or Please save the Client data.');
            return false;
        }
        viewPop("/IFF_MAIN/ASPX/OnLines/Rate/RateManagement.aspx?WindowName=PopWin&ff=" + acc_num + "&nn=" + encodeURIComponent(dba_name));
        return false;
    }

    function change_country(oSelect) {

        var text = oSelect.options[oSelect.options.selectedIndex].value;
        if (text == '_edit') {
            oSelect.options.selectedIndex = 0;
            edit_country(oSelect);
        }

        try {
            var strGroupName = oSelect.id.substring(oSelect.id.indexOf('lst_') + 4);
            document.getElementById('txt_' + strGroupName).value = oSelect.options[oSelect.options.selectedIndex].text;
        } catch (e) { }
    }

    function on_lst_dba_name_change(oSelect) {
        var text = oSelect.options[oSelect.options.selectedIndex].value;
        if (text == '_edit') {
            oSelect.options.selectedIndex = 0;
            edit_dba_name(oSelect);
        }

        try {
            document.getElementById('txt_dba_name').value = oSelect.options[oSelect.options.selectedIndex].text;
            document.getElementById('txt_org_account_number').value = oSelect.options[oSelect.options.selectedIndex].value;
        } catch (e) { }
        actionRequestForPrevNext(-1);
    }

    function edit_dba_name(oSelect) {
        var strGroupName = oSelect.id.substring(oSelect.id.indexOf('lst_') + 4);
        var oTxtClass = document.getElementById('txt_' + strGroupName);
        var param = 'PostBack=false&type=' + strGroupName + '&default=' + oTxtClass.value;
        var retVal = showModalDialog("../Include/all_dba_manage.asp?" + param, "AllDba", "dialogWidth:615px; dialogHeight:690px; help:0; status:0; scroll:0;center:1;Sunken;");

        try {
            if (retVal != '' && typeof (retVal) != 'undefined') {
                gather_list_again(strGroupName, oSelect.style.width, retVal);
            }
        } catch (f) { }
    }
    function on_lst_coloader_elt_acct_name_change(oSelect) {
        var text = oSelect.options[oSelect.options.selectedIndex].value;
        try {
            document.getElementById('txt_coloader_elt_acct').value = text;
            document.getElementById('txt_coloader_elt_acct_name').value = oSelect.options[oSelect.options.selectedIndex].text;
        } catch (e) { }
    }
    function on_lst_defaultBrokerName_change(oSelect) {
        var text = oSelect.options[oSelect.options.selectedIndex].value;
        try {
            document.getElementById('txt_defaultBroker').value = text.substring(0, text.indexOf('-'));
            document.getElementById('txt_broker_info').value = text.substring(text.indexOf('-') + 1);
            document.getElementById('txt_defaultBrokerName').value = oSelect.options[oSelect.options.selectedIndex].text;
        } catch (e) { }
    }
    /** end of on change for selection **/

    /** dialog boxes **/
    function on_lst_change(ListBoxName) {
        this.objName = ListBoxName;
        this.onchange = common_on_change;
    }

    function common_on_change() {
        var oSelect = document.getElementById(this.objName);
        var text = oSelect.options[oSelect.options.selectedIndex].value;
        if (text == '_edit') {
            oSelect.options.selectedIndex = 0;
            edit_all_code(oSelect);
        }
        else {
            var strGroupName = oSelect.id.substring(oSelect.id.indexOf('lst_') + 4);
            try {
                var oTxtClass = document.getElementById('txt_' + strGroupName);
                oTxtClass.value = text;
            } catch (f) { }
        }
    }

    function edit_all_code(oSelect) {
        var strGroupName = oSelect.id.substring(oSelect.id.indexOf('lst_') + 4);
        var oTxtClass = document.getElementById('txt_' + strGroupName);
        var param = 'PostBack=false&type=' + strGroupName + '&default=' + oTxtClass.value;
        var retVal = showModalDialog("../Include/all_code_manage.asp?" + param, "AllCode", "dialogWidth:490px; dialogHeight:366px; help:0; status:0; scroll:0;center:1;Sunken;");


        try {
            if (retVal != '' && typeof (retVal) != 'undefined') {
                gather_list_again(strGroupName, oSelect.style.width, retVal);
                if (strGroupName.indexOf('_city') > 0 || strGroupName.indexOf('_state') > 0 || strGroupName.indexOf('_zip') > 0) {
                    strGroupName = (strGroupName.indexOf('_mail_') > 0) ? strGroupName.replace('owner_mail', 'business') : strGroupName.replace('business', 'owner_mail');
                    var nSelect = document.getElementById('lst_' + strGroupName);
                    if (nSelect) {
                        gather_list_again(strGroupName, nSelect.style.width, retVal);
                    }
                    else {
                        gather_list_again(strGroupName, oSelect.style.width, retVal);
                    }
                }
            }
        } catch (f) { }
    }

    /** etc **/
    function goWeb(txtName) {
        var txtUrl = document.getElementById(txtName).value.replace('http://', '');
        if (txtUrl != "") {
            var Url = 'http://' + txtUrl;
            window.open(Url, '_blank', '');
            return false;
        }
    }

    function goMail(txtName) {
        var txtEmail = document.getElementById(txtName).value;
        if (validateEmail(txtEmail)) {
            if (txtEmail != "") {
                location.href = 'mailto:' + txtEmail;
            }
        }
    }
    function jPopUpPDFc() {
        var argS = 'menubar=1,toolbar=1,height=600,width=900,hotkeys=0,scrollbars=1,resizable=1';
        popUpPDF = window.open('', 'popUpPDF', argS);
    }

    function viewPDF() {
        var iOrg = parseInt(document.getElementById('txt_org_account_number').value);
        if (iOrg > 0) {
            var Url = 'clientProfile_pdf.asp?client=' + iOrg;
            window.location.href = Url;
            //window.open(Url,'_blank', 'height=600,width=900,scrollbars=1,resizable=1');

            return false;

        } else {
            alert('Plese select a Client!');
            return false;
        }
    }
    function adjustMask(name) {
        var oMask = document.getElementById(name + '_mask');
        if (oMask) {
            var param = 'PostBack=false&country=' + oMask.value;
        }
        else {
            var param = 'PostBack=false';
        }

        var retVal = showModalDialog("../Include/CountryPhoneMask.asp?" + param, "PhoneFormat", "dialogWidth:480px; dialogHeight:470px; help:0; status:0; scroll:0;center:1;Sunken;");

        if (retVal) {
            set_phone_mask(name, retVal);
        }
    }

    function set_phone_mask(name, retVal) {
        var o = document.getElementById(name);
        if (!o) return;
        var props = retVal.split("^");
        var original_phone_prefix = '';

        if (props[3] != '') {
            original_phone_prefix = '(' + trim(props[3]) + ')';
        }
        if (trim(props[0]) != '') { // country code
            var oMask = document.getElementById(name + '_mask');
            if (oMask) {
                oMask.value = props[0];
            }
            var oMask_exp = document.getElementById(name + '_mask_pre');
            if (oMask_exp) {
                oMask_exp.value = props[1];
            }
            var oMask_exp = document.getElementById(name + '_mask_exp');
            if (oMask_exp) {
                oMask_exp.value = props[2];
            }
        }

        props[1] = trim(props[1]); // country phone prefix
        if (props[1] != '' || original_phone_prefix != '') {
            if (o.value.substring(0, original_phone_prefix.length) == original_phone_prefix) {
                o.value = o.value.substring(original_phone_prefix.length)
            }
        }
        props[2] = trim(props[2]) // phone mask
        set_phone_format(o, props[1], props[2]);
    }

    function set_all_phone_mask() {
        set_mask_phone_with_id('business_phone');
        set_mask_phone_with_id('business_phone2');
        set_mask_phone_with_id('owner_phone');
        set_mask_phone_with_id('business_fax');
        set_mask_phone_with_id('c2Phone');
        set_mask_phone_with_id('c2Cell');
        set_mask_phone_with_id('c3Fax');
        set_mask_phone_with_id('c3Phone');
        set_mask_phone_with_id('c3Cell');
        set_mask_phone_with_id('c3Fax');

    }
    function set_mask_phone_with_id(id) {
        try {
            var obj = document.getElementById('txt_' + id);

            var o = igedit_all['txt_' + id];
            var p_pre_o = trim(document.getElementById('txt_' + id + '_mask_pre').value);
            var p_exp_o = trim(document.getElementById('txt_' + id + '_mask_exp').value);

            var prefix = '';
            if (p_pre_o != '') {
                prefix = '(' + p_pre_o + ')';
            }
            var mask = '';
            if (p_exp_o != '') {
                mask = p_exp_o;
            } else {
                mask = 'CCCCCCCCCCCCCCCCCCCC';
            }

            if (p_pre_o != '' && obj.value.indexOf(')') > 0) {

                if (prefix == obj.value.substring(0, obj.value.indexOf(')') + 1)) {
                    obj.value = obj.value.substring(obj.value.indexOf(')') + 1);
                }
            }

            var tmpStr = trim(obj.value);

            if (mask != 'CCCCCCCCCCCCCCCCCCCC') {
                tmpStr = clear_mask(tmpStr);
            }

            if (o) {
                o.setInputMask(prefix + mask);
            } else {
                igedit_init(obj.name, 1, obj.name + ",,1,,,,0,1,1,,,0,1,,-1,", [tmpStr, prefix + mask, "   10"]);
                o = igedit_all['txt_' + id];
            }
            o.setValue(tmpStr);
        } catch (f) { }


        if (obj.onfocus == null) {
            var f_onfocus = new on_focus(obj.id);
            obj.onfocus = function () { f_onfocus.onfocus(); };
        }

    }

    function on_focus(txtId) {
        this.objName = txtId;
        this.onfocus = common_on_focus;
    }

    function common_on_focus() {
        var id = this.objName;
        var o = document.getElementById(id);
        var p_pre_o = document.getElementById(id + '_mask_pre');
        var p_exp_o = document.getElementById(id + '_mask_exp');

        if (o) {
            if (p_pre_o.value != '') {
                p_pre_o.value = trim(p_pre_o.value);
            }
            if (p_exp_o.value != '') {
                p_exp_o.value = trim(p_exp_o.value);
            }

            if (p_pre_o.value && o.value.indexOf(')') > 0) {
                if (('(' + p_pre_o.value + ')') == o.value.substring(0, o.value.indexOf(')') + 1)) {
                    o.value = o.value.substring(o.value.indexOf(')') + 1);
                }
            }
            if (p_exp_o.value != '') {
                set_phone_format(o, p_pre_o.value, p_exp_o.value);
            }
        }
    }

    function cClick(o) {
        if (o.checked) {
            o.value = 'Y';
        }
        else {
            o.value = '';
        }

    }

    function allClick(a) {
        if (a.checked) {
            a.value = 'Y';
            document.getElementById("chk_is_consignee").value = 'Y';
            document.getElementById("chk_is_consignee").checked = true;
            document.getElementById("chk_is_agent").value = 'Y';
            document.getElementById("chk_is_agent").checked = true;
            document.getElementById("chk_is_shipper").value = 'Y';
            document.getElementById("chk_is_shipper").checked = true;
            document.getElementById("chk_is_carrier").value = 'Y';
            document.getElementById("chk_is_carrier").checked = true;
            document.getElementById("chk_z_is_trucker").value = 'Y';
            document.getElementById("chk_z_is_trucker").checked = true;
            document.getElementById("chk_z_is_warehousing").value = 'Y';
            document.getElementById("chk_z_is_warehousing").checked = true;
            document.getElementById("chk_z_is_cfs").value = 'Y';
            document.getElementById("chk_z_is_cfs").checked = true;
            document.getElementById("chk_z_is_broker").value = 'Y';
            document.getElementById("chk_z_is_broker").checked = true;
            document.getElementById("chk_z_is_govt").value = 'Y';
            document.getElementById("chk_z_is_govt").checked = true;
            document.getElementById("chk_is_vendor").value = 'Y';
            document.getElementById("chk_is_vendor").checked = true;
            document.getElementById("chk_z_is_special").value = 'Y';
            document.getElementById("chk_z_is_special").checked = true;


        }
        else {
            a.value = '';
            document.getElementById("chk_is_consignee").value = '';
            document.getElementById("chk_is_consignee").checked = false;
            document.getElementById("chk_is_agent").value = '';
            document.getElementById("chk_is_agent").checked = false;
            document.getElementById("chk_is_shipper").value = '';
            document.getElementById("chk_is_shipper").checked = false;
            document.getElementById("chk_is_carrier").value = '';
            document.getElementById("chk_is_carrier").checked = false;
            document.getElementById("chk_z_is_trucker").value = '';
            document.getElementById("chk_z_is_trucker").checked = false;
            document.getElementById("chk_z_is_warehousing").value = '';
            document.getElementById("chk_z_is_warehousing").checked = false;
            document.getElementById("chk_z_is_cfs").value = '';
            document.getElementById("chk_z_is_cfs").checked = false;
            document.getElementById("chk_z_is_broker").value = '';
            document.getElementById("chk_z_is_broker").checked = false;
            document.getElementById("chk_z_is_govt").value = '';
            document.getElementById("chk_z_is_govt").checked = false;
            document.getElementById("chk_is_vendor").value = '';
            document.getElementById("chk_is_vendor").checked = false;
            document.getElementById("chk_z_is_special").value = '';
            document.getElementById("chk_z_is_special").checked = false;
        }
    }

    function PrevNext(i) {
        actionRequestForPrevNext(i);
    }

    function ResetClient() {
        document.form1.action = "Client_Profile.asp?PostBack=true&Action=reset";
        document.form1.method = "POST";
        document.form1.target = "_self";
        document.form1.submit();
    }


    function txt_business_stateChange(o) {
        var oCountry = document.getElementById("txt_b_country_code");

        if (o.value == "") {
            oCountry.selectedIndex = 0;
        }
        else {
            oCountry.value = 'US';
        }
    }


    function goAddContact() {
        var acc_num = document.getElementById("txt_org_account_number").value;
        var dba_name = document.getElementById("txt_dba_name").value;

        if (!acc_num) {
            alert('Please select a Client!');
            return false;
        }

        if (acc_num == '') return false;
        var param = 'Start=yes' + '&Num=' + acc_num + '&Name=' + encodeURIComponent(dba_name);
        var props = "scrollBars=yes,resizable=yes,toolbar=yes,menubar=yes,location=no,directories=no,status=yes,width=950,height=500";
        window.open("AddContact.asp?" + param, "AddContact", props);

        try {
            var url = "/IFF_MAIN/asp/ajaxFunctions/ajax_check_add_info.asp?a=" + acc_num + "&t=contact";
            new ajax.xhr.Request('GET', '', url, showResponseAddInfoContact, '', '', '');
        } catch (f) { }

        return false;
    }

    function showResponseAddInfoContact(req) {
        if (req.readyState == 4) {
            if (req.status == 200) {
                if (req.responseText != 'e') {
                    document.getElementById('txt_add_contact').value = req.responseText;
                    set_contact();
                }
            }
            else {
                document.write(req.responseText);
            }
        }
    }

    function showResponseAddInfoRemarks(req) {
        if (req.readyState == 4) {
            if (req.status == 200) {
                if (req.responseText != 'e') {
                    document.getElementById('txt_add_remarks').value = req.responseText;
                    set_remarks();
                }
            }
            else {
                document.write(req.responseText);
            }
        }
    }

    function goRemarks() {
        var acc_num = document.getElementById("txt_org_account_number").value;
        var dba_name = document.getElementById("txt_dba_name").value;
        if (!acc_num) {
            alert('Please select a Client!');
            return false;
        }

        var param = 'Start=yes' + '&Num=' + acc_num + '&Name=' + encodeURIComponent(dba_name);
        var props = "scrollBars=no,resizable=yes,toolbar=yes,menubar=yes,location=no,directories=no,status=yes,width=840,height=500";
        popRemarks = window.open("AddRemarks.asp?" + param, "AddRemarks", props);

        try {
            var url = "/IFF_MAIN/asp/ajaxFunctions/ajax_check_add_info.asp?a=" + acc_num + "&t=remarks";
            new ajax.xhr.Request('GET', '', url, showResponseAddInfoRemarks, '', '', '');
        } catch (f) { }

        return false;
    }

    function setBillAddressList(name, val) {
        var lstField = document.getElementById('lst_' + name);
        if (lstField) {
            setSelectionValue(lstField.id, val);
        }

    }
    function copyAsAbove(o) {
        if (o.checked) {
            var lstField = null;
            document.form1.txt_owner_mail_address.value = document.form1.txt_business_address.value;
            document.form1.txt_owner_mail_address2.value = document.form1.txt_business_address2.value;
            document.form1.txt_owner_mail_city.value = document.form1.txt_business_city.value;
            document.form1.txt_owner_mail_state.value = document.form1.txt_business_state.value;
            document.form1.txt_owner_mail_zip.value = document.form1.txt_business_zip.value;
            document.form1.txt_owner_mail_country.value = document.form1.txt_business_country.value;
            setBillAddressList('owner_mail_address', document.form1.txt_owner_mail_address.value);
            setBillAddressList('owner_mail_address2', document.form1.txt_owner_mail_address2.value);
            setBillAddressList('owner_mail_city', document.form1.txt_owner_mail_city.value);
            setBillAddressList('owner_mail_state', document.form1.txt_owner_mail_state.value);
            setBillAddressList('owner_mail_zip', document.form1.txt_owner_mail_zip.value);
            setBillAddressList('owner_mail_country', document.form1.txt_owner_mail_country.value);
        }


    }
    function setClearBtn() {
        if (document.getElementById("filter_string").value == '') {
            document.getElementById("bClearF").disabled = "disabled";
        }
        else {
            document.getElementById("bClearF").disabled = "";
        }

    }

    function make_default_lists() {
        actionRequestForAll('SubConsignee', '/IFF_MAIN/asp/ajaxFunctions/ajax_get_all_code.asp?t=SubConsignee', '120px');

        actionRequestForAll('SubAgent', '/IFF_MAIN/asp/ajaxFunctions/ajax_get_all_code.asp?t=SubAgent', '120px');
        actionRequestForAll('SubShipper', '/IFF_MAIN/asp/ajaxFunctions/ajax_get_all_code.asp?t=SubShipper', '120px');
        actionRequestForAll('SubCarrier', '/IFF_MAIN/asp/ajaxFunctions/ajax_get_all_code.asp?t=SubCarrier', '120px');
        actionRequestForAll('SubTrucker', '/IFF_MAIN/asp/ajaxFunctions/ajax_get_all_code.asp?t=SubTrucker', '120px');
        actionRequestForAll('SubWarehousing', '/IFF_MAIN/asp/ajaxFunctions/ajax_get_all_code.asp?t=SubWarehousing', '120px');
        actionRequestForAll('SubCFS', '/IFF_MAIN/asp/ajaxFunctions/ajax_get_all_code.asp?t=SubCFS', '120px');
        actionRequestForAll('SubBroker', '/IFF_MAIN/asp/ajaxFunctions/ajax_get_all_code.asp?t=SubBroker', '120px');
        actionRequestForAll('SubCustomer', '/IFF_MAIN/asp/ajaxFunctions/ajax_get_all_code.asp?t=SubCustomer', '120px');
        actionRequestForAll('SubGovt', '/IFF_MAIN/asp/ajaxFunctions/ajax_get_all_code.asp?t=SubGovt', '120px');
        //	actionRequestForAll('SubBroker','/IFF_MAIN/asp/ajaxFunctions/ajax_get_all_code.asp?t=SubBroker','120px');
        //	actionRequestForAll('SubGovt','/IFF_MAIN/asp/ajaxFunctions/ajax_get_all_code.asp?t=SubGovt','120px');
        actionRequestForAll('SubVendor', '/IFF_MAIN/asp/ajaxFunctions/ajax_get_all_code.asp?t=SubVendor', '120px');

        actionRequestForAll('SubSpecial', '/IFF_MAIN/asp/ajaxFunctions/ajax_get_all_code.asp?t=SubSpecial', '120px');

    }

</script>

<% 
if not PostBack then
%>

<script language="javascript">

    // make as list type
    make_default_lists();

    var tmpOrg = '<%=vOrg%>';
    /*		
            if (trim(document.getElementById( "txt_dba_name" ).value) == '') {
    //			PrevNext(-1);
            } */
    if (tmpOrg != '') {
        if (tmpOrg.indexOf(':') < 0) {
            tmpOrg += ':';
        }

        get_dba_by_filter(tmpOrg);
    }

</script>

<%
end if
%>
<!-- //for Tooltip// -->

<script language="JavaScript" type="text/javascript" src="../include/tooltips.js"></script>

</html>
