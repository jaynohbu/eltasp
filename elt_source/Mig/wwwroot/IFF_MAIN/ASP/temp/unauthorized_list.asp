<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/transaction.txt" -->
<% Option Explicit %>
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/connection.asp" -->
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/Header.asp" -->
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/GOOFY_data_manager.inc" -->
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/GOOFY_util_fun.inc" -->
<table>
<%

    Dim allUserList,allPageList,i,j,k,mode
    
    Set allPageList = Server.CreateObject("System.Collections.ArrayList")
    Call GetAllTabs
    Call GetUnAuthPages
    
    Sub GetAllTabs
        Dim SQL,dataObj
        SQL = "select elt_account_number,userid from users where user_right <> 9 order by elt_account_number,userid"
        Set dataObj = new DataManager
        dataObj.SetDataList(SQL)
        Set allUserList = dataObj.GetDataList
    End Sub
    
    Sub GetUnAuthPages
    
        Dim SQL,dataObj,tmpDataList
        k = 0
        For i=0 To allUserList.count-1
            Set tmpDataList = Server.CreateObject("System.Collections.ArrayList")
            
            SQL = "select " & allUserList(i)("elt_account_number") _
                & " as elt_account_number," & allUserList(i)("userid") _
                & " as userid,* from se_pages where page_id not in " _
                & "(select a.page_id from se_user_authority a left join " _ 
                & "se_pages b on a.page_id = b.page_id left join se_modules c on " _
                & "b.Module_Id = c.Module_Id where "_
                & "a.elt_account_number=" & allUserList(i)("elt_account_number") _
                & " and a.userid=" & allUserList(i)("userid") & ")"
            
            Set dataObj = new DataManager
            dataObj.SetDataList(SQL)
            Set tmpDataList = dataObj.GetDataList
            
            If tmpDataList.Count < 20 Then
            k = k + 1
            For j=0 To tmpDataList.Count-1
%>
    <tr>
    <td><%=tmpDataList(j)("elt_account_number") %></td>
    <td><%=tmpDataList(j)("userid") %></td>
    <td><%=tmpDataList(j)("Name") %></td>
    </tr>
<%
            Next
            End If
        Next
    End Sub
%>
</table>
<%= k*j %> Records, <%=k %> users

<% 
    eltConn.Close
	Set eltConn=Nothing
 %>
