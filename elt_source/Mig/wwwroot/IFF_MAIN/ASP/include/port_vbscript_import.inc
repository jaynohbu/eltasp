Dim dPortCode 
Dim aPortCode 
Dim PortCode

Sub doDepPortChange(obj)
 	dPortCode=obj.options(obj.options.selectedIndex).text
 	document.form1.hDepText.Value=dPortCode
End Sub

Sub doArrPortChange(obj)
    aPortCode=obj.options(obj.options.selectedIndex).text
    document.form1.hArrText.Value=aPortCode
End Sub

Sub lstMAWBChange_air(name)   
dim aVal
	aVal=split(document.getElementById(name).Value,"^")

    document.getElementById("txtRefNo").Value=aVal(0)
	document.getElementById("txtVessel").Value=aVal(1)
	
	document.getElementById("txtCargoLocation").Value=aVal(2)
	document.getElementById("txtETD").Value=aVal(3)
	document.getElementById("txtETA").Value=aVal(4)	

	document.getElementById("hDepText").Value=aVal(5)	
	document.getElementById("hArrText").Value=aVal(6)		

	document.getElementById("hAgentOrgAcct").Value=aVal(9)
	document.getElementById("hSec").Value=aVal(10)		
	aVal(11) = replace(aVal(11),"Select One","")	
	document.getElementById("txtITEntryPort").Value=aVal(11)
	document.getElementById("txtITNumber").Value=aVal(12)
	document.getElementById("txtITDate").Value=aVal(13)
	document.getElementById("txtFreeDate").Value=aVal(14)
	document.getElementById("hAirline").Value=aVal(15)

	call setSelect("lstDepPort", aVal(7) )
	call setSelect("lstArrPort", aVal(8) )

End Sub 

Sub lstMAWBChange_ocean(name)   

	Dim aVal
	aVal=split(document.getElementById(name).Value,"^")
	//msgbox document.getElementById(name).Value
	document.getElementById("txtRefNo").Value=aVal(0)
	document.getElementById("txtVessel").Value=aVal(1)
	//msgbox aVal(1)
	document.getElementById("txtITEntryPort").Value=aVal(2)
	document.getElementById("txtITNumber").Value=aVal(3)
	document.getElementById("txtITDate").Value=aVal(4)
	document.getElementById("txtFreeDate").Value=aVal(5)
	document.getElementById("txtVoyageNo").Value=aVal(6)
	document.getElementById("txtSubMAWB").Value=aVal(7)
	document.getElementById("txtCargoLocation").Value=aVal(8)
	document.getElementById("txtETD").Value=aVal(9)
	document.getElementById("txtETA").Value=aVal(10)
	aVal(11) = replace(aVal(11),"Select One","")	

	document.getElementById("hDepText").Value=aVal(11)
	document.getElementById("hArrText").Value=aVal(12)
	
	document.getElementById("hAgentOrgAcct").Value=aVal(15)
	document.getElementById("hSec").Value=aVal(16)

	call setSelect("lstDepPort", aVal(13) )
	call setSelect("lstArrPort", aVal(14) )

End Sub 