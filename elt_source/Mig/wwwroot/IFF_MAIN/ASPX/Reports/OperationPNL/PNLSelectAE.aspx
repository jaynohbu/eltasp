<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PNLSelectAE.aspx.cs" Inherits="ASPX_Reports_OperationPNL_PNLSelectAE" %>

<%@ Register TagPrefix="igtbl" Namespace="Infragistics.WebUI.UltraWebGrid" Assembly="Infragistics.WebUI.UltraWebGrid, Version=11.1.20111.2064, Culture=neutral, PublicKeyToken=7dd5c3163f2cd0cb" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Air Export PNL</title>

    <script type="text/javascript" src="../../../ASP/ajaxFunctions/ajax.js"></script>

    <script type="text/javascript" src="../../../ASP/include/JPED.js"></script>

    <link href="../../css/elt_css.css" rel="stylesheet" type="text/css" />
    <link href="../../css/appstyle.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript">
    
        function searchNumFill(obj,changeFunction,vHeight){
            var qStr = obj.value;
            var keyCode = window.event.keyCode;
            var url;

            if(qStr != "" && keyCode != 229 && keyCode != 27){
                    url = "/IFF_MAIN/ASP/ajaxFunctions/ajax_get_international_mawb_list.asp?mode=AE&qStr=" + qStr;
                FillOutJPED(obj,url,changeFunction,vHeight);
            }
        }
        
        function searchNumFillAll(objName,changeFunction,vHeight){
            var obj = document.getElementById(objName);
                url = "/IFF_MAIN/ASP/ajaxFunctions/ajax_get_international_mawb_list.asp?mode=AE";
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
        
        function Button1_ClientClick(){
            if(document.getElementById("hSearchNum").value == "" || document.getElementById("hSearchNum").value == "0"){
                alert("Please, select a master AWB.");
                return false;
            }
            else{
                return true;
            }
        }
    </script>

</head>
<body style="margin: 0px 0px 0px 0px">
    <form id="form1" runat="server">
        <asp:HiddenField ID="PeriodChange" runat="server" Value="N" />
        <center>
            <table cellpadding="0" cellspacing="0" border="0" style="width: 95%">
                <tr>
                    <td class="pageheader" style="text-align: left">
                        Air Export PNL
                    </td>
                </tr>
            </table>
            <table cellpadding="0" cellspacing="0" border="0" style="width: 95%; border-color: #a0829c"
                class="border1px">
                <tr>
                    <td style="height: 8px; background-color: #E5D4E3">
                    </td>
                </tr>
                <tr>
                    <td style="height: 1px; background-color: #a0829c">
                    </td>
                </tr>
                <tr>
                    <td align="center"><br />
                        <table cellpadding="2" cellspacing="0" border="0" style="width:60%; border-color:#a0829c; text-align:left" class="border1px">
                            <tr>
                                <td>
                                    <table cellpadding="0" cellspacing="0" border="0">
                                        <tr>
                                        <td></td>
                                        <td class="bodyheader">Master AWB</td></tr>
                                        <tr>
                                            <td style="width:10px"></td>
                                            <td>
                                                <asp:HiddenField ID="hSearchNum" runat="server" Value="" />
                                                <div id="lstSearchNumDiv">
                                                </div>
                                                <asp:TextBox ID="lstSearchNum" runat="server" autocomplete="off" class="shorttextfield"
                                                    Style="width: 200px; border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9;
                                                    border-left: 1px solid #7F9DB9; border-right: 0px solid #7F9DB9; color: Black"
                                                    onkeyup=" searchNumFill(this,'lstSearchNumChange','');" onfocus="initializeJPEDField(this);"></asp:TextBox></td>
                                            <td style="width: 16px">
                                                <img src="/ig_common/Images/combobox_drop.gif" alt="" onclick="searchNumFillAll('lstSearchNum','lstSearchNumChange',200);"
                                                    style="border-top: 1px solid #7F9DB9; border-bottom: 1px solid #7F9DB9; border-right: 1px solid #7F9DB9;
                                                    border-left: 0px solid #7F9DB9; cursor: hand;" /></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="3" style="height: 10px">
                                </td>
                            </tr>
                            <tr>
                                <td colspan="3" style="text-align: right">
                                    <asp:ImageButton ID="Button1" runat="server" ImageUrl="../../../images/button_go.gif"
                                        OnClick="Button1_Click" OnClientClick="return Button1_ClientClick();"></asp:ImageButton></td>
                            </tr>
                        </table>
                        <br />
                    </td>
                </tr>
                <tr>
                    <td style="height: 1px; background-color: #a0829c">
                    </td>
                </tr>
                <tr>
                    <td style="height: 25px; background-color: #E5D4E3">
                    </td>
                </tr>
            </table>
        </center>
    </form>
</body>


</html>
