<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Delivery_confirmation.aspx.cs"
    Inherits="ASPX_DOMESTIC_DELIVERY_CONFIRMATION" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">


<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Delivery Confirmation</title>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        .fromCalendar{
            position:absolute; 
            top:92px; 
            left:446px; 
            background-color:#ffffff;
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
        a:hover {
	        color:#b83423
        }
        .style2 {color: #cc6600}
    body {
	    margin-left: 0px;
	    margin-right: 0px;
	    margin-bottom: 0px;
    }
    .goto a:link, a:visited {
	    color: #336699;
    }
    a:hover {
	    color: #CC3300;
    }
    a:link {
	    color: #336699;
	        }
    </style>

    <script type="text/javascript" language="javascript" src="/IFF_MAIN/ASP/ajaxFunctions/ajax.js"></script>

    <script type="text/javascript" src="/IFF_MAIN/ASP/include/JPED.js"></script>

    <script type="text/jscript">


        function SendClick(){
        
        if (document.getElementById("txtname").value == "")
        {
	        alert("Please enter your name!");
	       return false;
	       }
        else if (document.getElementById("txtEmail").value == "")
        {
            alert("Please enter your email address!");
	       return false;
	       }
	    else
	       {
	         if(checkEmptyEmail() != false)
	         {
	            alert("Your Email Send.");
	           /* if  (document.all("hShipperHAWBIndex").item(1).Value = "" then
	            document.form1.action= "delivery_confirmOK.asp?Send=yes&EMPHAWB=yes"
            else*/
	        //var url = "/IFF_MAIN/ASP/docmestic/delivery_confirmOK.asp?Send=yes"
            //FillOutJPED(obj,url,changeFunction,vHeight);
	         }
	       }
	  }
	  
	  function loadValues()
	  {
	    var Rnum = document.getElementById("TextBox5").value;

	    if( Rnum != "")
	    {
	        UpLoadFile(Rnum);
	    }
	  }
	  
	  function UpLoadFile(Rnum)
	  {
	  	var OrgNo=document.getElementById("hShipperID"+Rnum).value;
	  	var fileType=document.getElementById("TextBox1").value;
	    var fileName=document.getElementById("TextBox2").value;
	    var fileContent=document.getElementById("TextBox3").value;
	    var fileSize=document.getElementById("TextBox4").value;
        var url = "/IFF_MAIN/ASP/ajaxFunctions/ajax_get_Domestic_EMAIL_list.asp?mode=Updata&OrgNO=" + OrgNo + "&FileName=" + fileName +"&FileType=" + fileType + "&FileContent=" + fileContent+ "&FileSize=" + fileSize;
        new ajax.xhr.Request('GET','',url,lstSearchNumChange3,'','','','');
	    //alert(OrgNo+"-"+fileType+"-"+fileName+"-"+fileContent+"-"+fileSize);
	    lstSearchNumChange3();
	    document.getElementById("TextBox5").value="";
	  }

        
        function searchNumFill(obj,changeFunction,vHeight){
            var qStr = obj.value;
            var keyCode = window.event.keyCode;
            var url;

            if(qStr != "" && keyCode != 229 && keyCode != 27){
                if(document.getElementById("lstSearchType").value == "HAWB")
                {
                    url = "/IFF_MAIN/ASP/ajaxFunctions/ajax_get_Domestic_EMAIL_list.asp?mode=HAWB&qStr=" + qStr;
                }
                else if (document.getElementById("lstSearchType").value == "MGWB")
                {
                    url = "/IFF_MAIN/ASP/ajaxFunctions/ajax_get_Domestic_EMAIL_list.asp?mode=MAWB&qStr=" + qStr;
                }
                else
                {
                    url = "/IFF_MAIN/ASP/ajaxFunctions/ajax_get_Domestic_EMAIL_list.asp?mode=FILE&qStr=" + qStr;
                }
                FillOutJPED(obj,url,changeFunction,vHeight);
            }
        }
        function DeleteFile(FileName,ShipperNo)
        {
            var noValue = document.getElementById("hSearchNum").value;                        

            if(FileName != "" && FileName != "Select One"){
                var answer = confirm("Please, click OK to delete this file.");
                if(!answer){
                    return false;
                }
                try{
                    var querystring = "";
                    
                    var url = "/IFF_MAIN/ASP/ajaxFunctions/ajax_get_Domestic_EMAIL_list.asp?mode=Delete&OrgNO=" + ShipperNo + "&FileName=" + FileName;
                    new ajax.xhr.Request('GET','',url,lstSearchNumChange3,'','','','');
                }catch(err){}
            }
            else
            {
                alert("Please, select a shipout file to delete.");
                return false;
            }
        }
        
        function searchNumFillAll(objName,changeFunction,vHeight){
            var obj = document.getElementById(objName);
            if(document.getElementById("lstSearchType").value == "HAWB")
            {
                url = "/IFF_MAIN/ASP/ajaxFunctions/ajax_get_Domestic_EMAIL_list.asp?mode=HAWB";
            }
            else if (document.getElementById("lstSearchType").value == "MAWB")
            {
                url = "/IFF_MAIN/ASP/ajaxFunctions/ajax_get_Domestic_EMAIL_list.asp?mode=MAWB";
            }
            else
            {
                url = "/IFF_MAIN/ASP/ajaxFunctions/ajax_get_Domestic_EMAIL_list.asp?mode=FILE";
            }
            FillOutJPED(obj,url,changeFunction,vHeight);
        }
       
       function lstSearchNumChange(argV,argL){
            var divObj = document.getElementById("lstSearchNumDiv");
		    var hiddenObj = document.getElementById("hSearchNum");
		    var txtObj = document.getElementById("lstSearchNum");	
       
            hiddenObj.value = argV;
		    txtObj.value = argL;	    
            divObj.style.visibility = "hidden";
            divObj.style.position = "absolute";
		    divObj.innerHTML = "";
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

            var url="/IFF_MAIN/ASP/ajaxFunctions/ajax_get_org_address_info.asp?type=" + infoFormat + "&org=" + orgNum;

            xmlHTTP.open("GET",url,false);
            xmlHTTP.send();
            
            return xmlHTTP.responseText; 
        }
        function checkEmptyEmail()
        {
        
            var count=document.getElementById("TotalCount0").value;
            var n=0;
            while(n != count)
            {
                if(document.getElementById("chkHS"+n).checked == true)
                {
                    if(document.getElementById("TxtToPerson"+n).value == "")
                    {
                        alert("Please, Select All Shipper's Email.");
                        return false;
                    }
                }
                n=n+1;
            }
            
        }
        
        
    // End of list change effect ///////////////////////////////////////////////////////////////////  
    

        function ShowEmailHistory()
        {
            url= "../MISC/EmailHistory.aspx?title=Shipping Noticey&ao=A&ie=E";
	        window.open(url, 'popUpWindow', 'menubar=1,toolbar=1,hotkeys=1,status=1,location=0,scrollbars=1,resizable=1,width=900,height=600');
        }
        function ViewPDFhouse(hawbno)
        {
            url ="/IFF_MAIN/ASP/Domestic/view_print.asp?sType=house&hawb=" + hawbno + "&WindowName=popUpWindow";
            window.open(url, 'popUpWindow', 'menubar=1,toolbar=1,hotkeys=1,status=1,location=0,scrollbars=0,resizable=1,width=900,height=600');
        } 
        
        function ViewFile(FileName,ShipperNo)
        {
            url ="/IFF_MAIN/ASP/include/viewfile.asp?OrgNo=" + ShipperNo + "&FileName=" + FileName;
            window.open(url, 'popUpWindow', 'menubar=1,toolbar=1,hotkeys=1,status=1,location=0,scrollbars=1,resizable=1,width=900,height=600');
        } 
        function HouseSelectAll(chkObj,Hid) {
           
           
            var SubObjF;
            var SubObj = document.getElementById("chkHP"+Hid);
            SubObj.checked = chkObj.checked;

                for(var i=1;i<3;i++)
                {
          
                    SubObjF = document.getElementById("chkHF"+Hid+i);
                    
                    SubObjF.checked = chkObj.checked;
             
                }
  

           /* if(!txtObj.readOnly){
                txtObj.style.backgroundColor = "#d7d8ad";
            }
            else{
                txtObj.style.backgroundColor = "#cccccc";
            }*/
        }

        function lstSearchNumChange2(orgNum,orgName) {
            var type =document.getElementById("lstsearchType").value;
            
            var url = "./Delivery_confirmation.aspx?searchNum=" + orgNum + "&searchNo=" + encodeURIComponent(orgName)+ "&searchType=" + type  ;
            document.location.href = url;
        }
        function lstSearchNumChange3() {
            var type =document.getElementById("lstsearchType").value;
            var orgNum=document.getElementById("lstSearchNum").value;
            var orgName=document.getElementById("lstSearchNum").value;
            
            var url = "./Delivery_confirmation.aspx?searchNum=" + orgNum + "&searchNo=" + encodeURIComponent(orgName)+ "&searchType=" + type  ;
            document.location.href = url;
        }
        
        function cleartext(){
            document.getElementById("lstSearchNum").value="";
        }
        
        
    </script>
</head>
<body onLoad="self.focus(); loadValues();">
    <form id="form1" runat="server" class="bodycopy">
        <input type="hidden" id="hTotalPCS" name="hTotalPCS" value="0" />
        <!-- page title -->
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td width="50%" align="left" valign="middle" class="pageheader">
                    DELIVER CONFIRMATION
                </td>
                <td width="50%" align="right" valign="middle">
                    &nbsp;
                </td>
            </tr>
            <tr>
                <td align="left" valign="top" style="height: 15px; width: 776px;">
                    <table cellpadding="0" cellspacing="0" border="0">
                        <tr>
                            <td>
                                <asp:DropDownList CssClass="bodycopy" Width="130px" runat="server" ID="lstSearchType"
                                    onchange="cleartext()">
                                    <asp:ListItem Value="HAWB" Text="House AWB No."></asp:ListItem>
                                    <asp:ListItem Value="MAWB" Text="Master AWB No."></asp:ListItem>
                                    <asp:ListItem Value="File" Text="File No."></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <td style="width: 8px;"></td>
                            <td>
                                <asp:HiddenField ID="hSearchNum" runat="server" Value="" />
                                <!--<input type="hidden" id="hSearchNum" name="hSearchNum" />-->
                                <div id="lstSearchNumDiv">
                                </div>
                                <!--<input type="text"-->
                                <input type="text" autocomplete="off" id="lstSearchNum" name="lstSearchNum" value="<%=Request.Params.Get("searchNo") %>"
                                    class="shorttextfield" style="width: 150px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                    border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9; color: Black"
                                    onKeyUp=" searchNumFill(this,'lstSearchNumChange2','')" onfocus="initializeJPEDField(this);" /></td>
                            <td style="width: 16px">
                                <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="searchNumFillAll('lstSearchNum','lstSearchNumChange2',200);"
                                    style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                    border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        <br />
        <!--warp table starts -->
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#997132"
            class="border1px">
            <tr bgcolor="edd3cf">
                <td height="24" colspan="6" align="center" valign="middle" bgcolor="#eec983" class="bodyheader">
                    <span class="pageheader">
                        <img src="../../images/button_send_email.gif" width="101" height="18" name="bSend"
                            onClick="SendClick()" style="cursor: hand"></span></td>
            </tr>
            <tr>
                <td height="1" bgcolor="#997132">
                </td>
            </tr>
            <tr align="center" valign="middle" bgcolor="f3d9a8">
                <td height="24" colspan="6" align="center" bgcolor="#f3f3f3" class="bodyheader">
                    <br>
                    <table width="65%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td width="50%" height="28" align="left" valign="middle">
                                <span class="goto">
                                    <img src="/iff_main/ASP/Images/icon_email_history.gif" align="absbottom"><a href="javascript:;"
                                        onClick="ShowEmailHistory()">View Email History</a></span></td>
                            <td width="50%" align="right" class="bodyheader">
                                <img src="/iff_main/ASP/Images/required.gif" align="absbottom">Required field</td>
                        </tr>
                    </table>
                    <table width="65%" border="0" cellpadding="2" cellspacing="0" bordercolor="#997132"
                        bgcolor="edd3cf" class="border1px">
                        <tr align="left" valign="middle" bgcolor="#f3d9a8">
                            <td align="left" valign="middle" class="bodycopy" style="width: 2px">
                                &nbsp;</td>
                            <td width="177" height="20" align="left" valign="middle" class="bodyheader">
                                Your Name</td>
                            <td width="304" align="left" valign="middle" class="bodycopy">
                                &nbsp;</td>
                            <td width="246" align="left" valign="middle" class="bodycopy">
                                &nbsp;</td>
                        </tr>
                        <tr align="left" valign="middle" bgcolor="#FFFFFF">
                            <td align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy" style="width: 2px">
                                &nbsp;</td>
                            <td colspan="2" align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                <asp:TextBox runat="server" ID="txtname" CssClass="m_shorttextfield" Width="150px"></asp:TextBox>
                            </td>
                            <td align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                &nbsp;</td>
                        </tr>
                        <tr align="left" valign="middle" bgcolor="#f3d9a8">
                            <td align="left" valign="middle" class="bodycopy" style="width: 2px">
                                &nbsp;</td>
                            <td height="20" colspan="3" align="left" valign="middle" class="bodyheader">
                                From</td>
                        </tr>
                        <tr align="left" valign="middle" bgcolor="#F3f3f3">
                            <td align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy" style="width: 2px">
                                &nbsp;</td>
                            <td colspan="3" align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                <asp:TextBox runat="server" ID="txtEmail" CssClass="m_shorttextfield" Width="220px"></asp:TextBox></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
            <td>

            <asp:HiddenField runat=server ID="TextBox5" Value="" />
            <asp:HiddenField runat=server ID="TextBox1" Value="" />
            <asp:HiddenField runat=server ID="TextBox2" Value="" />
            <asp:HiddenField runat=server ID="TextBox3" Value="" />
            <asp:HiddenField runat=server ID="TextBox4" Value="" />
            </td>
            
            
            </tr>
            <tr align="center" valign="middle" bgcolor="f3d9a8">
                <td height="24" colspan="6" align="center" bgcolor="#f3f3f3" class="bodyheader">
                    <br>
                    <tr>
                        <td width="48" height="3" align="left" valign="middle" bgcolor="#997132" class="bodycopy">
                        </td>
                    </tr>

            <tr>
                <td bgcolor="#f3f3f3" style="height: 1px">
                    <!-- ship out list starts -->
                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td width="1221" colspan="9">
                            
                                <div>
                                    <asp:GridView ID="GridView1" runat="server" AllowPaging="True" AutoGenerateColumns="False"
                                        OnPageIndexChanging="GridView1_PageIndexChanging" Width="100%" BorderWidth="0px">
                                        <PagerSettings Position="Top" />
                                        <PagerStyle CssClass="bodyheader" Font-Bold="true" HorizontalAlign="Right" BorderStyle="None"
                                            BackColor="White" ForeColor="Black" />
                                        <HeaderStyle BorderStyle="None" HorizontalAlign="Left" VerticalAlign="Middle" Width="100%" />
                                        <RowStyle BackColor="#F3F3F3" BorderStyle="None" />
                                        <AlternatingRowStyle BackColor="White" />
                                        <Columns>
                                            <asp:TemplateField>
                                                <HeaderTemplate>
                                                    <!-- list header -->
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <!-- list item -->
                                                    <table width="100%" border="0" cellpadding="2" cellspacing="0" bordercolor="#ffffff"
                                                        bgcolor="ffffff" class="border1px">
                                                        <tr id='Row<%# Eval("HAWB_num").ToString() %>' align="left">
                                                            <td width="100%" align="left">
                                                                <table width="100%">
                                                                    <tr align="left" valign="middle" bgcolor="#ffffff">
                                                                        <td align="left" valign="middle" class="bodycopy" style="width: 30px">
                                                                            &nbsp;</td>
                                                                        <td width="4" align="left" valign="middle" class="bodycopy">
                                                                            <input type="checkbox" name="chkHS" id="chkHS<%# GetNo() %>" class="bodycopy" onclick="HouseSelectAll(this,<%# GetNo() %>)"
                                                                                value="<%# Eval("HAWB_num").ToString() %>" checked="checked" /></td>
                                                                        <td width="4" align="left" valign="middle" class="bodycopy">
                                                                            Shipper<input type="hidden" id="hShipperID<%# GetNo() %>" name="hShipperID" value="<%# Eval("Shipper_account_number").ToString() %>" /></td>
                                                                        <td width="528" align="left" valign="middle" class="bodycopy">
                                                                            <input type="text" id="txtshipname<%# GetNo() %>" name="txtshipname" value="<%# Eval("Shipper_name").ToString() %>" style="width: 380px;" />
                                                                            <asp:HiddenField runat=server ID="hShipID" Value="" /> 
                                                                            <!--  <asp:TextBox runat=server ID="txtshipname" CssClass="m_shorttextfield" Width="380px" ></asp:TextBox>-->
                                                                        </td>
                                                                     </tr>
                                                                    <tr align="left" valign="middle" bgcolor="#ffffff">
                                                                    <td align="left" valign="middle" class="bodycopy" style="width: 30px">&nbsp;</td>
                                                                     <td width="4" align="left" valign="middle" class="bodycopy">&nbsp;</td>
                                                                     <td width="4" align="left" valign="middle" class="bodycopy"> Consignee <input type="hidden" id="hConsigneeID<%# GetNo() %>" name="hConsigneeID" value="<%# Eval("Consignee_acct_num").ToString() %>" /></td>
                                                                     <td width="528" align="left" valign="middle" class="bodycopy">
                                                                            <input type="text" name="txtConsigName" id="txtConsigName<%# GetNo() %>" value="<%# Eval("Consignee_Name").ToString() %>" style="width: 380px;" /><tr>
                                                                    
                                                                    </tr>
                                                                    <tr align="left" valign="middle" bgcolor="#FFFFFF">
                                                                        <td align="left" valign="middle" class="bodycopy" style="width: 30px">
                                                                            &nbsp;</td>
                                                                        <td width="4" align="left" valign="middle" class="bodycopy">
                                                                            &nbsp;</td>
                                                                        <td width="4" align="left" valign="middle" class="bodyheader">
                                                                            <img src="/iff_main/ASP/Images/required.gif" align="absbottom">TO </td>
                                                                        <td width="528" align="left" valign="middle" class="bodycopy">
                                                                            <input type="text" name="TxtToPerson<%# GetNo() %>" value="<%# Eval("Email").ToString() %>" style="width: 380px;" /></td>
                                                                    </tr>
                                                                    <tr align="left" valign="middle" bgcolor="#FFFFFF">
                                                                        <td align="left" valign="middle" class="bodycopy" style="width: 30px">
                                                                            &nbsp;</td>
                                                                        <td width="4" align="left" valign="middle" class="bodycopy">
                                                                            &nbsp;</td>
                                                                        <td width="4" align="left" valign="middle" class="bodycopy">
                                                                            CC</td>
                                                                        <td width="528" align="left" valign="middle" class="bodycopy">
                                                                            <input type="text" id="TxtCC<%# GetNo() %>" name="TxtCC" value="" style="width: 380px;" />
                                                                        
                                                                            <asp:HiddenField ID="hSearchNum" runat="server" Value="" />
                                                                            <!--<asp:TextBox runat=server ID="TxtCC" CssClass="m_shorttextfield" Width="380px" ></asp:TextBox>
                                                                             CheckHAWB(Eval("shipper_account_number")) %>-->
                                                                        </td>
                                                                    </tr>
                                                                    <tr align="left" valign="middle" bgcolor="#FFFFFF">
                                                                        <td align="left" valign="middle" class="bodycopy" style="width: 30px">
                                                                            &nbsp;</td>
                                                                        <td width="4" align="left" valign="middle" class="bodycopy">
                                                                            &nbsp;</td>
                                                                        <td width="4" align="left" valign="middle" class="bodyheader">
                                                                            Subject</td>
                                                                        <td width="528" align="left" valign="middle" class="bodycopy">
                                                                            <input type="text" name="TxtSubject" value="Notice: <%# Eval("AgentName").ToString() %> <%# Eval("Nsubject").ToString() %>"
                                                                                style="width: 380px;" />
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td align="left" valign="middle" class="bodycopy" style="width: 30px">
                                                                        </td>
                                                                        <td width="4" height="1" align="left" valign="middle" bgcolor="#ffffff" class="bodycopy">
                                                                        </td>
                                                                        <td width="4" height="1" align="left" valign="middle" bgcolor="#ffffff" class="bodycopy">
                                                                        </td>
                                                                        <td width="528" height="1" align="left" valign="middle" bgcolor="#ffffff" class="bodycopy">
                                                                        
                                                                         <!--<table>                                          <tr>
                                                                                    <div>
                                                                    <asp:GridView ID="GridViewHAWB" runat="server" AllowPaging="False" AutoGenerateColumns="False" OnPageIndexChanging="GridViewOutDetail_PageIndexChanging"
                                                                        Width="100%" BorderWidth="0px" BorderStyle="None" CellPadding="0">
                                                                        <HeaderStyle BorderStyle="None" HorizontalAlign="Left" VerticalAlign="Middle" Width="100%" />
                                                                        <RowStyle BackColor="White" BorderStyle="None" />
                                                                        <AlternatingRowStyle BackColor="#F3F3F3" />
                                                                        <Columns>
                                                                            <asp:TemplateField>
                                                                                <HeaderTemplate>
                                                                      
                                                                                    <!-- list header -->
                                                                             <!-- </HeaderTemplate>
                                                                                <ItemTemplate>
                                                                                    <!-- list item -->
                                                                               <!--   <table cellpadding="0" cellspacing="0" border="0" style="width: 100%" class="gridViewTable">
                                                                                        <tr>
                                                                                          
                                                                                            <td height="20" style="padding-left: 10px" width="8%" class="searchList">
                                                                                            <input type="checkbox" name="chkHP2" id="chkHP2" class="bodycopy" value="<%# Eval("HAWB_num").ToString() %>"
                                                                                                        checked="checked" />
                                                                                                      <a href="javascript:;" onClick="ViewPDFhouse('<%# Eval("HAWB_num").ToString() %>')">
                                                                                                        <%# Eval("HAWB_num").ToString() %>
                                                                                                    </a>
                                                                                            </td>
                                                                       
                                                                                        </tr>
                                                                                    </table>
                                                                                </ItemTemplate>
                                                                            </asp:TemplateField>
                                                                        </Columns>
                                                                    </asp:GridView>
                                                                </div>
                                                                    </tr>-->
                                                                    <tr>
                                                                                      <td align="left" valign="middle" class="bodycopy" style="width: 30px">
                                                                        </td>
                                                                        <td width="4" height="1" align="left" valign="middle" bgcolor="#ffffff" class="bodycopy">
                                                                        </td>
                                                                        <td width="4" height="1" align="left" valign="middle" bgcolor="#ffffff" class="bodycopy">
                                                                        </td>
                                                                        <td width="528" height="1" align="left" valign="middle" bgcolor="#ffffff" class="bodycopy">
                                                                            <input type="checkbox" name="chkHP" id="chkHP<%# GetNo() %>" class="bodycopy" value="<%# Eval("HAWB_num").ToString() %>"
                                                                                checked="checked" />
                                                                            <font color="#CC3300">HAWB:</font> <a href="javascript:;" onClick="ViewPDFhouse('<%# Eval("HAWB_num").ToString() %>')">
                                                                                <%# Eval("HAWB_num").ToString() %>
                                                                            </a>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td align="left" valign="middle" class="bodycopy" style="width: 30px">
                                                                            &nbsp;</td>
                                                                        <td width="4" align="left" valign="middle" class="bodycopy">
                                                                            &nbsp;</td>
                                                                        <td width="4" align="left" valign="middle" class="bodyheader">
                                                                            &nbsp;</td>
                                                                        <td width="528" height="1" align="left" valign="middle" bgcolor="#ffffff" class="bodycopy">
                                                                            &nbsp;</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td align="left" valign="middle" class="bodycopy" style="width: 30px">
                                                                            &nbsp;</td>
                                                                        <td width="4" align="left" valign="middle" class="bodycopy">
                                                                            &nbsp;</td>
                                                                        <td width="55" align="left" valign="middle" class="bodycopy">
                                                                            Attach File</td>
                                                                        
                                                                        <td width="600" height="1" align="left" valign="middle" bgcolor="#ffffff" class="bodycopy">
                                       
                                                                            <asp:FileUpload id="FileUploadx" runat="server" />
                                                                            &nbsp;<asp:imageButton runat="server" ImageUrl="../../images/button_upload.gif" height="18" ID="btnUpload" OnClick="btnUpload_Click"/>
                                                                        </td>
                                                                    </tr>
                                                                    <!--///////////////////////////////////////////////////-->
                                                                             <tr>
                                                                      <td align="left" valign="middle" class="bodycopy" style="width: 30px">
                                                                            &nbsp;</td>
                                                                        <td width="4" align="left" valign="middle" class="bodycopy">
                                                                            &nbsp;</td>
                                                                     <td width="4" align="left" valign="top" class="bodyheader">
                                                                            &nbsp;</td>
                                                                        <td width="528" height="1" align="left" valign="middle" bgcolor="#ffffff" class="bodycopy">
                                                                <div>
                                                                    <asp:GridView ID="GridViewFile" runat="server" AllowPaging="False" AutoGenerateColumns="False" OnPageIndexChanging="GridViewOutDetail_PageIndexChanging"
                                                                        Width="100%" BorderWidth="0px" BorderStyle="None" CellPadding="0">
                                                                        <HeaderStyle BorderStyle="None" HorizontalAlign="Left" VerticalAlign="Middle" Width="100%" />
                                                                        <RowStyle BackColor="White" BorderStyle="None" />
                                                                        <AlternatingRowStyle BackColor="#F3F3F3" />
                                                                        <Columns>
                                                                            <asp:TemplateField>
                                                                                <HeaderTemplate>
                                                                                    <!-- list header -->
                                                                                    <%# GetNoX()%>
                                                                                    <input type="hidden" id="hcounter<%# GetNoR()%>" name="hcounter" value="<%# GetNo2()%>"/>
                                                                                    
                                                                                    <input type="hidden" id="TotalCount<%# GetNoR()%>" name="TotalCount" value="<%# GetNo() %>" style="width: 380px;" />
                                                                                    
                                                                                    <%# GetNoV()%>
                                                                              </HeaderTemplate>
                                                                                <ItemTemplate>
                                                                                    <!-- list item -->
                                                                                  <table cellpadding="0" cellspacing="0" border="0" style="width: 100%" class="gridViewTable">
                                                                                        <tr>
                                                                                          
                                                                                            <td height="20" style="padding-left: 10px" width="8%" class="searchList">
                                                                                            <input type="checkbox" name="chkHF" id="chkHF<%# GetNoR()%><%# GetNoC()%>" class="bodycopy" value="<%# Eval("File_name").ToString() %>"
                                                                                                        checked="checked" />
                                                                                                      <font color="#CC3300">Attachment<%# GetNo2()%> :</font><a href="javascript:;" onClick="ViewFile('<%# Eval("File_name").ToString() %>','<%# Eval("org_no").ToString() %>')">
                                                                                                        <%# Eval("File_name").ToString() %>
                                                                                                    </a>
                                                                                            </td>
                                                                                            <td height="20" style="padding-left: 10px" width="8%" class="searchList">
                                                                                            <img src="../../images/button_delete.gif" align="absbottom" onClick="DeleteFile('<%# Eval("File_name").ToString() %>','<%# Eval("org_no").ToString() %>')"  style="cursor:hand">
                                                                                            </td>
                                                                       
                                                                                        </tr>
                                                                                        
                                                                                    </table>
                                                                                    
                                                                                </ItemTemplate>
                                                                                
                                                                            </asp:TemplateField>
                                                                        </Columns>
                                                                    </asp:GridView>
                                                                </div>
                                                                 <!--   <div id="RepeaterDiv<%# GetNo() %>">
                                                                    <asp:Repeater id="At_File" runat="server">
                                                                    
                                                                    <HeaderTemplate>
                                                                    <table border="1" width="100%">
                                                                    <tr bgcolor="#b0c4de">
                                                                    <th>Companyname</th>
                                                                    <th>Contactname</th>
                                                                    <th>Address</th>
                                                                    <th>City</th>
                                                                    </tr>
                                                                    </HeaderTemplate>

                                                                    <ItemTemplate>
                                                                    <tr bgcolor="#f0f0f0">
                                                                    <td>
                                                             
                                                                    </tr>
                                                                    </ItemTemplate>

                                                                    <FooterTemplate>
                                                                    </table>
                                                                    </FooterTemplate>

                                                                    </asp:Repeater>
                                                                    </div>-->

                                                                        </td>
                                                                    </tr>
                                                                    
                                                                    <tr>
                                                                        <td align="left" valign="middle" class="bodycopy" style="width: 30px">
                                                                            &nbsp;</td>
                                                                        <td width="4" align="left" valign="middle" class="bodycopy">
                                                                            &nbsp;</td>
                                                                        <td width="4" align="left" valign="top" class="bodyheader">
                                                                            Message</td>
                                                                        <td width="528" height="1" align="left" valign="middle" bgcolor="#ffffff" class="bodycopy">
                                                                            <textarea name="txtShipperMSG" cols="100" rows="3" class="multilinetextfield"></textarea></td>
                                                                    </tr>
              
                                                                </table>
                                                            </td>
                                                    </table>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            
                                        </Columns>
                                    </asp:GridView>
                                    
                                </div>
                            </td>
                        </tr>
                    </table>
                     
                </td>
                <tr>
                    <td align="center" valign="middle" bgcolor="#f3f3f3" style="height: 24px">
                        <!-- bottom menu -->
                        <table width="100%" border="0" cellpadding="2" cellspacing="0">
                            <tr>
                                <td height="1" colspan="6" align="left" valign="middle" bgcolor="#997132" class="bodycopy">
                                </td>
                            </tr>
                            <tr>
                                <td align="center" valign="middle" bgcolor="#eec983" style="height: 24px">
                                    <img src="../../images/button_send_email.gif" width="101" height="18" name="bSend"
                                        onClick="SendClick()" style="cursor: hand"></td>
                            </tr>
                        </table>
                    </td>
                </tr>
        </table>
    </form>
</body>
</html>
