<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">
    public string[] aField0 = new string[4];
    public string[] aField1 = new string[4];
    public string[] aField2 = new string[4];

    protected void Page_Load(object sender, EventArgs e)
    {
        getRSS();

        // Initialize Page & Session
        string strIndex = "";
        if (Session["IndexTR"] != null) { strIndex = Session["IndexTR"].ToString(); }

        if (!IsPostBack)
        {
            Session["IndexTR"] = "0";
        }
        else { if (strIndex != "0") { Session["IndexTR"] = "9999"; } }

    }

    private void getRSS()
    {

        // Export News
        RssFunctions.RssReader reader = new RssFunctions.RssReader();
        reader.LoadFromHttp("http://cbp.gov/xp/cgov/admin/rss/?rssUrl=/export/");

        for (int i = 0; i < 4; i++)
        {
            RssFunctions.RssItem item = reader.Items[i];

            int comIndex = item.Pubdate.ToString().LastIndexOf(",");
            if (comIndex < 0)
            {
                aField0[i] = "- " + item.Pubdate.ToString();
            }
            else
            {
                int strLen = item.Pubdate.ToString().Length - comIndex;
                aField0[i] = "- " + item.Pubdate.ToString().Substring(comIndex + 1, strLen - 1);
            }

            aField1[i] = item.Title;
            aField2[i] = item.Link.ToString();
        }

    }

    protected void btnGoMain_Click(object sender, EventArgs e)
    {
        string strTr = "";

        if (Session["IndexTR"] != null)
        {
            strTr = Session["IndexTR"].ToString();
        }


        if (strTr != "9999")
        {
            Session["IndexTR"] = "9999";
            string param = Session["IndexTR"].ToString();
            Response.Redirect("/IFF_MAIN/Main.aspx?T=");
        }
        else
        {
            Session["IndexTR"] = "0";
        }
    }    

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>FreightEasy-A complete Freight Forwarding System Made Easy</title>

    <script type="text/javascript" language="javascript" src="freighteasy/js/favorite.js"></script>


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
    document.hLogin.submit();
}

function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
//-->
</script>

    <link href="freighteasy/css/style_freighteasy.css" rel="stylesheet" type="text/css" />
    <meta name="keywords" content="Freight Forwarders, IFF, software, NVOCC, Import, Export, supply chain management, HAWB, MAWB, SED, deconsolidation">
    <meta name="description" content="software solution for Freight Forwarders, logistics solution">
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
    <link rel="Shortcut Icon" type="image/ico" href="freighteasy/images/favicon.ico" />
    <style type="text/css">
