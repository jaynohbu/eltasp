// ClientTrackCtrl.cpp : Implementation of the CClientTrackCtrl ActiveX Control class.

#include "stdafx.h"
#include "ClientTrack.h"
#include "ClientTrackCtrl.h"
#include "ClientTrackPropPage.h"
#include <iphlpapi.h>
#include <Windows.h>
#include <Assert.h>

IMPLEMENT_DYNCREATE(CClientTrackCtrl, COleControl)


// Message map

BEGIN_MESSAGE_MAP(CClientTrackCtrl, COleControl)
	ON_OLEVERB(AFX_IDS_VERB_PROPERTIES, OnProperties)
END_MESSAGE_MAP()



// Dispatch map

BEGIN_DISPATCH_MAP(CClientTrackCtrl, COleControl)
	DISP_FUNCTION_ID(CClientTrackCtrl, "AboutBox", DISPID_ABOUTBOX, AboutBox, VT_EMPTY, VTS_NONE)
    DISP_FUNCTION_ID(CClientTrackCtrl, "GetIPAddr", dispidGetIPAddr, GetIPAddr, VT_I1, VTS_NONE)
    DISP_FUNCTION_ID(CClientTrackCtrl, "GetMacAddr", dispidGetMacAddr, GetMacAddr, VT_BSTR, VTS_NONE)
END_DISPATCH_MAP()



// Event map

BEGIN_EVENT_MAP(CClientTrackCtrl, COleControl)
END_EVENT_MAP()



// Property pages

// TODO: Add more property pages as needed.  Remember to increase the count!
BEGIN_PROPPAGEIDS(CClientTrackCtrl, 1)
	PROPPAGEID(CClientTrackPropPage::guid)
END_PROPPAGEIDS(CClientTrackCtrl)



// Initialize class factory and guid

IMPLEMENT_OLECREATE_EX(CClientTrackCtrl, "CLIENTTRACK.ClientTrackCtrl.1",
	0x794834bd, 0x2c77, 0x4d7e, 0x91, 0x89, 0x68, 0xaa, 0x99, 0xdc, 0x42, 0x6b)



// Type library ID and version

IMPLEMENT_OLETYPELIB(CClientTrackCtrl, _tlid, _wVerMajor, _wVerMinor)



// Interface IDs

const IID BASED_CODE IID_DClientTrack =
		{ 0x6376F744, 0xECE3, 0x4B58, { 0x86, 0xE0, 0x7E, 0xFE, 0xD8, 0xF6, 0xDD, 0xD9 } };
const IID BASED_CODE IID_DClientTrackEvents =
		{ 0x657E8F93, 0xBCA3, 0x463C, { 0x98, 0xF6, 0x30, 0x35, 0x90, 0x44, 0xEC, 0xBB } };



// Control type information

static const DWORD BASED_CODE _dwClientTrackOleMisc =
	OLEMISC_ACTIVATEWHENVISIBLE |
	OLEMISC_SETCLIENTSITEFIRST |
	OLEMISC_INSIDEOUT |
	OLEMISC_CANTLINKINSIDE |
	OLEMISC_RECOMPOSEONRESIZE;

IMPLEMENT_OLECTLTYPE(CClientTrackCtrl, IDS_CLIENTTRACK, _dwClientTrackOleMisc)



// CClientTrackCtrl::CClientTrackCtrlFactory::UpdateRegistry -
// Adds or removes system registry entries for CClientTrackCtrl

BOOL CClientTrackCtrl::CClientTrackCtrlFactory::UpdateRegistry(BOOL bRegister)
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
			IDS_CLIENTTRACK,
			IDB_CLIENTTRACK,
			afxRegApartmentThreading,
			_dwClientTrackOleMisc,
			_tlid,
			_wVerMajor,
			_wVerMinor);
	else
		return AfxOleUnregisterClass(m_clsid, m_lpszProgID);
}



// CClientTrackCtrl::CClientTrackCtrl - Constructor

