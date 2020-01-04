// AaaPpg.cpp : Implementation of the CAaaPropPage property page class.

#include "stdafx.h"
#include "aaa.h"
#include "AaaPpg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif


IMPLEMENT_DYNCREATE(CAaaPropPage, COlePropertyPage)


/////////////////////////////////////////////////////////////////////////////
// Message map

BEGIN_MESSAGE_MAP(CAaaPropPage, COlePropertyPage)
	//{{AFX_MSG_MAP(CAaaPropPage)
	// NOTE - ClassWizard will add and remove message map entries
	//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()


/////////////////////////////////////////////////////////////////////////////
// Initialize class factory and guid

IMPLEMENT_OLECREATE_EX(CAaaPropPage, "AAA.AaaPropPage.1",
	0x283b2f4a, 0x938d, 0x4837, 0xbb, 0xc9, 0x26, 0xbc, 0xf7, 0x5e, 0xd6, 0x5)


/////////////////////////////////////////////////////////////////////////////
// CAaaPropPage::CAaaPropPageFactory::UpdateRegistry -
// Adds or removes system registry entries for CAaaPropPage

BOOL CAaaPropPage::CAaaPropPageFactory::UpdateRegistry(BOOL bRegister)
{
	if (bRegister)
		return AfxOleRegisterPropertyPageClass(AfxGetInstanceHandle(),
			m_clsid, IDS_AAA_PPG);
	else
		return AfxOleUnregisterClass(m_clsid, NULL);
}


/////////////////////////////////////////////////////////////////////////////
// CAaaPropPage::CAaaPropPage - Constructor

CAaaPropPage::CAaaPropPage() :
	COlePropertyPage(IDD, IDS_AAA_PPG_CAPTION)
{
	//{{AFX_DATA_INIT(CAaaPropPage)
	// NOTE: ClassWizard will add member initialization here
	//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_DATA_INIT
}


/////////////////////////////////////////////////////////////////////////////
// CAaaPropPage::DoDataExchange - Moves data between page and properties

void CAaaPropPage::DoDataExchange(CDataExchange* pDX)
{
	//{{AFX_DATA_MAP(CAaaPropPage)
	// NOTE: ClassWizard will add DDP, DDX, and DDV calls here
	//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_DATA_MAP
	DDP_PostProcessing(pDX);
}


/////////////////////////////////////////////////////////////////////////////
// CAaaPropPage message handlers
