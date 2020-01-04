<!--  #INCLUDE FILE="../include/transaction.txt" -->
<% 
    Option Explicit
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<!--  #INCLUDE FILE="../include/connection.asp" -->
<!--  #INCLUDE FILE="../include/GOOFY_util_fun.inc" -->
<!--  #INCLUDE FILE="../include/GOOFY_data_manager.inc" -->
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Select Country</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />

    <script type="text/jscript">
        function lstCountryChange(){
            var vCurrencyCode = document.getElementById("lstCountry").value;
            document.getElementById("txtCountry").value = vCurrencyCode;
        }
        function SetCountry(){
            window.returnValue = document.getElementById("lstCountry").value;
            window.close();
        }
    </script>

</head>
<%

    Dim aAllData, i, vCountryCode
    
    Set aAllData = GetAllData()
    vCountryCode = Request.QueryString("code")
    
    Function GetAllData
        Dim feData,SQL
        Set feData = new DataManager
        SQL = "SELECT * FROM all_country_code a LEFT OUTER JOIN all_currency_code b ON (a.country_code=b.country_code) ORDER BY a.country_name"
        feData.SetDataList(SQL)
        Set GetAllData = feData.getDataList
    End Function
%>
<body style="background-color: #cdcdcd">
    <div style="text-align: center">
        <form id="form1" action="">
            <table cellpadding="0" cellspacing="0" border="0" class="bodycopy" style="width: 90%">
                <tr style="height: 8px">
                    <td colspan="3">
                    </td>
                </tr>
                <tr>
                    <td colspan="3" align="center">
                        <select id="lstCountry" name="lstCountry" size="15" class="bodycopy" style="width: 350"
                            onchange="lstCountryChange()">
                            <% For i=0 To aAllData.Count-1 %>
                            <option value="<%=aAllData(i)("country_code") %>" <% If vCountryCode=aAllData(i)("country_code") Then Response.Write("selected=selected") %>>
                                <%=aAllData(i)("country_name") %>
                                -
                                <%=aAllData(i)("country_code") %>
                            </option>
                            <% Next %>
                        </select>
                    </td>
                </tr>
                <tr style="height: 5px">
                    <td colspan="3">
                    </td>
                </tr>
                <tr>
                    <td>
                        Country Code
                    </td>
                    <td>
                        <input type="text" id="txtCountry" class="shorttextfield" readonly="readonly" size="8"
                            value="<%=vCountryCode %>" />
                    </td>
                    <td align="right">
                        <input type="button" value="Select & Close" class="bodycopy" onclick="SetCountry()" />
                    </td>
                </tr>
            </table>
        </form>
    </div>
</body>
</html>
