<%
FUNCTION GET_GREETING_MESSAGE( MsgType )
DIM tmpGRSQL
 tmpGRSQL= "select MsgTxt from greetMessage where AgentID = " & elt_account_number & " and MsgType='" & MsgType & "'"
 Set rsGRTmp = eltConn.Execute(tmpGRSQL)
 if not(rsGRTmp.BOF or rsGRTmp.EOF) then	
	 GET_GREETING_MESSAGE  = rsGRTmp("MsgTxt")				
 else 
	 GET_GREETING_MESSAGE = ""
 end if
 Set rsGRTmp  = Nothing
END FUNCTION
%>