<%@ Page Language="C#" AutoEventWireup="true" CodeFile="delivery_confirm.aspx.cs"
    Inherits="ASPX_Domestic_delivery_confirm" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>DELIVERY CONFIRMATION</title>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
    <link href="/IFF_MAIN/ASPX/CSS/elt_css.css" rel="stylesheet" type="text/css" />
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

    <script type="text/javascript" language="javascript" src="/ASP/ajaxFunctions/ajax.js"></script>

    <script type="text/javascript" src="/ASP/include/JPED.js"></script>

    <script type="text/jscript">

        function changeShipperEmail(obj,obj2){
            var EmailAddress = document.getElementById(obj.id).value;
            var orgNo =document.getElementById(obj2.id).value;
            if(EmailAddress != "")
            { 
                UpDateMail(EmailAddress, orgNo );
            }
            else
            {
                alert("Please enter Shipper email address"); 
            }
                
        }
        function changeConsigneeEmail(obj,obj2){
            var EmailAddress = document.getElementById(obj.id).value;
            var orgNo =document.getElementById(obj2.id).value;
            if(EmailAddress != "")
            { 
                UpDateMail(EmailAddress, orgNo );
            }
            else
            {
                alert("Please enter Consignee email address"); 
            }
            
        }
        function checkSelection(obj, obj2)
		{
		    var MID = document.getElementById(obj.id);
            var CID =document.getElementById(obj2.id);
		    CID.checked= MID.checked;
		}

       function BlockEmailRow(obj1,obj2,obj3,obj4,obj5,obj6,obj7,obj8,obj9,obj10,obj11)
       {
            var CID =document.getElementById(obj1.id);
            var EmailAddress1 = document.getElementById(obj2.id);
            var EmailAddress2 = document.getElementById(obj3.id);
            var Name1 = document.getElementById(obj4.id);
            var Name2 = document.getElementById(obj5.id);
            var EmailCC = document.getElementById(obj6.id);
            var EmailSubject = document.getElementById(obj7.id);
            var EmailBody = document.getElementById(obj8.id);
            var HAWBBox = document.getElementById(obj9.id);
            var Uploadimage = document.getElementById(obj10.id);

            
            if(CID.checked == true)
            {
                EmailAddress1.style.background="#FFFFFF"; 
		        EmailAddress2.style.background="#FFFFFF";
		        Name1.style.background="#FFFFFF"; 
		        Name2.style.background="#FFFFFF";
		        EmailCC.style.background="#FFFFFF";
                EmailSubject.style.background="#FFFFFF";
                EmailBody.style.background="#FFFFFF";
                 EmailAddress1.readOnly=false;
		        EmailAddress2.readOnly=false;
		        Name1.readOnly=false;
		        Name2.readOnly=false;
		        EmailCC.readOnly=false;
                EmailSubject.readOnly=false;
                EmailBody.readOnly=false;
                HAWBBox.checked= true;
                Uploadimage.style.visibility= "visible";
                
		    }
		    else
		    {
                EmailAddress1.style.background="#CCCCCC"; 
		        EmailAddress2.style.background="#CCCCCC";
		        Name1.style.background="#CCCCCC"; 
		        Name2.style.background="#CCCCCC";
		        EmailCC.style.background="#CCCCCC";
                EmailSubject.style.background="#CCCCCC";
                EmailBody.style.background="#CCCCCC";
               EmailAddress1.readOnly=true;
		        EmailAddress2.readOnly=true;
		        Name1.readOnly=true;
		        Name2.readOnly=true;
		        EmailCC.readOnly=true;
                EmailSubject.readOnly=true;
                EmailBody.readOnly=true;
                HAWBBox.checked= false;
                Uploadimage.style.visibility= "hidden";
		    }
       }

      function CheckboxCheck(obj,fileName, orgNO  )
      {
            var url;
            var value;
            if(obj.checked != true)
            {   
                value ="N";
            }
            else
            {
                value= "Y";
            }
            
            url = "/ASP/ajaxFunctions/ajax_get_Domestic_EMAIL_list.asp?mode=checkbox &OrgNo=" + orgNO + "&Value=" + value +" &Filename=" + fileName ;
            new ajax.xhr.Request('GET','',url,UpDateChange,'','','',''); 
      }
       //update USER MAIL
      function UpDateUserMail(obj )
      {
          var EmailAddress=obj.value;
          var url = "/ASP/ajaxFunctions/ajax_get_Domestic_EMAIL_list.asp?mode=Usermailupdate &Email=" + EmailAddress;
          new ajax.xhr.Request('GET','',url,UpDateChange,'','','','');

      }

      
      //update SENDER MAIL
       function UpDateMail(EmailAddress, orgNo )
      {
          if( orgNo != "" && orgNo != "0")
          {
               var url = "/ASP/ajaxFunctions/ajax_get_Domestic_EMAIL_list.asp?mode=UPDATE &OrgNO=" + orgNo + "&Email=" + EmailAddress;
                new ajax.xhr.Request('GET','',url,UpDateChange,'','','','');
           }
           else
           {
                alert("Please select Consignee from HAWB page"); 
            }
      }
      //After update
     function UpDateChange() {
        }
      //refrach Page
      function loadValues()
	  {
	    var Rnum = document.getElementById("reload").value;
        // check reload Code
	    if( Rnum == "Y")
	    {
	        document.getElementById("reload").value="N";
	        ReloadView();
	    }
	  }
        function searchNumFill(obj,changeFunction,vHeight){
            var qStr = obj.value;
            var keyCode = window.event.keyCode;
            var url;

            if(qStr != "" && keyCode != 229 && keyCode != 27){
                if(document.getElementById("lstSearchType").value == "HAWB")
                {
                    url = "/ASP/ajaxFunctions/ajax_get_Domestic_EMAIL_list.asp?mode=HAWB&qStr=" + qStr;
                }
                else if (document.getElementById("lstSearchType").value == "MGWB")
                {
                    url = "/ASP/ajaxFunctions/ajax_get_Domestic_EMAIL_list.asp?mode=MAWB&qStr=" + qStr;
                }
                else
                {
                    url = "/ASP/ajaxFunctions/ajax_get_Domestic_EMAIL_list.asp?mode=FILE&qStr=" + qStr;
                }
                FillOutJPED(obj,url,changeFunction,vHeight);
            }
        }
        //Review PDF file
        function ViewPDFhouse(hawbno)
        {
             url ="/ASP/Domestic/view_print.asp?sType=house&hawb=" + hawbno + "&WindowName=popUpWindow";
               window.open(url,'popUpWindow','width=1000,height=500,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=no');
        } 
        //Review Attach file
        function ViewFile(FileName,ShipperNo)
        {
            url ="/ASP/include/viewfile.asp?OrgNo=" + ShipperNo + "&FileName=" + FileName;
               window.open(url,'popUpWindow','width=1000,height=500,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=no');
        } 
        
        function searchNumFillAll(objName,changeFunction,vHeight){
            var obj = document.getElementById(objName);
            if(document.getElementById("lstSearchType").value == "HAWB")
            {
                url = "/ASP/ajaxFunctions/ajax_get_Domestic_EMAIL_list.asp?mode=HAWB";
            }
            else if (document.getElementById("lstSearchType").value == "MAWB")
            {
                url = "/ASP/ajaxFunctions/ajax_get_Domestic_EMAIL_list.asp?mode=MAWB";
            }
            else
            {
                url = "/ASP/ajaxFunctions/ajax_get_Domestic_EMAIL_list.asp?mode=FILE";
            }
            FillOutJPED(obj,url,changeFunction,vHeight);
        }

        function lstSearchNumChange2(selVal,selText) {
            var type =document.getElementById("lstsearchType").value;
            
            var url = "./delivery_confirm.aspx?searchNo=" + encodeURIComponent(selVal)+ "&searchType=" + type  ;
            document.location.href = url;
        }
        
    // End of list change effect ///////////////////////////////////////////////////////////////////  

        function DeleteFile(FileName,ShipperNo)
        {
            var type =document.getElementById("lstsearchType").value;
            var orgNum=document.getElementById("lstSearchNum").value;
            var orgName=document.getElementById("lstSearchNum").value;
            if(FileName != ""){
                var answer = confirm("Please, click OK to delete " + FileName);
                if(!answer){
                    return false;
                }
                try{
                     var url = "./delivery_confirm.aspx?searchNum=" + orgNum + "&searchNo=" + encodeURIComponent(orgName)+ "&searchType=" + type + "&orgNum=" + ShipperNo + "&FileName=" + FileName  ;
                      document.location.href = url;
                }catch(err){}
            }
            else
            {
                alert("Please, select files for delete.");
                return false;
            }
        }
        function ShowEmailHistory()
        {
            url= "../MISC/EmailHistory.aspx?title=Shipping Noticey&ao=A&ie=E";
	         window.open(url,'popUpWindow','width=1000,height=500,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=no');
        }



        function cleartext(){
            document.getElementById("lstSearchNum").value="";
        }
        
        function EditClickHAWB(HAWB)
        {
               url ="/ASP/Domestic/new_edit_hawb.asp?mode=search&hawb=" + HAWB + "&WindowName=popUpWindow";
               window.open(url, 'popUpWindow', 'menubar=1,toolbar=1,hotkeys=1,status=1,location=0,scrollbars=1,resizable=1,width=900,height=600');
		}

    
    // Reload Page 
     function ReloadView() {
        var type =document.getElementById("lstsearchType").value;
        var orgNum=document.getElementById("lstSearchNum").value;
        var orgName=document.getElementById("lstSearchNum").value;
        var url = "./delivery_confirm.aspx?searchNum=" + orgNum + "&searchNo=" + encodeURIComponent(orgName)+ "&searchType=" + type + "&backpage=Y" ;
        document.location.href = url;
    }
    </script>

