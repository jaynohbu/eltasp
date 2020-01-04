<!--  #INCLUDE FILE="../include/transaction.txt" -->
<% 
    Option Explicit
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<!--  #INCLUDE VIRTUAL="/ASP/include/connection.asp" -->
<!--  #INCLUDE VIRTUAL="/ASP/include/Header.asp" -->

<!--  #INCLUDE VIRTUAL="/ASP/include/GOOFY_data_manager.inc" -->
<!--  #INCLUDE VIRTUAL="/ASP/include/GOOFY_util_fun.inc" -->
<!--  #INCLUDE FILE="../include/countrystates.asp" -->
<!--  #include file="../include/recent_file.asp" -->
<%
    Dim dataObj,dataList,i,j,mode,max_seq,Port_Code
    Dim rs, SQL,add,delete,update,dAccount,tIndex,pos
    Dim vPortCode,vPortDesc,vPortID,vPortCity,vPortState,vPortCountry,CountryInfo
    
    mode = checkBlank(Request.QueryString("mode").Item, "view")
    
    If mode = "add" Then
        CountryInfo=Request("lstPortCountry")
        Call UpdatePort
    Elseif mode = "delete" Then
        Port_Code = checkBlank(Request.QueryString("PortNO").Item, "")
        Call DeletePort2
    End If 
    
    Call GetAllPort
    
    Sub GetAllPort
        Dim SQL,dataObj
        SQL= "select * from port where elt_account_number = " & elt_account_number & " order by port_desc"
        Set dataObj = new DataManager
        dataObj.SetDataList(SQL)
        Set dataList = dataObj.GetDataList
    End Sub
    
    Sub UpdatePort
        
        Dim SQL,dataObj,tmpTable,vPortCountryCode,vPortCountry
        pos=instr(CountryInfo,"-")
	    if pos>0 then
		vPortCountryCode=Left(CountryInfo,pos-1)
		vPortCountry=Mid(CountryInfo,pos+1,200)
	    end if
        SQL = "select * from port where elt_account_number=" & elt_account_number & " order by Port_code"
        Set dataObj = new DataManager
        dataObj.SetDataList(SQL)
        SQL = "select * from port where elt_account_number=" & elt_account_number _
        & " and Port_code=N'" & Request.Form("txtPortCode").Item & "'" 

        Set tmpTable = Server.CreateObject("System.Collections.HashTable")
        tmpTable.Add "elt_account_number", elt_account_number
        tmpTable.Add "port_code", Request.Form("txtPortCode").Item
        tmpTable.Add "port_desc", Request.Form("txtPortDesc").Item
        tmpTable.Add "port_id", Request.Form("txtPortID").Item
        tmpTable.Add "port_city", Request.Form("txtPortCity").Item
        tmpTable.Add "port_state", Request.Form("txtPortState").Item
        tmpTable.Add "port_country", vPortCountry 
        tmpTable.Add "port_country_code", vPortCountryCode              
      
        dataObj.SetColumnKeys("port")
        If dataObj.UpdateDBRow(SQL,tmpTable) Then
        Else
            Response.Write("<script>alert('Failed to add a port');</script>")
        End If
    End Sub
    
    Sub DeletePort2
        Dim SQL,rs
        Set rs = Server.CreateObject("ADODB.Recordset")
        SQL= "delete port where elt_account_number = " & elt_account_number & " and port_code=N'" & Port_Code & "'"
        Set rs = eltConn.execute(SQL)
    End Sub
    
 
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
     <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
    <title>Port</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript">

        function AddUpdatePort()
        {
            
            var form = document.getElementById("form1");
            var Port_NO= document.getElementById("txtPortCode").value;
            var Port_City= document.getElementById("txtPortCity").value;
            if(Port_NO == "" || Port_City=="")
            {
                alert("Enter Port Code and City");
                return false;
            }
            if(IsPortExist(document.getElementById("txtPortCode").value)){
                if(!confirm("Port already exists, Click OK to update the existing port")){
                    return false;
                }
            }
            if(Port_NO.length > 3)
            {
                alert("Port code has three characters!");
                return false;
            }
            
            form.action = "edit_port.asp?mode=add&PortNO=" + Port_NO;
            form.method = "POST";
            form.submit();
        }
        
        function IsPortExist(vPotCode)
        {
            var objList = document.getElementsByName("PortCode");
            
            for(var i=0;i<objList.length;i++){
                if(objList[i].value == vPotCode){
                    return true;
                }
            }
            return false;
        }
        
        function DeletePort(vPortNO)
        {
            var ans = confirm("Are you sure you want to delete this port? Please click OK to continue.");
            if (ans){
                var form = document.getElementById("form1");
                form.action = "edit_port.asp?mode=delete&PortNO=" + vPortNO;
                form.method = "POST";
                form.submit();    
            }
        }
        
        function EditPort(vIndex){

            document.getElementById("txtPortCode").value = document.getElementsByName("PortCode")[vIndex].value;
            document.getElementById("txtPortDesc").value = document.getElementsByName("PortDesc")[vIndex].value;
            document.getElementById("txtPortID").value = document.getElementsByName("PortID")[vIndex].value;
            document.getElementById("txtPortCity").value = document.getElementsByName("PortCity")[vIndex].value;
            document.getElementById("txtPortState").value = document.getElementsByName("PortState")[vIndex].value;
            findSelect(document.getElementById("lstPortCountry"),document.getElementsByName("lstPortCountrylist")[vIndex].value)
        }
    
        function findSelect(oSelect,selVal){
            oSelect.options.selectedIndex = 0;
            for(var i=0;i<oSelect.options.length;i++){
                var tmpText = oSelect.options[i].value;
                if(tmpText != "" && tmpText.match(selVal) != null){
                    oSelect.options[i].selected = true;
                    break;
                }
            }
        }
        
        function NewPort(){
            document.getElementById("txtPortCode").value = "";
            document.getElementById("txtPortDesc").value = "";
            document.getElementById("txtPortID").value = "";
            document.getElementById("txtPortCity").value = "";
            document.getElementById("txtPortState").value = "";
            document.getElementById("lstPortCountry").selectedIndex = 0;
        }
        
    </script>

    <style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
