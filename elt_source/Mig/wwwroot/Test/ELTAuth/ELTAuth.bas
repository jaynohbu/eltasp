Attribute VB_Name = "ELTAuthModule"
Option Explicit

' Declarations needed for GetAdaptersInfo & GetIfTable
Private Const MIB_IF_TYPE_OTHER                   As Long = 1
Private Const MIB_IF_TYPE_ETHERNET                As Long = 6
Private Const MIB_IF_TYPE_TOKENRING               As Long = 9
Private Const MIB_IF_TYPE_FDDI                    As Long = 15
Private Const MIB_IF_TYPE_PPP                     As Long = 23
Private Const MIB_IF_TYPE_LOOPBACK                As Long = 24
Private Const MIB_IF_TYPE_SLIP                    As Long = 28

Private Const MIB_IF_ADMIN_STATUS_UP              As Long = 1
Private Const MIB_IF_ADMIN_STATUS_DOWN            As Long = 2
Private Const MIB_IF_ADMIN_STATUS_TESTING         As Long = 3

Private Const MIB_IF_OPER_STATUS_NON_OPERATIONAL  As Long = 0
Private Const MIB_IF_OPER_STATUS_UNREACHABLE      As Long = 1
Private Const MIB_IF_OPER_STATUS_DISCONNECTED     As Long = 2
Private Const MIB_IF_OPER_STATUS_CONNECTING       As Long = 3
Private Const MIB_IF_OPER_STATUS_CONNECTED        As Long = 4
Private Const MIB_IF_OPER_STATUS_OPERATIONAL      As Long = 5

Private Const MAX_ADAPTER_DESCRIPTION_LENGTH      As Long = 128
Private Const MAX_ADAPTER_DESCRIPTION_LENGTH_p    As Long = MAX_ADAPTER_DESCRIPTION_LENGTH + 4
Private Const MAX_ADAPTER_NAME_LENGTH             As Long = 256
Private Const MAX_ADAPTER_NAME_LENGTH_p           As Long = MAX_ADAPTER_NAME_LENGTH + 4
Private Const MAX_ADAPTER_ADDRESS_LENGTH          As Long = 8
Private Const DEFAULT_MINIMUM_ENTITIES            As Long = 32
Private Const MAX_HOSTNAME_LEN                    As Long = 128
Private Const MAX_DOMAIN_NAME_LEN                 As Long = 128
Private Const MAX_SCOPE_ID_LEN                    As Long = 256

Private Const MAXLEN_IFDESCR                      As Long = 256
Private Const MAX_INTERFACE_NAME_LEN              As Long = MAXLEN_IFDESCR * 2
Private Const MAXLEN_PHYSADDR                     As Long = 8

' Information structure returned by GetIfEntry/GetIfTable
Private Type MIB_IFROW
    wszName(0 To MAX_INTERFACE_NAME_LEN - 1) As Byte    ' MSDN Docs say pointer, but it is WCHAR array
    dwIndex             As Long
    dwType              As Long
    dwMtu               As Long
    dwSpeed             As Long
    dwPhysAddrLen       As Long
    bPhysAddr(MAXLEN_PHYSADDR - 1) As Byte
    dwAdminStatus       As Long
    dwOperStatus        As Long
    dwLastChange        As Long
    dwInOctets          As Long
    dwInUcastPkts       As Long
    dwInNUcastPkts      As Long
    dwInDiscards        As Long
    dwInErrors          As Long
    dwInUnknownProtos   As Long
    dwOutOctets         As Long
    dwOutUcastPkts      As Long
    dwOutNUcastPkts     As Long
    dwOutDiscards       As Long
    dwOutErrors         As Long
    dwOutQLen           As Long
    dwDescrLen          As Long
    bDescr As String * MAXLEN_IFDESCR
End Type

Private Type TIME_t
    aTime As Long
End Type

Private Type IP_ADDRESS_STRING
    IPadrString     As String * 16
End Type

Private Type IP_ADDR_STRING
    AdrNext         As Long
    IPAddress       As IP_ADDRESS_STRING
    IpMask          As IP_ADDRESS_STRING
    NTEcontext      As Long
End Type

