<script language='vbscript'>
Function queryPort( strLocal, strNetwork )

	if strLocal ="" or strNetwork="" then
		
		if NOT strLocal ="" then		
			queryPort = strLocal
			exit function
		end if		
		
		if NOT strNetwork ="" then		
			queryPort = strNetwork
			exit function
		end if		

			queryPort = "LPT1"
			exit function		
	end if

	Dim qS,tmpUrl
	tmpUrl = "l=" & strLocal & "&n=" & strNetwork
	qS = showModalDialog("/IFF_MAIN/ASP/include/query_print_port.asp?"&tmpUrl ,,"dialogWidth:400px; dialogHeight:160px; help:no; status:no; scroll:no;center:yes")
	if qS = "" then qS = -1
	queryPort = qS
End Function

Function queryPort_for_zebra( strLocal, strNetwork )
	Dim qS,tmpUrl
	tmpUrl = "l=" & strLocal & "&n=" & strNetwork
	qS = showModalDialog("../include/ask_label_type.asp?"&tmpUrl ,,"dialogWidth:400px; dialogHeight:220px; help:no; status:no; scroll:no;center:yes")
	if qS = "" then qS = -1
	queryPort_for_zebra = qS
End Function
</script>