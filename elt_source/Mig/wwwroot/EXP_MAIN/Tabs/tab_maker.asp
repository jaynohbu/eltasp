<%@ TRANSaction=Supported LANGUAGE="VBScript" CODEPAGE="65001" %>
<% Option Explicit %>
<% Response.CharSet="UTF-8" %>
<!--  #INCLUDE FILE="../include/connection.asp" -->
<!--  #INCLUDE FILE="../include/Header.inc" -->
<!--  #INCLUDE FILE="../include/GOOFY_util_fun.inc" -->
<!--  #INCLUDE FILE="../include/GOOFY_data_manager.inc" -->
<!--  #INCLUDE FILE="../include/GOOFY_Util_Ver_2.inc" -->
<%

    Response.CacheControl = "no-cache"
    Response.AddHeader "Pragma", "no-cache"
    Response.Expires = -1

    Dim agent_is_dome,agent_is_intl,agent_is_cartage,agent_is_exporter,agent_is_warehouse,agent_status
	
	Dim vTopModule,vSubModule,vPageURL,vMode,vLogoURL,AESLogoURL,vPageLabel
	Dim top_level_list,sub_level_list,page_level_list,page_level_url_list,i
	
    Set top_level_list = Server.CreateObject("System.Collections.ArrayList")
    Set sub_level_list = Server.CreateObject("System.Collections.ArrayList")
    Set page_level_list = Server.CreateObject("system.Collections.ArrayList")
    Set page_level_url_list = Server.CreateObject("system.Collections.ArrayList")

    vMode = Request.QueryString.Item("mode")
    vTopModule = Request.QueryString.Item("top")
    vSubModule = Request.QueryString.Item("sub")
    vPageURL = Request.QueryString.Item("page")
    
    Call MODULE_CHECK
    
    If vMode = "back"  Then
        Call GET_TABS_BY_URL
    Elseif vMode = "land" Then
        '// Call GET_LANDING_TABS
    End If
	
	Call GET_TAB_LIST
	Call SELECT_LOGO
	
    eltConn.Close
    Set eltConn = Nothing
	
	'// End Of Main ////////////////////////////////////////////////////////////////////////////
	
	Sub SELECT_LOGO
        vLogoURL = ""
        AESLogoURL = "../Images/aeseasy.jpg"
	End Sub
	
	Sub GET_TABS_BY_URL
	    
	    vPageURL = Request.QueryString.Item("page")
	    vPageURL = Mid(vPageURL, Instr(UCase(vPageURL),"EXP_MAIN")+9,256)
	    
	    GET_TABS_BY_URL_RECUR (vPageURL)
	    
	End Sub
	
	Sub GET_LANDING_TABS
	    Dim rs,SQL,vpageTabId,vTopId,vSubId,vPageId
	    
	    vTopId = 0
        vSubId = 0
        vPageId = 0
	    vpageTabId = 0
	            
	    Set rs = Server.CreateObject("ADODB.Recordset")
	    SQL = "SELECT page_tab_id FROM users WHERE elt_account_number=" & elt_account_number & " AND userid=" & user_id
	    rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText
	    
	    If Not rs.EOF And Not rs.BOF Then
	        vpageTabId = ConvertAnyValue(rs("page_tab_id").value,"Long",0) 	    
	    End If
	    rs.Close()

	    Set rs = Server.CreateObject("ADODB.Recordset")
	    SQL = "SELECT page_url,top_module,sub_module,page_label FROM tab_master where page_id=" & vpageTabId
	    rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText

	    If Not rs.EOF And Not rs.BOF Then
	        vTopModule = rs("top_module").value
	        vSubModule = rs("sub_module").value
	        vPageLabel = rs("page_label").value
	        vPageURL = rs("page_url").value
	    End If
	    rs.Close()

	End Sub
	
	Function GET_TABS_BY_URL_RECUR (argURL)
	    Dim rs,SQL
	    Set rs = Server.CreateObject("ADODB.Recordset")
	    
	    SQL = "SELECT top_module,sub_module,page_label FROM tab_master where LOWER(page_url)='" _
	        & LCase(argURL) & "' AND top_module='" & vTopModule & "' AND page_seq_id>0 "
	    
	    rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText

	    If Not rs.EOF And Not rs.BOF Then
		    vTopModule = rs("top_module").value
	        vSubModule = rs("sub_module").value
	        vPageLabel = rs("page_label").value
	    Else
	        If InStrRev(argURL,"?") > 0 Then
	            argURL = Left(argURL,InStrRev(argURL,"?")-1)
	            GET_TABS_BY_URL_RECUR (argURL)
	            vPageURL = argURL
	        End If
	    End If
        rs.Close()
	End Function
	
	Sub RedirectTabs(arg)
	    Dim rs,SQL
	    Set rs = Server.CreateObject("ADODB.Recordset")
	    
	    SQL = "SELECT top_module,sub_module,page_label FROM tab_master where page_url='" & vPageURL & "' AND top_module='" & arg & "'"
	    rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText

	    If Not rs.EOF And Not rs.BOF Then
		    vTopModule = rs("top_module").value
	        vSubModule = rs("sub_module").value
	        vPageLabel = rs("page_label").value
	    End If
	    rs.Close()
	End Sub
	
	Sub MODULE_CHECK
        Dim rs,SQL
	    Set rs = Server.CreateObject("ADODB.Recordset")
	    SQL = "SELECT account_statue,is_dome,is_intl,is_cartage,is_exporter,is_warehouse FROM agent where elt_account_number=" & elt_account_number

	    rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText
    	
	    If Not rs.EOF And Not rs.BOF Then
		    agent_is_dome = rs("is_dome").value
	        agent_is_intl = rs("is_intl").value
	        agent_is_cartage = rs("is_cartage").value
	        agent_status = rs("account_statue").value
	        agent_is_exporter = rs("is_exporter").value
	        agent_is_warehouse = rs("is_warehouse").value
	    End If
	
	    rs.Close()
    End Sub
    
    '// Moodule logic can be removed after customizing each ELT account or user tab menu ////////////////
    Sub GET_TAB_LIST
        Dim rs,SQL
	    Set rs = Server.CreateObject("ADODB.Recordset")

	    SQL = "SELECT distinct top_module,top_seq_id FROM tab_master WHERE page_label<>'Default Page' AND page_label<>'Default Module Page' AND page_status='A' AND " _
	        & "page_id NOT IN (SELECT page_id FROM tab_user WHERE is_denied='Y' AND elt_account_number=" & elt_account_number & " AND user_id=" & user_id & ") ORDER BY top_seq_id"

	    rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText
    	Do While Not rs.EOF And Not rs.BOF
    	    '// Exception Cases
		    If rs("top_module").value = "Exporters" Then
		        top_level_list.Add rs("top_module").value
		    End If
		    rs.MoveNext()
	    Loop
	    rs.Close()
	    
	    vTopModule = ConvertAnyValue(vTopModule,"String",top_level_list(0))
	    
	    SQL = "SELECT distinct top_module,sub_module,top_seq_id,sub_seq_id,page_label,page_url FROM tab_master WHERE " _
	        & " top_module='" & vTopModule & "' AND page_label<>'Default Page' AND page_label<>'Default Module Page' AND page_status='A' AND " _
	        & "page_id NOT IN (SELECT page_id FROM tab_user WHERE is_denied='Y' AND elt_account_number=" & elt_account_number & " AND user_id=" & user_id & ") ORDER BY top_seq_id,sub_seq_id"

	    rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText
    	Do While Not rs.EOF And Not rs.BOF
    	    If Not sub_level_list.contains(rs("sub_module").value) Then
                sub_level_list.Add rs("sub_module").value
            End If
            If rs("page_label").value = "Default Module Page" And vSubModule = "" Then
                vSubModule = rs("sub_module").value
            End If
		    rs.MoveNext()
	    Loop
	    rs.Close()
	    
	    vSubModule = ConvertAnyValue(vSubModule,"String",sub_level_list(0))
	    
	    SQL = "SELECT distinct top_module,page_label,page_url,top_seq_id,sub_seq_id,page_seq_id,access_level FROM tab_master WHERE " _
	        & " top_module='" & vTopModule & "' AND sub_module='" & vSubModule & "' AND page_status='A' AND " _
	        & "page_id NOT IN (SELECT page_id FROM tab_user WHERE is_denied='Y' AND elt_account_number=" & elt_account_number & " AND user_id=" & user_id & ") ORDER BY top_seq_id,sub_seq_id,page_seq_id"
	    
	    rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText
    	Do While Not rs.EOF And Not rs.BOF
    	    If rs("page_label").value = "Default Page" Then
                vPageURL = ConvertAnyValue(vPageURL,"String",rs("page_url").value)
            Elseif rs("page_label").value = "Default Module Page" And Request.QueryString.Item("sub") = "" Then
                vPageURL = ConvertAnyValue(vPageURL,"String",rs("page_url").value)
            Elseif rs("page_label").value = "Default Module Page" Then
            Elseif rs("access_level") = "LIMIT" And agent_status <> "A" Then '// also not if the feature selected
            Else
                page_level_list.Add rs("page_label").value
                page_level_url_list.Add rs("page_url").value
            End If
		    rs.MoveNext()
	    Loop
	    rs.Close()
    End Sub
    
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Untitled Document</title>

    <script type="text/javascript">

        function lstTopModuleChange(){
            try{
            var selObj = document.getElementById("lstTopModule");
            window.location.href="tab_maker.asp?top=" + selObj.options[selObj.selectedIndex].text;
            }catch(err){ alert(err.description); }
        }
        function lstTopModuleChange(){
            try{
            var selObj = document.getElementById("lstTopModule");
            window.location.href="tab_maker.asp?top=" + selObj.options[selObj.selectedIndex].text;
            }catch(err){ alert(err.description); }
        }
        function SubLevelChange(arg){
            try{
            var selObj = document.getElementById("lstTopModule");
            window.location.href="tab_maker.asp?top=" + selObj.options[selObj.selectedIndex].text
                + "&sub=" + arg;
            }catch(err){ alert(err.description); }
        }

        function PageLevelChange(arg,obj,eventType){
        
            try{
            // clear onload, avoiding multi-threading
            document.body.onload = "";
            
            var ulObj,tmpStr
            var pageURL = parent.document.frames['mainFrame'].location.href;
            
            if (arg == ""){
                parent.document.frames['mainFrame'].location = "/IFF_MAIN/SystemAdmin/ModuleManagerVer2.aspx"
            }
            else if(encodeURIComponent(pageURL.toLowerCase()).match(encodeURIComponent(arg.toLowerCase())) != null){
                if(eventType == "click"){
                    parent.document.frames['mainFrame'].location = "/EXP_MAIN/" + arg;
                }
                ulObj = document.getElementById("<%=Replace(vSubModule," ","") %>Div").childNodes[0];
                for(var i=0;i<ulObj.children.length;i++){
                    tmpStr = ulObj.childNodes[i].firstChild.value;
                    if(tmpStr == arg){
                        ulObj.childNodes[i].firstChild.id="<%=Replace(vSubModule," ","") %>DivSelected";
                    }
                }
            }
            else{
                
                parent.document.frames['mainFrame'].location = "/EXP_MAIN/" + arg;
                if(obj != null){
                    tmpStr = ulObj = obj.parentNode.parentNode;
                    for(var i=0;i<ulObj.children.length;i++){
                        ulObj.childNodes[i].firstChild.id="";
                    }
                    obj.id = obj.parentNode.parentNode.parentNode.id + "Selected";
                }
                else{
                    ulObj = document.getElementById("<%=Replace(vSubModule," ","") %>Div").childNodes[0];
                    for(var i=0;i<ulObj.children.length;i++){
                        if(ulObj.childNodes[i].firstChild.value.toLowerCase() == arg.toLowerCase()){
                            ulObj.childNodes[i].firstChild.id="<%=Replace(vSubModule," ","") %>DivSelected";
                        }
                    }
                }
            }
            document.getElementById("hCurrentPage").value = arg;
            }catch(err){ alert(err.description); }
        }

        function MM_swapImgRestore() { //v3.0
            try{
            var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
            }catch(err){ alert(err.description); }
        }

        function MM_preloadImages() { //v3.0
            try{
            var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
            var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
            if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
            }catch(err){ alert(err.description); }
        }

        function MM_findObj(n, d) { //v4.01
            try{
            var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
            d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
            if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
            for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
            if(!x && d.getElementById) x=d.getElementById(n); return x;
            }catch(err){ alert(err.description); }
        }

        function MM_swapImage() { //v3.0
            try{
            var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
            if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
            }catch(err){ alert(err.description); }
        }
        
        function changeTopModule(arg) {
            try{
            var topModlueObj = document.getElementById("lstTopModule");
            for(var i=0; i<topModlueObj.options.length; i++){
                if(topModlueObj.options[i].text == arg){
                    topModlueObj.options.selectedIndex = i;
                }
            }
            }catch(err){ alert(err.description); }
        }

    </script>

    <link href="../css/tab.css" rel="stylesheet" type="text/css" />
    <!--[if IE 6]>
	<link rel="stylesheet" href="../css/ie6.css" type="text/css" media="screen" />
	<![endif]-->
    <style type="text/css">
		#bodyDiv {
			margin-top:9px;
			width: 100%;
		}
	</style>
