<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Domestic_Email.aspx.cs"
    Inherits="ASPX_Domestic_Domestic_Email" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Domestic Email Send</title>
    <link href="/IFF_MAIN/ASPX/CSS/elt_css.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript" language="javascript" src="/ASP/ajaxFunctions/ajax.js"></script>

    <script type="text/javascript" src="/ASP/include/JPED.js"></script>

    <script type="text/jscript">

        function SendClick(){
        
            if (document.getElementById("txtname").value == "")
            {
                alert("Please enter your name!");
                return false;
            }
            if (document.getElementById("txtEmail").value == "")
            {
                alert("Please enter your email address!");
                return false;
            }
        }

        function UpdateClick()
        {
            var EmailAddress=document.getElementById("TxtTO").value;
            var orgNO=document.getElementById("hORGNO").value;
            if (EmailAddress == "")
            {
                alert("Please Fill Up Customer Email Address!");
                return false;
            }
            else
            {
                url = "/ASP/ajaxFunctions/ajax_get_Domestic_EMAIL_list.asp?mode=UPDATE &OrgNO=" + orgNO + "&Email=" + EmailAddress;
                new ajax.xhr.Request('GET','',url,UpDateChange,'','','','');
                alert("Email UpDated");
            }
        }

      function UpDateChange() {
        }
      function showPDF() {
               var location=document.getElementById("Label1").value;
               var url= "D:\\TEMP\\" + location;
               //window.open(url,'popUpWindow','width=1000,height=500,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=no');
        }
    // End of list change effect ///////////////////////////////////////////////////////////////////  
    
       function cleartext(){
            document.getElementById("lstSearchNum").value="";
        }
    </script>

