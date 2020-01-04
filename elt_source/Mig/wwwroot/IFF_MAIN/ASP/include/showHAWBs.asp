<!--  #INCLUDE FILE="../include/transaction.txt" -->
<% 
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<!--  #INCLUDE FILE="./connection.asp" -->
<!--  #INCLUDE FILE="./header.asp" -->

<script language="javascript">

function showArrivalNotice(harg,marg)
{  
	window.returnValue = "HAWB=" + harg + "&MAWB=" + marg;
	window.close();
}
function alertAndClose(){
    alert("No result found!");
    window.close();
}

</script>
<%

Dim testList,i,hawbNum,mawbNum, AE
hawbNum = checkBlank(Request.QueryString("HAWB"),"")
mawbNum = checkBlank(Request.QueryString("MAWB"),"")

AE=Request.QueryString("AE")

Set testList = GetListByHAWB(hawbNum,elt_account_number,"import_hawb")

if testList.Count = 1 then 
    dim mrg, hrg
    mrg = testList(0)("MAWB")
    hrg = testList(0)("HAWB")
    response.Write("<script language='javascript'> showArrivalNotice('"& hrg &"','"& mrg &"' )</script>")
end if 

if testList.Count = 0 then 
   response.Write("<script language='javascript'> alertAndClose();</script>")
end if 

Function GetListByHAWB(hawbNum,eltNum,tableName)
    Dim returnList, hawbTable, sqlTxt, rs
    
    Set returnList = Server.CreateObject("System.Collections.ArrayList")
    Set rs = Server.CreateObject("ADODB.Recordset")
    
    If hawbNum = "" Then
        sqlTxt = "SELECT HAWB_NUM,MAWB_NUM FROM " & tableName & " WHERE MAWB_NUM=N'" _
            & mawbNum & "' AND elt_account_number=N'" & eltNum  & "' AND iType=N'" & AE & "'"
    Else
        sqlTxt = "SELECT HAWB_NUM,MAWB_NUM FROM " & tableName & " WHERE HAWB_NUM=N'" _
            & hawbNum & "' AND elt_account_number=N'" & eltNum  & "' AND iType=N'" & AE & "'"
    End If

    Set rs = eltConn.execute(sqlTxt)
    
    Do While Not rs.EOF and NOT rs.BOF
        Set hawbTable = Server.CreateObject("System.Collections.HashTable")
        hawbTable.Add "HAWB", rs("HAWB_NUM").Value
        hawbTable.Add "MAWB", rs("MAWB_NUM").Value
        returnList.Add hawbTable
        rs.MoveNext
	Loop
	
   
    
    Set GetListByHAWB = returnList
End Function

Function checkBlank(arg1,arg2)
    Dim result
    If IsNull(arg1) Then 
        result = arg2
    Else
		If Trim(arg1)="" Then
			result = arg2
		Else
			result = Trim(arg1)
		End If
    End If    
    checkBlank = result
    
End Function

%>


<html>
<head>
<link href="/iff_main/ASP/css/elt_css.css" rel="stylesheet" type="text/css" />
<style type="text/css">

<!--

.link {

                font-size: 10px;

                color: #336699;

}

-->

</style>

</head>



<body>
    <center>
        <br />
        <table class="bodycopy">
            <tr>
                <td align="left" class="bodyheader">
                    House AWB(S) found</td>
            </tr>
            <tr>
                <td style="height: 5px">
                </td>
            </tr>
            <% For i=0 To testList.Count-1 %>
            <tr>
                <td align='left' class="link" onclick="javascript:showArrivalNotice('<%=testList(i)("HAWB")%>','<%=testList(i)("MAWB")%>');"
                    onmouseout="this.style.textDecoration='none';" onmouseover="this.style.textDecoration='underline';"
                    style="cursor: hand;">
                    <%=testList(i)("MAWB")%>
                    -
                    <%=checkBlank(testList(i)("HAWB"),"Anonymous")%>
                </td>
            </tr>
            <tr>
                <td style="height: 3px">
                </td>
            </tr>
            <% Next %>
        </table>
    </center>
</body>
</html>
<!--  #INCLUDE FILE="./StatusFooter.asp" -->