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
    <title>Select or type in currency</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />

    <script type="text/jscript">
        function lstCurrencyChange(){
            var vCurrencyCode = document.getElementById("lstCurrency").value;
            document.getElementById("txtCurrency").value = vCurrencyCode;
        }
        function SetCurrency(){
            window.returnValue = document.getElementById("txtCurrency").value;
            window.close();
        }
    </script>

</head>
<%

    Dim aAllData, i, vCountry, vCurrency
    
    Set aAllData = GetAllCurrencies()
    vCountry = Request.QueryString("ccode")
    vCurrency = Request.QueryString("code")
    
    Function GetAllCurrencies
        Dim feData,SQL
        Set feData = new DataManager
        SQL = "SELECT * FROM all_country_code a LEFT OUTER JOIN all_currency_code b ON (a.country_code=b.country_code) ORDER BY a.country_name"
        feData.SetDataList(SQL)
        Set GetAllCurrencies = feData.getDataList
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
                        <select id="lstCurrency" name="lstCurrency" size="15" class="bodycopy" style="width: 350"
                            onchange="lstCurrencyChange()">
                            <% For i=0 To aAllData.Count-1 %>
                            <option value="<%=aAllData(i)("currency_code") %>" <% If vCountry=aAllData(i)("country_code") And vCurrency=aAllData(i)("currency_code") Then Response.Write("selected=selected") %>>
                                <%=aAllData(i)("country_name") %>
                                -
                                <%=aAllData(i)("currency_name") %>
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
                        Currency Code:
                    </td>
                    <td>
                        <input type="text" id="txtCurrency" class="shorttextfield" size="8"
                            value="<%=vCurrency %>" maxlength="3" />
                    </td>
                    <td align="right">
                        <input type="button" value="Select & Close" class="bodycopy" onclick="SetCurrency()" />
                    </td>
                </tr>
            </table>
        </form>
    </div>
</body>
</html>