CClientTrackCtrl::CClientTrackCtrl()
{
	InitializeIIDs(&IID_DClientTrack, &IID_DClientTrackEvents);
	// TODO: Initialize your control's instance data here.
}



// CClientTrackCtrl::~CClientTrackCtrl - Destructor

CClientTrackCtrl::~CClientTrackCtrl()
{
	// TODO: Cleanup your control's instance data here.
}



// CClientTrackCtrl::OnDraw - Drawing function

void CClientTrackCtrl::OnDraw(
			CDC* pdc, const CRect& rcBounds, const CRect& rcInvalid)
{
	if (!pdc)
		return;

	// TODO: Replace the following code with your own drawing code.
	pdc->FillRect(rcBounds, CBrush::FromHandle((HBRUSH)GetStockObject(WHITE_BRUSH)));
	pdc->Ellipse(rcBounds);
}



// CClientTrackCtrl::DoPropExchange - Persistence support

void CClientTrackCtrl::DoPropExchange(CPropExchange* pPX)
{
	ExchangeVersion(pPX, MAKELONG(_wVerMinor, _wVerMajor));
	COleControl::DoPropExchange(pPX);

	// TODO: Call PX_ functions for each persistent custom property.
}



// CClientTrackCtrl::OnResetState - Reset control to default state

void CClientTrackCtrl::OnResetState()
{
	COleControl::OnResetState();  // Resets defaults found in DoPropExchange

	// TODO: Reset any other control state here.
}



// CClientTrackCtrl::AboutBox - Display an "About" box to the user

void CClientTrackCtrl::AboutBox()
{
	CDialog dlgAbout(IDD_ABOUTBOX_CLIENTTRACK);
	dlgAbout.DoModal();
}

// CClientTrackCtrl message handlers

static char* GetMACaddress(void)
{
	IP_ADAPTER_INFO AdapterInfo[18];			// Allocate information for up to 16 NICs
	DWORD dwBufLen = sizeof(AdapterInfo);		// Save the memory size of buffer
    unsigned char MACData[8];
    char buffer[200]="";
	DWORD dwStatus = GetAdaptersInfo(			// Call GetAdapterInfo
		AdapterInfo,							// [out] buffer to receive data
		&dwBufLen);								// [in] size of receive data buffer
	assert(dwStatus == ERROR_SUCCESS);			// Verify return value is valid, no buffer overflow

	PIP_ADAPTER_INFO pAdapterInfo = AdapterInfo;// Contains pointer to current adapter info
	if(pAdapterInfo)
    {
        MACData[0]=pAdapterInfo->Address[0];
        MACData[1]=pAdapterInfo->Address[1];
        MACData[2]=pAdapterInfo->Address[2];
        MACData[3]=pAdapterInfo->Address[3];
        MACData[4]=pAdapterInfo->Address[4];
        MACData[5]=pAdapterInfo->Address[5];
        MACData[6]=pAdapterInfo->Address[6];
        MACData[7]=pAdapterInfo->Address[7];

		sprintf_s(buffer, "%02X:%02X:%02X:%02X:%02X:%02X", MACData[0], MACData[1], MACData[2], MACData[3], MACData[4], MACData[5]);
        pAdapterInfo = pAdapterInfo->Next;		// Progress through linked list
	}
    return buffer;
}

BSTR CClientTrackCtrl::GetIPAddr(void)
{
    AFX_MANAGE_STATE(AfxGetStaticModuleState());
    return SysAllocString(L"test");
}

BSTR CClientTrackCtrl::GetMacAddr(void)
{
    AFX_MANAGE_STATE(AfxGetStaticModuleState());

    char* macData = GetMACaddress();
    int len = lstrlenA(macData);
    BSTR bstrResult = SysAllocStringLen(NULL, len);
    ::MultiByteToWideChar(CP_ACP, 0, macData, len, bstrResult, len);
    return bstrResult;

    //return SysAllocString(L"test");
}