</head>
<body onLoad="self.focus(); loadValues();">
    <form id="form1" runat="server" class="bodycopy">
        <!-- page title -->
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td width="50%" align="left" valign="middle" class="pageheader">
                    DELIVERY CONFIRMATION
                </td>
                <td width="50%" align="right" valign="middle">
                    &nbsp;
                </td>
            </tr>
            <tr>
                <td align="left" valign="top" style="height: 15px; width: 776px;">
                    <table cellpadding="0" cellspacing="0" border="0">
                     <tr>
                    <td height="15" valign="top"><span class="select">Select AWB Type and No.</span></td>
                    </tr>
                        <tr>
                            <td>
                                <asp:DropDownList CssClass="bodycopy" Width="130px" runat="server" ID="lstSearchType"
                                    onChange="cleartext()">
                                    <asp:ListItem Value="HAWB" Text="House AWB No."></asp:ListItem>
                                    <asp:ListItem Value="MAWB" Text="Master AWB No."></asp:ListItem>
                                    <asp:ListItem Value="File" Text="File No."></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <td style="width: 8px;">
                            </td>
                            <td>
                                <asp:HiddenField ID="hSearchNum" runat="server" Value="" />
                                <!--<input type="hidden" id="hSearchNum" name="hSearchNum" />-->
                                <div id="lstSearchNumDiv">
                                </div>
                                <!--<input type="text"-->
                                <input type="text" autocomplete="off" id="lstSearchNum" name="lstSearchNum" value="<%=Request.Params.Get("searchNo") %>"
                                    class="shorttextfield" style="width: 150px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                    border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9; color: Black"
                                    onKeyUp=" searchNumFill(this,'lstSearchNumChange2','')" onfocus="initializeJPEDField(this,event);" /></td>
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
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#997132"
            class="border1px">
            <tr bgcolor="edd3cf">
                <td height="24" colspan="6" align="center" valign="middle" bgcolor="#eec983" class="bodyheader">
                    <span class="pageheader">
                        <asp:ImageButton ID="imagb" runat="server" ImageUrl="../../Images/button_send_email.gif" OnClick="btnEmail_Check" CssClass="marginleft"></asp:ImageButton></span></td>
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
                                    <img src="/ASP/Images/icon_email_history.gif" align="absbottom"><a href="javascript:;"
                                        onClick="ShowEmailHistory()">View Email History</a></span></td>
                            <td width="50%" align="right" class="bodyheader">
                                <img src="/ASP/Images/required.gif" align="absbottom">Required field</td>
                        </tr>
                    </table>
                    <table width="65%" border="0" cellpadding="2" cellspacing="0" bordercolor="#997132"
                        bgcolor="edd3cf" class="border1px">
                        <tr align="left" valign="middle" bgcolor="#f3d9a8">
                            <td align="left" valign="middle" class="bodycopy" style="width: 2px">
                                &nbsp;</td>
                            <td height="20" align="left" valign="middle" class="bodyheader" style="width: 176px">
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
                                <asp:TextBox runat="server" ID="txtname" CssClass="m_shorttextfield" Width="220px"></asp:TextBox>
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
                                <asp:TextBox runat="server" ID="txtEmail" CssClass="m_shorttextfield" onkeyup="UpDateUserMail(this)" Width="220px"></asp:TextBox></td>
                        </tr>
       

                    </table>
                <asp:HiddenField ID="reload" runat=server Value="N" />
                <asp:HiddenField ID="HSend" runat=server Value="N" />
                <asp:HiddenField ID="HEmpty" runat=server Value="N" />
                </td>
                
            </tr>
                                             <tr align="left" valign="middle" bgcolor="#F3f3f3">
                            <td align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy" style="width: 2px">
                                &nbsp;</td>
                            <td colspan="3" align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                                &nbsp;</td>
                        </tr>
             <tr>
                <td width="48" align="left" valign="middle" bgcolor="#997132" class="bodycopy" style="height: 3px">
                </td>
            </tr>
            <tr>
                <td bgcolor="#f3f3f3" style="height: 1px">
                    <!-- ship out list starts -->
                    
                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td width="1221" colspan="9">
                                <div>
                                    <asp:GridView runat="server" ID="GridViewHAWB" AllowPaging="True" AutoGenerateColumns="False"
                                        OnPageIndexChanging="GridViewHAWB_PageIndexChanging" Width="100%" BorderWidth="0px">
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
                                                                         <table width="100%" border="0" cellpadding="2" cellspacing="0" bordercolor="#ffffff"
                                                        bgcolor="ffffff" class="border1px">
                                                        <tr id='Row<%# Eval("row_index").ToString() %>' align="left">
                                                            <td width="100%" align="left">
                                                                <table width="100%">
                                                                    <tr align="left" valign="middle" bgcolor="#ffffff">
                                                                        <td align="left" valign="middle" class="bodycopy" style="width: 30px">
                                                                            <asp:HiddenField runat="server" ID="hHAWBNo" value=<%# Eval("hawb_num").ToString() %>/>
                                                                                <!--<img src="../../images/button_edit.gif" align="absbottom" onClick="EditClickHAWB('<%# Eval("HAWB_num").ToString() %>')"  style="cursor:hand">--></td>
                                                                        <td width="4" align="left" valign="middle" class="bodycopy">
                                                                                <asp:CheckBox ID="MainCheckBox"  runat="server" Checked="true" /></td>
                                                                        <td width="90" align="left" valign="middle" class="bodycopy">Shipper Name:</td>
                                                                        <td width="928" align="left" valign="middle" class="bodycopy">
                                                                            <asp:TextBox runat="server" ID="txtShipper_Name" CssClass="m_shorttextfield"  Width="220px" Text= <%# Eval("shipper_name").ToString() %>></asp:TextBox>
                                                                            <asp:HiddenField runat="server" ID="hOrgNo" Value=<%# Eval("shipper_account_number").ToString() %>/>
                                                                        </td>
                                                                     </tr>
                                                                     <tr align="left" valign="middle" bgcolor="#ffffff">
                                                                        <td align="left" valign="middle" class="bodycopy" style="width: 30px">
                                                                            &nbsp;</td>
                                                                        <td width="4" align="left" valign="middle" class="bodycopy">
                                                                                &nbsp;
                                                                                </td>
                                                                        <td width="90" align="left" valign="middle" class="bodycopy">
                                                                            <img src="/ASP/Images/required.gif" align="absbottom"><span class="bodyheader">Shipper Email:</span></td>
                                                                        <td width="928" align="left" valign="middle" class="bodycopy">
                                                                            <input type="hidden" id="hShipperID<%# Eval("row_index") %>" name="hShipperID" value="<%# Eval("Shipper_account_number").ToString() %>" />
                                                                            <asp:TextBox runat="server" ID="Txtshipper_email"  Text=<%# Eval("shipper_email").ToString() %> CssClass="m_shorttextfield" Width="220px" ></asp:TextBox>
                                                                           <!--Update Date Email Function)-->
                                                                           <!-- <asp:ImageButton ID="Image1" runat="server" ImageAlign="Middle" ImageUrl= "../../images/button_addupdate.gif" CssClass="marginleft"></asp:ImageButton>-->
                                                                        </td>
                                                                     </tr>
                                                                     <tr align="left" valign="middle" bgcolor="#ffffff">
                                                                        <td align="left" valign="middle" class="bodycopy" style="width: 30px">&nbsp;</td>
                                                                        <td width="4" align="left" valign="middle" class="bodycopy">&nbsp;</td>
                                                                        <td width="90" align="left" valign="middle" class="bodycopy">Consignee Name:</td>
                                                                        <td width="928" align="left" valign="middle" class="bodycopy">
                                                                            <asp:TextBox runat="server" ID="txtConsignee_name" CssClass="m_shorttextfield"  Width="220px" Text=<%# Eval("consignee_name").ToString() %>></asp:TextBox>
                                                                         </td>
                                                                     <tr align="left" valign="middle" bgcolor="#ffffff">
                                                                        <td align="left" valign="middle" class="bodycopy" style="width: 30px">&nbsp;</td>
                                                                        <td width="4" align="left" valign="middle" class="bodycopy">&nbsp;</td>
                                                                        <td width="90" align="left" valign="middle" class="bodycopy">Consignee Email:</td>
                                                                        <td width="928" align="left" valign="middle" class="bodycopy">
                                                                        <asp:HiddenField runat="server" ID="hConsigneeID" Value=<%# Eval("Consignee_num").ToString() %>/>
                                                                        <input type="hidden" id="hConsigneeID<%# Eval("row_index") %>" name="hConsigneeID" value="<%# Eval("Consignee_num").ToString() %>" />
                                                                        <asp:TextBox runat="server" ID="Txtconsignee_email"  CssClass="m_shorttextfield" Width="220px" Text=<%# Eval("consignee_email").ToString() %>></asp:TextBox>
                                                                         <!-- Email Update Button-->
                                                                         <!--<asp:ImageButton ID="Image2" runat="server" ImageAlign="Middle" ImageUrl= "../../images/button_addupdate.gif" CssClass="marginleft"></asp:ImageButton>-->
                                                                        </td>
                                                                     </tr>
                                                                     <tr align="left" valign="middle" bgcolor="#ffffff">
                                                                        <td align="left" valign="middle" class="bodycopy" style="width: 30px">&nbsp;</td>
                                                                        <td width="4" align="left" valign="middle" class="bodycopy">&nbsp;</td>
                                                                        <td width="90" align="left" valign="middle" class="bodycopy">CC:</td>
                                                                        <td width="928" align="left" valign="middle" class="bodycopy">
                                                                            <asp:TextBox runat="server" ID="TxtCC" CssClass="m_shorttextfield"  Width="220px" ></asp:TextBox>
                                                                        </td>
                                                                     </tr>
                                                                     <tr align="left" valign="middle" bgcolor="#ffffff">
                                                                        <td align="left" valign="middle" class="bodycopy" style="width: 30px">&nbsp;</td>
                                                                        <td width="4" align="left" valign="middle" class="bodycopy">&nbsp;</td>
                                                                        <td width="90" align="left" valign="middle" class="bodycopy"><span class="bodyheader">Subject:</span></td>
                                                                        <td width="928" align="left" valign="middle" class="bodycopy">
                                                                            <asp:TextBox runat="server" ID="TxtSubject" CssClass="m_shorttextfield" Width="500px" Text=<%#GetSubject(Eval("AgentName").ToString(), Eval("hawb_num").ToString())%>></asp:TextBox>
                                                                        </td>
                                                                        </tr>
                                                                        <tr align="left" valign="middle" bgcolor="#ffffff">
                                                                         <td align="left" valign="middle" class="bodycopy" style="width: 30px">&nbsp;</td>
                                                                        <td width="4" align="left" valign="middle" class="bodycopy">&nbsp;</td>
                                                                         <td width="90" align="left" valign="middle" class="bodycopy">&nbsp;</td>
                                                                         <td width="928" align="left" valign="middle" class="bodycopy">
                                                                         <asp:CheckBox ID="HAWBCheckBox"  runat="server" Checked="true" />
                                                                            <font color="#CC3300">HAWB:</font> <a href="javascript:;" onClick="ViewPDFhouse('<%# Eval("HAWB_num").ToString() %>')">
                                                                                <%# Eval("HAWB_num").ToString() %>
                                                                            </a> 
                                                                         </td>
                                                                      </tr>
                                                                      <tr align="left" valign="middle" bgcolor="#ffffff">
                                                                         <td align="left" valign="middle" class="bodycopy" style="width: 30px">&nbsp;</td>
                                                                         <td width="4" align="left" valign="middle" class="bodycopy">&nbsp;</td>
                                                                         <td width="90" align="left" valign="middle" class="bodycopy">Atach File:</td>
                                                                         <td width="928" align="left" valign="middle" class="bodycopy">
                                                                         <asp:FileUpload runat="server" Width="400px" ID="fileShipperAttachment" />
                                                                        <!--  upload image or button
                                                                        <asp:Button runat="server" ID="btnFileUpload" Text="Upload" CommandArgument='<%# Eval("row_index").ToString() + "-" + Eval("shipper_account_number").ToString() %>' OnCommand="btnFileUpload_Command" />-->
                                                                         <asp:ImageButton ID="ImagU" runat="server" ImageUrl="../../Images/button_upload.gif" CommandArgument='<%# Eval("row_index").ToString() + "-" + Eval("shipper_account_number").ToString() %>'  OnCommand="btnFileUpload_Command" CssClass="marginleft"></asp:ImageButton>
                                                                         </td>
                                                                      </tr>
                                                                      <tr align="left" valign="middle" bgcolor="#ffffff">
                                                                         <td align="left" valign="middle" class="bodycopy" style="width: 30px">&nbsp;</td>
                                                                         <td width="4" align="left" valign="middle" class="bodycopy">&nbsp;</td>
                                                                         <td width="90" align="left" valign="middle" class="bodycopy">&nbsp;</td>
                                                                         <td width="928" align="left" valign="middle" class="bodycopy">
                                                                          <asp:Repeater runat="server" ID="repeaterUploadFile">
                                                                            <HeaderTemplate>
                                                                                <%# GetNoV()%>
                                                                            </HeaderTemplate>
                                                                                <ItemTemplate>
                                                                                    <asp:CheckBox ID="checkItem"  runat="server" Checked='<%# CCBox(Eval("file_checked").ToString()) %>' />
                                                                                    <asp:HiddenField ID="hFileName" runat="server" Value=<%# Eval("File_name").ToString() %> />
                                                                                    <asp:HiddenField ID="hFOrgNo" runat="server" Value=<%# Eval("org_no").ToString() %> />
                                                                                   <!--<input type="checkbox" id="chkAttachFile" checked=checked value="" onclick="CheckboxCheck(this,'<%# Eval("File_name").ToString() %>','<%# Eval("org_no").ToString() %>')"/> -->
                                                                                    <font color="#CC3300">Attachment<%# GetNo2()%>: </font><a href="javascript:;" onClick="ViewFile('<%# Eval("File_name").ToString() %>','<%# Eval("org_no").ToString() %>')"><%# Eval("File_name").ToString() %></a>
                                                                                    <img src="../../images/button_delete.gif" align="absbottom" onClick="DeleteFile('<%# Eval("File_name").ToString() %>','<%# Eval("org_no").ToString() %>')"  style="cursor:hand">
                                                                                </ItemTemplate>
                                                                            </asp:Repeater>
                                                                            </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td align="left" valign="middle" class="bodycopy" style="width: 30px">
                                                                                    &nbsp;</td>
                                                                                <td width="4" align="left" valign="middle" class="bodycopy">
                                                                                    &nbsp;</td>
                                                                                <td width="90" align="left" valign="top" class="bodyheader">
                                                                                    Message</td>
                                                                                 <td width="928" align="left" valign="middle" class="bodycopy">
                                                                                      <asp:TextBox ID="txtBody" runat="server" Columns="70" TextMode="MultiLine"></asp:TextBox>
                                                                                  </td>
                                                                               </tr>
                                                                     </table>
                                                                     </td>
                                                                    </tr>
                                                                  
                                                                     
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
            </tr>
        </table>
        <br />

        <asp:Label ID="sqlOutput" runat="server"></asp:Label>
    </form>
</body>
</html>
