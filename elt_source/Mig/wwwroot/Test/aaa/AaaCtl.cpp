// AaaCtl.cpp : Implementation of the CAaaCtrl ActiveX Control class.

#include "stdafx.h"
#include "aaa.h"
#include "AaaCtl.h"
#include "AaaPpg.h"


#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif


IMPLEMENT_DYNCREATE(CAaaCtrl, COleControl)


/////////////////////////////////////////////////////////////////////////////
// Message map

BEGIN_MESSAGE_MAP(CAaaCtrl, COleControl)
	//{{AFX_MSG_MAP(CAaaCtrl)
	// NOTE - ClassWizard will add and remove message map entries
	//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG_MAP
	ON_OLEVERB(AFX_IDS_VERB_PROPERTIES, OnProperties)
END_MESSAGE_MAP()


/////////////////////////////////////////////////////////////////////////////
// Dispatch map

BEGIN_DISPATCH_MAP(CAaaCtrl, COleControl)
	//{{AFX_DISPATCH_MAP(CAaaCtrl)
	// NOTE - ClassWizard will add and remove dispatch map entries
	//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_DISPATCH_MAP
END_DISPATCH_MAP()


/////////////////////////////////////////////////////////////////////////////
// Event map

BEGIN_EVENT_MAP(CAaaCtrl, COleControl)
	//{{AFX_EVENT_MAP(CAaaCtrl)
	// NOTE - ClassWizard will add and remove event map entries
	//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_EVENT_MAP
END_EVENT_MAP()


/////////////////////////////////////////////////////////////////////////////
// Property pages

// TODO: Add more property pages as needed.  Remember to increase the count!
BEGIN_PROPPAGEIDS(CAaaCtrl, 1)
	PROPPAGEID(CAaaPropPage::guid)
END_PROPPAGEIDS(CAaaCtrl)


/////////////////////////////////////////////////////////////////////////////
// Initialize class factory and guid

IMPLEMENT_OLECREATE_EX(CAaaCtrl, "AAA.AaaCtrl.1",
	0xbf731253, 0x8017, 0x493f, 0x89, 0x85, 0x4f, 0x12, 0x67, 0x49, 0xb2, 0x33)


/////////////////////////////////////////////////////////////////////////////
// Type library ID and version

IMPLEMENT_OLETYPELIB(CAaaCtrl, _tlid, _wVerMajor, _wVerMinor)


/////////////////////////////////////////////////////////////////////////////
// Interface IDs

const IID BASED_CODE IID_DAaa =
		{ 0x57e70dd8, 0x791a, 0x44cc, { 0x98, 0xf0, 0x27, 0x7e, 0xaa, 0x55, 0xcc, 0x30 } };
const IID BASED_CODE IID_DAaaEvents =
		{ 0x73559503, 0xf1c3, 0x42ce, { 0xbd, 0xef, 0x98, 0xa4, 0x64, 0x6f, 0xaf, 0xcd } };


/////////////////////////////////////////////////////////////////////////////
// Control type information

static const DWORD BASED_CODE _dwAaaOleMisc =
	OLEMISC_INVISIBLEATRUNTIME |
	OLEMISC_SETCLIENTSITEFIRST |
	OLEMISC_INSIDEOUT |
	OLEMISC_CANTLINKINSIDE |
	OLEMISC_RECOMPOSEONRESIZE;

IMPLEMENT_OLECTLTYPE(CAaaCtrl, IDS_AAA, _dwAaaOleMisc)


/////////////////////////////////////////////////////////////////////////////
// CAaaCtrl::CAaaCtrlFactory::UpdateRegistry -
// Adds or removes system registry entries for CAaaCtrl

BOOL CAaaCtrl::CAaaCtrlFactory::UpdateRegistry(BOOL bRegister)
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
			IDS_AAA,
			IDB_AAA,
			afxRegApartmentThreading,
			_dwAaaOleMisc,
			_tlid,
			_wVerMajor,
			_wVerMinor);
	else
		return AfxOleUnregisterClass(m_clsid, m_lpszProgID);
}


/////////////////////////////////////////////////////////////////////////////
// CAaaCtrl::CAaaCtrl - Constructor

CAaaCtrl::CAaaCtrl()
{
	InitializeIIDs(&IID_DAaa, &IID_DAaaEvents);

	// TODO: Initialize your control's instance data here.
}


/////////////////////////////////////////////////////////////////////////////
// CAaaCtrl::~CAaaCtrl - Destructor

CAaaCtrl::~CAaaCtrl()
{
	// TODO: Cleanup your control's instance data here.
}


/////////////////////////////////////////////////////////////////////////////
// CAaaCtrl::OnDraw - Drawing function

void CAaaCtrl::OnDraw(
			CDC* pdc, const CRect& rcBounds, const CRect& rcInvalid)
{
	// TODO: Replace the following code with your own drawing code.
	pdc->FillRect(rcBounds, CBrush::FromHandle((HBRUSH)GetStockObject(WHITE_BRUSH)));
	pdc->Ellipse(rcBounds);
}


/////////////////////////////////////////////////////////////////////////////
// CAaaCtrl::DoPropExchange - Persistence support

void CAaaCtrl::DoPropExchange(CPropExchange* pPX)
{
	ExchangeVersion(pPX, MAKELONG(_wVerMinor, _wVerMajor));
	COleControl::DoPropExchange(pPX);

	// TODO: Call PX_ functions for each persistent custom property.

}


/////////////////////////////////////////////////////////////////////////////
// CAaaCtrl::OnResetState - Reset control to default state

void CAaaCtrl::OnResetState()
{
	COleControl::OnResetState();  // Resets defaults found in DoPropExchange

	// TODO: Reset any other control state here.
}


/////////////////////////////////////////////////////////////////////////////
// CAaaCtrl message handlers
