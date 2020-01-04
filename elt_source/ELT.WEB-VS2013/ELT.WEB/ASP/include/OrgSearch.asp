<SCRIPT LANGUAGE="vbscript">
<!---
sub SearchOrg(OrgType,obj,sobj)  ' never user
'Dim aOrgInfo(512,3),FinalOrgInfo(1,2)
SearchStr=document.all(sobj).value
if Not SearchStr="" then
	Set fso = CreateObject("Scripting.FileSystemObject")
	Set InFile=fso.OpenTextFile( "C:\TEMP\EltData\AllOrgInfo.elt", 1)

	DL="#@"
	tIndex=1
	document.all(obj).length=1
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
			IsConsignee=Mid(OrgInfo,1,pos-1)
			OrgInfo=Mid(OrgInfo,pos+2,1000)
		end if
		pos=instr(OrgInfo,DL)
		if pos>0 then
			IsShipper=Mid(OrgInfo,1,pos-1)
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
		pos=instr(UCase(OrgName),UCase(SearchStr))
		if pos>0 then
			'aOrgInfo(tIndex,1)=OrgName
			'aOrgInfo(tIndex,2)=OrgAcct & "-" & OrgName & chr(10) & OrgAddress & chr(10) & OrgCity & chr(10) & OrgPhone
			'aOrgInfo(tIndex,3)=OrgAcct
			'tIndex=tIndex+1
			if OrgType="All" Or (OrgType="Agent" And IsAgent="Y") Or (OrgType="Consignee" And IsConsignee="Y") Or (OrgType="Shipper" And IsShipper="Y") Or (OrgType="Notify" And (IsConsignee="Y" or IsShipper="Y")) Or (OrgType="Vendor" And IsVendor="Y") then
				set newOption=document.createElement("OPTION")
				newOption.text=OrgName
				if OrgType="Vendor" then
					newOption.Value=OrgAcct
				else
					newOption.Value=OrgAcct & "-" & OrgName & chr(10) & OrgAddress & chr(10) & OrgCity & chr(10) & OrgPhone
				end if
				if Not newOption.text="" then
					document.all(obj).add newOption,tIndex
					tIndex=tIndex+1
				end if
			end if
		end if
	Loop
	InFile.Close
	Set InFile=Nothing
	Set fso=Nothing
end if
'FinalOrgInfo(0,1)=aOrgInfo
'FinalOrgInfo(0,2)=tIndex
'SearchOrg=FinalOrgInfo
end sub


-->
</script>