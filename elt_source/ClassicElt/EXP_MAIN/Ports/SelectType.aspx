<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SelectType.aspx.cs" Inherits="Ports_SelectType" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Search Port</title>
<base target="_self" />
<link href="../css/elt_css.css" rel="stylesheet" type="text/css" />
<style type="text/css">
        .style01 {
            font-family: Verdana, Arial, Helvetica, sans-serif;
	        font-size: 12px;
	        font-weight: bold;
	        text-transform: uppercase;
	        color: #000000;
	    }
    </style>

<script type="text/javascript">

</script>

</head>
<body>
    <form id="form1" runat="server">
        <div style="text-align: center">
            <div style="width: 95%; text-align: left; margin: 10px 0px 10px 0px">
                <table class="style01" cellpadding="2" cellspacing="0" border="0" style="width: 100%;
                    border: solid 1px #999999">
                    <tr style="background-color: #dddddd">
                        <td colspan="2">
                            Select Type of Ports
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" class="bodycopy" style="height:1px; background-color:#999999">
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" class="bodycopy" style="height:10px">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:CheckBox runat="server" ID="chkUSPort" AutoPostBack="true" OnCheckedChanged="chkUSPort_CheckedChanged" />
                            US Port</td>
                        <td>
                            <asp:CheckBox runat="server" ID="chkNonUSPort" AutoPostBack="true" OnCheckedChanged="chkNonUSPort_CheckedChanged" />
                            Non-US Port</td>
                    </tr>
                </table>
            </div>
        </div>
    </form>
</body>
</html>
