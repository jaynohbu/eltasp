<SCRIPT LANGUAGE="vbscript">
<!---
function GetOrgInfo(AgentYes,ShipperYes,ConsigneeYes,VendorYes,NotifyYes,AllYes)
'agent is 0,shipper is 1,consignee is 2,vendor is 3,notify is 4,all is 5
Dim aOrgInfo(5,2)
Dim aAgentInfo(1024,3),aShipperInfo(4096,3),aConsigneeInfo(4096,3),aVendorInfo(1024,3),aNotifyInfo(8192,3),aAllInfo(10000,3)
Set fso = CreateObject("Scripting.FileSystemObject")
Set InFile=fso.OpenTextFile("<%=temp_path%>" & "\EltData\OrgInfo.elt", 1)
DL="#@"
aIndex=0
sIndex=0
cIndex=0
vIndex=0
nIndex=0
allIndex=0
Do While Not InFile.AtEndOfStream
	OrgInfo=InFile.ReadLine
	pos=0
	pos=instr(OrgInfo,DL)
	if pos>0 then
		OrgAcct=Mid(OrgInfo,1,pos-1)
		OrgInfo=Mid(OrgInfo,pos+2,1000)
	end if
	pos=instr(OrgInfo,DL)
	if pos>0 then
		IsAgent=Mid(OrgInfo,1,pos-1)
		OrgInfo=Mid(OrgInfo,pos+2,1000)
	end if
	pos=instr(OrgInfo,DL)
	if pos>0 then
		IsShipper=Mid(OrgInfo,1,pos-1)
		OrgInfo=Mid(OrgInfo,pos+2,1000)
	end if
	pos=instr(OrgInfo,DL)
	if pos>0 then
		IsConsignee=Mid(OrgInfo,1,pos-1)
		OrgInfo=Mid(OrgInfo,pos+2,1000)
	end if
	pos=instr(OrgInfo,DL)
	if pos>0 then
		IsVendor=Mid(OrgInfo,1,pos-1)
		OrgInfo=Mid(OrgInfo,pos+2,1000)
	end if
	pos=instr(OrgInfo,DL)
	if pos>0 then
		OrgName=Mid(OrgInfo,1,pos-1)
		OrgInfo=Mid(OrgInfo,pos+2,1000)
	end if
	pos=instr(OrgInfo,DL)
	if pos>0 then
		OrgAddress=Mid(OrgInfo,1,pos-1)
		OrgInfo=Mid(OrgInfo,pos+2,1000)
	end if
	pos=instr(OrgInfo,DL)
	if pos>0 then
		OrgCity=Mid(OrgInfo,1,pos-1)
		OrgPhone=Mid(OrgInfo,pos+2,1000)
	end if
	if IsAgent="Y" and AgentYes="Y" then
		aAgentInfo(aIndex,1)=OrgName
		aAgentInfo(aIndex,2)=OrgAcct & "-" & OrgName & chr(10) & OrgAddress & chr(10) & OrgCity & chr(10) & OrgPhone
		aAgentInfo(aIndex,3)=OrgAcct
		aIndex=aIndex+1
	end if
	if IsShipper="Y" and ShipperYes="Y" then
		aShipperInfo(sIndex,1)=OrgName
		aShipperInfo(sIndex,2)=OrgAcct & "-" & OrgName & chr(10) & OrgAddress & chr(10) & OrgCity & chr(10) & OrgPhone
		aShipperInfo(sIndex,3)=OrgAcct
		sIndex=sIndex+1
	end if
	if IsConsignee="Y" and ConsigneeYes="Y" then
		aConsigneeInfo(cIndex,1)=OrgName
		aConsigneeInfo(cIndex,2)=OrgAcct & "-" & OrgName & chr(10) & OrgAddress & chr(10) & OrgCity & chr(10) & OrgPhone
		aConsigneeInfo(cIndex,3)=OrgAcct
		cIndex=cIndex+1
	end if
	if IsVendor="Y" and VendorYes="Y" then
		aVendorInfo(vIndex,1)=OrgName
		aVendorInfo(vIndex,2)=OrgAcct & "-" & OrgName & chr(10) & OrgAddress & chr(10) & OrgCity & chr(10) & OrgPhone
		aVendorInfo(vIndex,3)=OrgAcct
		vIndex=vIndex+1
	end if
	if (IsShipper="Y" Or IsConsignee="Y") and NotifyYes="Y" then
		aNotifyInfo(nIndex,1)=OrgName
		aNotifyInfo(nIndex,2)=OrgAcct & "-" & OrgName & chr(10) & OrgAddress & chr(10) & OrgCity & chr(10) & OrgPhone
		aNotifyInfo(nIndex,3)=OrgAcct
		nIndex=nIndex+1
	end if
	if AllYes="Y" then
		aAllInfo(allIndex,1)=OrgName
		aAllInfo(allIndex,2)=OrgAcct & "-" & OrgName & chr(10) & OrgAddress & chr(10) & OrgCity & chr(10) & OrgPhone
		aAllInfo(allIndex,3)=OrgAcct
		allIndex=allIndex+1
	end if
Loop
InFile.Close
Set InFile=Nothing
if AgentYes="Y" then
	aOrgInfo(0,1)=StrSort(aAgentInfo,aIndex)
	aOrgInfo(0,2)=aIndex
end if
if ShipperYes="Y" then
	aOrgInfo(1,1)=StrSort(aShipperInfo,sIndex)
	aOrgInfo(1,2)=sIndex
end if
if ConsigneeYes="Y" then
	aOrgInfo(2,1)=StrSort(aConsigneeInfo,cIndex)
	aOrgInfo(2,2)=cIndex
end if
if VendorYes="Y" then
	aOrgInfo(3,1)=StrSort(aVendorInfo,vIndex)
	aOrgInfo(3,2)=vIndex
end if
if NotifyYes="Y" then
	aOrgInfo(4,1)=StrSort(aNotifyInfo,nIndex)
	aOrgInfo(4,2)=nIndex
end if
if AllYes="Y" then
	aOrgInfo(5,1)=StrSort(aAllInfo,allIndex)
	aOrgInfo(5,2)=allIndex
end if
GetOrgInfo=aOrgInfo
end function

function StrSort(aSort,UB)
Dim intTempStore
Dim i,j,ss
For i=0 To UB-1
   	 For j=i To UB
		ss=strComp(aSort(i,1),aSort(j,1),1)
    	if  ss>0 Then
   	 		temp1=aSort(i,1)
			temp2=aSort(i,2)
			temp3=aSort(i,3)
    		aSort(i,1)=aSort(j,1)
			aSort(i,2)=aSort(j,2)
			aSort(i,3)=aSort(j,3)
    		aSort(j,1)=temp1
			aSort(j,2)=temp2
			aSort(j,3)=temp3
    	End if
    Next
Next
StrSort=aSort
End function
-->
</script>