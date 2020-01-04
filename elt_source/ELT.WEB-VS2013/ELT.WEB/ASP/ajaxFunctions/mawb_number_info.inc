<%
	Dim rs, SQL    
	Dim mawbInfo
	
	Dim mOrgNum,vDepCode,vArrCode,mDepartureAirportCode,mDepartureAirport,mDepartureState,mTo,mBy,mTo1,mBy1,mTo2,mBy2,mDestAirport,mDestCountry
	Dim mFlight1,mFlight2,mETDDate1,mETDDate2,mExportDate,mETDDate,mCarrierDesc,mFlightDate1,mFlightDate2,mFile,mServiceLevel

    set rs=Server.CreateObject("ADODB.Recordset")
	
	SQL= "select a.service_level,a.mawb_no,a.Origin_Port_ID, a.Dest_Port_ID, a.Origin_Port_ID,a.Origin_Port_Location,a.origin_port_state,a.[To],a.[By],a.To_1,a.By_1,a.To_2,a.By_2,a.Dest_Port_Location,a.dest_port_country,a.Flight#1,a.Flight#2,a.ETD_DATE1,a.ETD_DATE2,a.Carrier_Desc,a.file#,b.org_account_number from mawb_number a,organization b where a.elt_account_number=b.elt_account_number and a.elt_account_number = " & elt_account_number & " And a.carrier_code=b.carrier_code and a.mawb_no=N'"&MAWB&"'"

		rs.CursorLocation = adUseClient
		rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
		Set rs.activeConnection = Nothing

    	
	    If Not rs.EOF Then
			mOrgNum=rs("org_account_number")
			vDepCode=rs("Origin_Port_ID")
			vArrCode =rs("Dest_Port_ID")
			mDepartureAirportCode = rs("Origin_Port_ID")
			mDepartureAirport = rs("Origin_Port_Location")
			mDepartureState=rs("origin_port_state")
			mTo= rs("To")
			mBy = rs("By")
			mTo1= rs("To_1")
			mBy1 = rs("By_1")
			mTo2= rs("To_2")
			mBy2 = rs("By_2")
			mDestAirport = rs("Dest_Port_Location")
			mDestCountry=rs("dest_port_country")
			mFlight1 = rs("Flight#1")
			mFlight2 = rs("Flight#2")
			mETDDate1 = rs("ETD_DATE1")
			mExportDate=mETDDate1
			mETDDate2 = rs("ETD_DATE2")
			mCarrierDesc = rs("Carrier_Desc")			
			if not mFlight1="" then
				if day(mETDDate1) > 9 then
				mFlightDate1=mFlight1 & "/" & day(mETDDate1)
				else
				mFlightDate1=mFlight1 & "/0" & day(mETDDate1)
				end if
			else
				mFlightDate1=""
			end if
			if not mFlight2="" then
			if day(mETDDate2) > 9 then
				mFlightDate2=mFlight2 & "/" & day(mETDDate2)
				else
				mFlightDate2=mFlight2 & "/0" & day(mETDDate2)
				end if
			else
				mFlightDate2=""
			end if
			mFile=rs("file#")
			mServiceLevel = rs("service_level").value
			mawbInfo = mOrgNum & chr(10) & mDepartureAirportCode & chr(10) & mDepartureAirport & chr(10) & mTo & chr(10) & mBy & Chr(10) & mTo1 & chr(10) & mBy1 & chr(10) & mTo2 & chr(10) & mBy2 & chr(10) & mDestAirport & chr(10) & mFlightDate1 & chr(10) & mFlightDate2 & chr(10) & mCarrierDesc & chr(10) & mExportDate & chr(10) & mDestCountry & chr(10) & mDepartureState & chr(10) & mFile & chr(10) & mServiceLevel & chr(10)

		End If
	    rs.close
		set rs=nothing 
%>