' Information structure returned by GetIfEntry/GetIfTable
Private Type IP_ADAPTER_INFO
    Next As Long
    ComboIndex As Long
    AdapterName         As String * MAX_ADAPTER_NAME_LENGTH_p
    Description         As String * MAX_ADAPTER_DESCRIPTION_LENGTH_p
    MACadrLength        As Long
    MacAddress(0 To MAX_ADAPTER_ADDRESS_LENGTH - 1) As Byte
    AdapterIndex        As Long
    AdapterType         As Long             ' MSDN Docs say "UInt", but is 4 bytes
    DhcpEnabled         As Long             ' MSDN Docs say "UInt", but is 4 bytes
    CurrentIpAddress    As Long
    IpAddressList       As IP_ADDR_STRING
    GatewayList         As IP_ADDR_STRING
    DhcpServer          As IP_ADDR_STRING
    HaveWins            As Long             ' MSDN Docs say "Bool", but is 4 bytes
    PrimaryWinsServer   As IP_ADDR_STRING
    SecondaryWinsServer As IP_ADDR_STRING
    LeaseObtained       As TIME_t
    LeaseExpires        As TIME_t
End Type

Private Type SERVER_INFO_101
    dw_platform_id As Long
    ptr_name As Long
    dw_ver_major As Long
    dw_ver_minor As Long
    dw_type As Long
    ptr_comment As Long
End Type

Private Type OSVERSIONINFO
        dwOSVersionInfoSize As Long
        dwMajorVersion As Long
        dwMinorVersion As Long
        dwBuildNumber As Long
        dwPlatformId As Long
        szCSDVersion As String * 128
End Type

Private Type WKSTA_INFO_101
   wki101_platform_id As Long
   wki101_computername As Long
   wki101_langroup As Long
   wki101_ver_major As Long
   wki101_ver_minor As Long
   wki101_lanroot As Long
End Type

Private Type WKSTA_USER_INFO_1
   wkui1_username As Long
   wkui1_logon_domain As Long
   wkui1_logon_server As Long
   wkui1_oth_domains As Long
End Type
     
     
Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (ByRef Destination As Any, ByRef Source As Any, ByVal numbytes As Long)
Public Declare Function GetAdaptersInfo Lib "iphlpapi.dll" (ByRef pAdapterInfo As Any, ByRef pOutBufLen As Long) As Long
Public Declare Function GetNumberOfInterfaces Lib "iphlpapi.dll" (ByRef pdwNumIf As Long) As Long
Public Declare Function GetIfEntry Lib "iphlpapi.dll" (ByRef pIfRow As Any) As Long
Private Declare Function GetIfTable Lib "iphlpapi.dll" (ByRef pIfTable As Any, ByRef pdwSize As Long, ByVal bOrder As Long) As Long
Private Declare Function ShellExecute Lib "shell32.dll" Alias "ShellExecuteA" (ByVal hwnd As Long, ByVal lpszOp As String, ByVal lpszFile As String, ByVal lpszParams As String, ByVal lpszDir As String, ByVal FsShowCmd As Long) As Long

Private Declare Function NetServerEnum Lib "Netapi32.dll" (vServername As Any, ByVal lLevel As Long, vBufptr As Any, lPrefmaxlen As Long, lEntriesRead As Long, lTotalEntries As Long, vServerType As Any, ByVal sDomain As String, vResumeHandle As Any) As Long
Private Declare Sub RtlMoveMemory Lib "kernel32" (dest As Any, vSrc As Any, ByVal lSize As Long)
Private Declare Sub lstrcpyW Lib "kernel32" (vDest As Any, ByVal sSrc As Any)
Private Declare Function NetApiBufferFree Lib "Netapi32.dll" (ByVal lpBuffer As Long) As Long

Private Declare Function GetVersionEx Lib "kernel32" Alias "GetVersionExA" (lpVersionInformation As OSVERSIONINFO) As Long
Private Const VER_PLATFORM_WIN32_NT = 2
Private Const VER_PLATFORM_WIN32_WINDOWS = 1
Private Const VER_PLATFORM_WIN32s = 0
Private Declare Function NetWkstaGetInfo Lib "Netapi32" (strServer As Any, ByVal lLevel As Long, pbBuffer As Any) As Long
Private Declare Function NetWkstaUserGetInfo Lib "Netapi32" (reserved As Any, ByVal lLevel As Long, pbBuffer As Any) As Long