</head>
<body>
    <form id="form1" runat="server" class="bodycopy">
        <!-- page title -->
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td width="50%" align="left" valign="middle" class="pageheader">
                    DOMESTIC EMAIL
                </td>
                <td width="50%" align="right" valign="middle">
                    &nbsp;
                </td>
            </tr>
   
        </table>
        <br />
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#997132"
            class="border1px">
            
              <tr bgcolor="#eec983">
                                        <td width="26%" valign="middle" style="height: 30px">
                                            <img src="/ASP/Images/spacer.gif" width="70" height="5" /><img src="/ASP/Images/spacer.gif"
                                                width="70" height="5" />
                                        </td>
                                        <td width="48%" align="center" valign="middle" style="height: 30px">
                                             <span class="pageheader">
                            <asp:ImageButton ID="imagb" runat="server" ImageUrl="../../Images/button_send_email.gif" OnClick="SendMail" CssClass="marginleft"></asp:ImageButton></span></td>
                                        <td width="13%" align="right" valign="middle" style="height: 30px">
                                        </td>
                                        <td width="13%" align="right" valign="middle" style="height: 30px">
                                        <asp:ImageButton ID="closeButton2" runat="server" ImageUrl="../../Images/button_undo.gif" OnClick="MailClose" CssClass="marginleft"></asp:ImageButton>
                                            </td>
                                    </tr>
     
            <tr>
                  <td bgcolor="#997132" style="height: 1px">
                </td>
                <td bgcolor="#997132" style="height: 1px">
                </td>
                <td bgcolor="#997132" style="height: 1px">
                </td>
                <td bgcolor="#997132" style="height: 1px">
                </td>
            </tr>
            <tr align="center" valign="middle" bgcolor="f3d9a8">
                <td height="24" colspan="6" align="center" bgcolor="#f3f3f3" class="bodyheader">
                    <br>
                    <table border="0" cellspacing="0" cellpadding="0" style="width: 56%">
                        <tr>
                            <td width="50%" height="28" align="left" valign="middle">
                                </td>
                            <td width="50%" align="right" class="bodyheader">
                                <img src="/ASP/Images/required.gif" align="absbottom">Required field</td>
                        </tr>
                    </table>
                    <table border="0" cellpadding="2" cellspacing="0" bordercolor="#997132"
                        bgcolor="edd3cf" class="border1px" style="width: 57%">
                        <tr align="left" valign="middle" bgcolor="#f3d9a8">
                            <td align="left" valign="middle" class="bodycopy" style="width: 26px">
                                &nbsp;</td>
                            <td height="20" align="left" valign="middle" class="bodyheader">
                                Your Name</td>
                            <td align="left" valign="middle" class="bodycopy" style="width: 275px">
                                From;</td>
                        </tr>
                        <tr align="left" valign="middle" bgcolor="#FFFFFF">
                            <td align="left" valign="middle" class="bodycopy" style="width: 26px; height: 24px;">
                                &nbsp;</td>
                            <td align="left" valign="middle" class="bodyheader" style="height: 24px">
                                <asp:TextBox runat="server" ID="txtname" CssClass="m_shorttextfield" Width="180px"></asp:TextBox></td>
                            
                            <td align="left" valign="middle" class="bodycopy" style="width: 275px; height: 24px">
                                <asp:TextBox runat="server" ID="txtEmail" CssClass="m_shorttextfield" Width="220px"></asp:TextBox></td>
                        </tr>
                    
                        <tr align="left" valign="middle" bgcolor="#f3d9a8">
                            <td align="left" valign="middle" class="bodycopy" style="width: 26px">
                                &nbsp;</td>
                            <td height="20" align="left" valign="middle" class="bodyheader">
                                Customer Name</td>
                         
                            <td align="left" valign="middle" class="bodycopy" style="width: 275px">
                                TO</td>
                        </tr>
                         <tr align="left" valign="middle" bgcolor="#FFFFFF">
                            <td align="left" valign="middle" class="bodycopy" style="width: 26px; height: 27px;">
                                &nbsp;</td>
                            <td align="left" valign="middle" class="bodyheader" style="height: 27px">
                                <asp:TextBox runat="server" ID="TxtCustomerName" CssClass="m_shorttextfield" Width="180px"></asp:TextBox></td>
                           
                            <td align="left" valign="middle" class="bodycopy" style="width: 275px; height: 27px;">
                                <asp:TextBox runat="server" ID="TxtTO" CssClass="m_shorttextfield" Width="220px" ></asp:TextBox>
                                <img src="../../images/button_update.gif" height="18" name="UpDateMail" align=top onClick="UpdateClick()" style="cursor: hand; width: 47px;"></td>
                        </tr>
                       
                      <tr align="left" valign="middle" bgcolor="#f3d9a8">
                            <td align="left" valign="middle" class="bodycopy" style="width: 26px">
                                &nbsp;</td>
                            <td height="20" align="left" valign="middle" class="bodyheader">
                                Subject</td>
                            <td align="left" valign="middle" class="bodycopy" style="width: 275px">
                                &nbsp;</td>
                        </tr>
                        <tr align="left" valign="middle" bgcolor="#F3f3f3">
                            <td align="left" valign="middle" class="bodycopy" style="width: 26px">
                                &nbsp;</td>
                            <td height="20" align="left" valign="middle" class="bodyheader">
                                <asp:TextBox runat="server" ID="TxtSubject" CssClass="m_shorttextfield" Width="220px"></asp:TextBox></td>
                            <td align="left" valign="middle" class="bodycopy" style="width: 275px">
                                 </td>
                        </tr>
                        <tr align="left" valign="middle" bgcolor="#f3d9a8">
                            <td align="left" valign="middle" class="bodycopy" style="width: 26px">
                                &nbsp;</td>
                            <td height="20" align="left" valign="middle" class="bodyheader">
                                File Attchment</td>
                            <td align="left" valign="middle" class="bodycopy" style="width: 275px">
                                &nbsp;</td>
                        </tr>
                        <tr align="left" valign="middle" bgcolor="#F3f3f3">
                            <td align="left" valign="middle" class="bodycopy" style="width: 26px">
                                &nbsp;</td>
                            <td height="20" align="left" valign="middle" class="bodyheader">
                            <table>
                            <tr>
                            <td>
                                <asp:CheckBox ID="PDFCheckBox"  runat="server" Checked="true" /> 
                                <img src="../../images/button_pdflogo.gif" width="15" height="15" name="pdfx" onclick="showPDF()" style="cursor: hand">
                                <font color="#CC3300"><asp:Label ID="Label2" runat="server"></asp:Label> </font><asp:Label ID="Label1" runat="server"></asp:Label></td>
                            </tr>
                            </table>
                            </td>
                           
                            <td align="left" valign="middle" class="bodycopy" style="width: 275px">
                                &nbsp;</td>
                        </tr>

                        <tr align="left" valign="middle" bgcolor="#f3d9a8">
                            <td align="left" valign="middle" class="bodycopy" style="width: 26px">
                                &nbsp;</td>
                            <td height="20" colspan="3" align="left" valign="middle" class="bodyheader">
                               Body</td>
                        </tr>
                        <tr align="left" valign="middle" bgcolor="#F3f3f3">
                            <td align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy" style="width: 26px">
                                &nbsp;</td>
                            <td colspan="3" align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
                               <asp:TextBox ID="txtBody" runat="server" Columns="40" TextMode="MultiLine" Width="650px"></asp:TextBox></td>
                        </tr>
                      
                    </table>
                    <table border="0" cellspacing="0" cellpadding="0" style="width: 56%">
                        <tr>
                            <td width="50%" height="28" align="left" valign="middle">
                                </td>
                            <td width="50%" align="right" class="bodyheader">
                                </td>
                        </tr>
                    </table>
                </td>
            </tr>
            
                             
                        <tr>
                <td bgcolor="#997132" style="height: 1px">
                </td>
                <td bgcolor="#997132" style="height: 1px">
                </td>
                <td bgcolor="#997132" style="height: 1px">
                </td>
                <td bgcolor="#997132" style="height: 1px">
                </td>
            </tr>
            <tr bgcolor="edd3cf">
                <td height="24" colspan="6" align="center" valign="middle" bgcolor="#eec983" class="bodyheader">
                    <span class="pageheader">
                            <asp:ImageButton ID="ImageButton1" runat="server" ImageUrl="../../Images/button_send_email.gif" OnClick="SendMail" CssClass="marginleft"></asp:ImageButton></span></td>
            </tr>

        </table>
        <br />
        <br />
        <asp:Label ID="sqlOutput" runat="server"></asp:Label>
        <asp:HiddenField runat="Server" ID="hORGNO" Value="" />
    </form>
</body>
</html>
