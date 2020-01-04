<!--  #INCLUDE FILE="../include/transaction.txt" -->
<%
    Option Explicit
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<!--  #INCLUDE FILE="../include/connection.asp" -->
<!--  #INCLUDE FILE="../include/Header.asp" -->
<!--  #INCLUDE FILE="../include/GOOFY_data_manager.inc" -->
<!--  #INCLUDE FILE="../include/GOOFY_util_fun.inc" -->
<%
    Dim feData, SQL, vHAWB, vMAWB, vHBOL, vBooking, vType, aAllData, i
    
    vHAWB = checkBlank(Request.QueryString("HAWB"),"")
    vMAWB = checkBlank(Request.QueryString("MAWB"),"")
    vHBOL = checkBlank(Request.QueryString("HBOL"),"")
    vBooking = checkBlank(Request.QueryString("BOOK"),"")
    vType = checkBlank(Request.QueryString("TYPE"),"A")
    
    Set feData = new DataManager
    
    SQL = "SELECT * FROM invoice WHERE import_export='E' AND invoice_type='I' AND amount_charged<0 AND elt_account_number=" _
        & elt_account_number & " AND hawb_num=N'" & vHAWB &"' AND mawb_num=N'" & vMAWB & "' AND air_ocean='" & vType & "'"
    
    feData.SetDataList(SQL)
    Set aAllData = feData.getDataList

%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />
    <title>Credit Note</title>

    <script type="text/javascript">
        window.returnValue = -1;
        function SetReturnValue(arg){
            window.returnValue = arg;
            window.close();
        }
        
        <% If aAllData.Count = 0 Then %>
        SetReturnValue(0);
        <% End If %>
    </script>

</head>
<body>
    <div style="text-align: center; width: 100%">
        <div style="text-align: left; width: 95%" class="pageheader">
            SELECT/CREATE CREDIT NOTE</div>
        <table cellpadding="2" cellspacing="0" border="0" class="bodycopy" style="text-align: left;
            width: 95%">
            <tr class="bodyheader" style="background-color:#dddddd">
                <td>
                </td>
                <td>
                    Credit Note No</td>
                <td>
                    Customer Name</td>
                <td>
                    Credit Amount</td>
                <td>
                </td>
            </tr>
            <% For i = 0 To aAllData.Count-1 %>
            <tr>
                <td>
                    <input type="checkbox" value="Select" onclick="SetReturnValue(<%=aAllData(i)("invoice_no") %>)"
                        class="bodycopy" />
                </td>
                <td>
                    <%=aAllData(i)("invoice_no") %>
                </td>
                <td>
                    <%=aAllData(i)("Customer_Name") %>
                </td>
                <td>
                    <%=aAllData(i)("amount_charged") %>
                </td>
                <td>
                </td>
            </tr>
            <tr>
                <td colspan="5" style="background-color:#cccccc; height:1px"></td>
            </tr>
            <% Next %>
        </table>
        <br />
        <div style="text-align: left; width: 95%">
            <input type="button" class="bodycopy" onclick="SetReturnValue(0);" value="New Credit Note"/>
            <input type="button" class="bodycopy" onclick="window.close();" value="Cancel"/>
        </div>
    </div>
</body>
</html>