Private Declare Function SysComputerName Lib "kernel32" Alias "GetComputerNameA" (ByVal lpBuffer As String, nSize As Long) As Long
Private Declare Function SysUserName Lib "advapi32.dll" Alias "GetUserNameA" (ByVal lpBuffer As String, nSize As Long) As Long

Private Const SV_TYPE_SQLSERVER = &H4

'-----------------------------------------------------------------------------------
' Get the system's MAC address(es) via GetAdaptersInfo API function (IPHLPAPI.DLL)
'
' Note: GetAdaptersInfo returns information about physical adapters
'-----------------------------------------------------------------------------------
Public Function GetMACs_AdaptInfo() As String

    Dim AdapInfo As IP_ADAPTER_INFO, bufLen As Long, sts As Long
    Dim retStr As String, numStructs%, i%, IPinfoBuf() As Byte, srcPtr As Long
    
    
    ' Get size of buffer to allocate
    sts = GetAdaptersInfo(AdapInfo, bufLen)
    If (bufLen = 0) Then Exit Function
    numStructs = bufLen / Len(AdapInfo)
    retStr = numStructs & " Adapter(s):" & vbCrLf
    
    ' reserve byte buffer & get it filled with adapter information
    ' !!! Don't Redim AdapInfo array of IP_ADAPTER_INFO,
    ' !!! because VB doesn't allocate it contiguous (padding/alignment)
    ReDim IPinfoBuf(0 To bufLen - 1) As Byte
    sts = GetAdaptersInfo(IPinfoBuf(0), bufLen)
    If (sts <> 0) Then Exit Function
    
    ' Copy IP_ADAPTER_INFO slices into UDT structure
    srcPtr = VarPtr(IPinfoBuf(0))
    For i = 0 To numStructs - 1
        If (srcPtr = 0) Then Exit For
'        CopyMemory AdapInfo, srcPtr, Len(AdapInfo)
        CopyMemory AdapInfo, ByVal srcPtr, Len(AdapInfo)
        
        ' Extract Ethernet MAC address
        With AdapInfo
            If (.AdapterType = MIB_IF_TYPE_ETHERNET) Then
                retStr = retStr & vbCrLf & "[" & i & "] " & sz2string(.Description) _
                        & vbCrLf & vbTab & MAC2String(.MacAddress) & vbCrLf
            End If
        End With
        srcPtr = AdapInfo.Next
    Next i
    
    ' Return list of MAC address(es)
    GetMACs_AdaptInfo = retStr
    
End Function



Public Function GetMAC_Address() As String

    Dim AdapInfo As IP_ADAPTER_INFO, bufLen As Long, sts As Long
    Dim retStr As String, numStructs%, i%, IPinfoBuf() As Byte, srcPtr As Long
    
    
    ' Get size of buffer to allocate
    sts = GetAdaptersInfo(AdapInfo, bufLen)
    If (bufLen = 0) Then Exit Function
    numStructs = bufLen / Len(AdapInfo)
    retStr = numStructs & " Adapter(s):" & vbCrLf
    
    ' reserve byte buffer & get it filled with adapter information
    ' !!! Don't Redim AdapInfo array of IP_ADAPTER_INFO,
    ' !!! because VB doesn't allocate it contiguous (padding/alignment)
    ReDim IPinfoBuf(0 To bufLen - 1) As Byte
    sts = GetAdaptersInfo(IPinfoBuf(0), bufLen)
    If (sts <> 0) Then Exit Function
    
    ' Copy IP_ADAPTER_INFO slices into UDT structure
    srcPtr = VarPtr(IPinfoBuf(0))
    For i = 0 To numStructs - 1
        If (srcPtr = 0) Then Exit For
'        CopyMemory AdapInfo, srcPtr, Len(AdapInfo)
        CopyMemory AdapInfo, ByVal srcPtr, Len(AdapInfo)
        
        ' Extract Ethernet MAC address
        With AdapInfo
            If (.AdapterType = MIB_IF_TYPE_ETHERNET) Then
                retStr = MAC2String(.MacAddress)
            End If
        End With
        If (retStr <> "") Then Exit For
        srcPtr = AdapInfo.Next
    Next i
    
    ' Return list of MAC address(es)
    GetMAC_Address = retStr
    
