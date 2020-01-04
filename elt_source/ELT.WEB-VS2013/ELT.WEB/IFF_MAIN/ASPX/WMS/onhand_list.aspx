<%@ Page Language="C#" AutoEventWireup="true" CodeFile="onhand_list.aspx.cs" Inherits="ASPX_WMS_onhand_list"
    Culture="auto" meta:resourcekey="PageResource1" UICulture="auto" CodePage="65001" %>

<%@ Register Assembly="iMoon.WebControls.ComboBox" Namespace="iMoon.WebControls"
    TagPrefix="iMoon" %>

<%@ Register TagPrefix="igtbl" Namespace="Infragistics.WebUI.UltraWebGrid" Assembly="Infragistics.WebUI.UltraWebGrid, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>On_Hand Page</title>
    <meta http-equiv="Content-Type" content="text/html; UTF-8" />
    <link href="/IFF_MAIN/ASPX/CSS/elt_css.css" rel="stylesheet" type="text/css" />
    <link href="../CSS/AppStyle.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        .fromCalendar{
            position:absolute; 
            top:0px; 
            left:20px; 
            background-color:#FFFFFF;
            z-index:2;
        }
        .toCalendar{
            position:absolute; 
            top:115px; 
            left:446px; 
            background-color:#ffffff;
            z-index:2;
        }
        body {
	        margin-left: 0px;
	        margin-right: 0px;
	        margin-bottom: 0px;
        }
        .style1 {color: #c16b42}

        #Layer1 {
	        position:absolute;
	        width:320px;
	        height:180;
	        z-index:1;
	        left: 534px;
	        top: 81px;
        }
		.style2 {
			margin-left:18px;
		}
                       </style>

    <script type="text/javascript" language="javascript" src="/ASP/ajaxFunctions/ajax.js"></script>
    <script src="/IFF_MAIN/ASPX/jScripts/ig_editDrop1.js" type="text/javascript"></script>

    <script type="text/javascript" src="/ASP/include/JPED.js">
        function lstAccountOfName_onclick() {
        }

    </script>

    <script type="text/jscript">

        function lstAccountOfChange(orgNum,orgName) {
        
        var url;
             if (orgNum=="" || orgName=="")
             {
             url = "./onhand_list.aspx" 
             }
             else
             {
                url = "./onhand_list.aspx?orgAcct=" + orgNum + "&orgName=" + encodeURIComponent(orgName);
             }
            document.location.href = url;
        }
        
       function CheckDate() {

           if( document.form1.ComboBox1.value != "") {
	            document.form1.txtNum.value = document.form1.ComboBox1.selectedIndex;
	             return true;
            }
            if( document.form1.lstSearchNum.value != "") return true;
            if( document.form1.txtHAWBNum.value != "") return true;
            if( document.form1.txtMAWBNum.value != "") return true;
            if( document.form1.txtRefNo.value != "") return true;
            if( document.form1.txtFileNo.value != "") return true;

            Webdatetimeedit1
            var    a=Wedit1.getValue();
		            if(!a)  {
		            alert(' Please input the from date!');
		            return false;
		            }
            		
		            return true;
		}
		   function lstSearchNumChange(argV,argL){
            var divObj = document.getElementById("lstSearchNumDiv");
		    var hiddenObj = document.getElementById("hSearchNum");
		    var txtObj = document.getElementById("lstSearchNum");	
       
            //var url = "/ASP/ajaxFunctions/ajax_warehouse_receipt.asp?mode=view&uid=" + argV;
            //new ajax.xhr.Request('GET','',url,displayScreen,'','','','');
            hiddenObj.value = argV;
//		    infoObj.value = getOrganizationInfo(orgNum,"B");
		    txtObj.value = argL;	    
            divObj.style.visibility = "hidden";
            divObj.style.position = "absolute";
		    divObj.innerHTML = "";
        }
		
		
		
        function lstDataChange(orgNum,orgName) {
            var url = "./onhand_list.aspx?orgAcct=" + orgNum + "&orgName=" + encodeURIComponent(orgName);
            document.location.href = url;
        }
        
       function lstAccountOfChange2(ANum,AName){
        var AdivObj = document.getElementById("lstAccountOfNameDiv");
		var AhiddenObj = document.getElementById("hAccountOfAcct");
		var AtxtObj = document.getElementById("lstAccountOfName");

		AhiddenObj.value = ANum;

		AtxtObj.value = AName;
		AdivObj.style.position = "absolute";
		AdivObj.style.visibility = "hidden";
		AdivObj.innerHTML = "";		
	}
        
        function getOrganizationInfo(orgNum,infoFormat){
            if (window.ActiveXObject) {
                try {
                    xmlHTTP = new ActiveXObject("Msxml2.XMLHTTP");
                } catch(error) {
                    try {
                        xmlHTTP = new ActiveXObject("Microsoft.XMLHTTP");
                    } catch(error) { return ""; }
                }
            } 
            else if (window.XMLHttpRequest) {
                xmlHTTP = new XMLHttpRequest();
            } 
            else { return ""; }

            var url="/ASP/ajaxFunctions/ajax_get_org_address_info.asp?type=" + infoFormat + "&org=" + orgNum;

            xmlHTTP.open("GET",url,false);
            xmlHTTP.send();
            
            return xmlHTTP.responseText; 
        }
        
    // End of list change effect ///////////////////////////////////////////////////////////////////  
    
        function checkAllWRs() {
            var chkObj = document.getElementsByName("chkWR");
            var txtObj = document.getElementsByName("txtPiece");

            for(var i=0;i<chkObj.length;i++){
                chkObj[i].checked = true;
                txtObj[i].style.backgroundColor = "transparent";
                txtObj[i].readOnly = false;
            }
        }
        
        function countChecked() {
            var count = 0;
            var chkObj = document.getElementsByName("chkWR");
            var txtObj = document.getElementsByName("txtPiece");

            for(var i=0;i<chkObj.length;i++){
                if(chkObj[i].checked) count++;
            }
            return count;
        }
        
        function clearAll() {
            var url = "./onhand_list.aspx";
            document.location.href = url;
        }
            
        function enableTxtPiece(chkObj,row_id) {
            var txtObj = document.getElementById("txtPiece" + row_id);
            txtObj.readOnly = !chkObj.checked;
            
            
            if(!txtObj.readOnly){
                txtObj.style.backgroundColor = "transparent";
            }
            else{
                txtObj.style.backgroundColor = "#cccccc";
            }
        }
        
        
       function searchNumFill(obj,changeFunction,vHeight){
            var qStr = obj.value;
            var keyCode = window.event.keyCode;
            var url;

            if(qStr != "" && keyCode != 229 && keyCode != 27){
                url = "/ASP/ajaxFunctions/ajax_warehouse_receipt.asp?mode=list&qStr=" + qStr;
                FillOutJPED(obj,url,changeFunction,vHeight);
            }
        }

        
        function searchNumFillAll(objName,changeFunction,vHeight){
            var obj = document.getElementById(objName);
            
            url = "/ASP/ajaxFunctions/ajax_warehouse_receipt.asp?mode=list2";
            FillOutJPED(obj,url,changeFunction,vHeight);
        }
        function checkPieceLimit(txtObj,limitPiece) {
            if (txtObj.value > limitPiece){
                alert("Can't enter more than remaining pieces");
                txtObj.value = limitPiece;
            }
        }
        function jPopUpNormal(){
            var argS = 'menubar=1,toolbar=1,height=400,width=780,hotkeys=0,scrollbars=1,resizable=1';
            popUpWindow = window.open('','popUpWindow', argS);
        }
        function goWRScreen(orgnum,orgname) {
               url ="/ASP/WMS/warehouse_receipt.asp?o="+orgname+"&n="+orgnum+ "&WindowName=popUpWindow";
               window.open(url, 'popUpWindow', 'menubar=1,toolbar=1,hotkeys=1,status=1,location=0,scrollbars=1,resizable=1,width=900,height=600');
			}
			

	    function goCustomerScreen(cus_acct) {
    
                url ="/ASP/master_data/client_profile.asp?Action=filter&n="+cus_acct+ "&WindowName=popUpWindow";
               window.open(url, 'popUpWindow', 'menubar=1,toolbar=1,hotkeys=1,status=1,location=0,scrollbars=1,resizable=1,width=900,height=600');
			}			

        
    </script>
    <script src="/Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
    <script src="/Scripts/jquery-ui-1.8.20.min.js" type="text/javascript"></script>
    <script src="/Scripts/jquery.plugin.period.js" type="text/javascript"></script>
     <link href="/Scripts/jquery-ui-1.10.3/themes/base/jquery-ui.css"
        rel="stylesheet" type="text/css" />
    <script type="text/javascript">

        $(document).ready(function () {
            $("#Webdatetimeedit1").datepicker();
            $("#Webdatetimeedit2").datepicker();
            $("#ddlPeriod").PeriodList({ StartDateField: $("#Webdatetimeedit1").get(0), EndDateField: $("#Webdatetimeedit2").get(0) });
        });
    </script>