<!--
.style3 {color: #999999}
.style4 {color: #1783c7}
-->
    </style>
</head>
<body onload="MM_preloadImages('freighteasy/images/button_elthome_over.gif','freighteasy/images/button_login_help_over.gif')">
 <form id="inputs" runat="server">
    <table width="100%" border="0" cellpadding="0" cellspacing="0"">
        <tr>
            <td width="100%" align="left" valign="top">
                <table width="100%" height="42" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td>
                            <% 
                                Server.Execute("/Include/main_menu.htm");
                            %>
                        </td>
                    </tr>
                </table>
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td height="1" colspan="2" bgcolor="#a4a3a7">                        </td>
                    </tr>
                <td bgcolor="#d5d6e1">
                    <table width="100%" height="0" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td width="3%" height="16" align="left" valign="middle">                            </td>
                            <td align="left" valign="bottom" class="breadcrumb">                            </td>
                        </tr>
                        <tr>
                            <td align="left" valign="top">&nbsp;                                </td>
                            <td align="left" valign="bottom">
                                <a href="freighteasy/index.aspx">
                                    <img src="freighteasy/images/product_logo.gif" width="121" height="37" border="0" onclick="javascript:goIFF();" /></a><img
                                        src="freighteasy/images/spacer.gif" width="276" height="1" /></td>
                        </tr>
                        <tr>
                            <td height="1" colspan="2" align="left" valign="top">                            </td>
                        </tr>
                    </table>                </td>
            <td bgcolor="#d5d6e1">&nbsp;                </td>
        </tr>
        <tr>
            <td height="1" colspan="2" bgcolor="#a4a3a7">            </td>
        </tr>
        <tr>
            <td width="66%" align="left" valign="top">
                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td width="3%" height="24" align="left" valign="top" bgcolor="#FFFFFF">&nbsp;                            </td>
                        <td width="94%" align="left" valign="top" bgcolor="#FFFFFF">                        </td>
                        <td width="3%" align="left" valign="top" bgcolor="#FFFFFF">                        </td>
                    </tr>
                    <tr>
                        <td height="29" align="left" valign="top" bgcolor="#FFFFFF">                        </td>
                        <td align="left" valign="top" bgcolor="#FFFFFF">
                            <h1>A Complete Freight Forwarding System Made Easy</h1>                        </td>
                        <td align="left" valign="top" bgcolor="#FFFFFF">                        </td>
                    </tr>
                    <tr>
                        <td align="left" valign="top" bgcolor="#FFFFFF">                        </td>
                        <td align="left" valign="top" bgcolor="#FFFFFF"><p>
                            FreightEasy&trade; is an all-in-one software system made for Freight Forwarders.
                            It is web-native, which increases data security, allows users to use it outside
                            of the office, and greatly reduces the time and cost of implementation. FreightEasy
                            also has an integrated accounting and reporting system. Its design is very intuitive
                            with a professional look and feel.&nbsp;Despite these improvements over other systems
                            on the market, FreightEasy still comes at a competitive price.</p>                        </td>
                        <td align="left" valign="top" bgcolor="#FFFFFF">                        </td>
                    </tr>
                </table>            </td>
            <td rowspan="2" width="34%" align="left" valign="top" bgcolor="#edf2f8">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td width="70%" align="left" valign="top" bgcolor="#edf2f8">
                            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td width="8%" align="left" valign="top" bgcolor="#edf2f8">                                    </td>
                                    <td width="92%" align="left" valign="top" bgcolor="#edf2f8">
                                        <div id="features">
                                            <img src="freighteasy/images/feature_default.gif" width="202" height="52" />
                                            <h4>
                                                FreightEasy&trade; was designed with one overarching goal in mind: to give our members
                                                a competitive edge. We have achieved this goal by concentrating on system features
                                                that will have a real impact on real businesses.</h4>
                                            <h5>
                                                <a href="freighteasy/feature_story.asp">< Read More ></a></h5>
                                        </div></td>
                                </tr>
                                <tr>
                                    <td height="1">                                    </td>
                                    <td height="1" bgcolor="#9dc8ef">                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" bgcolor="#edf2f8">&nbsp;                                        </td>
                                    <td align="left" valign="top">
                                        <div id="featurequeston">
                                            Learn how FreightEasy’s features will improve the way you do business.</div>

                                            <select name="listbox" id="listbox" onchange="javascript:listboxscript();">
                                                <option value="0">Choose from the following:</option>
                                                <option value="1">Customer Care</option>
                                                <option value="2">Mobility</option>
                                                <option value="3">Accounting</option>
                                                <option value="4">SaaS</option>
                                                <option value="5">System Design</option>
                                            </select>                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" bgcolor="#edf2f8">&nbsp;                                        </td>
                                    <td align="left" valign="top">&nbsp;                                        </td>
                                </tr>
                            </table>                        </td>
                        <td width="30%" align="left" valign="top" bgcolor="#edf2f8">&nbsp;                            </td>
                    </tr>
                </table>            </td>
        </tr>
        <tr>
            <td align="left" valign="bottom">
                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td width="3%">&nbsp;                            </td>
                        <td width="94%">
                            <img src="freighteasy/images/index_intro.jpg" width="590" height="140" /></td>
                        <td width="3%">&nbsp;                            </td>
                    </tr>
                </table>            </td>
        </tr>
        <tr>
            <td height="1" colspan="2" bgcolor="#a4a3a7">            </td>
        </tr>
        <tr>
            <td align="left" valign="top">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">

                    <tr>
                        <td width="3%" align="left" valign="top" id="infogroup"><table width="100%" height="52" border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td id="logtitleback">&nbsp;</td>
                            </tr>
                        </table></td>
                        <td colspan="2" align="left" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td align="left" valign="top" id="infogroup"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td height="52" align="left" valign="bottom" id="logtitleback"><img src="freighteasy/images/memberlogin.gif" /><br />
<img src="freighteasy/images/spacer.gif" width="180" height="7" /></td>
                                    </tr>
                                    <tr>
                                        <td><iframe id="loginFrame" style="padding-right: 0px; padding-left: 0px; padding-bottom: 0px;
                                                            margin: 0px; padding-top: 0px" name="loginFrame" frameborder="no" scrolling="no"
                                                            height="130px" width="181px" src="<% Request.ServerVariables["SERVER_NAME"].ToLower(); %>/IFF_MAIN/Authentication/login2.aspx"> </iframe></td>
                                    </tr>
                                    <tr>
                                        <td height="24" align="left" valign="bottom"><a href="freighteasy/getting_tips.asp" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('loginhelp','','freighteasy/images/button_login_help_over.gif',1)"><img src="freighteasy/images/button_login_help.gif" name="loginhelp" width="173" height="16" border="0" id="loginhelp" /></a></td>
                                    </tr>
                                </table></td>
                                <td width="77%" align="left" valign="top" id="infogroupright"><table width="100%" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td width="5%" height="58" align="left" valign="bottom" id="tablineback">&nbsp;</td>
                                        <td width="90%" align="left" valign="bottom" id="tablineback"><table border="0" cellspacing="0" cellpadding="0">
                                                <tr>
                                                    <td width="1" bgcolor="#aeaeae"></td>
                                                    <td id="T1" onclick="tabscript(this);" ><img src="freighteasy/images/spacer.gif" width="1" height="16" align="absmiddle" /><a href="#">Trial Account</a></td>
                                                    <td width="1" bgcolor="#aeaeae"></td>
                                                    <td id="T2" onclick="tabscript(this);" ><img src="freighteasy/images/icon_down.gif" width="13" height="16" align="absmiddle" />&nbsp;&nbsp;<a href="#">Downloads</a></td>
                                                    <td width="1" bgcolor="#aeaeae"></td>
                                                    <td id="T3" onclick="tabscript(this);" ><img src="freighteasy/images/spacer.gif" width="1" height="16" align="absmiddle" /><a href="#">News</a></td>
                                                    <td width="1" bgcolor="#aeaeae"></td>
                                                </tr>
                                        </table></td>
                                        <td width="5%" align="left" valign="bottom" id="tablineback">&nbsp;</td>
                                    </tr>
                                    
                                    <tr>
                                        <td>&nbsp;</td>
                                        <td>
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr>
                                                        <td width="35%" align="left" valign="top"><div id="tabbody"><div id="tabbodyleft"><img src="freighteasy/images/tab_trial_img.gif" width="98" height="98" /></div><div id="tabbodyright">
                                                            <h2>Want to know how FreightEasy works? Free Trial Accounts are available.</h2>
                                                            <ul class="psmall"><li><img src="freighteasy/images/tabbutton1.gif" width="18" height="11" align="absmiddle" />Instant account setup</li><li><img src="freighteasy/images/tabbutton2.gif" width="18" height="11" align="absmiddle" />A full version of the system</li></ul><ul class="psmallbottom"><li><img src="freighteasy/images/tabbutton3.gif" width="18" height="11" align="absmiddle" />No installation required</li></ul><h2 class="buttonlink"><a href="freighteasy/account_setup.asp"><img src="freighteasy/images/button_trial.gif" border="0" /></a></h2></div>
                                                        </div></td>
                                                        </tr>
                                                </table>
                                        </td>
                                        <td>&nbsp;</td>
                                    </tr>
                                </table></td>
                            </tr>
                        </table>                        </td>
                        </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td width="94%" align="left" valign="top">&nbsp;</td>
                        <td width="3%">&nbsp;</td>
                    </tr>
                </table>            </td>
            <td align="left" valign="top">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td width="70%" align="left" valign="top">
                            <div id="navleftbar">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td>
                                            <ul id="mainnavheader">
                                                <li><a href="#">FreightEasy Home</a></li>
                                            </ul>
                                            <ul id="mainnav">
                                                <li><a href="freighteasy/introduction.asp">Introduction</a></li>
                                                <li><a href="freighteasy/why_fe.asp">Why FreightEasy</a></li>
                                                <li><a href="freighteasy/features.asp">Features</a></li>
                                            </ul>
                                            <ul id="mainnavbottom">
                                                <li><a href="freighteasy/faqs.asp">FAQs</a></li></ul>                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <ul id="mainnavheader">
                                                <li><a href="#">Quick Links </a></li>
                                            </ul>
                                            <ul id="mainnav">
                                                <li><a href="freighteasy/account_setup.asp">Free Trial Account </a></li>
                                                <li><a href="freighteasy/getting_tips.asp">Getting Started Tips </a></li>
                                                <li><a href="support.asp">Support</a></li>
                                            </ul>                                        </td>
                                    </tr>
                                </table>
                            </div>                        </td>
                        <td width="30%">&nbsp;                            </td>
                    </tr>
                </table>            </td>
        </tr>
        <tr>
            <td height="1" colspan="2" bgcolor="#a4a3a7">            </td>
        </tr>
        <tr>
            <td>
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td width="3%" height="48">&nbsp;                            </td>
                        <td width="94%" align="left" valign="middle">
                        
<!--// siteinfo -->                        
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td width="66%" height="42">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td width="100%" align="left" valign="middle">
                        <div id="siteinfo">
                            Copyright&copy; 2006 E-Logistics Technology, Inc. All rights reserved.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <a href="freighteasy/index.aspx">Home</a> | <a href="legal.asp">Legal &amp; Privacy</a>
                            | <a href="contact.asp">Contact</a></div>                    </td>
                </tr>
            </table>        </td>
    </tr>
</table>
<!--// -->                        </td>
                        <td width="3%">&nbsp;                            </td>
                    </tr>
                </table>            </td>
            <td align="left" valign="top"><div id="aspbutton"><asp:Button ID="btnGoMain" runat="server" OnClick="btnGoMain_Click" Width="0px" Height="0px" CausesValidation="False"></asp:Button>
            <asp:LinkButton ID="LinkButton1" runat="server" Height="0px" Width="0px"></asp:LinkButton></div>            </td>
        </tr>
    </table>
            </form>
</body>
</html>