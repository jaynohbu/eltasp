// FreightEasyNetCtl.cpp : Implementation of the CFreightEasyNetCtrl ActiveX Control class.

#include "stdafx.h"
#include "FreightEasyNet.h"
#include "FreightEasyNetCtl.h"
#include "FreightEasyNetPpg.h"

#include "Iptypes.h"
#include "iphlpapi.h"
#include "shellapi.h"
#pragma comment (lib,"iphlpapi.lib")
#pragma comment (lib,"shell32.lib")

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif


IMPLEMENT_DYNCREATE(CFreightEasyNetCtrl, COleControl)


/////////////////////////////////////////////////////////////////////////////
// Message map

BEGIN_MESSAGE_MAP(CFreightEasyNetCtrl, COleControl)
	//{{AFX_MSG_MAP(CFreightEasyNetCtrl)
	// NOTE - ClassWizard will add and remove message map entries
	//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG_MAP
	ON_OLEVERB(AFX_IDS_VERB_PROPERTIES, OnProperties)
END_MESSAGE_MAP()


/////////////////////////////////////////////////////////////////////////////
// Dispatch map

BEGIN_DISPATCH_MAP(CFreightEasyNetCtrl, COleControl)
	//{{AFX_DISPATCH_MAP(CFreightEasyNetCtrl)
	DISP_PROPERTY_EX(CFreightEasyNetCtrl, "MacAddress", GetMacAddress, SetNotSupported, VT_BSTR)
	DISP_PROPERTY_EX(CFreightEasyNetCtrl, "IPAddress", GetIPAddress, SetNotSupported, VT_BSTR)
	DISP_PROPERTY_EX(CFreightEasyNetCtrl, "HostName", GetHostName, SetNotSupported, VT_BSTR)
	DISP_PROPERTY_EX(CFreightEasyNetCtrl, "DomainName", GetDomainName, SetNotSupported, VT_BSTR)
	DISP_FUNCTION(CFreightEasyNetCtrl, "PrintForm", PrintForm, VT_I2, VTS_BSTR VTS_BSTR VTS_BSTR)
	//}}AFX_DISPATCH_MAP
	DISP_FUNCTION_ID(CFreightEasyNetCtrl, "AboutBox", DISPID_ABOUTBOX, AboutBox, VT_EMPTY, VTS_NONE)
END_DISPATCH_MAP()


/////////////////////////////////////////////////////////////////////////////
// Event map

BEGIN_EVENT_MAP(CFreightEasyNetCtrl, COleControl)
	//{{AFX_EVENT_MAP(CFreightEasyNetCtrl)
	// NOTE - ClassWizard will add and remove event map entries
	//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_EVENT_MAP
END_EVENT_MAP()


/////////////////////////////////////////////////////////////////////////////
// Property pages

// TODO: Add more property pages as needed.  Remember to increase the count!
BEGIN_PROPPAGEIDS(CFreightEasyNetCtrl, 1)
	PROPPAGEID(CFreightEasyNetPropPage::guid)
END_PROPPAGEIDS(CFreightEasyNetCtrl)


/////////////////////////////////////////////////////////////////////////////
// Initialize class factory and guid

IMPLEMENT_OLECREATE_EX(CFreightEasyNetCtrl, "FREIGHTEASYNET.FreightEasyNetCtrl.1",
	0x34fd3126, 0x734c, 0x4f94, 0xb0, 0x6, 0x8e, 0x1b, 0x23, 0xe1, 0x49, 0xc8)


/////////////////////////////////////////////////////////////////////////////
// Type library ID and version

IMPLEMENT_OLETYPELIB(CFreightEasyNetCtrl, _tlid, _wVerMajor, _wVerMinor)


/////////////////////////////////////////////////////////////////////////////
// Interface IDs

const IID BASED_CODE IID_DFreightEasyNet =
		{ 0xe69a8679, 0x82ef, 0x4a8a, { 0x99, 0x32, 0xac, 0xdd, 0x2e, 0x3c, 0x7a, 0x79 } };
const IID BASED_CODE IID_DFreightEasyNetEvents =
		{ 0xff0d076, 0x75b2, 0x4601, { 0xab, 0x4d, 0x6a, 0x7e, 0x43, 0x6d, 0xf5, 0xc } };


/////////////////////////////////////////////////////////////////////////////
// Control type information

static const DWORD BASED_CODE _dwFreightEasyNetOleMisc =
	OLEMISC_INVISIBLEATRUNTIME |
	OLEMISC_ACTIVATEWHENVISIBLE |
	OLEMISC_SETCLIENTSITEFIRST |
	OLEMISC_INSIDEOUT |
	OLEMISC_CANTLINKINSIDE |
	OLEMISC_RECOMPOSEONRESIZE;

IMPLEMENT_OLECTLTYPE(CFreightEasyNetCtrl, IDS_FREIGHTEASYNET, _dwFreightEasyNetOleMisc)


/////////////////////////////////////////////////////////////////////////////
// CFreightEasyNetCtrl::CFreightEasyNetCtrlFactory::UpdateRegistry -
// Adds or removes system registry entries for CFreightEasyNetCtrl

BOOL CFreightEasyNetCtrl::CFreightEasyNetCtrlFactory::UpdateRegistry(BOOL bRegister)
{
	// TODO: Verify that your control follows apartment-model threading rules.
	// Refer to MFC TechNote 64 for more information.
	// If your control does not conform to the apartment-model rules, then
	// you must modify the code below, changing the 6th parameter from
	// afxRegApartmentThreading to 0.

	if (bRegister)
		return AfxOleRegisterControlClass(
			AfxGetInstanceHandle(),
			m_clsid,
			m_lpszProgID,
			IDS_FREIGHTEASYNET,
			IDB_FREIGHTEASYNET,
			afxRegApartmentThreading,
			_dwFreightEasyNetOleMisc,
			_tlid,
			_wVerMajor,
			_wVerMinor);
	else
		return AfxOleUnregisterClass(m_clsid, m_lpszProgID);
}


