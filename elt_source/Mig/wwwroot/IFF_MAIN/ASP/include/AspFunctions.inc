<%
    function check_url(chkStr)
        DIM UrlRef
	    UrlRef = Request.ServerVariables("HTTP_REFERER")
        if isnull(UrlRef) then
	        check_url = false
	        exit function
        else
	        if instr(UCASE(UrlRef),chkStr) > 0 then
		        check_url = true
		        exit function
	        else
		        check_url = false
		        exit function
	        end if
        end if
    end function

    Sub SESSION_VALID_AJAX( curPageName )
        Dim SQL_SESSION
        DIM session_ip,tmp_account_number

        On Error Resume Next:
	    session_ip = Request.Cookies("CurrentUserInfo")("IP")
	    tmp_account_number = Request.Cookies("CurrentUserInfo")("elt_account_number")

	    SQL_SESSION = "Update view_login Set alive = 1, u_time='"&now&"',requested_page=N'"&curPageName&"' where elt_account_number="&tmp_account_number&" AND ip=N'"&session_ip&"'" 
	    eltConn.Execute SQL_SESSION
    End SUB

    Sub put_recent_work(sUrl,DocNum,WorkDetail, strSoTitle)
        Dim SQL_RECENT,tmp_account_number,tmp_user_id
	    WorkDetail = replace(WorkDetail,"'","`")
	    WorkDetail = replace(WorkDetail,"""","``")
	    strSoTitle = replace(strSoTitle,"'","`")
	    strSoTitle = replace(strSoTitle,"""","``")
	    tmp_account_number = Request.Cookies("CurrentUserInfo")("elt_account_number")
	    tmp_user_id = Request.Cookies("CurrentUserInfo")("user_id")
	    SQL_RECENT= "insert INTO Recent_Work ( elt_account_number, user_id, workdate, title, docnum, surl, workdetail,remark,status ) "
	    SQL_RECENT= SQL_RECENT & " VALUES (" & tmp_account_number & ", N'" & tmp_user_id & "', '" & getDateTime() & "', N'" & strSoTitle & "',N'"& DocNum & "' ,N'" & sUrl & "' ,N'" & WorkDetail & "','','')" 
	    eltConn.Execute SQL_RECENT
    End Sub

    Function getTodaySQL()
        dim strDate
	    strDate = Year(Now) 
	    If len(Month(Now))=1 Then
		    strDate = strDate & 	"0" & Month(Now) 
	    Else
		    strDate = strDate &  Month(Now) 
	    End If
	    If len(Day(Now))=1 Then
		    strDate = strDate & 	"0" & Day(Now) 
	    Else
		    strDate = strDate & Day(Now) 
	    End If

	    getTodaySQL = strDate
    End Function


    Function getTimeSQL()
    dim strTime

	    If len(hour(Now))=1 Then
		    strTime = strTime & 	"0" & hour(Now)
	    Else
		    strTime = strTime &  hour(Now)
	    End If

	    If len(minute(Now))=1 Then
		    strTime = strTime & 	"0" & minute(Now)
	    Else
		    strTime = strTime &  minute(Now) 
	    End If
	    If len(second(Now))=1 Then
		    strTime = strTime & 	"0" & second(Now)
	    Else
		    strTime = strTime & second(Now) 
	    End If

	    getTimeSQL = strTime
    End Function


    Function getDateTime()
        dim strDateTime

	    strDateTime = mid(getTodaySQL(), 5,2) & "/" & mid(getTodaySQL(), 7,2) & "/" & mid(getTodaySQL(), 1,4)
	    strDateTime = strDateTime & " " & mid(getTimeSQL(), 1,2) & ":" & mid(getTimeSQL(), 3,2) & ":" & mid(getTimeSQL(), 5,2) 
     
	    getDateTime = strDateTime
    End Function


    sub transfer( elt_account_number, source, target )

        DIM SQL
        SQL = " EXEC sp_transfer_org_data "& elt_account_number & "," & source & "," & target
        eltConn.execute (SQL)

    end sub
%>


