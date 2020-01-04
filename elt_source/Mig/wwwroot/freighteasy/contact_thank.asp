<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>FreightEasy Home</title>
    <style type="text/css">
</style>

    <script type="text/JavaScript">
<!--
function viewPop(Url) {
var strJavaPop = "";
strJavaPop = window.open(Url,'popupNew','staus=0,titlebar=0,toolbar=1,menubar=1,scrollbars=1,resizable=1,location=0,width=900,height=600,hotkeys=0');
strJavaPop.focus();
}

function GoMain() {
__doPostBack("btnGoMain", "");   		
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function goIFF() 
{
    window.location = '/freighteasy/index.aspx';
}
//-->
    </script>

    <link href="css/style_freighteasy.css" rel="stylesheet" type="text/css" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <style type="text/css">
<!--
.style3 {font-family: Verdana, Arial, Helvetica, sans-serif}
.style5 {font-family: Verdana, Arial, Helvetica, sans-serif; font-weight: bold; }
-->
</style>
</head>
<%
Dim sRequest_Name,sRequest_Title,sRequest_Company_Name,sRequest_Address,sRequest_City,sRequest_State,sRequest_Zip,sRequest_Email,sRequest_Phone_Number,sRequest_Fax_Number,sRequest_Best_Time_to_Call,sRequest_Specific_Inquiries
Dim sRedirect_URL,sMailToName,sMailToAddress
Dim strContactInfo

	sRequest_Name = Request("Request_Name")
	sRequest_Title = Request("Request_Title")
	sRequest_Company_Name = Request("Request_Company_Name")
	sRequest_Address = Request("Request_Address")
	sRequest_City = Request("Request_City")
	sRequest_State = Request("Request_State")
	sRequest_Zip = Request("Request_Zip")
	sRequest_Email = Request("Request_Email")
	sRequest_Phone_number = Request("Request_Phone_Number")
	sRequest_Fax_number = Request("Request_Fax_Number")
	sRequest_Best_Time_to_Call = Request("Request_Best_Time_to_Call")
	

	sRequest_Specific_Inquiries = Request("Request_Specific_Inquiries")

	sRedirect_URL = Request("Redirect_URL")
	sMailToName = Request("MailToName")
	sMailToAddress = Request("MailToAddress")
	
	Set Mail=Server.CreateObject("Persits.MailSender")
	MailServer=Request.ServerVariables("SERVER_NAME")
	Mail.Host = ""

	sRequest_Comments = Replace(sRequest_Comments,Chr(13),"<br>")	
			
	strContactInfo = strContactInfo & " Name              : " & sRequest_Name & "<br>"
	strContactInfo = strContactInfo & " Title             : " & sRequest_Title & "<br>"
	strContactInfo = strContactInfo & " Company Name      : " & sRequest_Company_Name & "<br>"
	strContactInfo = strContactInfo & " Address           : " & sRequest_Address & "<br>"
	strContactInfo = strContactInfo & " City              : " & sRequest_City & "<br>"
	strContactInfo = strContactInfo & " State             : " & sRequest_State & "<br>"
	strContactInfo = strContactInfo & " Zip               : " & sRequest_Zip & "<br>"
	strContactInfo = strContactInfo & " Email             : " & sRequest_Email & "<br>"
	strContactInfo = strContactInfo & " Phone Number      : " & sRequest_Phone_Number & "<br>"
	strContactInfo = strContactInfo & " Fax Number        : " & sRequest_Fax_Number & "<br>"
	strContactInfo = strContactInfo & " Best Time to Call : " & sRequest_Best_Time_to_Call & "<br>"
	strContactInfo = strContactInfo & " Specific Inquiries          : " & sRequest_Specific_Inquiries & "<br>"


'// HTML Format

			str="<html xmlns='http://www.w3.org/1999/xhtml><head><meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1' /><title>Untitled Document</title><style type='text/css'><!--.style3 {	font-family: Verdana, Arial, Helvetica, sans-serif;	font-size: 9px;}--></style></head><body><p class='style3'><strong>Contact Request</strong></p><p class='style3'>"
			str=str & strContactInfo
			str=str & "</p><table width='100%' border='0' cellspacing='0' cellpadding='0'><tr><td align='left' valign='bottom'>      <span class='style3'>This message was sent by E-LOGISTICS TECHNOLOGY on behalf of <a href='mailto:"&sRequest_Email&"'>" & sRequest_Name & "</a>.</span></td><td align='right' valign='top'><a href='http://e-logitech.net' target='_blank'><img src='http://www.e-logitech.net:8080/elt_email/images/powered_logo.gif' width='123' height='50' border='0' /></a> </td>  </tr></table><span class='style3'><br /></span><span class='style3'>If you would like to reply to this message, please click on the following link:<br /><a href='mailto:"&sRequest_Email&"'>" & sRequest_Email & "</a>.</span></body></html>"

			Mail.IsHTML=True
			Mail.Body=str
			Mail.Subject="[Sales Contact Request]" & " From : " & sRequest_Name

			Mail.From="info@e-logitech.net"
			Mail.FromName="[Sales Contact Request from Customer]"		
			Mail.AddAddress sMailToAddress

'////////////////////////////////////////////////////////////
		
			On Error Resume Next
			Mail.Send	' send message
			error_num=Err.Number
			Set Mail=Nothing
			
%>
<body onload="MM_preloadImages('images/button_elthome_over.gif')">
    <table width="100%" border="0" cellpadding="0" cellspacing="0"">
        <tr>
            <td width="100%" align="left" valign="top">
                <table width="100%" height="42" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td>
                            <% Server.Execute("/Include/main_menu.htm") %>
                        </td>
                    </tr>
                </table>
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td height="1" colspan="2" bgcolor="#a4a3a7">
                        </td>
                    </tr>
                    <tr>
                        <td bgcolor="#d5d6e1">
                            <table width="100%" height="0" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td width="3%" height="16" align="left" valign="middle">
                                    </td>
                                    <td align="left" valign="bottom" class="breadcrumb">
                                        <a href="index.aspx">Home</a> / <a href="../contact.asp">Contact</a></td>
                                </tr>
                                <tr>
                                    <td align="left" valign="top">
                                        &nbsp;</td>
                                    <td align="left" valign="bottom">
                                        <a href="index.aspx">
                                            <img src="images/product_logo.gif" width="121" height="37" border="0" onclick="javascript:goIFF();" /></a><img
                                                src="images/spacer.gif" width="276" height="1" /></td>
                                </tr>
                                <tr>
                                    <td height="1" colspan="2" align="left" valign="top">
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td bgcolor="#d5d6e1">
                            &nbsp;</td>
                    </tr>
                    <tr>
                        <td height="1" colspan="2" bgcolor="#a4a3a7">
                        </td>
                    </tr>
                    <tr>
                        <td width="66%" align="left" valign="top">
                            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td height="24" align="left" valign="top" bgcolor="#FFFFFF">
                                        &nbsp;</td>
                                    <td colspan="2" align="right" valign="top" bgcolor="#FFFFFF">
                                        &nbsp;</td>
                                </tr>
                                <tr>
                                    <td width="3%" height="29" align="left" valign="top" bgcolor="#FFFFFF">
                                    </td>
                                    <td width="94%" align="left" valign="top" bgcolor="#FFFFFF">
                                        <h1>
                                            Thank you for your interest
                                        </h1>
                                    </td>
                                    <td width="3%" align="left" valign="top" bgcolor="#FFFFFF">
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" valign="top" bgcolor="#FFFFFF">
                                    </td>
                                    <td align="left" valign="top" bgcolor="#FFFFFF">
                                        <p>
                                            Thank you for taking the time to answer these questions for us. None of the information
                                            you have entered will be shared with any outside parties. We will get back to you
                                            shortly.
                                        </p>
                                        <p>
                                            &nbsp;</p>
                                    </td>
                                    <td align="left" valign="top" bgcolor="#FFFFFF">
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td rowspan="2" width="34%" align="left" valign="top">
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td width="70%" align="left" valign="top" bgcolor="#edf2f8">
                                        <div id="infospace">
                                        </div>
                                        <br />
                                    </td>
                                    <td width="30%" align="left" valign="top" bgcolor="#edf2f8">
                                        &nbsp;</td>
                                </tr>
                                <tr>
                                    <td height="1" colspan="2" align="left" valign="top" bgcolor="#b6b4ba">
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" valign="top">
                                        <div id="navleftbar">
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr>
                                                    <td>
                                                        <ul id="mainnavheader">
                                                            <li><a href="#">FreightEasy<span class="body">&trade;</span> Home</a></li>
                                                        </ul>
                                                        <ul id="mainnav">
                                                            <li><a href="introduction.asp">Introduction</a></li>
                                                            <li><a href="why_fe.asp">Why FreightEasy</a></li>
                                                            <li><a href="features.asp">Features</a></li>
                                                        </ul>
                                                        <ul id="mainnavbottom">
                                                            <li><a href="faqs.asp">FAQs</a></li>
                                                        </ul>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <ul id="mainnavheader">
                                                            <li><a href="#">Quick Links </a></li>
                                                        </ul>
                                                        <ul id="mainnav">
                                                            <li><a href="account_setup.asp">Free Trial Account </a></li>
                                                            <li><a href="getting_tips.asp">Getting Started Tips </a></li>
                                                            <li><a href="../support.asp">Support</a></li>
                                                        </ul>
                                                    </td>
                                                </tr>
                                            </table>
                                            <br />
                                            <br />
                                        </div>
                                    </td>
                                    <td align="left" valign="top">
                                        &nbsp;</td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td align="left" valign="bottom">
                            &nbsp;</td>
                    </tr>
                    <tr>
                        <td height="1" colspan="2" bgcolor="#a4a3a7">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td width="3%" height="48">
                                        &nbsp;</td>
                                    <td width="94%" align="left" valign="middle">
                                        <% 
            Server.Execute("/Include/siteinfo.html")
                                        %>
                                    </td>
                                    <td width="3%">
                                        &nbsp;</td>
                                </tr>
                            </table>
                        </td>
                        <td align="left" valign="top">
                            <asp:button id="btnGoMain" runat="server" onclick="btnGoMain_Click" width="0px" height="0px"
                                causesvalidation="False" />
                            <asp:linkbutton id="LinkButton1" runat="server" height="0px" width="0px"></asp:linkbutton>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <br />
    <br />
    <br />
    <br />
    <br />
</body>
</html>
