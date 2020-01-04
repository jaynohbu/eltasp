Option Strict Off
Option Explicit On
Module modGetMACadr
	
	' Declarations needed for GetAdaptersInfo & GetIfTable
	Private Const MIB_IF_TYPE_OTHER As Integer = 1
	Private Const MIB_IF_TYPE_ETHERNET As Integer = 6
	Private Const MIB_IF_TYPE_TOKENRING As Integer = 9
	Private Const MIB_IF_TYPE_FDDI As Integer = 15
	Private Const MIB_IF_TYPE_PPP As Integer = 23
	Private Const MIB_IF_TYPE_LOOPBACK As Integer = 24
	Private Const MIB_IF_TYPE_SLIP As Integer = 28
	
	Private Const MIB_IF_ADMIN_STATUS_UP As Integer = 1
	Private Const MIB_IF_ADMIN_STATUS_DOWN As Integer = 2
	Private Const MIB_IF_ADMIN_STATUS_TESTING As Integer = 3
	
	Private Const MIB_IF_OPER_STATUS_NON_OPERATIONAL As Integer = 0
	Private Const MIB_IF_OPER_STATUS_UNREACHABLE As Integer = 1
	Private Const MIB_IF_OPER_STATUS_DISCONNECTED As Integer = 2
	Private Const MIB_IF_OPER_STATUS_CONNECTING As Integer = 3
	Private Const MIB_IF_OPER_STATUS_CONNECTED As Integer = 4
	Private Const MIB_IF_OPER_STATUS_OPERATIONAL As Integer = 5
	
	Private Const MAX_ADAPTER_DESCRIPTION_LENGTH As Integer = 128
	Private Const MAX_ADAPTER_DESCRIPTION_LENGTH_p As Integer = MAX_ADAPTER_DESCRIPTION_LENGTH + 4
	Private Const MAX_ADAPTER_NAME_LENGTH As Integer = 256
	Private Const MAX_ADAPTER_NAME_LENGTH_p As Integer = MAX_ADAPTER_NAME_LENGTH + 4
	Private Const MAX_ADAPTER_ADDRESS_LENGTH As Integer = 8
	Private Const DEFAULT_MINIMUM_ENTITIES As Integer = 32
	Private Const MAX_HOSTNAME_LEN As Integer = 128
	Private Const MAX_DOMAIN_NAME_LEN As Integer = 128
	Private Const MAX_SCOPE_ID_LEN As Integer = 256
	
	Private Const MAXLEN_IFDESCR As Integer = 256
	Private Const MAX_INTERFACE_NAME_LEN As Integer = MAXLEN_IFDESCR * 2
	Private Const MAXLEN_PHYSADDR As Integer = 8
	
	' Information structure returned by GetIfEntry/GetIfTable
	Private Structure MIB_IFROW
		<VBFixedArray(MAX_INTERFACE_NAME_LEN - 1)> Dim wszName() As Byte ' MSDN Docs say pointer, but it is WCHAR array
		Dim dwIndex As Integer
		Dim dwType As Integer
		Dim dwMtu As Integer
		Dim dwSpeed As Integer
		Dim dwPhysAddrLen As Integer
		<VBFixedArray(MAXLEN_PHYSADDR - 1)> Dim bPhysAddr() As Byte
		Dim dwAdminStatus As Integer
		Dim dwOperStatus As Integer
		Dim dwLastChange As Integer
		Dim dwInOctets As Integer
		Dim dwInUcastPkts As Integer
		Dim dwInNUcastPkts As Integer
		Dim dwInDiscards As Integer
		Dim dwInErrors As Integer
		Dim dwInUnknownProtos As Integer
		Dim dwOutOctets As Integer
		Dim dwOutUcastPkts As Integer
		Dim dwOutNUcastPkts As Integer
		Dim dwOutDiscards As Integer
		Dim dwOutErrors As Integer
		Dim dwOutQLen As Integer
		Dim dwDescrLen As Integer
		'UPGRADE_WARNING: Fixed-length string size must fit in the buffer. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="3C1E4426-0B80-443E-B943-0627CD55D48B"'
		<VBFixedString(MAXLEN_IFDESCR),System.Runtime.InteropServices.MarshalAs(System.Runtime.InteropServices.UnmanagedType.ByValArray,SizeConst:=MAXLEN_IFDESCR)> Public bDescr() As Char
		
		'UPGRADE_TODO: "Initialize" must be called to initialize instances of this structure. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="B4BFF9E0-8631-45CF-910E-62AB3970F27B"'
		Public Sub Initialize()
			ReDim wszName(MAX_INTERFACE_NAME_LEN - 1)
			ReDim bPhysAddr(MAXLEN_PHYSADDR - 1)
		End Sub
	End Structure
	
	Private Structure TIME_t
		Dim aTime As Integer
	End Structure
	
	Private Structure IP_ADDRESS_STRING
		'UPGRADE_WARNING: Fixed-length string size must fit in the buffer. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="3C1E4426-0B80-443E-B943-0627CD55D48B"'
		<VBFixedString(16),System.Runtime.InteropServices.MarshalAs(System.Runtime.InteropServices.UnmanagedType.ByValArray,SizeConst:=16)> Public IPadrString() As Char
	End Structure
	
	Private Structure IP_ADDR_STRING
		Dim AdrNext As Integer
		Dim IpAddress As IP_ADDRESS_STRING
		Dim IpMask As IP_ADDRESS_STRING
		Dim NTEcontext As Integer
	End Structure
	
	' Information structure returned by GetIfEntry/GetIfTable
	Private Structure IP_ADAPTER_INFO
		'UPGRADE_NOTE: Next was upgraded to Next_Renamed. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
		Dim Next_Renamed As Integer
		Dim ComboIndex As Integer
		'UPGRADE_WARNING: Fixed-length string size must fit in the buffer. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="3C1E4426-0B80-443E-B943-0627CD55D48B"'
		<VBFixedString(MAX_ADAPTER_NAME_LENGTH_p),System.Runtime.InteropServices.MarshalAs(System.Runtime.InteropServices.UnmanagedType.ByValArray,SizeConst:=MAX_ADAPTER_NAME_LENGTH_p)> Public AdapterName() As Char
		'UPGRADE_WARNING: Fixed-length string size must fit in the buffer. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="3C1E4426-0B80-443E-B943-0627CD55D48B"'
		<VBFixedString(MAX_ADAPTER_DESCRIPTION_LENGTH_p),System.Runtime.InteropServices.MarshalAs(System.Runtime.InteropServices.UnmanagedType.ByValArray,SizeConst:=MAX_ADAPTER_DESCRIPTION_LENGTH_p)> Public Description() As Char
		Dim MACadrLength As Integer
		<VBFixedArray(MAX_ADAPTER_ADDRESS_LENGTH - 1)> Dim MACaddress() As Byte
		Dim AdapterIndex As Integer
		Dim AdapterType As Integer ' MSDN Docs say "UInt", but is 4 bytes
		Dim DhcpEnabled As Integer ' MSDN Docs say "UInt", but is 4 bytes
		Dim CurrentIpAddress As Integer
		Dim IpAddressList As IP_ADDR_STRING
		Dim GatewayList As IP_ADDR_STRING
		Dim DhcpServer As IP_ADDR_STRING
		Dim HaveWins As Integer ' MSDN Docs say "Bool", but is 4 bytes
		Dim PrimaryWinsServer As IP_ADDR_STRING
		Dim SecondaryWinsServer As IP_ADDR_STRING
		Dim LeaseObtained As TIME_t
		Dim LeaseExpires As TIME_t
		
		'UPGRADE_TODO: "Initialize" must be called to initialize instances of this structure. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="B4BFF9E0-8631-45CF-910E-62AB3970F27B"'
		Public Sub Initialize()
			ReDim MACaddress(MAX_ADAPTER_ADDRESS_LENGTH - 1)
		End Sub
	End Structure
	
	
	'UPGRADE_ISSUE: Declaring a parameter 'As Any' is not supported. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="FAE78A8D-8978-4FD4-8208-5B7324A8F795"'
	'UPGRADE_ISSUE: Declaring a parameter 'As Any' is not supported. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="FAE78A8D-8978-4FD4-8208-5B7324A8F795"'
	Private Declare Sub CopyMemory Lib "kernel32"  Alias "RtlMoveMemory"(ByRef Destination As Any, ByRef Source As Any, ByVal numbytes As Integer)
	
	'UPGRADE_ISSUE: Declaring a parameter 'As Any' is not supported. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="FAE78A8D-8978-4FD4-8208-5B7324A8F795"'
	Public Declare Function GetAdaptersInfo Lib "iphlpapi.dll" (ByRef pAdapterInfo As Any, ByRef pOutBufLen As Integer) As Integer
	Public Declare Function GetNumberOfInterfaces Lib "iphlpapi.dll" (ByRef pdwNumIf As Integer) As Integer
	'UPGRADE_ISSUE: Declaring a parameter 'As Any' is not supported. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="FAE78A8D-8978-4FD4-8208-5B7324A8F795"'
	Public Declare Function GetIfEntry Lib "iphlpapi.dll" (ByRef pIfRow As Any) As Integer
	'UPGRADE_ISSUE: Declaring a parameter 'As Any' is not supported. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="FAE78A8D-8978-4FD4-8208-5B7324A8F795"'
	Private Declare Function GetIfTable Lib "iphlpapi.dll" (ByRef pIfTable As Any, ByRef pdwSize As Integer, ByVal bOrder As Integer) As Integer
	
	
	'-----------------------------------------------------------------------------------
	' Get the system's MAC address(es) via GetAdaptersInfo API function (IPHLPAPI.DLL)
	'
	' Note: GetAdaptersInfo returns information about physical adapters
	'-----------------------------------------------------------------------------------
	Public Function GetMACs_AdaptInfo() As String
		
		'UPGRADE_WARNING: Arrays in structure AdapInfo may need to be initialized before they can be used. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="814DF224-76BD-4BB4-BFFB-EA359CB9FC48"'
		Dim AdapInfo As IP_ADAPTER_INFO
		Dim bufLen, sts As Integer
		Dim retStr As String
		Dim numStructs, i As Short
		Dim IPinfoBuf() As Byte
		Dim srcPtr As Integer
		
		
		' Get size of buffer to allocate
		'UPGRADE_WARNING: Couldn't resolve default property of object AdapInfo. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
		sts = GetAdaptersInfo(AdapInfo, bufLen)
		If (bufLen = 0) Then Exit Function
		numStructs = bufLen / Len(AdapInfo)
		retStr = numStructs & " Adapter(s):" & vbCrLf
		
		' reserve byte buffer & get it filled with adapter information
		' !!! Don't Redim AdapInfo array of IP_ADAPTER_INFO,
		' !!! because VB doesn't allocate it contiguous (padding/alignment)
		ReDim IPinfoBuf(bufLen - 1)
		sts = GetAdaptersInfo(IPinfoBuf(0), bufLen)
		If (sts <> 0) Then Exit Function
		
		' Copy IP_ADAPTER_INFO slices into UDT structure
		'UPGRADE_ISSUE: VarPtr function is not supported. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="367764E5-F3F8-4E43-AC3E-7FE0B5E074E2"'
		srcPtr = VarPtr(IPinfoBuf(0))
		For i = 0 To numStructs - 1
			If (srcPtr = 0) Then Exit For
			'        CopyMemory AdapInfo, srcPtr, Len(AdapInfo)
			'UPGRADE_WARNING: Couldn't resolve default property of object AdapInfo. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
			CopyMemory(AdapInfo, srcPtr, Len(AdapInfo))
			
			' Extract Ethernet MAC address
			With AdapInfo
				If (.AdapterType = MIB_IF_TYPE_ETHERNET) Then
					retStr = retStr & vbCrLf & "[" & i & "] " & sz2string(.Description) & vbCrLf & vbTab & MAC2String(.MACaddress) & vbCrLf
				End If
			End With
			srcPtr = AdapInfo.Next_Renamed
		Next i
		
		' Return list of MAC address(es)
		GetMACs_AdaptInfo = retStr
		
	End Function
	
	
	'-----------------------------------------------------------------------------------
	' Get the system's MAC address(es) via GetIfTable API function (IPHLPAPI.DLL)
	'
	' Note: GetIfTable returns information also about the virtual loopback adapter
	'-----------------------------------------------------------------------------------
	Public Function GetMACs_IfTable() As String
		
		Dim NumAdapts, nRowSize As Integer
		Dim i As Short
		Dim retStr As String
		'UPGRADE_WARNING: Arrays in structure IfInfo may need to be initialized before they can be used. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="814DF224-76BD-4BB4-BFFB-EA359CB9FC48"'
		Dim IfInfo As MIB_IFROW
		Dim IPinfoBuf() As Byte
		Dim bufLen, sts As Integer
		
		
		' Get # of interfaces defined (sometimes 1 more than GetIfTable)
		sts = GetNumberOfInterfaces(NumAdapts)
		
		' Get size of buffer to allocate
		sts = GetIfTable(0, bufLen, 1)
		If (bufLen = 0) Then Exit Function
		
		' reserve byte buffer & get it filled with adapter information
		ReDim IPinfoBuf(bufLen - 1)
		sts = GetIfTable(IPinfoBuf(0), bufLen, 1)
		If (sts <> 0) Then Exit Function
		
		NumAdapts = IPinfoBuf(0)
		nRowSize = Len(IfInfo)
		retStr = NumAdapts & " Interface(s):" & vbCrLf
		
		For i = 1 To NumAdapts
			' copy one IfRow chunk of byte data into an MIB_IFROW structure
			'UPGRADE_WARNING: Couldn't resolve default property of object IfInfo. Click for more: 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
			Call CopyMemory(IfInfo, IPinfoBuf(4 + (i - 1) * nRowSize), nRowSize)
			
			' Take adapter address if correct type
			With IfInfo
				retStr = retStr & vbCrLf & "[" & i & "] " & Left(.bDescr, .dwDescrLen - 1) & vbCrLf
				If (.dwType = MIB_IF_TYPE_ETHERNET) Then
					retStr = retStr & vbTab & MAC2String(.bPhysAddr) & vbCrLf
				End If
			End With
		Next i
		
		GetMACs_IfTable = retStr
		
	End Function
	
	
	' Convert a byte array containing a MAC address to a hex string
	Private Function MAC2String(ByRef AdrArray() As Byte) As String
		Dim aStr, hexStr As String
		Dim i As Short
		
		For i = 0 To 5
			If (i > UBound(AdrArray)) Then
				hexStr = "00"
			Else
				hexStr = Hex(AdrArray(i))
			End If
			
			If (Len(hexStr) < 2) Then hexStr = "0" & hexStr
			aStr = aStr & hexStr
			If (i < 5) Then aStr = aStr & "-"
		Next i
		
		MAC2String = aStr
		
	End Function
	
	
	' Convert a zero-terminated fixed string to a dynamic VB string
	Private Function sz2string(ByVal szStr As String) As String
		sz2string = Left(szStr, InStr(1, szStr, Chr(0)) - 1)
	End Function
End Module