/////////////////////////////////////////////////////////////////////////////
// CFreightEasyNetCtrl::CFreightEasyNetCtrl - Constructor

CFreightEasyNetCtrl::CFreightEasyNetCtrl()
{
	InitializeIIDs(&IID_DFreightEasyNet, &IID_DFreightEasyNetEvents);

// get address
    PIP_ADAPTER_INFO pAdapterInfo;
    PIP_ADAPTER_INFO pAdapter = NULL;
    DWORD dwRetVal = 0;

    pAdapterInfo = (IP_ADAPTER_INFO *) malloc( sizeof(IP_ADAPTER_INFO) );
    ULONG ulOutBufLen = sizeof(IP_ADAPTER_INFO);

    // Make an initial call to GetAdaptersInfo to get
    // the necessary size into the ulOutBufLen variable
    if (GetAdaptersInfo( pAdapterInfo, &ulOutBufLen) != ERROR_SUCCESS) {
        //GlobalFree (pAdapterInfo);
        free(pAdapterInfo);
        pAdapterInfo = (IP_ADAPTER_INFO *) malloc (ulOutBufLen);
    }

    if ((dwRetVal = GetAdaptersInfo( pAdapterInfo, &ulOutBufLen)) == NO_ERROR) {
        pAdapter = pAdapterInfo;
        while (pAdapter) {
			m_strMacAddress = pAdapter->AdapterName;
			m_strIPAddress  = pAdapter->PrimaryWinsServer.IpAddress.String;
            pAdapter = pAdapter->Next;
        }
    }
    else 
    {
			m_strMacAddress = "failed";
			m_strIPAddress  = "failed";
    }

// get Host Name & Domain Name
	PFIXED_INFO pFixedInfo;
    PFIXED_INFO pFixed = NULL;
	pFixedInfo = (FIXED_INFO *) malloc( sizeof(FIXED_INFO) );
 
    ulOutBufLen = sizeof(FIXED_INFO);
 
    if (GetNetworkParams( pFixedInfo, &ulOutBufLen) != ERROR_SUCCESS) {
        free(pFixedInfo);
        pFixedInfo = (FIXED_INFO *) malloc (ulOutBufLen);
    }
    if ((dwRetVal = GetNetworkParams( pFixedInfo, &ulOutBufLen)) == NO_ERROR) {
        pFixed = pFixedInfo;
		m_strHostName = pFixed->HostName;
		m_strDomainName  = pFixed->DomainName;
	}
    else 
    {
		m_strHostName = "failed";
		m_strDomainName  = "failed";
    } 

}


/////////////////////////////////////////////////////////////////////////////
// CFreightEasyNetCtrl::~CFreightEasyNetCtrl - Destructor

CFreightEasyNetCtrl::~CFreightEasyNetCtrl()
{
	// TODO: Cleanup your control's instance data here.
}


/////////////////////////////////////////////////////////////////////////////
// CFreightEasyNetCtrl::DoPropExchange - Persistence support

void CFreightEasyNetCtrl::DoPropExchange(CPropExchange* pPX)
{
	ExchangeVersion(pPX, MAKELONG(_wVerMinor, _wVerMajor));
	COleControl::DoPropExchange(pPX);

	// TODO: Call PX_ functions for each persistent custom property.

}


/////////////////////////////////////////////////////////////////////////////
// CFreightEasyNetCtrl::OnResetState - Reset control to default state

void CFreightEasyNetCtrl::OnResetState()
{
	COleControl::OnResetState();  // Resets defaults found in DoPropExchange

	// TODO: Reset any other control state here.
}


/////////////////////////////////////////////////////////////////////////////
// CFreightEasyNetCtrl::AboutBox - Display an "About" box to the user

void CFreightEasyNetCtrl::AboutBox()
{
	CDialog dlgAbout(IDD_ABOUTBOX_FREIGHTEASYNET);
	dlgAbout.DoModal();
}


/////////////////////////////////////////////////////////////////////////////
// CFreightEasyNetCtrl message handlers

short CFreightEasyNetCtrl::PrintForm(LPCTSTR FormName, LPCTSTR Port, LPCTSTR OS) 
{
    SHELLEXECUTEINFO ShExecInfo;
    //HINSTANCE hInst;
    // Fill the SHELLEXECUTEINFO array.
    ShExecInfo.cbSize = sizeof(SHELLEXECUTEINFO);
    ShExecInfo.fMask = NULL;
    ShExecInfo.hwnd = NULL;
    ShExecInfo.lpVerb = "print";
    ShExecInfo.lpFile = FormName;  // a fully qualified path
    ShExecInfo.lpParameters = Port;
    ShExecInfo.lpDirectory = NULL;    
    ShExecInfo.nShow = NULL;
    ShExecInfo.hInstApp = NULL;
    if(ShellExecuteEx(&ShExecInfo)) 
	{
		return 0;
	}
	else
	{
		return 1;
	}
}

BSTR CFreightEasyNetCtrl::GetMacAddress() 
{
	return m_strMacAddress.AllocSysString();
}


BSTR CFreightEasyNetCtrl::GetIPAddress() 
{
	return m_strIPAddress.AllocSysString();
}

BSTR CFreightEasyNetCtrl::GetHostName() 
{
	return m_strHostName.AllocSysString();
}

BSTR CFreightEasyNetCtrl::GetDomainName() 
{
	return m_strDomainName.AllocSysString();
}