</head>
<body>
    <form id="form1" runat="server" class="bodycopy">
        <input type="image" style="position:absolute; visibility:hidden" onclick="return false;" />
        <input type="hidden" id="hTotalPCS" name="hTotalPCS" value="0" />
        <!-- page title -->
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td width="50%" align="left" valign="middle" class="pageheader">
                    On-Hand Report
                </td>
                <td width="50%" align="right" valign="middle">
            </tr>
        </table>
        <!--warp table starts -->
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#9e816e"
            class="border1px">
            <tr>
                <td height="8" bgcolor="#e5cfbf">
                </td>
            </tr>
            <tr>
                <td height="1" bgcolor="#9e816e">
                </td>
            </tr>
            <tr>
                <td align="center" bgcolor="#f3f3f3" class="bodycopy" style="padding-left: 10px">
                    <br />
                    <br />
                    <table width="36%" border="0" cellpadding="0" cellspacing="0" bordercolor="#9e816e"
                        bgcolor="#FFFFFF" class="border1px" style="padding-left: 8px">
                        <tr>
                            <td align="left" bgcolor="#f4e9e0" style="height: 20px">
                                <span class=" bodyheader style1">Date as of </span>
                            </td>
                        </tr>
                        <tr>
                            <td align="left" valign="middle">
                                <table border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td colspan="2" align="left" style="width: 110px; height: 22px">
                                            <asp:TextBox runat="server" ID="Webdatetimeedit1"></asp:TextBox>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td height="2" align="left" valign="middle" bgcolor="#9e816e">
                            </td>
                        </tr>
                        <tr>
                            <td height="18" align="left" bgcolor="#f3f3f3" class="bodyheader">
                                Customer</td>
                        </tr>
                        <tr>
                            <td align="left">
                                <!-- Start JPED -->
                                <input type="hidden" id="hAccountOfAcct" name="hAccountOfAcct" value="<%=Request.Form.Get("hAccountOfAcct") %>" />
                                <div id="lstAccountOfNameDiv">
                                </div>
                                <table cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td style="height: 17px">
                                            <!--<%=Request.Params.Get("orgName") %>-->
                                            <input type="text" autocomplete="off" id="lstAccountOfName" name="lstAccountOfName"
                                                value="<%=Request.Form.Get("lstAccountOfName") %>" class="shorttextfield" style="width: 240px;
                                                border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-left: 1px solid #7F9DB9;
                                                border-right: 0px solid #7F9DB9; color: Black" onkeyup="organizationFill(this,'','lstAccountOfChange2')"
                                                onfocus="initializeJPEDField(this,event);" language="javascript" onclick="return lstAccountOfName_onclick()" /></td>
                                        <td style="height: 17px">
                                            <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="organizationFillAll('lstAccountOfName','','lstAccountOfChange2')"
                                                style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                        <td style="height: 17px">
                                            <!-- <img src="/ig_common/Images/combobox_addnew.gif" alt="" border="0" style="cursor: pointer onclick="quickAddClient('hAccountOfAcct','lstAccountOfName','txtAccountOfInfo')" /></td>
                                        <td width="20%" style="padding-left: 10px; height: 44px
                                        -->
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td align="left" bgcolor="#f3f3f3" class="bodyheader" style="height: 17px">
                                Warehouse Receipt No.
                            </td>
                        </tr>
                        <tr>
                            <td align="left" style="height: 20px">
                                <!-- Start JPED -->
                                <input type="hidden" id="hSearchNum" name="hSearchNum" />
                                <div id="lstSearchNumDiv">
                                </div>
                                <table border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td>
                                            <!--<input type="text"-->
                                            <asp:TextBox ID="lstSearchNum" runat="server" name="lstSearchNum" autocomplete="off"
                                                class="shorttextfield" Style="width: 120px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9; color: Black"
                                                onKeyUp=" searchNumFill(this,'lstSearchNumChange','');" onfocus="initializeJPEDField(this,event);"></asp:TextBox></td>
                                        <!--docModified(-1);-->
                                        <td>
                                            <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="searchNumFillAll('lstSearchNum','lstSearchNumChange',200);"
                                                style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                        <td style="padding-left: 10px; width: 4%;">
                                        </td>
                                        <td style="padding-left: 10px">
                                            <asp:CheckBox ID="check1" Text="Sort by Customer" TextAlign="Right" runat="server" /></td>
                                        <!--<asp:TextBox ID="txtWR" runat="server"></asp:TextBox></td>-->
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td align="right" bgcolor="#f3f3f3" style="padding: 3px 24px 3px">
                                <asp:ImageButton ID="ImageButton1" runat="server" ImageUrl="../../Images/button_go.gif"
                                    OnClick="Page_Load"></asp:ImageButton></td>
                        </tr>
                    </table>
                    <asp:TextBox ID="sortway" runat="server" CssClass="m_shorttextfield" Enabled="true"
                        Width="70px"></asp:TextBox>
                    <asp:TextBox ID="sortway2" runat="server" CssClass="m_shorttextfield" Width="120px"></asp:TextBox>
                    <br />
                </td>
            </tr>
            <tr>
                <td height="24" bgcolor="#f3f3f3" style="padding-left: 10px">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td width="61%">
                                <asp:ImageButton ID="ExcelPrintButton" runat="server" ImageUrl="../../Images/button_exel.gif"
                                    OnClick="ExcelPrintButton_Click"></asp:ImageButton>
                                <asp:ImageButton ID="PDFPrintButton" runat="server" ImageUrl="../../Images/button_pdf.gif"
                                    OnClick="PDFPrintButton_Click" CssClass="style2"></asp:ImageButton></td>
                            <td width="39%" align="right" class="bodycopy" style="padding-right: 10px">
                                &nbsp;</td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td height="2" bgcolor="#9e816e">
                </td>
            </tr>
            <tr>
                <td bgcolor="#f4e9e0">
                    <!-- ship out list starts -->
                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td width="100%">
                                <asp:GridView ID="GridView1" runat="server" AllowPaging="True" AutoGenerateColumns="False"
                                    OnPageIndexChanging="GridView1_PageIndexChanging" OnRowCommand="GridView1_RowCommand"
                                    Width="100%" BorderWidth="0px" CellPadding="0">
                                    <PagerSettings Position="Top" />
                                    <PagerStyle CssClass="bodyheader" Font-Bold="True" HorizontalAlign="Right" BorderStyle="None"
                                        ForeColor="Black" />
                                    <HeaderStyle BorderStyle="None" HorizontalAlign="Left" VerticalAlign="Middle" Width="100%" />
                                    <RowStyle BackColor="White" BorderStyle="None" />
                                    <AlternatingRowStyle BackColor="#F3F3F3" />
                                    <Columns>
                                        <asp:TemplateField>
                                            <HeaderTemplate>
                                                <!-- list header -->
                                                <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                                    <tr>
                                                        <td bgcolor="#f4e9e0" class="bodyheader style1" style="padding-left: 12px; height: 20px;">
                                                            ON-HAND REPORT
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td height="1" align="left" valign="middle" bgcolor="#9e816e">
                                                        </td>
                                                    </tr>
                                                </table>
                                                <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                                    <tr class="bodyheader" align="left">
                                                        <td width="1%" height="13" rowspan="2" align="left" bgcolor="#f3f3f3">
                                                        </td>
                                                        <td width="8%" rowspan="2" align="left" bgcolor="#f3f3f3">
                                                            Received Date<asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif"
                                                                OnClick="date_Click" ID="ImageButton3" /></td>
                                                        <td width="9%" rowspan="2" align="left" bgcolor="#f3f3f3">
                                                            W/R No.<asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif" OnClick="number_Click"
                                                                ID="Mast_Sort1" /></td>
                                                        <td width="16%" rowspan="2" align="left" bgcolor="#f3f3f3">
                                                            Customer<asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif" OnClick="customer_Click"
                                                                ID="Customer_sort" /></td>
                                                        <td width="10%" rowspan="2" align="left" bgcolor="#f3f3f3">
                                                            Customer Ref No.</td>
                                                        <td width="8%" rowspan="2" align="left" bgcolor="#f3f3f3">
                                                            P.O. No.</td>
                                                        <td width="16%" rowspan="2" align="left" bgcolor="#f3f3f3">
                                                            Received from</td>
                                                        <td width="18%" rowspan="2" align="left" bgcolor="#f3f3f3">
                                                            Descriptions</td>
                                                        <td colspan="2" align="center" bgcolor="#f3f3f3" style="border-left: 1px solid #9e816e">
                                                            NO. OF QTY</td>
                                                    </tr>
                                                    <tr class="bodyheader" align="left">
                                                        <td width="7%" height="13" align="center" bgcolor="#f3f3f3" style="border-left: 1px solid #9e816e;
                                                            border-top: 1px solid #9e816e">
                                                            Received</td>
                                                        <td width="7%" bgcolor="#f3f3f3" align="center" style="border-left: 1px solid #9e816e;
                                                            border-top: 1px solid #9e816e">
                                                            <span class="style1">On-Hand </span>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="10" height="1" bgcolor="#9e816e">
                                                        </td>
                                                    </tr>
                                                </table>
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <!-- list item -->
                                                <table cellpadding="0" cellspacing="0" border="0" style="width: 100%">
                                                    <tr id='Row<%# Eval("auto_uid").ToString() %>' align="left">
                                                        <td width="1%" align="left" height="20">
                                                            <input type="hidden" name="hWRNum" value="<%# Eval("wr_num").ToString() %>" />
                                                            <input type="hidden" name="hWRValue" value="<%# Eval("auto_uid").ToString() %>" />
                                                        </td>
                                                        <td width="8%" align="left">
                                                            <%# Eval("received_date","{0:d}").ToString() %>
                                                        </td>
                                                        <td width="9%" align="left" class="searchList">
                                                            <a href="javascript:;" onclick="goWRScreen('<%# Eval("auto_uid").ToString() %>','<%# Eval("wr_num").ToString() %>')">
                                                                <%# Eval("wr_num").ToString() %>
                                                            </a>
                                                        </td>
                                                        <td width="16%" align="left" class="searchList">
                                                            <a href="javascript:;" onclick="goCustomerScreen('<%# Eval("customer_acct").ToString() %>')">
                                                                <%# Eval("customer_name").ToString() %>
                                                            </a>
                                                        </td>
                                                        <td width="10%" align="left">
                                                            <%# Eval("customer_ref_no").ToString() %>
                                                        </td>
                                                        <td width="8%" align="left">
                                                            <%# Eval("PO_No").ToString() %>
                                                        </td>
                                                        <td width="16%" align="left" class="searchList">
                                                            <a href="javascript:;" onclick="goCustomerScreen('<%# Eval("shipper_acct").ToString() %>')">
                                                                <%# Eval("shipper_name").ToString() %>
                                                            </a>
                                                        </td>
                                                        <td width="18%" align="left">
                                                            <%# Eval("item_desc").ToString()%>
                                                        </td>
                                                        <td width="7%" align="right" style="padding-right: 10px">
                                                            <%# Eval("item_piece_origin").ToString() %>
                                                        </td>
                                                        <td width="7%" align="right" style="padding-right: 10px" class="bodyheader">
                                                            <%# Eval("remain").ToString() %>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td align="left" valign="middle" bgcolor="#ffffff">
                    <asp:GridView ID="GridView2" runat="Server" AllowPaging="True" AutoGenerateColumns="False"
                        OnPageIndexChanging="GridView2_PageIndexChanging" Width="100%" BorderWidth="0px"
                        BorderStyle="None" CellPadding="0">
                        <PagerSettings Position="Top" />
                        <PagerStyle CssClass="bodyheader" Font-Bold="True" HorizontalAlign="Right" BorderStyle="None"
                            BackColor="White" ForeColor="Black" />
                        <HeaderStyle BorderStyle="None" HorizontalAlign="Left" VerticalAlign="Middle" Width="100%" />
                        <RowStyle BackColor="#F3F3F3" BorderStyle="None" />
                        <AlternatingRowStyle BackColor="White" />
                        <Columns>
                            <asp:TemplateField>
                                <HeaderTemplate>
                                    <!-- list header -->
                                    <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                        <tr>
                                            <td bgcolor="#f4e9e0" class="bodyheader style1" style="padding-left: 12px; height: 20px;">
                                                ON-HAND REPORT
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height="1" align="left" valign="middle" bgcolor="#9e816e">
                                            </td>
                                        </tr>
                                    </table>
                                    <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                                        <tr class="bodyheader" align="left">
                                            <td width="1%" height="13" rowspan="2" align="left" bgcolor="#f3f3f3">
                                            </td>
                                            <td width="10%" rowspan="2" align="left" bgcolor="#f3f3f3">
                                                Received Date<asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif"
                                                    OnClick="date_Click" ID="ImageButton3" /></td>
                                            <td width="9%" rowspan="2" align="left" bgcolor="#f3f3f3">
                                                W/R No.<asp:ImageButton runat="server" ImageUrl="../../images/collapse.gif" OnClick="number_Click"
                                                    ID="Mast_Sort1" /></td>
                                            <td width="10%" rowspan="2" align="left" bgcolor="#f3f3f3">
                                                Customer Ref No.</td>
                                            <td width="10%" rowspan="2" align="left" bgcolor="#f3f3f3">
                                                P.O. No.</td>
                                            <td width="18%" rowspan="2" align="left" bgcolor="#f3f3f3">
                                                Received from</td>
                                            <td width="10%" rowspan="2" align="left" bgcolor="#f3f3f3">
                                                Storage Start Date</td>
                                            <td width="18%" rowspan="2" align="left" bgcolor="#f3f3f3">
                                                Descriptions</td>
                                            <td colspan="2" align="center" bgcolor="#f3f3f3" style="border-left: 1px solid #9e816e">
                                                NO. OF QTY</td>
                                        </tr>
                                        <tr class="bodyheader" align="left">
                                            <td width="7%" height="13" align="center" bgcolor="#f3f3f3" style="border-left: 1px solid #9e816e;
                                                border-top: 1px solid #9e816e">
                                                Received</td>
                                            <td width="7%" bgcolor="#f3f3f3" align="center" style="border-left: 1px solid #9e816e;
                                                border-top: 1px solid #9e816e">
                                                <span class="style1">On-Hand </span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="10" height="1" bgcolor="#9e816e">
                                            </td>
                                        </tr>
                                    </table>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <table width="100%" id="ChildTable<%# Eval("row_index").ToString() %>">
                                        <tr>
                                            <td class="bodyheader" style="padding-left: 10px">
                                                <%# Eval("customer_name").ToString() %>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:GridView ID="GridView3" runat="server" AllowPaging="True" AutoGenerateColumns="False"
                                                    OnPageIndexChanging="GridView3_PageIndexChanging" Width="100%" BorderWidth="0px"
                                                    BorderStyle="None" CellPadding="0">
                                                    <PagerSettings Position="Top" />
                                                    <PagerStyle CssClass="bodyheader" Font-Bold="True" HorizontalAlign="Right" BorderStyle="None"
                                                        BackColor="White" ForeColor="Black" />
                                                    <HeaderStyle BorderStyle="None" HorizontalAlign="Left" VerticalAlign="Middle" Width="100%" />
                                                    <Columns>
                                                        <asp:TemplateField>
                                                            <HeaderTemplate>
                                                                <!-- list header -->
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <!-- list item -->
                                                                <table cellpadding="0" cellspacing="0" border="0" style="width: 100%">
                                                                    <tr id='Row<%# Eval("auto_uid").ToString() %>'>
                                                                        <td width="1%" align="left" height="20">
                                                                            <input type="hidden" name="hWRNum" value="<%# Eval("wr_num").ToString() %>" />
                                                                            <input type="hidden" name="hWRValue" value="<%# Eval("auto_uid").ToString() %>" />
                                                                            <!-- Eval("item_piece_origin-item_shipout").ToString() %>  -->
                                                                        </td>
                                                                        <td width="10%" align="left">
                                                                            <%# Eval("received_date","{0:d}").ToString() %>
                                                                        </td>
                                                                        <td width="9%" align="left" class="searchList">
                                                                            <a href="javascript:;" onclick="goWRScreen('<%# Eval("auto_uid").ToString() %>','<%# Eval("wr_num").ToString() %>')">
                                                                                <%# Eval("wr_num").ToString() %>
                                                                            </a>
                                                                        </td>
                                                                        <td width="10%" align="left">
                                                                            <%# Eval("customer_ref_no").ToString() %>
                                                                        </td>
                                                                        <td width="10%" align="left">
                                                                            <%# Eval("PO_NO").ToString() %>
                                                                        </td>
                                                                        <td width="18%" align="left" class="searchList">
                                                                            <a href="javascript:;" onclick="goCustomerScreen('<%# Eval("shipper_acct").ToString() %>')">
                                                                                <%# Eval("received_name").ToString()%>
                                                                            </a>
                                                                        </td>
                                                                        <td width="10%" align="left">
                                                                            <%# Eval("storage_date", "{0:d}").ToString()%>
                                                                        </td>
                                                                        <td width="18%" align="left">
                                                                            <%# Eval("item_desc").ToString()%>
                                                                        </td>
                                                                        <td width="7%" align="right" style="padding-right: 10px">
                                                                            <%# Eval("item_piece_origin").ToString() %>
                                                                        </td>
                                                                        <td width="7%" align="right" style="padding-right: 10px" class="bodyheader">
                                                                            <%# Eval("remain").ToString() %>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                    </Columns>
                                                </asp:GridView>
                                    </table>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EditRowStyle BorderStyle="None" />
                    </asp:GridView>
                </td>
            </tr>
            <tr>
                <td>
                    <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                        <tr class="bodyheader" align="left">
                            <td width="68%" align="left" height="20">
                            </td>
                            <td width="18%" align="Right">
                                Total:</td>
                            <td width="7%" align="right" style="padding-right: 10px">
                                <p>
                                    <asp:Label ID="label2" runat="server" /></p>
                            </td>
                            <td width="7%" align="right" style="padding-right: 10px" class="bodyheader">
                                <p>
                                    <asp:Label ID="label1" runat="server" /></p>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    <p>
                        <asp:Label ID="label3" runat="server" /></p>
                </td>
            </tr>
            <!-- wrap table ends -->
        </table>
        <p>
            <asp:Button ID="btnValidate" runat="server" Text="for Validation" Visible="False"></asp:Button>
            <asp:HiddenField ID="hCommand" runat="server" />
            <asp:LinkButton ID="LinkButton1" runat="server" Visible="False">LinkButton</asp:LinkButton><asp:TextBox
                ID="txtNum" runat="server" Height="1px" Width="1px"></asp:TextBox><!-- end --></p>
        
    </form>


</body>
<!--  #INCLUDE FILE="../include/StatusFooter.htm" -->
</html>
