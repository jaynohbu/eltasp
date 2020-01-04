// FreightEasyNetPpg.cpp : Implementation of the CFreightEasyNetPropPage property page class.

#include "stdafx.h"
#include "FreightEasyNet.h"
#include "FreightEasyNetPpg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif


IMPLEMENT_DYNCREATE(CFreightEasyNetPropPage, COlePropertyPage)


/////////////////////////////////////////////////////////////////////////////
// Message map

BEGIN_MESSAGE_MAP(CFreightEasyNetPropPage, COlePropertyPage)
	//{{AFX_MSG_MAP(CFreightEasyNetPropPage)
	// NOTE - ClassWizard will add and remove message map entries
	//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()


/////////////////////////////////////////////////////////////////////////////
// Initialize class factory and guid

IMPLEMENT_OLECREATE_EX(CFreightEasyNetPropPage, "FREIGHTEASYNET.FreightEasyNetPropPage.1",
	0xbf774ac, 0xef38, 0x4dfe, 0xb2, 0xaa, 0xba, 0xe8, 0xfc, 0x77, 0x90, 0x1e)


/////////////////////////////////////////////////////////////////////////////
// CFreightEasyNetPropPage::CFreightEasyNetPropPageFactory::UpdateRegistry -
// Adds or removes system registry entries for CFreightEasyNetPropPage

BOOL CFreightEasyNetPropPage::CFreightEasyNetPropPageFactory::UpdateRegistry(BOOL bRegister)
{
	if (bRegister)
		return AfxOleRegisterPropertyPageClass(AfxGetInstanceHandle(),
			m_clsid, IDS_FREIGHTEASYNET_PPG);
	else
		return AfxOleUnregisterClass(m_clsid, NULL);
}


/////////////////////////////////////////////////////////////////////////////
// CFreightEasyNetPropPage::CFreightEasyNetPropPage - Constructor

CFreightEasyNetPropPage::CFreightEasyNetPropPage() :
	COlePropertyPage(IDD, IDS_FREIGHTEASYNET_PPG_CAPTION)
{
	//{{AFX_DATA_INIT(CFreightEasyNetPropPage)
	// NOTE: ClassWizard will add member initialization here
	//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_DATA_INIT
}


/////////////////////////////////////////////////////////////////////////////
// CFreightEasyNetPropPage::DoDataExchange - Moves data between page and properties

void CFreightEasyNetPropPage::DoDataExchange(CDataExchange* pDX)
{
	//{{AFX_DATA_MAP(CFreightEasyNetPropPage)
	// NOTE: ClassWizard will add DDP, DDX, and DDV calls here
	//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_DATA_MAP
	DDP_PostProcessing(pDX);
}


/////////////////////////////////////////////////////////////////////////////
// CFreightEasyNetPropPage message handlers
