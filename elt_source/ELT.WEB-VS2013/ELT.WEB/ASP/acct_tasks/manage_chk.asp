<!--  #INCLUDE FILE="../include/transaction.txt" -->
<% Option Explicit %>
<!--  #INCLUDE FILE="../include/connection.asp" -->
<html>
<head>
<title>Print Checks</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../css/elt_css.css" rel="stylesheet" type="text/css">
<script type="text/jscript" language="javascript" src="../include/WebDateSetJN.js" ></script>	
    <style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
a {
	font-size: 9px;
	color: #000000;
	text-decoration: none;
	font-family: Verdana;
}
a:hover {
	color: #b83423;
}
.style5 {color: #cc6600}
-->
    </style>
</head>
<!--  #INCLUDE FILE="../include/header.asp" -->
    <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
<!--  #include file="../include/recent_file.asp" -->
                    <script type="text/javascript">
                        function DisplayResultTable(page) {

                            var index = 1;
                            var t = $("result_table_" + index);
                            while (t != null) {
                               
                                if (page == index)
                                    t.style.display = "block";
                                else
                                    t.style.display = "none";
                                index = index + 1;
                                t = $("result_table_" + index);
                            }
                        }

                    </script>
<%
	Dim PostBack,i,Action
	Dim vStartDate,vEndDate,BankAcct
	Dim filter_string
%>

<%	
	PostBack = Request.QueryString("PostBack")
	if isnull(PostBack) then PostBack = ""
	if PostBack = "" then PostBack = false
	Action = Request.QueryString("Action")	
	if isnull(Action) then Action = ""	
%>

<%
	if not PostBack then
		call get_bank_acct
	end if
%>
<%
	if Action = "" then
	else
		select case Action
			case ""
		end select			
	end if
%>

<%
sub get_bank_acct
	DIM rs,SQL,tmpTable

	set BankAcct = Server.CreateObject("System.Collections.ArrayList")

	SQL= "select * from gl where elt_account_number = " & elt_account_number & " and (gl_account_type='"&CONST__BANK&_
	"') order by isnull(gl_default,'') desc, cast(gl_account_number as NVARCHAR)"
	
	Set rs = eltConn.Execute(SQL)

	do while not rs.EOF
		Set tmpTable = Server.CreateObject("System.Collections.HashTable")
		tmpTable.Add "BankAcctNo", rs("gl_account_number").value
		tmpTable.Add "BankDesc", rs("gl_account_desc").value
		BankAcct.Add tmpTable	
		rs.movenext
	loop
	
	rs.Close
	
	set rs = nothing
end sub
%>
<body link="336699" vlink="336699" topmargin="0">
<form name='form1' method="POST">
 <input type="hidden" name="filter_string" id="filter_string" value="<%=filter_string%>">	
<table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
  <tr>
    <td width="50%" height="32" align="left" valign="middle" class="pageheader">MANAGE Checks  </td>
    <td width="50%" align="right" valign="middle">&nbsp;</td>
  </tr>
</table>
<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#89A979" bgcolor="#89A979" class="border1px">
  <tr> 
    <td>	
        <table width="100%" border="0" cellpadding="0" cellspacing="0">
          <tr> 
            <td colspan="2" height="8" align="left" valign="top" bgcolor="D5E8CB" class="bodyheader"></td>
          </tr>
		  <tr> 
            <td colspan="2" height="1" align="left" valign="top" bgcolor="#89A979" class="bodyheader"></td>
          </tr>
          <tr align="center" valign="middle"> 
            <td colspan="2" bgcolor="#F3f3f3"><br> 
                <table width="64%" border="0" cellpadding="2" cellspacing="0" bordercolor="#89A979" class="border1px">
			  <tr>
			      <td width="1%" bgcolor="#E7F0E2">&nbsp;</td>
			      <td width="43%" height="20" bgcolor="#E7F0E2"><span class="bodyheader style5">Bank Account </span></td>
			      <td width="20%" bgcolor="#E7F0E2"><span class="bodyheader">Period</span></td>
			      <td width="17%" bgcolor="#E7F0E2"><span class="bodyheader">Start Date</span></td>
			      <td width="19%" bgcolor="#E7F0E2"><span class="bodyheader">End Date</span></td>
			      </tr>
			  <tr bgcolor="#FFFFFF"><td>&nbsp;</td>
			  		<td><span class="bodycopy">
			  		    <SELECT name="lstBank" size=1 class="smallselect" style="WIDTH: 240px" 
                            id="lstBank">
						<option Value="0">All</option>
	                  <% if Not IsNull(BankACCT) And Not isEmpty(BankACCT) Then %>
                        <% for i=0 to BankACCT.count-1 %>
                        <option Value="<%=BankACCT(i)("BankAcctNo")%>"><%= BankACCT(i)("BankDesc") %></option>
                        <% next %>
					 <% end if %>		
                      </SELECT>
			  		</span></td>
					<td><select name="lstDate" style="WIDTH: 106px" class="smallselect" 
                            onChange= "Javascript:myRadioButtonforDateSet1CheckDate(this)" id="lstDate">
                        <option value="Clear" > Select </option>
                        <option value="Today">Today</option>
                        <option value="Month to Date">Month to Date</option>
                        <option value="Quarter to Date">Quarter to Date</option>
                        <option value="Year to Date">Year to Date</option>
                        <option value="This Month">This Month</option>
                        <option value="This Quarter">This Quarter</option>
                        <option value="This Year">This Year</option>
                        <option value="Last Month">Last Month</option>
                        <option value="Last Quarter">Last Quarter</option>
                        <option value="Last Year">Last Year</option>
                    </select></td><%= vStartDate %>
					<td><span class="bodycopy">
					    <input name="txtStartDate" class="m_shorttextfield date" 
                            value="" preset="shortdate" size="16" id="txtStartDate" />
					</span></td><%= vEndDate %>
					<td><span class="bodycopy">
					    <input name="txtEndDate" class="m_shorttextfield date" 
                            value="" preset="shortdate" size="16" id="txtEndDate" />
					</span></td>
					</tr>
                <tr align="left" valign="middle">
                    <td height="2" colspan="5" bgcolor="#89A979" class="bodycopy"></td>
                    </tr>
                <tr align="left" valign="middle">
                    <td bgcolor="#f3f3f3" class="bodycopy">&nbsp;</td>
                    <td height="18" align="left" bgcolor="#f3f3f3" class="bodycopy"><span class="bodyheader">List option</span></td>
                    <td bgcolor="#f3f3f3" class="bodyheader">Check #</td>
                    <td bgcolor="#f3f3f3" class="bodycopy">&nbsp;</td>
                    <td bgcolor="#f3f3f3" class="bodycopy">&nbsp;</td>
                    </tr>
                <tr align="left" valign="middle">
                  <td bgcolor="#FFFFFF" class="bodycopy">&nbsp;</td>
                  <td bgcolor="#FFFFFF" class="bodycopy" align="left"><span class="bodyheader">
                      <select name="lstFilter" size=1 class="smallselect" style="WIDTH: 106px" 
                          id="lstFilter">
                          <option value="">All</option>
                          <option value="Uncompleted">Uncompleted</option>
                          <option value="Completed">Completed</option>
                          <option value="Voided">Voided</option>
                      </select>
                      &nbsp;&nbsp;&nbsp;</span></td>
                  <td bgcolor="#FFFFFF" class="bodycopy"><input type="text" id="txtCheckNum" class="m_shorttextfield" /></td>
                  <td bgcolor="#FFFFFF" class="bodycopy"></td>
                  <td align="center" bgcolor="#FFFFFF" class="bodycopy"><img src="../images/button_go.gif" width="31" height="18" onClick="doBtn(this)"  id="bGo" style="cursor:hand"></td>
                  </tr>
              </table>
                <table width="64%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td><span class="bodycopy">
                            <input id="txt_status" class="bodycopy" name="txt_status" style="width: 70px; text-align:left; border-style:none; background-color:#f3f3f3" type="text"  readonly="true"/>
                        </span></td>
                    </tr>
                </table></td>
          </tr>
        </table>
	  </td>
    </tr>
</table>
<!-- start of result panel -->
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#89A979" class="border1px">
		  <tr align="left" bgcolor="#f3f3f3" valign="top">
			<td height="22" align="center" valign="top" bgcolor="#FFFFFF" id="td_result"></td>
		  </tr>
		  <tr align="left" valign="top">
		      <td height="1" align="center" valign="top" bgcolor="#89A979"></td>
	        </tr>
		  <tr align="left" bgcolor="#f3f3f3" valign="top">
		      <td height="24" align="center" valign="top" bgcolor="#D5E8CB"></td>
	        </tr>
    </table>
<!-- end of result panel -->	
	<input type="hidden" name="selItems" id="selItems">			
</form>
<script language="javascript" type="text/javascript" src="/ASP/ajaxFunctions/ajax.js"></script>
<script language="javascript" type="text/javascript" src="/ASP/ajaxFunctions/otherFunctions.js"></script>
<script language="javascript">

function create_innerHTML_for_chk(htmlText){
		var selectHtml = htmlText;
		var td_result = document.getElementById('td_result');
		if (td_result) {
			td_result.innerHTML = selectHtml;
		}	
		var str = document.getElementById('selItems').value;
		var selItems = 	str.split('^');
		if(selItems.length == 1 ) {
			set_table_chk_box(true,eval("document.form1.img" + str));
			return false;
		}
		if(selItems.length > 1) {
			var itemL = document.all.chk.length;
			for( i=0; i<selItems.length;i++) {
				if(selItems[i] != '') {
					set_table_chk_box(true,eval("document.form1.img" + selItems[i]));
				}		
			}
		}
		return false;
}

function showResponseFindResult(req,field,tmpVal,tWidth,tMaxLength,url,post_parameter) {
	if (req.readyState == 4) {
		if (req.status == 200) {
			create_innerHTML_for_chk(req.responseText);
			document.getElementById('txt_status').value= '';
			if (req.responseText.indexOf('No data was found.') < 0 ) {
				put_history(url,post_parameter);			
			}
		} else {
			document.write(req.responseText);		
		}
	}	
}

function get_post_parameters_chk() {

var startDate  = document.getElementById('txtStartDate').value;
var endDate  = document.getElementById('txtEndDate').value;
var oSelect = document.getElementById('lstBank');
var text = oSelect.options[ oSelect.options.selectedIndex ].value;
var oSelect2 = document.getElementById('lstFilter');
var text2 = oSelect2.options[ oSelect2.options.selectedIndex ].value;
var checkNum = document.getElementById("txtCheckNum").value;

var post_parameter = '';
	
	post_parameter += 'startDate=' + startDate + '&';
	post_parameter += 'endDate=' + endDate + '&';
	post_parameter += 'bank=' + text + '&';
	post_parameter += 'opt=' + text2 + '&';
	post_parameter += 'CheckNum=' + checkNum + '&';
	
	return post_parameter;
}

		function sel_all_table(how) {
			var itemL = document.all.chk.length;
			var selStr = '';
			if(itemL) {
			    for (i = 0; i < itemL; i++) {
			        var seq = document.all.chk[i].id.replace("chkimg", "");
			        set_table_chk_box(how, eval("document.form1.img" + seq));
			        if (how) { selStr += seq + '^'; }
				}
			} else {
			    var seq = document.all.chk.id.replace("chkimg", "");
			    set_table_chk_box(how, eval("document.form1.img" + seq));
			    if (how) { selStr += dseq + '^'; }
			}
			document.getElementById('selItems').value = selStr;							
		}
		
		function set_table_chk_box(how,obj){
		   if (obj) {
				if(how) {
						obj.checkeditem = "Y";
						obj.src = "../images/checkbox_o.gif";
						eval("document.form1.chk" + obj.id + ".value='on'");

				} else {
						obj.checkeditem = "N";
						obj.src = "../images/checkbox_n.gif";
						eval("document.form1.chk" + obj.id + ".value='off'");
				}
			}	
		}	
		function DoChecking(seq){
			eval("document.form1.img" + seq + ".click()");
		}
		function ItemWasChecked(obj) {
			if (obj.checkeditem == "N"){
				obj.checkeditem = "Y";
				obj.src = "../images/checkbox_o.gif";
				eval("document.form1.chk" + obj.id + ".value='on'");
				document.getElementById('selItems').value = document.getElementById('selItems').value + '^' + obj.id.substr(3);
			}else{
				obj.checkeditem = "N";
				obj.src = "../images/checkbox_n.gif";
				eval("document.form1.chk" + obj.id + ".value='off'");
				var str = document.getElementById('selItems').value;
				document.getElementById('selItems').value = str.replace(obj.id.substr(3),'');
				document.getElementById('selItems').value = document.getElementById('selItems').value.replace('^^','');
			}
		}		
				
		function doBtn(o) {
			try {
					switch(o.id) {
						case 'bGo' :
									document.getElementById('selItems').value = '';				
									document.getElementById('filter_string').value = '';				
									var post_parameter = get_post_parameters_chk();
									go_search("/ASP/ajaxFunctions/ajax_get_chk_result_html.asp?Action=Search&WindowName="
									 +window.name,post_parameter);							 
									break;
						case 'bRefresh' :
							refresh();	
							break;										
						case 'bSelAll' :
							sel_all_table(true);	
							break;										
						case 'bUselAll' :
							sel_all_table(false);	
							break;										
						case 'bClear' :
							modify_check_selected(o.id);	
							break;										
						case 'bUclear' :
							modify_check_selected(o.id);	
							break;										
						case 'bVoid' :
							modify_check_selected(o.id);	
							break;										
						case 'bUvoid' :
							modify_check_selected(o.id);	
							break;										
						default :
							break;
					}
			} catch(ex) {}
		}
		
		function convert_check_str(retVal) {
			while(retVal.indexOf("^") != -1) { retVal = retVal.replace('^',':');	}			
			if(retVal.substr(0,1) == ':') {
				retVal = retVal.substr(1);
			}
			return retVal;
		}

		function modify_check_selected(o) {
			var retVal = document.getElementById('selItems').value;						
			if(retVal == '') {
				alert('Please select at least one item.');
					return;
			}
			retVal = convert_check_str(retVal);	
			goModify(retVal+':',o);
		}
		function goModify(ns,o) {
			if (!ns) return false;
			var msgBox = document.getElementById('txt_status');
			msgBox.value= 'modify check...';		
			var post_parameter = get_post_parameters_chk();
			var url = "/ASP/ajaxFunctions/ajax_get_chk_result_html.asp?Action="+o+"&WindowName="+window.name;	
			new ajax.xhr.Request('POST',post_parameter+'param='+ns,url,showResponseFindResult,'','','');			
		}
		// start of history
		var objectHistory = null;
		if(window.parent.dhtmlHistory != null && typeof(window.parent.dhtmlHistory) != 'undefined' ) {
			objectHistory = window.parent;
		} 
		else {
			document.write("<scr"+"ipt type=text/javascript src='/ASP/ajaxFunctions/lib/dhtmlHistory.js'><\/scr"+"ipt>"); 
			objectHistory = window;
		}
		window.onload = initialize;
		
		function initialize() {
			  objectHistory.dhtmlHistory.initialize();
			  objectHistory.dhtmlHistory.addListener(historyfunc);
			  if(objectHistory.dhtmlHistory.isFirstLoad() ) {
					var post_parameter = get_post_parameters_chk();
					objectHistory.historyStorage.reset();					
					go_search("/ASP/ajaxFunctions/ajax_get_chk_result_html.asp?Action=Search&WindowName="
					 +window.name,post_parameter);							 							
			  }
		}
		
		function historyfunc(HistoryName, HistoryValue) {
			  if(HistoryValue == null) return;
			  var storage_data = objectHistory.historyStorage.get(HistoryValue);
			  if ( storage_data != null ) {
					var url = "/ASP/ajaxFunctions/ajax_get_chk_result_html.asp?Action=Search&WindowName="
					 +window.name;
					var post_parameter = storage_data.split(':')[1];
					go_search(url,post_parameter);							 
			  } 
		}
		
		function $() {
		  var element = arguments[0];
		  var elength = document.getElementsByName(element).length;
		  return (elength > 1) 
			? document.getElementsByName(element) 
			: document.getElementById(element);
		}

		var his_id = '';
		
		function put_history(url,post_parameter) {
			  var historyID   = 'HIS_ID:' + his_id;
			  var historyDATAID = 'HIS_DATA_ID_' + his_id;
			  objectHistory.dhtmlHistory.add(historyID , historyDATAID);
			  objectHistory.historyStorage.put(historyDATAID, url+ ":" + post_parameter);
		}
// end of history
		
		function go_search(url,post_parameter) {
			var msgBox = document.getElementById('txt_status');
			msgBox.value= 'loading...';		
			new ajax.xhr.Request('POST',post_parameter,url,showResponseFindResult,'','','');			
		}

		function refresh() {
			  var storage_data = objectHistory.historyStorage.get('HIS_DATA_ID_');
			  if ( storage_data != null ) {
					var sortVal = '';
					var url = filter_url(storage_data.split(':')[0]);
					var post_parameter = storage_data.split(':')[1];
					go_search(url,post_parameter);
			  }		
		}

		function result_sort(oTd) {
			  var storage_data = objectHistory.historyStorage.get('HIS_DATA_ID_');
			  if ( storage_data != null ) {
					var sortVal = '';
					if(oTd.value == '') {
						sortVal = '&sortA=' + oTd.id;					
					}
					else {
							if(oTd.value == 'A') {
								sortVal = '&sortD=' + oTd.id;					
							} else {
								sortVal = '&sortA=' + oTd.id;												
							}
					}
					var url = filter_url(storage_data.split(':')[0]) + sortVal;
					var post_parameter = storage_data.split(':')[1];
					go_search(url,post_parameter);
			  }		
		}
		function filter_url(url) {
			if(url.indexOf('&sortA') > 0 ) {
				url = url.substr(0,url.indexOf('&sortA'));
			}
			if(url.indexOf('&sortD') > 0 ) {
				url = url.substr(0,url.indexOf('&sortD'));
			}
			return url
		}
		
		function goLink(type,n) {
			if(type == 'BP-CHK') {
				var url = 'pay_bills.asp?EditCheck=yes&CheckQueueID='+n;
			} else {
				var url = 'write_chk.asp?EditCheck=yes&CheckQueueID='+n;
			}
			var argS = 'menubar=1,toolbar=1,height=610,width=900,hotkeys=0,scrollbars=1,resizable=1';
			window.open(url,'PopWin', argS);
			return false;			
		}
		
	</script>	
</script>
	<%
	if not PostBack then
	%>
	<script language="javascript">
		document.getElementById('lstDate').selectedIndex = 2;
		myRadioButtonforDateSet1CheckDate(document.getElementById('lstDate'));
	</script>	
	<%
	end if
	%>
</body>
<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