End Function
'-----------------------------------------------------------------------------------
' Get the system's MAC address(es) via GetIfTable API function (IPHLPAPI.DLL)
'
' Note: GetIfTable returns information also about the virtual loopback adapter
'-----------------------------------------------------------------------------------
Public Function GetMACs_IfTable() As String
    
    Dim NumAdapts As Long, nRowSize As Long, i%, retStr As String
    Dim IfInfo As MIB_IFROW, IPinfoBuf() As Byte, bufLen As Long, sts As Long
    
    
    ' Get # of interfaces defined (sometimes 1 more than GetIfTable)
    sts = GetNumberOfInterfaces(NumAdapts)
    
    ' Get size of buffer to allocate
    sts = GetIfTable(ByVal 0&, bufLen, 1)
    If (bufLen = 0) Then Exit Function

    ' reserve byte buffer & get it filled with adapter information
    ReDim IPinfoBuf(0 To bufLen - 1) As Byte
    sts = GetIfTable(IPinfoBuf(0), bufLen, 1)
    If (sts <> 0) Then Exit Function
    
    NumAdapts = IPinfoBuf(0)
    nRowSize = Len(IfInfo)
    retStr = NumAdapts & " Interface(s):" & vbCrLf

    For i = 1 To NumAdapts
        ' copy one IfRow chunk of byte data into an MIB_IFROW structure
        Call CopyMemory(IfInfo, IPinfoBuf(4 + (i - 1) * nRowSize), nRowSize)
        
        ' Take adapter address if correct type
        With IfInfo
            retStr = retStr & vbCrLf & "[" & i & "] " & Left$(.bDescr, .dwDescrLen - 1) & vbCrLf
            If (.dwType = MIB_IF_TYPE_ETHERNET) Then
                retStr = retStr & vbTab & MAC2String(.bPhysAddr) & vbCrLf
            End If
        End With
    Next i

    GetMACs_IfTable = retStr
    
End Function

Public Function GetIP_Address() As String
    
    Dim AdapInfo As IP_ADAPTER_INFO, bufLen As Long, sts As Long
    Dim retStr As String, numStructs%, i%, IPinfoBuf() As Byte, srcPtr As Long
    
    
    ' Get size of buffer to allocate
    sts = GetAdaptersInfo(AdapInfo, bufLen)
    If (bufLen = 0) Then Exit Function
    numStructs = bufLen / Len(AdapInfo)
    retStr = numStructs & " Adapter(s):" & vbCrLf
    
    ' reserve byte buffer & get it filled with adapter information
    ' !!! Don't Redim AdapInfo array of IP_ADAPTER_INFO,
    ' !!! because VB doesn't allocate it contiguous (padding/alignment)
    ReDim IPinfoBuf(0 To bufLen - 1) As Byte
    sts = GetAdaptersInfo(IPinfoBuf(0), bufLen)
    If (sts <> 0) Then Exit Function
    
    ' Copy IP_ADAPTER_INFO slices into UDT structure
    srcPtr = VarPtr(IPinfoBuf(0))
    For i = 0 To numStructs - 1
        If (srcPtr = 0) Then Exit For
        CopyMemory AdapInfo, ByVal srcPtr, Len(AdapInfo)
        With AdapInfo
            retStr = .IpAddressList.IPAddress.IPadrString
        End With
        If Len(retStr) > 10 And Left$(retStr, 7) <> "0.0.0.0" Then
           Exit For
        End If
        srcPtr = AdapInfo.Next
    Next i
    
    GetIP_Address = retStr
    
End Function

' Convert a byte array containing a MAC address to a hex string
Private Function MAC2String(AdrArray() As Byte) As String
    Dim aStr As String, hexStr As String, i%
    
    For i = 0 To 5
        If (i > UBound(AdrArray)) Then
            hexStr = "00"
        Else
            hexStr = Hex$(AdrArray(i))
        End If
        
        If (Len(hexStr) < 2) Then hexStr = "0" & hexStr
        aStr = aStr & hexStr
        If (i < 5) Then aStr = aStr & "-"
    Next i
    
    MAC2String = aStr
    