.style1 {color: #cc6600}
.style5 {color: #663366}
-->
</style>
</head>
<body>
    <form name="form1" id="form1">
        <input type="image" style="position:absolute; visibility:hidden" onclick="return false;" />
        <!-- tooltip placeholder -->
        <div id="tooltipcontent">
        </div>
        <table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
            <tr>
                <td width="33%" height="32" align="left" valign="middle" class="pageheader">
                    Port</td>
                <td width="67%" height="20" align="right" valign="bottom" class="bodycopy">
                    <a href="/ASP/Code/DOMESTIC_PORT_CODE.xls" target='mainFrame' class="style1">Domestic
                        Port ID Lookup</a> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a
                            href="/ASP/Code/FOREIGN_PORT_CODE.xls" target='mainFrame' class="style1">Foreign Port
                            ID Lookup</a></td>
            </tr>
        </table>
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#73beb6"
            class="border1px">
            <tr>
                <td height="8" align="left" valign="top" bgcolor="#ccebed" class="bodyheader">
                </td>
            </tr>
            <tr>
                <td height="1" align="left" valign="top" bgcolor="#73beb6">
                </td>
            </tr>
            <tr>
                <td align="left">
                    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="bodycopy"
                        id="tblHeader" style="padding-left: 10px">
                        <tr align="left" valign="middle" bgcolor="ecf7f8">
                            <td bgcolor="ecf7f8" class="bodyheader" style="height: 18px">
                                Port Code</td>
                            <td bgcolor="ecf7f8" class="bodyheader" style="height: 18px">
                                Port Desc</td>
                            <td bgcolor="ecf7f8" class="bodyheader" style="height: 18px">
                                Port ID</td>
                            <td bgcolor="ecf7f8" class="bodyheader" style="height: 18px">
                                City</td>
                            <td bgcolor="ecf7f8" class="bodyheader" style="height: 18px">
                                State</td>
                            <td bgcolor="ecf7f8" class="bodyheader" style="height: 18px">
                                Country
                                <% if mode_begin then %>
                                <div style="width: 21px; display: inline; vertical-align: middle" onmouseover="showtip('This list of countries is set up in the Site Admin > Company Information > Country Master portion of the system.');"
                                    onmouseout="hidetip()">
                                    <img src="../Images/button_info.gif" align="bottom" class="bodylistheader"></div>
                                <% end if %>
                            </td>
                            <td bgcolor="ecf7f8" class="bodyheader" style="height: 18px">
                                &nbsp;</td>
                            <td bgcolor="ecf7f8" class="bodyheader" style="height: 18px">
                                &nbsp;</td>
                            <td bgcolor="ecf7f8" class="bodyheader" style="height: 18px">
                                &nbsp;</td>
                        </tr>
                        <tr bgcolor="73beb6">
                            <td height="2" align="left" valign="top">
                            </td>
                            <td align="left" valign="top" class="bodyheader">
                            </td>
                            <td align="left" valign="top" class="bodyheader">
                            </td>
                            <td align="left" valign="top" class="bodyheader">
                            </td>
                            <td align="left" valign="top" class="bodyheader">
                            </td>
                            <td align="left" valign="top" class="bodyheader">
                            </td>
                            <td align="left" valign="top" class="bodyheader">
                            </td>
                            <td align="left" valign="top" class="bodyheader">
                            </td>
                            <td align="left" valign="top" class="bodyheader">
                            </td>
                        </tr>
                        <tr>
                            <td bgcolor="f3f3f3">
                                <input type="text" class="shorttextfield" id="txtPortCode" maxlength="8" name="txtPortCode"
                                    size="7" value=""></td>
                            <td bgcolor="f3f3f3">
                                <input type="text" class="shorttextfield" id="txtPortDesc" maxlength="50" name="txtPortDesc"
                                    size="35" value=""></td>
                            <td bgcolor="f3f3f3">
                                <input type="number" class="shorttextfield" id="txtPortID" maxlength="50" name="txtPortID" 
                                    size="8" value="" style="behavior: url(../include/igNumChkLeft.htc)"></td>
                            <td bgcolor="f3f3f3">
                                <input type="text" class="shorttextfield" id="txtPortCity" maxlength="50" name="txtPortCity"
                                    size="24" value=""></td>
                            <td bgcolor="f3f3f3">
                                <input type="text" class="shorttextfield" id="txtPortState" maxlength="10" name="txtPortState"
                                    size="6" value=""></td>
                            <td bgcolor="f3f3f3">
                                <select name="lstPortCountry" id="lstPortCountry" size="1" class="smallselect" style="width: 160px">
                                    <option value="0">Select One</option>
                                    <% for j=0 to countryIndex %>
                                    <option value="<%= AllCountryCode(j) & "-" & AllCountryDesc(j) %>">
                                        <%= AllCountryDesc(j) %>
                                    </option>
                                    <% next %>
                                </select>
                            </td>
                            <td bgcolor="f3f3f3">
                                <img src="../images/button_addupdate.gif" height="18" onclick="AddUpdatePort()" style="cursor: hand;
                                    width: 74px;"></td>
                            <td bgcolor="f3f3f3">
                                <a href="javascript:;" onclick="NewPort()" style="cursor: hand">Clear</a>
                            </td>
                            <td bgcolor="f3f3f3">
                            </td>
                        </tr>
                        <tr bgcolor="73beb6">
                            <td height="1" align="left" valign="top">
                            </td>
                            <td align="left" valign="top" class="bodyheader">
                            </td>
                            <td align="left" valign="top" class="bodyheader">
                            </td>
                            <td align="left" valign="top" class="bodyheader">
                            </td>
                            <td align="left" valign="top" class="bodyheader">
                            </td>
                            <td align="left" valign="top" class="bodyheader">
                            </td>
                            <td align="left" valign="top" class="bodyheader">
                            </td>
                            <td align="left" valign="top" class="bodyheader">
                            </td>
                            <td align="left" valign="top" class="bodyheader">
                            </td>
                        </tr>
                        <tr align="left" bgcolor="#FFFFFF">
                            <td height="20" valign="middle" class="bodycopy">
                                &nbsp;</td>
                            <td height="20" valign="middle" class="bodycopy">
                                &nbsp;</td>
                            <td height="20" valign="middle" class="bodycopy">
                                &nbsp;</td>
                            <td height="20" colspan="2" valign="middle" class="bodycopy">
                                &nbsp;</td>
                            <td height="20" valign="middle" class="bodycopy">
                                &nbsp;</td>
                            <td height="20" valign="middle" class="bodycopy">
                                &nbsp;</td>
                            <td height="20" valign="middle" class="bodycopy">
                                &nbsp;</td>
                            <td height="20" valign="middle" class="bodycopy">
                                &nbsp;</td>
                        </tr>
                        <% For i=0 To dataList.Count-1 %>
                        <tr align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                            <td>
                                <input type="text" class="d_shorttextfield" name="PortCode" size="7" value="<%=dataList(i)("port_code") %>"
                                    readonly="readonly"></td>
                            <td>
                                <input type="text" class="d_shorttextfield" name="PortDesc" size="35" value="<%=dataList(i)("port_desc") %>"
                                    readonly="readonly"></td>
                            <td>
                                <input type="text" class="d_shorttextfield" name="PortID" size="8" value="<%=dataList(i)("port_id") %>"
                                    style="behavior: url(../include/igNumChkLeft.htc)" readonly="readonly"></td>
                            <td>
                                <input type="text" class="d_shorttextfield" name="PortCity" size="24" value="<%=dataList(i)("port_city") %>"
                                    readonly="readonly"></td>
                            <td>
                                <input type="text" class="d_shorttextfield" name="PortState" size="6" value="<%=dataList(i)("port_state") %>"
                                    readonly="readonly"></td>
                            <td>
                                <input type="hidden" name="lstPortCountrylist" value="<%=dataList(i)("port_country_code") & "-" & dataList(i)("port_country") %>" />
                                <%=dataList(i)("port_country") %>
                            </td>
                            <td>
                                <img src="../images/button_delete.gif" width="50" height="17" onclick="DeletePort('<%=dataList(i)("port_code") %>')"
                                    style="cursor: hand"></td>
                            <td>
                                <img src="../images/button_edit.gif" height="18" onclick="EditPort(<%= i %>)" style="cursor: hand;
                                    width: 38px;"></td>
                        </tr>
                        <% Next %>
                    </table>
                </td>
            </tr>
            <tr>
                <td colspan="11" style="background-color: #ffffff; height: 10px">
                </td>
            </tr>
            <tr>
                <td height="1" colspan="11" align="left" valign="top" bgcolor="73beb6" class="bodyheader">
                </td>
            </tr>
            <tr>
                <td height="20" colspan="11" align="right" valign="middle" bgcolor="ccebed" class="bodycopy">
                    &nbsp;</td>
            </tr>
        </table>
        <br />
    </form>
</body>
<!-- //for Tooltip// -->

<script language="JavaScript" type="text/javascript" src="../include/tooltips.js"></script>

<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
