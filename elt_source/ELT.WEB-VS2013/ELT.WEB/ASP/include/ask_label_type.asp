<!--  #INCLUDE FILE="transaction.txt" -->
<%
    Option Explicit
    Response.Charset = "UTF-8"
    Session.CodePage = "65001"
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Select a Print Port</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />

    <script type="text/jscript">
    window.name = "query_print_port";
    function closeReturn(s) 
    {
	    window.returnValue = s;
	    window.close();
    }
    </script>

    <!--  #INCLUDE FILE="connection.asp" -->
    <!--  #INCLUDE FILE="header.asp" -->
</head>
<%

    DIM strLocal,strNetwork,Action,vAdd_Info,vLabelType,vIATA

	Action = Request.QueryString("Action")
	if Action ="ok" then
	end if	
	
	strLocal   = Request.QueryString("l")
	strNetwork = Request.QueryString("n")
	vIATA = Request.QueryString("iata")

	if strLocal ="" and strNetwork="" then
		response.write "<script language='javascript'>closeReturn('LPT1');</script>"
		response.end()
	end if
	
	DIM rs,SQL
	SQL = "select * from users where elt_account_number = " & elt_account_number & " and userid=" & user_id
	Set rs = eltConn.execute (SQL)
	if Not rs.EOF then
		vLabelType=rs("label_type")
		if isnull(vLabelType) then
			 vLabelType =1
		end if 
		vAdd_Info=rs("add_to_label")	
	end if	
	rs.Close	 
    Set rs = nothing

%>
<body link="336699" vlink="336699" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#dddddd">
        <tr>
            <td>
                <form name="form1" method="post" action="query_print_port.asp">
                    <table width="100%" border="0" cellpadding="3" cellspacing="0" bordercolor="#dddddd"
                        class="border1px">
                        <tr bgcolor="dddddd">
                            <td height="8" colspan="6" align="center" valign="top" bgcolor="#eeeeee" class="bodyheader">
                                * Please select a printer port</td>
                        </tr>
                        <tr align="left" valign="middle" bgcolor="#dddddd">
                            <td colspan="2" height="1" class="bodyheader">
                            </td>
                        </tr>
                        <tr align="left" valign="middle" bgcolor="f3f3f3">
                            <td height="22" align="right" bgcolor="f3f3f3" class="bodyheader">
                                Network Printer
                            </td>
                            <td align="left">
                                <input name="rb1" type="radio" id="rb2" <% if strNetwork <> "" then response.write "checked='checked'" %><% if strNetwork = "" then response.write " disabled='disabled'" end if%> />
                                <strong>
                                    <% if strNetwork = "" then response.write "N/A" else response.write(strNetwork) end if %>
                                </strong>
                            </td>
                        </tr>
                        <tr align="left" valign="middle" bgcolor="f3f3f3">
                            <td width="29%" height="22" align="right" bgcolor="f3f3f3" class="bodyheader">
                                Local Printer
                            </td>
                            <td width="71%" align="left" class="bodyheader">
                                <input name="rb1" type="radio" id="rb1" <% if strNetwork = "" and strLocal <> "" then response.write "checked='checked'" %><% if strLocal = "" then response.write " disabled='disabled'" end if%> />
                                <strong>
                                    <% if strLocal = "" then response.write "N/A" else response.write(strLocal) end if %>
                                </strong>
                            </td>
                        </tr>
                        <tr>
                            <td class="bodyheader" align="right">
                                Starting Number
                            </td>
                            <td>
                                <input type="text" id="txt_starting_page" name="txt_starting_page" class="shorttextfield" value="1" />
                            </td>
                        </tr>
                        <tr align="left" valign="middle" bgcolor="f3f3f3" <%If vIATA = "N" Then Response.Write("style='visibility:hidden;'") %>>
                            <td height="22" align="right" bgcolor="f3f3f3" class="bodyheader">
                                &nbsp;</td>
                            <td align="left" class="bodyheader">
                                <input id="chk_iata" name="chk_iata" onclick="javascript:cClick(this);" type="checkbox"
                                    style="cursor: hand" checked='checked' value='Y' />
                                <label for="chk_iata">
                                    Print IATA label</label></td>
                        </tr>
                        <tr align="left" valign="middle" bgcolor="f3f3f3">
                            <td height="22" align="right" bgcolor="f3f3f3" class="bodyheader">
                                &nbsp;</td>
                            <td align="left" class="bodyheader">
                                <input id="chk_address" name="chk_address" onclick="javascript:cClick(this);" type="checkbox"
                                    style="cursor: hand" <% if vAdd_Info="Y" then response.write(" checked='checked' ") %>
                                    <% if vAdd_Info="Y" then response.write("value='Y'") %> />
                                <label for="chk_address_only">
                                    Print address label</label></td>
                        </tr>
                        <tr align="center" bgcolor="ffffff">
                            <td height="20" colspan="2" valign="middle" class="bodycopy">
                                <input type="button" class="bodycopy" id="Button2" style="width: 100px"
                                    value='Ok' name="Ok" onclick="okClick();" />
                                <input type="button" class="bodycopy" id="Button3" style="width: 100px"
                                    onclick="javascript:window.close();" value="Cancel" name="CloseMe" /></td>
                        </tr>
                    </table>
                </form>
            </td>
        </tr>
    </table>
</body>

<script type="text/javascript">
    function cClick(o){

        if(o.checked) then
	        o.value = "Y"
        else
	        o.value = ""
        end if
    	
    }

    function okClick(){
	    var add_option = ""		
	    if (document.getElementById("chk_iata").checked )
		    add_option = "I";

	    if (document.getElementById("chk_address").checked )
		    add_option = "A";

	    if (document.getElementById("chk_iata").checked && document.getElementById("chk_address").checked )
		    add_option = "X";

    	
	    var label_type = 1;
	    var vPort="";
	    if(document.form1.rb1.item(0).checked) 
		    vPort = "<%=strNetwork%>" ;
	    else
		    vPort = "<%=strLocal%>"  ;
	    
	    var vStartPage = document.getElementById("txt_starting_page").value;
	    if (! IsNumeric(vStartPage) )
	        vStartPage = 1;
	    
	    if (add_option == "" )
		    window.returnValue = "";
	    else	
		    window.returnValue = vPort + "^^^"+ add_option + "^^^" + label_type+ "^^^" +vStartPage;

	    window.close();
    		
    }

</script>

</html>
