<%
	'--------------------------------------------------------------------------
	'Subroutine to  display Page links.
	Sub DisplayPageLinks(rs,intPageNum)
		Dim i 'as integer
		Response.Write "<br> Jump to Page: "
		For i=1 to rs.PageCount
			if i=intPageNum then
				Response.Write  i &"&nbsp;"
			else
				Response.Write "&nbsp;<a href=""" _
				& Request.ServerVariables("SCRIPT_NAME") _
				& "?Search=yes&pn="& i _
				& "&txtStartDate="& vStartDate & "&txtEndDate="& vEndDate _
				& "&lstDate=" & vSelDate & "&txtDeptPort1=" & vDeptPort1 & "&txtDeptPort2="& vDeptPort2 _
				& "&lstDeptPort=" & vSelDeptPort & "&lstDestPort=" & vSelDestPort _
				& "&txtDestPort1=" & vDestPort1 & "&txtDestPort2=" & vDestPort2 _
				& "&lstShipperName=" & vlstShipper & "&lstConsigneeName=" & vlstConsignee _
				& "&txtShipper1=" & vShipper1 & "&txtShipper2=" & vShipper2 _
				& "&txtConsignee1=" & vConsignee1 & "&txtConsignee2=" & vConsignee2 _
				& "&lstAgentName=" & vlstAgent& "&lstAirline=" & vlstAirline _
				& "&txtAgent1=" & vAgent1 & "&txtAgent2=" & vAgent2 _
				& "&txtAirline1=" & vAirline1 & "&txtAirline2=" & vAirline2 _
	 		    & """>" & i & "&nbsp;</a>"
			end if
		Next 'i
	
	End Sub
	'----------------------------------------------------------------
	'subroutine to dislay Navigation links.
	Sub DisplayNavigation(rs,intPageNum)
		Response.Write "<P>"
		if intPageNum > 1 then
			Response.Write  ">> <a href="""&Request.ServerVariables("SCRIPT_NAME") &"?Search=yes&pn="&intPageNum -1 _
				& "&txtStartDate="& vStartDate & "&txtEndDate="& vEndDate _
				& "&lstDate=" & vSelDate & "&txtDeptPort1=" & vDeptPort1 & "&txtDeptPort2="& vDeptPort2 _
				& "&lstDeptPort=" & vSelDeptPort & "&lstDestPort=" & vSelDestPort _
				& "&txtDestPort1=" & vDestPort1 & "&txtDestPort2=" & vDestPort2 _
				& "&lstShipperName=" & vlstShipper & "&lstConsigneeName=" & vlstConsignee _
				& "&txtShipper1=" & vShipper1 & "&txtShipper2=" & vShipper2 _
				& "&txtConsignee1=" & vConsignee1 & "&txtConsignee2=" & vConsignee2 _
				& "&lstAgentName=" & vlstAgent& "&lstAirline=" & vlstAirline _
				& "&txtAgent1=" & vAgent1 & "&txtAgent2=" & vAgent2 _
				& "&txtAirline1=" & vAirline1 & "&txtAirline2=" & vAirline2 _
				& """>PREVIOUS</a>&nbsp;&nbsp;&nbsp;"
		end if
		if intPageNum < rs.PageCount then
			Response.Write  "&nbsp;&nbsp; <a href="""&Request.ServerVariables("SCRIPT_NAME") &"?Search=yes&pn="&intPageNum +1 _
				& "&txtStartDate="& vStartDate & "&txtEndDate="& vEndDate _
				& "&lstDate=" & vSelDate & "&txtDeptPort1=" & vDeptPort1 & "&txtDeptPort2="& vDeptPort2 _
				& "&lstDeptPort=" & vSelDeptPort & "&lstDestPort=" & vSelDestPort _
				& "&txtDestPort1=" & vDestPort1 & "&txtDestPort2=" & vDestPort2 _
				& "&lstShipperName=" & vlstShipper & "&lstConsigneeName=" & vlstConsignee _
				& "&txtShipper1=" & vShipper1 & "&txtShipper2=" & vShipper2 _
				& "&txtConsignee1=" & vConsignee1 & "&txtConsignee2=" & vConsignee2 _
				& "&lstAgentName=" & vlstAgent& "&lstAirline=" & vlstAirline _
				& "&txtAgent1=" & vAgent1 & "&txtAgent2=" & vAgent2 _
				& "&txtAirline1=" & vAirline1 & "&txtAirline2=" & vAirline2 _
			
				& """>NEXT << </a>&nbsp"
		end if
			Response.Write "</P>"
End Sub

'--------------------------------------------------------------------------
'function for sorting
Function CreateHeading(strTitle,strNewSort,strOldSort,strOldOrder,vStartDate,vEndDate, _
	 vSelDate,vDeptPort1,vDeptPort2, vSelDeptPort,vSelDestPort,vDestPort1,vDestPort2, _
	 vlstShipper,vlstConsignee,vShipper1,vShipper2,vConsignee1,vConsignee2, _
	 vlstAgent,vlstAirline,vAgent1,vAgent2,vAirline1,vAirline2,shipper_link_value, _
	 consignee_link_value,vShipperId,vConsigneeId )
	Dim strNewOrder

	If strNewSort=strOldSort then
		If strOldOrder="ASC" then
			strNewOrder="DESC"
		else
			strNewOrder="ASC"
		end if
	else
		strNewOrder="ASC"
	end if

	CreateHeading="<a href=""" & Request.ServerVariables("SCRIPT_NAME") & "?so=" &strNewSort _
					& "&sd=" & strNewOrder & "&txtStartDate="& vStartDate & "&txtEndDate="& vEndDate _
					& "&lstDate=" & vSelDate & "&txtDeptPort1=" & vDeptPort1 & "&txtDeptPort2="& vDeptPort2 _
					& "&lstDeptPort=" & vSelDeptPort & "&lstDestPort=" & vSelDestPort _
					& "&txtDestPort1=" & vDestPort1 & "&txtDestPort2=" & vDestPort2 _
					& "&lstShipperName=" & vlstShipper & "&lstConsigneeName=" & vlstConsignee _
					& "&txtShipper1=" & vShipper1 & "&txtShipper2=" & vShipper2 _
					& "&txtConsignee1=" & vConsignee1 & "&txtConsignee2=" & vConsignee2 _
					& "&lstAgentName=" & vlstAgent& "&lstAirline=" & vlstAirline _
					& "&txtAgent1=" & vAgent1 & "&txtAgent2=" & vAgent2 _
					& "&txtAirline1=" & vAirline1 & "&txtAirline2=" & vAirline2 _
					& "&ShipperLink=" & shipper_link_value & "&ConsigneeLink=" & consignee_link_value _
					& "&lstShipperId=" & vShipperId & "&lstConsigneeId=" & vConsigneeId _
					&""" >" & strTitle & "</a>"
					
	'Response.Write "<br>" & 
End Function
%>