End Function


' Convert a zero-terminated fixed string to a dynamic VB string
Private Function sz2string(ByVal szStr As String) As String
    sz2string = Left$(szStr, InStr(1, szStr, Chr$(0)) - 1)
End Function



Private Function TrimNull(item As String)

    Dim pos As Integer
   
   'double check that there is a chr$(0) in the string
    pos = InStr(item, Chr$(0))
    If pos Then
       TrimNull = Left$(item, pos - 1)
    Else
       TrimNull = item
    End If
  
End Function


Public Function GetDomainName(strType As String)
    Dim lngRet As Long
    Dim arrByteBuffer(512) As Byte
    Dim i As Integer
    Dim tWK_INFO As WKSTA_INFO_101
    Dim lngWK_Ptr As Long
    Dim tWK_USER As WKSTA_USER_INFO_1
    Dim lngWK_USER_Ptr As Long
   
    Dim strDomain As String

    If IfWinNT Then
        
        lngRet = NetWkstaGetInfo(ByVal 0&, 101, lngWK_Ptr)
        RtlMoveMemory tWK_INFO, ByVal tWK_INFO, Len(tWK_INFO)
        
        lngRet = NetWkstaUserGetInfo(ByVal 0&, 1, lngWK_USER_Ptr)
        RtlMoveMemory tWK_USER, ByVal lngWK_USER_Ptr, Len(tWK_USER)
        
        If (strType = "USER") Then
            lstrcpyW arrByteBuffer(0), tWK_USER.wkui1_username
        ElseIf (strType = "SERVER") Then
            lstrcpyW arrByteBuffer(0), tWK_USER.wkui1_logon_server
        ElseIf (strType = "OTHER") Then
            lstrcpyW arrByteBuffer(0), tWK_USER.wkui1_oth_domains
        Else
            lstrcpyW arrByteBuffer(0), tWK_USER.wkui1_logon_domain
        End If
        'Get Every other byte of the array
        i = 0
        Do While arrByteBuffer(i) <> 0
            strDomain = strDomain & Chr(arrByteBuffer(i))
            i = i + 2
        Loop
        lngRet = NetApiBufferFree(lngWK_USER_Ptr)

        GetDomainName = strDomain

    Else
        GetDomainName = ""
    End If
End Function


Private Function IfWinNT() As Boolean
    Dim os As OSVERSIONINFO
    Dim lngRet As Long
    
    os.dwOSVersionInfoSize = Len(os)
    lngRet = GetVersionEx(os)
    
    If lngRet <> 0 Then
        Select Case os.dwPlatformId
            Case VER_PLATFORM_WIN32_NT
                IfWinNT = True
            Case Else
                IfWinNT = False
        End Select
    End If
End Function

Public Function GetComputerName() As String
  Dim sBuffer As String
  
  Dim lAns As Long
 
  sBuffer = Space$(255)
  lAns = SysComputerName(sBuffer, 255)
  If lAns <> 0 Then
        'read from beginning of string to null-terminator
        GetComputerName = Left$(sBuffer, InStr(sBuffer, Chr(0)) - 1)
   Else
        Err.Raise Err.LastDllError, , _
          "A system call returned an error code of " _
           & Err.LastDllError
   End If

End Function

Public Function GetUserName() As String
  Dim sBuffer As String
  
  Dim lAns As Long
 
  sBuffer = Space$(255)
  lAns = SysUserName(sBuffer, 255)
  If lAns <> 0 Then
        'read from beginning of string to null-terminator
        GetUserName = Left$(sBuffer, InStr(sBuffer, Chr(0)) - 1)
   Else
        Err.Raise Err.LastDllError, , _
          "A system call returned an error code of " _
           & Err.LastDllError
   End If

End Function

Public Sub sysPrintForm(strFileName As String, strPortName As String)
    If IfWinNT Then
        'MsgBox "print " & strPortName & " " & strFileName
        Shell ("print /D:" & strPortName & " " & strFileName)
    Else
        'MsgBox "command.com /c copy " & strFileName & " " & strPortName
        Shell ("command.com /c copy " & strFileName & " " & strPortName)
    End If
End Sub

Private Sub ELT_Execute(ByVal cmd As String)
    Shell (cmd)
End Sub