</head>
<body onload="PageLevelChange('<%=vPageURL %>',null,'load'); MM_preloadImages('../Images/button_refresh_type_over.gif','../Images/button_logout_type_over.gif')"
    scroll="no">
    <div id="bodyDiv">
        <!-- // MODULE SELECTION // -->
        <div id="moduleSelect">
            <div style="float: left">
                <img src="<%=vLogoURL %>" alt="Product Logo" style="margin-top: 10px; visibility:hidden" />
            </div>
            <div style="margin-top: 14px; margin-left: 138px; text-align: left; visibility:hidden">
                <select style="width: 115px" id="lstTopModule" name="lstTopModule" onchange="lstTopModuleChange()"
                    class="moduleText">
                    <% For i=0 To top_level_list.Count-1 %>
                    <option <% If top_level_list(i)=vTopModule Then Response.Write("selected") %>>
                        <%=top_level_list(i) %>
                    </option>
                    <% Next %>
                </select>
            </div>
        </div>
        <!-- // MODULE LOGO disabled by MJ for replacing client logo 1/11/2008 // -->
        <div id="logoHolder">
            <img src="<%=AESLogoURL %>" alt="Company Logo" style="visibility:visible; margin-top:6px" /></div>
        <!-- graphic devider -->
        <div class="middleRight">
        </div>
        <div class="middleLeft" style="text-align: right">
            <img src="../Images/mainnav_back2.gif" alt="" /></div>
        <!-- -------------------------------- -->
        <!-- // NAVIGATION TABS START HERE // -->
        <!-- -------------------------------- -->
        <!-- navigation tabs -->
        <div id="tabs">
            <div class="rightDiv">
                <ul>
                    <li>
                        <img src="../Images/button_refresh_type.gif" name="refresh" width="58" height="18"
                            border="0" id="refresh" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('refresh','','../Images/button_refresh_type_over.gif',1)"
                            onclick="parent.frameReload();" style="margin-right: 18px; margin-top: 3px; cursor: pointer"
                            alt="Click to refresh current page" /><img src="../Images/button_logout_type.gif"
                                name="logout" width="54" height="18" border="0" id="logout" onmouseout="MM_swapImgRestore()"
                                onmouseover="MM_swapImage('logout','','../Images/button_logout_type_over.gif',1)"
                                onclick="parent.logout();" style="margin-right: 30px; margin-top: 3px; cursor: pointer"
                                alt="Click to logout" />
                    </li>
                </ul>
            </div>
            <div class="leftDiv">
                <ul>
                    <% For i=0 To sub_level_list.Count-1  %>
                    <li <% If sub_level_list(i)=vSubModule Then %>id="Cur<%=Replace(vSubModule," ","") %>Div"
                        <% End If %>><a href="#" onclick="SubLevelChange('<%=sub_level_list(i) %>')"><span>
                            <%=sub_level_list(i) %>
                        </span></a></li>
                    <% Next %>
                </ul>
            </div>
        </div>
        <!-- subtabs (page level) -->
        <div id="<%=Replace(vSubModule," ","") %>Div" style="width: 100%; height: 28px">
            <ul style="margin-left: -57px;">
                <% For i=0 To page_level_list.Count-1  %>
                <li><a value="<%=page_level_url_list(i) %>" href="#" onclick="PageLevelChange('<%=page_level_url_list(i) %>',this,'click')"
                    <% If i=0 Then Response.Write("class='noLeft'") %> <% If i=(page_level_list.Count-1) Then Response.Write("class='noRight'") %>>
                    <span>
                        <%=page_level_list(i) %>
                    </span></a></li>
                <% Next %>
            </ul>
        </div>
        <input type="hidden" id="hCurrentPage" value="<%=vPageURL %>" />
    </div>
</body>

<script type="text/javascript">
    
    try{
        window.attachEvent("onload", function(){fixProgressBar();}); 
        window.focus();
        
    }catch (ex) {}
    
    function fixProgressBar()
    {
	    if(parent.frames['dummyFrame'])
	    {
		    parent.frames['dummyFrame'].document.write("");
		    parent.frames['dummyFrame'].document.close();
	    }    
    }

</script>


</html>
