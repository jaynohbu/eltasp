<%
FromDate=Request("txtFromDate")
			if FromDate="" then FromDate=Month(Date) & "/1/" & Year(Date)

vYear1=Year(FromDate)
vMonth1=Month(FromDate)
vDay1=Day(FromDate)

ToDate=Request("txtToDate")
			if ToDate="" then ToDate=Date

ToDate=CDate(ToDate)
vYear2=Year(ToDate)
vMonth2=Month(ToDate)
vDay2=Day(ToDate)
vDates=Request("lstDates")

			if vDates="" then vDates="Month to Date"

			if vDates="Today" then
				FromDate=Date
				ToDate=Date
			elseif vDates="Month to Date" then
				FromDate=cDate(Month(Date) & "/01/" & Year(Date))
				ToDate=Date
			elseif vDates="Quarter to Date" then
				tq=Month(Date)
				if tq>=1 and tq<=3 then
					FromDate=cDate("01/01/" & Year(Date))
				elseif tq>=4 and tq<=6 then
					FromDate=cDate("04/01/" & Year(Date))
				elseif tq>=7 and tq<=9 then
					FromDate=cDate("07/01/" & Year(Date))
				else 
					FromDate=cDate("10/01/" & Year(Date))
				end if
				ToDate=Date
			elseif vDates="Year to Date" then
				FromDate=cDate("01/01/" & Year(Date))
				ToDate=Date
			elseif vDates="This Month" then
				FromDate=cDate(Month(Date) & "/01/" & Year(Date))
				ToDate=cDate(Month(Date)+1 & "/01/" & Year(Date))-1
			elseif vDates="This Quarter" then
				tq=Month(Date)
				if tq>=1 and tq<=3 then
					FromDate=cDate("01/01/" & Year(Date))
					ToDate=cDate("03/31/" & Year(Date))
				elseif tq>=4 and tq<=6 then
					FromDate=cDate("04/01/" & Year(Date))
					ToDate=cDate("06/30/" & Year(Date))
				elseif tq>=7 and tq<=9 then
					FromDate=cDate("07/01/" & Year(Date))
					ToDate=cDate("09/30/" & Year(Date))
				else 
					FromDate=cDate("10/01/" & Year(Date))
					ToDate=cDate("12/31/" & Year(Date))
				end if
			elseif vDates="This Year" then
				FromDate=cDate("01/01/" & Year(Date))
				ToDate=cDate("12/31/" & Year(Date))
			elseif vDates="Last Month" then
				FromDate=cDate(Month(Date)-1 & "/01/" & Year(Date))
				ToDate=cDate(Month(Date) & "/01/" & Year(Date))-1
			elseif vDates="Last Quarter" then
				tq=Month(Date)
				if tq>=1 and tq<=3 then
					FromDate=cDate("10/01/" & Year(Date)-1)
					ToDate=cDate("12/31/" & Year(Date)-1)
				elseif tq>=4 and tq<=6 then
					FromDate=cDate("01/01/" & Year(Date))
					ToDate=cDate("03/31/" & Year(Date))
				elseif tq>=7 and tq<=9 then
					FromDate=cDate("04/01/" & Year(Date))
					ToDate=cDate("06/30/" & Year(Date))
				else 
					FromDate=cDate("07/01/" & Year(Date))
					ToDate=cDate("09/30/" & Year(Date))
				end if
			elseif vDates="Last Year" then
				FromDate=cDate("01/01/" & Year(Date)-1)
				ToDate=cDate("12/31/" & Year(Date)-1)
			else
			end if

%>